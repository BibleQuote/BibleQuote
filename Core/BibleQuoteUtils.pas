unit BibleQuoteUtils;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses ZipUtils, MultiLanguage, IOUtils, JCLDebug, PlainUtils,
  Contnrs, Windows, SysUtils, Classes, SystemInfo, CRC32, Vcl.Graphics,
  ImageUtils, SyncObjs, ShlObj, AppPaths, AppIni;

type

  TBQException = class(Exception)
    mErrCode: Cardinal;
    mMessage: string;
    constructor CreateFmt(const Msg: string; const Args: array of const);
  end;

  TbqHLVerseOption = (hlFalse, hlTrue, hlDefault);

  TModuleType = (
    modtypeBible,
    modtypeBook,
    modtypeComment,
    modtypeDictionary);

  TModMatchType = (mmtName, mmtBookName, mmtCat, mmtPartial, nmtAuthor);
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
  private
    FFullName, FShortName, FShortPath, FFullPath: String;
    FModType: TModuleType;
    FModCats: String;
    FModBookNames: String;

    FAuthor: String;
    FModuleVersion: String;
    FCoverPath: String;
    FHasStrong: Boolean;

    FRects: PRectArray;

  public
    mMatchInfo: TMatchInfoArray;

    constructor Create(
      aModType: TModuleType;
      aFullName, aShortName, aShortPath, aFullPath: String;
      aBookNames: String;
      aModCats: TStrings;
      aAuthor: String;
      aModuleVersion: String;
      aCoverPath: String;
      aHasStrong: boolean); overload;

    constructor Create(
      aModType: TModuleType;
      aFullName, aShortName, aShortPath, aFullPath: String;
      aBookNames: String;
      aModCats: String;
      aAuthor: String;
      aModuleVersion: String;
      aCoverPath: String;
      aHasStrong: boolean); overload;

    constructor Create(me: TModuleEntry); overload;
    destructor Destroy; override;

    procedure Init(
      aModType: TModuleType;
      aFullName, aShortName, aShortPath, aFullPath: String;
      aBookNames: String;
      aModCatsLst: TStrings;
      aAuthor: String;
      aModuleVersion: String;
      aCoverPath: String;
      aHasStrong: boolean); overload;

    procedure Init(
      aModType: TModuleType;
      aFullName, aShortName, aShortPath, aFullPath: String;
      aBookNames: String;
      aModCats: String;
      aAuthor: String;
      aModuleVersion: String;
      aCoverPath: String;
      aHasStrong: boolean); overload;

    procedure Assign(source: TModuleEntry);
    function Match(aMatchLst: TStringList; var mi: TMatchInfoArray; aAllMatch: Boolean = false): TModMatchTypes;

    function BookNameByIx(ix: integer): string;
    function VisualSignature(): string;
    function BibleBookPresent(ix: integer): boolean;
    function GetCoverImage(width, height: integer): TPicture;

    function GetInfoPath(): string;

    property ShortPath: String read FShortPath;
    property FullPath: String read FFullPath;
    property FullName: String read FFullName;
    property ShortName: String read FShortName;
    property ModType: TModuleType read FModType;
    property ModBookNames: String read FModBookNames;
    property ModCats: String read FModCats;
    property Author: String read FAuthor;
    property CoverPath: String read FCoverPath;
    property HasStrong: Boolean read FHasStrong;
    property ModuleVersion: String read FModuleVersion;

  protected
    FCachedCover: TPicture;
    FCachedWidth, FCachedHeight: integer;
    FCachedCoverLock : TCriticalSection;

    function DefaultModCats(): string;
    procedure FixedResult(aFound: Boolean; aAllMatch: Boolean; var aModTypes: TModMatchTypes;
          aModType: TModMatchType; var aFullMath: Boolean);
  end;

  TCachedModules = class(TObjectList)
  protected
    mSorted: boolean;
    mModTypedAsPointers: array [TModuleType] of integer;
    FOnAssignEvent: TNotifyEvent;

    function GetItem(Index: integer): TModuleEntry;
    procedure SetItem(Index: integer; AObject: TModuleEntry);
  public
    procedure Assign(source: TCachedModules);
    procedure CopyRange(source: TCachedModules);
    function FindByName(const name: string; fromix: integer = 0): integer;
    function ResolveModuleByNames(const modName, modShortName: string) : TModuleEntry;
    function IndexOf(const name: string; fromix: integer = 0) : integer; overload;
    function FindByFolder(const name: string): integer;
    function FindByFullPath(const wsFullPath: string): integer;
    function GetModTypedAsCount(modType: TModuleType): integer;
    function ModTypedAsFirst(modType: TModuleType): TModuleEntry;
    function ModTypedAsNext(modType: TModuleType): TModuleEntry;
    procedure SaveToFile(Path: String);
    procedure _Sort();

    property Items[Index: integer]: TModuleEntry read GetItem write SetItem; default;

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

function SpecialIO(const fileName: string; strings: TStrings; obf: int64; read: boolean = true): boolean;
function ExtractModuleName(aModuleSignature: string): string;
function StrPosW(const Str, SubStr: PChar): PChar;
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

function ResolveFullPath(Path: string): String;
function GetCallerEIP(): Pointer;

var
  Lang: TMultiLanguage;
  G_DebugEx: integer;
  G_NoCategoryStr: string = 'Áåç êàòåãîðèè';

implementation

uses JclSysInfo, MainFrm, Controls, Forms, Clipbrd, StrUtils, BibleQuoteConfig,
  StringProcs, JclBase;

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

function IsDown(key: integer): boolean;
begin
  result := (Windows.GetKeyState(key) and $8000) <> 0;
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
  Init(source.modType, source.FullName, source.ShortName,
    source.ShortPath, source.FullPath, source.ModBookNames, source.ModCats,
    source.Author, source.ModuleVersion,
    source.CoverPath, source.HasStrong);
  mMatchInfo := source.mMatchInfo;
end;

constructor TModuleEntry.Create(
  aModType: TModuleType;
  aFullName, aShortName, aShortPath, aFullPath: String;
  aBookNames: String;
  aModCats: TStrings;
  aAuthor: String;
  aModuleVersion: String;
  aCoverPath: String;
  aHasStrong: boolean);
begin
  inherited Create;

  Init(aModType, aFullName, aShortName, aShortPath, aFullPath, aBookNames, aModCats,
       aAuthor, aModuleVersion, aCoverPath, aHasStrong);
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
  FreeMem(FRects);
  FreeAndNil(FCachedCoverLock);

  if Assigned(FCachedCover) then
    FreeAndNil(FCachedCover);

  mMatchInfo := nil;
  inherited;
end;

procedure TModuleEntry.FixedResult(aFound: Boolean; aAllMatch: Boolean;
  var aModTypes: TModMatchTypes; aModType: TModMatchType;
  var aFullMath: Boolean);
begin
    if aFound then
    begin
      if not aAllMatch then
      begin
        Include(aModTypes, mmtName);
      end;
    end
    else
      aFullMath := False;

end;

function TModuleEntry.GetInfoPath(): string;
begin
  if FileExists(ShortPath) then
    Result := ShortPath
  else
    Result := ResolveFullPath(TPath.Combine(ShortPath, C_ModuleIniName));
end;

constructor TModuleEntry.Create(
  aModType: TModuleType;
  aFullName, aShortName, aShortPath, aFullPath: String;
  aBookNames: String;
  aModCats: String;
  aAuthor: String;
  aModuleVersion: String;
  aCoverPath: string;
  aHasStrong: boolean);
begin
  Init(aModType, aFullName, aShortName, aShortPath, aFullPath, aBookNames, aModCats,
       aAuthor, aModuleVersion, aCoverPath, aHasStrong);
end;

procedure TModuleEntry.Init(
  amodType: TModuleType;
  aFullName, aShortName, aShortPath, aFullPath: String;
  aBookNames: String;
  aModCats: String;
  aAuthor: String;
  aModuleVersion: String;
  aCoverPath: String;
  aHasStrong: boolean);
begin
  FModType := aModType;
  FFullName := aFullName;
  FShortPath := aShortPath;
  FShortName := aShortName;
  FFullPath := aFullPath;
  FRects := nil;
  FModBookNames := aBookNames;
  if Length(amodCats) <= 0 then
  begin
    FModCats := DefaultModCats();
  end
  else
    FModCats := aModCats;

  FCachedCover := nil;
  FAuthor := aAuthor;
  FModuleVersion := aModuleVersion;
  FCoverPath := aCoverPath;
  FCachedCoverLock := TCriticalSection.Create;
  FHasStrong := aHasStrong;
end;

function TModuleEntry.Match(aMatchLst: TStringList; var mi: TMatchInfoArray; aAllMatch: Boolean = false): TModMatchTypes;
type
  TBQBookSet = set of byte;

var
  listIx: integer;
  MatchStrUp, StrCatsUp, StrNameUP, StrBNamesUp, StrAuthorUp: String;
  TagFullMatch, NameFullMatch, AuthorFullMatch, NameFound, AuthorFound, TagFound, BookNameFound,
  PartialMacthed, FoundBookNameHits, SearchBookNames, BooksetInit: Boolean;
  p, pf: PChar;
  curHits, allHits: TBQBookSet;
  pbs: ^TBQBookSet;
  fndIx, newfndIx: byte;
  book_cnt, arrSz: integer;
begin
  Result := [];
  if aMatchLst.count = 0 then exit;

  StrNameUP := AnsiLowerCase(FullName);
  StrAuthorUp := AnsiLowerCase(Author);
  StrCatsUp := AnsiLowerCase(ModCats);
  StrBNamesUp := AnsiLowerCase(ModBookNames);

  TagFullMatch := true;
  NameFullMatch := true;
  AuthorFullMatch := true;
  PartialMacthed := true;
  allHits := [];
  // for newfndIx:=1 to 255 do include(allHits,newfndIx);
  SearchBookNames := not(modType in [modtypeBible, modtypeComment]);
  BooksetInit := true;
  for listIx := 0 to aMatchLst.count - 1 do
  begin
    curHits := [];
    MatchStrUp := AnsiLowerCase(aMatchLst[listIx]);

    NameFound := Pos(MatchStrUp, StrNameUP) > 0;
    FixedResult(NameFound, aAllMatch, Result, mmtName, NameFullMatch);

    TagFound := Pos(matchStrUp, StrCatsUp) > 0;
    FixedResult(TagFound, aAllMatch, Result, mmtCat, TagFullMatch);

    AuthorFound := Pos(matchStrUp, StrAuthorUp) > 0;
    FixedResult(AuthorFound, aAllMatch, Result, nmtAuthor, AuthorFullMatch);

    p := PChar(Pointer(StrBNamesUp));
    pf := p + Length(StrBNamesUp);
    FoundBookNameHits := false;
    if SearchBookNames then
    begin

      repeat
        p := StrPosW(p, PChar(Pointer(MatchStrUp)));
        bookNameFound := p <> nil;
        if bookNameFound then
        begin
          FoundBookNameHits := true;
          newfndIx := StrTokenIx(StrBNamesUp, p - PChar(Pointer(StrBNamesUp)) + 1);
          if newfndIx > 0 then
            Include(curHits, newfndIx);

          inc(p, Length(MatchStrUp));

          if not aAllMatch then
          begin
            Include(Result, mmtBookName);
          end;
        end

        until (p > pf) or (not BookNameFound);
        if aAllMatch then
        begin
          // if foundBookNameHits then begin
          if FoundBookNameHits then
          begin
            // if books found
            if BooksetInit then
            begin
              // if it's the first book entry
              allHits := allHits + curHits;
              BooksetInit := false;
            end
            else if not(TagFound or NameFound or AuthorFound) then
            begin
              allHits := allHits * curHits;
            end;
          end
          else if not(TagFound or NameFound or AuthorFound) then
            allHits := [];
          FoundBookNameHits := allHits <> [];
        end
        else
          allHits := allHits + curHits;
      end; // if search books
      if aAllMatch then
      begin
        if (not NameFound) and (not AuthorFound) and (not TagFound) and (not FoundBookNameHits) then
        begin
          PartialMacthed := false;
          break;
        end;
      end
    end; // for

    if aAllMatch then
    begin

      if TagFullMatch then
        Include(Result, mmtCat);
      if NameFullMatch then
        Include(Result, mmtName);
      if AuthorFullMatch then
        Include(Result, nmtAuthor);
      if allHits <> [] then
      begin
        Include(Result, mmtBookName);
      end;

      if Result = [] then
      begin
        if PartialMacthed then
          Result := [mmtPartial]
      end; // not found full match

    end; // if allmatch
    if mmtBookName in Result then
    begin
      fndIx := 0;
      arrSz := Length(mi);
      if aAllMatch then
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
        Exclude(Result, mmtBookName);
    end;

  end;

  function TModuleEntry.VisualSignature(): string;
  begin
    if Length(ShortName) > 0 then
      result := ShortName
    else
      result := ShortPath;
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
    CoverFullPath: string;
    origPicture: TPicture;
  begin
    Result := nil;

    if (CoverPath = '') then
      Exit;

    CoverFullPath := TPath.Combine(ShortPath, CoverPath);
    if not FileExists(CoverFullPath) then
      Exit;

    FCachedCoverLock.Acquire;
    try
      if Assigned(FCachedCover) and (width = FCachedWidth) and (height = FCachedHeight) then
      begin
        Result := FCachedCover;
        Exit;
      end;

      origPicture := TPicture.Create();
      try
        origPicture.LoadFromFile(CoverFullPath);

        FCachedCover := StretchImage(origPicture, width, height);
        FCachedWidth := width;
        FCachedHeight := height;

        Result := FCachedCover;
      finally
        origPicture.Free;
      end;
    finally
      FCachedCoverLock.Release;
    end;

  end;

  procedure TModuleEntry.Init(
    amodType: TModuleType;
    aFullName, aShortName, aShortPath, aFullPath: String;
    aBookNames: String;
    aModCatsLst: TStrings;
    aAuthor: String;
    aModuleVersion: String;
    aCoverPath: String;
    aHasStrong: boolean);
  begin
    FModType := amodType;
    FFullName := aFullName;
    FShortPath := aShortPath;
    FShortName := aShortName;
    FFullPath := aFullPath;
    FModBookNames := aBookNames;
    FRects := nil;
    if aModCatsLst.count <= 0 then
      FModCats := DefaultModCats()
    else
      FModCats := TokensToStr(aModCatsLst, '|');
    FAuthor := aAuthor;
    FModuleVersion := aModuleVersion;
    FCoverPath := aCoverPath;
    FCachedCover := nil;
    FCachedCoverLock := TCriticalSection.Create;
    FHasStrong := aHasStrong;
  end;

  { TCachedModules }

  procedure TCachedModules.Assign(source: TCachedModules);
  begin
    Clear();
    CopyRange(source);

    if Assigned(FOnAssignEvent) then
      FOnAssignEvent(Self);
  end;

  procedure TCachedModules.CopyRange(source: TCachedModules);
  var
    I, cnt: integer;
  begin
    cnt := source.count - 1;
    for I := 0 to cnt do
      Add(TModuleEntry.Create(TModuleEntry(source.Items[I])));
  end;

  procedure TCachedModules.SaveToFile(Path: string);
  var
    ModStringList: TStringList;
    I: Integer;
    ModuleEntry: TModuleEntry;
  begin
    ModStringList := TStringList.Create();
    try
      if Count <= 0 then
        Exit;

      ModStringList.Add('v5');

      for I := 0 to Count - 1 do
      begin
        ModuleEntry := TModuleEntry(Self[I]);
        with ModStringList, ModuleEntry do
        begin
          Add(IntToStr(ord(ModType)));
          Add(FullName);
          Add(ShortName);
          Add(ShortPath);
          Add(FullPath);
          Add(ModBookNames);
          Add(ModCats);
          Add(Author);
          Add(CoverPath);
          Add(BoolToStr(HasStrong));
          Add('***');
        end;
      end;

      ModStringList.SaveToFile(Path, TEncoding.UTF8);
    finally
      ModStringList.Free()
    end;
  end;

  function __ModEntryCmp(Item1, Item2: TModuleEntry): integer;
  begin
    result := OmegaCompareTxt(Item1.FullName, Item2.FullName, -1, true);
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
      r := OmegaCompareTxt(name, TModuleEntry(Items[I]).FullName);
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
      (OmegaCompareTxt(name, TModuleEntry(Items[I]).FullName) = 0) do
      dec(I);
    inc(I);
    result := I;
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
      result := OmegaCompareTxt(name, TModuleEntry(Items[I]).FullName, -1, true);
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
      result := CompareText(name, TModuleEntry(Items[I]).ShortPath);
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
      result := CompareText(wsFullPath, Items[I].FullPath);
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
      if result.ShortName = modShortName then
        exit;
      c := count;

      repeat
        result := TModuleEntry(Items[foundIx]);
        inc(foundIx);
      until (foundIx > c) or (OmegaCompareTxt(result.FullName, modName, -1, true) <> 0) or (result.ShortName <> modShortName); // until

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
    s := AnsiLowerCase(Str);
    for I := 0 to c do
    begin
      fnd := (Pos(AnsiLowerCase(tkns[I]), s) > 0);
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

  function ResolveFullPath(Path: String): String;
  var
    Directory, FullPath, Root: string;
    Roots: TArray<String>;
  begin
    Directory := ExtractFileDir(Path);

    if TPath.IsPathRooted(Path) then
      Result := Path;

    Roots := [
      TAppDirectories.Root,
      TLibraryDirectories.Root,
      TLibraryDirectories.Bibles,
      TLibraryDirectories.Books,
      TLibraryDirectories.Commentaries,
      AppConfig.SecondPath];

    for Root in Roots do
    begin
      FullPath := TPath.Combine(Root, Path);
      if FileExists(FullPath) then
      begin
        Result := FullPath;
        Exit;
      end;
    end;
  end;

  function GetCallerEIP(): Pointer; assembler;
  asm
    mov eax,dword ptr [esp]
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

finalization

// S_SevenZip.Free();
JclStopExceptionTracking();
FreeAndNil(g_ExceptionContext);

end.
