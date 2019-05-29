unit BackgroundServices;

interface

uses
  Classes, SyncObjs, SysUtils, DictInterface, Windows, BibleQuoteUtils, EngineInterfaces,
  TagsDb, Types, IOUtils, AppPaths, DictLoaderInterface, DictLoaderFabric,
  IOProcs;

type

  TbqWorkerRequiredOperation = (
    wroSleep,
    wroTerminated,
    wroLoadDictionaries,
    wroInitDicTokens,
    wroInitVerseListEngine);

  TbqWorker = class(TThread)

  protected
    mSection: TCriticalSection;
    mEvent, mDoneOperationEvent: TSimpleEvent;
    mDictionariesPath: string;
    mDictionaryTokens: TBQStringList;
    mOperation: TbqWorkerRequiredOperation;

    mBusy: boolean;
    mEngine: IInterface;
    mResult: HRESULT;
    procedure Execute; override;
    function _LoadDictionaries(const aPath: string): HRESULT;
    function getAsynInface(): IbqEngineAsyncTraits;
    function _InitDictionaryItemsList(lst: TBQStringList): HRESULT;
    function _InitVerseListEngine(): HRESULT;
    function GetBusy(): boolean;
    procedure SetBusy(aVal: boolean);

  public
    function LoadDictionaries(const fromPath: string; foreground: boolean): HRESULT;
    function InitDictionaryItemsList(lst: TBQStringList; foreground: boolean = false): HRESULT;
    function InitVerseListEngine(foreground: boolean): HRESULT;
    function WaitUntilDone(dwTime: DWORD): TWaitResult;
    constructor Create(iEngine: IInterface);
    procedure Finalize();
    destructor Destroy; override;
    procedure Resume();
    procedure Suspend();
    property OperationResult: HRESULT read mResult;
    property Busy: boolean read GetBusy write SetBusy;
  end;

implementation

uses SelectEntityType;

procedure TbqWorker.SetBusy(aVal: boolean);
begin
  try
    mSection.Acquire();
    mBusy := aVal;
  finally
    mSection.Release()
  end;

end;

procedure TbqWorker.Suspend;
begin
  TThread(self).Suspend();
end;

function TbqWorker.WaitUntilDone(dwTime: DWORD): TWaitResult;
begin
  result := mDoneOperationEvent.WaitFor(dwTime);
end;

function TbqWorker._InitDictionaryItemsList(lst: TBQStringList): HRESULT;
var
  dicCount, wordCount, dicIx, wordIx: integer;
  hr: HRESULT;
  engine: IbqEngineDicTraits;
  currentDic: IDict;
begin
  result := S_FALSE;
  hr := mEngine.QueryInterface(IbqEngineDicTraits, engine);
  if hr <> S_OK then
    exit;

  if lst = nil then
    lst := TBQStringList.Create
  else
    lst.Clear();
  lst.Sorted := true;
  dicCount := engine.DictionariesCount() - 1;
  for dicIx := 0 to dicCount do
  begin
    currentDic := engine.GetDictionary(dicIx);
    wordCount := currentDic.GetWordCount() - 1;
    for wordIx := 0 to wordCount do
    begin
      lst.Add(currentDic.GetWord(wordIx));
    end;
  end;
  result := S_OK;
end;

function TbqWorker._InitVerseListEngine(): HRESULT;
begin
  try
    TagsDbEngine.InitVerseListEngine(TPath.Combine(TAppDirectories.UserSettings, 'TagsDb.bqd'));
    result := S_OK;
  except
    on e: Exception do
    begin
      result := -2;
    end;
  end;
end;

function TbqWorker._LoadDictionaries(const aPath: string): HRESULT;
var
  FileEntries: TStringDynArray;
  FileEntryPath: String;
  Engine: IbqEngineDicTraits;
  hr: HRESULT;

  i: integer;
  DictLoader: IDictLoader;
  DictType: TDictTypes;
begin
  Result := S_FALSE;
  hr := mEngine.QueryInterface(IbqEngineDicTraits, engine);
  if hr <> S_OK then
    exit;

  FileEntries := TDirectory.GetFileSystemEntries(aPath);
  if (Length(FileEntries) <= 0) then
  begin
      Result := E_NOINTERFACE;
      Exit;
  end;

  for i := 0 to Length(FileEntries) - 1 do
  begin

    FileEntryPath := FileEntries[i];

    DictType := TSelectEntityType.SelectDictType(FileEntryPath);

    DictLoader := TDictLoaderFabric.CreateDictLoader(DictType);

    if not Assigned(DictLoader) then
    begin
      if (IsDirectory(FileEntryPath) and DirectoryExists(FileEntryPath)) then
        _LoadDictionaries(FileEntryPath);

      continue;
    end;

    if not DictLoader.LoadDictionaries(FileEntryPath, Engine) then exit;


  end;

  Result := S_OK;
end;

constructor TbqWorker.Create(iEngine: IInterface);
begin
  mEngine := iEngine;
  mSection := TCriticalSection.Create;
  mEvent := TSimpleEvent.Create(nil, false, false, '');
  mDoneOperationEvent := TSimpleEvent.Create(nil, false, false, '');
  inherited Create(false);
end;

destructor TbqWorker.Destroy;
begin
  Finalize();
  FreeAndNil(mSection);
  FreeAndNil(mEvent);
  FreeAndNil(mDoneOperationEvent);
  FreeAndNil(mDictionaryTokens);
  FreeAndNil(mSection);

  inherited;
end;

procedure TbqWorker.Execute;
var
  engine: IbqEngineAsyncTraits;
  wr: TWaitResult;
begin
  repeat
    wr := mEvent.WaitFor(INFINITE);
  until wr <> wrTimeout;
  if wr <> wrSignaled then
    exit;

  repeat
    mBusy := true;
    mDoneOperationEvent.ResetEvent();
    try
      if mOperation = wroLoadDictionaries then
      begin
        mResult := _LoadDictionaries(mDictionariesPath);
        engine := getAsynInface();
        if assigned(engine) then
          engine.AsyncStateCompleted(bqsDictionariesLoading, mResult);
        mDictionariesPath := '';
      end
      else if mOperation = wroInitDicTokens then
      begin
        mResult := _InitDictionaryItemsList(mDictionaryTokens);
        engine := getAsynInface();
        if assigned(engine) then
          engine.AsyncStateCompleted(bqsDictionariesListCreating, mResult);
        mDictionaryTokens := nil;
      end
      else if mOperation = wroInitVerseListEngine then
      begin
        mResult := _InitVerseListEngine();
        engine := getAsynInface();
        if assigned(engine) then
          engine.AsyncStateCompleted(bqsVerseListEngineInitializing, mResult);
      end;
      // SetName;
    except
      mResult := -2;
      MessageBeep(MB_ICONERROR);
    end;

    mOperation := wroSleep;
    Busy := false;
    mDoneOperationEvent.SetEvent();
    if not Terminated then
      repeat
        wr := mEvent.WaitFor(3000);
      until (wr <> wrTimeout) and (mOperation <> wroSleep) or (Terminated);

  until (Terminated) or (wr <> wrSignaled);

  mOperation := wroTerminated;

end;

procedure TbqWorker.Finalize;
begin
  Terminate();
  if mOperation = wroSleep then
  begin
    mOperation := wroTerminated;
    mEvent.SetEvent();
  end;
  WaitFor();
  mEngine := nil;
end;

function TbqWorker.getAsynInface(): IbqEngineAsyncTraits;
var
  hr: HRESULT;
begin
  if assigned(mEngine) then
    hr := mEngine.QueryInterface(IbqEngineAsyncTraits, result)
  else
    hr := S_FALSE;
  if hr <> S_OK then
    result := nil;
end;

function TbqWorker.GetBusy: boolean;
begin
  try
    mSection.Acquire();
    result := mBusy
  finally
    mSection.Release()
  end;
end;

function TbqWorker.InitDictionaryItemsList(lst: TBQStringList; foreground: boolean = false): HRESULT;
begin
  result := S_FALSE;
  if foreground then
  begin
    result := _InitDictionaryItemsList(lst);
    exit
  end;

  if Busy then
    exit;

  mOperation := wroInitDicTokens;
  mDictionaryTokens := lst;
  mEvent.SetEvent();
  result := S_OK;
end;

function TbqWorker.InitVerseListEngine(foreground: boolean): HRESULT;
begin
  if foreground then
  begin
    result := _InitVerseListEngine();
    exit
  end;
  result := S_FALSE;
  if Busy then
    exit;
  mOperation := wroInitVerseListEngine;
  mEvent.SetEvent();
  result := S_OK;
end;

function TbqWorker.LoadDictionaries(const fromPath: string; foreground: boolean): HRESULT;
begin
  result := S_FALSE;
  if foreground then
  begin
    result := _LoadDictionaries(fromPath);

    exit;
  end;

  if (Busy) then
    exit;

  mOperation := wroLoadDictionaries;
  mDictionariesPath := fromPath;
  mEvent.SetEvent();
  result := S_OK;
end;

procedure TbqWorker.Resume;
begin
  Busy := true;
  if Suspended then
    TThread(self).Resume();

end;

end.
