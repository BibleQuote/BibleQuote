unit HintTools;

interface

uses Controls, Classes, Windows, Forms, SysUtils;

type
  TbqHintWindow = class(THintWindow)
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
  end;

implementation

uses Types;

{ TbqHintWindow }

procedure TbqHintWindow.ActivateHint(Rect: TRect; const AHint: string);
var
  r, maxOffset: integer;

begin
  r := Screen.DesktopRect.Right - Rect.Right - 30;
  maxOffset := Rect.Right - Screen.DesktopWidth - Rect.Left + 30;
  if (maxOffset < 0) and (r < 0) then
  begin
    if maxOffset - r < 0 then
      maxOffset := r;
    OffsetRect(Rect, maxOffset, 0);
  end;

  inherited;
end;

end.
