unit bqClosablePageControl;

interface

uses Windows, Classes, ComCtrls, Graphics, Forms, Controls, ExtCtrls,
  Messages, GraphUtil, System.UITypes, ImgList;

type
  TClosablePageControl = class;
  TDeleteTab = procedure(sender: TClosablePageControl; index: integer)
    of object;
  TTabDoubleClick = procedure(sender: TClosablePageControl; index: integer)
    of object;

  TClosablePageControl = class(TPageControl)
  private

  protected
    FOnDeleteTab: TDeleteTab;
    FOnTabDoubleClick: TTabDoubleClick;
    FCloseButtonIndex: TImageIndex;
    mWheelAcc: integer;
    mDelLocked: integer;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk);
      message WM_LBUTTONDBLCLK;
    procedure CMMouseWheel(var Message: TCMMouseWheel); message CM_MOUSEWHEEL;
    procedure SetCloseButtonIndex(const Value: TImageIndex);
    procedure UpdateActivePage; override;
  published
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CloseButtonIndex: TImageIndex read FCloseButtonIndex
      write SetCloseButtonIndex default -1;
    property OnDeleteTab: TDeleteTab read FOnDeleteTab write FOnDeleteTab;
    property OnTabDoubleClick: TTabDoubleClick read FOnTabDoubleClick
      write FOnTabDoubleClick;
  end;

procedure Register();

implementation

uses SysUtils, CommCtrl, Types;

procedure Register();
begin
  RegisterComponents('BqComponents', [TClosablePageControl]);
end;

procedure TClosablePageControl.UpdateActivePage;
begin
  inherited;
  InvalidateRect(Handle, ClientRect, TRUE);
end;

procedure TClosablePageControl.CMMouseWheel(var Message: TCMMouseWheel);
begin
  inherited;
  Inc(mWheelAcc, Message.WheelDelta);
  if (mWheelAcc >= 360) or (mWheelAcc <= -360) then
  begin
    ScrollTabs(ord(mWheelAcc < 0) * 2 - 1);
    mWheelAcc := 0;
  end;
end;

constructor TClosablePageControl.Create(AOwner: TComponent);
begin
  inherited;
  FCloseButtonIndex := -1;
end;

procedure TClosablePageControl.SetCloseButtonIndex(const Value: TImageIndex);
begin
  if Value <> FCloseButtonIndex then
  begin
    FCloseButtonIndex := Value;
    Invalidate;
  end;
end;

destructor TClosablePageControl.Destroy;
begin
  inherited;
end;

procedure TClosablePageControl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  tabIndex: integer;
  tabRect: TRect;
  point: TPoint;
  imageWidth, imageHeight: integer;
label
  default_processing;
begin
  if Button <> mbLeft then
    goto default_processing;
  tabIndex := IndexOfTabAt(X, Y);
  if tabIndex < 0 then
    goto default_processing;
  TabCtrl_GetItemRect(Handle, tabIndex, tabRect);
  point.X := X;
  point.Y := Y;

  imageWidth := 13;
  imageHeight := 13;
  if (imageWidth < 3) or (imageHeight < 3) then
    goto default_processing;
  tabRect.Left := tabRect.Right - imageWidth - 4;
  Inc(tabRect.Top, 3);
  tabRect.Bottom := tabRect.Top + imageHeight + 3;
  if not PtInRect(tabRect, point) then
    goto default_processing;
  exit;
default_processing:
  inherited;
end;

procedure TClosablePageControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
var
  tabIndex, saveTabIndex: integer;
  tabRect: TRect;
  point: TPoint;
  imageWidth, imageHeight: integer;
begin
  inherited;

  if (Button <> mbLeft) then
    exit;
  tabIndex := IndexOfTabAt(X, Y);
  if tabIndex < 0 then
    exit;
  TabCtrl_GetItemRect(Handle, tabIndex, tabRect);
  point.X := X;
  point.Y := Y;
  saveTabIndex := tabIndex;
  imageWidth := 13;
  imageHeight := 13;
  if (imageWidth < 3) or (imageHeight < 3) then
    exit;
  tabRect.Left := tabRect.Right - imageWidth - 4;
  Inc(tabRect.Top, 3);
  tabRect.Bottom := tabRect.Top + imageHeight + 3;
  if (not PtInRect(tabRect, point)) then
    exit;
  if (mDelLocked > 0) then
    exit;
  if not assigned(FOnDeleteTab) then
    exit;
  FOnDeleteTab(self, tabIndex);
  if (saveTabIndex >= Tabs.Count) then
    saveTabIndex := Tabs.Count;
end;

procedure TClosablePageControl.WMLButtonDblClk(var Message: TWMLButtonDblClk);
var
  ix: integer;
begin
  if not assigned(FOnTabDoubleClick) then
  begin
    inherited;
    exit
  end;
  ix := IndexOfTabAt(message.XPos, message.YPos);
  if (ix < 0) or (ix >= PageCount) then
  begin
    inherited;
    exit
  end;
  FOnTabDoubleClick(self, ix);
end;

procedure TClosablePageControl.WMPaint(var Message: TWMPaint);
var
  i, cnt, aix: integer;
  r2: TRect;
  active: boolean;
  imageWidth, textLength, fontHeight: integer;
  textRect, saveRect: TRect;
  caption: string;
  tabSheet: TTabSheet;
  delta, oldRight, iconOffset: integer;
  iconHandle: HICON;
begin
  inherited;
  if csDesigning in ComponentState then
    exit;
  Inc(mDelLocked);
  try
    aix := ActivePageIndex;
    cnt := PageCount - 1;
    if cnt <= 0 then
      exit;
    imageWidth := 13;

    if FCloseButtonIndex > -1 then
    begin
      iconHandle := ImageList_GetIcon(Images.Handle, FCloseButtonIndex, ILD_NORMAL);
    end;

    for i := 0 to cnt do
    begin
      active := i = aix;
      if (SendMessage(Handle, TCM_GETITEMRECT, i, LPARAM(@r2)) = 0) then
        continue;

      if FCloseButtonIndex > -1 then
      begin
        if active then iconOffset := 0 else iconOffset := 2;
        DrawIconEx(Canvas.Handle, r2.Right - imageWidth - 4, r2.Top + 3 + iconOffset,
          iconHandle, imageWidth, imageWidth, 0, 0, DI_NORMAL);
      end;
      if active then
      begin
        Canvas.Font.Style := [fsBold];
      end;
      fontHeight := Canvas.Font.Height;
      if fontHeight < 0 then
        fontHeight := -fontHeight + 5;
      with textRect do
      begin
        Top := r2.Top + ((r2.Bottom - r2.Top) - fontHeight) div 2;
        if not active then
          Inc(Top, 2);
        Left := r2.Left + 5;
        Right := r2.Right - imageWidth - 4;
        Bottom := r2.Bottom;
      end;
      saveRect := textRect;
      tabSheet := TTabSheet(Pages[i]);

      caption := tabSheet.caption;

      textLength := length(TrimRight(caption));

      if textLength = 0 then
      begin
        if length(caption) = 0 then
          caption := ' ';
        textLength := 1;
      end;

      Canvas.TextFlags := 0;
      DrawText(Canvas.Handle, caption, textLength, textRect,
        DT_CALCRECT or DT_CENTER or DT_VCENTER);
      delta := (r2.Right - textRect.Right - imageWidth - 7);
      oldRight := textRect.Right;
      while delta + textRect.Right - oldRight <= 0 do
      begin
        caption := caption + ' ';
        textLength := length(caption);
        DrawText(Canvas.Handle, caption, textLength, textRect,
          DT_CALCRECT or DT_CENTER or DT_VCENTER);

      end;
      if length(tabSheet.caption) <> length(caption) then
        tabSheet.caption := caption;
    end;
  finally
    Dec(mDelLocked);
    if (iconHandle > 0) then
    begin
      DestroyIcon(iconHandle);
    end;
  end;
end;

end.
