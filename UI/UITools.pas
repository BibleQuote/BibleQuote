unit UITools;

interface

uses Controls, ComCtrls;

type
  TEnumControlsProc = function (AControl: TControl): Boolean of object;

  TUITools = class
  class function RealignToolBars(AControl: TControl): Boolean;
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
