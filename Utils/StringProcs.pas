unit StringProcs;

interface

uses
  SysUtils,
  Classes,
  Windows,
  StrUtils,
  Graphics,
  Character;

function UpperCaseFirstLetter(s: string): string;

function FirstWord(s: string): string;
function DeleteFirstWord(var s: string): string;
function IniStringFirstPart(s: string): string;
function IniStringSecondPart(s: string): string;

function StrReplace(var s: string; const substr1, substr2: string; recurse: boolean): boolean;
procedure StrColorUp(var Source: string; const Word, C1, C2: string; MatchCase: Boolean; WholeWord: Boolean = False);

function StrDeleteFirstNumber(var s: string): string;
function StrGetFirstNumber(s: string): string;

function Comment(s: string): string; // retrieves a comment from a command line

function DumpFileName(s: string): string;

function SplitValue(s: string; var strname: string; var chapter, fromverse, toverse: integer): boolean;

function Hex2Color(s: string): TColor;
function Color2Hex(col: TColor): string;

function ParseHTML(s, HTML: string): string;

function Get_ANAME_VerseNumber(const s: string; start, iPos: integer): integer;
function Get_AHREF_VerseCommand(const s: string; iPos: integer): string;

function DeleteStrongNumbers(S: String): String;
function FormatStrongNumbers(s: string; supercase: boolean;const Hebrew: integer=-1): string;

// find string in SORTED list, maybe partial match
function FindString(List: TStringList; s: string): integer;

procedure AddLine(var rResult: string; const aLine: string);
function PosCIL(aSubString: string; const aString: string; aStartPos: integer = 1): integer; overload;

function FindPosition(const sourceString, findString: string; const startPos: integer; options: TStringSearchOptions): integer;
function StripHtmlMarkup(const source: string): string;
function IsValidStrong(const source: string): boolean;
function FormatStrong(const number: Integer; const isHebrew: Boolean): String;
function StrongVal(const source: string; var num: integer; var isHebrew: boolean;const DefaultHebrew:boolean=false): boolean;
function RepeatString(const s: string; count: cardinal): string;

function StreamToString(const aStream: TStream; const Encoding: TEncoding): String;

const
  DefaultHTMLFilter: string =
    '<b></b><i></i><u></u><h1></h1><h2></h2><h3></h3><h4></h4><h5></h5><h6></h6>';

implementation

// find string in SORTED list, maybe partial match
function FindString(List: TStringList; s: string): integer;
var
  b, e, len: integer;
begin
  Result := -1;
  b := 0;
  e := List.Count - 1;
  len := Length(s);

  while (b < e - 1) and (Result < 0) do
  begin
    if Copy(List[(b + e) div 2], 1, len) < s then
      b := (b + e) div 2
    else if Copy(List[(b + e) div 2], 1, len) > s then
      e := (b + e) div 2
    else
      Result := (b + e) div 2;
  end;

  if (b = e) and (Copy(List[b], 1, len) = s) then
    Result := b;
  if (b = e - 1) and (Copy(List[b], 1, len) = s) then
    Result := b;
  if (b = e - 1) and (Copy(List[e], 1, len) = s) then
    Result := e;
end;

function FormatStrongNumbers(s: string; supercase: boolean;const Hebrew: integer=-1): string;
var
  i, len: integer;
  isNum: boolean;
  link: string;
begin
  Result := '';
  len := Length(s);
  isNum := false;

  for i := 1 to len do
  begin
    if ((integer(s[i]) >= integer('0')) and (integer(s[i]) <= integer('9')))
//      and not (s[i-1]='[')
    then
    begin
      if isNum then // если сейчас идет число, то удлинем ссылку
        link := link + s[i]
      else

      begin
        isNum := true;
        link := s[i]; // start the number link
      end;
    end
    else
    begin // not digit now
      if isNum then // if there was link
      begin
        if (link = 'H') or (link = 'G') then
        begin // stop
          isNum := false;
          Result := Result + link;
        end
        else
        begin
          isNum := false;
          // if link <> '0' then
          // begin
          // if hebrew and (link <> '0') then link := '0' + link;
          if not (link.StartsWith('H') or link.StartsWith('G')) then
               begin
               if Hebrew=1 then
              link:= 'H'+link;
               if Hebrew=0 then
              link:= 'G'+link;
               end;
          if supercase then
            Result := Result + '<SUP><font size=0><a href=s' + link + '>' + link
              + ' </a></font></SUP>'
          else
            Result := Result + '<a href=s' + link + '>' + link + ' </a>'
            // end;
        end;
        Result := Result + s[i];
      end
      else if (integer(s[i]) = integer('H')) or (integer(s[i]) = integer('G'))
      then
      begin
        isNum := true;
        link := s[i];
      end
      else
        // finish the link, draw the symbol
        Result := Result + s[i];
    end;
  end;

  if isNum then // if a link was in the end, close it
  begin
    if supercase then
      Result := Result + '<font size=1><a href=s' + link + '>' + link +
        '</a></font> '
    else
      Result := Result + '<a href=s' + link + '>' + link + '</a> '
  end;

end;

function DeleteStrongNumbers(S: String): String;
var
  I, Len: Integer;
begin
  Result := '';
  Len := Length(S);
  for I := 1 to Len do
  begin
    if S[I].IsDigit then
      continue;

    if S[I].IsInArray(['G', 'H']) then
    begin
      if ((I < Len) and (S[I + 1].IsDigit)) then
        continue;
    end;

    if ((I < Len) and (S[I] = ' ')) then
    begin
      if S[I + 1].IsDigit then
        continue;

      if S[I + 1].IsInArray(['G', 'H']) then
        if ((I < Len - 1) and (S[I + 2].IsDigit)) then
          continue;
    end;

    Result := Result + S[I];
  end;
end;

function FirstWord(s: string): string;
var
  s1: string;
  i: integer;
begin
  Result := '';
  s1 := Trim(s);
  i := Pos(' ', s1);
  if i > 0 then
    Result := Copy(s1, 1, i - 1)
  else
    Result := s1;
end;

function DeleteFirstWord(var s: string): string;
var
  s1: string;
  i: integer;
begin
  Result := s;

  s1 := Trim(s);
  i := Pos(' ', s1);
  if i > 0 then
  begin
    Result := Copy(s, 1, i - 1);
    s := Copy(s1, i + 1, Length(s1));
  end
  else
    s := '';
end;

function IniStringFirstPart(s: string): string;
var
  i: integer;
begin
  i := Pos('=', s);
  if i > 0 then
    Result := Trim(Copy(s, 1, i - 1))
  else
    Result := Trim(s);
end;

function IniStringSecondPart(s: string): string;
var
  i: integer;
begin
  i := Pos('=', s);
  if i > 0 then
    Result := Trim(Copy(s, i + 1, Length(s)))
  else
    Result := '';
end;

procedure StrColorUp(var Source: string; const Word, C1, C2: string; MatchCase: Boolean; WholeWord: Boolean = False);
var
  StartIndex, MatchIndex: Integer; // zero based indices
  Len: Integer;
  Res: String;
  PrevString, MatchString: String;
  StringSearchOptions: TStringSearchOptions;
begin
  StringSearchOptions := [soDown];

  if MatchCase then
    Include(StringSearchOptions, soMatchCase);

  if WholeWord then
    Include(StringSearchOptions, soWholeWord);

  StartIndex := 0;
  Len := Length(Word);

  Res := '';
  while True do
  begin
    MatchIndex := FindPosition(Source, Word, StartIndex, StringSearchOptions);

    if (MatchIndex = 0) then
      Break;

    MatchIndex  := MatchIndex - 1;
    PrevString  := Copy(Source, StartIndex + 1, MatchIndex - StartIndex);
    MatchString := Copy(Source, MatchIndex + 1, Len);

    Res := Res + PrevString + C1 + MatchString + C2;

    StartIndex := MatchIndex + Len;
  end;

  // Copy the rest of the string
  Res := Res + Copy(Source, StartIndex + 1, Length(Source) - StartIndex);
  Source := Res;
end;

function StrReplace(var s: string; const substr1, substr2: string; recurse: boolean): boolean;
var
  i, len1: integer;
  res: string;
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
    res := res + Copy(s, 1, i - 1) + substr2;
    s := Copy(s, i + len1, Length(s));

    i := Pos(substr1, s);
  until (not recurse) or (i = 0);

  s := res + s;
end;

function StrGetFirstNumber(s: string): string;
var
  i, len: integer;
  ok: boolean;
begin
  len := Length(s);

  Result := '';
  if (len = 0) then
    Exit;

  i := 0;
  repeat
    Inc(i);
    ok := (s[i] >= '0') and (s[i] <= '9');
  until (not ok) or (i = len);

  Result := Copy(s, 1, i - 1);
end;

function StrDeleteFirstNumber(var s: string): string;
var
  i, len, nums: integer;
  ok: boolean;
begin
  len := Length(s);
  if len < 1 then
  begin
    Result := '';
    Exit;
  end;
  i := 0;
  repeat
    Inc(i);
  until (s[i] <> #32) or (i >= len);
  nums := i;
  dec(i);
  repeat
    Inc(i);
    ok := (s[i] >= '0') and (s[i] <= '9');
  until (not ok) or (i = len);

  Result := Copy(s, nums, i - nums);
  s := Trim(Copy(s, i, len));
end;

function Comment(s: string): string; // retrieves a comment from a command line
var
  i: integer;
begin
  i := Pos('$$$', s);
  if i > 0 then
    Result := Trim(Copy(s, i + 3, Length(s)))
  else
    Result := '';
end;

function DumpFileName(s: string): string;
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

function UpperCaseFirstLetter(s: string): string;
begin
  Result := UpperCase(Copy(s, 1, 1)) + LowerCase(Copy(s, 2, Length(s)));
end;

// разбор записей типа Ѕыт. 1 : 1- 25 для получени¤ адреса отрывка
// для модуля bookmarks адреса выглядят так: 40.1:2-34

function SplitValue(s: string; var strname: string;
  var chapter, fromverse, toverse: integer): boolean;
var
  scopy: string;
  colonpos, dashpos, spacepos, pointpos, commapos: integer;
begin
  chapter := 1;
  fromverse := 0;
  toverse := 0;

  scopy := Trim(s);

  pointpos := Pos('.', scopy);
  if (pointpos > 0) and (Pos('.', Copy(scopy, pointpos + 1, Length(scopy))) > 0)
  then
    pointpos := pointpos + Pos('.', Copy(scopy, pointpos + 1, Length(scopy)));
  // в некоторых книгах две точки в сокращении имени, напр. ѕрем.—ол.

  spacepos := Pos(' ', scopy);
  if (pointpos = 0) or (spacepos > pointpos + 1) then
    pointpos := spacepos;

  strname := Trim(Copy(scopy, 1, pointpos));

  colonpos := Pos(':', scopy);
  dashpos := Pos('-', scopy);
  commapos := Pos(',', scopy);
  if dashpos = 0 then
    dashpos := commapos; // Ѕыт.12:2,3

  try
    if colonpos <> 0 then
      chapter := StrToInt(Trim(Copy(scopy, pointpos + 1,
        colonpos - pointpos - 1)))
    else
    begin
      chapter := StrToInt(Trim(Copy(scopy, pointpos + 1, Length(scopy))));

      fromverse := 0;
      toverse := 0;

      Result := true;
      Exit;
    end;

    if dashpos <> 0 then
    begin
      fromverse := StrToInt(Trim(Copy(scopy, colonpos + 1,
        dashpos - colonpos - 1)));
      toverse := StrToInt(Trim(Copy(scopy, dashpos + 1, Length(scopy))));
    end
    else
    begin
      fromverse := StrToInt(Trim(Copy(scopy, colonpos + 1, Length(scopy))));
      toverse := 0;
    end;

    Result := true;

  except
    Result := false;
  end;

end;

function Char2Hex(c: Char): integer;
begin
  Result := 0;
  if (c <= '9') and (c >= '0') then
    Result := integer(c) - integer('0')
  else if (c >= 'A') and (c <= 'F') then
    Result := integer(c) - integer('A') + 10;
end;

function Hex2Color(s: string): TColor; // #xxyyzz -> TColor
var
  snew: string;
  l: integer;
begin
  Result := 0;

  snew := UpperCase(Trim(s));
  l := Length(snew);
  if l >= 7 then
  begin
    Result := Char2Hex(snew[6]) * 16 + Char2Hex(snew[7]);
    Result := Result * 256;
  end;
  if l >= 5 then
  begin

    Result := Result + Char2Hex(snew[4]) * 16 + Char2Hex(snew[5]);
    Result := Result * 256;
  end;
  if l > 3 then
    Result := Result + Char2Hex(snew[2]) * 16 + Char2Hex(snew[3]);
end;

function Color2Hex(col: TColor): string;
begin
  Result := Format('#%.2x%.2x%.2x', [ColorToRGB(col) and $FF,
    (ColorToRGB(col) and $FF00) shr 8, (ColorToRGB(col) and $FF0000) shr 16]);
end;

// !!!   оптимизации: последовательное наращивание длинной строки.
function ParseHTML(s, HTML: string): string;
var
  Tokens: TStrings;
  i, minCharCode, s_length, tmp_max, tmp_ix { , tc } : integer;
  charArrayAccumullator: array of Char;
  useDefaultFilter: boolean;
  str: string;
  procedure grow_tmp();
  begin
    Inc(tmp_max);
    tmp_max := tmp_max * 2;
    SetLength(charArrayAccumullator, tmp_max);
    dec(tmp_max);
    // FillChar(tmp[tmp_ix+1], tmp_max, 0);
  end;

begin
  useDefaultFilter := (HTML = DefaultHTMLFilter);

  if s = '' then
  begin
    Result := '';
    Exit;
  end;

  Tokens := TStringList.Create;
  try
    i := 0;
    tmp_max := 1024;
    tmp_ix := 0;
    SetLength(charArrayAccumullator, tmp_max);
    dec(tmp_max);
    // FillChar(Pointer(tmp)^, tmp_max*2, 0);
    minCharCode := 65535;
    s_length := Length(s);
    // tc:=GetTickCount();
    repeat
      Inc(i);

      if s[i] = '<' then
      begin
        charArrayAccumullator[tmp_ix] := #0;
        Inc(tmp_ix);
        if tmp_ix >= tmp_max then
          grow_tmp();
        str := PChar(Pointer(charArrayAccumullator));
        Tokens.AddObject(str, Pointer(0));

        minCharCode := 65535;
        tmp_ix := 0;
        charArrayAccumullator[tmp_ix] := '<';
        Inc(tmp_ix);
        if tmp_ix >= tmp_max then
          grow_tmp();
        continue;
      end;

      if s[i] = '>' then
      begin
        charArrayAccumullator[tmp_ix] := '>';
        Inc(tmp_ix);
        if tmp_ix >= tmp_max then
          grow_tmp();
        charArrayAccumullator[tmp_ix] := #0;
        Inc(tmp_ix);
        if tmp_ix >= tmp_max then
          grow_tmp();
        if charArrayAccumullator[0] <> #0 then
        begin
          str := PChar(@charArrayAccumullator[0]);
          if (minCharCode <= integer('z')) then
            Tokens.AddObject(str, Pointer(1))
          else
            Tokens.AddObject('&lt;' + Copy(str, 2, Length(str) - 2) + '&gt;',
              Pointer(0));
        end;
        // <русское слово> преобразовываетс¤ в [русское слово]
        // компонента браузера не показывает текст типа <русское слово>

        minCharCode := 65535;
        // tmp := '';
        tmp_ix := 0;
        continue;
      end
      else

        if (s[i] <> ' ') and (s[i] <> #9) and (integer(s[i]) < minCharCode) then
          minCharCode := integer(s[i]);

      charArrayAccumullator[tmp_ix] := s[i]; // Copy(s,i,1);
      Inc(tmp_ix);
      if tmp_ix >= tmp_max then
        grow_tmp();
    until i >= s_length;

    charArrayAccumullator[tmp_ix] := #0;
    Inc(tmp_ix);

    if tmp_ix >= tmp_max then
      grow_tmp();

    str := PChar(@charArrayAccumullator[0]);
    Tokens.AddObject(str, Pointer(0));
    Result := '';

    for i := 0 to Tokens.Count - 1 do
    begin
      if useDefaultFilter then
        str := LowerCase(Tokens[i])
      else
        str := FirstWord(LowerCase(Tokens[i]));

      if (integer(Tokens.Objects[i]) <> 1) or (Pos(str, HTML) <> 0) then
        Result := Result + Tokens[i];
    end;
  finally
    SetLength(charArrayAccumullator, 0);
    Tokens.Free;
  end;
end;

function Get_ANAME_VerseNumber(const s: string; start, iPos: integer): integer;
var
  anamepos, len, i: integer;
  sign: string;
begin
  i := start;

  repeat
    sign := '<a name="bqverse' + IntToStr(i) + '">';
    len := Length(sign);

    anamepos := Pos(sign, s);
    if (anamepos = 0) or (anamepos >= iPos - len) then
      break;
    Inc(i);
  until false;

  Result := i - 1;
  if Result < 1 then
    Result := 1;
end;

{ AlekId }
function Get_AHREF_VerseCommand(const s: string; iPos: integer): string;
var
  anamepos, i, searchpos: integer;
  sign: string;
label found;
begin
  searchpos := 1;
  sign := '<a href="';

  repeat

    anamepos := PosEx(sign, s, searchpos);
    if anamepos > 0 then
    begin
      if (anamepos > iPos) then
        break
      else if anamepos = iPos then
      begin
        searchpos := anamepos + 1;
        break;
      end;
      searchpos := anamepos + 1;
    end;

  until (anamepos = 0);
  if (searchpos = 0) then
  begin
    Result := '';
    Exit;
  end;

  i := PosEx('">', s, searchpos);
  if i > 0 then
  begin
    Result := Copy(s, searchpos + 8, i - searchpos - 8);
    Exit;
  end;
end;

{ /ALekID }
procedure AddLine(var rResult: string; const aLine: string);
begin
  if rResult = '' then
    rResult := aLine
  else
    rResult := rResult + #13#10 + aLine;
end;

function LatCharToLower(aChar: AnsiChar): AnsiChar; overload;
begin
  if (aChar >= 'A') and (aChar <= 'Z') then
    Result := AnsiChar(Byte(aChar) + 32)
  else
    Result := aChar;
end;

function LatCharToLower(aChar: Char): Char; overload;
begin
  if (aChar >= 'A') and (aChar <= 'Z') then
    Result := Char(Word(aChar) + 32)
  else
    Result := aChar;
end;

function PosCIL(aSubString: string; const aString: string; aStartPos: integer = 1): integer; overload;
var
  dLength: integer;
  dSubLength: integer;
  dPos: integer;
  dPos2: integer;
  dFirstChar: Char;

label
  NextFirstChar;
begin
  Result := 0;

  dSubLength := Length(aSubString);
  dLength := Length(aString);
  if dSubLength = 0 then
    Exit;
  if aStartPos + dSubLength - 1 > dLength then
    Exit;

  for dPos := 1 to dSubLength do
    aSubString[dPos] := LatCharToLower(aSubString[dPos]);

  dFirstChar := aSubString[1];

  dLength := dLength - dSubLength + 1;
  for dPos := aStartPos to dLength do
  begin
    if LatCharToLower(aString[dPos]) = dFirstChar then
    begin
      for dPos2 := 2 to dSubLength do
        if LatCharToLower(aString[dPos + dPos2 - 1]) <> aSubString[dPos2] then
          Goto NextFirstChar;

      Result := dPos;
      Exit;

    end;

  NextFirstChar:
  end;

end;

function FindPosition(const sourceString, findString: string; const startPos: integer; options: TStringSearchOptions): integer;
var
  pResult, buf: PChar;
begin
  Result := 0;
  buf := PChar(sourceString);
  pResult := SearchBuf(buf, Length(sourceString), startPos, 0, findString, options);
  if pResult <> nil then
    Result := (pResult - PChar(sourceString)) + 1;
end;

function StripHtmlMarkup(const source: string): string;
var
  i, count: integer;
  inTag: boolean;
  p: PChar;
begin
  SetLength(Result, Length(source));
  P := PChar(Result);
  inTag := False;
  count := 0;
  for i := 1 to Length(source) do
    if inTag then
      begin
        if source[i] = '>' then inTag := False;
      end
    else
      if source[i] = '<' then inTag := True
      else
        begin
          P[count] := source[i];
          Inc(count);
        end;
  SetLength(Result, count);
end;

function IsValidStrong(const source: string): boolean;
var
  num: integer;
  isHebrew: boolean;
begin
  Result := StrongVal(source, num, isHebrew);
end;

function FormatStrong(const number: Integer; const isHebrew: Boolean): String;
begin
  Result := IfThen(isHebrew, 'H', 'G') + IntToStr(number);
end;

function StrongVal(const source: string; var num: integer; var isHebrew: boolean;const DefaultHebrew:boolean=false): boolean;
var
  code: Integer;
  s: string;
begin
  s := Trim(source);

  if StartsText('0', s) then
    isHebrew := true
  else
   if StartsText('H', s) then
  begin
    isHebrew := true;
    s := Copy(s, 2, Length(s) - 1);
  end
  else if StartsText('G', s) then
  begin
    isHebrew := false;
    s := Copy(s, 2, Length(s) - 1);
  end
  else
    isHebrew :=DefaultHebrew;
  Val(s, num, code);

  Result := code = 0;
end;



function RepeatString(const s: string; count: cardinal): string;
var
  i: Integer;
begin
  for i := 1 to count do
    Result := Result + s;
end;

function StreamToString(const aStream: TStream; const Encoding: TEncoding): String;
var
  StringBytes: TBytes;
begin
  aStream.Position := 0;
  SetLength(StringBytes, aStream.Size);
  aStream.ReadBuffer(StringBytes, aStream.Size);
  Result := Encoding.GetString(StringBytes);
end;

end.

