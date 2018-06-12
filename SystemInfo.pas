unit SystemInfo;

interface

uses Windows;

function WindowsUserName(const aDefault: string = 'default'): string;

implementation

function WindowsUserName(const aDefault: string = 'default'): string;
const
  maxUserNameLen = 254;
var
  userName      : string;
  dwUserNameLen : DWord;
begin
  dwUserNameLen := maxUserNameLen - 1;
  SetLength(userName, maxUserNameLen);
  GetUserName(PChar(userName), dwUserNameLen);
  SetLength(userName, dwUserNameLen);
  Result := userName;

  if Result = '' then
    Result := aDefault;
end;

end.
