unit PlainUtils;

interface

uses JCLWideStrings, WideStrings, SysUtils, Windows, Classes, Character;

function PChar2Int(pwc: PWideChar; out val: integer): PChar;
function StrToTokens(const str: string; const delim: string; strLst: TStrings;
  useQuotes: boolean = false): integer;
function StrLimitToWordCnt(const ws: string; maxWordCount: integer;
  out actualWc: integer; out limited: boolean): string;
function NextWordIndex(const ws: string; startIx: integer): integer;
function WideIsSpaceEndedString(const ws: string): boolean;
function bqWidePosCI(const substr: string; str: string): integer;
function FindFirstFileExW(lpFileName: PWideChar;
  fInfoLevelId: _FINDEX_INFO_LEVELS; lpFindFileData: Pointer;
  fSearchOp: _FINDEX_SEARCH_OPS; lpSearchFilter: Pointer;
  dwAdditionalFlags: DWORD): THANDLE; stdcall;
function FindNextFileW(hFindFile: THANDLE;
  var lpFindFileData: _WIN32_FIND_DATAW): BOOL; stdcall;
function bqNowDateTimeString(): WideString;
function ParamStartedWith(const token: string; out param: string): boolean;

implementation

uses BibleQuoteConfig, JclUnicode;
function FindFirstFileExW; external kernel32 name 'FindFirstFileExW';
function FindNextFileW; external kernel32 name 'FindNextFileW';

function PChar2Int(pwc: PChar; out val: integer): PChar;

var
  vl: integer;
begin

  val := 0;
  vl := integer(pwc^) - ord('0');
  while (vl >= 0) and (vl <= 9) do
  begin
    val := 10 * val + vl;
    inc(pwc);
    vl := integer(pwc^) - ord('0');
  end;
  result := pwc;
end;

function StrToTokens(const str: string; const delim: string; strLst: TStrings;
  useQuotes: boolean = false): integer;
var
  dl: integer;

  dlp, prevPos, curPos: PWideChar;
  ws: WideString;
begin
  result := 0;
  dl := Length(delim);
  strLst.Clear;
  dlp := PWideChar(Pointer(delim));
  prevPos := PWideChar(Pointer(str));
  curPos := StrPos(prevPos, dlp);
  if not assigned(curPos) then
  begin
    if Length(str) > 0 then
      strLst.Add(str);
    exit;
  end;
  repeat
    if curPos - prevPos > 0 then
    begin
      SetString(ws, prevPos, (curPos - prevPos));
      ws := Trim(ws);
      strLst.Add(ws);
      prevPos := curPos + dl;
      inc(result);
    end
    else
      inc(prevPos, dl);
    curPos := StrPos(prevPos, dlp);
  until curPos = nil;
  if prevPos <> nil then
  begin
    ws := prevPos;
    ws := Trim(ws);
    if Length(ws) > 0 then
    begin
      strLst.Add(ws);
      inc(result)
    end;
  end;

end;

function StrLimitToWordCnt(const ws: string; maxWordCount: integer;
  out actualWc: integer; out limited: boolean): string;
var
  pwc, start: PChar;
  wordStarted, charIsSeparator: boolean;
begin
  start := PChar(Pointer(ws));
  pwc := start;
  actualWc := 0;
  result := '';
  limited := (maxWordCount <= 0);
  if (pwc = nil) or (pwc^ = #0) or limited then
    exit;
  wordStarted := false;
  repeat
    // UnicodeIsPunctuation
    charIsSeparator := (pwc^).GetUnicodeCategory()
      in [TUnicodeCategory.ucConnectPunctuation,
      TUnicodeCategory.ucDashPunctuation, TUnicodeCategory.ucOpenPunctuation,
      TUnicodeCategory.ucClosePunctuation, TUnicodeCategory.ucOtherPunctuation,
      TUnicodeCategory.ucInitialPunctuation,
      TUnicodeCategory.ucFinalPunctuation, TUnicodeCategory.ucSpaceSeparator,
      TUnicodeCategory.ucLineSeparator, TUnicodeCategory.ucParagraphSeparator];
    if charIsSeparator then
    begin
      if wordStarted then
      begin
        wordStarted := false;
        if actualWc >= maxWordCount then
          break;
      end;
    end
    else if not wordStarted then
    begin
      if ((pwc^).GetUnicodeCategory() in [TUnicodeCategory.ucUppercaseLetter,
        TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucTitlecaseLetter,
        TUnicodeCategory.ucModifierLetter, TUnicodeCategory.ucOtherLetter,
        TUnicodeCategory.ucDecimalNumber]) or ((pwc^).IsDigit()) then
      begin
        inc(actualWc);
        wordStarted := true;
      end; // alphanum

    end; // word is not started

    inc(pwc);
  until pwc^ = #0;
  limited := pwc^ <> #0;

  result := Copy(ws, 1, (pwc - start));
end;

function NextWordIndex(const ws: string; startIx: integer): integer;
var
  pwc, start: PChar;
  charIsSeparator, separatorfound: boolean;

begin
  start := PChar(Pointer(ws));
  pwc := start;
  result := 0;
  if (pwc = nil) or (pwc^ = #0) then
    exit;

  separatorfound := false;
  repeat
    // UnicodeIsPunctuation
    charIsSeparator := (pwc^).GetUnicodeCategory()
      in [TUnicodeCategory.ucConnectPunctuation,
      TUnicodeCategory.ucDashPunctuation, TUnicodeCategory.ucOpenPunctuation,
      TUnicodeCategory.ucClosePunctuation, TUnicodeCategory.ucOtherPunctuation,
      TUnicodeCategory.ucInitialPunctuation,
      TUnicodeCategory.ucFinalPunctuation, TUnicodeCategory.ucSpaceSeparator,
      TUnicodeCategory.ucLineSeparator, TUnicodeCategory.ucParagraphSeparator];

    if charIsSeparator and (not separatorfound) then
      separatorfound := true;
    if separatorfound then
    begin
      if ((pwc^).GetUnicodeCategory() in [TUnicodeCategory.ucUppercaseLetter,
        TUnicodeCategory.ucLowercaseLetter, TUnicodeCategory.ucTitlecaseLetter,
        TUnicodeCategory.ucModifierLetter, TUnicodeCategory.ucOtherLetter,
        TUnicodeCategory.ucDecimalNumber]) or ((pwc^).IsDigit()) then
      begin
        result := pwc - start;
        exit;
      end; // alphanum

    end; // sepator fnd

    inc(pwc);
  until pwc^ = #0;
end;

function WideIsSpaceEndedString(const ws: string): boolean;
begin
  result := UnicodeIsSpace(Cardinal(ws[Length(ws) - 1]));
end;

function bqWidePosCI(const substr: string; str: string): integer;
var
  strUpper, subStrUpper: string;
begin
  subStrUpper := SysUtils.UpperCase(substr);
  strUpper := UpperCase(str);

  result := Pos(subStrUpper, strUpper);

end;

function bqNowDateTimeString(): WideString;
var
  strDate: string;
  fs: TFormatSettings;
begin
  try
    fs := TFormatSettings.Create(GetSystemDefaultLCID());

    fs.DateSeparator := '/';
    fs.TimeSeparator := ':';
    DateTimeToString(strDate, 'dd/mmm/yy hh:mm:ss ', Now(), fs);
    result := strDate;
  except
    on e: exception do
      result := e.message;
  end;

end;

function ParamStartedWith(const token: string; out param: string): boolean;
var
  params, paramIndex: integer;
var
  len: integer;
begin
  params := ParamCount - 1;
  result := false;
  for paramIndex := 0 to params do
  begin
    param := ParamStr(paramIndex);
    len := Length(token);
    result := (len <= Length(param)) and
      (StrLIComp(PChar(token), PChar(param), len) = 0);
    if result then
      break;
  end;
  if not result then
  begin
    param := '';
    exit
  end;
end;

end.
