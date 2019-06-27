unit ManageFonts;

interface

uses Controls, Classes, Windows, Forms, SysUtils, IOUtils, BibleQuoteUtils,
     SevenZipHelper, AppIni;

type
  TBQInstalledFontInfo = class
  private
    FPath: string;
    FFileNeedsCleanUp: boolean;
    FHandle: HFont;
  public
    constructor Create(const aPath: string; afileNeedsCleanUp: boolean; aHandle: HFont);
  end;

  TFontManager = class
  public
    function ActivateFont(const fontPath: string): DWORD;
    function PrepareFont(const aFontName, aFontPath: string): Boolean;
    function SuggestFont(const desiredFontName, desiredFontPath: string; desiredCharset: integer): string;
    function InstallFont(const specialPath: string): HRESULT;
  end;

function FontExists(const fontName: string): boolean;
function FontFromCharset(charset: integer; desiredFont: string = ''): string;
procedure cleanUpInstalledFonts();
function ExctractName(const filename: string): string;

type
  PfnAddFontMemResourceEx = function(p1: Pointer; p2: DWORD; p3: PDesignVector; p4: LPDWORD): THandle; stdcall;

type
  PfnRemoveFontMemResourceEx = function(p1: THandle): BOOL; stdcall;

var
  G_AddFontMemResourceEx: PfnAddFontMemResourceEx;
  G_RemoveFontMemResourceEx: PfnRemoveFontMemResourceEx;

var
  FontManager: TFontManager;
  InstalledFonts: TStringList;

  __hitCount: integer;
{$J+}
  const lastPrec: integer = 0;
{$J-}

implementation

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

{ TBQInstalledFontInfo }

constructor TBQInstalledFontInfo.Create(
  const aPath: string;
  afileNeedsCleanUp: boolean;
  aHandle: HFont);
begin
  FHandle := aHandle;
  FFileNeedsCleanUp := afileNeedsCleanUp;
  FPath := aPath;
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

function FontFromCharset(charset: integer; desiredFont: string = ''): string;
var
  logFont: tagLOGFONT;
  fontNameLength: integer;
  fontName: array [0 .. 64] of Char;
  DC: HDC;
begin
  DC := GetDC(GetDesktopWindow);

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
    EnumFontFamiliesEx(DC, logFont, @EnumFontFamExProc, 0, 0);
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
  EnumFontFamiliesEx(DC, logFont, @EnumFontFamExProc, integer(@fontName), 0);
  if (__hitCount > 0) and (fontName[0] <> #0) then
  begin
    result := PChar(@fontName);
    InstalledFonts.Add(result); // long font names workaround
  end
  else
    result := EmptyStr;
end;

function FontExists(const fontName: string): boolean;
begin
  if InstalledFonts.IndexOf(fontName) >= 0 then
  begin
    result := true;
    exit;
  end;
  result := Screen.Fonts.IndexOf(fontName) >= 0;
end;

procedure cleanUpInstalledFonts();
var
  cnt, I: integer;
  ifi: TBQInstalledFontInfo;
  tf: array [0 .. 1023] of Char;
  tempPathLen: integer;
begin
  ifi := nil;
  if not(assigned(InstalledFonts)) then
    exit;
  cnt := InstalledFonts.count - 1;
  if cnt > 0 then
  begin
    tempPathLen := GetTempPath(1023, tf);
    if tempPathLen < 1024 then
      for I := 0 to cnt do
      begin
        try
          ifi := InstalledFonts.Objects[I] as TBQInstalledFontInfo;
          if not assigned(ifi) then
            continue; // for fake installed font - long font names workaround

          if (ifi.FHandle <> 0) and assigned(G_RemoveFontMemResourceEx) then
            G_RemoveFontMemResourceEx(ifi.FHandle)
          else
          begin
            RemoveFontResource(PChar(Pointer(ifi.FPath)));
            if ifi.FFileNeedsCleanUp then
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
    InstalledFonts.Free();
  except
  end;
end;

function TFontManager.SuggestFont(const desiredFontName, desiredFontPath: string; desiredCharset: integer): string;
begin
  if Length(desiredFontName) > 0 then
    if PrepareFont(desiredFontName, desiredFontPath) then
    begin
      // load font if installed
      Result := desiredFontName;
      Exit;
    end;
  // if there is no preferred font or it is not found and the encoding is specified
  if (desiredCharset >= 2) then
  begin
    // find the font with the desired encoding
    if Length(desiredFontName) > 0 then
      Result := desiredFontName
    else
      Result := AppConfig.DefFontName;
    Result := FontFromCharset(desiredCharset, Result);
  end;
  // if the font is still not found, take the font from the app settings
  if (Length(Result) <= 0) then
    Result := AppConfig.DefFontName;
end;

function TFontManager.PrepareFont(const aFontName, aFontPath: string): Boolean;
var
  fontFullPath: string;
begin
  Result := FontExists(aFontName);
  if Result then
    Exit;
  fontFullPath := TPath.Combine(aFontPath, aFontName);
  if FileExistsEx(fontFullPath + '.otf') >= 0 then
    fontFullPath := fontFullPath + '.otf'
  else
    fontFullPath := fontFullPath + '.ttf';

  Result := ActivateFont(fontFullPath) > 0;
end;

function TFontManager.ActivateFont(const fontPath: string): DWORD;
var
  tf: array [0 .. 1023] of Char;
  fileIx, fileSz, tempPathLen: integer;
  wsArchive, wsFile: string;
  pFile: PChar;
  fileHandle: THandle;
  writeResult: BOOL;
  fileNeedsCleanUp: Boolean;
  fontHandle: HFont;
  bytesWritten: DWORD;
begin
  Result := 0;
  fontHandle := 0;
  fileNeedsCleanUp := false;
  wsArchive := fontPath;
  if fontPath[1] = '?' then
  begin
    wsArchive := GetArchiveFromSpecial(fontPath, wsFile);
    fileIx := getSevenZ().GetIndexByFilename(wsFile, @fileSz);
    if (fileIx < 0) or (fileSz <= 0) then
      Exit;
    GetMem(pFile, fileSz);
    try
      getSevenZ().ExtracttoMem(fileIx, pFile, fileSz);
      if getSevenZ().ErrCode <> 0 then
        Exit;
      if (Win32MajorVersion >= 5) and (Assigned(G_AddFontMemResourceEx)) then
      begin
        fontHandle := G_AddFontMemResourceEx(pFile, fileSz, nil, @Result);
      end;
      if Result = 0 then
      begin // failed to load in memory
        tempPathLen := GetTempPath(1023, tf);
        if tempPathLen > 1024 then
          Exit;
        wsArchive := tf + wsFile;
        if not FileExists(wsArchive) then
        begin
          fileHandle := CreateFile(
            PChar(Pointer(wsArchive)),
            GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);

          if fileHandle = INVALID_HANDLE_VALUE then
            Exit;
          try
            writeResult := WriteFile(fileHandle, pFile^, fileSz, bytesWritten, nil);
          finally
            CloseHandle(fileHandle);
          end;
          fileNeedsCleanUp := true;
          if not writeResult then
            Exit;
        end;
      end

    finally
      FreeMem(pFile);
    end;
  end
  else
    wsFile := FileRemoveExtension(ExtractFileName(fontPath));
  if Result = 0 then
    Result := AddFontResource(PChar(Pointer(wsArchive)));

  if Result <> 0 then
  begin
    Screen.Fonts.Add(ExctractName(wsFile));
    InstalledFonts.AddObject(ExctractName(wsFile), TBQInstalledFontInfo.Create(wsArchive, fileNeedsCleanUp, fontHandle));
  end;
end;

function TFontManager.InstallFont(const specialPath: string): HRESULT;
var
  wsName, wsFolder: string;
  rslt: Boolean;
begin
  wsName := ExtractFileName(specialPath);
  wsFolder := ExtractFilePath(specialPath);
  rslt := PrepareFont(FileRemoveExtension(wsName), wsFolder);
  Result := -1 + ord(rslt);
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

initialization
begin
  InstalledFonts := TStringList.Create;
  InstalledFonts.Sorted := true;
  InstalledFonts.Duplicates := dupIgnore;
  load_proc();

  FontManager := TFontManager.Create;
end;

finalization
begin
  FreeAndNil(FontManager);
end;


end.
