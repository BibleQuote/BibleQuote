unit rkGlassButton;
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
// GlassButton by Roy Magne Klever
//
// WEB: www.rmklever.com
// Mail: roymagne@rmklever.com
//
// version 2.4, Feb 2014
//
// MPL 1.1 licenced

interface

uses
  Windows, SysUtils, Classes, Controls, ExtCtrls, Graphics, Forms, Messages,
  ImgList, Math, Menus, Dialogs, System.Types;

const
  CM_POPREFRESH = WM_USER + 1299; // Custom Message...
  CM_POPUP = WM_USER + 1300;

type
  TWinControlCracker = class(TWinControl);
  PRGB24 = ^TRGB24;

  TRGB24 = packed record
    B: Byte;
    G: Byte;
    R: Byte;
  end;

  PLine24 = ^TLine24;
  TLine24 = packed array [0 .. MaxInt div SizeOf(TRGB24) - 1] of TRGB24;
  PRGBArray = ^TRGBArray;
  TRGBArray = packed array [0 .. MaxInt div SizeOf(TRGB24) - 1] of TRGB24;
  TShadowStyle = (ssNone, ssGlow, ssDrop);
  TTextAlign = (taLeft, taCenter, taRight);
  TGlyphPos = (gpTop, gpBottom, gpLeft, gpRight);
  TClickStyle = (csLeft, csRight, csMiddle, csEnter);
  TAlphaRender = procedure(ABitmap: TBitmap; ARect: TRect; AColor: TColor;
    Alpha: Byte) of Object;

  TrkGlassButton = class(TCustomControl)
  private
    ArrowX, ArrowY: Integer;
    GlyphX, GlyphY: Integer;
    TextX, TextY: Integer;
    TextRect: TRect;
    GlowColor: TRGB24;
    FAltFocus: Boolean;
    FAltRender: Boolean;
    FArrow: Boolean;
    FArrowWidth: Integer;
    FAutoSize: Boolean;
    FBlurLevel: Integer;
    FBmp: TBitmap;
    FBtnIdx: Integer;
    FButtonDown: Boolean;
    FClickStyle: TClickStyle;
    FColor: TColor;
    FColorDown: TColor;
    FColorFocused: TColor;
    FColorFrame: TColor;
    FColorGlow: TColor;
    FDisabledColor: TColor;
    FDown: Boolean;
    FDuoStyle: Boolean;
    FFlat: Boolean;
    FFlatDown: Boolean;
    FGloss: Integer;
    FGlossy: Boolean;
    FGlossyLevel: Byte;
    FGlyphPos: TGlyphPos;

    FImageChangeLink: TChangeLink;
    FImageIndex: TImageIndex;
    FImages: TCustomImageList;

    FImageOffset: Integer;
    FImageSpacing: Integer;
    FLightHeight: Integer;
    FNoClick: Boolean;
    FPopup: Boolean;
    FPopupAlignment: TPopupAlignment;
    FPopupMenu: TPopupMenu;
    FPopupOff: Integer;
    FShadowStyle: TShadowStyle;
    FSingleBorder: Boolean;
    FTextAlign: TTextAlign;
    FOnPopup: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnBeforePopup: TNotifyEvent;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure CMIsToolControl(var Msg: TMessage); message CM_ISTOOLCONTROL;
    procedure CMPopUp(var Msg: TMessage); message CM_POPUP;
    procedure CMTextChanged(var Msg: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Msg: TMessage); message CM_FONTCHANGED;
    procedure ImageListChange(Sender: TObject);
    procedure InitPos;
    procedure PaintButton;
    procedure SetColor(const Value: TColor);
    procedure SetFrameColor(const Value: TColor);
    procedure SetColorDown(const Value: TColor);
    procedure SetDuoStyle(const Value: Boolean);
    procedure SetArrow(const Value: Boolean);
    procedure SetImageIndex(Value: TImageIndex);
    procedure PaintAlphaArrow(ShowDown: Boolean);
    procedure PaintAlphaRect(ABitmap: TBitmap; ARect: TRect; AColor: TColor;
      Alpha: Byte);
    procedure PaintAlphaTxt(ShowDown, ShowArrow: Boolean);
    procedure SetColorFocused(const Value: TColor);
    procedure SetDown(const Value: Boolean);
    procedure SetGlossy(const Value: Boolean);
    procedure SetGlossyLevel(const Value: Byte);
    procedure SetImageSpacing(const Value: Integer);
    procedure SetImageOffset(const Value: Integer);
    procedure SetLightHeight(const Value: Integer);
    procedure SetShadowColor(const Value: TColor);
    procedure SetShadowStyle(const Value: TShadowStyle);
    procedure SetSingleBorder(const Value: Boolean);
    procedure WMERASEBKGND(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged);
      message WM_WINDOWPOSCHANGED;
    procedure SetDisabledColor(const Value: TColor);
    procedure SetFlat(const Value: Boolean);
    procedure SetTextAlign(const Value: TTextAlign);
    procedure PaintAlphaRectAlt(ABitmap: TBitmap; ARect: TRect; AColor: TColor;
      Alpha: Byte);
    procedure SetAltFocus(const Value: Boolean);
    procedure SetAltRender(const Value: Boolean);
    procedure SetFlatDown(const Value: Boolean);
    procedure SetGlyphPos(const Value: TGlyphPos);
    procedure SetImages(Value: TCustomImageList);
    procedure SetArrowWidth(const Value: Integer);
    procedure SetAutoSize(const Value: Boolean);
    { Private declarations }
  protected
    { Protected declarations }
    AlphaRender: TAlphaRender;
    InCreate: Boolean;
    MClick: Boolean;
    InBtn: Boolean;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure Click; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure PaintWindow(DC: HDC); override;
    procedure Resize; override;
    procedure SetEnabled(Value: Boolean); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function BtnAutoSize(Calc: Boolean): TPoint;
    procedure DoClick(Sender: TObject; ClickStyle: TClickStyle = csLeft);
    procedure ShowPopup;
    property ClickStyle: TClickStyle read FClickStyle;
  published
    { Published declarations }
    property Action;
    property Align;
    property AltFocus: Boolean read FAltFocus write SetAltFocus;
    property AltRender: Boolean read FAltRender write SetAltRender;
    property Anchors;
    property Arrow: Boolean read FArrow write SetArrow default False;
    property ArrowWidth: Integer read FArrowWidth write SetArrowWidth
      default 18;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property Caption;
    property Color: TColor read FColor write SetColor default $00F4F4F4;
    property ColorDown: TColor read FColorDown write SetColorDown
      default clGray;
    property ColorFocused: TColor read FColorFocused write SetColorFocused
      default clYellow;
    property ColorFrame: TColor read FColorFrame write SetFrameColor
      default clSilver;
    property ColorShadow: TColor read FColorGlow write SetShadowColor
      default clBlack;
    property ColorDisabled: TColor read FDisabledColor write SetDisabledColor
      default clSilver;
    property Down: Boolean read FDown write SetDown default False;
    property DropDownAlignment: TPopupAlignment read FPopupAlignment
      write FPopupAlignment;
    property DropDownMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property DuoStyle: Boolean read FDuoStyle write SetDuoStyle default False;
    property Enabled;
    property Flat: Boolean read FFlat write SetFlat default True;
    property FlatDown: Boolean read FFlatDown write SetFlatDown default False;
    property Font;
    property Glossy: Boolean read FGlossy write SetGlossy default False;
    property GlossyLevel: Byte read FGlossyLevel write SetGlossyLevel
      default 20;
    property GlyphPos: TGlyphPos read FGlyphPos write SetGlyphPos;
    property Height;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex;
    property ImageOffset: Integer read FImageOffset write SetImageOffset
      default 4;
    property Images: TCustomImageList read FImages write SetImages;
    property ImageSpacing: Integer read FImageSpacing write SetImageSpacing
      default 4; // ANDRE
    property Left;
    property LightHeight: Integer read FLightHeight write SetLightHeight;
    property ParentFont;
    property PopupOffset: Integer read FPopupOff write FPopupOff default 0;
    property ShadowStyle: TShadowStyle read FShadowStyle write SetShadowStyle
      default ssNone;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TextAlign: TTextAlign read FTextAlign write SetTextAlign;
    property Top;
    property Visible;
    property Width;
    property OnBeforePopup: TNotifyEvent read FOnBeforePopup
      write FOnBeforePopup;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnKeyDown;
    property OnKeyUp;
    property OnResize;
    property SingleBorder: Boolean read FSingleBorder write SetSingleBorder
      default False;
  end;

procedure Register;

implementation

uses
  ActnList;

procedure DrawParentImage(Control: TControl; Dest: TCanvas);
var
  SaveIndex: Integer;
  DC: HDC;
  Position: TPoint;
begin
  with Control do
  begin
    if Parent = nil then
      Exit;
    DC := Dest.Handle;
    SaveIndex := SaveDC(DC);
{$IFDEF DFS_COMPILER_2}
    GetViewportOrgEx(DC, @Position);
{$ELSE}
    GetViewportOrgEx(DC, Position);
{$ENDIF}
    SetViewportOrgEx(DC, Position.X - Left, Position.Y - Top, nil);
    IntersectClipRect(DC, 0, 0, Parent.ClientWidth, Parent.ClientHeight);
    Parent.Perform(WM_ERASEBKGND, WParam(DC), 0);
    Parent.Perform(WM_PAINT, WParam(DC), 0);
    RestoreDC(DC, SaveIndex);
  end;
end;

procedure fxBoxBlur(Src: TBitmap; radius, rep: Integer);
type
  PintRGB = ^TintRGB;

  TintRGB = packed record
    iB: Integer;
    iG: Integer;
    iR: Integer;
  end;
var
  j, divF, i, w, h, X, Y, ny, tx, ty, prg, rad1: Integer;
  ox, radm1, boxW, boxH: Integer;
  p: PRGB24;
  ptrS, ptrD, pv: Integer;
  s0, s1: PRGB24;
  bool: Boolean;
  lutRGB: array of TintRGB;
  R, G, B: Byte;
begin
  if radius = 0 then
    Exit;
  divF := (radius * 2) + 1;
  w := Src.Width - 1;
  h := Src.Height - 1;
  SetLength(lutRGB, Max(w, h) + 1 + (radius * 2));
  s1 := Src.ScanLine[0];
  ptrD := Integer(Src.ScanLine[1]) - Integer(s1);
  rad1 := radius - 1;
  ny := Integer(s1);
  for Y := 0 to h do
  begin
    for j := 1 to rep do
    begin
      for i := -radius to 0 do
      begin
        with PRGB24(ny)^, lutRGB[i + radius] do
        begin
          iR := R + lutRGB[i + radius - 1].iR;
          iG := G + lutRGB[i + radius - 1].iG;
          iB := B + lutRGB[i + radius - 1].iB;
        end;
      end;
      for i := 1 to w do
      begin
        tx := i;
        with PRGB24(ny + tx * 3)^, lutRGB[i + radius] do
        begin
          iR := R + lutRGB[i + radius - 1].iR;
          iG := G + lutRGB[i + radius - 1].iG;
          iB := B + lutRGB[i + radius - 1].iB;
        end;
      end;
      prg := w * 3;
      for i := w + 1 to w + radius do
      begin
        with PRGB24(ny + prg)^, lutRGB[i + radius] do
        begin
          iR := R + lutRGB[i + radius - 1].iR;
          iG := G + lutRGB[i + radius - 1].iG;
          iB := B + lutRGB[i + radius - 1].iB;
        end;
      end;
      ox := 0;
      for X := 0 to w do
      begin
        tx := X + radius;
        with PRGB24(ny + ox)^, lutRGB[tx + radius] do
        begin
          R := ((iR - lutRGB[tx - radius - 1].iR) div divF);
          G := ((iG - lutRGB[tx - radius - 1].iG) div divF);
          B := ((iB - lutRGB[tx - radius - 1].iB) div divF);
        end;
        inc(ox, 3);
      end;
    end;
    inc(ny, ptrD);
  end;
  ox := 0;
  for X := 0 to w do
  begin
    for j := 0 to rep do
    begin
      ny := Integer(s1);
      for i := -radius to 0 do
      begin
        with PRGB24(ny + X * 3)^, lutRGB[i + radius] do
        begin
          iR := R + lutRGB[i + radius - 1].iR;
          iG := G + lutRGB[i + radius - 1].iG;
          iB := B + lutRGB[i + radius - 1].iB;
        end;
      end;
      for i := 1 to h do
      begin
        inc(ny, ptrD);
        with PRGB24(ny + X * 3)^, lutRGB[i + radius] do
        begin
          iR := R + lutRGB[i + radius - 1].iR;
          iG := G + lutRGB[i + radius - 1].iG;
          iB := B + lutRGB[i + radius - 1].iB;
        end;
      end;
      for i := h + 1 to h + radius do
      begin
        with PRGB24(ny + X * 3)^, lutRGB[i + radius] do
        begin
          iR := R + lutRGB[i + radius - 1].iR;
          iG := G + lutRGB[i + radius - 1].iG;
          iB := B + lutRGB[i + radius - 1].iB;
        end;
      end;
      ny := Integer(s1);
      for Y := 0 to h do
      begin
        ty := Y + radius;
        with PRGB24(ny + ox)^, lutRGB[ty + radius] do
        begin
          R := ((iR - lutRGB[ty - radius - 1].iR) div divF);
          G := ((iG - lutRGB[ty - radius - 1].iG) div divF);
          B := ((iB - lutRGB[ty - radius - 1].iB) div divF);
        end;
        inc(ny, ptrD);
      end;
    end;
    inc(ox, 3);
  end;
  SetLength(lutRGB, 0);
  // Convert to greyscale
  s1 := Src.ScanLine[0];
  for Y := 0 to h do
  begin
    for X := 0 to w do
    begin
      R := PRGBArray(s1)[X].R;
      G := PRGBArray(s1)[X].G;
      B := PRGBArray(s1)[X].B;
      R := Byte((R + G + B) div 3);
      PRGBArray(s1)[X].B := R;
      PRGBArray(s1)[X].G := R;
      PRGBArray(s1)[X].R := R;
    end;
    inc(Integer(s1), ptrD);
  end;
end;

procedure fxBoxBlur8(Src: TBitmap; radius, rep: Integer);
var
  j, divF, i, w, h, X, Y, ny, tx, ty: Integer;
  ox: Integer;
  ptrD: Integer;
  s1: pByte;
  lut8: array of Integer;
begin
  if radius = 0 then
    Exit;
  divF := (radius * 2) + 1;
  w := Src.Width - 1;
  h := Src.Height - 1;
  SetLength(lut8, Max(w, h) + 1 + (radius * 2));
  s1 := Src.ScanLine[0];
  ptrD := Integer(Src.ScanLine[1]) - Integer(s1);
  ny := Integer(s1);
  for Y := 0 to h do
  begin
    for j := 1 to rep do
    begin
      for i := -radius to 0 do
        lut8[i + radius] := pByte(ny)^ + lut8[i + radius - 1];
      for i := 1 to w do
      begin
        tx := i;
        lut8[i + radius] := pByte(ny + tx)^ + lut8[i + radius - 1];
      end;
      for i := w + 1 to w + radius do
        lut8[i + radius] := pByte(ny + w)^ + lut8[i + radius - 1];
      ox := 0;
      for X := 0 to w do
      begin
        tx := X + radius;
        pByte(ny + ox)^ := ((lut8[tx + radius] - lut8[tx - radius - 1])
          div divF);
        inc(ox, 1);
      end;
    end;
    inc(ny, ptrD);
  end;
  ox := 0;
  for X := 0 to w do
  begin
    for j := 0 to rep do
    begin
      ny := Integer(s1);
      for i := -radius to 0 do
        lut8[i + radius] := pByte(ny + X)^ + lut8[i + radius - 1];
      for i := 1 to h do
      begin
        inc(ny, ptrD);
        lut8[i + radius] := pByte(ny + X)^ + lut8[i + radius - 1];
      end;
      for i := h + 1 to h + radius do
        lut8[i + radius] := pByte(ny + X)^ + lut8[i + radius - 1];
      ny := Integer(s1);
      for Y := 0 to h do
      begin
        ty := Y + radius;
        pByte(ny + ox)^ := ((lut8[ty + radius] - lut8[ty - radius - 1])
          div divF);
        inc(ny, ptrD);
      end;
    end;
    inc(ox, 1);
  end;
  SetLength(lut8, 0);
end;

function Blend(Color1, Color2: TColor; A: Byte): TColor; inline;
var
  c1, c2: LongInt;
  R, G, B, v1, v2: Byte;
begin
  A := Round(2.55 * A);
  c1 := ColorToRGB(Color1);
  c2 := ColorToRGB(Color2);
  v1 := Byte(c1);
  v2 := Byte(c2);
  R := Byte(A * (v1 - v2) shr 8 + v2);
  v1 := Byte(c1 shr 8);
  v2 := Byte(c2 shr 8);
  G := Byte(A * (v1 - v2) shr 8 + v2);
  v1 := Byte(c1 shr 16);
  v2 := Byte(c2 shr 16);
  B := Byte(A * (v1 - v2) shr 8 + v2);
  Result := (B shl 16) + (G shl 8) + R;
end;

procedure TrkGlassButton.PaintWindow(DC: HDC);
begin
  Canvas.Lock;
  try
    Canvas.Handle := DC;
    try
      FBmp.Canvas.Font.Assign(Font);
      PaintButton;
    finally
      Canvas.Handle := 0;
    end;
  finally
    Canvas.Unlock;
  end;
end;

procedure PaintArrow(Canvas: TCanvas; X, Y: Integer);
begin
  with Canvas do
  begin
    MoveTo(X + 3, Y + 3);
    LineTo(X + 7, Y + 3);
    LineTo(X + 5, Y + 5);
    LineTo(X + 3, Y + 3);
    LineTo(X + 6, Y + 5);
    MoveTo(X + 2, Y + 2);
    LineTo(X + 9, Y + 2);
  end
end;

procedure TrkGlassButton.PaintAlphaArrow(ShowDown: Boolean);
var
  row, slSize, X, Y, i: Integer;
  rowSrc, slSizeSrc: Integer;
  slPnt, slPntSrc: PRGB24;
  Bmp: TBitmap;
begin
  if ShowDown and (not FFlatDown) then
    i := 1
  else
    i := 0;
  if FShadowStyle <> ssNone then
  begin
    Bmp := TBitmap.Create;
    try
      Bmp.PixelFormat := pf24bit;
      Bmp.Width := ArrowWidth + 6;
      Bmp.Height := ClientHeight - 2;
      Bmp.Canvas.Brush.Color := clWhite;
      Bmp.Canvas.FillRect(Bmp.Canvas.ClipRect);
      if not Enabled then
        Bmp.Canvas.Pen.Color := FDisabledColor
      else
        Bmp.Canvas.Pen.Color := Font.Color;
      if FShadowStyle = ssGlow then
        PaintArrow(Bmp.Canvas, ArrowWidth shr 1, ArrowY)
      else
        PaintArrow(Bmp.Canvas, (ArrowWidth shr 1) + 1, ArrowY + 1);
      fxBoxBlur(Bmp, FBlurLevel, 3);
      row := Integer(FBmp.ScanLine[i]);
      slSize := Integer(FBmp.ScanLine[i + 1]) - row;
      rowSrc := Integer(Bmp.ScanLine[0]);
      slSizeSrc := Integer(Bmp.ScanLine[1]) - rowSrc;
      row := row + (((FBmp.Width - (ArrowWidth + 6)) + i) * 3);
      for Y := 0 to Bmp.Height - 1 do
      begin
        slPnt := PRGB24(row);
        slPntSrc := PRGB24(rowSrc);
        for X := 0 to Bmp.Width - 1 do
        begin
          slPnt.R := Byte(slPntSrc.R * (slPnt.R - GlowColor.R) shr 8 +
            GlowColor.R);
          slPnt.G := Byte(slPntSrc.R * (slPnt.G - GlowColor.G) shr 8 +
            GlowColor.G);
          slPnt.B := Byte(slPntSrc.R * (slPnt.B - GlowColor.B) shr 8 +
            GlowColor.B);
          inc(slPnt);
          inc(slPntSrc);
        end;
        inc(row, slSize);
        inc(rowSrc, slSizeSrc);
      end;
    finally
      Bmp.Free;
    end;
  end;
  if not Enabled then
    FBmp.Canvas.Pen.Color := FDisabledColor
  else
    FBmp.Canvas.Pen.Color := Font.Color;
  PaintArrow(FBmp.Canvas, ArrowX + i, ArrowY + i);
end;

procedure TrkGlassButton.PaintAlphaTxt(ShowDown, ShowArrow: Boolean);
const
  txtLeft = DT_END_ELLIPSIS or DT_SINGLELINE or DT_LEFT or DT_VCENTER;
  txtCenter = DT_END_ELLIPSIS or DT_SINGLELINE or DT_CENTER or DT_VCENTER;
  txtRight = DT_END_ELLIPSIS or DT_SINGLELINE or DT_RIGHT or DT_VCENTER;
var
  row, slSize, X, Y, off, i: Integer;
  rowSrc, slSizeSrc: Integer;
  slPnt, slPntSrc: PRGB24;
  ts: TSize;
  Bmp, BmpAlpha: TBitmap;
  DC: HDC;
  Glyph: Boolean;
  tr: TRect;
begin
  if ShowDown and (not FFlatDown) then
    i := 1
  else
    i := 0;
  Glyph := (FImageIndex <> -1) and (Assigned(FImages));
  if FShadowStyle <> ssNone then
  begin
    BmpAlpha := TBitmap.Create;
    try
      BmpAlpha.PixelFormat := pf24bit;
      BmpAlpha.Width := FBmp.Width - 2;
      BmpAlpha.Height := FBmp.Height - 2;
      BmpAlpha.Canvas.Brush.Color := clWhite;
      BmpAlpha.Canvas.FillRect(BmpAlpha.Canvas.ClipRect);
      if Glyph then
      begin
        Bmp := TBitmap.Create;
        try
          Bmp.Monochrome := True;
          FImages.GetBitmap(FImageIndex, Bmp);
          BmpAlpha.Canvas.Brush.Color := clBlack;
          DC := BmpAlpha.Canvas.Handle;
          SetTextColor(DC, clBlack);
          SetBkColor(DC, clWhite);
          if FShadowStyle = ssGlow then
            BitBlt(DC, GlyphX, GlyphY, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle,
              0, 0, SRCAND)
          else
            BitBlt(DC, GlyphX + 1, GlyphY + 1, Bmp.Width, Bmp.Height,
              Bmp.Canvas.Handle, 0, 0, SRCAND);
        finally
          Bmp.Free;
        end;
      end;
      if Caption <> '' then
      begin
        BmpAlpha.Canvas.Font.Assign(Font);
        ts := BmpAlpha.Canvas.TextExtent(Caption);
        BmpAlpha.Canvas.Brush.Style := bsClear;
        BmpAlpha.Canvas.Font.Color := clBlack;
        if FShadowStyle <> ssGlow then
          off := 1
        else
          off := 0;
        tr := TextRect;
        tr.Left := tr.Left + off;
        tr.Top := tr.Top + off;
        tr.Right := tr.Right + off;
        tr.Bottom := tr.Bottom + off;
        case FTextAlign of
          taLeft:
            DrawText(BmpAlpha.Canvas.Handle, PChar(Caption), Length(Caption),
              tr, txtLeft);
          taCenter:
            DrawText(BmpAlpha.Canvas.Handle, PChar(Caption), Length(Caption),
              tr, txtCenter);
          taRight:
            DrawText(BmpAlpha.Canvas.Handle, PChar(Caption), Length(Caption),
              tr, txtRight);
        else
        end;
      end;
      if ShowArrow then
      begin
        BmpAlpha.Canvas.Pen.Color := clBlack;
        if FShadowStyle = ssGlow then
          PaintArrow(BmpAlpha.Canvas, ArrowX, ArrowY)
        else
          PaintArrow(BmpAlpha.Canvas, ArrowX + 1, ArrowY + 1);
      end;
      fxBoxBlur(BmpAlpha, FBlurLevel, 3);
      row := Integer(FBmp.ScanLine[i]);
      slSize := Integer(FBmp.ScanLine[i + 1]) - row;
      rowSrc := Integer(BmpAlpha.ScanLine[0]);
      slSizeSrc := Integer(BmpAlpha.ScanLine[1]) - rowSrc;
      row := row + (i * 3);
      for Y := 0 to BmpAlpha.Height - 1 do
      begin
        slPnt := PRGB24(row);
        slPntSrc := PRGB24(rowSrc);
        for X := 0 to BmpAlpha.Width - 1 do
        begin
          slPnt.R := Byte(slPntSrc.R * (slPnt.R - GlowColor.R) shr 8 +
            GlowColor.R);
          slPnt.G := Byte(slPntSrc.R * (slPnt.G - GlowColor.G) shr 8 +
            GlowColor.G);
          slPnt.B := Byte(slPntSrc.R * (slPnt.B - GlowColor.B) shr 8 +
            GlowColor.B);
          inc(slPnt);
          inc(slPntSrc);
        end;
        inc(row, slSize);
        inc(rowSrc, slSizeSrc);
      end;
    finally
      BmpAlpha.Free;
    end;
  end;
  if Glyph then
    FImages.Draw(FBmp.Canvas, GlyphX + i, GlyphY + i, FImageIndex, Enabled);
  tr := TextRect;
  tr.Left := tr.Left + i;
  tr.Top := tr.Top + i;
  tr.Right := tr.Right + i;
  tr.Bottom := tr.Bottom + i;
  if not Enabled then
    FBmp.Canvas.Font.Color := FDisabledColor
  else
    FBmp.Canvas.Font.Color := Font.Color;
  FBmp.Canvas.Brush.Style := bsClear;
  case FTextAlign of
    taLeft:
      DrawText(FBmp.Canvas.Handle, PChar(Caption), Length(Caption), tr,
        txtLeft);
    taCenter:
      DrawText(FBmp.Canvas.Handle, PChar(Caption), Length(Caption), tr,
        txtCenter);
    taRight:
      DrawText(FBmp.Canvas.Handle, PChar(Caption), Length(Caption), tr,
        txtRight);
  else
  end;

  if ShowArrow then
  begin
    FBmp.Canvas.Pen.Color := FBmp.Canvas.Font.Color;
    PaintArrow(FBmp.Canvas, ArrowX + i, ArrowY + i);
  end;
end;

procedure TrkGlassButton.PaintAlphaRect(ABitmap: TBitmap; ARect: TRect;
  AColor: TColor; Alpha: Byte);
var
  C: LongInt;
  i, row, slSize, X, Y: Integer;
  Ra, Ga, Ba: array [0 .. 255] of Byte;
  Col: TRGB24;
  slPnt: PRGB24;
  A, aStep, h: Integer;
begin
  C := ColorToRGB(AColor);
  Col.B := (C shr 16) and $FF;
  Col.G := (C shr 8) and $FF;
  Col.R := C and $FF;
  for i := 0 to 255 do
  begin
    Ra[i] := Byte(Alpha * (Col.R - i) shr 8 + i);
    Ga[i] := Byte(Alpha * (Col.G - i) shr 8 + i);
    Ba[i] := Byte(Alpha * (Col.B - i) shr 8 + i);
  end;
  row := Integer(ABitmap.ScanLine[ARect.Top]);
  slSize := Integer(ABitmap.ScanLine[ARect.Top + 1]) - row;
  row := row + (ARect.Left * 3);
  h := 0;
  if FGlossy then
  begin
    A := 176;
    h := (ARect.Bottom - ARect.Top) shr 1;
    aStep := (A - Alpha) div h;
    for Y := 0 to h - 1 do
    begin
      slPnt := PRGB24(row);
      for X := ARect.Left to ARect.Right - 1 do
      begin
        slPnt.R := Byte(A * (Col.R - slPnt.R) shr 8 + slPnt.R);
        slPnt.G := Byte(A * (Col.G - slPnt.G) shr 8 + slPnt.G);
        slPnt.B := Byte(A * (Col.B - slPnt.B) shr 8 + slPnt.B);
        inc(slPnt)
      end;
      A := A - aStep;
      inc(row, slSize);
    end;
  end;
  for Y := h to ARect.Bottom - 1 do
  begin
    slPnt := PRGB24(row);
    for X := ARect.Left to ARect.Right - 1 do
    begin
      slPnt.R := Ra[slPnt.R];
      slPnt.G := Ga[slPnt.G];
      slPnt.B := Ba[slPnt.B];
      inc(slPnt)
    end;
    inc(row, slSize);
  end;
end;

procedure TrkGlassButton.PaintAlphaRectAlt(ABitmap: TBitmap; ARect: TRect;
  AColor: TColor; Alpha: Byte);
var
  C: LongInt;
  i, row, slSize, X, Y: Integer;
  Ra, Ga, Ba: array [0 .. 255] of Byte;
  Col: TRGB24;
  slPnt: PRGB24;
  A, aStep, h: Integer;
begin
  C := ColorToRGB(AColor);
  Col.B := (C shr 16) and $FF;
  Col.G := (C shr 8) and $FF;
  Col.R := C and $FF;
  for i := 0 to 255 do
  begin
    Ra[i] := Byte(Alpha * (Col.R - i) shr 8 + i);
    Ga[i] := Byte(Alpha * (Col.G - i) shr 8 + i);
    Ba[i] := Byte(Alpha * (Col.B - i) shr 8 + i);
  end;
  row := Integer(ABitmap.ScanLine[ARect.Top]);
  slSize := Integer(ABitmap.ScanLine[ARect.Top + 1]) - row;
  row := row + (ARect.Left * 3);
  if FGlossy then
  begin
    A := 176;
    h := (ARect.Bottom - ARect.Top) shr 1;
    aStep := (A - Alpha) div h;
    for Y := 0 to ARect.Bottom - 1 do
    begin
      slPnt := PRGB24(row);
      for X := ARect.Left to ARect.Right - 1 do
      begin
        slPnt.R := Ra[slPnt.R];
        slPnt.G := Ga[slPnt.G];
        slPnt.B := Ba[slPnt.B];
        if Y < h then
        begin
          slPnt.R := Byte(A * (255 - slPnt.R) shr 8 + slPnt.R);
          slPnt.G := Byte(A * (255 - slPnt.G) shr 8 + slPnt.G);
          slPnt.B := Byte(A * (255 - slPnt.B) shr 8 + slPnt.B);
        end;
        inc(slPnt);
      end;
      A := A - aStep;
      inc(row, slSize);
    end;
  end;
end;

procedure AlphaGlow(ABitmap: TBitmap; AVal: Word; AColor: TColor; ALH: Integer);
var
  X, Y, w, h, j, w1: Integer;
  row: PRGBArray;
  slMain, slSize, slPtr: Integer;
  R, G, B, A: Byte;
begin
  if ALH > ABitmap.Height then
    ALH := ABitmap.Height;
  h := ABitmap.Height;
  w := ABitmap.Width;
  AColor := ColorToRGB(AColor);
  R := Byte(AColor);
  G := Byte(AColor shr 8);
  B := Byte(AColor shr 16);
  w1 := w - 1;
  w := (w shr 1) + (w and 1);
  slMain := Integer(ABitmap.ScanLine[h - ALH]);
  slSize := Integer(ABitmap.ScanLine[h - (ALH - 1)]) - slMain;
  for X := 0 to w - 1 do
  begin
    j := MulDiv(AVal, X, w);
    if j > 255 then
      j := 255;
    slPtr := slMain;
    for Y := 0 to ALH - 2 do
    begin
      row := PRGBArray(slPtr);
      A := 255 - MulDiv(j, Y, ALH);
      row[X].R := Byte(A * (row[X].R - R) shr 8 + R);
      row[X].G := Byte(A * (row[X].G - G) shr 8 + G);
      row[X].B := Byte(A * (row[X].B - B) shr 8 + B);
      if (X < (w1 - X)) then
      begin
        row[w1 - X].R := Byte(A * (row[w1 - X].R - R) shr 8 + R);
        row[w1 - X].G := Byte(A * (row[w1 - X].G - G) shr 8 + G);
        row[w1 - X].B := Byte(A * (row[w1 - X].B - B) shr 8 + B);
      end;
      slPtr := slPtr + slSize;
    end;
  end;
end;

procedure TrkGlassButton.PaintButton;
const
  TxtOp: Integer = DT_END_ELLIPSIS or DT_SINGLELINE or DT_NOPREFIX or
    DT_VCENTER;
var
  R, r1, r2: TRect;
  bool, DownState: Boolean;
  C, c1, c2, c3, c4: TColor;
begin
  if InCreate then
    Exit;
  InitPos;
  FBmp.Width := ClientWidth;
  FBmp.Height := ClientHeight;
  FBmp.Canvas.Brush.Style := bsClear;
  DrawParentImage(self, FBmp.Canvas);

  R := ClientRect;
  if (Focused) or (not FFlat) then
  begin
    c1 := Blend(FBmp.Canvas.Pixels[R.Left, R.Bottom - 1],
      FBmp.Canvas.Pixels[R.Left, R.Top], 50);
    c2 := Blend(FBmp.Canvas.Pixels[R.Left, R.Top],
      FBmp.Canvas.Pixels[R.Right - 1, R.Top], 50);
    c3 := Blend(FBmp.Canvas.Pixels[R.Right - 1, R.Top],
      FBmp.Canvas.Pixels[R.Right - 1, R.Bottom - 1], 50);
    c4 := Blend(FBmp.Canvas.Pixels[R.Left, R.Bottom - 1],
      FBmp.Canvas.Pixels[R.Right - 1, R.Bottom - 1], 50);
    c1 := Blend(c1, c2, 50);
    c2 := Blend(c3, c4, 50);
    c1 := Blend(c1, c2, 50);
    c1 := Blend(c1, FColorFrame, 50);
    InflateRect(R, -1, -1);
    if (FBtnIdx = -1) then
      AlphaRender(FBmp, R, Color, FGloss);
    if Focused then
      if FAltFocus then
        AlphaRender(FBmp, R, FColorFocused, FGloss)
      else
        AlphaGlow(FBmp, 255, FColorFocused, FLightHeight);
    R := ClientRect;
    FBmp.Canvas.Pen.Color := c1;

    FBmp.Canvas.MoveTo(R.Left + 2, R.Top);
    FBmp.Canvas.LineTo(R.Right - 2, R.Top);
    FBmp.Canvas.Pixels[R.Left + 1, R.Top + 1] :=
      Blend(FBmp.Canvas.Pixels[R.Left + 1, R.Top + 1], c1, 25);

    FBmp.Canvas.MoveTo(R.Left + 2, R.Bottom - 1);
    FBmp.Canvas.LineTo(R.Right - 2, R.Bottom - 1);
    FBmp.Canvas.Pixels[R.Right - 2, R.Top + 1] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 2, R.Top + 1], c1, 25);

    FBmp.Canvas.MoveTo(R.Left, R.Top + 2);
    FBmp.Canvas.LineTo(R.Left, R.Bottom - 2);
    FBmp.Canvas.Pixels[R.Left + 1, R.Bottom - 2] :=
      Blend(FBmp.Canvas.Pixels[R.Left + 1, R.Bottom - 2], c1, 25);

    FBmp.Canvas.MoveTo(R.Right - 1, R.Top + 2);
    FBmp.Canvas.LineTo(R.Right - 1, R.Bottom - 2);
    FBmp.Canvas.Pixels[R.Right - 2, R.Bottom - 2] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 2, R.Bottom - 2], c1, 25);

    FBmp.Canvas.Pixels[R.Left, R.Top + 1] :=
      Blend(FBmp.Canvas.Pixels[R.Left, R.Top + 1], c1, 33);
    FBmp.Canvas.Pixels[R.Left + 1, R.Top] :=
      Blend(FBmp.Canvas.Pixels[R.Left + 1, R.Top], c1, 33);
    FBmp.Canvas.Pixels[R.Right - 1, R.Top + 1] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 1, R.Top + 1], c1, 33);
    FBmp.Canvas.Pixels[R.Right - 2, R.Top] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 2, R.Top], c1, 33);
    FBmp.Canvas.Pixels[R.Left, R.Bottom - 2] :=
      Blend(FBmp.Canvas.Pixels[R.Left, R.Bottom - 2], c1, 33);
    FBmp.Canvas.Pixels[R.Left + 1, R.Bottom - 1] :=
      Blend(FBmp.Canvas.Pixels[R.Left + 1, R.Bottom - 1], c1, 33);
    FBmp.Canvas.Pixels[R.Right - 1, R.Bottom - 2] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 1, R.Bottom - 2], c1, 33);
    FBmp.Canvas.Pixels[R.Right - 2, R.Bottom - 1] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 2, R.Bottom - 1], c1, 33);
  end;

  DownState := FButtonDown or FDown;
  if (csDesigning in ComponentState) or (FBtnIdx <> -1) or (DownState) then
  begin
    InflateRect(R, -1, -1);
    if not(csDesigning in ComponentState) or DownState then
    begin
      if DownState then
      begin
        if FDuoStyle then
        begin
          r1 := R;
          r1.Right := r1.Right - ArrowWidth;
          r2 := R;
          r2.Left := r2.Right - (ArrowWidth - 1);
          if FDown or (FButtonDown and (FBtnIdx = 0)) then
            AlphaRender(FBmp, r1, ColorDown, FGloss)
          else
            AlphaRender(FBmp, r1, Color, FGloss);

          if (FButtonDown and (FBtnIdx = 1)) then
            AlphaRender(FBmp, r2, ColorDown, FGloss)
          else
            AlphaRender(FBmp, r2, Color, FGloss);
        end
        else
          AlphaRender(FBmp, R, ColorDown, FGloss);
      end
      else
        AlphaRender(FBmp, R, Color, FGloss);
    end;

    R := ClientRect;
    c1 := Blend(FBmp.Canvas.Pixels[R.Left, R.Bottom - 1],
      FBmp.Canvas.Pixels[R.Left, R.Top], 50);
    c2 := Blend(FBmp.Canvas.Pixels[R.Left, R.Top],
      FBmp.Canvas.Pixels[R.Right - 1, R.Top], 50);
    c3 := Blend(FBmp.Canvas.Pixels[R.Right - 1, R.Top],
      FBmp.Canvas.Pixels[R.Right - 1, R.Bottom - 1], 50);
    c4 := Blend(FBmp.Canvas.Pixels[R.Left, R.Bottom - 1],
      FBmp.Canvas.Pixels[R.Right - 1, R.Bottom - 1], 50);
    c1 := Blend(c1, c2, 50);
    c2 := Blend(c3, c4, 50);
    c1 := Blend(c1, c2, 50);
    c1 := Blend(c1, FColorFrame, 50);
    InflateRect(R, -1, -1);
    if (FBtnIdx = -1) then
      AlphaRender(FBmp, R, Color, FGloss);

    if Focused then
      if FAltFocus then
        AlphaRender(FBmp, R, FColorFocused, FGloss)
      else
        AlphaGlow(FBmp, 255, FColorFocused, FLightHeight);

    R := ClientRect;
    FBmp.Canvas.Pen.Color := c1;
    FBmp.Canvas.MoveTo(R.Left + 2, R.Top);
    FBmp.Canvas.LineTo(R.Right - 2, R.Top);
    FBmp.Canvas.Pixels[R.Left + 1, R.Top + 1] :=
      Blend(FBmp.Canvas.Pixels[R.Left + 1, R.Top + 1], c1, 25);

    FBmp.Canvas.MoveTo(R.Left + 2, R.Bottom - 1);
    FBmp.Canvas.LineTo(R.Right - 2, R.Bottom - 1);
    FBmp.Canvas.Pixels[R.Right - 2, R.Top + 1] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 2, R.Top + 1], c1, 25);

    FBmp.Canvas.MoveTo(R.Left, R.Top + 2);
    FBmp.Canvas.LineTo(R.Left, R.Bottom - 2);
    FBmp.Canvas.Pixels[R.Left + 1, R.Bottom - 2] :=
      Blend(FBmp.Canvas.Pixels[R.Left + 1, R.Bottom - 2], c1, 25);

    FBmp.Canvas.MoveTo(R.Right - 1, R.Top + 2);
    FBmp.Canvas.LineTo(R.Right - 1, R.Bottom - 2);
    FBmp.Canvas.Pixels[R.Right - 2, R.Bottom - 2] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 2, R.Bottom - 2], c1, 25);

    FBmp.Canvas.Pixels[R.Left, R.Top + 1] :=
      Blend(FBmp.Canvas.Pixels[R.Left, R.Top + 1], c1, 33);
    FBmp.Canvas.Pixels[R.Left + 1, R.Top] :=
      Blend(FBmp.Canvas.Pixels[R.Left + 1, R.Top], c1, 33);
    FBmp.Canvas.Pixels[R.Right - 1, R.Top + 1] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 1, R.Top + 1], c1, 33);
    FBmp.Canvas.Pixels[R.Right - 2, R.Top] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 2, R.Top], c1, 33);
    FBmp.Canvas.Pixels[R.Left, R.Bottom - 2] :=
      Blend(FBmp.Canvas.Pixels[R.Left, R.Bottom - 2], c1, 33);
    FBmp.Canvas.Pixels[R.Left + 1, R.Bottom - 1] :=
      Blend(FBmp.Canvas.Pixels[R.Left + 1, R.Bottom - 1], c1, 33);
    FBmp.Canvas.Pixels[R.Right - 1, R.Bottom - 2] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 1, R.Bottom - 2], c1, 33);
    FBmp.Canvas.Pixels[R.Right - 2, R.Bottom - 1] :=
      Blend(FBmp.Canvas.Pixels[R.Right - 2, R.Bottom - 1], c1, 33);

    if (not FSingleBorder) then
    begin
      c3 := Blend(c1, clWhite, 50);
      InflateRect(R, -1, -1);
      FBmp.Canvas.Pen.Color := c3;
      FBmp.Canvas.Polyline([Point(R.Left, R.Top + 1), Point(R.Left + 1, R.Top),
        Point(R.Left + 1, R.Top), Point(R.Right - 2, R.Top),
        Point(R.Right - 1, R.Top + 1), Point(R.Right - 1, R.Bottom - 2),
        Point(R.Right - 2, R.Bottom - 1), Point(R.Left + 1, R.Bottom - 1),
        Point(R.Left, R.Bottom - 2), Point(R.Left, R.Top + 1)]);
    end;
    R := ClientRect;
    if FDuoStyle then
    begin
      FBmp.Canvas.MoveTo(R.Right - (ArrowWidth + 1), R.Top + 1);
      FBmp.Canvas.LineTo(R.Right - (ArrowWidth + 1), R.Bottom - 1);
      if DownState then
      begin
        if (FBtnIdx = 0) or (FDown) then
        begin
          if FFlatDown then
          begin
            C := Blend(c1, clWhite, 45);
            FBmp.Canvas.Pen.Color := C;
            FBmp.Canvas.Polyline([Point(R.Left + 2, R.Bottom - 2),
              Point(R.Left + 1, R.Bottom - 3), Point(R.Left + 1, R.Top + 2),
              Point(R.Left + 2, R.Top + 1), Point(R.Right - (ArrowWidth + 2),
              R.Top + 1), Point(R.Right - (ArrowWidth + 2), R.Top + 2),
              Point(R.Right - (ArrowWidth + 2), R.Bottom - 3),
              Point(R.Right - (ArrowWidth + 2), R.Bottom - 2),
              Point(R.Left + 2, R.Bottom - 2)]);
            C := Blend(C, Blend(c1, clWhite, 35), 25);
            FBmp.Canvas.Pixels[R.Left + 2, R.Top + 2] := C;
            FBmp.Canvas.Pixels[R.Left + 2, R.Bottom - 3] := C;
          end
          else
          begin
            FBmp.Canvas.Pen.Color := Blend(c1, clBlack, 75);
            FBmp.Canvas.Polyline([Point(R.Left + 2, R.Bottom - 2),
              Point(R.Left + 1, R.Bottom - 3), Point(R.Left + 1, R.Top + 2),
              Point(R.Left + 2, R.Top + 1), Point(R.Right - (ArrowWidth + 1),
              R.Top + 1)]);
            FBmp.Canvas.Pen.Color := Blend(c1, clWhite, 75);
            FBmp.Canvas.Polyline([Point(R.Right - (ArrowWidth + 2), R.Top + 2),
              Point(R.Right - (ArrowWidth + 2), R.Bottom - 3),
              Point(R.Right - (ArrowWidth + 2), R.Bottom - 2),
              Point(R.Left + 2, R.Bottom - 2)]);
          end;
        end;

        if (FBtnIdx = 1) and (FButtonDown) then
        begin
          if FFlatDown then
          begin
            C := Blend(c1, clWhite, 45);
            FBmp.Canvas.Pen.Color := C;
            FBmp.Canvas.Polyline([Point(R.Right - FArrowWidth, R.Bottom - 2),
              Point(R.Right - FArrowWidth, R.Top + 1), Point(R.Right - 3,
              R.Top + 1), Point(R.Right - 2, R.Top + 2), Point(R.Right - 2,
              R.Bottom - 3), Point(R.Right - 3, R.Bottom - 2),
              Point(R.Right - FArrowWidth, R.Bottom - 2)]);
            C := Blend(C, Blend(c1, clWhite, 35), 25);
            FBmp.Canvas.Pixels[R.Right - 3, R.Top + 2] := C;
            FBmp.Canvas.Pixels[R.Right - 3, R.Bottom - 3] := C;
          end
          else
          begin
            FBmp.Canvas.Pen.Color := Blend(c1, clBlack, 75);
            FBmp.Canvas.Polyline([Point(R.Right - FArrowWidth, R.Bottom - 2),
              Point(R.Right - FArrowWidth, R.Top + 1), Point(R.Right - 2,
              R.Top + 1)]);
            FBmp.Canvas.Pen.Color := Blend(c1, clWhite, 75);
            FBmp.Canvas.Polyline([Point(R.Right - 2, R.Top + 2),
              Point(R.Right - 2, R.Bottom - 3), Point(R.Right - 3,
              R.Bottom - 2), Point(R.Right - FArrowWidth, R.Bottom - 2)]);
          end;
        end;
      end;
    end
    else
    begin
      if DownState then
        if FFlatDown then
        begin
          C := Blend(c1, clWhite, 45);
          FBmp.Canvas.Pen.Color := C;
          FBmp.Canvas.Polyline([Point(R.Left + 2, R.Bottom - 2),
            Point(R.Left + 1, R.Bottom - 3), Point(R.Left + 1, R.Top + 2),
            Point(R.Left + 2, R.Top + 1), Point(R.Right - 3, R.Top + 1),
            Point(R.Right - 2, R.Top + 2), Point(R.Right - 2, R.Bottom - 3),
            Point(R.Right - 3, R.Bottom - 2), Point(R.Left + 2, R.Bottom - 2)]);
          C := Blend(C, Blend(c1, clWhite, 35), 25);
          FBmp.Canvas.Pixels[R.Left + 2, R.Top + 2] := C;
          FBmp.Canvas.Pixels[R.Left + 2, R.Bottom - 3] := C;
          FBmp.Canvas.Pixels[R.Right - 3, R.Top + 2] := C;
          FBmp.Canvas.Pixels[R.Right - 3, R.Bottom - 3] := C;
        end
        else
        begin
          FBmp.Canvas.Pen.Color := Blend(c1, clBlack, 75);
          FBmp.Canvas.Polyline([Point(R.Left + 2, R.Bottom - 2),
            Point(R.Left + 1, R.Bottom - 3), Point(R.Left + 1, R.Top + 2),
            Point(R.Left + 2, R.Top + 1), Point(R.Right - 2, R.Top + 1)]);
          FBmp.Canvas.Pen.Color := Blend(c1, clWhite, 75);
          FBmp.Canvas.Polyline([Point(R.Right - 2, R.Top + 2),
            Point(R.Right - 2, R.Bottom - 3), Point(R.Right - 3, R.Bottom - 2),
            Point(R.Left + 2, R.Bottom - 2)]);
        end;
    end;
  end;
  if FDuoStyle then
  begin
    PaintAlphaArrow(FButtonDown and (FBtnIdx = 1));
    PaintAlphaTxt(DownState and (FBtnIdx = 0), False);
  end
  else
    PaintAlphaTxt(DownState, FArrow);
  BitBlt(Canvas.Handle, 0, 0, FBmp.Width, FBmp.Height, FBmp.Canvas.Handle, 0,
    0, SRCCOPY);
end;

procedure TrkGlassButton.WMERASEBKGND(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TrkGlassButton.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  // Answer Delphi that this component wants to handle its own arrow key press:
  message.Result := DLGC_WANTARROWS;
end;

procedure TrkGlassButton.WMKILLFOCUS(var Message: TWMKILLFOCUS);
begin
  if TabStop then
    Invalidate;
end;

procedure TrkGlassButton.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

procedure TrkGlassButton.WMSETFOCUS(var Message: TWMSETFOCUS);
begin
  if TabStop then
    Invalidate;
end;

procedure TrkGlassButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      // if not CheckDefaults or (Self.ImageIndex = -1) then
      // begin
      self.ImageIndex := ImageIndex;
      // end;
    end;
  Paint;
end;

procedure TrkGlassButton.Click;
begin
  if (not Focused) and TabStop then
    SetFocus;

  MClick := True;

  if FDuoStyle then
  begin
    if FBtnIdx = 0 then
      inherited;
  end
  else
  begin
    if FNoClick then
      FNoClick := False
    else if InBtn then
      inherited;
  end;
end;

procedure TrkGlassButton.CMFontChanged(var Msg: TMessage);
begin
  Invalidate;
end;

procedure TrkGlassButton.CMIsToolControl(var Msg: TMessage);
begin
  Msg.Result := 1;
end;

procedure TrkGlassButton.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  Invalidate;
  inherited;
  if not(csLoading in ComponentState) then
    Resize;
end;

procedure TrkGlassButton.SetAltFocus(const Value: Boolean);
begin
  FAltFocus := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetAltRender(const Value: Boolean);
begin
  FAltRender := Value;
  if Value then
    AlphaRender := PaintAlphaRectAlt
  else
    AlphaRender := PaintAlphaRect;
  Invalidate;
end;

procedure TrkGlassButton.SetArrow(const Value: Boolean);
begin
  FArrow := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetArrowWidth(const Value: Integer);
begin
  FArrowWidth := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetAutoSize(const Value: Boolean);
begin
  FAutoSize := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetColor(const Value: TColor);
begin
  FColor := ColorToRGB(Value);
  Invalidate;
end;

procedure TrkGlassButton.SetColorDown(const Value: TColor);
begin
  FColorDown := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetColorFocused(const Value: TColor);
begin
  FColorFocused := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetDisabledColor(const Value: TColor);
begin
  FDisabledColor := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetDown(const Value: Boolean);
begin
  FDown := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetDuoStyle(const Value: Boolean);
begin
  FDuoStyle := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetEnabled(Value: Boolean);
begin
  inherited;
  Invalidate;
end;

procedure TrkGlassButton.SetFlat(const Value: Boolean);
begin
  FFlat := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetFlatDown(const Value: Boolean);
begin
  FFlatDown := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetFrameColor(const Value: TColor);
begin
  FColorFrame := ColorToRGB(Value);
  Invalidate;
end;

procedure TrkGlassButton.SetGlossy(const Value: Boolean);
begin
  FGlossy := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetGlossyLevel(const Value: Byte);
var
  v: Integer;
begin
  v := Value;
  if v < 0 then
    v := 0;
  if v > 100 then
    v := 100;
  FGlossyLevel := v;
  v := Trunc(v * 2.55);
  v := MulDiv(v, 196, 255);
  FGloss := v;
  Invalidate;
end;

procedure TrkGlassButton.SetGlyphPos(const Value: TGlyphPos);
begin
  FGlyphPos := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetImageOffset(const Value: Integer);
begin
  FImageOffset := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetImages(Value: TCustomImageList);
begin
  if FImages <> nil then
    FImages.UnRegisterChanges(FImageChangeLink);
  FImages := Value;
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(self);
  end;
  Invalidate;
end;

procedure TrkGlassButton.SetImageSpacing(const Value: Integer);
begin
  FImageSpacing := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    if Assigned(Images) then
      Invalidate;
  end;
end;

procedure TrkGlassButton.SetLightHeight(const Value: Integer);
begin
  FLightHeight := Value;
  if (FLightHeight < 0) then
    FLightHeight := 0;
end;

procedure TrkGlassButton.SetShadowColor(const Value: TColor);
var
  C: Integer;
begin
  FColorGlow := Value;
  C := ColorToRGB(FColorGlow);
  GlowColor.R := Byte(C);
  GlowColor.G := Byte(C shr 8);
  GlowColor.B := Byte(C shr 16);
  Invalidate;
end;

procedure TrkGlassButton.SetShadowStyle(const Value: TShadowStyle);
begin
  FShadowStyle := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetSingleBorder(const Value: Boolean);
begin
  FSingleBorder := Value;
  Invalidate;
end;

procedure TrkGlassButton.SetTextAlign(const Value: TTextAlign);
begin
  FTextAlign := Value;
  Invalidate;
end;

procedure TrkGlassButton.ShowPopup;
var
  pt: TPoint;
begin
  if (not Focused) and (TabStop) then
    SetFocus;
  if Assigned(FPopupMenu) then
  begin
    pt.X := 0;
    if FPopupAlignment = paCenter then
      pt.X := ClientWidth shr 1
    else if FPopupAlignment = paRight then
      pt.X := ClientWidth;
    pt.Y := ClientHeight;
    pt := ClientToScreen(pt);
    if FDuoStyle then
      FBtnIdx := 1
    else
      FBtnIdx := 0;
    FButtonDown := True;
    PaintButton;
    if not FPopup then
      PostMessage(Handle, CM_POPUP, 0, 0);
    FButtonDown := False;
    FBtnIdx := -1;
    FPopup := False;
    Invalidate;
  end;
end;

procedure TrkGlassButton.ImageListChange(Sender: TObject);
begin
  if Sender = Images then
    Invalidate;
end;

function TrkGlassButton.BtnAutoSize(Calc: Boolean): TPoint;
var
  ts: TSize;
  w, h: Integer;
begin
  Result := Point(0, 0);
  if InCreate then
    Exit;
  ts := FBmp.Canvas.TextExtent(Caption);
  w := ts.cx + 8;
  h := ts.cy + 8;
  if (FImageIndex <> -1) and Assigned(FImages) then
  begin
    if (FGlyphPos = gpTop) or (FGlyphPos = gpBottom) then
    begin
      w := Max(w, FImages.Width + 6);
      h := h + FImageOffset + FImages.Height + ImageSpacing
    end
    else
    begin
      w := w + FImageOffset + FImages.Width + ImageSpacing;
      h := Max(h, FImages.Height + 6);
    end;
  end;
  if FDuoStyle then
    w := w + FArrowWidth
  else if FArrow then
    w := w + 16;
  Result := Point(w, h);
  if not Calc then
  begin
    Width := w;
    Height := h;
  end;
end;

procedure TrkGlassButton.InitPos;
var
  ts: TSize;
  img: Integer;
begin
  if InCreate then
    Exit;

  if FArrow then
    ArrowX := Width - 14;
  if FDuoStyle then
    ArrowX := Width - (ArrowWidth shr 1) - 6;

  ArrowY := (Height shr 1) - 4;
  ts := FBmp.Canvas.TextExtent(Caption);
  if FAutoSize then
    BtnAutoSize(False);

  TextRect := Rect(0, 0, Width - 1, Height - 1);
  TextX := 0;
  TextY := (Height - ts.cy) shr 1;

  if (FImageIndex <> -1) and Assigned(FImages) then
  begin
    img := (FImages.Height or FImages.Width);
    case FGlyphPos of
      gpTop, gpBottom:
        begin
          GlyphX := (Width - FImages.Width) shr 1;
          if FArrow or FDuoStyle then
            GlyphX := GlyphX - (FArrowWidth shr 1);
          if FGlyphPos = gpBottom then
          begin
            GlyphY := Height - (FImageOffset + img);
            TextRect.Bottom := GlyphY - ImageSpacing;
            TextY := ((Height - TextY) - ts.cy) shr 1;
          end
          else
          begin
            GlyphY := FImageOffset;
            TextY := GlyphY + img + ImageSpacing;
            TextRect.Top := TextY;
            TextY := TextY + (((Height - TextY) - ts.cy) shr 1);
          end;
          TextX := FImageOffset;
          TextRect.Left := 0;
          TextRect.Right := Width;
        end;
      gpLeft, gpRight:
        begin
          if FGlyphPos = gpLeft then
          begin
            GlyphX := FImageOffset;
            TextX := FImageOffset + img + ImageSpacing;
            TextRect.Left := TextX;
            TextRect.Right := Width - FImageOffset;
          end
          else
          begin
            GlyphX := Width - (img + FImageOffset);
            if FArrow or FDuoStyle then
              GlyphX := GlyphX - FArrowWidth;
            TextX := TextX + img + FImageSpacing + FImageOffset;
            TextRect.Left := FImageOffset;
            TextRect.Right := Width - (img + FImageOffset + FImageSpacing);
          end;
          GlyphY := (Height - FImages.Height) shr 1;
          TextY := (Height - ts.cy) shr 1;
        end;
    end;
  end;

  if FDuoStyle then
    TextRect.Right := TextRect.Right - FArrowWidth
  else if FArrow then
    TextRect.Right := TextRect.Right - 16;
end;

procedure TrkGlassButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  FButtonDown := False;
  FPopup := False;
  case Key of
    VK_DOWN { , VK_UP } :
      begin
        Key := 0;
        if FArrow or Assigned(FPopupMenu) then
        begin
          FButtonDown := True;
          if FDuoStyle then
            FBtnIdx := 1
          else
            FBtnIdx := 0;
          PaintButton;
        end;
      end;
    VK_RETURN:
      begin
        Key := 0;
        FButtonDown := True;
        FBtnIdx := 0;
        PaintButton;
      end;
    VK_LEFT:
      TWinControlCracker(Parent).SelectNext(self, False, True);
    VK_RIGHT:
      TWinControlCracker(Parent).SelectNext(self, True, True);
  else
  end;
end;

procedure TrkGlassButton.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  FButtonDown := False;
  FPopup := False;
  if Key = VK_DOWN then
  begin
    Key := 0;
    if FArrow or Assigned(FPopupMenu) then
    begin
      if FDuoStyle then
        FBtnIdx := 1
      else
        FBtnIdx := 0;
      PostMessage(Handle, CM_POPUP, 0, 0);
    end;
  end
  else if Key = VK_RETURN then
  begin
    if (not FDuoStyle) and Assigned(FPopupMenu) then
      PostMessage(Handle, CM_POPUP, 0, 0)
    else
    begin
      Key := 0;
      FBtnIdx := -1;
      PaintButton;
      FClickStyle := csEnter;
      if Assigned(OnClick) then
        OnClick(self);
    end;
  end
end;

constructor TrkGlassButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InCreate := True;
  Width := 75;
  Height := 25;
  ControlStyle := ControlStyle + [csSetCaption, csDoubleClicks];
  FAutoSize := False;
  FColor := clWhite;
  FColorFrame := clGray;
  FColorDown := clBlack;
  FColorFocused := clYellow;
  FColorGlow := clBlack;
  TextRect.Top := 0;
  TextRect.Bottom := Height;
  AlphaRender := PaintAlphaRect;
  FAltFocus := False;
  FAltRender := False;
  FBmp := TBitmap.Create;
  FBmp.PixelFormat := pf24bit;
  FArrow := False;
  FArrowWidth := 18;
  FBlurLevel := 1;
  FBtnIdx := -1;
  FButtonDown := False;
  FDisabledColor := clSilver;
  FDuoStyle := False;
  FFlat := True;
  FFlatDown := False;
  FGlossy := False;
  FGlossyLevel := 37;
  FGlyphPos := gpLeft;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FImageOffset := 4;
  FImageSpacing := 4;
  FNoClick := False;
  FPopup := False;
  FPopupAlignment := paLeft;
  FPopupOff := 0;
  FShadowStyle := ssNone;
  FSingleBorder := False;
  FTextAlign := taCenter;
  FLightHeight := Height;
  ParentFont := True;
  InCreate := False;
end;

destructor TrkGlassButton.Destroy;
begin
  FImageChangeLink.Free;
  FBmp.Free;
  inherited Destroy;
end;

procedure TrkGlassButton.DoClick(Sender: TObject; ClickStyle: TClickStyle);
begin
  FClickStyle := ClickStyle;
  Click;
end;

procedure TrkGlassButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  MClick := False;
  inherited;
  if (Button = mbLeft) then
  begin
    if (not Focused) and (TabStop) then
      SetFocus;
    if FPopup then
      FPopup := False;
    FButtonDown := True;
    if X > Width - (ArrowWidth + 2) then
      FBtnIdx := 1
    else
      FBtnIdx := 0;
    PaintButton;
  end;
end;

procedure TrkGlassButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  idx: Integer;
begin
  if Button = mbLeft then
  begin
    if (not MClick) and (InBtn) and (FButtonDown) then
    begin
      if Button = mbLeft then
        FClickStyle := csLeft
      else if Button = mbRight then
        FClickStyle := csRight
      else if Button = mbMiddle then
        FClickStyle := csMiddle;
      Click;
    end;

    idx := FBtnIdx;
    if (Button = mbLeft) and ((PtInRect(ClientRect, Point(X, Y)))) then
    begin
      if FDuoStyle then
      begin
        if X > Width - (ArrowWidth + 2) then
        begin
          FBtnIdx := 1;
          if not FPopup and (idx = FBtnIdx) then
            PostMessage(Handle, CM_POPUP, 0, 0);
        end;
      end
      else if Assigned(FPopupMenu) then
        PostMessage(Handle, CM_POPUP, 0, 0);
    end;
    FButtonDown := False;
    FBtnIdx := -1;
    FPopup := False;
    Invalidate;
  end;
  inherited;
end;

procedure TrkGlassButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  idx: Integer;
begin
  InBtn := (PtInRect(ClientRect, Point(X, Y)));
  if (InBtn) and (not FButtonDown) then
  begin
    if X > Width - (ArrowWidth + 2) then
      idx := 1
    else
      idx := 0;
    if idx <> FBtnIdx then
    begin
      FBtnIdx := idx;
      Invalidate;
    end;
    FButtonDown := (ssLeft In Shift);
  end;
  inherited;
end;

procedure TrkGlassButton.CMMouseEnter(var Msg: TMessage);
begin
  FPopup := False;
  FButtonDown := False;
  FBtnIdx := -1;
  Invalidate;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(self);
  inherited;
end;

procedure TrkGlassButton.CMMouseLeave(var Msg: TMessage);
begin
  if not FPopup then
  begin
    FButtonDown := False;
    FBtnIdx := -1;
    Invalidate;
  end;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(self);
  inherited;
end;

procedure TrkGlassButton.CMPopUp(var Msg: TMessage);
var
  pt: TPoint;
begin
  if Assigned(FPopupMenu) then
  begin
    if Assigned(FOnBeforePopup) then
      FOnBeforePopup(self);
    pt.X := 0;
    if FPopupAlignment = paCenter then
      pt.X := ClientWidth shr 1
    else if FPopupAlignment = paRight then
      pt.X := ClientWidth;
    pt.Y := ClientHeight;
    pt := ClientToScreen(pt);
    PaintButton;
    FPopup := True;
    if Assigned(FOnPopup) then
      FOnPopup(self);
    FPopupMenu.Alignment := FPopupAlignment;
    FPopupMenu.Popup(pt.X + FPopupOff, pt.Y);
    FBtnIdx := -1;
    FButtonDown := False;
    Invalidate;
  end;
end;

procedure TrkGlassButton.CMTextChanged(var Msg: TMessage);
begin
  Invalidate;
end;

procedure TrkGlassButton.Resize;
begin
  Invalidate;
end;

procedure Register;
begin
  RegisterComponents('rmklever', [TrkGlassButton]);
end;

end.
