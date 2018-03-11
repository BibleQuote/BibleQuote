unit WCharWindows;

interface

Uses
  Windows, SysUtils, Classes;

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
  dLength: Cardinal;
begin
  dLength := 0;

  Windows.GetUserNameW (PWideChar (dWBuffer), dLength);
  dWBuffer := StringOfChar (' ', dLength+1);
  Windows.GetUserNameW (PWideChar (dWBuffer), dLength);
  SetLength (dWBuffer, dLength);
  Result := Trim (dWBuffer);

  if Result = '' then
    Result := aDefault;

end;

function WindowsTempDirectory: WideString;
var
  dWBuffer: WideString;
  dLength: Cardinal;
begin
  dLength := Windows.GetTempPathW (0, PWideChar (dWBuffer));
  dWBuffer := StringOfChar (' ', dLength+1);
  dLength := Windows.GetTempPathW (dLength+1, PWideChar (dWBuffer));
  SetLength (dWBuffer, dLength);
  Result := dWBuffer;

  if Result [Length (Result)] <> '\' then
    Result := Result + '\';
end;

function WindowsDirectory: WideString;
var
  dWBuffer: WideString;
  dLength: Cardinal;
begin
  dLength := Windows.GetWindowsDirectoryW (PWideChar (dWBuffer), 0);
  dWBuffer := StringOfChar (' ', dLength+1);
  dLength := Windows.GetWindowsDirectoryW (PWideChar (dWBuffer), dLength+1);
  SetLength (dWBuffer, dLength);
  Result := dWBuffer;

  if Result [Length (Result)] <> '\' then
    Result := Result + '\';
end;

function WStrMessageBox (aMessage: WideString; aTitle: WideString = 'Message'; aButtons: Cardinal = 0; aHWND: HWND = 0): Integer; overload;
begin
    Result := Windows.MessageBoxW (aHWND, PWideChar (aMessage), PWideChar (aTitle), aButtons);
end;

function WStrMessageBox (aInteger: Integer; aTitle: WideString = 'Message'; aButtons: Cardinal = 0; aHWND: HWND = 0): Integer; overload;
begin
  Result := Windows.MessageBoxW (aHWND, PWideChar (WideString (IntToStr (aInteger))), PWideChar (aTitle), aButtons);
end;

// Пока что ленивый вариант.
function ReadFileSize (const aFileName: WideString): Cardinal;
var
  dFile: TFileStream;
begin
  dFile := nil;

  try
    dFile := TFileStream.Create (aFileName, fmOpenRead);
    Result := dFile.Size;
  finally
    dFile.Free;
  end;
end;

end.
