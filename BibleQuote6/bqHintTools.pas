unit bqHintTools;

interface
uses Controls,tntControls,tntForms,Classes,Windows,Forms, tntSysUtils;
type
TbqHintWindow=class(TTntCustomHintWindow)
procedure ActivateHint(Rect: TRect; const AHint: AnsiString); override;
function CalcHintRect(MaxWidth: Integer; const AHint: AnsiString; AData: Pointer): TRect; override;
end;
implementation

uses Types;

{ TbqHintWindow }

procedure TbqHintWindow.ActivateHint(Rect: TRect; const AHint: AnsiString);
var r, maxOffset:integer;

begin
  r:=Screen.DesktopRect.Right - Rect.Right-30;
  maxOffset:=Rect.Right-Screen.DesktopWidth-Rect.Left+30;
  if (maxOffset<0) and (r<0) then begin
    if maxOffset-r<0 then maxOffset:=r ;
    OffsetRect(Rect,maxOffset,0);
  end;

//    if ((rect.Right+10)>Screen.DesktopWidth) and (Rect.Left>30) then begin
//    OffsetRect(rect,-20,0);
  inherited;
end;

function TbqHintWindow.CalcHintRect(MaxWidth: Integer; const AHint: AnsiString;
  AData: Pointer): TRect;

var
  WideHintStr: WideString;
  h,w:integer;

begin
  if (not Win32PlatformIsUnicode)
  or (not DataPointsToHintInfoForTnt(AData)) then  begin
    Result :=  inherited CalcHintRect(MaxWidth, AHint, AData);
    exit
end;
//    result:=inherited CalcHintRect(MaxWidth, AHint, AData);
//   exit;
    WideHintStr := ExtractTntHintCaption(AData);
  Canvas.Font.Assign(Screen.HintFont);
  Result := Rect(0, 0, MaxWidth, 0);
  h:=DrawTextW(Canvas.Handle, Pointer(WideHintStr), -1, Result,
   DT_CALCRECT or DT_LEFT or  DT_WORDBREAK or DT_NOPREFIX);
  if (h<Screen.Height) and (result.Right*3>=Screen.Width) then begin
  w:=round(Sqrt(7*h*Result.Right/3) *10/9);
  if w*3<Screen.Width then w:=Screen.Width div 3;
  repeat
  w:=w*9 div 10;
  Result := Rect(0, 1, w, 0);
  h:=DrawTextW(Canvas.Handle, Pointer(WideHintStr), -1, Result,
   DT_CALCRECT or DT_LEFT or DT_EXTERNALLEADING or   DT_WORDBREAK or DT_NOPREFIX  or DT_EDITCONTROL
   or  DrawTextBiDiModeFlagsReadingOnly);
  until (h<Screen.Height-50) or (w<100);
  end;
  Inc(Result.Right, 8);
  Inc(Result.Bottom, 4);
 end;




end.
