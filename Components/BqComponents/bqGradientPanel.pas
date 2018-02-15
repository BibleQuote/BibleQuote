unit bqGradientPanel;

interface

uses Windows, Classes, ComCtrls, Graphics, Forms, Controls, ExtCtrls,
  Messages, GraphUtil;

type
  TGradientPanel = class(TPanel)
  protected
    mGradientDirection: TGradientDirection;
    mGradientStartColor, mGradientEndColor: TColor;
    procedure Paint(); override;
  published
    property GradientDirection: TGradientDirection read mGradientDirection
      write mGradientDirection;
    property GradientStartColor: TColor read mGradientStartColor
      write mGradientStartColor;
    property GradientEndColor: TColor read mGradientEndColor
      write mGradientEndColor;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('BqComponents', [TGradientPanel]);
end;

procedure TGradientPanel.Paint;
begin

  if not(csDesigning in ComponentState) then
  begin

    GradientFillCanvas(canvas, mGradientStartColor, mGradientEndColor,
      GetClientRect(), mGradientDirection);
  end
  else
    inherited;
end;

end.
