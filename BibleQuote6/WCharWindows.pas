unit WCharWindows;

interface

Uses
  Windows, SysUtils, TNTSysUtils, Classes;

function WindowsUserName (const aDefault: WideString = 'default'): WideString;
function WindowsDirectory: WideString;
function WindowsTempDirectory: WideString;
function WStrMessageBox (aMessage: WideString; aTitle: WideString = 'Message'; aButtons: Cardinal = 0; aHWND: HWND = 0): Integer; overload;
function WStrMessageBox (aInteger: Integer; aTitle: WideString = 'Message'; aButtons: Cardinal = 0; aHWND: HWND = 0): Integer; overload;
function ReadFileSize (const aFileName: WideString): Cardinal;

implementation

function WindowsUserName (const aDefault: WideString = 'default'): WideString;
var
  dWBuffer: WideString;
  dABuffer: String;
  dLength: Cardinal;
begin
  dLength := 0;

  if Win32PlatformIsUnicode then
  begin
    Windows.GetUserNameW (PWideChar (dWBuffer), dLength);
    dWBuffer := StringOfChar (' ', dLength+1);
    Windows.GetUserNameW (PWideChar (dWBuffer), dLength);
    SetLength (dWBuffer, dLength);
    Result := Trim (dWBuffer);

  end else
  begin
    Windows.GetUserNameA (PChar (dABuffer), dLength);
    dABuffer := StringOfChar (' ', dLength+1);
    Windows.GetUserNameA (PChar (dABuffer), dLength);
    SetLength (dABuffer, dLength);
    Result := Trim (dABuffer);

  end;

  if Result = '' then
    Result := aDefault;

end;

function WindowsTempDirectory: WideString;
var
  dWBuffer: WideString;
  dABuffer: String;
  dLength: Cardinal;
begin
  if Win32PlatformIsUnicode then
  begin
    dLength := Windows.GetTempPathW (0, PWideChar (dWBuffer));
    dWBuffer := StringOfChar (' ', dLength+1);
    dLength := Windows.GetTempPathW (dLength+1, PWideChar (dWBuffer));
    SetLength (dWBuffer, dLength);
    Result := dWBuffer;

  end else
  begin
    dLength := Windows.GetTempPathA (0, PChar (dABuffer));
    dABuffer := StringOfChar (' ', dLength+1);
    dLength := Windows.GetTempPathA (dLength+1, PChar (dABuffer));
    SetLength (dABuffer, dLength);
    Result := dABuffer;

  end;

  if Result [Length (Result)] <> '\' then
    Result := Result + '\';
end;

function WindowsDirectory: WideString;
var
  dWBuffer: WideString;
  dABuffer: String;
  dLength: Cardinal;
begin
  if Win32PlatformIsUnicode then
  begin
    dLength := Windows.GetWindowsDirectoryW (PWideChar (dWBuffer), 0);
    dWBuffer := StringOfChar (' ', dLength+1);
    dLength := Windows.GetWindowsDirectoryW (PWideChar (dWBuffer), dLength+1);
    SetLength (dWBuffer, dLength);
    Result := dWBuffer;

  end else
  begin
    dLength := Windows.GetWindowsDirectoryA (PChar (dABuffer), 0);
    dABuffer := StringOfChar (' ', dLength+1);
    dLength := Windows.GetWindowsDirectoryA (PChar (dABuffer), dLength+1);
    SetLength (dABuffer, dLength);
    Result := dABuffer;

  end;

  if Result [Length (Result)] <> '\' then
    Result := Result + '\';
end;

function WStrMessageBox (aMessage: WideString; aTitle: WideString = 'Message'; aButtons: Cardinal = 0; aHWND: HWND = 0): Integer; overload;
var
  dAMessage: String;
  dATitle: String;
begin
  if Win32PlatformIsUnicode then
  begin
    Result := Windows.MessageBoxW (aHWND, PWideChar (aMessage), PWideChar (aTitle), aButtons);
  end else
  begin
    dAMessage := aMessage;
    dATitle := aTitle;
    Result := Windows.MessageBoxA (aHWND, PChar (dAMessage), PChar (dATitle), aButtons);
  end;

end;

function WStrMessageBox (aInteger: Integer; aTitle: WideString = 'Message'; aButtons: Cardinal = 0; aHWND: HWND = 0): Integer; overload;
var
  dAMessage: String;
  dATitle: String;
begin
  if Win32PlatformIsUnicode then
  begin
    Result := Windows.MessageBoxW (aHWND, PWideChar (WideString (IntToStr (aInteger))), PWideChar (aTitle), aButtons);
  end else
  begin
    dAMessage := IntToStr (aInteger);
    dATitle := aTitle;
    Result := Windows.MessageBoxA (aHWND, PChar (dAMessage), PChar (dATitle), aButtons);
  end;

end;

// Пока что ленивый вариант.
function ReadFileSize (const aFileName: WideString): Cardinal;
var
  dFile: TFileStream;
begin
  dFile := nil;

  try
    Result := 0;
    dFile := TFileStream.Create (aFileName, fmOpenRead);
    Result := dFile.Size;
  finally
    dFile.Free;
  end;
end;

end.
