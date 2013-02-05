
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{  Copyright (c) 1995-2005 Borland Software Corporation }
{                                                       }
{*******************************************************}

{****************************************************************************}
{                                                                            }
{ Limitation on Distribution of Programs Created with this Source Code File: }
{ ========================================================================== }
{                                                                            }
{ For distribution of an application which you create with this Source       }
{ Code File, your application may not be a general-purpose, interactive      }
{ spreadsheet program, or a substitute for or generally competitive          }
{ with Quattro Pro.                                                          }
{                                                                            }
{****************************************************************************}

unit Tabs;

{$T-,H+,X+}

interface

uses Windows, WideStrings, Classes, Graphics, Forms, Controls, Messages, ImgList,
  ComCtrls, ExtCtrls;

type
  TScrollBtn = (sbLeft, sbRight);

  TScrollOrientation = (soLeftRight, soUpDown);

  TScroller = class(TCustomControl)
  private
    { property usage }
    FMin: Longint;
    FMax: Longint;
    FPosition: Longint;
    FOnClick: TNotifyEvent;
    FChange: Integer;
    FScrollOrientation: TScrollOrientation;

    { private usage }
    FBitmap: TBitmap;
    FPressed: Boolean;
    FDown: Boolean;
    FCurrent: TScrollBtn;
    FWidth: Integer;
    FHeight: Integer;

    FDownTimer: TTimer;

    { property access methods }
    procedure SetMin(Value: Longint);
    procedure SetMax(Value: Longint);
    procedure SetPosition(Value: Longint);

    { private methods }
    function CanScrollLeft: Boolean;
    function CanScrollRight: Boolean;
    procedure DoMouseDown(X: Integer);
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure SetScrollOrientation(const Value: TScrollOrientation);
    procedure DoScrollTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property Min: Longint read FMin write SetMin default 0;
    property Max: Longint read FMax write SetMax default 0;
    property Position: Longint read FPosition write SetPosition default 0;
    property ScrollOrientation: TScrollOrientation read FScrollOrientation write SetScrollOrientation;
    property Change: Integer read FChange write FChange default 1;
  end;

  TTabSet = class;

  TTabList = class(TStringList)
  private
    FTabSet: TTabSet;
  public
    constructor Create(const ATabSet: TTabSet);
    procedure Insert(Index: Integer; const S: string); override;
    procedure Delete(Index: Integer); override;
    function Add(const S: string): Integer; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure Clear; override;
    procedure AddStrings(Strings: TStrings); override;
  end;
  TtbStyles=array of integer;
  TUnicodeTabList = class(TWideStringList)
  private
    FTabSet: TTabSet;

  public
    tbStyles:TtbStyles;
    constructor Create(const ATabSet: TTabSet);
    procedure Insert(Index: Integer; const ws: WideString); override;
    procedure Delete(Index: Integer); override;
    function Add(const ws: WideString): Integer; override;
    procedure Put(Index: Integer; const ws: WideString); override;
    procedure Clear; override;
  end;


  { each TEdgeType is made up of one or two of these parts }
  TEdgePart = (epSelectedLeft, epUnselectedLeft, epSelectedRight,
    epUnselectedRight);

  { represents the intersection between two tabs, or the edge of a tab }
  TEdgeType = (etNone, etFirstIsSel, etFirstNotSel, etLastIsSel, etLastNotSel,
    etNotSelToSel, etSelToNotSel, etNotSelToNotSel);

  TTabSetTabStyle = (tsStandard, tsOwnerDraw, tsSoftTabs, tsModernTabs, tsModernPopout);
  TTabStyle = TTabSetTabStyle;

  TMeasureTabEvent = procedure(Sender: TObject; Index: Integer;
    var TabWidth: Integer) of object;
  TTabSetDrawTabEvent = procedure(Sender: TObject; TabCanvas: TCanvas; R: TRect;
    Index: Integer; Selected: Boolean) of object;
  TDrawTabEvent = TTabSetDrawTabEvent;
  TTabChangeEvent = procedure(Sender: TObject; NewTab: Integer;
    var AllowChange: Boolean) of object;

  TTabSet = class(TCustomControl)
  private
    FStartMargin: Integer;
    FEndMargin: Integer;
    FTabs: TStrings;
    FWideTabs:TWideStrings;
    FTabIndex: Integer;
    FFirstIndex: Integer;
    FVisibleTabs: Integer;
    FSelectedColor: TColor;
    FUnselectedColor: TColor;
    FBackgroundColor: TColor;
    FDitherBackground: Boolean;
    FAutoScroll: Boolean;
    FStyle: TTabStyle;
    FOwnerDrawHeight: Integer;
    FOnMeasureTab: TMeasureTabEvent;
    FOnDrawTab: TDrawTabEvent;
    FOnChange: TTabChangeEvent;

    FEdgeImageList: TImageList;
    FMemBitmap: TBitmap;   { used for off-screen drawing }
    FBrushBitmap: TBitmap; { used for background pattern }
    FTabPositions: TList;

    FSortedTabPositions: TList;
    FTabHeight: Integer;
    FScroller: TScroller;
    FDoFix: Boolean;
    FSoftTop: Boolean;
    FImages: TCustomImageList;
    FImageChangeLink: TChangeLink;
    FOnGetImageIndex: TTabGetImageEvent;
    FShrinkToFit: Boolean;
    FEdgeWidth: Integer;
    FTabPosition: TTabPosition;
    { property access methods }
    procedure SetSelectedColor(Value: TColor);
    procedure SetUnselectedColor(Value: TColor);
    procedure SetBackgroundColor(Value: TColor);
    procedure SetDitherBackground(Value: Boolean);
    procedure SetAutoScroll(Value: Boolean);
    procedure SetStartMargin(Value: Integer);
    procedure SetEndMargin(Value: Integer);
    procedure SetFirstIndex(Value: Integer);
    procedure SetTabList(Value: TStrings);
    procedure SetWideTabList(Value:TWideStrings);
    procedure SetTabStyle(Value: TTabStyle);
    procedure SetTabHeight(Value: Integer);
    { private methods }
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure PaintEdge(X, Y, H: Integer; Edge: TEdgeType);
    procedure CreateBrushPattern(Bitmap: TBitmap);
    function CalcTabPositions(const AStart, AStop: Integer; Canvas: TCanvas;
      First: Integer; FullTabs: Boolean): Integer;
    procedure CreateScroller;
    procedure InitBitmaps;
    procedure DoneBitmaps;
    procedure CreateEdgeParts;
    procedure FixTabPos;
    procedure ScrollClick(Sender: TObject);
    procedure SetSoftTop(const Value: Boolean);
    procedure SetImages(const Value: TCustomImageList);
    function ScrollerSize: Integer;
    procedure SetShrinkToFit(const Value: Boolean);
    procedure SetTabPosition(const Value: TTabPosition);
    procedure SetFontOrientation(ACanvas: TCanvas);
    procedure DrawLine(Canvas: TCanvas; FromX, FromY, ToX, ToY: Integer);
     procedure ImageListChange(Sender: TObject);
    procedure DoDefaultPainting;
    procedure DoModernPainting;
    procedure DoPopoutModernPainting;
    procedure SetupTabPositions;
    function ScrollerShown: Boolean;
    function TextWidth(canvas:TCanvas; wText:WideString):integer;
  protected
    function CanChange(NewIndex: Integer): Boolean;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DrawTab(TabCanvas: TCanvas; R: TRect; Index: Integer;
      Selected: Boolean); virtual;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetImageIndex(TabIndex: Integer): Integer; virtual;
    procedure MeasureTab(Index: Integer; var TabWidth: Integer); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    property Scroller: TScroller read FScroller;
    procedure SetTabIndex(Value: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ItemAtPos(Pos: TPoint; IgnoreTabHeight: Boolean = False): Integer;
    function ItemRect(Index: Integer): TRect;
    function ItemWidth(Index: Integer): Integer;
    function MinClientRect: TRect; overload;
    function MinClientRect(IncludeScroller: Boolean): TRect; overload;
    function MinClientRect(TabCount: Integer; IncludeScroller: Boolean = False): TRect; overload;
    procedure SelectNext(Direction: Boolean);
    property Canvas;
    property FirstIndex: Integer read FFirstIndex write SetFirstIndex default 0;
    property WideTabs: TWideStrings read FWideTabs write SetWideTabList;

  published
    property Align;
    property Anchors;
    property AutoScroll: Boolean read FAutoScroll write SetAutoScroll default True;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor default clBtnFace;
    property Constraints;
    property DitherBackground: Boolean read FDitherBackground write SetDitherBackground default True;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EndMargin: Integer read FEndMargin write SetEndMargin default 5;
    property Font;
    property Images: TCustomImageList read FImages write SetImages;
    property ParentBackground default False;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property ShrinkToFit: Boolean read FShrinkToFit write SetShrinkToFit default False;
    property StartMargin: Integer read FStartMargin write SetStartMargin default 5;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clBtnFace;
    property SoftTop: Boolean read FSoftTop write SetSoftTop default False;
    property Style: TTabStyle read FStyle write SetTabStyle default tsStandard;
    property TabHeight: Integer read FOwnerDrawHeight write SetTabHeight default 20;
    property Tabs: TStrings read FTabs write SetTabList;
    property TabIndex: Integer read FTabIndex write SetTabIndex default -1;
    property TabPosition: TTabPosition read FTabPosition write SetTabPosition default tpBottom;
    property UnselectedColor: TColor read FUnselectedColor write SetUnselectedColor default clWindow;
    property Visible;
    property VisibleTabs: Integer read FVisibleTabs;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnClick;
    property OnChange: TTabChangeEvent read FOnChange write FOnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawTab: TDrawTabEvent read FOnDrawTab write FOnDrawTab;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex: TTabGetImageEvent read FOnGetImageIndex write FOnGetImageIndex;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMeasureTab: TMeasureTabEvent read FOnMeasureTab write FOnMeasureTab;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses Consts, SysUtils, Themes, Math, Types, GraphUtil, tntControls;

{$R Tabs.res}

type
  TTabPos = packed record
    Size, StartPos: Word;
  end;

{ TScroller }

constructor TScroller.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  FBitmap := TBitmap.Create;
  FWidth := 24;
  FHeight := 13;
  FMin := 0;
  FMax := 0;
  FPosition := 0;
  FChange := 1;
  FDownTimer := TTimer.Create(nil);
  FDownTimer.Enabled := False;
  FDownTimer.Interval := 100;
  FDownTimer.OnTimer := DoScrollTimer;
end;

destructor TScroller.Destroy;
begin
  FDownTimer.Free;
  FBitmap.Free;
  inherited Destroy;
end;

procedure TScroller.Paint;
const
  cLeftOrient: array[TScrollOrientation] of string = ('SBLEFT', 'SBUP');
  cLeftDnOrient: array[TScrollOrientation] of string = ('SBLEFTDN', 'SBUPDN');
  cLeftDisOrient: array[TScrollOrientation] of string = ('SBLEFTDIS', 'SBUPDIS');
  cRightOrient: array[TScrollOrientation] of string = ('SBRIGHT', 'SBDOWN');
  cRightDnOrient: array[TScrollOrientation] of string = ('SBRIGHTDN', 'SBDOWNDN');
  cRightDisOrient: array[TScrollOrientation] of string = ('SBRIGHTDIS', 'SBDOWNDIS');
begin
  with Canvas do
  begin
    { paint left button }
    if CanScrollLeft then
    begin
      if FDown and (FCurrent = sbLeft) then
        FBitmap.LoadFromResourceName(HInstance, cLeftDnOrient[FScrollOrientation])
      else
        FBitmap.LoadFromResourceName(HInstance, cLeftOrient[FScrollOrientation]);
    end
    else
      FBitmap.LoadFromResourceName(HInstance, cLeftDisOrient[FScrollOrientation]);
    Draw(0, 0, FBitmap);

    { paint right button }
    if CanScrollRight then
    begin
      if FDown and (FCurrent = sbRight) then
        FBitmap.LoadFromResourceName(HInstance, cRightDnOrient[FScrollOrientation])
      else
        FBitmap.LoadFromResourceName(HInstance, cRightOrient[FScrollOrientation]);
    end
    else
      FBitmap.LoadFromResourceName(HInstance, cRightDisOrient[FScrollOrientation]);
    Draw((FWidth div 2) - 1, 0, FBitmap);
  end;
end;

procedure TScroller.WMSize(var Message: TWMSize);
begin
  inherited;
  Width := FWidth - 1;
  Height := FHeight;
end;

procedure TScroller.SetMin(Value: Longint);
begin
  if Value < FMax then FMin := Value;
end;

procedure TScroller.SetMax(Value: Longint);
begin
  if Value > FMin then FMax := Value;
end;

procedure TScroller.SetPosition(Value: Longint);
begin
  if Value <> FPosition then
  begin
    if Value < Min then Value := Min;
    if Value > Max then Value := Max;
    FPosition := Value;
    Invalidate;
    if Assigned(FOnClick) then
      FOnClick(Self);
  end;
end;

function TScroller.CanScrollLeft: Boolean;
begin
  Result := Position > Min;
end;

function TScroller.CanScrollRight: Boolean;
begin
  Result := Position < Max;
end;

procedure TScroller.DoMouseDown(X: Integer);
begin
  if X < FWidth div 2 then
    FCurrent := sbLeft
  else
    FCurrent := sbRight;
  case FCurrent of
    sbLeft: if not CanScrollLeft then Exit;
    sbRight: if not CanScrollRight then Exit;
  end;
  FPressed := True;
  FDown := True;
  Invalidate;
  SetCapture(Handle);
  FDownTimer.Enabled := True;
end;

procedure TScroller.WMLButtonDown(var Message: TWMLButtonDown);
begin
  DoMouseDown(Message.XPos);
end;

procedure TScroller.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  DoMouseDown(Message.XPos);
end;

procedure TScroller.WMMouseMove(var Message: TWMMouseMove);
var
  P: TPoint;
  R: TRect;
begin
  if FPressed then
  begin
    P := Point(Message.XPos, Message.YPos);
    R := Rect(0, 0, FWidth div 2, FHeight);
    if FCurrent = sbRight then OffsetRect(R, FWidth div 2, 0);
    if PtInRect(R, P) <> FDown then
    begin
      FDown := not FDown;
      FDownTimer.Enabled := FDown;
      Invalidate;
    end;
  end;
end;

procedure TScroller.WMLButtonUp(var Message: TWMLButtonUp);
var
  NewPos: Longint;
begin
  FDownTimer.Enabled := False;
  ReleaseCapture;
  FPressed := False;

  if FDown then
  begin
    FDown := False;
    NewPos := Position;
    case FCurrent of
      sbLeft: Dec(NewPos, Change);
      sbRight: Inc(NewPos, Change);
    end;
    Position := NewPos;
  end;
end;

procedure TScroller.SetScrollOrientation(const Value: TScrollOrientation);
const
  cWidthSize: array[TScrollOrientation] of Integer = (24, 26);
  cHeightSize: array[TScrollOrientation] of Integer = (13, 12);
begin
  if FScrollOrientation <> Value then
  begin
    FWidth := cWidthSize[Value];
    FHeight := cHeightSize[Value];
    FScrollOrientation := Value;
    Resize;
    Invalidate;
  end;
end;

procedure TScroller.DoScrollTimer(Sender: TObject);
var
  NewPos: Integer;
begin
  if FDown then
  begin
    NewPos := Position;
    case FCurrent of
      sbLeft:
        if CanScrollLeft then
          Dec(NewPos, Change);
      sbRight:
        if CanScrollRight then
          Inc(NewPos, Change);
    end;
    Position := NewPos;
  end;
end;

{ TTabList }

function TTabList.Add(const S: string): Integer;
begin
  Result := inherited Add(S);
  if FTabSet <> nil then
    FTabSet.Invalidate;
end;

procedure TTabList.Insert(Index: Integer; const S: string);
begin
  inherited Insert(Index, S);
  if FTabSet <> nil then
  begin
    if Index <= FTabSet.FTabIndex then Inc(FTabSet.FTabIndex);
    FTabSet.Invalidate;
  end;
end;

procedure TTabList.Delete(Index: Integer);
var
  OldIndex: Integer;
  LastVisibleTab: Integer;
begin
  OldIndex := FTabSet.Tabindex;
  inherited Delete(Index);

  if OldIndex < Count then
    FTabSet.FTabIndex := OldIndex
  else
    FTabSet.FTabIndex := Count - 1;

  if FTabSet.HandleAllocated then
  begin
    { See if we can fit more tabs onto the screen now }
    if (not FTabSet.FShrinkToFit) and (Count > 0) then
    begin
      if FTabSet.FVisibleTabs < Count then
        FTabSet.SetupTabPositions; { Insure FVisibleTabs is up to date }
      LastVisibleTab := FTabSet.FFirstIndex + FTabSet.FVisibleTabs - 1;
      if (LastVisibleTab = Count - 1) and (FTabSet.FFirstIndex > 0) then
        FTabSet.FFirstIndex := FTabSet.FFirstIndex - 1; { We could probably fit one more on screen }
      FTabSet.FixTabPos;
    end;
  end;

  FTabSet.SetupTabPositions;
  FTabSet.Invalidate;
  if OldIndex = Index then
    FTabSet.Click;  { We deleted the selected tab }
end;

procedure TTabList.Put(Index: Integer; const S: string);
begin
  inherited Put(Index, S);
  if FTabSet <> nil then
    FTabSet.Invalidate;
end;

procedure TTabList.Clear;
begin
  inherited Clear;
  FTabSet.FTabIndex := -1;
  FTabSet.Invalidate;
end;

procedure TTabList.AddStrings(Strings: TStrings);
begin
  SendMessage(FTabSet.Handle, WM_SETREDRAW, 0, 0);
  inherited AddStrings(Strings);
  SendMessage(FTabSet.Handle, WM_SETREDRAW, 1, 0);
  FTabSet.Invalidate;
end;

constructor TTabList.Create(const ATabSet: TTabSet);
begin
  inherited Create;
  FTabSet := ATabSet;
end;

{ TTabSet }

const
  cNonFlatWidth = 9;

constructor TTabSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csDoubleClicks, csOpaque, csPannable];
  Width := 185;
  Height := 21;

  FTabPositions := TList.Create;
  FSortedTabPositions := TList.Create;
  FTabHeight := 20;

  FTabs := TTabList.Create(Self);
  FWideTabs:=TUnicodeTabList.Create(self);
  InitBitmaps;

  CreateScroller;

  FTabIndex := -1;
  FFirstIndex := 0;
  FVisibleTabs := 0;  { set by draw routine }
  FStartMargin := 5;
  FEndMargin := 5;
  FTabPosition := tpBottom;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FEdgeWidth := cNonFlatWidth;  { This controls the angle of the tab edges }

  { initialize default values }
  FSelectedColor := clBtnFace;
  FUnselectedColor := clWindow;
  FBackgroundColor := clBtnFace;
  FDitherBackground := True;
  CreateBrushPattern(FBrushBitmap);
  FAutoScroll := True;
  FStyle := tsStandard;
  FOwnerDrawHeight := 20;

  ParentFont := False;
  Font.Name := DefFontData.Name;
  Font.Height := DefFontData.Height;
  Font.Style := [];

  { create the edge bitmaps }
  CreateEdgeParts;
end;

procedure TTabSet.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params.WindowClass do
    style := style and not (CS_VREDRAW or CS_HREDRAW);
end;

procedure TTabSet.CreateScroller;
begin
  FScroller := TScroller.Create(Self);
  with Scroller do
  begin
    Parent := Self;
    Top := 3;
    Min := 0;
    Max := 0;
    Position := 0;
    Visible := False;
    OnClick := ScrollClick;
  end;
end;

procedure TTabSet.InitBitmaps;
begin
  FMemBitmap := TBitmap.Create;
  FBrushBitmap := TBitmap.Create;
end;

destructor TTabSet.Destroy;
begin
  FTabs.Free;
  FWideTabs.Free();
  FTabPositions.Free;
  FSortedTabPositions.Free;
  DoneBitmaps;
  FImageChangeLink.Free;
  inherited Destroy;
end;

procedure TTabSet.DoneBitmaps;
begin
  FMemBitmap.Free;
  FBrushBitmap.Free;
  FEdgeImageList.Free;
end;

procedure TTabSet.ScrollClick(Sender: TObject);
begin
  FirstIndex := TScroller(Sender).Position;
end;

function TabPosCompare(Item1, Item2: Pointer): Integer;
var
  FirstTabPos, SecondTabPos: TTabPos;
begin
  FirstTabPos := TTabPos(Item1);
  SecondTabPos := TTabPos(Item2);
  Result := SecondTabPos.Size - FirstTabPos.Size;
end;

{ cache the tab position data, and return number of visible tabs }
function TTabSet.CalcTabPositions(const AStart, AStop: Integer; Canvas: TCanvas;
  First: Integer; FullTabs: Boolean): Integer;
var
  Index: Integer;
  TabPos, NextTabPos: TTabPos;
  Start, Stop: Integer;
  CutAmount, CurrentCut: Integer;
  I, J: Integer;
  MaxSize: Integer;
begin
  FTabPositions.Count := 0;  { Erase all previously cached data }
  FSortedTabPositions.Clear;
  Index := First;
  Start := AStart;
  Stop := AStop;
  while (Start < Stop) and (Index < WideTabs.Count) do
  begin
    with Canvas do
    begin
      TabPos.StartPos := Start;
      TabPos.Size := ItemWidth(Index);
      Inc(Start, TabPos.Size + FEdgeWidth);    { next usable position }

      if (Start <= Stop) or (not FullTabs) then { Allowing this allows partial tabs }
      begin
        FTabPositions.Add(Pointer(TabPos));    { add to list }
        Inc(Index);
      end;
      FSortedTabPositions.Add(Pointer(TabPos));
    end;
  end;
  { If we are to "resize" tabs, then do that }
  if FShrinkToFit and (Index < WideTabs.Count) then
  begin
    Inc(Index); { Last one already added in the above loop }
    { First, finish "adding" in all the tabs. }
    while (Index < WideTabs.Count) do
    begin
      TabPos.StartPos := Start;
      TabPos.Size := ItemWidth(Index);
      Inc(Start, TabPos.Size + FEdgeWidth);
      FSortedTabPositions.Add(Pointer(TabPos));
      Inc(Index);
    end;
    CutAmount := Start - AStop;
    { Now sort them, so we can shrink the largest ones down to make them fit. }
    FSortedTabPositions.Sort(TabPosCompare);
    { Trim off what we have to cut }
    while (CutAmount > 0) and (FSortedTabPositions.Count > 0) do
    begin
      TabPos := TTabPos(FSortedTabPositions[0]);
      CurrentCut := CutAmount;
      J := 1; { Number of tabs the same size }
      for I := 1 to FSortedTabPositions.Count - 1 do
      begin
        NextTabPos := TTabPos(FSortedTabPositions[I]);
        if TabPos.Size <> NextTabPos.Size then
        begin
          { Take the difference between the tab sizes, or the whole cut
            amount, if it is smaller }
          CurrentCut := Min(TabPos.Size - NextTabPos.Size, CutAmount);
          Break;
        end;
        Inc(J);
      end;
      { Divide the cut amount among the tabs of the same size }
      CurrentCut := Max(1, CurrentCut div J);
      { Cut all those tabs the same amount, but at least one pixel. }
      for I := 0 to J - 1 do
      begin
        TabPos := TTabPos(FSortedTabPositions[I]);
        Dec(TabPos.Size, CurrentCut);
        FSortedTabPositions[I] := Pointer(TabPos);
        Dec(CutAmount, CurrentCut);
        if CutAmount <= 0 then
          Break; { We are done }
      end;
    end;

    if FSortedTabPositions.Count > 0 then
    begin
      { The largest one's size is the max size to use }
      MaxSize := TTabPos(FSortedTabPositions[0]).Size;
      { Now, add all the tabs again, using this size as the maxsize for a tab }

      FTabPositions.Clear;
      Index := First;
      Start := AStart;
      Stop := AStop;
      while (Start < Stop) and (Index < WideTabs.Count) do
      begin
        with Canvas do
        begin
          TabPos.StartPos := Start;
          TabPos.Size := Min(ItemWidth(Index), MaxSize);
          Inc(Start, TabPos.Size + FEdgeWidth);    { next usable position }
          if Start <= Stop then
          begin
            FTabPositions.Add(Pointer(TabPos));    { add to list }
            Inc(Index);
          end;
        end;
      end;
    end;
  end;
  Result := Index - First;
end;

function TTabSet.ItemAtPos(Pos: TPoint; IgnoreTabHeight: Boolean): Integer;
var
  TabPos: TTabPos;
  I: Integer;
  YStart: Integer;
  Extra: Integer;
  MinLeft, MaxRight: Integer;
begin
  Result := -1;
  if (Pos.X < 0) or (Pos.X > ClientWidth) or
     (Pos.Y < 0) or (Pos.Y > ClientHeight) then
    Exit;

  case FTabPosition of
    tpBottom:
      YStart := 0;
    tpTop:
      YStart := ClientHeight - FTabHeight;
    tpLeft:
    begin
      { Switch the X and Y }
      I := Pos.X;
      Pos.X := Pos.Y;
      Pos.Y := I;
      YStart := ClientWidth - FTabHeight;  { Really the "X" start }
    end;
    tpRight:
    begin
      { Switch the X and Y }
      I := Pos.X;
      Pos.X := Pos.Y;
      Pos.Y := I;
      YStart := 0;  { Really the "X" start }
    end;
    else
      YStart := 0;
  end;

  if IgnoreTabHeight or ((Pos.Y >= YStart) and (Pos.Y <= YStart + FTabHeight)) then
  begin
    if Pos.Y < YStart + FTabHeight div 2 then
      Extra := FEdgeWidth div 3
    else
      Extra := FEdgeWidth div 2;

    for I := 0 to FTabPositions.Count - 1 do
    begin
      Pointer(TabPos) := FTabPositions[I];
      MinLeft := TabPos.StartPos - Extra;
      MaxRight := TabPos.StartPos + TabPos.Size + Extra;
      if (Pos.X >= MinLeft) and (Pos.X <= MaxRight) then
      begin
        Result := FirstIndex + I;
        Break;
      end;
    end;
  end;
end;

function TTabSet.ItemRect(Index: Integer): TRect;
var
  TabPos: TTabPos;
  TabTop: Integer;
begin
  if FFirstIndex > 0 then
    Index := Index - FFirstIndex;
  if (FTabPositions.Count > 0) and (Index >= 0) and (Index < FTabPositions.Count) then
  begin
    Pointer(TabPos) := FTabPositions[Index];
    if FTabPosition in [tpBottom, tpRight] then
      TabTop := 0
    else if FTabPosition = tpTop then
      TabTop := ClientHeight - FTabHeight
    else { FTabPosition = tpLeft }
      TabTop := ClientWidth - FTabHeight;

    if FTabPosition in [tpTop, tpBottom] then
    begin
      Result := Rect(TabPos.StartPos, TabTop, TabPos.StartPos + TabPos.Size,
        TabTop + FTabHeight);
      InflateRect(Result, 1, -2);
    end
    else     { Flip the X and Y if the position is vertical }
    begin
      Result := Rect(TabTop, TabPos.StartPos, TabTop + FTabHeight,
        TabPos.StartPos + TabPos.Size);
      InflateRect(Result, -1, 1);
    end;
  end
  else
    Result := Rect(0, 0, 0, 0);
end;

procedure TTabSet.DrawLine(Canvas: TCanvas; FromX, FromY, ToX, ToY: Integer);
var
  T: Integer;
begin
  if FTabPosition in [tpLeft, tpRight] then
  begin
    T := FromX;
    FromX := FromY;
    FromY := T;
    T := ToX;
    ToX := ToY;
    ToY := T;
  end;
  Canvas.MoveTo(FromX, FromY);
  Canvas.LineTo(ToX, ToY);
end;

procedure TTabSet.DoDefaultPainting;
var
  YStart, YEnd, YMod: Integer;
  TabPos: TTabPos;
  Tab: Integer;
  Leading: TEdgeType;
  Trailing: TEdgeType;
  isFirst, isLast, isSelected, isPrevSelected: Boolean;
  R: TRect;
  MinRect: Integer;
  sz: tagSIZE;
  ws:WideString;
  ImageIndex: Integer;
  TabTop: Integer;
  TotalSize: Integer;

 procedure _TextRect(handle:HDC; var Rect: TRect; var Text: WideString;
  TextFormat: TTextFormat = []);
  const
  cTextFormats: array[TTextFormats] of Integer =
  (DT_BOTTOM, DT_CALCRECT, DT_CENTER, DT_EDITCONTROL, DT_END_ELLIPSIS,
   DT_PATH_ELLIPSIS, DT_EXPANDTABS, DT_EXTERNALLEADING, DT_LEFT,
   DT_MODIFYSTRING, DT_NOCLIP, DT_NOPREFIX, DT_RIGHT, DT_RTLREADING,
   DT_SINGLELINE, DT_TOP, DT_VCENTER, DT_WORDBREAK);
var
  Format: Integer;
  F: TTextFormats;
//  r:integer;
begin
  Format := 0;
  for F := Low(TTextFormats) to High(TTextFormats) do
    if F in TextFormat then
      Format := Format or cTextFormats[F];
  DrawTextExW(Handle, PWideChar(Pointer(Text)), Length(Text), Rect, Format, nil);
end;


begin
  { Calculate our true drawing positions }
  if FTabPosition in [tpBottom, tpRight] then
  begin
    TabTop := 0;
    YStart := 0;
    YEnd := FTabHeight;
    YMod := 1;
  end
  else if FTabPosition = tpTop then
  begin
    TabTop := ClientHeight - FTabHeight;
    YStart := ClientHeight - 1;
    YMod := -1;
    YEnd := TabTop - 1;
  end
  else { tpLeft }
  begin
    TabTop := ClientWidth - FTabHeight;
    YStart := ClientWidth - 1;
    YMod := -1;
    YEnd := TabTop - 1;
  end;

  if FTabPosition in [tpTop, tpBottom] then
    TotalSize := FMemBitmap.Width
  else
    TotalSize := FMemBitmap.Height;

  { draw background of tab area }
  with FMemBitmap.Canvas do
  begin {$R-}
    Brush.Bitmap := FBrushBitmap;
    if ThemeServices.ThemesEnabled and ParentBackground then
      Perform(WM_ERASEBKGND, FMemBitmap.Canvas.Handle, 0)
    else
      FillRect(Rect(0, 0, FMemBitmap.Width, FMemBitmap.Height));

    // draw top edge
    // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    //  \               /--------------/
    //   \             /\             /
    //    \___________/  \___________/
    Pen.Width := 1;
    Pen.Color := clBtnShadow;
    DrawLine(FMemBitmap.Canvas, 0, YStart, TotalSize + 1, YStart);

    if not FSoftTop then
    begin
      Pen.Color := clWindowFrame;
      DrawLine(FMemBitmap.Canvas, 0, YStart + YMod, TotalSize + 1, YStart + YMod);
    end;
    MinRect := TextWidth('X...'); { Do not localize }
  end;

  for Tab := 0 to FTabPositions.Count - 1 do
  begin
    Pointer(TabPos) := FTabPositions[Tab];

    isFirst := Tab = 0;
    isLast := Tab = VisibleTabs - 1;
    isSelected := Tab + FirstIndex = TabIndex;
//    isHl:=TUnicodeTabList(FWideTabs).tbStyles[tab]=1;
    isPrevSelected := (Tab + FirstIndex) - 1 = TabIndex;

    { Rule: every tab paints its leading edge, only the last tab paints a
      trailing edge }
    Trailing := etNone;

    if isLast then
    begin
      if isSelected then
        Trailing := etLastIsSel
      else
        Trailing := etLastNotSel;
    end;

    if isFirst then
    begin
      if isSelected then
        Leading := etFirstIsSel
      else
        Leading := etFirstNotSel;
    end
    else { not first }
    begin
      if isPrevSelected then
        Leading := etSelToNotSel
      else if isSelected then
        Leading := etNotSelToSel
      else
        Leading := etNotSelToNotSel;
    end;

    { draw leading edge }
    // |XXXX|================================
    // | X  |             /--------------/
    // |  X |            /\             /
    // |   X|___________/  \___________/
    if Leading <> etNone then
      PaintEdge(TabPos.StartPos - FEdgeWidth, TabTop, FTabHeight - 1, Leading);

    { set up the canvas }
    if FTabPosition in [tpTop, tpBottom] then
      R := Rect(TabPos.StartPos, TabTop, TabPos.StartPos + TabPos.Size,
        TabTop + FTabHeight)
    else { Switch X and Y  }
      R := Rect(TabTop, TabPos.StartPos, TabTop + FTabHeight,
        TabPos.StartPos + TabPos.Size);

    if isSelected then
      FMemBitmap.Canvas.Brush.Color := SelectedColor
    else
      FMemBitmap.Canvas.Brush.Color := UnselectedColor;

    FMemBitmap.Canvas.FillRect(R);

    if (FStyle = tsOwnerDraw) then
      DrawTab(FMemBitmap.Canvas, R, Tab + FirstIndex, isSelected)
    else
    begin
      with FMemBitmap.Canvas do
      begin
        if FTabPosition in [tpTop, tpBottom] then
        begin
          Inc(R.Top, 2);
          { Move a little to the right; it looks better with newer fonts }
          Inc(R.Left, 1);
          Inc(R.Right, 1);
        end
        else
        begin
          { Flip the width and height of the rect so we
            get correct clipping of the text when writing at a non-0
            orientation }
          if FTabPosition = tpRight then
          begin
            Inc(R.Left, 1 + TextHeight('X')) { Do not localize }
          end
          else { tpLeft }
          begin
            Inc(R.Left, 2);
            { For vertical text consideration, the drawing starts at the
              "bottom" }
            R.Top := R.Top + TabPos.Size;
          end;
          R.Right := R.Left + TabPos.Size;
          R.Bottom := R.Top + FTabHeight;
        end;
        { Draw the image first }
        if (FImages <> nil) then
        begin
          ImageIndex := GetImageIndex(Tab + FirstIndex);
          if (ImageIndex > -1) and (ImageIndex < FImages.Count) then
          begin
            if FTabPosition in [tpTop, tpBottom] then
            begin
              FImages.Draw(FMemBitmap.Canvas, R.Left, R.Top, ImageIndex);
              Inc(R.Left, 2 + FImages.Width);
              Inc(R.Top, 2);
            end
            else if FTabPosition = tpRight then
            begin
              FImages.Draw(FMemBitmap.Canvas, R.Left - TextHeight('X'),
                R.Top, ImageIndex);
              Inc(R.Top, 2 + FImages.Height);
              Dec(R.Right, FImages.Height); { For proper clipping }
              Inc(R.Left, 2);
            end
            else
            begin
              FImages.Draw(FMemBitmap.Canvas, R.Left, R.Top - FImages.Height,
                ImageIndex);
              Dec(R.Top, 2 + FImages.Height);
              Dec(R.Right, FImages.Height); { For proper clipping }
              Inc(R.Left, 2);
            end;
          end;
        end;
        //S := Tabs[Tab + FirstIndex];
        ws:=WideTabs[Tab + FirstIndex];
        sz.cX := 0;
        sz.cY := 0;
        {if isHl then FMemBitmap.Canvas.Font.Color:=$5788aE
        else} FMemBitmap.Canvas.Font.Color:=self.Font.Color;
        Windows.GetTextExtentPoint32W(Canvas.Handle, PWideChar(Pointer(ws) ), Length(ws), sz);
        if (R.Right - R.Left >= MinRect) or
            (sz.cX <= (R.Right - R.Left)) then begin
           _TextRect(FMemBitmap.Canvas.Handle, R, ws, [tfEndEllipsis, tfCenter, tfNoClip]);
          end
      end;
    end;

    { draw trailing edge  }
    // ===============|XXXX|=================
    //  \             |  XX|-------------/
    //   \            | XX |            /
    //    \___________|X  X|___________/
    // or
    // ==============================|XXXX|==
    //  \               /------------|XXX |
    //   \             /\            | X  |
    //    \___________/  \___________|X   |
    if Trailing <> etNone then
      PaintEdge(TabPos.StartPos + TabPos.Size, TabTop, FTabHeight - 1, Trailing);

    { draw connecting lines above and below the text }
    // ====================================
    //  \               /-XXXXXXXXXXX--/
    //   \             /\             /
    //    \XXXXXXXXXXX/  \XXXXXXXXXXX/
    with FMemBitmap.Canvas do
    begin
      if (FStyle = tsSoftTabs)  then
        Pen.Color := clBtnShadow
      else
        Pen.Color := clWindowFrame;


      DrawLine(FMemBitmap.Canvas, TabPos.StartPos, YEnd - YMod,
        TabPos.StartPos + TabPos.Size, YEnd - YMod);

      if not isSelected then
      begin
        if SoftTop then
          Pen.Color := BackgroundColor
        else
          Pen.Color := clWindowFrame;

        if SoftTop then
        DrawLine(FMemBitmap.Canvas, TabPos.StartPos, YStart + YMod,
          TabPos.StartPos + TabPos.Size, YStart + YMod);

        Pen.Color := clBtnShadow;
        if SoftTop then
        DrawLine(FMemBitmap.Canvas, TabPos.StartPos, YStart,
          TabPos.StartPos + TabPos.Size + 1, YStart);
//       if isHl then begin
//        Pen.Color:=$0097CDF9;
//        Pen.Width:=2;
//        DrawLine(FMemBitmap.Canvas, TabPos.StartPos, YEnd - YMod-1,
//
//        TabPos.StartPos + TabPos.Size+5, YEnd - YMod-1);
//        Pen.Width:=1;
//        end;

      end;
    end;
  end;
end;

procedure TTabSet.Paint;
begin
  SetupTabPositions;
  FDoFix := False;
  if FStyle in [tsStandard, tsOwnerDraw, tsSoftTabs] then
    DoDefaultPainting
  else if FStyle = tsModernTabs then
    DoModernPainting
  else
    DoPopoutModernPainting;
  Canvas.Draw(0, 0, FMemBitmap);

end;

procedure TTabSet.CreateEdgeParts;
var
  H: Integer;
  Working: TBitmap;
  EdgePart: TEdgePart;
  MaskColor: TColor;
  Y: Integer;
  YEnd: Integer;
  YMod: Integer;

  procedure DrawPoly(Canvas: TCanvas; Polygon: Boolean;
    Points: array of TPoint);
  var
    I: Integer;
    TempX: Integer;
  begin
    if FTabPosition in [tpLeft, tpRight] then
    begin
      { Switch the X and Y in the points }
      for I := Low(Points) to High(Points) do
      begin
        TempX := Points[I].X;
        Points[I].X := Points[I].Y;
        Points[I].Y := TempX;
      end;
    end;
    if Polygon then
      Canvas.Polygon(Points)
    else
      Canvas.Polyline(Points);
  end;

  procedure DrawUL(Canvas: TCanvas);
  begin
    with Canvas do
    begin
      { Draw the top line }
      Pen.Color := clBtnShadow;
      DrawPoly(Canvas, False, [Point(0, Y), Point(FEdgeWidth + 1, Y)]);
      { Fill in the middle }
      Pen.Color := UnselectedColor;
      Brush.Color := UnselectedColor;

      DrawPoly(Canvas, True, [Point(3, Y + YMod),
        Point(FEdgeWidth - 1, YEnd), Point(FEdgeWidth, YEnd),
        Point(FEdgeWidth, Y + YMod), Point(3, Y + YMod)]);

      if SoftTop then
      begin
        Pen.Color := BackgroundColor;
        DrawPoly(Canvas, False, [Point(4, Y + YMod),
          Point(FEdgeWidth + 1, Y + YMod)]);

        if FStyle = tsSoftTabs then
          Pen.Color := clBtnShadow
        else
          Pen.Color := clWindowFrame;
        DrawPoly(Canvas, False, [Point(3, Y + YMod),
          Point(FEdgeWidth - 1, YEnd),
          Point(FEdgeWidth, YEnd)]);
      end
      else
      begin
        if FStyle = tsSoftTabs then
          Pen.Color := clBtnShadow
        else
          Pen.Color := clWindowFrame;
        DrawPoly(Canvas, False, [Point(0, Y + YMod),
          Point(FEdgeWidth + 1, Y + YMod),
          Point(3, Y + YMod),
          Point(FEdgeWidth - 1, YEnd),
          Point(FEdgeWidth, YEnd)]);
      end;
    end;
  end;

  procedure DrawSL(Canvas: TCanvas);
  begin
    with Canvas do
    begin
      Pen.Color := SelectedColor;
      Brush.Color := SelectedColor;
      { Fill the inside with the selected color }
      DrawPoly(Canvas, True, [Point(3, Y),
        Point(FEdgeWidth - 1, YEnd),
        Point(FEdgeWidth, YEnd),
        Point(FEdgeWidth, Y),
        Point(3, Y)]);

      Pen.Color := clBtnShadow;
      if not (FStyle = tsSoftTabs) then
      begin
        { Draw 3-D edges on the left }
        DrawPoly(Canvas, False, [Point(0, Y), Point(4, Y)]);
        Pen.Color := clBtnHighlight;
        DrawPoly(Canvas, False, [Point(4, Y + YMod),
          Point(FEdgeWidth, YEnd + 1)]);
        Pen.Color := clWindowFrame;
      end;

      if SoftTop then
        DrawPoly(Canvas, False, [Point(3, Y + YMod),
          Point(FEdgeWidth - 1, YEnd),
          Point(FEdgeWidth, YEnd)])
      else
        DrawPoly(Canvas, False, [Point(0, Y + YMod),
          Point(3, Y + YMod),
          Point(FEdgeWidth - 1, YEnd),
          Point(FEdgeWidth, YEnd)]);
    end;
  end;

  procedure DrawUR(Canvas: TCanvas);
  begin
    with Canvas do
    begin
      Pen.Color := clBtnShadow;
      DrawPoly(Canvas, False, [Point(-1, Y), Point(FEdgeWidth + 1, Y)]);

      Pen.Color := UnselectedColor;
      Brush.Color := UnselectedColor;

      DrawPoly(Canvas, True, [Point(FEdgeWidth - 3, Y + YMod),
        Point(1, YEnd), Point(0, YEnd),
        Point(0, Y + YMod), Point(FEdgeWidth - 3, Y + YMod)]);

      { workaround for bug in S3 driver }
      Pen.Color := clBtnShadow;
      DrawPoly(Canvas, False, [Point(-1, Y), Point(FEdgeWidth + 1, Y)]);

      if SoftTop then
      begin
        Pen.Color := BackgroundColor;
        DrawPoly(Canvas, False, [Point(0, Y + YMod),
          Point(FEdgeWidth - 1, Y + YMod)]);

        if FStyle = tsSoftTabs then
          Pen.Color := clBtnShadow
        else
          Pen.Color := clWindowFrame;
        DrawPoly(Canvas, False, [Point(FEdgeWidth - 2, Y + YMod),
          Point(2, YEnd),
          Point(-1, YEnd)]);
      end
      else
      begin
        if FStyle = tsSoftTabs then
          Pen.Color := clBtnShadow
        else
          Pen.Color := clWindowFrame;
        DrawPoly(Canvas, False, [Point(0, Y + YMod),
          Point(FEdgeWidth + 1, Y + YMod),
          Point(FEdgeWidth - 2, Y + YMod),
          Point(2, YEnd),
          Point(-1, YEnd)]);
      end;
    end;
  end;

  procedure DrawSR(Canvas: TCanvas);
  begin
    with Canvas do
    begin
      Pen.Color := SelectedColor;
      Brush.Color := SelectedColor;
      DrawPoly(Canvas, True, [Point(FEdgeWidth - 3, Y + YMod),
        Point(2, YEnd),
        Point(0, YEnd),
        Point(0, Y),
        Point(FEdgeWidth + 1, Y)]);

      Pen.Color := clBtnShadow;
      if FStyle = tsSoftTabs then
        DrawLine(Canvas, FEdgeWidth + 1, Y, FEdgeWidth - 2, Y)
      else
      begin
        DrawPoly(Canvas, False, [Point(FEdgeWidth + 1, Y),
          Point(FEdgeWidth - 3, Y),
          Point(FEdgeWidth - 3, Y + YMod),
          Point(1, YEnd),
          Point(-1, YEnd)]);
        Pen.Color := clWindowFrame;
      end;
      if SoftTop then
        DrawPoly(Canvas, False, [Point(FEdgeWidth - 2, Y + YMod),
          Point(2, YEnd),
          Point(-1, YEnd)])
      else
        DrawPoly(Canvas, False, [Point(FEdgeWidth, Y + YMod),
          Point(FEdgeWidth - 2, Y + YMod),
          Point(2, YEnd),
          Point(-1, YEnd)]);
    end;
  end;

var
  TempList: TImageList;
  SaveHeight: Integer;
  ActualWidth, ActualHeight: Integer;
begin
  FMemBitmap.Canvas.Font := Font;

  { Owner }
  SaveHeight := FTabHeight;
  try
    if FStyle = tsOwnerDraw then
      FTabHeight := FOwnerDrawHeight
    else
    begin
      FTabHeight := FMemBitmap.Canvas.TextHeight('T') + 4;
      if (FImages <> nil) and (FTabHeight < FImages.Height + 4) then
        FTabHeight := FImages.Height + 4;
    end;

    H := FTabHeight - 1;

    if FTabPosition in [tpBottom, tpTop] then
    begin
      ActualWidth := FEdgeWidth;
      ActualHeight := FTabHeight;
    end
    else
    begin
      { Switch the values }
      ActualWidth := FTabHeight;
      ActualHeight := FEdgeWidth;
    end;
    TempList := TImageList.CreateSize(ActualWidth, ActualHeight); {exceptions}
  except
    FTabHeight := SaveHeight;
    raise;
  end;
  FEdgeImageList.Free;
  FEdgeImageList := TempList;

  if not (FStyle in [tsModernTabs, tsModernPopout]) then
  begin
    { These parts aren't used in the "modern" painting look }
    Working := TBitmap.Create;
    try
      Working.Width := ActualWidth;
      Working.Height := ActualHeight;
      MaskColor := clOlive;

      if FTabPosition in [tpBottom, tpRight] then
      begin
        Y := 0;
        YMod := 1;
        YEnd := H;
      end
      else
      begin
        { Flip the Y positions }
        Y := H;
        YMod := -1;
        YEnd := 0;
      end;

      for EdgePart := Low(TEdgePart) to High(TEdgePart) do
      begin
        with Working.Canvas do
        begin
          Brush.Color := MaskColor;
          Brush.Style := bsSolid;
          FillRect(Rect(0, 0, ActualWidth, ActualHeight));
        end;
        case EdgePart of
          epSelectedLeft: DrawSL(Working.Canvas);
          epUnselectedLeft: DrawUL(Working.Canvas);
          epSelectedRight: DrawSR(Working.Canvas);
          epUnselectedRight: DrawUR(Working.Canvas);
        end;
        FEdgeImageList.AddMasked(Working, MaskColor);
      end;
    finally
      Working.Free;
    end;
  end;
end;

procedure TTabSet.PaintEdge(X, Y, H: Integer; Edge: TEdgeType);
var
  TempX: Integer;
begin
  if FTabPosition in [tpLeft, tpRight] then
  begin
    { Switch X and Y }
    TempX := X;
    X := Y;
    Y := TempX;
  end;

  case Edge of
    etFirstIsSel:
      FEdgeImageList.Draw(FMemBitmap.Canvas, X, Y, Ord(epSelectedLeft));
    etLastIsSel:
      FEdgeImageList.Draw(FMemBitmap.Canvas, X, Y, Ord(epSelectedRight));
    etFirstNotSel:
      FEdgeImageList.Draw(FMemBitmap.Canvas, X, Y, Ord(epUnselectedLeft));
    etLastNotSel:
      FEdgeImageList.Draw(FMemBitmap.Canvas, X, Y, Ord(epUnselectedRight));
    etNotSelToSel:
      begin
        FEdgeImageList.Draw(FMemBitmap.Canvas, X, Y, Ord(epUnselectedRight));
        FEdgeImageList.Draw(FMemBitmap.Canvas, X, Y, Ord(epSelectedLeft));
      end;
    etSelToNotSel:
      begin
        FEdgeImageList.Draw(FMemBitmap.Canvas, X, Y, Ord(epUnselectedLeft));
        FEdgeImageList.Draw(FMemBitmap.Canvas, X, Y, Ord(epSelectedRight));
      end;
    etNotSelToNotSel:
      begin
        FEdgeImageList.Draw(FMemBitmap.Canvas, X, Y, Ord(epUnselectedLeft));
        FEdgeImageList.Draw(FMemBitmap.Canvas, X, Y, Ord(epUnselectedRight));
      end;
  end;
end;

procedure TTabSet.CreateBrushPattern(Bitmap: TBitmap);
var
  X, Y: Integer;
begin
  Bitmap.Width := 8;
  Bitmap.Height := 8;
  with Bitmap.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := FBackgroundColor;
    FillRect(Rect(0, 0, Width, Height));
    if FDitherBackground then
      for Y := 0 to 7 do
        for X := 0 to 7 do
          if (Y mod 2) = (X mod 2) then  { toggles between even/odd pixles }
            Pixels[X, Y] := clWhite;     { on even/odd rows }
  end;
end;


function TTabSet.ScrollerSize: Integer;
begin
  if FTabPosition in [tpTop, tpBottom] then
    Result := Scroller.Width + 4
  else
    Result := Scroller.Height + 4;
end;

procedure TTabSet.FixTabPos;
var
  LastVisibleTab: Integer;

  function GetRightSide: Integer;
  begin
    if FTabPosition in [tpTop, tpBottom] then
      Result := Width - EndMargin
    else
      Result := Height - EndMargin;

    if AutoScroll and (FVisibleTabs < WideTabs.Count - 1) then
      Dec(Result, ScrollerSize);
  end;

  function ReverseCalcNumTabs(Start, Stop: Integer; Canvas: TCanvas;
    Last: Integer): Integer;
  var
    W: Integer;
  begin
    if HandleAllocated then
    begin
      Result := Last;
      while (Start >= Stop) and (Result >= 0) do
      begin
        with Canvas do
        begin
          W := ItemWidth(Result) + FEdgeWidth;
          Dec(Start, W);  { next usable position }
          if Start >= Stop then Dec(Result);
        end;
      end;
      if (Start < Stop) or (Result < 0) then
        Inc(Result);
    end
    else
      Result := FFirstIndex;
  end;

begin
  if (not FShrinkToFit) and (WideTabs.Count > 0) then
  begin
    if FVisibleTabs < WideTabs.Count then
      SetupTabPositions; { Insure FVisibleTabs is up to date }
    LastVisibleTab := FFirstIndex + FVisibleTabs - 1;
    if (LastVisibleTab > 0) and (FTabIndex >= LastVisibleTab) then
    begin
      FFirstIndex := ReverseCalcNumTabs(GetRightSide, StartMargin,
        Canvas, FTabIndex);
      LastVisibleTab := FFirstIndex + FVisibleTabs - 1;
      if FTabIndex > LastVisibleTab then
        Inc(FFirstIndex);
    end
    else if (FTabIndex >= 0) and (FTabIndex < FFirstIndex) then
      FFirstIndex := FTabIndex;
  end;
end;

procedure TTabSet.SetSelectedColor(Value: TColor);
begin
  if Value <> FSelectedColor then
  begin
    FSelectedColor := Value;
    CreateEdgeParts;
    Invalidate;
  end;
end;

procedure TTabSet.SetUnselectedColor(Value: TColor);
begin
  if Value <> FUnselectedColor then
  begin
    FUnselectedColor := Value;
    CreateEdgeParts;
    Invalidate;
  end;
end;

procedure TTabSet.SetBackgroundColor(Value: TColor);
begin
  if Value <> FBackgroundColor then
  begin
    FBackgroundColor := Value;
    CreateBrushPattern(FBrushBitmap);
    FMemBitmap.Canvas.Brush.Style := bsSolid;
    Invalidate;
  end;
end;

procedure TTabSet.SetDitherBackground(Value: Boolean);
begin
  if Value <> FDitherBackground then
  begin
    FDitherBackground := Value;
    CreateBrushPattern(FBrushBitmap);
    FMemBitmap.Canvas.Brush.Style := bsSolid;
    Invalidate;
  end;
end;

procedure TTabSet.SetAutoScroll(Value: Boolean);
begin
  if Value <> FAutoScroll then
  begin
    FAutoScroll := Value;
    Scroller.Visible := False;
    ShowWindow(Scroller.Handle, SW_HIDE);
    Invalidate;
  end;
end;

procedure TTabSet.SetStartMargin(Value: Integer);
begin
  if Value <> FStartMargin then
  begin
    FStartMargin := Value;
    Invalidate;
  end;
end;

procedure TTabSet.SetEndMargin(Value: Integer);
begin
  if Value <> FEndMargin then
  begin
    FEndMargin := Value;
    Invalidate;
  end;
end;

function TTabSet.CanChange(NewIndex: Integer): Boolean;
begin
  Result := True;
  if Assigned(FOnChange) then
    FOnChange(Self, NewIndex, Result);
end;

procedure TTabSet.SetTabIndex(Value: Integer);
var
  F: TCustomForm;
begin
  if Value <> FTabIndex then
  begin
    if (Value < -1) or (Value >= WideTabs.Count) then
       raise Exception.CreateRes(@SInvalidTabIndex);
    if CanChange(Value) then
    begin
      if Visible then
      begin
        F := GetParentForm(Self);
        if F <> nil then
          F.SendCancelMode(Self)
        else
          SendCancelMode(Self);
      end;
      FTabIndex := Value;
      if HandleAllocated then
        FixTabPos;
    //    Click;//AlekId
       Invalidate;
    end;
  end;
//AlekId
Click;
end;

procedure TTabSet.SelectNext(Direction: Boolean);
var
  NewIndex: Integer;
begin
  if WideTabs.Count > 1 then
  begin
    NewIndex := TabIndex;
    if Direction then
      Inc(NewIndex)
    else Dec(NewIndex);
    if NewIndex = WideTabs.Count then
      NewIndex := 0
    else if NewIndex < 0 then
      NewIndex := WideTabs.Count - 1;
    SetTabIndex(NewIndex);
  end;
end;

procedure TTabSet.SetFirstIndex(Value: Integer);
begin
  if (Value >= 0) and (Value < WideTabs.Count) then
  begin
    FFirstIndex := Value;
    Invalidate;
  end;
end;

procedure TTabSet.SetTabList(Value: TStrings);
begin
  FTabs.Assign(Value);
  FTabIndex := -1;
  if FWideTabs.Count > 0 then TabIndex := 0
  else Invalidate;
end;

procedure TTabSet.SetTabStyle(Value: TTabStyle);
begin
  if Value <> FStyle then
  begin
    FStyle := Value;
    if FStyle = tsSoftTabs then
      FSoftTop := True; { Force a soft top in this case }
    CreateEdgeParts;
    Invalidate;
  end;
end;

procedure TTabSet.SetWideTabList(Value: TWideStrings);
begin
  FWideTabs.Assign(Value);
  FTabIndex := -1;
  if FTabs.Count > 0 then TabIndex := 0
  else Invalidate;
end;


function TTabSet.TextWidth(canvas: TCanvas; wText: WideString): integer;
var sz:tagSize;
begin
sz.cX := 0;
sz.cY := 0;
Windows.GetTextExtentPoint32W(Canvas.Handle, PWideChar(Pointer(wText) ), Length(wText), sz);
result:=sz.cX;
end;

procedure TTabSet.SetTabHeight(Value: Integer);
var
  SaveHeight: Integer;
begin
  if Value <> FOwnerDrawHeight then
  begin
    SaveHeight := FOwnerDrawHeight;
    try
      FOwnerDrawHeight := Value;
      CreateEdgeParts;
      Invalidate;
    except
      FOwnerDrawHeight := SaveHeight;
      raise;
    end;
  end;
end;

procedure TTabSet.DrawTab(TabCanvas: TCanvas; R: TRect; Index: Integer;
  Selected: Boolean);
begin
  if Assigned(FOnDrawTab) then
    FOnDrawTab(Self, TabCanvas, R, Index, Selected);
end;

procedure TTabSet.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TTabSet.MeasureTab(Index: Integer; var TabWidth: Integer);
begin
  if Assigned(FOnMeasureTab) then
    FOnMeasureTab(Self, Index, TabWidth);
end;

procedure TTabSet.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  I: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    I := ItemAtPos(Point(X, Y));
    if I <> -1 then
      SetTabIndex(I);
  end;
end;

procedure TTabSet.WMSize(var Message: TWMSize);
var
  NumVisTabs, LastTabPos: Integer;

  function CalcNumTabs(Start, Stop: Integer; Canvas: TCanvas;
    First: Integer): Integer;
  begin
    Result := First;
    while (Start < Stop) and (Result < WideTabs.Count) do
      with Canvas do
      begin
        Inc(Start, ItemWidth(Result) + FEdgeWidth);    { next usable position }
        if Start <= Stop then
          Inc(Result);
      end;
  end;

begin
  inherited;
  if (not FShrinkToFit) and (WideTabs.Count > 1) then
  begin
    if FTabPosition in [tpTop, tpBottom] then
      LastTabPos := Width - EndMargin
    else
      LastTabPos := Height - EndMargin;

    NumVisTabs := CalcNumTabs(StartMargin + FEdgeWidth, LastTabPos, Canvas, 0);
    if (FTabIndex = WideTabs.Count) or (NumVisTabs > FVisibleTabs) or
       (NumVisTabs = WideTabs.Count) then
      FirstIndex := WideTabs.Count - NumVisTabs;
    FDoFix := True;
  end;
  Invalidate;
end;

procedure TTabSet.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  CreateEdgeParts;
  CreateBrushPattern(FBrushBitmap);
  FMemBitmap.Canvas.Brush.Style := bsSolid;
  { Windows follows this message with a WM_PAINT }
end;

procedure TTabSet.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Canvas.Font := Font;
  CreateEdgeParts;
  Invalidate;
end;

procedure TTabSet.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTALLKEYS;
end;

procedure TTabSet.CMDialogChar(var Message: TCMDialogChar);
var
  I: Integer;
begin
  for I := 0 to FTabs.Count - 1 do
  begin
    if IsAccel(Message.CharCode, FTabs[I]) then
    begin
      Message.Result := 1;
      if FTabIndex <> I then
        SetTabIndex(I);
      Exit;
    end;
  end;
  inherited;
end;

function TTabSet.MinClientRect: TRect;
begin
  Result := MinClientRect(WideTabs.Count, False);
end;

function TTabSet.MinClientRect(IncludeScroller: Boolean): TRect;
begin
  Result := MinClientRect(WideTabs.Count, IncludeScroller);
end;

function TTabSet.MinClientRect(TabCount: Integer; IncludeScroller: Boolean): TRect;
var
  I: Integer;
begin
  Result := Rect(0, 0, StartMargin, FTabHeight + 5);
  for I := 0 to TabCount - 1 do
    Inc(Result.Right, ItemWidth(I) + FEdgeWidth);
  Inc(Result.Right, EndMargin);
  if IncludeScroller then
    Inc(Result.Right, ScrollerSize);
  { If the orientation isn't top/bottom, switch the end points }
  if FTabPosition in [tpLeft, tpRight] then
  begin
    I := Result.Right;
    Result.Right := Result.Left;
    Result.Left := I;
  end;
end;

procedure TTabSet.SetFontOrientation(ACanvas: TCanvas);
begin
  if FTabPosition = tpRight then
    ACanvas.Font.Orientation := 2700 { 90 degrees to the right }
  else if FTabPosition = tpLeft then
    ACanvas.Font.Orientation := 900 { 90 degrees to the left }
  else
    ACanvas.Font.Orientation := 0; 
end;

function TTabSet.ItemWidth(Index: Integer): Integer;
var
  I: Integer;
begin
  with Canvas do
  begin
    SetFontOrientation(Canvas);
    Result := self.TextWidth(Canvas, WideTabs[Index])+1;
    if (FImages <> nil) then
    begin
      I := GetImageIndex(Index);
      if (I > -1) and (I < FImages.Count) then
        Result := Result + FImages.Width + 1;
    end;
  end;
  if (FStyle = tsOwnerDraw) then
    MeasureTab(Index, Result);
end;

procedure TTabSet.SetSoftTop(const Value: Boolean);
begin
  if Value <> SoftTop then
  begin
    FSoftTop := Value;
    CreateEdgeParts;
    Invalidate;
  end;
end;

procedure TTabSet.SetImages(const Value: TCustomImageList);
begin
  if Images <> Value then
  begin
    if Images <> nil then
      Images.UnRegisterChanges(FImageChangeLink);
    FImages := Value;
    if Images <> nil then
    begin
      Images.RegisterChanges(FImageChangeLink);
      Images.FreeNotification(Self);
    end;
    CreateEdgeParts; { Height is changed if Value <> nil }
    Invalidate;
  end;
end;

procedure TTabSet.ImageListChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TTabSet.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Images) then
    Images := nil;
end;

function TTabSet.GetImageIndex(TabIndex: Integer): Integer;
begin
  Result := TabIndex;
  if Assigned(FOnGetImageIndex) then
    FOnGetImageIndex(Self, TabIndex, Result);
end;

procedure TTabSet.SetShrinkToFit(const Value: Boolean);
begin
  if FShrinkToFit <> Value then
  begin
    FShrinkToFit := Value;
    Invalidate;
  end;
end;

procedure TTabSet.CMHintShow(var Message: TCMHintShow);
var
  R, Calced: TRect;
  I: Integer;
  S: string;
begin
  Message.Result := 0; { Don't show the hint }
  if FShrinkToFit and (Message.HintInfo.HintControl = Self) then begin
    with Message.HintInfo^ do
    begin
      I := ItemAtPos(CursorPos);
      if I <> -1 then
      begin
        { See if it has truncated text }
        R := ItemRect(I);
        if (FImages <> nil) and (GetImageIndex(I) <> -1) then
          Inc(R.Left, FImages.Width + 2);
        Calced := R;
        S := FWideTabs[I];
        Canvas.TextRect(Calced, S, [tfCalcRect]);
        if R.Right < Calced.Right then
        begin
          Message.Result := 0; { Show the hint }
          Message.HintInfo.CursorRect := R;
          HintStr := FWideTabs[I];
        end;
      end;
    end;
    end else begin
      ProcessCMHintShowMsg(TMessage(Message) );
    end;
end;

procedure TTabSet.SetTabPosition(const Value: TTabPosition);
begin
  if FTabPosition <> Value then
  begin
    FTabPosition := Value;
    SetFontOrientation(Canvas);
    SetFontOrientation(FMemBitmap.Canvas);
    if FTabPosition in [tpTop, tpBottom] then
      Scroller.ScrollOrientation := soLeftRight
    else
      Scroller.ScrollOrientation := soUpDown;
    CreateEdgeParts; { Updates the parts with the new look }
    Invalidate;
  end;
end;

procedure TTabSet.DoModernPainting;
var
  YStart: Integer;
  TabPos: TTabPos;
  Tab: Integer;
  isSelected, isNextSelected: Boolean;
  R: TRect;
  MinRect: Integer;
  S: string;
  ImageIndex: Integer;
  TabTop: Integer;
  TotalSize: Integer;
  BitmapRect: TRect;
  TabOffset: Integer;
  DrawImage: Boolean;
  BGColor: TColor;
begin
  { Calculate our true drawing positions }
  if FTabPosition in [tpBottom, tpRight] then
  begin
    TabTop := 2;
    YStart := 1;
  end
  else if FTabPosition = tpTop then
  begin
    TabTop := ClientHeight - FTabHeight - 2;
    YStart := ClientHeight - 2;
  end
  else { tpLeft }
  begin
    TabTop := ClientWidth - FTabHeight - 2;
    YStart := ClientWidth - 2;
  end;

  if FTabPosition in [tpTop, tpBottom] then
    TotalSize := FMemBitmap.Width
  else
    TotalSize := FMemBitmap.Height;

  { draw background of tab area }
  with FMemBitmap.Canvas do
  begin
    { Fill in with the background color }
    BGColor := GetHighlightColor(FBackgroundColor);
    Brush.Color := BGColor;
    Pen.Width := 1;
    Pen.Color := BackgroundColor;
    BitmapRect := Rect(0, 0, FMemBitmap.Width, FMemBitmap.Height);
    Rectangle(BitmapRect);
    { First, draw two lines that are the background color }
    DrawLine(FMemBitmap.Canvas, 0, YStart, TotalSize, YStart);
    if FTabPosition in [tpBottom, tpRight] then
      Inc(YStart)
    else
      Dec(YStart);
    { draw the top edge }
    {
      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      | |           |            |             |
      | |           |            |             |
      | |___________|            |             |
      |__________________________________________________
    }
    Pen.Color := clWindowFrame;
    DrawLine(FMemBitmap.Canvas, 0, YStart, TotalSize, YStart);

    MinRect := TextWidth('X...'); { Do not localize }
  end;

  TabOffset := FEdgeWidth div 2;

  for Tab := 0 to FTabPositions.Count - 1 do
  begin
    Pointer(TabPos) := FTabPositions[Tab];

    isSelected := Tab + FirstIndex = TabIndex;
    isNextSelected := (Tab + FirstIndex) + 1 = TabIndex;

    if isSelected then
    begin
      { Draw the first leading edge darkened. }
      FMemBitmap.Canvas.Pen.Color := clWindowFrame;
      DrawLine(FMemBitmap.Canvas,
        TabPos.StartPos - TabOffset + 1, TabTop,
        TabPos.StartPos - TabOffset + 1, TabTop + FTabHeight);
      FMemBitmap.Canvas.Pen.Color := GetHighlightColor(SelectedColor);
      { Draw the next leading edge as highlighted. }
      DrawLine(FMemBitmap.Canvas,
        TabPos.StartPos - TabOffset + 2, TabTop,
        TabPos.StartPos - TabOffset + 2, TabTop + FTabHeight);

      FMemBitmap.Canvas.Pen.Color := clWindowFrame;
      { Draw the bottom edge. }
      if FTabPosition in [tpBottom, tpRight] then
        DrawLine(FMemBitmap.Canvas,
          TabPos.StartPos + 1 - TabOffset, TabTop + FTabHeight - 1,
          TabPos.StartPos + TabPos.Size + 1 + TabOffset,
          TabTop + FTabHeight - 1)
      else
        DrawLine(FMemBitmap.Canvas, { Really the top edge, in this case }
          TabPos.StartPos + 1 - TabOffset + 1, TabTop,
          TabPos.StartPos + TabPos.Size + 1 + TabOffset, TabTop);

      { Draw the right edge }
      DrawLine(FMemBitmap.Canvas,
        TabPos.StartPos + TabPos.Size + TabOffset, TabTop,
        TabPos.StartPos + TabPos.Size + TabOffset,
        TabTop + FTabHeight - 1);
      { Fill in the inside up with the button face }
      FMemBitmap.Canvas.Brush.Color := SelectedColor;

      if FTabPosition in [tpTop, tpBottom] then
        R := Rect(TabPos.StartPos + 2 - TabOffset, TabTop,
          TabPos.StartPos + TabPos.Size + TabOffset, TabTop + FTabHeight - 1)
      else
        R := Rect(TabTop, TabPos.StartPos + 2 - TabOffset,
          TabTop + FTabHeight - 1, TabPos.StartPos + TabPos.Size + TabOffset);

      if FTabPosition = tpTop then
      begin
       { Move the rect down and to the right a little }
        Inc(R.Left);
        Inc(R.Top);
        Inc(R.Bottom);
      end
      else if FTabPosition = tpLeft then
      begin
        Inc(R.Left);
        Inc(R.Top);
        Inc(R.Right);
      end
      else if FTabPosition = tpRight then
        Inc(R.Top)
      else
        Inc(R.Left);
      FMemBitmap.Canvas.FillRect(R);
    end
    else if not isNextSelected then
    begin
      { Draw a little vertical line at the end to seperate the tabs }
      FMemBitmap.Canvas.Pen.Color := clBtnShadow;
      DrawLine(FMemBitmap.Canvas,
        TabPos.StartPos + TabPos.Size + TabOffset, TabTop + 3,
        TabPos.StartPos + TabPos.Size + TabOffset,
        TabTop + FTabHeight - 1 - 2);
    end;

    { set up the canvas }
    if FTabPosition in [tpTop, tpBottom] then
      R := Rect(TabPos.StartPos, TabTop, TabPos.StartPos + TabPos.Size,
        TabTop + FTabHeight)
    else { Switch X and Y  }
      R := Rect(TabTop, TabPos.StartPos, TabTop + FTabHeight,
        TabPos.StartPos + TabPos.Size);

    with FMemBitmap.Canvas do
    begin
      Brush.Style := bsClear; { For painting text }
      if FTabPosition in [tpTop, tpBottom] then
      begin
        Inc(R.Top, 2);
        Inc(R.Left, 1);
        Inc(R.Right, 1);
      end
      else
      begin
        { Flip the width and height of the rect so we
          get correct clipping of the text when writing at a non-0
          orientation }
        if FTabPosition = tpRight then
          Inc(R.Left, 1 + TextHeight('X')) { Do not localize }
        else
        begin
          Inc(R.Left, 2);
          R.Top := R.Top + TabPos.Size; { Vertical text consideration }
        end;
        R.Right := R.Left + TabPos.Size + 2;
        R.Bottom := R.Top + FTabHeight;
      end;
      { Draw the image first }
      if (FImages <> nil) then
      begin
        ImageIndex := GetImageIndex(Tab + FirstIndex);
        DrawImage := (ImageIndex > -1) and (ImageIndex < FImages.Count);
        if FTabPosition in [tpTop, tpBottom] then
        begin
          if DrawImage and (R.Left + 2 + FImages.Width < R.Right) then
          begin
            FImages.Draw(FMemBitmap.Canvas, R.Left, R.Top, ImageIndex);
            Inc(R.Left, 2 + FImages.Width);
          end;
          Inc(R.Top, 2);
        end
        else if FTabPosition = tpRight then
        begin
          if DrawImage then
          begin
            FImages.Draw(FMemBitmap.Canvas, R.Left - TextHeight('X') + 2,
              R.Top, ImageIndex);
            Inc(R.Top, 2 + FImages.Height);
            Dec(R.Right, FImages.Height); { For proper clipping }
          end;
          Inc(R.Left, 2);
        end
        else
        begin
          if DrawImage then
          begin
            FImages.Draw(FMemBitmap.Canvas, R.Left, R.Top - FImages.Height,
              ImageIndex);
            Dec(R.Top, 2 + FImages.Height);
            Dec(R.Right, FImages.Height); { For proper clipping }
          end;
          Inc(R.Left, 2);
        end;
      end;
      S := Tabs[Tab + FirstIndex];
      if (R.Right - R.Left >= MinRect) or
          (TextWidth(S) <= (R.Right - R.Left)) then
        TextRect(R, S, [tfEndEllipsis, tfNoClip]);
    end;
  end;
end;

procedure TTabSet.DoPopoutModernPainting;
var
  TabPos: TTabPos;
  Tab: Integer;
  isSelected: Boolean;
  MinRect: Integer;
  S: string;
  ImageIndex: Integer;
  TabTop: Integer;
  BitmapRect: TRect;
  TabOffset: Integer;
  DrawImage: Boolean;
  TabRect: TRect;
  ImageY: Integer;
begin
  { Calculate our true drawing positions }
  if FTabPosition in [tpBottom, tpRight] then
  begin
    TabTop := 0;
  end
  else if FTabPosition = tpTop then
  begin
    TabTop := ClientHeight - FTabHeight;
  end
  else { tpLeft }
  begin
    TabTop := ClientWidth - FTabHeight;
  end;

  { Fill in with the background color }
  FMemBitmap.Canvas.Brush.Color := GetHighlightColor(FBackgroundColor);
  BitmapRect := Rect(0, 0, FMemBitmap.Width, FMemBitmap.Height);
  FMemBitmap.Canvas.FillRect(BitmapRect);
  MinRect := FMemBitmap.Canvas.TextWidth('X...'); { Do not localize }

  TabOffset := FEdgeWidth div 2;

  FMemBitmap.Canvas.Pen.Width := 1;
  for Tab := 0 to FTabPositions.Count - 1 do
  begin
    Pointer(TabPos) := FTabPositions[Tab];

    isSelected := Tab + FirstIndex = TabIndex;

    if FTabPosition in [tpTop, tpBottom] then
      TabRect := Rect(TabPos.StartPos - TabOffset, TabTop,
        TabPos.StartPos + TabPos.Size + 2 + TabOffset,
        TabTop + FTabHeight)
    else { Switch the values }
      TabRect := Rect(TabTop, TabPos.StartPos - TabOffset,
        TabTop + FTabHeight, TabPos.StartPos + TabPos.Size + 2 + TabOffset);

    if isSelected then
    begin
      { Make it stand out by being a little higher }
      case TabPosition of
        tpTop: Dec(TabRect.Top);
        tpLeft: Dec(TabRect.Left);
        tpBottom: Inc(TabRect.Bottom);
        tpRight: Inc(TabRect.Right);
      end;
    end;

    with FMemBitmap.Canvas do
    begin
      Pen.Color := clBtnShadow;
      Pen.Width := 1;
      if isSelected then
        Brush.Color := FSelectedColor
      else
        Brush.Color := FUnselectedColor;
      Rectangle(TabRect);
      Brush.Style := bsClear; { For painting text }

      { Pop out a little }
      if isSelected then
        if TabPosition = tpRight then
          Inc(TabRect.Left)
        else if TabPosition = tpBottom then
          Inc(TabRect.Top);

      if FTabPosition in [tpTop, tpBottom] then
      begin
        Inc(TabRect.Top, 1);
        Inc(TabRect.Left, 3); { Buffer for text/images }
      end
      else
      begin
        Inc(TabRect.Top, 2); { Buffer for text/images }
        { Flip the width and height of the rect so we
          get correct clipping of the text when writing at a non-0
          orientation }
        if FTabPosition = tpRight then
          Inc(TabRect.Left, 1 + TextHeight('X')) { Do not localize }
        else
        begin
          Inc(TabRect.Left, 2);
          TabRect.Top := TabRect.Top + TabPos.Size + TabOffset; { Vertical text consideration }
        end;
        TabRect.Right := TabRect.Left + TabPos.Size + TabOffset;
        TabRect.Bottom := TabRect.Top + FTabHeight;
      end;
      { Draw the image first }
      if (FImages <> nil) then
      begin
        ImageIndex := GetImageIndex(Tab + FirstIndex);
        DrawImage := (ImageIndex > -1) and (ImageIndex < FImages.Count);
        if FTabPosition in [tpTop, tpBottom] then
        begin
          if DrawImage then
          begin
            FImages.Draw(FMemBitmap.Canvas, TabRect.Left, TabRect.Top + 1, ImageIndex);
            Inc(TabRect.Left, 2 + FImages.Width);
          end;
          Inc(TabRect.Top, 2);
        end
        else if FTabPosition = tpRight then
        begin
          if DrawImage then
          begin
            FImages.Draw(FMemBitmap.Canvas, TabRect.Left - TextHeight('X') + 2,
              TabRect.Top, ImageIndex);
            Inc(TabRect.Top, 2 + FImages.Height);
            Dec(TabRect.Right, FImages.Height); { For proper clipping }
          end;
          Inc(TabRect.Left, 2);
        end
        else { tpLeft }
        begin
          ImageY := TabRect.Top - FImages.Height;
          { Make sure it doesn't go up too far }
          if DrawImage and (ImageY >= (TabRect.Top - TabPos.Size - TabOffset)) then
          begin
            FImages.Draw(FMemBitmap.Canvas, TabRect.Left, ImageY, ImageIndex);
            Dec(TabRect.Top, 2 + FImages.Height);
            Dec(TabRect.Right, FImages.Height); { For proper clipping }
          end;
          Inc(TabRect.Left, 2);
        end;
      end;
      S := Tabs[Tab + FirstIndex];
      if (TabRect.Right - TabRect.Left >= MinRect) or
          (TextWidth(S) <= (TabRect.Right - TabRect.Left)) then
        TextRect(TabRect, S, [tfEndEllipsis, tfNoClip]);
    end;
  end;
end;

procedure TTabSet.SetupTabPositions;
var
  TabStart, LastTabPos: Integer;
  EndPixels: Integer;
  WholeVisibleTabs: Integer;
begin
  if not HandleAllocated then
    Exit;
  { Set the size of the off-screen bitmap.  Make sure that it is tall enough to
    display the entire tab, even if the screen won't display it all.  This is
    required to avoid problems with using FloodFill. }
  if FTabPosition in [tpTop, tpBottom] then
  begin
    FMemBitmap.Width := ClientWidth;
    if ClientHeight < FTabHeight + 5 then
      FMemBitmap.Height := FTabHeight + 5
    else
      FMemBitmap.Height := ClientHeight;
    EndPixels := Width;
    Scroller.Left := EndPixels - Scroller.Width - 2;
    Scroller.Top := 3;
  end
  else
  begin
    { Sideways }
    FMemBitmap.Height := ClientHeight;
    if ClientWidth < FTabHeight + 5 then
      FMemBitmap.Width := FTabHeight + 5
    else
      FMemBitmap.Width := ClientWidth;
    EndPixels := Height;
    Scroller.Top := EndPixels - Scroller.Height - 2;
    if FTabPosition = tpRight then
      Scroller.Left := 3
    else
      Scroller.Left := Width - Scroller.Width - 2;
  end;

  SetFontOrientation(Canvas);
  FMemBitmap.Canvas.Font := Canvas.Font;

  TabStart := StartMargin + FEdgeWidth; { where does first text appear? }
  LastTabPos := EndPixels - EndMargin;  { tabs draw until this position }

  { do initial calculations for how many tabs are visible }
  FVisibleTabs := CalcTabPositions(TabStart, LastTabPos, FMemBitmap.Canvas,
    FirstIndex, True);

  { enable the scroller if FAutoScroll = True and not all tabs are visible }
  if ScrollerShown then
  begin
    Dec(LastTabPos, ScrollerSize);
    { recalc the tab positions }
    WholeVisibleTabs := FVisibleTabs;
    FVisibleTabs := CalcTabPositions(TabStart, LastTabPos, FMemBitmap.Canvas,
      FirstIndex, False);
    { set the scroller's range }
    Scroller.Visible := True;
    Scroller.Min := 0;
    Scroller.Max := WideTabs.Count - WholeVisibleTabs;
    Scroller.Position := FirstIndex;
  end
  else if VisibleTabs >= WideTabs.Count then
    Scroller.Visible := False;

  if FDoFix then
  begin
    FDoFix := False;
    FixTabPos;
    FVisibleTabs := CalcTabPositions(TabStart, LastTabPos, FMemBitmap.Canvas,
      FirstIndex, not Scroller.Visible);
  end;
end;

function TTabSet.ScrollerShown: Boolean;
begin
  Result := AutoScroll and (FVisibleTabs < WideTabs.Count);
end;

procedure TTabSet.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  if ThemeServices.ThemesEnabled then
    inherited
  else
    Message.Result := 0;
end;

{ TUnicodeTabList }

function TUnicodeTabList.Add(const ws: WideString): Integer;
begin
  Result := inherited Add(ws);
  SetLength(tbStyles,Count);
  if FTabSet <> nil then
  FTabSet.Invalidate;
end;

procedure TUnicodeTabList.Clear;
begin
  inherited Clear;
  FTabSet.FTabIndex := -1;
  FTabSet.Invalidate;
end;

constructor TUnicodeTabList.Create(const ATabSet: TTabSet);
begin
  inherited Create();
  FTabSet := ATabSet;
end;

procedure TUnicodeTabList.Delete(Index: Integer);
var
  OldIndex: Integer;
  LastVisibleTab: Integer;
begin
  OldIndex := FTabSet.Tabindex;
  inherited Delete(Index);

  if OldIndex < Count then
    FTabSet.FTabIndex := OldIndex
  else
    FTabSet.FTabIndex := Count - 1;

  if FTabSet.HandleAllocated then
  begin
    { See if we can fit more tabs onto the screen now }
    if (not FTabSet.FShrinkToFit) and (Count > 0) then
    begin
      if FTabSet.FVisibleTabs < Count then
        FTabSet.SetupTabPositions; { Insure FVisibleTabs is up to date }
      LastVisibleTab := FTabSet.FFirstIndex + FTabSet.FVisibleTabs - 1;
      if (LastVisibleTab = Count - 1) and (FTabSet.FFirstIndex > 0) then
        FTabSet.FFirstIndex := FTabSet.FFirstIndex - 1; { We could probably fit one more on screen }
      FTabSet.FixTabPos;
    end;
  end;

  FTabSet.SetupTabPositions;
  FTabSet.Invalidate;
  if OldIndex = Index then
    FTabSet.Click;  { We deleted the selected tab }
end;

procedure TUnicodeTabList.Insert(Index: Integer; const ws: WideString);
begin
  inherited Insert(Index, ws);
  SetLength(tbStyles,Count);
  tbStyles[index]:=0;
  if FTabSet <> nil then
  begin
    if Index <= FTabSet.FTabIndex then Inc(FTabSet.FTabIndex);

    FTabSet.Invalidate;
  end;
  end;

procedure TUnicodeTabList.Put(Index: Integer; const ws: WideString);
begin
  inherited Put(Index, ws);
  SetLength(tbStyles,Count);
  if FTabSet <> nil then
    FTabSet.Invalidate;

end;

end.

