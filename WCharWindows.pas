unit WCharWindows;

interface

Uses
  Windows, SysUtils, Classes;

function WStrMessageBox(aMessage: WideString; aTitle: WideString = 'Message'; aButtons: Cardinal = 0; aHWND: HWND = 0): Integer; overload;
function WStrMessageBox(aInteger: Integer; aTitle: WideString = 'Message'; aButtons: Cardinal = 0; aHWND: HWND = 0): Integer; overload;

implementation

function WStrMessageBox(aMessage: WideString; aTitle: WideString = 'Message'; aButtons: Cardinal = 0; aHWND: HWND = 0): Integer; overload;
begin
    Result := Windows.MessageBoxW (aHWND, PWideChar (aMessage), PWideChar (aTitle), aButtons);
end;

function WStrMessageBox(aInteger: Integer; aTitle: WideString = 'Message'; aButtons: Cardinal = 0; aHWND: HWND = 0): Integer; overload;
begin
  Result := Windows.MessageBoxW (aHWND, PWideChar (WideString (IntToStr (aInteger))), PWideChar (aTitle), aButtons);
end;

end.
