unit BibleQuoteUtils;

interface
uses SevenZipHelper,SevenZipVCL, MultiLanguage,
  Contnrs, JCLStrings, Windows, SysUtils, Classes, JCLDebug,
  COperatingSystemInfo;
type
  TBibleModuleSecurity = class
    path, folder: WideString;
    pwd: WideString;
  end;

  TPasswordPolicy = class
  protected
    mPasswordList: TWideStrings;
    mPath: WideString;
    mUserHash: int64;
    function GetUserHash(): int64;
    function XorPassword(aPwd: string; produceHex: boolean = true): string;
  public
    function LoadFromFile(const filename: WideString): boolean;
    procedure SaveToFile(const filename: WideString);
    function GetPassword(aSender: TSevenZip; out aPassword: WideString):
      boolean;
    procedure InvalidatePassword(const aFile: WideString);
    constructor Create(wsString: WideString);
    destructor Destroy(); override;
  end;

  TBQException = class(Exception)
    mErrCode: Cardinal;
    mWideMsg: WideString;
    constructor CreateFmt(const Msg: string; const Args: array of const);
  end;
  TbqHLVerseOption=( hlFalse, hlTrue, hlDefault);
  TBQPasswordException = class(TBQException)
    mArchive: WideString;
    mWrongPassword: WideString;
    constructor CreateFmt(const password, module: WideString; const Msg: string;
      const Args: array of const);
  end;
  TBQInstalledFontInfo = class
    mPath: WideString;
    mFileNeedsCleanUp: boolean;
    mHandle: HFont;
    constructor Create(const aPath: WideString; afileNeedsCleanUp: boolean;
      aHandle: HFont);

  end;

  TModuleType = (modtypeBible, modtypeBook, modtypeComment, modtypeTag, modtypeBookHighlighted);
  TModMatchType = (mmtName, mmtBookName, mmtCat, mmtPartial);
  TModMatchTypes = set of TModMatchType;

  TRectArray = array[0..9] of TRect;
  PRectArray = ^TRectArray;

  TMatchInfo=record
      ix:integer;
      matchSt:integer;
      name:WideString;
      rct:TRect;
  end;
  TMatchInfoArray=array of TMatchInfo;
//  TBooksRange=1..77;
//  TbitBooks=packed array[TBooksRange] of boolean;
   TbqItemStyle=(bqisExpanded);
   TbqItemStyles=set of TbqItemStyle ;
  TModuleEntry = class
    wsFullName, wsShortName, wsShortPath, wsFullPath: Widestring;
    modType: TModuleType;
    modCats: WideString;
    modBookNames: UTF8String;

    mRects: PRectArray;
    mCatsCnt: integer;
    mNode: Pointer;
    mStyle:TbqItemStyles;
    mMatchInfo:TMatchInfoArray;
  //  mBookBits:TbitBooks;
    constructor Create(amodType: TModuleType; awsFullName, awsShortName,
      awsShortPath, awsFullPath: Widestring; awsBookNames: UTF8String;
       modCats:    TWideStrings); overload;
    constructor Create(amodType: TModuleType; awsFullName, awsShortName,
      awsShortPath, awsFullPath: Widestring; awsBookNames: UTF8String;
       modCats:         WideString); overload;
    constructor Create(me: TModuleEntry); overload;
    destructor Destroy; override;
    procedure Init(amodType: TModuleType; awsFullName, awsShortName,
      awsShortPath, awsFullPath: Widestring; awsBookNames: UTF8String;
        modCatsLst: TWideStrings); overload;
    procedure Init(amodType: TModuleType; awsFullName, awsShortName,
      awsShortPath, awsFullPath: Widestring; awsBookNames: UTF8String;
        amodCats:  WideString); overload;
    procedure Assign(source: TModuleEntry);
    function Match(matchLst: TWideStringList;var  mi:TMatchInfoArray; allMath: boolean
      = false): TModMatchTypes;
     function BookNameByIx(ix:integer):WideString;
     function VisualSignature():WideString;
     function BibleBookPresent(ix:integer):boolean;

     function getIniPath():WideString;
  protected


    function DefaultModCats(): WideString;
  end;
  TCachedModules = class(TObjectList)
  protected
    mSorted: boolean;
    mModTypedAsPointers:array[TModuleType] of Integer;
    function GetItem(Index: Integer): TModuleEntry;
    procedure SetItem(Index: Integer; AObject: TModuleEntry);
    function GetArchivedCount():integer;
  public
    procedure Assign(source: TCachedModules);
    function FindByName(const name: WideString; fromix: integer = 0): integer;
    function ResolveModuleByNames(const modName,modShortName:WideString):TModuleEntry;
    function IndexOf(const name: WideString; fromix: integer = 0): integer;overload;
    function FindByFolder(const name:WideString):integer;
    function FindByFullPath(const wsFullPath:WideString):integer;
    function GetModTypedAsCount(modType:TModuleType):integer;
    function ModTypedAsFirst(modType:TModuleType):TModuleEntry;
    function ModTypedAsNext(modType:TModuleType):TModuleEntry;
    procedure _Sort();


    property Items[Index: Integer]: TModuleEntry read GetItem write SetItem; default;

    property ArchivedModulesCount:integer read GetArchivedCount;
    property ModTypedAsCount[modType:TModuleType]:integer read GetModTypedAsCount;

  end;

  TbqOldObjectList=class(TList)
   procedure Notify(Ptr: Pointer; Action: TListNotification); virtual;
  end;
  TBQStringList = class(TStringList)
  protected
    function CompareStrings(const S1, S2: string): Integer; override;
  public
    function LocateLastStartedWith(const subString: string; startFromIx:
      integer = 0; strict: boolean = false): integer;
  end;
  TbqExceptionContext=class(TWideStringList)
  end;
  TbqTextFileWriter=class(TObject)
  protected
  mHandle:THandle;
  public
    constructor Create(const aFileName:WideString);
    function WriteUnicodeLine(const line:WideString):HRESULT;
    function Close():HRESULT;
    destructor destroy();override;
  end;

var g_ExceptionContext:TbqExceptionContext;


const
  Crc32Bytes = 4;
  Crc32Start: Cardinal = $FFFFFFFF;
  Crc32Bits = 32;
const
  Crc32Table: array[0..255] of Cardinal = (
    $00000000, $04C11DB7, $09823B6E, $0D4326D9, $130476DC, $17C56B6B, $1A864DB2,
      $1E475005,
    $2608EDB8, $22C9F00F, $2F8AD6D6, $2B4BCB61, $350C9B64, $31CD86D3, $3C8EA00A,
      $384FBDBD,
    $4C11DB70, $48D0C6C7, $4593E01E, $4152FDA9, $5F15ADAC, $5BD4B01B, $569796C2,
      $52568B75,
    $6A1936C8, $6ED82B7F, $639B0DA6, $675A1011, $791D4014, $7DDC5DA3, $709F7B7A,
      $745E66CD,
    $9823B6E0, $9CE2AB57, $91A18D8E, $95609039, $8B27C03C, $8FE6DD8B, $82A5FB52,
      $8664E6E5,
    $BE2B5B58, $BAEA46EF, $B7A96036, $B3687D81, $AD2F2D84, $A9EE3033, $A4AD16EA,
      $A06C0B5D,
    $D4326D90, $D0F37027, $DDB056FE, $D9714B49, $C7361B4C, $C3F706FB, $CEB42022,
      $CA753D95,
    $F23A8028, $F6FB9D9F, $FBB8BB46, $FF79A6F1, $E13EF6F4, $E5FFEB43, $E8BCCD9A,
      $EC7DD02D,
    $34867077, $30476DC0, $3D044B19, $39C556AE, $278206AB, $23431B1C, $2E003DC5,
      $2AC12072,
    $128E9DCF, $164F8078, $1B0CA6A1, $1FCDBB16, $018AEB13, $054BF6A4, $0808D07D,
      $0CC9CDCA,
    $7897AB07, $7C56B6B0, $71159069, $75D48DDE, $6B93DDDB, $6F52C06C, $6211E6B5,
      $66D0FB02,
    $5E9F46BF, $5A5E5B08, $571D7DD1, $53DC6066, $4D9B3063, $495A2DD4, $44190B0D,
      $40D816BA,
    $ACA5C697, $A864DB20, $A527FDF9, $A1E6E04E, $BFA1B04B, $BB60ADFC, $B6238B25,
      $B2E29692,
    $8AAD2B2F, $8E6C3698, $832F1041, $87EE0DF6, $99A95DF3, $9D684044, $902B669D,
      $94EA7B2A,
    $E0B41DE7, $E4750050, $E9362689, $EDF73B3E, $F3B06B3B, $F771768C, $FA325055,
      $FEF34DE2,
    $C6BCF05F, $C27DEDE8, $CF3ECB31, $CBFFD686, $D5B88683, $D1799B34, $DC3ABDED,
      $D8FBA05A,
    $690CE0EE, $6DCDFD59, $608EDB80, $644FC637, $7A089632, $7EC98B85, $738AAD5C,
      $774BB0EB,
    $4F040D56, $4BC510E1, $46863638, $42472B8F, $5C007B8A, $58C1663D, $558240E4,
      $51435D53,
    $251D3B9E, $21DC2629, $2C9F00F0, $285E1D47, $36194D42, $32D850F5, $3F9B762C,
      $3B5A6B9B,
    $0315D626, $07D4CB91, $0A97ED48, $0E56F0FF, $1011A0FA, $14D0BD4D, $19939B94,
      $1D528623,
    $F12F560E, $F5EE4BB9, $F8AD6D60, $FC6C70D7, $E22B20D2, $E6EA3D65, $EBA91BBC,
      $EF68060B,
    $D727BBB6, $D3E6A601, $DEA580D8, $DA649D6F, $C423CD6A, $C0E2D0DD, $CDA1F604,
      $C960EBB3,
    $BD3E8D7E, $B9FF90C9, $B4BCB610, $B07DABA7, $AE3AFBA2, $AAFBE615, $A7B8C0CC,
      $A379DD7B,
    $9B3660C6, $9FF77D71, $92B45BA8, $9675461F, $8832161A, $8CF30BAD, $81B02D74,
      $857130C3,
    $5D8A9099, $594B8D2E, $5408ABF7, $50C9B640, $4E8EE645, $4A4FFBF2, $470CDD2B,
      $43CDC09C,
    $7B827D21, $7F436096, $7200464F, $76C15BF8, $68860BFD, $6C47164A, $61043093,
      $65C52D24,
    $119B4BE9, $155A565E, $18197087, $1CD86D30, $029F3D35, $065E2082, $0B1D065B,
      $0FDC1BEC,
    $3793A651, $3352BBE6, $3E119D3F, $3AD08088, $2497D08D, $2056CD3A, $2D15EBE3,
      $29D4F654,
    $C5A92679, $C1683BCE, $CC2B1D17, $C8EA00A0, $D6AD50A5, $D26C4D12, $DF2F6BCB,
      $DBEE767C,
    $E3A1CBC1, $E760D676, $EA23F0AF, $EEE2ED18, $F0A5BD1D, $F464A0AA, $F9278673,
      $FDE69BC4,
    $89B8FD09, $8D79E0BE, $803AC667, $84FBDBD0, $9ABC8BD5, $9E7D9662, $933EB0BB,
      $97FFAD0C,
    $AFB010B1, $AB710D06, $A6322BDF, $A2F33668, $BCB4666D, $B8757BDA, $B5365D03,
      $B1F740B4
    );
resourcestring
  bqPageStyle = '<STYLE> '#13#10 +
    '<!--'#13#10 +
    'p.BQNormal{'#13#10 +
    'margin:0;'#13#10 +
    'margin-bottom : 0;'#13#10 +
    'margin-left : 0.8ex;'#13#10 +
    'margin-right : 0.8ex;'#13#10 +
  //  'text-align:%s;'#13#10 +
  'font-size:x-large;'#13#10 +
//    '%s'#13#10 +
  'text-indent:40px;'#13#10 +
    '}'#13#10 +

    'A.OmegaVerseNumber {'#13#10 +
//    color: brown;'#13#10 +
    'font-family:Helvetica;'#13#10 +
    '}'#13#10 +
//use    'A.OmegaStrongNumber {color: green}'#13#10 +
//use    'A.BQNote {color: green}'#13#10 +
//    'sup{font-size:70%%;}'#13#10+
//    'A:visited {color: brown}'#13#10 +
  '-->'#13#10 +
  'A.bqResolvedLink {'#13#10 +
//  color: Sienna;'#13#10 +
    'font-family:''Times New Roman'';'#13#10 +
    'font-style:italic;'#13#10 +
    'font-weight:lighter;'#13#10 +
    '}'#13#10 +
//use    'A.OmegaStrongNumber {color: green}'#13#10 +
//    'sup{font-size:70%%;}'#13#10+
//    'A:visited {color: brown}'#13#10 +
  '-->'#13#10 +
    '</STYLE>';

function GetArchiveFromSpecial(const aSpecial: string): string;
  overload;
function GetArchiveFromSpecial(const aSpecial: string; out fileName:
  string): string; overload;
function GetCachedModulesListDir(): string;
function FileExistsEx(aPath: string): integer;
function ArchiveFileSize(wsPath: string): integer;
function SpecialIO(const wsFileName: string; wsStrings: TStrings; obf:
  Int64; read: boolean = true): boolean;
function FontExists(const wsFontName: string): boolean;
function FontFromCharset(aHDC: HDC; charset: integer; wsDesiredFont: string =
  ''): string;
function GetCRC32(pData: PByteArray; count: Integer; Crc: Cardinal = 0):
  Cardinal;
function ExtractModuleName(aModuleSignature: string): string;
function StrPosW(const Str, SubStr: PChar): PChar;
function ExctractName(const wsFile: string): string;
function IsDown(key: integer): boolean;
function FileRemoveExtension(const Path: string): string;
procedure CopyHTMLToClipBoard(const str: string; const htmlStr: AnsiString =
  '');
function OmegaCompareTxt(const str1, str2: string; len: integer = -1;
  strict: boolean = false): integer;
procedure InsertDefaultFontInfo(var html: string; fontName: string; fontSz:
  integer);
function TokensToStr(Lst: TStrings; delim: string; addlastDelim: boolean
  = true): string;
function StrMathTokens(const str: string; tkns: TStrings; fullMatch:
  boolean): boolean;
function CompareTokenStrings(const tokensCompare:string; const tokenCompareAgainst:string; delim:Char):integer;
function StrGetTokenByIx(tknString:AnsiString;tokenIx:integer):AnsiString;
function GetTokenFromString(pStr:Pchar;delim:Char; out len:integer):PChar;
function PeekToken(pC:PChar; delim:Char):string;

function MainFileExists(s: string): string;
function ExePath():string;
function OSinfo():TOperatingSystemInfo;
function WinInfoString():string;
function GetCallerEIP():Pointer;
function GetCallerEbP():Pointer;
procedure cleanUpInstalledFonts();
function CreateAndGetConfigFolder: string;
type
  PfnAddFontMemResourceEx = function(p1: Pointer; p2: DWORD; p3: PDesignVector;
    p4: LPDWORD): THandle; stdcall;
type
  PfnRemoveFontMemResourceEx = function(p1: THandle): BOOL; stdcall;
var
  G_AddFontMemResourceEx: PfnAddFontMemResourceEx;
  G_RemoveFontMemResourceEx: PfnRemoveFontMemResourceEx;
var
  G_InstalledFonts: TWideStringList;
  Lang: TMultiLanguage;
  G_DebugEx: integer;
  G_NoCategoryStr: WideString = '��� ���������';
  MainCfgIni: TMultiLanguage;
  G_SecondPath:WideString;
implementation
uses JclSysInfo, MainFrm, Controls, Forms, Clipbrd,StrUtils,BibleQuoteConfig, WCharWindows ,string_procs,JclBase;
var __exe__path:WideString;

function OmegaCompareTxt(const str1, str2: string; len: integer = -1;
  strict: boolean = false): integer;
var
  str1len, str2len, minLen: integer;
  ptr: PCHAR;
  ch: char;
begin

  str1len := length(str1); str2len := Length(str2);
  if str1len > str2len then minLen := str2len else minLen := str1len;
  if len > minLen then len := minlen;

  result := CompareStringW($0007f, NORM_IGNORECASE,
    PWIDECHAR(Pointer(str1)), len,
    PWIDECHAR(Pointer(str2)), len) - 2;
  if (result = 0) and strict then result := str1len - str2len;
end;

function GetArchiveFromSpecial(const aSpecial: string): string;
  overload;
var
  pz: Integer;
begin
//������ ���� rststrong.bqb??bibleqt.ini � rststrong.bqb
  pz := Pos('??', aSpecial);
  if pz <= 0 then result := EmptyWideStr
  else
    result := Copy(aSpecial, 1, pz - 1);
end;

function FileRemoveExtension(const Path: string): string;
var
  I: Integer;
begin

  I := LastDelimiter(':.\', Path);
  if (I > 0) and (Path[I] = '.') then
    Result := Copy(Path, 1, I - 1)
  else
    Result := Path;
end;

function GetArchiveFromSpecial(const aSpecial: string; out fileName:
  string): string; overload;
var
  pz: Integer;
  correct: integer;
begin
  //������ ���� rststrong.bqb??bibleqt.ini � rststrong.bqb � bibleqt.ini
  pz := Pos('??', aSpecial);
  if pz <= 0 then result := EmptyWideStr
  else begin
    correct := Ord(aSpecial[1] = '?') + 1;
    result := Copy(aSpecial, correct, pz - correct);
    fileName := Copy(aSpecial, pz + 2, $FFFFFF);
  end; //else
end; //fn

function TokensToStr(Lst: TStrings; delim: string; addlastDelim: boolean
  = true): string;
var
  c, i: integer;
begin
  result := '';
  c := Lst.Count - 1;
  if c < 0 then exit;
  result := lst[0];
  for i := 1 to c do result := result + delim + lst[i];
  if (c >= 0) and addlastDelim then result := result + delim;
end;



function StrTokenIx(const tknString:WideString; hitPos:integer):integer;
var tknCnt, sl, si:integer;
begin
sl:=Length(tknString);
si:=1;result:=1;
repeat
if hitPos<=si then break;
if tknString[si]='|' then inc(result);
inc(si);
until si>sl;
if si>=sl then result:=0;
end;

function StrGetTokenByIx(tknString:AnsiString;tokenIx:integer):AnsiString;
var p, p2:integer;
begin
p:=1;
dec(TokenIx);
if TokenIx>0 then
repeat
 p:=PosEx('|', tknString, p);
 if p>0 then Inc(p);
 dec(tokenIx);
until (tokenIx<=0) or (p=0);

if (p=0) then begin result:=''; exit end;
p2:=PosEx('|', tknString, p);
if p2=0 then p2:=$FFF;
Result:=Copy(tknString, p, p2-p);
end;


var
  __cachedModulesListFolder: string;

function GetCachedModulesListDir(): string;
begin
  if length(__cachedModulesListFolder) <= 0 then begin

    __cachedModulesListFolder := CreateAndGetConfigFolder();
    __cachedModulesListFolder := ExtractFilePath(
      Copy(__cachedModulesListFolder, 1, length(__cachedModulesListFolder) -
        1));
  end;
  result := __cachedModulesListFolder;
end;

function ArchiveFileSize(wsPath: string): integer;
var
  wsArchive, wsFile: string;
begin
  Result := -1;
  try
    wsArchive := GetArchiveFromSpecial(wsPath, wsFile);
    getSevenZ().SZFileName := wsArchive;
    if getSevenZ().GetIndexByFilename(wsFile, @Result) < 0 then Result := -1;
  except
  on e:exception do begin
  g_ExceptionContext.Add('BibleQuoteUtils.ArchiveFileSize.wsPath'+ wsPath);
  end;
  end;

end;

function FileExistsEx(aPath: string): integer;
var
  wsArchive, wsFile: string;
begin
  result := -1;
  if length(aPath) < 1 then exit;
  if aPath[1] <> '?' then begin
    result := ord(FileExists(aPath)) - 1; exit; end;
  wsArchive := GetArchiveFromSpecial(aPath, wsFile);
  if (length(wsArchive) <= 0) or (length(wsFile) < 0) then exit;
  try
    getSevenZ().SZFileName := wsArchive;
    result := getSevenZ().GetIndexByFilename(wsFile);
  except
  g_ExceptionContext.Add('FileExistsEx.aPath='+aPath);
  raise;
  end;

end;

function SpecialIO(const wsFileName: string; wsStrings: TStrings; obf:
  Int64; read: boolean = true): boolean;
var
  fileHandle: THandle;
  fileSz, readed: Cardinal;
  crcExpected, crcCalculated: Cardinal;
//    rslt:LongBool;
  buf: PChar;
  ws: string;

  procedure _EncodeDecode(); //������� 64bit xor ����������
  var
    i, count: Cardinal;
    pc: PCardinal;
    f, s: Cardinal;
  begin
    count := (fileSz shr 3) - 1;
    f := Cardinal(obf);
    s := PCardinal(pchar(@obf) + 4)^;
    pc := PCardinal(PChar(buf)); //���� ���� �� ���������
    for i := 0 to count do begin
      pc := PCardinal(PChar(buf) + i * 8);
      pc^ := pc^ xor f;
      PCardinal(pchar(pc) + 4)^ := PCardinal(pchar(pc) + 4)^ xor s;
    end;
    if (fileSz - count * 8) >= 4 then begin
      inc(pc); pc^ := pc^ xor f; end;

  end;

begin //
  if read then begin
    fileHandle := CreateFileW(PWideChar(Pointer(wsFileName)), GENERIC_READ, 0,
      nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if fileHandle = INVALID_HANDLE_VALUE then begin
      result := false; exit; end;
    fileSz := GetFileSize(fileHandle, nil);
    if fileSz = INVALID_FILE_SIZE then begin
      result := false; exit; end;
    dec(fileSz, 4);
    GetMem(buf, fileSz);
    try
      result := ReadFile(fileHandle, crcExpected, 4, readed, nil);
      if (not result) or (readed <> 4) then exit;
      result := ReadFile(fileHandle, buf^, fileSz, readed, nil);
      if (result) then begin
        _EncodeDecode();
        crcCalculated := GetCRC32(PByteArray(buf), fileSz);
        if crcCalculated <> crcExpected then begin

          result := false; exit; end;
        wsStrings.SetText(buf);

      end;
    finally (*����� �� ���� ������*)
      CloseHandle(fileHandle);
      FreeMem(buf); end;
  end
  else begin //������
    fileHandle := CreateFileW(PWideChar(Pointer(wsFileName)),
      GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if fileHandle = INVALID_HANDLE_VALUE then begin
      result := false; exit; end;
    try
      ws := wsStrings.Text;
      fileSz := Length(ws) * 2;
      buf := Pointer(PWideChar(ws));
      crcCalculated := GetCRC32(PByteArray(buf), fileSz);
      _EncodeDecode();
      result := WriteFile(fileHandle, crcCalculated, 4, readed, nil);
      if (not result) or (readed <> 4) then exit;
      result := WriteFile(fileHandle, buf^, fileSz, readed, nil);
    finally
      CloseHandle(fileHandle);
    end;
  end;
end;

function GetCRC32(pData: PByteArray; count: Integer; Crc: Cardinal = 0):
  Cardinal;
var
  I: Integer;
begin
  Result := Crc32Start;
  Dec(count);
  for I := 0 to count do begin
    // a 32 bit value shr 24 is a Byte, explictit type conversion to Byte adds an ASM instruction
    Result := Crc32Table[Result shr (CRC32Bits - 8)] xor (Result shl 8) xor
      pData[I];
  end;
  for I := 0 to Crc32Bytes - 1 do begin
    // a 32 bit value shr 24 is a Byte, explictit type conversion to Byte adds an ASM instruction
    Result := Crc32Table[Result shr (CRC32Bits - 8)] xor (Result shl 8) xor (Crc
      shr (CRC32Bits - 8));
    Crc := Crc shl 8;
  end;
end;

{ TPasswordPolicy }

constructor TPasswordPolicy.Create(wsString: WideString);

begin
  mPasswordList := TWideStringList.Create();
  LoadFromFile(wsString);
  mUserHash := GetUserHash();
  writeln('TPasswordPolicy.Create ���: ', mUserHash);
//  getSevenZ().OnGetPassword := GetPassword;
  _S_SevenZipGetPasswordProc:=GetPassword;
end;

destructor TPasswordPolicy.Destroy;
begin
//nothing
  getSevenZ().OnGetPassword := nil;
  mPasswordList.Free();
  inherited;
end;

function TPasswordPolicy.GetPassword(aSender: TSevenZip;
  out aPassword: WideString): boolean;
var
  filename: string;
  ix, pwFormShowResult, pwdLength: integer;
  blSavePwd: boolean;
  s: WideString;
  pwdEncoded: string;

  function HexDigitVal(d: Char): byte;
  begin
    result := 0;
    case d of
      '0'..'9': result := ord(d) - ord('0');
      'A'..'F': result := ord(d) - ord('A') + 10;
    else abort;
    end;
  end;

begin
  filename := aSender.SZFileName;
  ix := mPasswordList.IndexOfName(fileName);
  if (ix < 0) then
    begin //����������� ������ �� ������ � ����...
    pwFormShowResult := MainForm.PassWordFormShowModal(aSender.SZFileName,
      aPassword, blSavePwd);
    if (pwFormShowResult = mrOk) and (length(aPassword) > 0) then begin
      s := XorPassword(UTF8Encode(aPassword));
      Writeln(filename, ' ', s);
      mPasswordList.AddObject(WideFormat('%s=%s', [filename, s]),
        TObject(ord(blSavePwd)));
    end
    else if (pwFormShowResult = mrCancel) then begin
      result := false; exit; end;

  end
  else begin //���� ������ � ����
    s := mPasswordList[ix];
    ix := Pos('=', s);
    s := Copy(s, ix + 1, $FFFF);
    pwdLength := length(s) div 2;
    SetLength(pwdEncoded, pwdLength);
    for ix := 1 to pwdLength do begin
      pwdEncoded[ix] := chr(HexDigitVal(Char(s[(ix - 1) * 2 + 1])) * 16
        + HexDigitVal(Char(s[ix * 2])));
    end;
    writeln('������  ', pwdEncoded);
    pwdEncoded := XorPassword(pwdEncoded, false);
    writeln('����� �����  ', pwdEncoded);
    Flush(output);
    aPassword := UTF8Decode(pwdEncoded);
  end;
  result := true;
end;

function TPasswordPolicy.GetUserHash: int64;
var
  userFolder: string;
  len: integer;
  data: int64;
  userFolderW: WideString;
begin
  userFolderW := WideUpperCase(CreateAndGetConfigFolder());
  userFolder := UTF8Encode(userFolderW);
  len := length(userFolder);
  if len <= 0 then begin result := 0; exit; end;
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

procedure TPasswordPolicy.InvalidatePassword(const aFile: WideString);
var
  ix: integer;
begin
  ix := mPasswordList.IndexOfName(aFile);
  if ix >= 0 then mPasswordList.Delete(ix);
end;

function TPasswordPolicy.LoadFromFile(const fileName: WideString): boolean;
var
  i, count: integer;
begin
  result := false;
  try
    if not assigned(mPasswordList) then mPasswordList := TWideStringList.Create()
    else mPasswordList.Clear();
    mPath := ExtractFilePath(fileName);
    result := SpecialIo(filename, mPasswordList, $1F6D35AC138E5311);
    if not result then exit;
    count := mPasswordList.Count - 1;
    for i := 0 to count do mPasswordList.Objects[i] := TObject(1);
    result := true;
  except
  g_ExceptionContext.Add('TPasswordPolicy.LoadFromFile.fileName='+filename);
  raise;
  end;

end; //func LoadFile

procedure TPasswordPolicy.SaveToFile(const filename: WideString);
var
  i, recordCount: integer;
begin
  recordCount := mPasswordList.Count;
  if recordCount <= 0 then exit;
  i := 0;
  repeat
    if integer(mPasswordList.Objects[i]) = 0 then begin
      mPasswordList.Delete(i); dec(recordCount); end
    else inc(i);
  until i >= recordCount;
  if recordCount <= 0 then exit;
  SpecialIO(filename, mPasswordList, $1F6D35AC138E5311, false);
end;

function TPasswordPolicy.XorPassword(aPwd: string; produceHex: boolean = true):
  string;
var
  i, j, pwdLength: integer;
  charByte: byte;
  pUserHash: PByteArray;
begin
  pwdLength := Length(aPwd);
  pUserHash := @mUserHash;
  i := 1; j := 0;
  repeat
    charByte := ord(aPwd[i]) xor pUserHash^[j];
    inc(i); inc(j);
    if produceHex then
      result := result + IntToHex(charByte, 2)
    else result := result + chr(charByte);
    if j > 7 then j := 0;
  until i > pwdLength;

end;

{ TBQException }

constructor TBQException.CreateFmt(const Msg: string;
  const Args: array of const);
begin
  mWideMsg := '������!';
  if Assigned(Lang) then begin
    mWideMsg := Lang.SayDefault(Msg, mWideMsg);
    mWideMsg := WideFormat(mWideMsg, Args);
  end; //if assigned
  inherited CreateFmt(mWideMsg, Args);
end;

{ TBQPasswordException }

constructor TBQPasswordException.CreateFmt(const password, module: WideString;
  const Msg: string; const Args: array of const);
begin
  mArchive := module; mWrongPassword := password;
  inherited CreateFmt(Msg, Args);
end;

var
  __hitCount: integer;
  {$J+}const lastPrec:integer=0; {$J-}

function EnumFontFamExProc(lpelfe: PENUMLOGFONTEXW; //logical-font data
  lpntme: PEnumTextMetricW; // physical-font data
  FontType: DWORD; // type of font
  lParam: LPARAM // application-defined data
  ): integer; stdcall;
   var ws:WideString;
begin
  result := 1;
  if (lpelfe^.elfLogFont.lfOutPrecision < OUT_STROKE_PRECIS) and
    (lParam <> 0) then exit;

  inc(__hitCount);
  if (lparam <> 0) and ( (PWideChar(lparam)^ = #0) or
  (lpelfe^.elfLogFont.lfOutPrecision>lastPrec)) then begin
    ws:=lpelfe^.elfFullName;
    Move(lpelfe^.elfFullName, PWideChar(lparam)^, 64);
    lastPrec:=lpelfe^.elfLogFont.lfOutPrecision;
  end;
end;

function FontFromCharset(aHDC: HDC; charset: integer; wsDesiredFont: string =
  ''): string;
var
  logFont: tagLOGFONTW;
  fontNameLength: integer;
  fontName: array[0..64] of WideChar;
begin
  __hitCount := 0;
  FillChar(logFont, sizeof(logFont), 0);
  FillChar(fontName, 64, 0);
  logFont.lfCharSet := charset;
//  logFont.lfOutPrecision:=OUT_TT_ONLY_PRECIS;
  fontNameLength := Length(wsDesiredFont);
  if fontNameLength > 0 then begin
    if (fontNameLength > 31) then fontNameLength := 31;
    Move(Pointer(wsDesiredFont)^, logFont.lfFaceName, fontNameLength * 2);
    EnumFontFamiliesExW(aHDC, logFont, @EnumFontFamExProc, 0, 0);
    if __hitCount > 0 then begin
      result := wsDesiredFont;
      exit;
    end;
  end;
  __hitCount := 0;lastPrec:=0;
  FillChar(logFont, sizeof(logFont), 0);
  FillChar(fontName, 64, 0);
  logFont.lfCharSet := charset;
  EnumFontFamiliesExW(aHDC, logFont, @EnumFontFamExProc, integer(@fontName), 0);
  if (__hitCount > 0) and (fontName[0] <> #0) then begin
   result := PWideChar(@fontName);
   G_InstalledFonts.Add(result);//long font names workaround
   end
  else result := EmptyWideStr;
end;

function FontExists(const wsFontName: string): boolean;
begin
  if G_InstalledFonts.IndexOf(wsFontName) >= 0 then
    begin result := true; exit; end;
  (*������������������ ��� ��������: �� ����������
   unicode, � �������������� - �������*)
{  __hitCount := 0;
  FillChar(logFont, sizeof(logFont), 0);
  fontNameLength := Length(wsFontName);
  logFont.lfCharSet := DEFAULT_CHARSET;
  if (fontNameLength > 31) then fontNameLength := 31;
  Move(Pointer(wsFontName)^, logFont.lfFaceName, fontNameLength * 2);
  EnumFontFamiliesExW(aHDC, logFont, @EnumFontFamExProc, 0, 0);
  result := __hitCount > 0;}
  result := Screen.Fonts.IndexOf(wsFontName) >= 0;

end;

function ExctractName(const wsFile: string): string;
var
  pC, pLastDot: PChar;
begin
  pC := PChar(Pointer(wsFile));
  if (pC = nil) or (pC^ = #0) then begin result := ''; exit end;
  pLastDot := nil;
  repeat
    if pC^ = '.' then pLastDot := pC;
    inc(pC);
  until (pC^ = #0);
  if pLastDot <> nil then
    result := Copy(wsFile, 1, pLastDot - PWideChar(Pointer(wsFile)))
  else result := wsFile;
end;

function ExtractModuleName(aModuleSignature: string): string;
var
  ipos: integer;
begin
  ipos := Pos(' $$$ ', aModuleSignature);
  if ipos <= 0 then begin result := ''; exit end;
  result := Copy(aModuleSignature, 1, ipos - 1);
end;

function StrPosW(const Str, SubStr: PWideChar): PWideChar;
var
  P: PWideChar;
  I: Integer;
begin
  Result := nil;
  if (Str = nil) or (SubStr = nil) or (Str^ = #0) or (SubStr^ = #0) then
    Exit;
  Result := Str;
  while Result^ <> #0 do
  begin
    if Result^ <> SubStr^ then
      Inc(Result)
    else
    begin
      P := Result + 1;
      I := 1;
      while (P^ <> #0) and (P^ = SubStr[I]) do
      begin
        Inc(I);
        Inc(P);
      end;
      if SubStr[I] = #0 then
        Exit
      else
        Inc(Result);
    end;
  end;
  Result := nil;
end;

{ TBQInstalledFontInfo }

constructor TBQInstalledFontInfo.Create(const aPath: WideString;
  afileNeedsCleanUp: boolean; aHandle: HFont);
begin
  mHandle := aHandle; mFileNeedsCleanUp := afileNeedsCleanUp; mPath := aPath;
end;

function IsDown(key: integer): boolean;
begin
  result := (Windows.GetKeyState(key) and $8000) <> 0;
end;

procedure cleanUpInstalledFonts();
var
  cnt, i: integer;
  ifi: TBQInstalledFontInfo;
  test: BOOL;
  tf: array[0..1023] of WideChar;
  tempPathLen: integer;
begin
  if not (assigned(G_InstalledFonts) ) then exit;
  cnt := G_InstalledFonts.Count - 1;
  if cnt > 0 then begin
  tempPathLen := GetTempPathW(1023, tf);
  if tempPathLen < 1024 then
  for i := 0 to cnt do begin
    try
      ifi := G_InstalledFonts.Objects[i] as TBQInstalledFontInfo;
      if not assigned(ifi) then continue;// for fake installed font - long font names workaround
      
      if (ifi.mHandle <> 0) and assigned(G_RemoveFontMemResourceEx) then
        test := G_RemoveFontMemResourceEx(ifi.mHandle)
      else begin
        test := RemoveFontResourceW(PWideChar(Pointer(ifi.mPath)));
        if ifi.mFileNeedsCleanUp then begin
      { TODO -oAlekId -cQA : �������� ���������� �������� ����� ������ }
    //���� ������
        end;
      end;
    except end;
    ifi.Free();
  end; //for
  end;
 try G_InstalledFonts.Free(); except end;
end;

procedure load_proc();
var
  h: THandle;
begin
  h := LoadLibrary('gdi32.dll');
  G_AddFontMemResourceEx := PfnAddFontMemResourceEx(GetProcAddress(h,
    'AddFontMemResourceEx'));
  G_RemoveFontMemResourceEx := PfnRemoveFontMemResourceEx(GetProcAddress(h,
    'RemoveFontMemResourceEx'));
end;

function FormatHTMLClipboardHeader(HTMLText: string): string;
const
  CrLf = #13#10;
begin
  HTMLText := '<!--StartFragment-->' + #13#10 + HTMLText + #13#10 +
    '<!--EndFragment -->' + #13#10;
  Result := 'Version:0.9' + CrLf;
  Result := Result + 'StartHTML:-1' + CrLf;
  Result := Result + 'EndHTML:-1' + CrLf;
  Result := Result + 'StartFragment:000081' + CrLf;
  Result := Result + 'EndFragment:������' + CrLf;
  Result := Result + HTMLText + CrLf;
  Result := StringReplace(Result, '������', Format('%.6d',
    [Length(Result)]), []);
end;

function GetHeader(HTML: string): string;
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
  DocType =
    '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'#13#10;

    // Let the compiler determine the description length.
  PreliminaryLength = Length(Version) + Length(StartHTML) +
    Length(EndHTML) + Length(StartFragment) +
    Length(EndFragment) + 4 * NumberLengthAndCR +
    2; {2 for last CRLF}
var
  URLString: string;
  StartHTMLIndex,
    EndHTMLIndex,
    StartFragmentIndex,
    EndFragmentIndex: integer;
begin
  Insert(StartFrag, HTML, 1);
  HTML := DocType + HTML;
  {Append the EndFrag string}
  HTML := HTML + EndFrag;
  {Add the header to start}

  UrlString := 'about:blank';
  StartHTMLIndex := PreliminaryLength + Length(URLString);
  EndHTMLIndex := StartHTMLIndex + Length(HTML);
  StartFragmentIndex := StartHTMLIndex + Pos(StartFrag, HTML) + Length(StartFrag)
    - 1;
  EndFragmentIndex := StartHTMLIndex + Pos(EndFrag, HTML) - 1;

  Result := Version +
    SysUtils.Format('%s%.8d', [StartHTML, StartHTMLIndex]) + #13#10 +
    SysUtils.Format('%s%.8d', [EndHTML, EndHTMLIndex]) + #13#10 +
    SysUtils.Format('%s%.8d', [StartFragment, StartFragmentIndex]) + #13#10 +
    SysUtils.Format('%s%.8d', [EndFragment, EndFragmentIndex]) + #13#10 +
    URLString + #13#10 + HTML;
end;

 //The second parameter is optional and is put into the clipboard as CF_HTML.
//Function can be used standalone or in conjunction with the VCL clipboard so long as
//you use the USEVCLCLIPBOARD conditional define
//($define USEVCLCLIPBOARD}
//(and clipboard.open, clipboard.close).
//Code from http://www.lorriman.com

procedure InsertDefaultFontInfo(var html: string; fontName: string; fontSz:
  integer);
var
  I: integer;
  S, L: string;
  HeadFound: boolean;
begin
  L := LowerCase(HTML);
  I := Pos('<head>', L);
  HeadFound := I > 0;
  if not HeadFound then
    I := Pos('<html>', L);
  if I <= 0 then
    I := 1;
  S := '<style> body {font-size: ' + IntToStr(fontSz) + 'pt; font-family: "' +
    fontName + '"; }</style>';
  if not HeadFound then
    S := '<head>' + S + '</head>';
  Insert(S, HTML, I);
end;

procedure CopyHTMLToClipBoard(const str: string; const htmlStr: AnsiString =
  '');
var
  gMem: HGLOBAL;
  lp: PChar;
  i, l: Integer;
  astr: string;
  uf, hf: UINT;
begin
  gMem := 0;
  hf := RegisterClipboardFormat('HTML Format');
  clipboard.Open;
  try
     //most descriptive first as per api docs
//     astr:=FormatHTMLClipboardHeader(htmlStr );
    astr := GetHeader(htmlStr);
    uf := CF_UNICODETEXT;
{$IFNDEF USEVCLCLIPBOARD}
     //Win32Check(EmptyClipBoard);
{$ENDIF}
    if length(htmlStr) > 0 then begin
       //an extra "1" for the null terminator
      l := Length(astr) + 1;
      gMem := GlobalAlloc(GMEM_DDESHARE + GMEM_MOVEABLE, l);
       {Succeeded, now read the stream contents into the memory the pointer points at}
      try
        Win32Check(gmem <> 0);
        lp := GlobalLock(gMem);
        Win32Check(lp <> nil);
        CopyMemory(lp, Pointer(astr), l);
      finally
        GlobalUnlock(gMem);
      end;
      Win32Check(gmem <> 0);
      SetClipboardData(hf, gMEm);
      Win32Check(gmem <> 0);
      gmem := 0;
    end;
    if false {length(str)>0} then begin
      l := Length(str) * 2 + 2;
      gMem := GlobalAlloc(GMEM_DDESHARE + GMEM_MOVEABLE, l);
       {Succeeded, now read the stream contents into the memory the pointer points at}
      try
        Win32Check(gmem <> 0);
        lp := GlobalLock(gMem);
        Win32Check(lp <> nil);
        CopyMemory(lp, Pointer(str), l);
      finally
        GlobalUnlock(gMem);
      end;
      Win32Check(gmem <> 0);
      SetClipboardData(uf, gMEm);
      Win32Check(gmem <> 0);
      gmem := 0;
    end;

  finally
{$IFNDEF USEVCLCLIPBOARD}
    clipboard.close;
{$ENDIF}
  end;
end;
{ TModuleEntry }

procedure TModuleEntry.Assign(source: TModuleEntry);
begin
  Init(source.modType, source.wsFullName, source.wsShortName,
    source.wsShortPath,
    source.wsFullPath, source.modBookNames, source.modCats);
  mMatchInfo:=source.mMatchInfo;
end;

constructor TModuleEntry.Create(amodType: TModuleType; awsFullName,
  awsShortName,
  awsShortPath, awsFullPath: Widestring; awsBookNames: UTF8String;
   modCats: TWideStrings);
begin
  inherited Create;
//  modType := amodType;
//  wsFullName := awsFullName;
//  wsShortPath := awsShortPath;
//  wsShortName := awsShortName;
//  wsFullPath := awsFullPath;
  Init(amodType, awsFullName, awsShortName, awsShortPath,
    awsFullPath, awsBookNames, modCats);
end;

constructor TModuleEntry.Create(me: TModuleEntry);
begin
  Assign(me);
end;

function TModuleEntry.DefaultModCats(): WideString;
begin

  case modType of
    modtypeBible: result := Lang.SayDefault('HolySriptCat', 'Holy Scripture, Bible');
    modtypeBook: result := Lang.SayDefault ('NoCat', 'No Category');
    modtypeComment: result :=Lang.SayDefault ('CommentCat', 'BibleCommentaries');

  end; //case

end;

destructor TModuleEntry.destroy;
begin
  FreeMem(mRects);
  mMatchInfo:=nil;
  inherited;
end;

function TModuleEntry.getIniPath: WideString;
begin
result:=MainFileExists(wsShortPath+'\'+C_ModuleIniName);
end;

constructor TModuleEntry.Create(amodType: TModuleType; awsFullName,
  awsShortName, awsShortPath, awsFullPath: WideString; awsBookNames: UTF8String;
    modCats: WideString);
begin
  Init(amodType, awsFullName, awsShortName, awsShortPath,
    awsFullPath, awsBookNames, modCats);
end;

procedure TModuleEntry.Init(amodType: TModuleType; awsFullName, awsShortName,
  awsShortPath, awsFullPath: WideString; awsBookNames: UTF8String; amodCats:
    WideString);
begin
  modType := amodType;
  wsFullName := awsFullName;
  wsShortPath := awsShortPath;
  wsShortName := awsShortName;
  wsFullPath := awsFullPath;
  mRects:=nil;
  modBookNames := awsBookNames;
  if length(amodCats) <= 0 then begin
    modCats := DefaultModCats();
  end else modCats := amodCats;
end;

function TModuleEntry.Match(matchLst: TStringList;
  var mi:TMatchInfoArray; allMath: boolean = false): TModMatchTypes;
type TBQBookSet=set of Byte;

var
  listIx, listCnt,  fndPos: integer;
  matchStrUp, strCatsUp, strNameUP, strBNamesUp: string;
  tagFullMatch, nameFullMatch, bookNameFullMatch, nameFound,tagFound, bookNameFound,
    partialMacthed, foundBookNameHits,searchBookNames, booksetInit: Boolean;
    p,pf:PWideChar;
    curHits, allHits,saveHits:TBQBookSet;
    pbs:^TBQBookSet;
    fndIx, newfndIx:byte;
    book_cnt, arrSz:integer;
begin
  listCnt := matchLst.Count - 1;
  result := [];
  if listCnt < 0 then exit;
  strNameUP := LowerCase(wsFullName);
  strCatsUp := LowerCase(modCats);
  strBNamesUp := LowerCase(UTF8Decode(modBookNames));

  tagFullMatch := true; nameFullMatch := true; bookNameFullMatch:=true; partialMacthed := true;
  allHits:=[];
  //for newfndIx:=1 to 255 do include(allHits,newfndIx);
  searchBookNames:=not (modType in [modtypeBible, modtypeComment]);
  booksetInit:=true;
  for listIx := 0 to listCnt do begin
    curHits:=[];
    matchStrUp := LowerCase(matchLst[ListIx]);
    nameFound := (Pos(matchStrUp, strNameUP) > 0);
    if nameFound then begin
      if not allMath then begin Include(result, mmtName); end;
    end else nameFullMatch := false;
//else if allMath then begin  result:=mmtNone; exit end;
    tagFound:=Pos(matchStrUp, strCatsUp) > 0;
    if tagFound then begin
      if not allMath then begin
       Include(result, mmtCat); break; end;
    end
    else begin //not match cat
      tagFullMatch := false;
    end;

    p:=PWideChar(Pointer(strBNamesUp));
    pf:=p+length(strBNamesUp);
    foundBookNameHits:=false;
    if searchBookNames
        {or ((not tagFound)and (not nameFound)))} then begin
       
    repeat
    p:=StrPosW(p, PWideChar(Pointer(matchStrUp)) );
    bookNameFound:=p <> nil;
    if bookNameFound then begin
    foundBookNameHits:=true;
      newfndIx:=StrTokenIx(strBNamesUp, p-PWideChar(Pointer(strBNamesUp))+1);
      if newfndIx>0 then include(curHits,newfndIx);
      Inc(p, length(matchStrUp));

      if not allMath then begin
       Include(result, mmtBookName);
       end
      else {all match} begin

//       if fndIx=-2 then fndIx:=newfndIx//first hit
//       else if (newfndIx<>fndIx) then bookNameFullMatch:=false;

       end// all match
    end

    until (p>pf) or (not bookNameFound)  ;
    if allMath then begin
//      if foundBookNameHits then begin
       if foundBookNameHits then begin
       //���� ����� �������
        if   booksetInit then begin
        //���� ��� ������ ������ ����
        allHits:=allHits+curHits;
        booksetInit:=false;
        end
        else if not (tagFound or nameFound) then begin
             allHits:=allHits*curHits;
          end;
      end
      else if not (tagFound or nameFound) then allHits:=[];
      foundBookNameHits:=allHits<>[];
   end
   else allHits:=allHits+curHits;
   end;//if search books
    if allMath then begin
//      if foundBookNameHits then begin
//      if tagFound or nameFound or booksetInit then begin
//      allHits:=allHits+curHits;
//      booksetInit:=false;
//      end
//      else    allHits:=allHits*curHits;
//      foundBookNameHits:=allHits<>[];
  //    end;

    if  (not nameFound) and (not tagFound) and (not foundBookNameHits)  then begin
        partialMacthed := false;
        break;
    end;
    end
  end; //for

  if allMath then begin

    if tagFullMatch then Include(Result, mmtCat);
    if nameFullMatch then Include(Result, mmtName);
    if allHits<>[] then begin
     Include(Result, mmtBookName);
    end;

    if result = [] then begin
      if partialMacthed then result := [mmtPartial]
    end; //not found full match

  end; //if allmatch
  if mmtBookName in result then begin
  fndIx:=0;
  arrSz:=length(mi);
     if allMath then pbs:=@allHits else pbs:=@allHits;
     book_cnt:=0;
     repeat
      if fndIx in pbs^ then begin
      if (book_cnt>=arrSz) then begin

      Inc(arrSz,arrSz+1);
      SetLength(mi,arrSz);
      end;
        mi[book_cnt].ix:=fndIx;
        mi[book_cnt].matchSt:=1;
        mi[book_cnt].name:=C_BulletChar+#32+BookNameByIx(fndIx);

        inc(book_cnt);
      end;
      inc(fndIx);
     until (fndIx=0);
     SetLength(mi, book_cnt);
     if book_cnt<=0 then
         Exclude(result,mmtBookName);
     end;

end;


function TModuleEntry.VisualSignature():WideString;
begin
  if length(wsShortName)>0 then result:=wsShortName
  else result:=wsShortPath;
end;
function TModuleEntry.BibleBookPresent(ix:integer):boolean;
var r:ansistring;
begin
result:=false;
if not (modType in [modtypeBible,modtypeComment]) then exit;
r:=StrGetTokenByIx(modBookNames, ix);
result:=(r='1');
end;


function TModuleEntry.BookNameByIx(ix:integer): WideString;
begin
if (Ix<=0) then begin Result:=''; exit;end;
Result:=UTF8Decode(StrGetTokenByIx(modBookNames, Ix));
end;

procedure TModuleEntry.Init(amodType: TModuleType; awsFullName, awsShortName,
  awsShortPath, awsFullPath: Widestring; awsBookNames: UTF8String; modCatsLst:
    TWideStrings);
begin
  modType := amodType;
  wsFullName := awsFullName;
  wsShortPath := awsShortPath;
  wsShortName := awsShortName;
  wsFullPath := awsFullPath;
  modBookNames := awsBookNames;
  mRects:=nil;
  if modCatsLst.Count <= 0 then modCats := DefaultModCats()
  else modCats := TokensToStr(modCatsLst, '|');
end;

{ TCachedModules }

procedure TCachedModules.Assign(source: TCachedModules);
var
  i, cnt: integer;
  me: TModuleEntry;
begin
  cnt := source.Count - 1;
  Clear();
  for i := 0 to cnt do Add(TModuleEntry.Create(TModuleEntry(source.Items[i])));
end;

function __ModEntryCmp(Item1, Item2: TModuleEntry): Integer;
begin
  Result := OmegaCompareTxt(Item1.wsFullName, Item2.wsFullName,-1, true);
end;

function TCachedModules.FindByName(const name: WideString;
  fromix: integer): integer;
var
  cnt, i, newi, fin, r: integer;
begin
  cnt := Count;
  result := -1;
  if cnt <= 0 then exit;

  i := fromix + ((cnt - fromix) div 2);
  fin := cnt - 1;
  newi:=i;
  repeat
    i := newi;
    r := OmegaCompareTxt(name, TModuleEntry(Items[i]).wsFullName);
    if r = 0 then break;
    if r < 0 then fin := i else fromIx := i+1;
    newi := (fromix + fin) div 2;
  until i=newi;
  if r <> 0 then begin result := -1; exit; end;
  dec(i);
  while  (i>=fromix) and
   (OmegaCompareTxt(name, TModuleEntry(Items[i]).wsFullName)=0) do dec(i);
  inc(i);
  result := i;
end;

function TCachedModules.GetArchivedCount: integer;
var i,c:integer;
begin
c:=Count-1;
result:=0;
for i:=c downto 0 do begin
if items[i].wsFullPath[1]='?' then inc(result);
end;
end;

function TCachedModules.GetItem(Index: Integer): TModuleEntry;
begin
result:=TModuleEntry(inherited GetItem(index));
end;

function TCachedModules.GetModTypedAsCount(modType: TModuleType): integer;
var i,c:integer;
begin
c:=Count-1; result:=0;
for i:=c downto 0 do begin
  if Items[i].modType=modType then Inc(result);
end
end;

function TCachedModules.IndexOf(const name: WideString;
  fromix: integer): integer;
var
  cnt, i, newi, fin, r: integer;
begin
  cnt := self.Count - 1;
  result := -1;
  if cnt < 0 then exit;
  for i := 0 to cnt do begin
    result := OmegaCompareTxt(name, TModuleEntry(Items[i]).wsFullName,-1,true);
    if result = 0 then begin result := i; exit end;
  end;

  result := -1;
end;

function TCachedModules.ModTypedAsFirst(modType: TModuleType): TModuleEntry;
var i,c,f:integer;
begin
mModTypedAsPointers[modType]:=-1;
f:=-1;
c:=count-1;
result:=nil;
for i:=0 to c do begin
if Items[i].modType=modType then begin f:=i; break; end;
end;
if f>=0 then begin
mModTypedAsPointers[modType]:=f+1;
result:=Items[f];
end;

end;

function TCachedModules.ModTypedAsNext(modType: TModuleType): TModuleEntry;
var i,c,f:integer;
begin
c:=count-1;
result:=nil;
f:=-1;
i:=mModTypedAsPointers[modType];
if i<=c then
repeat
if Items[i].modType=modType then begin f:=i; break; end;
inc(i);
until i>c;
if f>=0 then begin
result:=Items[f];
end;
mModTypedAsPointers[modType]:=i+1;

end;

function TCachedModules.FindByFolder(const name:WideString):integer;
var
  cnt, i, newi, fin, r: integer;
begin
  cnt := self.Count - 1;
  result := -1;
  if cnt < 0 then exit;
  for i := 0 to cnt do begin
    result := WideCompareText(name, TModuleEntry(Items[i]).wsShortPath);
    if result = 0 then begin result := i; exit end;
  end;
  result := -1;
end;


function TCachedModules.FindByFullPath(const wsFullPath: WideString): integer;
var
  cnt, i, newi, fin, r: integer;
begin
  cnt := self.Count - 1;
  result := -1;
  if cnt < 0 then exit;
  for i := 0 to cnt do begin
    result := WideCompareText(wsFullPath, Items[i].wsFullPath);
    if result = 0 then begin result := i; exit end;
  end;
  result := -1;

end;

procedure TCachedModules._Sort;
begin
  self.Sort(@__ModEntryCmp);
  mSorted := true;
end;



function TCachedModules.ResolveModuleByNames(const modName,modShortName:WideString):TModuleEntry;
var foundIx,c:integer;
begin
result:=nil;
try
  foundIx:=IndexOf(modName);
  if (foundIx<0) then exit;
  result:=TModuleEntry(Items[foundIx]);
  if Result.wsShortName=modShortName then exit;
  c:=Count;

   repeat
   result:=TModuleEntry(Items[foundIx]);
   inc(foundIx);
  until (foundIx>c) or (OmegaCompareTxt(result.wsFullName,modName,-1, true)<>0)
 or (result.wsShortName<>modShortName);//until

  result:=TModuleEntry(Items[foundIx-1]);
except
on e:Exception do begin
g_ExceptionContext.Add(
WideFormat('TCachedModules.ResolveModuleByNames: modName=%s | modShortName=%s ',
  [modName, modShortName])
  );
end;
end;
end;

procedure TCachedModules.SetItem(Index: Integer; AObject: TModuleEntry);
begin
inherited SetItem(index, AObject);
end;

{ TBQStringList }

function TBQStringList.CompareStrings(const S1, S2: string): Integer;
begin
  result := OmegaCompareTxt(S1, S2);
end;

function TBQStringList.LocateLastStartedWith(const subString: string;
  startFromIx: integer = 0; strict: boolean = false): integer;
var
  l, fin, i, newi, cnt, bestMatchLen, matchLen,bestMatchLenIx,currentCompareLen,
    startIx,lenDifferenceMin, lenDifference: integer;
begin
  cnt := Count;
  l := length(subString);
  i := startfromix + ((cnt - startFromIx) div 2);
  newi:=i;
  fin := cnt - 1;
  startIx:=startFromIx;
  repeat
   i := newi;
    result := OmegaCompareTxt(subString, Strings[i], l,true);
    if result = 0 then break;
    if result < 0 then fin := i else startIx := i+1;
    newi := (startIx + fin) div 2;
  until i=newi;
  if (result=0) then begin result:=i; exit;end;
  if  (strict) then begin result:=-1; exit;end;

  fin := cnt - 1;
  startIx:=startFromIx;

  bestMatchLen:=-1;
  lenDifferenceMin:=$FFFF;
  repeat
   i := newi;
    result := OmegaCompareTxt(subString, Strings[i], l,false);
    if result = 0 then begin
      matchLen:=length(Strings[i]);
      lenDifference:=matchLen-l; if lenDifference<0 then lenDifference:=-lenDifference;
      if ((matchLen>bestMatchLen) and ((matchLen<=l)or (lenDifference<=lenDifferenceMin )) ) or
         ((matchLen<bestMatchLen) and ((bestMatchLen>l) or (lenDifference<lenDifferenceMin)) )or
          (bestMatchLen<0)  then begin
       bestMatchLen:=matchLen; bestMatchLenIx:=i; lenDifferenceMin:=lenDifference;
      end;
    result:=l-matchLen;
    end;
    if result < 0 then fin := i else startIx := i+1;
    newi := (startIx + fin) div 2;
  until i=newi;
  if bestMatchLen<0 then result:=-1
  else Result:=bestMatchLenIx;

//  if result <> 0 then result := -1
//  else begin
//    dec(i);
//    while (i >= 0) and (OmegaCompareTxt(subString, strings[i], l) = 0) do
//      dec(i);
//    inc(i);
//    result := i;
//    if strict and (length(strings[i]) <> l) then result := -1;
//  end;
end;

function StrMathTokens(const str: string; tkns: TStrings; fullMatch:
  boolean): boolean;
var
  i, c: integer;
  s: string;
  fnd: boolean;
begin
  c := tkns.Count - 1;
  if c < 0 then begin result := false; exit end;
  result := true;
  s := LowerCase(str);
  for i := 0 to c do begin
    fnd := (Pos(LowerCase(tkns[i]), s) > 0);
    if fnd xor fullMatch then begin result := fnd; exit end
  end; //for
  result := fullMatch;
end;

function GetTokenFromString(pStr:PWidechar;delim:WideChar; out len:integer):PWideChar;
var currentCmpCh:WideChar;
label endfail;
begin

currentCmpCh:=pStr^;
if currentCmpCh=#0 then goto endfail;
//skip to first symb
if currentCmpCh=delim then  repeat
 inc(pStr); currentCmpCh:=pStr^;
 if (currentCmpCh=#0) then goto endfail;
 until  (currentCmpCh<>delim);
result:=pStr;
inc (pStr);currentCmpCh:=pStr^;
//inc to delim or end
while (currentCmpCh<>#0) and (currentCmpCh<>delim) do begin
inc(pStr); currentCmpCh:=pStr^; end;
len:=pStr-result;

exit;
//here first token is found

endfail:len:=0; result:=nil;
end;


function PeekToken(pC:PChar; delim:Char):string;
var saveChar:Char;
    l:integer;
label fail;
begin

if pc=nil then goto fail;
pc:=GetTokenFromString(pc, delim, l);
if pC<>nil then begin
   saveChar:=(pc+l)^;
   (pc+l)^:=#0;
   result:=pC;
   (pc+l)^:=saveChar;
   exit
end;
fail:
 result:=''; 
end;
function CompareTokenStrings(const tokensCompare:string; const tokenCompareAgainst:string; delim:Char):integer;
var pTokenCmp, pTokenCmpAg :PChar;
    currentCmpCh,currentCmpChA:Char;
    cmpTokeLen,cmpTokeLenAdj, cmpAgTokeLen,cmpAgTokeLenAdj, matchCnt, compareCnt:integer;
    equal:boolean;

begin
result:=-1;
pTokenCmp:=Pointer(tokensCompare);
matchCnt:=0;compareCnt:=0;
pTokenCmp:=GetTokenFromString(pTokenCmp, delim,cmpTokeLen);
while (pTokenCmp<>nil) do begin
  cmpTokeLenAdj:=cmpTokeLen;
  if (pTokenCmp+cmpTokeLen-1)^='.' then dec( cmpTokeLenAdj);
  pTokenCmpAg:=Pointer(tokenCompareAgainst);
  pTokenCmpAg:=GetTokenFromString(pTokenCmpAg, delim,cmpAgTokeLen);
  equal:=false;
  while (  pTokenCmpAg<>nil) and (not equal) do begin
    cmpAgTokeLenAdj:=cmpAgTokeLen;
    if (pTokenCmpAg+cmpAgTokeLen-1)^='.' then dec( cmpAgTokeLenAdj);
    equal:=CompareStringW($0007f,NORM_IGNORECASE,pTokenCmp,cmpTokeLenAdj,
    pTokenCmpAg,cmpAgTokeLenAdj)=CSTR_EQUAL;
    pTokenCmpAg:=GetTokenFromString(pTokenCmpAg+cmpAgTokeLen, delim,cmpAgTokeLen);
  end;
  inc ( matchCnt,ord(equal) ); inc(compareCnt);
  pTokenCmp:=GetTokenFromString(pTokenCmp+cmpTokeLen, delim,cmpTokeLen);
end;
if compareCnt=0 then result:=-1
else result:= matchCnt*100 div compareCnt;

end;


function MainFileExists(s: string): string;
var
  filePath, fullPath, modfolder: WideString;
begin
  Result := '';
  //������ ������ ����� ��������� ��� �����
  filePath := ExtractFilePath(s);
  modfolder := Copy(filePath, 1, length(filePath) - 1);
  fullPath := ExePath + C_CompressedModulesSubPath + '\' + modfolder + '.bqb';
  if FileExists(fullpath) then
    Result := '?' + fullpath + '??' + C_ModuleIniName
  else if FileExists(ExePath + s) then
    Result := ExePath + s
  else if FileExists(G_SecondPath + s) then
    Result := G_SecondPath + s
  else
  begin
    fullPath := ExePath + 'compressed\' + Copy(filePath, 1,
      length(filePath) - 1) + '.bqb';
    if FileExists(fullpath) then
      Result := '?' + fullpath + '??' + C_ModuleIniName
    else
    begin
      filePath := ExtractFilePath(s);
      fullPath := ExePath + C_CommentariesSubPath + '\' + Copy(filePath, 1,
        length(filePath) - 1) + '.bqb';
      if FileExists(fullpath) then
        Result := '?' + fullpath + '??' + C_ModuleIniName
      else if FileExists(ExePath + 'Commentaries\' + s) then
        Result := ExePath + 'Commentaries\' + s;
    end;
  end;
end;

procedure __init_vars();
var buff:PChar;
    wrtn:integer;
begin
GetMem(buff, 4096);
wrtn:=Windows.GetModuleFileNameW(0, buff, 2047);
__exe__path:=ExtractFilePath(  buff);

FreeMem(buff);
end;
function ExePath():string;
begin
result:=__exe__path;
end;

function CreateAndGetConfigFolder: string;
var
  dUserName: string;
  dPath: string;
  wsPath: string;
begin
  wsPath := ExtractFileName(ExtractFileDir(ExePath()));

  if Pos('Portable', wsPath) <> 0 then dUserName := 'CommonProfile'
  else dUserName := WindowsUserName();

  Result := ExePath + 'users\' + DumpFileName(dUserName) + '\';
  if ForceDirectories(Result) then
    Exit;
//AlekId:Weird
//  Result := WindowsDirectory + 'biblequote\' + DumpFileName(dUserName) + '\';
//  if ForceDirectories(Result) then
//    Exit;

  dPath := GetAppDataFolder;
  if dPath <> '' then
  begin
    Result := dPath + 'BibleQuoteUni\';
    if ForceDirectories(Result) then
      Exit;
  end;
  MessageBoxW(0, 'Cannot Found BibleQute data folder', 'BibleQute Error', MB_OK
    or MB_ICONERROR);
  Result := '';

end;

function IsWindows64: Boolean;
type
  TIsWow64Process = function(AHandle:THandle; var AIsWow64: BOOL): BOOL; stdcall;
var
  vKernel32Handle: DWORD;
  vIsWow64Process: TIsWow64Process;
  vIsWow64       : BOOL;
begin
  // 1) assume that we are not running under Windows 64 bit
  Result := False;

  // 2) Load kernel32.dll library
  vKernel32Handle := LoadLibrary('kernel32.dll');
  if (vKernel32Handle = 0) then Exit; // Loading kernel32.dll was failed, just return

  try

    // 3) Load windows api IsWow64Process
    @vIsWow64Process := GetProcAddress(vKernel32Handle, 'IsWow64Process');
    if not Assigned(vIsWow64Process) then Exit; // Loading IsWow64Process was failed, just return

    // 4) Execute IsWow64Process against our own process
    vIsWow64 := False;
    if (vIsWow64Process(GetCurrentProcess, vIsWow64)) then
      Result := vIsWow64;   // use the returned value

  finally
    FreeLibrary(vKernel32Handle);  // unload the library
  end;
end;


var _osInfo:TOperatingSystemInfo=nil;


function OSinfo():TOperatingSystemInfo;
begin
if not assigned(_osInfo) then begin
_osInfo:=TOperatingSystemInfo.Create(nil);
_osInfo.Active:=true;
end;
result:= _osInfo;

end;

function WinInfoString():string;
{$J+}
const win_info:string='';
var osprop:TOperatingSystemProperties;
{$J-}
begin
if length(win_info)=0 then begin
try
osprop:=OSinfo().OperatingSystemProperties;

win_info:=osprop.Caption;
if length(osprop.CSDVersion)>0 then
     win_info:=Format('%s (%s)',[win_info, osprop.CSDVersion]);
if length(osprop.OSLanguageAsString)>0 then
     win_info:=Format('%s (OSLang: %s[%d])',[win_info, osprop.OSLanguageAsString,osprop.OSLanguage]);
win_info:=Format('%s (SP: %d.%d)',[win_info, osprop.ServicePackMajorVersion,osprop.ServicePackMinorVersion ]);
except
win_info:=GetWindowsProductString()+' '+ GetWindowsServicePackVersionString();
end;

if IsWindows64() then win_info:=win_info+' (64bit)'
else win_info:=win_info+' (32bit)';

end;

result:=win_info;

end;

function GetCallerEIP():Pointer;assembler;
asm
mov eax,dword ptr [esp]
end;
function GetCallerEbP():Pointer;assembler;
asm
mov eax, ebp
end;


{$REGION  TbqOldObjectList }
/// <summary>������������ ����-����� �� ������ � TDateTime.</summary>
/// <param name="AValue">������, �������������� ���� �� ������. ����� ������ ���� 'Sun, 25 Jan 2009 12:48:15 +0300'.<param>
/// <returns>�������� TDateTime (�� �������� �������), ������� ������������� ��������� AValue, ��� 0, ���� AValue �� �������� ����������� ������������� ����.</returns>
/// <seealso cref="GetDate">GetDate</seealso>
procedure TbqOldObjectList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lnDeleted then

end;
{$ENDREGION}
{ TbqTextFileWriter }

function TbqTextFileWriter.CLose: HRESULT;
begin
if CloseHandle(mHandle) then result:=S_FALSE else result:=S_OK;
mHandle:=0;
end;

constructor TbqTextFileWriter.Create(const aFileName: WideString);
var writePos:integer;
begin
mHandle:=CreateFileW(Pointer(aFileName),GENERIC_WRITE,FILE_SHARE_READ,nil,OPEN_ALWAYS,
      FILE_ATTRIBUTE_NORMAL,0);
if mHandle=INVALID_HANDLE_VALUE then RaiseLastOSError();
writePos:=FileSeek(mHandle,0,soFromEnd);
if writePos=0 then FileWrite(mHandle,BOM_UTF16_LSB,2);
end;

destructor TbqTextFileWriter.destroy;
begin
  Close();
  inherited;
end;

function TbqTextFileWriter.WriteUnicodeLine(const line: WideString): HRESULT;
var bytesWritten:Cardinal;
    boolWrite:BOOL;
    leng:integer;
begin
leng:=Length(line)*2;
if leng>0 then begin
   boolWrite:=WriteFile(mHandle,pointer(line)^, leng,bytesWritten,nil)
 end
else boolWrite:=false;

WriteFile(mHandle, C_crlf,4,bytesWritten,nil) ;
if boolWrite then result:=S_OK else result:=S_FALSE;
end;

initialization
   // Enable raw mode (default mode uses stack frames which aren't always generated by the compiler)
  Include(JclStackTrackingOptions, stRawMode);
  Include(JclStackTrackingOptions, stStack);
  // Disable stack tracking in dynamically loaded modules (it makes stack tracking code a bit faster)
//  Include(JclStackTrackingOptions, stStaticModuleList);
  // Initialize Exception tracking
  g_ExceptionContext:=TbqExceptionContext.Create();
  JclStartExceptionTracking;
  __init_vars();
  G_InstalledFonts := TWideStringList.Create;
  G_InstalledFonts.Sorted := true;
  G_InstalledFonts.Duplicates := dupIgnore;
  load_proc();

finalization
//  S_SevenZip.Free();
  JclStopExceptionTracking();
  FreeAndNil(g_ExceptionContext);
  FreeAndNil(_osInfo);

end.

