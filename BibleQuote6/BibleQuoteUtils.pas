unit BibleQuoteUtils;

interface
uses SevenZipVCL, Contnrs, WideStrings, Windows, SysUtils ;
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
    function GetPassword(aSender: TSevenZip; out aPassword: WideString): boolean;
    procedure InvalidatePassword(const aFile: WideString);
    constructor Create(wsString: WideString);
    destructor Destroy(); override;
  end;

  TBQException = class(Exception)
    mErrCode: Cardinal;
    mWideMsg: WideString;
    constructor CreateFmt(const Msg: string; const Args: array of const);
  end;

  TBQPasswordException = class(TBQException)
    mArchive: WideString;
    mWrongPassword: WideString;
    constructor CreateFmt(const password, module: WideString; const Msg: string; const Args: array of const);
  end;
  TBQInstalledFontInfo=class
    mPath:WideString;
    mFileNeedsCleanUp:boolean;
    mHandle:HFont;
    constructor Create(const aPath:WideString; afileNeedsCleanUp:boolean; aHandle:HFont);
    end;

const
  Crc32Bytes = 4;
  Crc32Start: Cardinal = $FFFFFFFF;
  Crc32Bits = 32;
const
  Crc32Table: array[0..255] of Cardinal = (
    $00000000, $04C11DB7, $09823B6E, $0D4326D9, $130476DC, $17C56B6B, $1A864DB2, $1E475005,
    $2608EDB8, $22C9F00F, $2F8AD6D6, $2B4BCB61, $350C9B64, $31CD86D3, $3C8EA00A, $384FBDBD,
    $4C11DB70, $48D0C6C7, $4593E01E, $4152FDA9, $5F15ADAC, $5BD4B01B, $569796C2, $52568B75,
    $6A1936C8, $6ED82B7F, $639B0DA6, $675A1011, $791D4014, $7DDC5DA3, $709F7B7A, $745E66CD,
    $9823B6E0, $9CE2AB57, $91A18D8E, $95609039, $8B27C03C, $8FE6DD8B, $82A5FB52, $8664E6E5,
    $BE2B5B58, $BAEA46EF, $B7A96036, $B3687D81, $AD2F2D84, $A9EE3033, $A4AD16EA, $A06C0B5D,
    $D4326D90, $D0F37027, $DDB056FE, $D9714B49, $C7361B4C, $C3F706FB, $CEB42022, $CA753D95,
    $F23A8028, $F6FB9D9F, $FBB8BB46, $FF79A6F1, $E13EF6F4, $E5FFEB43, $E8BCCD9A, $EC7DD02D,
    $34867077, $30476DC0, $3D044B19, $39C556AE, $278206AB, $23431B1C, $2E003DC5, $2AC12072,
    $128E9DCF, $164F8078, $1B0CA6A1, $1FCDBB16, $018AEB13, $054BF6A4, $0808D07D, $0CC9CDCA,
    $7897AB07, $7C56B6B0, $71159069, $75D48DDE, $6B93DDDB, $6F52C06C, $6211E6B5, $66D0FB02,
    $5E9F46BF, $5A5E5B08, $571D7DD1, $53DC6066, $4D9B3063, $495A2DD4, $44190B0D, $40D816BA,
    $ACA5C697, $A864DB20, $A527FDF9, $A1E6E04E, $BFA1B04B, $BB60ADFC, $B6238B25, $B2E29692,
    $8AAD2B2F, $8E6C3698, $832F1041, $87EE0DF6, $99A95DF3, $9D684044, $902B669D, $94EA7B2A,
    $E0B41DE7, $E4750050, $E9362689, $EDF73B3E, $F3B06B3B, $F771768C, $FA325055, $FEF34DE2,
    $C6BCF05F, $C27DEDE8, $CF3ECB31, $CBFFD686, $D5B88683, $D1799B34, $DC3ABDED, $D8FBA05A,
    $690CE0EE, $6DCDFD59, $608EDB80, $644FC637, $7A089632, $7EC98B85, $738AAD5C, $774BB0EB,
    $4F040D56, $4BC510E1, $46863638, $42472B8F, $5C007B8A, $58C1663D, $558240E4, $51435D53,
    $251D3B9E, $21DC2629, $2C9F00F0, $285E1D47, $36194D42, $32D850F5, $3F9B762C, $3B5A6B9B,
    $0315D626, $07D4CB91, $0A97ED48, $0E56F0FF, $1011A0FA, $14D0BD4D, $19939B94, $1D528623,
    $F12F560E, $F5EE4BB9, $F8AD6D60, $FC6C70D7, $E22B20D2, $E6EA3D65, $EBA91BBC, $EF68060B,
    $D727BBB6, $D3E6A601, $DEA580D8, $DA649D6F, $C423CD6A, $C0E2D0DD, $CDA1F604, $C960EBB3,
    $BD3E8D7E, $B9FF90C9, $B4BCB610, $B07DABA7, $AE3AFBA2, $AAFBE615, $A7B8C0CC, $A379DD7B,
    $9B3660C6, $9FF77D71, $92B45BA8, $9675461F, $8832161A, $8CF30BAD, $81B02D74, $857130C3,
    $5D8A9099, $594B8D2E, $5408ABF7, $50C9B640, $4E8EE645, $4A4FFBF2, $470CDD2B, $43CDC09C,
    $7B827D21, $7F436096, $7200464F, $76C15BF8, $68860BFD, $6C47164A, $61043093, $65C52D24,
    $119B4BE9, $155A565E, $18197087, $1CD86D30, $029F3D35, $065E2082, $0B1D065B, $0FDC1BEC,
    $3793A651, $3352BBE6, $3E119D3F, $3AD08088, $2497D08D, $2056CD3A, $2D15EBE3, $29D4F654,
    $C5A92679, $C1683BCE, $CC2B1D17, $C8EA00A0, $D6AD50A5, $D26C4D12, $DF2F6BCB, $DBEE767C,
    $E3A1CBC1, $E760D676, $EA23F0AF, $EEE2ED18, $F0A5BD1D, $F464A0AA, $F9278673, $FDE69BC4,
    $89B8FD09, $8D79E0BE, $803AC667, $84FBDBD0, $9ABC8BD5, $9E7D9662, $933EB0BB, $97FFAD0C,
    $AFB010B1, $AB710D06, $A6322BDF, $A2F33668, $BCB4666D, $B8757BDA, $B5365D03, $B1F740B4
    );

function GetArchiveFromSpecial(const aSpecial: WideString): WideString;overload;
function GetArchiveFromSpecial(const aSpecial: WideString; out fileName: WideString): WideString;overload;
function GetCachedModulesListDir(): WideString;
function FileExistsEx(aPath: WideString): integer;
function ArchiveFileSize(wsPath: WideString): integer;
function SpecialIO(const wsFileName: WideString; wsStrings: TWideStrings; obf: Int64; read: boolean = true): boolean;
function FontExists(aHDC: HDC; const wsFontName: WideString): boolean;
function FontFromCharset(aHDC: HDC; charset: integer; wsDesiredFont: WideString = ''): WideString;
function GetCRC32(pData: PByteArray; count: Integer; Crc: Cardinal = 0): Cardinal;
function ExtractModuleName(aModuleSignature:WideString):WideString;
function StrPosW(const Str, SubStr: PWideChar): PWideChar;
function ExctractName(const wsFile:WideString):WideString;
function IsDown(key:integer):boolean;

var S_SevenZip: TSevenZip;
    G_InstalledFonts:TWideStringList;
implementation
uses WCharReader, MultiLanguage, main, Controls;

function GetArchiveFromSpecial(const aSpecial: WideString): WideString; overload;
var pz: Integer;
begin
//строки типа rststrong.bqb??bibleqt.ini в rststrong.bqb
  pz := Pos('??', aSpecial);
  if pz <= 0 then result := EmptyWideStr
  else
    result := Copy(aSpecial, 1, pz - 1);
end;

function GetArchiveFromSpecial(const aSpecial: WideString; out fileName: WideString): WideString; overload;
var pz: Integer;
  correct: integer;
begin
  //строки типа rststrong.bqb??bibleqt.ini в rststrong.bqb и bibleqt.ini
  pz := Pos('??', aSpecial);
  if pz <= 0 then result := EmptyWideStr
  else begin
    correct := Ord(aSpecial[1] = '?') + 1;
    result := Copy(aSpecial, correct, pz - correct);
    fileName := Copy(aSpecial, pz + 2, $FFFFFF);
  end; //else
end; //fn

var __cachedModulesListFolder: WideString;

function GetCachedModulesListDir(): WideString;
begin
  if length(__cachedModulesListFolder) <= 0 then begin

    __cachedModulesListFolder := CreateAndGetConfigFolder();
    __cachedModulesListFolder := ExtractFilePath(
      Copy(__cachedModulesListFolder, 1, length(__cachedModulesListFolder) - 1));
  end;
  result := __cachedModulesListFolder;
end;

function ArchiveFileSize(wsPath: WideString): integer;
var wsArchive, wsFile: WideString;
begin
  Result := -1;
  try
    wsArchive := GetArchiveFromSpecial(wsPath, wsFile);
    S_SevenZip.SZFileName := wsArchive;
    if S_SevenZip.GetIndexByFilename(wsFile, @Result) < 0 then Result := -1;
  except end;

end;

function FileExistsEx(aPath: WideString): integer;
var wsArchive, wsFile: WideString;
begin
  result := -1;
  if length(aPath) < 1 then exit;
  if aPath[1] <> '?' then begin
    result := ord(FileExists(aPath)) - 1; exit; end;
  wsArchive := GetArchiveFromSpecial(aPath, wsFile);
  if (length(wsArchive) <= 0) or (length(wsFile) < 0) then exit;
  try
    S_SevenZip.SZFileName := wsArchive;
    result := S_SevenZip.GetIndexByFilename(wsFile);
  except end;

end;

function SpecialIO(const wsFileName: WideString; wsStrings: TWideStrings; obf: Int64; read: boolean = true): boolean;
var fileHandle: THandle;
  fileSz, readed: Cardinal;
  crcExpected, crcCalculated: Cardinal;
//    rslt:LongBool;
  buf: PWideChar;
  ws: WideString;

  procedure _EncodeDecode(); //простое 64bit xor шифрование
  var i, count: Cardinal;
    pc: PCardinal;
    f, s: Cardinal;
  begin
    count := (fileSz shr 3) - 1;
    f := Cardinal(obf);
    s := PCardinal(pchar(@obf) + 4)^;
    pc := PCardinal(PChar(buf)); //если цикл не сработает
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
    fileHandle := CreateFileW(PWideChar(Pointer(wsFileName)), GENERIC_READ, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
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
    finally (*чтобы не было утечки*)
      CloseHandle(fileHandle);
      FreeMem(buf); end;
  end
  else begin //запись
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

function GetCRC32(pData: PByteArray; count: Integer; Crc: Cardinal = 0): Cardinal;
var
  I: Integer;
begin
  Result := Crc32Start;
  Dec(count);
  for I := 0 to count do begin
    // a 32 bit value shr 24 is a Byte, explictit type conversion to Byte adds an ASM instruction
    Result := Crc32Table[Result shr (CRC32Bits - 8)] xor (Result shl 8) xor pData[I];
  end;
  for I := 0 to Crc32Bytes - 1 do begin
    // a 32 bit value shr 24 is a Byte, explictit type conversion to Byte adds an ASM instruction
    Result := Crc32Table[Result shr (CRC32Bits - 8)] xor (Result shl 8) xor (Crc shr (CRC32Bits - 8));
    Crc := Crc shl 8;
  end;
end;

{ TPasswordPolicy }

constructor TPasswordPolicy.Create(wsString: WideString);

begin
  mPasswordList := TWideStringList.Create();
  LoadFromFile(wsString);
  mUserHash := GetUserHash();
  writeln('хэш: ', mUserHash);
  S_SevenZip.OnGetPassword := GetPassword;
end;

destructor TPasswordPolicy.Destroy;
begin
//nothing
  S_SevenZip.OnGetPassword := nil;
  mPasswordList.Free();
  inherited;
end;

function TPasswordPolicy.GetPassword(aSender: TSevenZip;
  out aPassword: WideString): boolean;
var filename: string;
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
  if (ix < 0) then begin //запрошенный пароль не найден в кэше...
    pwFormShowResult := MainForm.PassWordFormShowModal(aSender.SZFileName,
      aPassword, blSavePwd);
    if (pwFormShowResult = mrOk) and (length(aPassword) > 0) then begin
      s := XorPassword(UTF8Encode(aPassword));
       Writeln(filename, ' ', s);
      mPasswordList.AddObject(WideFormat('%s=%s', [filename, s]), TObject(ord(blSavePwd)));
    end
    else if (pwFormShowResult = mrCancel) then begin
      result := false; exit; end;

  end
  else begin //если найден в кэше
    s := mPasswordList[ix];
    ix := Pos('=', s);
    s := Copy(s, ix + 1, $FFFF);
    pwdLength := length(s) div 2;
    SetLength(pwdEncoded, pwdLength);
    for ix := 1 to pwdLength do begin
      pwdEncoded[ix] := chr(HexDigitVal(Char(s[(ix - 1) * 2 + 1])) * 16
        + HexDigitVal(Char(s[ix * 2])));
    end;
     writeln('найден  ', pwdEncoded);
    pwdEncoded := XorPassword(pwdEncoded, false);
    writeln('после ксора  ', pwdEncoded);
    Flush(output);
    aPassword := UTF8Decode(pwdEncoded);
  end;
  result := true;
end;

function TPasswordPolicy.GetUserHash: int64;
var userFolder: string;
  len : integer;
  data: int64;
  userFolderW:WideString;
begin
  userFolderW:=WideUpperCase( CreateAndGetConfigFolder());
  userFolder := UTF8Encode(userFolderW);
  len := length(userFolder);
  if len<=0 then begin result:=0; exit;end;
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
var ix: integer;
begin
  ix := mPasswordList.IndexOfName(aFile);
  if ix >= 0 then mPasswordList.Delete(ix);
end;

function TPasswordPolicy.LoadFromFile(const fileName: WideString): boolean;
var i, count: integer;
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
  except end;

end; //func LoadFile

procedure TPasswordPolicy.SaveToFile(const filename: WideString);
var i, recordCount: integer;
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

function TPasswordPolicy.XorPassword(aPwd: string; produceHex: boolean = true): string;
var i, j, pwdLength: integer;
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
  mWideMsg := 'Ошибка!';
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

var __hitCount: integer;

function EnumFontFamExProc(lpelfe: PENUMLOGFONTEXW; //logical-font data
  lpntme: PNewTextMetricExW; // physical-font data
  FontType: DWORD; // type of font
  lParam: LPARAM // application-defined data
  ): integer; stdcall;
begin
   result := 1;
  if (lpelfe^.elfLogFont.lfOutPrecision<>OUT_STROKE_PRECIS) and
  (lParam<>0) then exit;

  inc(__hitCount);
  if (lparam <> 0) and (PWideChar(lparam)^ = #0) then
    Move(lpelfe^.elfLogFont.lfFaceName, PWideChar(lparam)^, 32);
end;

function FontFromCharset(aHDC: HDC; charset: integer; wsDesiredFont: WideString = ''): WideString;
var logFont: tagLOGFONTW;
  fontNameLength: integer;
  fontName: array[0..31] of WideChar;
begin
  __hitCount := 0;
  FillChar(logFont, sizeof(logFont), 0);
  FillChar(fontName, 64, 0);
  logFont.lfCharSet := charset;
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
  __hitCount := 0;
  FillChar(logFont, sizeof(logFont), 0);
  FillChar(fontName, 64, 0);
  logFont.lfCharSet := charset;
  EnumFontFamiliesExW(aHDC, logFont, @EnumFontFamExProc, integer(@fontName), 0);
  if (__hitCount > 0) and (fontName[0] <> #0) then result := PWideChar(@fontName)
  else result := EmptyWideStr;
end;


function FontExists(aHDC: HDC; const wsFontName: WideString): boolean;
var logFont: tagLOGFONTW;
  fontNameLength: integer;
begin
  if G_InstalledFonts.IndexOf(wsFontName)>=0 then begin result:=true; exit; end;
  __hitCount := 0;
  FillChar(logFont, sizeof(logFont), 0);
  fontNameLength := Length(wsFontName);
  logFont.lfCharSet := DEFAULT_CHARSET;
  if (fontNameLength > 31) then fontNameLength := 31;
  Move(Pointer(wsFontName)^, logFont.lfFaceName, fontNameLength * 2);
  EnumFontFamiliesExW(aHDC, logFont, @EnumFontFamExProc, 0, 0);
  result := __hitCount > 0;
end;

function ExctractName(const wsFile:WideString):WideString;
var pC, pLastDot:PWideChar;
begin
pC:=PWideChar(Pointer(wsFile));
if (pC=nil) or (pC^=#0) then begin result:=''; exit end;
pLastDot:=nil;
repeat
if pC^='.' then pLastDot:=pC;
inc(pC);
until (pC^=#0);
if pLastDot<>nil then result:=Copy(wsFile, 1, pLastDot-PWideChar(Pointer(wsFile)))
else result:='';
end;

function ExtractModuleName(aModuleSignature:WideString):WideString;
var ipos:integer;
begin
  ipos := Pos(' $$$ ', aModuleSignature);
  if ipos<=0 then begin result:=''; exit end;
  result:= Copy(aModuleSignature,1,  ipos -1);
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
mHandle:=aHandle; mFileNeedsCleanUp:= afileNeedsCleanUp; mPath:=aPath;
end;

function IsDown(key:integer):boolean;
begin
result:=(GetKeyState(key) and  $8000)<>0;
end;

procedure _cleanUpInstalledFonts();
var cnt, i:integer;
    ifi:TBQInstalledFontInfo;
    test:BOOL;
   tf: array[0..1023] of WideChar;
   tempPathLen:integer;
begin
cnt:=G_InstalledFonts.Count-1;
if cnt<0 then exit;
tempPathLen := GetTempPathW(1023, tf);
if tempPathLen > 1024 then exit;
for i:=0 to cnt do begin
  try
  ifi:= G_InstalledFonts.Objects[i] as TBQInstalledFontInfo;
  if ifi.mHandle<>0 then test:=RemoveFontMemResourceEx(ifi.mHandle)
  else begin
    test:=RemoveFontResourceW(PWideChar(Pointer(ifi.mPath)));
    if ifi.mFileNeedsCleanUp then begin
      { TODO -oAlekId -cQA : Добавить безопасное удаление файла шрифта }
    //пока ничего
    end;
  end;
  except end;
end; //for
end;


initialization
   G_InstalledFonts:=TWideStringList.Create;
  S_SevenZip := TSevenZip.Create(nil);
finalization
  _cleanUpInstalledFonts();
  S_SevenZip.Free();
end.

