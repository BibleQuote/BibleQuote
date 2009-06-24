unit AlekPageControl;

interface
{$R clsb.res}
uses Windows, Classes, TntComCtrls, Graphics,Forms,Controls ;
type
TAlekPageControl=class;
TAlekPageControlDeleteTab=procedure (sender:TAlekPageControl;index:integer) of object;
 TAlekPageControl=class(TTntPageControl)
 protected
 FCloseImage:TBitmap;
 FOnDeleteTab:TAlekPageControlDeleteTab;
 FFontHandle:HFont;
 procedure DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean); override;
 procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
 procedure DblClick; override;
 public
 property CloseTabImage:TBitmap read FCloseImage;
 published
 constructor Create(AOwner: TComponent); override;
 destructor Destroy; override;
 property OnDeleteTab:TAlekPageControlDeleteTab read FOnDeleteTab write FOnDeleteTab;
 end;
 procedure Register();
implementation

uses SysUtils, ComCtrls, CommCtrl, Types;
procedure Register();
begin
  RegisterComponents('Samples',[TAlekPageControl]);
end;
{ TAlekPageControl }

constructor TAlekPageControl.Create(AOwner: TComponent);
begin
  inherited;
FCloseImage:=TBitmap.Create();
FFontHandle:=0;
end;

procedure TAlekPageControl.DblClick;
begin
  inherited;

end;

destructor TAlekPageControl.Destroy;
begin
  inherited;
  FCloseImage.Free();
end;

procedure TAlekPageControl.DrawTab(TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
var        image_width, image_height, textlength, fontheight:integer;
            textRect, saveRect:TRect;
            _caption:WideString;
            pCaption:PWideChar;
            ts:TTntTabSheet;
            delta, oldright, savelength:integer;
            currentFontHandle:HFont;
begin
//  inherited;
//Canvas.Brush.Color:=RGB(255,0,0);
//Canvas.FillRect(Rect);
image_width:=FCloseImage.Width; image_height:=FCloseImage.Height;
if (image_width<3) or (image_height<3) then exit;
if not FCloseImage.Empty then
Canvas.Draw(Rect.Right-image_width-4,Rect.Top+3, FCloseImage);
if Active then begin
Canvas.Font.Color:=clHighlight;
Canvas.Font.Style:=[fsBold];
end;
fontheight:=Canvas.Font.Height;
if fontheight<0 then fontheight:=-fontheight+5;
with textRect do begin
  Top:=Rect.Top+((Rect.Bottom-Rect.Top)-fontheight) div 2;
  if not Active then Inc(Top, 2);
  Left:=Rect.Left+5;
  Right:=Rect.Right-image_width-4;
  Bottom:=Rect.Bottom;
end;
currentFontHandle:=Canvas.Font.Handle;
saveRect:=textRect;
ts:= TTntTabSheet(Pages[TabIndex]);
_caption:=ts.Caption;
textlength:=length(TrimRight(_caption) );
savelength:=textlength;
pCaption:=PWideChar(integer(_caption) );
DrawTextW(Canvas.Handle,pCaption,textlength, textRect, DT_CALCRECT or DT_CENTER or DT_VCENTER);
delta:=(Rect.Right-textRect.Right- image_width-5);
oldright:=textRect.Right;
while delta+textRect.Right-oldright<=0 do begin
_caption:=_caption+'  ';
pCaption:=PWideChar(integer(_caption) );
textlength:=length(_caption);
DrawTextW(Canvas.Handle,pCaption,textlength, textRect, DT_CALCRECT or DT_CENTER or DT_VCENTER);
end ;
if length(ts.Caption)<>length(_caption) then ts.Caption:=_caption;
DrawTextW(Canvas.Handle,pCaption,savelength, saveRect,  DT_CENTER or DT_VCENTER);
//textlength,nil);
end;

procedure TAlekPageControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
  var _tabIndex, saveTabIndex:integer;
      tabRect:TRect;
      point:TPoint;
      image_width, image_height:integer;
begin
  inherited;
if Button<>mbLeft then exit;
_tabIndex:=  IndexOfTabAt(X,Y);
if _tabIndex<0 then exit;
TabCtrl_GetItemRect(Handle, tabIndex, tabRect);
point.X:=X; point.Y:=Y;
saveTabIndex:=TabIndex;
image_width:=FCloseImage.Width; image_height:=FCloseImage.Height;
if (image_width<3) or (image_height<3) then exit;
tabRect.Left:=tabRect.Right-image_width-4; Inc(tabRect.Top,3); tabRect.Bottom:=tabRect.Top+image_height+3;
if not PtInRect(TabRect,point) then exit;
//Tabs.Delete(tabIndex);
if not assigned(FOnDeleteTab) then exit;
FOnDeleteTab(self,_tabIndex);
if (saveTabIndex>=Tabs.Count) then saveTabIndex:=Tabs.Count;
TabIndex:=saveTabIndex;
end;

end.
