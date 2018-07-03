unit ThinCaptionedDockTree;

interface

uses
  Winapi.Windows, System.Types, Vcl.Graphics, Vcl.Themes, Vcl.GraphUtil, Vcl.DockTabSet,
  Vcl.CaptionedDockTree, Vcl.Controls;

type
  TThinCaptionedDockTree = class(TCaptionedTabDockTree)
  public
    function AdjustCaptionRect(const ARect: TRect): TRect; override;
    procedure AdjustDockRect(Control: TControl; var ARect: TRect); override;
    class function GetDockCaptionDrawer: TDockCaptionDrawerClass; override;
  end;

type
  TThinDockCaptionDrawer = class(TDockCaptionDrawer)
  private
    function GetCloseRect(const CaptionRect: TRect): TRect;
    function GetPinRect(const CaptionRect: TRect): TRect;
    function CalcButtonSize(const CaptionRect: TRect): Integer;
  public
    procedure DrawDockCaption(const Canvas: TCanvas; CaptionRect: TRect; State: TParentFormState); override;
  end;

implementation

function GetThemeColor(Details: TThemedElementDetails; ElementColor: TElementColor; var Color: TColor): Boolean; inline;
begin
  Result := StyleServices.Enabled and StyleServices.GetElementColor(Details, ElementColor, Color) and (Color <> clNone);
end;

{ TThinCaptionedDockTree }

class function TThinCaptionedDockTree.GetDockCaptionDrawer: TDockCaptionDrawerClass;
begin
  Result := TThinDockCaptionDrawer;
end;

procedure TThinCaptionedDockTree.AdjustDockRect(Control: TControl; var ARect: TRect);
begin
  if DockCaptionOrientation = dcoHorizontal then
    Inc(ARect.Top, 16)
  else
    Inc(ARect.Left, 16)
end;

function TThinCaptionedDockTree.AdjustCaptionRect(const ARect: TRect): TRect;
begin
  Result := ARect;
  if DockCaptionOrientation = dcoHorizontal then
  begin
    Result.Left := Result.Left + 1;
    Result.Bottom := Result.Top + 16 - 1;
    Result.Right := Result.Right - 2; { Shrink the rect a little }
  end
  else
  begin
    Result.Right := Result.Left + 16 - 1;
    Result.Left := Result.Left + 1;
    Result.Bottom := Result.Bottom - 3;
  end;
end;

{ TThinDockCaptionDrawer }

function TThinDockCaptionDrawer.CalcButtonSize(const CaptionRect: TRect): Integer;
const
  cButtonBuffer = 8;
begin
  if Self.DockCaptionOrientation = dcoHorizontal then
    Result := CaptionRect.Bottom - CaptionRect.Top - cButtonBuffer
  else
    Result := CaptionRect.Right - CaptionRect.Left - cButtonBuffer;
end;

procedure TThinDockCaptionDrawer.DrawDockCaption(const Canvas: TCanvas; CaptionRect: TRect; State: TParentFormState);
var
  LColor: TColor;
  LStyle: TCustomStyleServices;
  LDetails: TThemedElementDetails;

  procedure PaintCloseX(const LeftTip, TopTip: Integer);
  begin
    if not GetThemeColor(LDetails, ecEdgeFillColor, LColor) then
      LColor := cl3DDkShadow;

    Canvas.Pen.Color := LColor;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Width := 1;

    // Left side
    Canvas.MoveTo(LeftTip + 0, TopTip + 0);
    Canvas.LineTo(LeftTip + 0, TopTip + 1);
    Canvas.LineTo(LeftTip + 1, TopTip + 2);
    Canvas.LineTo(LeftTip + 2, TopTip + 3);
    Canvas.LineTo(LeftTip + 1, TopTip + 4);
    Canvas.LineTo(LeftTip + 0, TopTip + 5);
    Canvas.LineTo(LeftTip + 0, TopTip + 7);

    // top
    Canvas.MoveTo(LeftTip + 1, TopTip - 1);
    Canvas.LineTo(LeftTip + 2, TopTip - 1);
    Canvas.LineTo(LeftTip + 3, TopTip + 0);
    Canvas.LineTo(LeftTip + 4, TopTip + 1);
    Canvas.LineTo(LeftTip + 5, TopTip + 0);
    Canvas.LineTo(LeftTip + 6, TopTip - 1);
    Canvas.LineTo(LeftTip + 8, TopTip - 1);

    // right side
    Canvas.MoveTo(LeftTip + 8, TopTip + 0);
    Canvas.LineTo(LeftTip + 8, TopTip + 1);
    Canvas.LineTo(LeftTip + 7, TopTip + 2);
    Canvas.LineTo(LeftTip + 6, TopTip + 3);
    Canvas.LineTo(LeftTip + 7, TopTip + 4);
    Canvas.LineTo(LeftTip + 8, TopTip + 5);
    Canvas.LineTo(LeftTip + 8, TopTip + 7);

    // bottom
    Canvas.MoveTo(LeftTip + 1, TopTip + 7);
    Canvas.LineTo(LeftTip + 2, TopTip + 7);
    Canvas.LineTo(LeftTip + 3, TopTip + 6);
    Canvas.LineTo(LeftTip + 4, TopTip + 5);
    Canvas.LineTo(LeftTip + 5, TopTip + 6);
    Canvas.LineTo(LeftTip + 6, TopTip + 7);
    Canvas.LineTo(LeftTip + 8, TopTip + 7);

    // Fill
    if not GetThemeColor(LDetails, ecEdgeHighLightColor, LColor) then
      LColor := cl3DDkShadow;
    Canvas.Brush.Color := LColor;
    Canvas.FloodFill(LeftTip + 3, TopTip + 1, Canvas.Pixels[LeftTip + 3, TopTip + 1], fsSurface);
  end;

  procedure PaintPin(const LeftTip, TopTip: Integer);
  var
    Left, Top: Integer;
  begin
    Canvas.Pen.Color := Canvas.Font.Color;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Width := 1;

    if not GetThemeColor(LDetails, ecEdgeFillColor, LColor) then
      LColor := cl3DDkShadow;
    Canvas.Pen.Color := LColor;

    if Self.DockCaptionPinButton = dcpbDown then
    begin
      Top := TopTip + 1;
      Left := LeftTip;
      { Draw the top box }
      Canvas.MoveTo(Left + 1, Top + 4);
      Canvas.LineTo(Left + 1, Top);
      Canvas.LineTo(Left + 5, Top);
      Canvas.LineTo(Left + 5, Top + 5);
      { Draw the middle line }
      Canvas.MoveTo(Left, Top + 5);
      Canvas.LineTo(Left + 7, Top + 5);
      { Draw a depth line }
      Canvas.MoveTo(Left + 4, Top + 1);
      Canvas.LineTo(Left + 4, Top + 5);
      Canvas.MoveTo(Left + 3, Top + 6);
      Canvas.LineTo(Left + 3, Top + 6 + 4);

      if not GetThemeColor(LDetails, ecEdgeHighLightColor, LColor) then
        LColor := cl3DDkShadow;
      Canvas.Brush.Color := LColor;
      Canvas.FillRect(Rect(Left + 2, Top + 1, Left + 4, Top + 5));
    end
    else
    begin
      Top := TopTip;
      Left := LeftTip;
      { Draw the right box }
      Canvas.MoveTo(Left + 4, Top + 1);
      Canvas.LineTo(Left + 9, Top + 1);
      Canvas.LineTo(Left + 9, Top + 5);
      Canvas.LineTo(Left + 3, Top + 5);
      { Draw the middle line }
      Canvas.MoveTo(Left + 3, Top);
      Canvas.LineTo(Left + 3, Top + 7);
      { Draw a depth line }
      Canvas.MoveTo(Left + 4, Top + 4);
      Canvas.LineTo(Left + 9, Top + 4);
      Canvas.MoveTo(Left, Top + 3);
      Canvas.LineTo(Left + 3, Top + 3);

      if not GetThemeColor(LDetails, ecEdgeHighLightColor, LColor) then
        LColor := cl3DDkShadow;
      Canvas.Brush.Color := LColor;
      Canvas.FillRect(Rect(Left + 4, Top + 2, Left + 9, Top + 4));
    end;
  end;

  procedure DrawCloseButton(const ARect: TRect);
  var
    LeftTip, TopTip: Integer;
  begin
    LeftTip := ARect.Left - 2;
    TopTip := ARect.Top;
    LDetails := LStyle.GetElementDetails(tpDockPanelCloseNormal);

    PaintCloseX(LeftTip, TopTip);
  end;

  procedure DrawPinButton(const ARect: TRect);
  var
    LeftTip, TopTip: Integer;
  begin
    if Self.DockCaptionPinButton = dcpbUp then
    begin
      LeftTip := ARect.Left + 2;
      TopTip := ARect.Top + 3;
    end
    else
    begin
      LeftTip := ARect.Left + 3;
      TopTip := ARect.Top + 1;
    end;
    LDetails := LStyle.GetElementDetails(tpDockPanelPinNormal);
    PaintPin(LeftTip, TopTip);
  end;

const
  CHorzStates: array [Boolean] of TThemedPanel = (tpDockPanelHorzNormal, tpDockPanelHorzSelected);
  CVertStates: array [Boolean] of TThemedPanel = (tpDockPanelVertNormal, tpDockPanelVertSelected);
var
  ShouldDrawClose: Boolean;
  CloseRect, PinRect: TRect;
begin
  // inherited;

  LStyle := StyleServices;
  LDetails := LStyle.GetElementDetails(CHorzStates[State.Focused]);

  if not GetThemeColor(LDetails, ecTextColor, LColor) then
    LColor := State.FontColor;
  Canvas.Font.Color := LColor;
  Canvas.Pen.Width := 1;
  if not GetThemeColor(LDetails, ecBorderColor, LColor) then
    LColor := State.StartColor;
  Canvas.Pen.Color := LColor;

  if Self.DockCaptionOrientation = dcoHorizontal then
  begin
    CaptionRect.Top := CaptionRect.Top + 1;

    if not GetThemeColor(LDetails, ecFillColor, LColor) then
      if State.Focused then
        LColor := clLtGray
      else
        LColor := clBtnFace;
    Canvas.Brush.Color := LColor;

    // Canvas.FillRect(CaptionRect);
    Canvas.FillRect(Rect(CaptionRect.Left - 1, CaptionRect.Top - 1, CaptionRect.Right + 2, CaptionRect.Bottom));

    { Get the close rect size/position }
    CloseRect := GetCloseRect(CaptionRect);
    { Does it have the pin button? Make some room for it, and draw it. }
    if Self.DockCaptionPinButton <> dcpbNone then
    begin
      PinRect := GetPinRect(CaptionRect);
      if Self.DockCaptionPinButton = dcpbUp then
        Inc(PinRect.Top); { Down a little further - better looks }
      DrawPinButton(PinRect);
      CaptionRect.Right := PinRect.Right - 2;
    end
    else
    begin
      { Shrink the rect to consider the close button on the right, and
        not draw text in it. }
      CaptionRect.Right := CloseRect.Right - 2;
    end;

    { Move away from the left edge a little before drawing text }
    CaptionRect.Left := CaptionRect.Left + 6;
    { Draw the icon, if found. }
    // DrawIcon;
    ShouldDrawClose := CloseRect.Left >= CaptionRect.Left;
  end
  else
  begin

  end;

  Canvas.Brush.Style := bsClear; { For drawing the font }
  if State.Caption <> '' then
  begin
    if State.Focused then
      Canvas.Font.Style := Canvas.Font.Style + [fsBold]
    else
      Canvas.Font.Style := Canvas.Font.Style - [fsBold];

    if ShouldDrawClose then
      CaptionRect.Right := CaptionRect.Right - (CloseRect.Right - CloseRect.Left) - 4;

    Canvas.TextRect(CaptionRect, State.Caption, [tfEndEllipsis, tfVerticalCenter, tfSingleLine]);
  end;

  if ShouldDrawClose then
    DrawCloseButton(CloseRect);
end;

const
  cSideBuffer = 4;

function TThinDockCaptionDrawer.GetCloseRect(const CaptionRect: TRect): TRect;
var
  CloseSize: Integer;
begin
  CloseSize := CalcButtonSize(CaptionRect);
  if Self.DockCaptionOrientation = dcoHorizontal then
  begin
    Result.Left := CaptionRect.Right - CloseSize - cSideBuffer;
    Result.Top := CaptionRect.Top + ((CaptionRect.Bottom - CaptionRect.Top) - CloseSize) div 2;
  end
  else
  begin
    Result.Left := CaptionRect.Left + ((CaptionRect.Right - CaptionRect.Left) - CloseSize) div 2;
    Result.Top := CaptionRect.Top + 2 * cSideBuffer;
  end;
  Result.Right := Result.Left + CloseSize;
  Result.Bottom := Result.Top + CloseSize;
end;

function TThinDockCaptionDrawer.GetPinRect(const CaptionRect: TRect): TRect;
var
  PinSize: Integer;
begin
  PinSize := CalcButtonSize(CaptionRect);
  if Self.DockCaptionOrientation = dcoHorizontal then
  begin
    Result.Left := CaptionRect.Right - 2 * PinSize - 2 * cSideBuffer;
    Result.Top := CaptionRect.Top + ((CaptionRect.Bottom - CaptionRect.Top) - PinSize) div 2;
  end
  else
  begin
    Result.Left := CaptionRect.Left + ((CaptionRect.Right - CaptionRect.Left) - PinSize) div 2;
    Result.Top := CaptionRect.Top + 2 * cSideBuffer + 2 * PinSize;
  end;
  Result.Right := Result.Left + PinSize + 2;
  Result.Bottom := Result.Top + PinSize;
end;

end.
