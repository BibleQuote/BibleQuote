unit links_parser;

interface

uses SysUtils, Classes, WideStrings;

procedure StrToLinks(s: WideString; Links: TWideStrings);
procedure Tokenize(sourcestr: WideString; var Tokens: TWideStrings);

implementation

//const
//  Separators = [',', '.', ':', '-', ';'];
//  Digits = ['0'..'9'];

function IsSeparator(aChar: WideChar): Boolean;
begin
  case aChar of
    ',', '.', ':', '-', ';': Result := true;
  else Result := false;
  end;
end;

function IsDigit(aChar: WideChar): Boolean;
begin
  Result := (aChar >= '0') and (aChar <= '9');
end;

procedure Tokenize(sourcestr: WideString; var Tokens: TWideStrings);
var
  s, wrd: WideString;
  len, i: integer;
begin
  s := Trim(sourcestr);
  len := Length(s);

  wrd := '';
  i := 1;
  while i <= len do
  begin
    if s[i] = ' ' then
    begin
      if wrd <> '' then Tokens.Add(wrd);
      wrd := '';
      Inc(i);
      continue;
    end;

    if IsSeparator(s[i]) and
      (IsDigit(s[i - 1]) or IsSeparator(s[i - 1])) then
    begin
      Tokens.Add(wrd);
      Tokens.Add(s[i]);
      wrd := '';
      Inc(i);
      continue;
    end
    else if (s[i] = '.') then
    begin
      wrd := wrd + s[i];
      Tokens.Add(wrd);
      wrd := '';
      Inc(i);
      continue;
    end
    else
      wrd := wrd + s[i];

    Inc(i);
  end;
  if wrd <> '' then Tokens.Add(wrd);
end;

procedure StrToLinks(s: WideString; Links: WideStrings.TWideStrings);
var
  i, ci: integer;
  list: TWideStrings;
  book: WideString;
  chapter, fromverse, toverse: integer;
  ctxBook: WideString;
  pl, colonUsed, commaUsed, addRslt: boolean;

  function parselink(out needAdd: boolean): boolean;
  var
    ival, code: integer;
    fset,defBook, firstComma: boolean;
  begin
    result := false;
    needAdd := true;
    defbook:=false;
    try
      firstComma:=list[ci] = ',';
      if (list[ci] = ';') or firstComma then inc(ci);
      Val(list[ci], ival, code);
      if code = 0 then begin
        if (ival > 3) then begin
          if Length(ctxBook) = 0 then exit;
          defBook:=true;
        end else begin
          inc(ci);
          {$HINTS OFF}
          Val(list[ci], ival, code);
          {$HINTS ON}
          if (code = 0) or (list[ci] = ':') or (list[ci] = '.') or ((list[ci] =
            ',')) then begin //second token also digit
            dec(ci, 1);
            if (length(ctxBook) = 0) then exit
            else defBook:=true;
          end
          else begin
            ctxBook := list[ci - 1] + list[ci];
            inc(ci);
          end;
        end
      end else begin ctxBook := list[ci]; inc(ci) end;

       fromverse := 1; toverse := 0; colonUsed := false; commaUsed
        := false;
      result := true;
      if not (firstComma and defBook) then begin
        chapter:=1;
        chapter := StrToIntDef(list[ci], -1);
        if chapter = -1 then chapter := 1
        else begin inc(ci);
          colonUsed := (list[ci] = ':') or (list[ci] = '.');
          if colonUsed or (list[ci] = ',') then inc(ci);
        end;
      end;
      fset := false;
      repeat

        if list[ci] = ';' then exit;
        ival := StrToIntDef(list[ci], -1);
        if ival = -1 then begin exit end;

        inc(ci);
        if not fset then begin
          fromverse := ival;
          result := true;
          needAdd := true;
          commaUsed := list[ci] = ',';
          if commaUsed then begin
            Links.Add(WideFormat('%s %d:%d', [ctxBook, chapter, fromverse]));
            inc(ci);
            needAdd := false;
     //result:=false;
          end
          else begin
            needAdd := true;
            if (list[ci] = '-') then inc(ci);
            fset := true; end;
        end
        else begin
          if ival <= fromverse then begin
            result := true;
            dec(ci); exit
          end;
          toverse := ival; break;

        end;
      until (list[ci] = ';');

    except end;
  end;

  
begin
  list := TWideStringList.Create;
  try
  Links.Clear;

  Tokenize(s, list);
  ci := 0;
  repeat
    pl := parselink(addRslt);
    if pl and addRslt then
      if toverse = 0 then
        Links.Add(WideFormat('%s %d:%d', [ctxBook, chapter, fromverse]))
      else
        Links.Add(WideFormat('%s %d:%d-%d', [ctxBook, chapter, fromverse,
          toverse]));

  until (ci >= list.Count) or (not pl);

  finally  list.free(); end;
  exit;

  if list.Count = 2 then
  begin
    list.Add(':');
    list.Add('1'); // jn 4 gives jn 1:1 due to an error; this helps
    // jn 5:13; 4; 6 gives 5:13, 4:1, 6:1 -- OK!! So count=2 is necessary
  end;
  list.Add(';'); // finish the list of links

  book := list[0];
  chapter := 1;
  fromverse := 1;
  toverse := 0;

  for i := 1 to list.Count - 1 do
  begin
    if list[i] = ',' then // verse separator
    begin
      if toverse = 0 then
        Links.Add(Format('%s %d:%d', [book, chapter, fromverse]))
      else
        Links.Add(Format('%s %d:%d-%d', [book, chapter, fromverse, toverse]));

      fromverse := StrToInt(list[i + 1]);
      toverse := 0;

      continue;
    end;

    if list[i] = ';' then // link separator
    begin
      if toverse = 0 then
        Links.Add(Format('%s %d:%d', [book, chapter, fromverse]))
      else
        Links.Add(Format('%s %d:%d-%d', [book, chapter, fromverse, toverse]));

      if i < list.Count - 1 then
      begin
        if IsDigit((list[i + 1])[Length(list[i + 1])]) then
          chapter := StrToInt(list[i + 1])
        else begin
          book := list[i + 1];
          chapter := StrToInt(list[i + 2]);
        end;
      end;
      fromverse := 1;
      toverse := 0;

      continue;
    end;

    if (list[i] = '.') or (list[i] = ':') then // chapter and verse separator
    begin
      chapter := StrToInt(list[i - 1]);
      fromverse := StrToInt(list[i + 1]);
      toverse := 0;

      continue;
    end;

    if list[i] = '-' then
    begin
      fromverse := StrToInt(list[i - 1]);
      toverse := StrToInt(list[i + 1]);

      continue;
    end;

    if (i = 1) and IsDigit((list[i])[1]) then
    begin
      chapter := StrToInt(list[i]);
    end;
  end;

  list.Free;
end;

end.

