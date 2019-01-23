unit Engine;

interface

uses Windows, Classes, Contnrs, DictInterface, BackgroundServices, BibleQuoteUtils,
  EngineInterfaces, TagsDb, Forms, Generics.Collections;

type

  TBibleQuoteEngine = class(TInterfacedObject, IbqEngineDicTraits, IbqEngineAsyncTraits)
  private

    { class TBibleQuoteEngine is  the core engine of the App }
    { we'll move all UI independent logic here }
  protected
    mState: TBibleQuoteState;
    mLastDicsLocation: string;
    // Dics: array[0..255] of TDict;
    mDics: TList<IDict>;
    mWorker: TbqWorker;
    mDicList: TBQStringList;
    mBackOpsActive: boolean;

    function GetState(stateEntryName: TBibleQuoteStateEntries): boolean; inline;
    procedure AsyncStateCompleted(state: TBibleQuoteStateEntries; res: HRESULT);
    function GetDictionary(aIndex: Cardinal): IDict;
    function AddDictionary(aDictionary: IDict): Cardinal;

  public
    mLastUsedComment: string;
    function Finalize(): HRESULT;
    procedure Initilize();
    function LoadDictionaries(const Path: string; foreground: boolean): HRESULT;
    function InitDictionaryItemsList(foreground: boolean): HRESULT;
    function InitVerseListEngine(foreground: boolean): HRESULT;
    function DictionariesCount(): Cardinal;
    constructor Create();
    destructor Destroy; override;
    property state[TBibleQuoteStateEntries: TBibleQuoteStateEntries]: boolean read GetState; default;
    property Dictionaries[i: Cardinal]: IDict read GetDictionary;
    property DictionaryTokens: TBQStringList read mDicList;
  end;

implementation

uses SysUtils;
{ TBibleQuoteEngine }

function TBibleQuoteEngine.AddDictionary(aDictionary: IDict): Cardinal;
begin
  Result := mDics.Add(aDictionary);
end;

procedure TBibleQuoteEngine.AsyncStateCompleted(state: TBibleQuoteStateEntries; res: HRESULT);
begin
  Exclude(mState, state);
  Include(mState, Succ(state));
  mBackOpsActive := false;
end;

constructor TBibleQuoteEngine.Create();
begin
  inherited Create();
  mDics := TList<IDict>.Create();
  mWorker := TbqWorker.Create(self);
  Initilize();
end;

destructor TBibleQuoteEngine.Destroy;
begin
  inherited;
  Finalize();

  ClearDictList();
  FreeAndNil(mDics);
  FreeAndNil(mDicList);
  FreeAndNil(mWorker);
end;

function TBibleQuoteEngine.DictionariesCount: Cardinal;
begin
  Result := mDics.Count;
end;

function TBibleQuoteEngine.GetDictionary(aIndex: Cardinal): IDict;
begin
  Result := mDics[aIndex];
end;

function TBibleQuoteEngine.GetState(stateEntryName: TBibleQuoteStateEntries): boolean;
begin
  Result := stateEntryName in mState;
end;

function TBibleQuoteEngine.InitDictionaryItemsList(foreground: boolean): HRESULT;
begin
  if not Assigned(mDicList) then
    mDicList := TBQStringList.Create();
  if (bqsDictionariesListCreating in mState) then
  begin
    if foreground then
    begin
      mWorker.WaitUntilDone(INFINITE);
      Result := mWorker.OperationResult;
      Exclude(mState, bqsDictionariesListCreating);
      Include(mState, bqsDictionariesListCreated);
      exit
    end;
    Result := S_OK;
    exit;
  end;

  Result := mWorker.InitDictionaryItemsList(mDicList, foreground);
  if foreground then
  begin
    Exclude(mState, bqsDictionariesListCreating);
    Include(mState, bqsDictionariesListCreated);
    exit;
  end;
  if Result <> S_OK then
  begin
    Exclude(mState, bqsDictionariesListCreating);
    exit;
  end;
  Include(mState, bqsDictionariesListCreating);
  mBackOpsActive := true;

end;

procedure TBibleQuoteEngine.Initilize();
begin
  mBackOpsActive := false;
end;

function TBibleQuoteEngine.Finalize(): HRESULT;
begin
  Result := S_OK;
  if Assigned(mWorker) then
    mWorker.Finalize();
end;

function TBibleQuoteEngine.InitVerseListEngine(foreground: boolean): HRESULT;
begin
  if bqsVerseListEngineInitialized in mState then
  begin
    Result := S_OK;
    exit
  end;
  if bqsVerseListEngineInitializing in mState then
    if foreground then
    begin
      mWorker.WaitUntilDone(INFINITE);
      Result := mWorker.OperationResult;
      exit
    end
    else
    begin
      Result := S_OK;
      exit;
    end;
  Result := mWorker.InitVerseListEngine(foreground);
  if foreground then
  begin
    Exclude(mState, bqsVerseListEngineInitializing);
    Include(mState, bqsVerseListEngineInitialized);
  end;

end;

function TBibleQuoteEngine.LoadDictionaries(const Path: string; foreground: boolean): HRESULT;
var
  blDicsLoaded: boolean;
begin
  blDicsLoaded := (bqsDictionariesLoaded in mState);
  if (blDicsLoaded) then
  begin
    Result := S_OK;
    exit;
  end;
  if foreground then
    if bqsDictionariesLoading in mState then
    begin
      mWorker.WaitUntilDone(INFINITE);
      Result := mWorker.OperationResult;
      Exclude(mState, bqsDictionariesLoading);
      Include(mState, bqsDictionariesLoaded);
      exit;
    end
    else
    begin
      Result := mWorker.LoadDictionaries(Path, true);
      Include(mState, bqsDictionariesLoaded);
      exit;
    end;

  Result := mWorker.LoadDictionaries(Path, false);
  if Result <> S_OK then
    exit;
  Include(mState, bqsDictionariesLoading);
  mBackOpsActive := true;

end;

end.
