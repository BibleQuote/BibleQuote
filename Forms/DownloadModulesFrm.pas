unit DownloadModulesFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, ThirdPartModulesProcs, SyncObjs,
  System.JSON, Generics.Collections, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.ToolWin, Vcl.Menus;

const
  MYBIBLE_URLS: TArray<String> = [
    'https://dl.dropbox.com/s/peatcjj6azrnj0u/registry.zip',
    'http://mybible.interbiblia.org/registry.zip',
    'http://m.ph4.ru/registry.zip',
    'http://files.redhost.info/files/609/registry.zip'
  ];


type

  TThirdPartyModuleTypes = (tpmtUnknown, tpmtBible, tpmtCommentary, tpmtDictionary);
  TThirdPartyStatuses = (tpsInstalled, tpsNotDownloaded, tpsPending);

  TThirdPartyModule = class
  private
    FStatus: TThirdPartyStatuses;
    FCaption: String;
    FTitle: String;
    FComment: String;
    FSize: String;
    FDate: String;
    FFileName: String;
    FUrls: TArray<String>;
    FModuleType: TThirdPartyModuleTypes;

    function GetModuleType(aFileName: String): TThirdPartyModuleTypes;
    function StatusToString(): String;
  public
    constructor Create(aCaption, aTitle, aComment, aDate, aSize, aFileName: String; aUrls: TArray<String>);

    property Status: TThirdPartyStatuses read FStatus write FStatus;
    property StatusStr: String read StatusToString;
    property Caption: String read FCaption;
    property Title: String read FTitle;
    property Comment: String read FComment;
    property Size: String read FSize;
    property Date: String read FDate;
    property FileName: String read FFileName;
    property Urls: TArray<String> read FUrls;

    property ModuleType: TThirdPartyModuleTypes read FModuleType;

  end;

  TThirdPartyPair = TPair<String, TThirdPartyModule>;
  TThirdPartyModules = TList<TThirdPartyPair>;
  THosts = TDictionary<String, String>;

  TDownloadModulesForm = class(TForm)
    sbModules: TStatusBar;
    tcModules: TTabControl;
    lvModules: TListView;
    ToolBar1: TToolBar;
    tbtnDownloadModule: TToolButton;
    imgCollection: TImageCollection;
    vimgIcons: TVirtualImageList;
    pmModules: TPopupMenu;
    miDownloadModule: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure lvModulesData(Sender: TObject; Item: TListItem);
    procedure tcModulesChange(Sender: TObject);
    procedure tbtnDownloadModuleClick(Sender: TObject);
    procedure miDownloadModuleClick(Sender: TObject);
  private
    { Private declarations }
    FUpdateModuleListCriticalSection: TCriticalSection;
    FUpdateModuleStatusCriticalSection: TCriticalSection;
    FBibleModules: TThirdPartyModules;
    FCommentaryModules: TThirdPartyModules;
    FDictionaryModules: TThirdPartyModules;
    FHosts: THosts;

    procedure InitTabs();
    procedure TranslateForm();
    procedure UpdateModuleList();
    procedure TryLoadModuleInfo(aUrls: TArray<String>; aDestFile: String);
    procedure TryDownloadModule(aModule: TThirdPartyModule);
    procedure UpdateModuleListFromRegistry(aDownloadedFile: String);
    procedure OnProcessedDownloadedRegistryMessage(var Msg: TMessage); message PROCESS_DOWNLOADED_REESTRY;
    procedure OnProcessDownloadedModuleMessage(var Msg: TMessage); message PROCESS_DOWNLOADED_MODULE;
    procedure OnSetStatusPendingMessage(var Msg: TMessage); message SET_STATUS_PENDING;
    procedure OnSetStatusNotDownloadedMessage(var Msg: TMessage); message SET_STATUS_NOTDOWNLOADED;
    function ExtractRegisterJson(aDownloadedFile: String): TJsonObject;
    procedure ExtractSqliteFile(aDownloadedFile, aDestFilePath: String);
    procedure UploadRegisterJsonDataToList(aJson: TJsonObject);
    procedure UploadModuleJsonDataToList(aModuleJson: TJsonObject);
    procedure ProcesseDownloadedModule(aCaption: String; aModuleType: TThirdPartyModuleTypes; aDownloadedFilePath: String);
    procedure SetModuleStatus(aCaption: String; aModuleType: TThirdPartyModuleTypes;
                        aStatus: TThirdPartyStatuses);
    procedure ClearThirdPartModules(); overload;
    procedure ClearThirdPartModules(aThirdPartyModules: TThirdPartyModules); overload;
    function SelectModules(aModuleType: TThirdPartyModuleTypes): TThirdPartyModules;
    function SelectCurrentModules(): TThirdPartyModules;
    function GetCurrentDisplayedModuleType(): TThirdPartyModuleTypes;
    function FormModuleUrl(aModuleUrls: TArray<String>; aHosts: THosts): TArray<String>;
    function FindModule(aCaption: String; aModuleType: TThirdPartyModuleTypes): TThirdPartyModule; overload;
    function FindModule(aIndex: Integer; aModuleType: TThirdPartyModuleTypes): TThirdPartyModule; overload;
    function GetModuleDir(aModuleType: TThirdPartyModuleTypes): String;
    function GetModulePath(aModule: TThirdPartyModule): String;
    function AppendSQLiteExt(aFileName: String): String;
    function FindOutModuleStatus(aModule: TThirdPartyModule): TThirdPartyStatuses;
  public
    { Public declarations }

  end;

var
  DownloadModulesForm: TDownloadModulesForm;

implementation

{$R *.dfm}
uses BibleQuoteUtils, IOUtils, IOProcs, StrUtils, SevenZipHelper, SevenZipVCL,
  System.JSON.Readers, StringProcs, RegularExpressions, SelectEntityType,
  JsonProcs, AppPaths;

procedure TDownloadModulesForm.ClearThirdPartModules;
begin
  ClearThirdPartModules(FBibleModules);
  ClearThirdPartModules(FCommentaryModules);
  ClearThirdPartModules(FDictionaryModules);
end;

function TDownloadModulesForm.AppendSQLiteExt(aFileName: String): String;
const
  SQLiteExt = '.SQLite3';
begin
  Result := aFileName;

  if ExtractFileExt(aFileName) <> SQLiteExt then
    Result := Result + SQLiteExt;

end;

procedure TDownloadModulesForm.ClearThirdPartModules(
  aThirdPartyModules: TThirdPartyModules);
var
  Pair: TThirdPartyPair;
begin
  for Pair in aThirdPartyModules do
    Pair.Value.Free;
end;

function TDownloadModulesForm.ExtractRegisterJson(
  aDownloadedFile: String): TJsonObject;
const
  RegistryJson = 'registry.json';
var
  Stream: TMemoryStream;
  JsonString : String;
begin

  Stream := TMemoryStream.Create;
  try
    ExtractZipToStream(aDownloadedFile, RegistryJson, Stream);

    JsonString := StreamToString(Stream, TEncoding.UTF8);
    Result := TJSONObject.ParseJSONValue(JsonString) as TJsonObject;

  finally
    Stream.Free;

  end;

end;



procedure TDownloadModulesForm.ExtractSqliteFile(
  aDownloadedFile, aDestFilePath: String);
const
  SqliteFile = '.SQLite3';
var
  Stream: TFileStream;
  Directory: String;
begin
  Directory := ExtractFileDir(aDestFilePath);
  if not DirectoryExists(Directory) then
  begin
    CreateDir(Directory);
  end;

  Stream := TFileStream.Create(aDestFilePath, fmCreate);
  try
    ExtractZipToStream(aDownloadedFile, SqliteFile, Stream);
  finally
    Stream.Free;
  end;
end;

function TDownloadModulesForm.FindModule(aCaption: String;
  aModuleType: TThirdPartyModuleTypes): TThirdPartyModule;
var
  Modules: TThirdPartyModules;
  Pair: TThirdPartyPair;
begin
  Result := nil;

  Modules := SelectModules(aModuleType);

  if not Assigned(Modules) then exit;

  for Pair in Modules do
    if Pair.Key = aCaption then
    begin
      Result := Pair.Value;
      break;
    end;

end;

function TDownloadModulesForm.FindModule(aIndex: Integer;
  aModuleType: TThirdPartyModuleTypes): TThirdPartyModule;

var
  Modules: TThirdPartyModules;
begin

  Result := nil;

  Modules := SelectModules(aModuleType);

  if not Assigned(Modules) then exit;

  if aIndex >= Modules.Count then exit;

  Result := Modules[aIndex].Value;

end;

function TDownloadModulesForm.FindOutModuleStatus(
  aModule: TThirdPartyModule): TThirdPartyStatuses;
var
  ProspectiveModulePath : String;
begin
  ProspectiveModulePath := GetModulePath(aModule);

  if FileExists(ProspectiveModulePath) then
    Result := tpsInstalled
  else
    Result := tpsNotDownloaded;

end;

procedure TDownloadModulesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDownloadModulesForm.FormCreate(Sender: TObject);
begin
  FUpdateModuleListCriticalSection:= TCriticalSection.Create();
  FUpdateModuleStatusCriticalSection:= TCriticalSection.Create();
  FBibleModules := TThirdPartyModules.Create();
  FCommentaryModules := TThirdPartyModules.Create();
  FDictionaryModules := TThirdPartyModules.Create();
  FHosts := THosts.Create();

  InitTabs();

end;

procedure TDownloadModulesForm.FormDestroy(Sender: TObject);
begin
  FUpdateModuleListCriticalSection.Free;
  FUpdateModuleStatusCriticalSection.Free;

  ClearThirdPartModules();

  FreeAndNil(FBibleModules);
  FreeAndNil(FCommentaryModules);
  FreeAndNil(FDictionaryModules);
  FreeAndNil(FHosts);
end;

function TDownloadModulesForm.FormModuleUrl(aModuleUrls: TArray<String>;
  aHosts: THosts): TArray<String>;
var
  Options: TRegExOptions;
  RegEx: TRegEx;
  MatchCollection: TMatchCollection;
  i: Integer;
  Group, FileName: String;
  Url: String;
begin
  Result := aModuleUrls;

  Options := [roSingleLine];

  RegEx := TRegEx.Create('^{(?P<alias>.*?)}(?P<file>.*?)$', Options);

  for I := 0 to Length(aModuleUrls) -1  do
  begin
    Url := aModuleUrls[i];
    if not RegEx.IsMatch(Url) then exit;

    MatchCollection := RegEx.Matches(aModuleUrls[i]);

    Group := MatchCollection[0].Groups.Item[1].Value;
    FileName := MatchCollection[0].Groups.Item[2].Value;

    if aHosts.ContainsKey(Group) then
      Result[i] := Format(aHosts[Group], [FileName]);

  end;

end;

procedure TDownloadModulesForm.FormShow(Sender: TObject);
begin
  TranslateForm();

  UpdateModuleList();
end;

function TDownloadModulesForm.GetCurrentDisplayedModuleType: TThirdPartyModuleTypes;
begin
  Result := tpmtUnknown;

  if tcModules.TabIndex < 0  then exit;

  Result := TThirdPartyModuleTypes(tcModules.Tabs.Objects[tcModules.TabIndex]);

end;

function TDownloadModulesForm.GetModulePath(aModule: TThirdPartyModule): String;
var
  ModuleDir: String;
begin
  ModuleDir := TPath.Combine(GetModuleDir(aModule.ModuleType), ExtractFileName(aModule.FileName));
  Result := TPath.Combine(ModuleDir, AppendSQLiteExt(aModule.FileName));
end;

function TDownloadModulesForm.GetModuleDir(
  aModuleType: TThirdPartyModuleTypes): String;
begin
  Result := GetTempDirectory();

  case aModuleType of
  tpmtBible: Result := TLibraryDirectories.Bibles;
  tpmtCommentary: Result := TLibraryDirectories.Commentaries;
  tpmtDictionary: Result := TLibraryDirectories.Dictionaries;
  end;

end;

procedure TDownloadModulesForm.InitTabs();
begin
  tcModules.Tabs.AddObject(Lang.Say('StrBibleTranslations'), Pointer(tpmtBible));
  tcModules.Tabs.AddObject(Lang.Say('StrCommentaries'), Pointer(tpmtCommentary));
  tcModules.Tabs.AddObject(Lang.Say('StrAllDictionaries'), Pointer(tpmtDictionary));
end;

procedure TDownloadModulesForm.lvModulesData(Sender: TObject; Item: TListItem);
var
  Module: TThirdPartyModule;
begin

  Module := FindModule(Item.Index, GetCurrentDisplayedModuleType());

  if not Assigned(Module) then exit;

  Item.Caption := Module.StatusStr;
  Item.SubItems.Add(Module.Caption);
  Item.SubItems.Add(Module.Title);
  Item.SubItems.Add(Module.Comment);
  Item.SubItems.Add(Module.Size);
  Item.SubItems.Add(Module.Date);


end;

procedure TDownloadModulesForm.miDownloadModuleClick(Sender: TObject);
var
  Module: TThirdPartyModule;
begin
  if lvModules.ItemIndex < 0 then exit;

  Module := FindModule(lvModules.ItemIndex, GetCurrentDisplayedModuleType());
  if not Assigned(Module) then exit;

  TryDownloadModule(Module);

end;

procedure TDownloadModulesForm.OnProcessedDownloadedRegistryMessage(
  var Msg: TMessage);
var
  DownloadedFileRec: PDownloadedFileRec;
begin

  DownloadedFileRec := PDownloadedFileRec(Msg.WParam);
  try

    UpdateModuleListFromRegistry(DownloadedFileRec^.FilePath);

  finally
    Dispose(DownloadedFileRec);
  end;


end;

procedure TDownloadModulesForm.OnSetStatusNotDownloadedMessage(
  var Msg: TMessage);
var
  UpdateModuleRec: PUpdateModuleRec;
begin

  UpdateModuleRec := PUpdateModuleRec(Msg.WParam);
  try
    with UpdateModuleRec^ do
      SetModuleStatus(Caption, TThirdPartyModuleTypes(ModuleType), tpsNotDownloaded);

  finally
    Dispose(UpdateModuleRec);
  end;
end;

procedure TDownloadModulesForm.OnSetStatusPendingMessage(var Msg: TMessage);
var
  UpdateModuleRec: PUpdateModuleRec;
begin

  UpdateModuleRec := PUpdateModuleRec(Msg.WParam);
  try
    with UpdateModuleRec^ do
      SetModuleStatus(Caption, TThirdPartyModuleTypes(ModuleType), tpsPending);

  finally
    Dispose(UpdateModuleRec);
  end;
end;

procedure TDownloadModulesForm.OnProcessDownloadedModuleMessage(var Msg: TMessage);
var
  UpdateModuleRec: PUpdateModuleRec;
begin

  UpdateModuleRec := PUpdateModuleRec(Msg.WParam);
  try
    with UpdateModuleRec^ do
      ProcesseDownloadedModule(Caption, TThirdPartyModuleTypes(ModuleType), FilePath);

  finally
    Dispose(UpdateModuleRec);
  end;


end;

function TDownloadModulesForm.SelectCurrentModules: TThirdPartyModules;
begin
  Result := SelectModules(GetCurrentDisplayedModuleType());
end;

function TDownloadModulesForm.SelectModules(
  aModuleType: TThirdPartyModuleTypes): TThirdPartyModules;
begin
  Result := nil;

  case aModuleType of
    tpmtBible: Result:= FBibleModules;
    tpmtCommentary: Result := FCommentaryModules;
    tpmtDictionary: Result := FDictionaryModules;
  end;
end;

procedure TDownloadModulesForm.SetModuleStatus(aCaption: String;
  aModuleType: TThirdPartyModuleTypes; aStatus: TThirdPartyStatuses);
var
    Module: TThirdPartyModule;

begin
    Module := FindModule(aCaption, aModuleType);

    if not Assigned(Module) then exit;

    Module.Status := aStatus;

    if aModuleType = GetCurrentDisplayedModuleType() then
      lvModules.Refresh;

end;

procedure TDownloadModulesForm.tbtnDownloadModuleClick(Sender: TObject);
begin
  miDownloadModule.Click();
end;

procedure TDownloadModulesForm.tcModulesChange(Sender: TObject);
var
  Modules: TThirdPartyModules;
begin
  Modules := SelectCurrentModules();

  if not Assigned(Modules) then exit;
  
  lvModules.Items.Count := Modules.Count;
  lvModules.Refresh;
end;

procedure TDownloadModulesForm.TranslateForm();
begin
  Lang.TranslateControl(Self);

  lvModules.Columns[0].Caption := Lang.Say('StrTPModuleStatus');
  lvModules.Columns[1].Caption := Lang.Say('StrTPModuleCaption');
  lvModules.Columns[2].Caption := Lang.Say('StrTPModuleTitle');
  lvModules.Columns[3].Caption := Lang.Say('StrTPModuleCommentary');
  lvModules.Columns[4].Caption := Lang.Say('StrTPModuleSize');
  lvModules.Columns[5].Caption := Lang.Say('StrTPModuleDate');
end;

procedure TDownloadModulesForm.TryDownloadModule(aModule: TThirdPartyModule);
var
  ModuleUrls: TArray<String>;
begin
  ModuleUrls := FormModuleUrl(aModule.FUrls, FHosts);

  with TThirdPartModuleDownload.Create(True, ModuleUrls, ChangeFileExt(aModule.FileName, '.zip'),
          aModule.Caption, Integer(aModule.ModuleType), Self.Handle) do
  begin
    FreeOnTerminate := True;
    Resume;
  end;
end;

procedure TDownloadModulesForm.TryLoadModuleInfo(aUrls: TArray<String>; aDestFile: String);
begin

  with TThirdPartModulesDownload.Create(True, aUrls, aDestFile, Self.Handle) do
  begin
    FreeOnTerminate := True;
    Resume;
  end;

end;

procedure TDownloadModulesForm.UpdateModuleList;
const
  RegistryFileName = 'registry.zip';
begin

  sbModules.SimpleText := Lang.Say('StrTPModulesStartRegistryDownloading');

  TryLoadModuleInfo(MYBIBLE_URLS, RegistryFileName);
end;

procedure TDownloadModulesForm.UpdateModuleListFromRegistry(
  aDownloadedFile: String);
const
  CREATE_SUBDIR = True;
var
  Json: TJsonObject;

begin
  FUpdateModuleListCriticalSection.Enter;
  try
    sbModules.SimpleText := Lang.Say('StrTPModulesFinishRegistryDownloading');

    Json := ExtractRegisterJson(aDownloadedFile);

    try
      UploadRegisterJsonDataToList(Json);
    finally
      Json.Free;
    end;

    sbModules.SimpleText := Lang.Say('StrTPModulesUpdatingModulesInfoFinished');
  finally
    FUpdateModuleListCriticalSection.Leave;
  end;
end;

procedure TDownloadModulesForm.ProcesseDownloadedModule(aCaption: String;
  aModuleType: TThirdPartyModuleTypes; aDownloadedFilePath: String);
var
  DestFilePath: String;
  Module: TThirdPartyModule;
begin
  FUpdateModuleStatusCriticalSection.Enter;
  try
    sbModules.SimpleText := Lang.Say('StrModuleWasDownloaded');

    Module := FindModule(aCaption, aModuleType);

    if not Assigned(Module) then exit;

    DestFilePath := GetModulePath(Module);

    ExtractSqliteFile(aDownloadedFilePath, DestFilePath);

    Module.Status := tpsInstalled;

    if aModuleType = GetCurrentDisplayedModuleType() then
      lvModules.Refresh;


    sbModules.SimpleText := Format(Lang.Say('StrModuleDownloadedSuccessfully'),
                              [Module.Title]);
  finally
    FUpdateModuleStatusCriticalSection.Leave;
  end;
end;

procedure TDownloadModulesForm.UploadModuleJsonDataToList(
  aModuleJson: TJsonObject);
var
  abr: String;
  des: String;
  cmt: String;
  upd: String;
  siz: String;
  fil: String;
  url: TArray<String>;
  ThirdPartModule: TThirdPartyModule;
  Modules: TThirdPartyModules;
begin

  with aModuleJson do
  begin
    abr := ReadString('abr');
    des := ReadString('des');
    cmt := ReadString('cmt');
    upd := ReadString('upd');
    siz := ReadString('siz');
    fil := ReadString('fil');
    url := ReadStringArray('url');
  end;

  ThirdPartModule:= TThirdPartyModule.Create(abr, des, cmt, upd, siz, fil, url);

  ThirdPartModule.Status := FindOutModuleStatus(ThirdPartModule);

  Modules := SelectModules(ThirdPartModule.ModuleType);

  if Assigned(Modules) then
  begin
    Modules.Add(TThirdPartyPair.Create(abr, ThirdPartModule));

    if ThirdPartModule.ModuleType = GetCurrentDisplayedModuleType() then
      lvModules.Items.Count := Modules.Count;

  end
  else
    ThirdPartModule.Free;

end;

procedure TDownloadModulesForm.UploadRegisterJsonDataToList(aJson: TJsonObject);
var
  DownloadsNode: TJSONArray;
  ModuleJson: TJSONValue;
  HostsNode: TJSONArray;
  HostJson: TJSONValue;
  HostAlias: String;
  HostTempl: String;
begin

  DownloadsNode := aJson.GetArray('downloads');
  for ModuleJson in DownloadsNode do
  begin
    UploadModuleJsonDataToList(ModuleJson as TJsonObject);
  end;

  HostsNode := aJson.Get('hosts').JsonValue as TJSONArray;
  for HostJson in HostsNode do
  begin
    HostAlias := TJsonObject(HostJson).ReadString('alias');
    HostTempl := TJsonObject(HostJson).ReadString('path');
    FHosts.Add(HostAlias, HostTempl);
  end;

end;

{ TThirdPartModule }


constructor TThirdPartyModule.Create(aCaption, aTitle, aComment, aDate, aSize, aFileName: String; aUrls: TArray<String>);
begin
  FStatus := tpsNotDownloaded;

  FCaption := aCaption;
  FTitle := aTitle;
  FComment := aComment;
  FSize := aSize;
  FDate := aDate;
  FFileName := aFileName;
  FUrls := aUrls;

  FModuleType := GetModuleType(aFileName);
end;

function TThirdPartyModule.GetModuleType(aFileName: String): TThirdPartyModuleTypes;
begin

  Result := tpmtUnknown;

  if TSelectEntityType.IsMyBibleDictionary(aFileName) then
    Result := tpmtDictionary
  else if TSelectEntityType.IsMyBibleBible(aFileName) then
    Result := tpmtBible
  else if TSelectEntityType.IsMyBibleCommentary(aFileName) then
    Result := tpmtCommentary;


end;

function TThirdPartyModule.StatusToString: String;
begin
  Result := '';

  case FStatus of
    tpsInstalled: Result := Lang.Say('StrTPModuleStatusInstalled');
    tpsPending: Result := Lang.Say('StrTPModuleStatusPending');
    tpsNotDownloaded: Result := Lang.Say('StrTPModuleStatusNotDownloaded');
  end;
end;

end.
