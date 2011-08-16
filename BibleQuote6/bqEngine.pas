unit bqEngine;

interface
uses Windows,Classes, Contnrs,Dict,bqBackgroundServices,BibleQuoteUtils,bqEngineInterfaces,VersesDB,Forms;
type


 TBibleQuoteEngine=class(TInterfacedObject,IbqEngineDicTraits,IbqEngineAsyncTraits)
  private

 {class TBibleQuoteEngine is  the core engine of the App}
 {we'll move all UI independent logic here}
 protected
 mState:TBibleQuoteState;
 mLastDicsLocation:WideString;
 //Dics: array[0..255] of TDict;
 mDics:TObjectList;
 mWorker:TbqWorker;
 mDicList: TBQStringList;
 mBackOpsActive:boolean;
 mTags_n_VersesList: TbqVerseTagsList;
 function GetState(stateEntryName:TBibleQuoteStateEntries):boolean;inline;
 procedure AsyncStateCompleted(state:TBibleQuoteStateEntries; res:HRESULT);
 function GetDictionary(aIndex:Cardinal):TDict;
 function AddDictionary(aDictionary:TDict):Cardinal;

 public
 mLastUsedComment:WideString;
 function Finalize():HRESULT;
 function Initilize(const fromPath:WideString):HRESULT;
 function LoadDictionaries(const Path:WideString;foreground:boolean):HRESULT;
 function InitDictionaryItemsList(foreground:boolean):HRESULT;
 function InitVerseListEngine(ui:IuiVerseOperations;foreground:boolean):HRESULT;
 function DictionariesCount():Cardinal;
 function CacheTagNames():HRESULT;
 constructor Create(const basePath:WideString);
 destructor Destroy;override;
 property State[TBibleQuoteStateEntries:TBibleQuoteStateEntries]:boolean read GetState;default;
 property Dictionaries[i:Cardinal]:TDict read GetDictionary;
 property DictionaryTokens:TBQStringList read mDicList;
 property VersesTagsList:TbqVerseTagsList read mTags_n_VersesList;
end;
implementation
uses SysUtils;
{ TBibleQuoteEngine }

function TBibleQuoteEngine.AddDictionary(aDictionary: TDict): Cardinal;
begin
Result:=mDics.Add(aDictionary);
end;

procedure TBibleQuoteEngine.AsyncStateCompleted(state: TBibleQuoteStateEntries;
  res: HRESULT);
begin
Exclude(mState,state);
{if res=S_OK then} Include(mState,Succ(state));
mBackOpsActive:=false;
end;

function TBibleQuoteEngine.CacheTagNames: HRESULT;
begin
result:=S_OK;
if State[bqsTaggedBookmarksCached] then begin result:=S_OK; exit; end;
if not Assigned(mTags_n_VersesList) then mTags_n_VersesList:=TbqVerseTagsList.Create(true);

VerseListEngine.SeedNodes(mTags_n_VersesList);
Include(mState,bqsTaggedBookmarksCached);
end;

constructor TBibleQuoteEngine.Create(const basePath: WideString);
begin
inherited Create();
mDics:=TObjectList.Create(true);
mWorker:=TbqWorker.Create(self);
Initilize(basePath);
end;

destructor TBibleQuoteEngine.Destroy;
begin
inherited;
Finalize();
FreeAndNil(mDics);
FreeAndNil(mDicList);
FreeAndNil(mTags_n_VersesList);
FreeAndNil(mWorker);
end;

function TBibleQuoteEngine.DictionariesCount: Cardinal;
begin
result:=mDics.Count;
end;

function TBibleQuoteEngine.GetDictionary(aIndex: Cardinal): TDict;
begin
result:=TDict( mDics[aIndex]);
end;

function TBibleQuoteEngine.GetState(
  stateEntryName: TBibleQuoteStateEntries): boolean;
begin
result:=stateEntryName in mState;
end;

function TBibleQuoteEngine.InitDictionaryItemsList(foreground:boolean): HRESULT;
begin
//
  result := S_FALSE;
  if not assigned(mDicList) then mDicList:=TBQStringList.Create();
  if (bqsDictionariesListCreating in mState)  then begin
  if foreground then begin
      mWorker.WaitUntilDone(INFINITE);
      result:=mWorker.OperationResult;
      exclude(mState,bqsDictionariesListCreating);include(mstate,bqsDictionariesListCreated);
      exit
  end;
   result:=S_OK; exit;
  end;

  result:=mWorker.InitDictionaryItemsList(mDicList,foreground);
  if foreground then begin
     exclude(mState,bqsDictionariesListCreating);
     include(mState,bqsDictionariesListCreated);
     exit;
  end;
  if result<>S_OK then begin
    exclude(mState,bqsDictionariesListCreating);
    exit;
   end;
  Include(mState,bqsDictionariesListCreating);
  mBackOpsActive:=true;

end;




function TBibleQuoteEngine.Initilize(const fromPath: WideString): HRESULT;
begin
mBackOpsActive:=false;
//LoadDictionaries('');
end;
function TBibleQuoteEngine.Finalize():HRESULT;
begin
  result:=S_OK;
   if assigned(mWorker) then
   mWorker.Finalize();
end;

function TBibleQuoteEngine.InitVerseListEngine(ui:IuiVerseOperations;foreground:boolean): HRESULT;
begin
  if not assigned(VerseListEngine) then
    Application.CreateForm(TVerseListEngine, VerseListEngine);
  if bqsVerseListEngineInitialized in mState  then begin result:=S_OK; exit end;
  if bqsVerseListEngineInitializing in mState then
    if foreground then begin
        mWorker.WaitUntilDone(INFINITE);
        result:=mWorker.OperationResult;
        exit
    end
    else begin result:=S_OK; exit;end;
    result:=mWorker.InitVerseListEngine(ui,foreground);
    if foreground then begin
    Exclude(mState,bqsVerseListEngineInitializing); Include(mState,bqsVerseListEngineInitialized);
    end;

end;

function TBibleQuoteEngine.LoadDictionaries(const Path:WideString;foreground:boolean): HRESULT;
var
  c,cmpR: integer;
  blDicsLoaded:boolean;
begin
  result := S_FALSE;
  blDicsLoaded:=(bqsDictionariesLoaded in mState);
  if (blDicsLoaded)  then begin
   //cmpR:=CompareStringW($0007f, NORM_IGNORECASE,
   result:=S_OK; exit;
  end;
  if foreground then
    if bqsDictionariesLoading in mState then begin
        mWorker.WaitUntilDone(INFINITE);
        result:=mWorker.OperationResult;
        Exclude(mState,bqsDictionariesLoading);Include(mState,bqsDictionariesLoaded);
        exit;
    end
    else begin
    result:=mWorker.LoadDictionaries(path,true);
    Include(mState,bqsDictionariesLoaded);
    exit;
    end;



  result:=mWorker.LoadDictionaries(path,false);
  if result<>S_OK then exit;
  Include(mState,bqsDictionariesLoading);
  mBackOpsActive:=true;

end;

end.
