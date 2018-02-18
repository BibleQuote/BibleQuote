unit AlekPageControl;

interface
{$R clsb.res}
uses Windows, Classes, ComCtrls, Graphics, Forms, Controls, ExtCtrls,
Messages, GraphUtil;
type
  TAlekPageControl = class;
  TAlekPageControlDeleteTab = procedure(sender: TAlekPageControl; index: integer)
    of object;
   TAlekPageControlDblClck = procedure(sender: TAlekPageControl; index: integer)
    of object;
  TAlekPageControl = class(TPageControl)
  private


  protected
    FCloseImage: HICON;
    FOnDeleteTab: TAlekPageControlDeleteTab;
    FOnDblClk:TAlekPageControlDblClck;
    mWheelAcc:integer;
    mDelLocked:integer;
{    FFontHandle: HFont;}
    //procedure DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean);
//      override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
//    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure CMMouseWheel(var Message: TCMMouseWheel); message CM_MOUSEWHEEL;
  public
    property CloseTabImage: HICON read FCloseImage write FCloseImage;
  published
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property OnDeleteTab: TAlekPageControlDeleteTab read FOnDeleteTab write
      FOnDeleteTab;
    property OnDblClick :TAlekPageControlDblClck read FOnDblClk write FOnDblClk;
  end;

  TAlekPanel = class(TPanel)
  protected
    mGradientDirection: TGradientDirection;
    mGradientStartColor, mGradientEndColor: TColor;
    procedure Paint(); override;
  published
    property GradientDirection: TGradientDirection read mGradientDirection write
      mGradientDirection;
    property GradientStartColor: TColor read mGradientStartColor write
      mGradientStartColor;
    property GradientEndColor: TColor read mGradientEndColor write
      mGradientEndColor;
  end;

procedure Register();
implementation

uses SysUtils, CommCtrl, Types;

procedure Register();
begin
  RegisterComponents('Samples', [TAlekPageControl, TAlekPanel]);
end;
{ TAlekPageControl }

procedure TAlekPageControl.CMMouseWheel(var Message: TCMMouseWheel);
begin
//
inherited;
Inc(mWheelAcc,Message.WheelDelta);
if (mWheelAcc>=360) or (mWheelAcc<=-360) then begin
  ScrollTabs(ord(mWheelAcc<0)*2-1);
  mWheelAcc:=0;
end;
end;

constructor TAlekPageControl.Create(AOwner: TComponent);
begin
  inherited;

//  FCloseImage := TIcon.Create();
//  FCloseImage.SetSize(13,13);
end;


destructor TAlekPageControl.Destroy;
begin
  inherited;
//  FCloseImage.Free();
end;

(*procedure TAlekPageControl.DrawTab(TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
var
  image_width, image_height, textlength, fontheight: integer;
  textRect, saveRect, r2: TRect;
  _caption: WideString;
  pCaption: PWideChar;
  ts: TTntTabSheet;
  delta, oldright, savelength: integer;
  themesEnabled: boolean;
  themeServices: TThemeServices;
  themedElemId: TThemedTab;
  themedElementDetails: TThemedElementDetails;
  nDC: HDC;
  //          currentFontHandle:HFont;
begin
//  inherited;
//Canvas.Brush.Color:=RGB(255,0,0);
//Canvas.FillRect(Rect);

  image_width := FCloseImage.Width; image_height := FCloseImage.Height;
  if (image_width < 3) or (image_height < 3) then exit;
  themeServices := Themes.ThemeServices();
  r2 := Rect;
{if themeServices.ThemesEnabled then begin
  nDC:=GetWindowDC(Self.Handle);
  Inc(r2.Top,0);
  Inc(r2.Left,2);
  Dec(r2.Right,2);
  if Active then themedElemId:=ttTopTabItemSelected else themedElemId:=ttTabItemNormal;
  themedElementDetails:=themeServices.GetElementDetails(themedElemId);
  themeServices.DrawElement(nDC{Canvas.Handle, themedElementDetails, R2);

  if Active then themedElemId:=ttTopTabItemBothEdgeSelected else themedElemId:=ttTabItemBothEdgeNormal;
  themedElementDetails:=themeServices.GetElementDetails(themedElemId);
  themeServices.DrawElement(nDC{Canvas.Handle, themedElementDetails, R2);
//  themedElementDetails:=themeServices.GetElementDetails(tt;
//  themeServices.DrawElement(Canvas.Handle, themedElementDetails, Rect);
ReleaseDC(Self.Handle, nDC);
end;   }
  if not FCloseImage.Empty then
  //  Canvas.Draw(r2.Right - image_width - 4, r2.Top + 3, FCloseImage);
  BitBlt(Canvas.Handle,r2.Right - image_width - 4, r2.Top + 3,
   image_width,  image_height, FCloseImage.Handle, 0,0, SRCINVERT);
  if Active then begin
//Canvas.Font.Color:=clHighlight; //��������� ������ ������
    Canvas.Font.Style := [fsBold];
  end;
  fontheight := Canvas.Font.Height;
  if fontheight < 0 then fontheight := -fontheight + 5;
  with textRect do begin
    Top := r2.Top + ((r2.Bottom - r2.Top) - fontheight) div 2;
    if not Active then Inc(Top, 2);
    Left := r2.Left + 5;
    Right := r2.Right - image_width - 4;
    Bottom := r2.Bottom;
  end;
//currentFontHandle:=Canvas.Font.Handle;
  saveRect := textRect;
  ts := TTntTabSheet(Pages[TabIndex]);
  _caption := ts.Caption;
  textlength := length(TrimRight(_caption));
  savelength := textlength;
  pCaption := PWideChar(integer(_caption));
  Canvas.TextFlags := 0;
  DrawTextW(Canvas.Handle, pCaption, textlength, textRect, DT_CALCRECT or
    DT_CENTER or DT_VCENTER);
  delta := (r2.Right - textRect.Right - image_width - 17);
  oldright := textRect.Right;
  while delta + textRect.Right - oldright <= 0 do begin
    _caption := _caption + '  ';
    pCaption := PWideChar(integer(_caption));
    textlength := length(_caption);
    DrawTextW(Canvas.Handle, pCaption, textlength, textRect, DT_CALCRECT or
      DT_CENTER or DT_VCENTER);
  end;
  if length(ts.Caption) <> length(_caption) then ts.Caption := _caption;
  SetBkMode(Canvas.Handle, TRANSPARENT);
  DrawTextW(Canvas.Handle, pCaption, savelength, saveRect, DT_CENTER or
    DT_VCENTER);

//ExtTextOutW(Canvas.Handle, saveRect.Left, saveRect.Top, ETO_CLIPPED,nil, pCaption,savelength, nil);
//textlength,nil);
end;
  *)

procedure TAlekPageControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  _tabIndex{, saveTabIndex}: integer;
  tabRect: TRect;
  point: TPoint;
  image_width, image_height: integer;
label
  default_processing;
begin
  if Button <> mbLeft then goto default_processing;
  _tabIndex := IndexOfTabAt(X, Y);
  if _tabIndex < 0 then goto default_processing;
  TabCtrl_GetItemRect(Handle, tabIndex, tabRect);
  point.X := X; point.Y := Y;
  //saveTabIndex := TabIndex;//AlekId:Hint
  image_width := 13; image_height :=13;
  if (image_width < 3) or (image_height < 3) then goto default_processing;
  tabRect.Left := tabRect.Right - image_width - 4; Inc(tabRect.Top, 3);
    tabRect.Bottom := tabRect.Top + image_height + 3;
  if not PtInRect(TabRect, point) then goto default_processing;
  exit;
  default_processing:
  inherited;
end;

procedure TAlekPageControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  _tabIndex, saveTabIndex: integer;
  tabRect: TRect;
  point: TPoint;
  image_width, image_height: integer;
begin
  inherited;

  if  (Button <> mbLeft) then exit;
  _tabIndex := IndexOfTabAt(X, Y);
  if _tabIndex < 0 then exit;
  TabCtrl_GetItemRect(Handle, tabIndex, tabRect);
  point.X := X; point.Y := Y;
  saveTabIndex := TabIndex;
  image_width := 13; image_height := 13;
  if (image_width < 3) or (image_height < 3) then exit;
  tabRect.Left := tabRect.Right - image_width - 4; Inc(tabRect.Top, 3);
    tabRect.Bottom := tabRect.Top + image_height + 3;
  if (not PtInRect(TabRect, point))  then exit;
//Tabs.Delete(tabIndex);
  if (mDelLocked>0) then exit;
  if not assigned(FOnDeleteTab) then exit;
  FOnDeleteTab(self, _tabIndex);
  if (saveTabIndex >= Tabs.Count) then saveTabIndex := Tabs.Count;
  TabIndex := saveTabIndex;
end;

procedure TAlekPageControl.WMLButtonDblClk(var Message: TWMLButtonDblClk);
var ix:integer;
begin
if not assigned(FOnDblClk ) then begin inherited; exit end;
ix:=IndexOfTabAt(message.XPos,message.YPos);
if (ix<0) or (ix>=PageCount) then begin inherited; exit end;
FOnDblClk(self, ix);
end;

//procedure TAlekPageControl.WMMouseWheel(var Message: TWMMouseWheel);
//begin
////
//
//end;

procedure TAlekPageControl.WMPaint(var Message: TWMPaint);
var
  i, cnt, aix: integer;
  r2: TRect;
  active: boolean;
  image_width, {image_height,} textlength, fontheight: integer;
  textRect, saveRect: TRect;
  _caption: WideString;
  pCaption: PWideChar;
  ts: TTabSheet;
  delta, oldright{, savelength}: integer;
begin
  inherited;
  if csDesigning in ComponentState then exit;
  Inc(mDelLocked);
  try

//  themeServices := Themes.ThemeServices();   //AlekId:Hint
  aix := ActivePageIndex;
  cnt := PageCount - 1;
  if cnt<=0 then exit;
  image_width := 13;// image_height := 13;
//  if (image_width < 3) or (image_height < 3) then exit;
  for i := 0 to cnt do begin
    active := i = aix;
    if (SendMessage(Handle, TCM_GETITEMRECT, i, LPARAM(@r2)) = 0) then continue;

    if FCloseImage<>0 then begin
      DrawIconEx(Canvas.Handle, r2.Right - image_width - 4, r2.Top + 3, FCloseImage, 13,13,0, 0, DI_NORMAL);
//      Canvas.Draw(r2.Right - image_width - 4, r2.Top + 3, FCloseImage);
//       bitmapRect.Left:=r2.Right - image_width - 4;
//       bitmapRect.Top:=r2.Top + 3;

//       Canvas.BrushCopy();
//       BitBlt(Canvas.Handle,r2.Right - image_width - 4, r2.Top + 3,
//   image_width,  image_height, FCloseImage.Handle, 0,0, SRCCOPY);
      end;
    if Active then begin
//Canvas.Font.Color:=clHighlight; //��������� ������ ������
      Canvas.Font.Style := [fsBold];
    end;
    fontheight := Canvas.Font.Height;
    if fontheight < 0 then fontheight := -fontheight + 5;
    with textRect do begin
      Top := r2.Top + ((r2.Bottom - r2.Top) - fontheight) div 2;
      if not Active then Inc(Top, 2);
      Left := r2.Left + 5;
      Right := r2.Right - image_width - 4;
      Bottom := r2.Bottom;
    end;
    saveRect := textRect;
    ts := TTabSheet(Pages[i]);

    _caption := ts.Caption;


    textlength := length(TrimRight(_caption));


    if textlength=0 then begin
       if length(_caption)=0  then _caption:=' ';
       textlength:=1;
      end;

//    savelength := textlength;
    pCaption := PWideChar(Pointer(_caption));
    Canvas.TextFlags := 0;
    DrawTextW(Canvas.Handle, pCaption, textlength, textRect, DT_CALCRECT or
      DT_CENTER or DT_VCENTER);
    delta := (r2.Right - textRect.Right - image_width - 7);
    oldright := textRect.Right;
    while delta + textRect.Right - oldright <= 0 do begin
      _caption := _caption + ' ';
      pCaption := PWideChar(Pointer(_caption));
      textlength := length(_caption);
      DrawTextW(Canvas.Handle, pCaption, textlength, textRect, DT_CALCRECT or
        DT_CENTER or DT_VCENTER);

    end;
    if length(ts.Caption) <> length(_caption) then ts.Caption := _caption;
//    SetBkMode(Canvas.Handle, TRANSPARENT);
//    DrawTextW(Canvas.Handle, pCaption, savelength, saveRect, DT_CENTER or
//      DT_VCENTER);
//  themedElementDetails:=themeServices.GetElementDetails(tt;
//  themeServices.DrawElement(Canvas.Handle, themedElementDetails, Rect);
  end; //for
  finally Dec(mDelLocked); end;
end;

{ TAlekPanel }

procedure TAlekPanel.Paint;
begin

if not (csDesigning in ComponentState) then begin

  GradientFillCanvas(canvas, mGradientStartColor, mGradientEndColor,
    GetClientRect(),
    mGradientDirection);
end else   inherited;
end;


end.

