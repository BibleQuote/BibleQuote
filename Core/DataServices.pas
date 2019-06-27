unit DataServices;

interface

uses System.Classes, BibleQuoteUtils, DataScanning, Jobs, Bible, AppIni,
  DictInterface, System.Generics.Collections, TagsDb, IOUtils, AppPaths;

type
  TDataService = class
  private
    FScanModulesJob: TJob<TCachedModules>;
    FOnScanModulesComplete: TNotifyEvent;

    FScanDictsJob: TJob<TDictData>;
    FOnScanDictsComplete: TNotifyEvent;

    FLoadTagsJob: TJob<Variant>;
    FOnLoadTagsComplete: TNotifyEvent;

    FModules: TCachedModules;
    FDictData: TDictData;

    FScanner: TModulesScanner;
    FDictScanner: TDictScanner;

    function GetDictionaries(): TList<IDict>;
    function GetDictTokens(): TBQStringList;
  public
    constructor Create(Scanner: TModulesScanner; DictScanner: TDictScanner); reintroduce;

    procedure ScanModulesAsync();
    procedure ScanDictsAsync();
    procedure LoadTagsAsync();

    procedure ScanFirstModules();
    function LoadCachedModules(): Boolean;

    function ScanModulesAndWait(): TCachedModules;
    function ScanDictsAndWait(): TDictData;
    procedure LoadTagsAndWait();

    property OnScanModulesComplete: TNotifyEvent read FOnScanModulesComplete write FOnScanModulesComplete;
    property OnScanDictsComplete: TNotifyEvent read FOnScanDictsComplete write FOnScanDictsComplete;
    property OnLoadTagsComplete: TNotifyEvent read FOnLoadTagsComplete write FOnLoadTagsComplete;

    property Modules: TCachedModules read FModules;
    property Dictionaries: TList<IDict> read GetDictionaries;
    property DictTokens: TBQStringList read GetDictTokens;
  end;

implementation

constructor TDataService.Create(Scanner: TModulesScanner; DictScanner: TDictScanner);
begin
  inherited Create;

  FModules := TCachedModules.Create;
  FDictData := TDictData.Create;

  FScanner := Scanner;
  FDictScanner := DictScanner;

  FLoadTagsJob := TJob<Variant>.Create(
    function(): Variant
    begin
      TagsDbEngine.InitVerseListEngine(TPath.Combine(TAppDirectories.UserSettings, 'TagsDb.bqd'));
    end,
    procedure(Job: TJob<Variant>)
    begin
      if (Job.GetStatus = jsSucceed) then
      begin
        if Assigned(FOnLoadTagsComplete) then
        begin
          TThread.Synchronize(
            TThread.CurrentThread,
            procedure()
            begin
              FOnLoadTagsComplete(Self);
            end);
        end;
      end;
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

        if Assigned(FOnScanDictsComplete) then
        begin
          TThread.Synchronize(
            TThread.CurrentThread,
            procedure()
            begin
              FOnScanDictsComplete(Self);
            end);
        end;
      end;
    end
  );

  FScanModulesJob := TJob<TCachedModules>.Create(
    function(): TCachedModules
    begin
      Result := Scanner.Scan();
    end,
    procedure(Job: TJob<TCachedModules>)
    begin

      if (Job.GetStatus = jsSucceed) then
      begin
        FModules.Assign(Job.Result);

        if Assigned(FOnScanModulesComplete) then
        begin
          TThread.Synchronize(
            TThread.CurrentThread,
            procedure()
            begin
              FOnScanModulesComplete(Self);
            end);
        end;
      end;
    end);
end;

function TDataService.GetDictionaries(): TList<IDict>;
begin
  Result := FDictData.Dictionaries;
end;

function TDataService.GetDictTokens(): TBQStringList;
begin
  Result := FDictData.DictTokens;
end;

procedure TDataService.ScanModulesAsync();
begin
  FScanModulesJob.Reset;
  TJobExecutor.RunAsync<TCachedModules>(FScanModulesJob);
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

  FModules.CopyRange(Scanner.Scan());
end;

function TDataService.LoadCachedModules(): Boolean;
begin
  Result := FScanner.TryLoadCachedModules(FModules);
end;

function TDataService.ScanModulesAndWait(): TCachedModules;
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
