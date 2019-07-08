unit Jobs;

interface

uses SysUtils, SyncObjs, Classes, System.Threading;

type
  TJobStatus = (
    jsPending,
    jsRunning,
    jsSucceed,
    jsFailed);

  IJob = interface
    procedure Execute;
    function Reset: Boolean;
    function Wait(Timeout: Cardinal = 0): Boolean;
    procedure WaitForComplete();

    function GetStatus: TJobStatus;
  end;

  IJob<T> = interface(IJob)
    function Result: T;
  end;

  TJob<T> = class(TInterfacedObject, IJob, IJob<T>)
  private
    FEvent: TEvent;
    FResult: T;
    FStatus: TJobStatus;
    FError: Exception;
    FFunc: TFunc<T>;
    FOnComplete: TProc<TJob<T>>;
  public
    constructor Create(Func: TFunc<T>; OnComplete: TProc<TJob<T>> = nil); reintroduce; virtual;
    destructor Destroy; override;

    procedure Execute;
    function Reset: Boolean;
    function Wait(Timeout: Cardinal = 0): Boolean;
    procedure WaitForComplete();
    function Result: T;

    function GetStatus: TJobStatus;

    property Status: TJobStatus read GetStatus;
    function IsComplete: Boolean;
  end;

  TJobExecutor = class abstract
  public
    class procedure RunAsync<T>(Job: TJob<T>); static;
  end;

implementation

class procedure TJobExecutor.RunAsync<T>(Job: TJob<T>);
begin
  TTask.Run(Job.Execute);
end;

constructor TJob<T>.Create(Func: TFunc<T>; OnComplete: TProc<TJob<T>> = nil);
begin
  inherited Create;

  FFunc := Func;
  FOnComplete := OnComplete;
  FStatus := TJobStatus.jsPending;
  FResult := T(nil);
  FEvent := TEvent.Create;
  FEvent.ResetEvent;
end;

destructor TJob<T>.Destroy;
begin
  FreeAndNil(FEvent);

  inherited;
end;

procedure TJob<T>.Execute;
begin
  if (FStatus = jsRunning) then
    Exit;

  try
    FStatus := jsRunning;

    FResult := FFunc();
    FStatus := jsSucceed;
  except
    on E: Exception do
    begin
      FError := E;
      FStatus := jsFailed;
    end;
  end;

  if Assigned(FOnComplete) then
    FOnComplete(Self);

  FEvent.SetEvent;
end;

function TJob<T>.Reset: Boolean;
begin
  if (FStatus = jsRunning) then
  begin
    Result := False;
    Exit;
  end;

  FEvent.ResetEvent;
  FStatus := jsPending;
  Result := True;
end;

function TJob<T>.Result: T;
begin
  Result := FResult;
end;

function TJob<T>.GetStatus: TJobStatus;
begin
  Result := FStatus;
end;

function TJob<T>.IsComplete: Boolean;
begin
  Result := FStatus in [jsSucceed, jsFailed];
end;

procedure TJob<T>.WaitForComplete();
begin
  FEvent.WaitFor(INFINITE);
end;

function TJob<T>.Wait(Timeout: Cardinal): Boolean;
var
  wr: TWaitResult;
begin
  wr := FEvent.WaitFor(Timeout);
  Result := wr <> TWaitResult.wrTimeout;
end;

end.
