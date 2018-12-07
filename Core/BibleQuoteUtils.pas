unit BibleQuoteUtils;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses SevenZipHelper, SevenZipVCL, MultiLanguage, IOUtils, JCLDebug, PlainUtils,
  Contnrs, Windows, SysUtils, Classes, SystemInfo, CRC32, Vcl.Graphics,
  ImageUtils, SyncObjs, ShlObj, AppPaths, AppIni;

type
  TPasswordPolicy = class
  protected
    mPasswordList: TStrings;
    mPath: string;
    mUserHash: int64;
    function GetUserHash(): int64;
    function XorPassword(aPwd: string; produceHex: boolean = true): string;
  public
    function LoadFromFile(const filename: string): boolean;
    procedure SaveToFile(const filename: string);
    function GetPassword(aSender: TSevenZip; out aPassword: WideString) : boolean;
    procedure InvalidatePassword(const aFile: string);
    constructor Create(wsString: string);
    destructor Destroy(); override;
  end;

  TBQException = class(Exception)
    mErrCode: Cardinal;
    mMessage: string;
    constructor CreateFmt(const Msg: string; const Args: array of const);
  end;

  TbqHLVerseOption = (hlFalse, hlTrue, hlDefault);

  TBQPasswordException = class(TBQException)
    mArchive: string;
    mWrongPassword: string;
    constructor CreateFmt(const password, module: string; const Msg: string; const Args: array of const);
  end;

  TBQInstalledFontInfo = class
    mPath: string;
    mFileNeedsCleanUp: boolean;
    mHandle: HFont;
    constructor Create(const aPath: string; afileNeedsCleanUp: boolean; aHandle: HFont);

  end;

  TModuleType = (
    modtypeBible,
    modtypeBook,
    modtypeComment);

  TModMatchType = (mmtName, mmtBookName, mmtCat, mmtPartial);
  TModMatchTypes = set of TModMatchType;

  TRectArray = array [0 .. 9] of TRect;
  PRectArray = ^TRectArray;

  TMatchInfo = record
    ix: integer;
    matchSt: integer;
    name: string;
    rct: TRect;
  end;

  TMatchInfoArray = array of TMatchInfo;
  TbqItemStyle = (bqisExpanded);
  TbqItemStyles = set of TbqItemStyle;

  TModuleEntry = class
    mFullName, mShortName, mShortPath, mFullPath: string;
    modType: TModuleType;
    modCats: string;
    modBookNames: string;

    mAuthor: string;
    mCoverPath: string;
    mHasStrong: Boolean;

    mRects: PRectArray;
    mCatsCnt: integer;
    mNode: Pointer;
    mStyle: TbqItemStyles;
    mMatchInfo: TMatchInfoArray;

    constructor Create(
      amodType: TModuleType;
      aFullName, aShortName, aShortPath, aFullPath: string;
      aBookNames: string;
      modCats: TStrings;
      anAuthor: string;
      aCoverPath: string;
      hasStrong: boolean); overload;

    constructor Create(
      amodType: TModuleType;
      aFullName, aShortName, aShortPath, aFullPath: string;
      aBookNames: string;
      modCats: string;
      anAuthor: string;
      aCoverPath: string;
      hasStrong: boolean); overload;

    constructor Create(me: TModuleEntry); overload;
    destructor Destroy; override;

    procedure Init(
      amodType: TModuleType;
      aFullName, aShortName, aShortPath, aFullPath: string;
      aBookNames: string;
      modCatsLst: TStrings;
      anAuthor: string;
      aCoverPath: string;
      hasStrong: boolean); overload;

    procedure Init(
      amodType: TModuleType;
      aFullName, aShortName, aShortPath, aFullPath: string;
      aBookNames: string;
      amodCats: string;
      anAuthor: string;
      aCoverPath: string;
      hasStrong: boolean); overload;

    procedure Assign(source: TModuleEntry);
    function Match(matchLst: TStringList; var mi: TMatchInfoArray; allMath: boolean = false): TModMatchTypes;

    function BookNameByIx(ix: integer): string;
    function VisualSignature(): string;
    function BibleBookPresent(ix: integer): boolean;
    function GetCoverImage(width, height: integer): TPicture;

    function getIniPath(): string;
  protected
    mCachedCover: TPicture;
    mCachedWidth, mCachedHeight: integer;
    mCachedCoverLock : TCriticalSection;

    function DefaultModCats(): string;
  end;

  TCachedModules = class(TObjectList)
  protected
    mSorted: boolean;
    mModTypedAsPointers: array [TModuleType] of integer;
    FOnAssignEvent: TNotifyEvent;

    function GetItem(Index: integer): TModuleEntry;
    procedure SetItem(Index: integer; AObject: TModuleEntry);
    function GetArchivedCount(): integer;
  public
    procedure Assign(source: TCachedModules);
    function FindByName(const name: string; fromix: integer = 0): integer;
    function ResolveModuleByNames(const modName, modShortName: string) : TModuleEntry;
    function IndexOf(const name: string; fromix: integer = 0) : integer; overload;
    function FindByFolder(const name: string): integer;
    function FindByFullPath(const wsFullPath: string): integer;
    function GetModTypedAsCount(modType: TModuleType): integer;
    function ModTypedAsFirst(modType: TModuleType): TModuleEntry;
    function ModTypedAsNext(modType: TModuleType): TModuleEntry;
    procedure _Sort();

    property Items[Index: integer]: TModuleEntry read GetItem write SetItem; default;

    property ArchivedModulesCount: integer read GetArchivedCount;
    property ModTypedAsCount[modType: TModuleType]: integer read GetModTypedAsCount;

    property OnAssignEvent: TNotifyEvent read FOnAssignEvent write FOnAssignEvent;
  end;

  TBQStringList = class(TStringList)
  protected
    function CompareStrings(const S1, S2: string): integer; override;
  public
    function LocateLastStartedWith(const subString: string; startFromIx: integer = 0; strict: boolean = false): integer;
  end;

  TbqExceptionContext = class(TStringList)
  end;

  TbqTextFileWriter = class(TObject)
  protected
    mHandle: THandle;
  public
    constructor Create(const aFileName: string);
    function WriteLine(const line: string): HRESULT;
    function Close(): HRESULT;
    destructor Destroy(); override;
  end;

var
  g_ExceptionContext: TbqExceptionContext;

resourcestring
  bqPageStyle = '<STYLE> '#13#10 +
    '<!--'#13#10 +
    'p.BQNormal{'#13#10 +
    'margin:0;'#13#10 +
    'margin-bottom : 0;'#13#10 +
    'margin-left : 0.8ex;'#13#10 +
    'margin-right : 0.8ex;'#13#10 +
    'font-size:x-large;'#13#10 +
    'text-indent:40px;'#13#10 +
    '}'#13#10 +

    'A.OmegaVerseNumber {'#13#10 +
    'font-family:Helvetica;'#13#10 +
    '}'#13#10 +
  '-->'#13#10 +
  'A.bqResolvedLink {'#13#10 +
    'font-family:''Times New Roman'';'#13#10 +
    'font-style:italic;'#13#10 +
    'font-weight:lighter;'#13#10 +
    '}'#13#10 +
  '-->'#13#10 +
    '</STYLE>';

function GetArchiveFromSpecial(const aSpecial: string): string; overload;
function GetArchiveFromSpecial(const aSpecial: string; out filename: string): string; overload;
function FileExistsEx(aPath: string): integer;
function ArchiveFileSize(path: string): integer;
function SpecialIO(const fileName: string; strings: TStrings; obf: int64; read: boolean = true): boolean;
function FontExists(const fontName: string): boolean;
function FontFromCharset(aHDC: HDC; charset: integer; desiredFont: string = ''): string;
function ExtractModuleName(aModuleSignature: string): string;
function StrPosW(const Str, SubStr: PChar): PChar;
function ExctractName(const filename: string): string;
function IsDown(key: integer): boolean;
function FileRemoveExtension(const path: string): string;
procedure CopyHTMLToClipBoard(const Str: string; const htmlStr: string = '');
procedure InsertDefaultFontInfo(var html: string; fontName: string; fontSz: integer);
function TokensToStr(Lst: TStrings; delim: string; addlastDelim: boolean = true): string;
function StrMathTokens(const Str: string; tkns: TStrings; fullMatch: boolean): boolean;
function CompareTokenStrings(const tokensCompare: string; const tokenCompareAgainst: string; delim: Char): integer;
function StrGetTokenByIx(tknString: string; tokenIx: integer): string;
function GetTokenFromString(pStr: PChar; delim: Char; out len: integer): PChar;
function PeekToken(pC: PChar; delim: Char): string;

function MainFileExists(s: string): string;
function GetCallerEIP(): Pointer;
function GetCallerEbP(): Pointer;
procedure cleanUpInstalledFonts();

type
  PfnAddFontMemResourceEx = function(p1: Pointer; p2: DWORD; p3: PDesignVector; p4: LPDWORD): THandle; stdcall;

type
  PfnRemoveFontMemResourceEx = function(p1: THandle): BOOL; stdcall;

var
  G_AddFontMemResourceEx: PfnAddFontMemResourceEx;
  G_RemoveFontMemResourceEx: PfnRemoveFontMemResourceEx;

var
  G_InstalledFonts: TStringList;
  Lang: TMultiLanguage;
  G_DebugEx: integer;
  G_NoCategoryStr: string = 'Áåç êàòåãîðèè';

implementation

uses JclSysInfo, MainFrm, Controls, Forms, Clipbrd, StrUtils, BibleQuoteConfig,
  StringProcs, JclBase;

function GetArchiveFromSpecial(const aSpecial: string): string; overload;
var
  pz: integer;
begin
  // string like rststrong.bqb??bibleqt.ini in rststrong.bqb
  pz := Pos('??', aSpecial);
  if pz <= 0 then
    result := EmptyStr
  else
    result := Copy(aSpecial, 1, pz - 1);
end;

function FileRemoveExtension(const path: string): string;
var
  I: integer;
begin

  I := LastDelimiter(':.\', path);
  if (I > 0) and (path[I] = '.') then
    result := Copy(path, 1, I - 1)
  else
    result := path;
end;

function GetArchiveFromSpecial(const aSpecial: string; out filename: string): string; overload;
var
  pz: integer;
  correct: integer;
begin
  // string like rststrong.bqb??bibleqt.ini in rststrong.bqb and bibleqt.ini
  pz := Pos('??', aSpecial);
  if pz <= 0 then
    result := EmptyStr
  else
  begin
    correct := Ord(aSpecial[1] = '?') + 1;
    result := Copy(aSpecial, correct, pz - correct);
    filename := Copy(aSpecial, pz + 2, $FFFFFF);
  end; // else
end; // fn

function TokensToStr(Lst: TStrings; delim: string; addlastDelim: boolean = true): string;
var
  c, I: integer;
begin
  result := '';
  c := Lst.count - 1;
  if c < 0 then
    exit;
  result := Lst[0];
  for I := 1 to c do
    result := result + delim + Lst[I];
  if (c >= 0) and addlastDelim then
    result := result + delim;
end;

function StrTokenIx(const tknString: string; hitPos: integer): integer;
var
  sl, si: integer;
begin
  sl := Length(tknString);
  si := 1;
  result := 1;
  repeat
    if hitPos <= si then
      break;
    if tknString[si] = '|' then
      inc(result);
    inc(si);
  until si > sl;
  if si >= sl then
    result := 0;
end;

function StrGetTokenByIx(tknString: string; tokenIx: integer): string;
var
  p, p2: integer;
begin
  p := 1;
  dec(tokenIx);
  if tokenIx > 0 then
    repeat
      p := PosEx('|', tknString, p);
      if p > 0 then
        inc(p);
      dec(tokenIx);
    until (tokenIx <= 0) or (p = 0);

  if (p = 0) then
  begin
    result := '';
    exit
  end;
  p2 := PosEx('|', tknString, p);
  if p2 = 0 then
    p2 := $FFF;
  result := Copy(tknString, p, p2 - p);
end;

function ArchiveFileSize(path: string): integer;
var
  archive, aFile: string;
begin
  result := -1;
  try
    archive := GetArchiveFromSpecial(path, aFile);
    getSevenZ().SZFileName := archive;
    if getSevenZ().GetIndexByFilename(aFile, @result) < 0 then
      result := -1;
  except
    on e: Exception do
    begin
      g_ExceptionContext.Add('BibleQuoteUtils.ArchiveFileSize.wsPath' + path);
    end;
  end;

end;

function FileExistsEx(aPath: string): integer;
var
  archive, aFile: string;
begin
  result := -1;
  if Length(aPath) < 1 then
    exit;
  if aPath[1] <> '?' then
  begin
    result := Ord(FileExists(aPath)) - 1;
    exit;
  end;
  archive := GetArchiveFromSpecial(aPath, aFile);
  if (Length(archive) <= 0) or (Length(aFile) < 0) then
    exit;
  try
    getSevenZ().SZFileName := archive;
    result := getSevenZ().GetIndexByFilename(aFile);
  except
    g_ExceptionContext.Add('FileExistsEx.aPath=' + aPath);
    raise;
  end;

end;

function SpecialIO(const fileName: string; strings: TStrings; obf: int64; read: boolean = true): boolean;
var
  fileHandle: THandle;
  fileSz, readed: Cardinal;
  crcExpected, crcCalculated: Cardinal;
  buf: PChar;
  str: string;

  procedure _EncodeDecode(); // simple 64bit xor encoding
  var
    I, count: Cardinal;
    pC: PCardinal;
    f, s: Cardinal;
  begin
    count := (fileSz shr 3) - 1;
    f := Cardinal(obf);
    s := PCardinal(PChar(@obf) + 4)^;
    pC := PCardinal(PChar(buf));
    for I := 0 to count do
    begin
      pC := PCardinal(PChar(buf) + I * 8);
      pC^ := pC^ xor f;
      PCardinal(PChar(pC) + 4)^ := PCardinal(PChar(pC) + 4)^ xor s;
    end;
    if (fileSz - count * 8) >= 4 then
    begin
      inc(pC);
      pC^ := pC^ xor f;
    end;

  end;

begin
  if read then
  begin
    fileHandle := CreateFile(
      PChar(Pointer(fileName)), GENERIC_READ, 0,
      nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

    if fileHandle = INVALID_HANDLE_VALUE then
    begin
      result := false;
      exit;
    end;
    fileSz := GetFileSize(fileHandle, nil);
    if fileSz = INVALID_FILE_SIZE then
    begin
      result := false;
      exit;
    end;
    dec(fileSz, 4);
    GetMem(buf, fileSz);
    try
      result := ReadFile(fileHandle, crcExpected, 4, readed, nil);
      if (not result) or (readed <> 4) then
        exit;
      result := ReadFile(fileHandle, buf^, fileSz, readed, nil);
      if (result) then
      begin
        _EncodeDecode();
        crcCalculated := GetCRC32(PByteArray(buf), fileSz);
        if crcCalculated <> crcExpected then
        begin

          result := false;
          exit;
        end;
        strings.SetText(buf);

      end;
    finally
      CloseHandle(fileHandle);
      FreeMem(buf);
    end;
  end
  else
  begin // write
    fileHandle := CreateFile(PChar(Pointer(fileName)),
      GENERIC_WRITE, 0,
      nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);

    if fileHandle = INVALID_HANDLE_VALUE then
    begin
      result := false;
      exit;
    end;
    try
      str := strings.Text;
      fileSz := Length(str) * 2;
      buf := Pointer(PChar(str));
      crcCalculated := GetCRC32(PByteArray(buf), fileSz);
      _EncodeDecode();
      result := WriteFile(fileHandle, crcCalculated, 4, readed, nil);
      if (not result) or (readed <> 4) then
        exit;
      result := WriteFile(fileHandle, buf^, fileSz, readed, nil);
    finally
      CloseHandle(fileHandle);
    end;
  end;
end;

{ TPasswordPolicy }

constructor TPasswordPolicy.Create(wsString: string);

begin
  mPasswordList := TStringList.Create();
  LoadFromFile(wsString);
  mUserHash := GetUserHash();
  writeln('TPasswordPolicy.Create õýø: ', mUserHash);
  _S_SevenZipGetPasswordProc := GetPassword;
end;

destructor TPasswordPolicy.Destroy;
begin
  // nothing
  getSevenZ().OnGetPassword := nil;
  mPasswordList.Free();
  inherited;
end;

function TPasswordPolicy.GetPassword(aSender: TSevenZip; out aPassword: WideString): boolean;
var
  filename: string;
  ix, pwFormShowResult, pwdLength: integer;
  blSavePwd: boolean;
  s: string;
  pwdEncoded: string;

  function HexDigitVal(d: Char): byte;
  begin
    result := 0;
    case d of
      '0' .. '9':
        result := Ord(d) - Ord('0');
      'A' .. 'F':
        result := Ord(d) - Ord('A') + 10;
    else
      abort;
    end;
  end;

begin
  filename := aSender.SZFileName;
  ix := mPasswordList.IndexOfName(filename);
  if (ix < 0) then
  begin // requested password was not found in the cache
    pwFormShowResult := MainForm.PassWordFormShowModal(aSender.SZFileName, aPassword, blSavePwd);
    if (pwFormShowResult = mrOk) and (Length(aPassword) > 0) then
    begin
      s := XorPassword(aPassword);
      writeln(filename, ' ', s);
      mPasswordList.AddObject(Format('%s=%s', [filename, s]), TObject(Ord(blSavePwd)));
    end
    else if (pwFormShowResult = mrCancel) then
    begin
      result := false;
      exit;
    end;

  end
  else
  begin // password is in the cache
    s := mPasswordList[ix];
    ix := Pos('=', s);
    s := Copy(s, ix + 1, $FFFF);
    pwdLength := Length(s) div 2;
    SetLength(pwdEncoded, pwdLength);
    for ix := 1 to pwdLength do
    begin
      pwdEncoded[ix] := chr(HexDigitVal(Char(s[(ix - 1) * 2 + 1])) * 16 + HexDigitVal(Char(s[ix * 2])));
    end;
    writeln('found  ', pwdEncoded);
    pwdEncoded := XorPassword(pwdEncoded, false);
    writeln('after xor  ', pwdEncoded);
    Flush(output);
    aPassword := pwdEncoded;
  end;
  result := true;
end;

function TPasswordPolicy.GetUserHash: int64;
var
  userFolder: string;
  len: integer;
  data: int64;
begin
  userFolder := UpperCase(TAppDirectories.UserSettings);
  len := Length(userFolder);
  if len <= 0 then
  begin
    result := 0;
    exit;
  end;
  FillChar(data, 8, 0);

  asm
    pushad
    mov ecx, [len]
    mov eax, [userFolder]
    xor edx, edx
    xor esi, esi
    xor edi, edi
  @lp:
    xor dl, byte ptr [eax];
    shr edi, 1
    rcl edx, 1
    rcl esi, 1
    rcl edx, 1
    rcl esi, 1
    rcl edx, 1
    rcl esi, 1
    adc edi, 0
    inc eax
    dec ecx
    ja @lp

  @done:
    mov dword ptr [data], edx
    mov dword ptr 4[data], esi
    popad
  end;
  result := data;
end;

procedure TPasswordPolicy.InvalidatePassword(const aFile: string);
var
  ix: integer;
begin
  ix := mPasswordList.IndexOfName(aFile);
  if ix >= 0 then
    mPasswordList.Delete(ix);
end;

function TPasswordPolicy.LoadFromFile(const filename: string): boolean;
var
  I, count: integer;
begin
  try
    if not assigned(mPasswordList) then
      mPasswordList := TStringList.Create()
    else
      mPasswordList.Clear();
    mPath := ExtractFilePath(filename);
    result := SpecialIO(filename, mPasswordList, $1F6D35AC138E5311);
    if not result then
      exit;
    count := mPasswordList.count - 1;
    for I := 0 to count do
      mPasswordList.Objects[I] := TObject(1);
    result := true;
  except
    g_ExceptionContext.Add('TPasswordPolicy.LoadFromFile.fileName=' + filename);
    raise;
  end;

end; // func LoadFile

procedure TPasswordPolicy.SaveToFile(const filename: string);
var
  I, recordCount: integer;
begin
  recordCount := mPasswordList.count;
  if recordCount <= 0 then
    exit;
  I := 0;
  repeat
    if integer(mPasswordList.Objects[I]) = 0 then
    begin
      mPasswordList.Delete(I);
      dec(recordCount);
    end
    else
      inc(I);
  until I >= recordCount;
  if recordCount <= 0 then
    exit;
  SpecialIO(filename, mPasswordList, $1F6D35AC138E5311, false);
end;

function TPasswordPolicy.XorPassword(aPwd: string; produceHex: boolean = true): string;
var
  I, j, pwdLength: integer;
  charByte: byte;
  pUserHash: PByteArray;
begin
  pwdLength := Length(aPwd);
  pUserHash := @mUserHash;
  I := 1;
  j := 0;
  repeat
    charByte := Ord(aPwd[I]) xor pUserHash^[j];
    inc(I);
    inc(j);
    if produceHex then
      result := result + IntToHex(charByte, 2)
    else
      result := result + chr(charByte);
    if j > 7 then
      j := 0;
  until I > pwdLength;

end;

{ TBQException }

constructor TBQException.CreateFmt(const Msg: string; const Args: array of const);
begin
  mMessage := 'Error!';
  if assigned(Lang) then
  begin
    mMessage := Lang.SayDefault(Msg, mMessage);
    mMessage := Format(mMessage, Args);
  end; // if assigned
  inherited CreateFmt(mMessage, Args);
end;

{ TBQPasswordException }

constructor TBQPasswordException.CreateFmt(const password, module: string; const Msg: string; const Args: array of const);
begin
  mArchive := module;
  mWrongPassword := password;
  inherited CreateFmt(Msg, Args);
end;

var
  __hitCount: integer;
{$J+}
	const lastPrec: integer = 0;
{$J-}

function EnumFontFamExProc(
  lpelfe: PEnumLogFontEx; // logical-font data
  lpntme: PEnumTextMetric; // physical-font data
  FontType: DWORD; // type of font
  lParam: lParam // application-defined data
  ): integer; stdcall;
var
  str: string;
begin
  result := 1;
  if (lpelfe^.elfLogFont.lfOutPrecision < OUT_STROKE_PRECIS) and (lParam <> 0)
  then
    exit;

  inc(__hitCount);
  if (lParam <> 0) and ((PChar(lParam)^ = #0) or
    (lpelfe^.elfLogFont.lfOutPrecision > lastPrec)) then
  begin
    str := lpelfe^.elfFullName;
    Move(lpelfe^.elfFullName, PChar(lParam)^, 64);
    lastPrec := lpelfe^.elfLogFont.lfOutPrecision;
  end;
end;

function FontFromCharset(aHDC: HDC; charset: integer; desiredFont: string = ''): string;
var
  logFont: tagLOGFONT;
  fontNameLength: integer;
  fontName: array [0 .. 64] of Char;
begin
  __hitCount := 0;
  FillChar(logFont, sizeof(logFont), 0);
  FillChar(fontName, 64, 0);
  logFont.lfCharSet := charset;
  fontNameLength := Length(desiredFont);
  if fontNameLength > 0 then
  begin
    if (fontNameLength > 31) then
      fontNameLength := 31;

    Move(Pointer(desiredFont)^, logFont.lfFaceName, fontNameLength * 2);
    EnumFontFamiliesEx(aHDC, logFont, @EnumFontFamExProc, 0, 0);
    if __hitCount > 0 then
    begin
      result := desiredFont;
      exit;
    end;
  end;
  __hitCount := 0;
  lastPrec := 0;
  FillChar(logFont, sizeof(logFont), 0);
  FillChar(fontName, 64, 0);
  logFont.lfCharSet := charset;
  EnumFontFamiliesEx(aHDC, logFont, @EnumFontFamExProc, integer(@fontName), 0);
  if (__hitCount > 0) and (fontName[0] <> #0) then
  begin
    result := PChar(@fontName);
    G_InstalledFonts.Add(result); // long font names workaround
  end
  else
    result := EmptyStr;
end;

function FontExists(const fontName: string): boolean;
begin
  if G_InstalledFonts.IndexOf(fontName) >= 0 then
  begin
    result := true;
    exit;
  end;
  result := Screen.Fonts.IndexOf(fontName) >= 0;
end;

function ExctractName(const filename: string): string;
var
  pC, pLastDot: PChar;
begin
  pC := PChar(Pointer(filename));
  if (pC = nil) or (pC^ = #0) then
  begin
    result := '';
    exit
  end;
  pLastDot := nil;
  repeat
    if pC^ = '.' then
      pLastDot := pC;
    inc(pC);
  until (pC^ = #0);
  if pLastDot <> nil then
    result := Copy(filename, 1, pLastDot - PChar(Pointer(filename)))
  else
    result := filename;
end;

function ExtractModuleName(aModuleSignature: string): string;
var
  ipos: integer;
begin
  ipos := Pos(' $$$ ', aModuleSignature);
  if ipos <= 0 then
  begin
    result := '';
    exit
  end;
  result := Copy(aModuleSignature, 1, ipos - 1);
end;

function StrPosW(const Str, SubStr: PChar): PChar;
var
  p: PChar;
  I: integer;
begin
  result := nil;
  if (Str = nil) or (SubStr = nil) or (Str^ = #0) or (SubStr^ = #0) then
    exit;
  result := Str;
  while result^ <> #0 do
  begin
    if result^ <> SubStr^ then
      inc(result)
    else
    begin
      p := result + 1;
      I := 1;
      while (p^ <> #0) and (p^ = SubStr[I]) do
      begin
        inc(I);
        inc(p);
      end;
      if SubStr[I] = #0 then
        exit
      else
        inc(result);
    end;
  end;
  result := nil;
end;

{ TBQInstalledFontInfo }

constructor TBQInstalledFontInfo.Create(
  const aPath: string;
  afileNeedsCleanUp: boolean;
  aHandle: HFont);
begin
  mHandle := aHandle;
  mFileNeedsCleanUp := afileNeedsCleanUp;
  mPath := aPath;
end;

function IsDown(key: integer): boolean;
begin
  result := (Windows.GetKeyState(key) and $8000) <> 0;
end;

procedure cleanUpInstalledFonts();
var
  cnt, I: integer;
  ifi: TBQInstalledFontInfo;
  tf: array [0 .. 1023] of Char;
  tempPathLen: integer;
begin
  ifi := nil;
  if not(assigned(G_InstalledFonts)) then
    exit;
  cnt := G_InstalledFonts.count - 1;
  if cnt > 0 then
  begin
    tempPathLen := GetTempPath(1023, tf);
    if tempPathLen < 1024 then
      for I := 0 to cnt do
      begin
        try
          ifi := G_InstalledFonts.Objects[I] as TBQInstalledFontInfo;
          if not assigned(ifi) then
            continue; // for fake installed font - long font names workaround

          if (ifi.mHandle <> 0) and assigned(G_RemoveFontMemResourceEx) then
            G_RemoveFontMemResourceEx(ifi.mHandle)
          else
          begin
            RemoveFontResource(PChar(Pointer(ifi.mPath)));
            if ifi.mFileNeedsCleanUp then
            begin
              { Add the safe disposal of the font file }
            end;
          end;
        except
        end;
        if (ifi <> nil) then
          ifi.Free();
      end; // for
  end;
  try
    G_InstalledFonts.Free();
  except
  end;
end;

procedure load_proc();
var
  h: THandle;
begin
  h := LoadLibrary('gdi32.dll');
  G_AddFontMemResourceEx := PfnAddFontMemResourceEx
    (GetProcAddress(h, 'AddFontMemResourceEx'));
  G_RemoveFontMemResourceEx := PfnRemoveFontMemResourceEx
    (GetProcAddress(h, 'RemoveFontMemResourceEx'));
end;

function FormatHTMLClipboardHeader(HTMLText: string): string;
const
  CrLf = #13#10;
begin
  HTMLText := '<!--StartFragment-->' + #13#10 + HTMLText + #13#10 + '<!--EndFragment -->' + #13#10;
  result := 'Version:0.9' + CrLf;
  result := result + 'StartHTML:-1' + CrLf;
  result := result + 'EndHTML:-1' + CrLf;
  result := result + 'StartFragment:000081' + CrLf;
  result := result + 'EndFragment:°°°°°°' + CrLf;
  result := result + HTMLText + CrLf;
  result := StringReplace(result, '°°°°°°',
    Format('%.6d', [Length(result)]), []);
end;

function GetHeader(html: string): string;
const
  Version = 'Version:1.0'#13#10;
  StartHTML = 'StartHTML:';
  EndHTML = 'EndHTML:';
  StartFragment = 'StartFragment:';
  EndFragment = 'EndFragment:';
  SourceURL = 'SourceURL:';
  NumberLengthAndCR = 10;
const
  StartFrag = '<!--StartFragment-->';
  EndFrag = '<!--EndFragment-->';
  DocType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'#13#10;

  // Let the compiler determine the description length.
  PreliminaryLength = Length(Version) + Length(StartHTML) + Length(EndHTML) +
    Length(StartFragment) + Length(EndFragment) + 4 * NumberLengthAndCR + 2;
  { 2 for last CRLF }
var
  URLString: string;
  StartHTMLIndex, EndHTMLIndex, StartFragmentIndex, EndFragmentIndex: integer;
begin
  Insert(StartFrag, html, 1);
  html := DocType + html;
  html := html + EndFrag;

  URLString := 'about:blank';
  StartHTMLIndex := PreliminaryLength + Length(URLString);
  EndHTMLIndex := StartHTMLIndex + Length(html);
  StartFragmentIndex := StartHTMLIndex + Pos(StartFrag, html) + Length(StartFrag) - 1;
  EndFragmentIndex := StartHTMLIndex + Pos(EndFrag, html) - 1;

  result := Version + SysUtils.Format(
    '%s%.8d', [StartHTML, StartHTMLIndex]) + #13#10 +
    Format('%s%.8d', [EndHTML, EndHTMLIndex]) + #13#10 +
    Format('%s%.8d', [StartFragment, StartFragmentIndex]) + #13#10 +
    Format('%s%.8d', [EndFragment, EndFragmentIndex]) + #13#10 +
    URLString + #13#10 + html;
end;

// The second parameter is optional and is put into the clipboard as CF_HTML.
// Function can be used standalone or in conjunction with the VCL clipboard so long as
// you use the USEVCLCLIPBOARD conditional define
// ($define USEVCLCLIPBOARD}
// (and clipboard.open, clipboard.close).
// Code from http://www.lorriman.com

procedure InsertDefaultFontInfo(var html: string; fontName: string; fontSz: integer);
var
  I: integer;
  s, L: string;
  HeadFound: boolean;
begin
  L := LowerCase(html);
  I := Pos('<head>', L);
  HeadFound := I > 0;
  if not HeadFound then
    I := Pos('<html>', L);
  if I <= 0 then
    I := 1;
  s := '<style> body {font-size: ' + IntToStr(fontSz) + 'pt; font-family: "' +
    fontName + '"; }</style>';
  if not HeadFound then
    s := '<head>' + s + '</head>';
  Insert(s, html, I);
end;

procedure CopyHTMLToClipBoard(const Str: string; const htmlStr: string = '');
var
  gMem: HGLOBAL;
  lp: PChar;
  L: integer;
  astr: string;
  hf: UINT;
begin
  hf := RegisterClipboardFormat('HTML Format');
  clipboard.Open;
  try
    // most descriptive first as per api docs
    // astr:=FormatHTMLClipboardHeader(htmlStr );
    astr := GetHeader(htmlStr);
    if Length(htmlStr) > 0 then
    begin
      // an extra "1" for the null terminator
      L := Length(astr) + 1;
      gMem := GlobalAlloc(GMEM_DDESHARE + GMEM_MOVEABLE, L);
      { Succeeded, now read the stream contents into the memory the pointer points at }
      try
        Win32Check(gMem <> 0);
        lp := GlobalLock(gMem);
        Win32Check(lp <> nil);
        CopyMemory(lp, Pointer(astr), L);
      finally
        GlobalUnlock(gMem);
      end;
      Win32Check(gMem <> 0);
      SetClipboardData(hf, gMem);
      Win32Check(gMem <> 0);
    end;

  finally
{$IFNDEF USEVCLCLIPBOARD}
    clipboard.Close;
{$ENDIF}
  end;
end;

{ TModuleEntry }

procedure TModuleEntry.Assign(source: TModuleEntry);
begin
  Init(source.modType, source.mFullName, source.mShortName,
    source.mShortPath, source.mFullPath, source.modBookNames, source.modCats, source.mAuthor, source.mCoverPath, source.mHasStrong);
  mMatchInfo := source.mMatchInfo;
end;

constructor TModuleEntry.Create(
  amodType: TModuleType;
  aFullName, aShortName, aShortPath, aFullPath: string;
  aBookNames: string;
  modCats: TStrings;
  anAuthor: string;
  aCoverPath: string;
  hasStrong: boolean);
begin
  inherited Create;

  Init(amodType, aFullName, aShortName, aShortPath, aFullPath, aBookNames, modCats, anAuthor, aCoverPath, hasStrong);
end;

constructor TModuleEntry.Create(me: TModuleEntry);
begin
  Assign(me);
end;

function TModuleEntry.DefaultModCats(): string;
begin

  case modType of
    modtypeBible:
      result := Lang.SayDefault('HolySriptCat', 'Holy Scripture, Bible');
    modtypeBook:
      result := Lang.SayDefault('NoCat', 'No Category');
    modtypeComment:
      result := Lang.SayDefault('CommentCat', 'BibleCommentaries');

  end; // case
end;

destructor TModuleEntry.Destroy;
begin
  FreeMem(mRects);
  FreeAndNil(mCachedCoverLock);

  if Assigned(mCachedCover) then
    FreeAndNil(mCachedCover);

  mMatchInfo := nil;
  inherited;
end;

function TModuleEntry.getIniPath: string;
begin
  result := MainFileExists(TPath.Combine(mShortPath, C_ModuleIniName));
end;

constructor TModuleEntry.Create(
  amodType: TModuleType;
  aFullName, aShortName, aShortPath, aFullPath: string;
  aBookNames: string;
  modCats: string;
  anAuthor: string;
  aCoverPath: string;
  hasStrong: boolean);
begin
  Init(amodType, aFullName, aShortName, aShortPath, aFullPath, aBookNames, modCats, anAuthor, aCoverPath, hasStrong);
end;

procedure TModuleEntry.Init(
  amodType: TModuleType;
  aFullName, aShortName, aShortPath, aFullPath: string;
  aBookNames: string;
  amodCats: string;
  anAuthor: string;
  aCoverPath: string;
  hasStrong: boolean);
begin
  modType := amodType;
  mFullName := aFullName;
  mShortPath := aShortPath;
  mShortName := aShortName;
  mFullPath := aFullPath;
  mRects := nil;
  modBookNames := aBookNames;
  if Length(amodCats) <= 0 then
  begin
    modCats := DefaultModCats();
  end
  else
    modCats := amodCats;

  mCachedCover := nil;
  mAuthor := anAuthor;
  mCoverPath := aCoverPath;
  mCachedCoverLock := TCriticalSection.Create;
  mHasStrong := hasStrong;
end;

function TModuleEntry.Match(matchLst: TStringList; var mi: TMatchInfoArray; allMath: boolean = false): TModMatchTypes;
type
  TBQBookSet = set of byte;

var
  listIx, listCnt: integer;
  matchStrUp, strCatsUp, strNameUP, strBNamesUp: string;
  tagFullMatch, nameFullMatch, nameFound, tagFound, bookNameFound,
  partialMacthed, foundBookNameHits, searchBookNames, booksetInit: boolean;
  p, pf: PChar;
  curHits, allHits: TBQBookSet;
  pbs: ^TBQBookSet;
  fndIx, newfndIx: byte;
  book_cnt, arrSz: integer;
begin
  listCnt := matchLst.count - 1;
  result := [];
  if listCnt < 0 then
    exit;
  strNameUP := LowerCase(mFullName);
  strCatsUp := LowerCase(modCats);
  strBNamesUp := LowerCase(modBookNames);

  tagFullMatch := true;
  nameFullMatch := true;
  partialMacthed := true;
  allHits := [];
  // for newfndIx:=1 to 255 do include(allHits,newfndIx);
  searchBookNames := not(modType in [modtypeBible, modtypeComment]);
  booksetInit := true;
  for listIx := 0 to listCnt do
  begin
    curHits := [];
    matchStrUp := LowerCase(matchLst[listIx]);
    nameFound := (Pos(matchStrUp, strNameUP) > 0);
    if nameFound then
    begin
      if not allMath then
      begin
        Include(result, mmtName);
      end;
    end
    else
      nameFullMatch := false;
    // else if allMath then begin  result:=mmtNone; exit end;
    tagFound := Pos(matchStrUp, strCatsUp) > 0;
    if tagFound then
    begin
      if not allMath then
      begin
        Include(result, mmtCat);
        break;
      end;
    end
    else
    begin // not match cat
      tagFullMatch := false;
    end;

    p := PChar(Pointer(strBNamesUp));
    pf := p + Length(strBNamesUp);
    foundBookNameHits := false;
    if searchBookNames
    { or ((not tagFound)and (not nameFound))) } then
    begin

      repeat
        p := StrPosW(p, PChar(Pointer(matchStrUp)));
        bookNameFound := p <> nil;
        if bookNameFound then
        begin
          foundBookNameHits := true;
          newfndIx := StrTokenIx(strBNamesUp, p - PChar(Pointer(strBNamesUp)) + 1);
          if newfndIx > 0 then
            Include(curHits, newfndIx);

          inc(p, Length(matchStrUp));

          if not allMath then
          begin
            Include(result, mmtBookName);
          end;
        end

        until (p > pf) or (not bookNameFound);
        if allMath then
        begin
          // if foundBookNameHits then begin
          if foundBookNameHits then
          begin
            // if books found
            if booksetInit then
            begin
              // if it's the first book entry
              allHits := allHits + curHits;
              booksetInit := false;
            end
            else if not(tagFound or nameFound) then
            begin
              allHits := allHits * curHits;
            end;
          end
          else if not(tagFound or nameFound) then
            allHits := [];
          foundBookNameHits := allHits <> [];
        end
        else
          allHits := allHits + curHits;
      end; // if search books
      if allMath then
      begin
        if (not nameFound) and (not tagFound) and (not foundBookNameHits) then
        begin
          partialMacthed := false;
          break;
        end;
      end
    end; // for

    if allMath then
    begin

      if tagFullMatch then
        Include(result, mmtCat);
      if nameFullMatch then
        Include(result, mmtName);
      if allHits <> [] then
      begin
        Include(result, mmtBookName);
      end;

      if result = [] then
      begin
        if partialMacthed then
          result := [mmtPartial]
      end; // not found full match

    end; // if allmatch
    if mmtBookName in result then
    begin
      fndIx := 0;
      arrSz := Length(mi);
      if allMath then
        pbs := @allHits
      else
        pbs := @allHits;
      book_cnt := 0;
      repeat
        if fndIx in pbs^ then
        begin
          if (book_cnt >= arrSz) then
          begin

            inc(arrSz, arrSz + 1);
            SetLength(mi, arrSz);
          end;
          mi[book_cnt].ix := fndIx;
          mi[book_cnt].matchSt := 1;
          mi[book_cnt].name := C_BulletChar + #32 + BookNameByIx(fndIx);

          inc(book_cnt);
        end;
        inc(fndIx);
      until (fndIx = 0);
      SetLength(mi, book_cnt);
      if book_cnt <= 0 then
        Exclude(result, mmtBookName);
    end;

  end;

  function TModuleEntry.VisualSignature(): string;
  begin
    if Length(mShortName) > 0 then
      result := mShortName
    else
      result := mShortPath;
  end;

  function TModuleEntry.BibleBookPresent(ix: integer): boolean;
  var
    r: string;
  begin
    result := false;
    if not(modType in [modtypeBible, modtypeComment]) then
      exit;
    r := StrGetTokenByIx(modBookNames, ix);
    result := (r = '1');
  end;

  function TModuleEntry.BookNameByIx(ix: integer): string;
  begin
    if (ix <= 0) then
    begin
      result := '';
      exit;
    end;
    result := StrGetTokenByIx(modBookNames, ix);
  end;

  function TModuleEntry.GetCoverImage(width, height: integer): TPicture;
  var
    coverPath: string;
    origPicture: TPicture;
  begin
    Result := nil;

    if (mCoverPath = '') then
      Exit;

    coverPath := TPath.Combine(mShortPath, mCoverPath);
    if not FileExists(coverPath) then
      Exit;

    mCachedCoverLock.Acquire;
    try
      if Assigned(mCachedCover) and (width = mCachedWidth) and (height = mCachedHeight) then
      begin
        Result := mCachedCover;
        Exit;
      end;

      origPicture := TPicture.Create();
      try
        origPicture.LoadFromFile(coverPath);

        mCachedCover := StretchImage(origPicture, width, height);
        mCachedWidth := width;
        mCachedHeight := height;

        Result := mCachedCover;
      finally
        origPicture.Free;
      end;
    finally
      mCachedCoverLock.Release;
    end;

  end;

  procedure TModuleEntry.Init(
    amodType: TModuleType;
    aFullName, aShortName, aShortPath, aFullPath: string;
    aBookNames: string;
    modCatsLst: TStrings;
    anAuthor: string;
    aCoverPath: string;
    hasStrong: boolean);
  begin
    modType := amodType;
    mFullName := aFullName;
    mShortPath := aShortPath;
    mShortName := aShortName;
    mFullPath := aFullPath;
    modBookNames := aBookNames;
    mRects := nil;
    if modCatsLst.count <= 0 then
      modCats := DefaultModCats()
    else
      modCats := TokensToStr(modCatsLst, '|');
    mAuthor := anAuthor;
    mCoverPath := aCoverPath;
    mCachedCover := nil;
    mCachedCoverLock := TCriticalSection.Create;
    mHasStrong := hasStrong;
  end;

  { TCachedModules }

  procedure TCachedModules.Assign(source: TCachedModules);
  var
    I, cnt: integer;
  begin
    cnt := source.count - 1;
    Clear();
    for I := 0 to cnt do
      Add(TModuleEntry.Create(TModuleEntry(source.Items[I])));

    if Assigned(FOnAssignEvent) then
      FOnAssignEvent(Self);
  end;

  function __ModEntryCmp(Item1, Item2: TModuleEntry): integer;
  begin
    result := OmegaCompareTxt(Item1.mFullName, Item2.mFullName, -1, true);
  end;

  function TCachedModules.FindByName(const name: string; fromix: integer): integer;
  var
    cnt, I, newi, fin, r: integer;
  begin
    cnt := count;
    result := -1;
    if cnt <= 0 then
      exit;

    I := fromix + ((cnt - fromix) div 2);
    fin := cnt - 1;
    newi := I;
    repeat
      I := newi;
      r := OmegaCompareTxt(name, TModuleEntry(Items[I]).mFullName);
      if r = 0 then
        break;
      if r < 0 then
        fin := I
      else
        fromix := I + 1;
      newi := (fromix + fin) div 2;
    until I = newi;
    if r <> 0 then
    begin
      result := -1;
      exit;
    end;
    dec(I);
    while (I >= fromix) and
      (OmegaCompareTxt(name, TModuleEntry(Items[I]).mFullName) = 0) do
      dec(I);
    inc(I);
    result := I;
  end;

  function TCachedModules.GetArchivedCount: integer;
  var
    I, c: integer;
  begin
    c := count - 1;
    result := 0;
    for I := c downto 0 do
    begin
      if Items[I].mFullPath[1] = '?' then
        inc(result);
    end;
  end;

  function TCachedModules.GetItem(Index: integer): TModuleEntry;
  begin
    result := TModuleEntry(inherited GetItem(index));
  end;

  function TCachedModules.GetModTypedAsCount(modType: TModuleType): integer;
  var
    I, c: integer;
  begin
    c := count - 1;
    result := 0;
    for I := c downto 0 do
    begin
      if Items[I].modType = modType then
        inc(result);
    end
  end;

  function TCachedModules.IndexOf(const name: string; fromix: integer): integer;
  var
    cnt, I: integer;
  begin
    cnt := self.count - 1;
    result := -1;
    if cnt < 0 then
      exit;
    for I := 0 to cnt do
    begin
      result := OmegaCompareTxt(name, TModuleEntry(Items[I]).mFullName, -1, true);
      if result = 0 then
      begin
        result := I;
        exit
      end;
    end;

    result := -1;
  end;

  function TCachedModules.ModTypedAsFirst(modType: TModuleType): TModuleEntry;
  var
    I, c, f: integer;
  begin
    mModTypedAsPointers[modType] := -1;
    f := -1;
    c := count - 1;
    result := nil;
    for I := 0 to c do
    begin
      if Items[I].modType = modType then
      begin
        f := I;
        break;
      end;
    end;
    if f >= 0 then
    begin
      mModTypedAsPointers[modType] := f + 1;
      result := Items[f];
    end;

  end;

  function TCachedModules.ModTypedAsNext(modType: TModuleType): TModuleEntry;
  var
    I, c, f: integer;
  begin
    c := count - 1;
    result := nil;
    f := -1;
    I := mModTypedAsPointers[modType];
    if I <= c then
      repeat
        if Items[I].modType = modType then
        begin
          f := I;
          break;
        end;
        inc(I);
      until I > c;
    if f >= 0 then
    begin
      result := Items[f];
    end;
    mModTypedAsPointers[modType] := I + 1;

  end;

  function TCachedModules.FindByFolder(const name: string): integer;
  var
    cnt, I: integer;
  begin
    cnt := self.count - 1;
    result := -1;
    if cnt < 0 then
      exit;
    for I := 0 to cnt do
    begin
      result := CompareText(name, TModuleEntry(Items[I]).mShortPath);
      if result = 0 then
      begin
        result := I;
        exit
      end;
    end;
    result := -1;
  end;

  function TCachedModules.FindByFullPath(const wsFullPath: string): integer;
  var
    cnt, I: integer;
  begin
    cnt := self.count - 1;
    result := -1;
    if cnt < 0 then
      exit;
    for I := 0 to cnt do
    begin
      result := CompareText(wsFullPath, Items[I].mFullPath);
      if result = 0 then
      begin
        result := I;
        exit
      end;
    end;
    result := -1;

  end;

  procedure TCachedModules._Sort;
  begin
    self.Sort(@__ModEntryCmp);
    mSorted := true;
  end;

  function TCachedModules.ResolveModuleByNames(const modName, modShortName: string): TModuleEntry;
  var
    foundIx, c: integer;
  begin
    result := nil;
    try
      foundIx := IndexOf(modName);
      if (foundIx < 0) then
        exit;
      result := TModuleEntry(Items[foundIx]);
      if result.mShortName = modShortName then
        exit;
      c := count;

      repeat
        result := TModuleEntry(Items[foundIx]);
        inc(foundIx);
      until (foundIx > c) or (OmegaCompareTxt(result.mFullName, modName, -1, true) <> 0) or (result.mShortName <> modShortName); // until

      result := TModuleEntry(Items[foundIx - 1]);
    except
      on e: Exception do
      begin
        g_ExceptionContext.Add
          (Format
          ('TCachedModules.ResolveModuleByNames: modName=%s | modShortName=%s ',
          [modName, modShortName]));
      end;
    end;
  end;

  procedure TCachedModules.SetItem(Index: integer; AObject: TModuleEntry);
  begin
    inherited SetItem(index, AObject);
  end;

  { TBQStringList }

  function TBQStringList.CompareStrings(const S1, S2: string): integer;
  begin
    result := OmegaCompareTxt(S1, S2);
  end;

  function TBQStringList.LocateLastStartedWith(
    const subString: string;
    startFromIx: integer = 0;
    strict: boolean = false): integer;
  var
    L, fin, I, newi, cnt, bestMatchLen, matchLen, bestMatchLenIx, startIx,
      lenDifferenceMin, lenDifference: integer;
  begin
    cnt := count;
    L := Length(subString);
    I := startFromIx + ((cnt - startFromIx) div 2);

    if (cnt = 0) or (startFromIx >= cnt) then
    begin
      result := -1;
      exit;
    end;

    newi := I;
    fin := cnt - 1;
    startIx := startFromIx;
    repeat
      I := newi;
      result := OmegaCompareTxt(subString, Strings[I], L, true);
      if result = 0 then
        break;
      if result < 0 then
        fin := I
      else
        startIx := I + 1;
      newi := (startIx + fin) div 2;
    until I = newi;
    if (result = 0) then
    begin
      result := I;
      exit;
    end;
    if (strict) then
    begin
      result := -1;
      exit;
    end;

    fin := cnt - 1;
    startIx := startFromIx;

    bestMatchLen := -1;
    bestMatchLenIx := -1;
    lenDifferenceMin := $FFFF;
    repeat
      I := newi;
      result := OmegaCompareTxt(subString, Strings[I], L, false);
      if result = 0 then
      begin
        matchLen := Length(Strings[I]);
        lenDifference := matchLen - L;
        if lenDifference < 0 then
          lenDifference := -lenDifference;
        if ((matchLen > bestMatchLen) and
          ((matchLen <= L) or (lenDifference <= lenDifferenceMin))) or
          ((matchLen < bestMatchLen) and ((bestMatchLen > L) or
          (lenDifference < lenDifferenceMin))) or (bestMatchLen < 0) then
        begin
          bestMatchLen := matchLen;
          bestMatchLenIx := I;
          lenDifferenceMin := lenDifference;
        end;
        result := L - matchLen;
      end;
      if result < 0 then
        fin := I
      else
        startIx := I + 1;
      newi := (startIx + fin) div 2;
    until I = newi;
    if bestMatchLen < 0 then
      result := -1
    else
      result := bestMatchLenIx;
  end;

  function StrMathTokens(const Str: string; tkns: TStrings;
    fullMatch: boolean): boolean;
  var
    I, c: integer;
    s: string;
    fnd: boolean;
  begin
    c := tkns.count - 1;
    if c < 0 then
    begin
      result := false;
      exit
    end;
    s := LowerCase(Str);
    for I := 0 to c do
    begin
      fnd := (Pos(LowerCase(tkns[I]), s) > 0);
      if fnd xor fullMatch then
      begin
        result := fnd;
        exit
      end
    end; // for
    result := fullMatch;
  end;

  function GetTokenFromString(pStr: PChar; delim: Char; out len: integer): PChar;
  var
    currentCmpCh: Char;
  label endfail;
  begin

    currentCmpCh := pStr^;
    if currentCmpCh = #0 then
      goto endfail;
    // skip to first symb
    if currentCmpCh = delim then
      repeat
        inc(pStr);
        currentCmpCh := pStr^;
        if (currentCmpCh = #0) then
          goto endfail;
      until (currentCmpCh <> delim);
    result := pStr;
    inc(pStr);
    currentCmpCh := pStr^;
    // inc to delim or end
    while (currentCmpCh <> #0) and (currentCmpCh <> delim) do
    begin
      inc(pStr);
      currentCmpCh := pStr^;
    end;
    len := pStr - result;

    exit;
    // here first token is found

  endfail:
    len := 0;
    result := nil;
  end;

  function PeekToken(pC: PChar; delim: Char): string;
  var
    saveChar: Char;
    L: integer;
  label fail;
  begin

    if pC = nil then
      goto fail;
    pC := GetTokenFromString(pC, delim, L);
    if pC <> nil then
    begin
      saveChar := (pC + L)^;
      (pC + L)^ := #0;
      result := pC;
      (pC + L)^ := saveChar;
      exit
    end;
  fail:
    result := '';
  end;

  function CompareTokenStrings(const tokensCompare: string; const tokenCompareAgainst: string; delim: Char): integer;
  var
    pTokenCmp, pTokenCmpAg: PChar;
    cmpTokeLen, cmpTokeLenAdj, cmpAgTokeLen, cmpAgTokeLenAdj, matchCnt,
      compareCnt: integer;
    equal: boolean;

  begin
    pTokenCmp := Pointer(tokensCompare);
    matchCnt := 0;
    compareCnt := 0;
    pTokenCmp := GetTokenFromString(pTokenCmp, delim, cmpTokeLen);
    while (pTokenCmp <> nil) do
    begin
      cmpTokeLenAdj := cmpTokeLen;
      if (pTokenCmp + cmpTokeLen - 1)^ = '.' then
        dec(cmpTokeLenAdj);
      pTokenCmpAg := Pointer(tokenCompareAgainst);
      pTokenCmpAg := GetTokenFromString(pTokenCmpAg, delim, cmpAgTokeLen);
      equal := false;
      while (pTokenCmpAg <> nil) and (not equal) do
      begin
        cmpAgTokeLenAdj := cmpAgTokeLen;
        if (pTokenCmpAg + cmpAgTokeLen - 1)^ = '.' then
          dec(cmpAgTokeLenAdj);
        equal := CompareStringW(LANG_INVARIANT, NORM_IGNORECASE, pTokenCmp,
          cmpTokeLenAdj, pTokenCmpAg, cmpAgTokeLenAdj) = CSTR_EQUAL;
        pTokenCmpAg := GetTokenFromString(pTokenCmpAg + cmpAgTokeLen, delim,
          cmpAgTokeLen);
      end;
      inc(matchCnt, Ord(equal));
      inc(compareCnt);
      pTokenCmp := GetTokenFromString(pTokenCmp + cmpTokeLen, delim,
        cmpTokeLen);
    end;
    if compareCnt = 0 then
      result := -1
    else
      result := matchCnt * 100 div compareCnt;

  end;

  function MainFileExists(s: string): string;
  var
    filePath, fullPath, modfolder: string;
  begin
    result := '';
    // compressed modules take precedence over other modules
    filePath := ExtractFilePath(s);
    modfolder := Copy(filePath, 1, Length(filePath) - 1);
    fullPath := TPath.Combine(TAppDirectories.Root, modfolder + '.bqb');

    if FileExists(fullPath) then
      result := '?' + fullPath + '??' + C_ModuleIniName
    else if FileExists(TPath.Combine(TAppDirectories.Root, s)) then
      result := TPath.Combine(TAppDirectories.Root, s)
    else if FileExists(TPath.Combine(AppConfig.SecondPath , s)) then
      result := TPath.Combine(AppConfig.SecondPath, s)
  end;

  function GetCallerEIP(): Pointer; assembler;
  asm
    mov eax,dword ptr [esp]
  end;

  function GetCallerEbP(): Pointer; assembler;
  asm
    mov eax, ebp
  end;

{$ENDREGION}
  { TbqTextFileWriter }

  function TbqTextFileWriter.Close: HRESULT;
  begin
    if CloseHandle(mHandle) then
      result := S_FALSE
    else
      result := S_OK;
    mHandle := 0;
  end;

  constructor TbqTextFileWriter.Create(const aFileName: string);
  var
    writePos: integer;
  begin
    mHandle := CreateFile(Pointer(aFileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if mHandle = INVALID_HANDLE_VALUE then
      RaiseLastOSError();
    writePos := FileSeek(mHandle, 0, soFromEnd);
    if writePos = 0 then
      FileWrite(mHandle, BOM_UTF16_LSB, 2);
  end;

  destructor TbqTextFileWriter.Destroy;
  begin
    Close();
    inherited;
  end;

  function TbqTextFileWriter.WriteLine(const line: string): HRESULT;
  var
    bytesWritten: Cardinal;
    boolWrite: BOOL;
    leng: integer;
  begin
    leng := Length(line) * 2;
    if leng > 0 then
    begin
      boolWrite := WriteFile(mHandle, Pointer(line)^, leng, bytesWritten, nil)
    end
    else
      boolWrite := false;

    WriteFile(mHandle, C_crlf, 4, bytesWritten, nil);
    if boolWrite then
      result := S_OK
    else
      result := S_FALSE;
  end;

initialization

// Enable raw mode (default mode uses stack frames which aren't always generated by the compiler)
Include(JclStackTrackingOptions, stRawMode);
Include(JclStackTrackingOptions, stStack);

// Disable stack tracking in dynamically loaded modules (it makes stack tracking code a bit faster)
// Include(JclStackTrackingOptions, stStaticModuleList);
// Initialize Exception tracking
g_ExceptionContext := TbqExceptionContext.Create();
JclStartExceptionTracking;
G_InstalledFonts := TStringList.Create;
G_InstalledFonts.Sorted := true;
G_InstalledFonts.Duplicates := dupIgnore;
load_proc();

finalization

// S_SevenZip.Free();
JclStopExceptionTracking();
FreeAndNil(g_ExceptionContext);

end.
