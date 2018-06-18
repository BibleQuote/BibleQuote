unit SystemInfo;

interface

uses ShlObj, Windows, COperatingSystemInfo, JclSysInfo, SysUtils;

function WindowsUserName(const aDefault: string = 'default'): string;
function GetMyDocuments: string;
function OSinfo(): TOperatingSystemInfo;
function WinInfoString(): string;
function IsWindows64(): Boolean;

implementation

var
  _osInfo: TOperatingSystemInfo = nil;

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

function GetWindowsProductString: string;
begin
  Result := GetWindowsVersionString;
  if GetWindowsEditionString <> '' then
    Result := Result + ' ' + GetWindowsEditionString;
end;

function GetMyDocuments: string;
var
  r: Bool;
  path: array [0 .. Max_Path] of Char;
begin
  r := ShGetSpecialFolderPath(0, path, CSIDL_Personal, false);
  if not r then
    Result := 'C:\TEMP'
  else
    Result := path;
end;

function IsWindows64(): Boolean;
type
  TIsWow64Process = function(aHandle: THandle; var AIsWow64: BOOL) : BOOL; stdcall;
var
  vKernel32Handle: DWORD;
  vIsWow64Process: TIsWow64Process;
  vIsWow64: BOOL;
begin
  // 1) assume that we are not running under Windows 64 bit
  result := false;

  // 2) Load kernel32.dll library
  vKernel32Handle := LoadLibrary('kernel32.dll');
  if (vKernel32Handle = 0) then
    exit; // Loading kernel32.dll was failed, just return

  try

    // 3) Load windows api IsWow64Process
    @vIsWow64Process := GetProcAddress(vKernel32Handle, 'IsWow64Process');
    if not assigned(vIsWow64Process) then
      exit; // Loading IsWow64Process was failed, just return

    // 4) Execute IsWow64Process against our own process
    vIsWow64 := false;
    if (vIsWow64Process(GetCurrentProcess, vIsWow64)) then
      result := vIsWow64; // use the returned value

  finally
    FreeLibrary(vKernel32Handle); // unload the library
  end;
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
