unit bqPlainUtils;

interface
uses JCLWideStrings,WideStrings,SysUtils,Windows;

function PWideChar2Int(pwc:PWideChar; out val:integer):PWideChar;
function StrToTokens(const str: WideString; const delim: WideString;
  strLst: TWideStrings; useQuotes: boolean = false): integer;
function StrLimitToWordCnt(const ws:widestring; maxWordCount:integer;out actualWc:integer;out limited:boolean):WideString;
function NextWordIndex(const ws:WideString; startIx:integer):integer;
function WideStringToUtfBOMString(const ws:WideString):UTF8String;inline;
function WideIsSpaceEndedString(const ws:WideString):boolean;
function bqWidePosCI(const substr:WideString; str:WideString):integer;
function FindFirstFileExW(lpFileName: PWideChar; fInfoLevelId: _FINDEX_INFO_LEVELS;
  lpFindFileData: Pointer; fSearchOp: _FINDEX_SEARCH_OPS; lpSearchFilter: Pointer;
  dwAdditionalFlags: DWORD): THANDLE; stdcall;
function FindNextFileW(hFindFile: THANDLE; var lpFindFileData: _WIN32_FIND_DATAW): BOOL; stdcall;
function bqNowDateTimeString():WideString;
function ParamStartedWith(const token:WideString; out param:WideString):boolean;
implementation
uses BibleQuoteConfig,  JclUnicode, tntSystem;
function FindFirstFileExW; external kernel32 name 'FindFirstFileExW';
function FindNextFileW; external kernel32 name 'FindNextFileW';

function PWideChar2Int(pwc:PWideChar;  out val:integer):PWideChar;

var
    vl:integer;
begin

  val:=0;
  vl:=Integer(pwc^) -ord('0');
  while (vl>=0) and (vl<=9) do begin
  val:=10*val +vl;
  inc(pwc);
  vl:=Integer(pwc^) -ord('0');
  end;
  result:= pwc;
end;


function StrToTokens(const str: WideString; const delim: WideString;
  strLst: WideStrings.TWideStrings; useQuotes: boolean = false): integer;
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
  curPos := StrPosW(prevPos, dlp);
  if not assigned(curPos) then begin
    if length(str) > 0 then strLst.Add(str);
    exit;
  end;
  repeat
    if curPos - prevPos > 0 then begin
      SetString(ws, prevPos, (curPos - prevPos));
      ws := Trim(ws);
      strLst.Add(ws);
      prevPos := curPos + dl;
      inc(result);
    end else inc(prevPos, dl);
    curPos := StrPosW(prevPos, dlp);
  until curPos = nil;
  if prevPos <> nil then begin
    ws := prevPos;
    ws := Trim(ws);
    if length(ws) > 0 then begin strLst.Add(ws);inc(Result) end;
  end;

end;

function StrLimitToWordCnt(const ws:widestring; maxWordCount:integer;out actualWc:integer; out limited:boolean):WideString;
var pwc,start:PWideChar;
    wordStarted,charIsSeparator:boolean;


begin
start:=PWideChar(Pointer(ws));
pwc:=start;
actualWc:=0;
result:='';
limited:=(maxWordCount<=0);
if (pwc=nil) or (pwc^=#0) or limited then exit;
wordStarted:=false;
repeat
//UnicodeIsPunctuation
charIsSeparator:=CategoryLookup(Cardinal(pwc^),[ccSeparatorSpace,
 ccPunctuationConnector, ccPunctuationDash, ccPunctuationOpen,ccPunctuationClose,
 ccPunctuationOther, ccPunctuationInitialQuote, ccPunctuationFinalQuote,
 ccSeparatorSpace, ccSeparatorLine, ccSeparatorParagraph]);
 if charIsSeparator then begin
  if wordStarted then begin
   wordStarted:=false;
   if actualWc>=maxWordCount then  break;
   end;
 end
 else if not wordStarted then begin

  if  CategoryLookup(Cardinal(pwc^), [ccLetterUppercase, ccLetterLowercase, ccLetterTitlecase,
  ccLetterModifier, ccLetterOther, ccNumberDecimalDigit]) then begin
  Inc(actualWc);
  wordStarted:=true;
  end;//alphanum

 end;//word is not started

 inc(pwc);
 until pwc^=#0;
limited:=pwc^<>#0;

Result:= Copy(ws,1, (pwc-start));
end;

function NextWordIndex(const ws:WideString; startIx:integer):integer;
var pwc,start:PWideChar;
    charIsSeparator,separatorfound:boolean;


begin
start:=PWideChar(Pointer(ws));
pwc:=start;
result:=0;
if (pwc=nil) or (pwc^=#0)  then exit;

separatorfound:=false;
repeat
//UnicodeIsPunctuation
charIsSeparator:=CategoryLookup(Cardinal(pwc^),[ccSeparatorSpace, 
 ccPunctuationConnector, ccPunctuationDash, ccPunctuationOpen,ccPunctuationClose,
 ccPunctuationOther, ccPunctuationInitialQuote, ccPunctuationFinalQuote,
 ccSeparatorSpace, ccSeparatorLine, ccSeparatorParagraph]);
 if charIsSeparator and ( not separatorfound) then separatorfound:=true;
 if separatorfound then begin
  if  CategoryLookup(Cardinal(pwc^), [ccLetterUppercase, ccLetterLowercase, ccLetterTitlecase,
  ccLetterModifier, ccLetterOther, ccNumberDecimalDigit]) then begin
  result:=pwc-start;
  exit;
  end;//alphanum

 end;//sepator fnd

 inc(pwc);
 until pwc^=#0;
end;

function WideStringToUtfBOMString(const ws:WideString):UTF8String;inline;
begin
  result:=C__Utf8BOM+UTF8Encode(ws);
end;
function WideIsSpaceEndedString(const ws:WideString):boolean;
begin
result:=UnicodeIsSpace(Cardinal( ws[length(ws)-1]));
end;

function bqWidePosCI(const substr:WideString; str:WideString):integer;
var strUpper, subStrUpper:WideString;
begin
subStrUpper:= Sysutils.WideUpperCase(substr);
strUpper:=WideUpperCase(str);

result:=WidePos(subStrUpper, strUpper);

end;

function bqNowDateTimeString():WideString;
var strDate:string;
fs:TFormatSettings;
begin
  try
  GetLocaleFormatSettings(GetSystemDefaultLCID(),fs);

  fs.DateSeparator:='/';
  fs.TimeSeparator:=':';
  DateTimeToString(strDate,'dd/mmm/yy hh:mm:ss ',Now(),fs);
  result:=strDate;
  except
  on e:exception do result:=e.message;
  end;

end;
function ParamStartedWith(const token:WideString; out param:WideString):boolean;
var paramCount, paramIndex:integer;

begin
  paramCount:=WideParamCount()-1;
  result:=false;
  for paramIndex:=0 to paramCount do begin
   param:=WideParamStr(paramIndex);
  result:=WideStartsText(token,param);
  if result then break;
  end;
  if not result then begin param:=''; exit end;
end;
end.
