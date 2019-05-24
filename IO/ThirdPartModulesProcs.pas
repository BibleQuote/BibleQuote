unit ThirdPartModulesProcs;

interface

uses Classes, Messages, Windows;

const
  PROCESS_DOWNLOADED_REESTRY = WM_USER + 1;
  PROCESS_DOWNLOADED_MODULE  = WM_USER + 2;
  SET_STATUS_PENDING         = WM_USER + 3;
  SET_STATUS_NOTDOWNLOADED   = WM_USER + 4;
  ERROR_DOWNLOADING          = WM_USER + 5;

type

  TDownloadedFileRec = record
    FilePath: String;
  end;
  PDownloadedFileRec = ^TDownloadedFileRec;

  TErrorDownloadRec = record
    FilePath: String;
  end;
  PErrorDownloadRec = ^TErrorDownloadRec;


  TUpdateModuleRec = record
    FilePath: String;
    Caption: String;
    ModuleType: Integer;
  end;
  PUpdateModuleRec = ^TUpdateModuleRec;


  TThirdPartModulesDownload = class(TThread)
  private
    FUrls: TArray<String>;
    FDestFile: String;
    FCallbackWndHandle: HWND;

    function FormDownloadedFilePath(): String;
    function TryLoadFile(aUrl, aFilePath: String): Boolean;
    procedure SendDownloadedFileInfo(aDownloadedFilePath: String); virtual;
    procedure SendErrorDownloaded(); virtual;
    function CreateErrorDownloadRec(): PErrorDownloadRec;
    function CreateDownloadFileRec(aDownloadedFilePath: String): PDownloadedFileRec;
  public
    constructor Create(CreateSuspennded: Boolean; aUrls: TArray<String>;
        const aDestFile: String; aCallbackWndHandle: HWND);
    procedure Execute; override;
  end;

  TThirdPartModuleDownload = class(TThirdPartModulesDownload)
  private
    FCaption: String;
    FModuleType: Integer;

    procedure SendDownloadedFileInfo(aDownloadedFilePath: String); override;
    procedure SendErrorDownloaded(); override;
    procedure SendSetStatusPending();
    procedure SendSetStatusNotDownloaded();
    function CreateUpdateModuleRec(aDownloadedFilePath: String = ''): PUpdateModuleRec;
  public
    constructor Create(CreateSuspennded: Boolean; aUrls: TArray<String>;
        const aDestFile, aCaption: String; aModuleType: Integer; aCallbackWndHandle: HWND);

    procedure Execute; override;
  end;

implementation

{ TThirdPartModulesDownload }
uses IOUtils, UrlMon, IOProcs, SysUtils;

constructor TThirdPartModulesDownload.Create(CreateSuspennded: Boolean;
  aUrls: TArray<String>; const aDestFile: String; aCallbackWndHandle: HWND);
begin
  inherited Create(CreateSuspennded);

  FUrls := aUrls;
  FDestFile := aDestFile;
  FCallbackWndHandle := aCallbackWndHandle;
end;

function TThirdPartModulesDownload.CreateDownloadFileRec(
  aDownloadedFilePath: String): PDownloadedFileRec;
var
  DownloadedFileRec: PDownloadedFileRec;
begin
  New(DownloadedFileRec);
  with DownloadedFileRec^ do begin
    FilePath := aDownloadedFilePath;
  end;

  Result := DownloadedFileRec;
end;

function TThirdPartModulesDownload.CreateErrorDownloadRec(): PErrorDownloadRec;
var
  ErrorDownloadRec: PErrorDownloadRec;
begin

  New(ErrorDownloadRec);
  with ErrorDownloadRec^ do begin
    FilePath := FDestFile;
  end;

  Result := ErrorDownloadRec;
end;

procedure TThirdPartModulesDownload.Execute;
var
  i: Integer;
  FileDownloaded: Boolean;
  DownloadedFilePath: String;
begin

  DownloadedFilePath := FormDownloadedFilePath();
  FileDownloaded := False;

  for I := 0 to Length(FUrls) do
  begin
    if TryLoadFile(FUrls[i], DownloadedFilePath) then
    begin
      FileDownloaded := True;
      break;
    end;
  end;


  if FileDownloaded then
    SendDownloadedFileInfo(DownloadedFilePath)
  else
    SendErrorDownloaded();


end;

function TThirdPartModulesDownload.FormDownloadedFilePath(): String;
var
  aPath: String;
begin
  aPath:= ExtractFilePath(FDestFile);

  if not DirectoryExists(aPath) then
    aPath := GetTempDirectory();

  Result := TPath.Combine(aPath, FDestFile);

end;

procedure TThirdPartModulesDownload.SendDownloadedFileInfo(
  aDownloadedFilePath: String);
var
  DownloadedFileRec: PDownloadedFileRec;
begin
  DownloadedFileRec := CreateDownloadFileRec(aDownloadedFilePath);

  PostMessage( FCallbackWndHandle, PROCESS_DOWNLOADED_REESTRY, Integer(DownloadedFileRec), 0);
end;

procedure TThirdPartModulesDownload.SendErrorDownloaded();
var
  ErrorDownloadRec: PErrorDownloadRec;
begin
  ErrorDownloadRec := CreateErrorDownloadRec();

  PostMessage( FCallbackWndHandle, ERROR_DOWNLOADING, Integer(ErrorDownloadRec), 0);
end;

function TThirdPartModulesDownload.TryLoadFile(aUrl,
  aFilePath: String): Boolean;
begin


  try
    URLDownloadToFile(nil,
                      PChar(aUrl),
                      PChar(aFilePath ),
                      0,
                      nil);
    Result := True;
  except
    Result := False;
  end;

end;

{ TThirdPartModuleDownload }

constructor TThirdPartModuleDownload.Create(CreateSuspennded: Boolean; aUrls: TArray<String>;
        const aDestFile, aCaption: String; aModuleType: Integer; aCallbackWndHandle: HWND);
begin
  inherited Create(CreateSuspennded, aUrls, aDestFile, aCallbackWndHandle);

  FCaption := aCaption;
  FModuleType := aModuleType;

  SendSetStatusPending();
end;


function TThirdPartModuleDownload.CreateUpdateModuleRec(aDownloadedFilePath: String): PUpdateModuleRec;
var
  UpdateModuleRec: PUpdateModuleRec;

begin
    New(UpdateModuleRec);
    with UpdateModuleRec^ do begin

      Caption := FCaption;
      ModuleType := FModuleType;

      if not aDownloadedFilePath.IsEmpty then
        FilePath := aDownloadedFilePath;
    end;

    Result := UpdateModuleRec;
end;

procedure TThirdPartModuleDownload.Execute;
begin
  inherited ;

end;

procedure TThirdPartModuleDownload.SendDownloadedFileInfo(
  aDownloadedFilePath: String);
var
  UpdateModuleRec: PUpdateModuleRec;
begin
  UpdateModuleRec := CreateUpdateModuleRec(aDownloadedFilePath);

  PostMessage( FCallbackWndHandle, PROCESS_DOWNLOADED_MODULE, Integer(UpdateModuleRec), 0);
end;

procedure TThirdPartModuleDownload.SendErrorDownloaded();
begin
  inherited;

  SendSetStatusNotDownloaded();
end;

procedure TThirdPartModuleDownload.SendSetStatusNotDownloaded();
var
  UpdateModuleRec: PUpdateModuleRec;
begin
  UpdateModuleRec := CreateUpdateModuleRec();

  PostMessage( FCallbackWndHandle, SET_STATUS_NOTDOWNLOADED, Integer(UpdateModuleRec), 0);
end;

procedure TThirdPartModuleDownload.SendSetStatusPending;
var
  UpdateModuleRec: PUpdateModuleRec;
begin
  UpdateModuleRec := CreateUpdateModuleRec();

  PostMessage( FCallbackWndHandle, SET_STATUS_PENDING, Integer(UpdateModuleRec), 0);
end;

end.
