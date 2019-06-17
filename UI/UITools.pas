unit UITools;

interface

uses Controls, ComCtrls, System.SysUtils, System.Classes, ExtCtrls,
     System.DateUtils;

type
  TLibraryViewMode = (
    lvmCover,
    lvmTile,
    lvmList,
    lvmDetail
  );

  TEnumControlsProc = function (AControl: TControl): Boolean of object;

  TUITools = class
  class function RealignToolBars(AControl: TControl): Boolean;
  end;

  TDebouncedEvent = class (TComponent)
  private
    FSourceEvent: TNotifyEvent;
    FInterval: integer;

    FTimer: TTimer;
    FSender: TObject;

    FLastcallTimestamp: TDateTime;

    procedure DebouncedEvent(Sender: TObject);

    procedure DoCallEvent(Sender: TObject);
    procedure DoOnTimer(Sender: TObject);
  protected
    constructor Create(AOwner: TComponent; ASourceEvent: TNotifyEvent;
      AInterval: integer); reintroduce;
  public
    class function Wrap(ASourceEvent: TNotifyEvent; AInterval: integer;
      AOwner: TComponent): TNotifyEvent;
  end;

procedure EnumControls(AParent: TWinControl; const AEnumProc: TEnumControlsProc);

implementation

class function TUITools.RealignToolBars(AControl: TControl): Boolean;
var
  LToolBar: TToolBar absolute AControl;
begin
  Result := not (AControl is TToolBar);
  if not Result then begin
    LToolBar.HandleNeeded;
    if LToolBar.Wrapable then
      LToolBar.Realign;
  end;
end;

constructor TDebouncedEvent.Create(AOwner: TComponent;
  ASourceEvent: TNotifyEvent; AInterval: integer);
begin
  inherited Create(AOwner);
  self.FSourceEvent := ASourceEvent;
  self.FInterval := AInterval;

  self.FTimer := TTimer.Create(self);
  self.FTimer.Enabled := false;
  self.FTimer.Interval := AInterval;
  self.FTimer.OnTimer := self.DoOnTimer;
end;

procedure TDebouncedEvent.DebouncedEvent(Sender: TObject);
var
  Between: int64;
begin
  Between := MilliSecondsBetween(Now, self.FLastcallTimestamp);

  // if timer is not enabled, it means that last call happened
  // earlier than <self.FInteval> milliseconds ago
  if Between >= self.FInterval then begin
    self.DoCallEvent(Sender);
  end
  else begin
    // adjusting timer, so interval between calls will never be more than <FInterval> ms
    self.FTimer.Interval := self.FInterval - Between;

    // reset the timer
    self.FTimer.Enabled := false;
    self.FTimer.Enabled := true;

    // remember last Sender argument value to use it in a delayed call
    self.FSender := Sender;
  end;
end;

procedure TDebouncedEvent.DoCallEvent(Sender: TObject);
begin
  self.FLastcallTimestamp := Now;
  self.FSourceEvent(Sender);
end;

procedure TDebouncedEvent.DoOnTimer(Sender: TObject);
begin
  self.FTimer.Enabled := false;
  self.DoCallEvent(self.FSender);
end;

class function TDebouncedEvent.Wrap(ASourceEvent: TNotifyEvent;
  AInterval: integer; AOwner: TComponent): TNotifyEvent;
begin
  Result := TDebouncedEvent.Create(AOwner, ASourceEvent, AInterval).DebouncedEvent;
end;

procedure EnumControls(AParent: TWinControl; const AEnumProc: TEnumControlsProc);
var
  Li: Integer;
  LControl: TControl;
begin
  for Li := 0 to AParent.ControlCount - 1 do begin
    LControl := AParent.Controls[Li];
    if AEnumProc(LControl) and (LControl is TWinControl) then
      EnumControls(TWinControl(LControl), AEnumProc);
  end;
end;

end.
