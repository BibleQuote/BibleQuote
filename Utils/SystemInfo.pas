unit SystemInfo;

interface

uses ShlObj, Windows, COperatingSystemInfo, JclSysInfo, SysUtils;

function GetMyDocuments: string;
function OSinfo(): TOperatingSystemInfo;
function WinInfoString(): string;

implementation

var
  _osInfo: TOperatingSystemInfo = nil;

function GetWindowsProductString: string;
begin
  Result := GetWindowsVersionString;
  if GetWindowsEditionString <> '' then
    Result := Result + ' ' + GetWindowsEditionString;
end;

function GetMyDocuments: string;
var
  path: string;
begin
  path := GetPersonalFolder();
  if (path = '') then
    path := GetAppdataFolder();

  Result := path;
end;

function OSinfo(): TOperatingSystemInfo;
begin
  if not assigned(_osInfo) then
  begin
    _osInfo := TOperatingSystemInfo.Create(nil);
    _osInfo.Active := true;
  end;
  result := _osInfo;

end;

function WinInfoString(): string;
{$J+}
const
  win_info: string = '';
var
  osprop: TOperatingSystemProperties;
{$J-}
begin
  if Length(win_info) = 0 then
  begin
    try
      osprop := OSinfo().OperatingSystemProperties;

      win_info := osprop.Caption;
      if Length(osprop.CSDVersion) > 0 then
        win_info := Format('%s (%s)', [win_info, osprop.CSDVersion]);
      if Length(osprop.OSLanguageAsString) > 0 then
        win_info := Format('%s (OSLang: %s[%d])',
          [win_info, osprop.OSLanguageAsString, osprop.OSLanguage]);
      win_info := Format('%s (SP: %d.%d)',
        [win_info, osprop.ServicePackMajorVersion, osprop.ServicePackMinorVersion]);
    except
      win_info := GetWindowsProductString() + ' ' + GetWindowsServicePackVersionString();
    end;

    if IsWindows64() then
      win_info := win_info + ' (64bit)'
    else
      win_info := win_info + ' (32bit)';

  end;

  result := win_info;

end;

initialization

finalization
  if Assigned(_osInfo) then
    FreeAndNil(_osInfo);

end.
