{*****************************************************************}
{ SimpleTimer is a timer class. It is more lightweight than a     }
{ TTimer component as it doesn't require a handle, and since it's }
{ derived from TObject there's less overhead.                     }
{ This makes it ideal for developers who need a timer in their    }
{ own components or applications, but want to keep the resource   }
{ usage minimal.                                                  }
{                                                                 }
{ The unit is freeware. Feel free to use and improve it.          }
{ I would be pleased to hear what you think.                      }
{                                                                 }
{ Troels Jakobsen - delphiuser@get2net.dk                         }
{ Copyright (c) 2002                                              }
{*****************************************************************}

unit SimpleTimer;

{ Some methods have moved to the Classes unit in D6 and are thus deprecated.
  Using the following compiler directives we handle that situation. }

{$IFDEF VER140}
  {$DEFINE DELPHI_6}
{$ENDIF}
{$IFDEF VER180}
  {$DEFINE DELPHI_6_UP}
{$ENDIF}
{$IFDEF DELPHI_6}
  {$DEFINE DELPHI_6_UP}
{$ENDIF}

interface

uses
  Windows, Classes;

type
  TSimpleTimerCallBackProc = procedure(AOwner: TComponent); stdcall;

  TSimpleTimer = class(TObject)
  private
    FOwner: TComponent;
    FId: UINT;
    FActive: Boolean;
    FInterval: Cardinal;
    FCallBackProc: TSimpleTimerCallBackProc;
  public
    constructor Create(AOwner: TComponent; CallBackProc: TSimpleTimerCallBackProc);
    destructor Destroy; override;
    function Start(MilliSecs: Cardinal): Boolean;
    function Stop: Boolean;
    property Owner: TComponent read FOwner;
    property Active: Boolean read FActive;
  end;


implementation

uses
  Forms, Messages;

type
  TSimpleTimerHandler = class(TObject)
  private
    RefCount: Cardinal;
    FWindowHandle: HWND;
    procedure WndProc(var Msg: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTimer;
    procedure RemoveTimer;
  end;

var
  SimpleTimerHandler: TSimpleTimerHandler = nil;

{--------------- TSimpleTimerHandler ------------------}

constructor TSimpleTimerHandler.Create;
begin
  inherited Create;
{$IFDEF DELPHI_6_UP}   
  FWindowHandle := Classes.AllocateHWnd(WndProc);
{$ELSE}
  FWindowHandle := AllocateHWnd(WndProc);
{$ENDIF}
end;


destructor TSimpleTimerHandler.Destroy;
begin
{$IFDEF DELPHI_6_UP}
  Classes.DeallocateHWnd(FWindowHandle);
{$ELSE}
  DeallocateHWnd(FWindowHandle);
{$ENDIF}
  inherited Destroy;
end;


procedure TSimpleTimerHandler.AddTimer;
begin
  Inc(RefCount);
end;


procedure TSimpleTimerHandler.RemoveTimer;
begin
  if RefCount > 0 then
    Dec(RefCount);
end;


procedure TSimpleTimerHandler.WndProc(var Msg: TMessage);
var
  Timer: TSimpleTimer;
begin
  if Msg.Msg = WM_TIMER then
  begin
    try
      Timer := TSimpleTimer(Msg.wParam);
      if Assigned(Timer.FCallBackProc) then
        Timer.FCallBackProc(Timer.FOwner);
    except
      // ???
    end;
  end
  else
    Msg.Result := DefWindowProc(FWindowHandle, Msg.Msg, Msg.wParam, Msg.lParam);
end;

{---------------- Container management ----------------}

procedure AddTimer;
begin
  if not Assigned(SimpleTimerHandler) then
    // Create new handler
    SimpleTimerHandler := TSimpleTimerHandler.Create;
  SimpleTimerHandler.AddTimer;
end;


procedure RemoveTimer;
begin
  if Assigned(SimpleTimerHandler) then
  begin
    SimpleTimerHandler.RemoveTimer;
    if SimpleTimerHandler.RefCount = 0 then
    begin
      // Destroy handler
      SimpleTimerHandler.Free;
      SimpleTimerHandler := nil;
    end;
  end;
end;

{------------------ Callback method -------------------}
{
procedure TimerProc(hWnd: HWND; uMsg: UINT; idEvent: UINT; dwTime: DWORD); stdcall;
var
  Timer: TSimpleTimer;
begin
//  if uMsg = WM_TIMER then    // It's always WM_TIMER
  begin
    try
      Timer := TSimpleTimer(idEvent);
      if Assigned(Timer.FCallBackProc) then
        Timer.FCallBackProc(Timer.FOwner);
    except
      // ???
    end;
  end;
end;
}
{------------------- TSimpleTimer ---------------------}

constructor TSimpleTimer.Create(AOwner: TComponent; CallBackProc: TSimpleTimerCallBackProc);
begin
  inherited Create;
  FOwner := AOwner;
  FId := UINT(Self);         // Use Self as id in call to SetTimer and callback method
  FCallBackProc := CallBackProc;
  FActive := False;
  AddTimer;                  // Container management
end;


destructor TSimpleTimer.Destroy;
begin
  if FActive then
    Stop;
  RemoveTimer;               // Container management
  inherited Destroy;
end;


function TSimpleTimer.Start(MilliSecs: Cardinal): Boolean;
begin
  if FActive then
    Stop;
  FInterval := MilliSecs;
//  Result := (SetTimer(SimpleTimerHandler.FWindowHandle, FId, MilliSecs, @TimerProc) <> 0);
  Result := (SetTimer(SimpleTimerHandler.FWindowHandle, FId, MilliSecs, nil) <> 0);
  if Result then
    FActive := True
{  else
    raise EOutOfResources.Create(SNoTimers); }
end;


function TSimpleTimer.Stop: Boolean;
begin
  FActive := False;
  Result := KillTimer(SimpleTimerHandler.FWindowHandle, FId);
end;


initialization

finalization
  if Assigned(SimpleTimerHandler) then
  begin
    SimpleTimerHandler.Free;
    SimpleTimerHandler := nil;
  end;

end.

