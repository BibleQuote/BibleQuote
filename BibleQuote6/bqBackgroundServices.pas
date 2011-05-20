unit bqBackgroundServices;

interface

uses
  Classes,SyncObjs,SysUtils,Dict , Windows ,BibleQuoteUtils,bqEngineInterfaces,VersesDB;

type


  TbqWorkerRequiredOperation=(wroSleep,wroLoadDictionaries, wroInitDicTokens, wroInitVerseListEngine);
  TbqWorker = class(TThread)
  private
    procedure SetName;

  protected
    mSection:TCriticalSection;
    mEvent,mDoneOperationEvent:TSimpleEvent;
    mDictionariesPath:WideString;
    mDictionaryTokens:TBQStringList;
    mUI:IuiVerseOperations;
    mOperation:TbqWorkerRequiredOperation;

    mBusy:boolean;
    mEngine:IInterface;
    mResult:HRESULT;
    procedure Execute; override;
    function _LoadDictionaries(const fromPath:WideString):HRESULT;
    function getAsynInface():IbqEngineAsyncTraits;
    function _InitDictionaryItemsList(lst:TBQStringList): HRESULT;
    function _InitVerseListEngine(ui:IuiVerseOperations):HRESULT;
    function  GetBusy():boolean;
    procedure  SetBusy(aVal:boolean);

  public
    function LoadDictionaries(const fromPath:WideString;foreground:boolean):HRESULT;
    function InitDictionaryItemsList(lst:TBQStringList;foreground:boolean=false): HRESULT;
    function InitVerseListEngine(ui:IuiVerseOperations;foreground:boolean):HRESULT;
    function WaitUntilDone(dwTime:DWORD):TWaitResult;
    constructor Create(iEngine:IInterface);
    destructor Destroy; override;
    procedure Resume();
    procedure Suspend();
    property OperationResult:HRESULT read mResult;
    property Busy:boolean read GetBusy write SetBusy;
//    procedure LoadDictionaries(const
  end;

implementation
uses bqPlainUtils,TntSysUtils;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TbqWorker.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{$IFDEF MSWINDOWS}
type
  TThreadNameInfo = record
    FType: LongWord;     // must be 0x1000
    FName: PChar;        // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord;    // reserved for future use, must be zero
  end;
{$ENDIF}

{ TbqWorker }

procedure TbqWorker.SetBusy(aVal:boolean);
begin
try
mSection.Acquire();
mBusy:=aVal;
finally
mSection.Release()
end;

end;

procedure TbqWorker.SetName;
{$IFDEF MSWINDOWS}
var
  ThreadNameInfo: TThreadNameInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'bqWorker';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException( $406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo );
  except
  end;
{$ENDIF}
end;


procedure TbqWorker.Suspend;
begin

//mSection.Acquire;
//try
//self.Synchronize(self,TThread(self).Suspend );

TThread(self).Suspend();

//finally mSection.Release(); end;
end;

function TbqWorker.WaitUntilDone(dwTime: DWORD): TWaitResult;
begin
result:=mDoneOperationEvent.WaitFor(dwTime);
end;

function TbqWorker._InitDictionaryItemsList(lst: TBQStringList): HRESULT;
var
  dicCount, wordCount, dicIx, wordIx, c: integer;
  hr:HRESULT;
  engine:IbqEngineDicTraits;
  currentDic:TDict;
begin
  result := S_FALSE;
  hr:=mEngine.QueryInterface(IbqEngineDicTraits,engine) ;
  if hr<>S_OK then  exit;

  if lst=nil then lst:=TBQStringList.Create
  else lst.Clear();
  lst.Sorted:=true;
  dicCount:=engine.DictionariesCount()-1;
  dicIx:=0;
  for dicIx := 0 to dicCount do begin
   currentDic:=engine.GetDictionary(dicIx);
   wordCount:=currentDic.Words.Count-1;
   for wordIx := 0 to wordCount do begin
    lst.Add(currentDic.Words[wordIx]);
   end;
  end;
  result:=S_OK;
end;

function TbqWorker._InitVerseListEngine(ui: IuiVerseOperations): HRESULT;
begin
result:=S_FALSE;
  try
    VerseListEngine.InitVerseListEngine(ExePath + 'TagsDb.bqd',ui);
    result:=S_OK;
  except on e: Exception do begin
   result:=-2;
  end;
end;
end;

function TbqWorker._LoadDictionaries(const fromPath: WideString): HRESULT;
var ifindFirstResult:integer;
    wsFileMask, wsFileName, wsDictHtmlFileName, wsPath:WideString;
    findHandle:THandle;
    findData:_WIN32_FIND_DATAW;
    dictionary:TDict;
    engine:IbqEngineDicTraits;
    hr:HRESULT;
    blFound:BOOL;
begin
  result := S_FALSE;
  hr:=mEngine.QueryInterface(IbqEngineDicTraits,engine) ;
  if hr<>S_OK then  exit;

  wsPath:=WideIncludeTrailingPathDelimiter(fromPath);
  wsFileMask:=wsPath + '*.idx';
  findHandle := FindFirstFileExW(Pointer(wsFileMask),FindExInfoStandard,@findData,
      FindExSearchNameMatch,nil,0);
  if findHandle=INVALID_HANDLE_VALUE then exit;
  try
  repeat
  dictionary:=TDict.Create;
  wsFileName:=PWideChar(@(findData.cFileName[0]));
  wsDictHtmlFileName:=Copy(wsFileName, 1,length(wsFileName)-3)+'htm';
  dictionary.Initialize(wsPath+wsFileName,wsPath+wsDictHtmlFileName);
  engine.AddDictionary(dictionary);
  blFound:=FindNextFileW(findHandle,findData);
  until (not blFound) or (self.Terminated);
  if not blFound then result:=S_OK;
  
  finally FindClose(findHandle); end;

end;

constructor TbqWorker.Create(iEngine:IInterface);
begin
mEngine:=iEngine;
mSection:=TCriticalSection.Create;
mEvent:=TSimpleEvent.Create(nil, false, false,'bqWorkerSignal');
mDoneOperationEvent:=TSimpleEvent.Create(nil, false, false,'bqWorkerDone');
inherited  Create(false);
end;

destructor TbqWorker.Destroy;
begin
  FreeAndNil(mSection);
  FreeAndNil(mEvent);
  FreeAndNil(mDoneOperationEvent);
  mEngine:=nil;
  inherited;
end;

procedure TbqWorker.Execute;
var engine:IbqEngineAsyncTraits;
     wr:TWaitResult;
begin
  repeat
  wr:=mEvent.WaitFor(INFINITE);
  until wr<>wrTimeout;
  if wr<>wrSignaled then exit;

repeat
   mBusy:=true;
   mDoneOperationEvent.ResetEvent();
  try
  if mOperation=wroLoadDictionaries then begin
  mResult:=_LoadDictionaries(mDictionariesPath);
  engine:=getAsynInface();
  if assigned(engine) then
    engine.AsyncStateCompleted(bqsDictionariesLoading, mResult);
    mDictionariesPath:='';
  end
  else if mOperation=wroInitDicTokens then begin
  mResult:=_InitDictionaryItemsList(mDictionaryTokens);
  engine:=getAsynInface();
  if assigned(engine) then
    engine.AsyncStateCompleted(bqsDictionariesListCreating, mResult);
    mDictionaryTokens:=nil;
  end
  else if mOperation =wroInitVerseListEngine then begin
    mResult:=_InitVerseListEngine(mUI);
    engine:=getAsynInface();
    if assigned(engine) then
    engine.AsyncStateCompleted(bqsVerseListEngineInitializing, mResult);
    mUI:=nil;
  end;
  //  SetName;
  except
  mResult:=-2;
  MessageBeep(MB_ICONERROR);
  end;

  mOperation:=wroSleep;
  Busy:=false;
  mDoneOperationEvent.SetEvent();
  repeat
  wr:=mEvent.WaitFor(INFINITE);
  until (wr<>wrTimeout) and (mOperation<>wroSleep);

until (Terminated) or (wr<>wrSignaled);
  { Place thread code here }
end;

function TbqWorker.getAsynInface(): IbqEngineAsyncTraits;
var
    hr:HRESULT;
begin
hr:=mEngine.QueryInterface(IbqEngineAsyncTraits,result);
  if hr<>S_OK then result:=nil;
end;

function TbqWorker.GetBusy: boolean;
begin
try
mSection.Acquire();
result:=mBusy
finally
mSection.Release()
end;
end;

function TbqWorker.InitDictionaryItemsList(lst: TBQStringList;foreground:boolean=false): HRESULT;
begin
result:= S_FALSE;
if foreground then begin
 result:=_InitDictionaryItemsList(lst);
 exit
end;

if Busy then exit;


mOperation:=wroInitDicTokens;
mDictionaryTokens:=lst;
mEvent.SetEvent();
result:=S_OK;
end;

function TbqWorker.InitVerseListEngine(ui: IuiVerseOperations;foreground:boolean): HRESULT;
begin
if foreground then begin result:=_InitVerseListEngine(ui); exit end;
result:=S_FALSE;
if Busy then exit;
mOperation:=wroInitVerseListEngine;
mUI:=ui;
mEvent.SetEvent();
result:=S_OK;
end;

function TbqWorker.LoadDictionaries(const fromPath: WideString;foreground:boolean):HRESULT;
begin
result:= S_FALSE;
if foreground then begin
result:=_LoadDictionaries(fromPath);

exit;
end;

if (Busy) then exit;

mOperation:=wroLoadDictionaries;
mDictionariesPath:=fromPath;
mEvent.SetEvent();
result:=S_OK;
end;

procedure TbqWorker.Resume;
begin
busy:=true;
if Suspended then TThread(Self).Resume();

end;

end.
