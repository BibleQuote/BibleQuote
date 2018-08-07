unit FontManager;

interface

uses Controls, Classes, Windows, Forms, SysUtils, BibleQuoteUtils, IOUtils,
     SevenZipHelper;

type
  TFontManager = class
  private
    mDefaultFontName: string;
  public
    function ActivateFont(const fontPath: string): DWORD;
    function PrepareFont(const aFontName, aFontPath: string): Boolean;
    function SuggestFont(aHDC: HDC; const desiredFontName, desiredFontPath: string; desiredCharset: integer): string;

    property DefaultFontName: string read mDefaultFontName write mDefaultFontName;
  end;

implementation

function TFontManager.SuggestFont(aHDC: HDC; const desiredFontName, desiredFontPath: string; desiredCharset: integer): string;
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
      Result := mDefaultFontName;
    Result := FontFromCharset(aHDC, desiredCharset, Result);
  end;
  // if the font is still not found, take the font from the app settings
  if (Length(Result) <= 0) then
    Result := mDefaultFontName;
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
    G_InstalledFonts.AddObject(ExctractName(wsFile), TBQInstalledFontInfo.Create(wsArchive, fileNeedsCleanUp, fontHandle));
  end;
end;

end.
