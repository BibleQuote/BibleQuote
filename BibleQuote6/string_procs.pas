unit string_procs;

// some string procedures

interface

uses
  SysUtils,
  Classes,
  WideStrings,
  Windows,
  Graphics;

function UpperCaseFirstLetter(s: WideString): WideString;

function FirstWord(s: WideString): WideString;
function DeleteFirstWord(var s: WideString): WideString;
function IniStringFirstPart(s: WideString): WideString;
function IniStringSecondPart(s: WideString): WideString;

function SingleLetterDelete(var s: WideString): boolean;

function StrReplace(var s: WideString; const substr1, substr2: WideString; recurse: boolean): boolean;
function StrColorUp(var s: WideString; const wrd, c1, c2: WideString; casesensitive: boolean): boolean;

function StrDeleteFirstNumber(var s: WideString): WideString;
function StrGetFirstNumber(s: WideString): WideString;

// address $$$ comment $$$$$$ commentnext

function Comment(s: WideString): WideString; // retrieves a comment from a command line

function DumpFileName(s: WideString): WideString;

function SplitValue(s: WideString; var strname: WideString;
         var chapter, fromverse, toverse: integer): boolean;

function Hex2Color(s: WideString): TColor;
function Color2Hex(col: TColor): WideString;

function ParseHTML(s, HTML: WideString): WideString;

function Get_ANAME_VerseNumber(const s: WideString; start, iPos: integer): integer;
function Get_AHREF_VerseCommand(const s: string;  iPos: integer): string;

function DeleteStrongNumbers(s: WideString): WideString;
function FormatStrongNumbers(s: WideString; hebrew: boolean; supercase: boolean): WideString;

function LastPos(SubS, S: WideString): integer;

function FindString(List: TWideStringList; s: WideString): integer;
// find string in SORTED list, maybe partial match

procedure AddLine (var rResult: WideString; const aLine: WideString);

function PosCIL (aSubString: AnsiString; const aString: AnsiString; aStartPos: Integer = 1): Integer; overload;
function PosCIL (aSubString: WideString; const aString: WideString; aStartPos: Integer = 1): Integer; overload;

procedure TrimNullTerminatedString (var aString: String);

const
  DefaultHTMLFilter: WideString = '<b></b><i></i><u></u><h1></h1><h2></h2><h3></h3><h4></h4><h5></h5><h6></h6>';

implementation
uses StrUtils ;
// find string in SORTED list, maybe partial match
function FindString(List: TWideStringList; s: WideString): integer;
var
  b,e,len: integer;
begin
  Result := -1;
  b := 0;
  e := List.Count-1;
  len := Length(s);

  while (b < e-1) and (Result < 0) do
  begin
    if Copy (List[(b+e) div 2],1,len) < s then
      b := (b + e) div 2
    else if Copy(List[(b+e) div 2],1,len) > s then
      e := (b + e) div 2
    else
      Result := (b + e) div 2;
  end;

  if (b=e) and (Copy(List[b],1,len) = s) then Result := b;
  if (b=e-1) and (Copy(List[b],1,len) = s) then Result := b;
  if (b=e-1) and (Copy(List[e],1,len) = s) then Result := e;
end;

function LastPos(SubS, S: WideString): integer;
var
  offset, i, len: integer;
begin
  Result := 0;
  len := Length(S);
  offset := 0;
  repeat
    i := Pos(SubS, Copy(S, offset+1, len));
    if i > 0 then Result := i + offset;
    offset := offset + Length(SubS);
  until i = 0;
end;


function FormatStrongNumbers(s: WideString; hebrew: boolean; supercase: boolean): WideString;
var
  i, len: integer;
  isNum: boolean;
  link: WideString;
begin
  Result := '';
  len := Length(s);
  isNum := false;

  for i:=1 to len do
  begin
    if (
      (Integer (s[i]) >= Integer ('0')) and
      (Integer (s[i]) <= Integer ('9'))
    ) then
    begin
      if isNum then // если сейчас идет число, то удлиняем ссылку
        link := link + s[i]
      else begin
        isNum := true;
        link := s[i]; // start the number link
      end;
    end else begin // not digit now
      if isNum then // if there was link
      begin
        if (link = 'H') or (link = 'G') then begin // stop
          isNum := false;
          Result := Result + link;
        end else begin
          isNum := false;
          //if link <> '0' then
          //begin
            //if hebrew and (link <> '0') then link := '0' + link;
            if supercase then
              Result := Result + '<SUP><font size=0><a href=s' + link + '>' + link + '</a></font></SUP>'
            else
              Result := Result + '<a href=s' + link + '>' + link + '</a>'
          //end;
        end;
        Result := Result + s[i];
      end else if (integer(s[i]) = integer('H')) or (integer(s[i]) = integer('G')) then begin
        isNum := true;
        link := s[i];
      end else
        // finish the link, draw the symbol
        Result := Result + s[i];
    end;
  end;

  if isNum then // если шла ссылка то в конце надо ее завершить....
  begin
    if supercase then
      Result := Result + '<font size=1><a href=s' + link + '>' + link + '</a></font> '
    else
      Result := Result + '<a href=s' + link + '>' + link + '</a> '
  end;

end;

function DeleteStrongNumbers(s: WideString): WideString;
var
  i, len: integer;
begin
  Result := '';
  len := Length(s);
  for i:=1 to len do
  begin
    if (
        (Integer (s[i]) >= Integer ('0')) and
        (Integer (s[i]) <= Integer ('9'))
      )
      or (
      (i < len) and
      (s[i] = ' ') and
      ((Integer (s[i+1]) >= Integer ('0')) and
      (Integer (s[i+1]) <= Integer ('9')))
    )
    then continue;

    if (
        (Integer (s[i]) = Integer ('G')) or
        (Integer (s[i]) = Integer ('H'))
      )
      and (
      (i < len) and
      //(s[i] = ' ') and
      ((Integer (s[i+1]) >= Integer ('0')) and
      (Integer (s[i+1]) <= Integer ('9')))
    )
    then continue;

    Result := Result + s[i];
  end;
end;

function FirstWord(s: WideString): WideString;
var
  s1: WideString;
  i: integer;
begin
  Result := '';
  s1 := Trim(s);
  i := Pos(' ', s1);
  if i > 0
  then Result := Copy(s1, 1, i-1)
  else Result := s1;
end;

function DeleteFirstWord(var s: WideString): WideString;
var
  s1: WideString;
  i: integer;
begin
  Result := s;

  s1 := Trim(s);
  i := Pos(' ', s1);
  if i > 0 then begin
    Result := Copy(s, 1, i-1);
    s := Copy(s1, i+1, Length(s1));
  end
  else s := '';
end;

function IniStringFirstPart(s: WideString): WideString;
var
  i: integer;
begin
  i := Pos('=', s);
  if i > 0
  then Result := Trim(Copy(s,1,i-1))
  else Result := Trim(s);
end;

function IniStringSecondPart(s: WideString): WideString;
var
  i: integer;
begin
  i := Pos('=', s);
  if i > 0
  then Result := Trim(Copy(s,i+1,Length(s)))
  else Result := '';
end;

function StrColorUp(var s: WideString; const wrd, c1, c2: WideString; casesensitive: boolean): boolean;
var
  i, len1: integer;
  res, slow, wrdlow: WideString;
begin
  if not casesensitive then
  begin
    slow := WideLowerCase(s);
    wrdlow := WideLowerCase(wrd);
  end
  else begin
    slow := s;
    wrdlow := wrd;
  end;

  Result := true;

  i := Pos(wrdlow, slow);
  if i = 0 then
  begin
    Result := false;
    Exit;
  end;

  len1 := Length(wrdlow);

  res := '';
  repeat
    res := res + Copy(s,1,i-1) + c1 + Copy(s,i,Length(wrdlow)) + c2;

    s := Copy(s,i+len1,Length(s));
    slow := Copy(slow,i+len1,Length(slow));

    i := Pos(wrdlow, slow);
  until i=0;

  s := res + s;
end;

function StrReplace(var s: WideString; const substr1, substr2: WideString; recurse: boolean): boolean;
var
  i,len1: integer;
  res: WideString;
begin
  Result := true;

  i := Pos(substr1, s);
  if i = 0 then
  begin
    Result := false;
    Exit;
  end;

  len1 := Length(substr1);

  res := '';

  repeat
    res := res + Copy(s,1,i-1) + substr2;
    s := Copy(s,i+len1,Length(s));

    i := Pos(substr1, s);
  until (not recurse) or (i=0);

  s := res + s;
end;

function StrGetFirstNumber(s: WideString): WideString;
var
  i,len: integer;
  ok: boolean;
begin
  len := Length(s);

  i := 0;
  repeat
    Inc(i);
    ok := (s[i] >= '0') and (s[i] <= '9');
  until (not ok) or (i = len);

  Result := Copy(s,1,i-1);
end;

function StrDeleteFirstNumber(var s: WideString): WideString;
var
  i,len,nums: integer;
  ok: boolean;
begin
  len := Length(s);
  if len<1 then begin result:='' ; exit;end;
  i := 0;
  repeat inc(i); until (s[i]<>#32) or (i>=len);
  nums:=i; dec(i);
  repeat
    Inc(i);
    ok := (s[i] >= '0') and (s[i] <= '9');
  until (not ok) or (i = len);

  Result := Copy(s,nums,i-nums);
  s := Trim(Copy(s,i,len));
end;

function Comment(s: WideString): WideString; // retrieves a comment from a command line
var
  i: integer;
begin
  i := Pos('$$$', s);
  if i > 0
  then Result := Trim(Copy(s, i+3, Length(s)))
  else Result := '';
end;

function DumpFileName(s: WideString): WideString;
begin
  Result := s;
  StrReplace(Result, ':', ' ', true);
  StrReplace(Result, '"', ' ', true);
  StrReplace(Result, '?', ' ', true);
  StrReplace(Result, '*', ' ', true);
  StrReplace(Result, '\', ' ', true);
  StrReplace(Result, '/', ' ', true);

  StrReplace(Result, '  ', ' ', true);
  StrReplace(Result, '  ', ' ', true);
  StrReplace(Result, '  ', ' ', true);

  Result := Trim(Result);
end;

function UpperCaseFirstLetter(s: WideString): WideString;
begin
  Result := WideUpperCase(Copy(s,1,1)) + WideLowerCase(Copy(s,2,Length(s)));
end;

// разбор записей типа Быт. 1 : 1- 25 для получения адреса отрывка
// для модуля bookmarks адреса выглядят так: 40.1:2-34

function SplitValue(s: WideString; var strname: WideString;
         var chapter, fromverse, toverse: integer): boolean;
var
  scopy: WideString;
  colonpos, dashpos, spacepos, pointpos, commapos: integer;
begin
  chapter := 1;
  fromverse := 0;
  toverse := 0;

  scopy := Trim(s);

  pointpos := Pos('.', scopy);
  if (pointpos > 0) and (Pos('.', Copy(scopy, pointpos+1, Length(scopy))) > 0)
  then pointpos := pointpos + Pos('.', Copy(scopy, pointpos+1, Length(scopy)));
  // в некоторых книгах две точки в сокращении имени, напр. Прем.Сол.

  spacepos := Pos(' ', scopy);
  if (pointpos = 0) or (spacepos > pointpos+1) then pointpos := spacepos;

  strname := Trim(Copy(scopy, 1, pointpos));

  colonpos := Pos(':', scopy);
  dashpos  := Pos('-', scopy);
  commapos := Pos(',', scopy);
  if dashpos = 0 then dashpos := commapos; // Быт.12:2,3

  try
    if colonpos <> 0 then
      chapter := StrToInt(Trim(Copy(scopy, pointpos+1, colonpos-pointpos-1)))
    else begin
      chapter := StrToInt(Trim(Copy(scopy, pointpos+1, Length(scopy))));

      fromverse := 0;
      toverse := 0;

      Result := true;
      Exit;
    end;

    if dashpos <> 0 then
    begin
      fromverse := StrToInt(Trim(Copy(scopy, colonpos+1, dashpos-colonpos-1)));
      toverse := StrToInt(Trim(Copy(scopy, dashpos+1, Length(scopy))));
    end else
    begin
      fromverse := StrToInt(Trim(Copy(scopy, colonpos+1, Length(scopy))));
      toverse := 0;
    end;

    Result := true;

  except
    Result := false;
  end;

end;


function SingleLetterDelete(var s: WideString): boolean;
var
  snew, sword: WideString;
begin
  Result := false;
  snew := '';

  while s <> '' do
  begin
    sword := DeleteFirstWord(s);
    if Length(sword) > 1
    then snew := snew + sword + ' '
    else Result := true;
  end;

  s := Trim(snew);
end;

function Char2Hex(c: WideChar): integer;
begin
  result:=0;
  if (c <= '9') and (c>='0') then Result := Integer (c) - Integer ('0')
  else if (c>='A') and  (c<='F') then Result := Integer (c) - Integer ('A') + 10;
end;

function Hex2Color(s: WideString): TColor; // #xxyyzz -> TColor
var
  snew: WideString;
  l:integer;
begin
  result:=0;

  snew := WideUpperCase(Trim(s));
  l:=length(snew);
  if l>=7 then begin
  Result := Char2Hex(snew[6]) * 16 + Char2Hex(snew[7]);
  Result := Result * 256;
  end;
  if l>=5 then begin

  Result := Result + Char2Hex(snew[4]) * 16 + Char2Hex(snew[5]);
  Result := Result * 256;
  end;
  if l>3 then
  Result := Result + Char2Hex(snew[2]) * 16 + Char2Hex(snew[3]);
end;

function Color2Hex(col: TColor): WideString;
begin
  Result := Format('#%.2x%.2x%.2x',
    [ColorToRGB(col) and $FF,
    (ColorToRGB(col) and $FF00) shr 8,
    (ColorToRGB(col) and $FF0000) shr 16]);
end;

//!!! К оптимизации: последовательное наращивание длинной строки.
function ParseHTML(s, HTML: WideString): WideString;
var
  Tokens: TWideStrings;
  i, minCharCode, s_length, tmp_max, tmp_ix{, tc}: integer;
  charArrayAccumullator: array of WideChar;
  useDefaultFilter: boolean;
  wstr:WideString;
  procedure grow_tmp();
  begin
  Inc(tmp_max);
  tmp_max:=tmp_max*2;
  SetLength(charArrayAccumullator, tmp_max);
  dec(tmp_max);
  //FillChar(tmp[tmp_ix+1], tmp_max, 0);
  end;
begin
  useDefaultFilter := (HTML = DefaultHTMLFilter);

  if s = '' then
  begin
    Result := '';
    Exit;
  end;

  Tokens := TWideStringList.Create;
  try
  i := 0;
  tmp_max:=1024;
  tmp_ix:=0;
  SetLength(charArrayAccumullator, tmp_max);
  Dec(tmp_max);
//  FillChar(Pointer(tmp)^, tmp_max*2, 0);
  minCharCode := 65535;
  s_length:=Length(s);
  //tc:=GetTickCount();
  repeat
    Inc(i);

    if s[i] = '<' then
    begin
      charArrayAccumullator[tmp_ix]:=#0; inc(tmp_ix);
      if tmp_ix>=tmp_max then grow_tmp();
      wstr:=PWideChar(Pointer(charArrayAccumullator));
      Tokens.AddObject(wstr, Pointer(0));

      minCharCode := 65535;
      tmp_ix:=0;
      charArrayAccumullator[tmp_ix] := '<';
      Inc(tmp_ix);
      if tmp_ix>=tmp_max then grow_tmp();
      continue;
    end;

    if s[i] = '>' then
    begin
      charArrayAccumullator[tmp_ix]:='>'; inc(tmp_ix); if tmp_ix>=tmp_max then grow_tmp();
      charArrayAccumullator[tmp_ix]:=#0; inc(tmp_ix); if tmp_ix>=tmp_max then grow_tmp();
      if charArrayAccumullator[0]<>#0 then begin
        wstr:=PWideChar(@charArrayAccumullator[0]);
        if (minCharCode <= Integer ('z'))
        then Tokens.AddObject(wstr, Pointer(1))
        else Tokens.AddObject('&lt;' + Copy(wstr,2,Length(wstr)-2) + '&gt;', Pointer(0));
      end;
      // <русское слово> преобразовывается в [русское слово]
      // компонента браузера не показывает текст типа <русское слово>

      minCharCode := 65535;
      //tmp := '';
      tmp_ix:=0;
      continue;
    end else

    if (s[i] <> ' ') and (s[i] <> #9) and (Integer (s[i]) < minCharCode) then
      minCharCode := Integer (s[i]);

    charArrayAccumullator[tmp_ix] :=s[i]; //Copy(s,i,1);
    inc(tmp_ix); if tmp_ix>=tmp_max then grow_tmp();
  until i >=s_length ;

  charArrayAccumullator[tmp_ix]:=#0; inc(tmp_ix); if tmp_ix>=tmp_max then grow_tmp();
  wstr:=PWideChar(@charArrayAccumullator[0]);
  Tokens.AddObject(wstr, Pointer(0));
//  tc:=Integer(GetTickCount())-tc;
  Result := '';
//   tc:=GetTickCount();

  for i := 0 to Tokens.Count-1 do
  begin
    if useDefaultFilter then
      wstr := WideLowerCase(Tokens[i])
    else
      wstr := FirstWord(WideLowerCase(Tokens[i]));

    if (Integer(Tokens.Objects[i]) <> 1)
    or (Pos(wstr,HTML) <> 0)
    then Result := Result + Tokens[i];
  end;
//  tc:=Integer(GetTickCount())-tc;
  finally  SetLength(charArrayAccumullator,0); Tokens.Free; end;
end;

function Get_ANAME_VerseNumber(const s: WideString; start, iPos: integer): integer;
var
  anamepos, len, i: integer;
  sign: WideString;
begin
  i := start;

  repeat
    sign := '<a name="bqverse' + IntToStr(i) + '">';
    len := Length(sign);

    anamepos := Pos(sign, s);
    if (anamepos = 0) or (anamepos >= iPos-len) then break;
    Inc(i);
  until false;

  Result := i-1;
  if Result < 1 then Result := 1;
end;
 {AlekId}
function Get_AHREF_VerseCommand(const s: string;  iPos: integer): string;
var
  anamepos,  i, searchpos: integer;
  sign: WideString;
  label found;
begin
  searchpos:=1;
  sign := '<a href="';

  repeat

    anamepos := PosEx (sign, s, searchpos);
    if anamepos>0 then begin
    if (anamepos > iPos) then break
    else if anamepos=iPos then begin searchpos:=anamepos+1; break; end;
    searchpos:=anamepos+1;
    end;

  until (anamepos=0);
if  (searchpos=0) then begin result:=''; exit; end;

    i:=PosEx('">',s, searchpos);
    if i>0 then begin
      result:=copy(s,searchpos+8,i-searchpos-8);
      exit;
    end;
end;
{/ALekID}
procedure AddLine (var rResult: WideString; const aLine: WideString);
begin
  if rResult = '' then
    rResult := aLine
  else
    rResult := rResult + #13#10 + aLine;
end;

function LatCharToLower (aChar: AnsiChar): AnsiChar; overload;
begin
  if (aChar >= 'A') and (aChar <= 'Z') then
    Result := AnsiChar (Byte (aChar) + 32)
  else
    Result := aChar;
end;

function LatCharToLower (aChar: WideChar): WideChar; overload;
begin
  if (aChar >= 'A') and (aChar <= 'Z') then
    Result := WideChar (Word (aChar) + 32)
  else
    Result := aChar;
end;

function PosCIL (aSubString: AnsiString; const aString: AnsiString; aStartPos: Integer = 1): Integer; overload;
var
  dLength: Integer;
  dSubLength: Integer;
  dPos: Integer;
  dPos2: Integer;
  dFirstChar: AnsiChar;

label
  NextFirstChar;
begin
  Result := 0;

  dSubLength := Length (aSubString);
  dLength := Length (aString);
  if dSubLength = 0 then Exit;
  if aStartPos + dSubLength - 1 > dLength then Exit;

  for dPos := 1 to dSubLength do
    aSubString [dPos] := LatCharToLower (aSubString [dPos]);

  dFirstChar := aSubString [1];

  dLength := dLength - dSubLength + 1;
  for dPos := aStartPos to dLength do
  begin
    if LatCharToLower (aString [dPos]) = dFirstChar then
    begin
      for dPos2 := 2 to dSubLength do
        if LatCharToLower (aString [dPos + dPos2 - 1]) <> aSubString [dPos2] then
          Goto NextFirstChar;

      Result := dPos;
      Exit;

    end;

NextFirstChar:
  end;

end;

function PosCIL (aSubString: WideString; const aString: WideString; aStartPos: Integer = 1): Integer; overload;
var
  dLength: Integer;
  dSubLength: Integer;
  dPos: Integer;
  dPos2: Integer;
  dFirstChar: WideChar;

label
  NextFirstChar;
begin
  Result := 0;

  dSubLength := Length (aSubString);
  dLength := Length (aString);
  if dSubLength = 0 then Exit;
  if aStartPos + dSubLength - 1 > dLength then Exit;

  for dPos := 1 to dSubLength do
    aSubString [dPos] := LatCharToLower (aSubString [dPos]);

  dFirstChar := aSubString [1];

  dLength := dLength - dSubLength + 1;
  for dPos := aStartPos to dLength do
  begin
    if LatCharToLower (aString [dPos]) = dFirstChar then
    begin
      for dPos2 := 2 to dSubLength do
        if LatCharToLower (aString [dPos + dPos2 - 1]) <> aSubString [dPos2] then
          Goto NextFirstChar;

      Result := dPos;
      Exit;

    end;

NextFirstChar:
  end;

end;

procedure TrimNullTerminatedString (var aString: String);
var
  dPos: Integer;
begin
  dPos := Pos (#0, aString);
  if dPos > 0 then
    SetLength (aString, dPos - 1);  
end;

end.
