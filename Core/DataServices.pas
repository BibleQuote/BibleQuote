unit DataServices;

interface

uses System.Classes, BibleQuoteUtils, DataScanning, Jobs, Bible, AppIni,
  DictInterface, System.Generics.Collections, TagsDb, IOUtils, AppPaths,
  Messages, Windows;

const
  PROCESS_TAGS_LOADED    = WM_USER + 1;
  PROCESS_DICTS_LOADED   = WM_USER + 2;
  PROCESS_MODULES_LOADED = WM_USER + 3;

type
  TDataService = class
  private
    FScanModulesJob: TJob<TModulesData>;
    FScanDictsJob: TJob<TDictData>;
    FLoadTagsJob: TJob<Variant>;

    FModulesData: TModulesData;
    FDictData: TDictData;

    FScanner: TModulesScanner;
    FDictScanner: TDictScanner;

    FCallbackWndHandle: HWND;

    function GetDictionaries(): TList<IDict>;
    function GetBrokenDictionaries(): TList<String>;

    function GetDictTokens(): TBQStringList;
    function GetModules(): TCachedModules;
    function GetBrokenModules(): TList<String>;
  public
    constructor Create(Scanner: TModulesScanner; DictScanner: TDictScanner; CallbackWndHandle: HWND); reintroduce;

    procedure ScanModulesAsync();
    procedure ScanDictsAsync();
    procedure LoadTagsAsync();

    procedure ScanFirstModules();
    function LoadCachedModules(): Boolean;

    function ScanModulesAndWait(): TModulesData;
    function ScanDictsAndWait(): TDictData;
    procedure LoadTagsAndWait();

    property Modules: TCachedModules read GetModules;
    property BrokenModules: TList<String> read GetBrokenModules;
    property Dictionaries: TList<IDict> read GetDictionaries;
    property BrokenDictionaries: TList<String> read GetBrokenDictionaries;
    property DictTokens: TBQStringList read GetDictTokens;
  end;

implementation

constructor TDataService.Create(Scanner: TModulesScanner; DictScanner: TDictScanner; CallbackWndHandle: HWND);
begin
  inherited Create;

  FModulesData := TModulesData.Create;
  FDictData := TDictData.Create;

  FScanner := Scanner;
  FDictScanner := DictScanner;

  FCallbackWndHandle := CallbackWndHandle;
  FLoadTagsJob := TJob<Variant>.Create(
    function(): Variant
    begin
      TagsDbEngine.InitVerseListEngine(TPath.Combine(TAppDirectories.UserSettings, 'TagsDb.bqd'));
    end,
    procedure(Job: TJob<Variant>)
    begin
      if (Job.GetStatus = jsSucceed) then
        PostMessage(CallbackWndHandle, PROCESS_TAGS_LOADED, 0, 0);
    end
  );

  FScanDictsJob := TJob<TDictData>.Create(
    function(): TDictData
    begin
      Result := DictScanner.Scan();
    end,
    procedure(Job: TJob<TDictData>)
    begin
      if (Job.GetStatus = jsSucceed) then
      begin
        FDictData.Assign(Job.Result);

        PostMessage(CallbackWndHandle, PROCESS_DICTS_LOADED, 0, 0);
      end;
    end
  );

  FScanModulesJob := TJob<TModulesData>.Create(
    function(): TModulesData
    begin
      Result := Scanner.Scan();
    end,
    procedure(Job: TJob<TModulesData>)
    begin

      if (Job.GetStatus = jsSucceed) then
      begin
        FModulesData.Assign(Job.Result);

        PostMessage(CallbackWndHandle, PROCESS_MODULES_LOADED, 0, 0);
      end;
    end);
end;

function TDataService.GetModules(): TCachedModules;
begin
  Result := FModulesData.Modules;
end;

function TDataService.GetBrokenModules(): TList<String>;
begin
  Result := FModulesData.BrokenModules;
end;

function TDataService.GetDictionaries(): TList<IDict>;
begin
  Result := FDictData.Dictionaries;
end;

function TDataService.GetBrokenDictionaries(): TList<String>;
begin
  Result := FDictData.BrokenDictionaries;
end;

function TDataService.GetDictTokens(): TBQStringList;
begin
  Result := FDictData.DictTokens;
end;

procedure TDataService.ScanModulesAsync();
begin
  FScanModulesJob.Reset;
  TJobExecutor.RunAsync<TModulesData>(FScanModulesJob);
end;

procedure TDataService.ScanDictsAsync();
begin
  FScanDictsJob.Reset;
  TJobExecutor.RunAsync<TDictData>(FScanDictsJob);
end;

procedure TDataService.LoadTagsAsync();
begin
  FLoadTagsJob.Reset;
  TJobExecutor.RunAsync<Variant>(FLoadTagsJob);
end;

procedure TDataService.ScanFirstModules();
var
  LoadBook: TBible;
  Scanner: TModulesScanner;
begin
  LoadBook := TBible.Create();
  Scanner := TModulesScanner.Create(LoadBook, 5 {Load max 5 books});
  Scanner.SecondDirectory := AppConfig.SecondPath;

  Modules.CopyRange(Scanner.Scan().Modules);
end;

function TDataService.LoadCachedModules(): Boolean;
begin
  Result := FScanner.TryLoadCachedModules(FModulesData);
end;

function TDataService.ScanModulesAndWait(): TModulesData;
begin
  if (FScanModulesJob.Status = jsRunning) then
    FScanModulesJob.WaitForComplete
  else if (FScanModulesJob.Status = jsPending) then
  begin
    ScanModulesAsync;
    FScanModulesJob.WaitForComplete;
  end;

  Result := FScanModulesJob.Result;
end;

function TDataService.ScanDictsAndWait(): TDictData;
begin
  if (FScanDictsJob.Status = jsRunning) then
    FScanDictsJob.WaitForComplete
  else if (FScanDictsJob.Status = jsPending) then
  begin
    ScanDictsAsync;
    FScanDictsJob.WaitForComplete;
  end;

  Result := FScanDictsJob.Result;
end;

procedure TDataService.LoadTagsAndWait();
begin
  if (FLoadTagsJob.Status = jsRunning) then
    FLoadTagsJob.WaitForComplete
  else if (FLoadTagsJob.Status = jsPending) then
  begin
    LoadTagsAsync;
    FLoadTagsJob.WaitForComplete;
  end;
end;

end.
