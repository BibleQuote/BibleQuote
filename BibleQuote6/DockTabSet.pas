{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{  Copyright (c) 2002-2004 Borland Software Corporation }
{                                                       }
{*******************************************************}

unit DockTabSet;

interface

uses
  Windows, SysUtils, Classes, Controls, Tabs, Messages, Types, ExtCtrls, Contnrs,
  CaptionedDockTree, Graphics;

type
  TDockTabSet = class;
  TDockClientInfo = class;

  TTabDockPanel = class(TPanel)
  private
    FAutoHideTimer: TTimer;
    FSplitterWidth: Integer;
    FDockClientInfo: TDockClientInfo;
    FDockCaption: TPaintBox;
    FDockCaptionPanel: TPanel;
    FDownPos: TPoint;
    FFirstErase: Boolean;
    FGrabberSize: Integer;
    FInAnimation: Boolean;
    FSplitterPanel: TPanel;
    FStartingBounds: TRect;
    FDockCaptionDrawer: TDockCaptionDrawer;
    FMouseDownTime: Cardinal;
    FAnimateSpeed: Integer;
    FBitmapPrintChache: TBitmap;
    FIsNotXP: Boolean;
    function GetCaptionRect: TRect;
    procedure AutoHideTimerExec(Sender: TObject);
    procedure PaintDockCaption(Sender: TObject);
    procedure SplitterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SplitterMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DockCaptionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DockCaptionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DockCaptionMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  protected
    function ShouldAutoHide: Boolean;

    procedure BeginAnimation;
    procedure EndAnimation;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMNCPaint(var Message: TWMNCPaint); message WM_NCPAINT;
    procedure WMPrint(var Message: TWMPrint); message WM_PRINT;
    procedure WMPrintClient(var Message: TWMPrintClient); message WM_PRINTCLIENT;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;

    property SplitterWidth: Integer read FSplitterWidth write FSplitterWidth;
    property DockClientInfo: TDockClientInfo read FDockClientInfo;
    property SplitterPanel: TPanel read FSplitterPanel;
  public
    constructor Create(AOwner: TComponent; DockClientInfo: TDockClientInfo); reintroduce;
    destructor Destroy; override;
    procedure UpdateDockCaptionPin;
    property AnimateSpeed: Integer read FAnimateSpeed write FAnimateSpeed;
  end;

  TDockClientInfo = class(TComponent)
  private
    FDockTabSet: TDockTabSet;
    FDockClient: TWinControl;
    FTabIndex: Integer;
    FListIndex: Integer;
    FParentPanel: TTabDockPanel;
    FImageIndex: Integer;
    procedure SetTabIndex(const Value: Integer);
    procedure AddIconToImageList;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(const ADockTabSet: TDockTabSet; const ADockClient: TWinControl); reintroduce;
    destructor Destroy; override;
    procedure CreateTab(AlwaysCreate: Boolean = False);
    property DockClient: TWinControl read FDockClient;
    property DockTabSet: TDockTabSet read FDockTabSet;
    property ImageIndex: Integer read FImageIndex write FImageIndex;
    property ListIndex: Integer read FListIndex;
    property ParentPanel: TTabDockPanel read FParentPanel;
    property TabIndex: Integer read FTabIndex write SetTabIndex;
  end;

  TDockTabSet = class(TTabSet)
  private
    FAutoSelect: Boolean;
    FDockClients: TObjectList;
    FCurrentClient: TDockClientInfo;
    FDestDockSite: TWinControl;
    FInternalImages: TImageList;
    FOnTabAdded: TNotifyEvent;
    FOnTabRemoved: TNotifyEvent;
    FShouldFocus: Boolean;
    FAutoPopTimer: TTimer;
    FAutoPopIndex: Integer;
    procedure AutoPopTimerExec(Sender: TObject);
    function CalcDockSize(const Client: TControl): TRect;
    procedure CMDockClient(var Message: TCMDockClient); message CM_DOCKCLIENT;
    procedure CMDockNotification(var Message: TCMDockNotification); message CM_DOCKNOTIFICATION;
    procedure CMUnDockClient(var Message: TCMUnDockClient); message CM_UNDOCKCLIENT;
    procedure InvalidateDockSite(const Client: TControl; const FocusLost: Boolean);
    procedure SetDestDockSite(const Value: TWinControl);
  protected
    procedure DoAddDockClient(Client: TControl; const ARect: TRect); override;
    procedure DockOver(Source: TDragDockObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean); override;
    function DockReplaceDockClient(Client: TControl;
      NewDockSite: TWinControl; DropControl: TControl;
      ControlSide: TAlign; ReplacementClient: TControl): Boolean; override;
    procedure DoRemoveDockClient(Client: TControl); override;
    function FindDockClientInfo(const Client: TControl): TDockClientInfo;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetTabIndex(Value: Integer); override;
    procedure ShowDockClientInfo(const DockClientInfo: TDockClientInfo); virtual;
    function GetImageIndex(TabIndex: Integer): Integer; override;
    function GetTabName(const Client: TControl): string; virtual;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    function ShouldAutoHide(const Client: TWinControl): Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowDockClient(const Client: TControl);
    function IndexOfDockClient(const Client: TControl): Integer;
    procedure HideCurrentDockClient(const AnimateSpeed: Integer = 200);
  protected
    property Images; { Hide the Images property }
    property OnGetImageIndex; { Hide the OnGetImageIndex event }
  published
    property AutoSelect: Boolean read FAutoSelect write FAutoSelect default False;
    property DockSite default True;
    property DestinationDockSite: TWinControl read FDestDockSite write SetDestDockSite;
    property OnDockDrop;
    property OnDockOver;
    property OnGetSiteInfo;
    property OnStartDock;
    property OnUnDock;
    { OnTabAdded: occurs when a tab is added because a control was docked,
      or was made visible }
    property OnTabAdded: TNotifyEvent read FOnTabAdded write FOnTabAdded;
    { OnTabRemoved: occurs when a tab is removed, or when it is hidden }
    property OnTabRemoved: TNotifyEvent read FOnTabRemoved write FOnTabRemoved;
  end;

  { We need a dock tree which allows the user to redock items from
    on area to another. If you want your dock tree to support this,
    simply implement the interface, and the TDockTabSet will
    set the AlternateDockHost for you. You can then do some hit testing
    in your dock tree, and "undock" to the AlternateDockHost when
    someone hits a "pin" button (or similiar) }
  IAlternateDockHost = interface(IInterface)
    ['{808A554D-6502-4D77-B6F7-C0749434D9B7}']
    procedure SetAlternateDockHost(const DockHost: TWinControl);
  end;

  TCaptionedTabDockTree = class(TCaptionedDockTree, IAlternateDockHost)
  private
    FAlternateDockHost: TWinControl;
    function PinHitTest(const MousePos: TPoint): TDockZone;
  protected
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer; var Handled: Boolean); override;
  public
    procedure SetAlternateDockHost(const DockHost: TWinControl);
  end;

  ETabDockException = class(Exception);

implementation

uses Forms, GraphUtil, Themes;

var
  LastDockTabSet: TDockTabSet;

{ TDockTabSet }

function TDockTabSet.CalcDockSize(const Client: TControl): TRect;
begin
  Result := Rect(0, 0, Width, Height);
  with Result do
    case Align of
      alLeft:
      begin
        Left := Right;
        Right := Left + Client.LRDockWidth;
      end;
      alRight:
      begin
        Right := Left - 1; 
        Left := Right - Client.LRDockWidth;
      end;
      alTop:
      begin
        Top := Bottom + 1;
        Bottom := Top + Client.TBDockHeight;
      end;
      alBottom:
      begin
        Bottom := Top;
        Top := Bottom - Client.TBDockHeight;
      end;
    end;
end;

procedure TDockTabSet.CMDockClient(var Message: TCMDockClient);
var
  DockClient: TControl;
  I: Integer;
  DockInfo: TDockClientInfo;
begin
  Message.Result := 0;
  DockClient := Message.DockSource.Control;
  { First, look and see if the page is already docked.  }
  for I := 0 to FDockClients.Count - 1 do
  begin
    DockInfo := TDockClientInfo(FDockClients[I]);
    if DockInfo.DockClient = DockClient then
    begin
      { If the parent isn't the panel, something went wrong, so
        free this DockInfo and redock it }
      if DockClient.Parent <> DockInfo.ParentPanel then
      begin
        FDockClients.Delete(I); 
        Break; { Do the default docking } 
      end
      else if DockInfo.TabIndex <> Tabs.Count - 1 then
      begin
        { Move it to the end }
        DockInfo.TabIndex := -1;
        DockInfo.CreateTab;
        TabIndex := DockInfo.TabIndex;
        Exit; { Moved to the end } 
      end
      else
        Exit; { Already at the end }
    end;
  end;
  DockClient.Dock(Self, Message.DockSource.DockRect);
end;

procedure TDockTabSet.CMDockNotification(var Message: TCMDockNotification);
var
  DockClientInfo: TDockClientInfo;
  NewVisible: Boolean;
begin
  DockClientInfo := FindDockClientInfo(Message.Client);
  if DockClientInfo <> nil then
    case Message.NotifyRec.ClientMsg of
      WM_SETTEXT:
      begin
        if DockClientInfo.TabIndex <>  -1 then
          Tabs[DockClientInfo.TabIndex] := GetTabName(DockClientInfo.DockClient);
      end;
      CM_VISIBLECHANGED:
      begin
        NewVisible := Boolean(Message.NotifyRec.MsgWParam);
        if NewVisible then
        begin
          DockClientInfo.CreateTab; { Make sure the tab exists }
          TabIndex := DockClientInfo.TabIndex;
        end
        else
        begin
          if TabIndex = DockClientInfo.TabIndex then
            TabIndex := -1;
          DockClientInfo.ParentPanel.Visible := False; 
        end;
        if NewVisible then
          ShowDockClientInfo(DockClientInfo);
      end;
      CM_INVALIDATEDOCKHOST:
      begin
        with Message do
          InvalidateDockSite(Client, Boolean(NotifyRec.MsgLParam));
      end;
    end;
  inherited;
end;


constructor TDockTabSet.Create(AOwner: TComponent);
begin
  inherited;
  FShouldFocus := True;
  FDockClients := TObjectList.Create;
  DockSite := True;
  FInternalImages := TImageList.Create(nil);
  Images := FInternalImages;
  FAutoPopTimer := TTimer.Create(nil);
  FAutoPopTimer.Enabled := False;
  FAutoPopTimer.Interval := 500;
  FAutoPopTimer.OnTimer := AutoPopTimerExec;
  FAutoPopIndex := -1;
end;

destructor TDockTabSet.Destroy;
begin
  DestinationDockSite := nil; { Remove free notification }
  FDockClients.Free;
  Images := nil;
  FInternalImages.Free;
  if LastDockTabSet = Self then
    LastDockTabSet := nil;
  FAutoPopTimer.Free;
  inherited;
end;

resourcestring
  sOnlyWinControls = 'You can only tab dock TWinControl based Controls';

procedure TDockTabSet.DoAddDockClient(Client: TControl;
  const ARect: TRect);
var
  DockClientInfo: TDockClientInfo;
begin
  if Client is TWinControl then
  begin
    DockClientInfo := TDockClientInfo.Create(Self, TWinControl(Client));
    FDockClients.Add(DockClientInfo);
  end
  else
    raise ETabDockException.Create(sOnlyWinControls);
end;

procedure TDockTabSet.DockOver(Source: TDragDockObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  MaxWidth, MaxHeight: Integer;
  R: TRect;
begin
  inherited DockOver(Source, X, Y, State, Accept);
  if Accept then
  begin
    { Modify the dock rect and position to indicate where the
      control will appear at }
    R := CalcDockSize(Source.Control);
    with R do
      case Align of
        alLeft:
        begin
          if Parent <> nil then
          begin
            MaxWidth := Parent.ClientWidth - (Self.Left + Self.Width);
            if Right - Left > MaxWidth then
              Right := Left + MaxWidth;
          end;
        end;
        alRight:
        begin
          if Parent <> nil then
          begin
            MaxWidth := Self.Left;
            if Right - Left > MaxWidth then
              Left := Right - MaxWidth;
          end;
        end;
        alTop:
        begin
          if Parent <> nil then
          begin
            MaxHeight := Parent.ClientHeight - Self.Top + Self.Height;
            if Bottom - Top > MaxHeight then
              Bottom := Top + MaxHeight;
          end;
        end;
        alBottom:
        begin
          if Parent <> nil then
          begin
            MaxHeight := Self.Top;
            if Bottom - Top > MaxHeight then
              Top := Bottom - MaxHeight;
          end;
        end;
      end;
    MapWindowPoints(Handle, 0, R.TopLeft, 2);
    Source.DockRect := R;
  end;
end;

procedure TDockTabSet.DoRemoveDockClient(Client: TControl);
var
  I: Integer;
  DockInfo: TDockClientInfo;
begin
  if not (csDestroying in ComponentState) then
  begin
    for I := 0 to FDockClients.Count - 1 do
    begin
      DockInfo := TDockClientInfo(FDockClients[I]);
      if DockInfo.DockClient = Client then
      begin
//        DockInfo.ParentPanel.Visible := False; { Hide the panel }
        DockInfo.ParentPanel.FAutoHideTimer.Enabled := False;  { Kill the timer }
        FDockClients.Delete(I);
        Break;
      end;
    end;
  end;
end;

function TDockTabSet.FindDockClientInfo(
  const Client: TControl): TDockClientInfo;
var
  I: Integer;
begin
  for I := 0 to FDockClients.Count - 1 do
    if TDockClientInfo(FDockClients[I]).DockClient = Client then
    begin
      Result := TDockClientInfo(FDockClients[I]);
      Exit;
    end;
  Result := nil;
end;

procedure TDockTabSet.SetTabIndex(Value: Integer);
var
  I: Integer;
begin
  inherited SetTabIndex(Value);
  if Value = -1 then
    ShowDockClientInfo(nil)
  else
  begin
    for I := 0 to FDockClients.Count - 1 do
    begin
      if TDockClientInfo(FDockClients[I]).TabIndex = Value then
      begin
        ShowDockClientInfo(TDockClientInfo(FDockClients[I]));
        Break;
      end;
    end;
  end;
end;

procedure TDockTabSet.ShowDockClientInfo(const DockClientInfo: TDockClientInfo);
var
  R: TRect;
  MaxWidth, MaxHeight: Integer;
  SaveLRWidth, SaveTBHeight: Integer;
begin
  { Show the info if it is new, or if it isn't new, but isn't visible }
  if (FCurrentClient <> DockClientInfo) or
    ((FCurrentClient <> nil) and (not FCurrentClient.ParentPanel.Visible)) then
  begin
    if FCurrentClient <> nil then
      FCurrentClient.ParentPanel.Visible := False; { Hide the panel, not the client }

    FCurrentClient := DockClientInfo;
    if (FCurrentClient <> nil) and (Parent <> nil) then
    begin
      R := CalcDockSize(FCurrentClient.DockClient);
      { Make sure it doesn't go out of the parent's client rect }
      with R do
        case Align of
          alLeft:
          begin
            MaxWidth := Parent.ClientWidth - Self.Width - Self.Left - 1;
            Inc(Right, FCurrentClient.ParentPanel.SplitterWidth);
            Inc(Right, FCurrentClient.ParentPanel.BevelWidth * 2);
            if Right - Left > MaxWidth  then
              Right := Left + MaxWidth;
          end;
          alRight:
          begin
            MaxWidth := Self.Left;
            Dec(Left, FCurrentClient.ParentPanel.SplitterWidth);
            Dec(Left, FCurrentClient.ParentPanel.BevelWidth * 2);
            if Right - Left > MaxWidth then
              Left := Right - MaxWidth;
          end;
          alTop:
          begin
            MaxHeight := Parent.ClientHeight - Self.Height - Self.Top - 1;
            Inc(Bottom, FCurrentClient.ParentPanel.SplitterWidth);
            Inc(Bottom, FCurrentClient.ParentPanel.FDockCaptionPanel.Height);
            Inc(Bottom, FCurrentClient.ParentPanel.BevelWidth * 2);
            if Bottom - Top > MaxHeight then
              Bottom := Top + MaxHeight;
          end;
          alBottom:
          begin
            MaxHeight := Self.Top;
            Dec(Top, FCurrentClient.ParentPanel.SplitterWidth);
            Dec(Top, FCurrentClient.ParentPanel.FDockCaptionPanel.Height);
            Dec(Top, FCurrentClient.ParentPanel.BevelWidth * 2);
            if Bottom - Top > MaxHeight then
              Top := Bottom - MaxHeight;
          end;
        end;
      SaveLRWidth := FCurrentClient.DockClient.LRDockWidth;
      SaveTBHeight := FCurrentClient.DockClient.TBDockHeight;
      { Insure parenting is set correctly }
      FCurrentClient.DockClient.Align := alClient;
      { RAID 228994.  alClient causes the dock width and height to get updated.
        Keep the previous width and height. }
      FCurrentClient.DockClient.LRDockWidth := SaveLRWidth;
      FCurrentClient.DockClient.TBDockHeight := SaveTBHeight;
      FCurrentClient.DockClient.Parent := FCurrentClient.ParentPanel;
      FCurrentClient.ParentPanel.Parent := Parent;
      { Set the panel to the top of the Z order, map the points and show it.
        The Visible := True does the animation. }
      FCurrentClient.ParentPanel.BringToFront;
      MapWindowPoints(Handle, Parent.Handle, R.TopLeft, 2);
      FCurrentClient.ParentPanel.BoundsRect := R;
      FCurrentClient.ParentPanel.Visible := True;
      if FShouldFocus then
        FCurrentClient.DockClient.SetFocus;
    end;
  end
  else if (FCurrentClient <> nil) and FShouldFocus and
     (not FCurrentClient.ParentPanel.ContainsControl(Screen.ActiveControl)) then
    FCurrentClient.DockClient.SetFocus;
end;

procedure TDockTabSet.InvalidateDockSite(const Client: TControl;
  const FocusLost: Boolean);
var
  DockClientInfo: TDockClientInfo;
begin
  DockClientInfo := FindDockClientInfo(Client);
  if DockClientInfo <> nil then
  begin
    if TabIndex = DockClientInfo.TabIndex then
    begin
      DockClientInfo.ParentPanel.FDockCaption.Invalidate;
      if FocusLost then
      begin
        { Reset the timer. }
        DockClientInfo.ParentPanel.FAutoHideTimer.Enabled := False;
        DockClientInfo.ParentPanel.FAutoHideTimer.Enabled := True;
      end;
    end;
  end;
end;

procedure TDockTabSet.CMUnDockClient(var Message: TCMUnDockClient);
begin
  Message.Client.Align := alNone;
  Message.Result := 0; 
end;

procedure TDockTabSet.HideCurrentDockClient(const AnimateSpeed: Integer);
var
  OriginalSpeed: Integer;
  OldClient: TDockClientInfo;
begin
  if FCurrentClient <> nil then
  begin
    OldClient := FCurrentClient;
    OriginalSpeed := OldClient.ParentPanel.AnimateSpeed;
    try
      OldClient.ParentPanel.AnimateSpeed := AnimateSpeed;
      OldClient.ParentPanel.Visible := False;
    finally
      OldClient.ParentPanel.AnimateSpeed := OriginalSpeed;
      FCurrentClient := nil; { May already have been set to nil }
    end;
    FAutoPopTimer.Enabled := False;
  end;
end;

procedure TDockTabSet.SetDestDockSite(const Value: TWinControl);
var
  I: Integer;
  Alt: IAlternateDockHost;
begin
  if FDestDockSite <> Value then
  begin
    if FDestDockSite <> nil then
    begin
      FDestDockSite.RemoveFreeNotification(Self);
      if Supports(FDestDockSite.DockManager, IAlternateDockHost, Alt) then
        Alt.SetAlternateDockHost(nil);
    end;
    FDestDockSite := Value;
    if FDestDockSite <> nil then
      FDestDockSite.FreeNotification(Self);
    if not (csDestroying in ComponentState) then
    begin
      for I := 0 to FDockClients.Count - 1 do
        TDockClientInfo(FDockClients[I]).ParentPanel.UpdateDockCaptionPin;
      if (FDestDockSite <> nil) and Supports(FDestDockSite.DockManager, IAlternateDockHost, Alt) then
        Alt.SetAlternateDockHost(Self);
    end;
  end;
end;

procedure TDockTabSet.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDestDockSite) then
    FDestDockSite := nil;
end;

function TDockTabSet.IndexOfDockClient(const Client: TControl): Integer;
var
  I: Integer;
  DockClientInfo: TDockClientInfo;
begin
  for I := 0 to FDockClients.Count - 1 do
  begin
    DockClientInfo := TDockClientInfo(FDockClients[I]);
    if DockClientInfo.DockClient = Client then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

function TDockTabSet.GetImageIndex(TabIndex: Integer): Integer;
var
  I: Integer;
  DockClientInfo: TDockClientInfo;
begin
  Result := -1;
  { Find the info with that tab index }
  for I := 0 to FDockClients.Count - 1 do
  begin
    DockClientInfo := TDockClientInfo(FDockClients[I]);
    if DockClientInfo.TabIndex = TabIndex then
    begin
      Result := DockClientInfo.ImageIndex;
      Break;
    end;
  end;
end;

procedure TDockTabSet.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
begin
  inherited;
  if FAutoSelect then
  begin
    I := ItemAtPos(Point(X, Y));
    if (I <> -1) and (I <> TabIndex) then
    begin
      { Auto-popout instantly if already poped, else use a timer }
      if TabIndex <> -1 then
      begin
        HideCurrentDockClient(100); { Fast hide }
        FShouldFocus := False;
        try
          TabIndex := I;
        finally
          FShouldFocus := True;
        end;
      end
      else
      begin
        { Did the mouse move over a different tab? If so, reset the timer. }
        if (FAutoPopIndex <> I) then
          FAutoPopTimer.Enabled := False;
        { Start the timer going. }
        FAutoPopTimer.Enabled := True;
        FAutoPopIndex := I;
      end;
    end
    else
      FAutoPopIndex := -1;
  end;
end;

function TDockTabSet.DockReplaceDockClient(Client: TControl;
  NewDockSite: TWinControl; DropControl: TControl;
  ControlSide: TAlign; ReplacementClient: TControl): Boolean;
var
  DockInfo: TDockClientInfo;
  OldIndex: Integer;
begin
  DockInfo := FindDockClientInfo(Client);
  Result := DockInfo <> nil;
  if Result then
  begin
    { Remember the old one's tab position, and undock it to the new dock site } 
    OldIndex := DockInfo.TabIndex;
    { Dock the other to its new site }
    Client.ManualDock(NewDockSite, DropControl, ControlSide);
    { Now, add back in the replacement control. }
    ReplacementClient.ManualDock(Self);
    ReplacementClient.Align := alClient; { In case it changed }
    DockInfo := FindDockClientInfo(ReplacementClient);
    Assert(DockInfo <> nil);
    if DockInfo <> nil then
      DockInfo.TabIndex := OldIndex; { Replace that index } 
  end;
end;

function TDockTabSet.GetTabName(const Client: TControl): string;
begin
  if Client is TCustomForm then
    Result := TCustomForm(Client).Caption
  else
    Result := '';
end;

procedure TDockTabSet.AutoPopTimerExec(Sender: TObject);
var
  I: Integer;
begin
  FAutoPopTimer.Enabled := False;
  I := ItemAtPos(ScreenToClient(Mouse.CursorPos));
  if (I <> TabIndex) and (I <> -1) then
  begin
    if TabIndex <> -1 then
      HideCurrentDockClient(100); { Fast hide }
    FShouldFocus := False;
    try
      TabIndex := I;
    finally
      FShouldFocus := True;
    end;
  end;
end;

function TDockTabSet.ShouldAutoHide(const Client: TWinControl): Boolean;
begin
  Result := True; { Decendents and control this, if needed }
end;

{ TDockClientInfo }

procedure TDockClientInfo.AddIconToImageList;
var
  FormBitmap: TBitmap;
  DestBitmap: TBitmap;
begin
  { Extract the image for that form }
  if (DockClient is TForm) and (TForm(DockClient).Icon.HandleAllocated) then
  begin
    FormBitmap := nil;
    DestBitmap := TBitmap.Create;
    try
      FormBitmap := TBitmap.Create;
      DestBitmap.Width := FDockTabSet.FInternalImages.Width;
      DestBitmap.Height := FDockTabSet.FInternalImages.Height;
      DestBitmap.Canvas.Brush.Color := clFuchsia;
      DestBitmap.Canvas.FillRect(Rect(0, 0, DestBitmap.Width, DestBitmap.Height));
      FormBitmap.Width := TForm(DockClient).Icon.Width;
      FormBitmap.Height := TForm(DockClient).Icon.Height;
      FormBitmap.Canvas.Draw(0, 0, TForm(DockClient).Icon);
      ScaleImage(FormBitmap, DestBitmap, DestBitmap.Width / FormBitmap.Width);
      ImageIndex := FDockTabSet.FInternalImages.AddMasked(DestBitmap,
        DestBitmap.Canvas.Pixels[0, DestBitmap.Height - 1]);
    finally
      FormBitmap.Free;
      DestBitmap.Free;
    end;
  end;
end;

constructor TDockClientInfo.Create(const ADockTabSet: TDockTabSet;
  const ADockClient: TWinControl);
begin
  FDockTabSet := ADockTabSet;
  FDockClient := ADockClient;
  FListIndex := FDockTabSet.FDockClients.Count;
  FTabIndex := -1;
  FImageIndex := -1;
  CreateTab;
  FParentPanel := TTabDockPanel.Create(nil, Self);
  case FDockTabSet.Align of
    alRight:
    begin
      { When aligned to the right, make it "stick" to the right with anchors }
      FParentPanel.Width := FDockClient.LRDockWidth;
      FParentPanel.Anchors := [akRight, akTop, akBottom];
      FParentPanel.SplitterPanel.Align := alLeft;
      FParentPanel.SplitterPanel.Cursor := crHSplit;
    end;
    alLeft: { Vice-versa for the other side }
    begin
      FParentPanel.Width := FDockClient.LRDockWidth;
      FParentPanel.Anchors := [akLeft, akTop, akBottom];
      FParentPanel.SplitterPanel.Align := alRight;
      FParentPanel.SplitterPanel.Cursor := crHSplit;
    end;
    alTop:
    begin
      FParentPanel.Height := FDockClient.TBDockHeight;
      FParentPanel.Anchors := [akLeft, akRight, akTop];
      FParentPanel.SplitterPanel.Align := alBottom;
      FParentPanel.SplitterPanel.Cursor := crVSplit;
    end;
    alBottom:
    begin
      FParentPanel.Height := FDockClient.TBDockHeight;
      FParentPanel.Anchors := [akLeft, akRight, akBottom];
      FParentPanel.SplitterPanel.Align := alTop;
      FParentPanel.SplitterPanel.Cursor := crVSplit;
    end;
    else
    begin
      FParentPanel.BoundsRect := Rect(0, 0, FDockClient.Width, FDockClient.Height);
      { Make it resize with everything }
      FParentPanel.Anchors := [akLeft, akRight, akTop, akBottom];
      FParentPanel.SplitterPanel.Visible := False;
    end;
  end;
  { Align the dock caption after everything else } 
  FParentPanel.FDockCaptionPanel.Align := alTop;

  FDockClient.Visible := False; { Make sure it is hidden. The user most show it. } 
  FDockClient.Parent := nil; { will be the panel at a later time }
  FDockClient.FreeNotification(Self);
  FParentPanel.FreeNotification(Self);

  AddIconToImageList;
end;

procedure TDockClientInfo.CreateTab(AlwaysCreate: Boolean);
begin
  if (FTabIndex = -1) and (AlwaysCreate or FDockClient.Visible) then
  begin
    FTabIndex := FDockTabSet.Tabs.Add(FDockTabSet.GetTabName(FDockClient));
    if Assigned(FDockTabSet.OnTabAdded) then
      FDockTabSet.OnTabAdded(FDockTabSet);
  end;
end;

destructor TDockClientInfo.Destroy;
var
  I: Integer;
  Info: TDockClientInfo;
begin
  if not (csDestroying in FDockTabSet.ComponentState) then
  begin
    { Hide the dock client info, then remove the tab }
    if FDockTabSet.FCurrentClient = Self then
      FDockTabSet.HideCurrentDockClient(100);
    TabIndex := -1; { Removes the tab }
    { Remove our image from the image list }
    if FImageIndex > -1 then
    begin
      for I := 0 to FDockTabSet.FDockClients.Count - 1 do
      begin
        Info := TDockClientInfo(FDockTabSet.FDockClients[I]);
        if Info.FImageIndex > FImageIndex then
          Dec(Info.FImageIndex);
      end;
      FDockTabSet.FInternalImages.Delete(FImageIndex);
    end;
  end;
  if FDockClient <> nil then
    FDockClient.RemoveFreeNotification(Self);
  FParentPanel.Free; { May already be nil } 
  inherited;
end;

procedure TDockClientInfo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDockClient) then
    FDockClient := nil
  else if (Operation = opRemove) and (AComponent = FParentPanel) then
    FParentPanel := nil;
end;

procedure TDockClientInfo.SetTabIndex(const Value: Integer);
var
  I: Integer;
begin
  if Value <> FTabIndex then
  begin
    if Value <> -1  then
    begin
      CreateTab(True); { Assume the user wants the tab there }
      { Make sure that we have up to Value worth of tabs }
      while (FDockTabSet.Tabs.Count <= Value) do
        FDockTabSet.Tabs.Add(''); { Will hopefully be filled in later by the user }
      FDockTabSet.Tabs.Move(FTabIndex, Value)
    end
    else
    begin
      { Delete our tab index, and update all others after it, as one lower }
      for I := 0 to FDockTabSet.FDockClients.Count - 1 do
      begin
        with TDockClientInfo(FDockTabSet.FDockClients[I]) do
          if FTabIndex > Self.FTabIndex then
            FTabIndex := FTabIndex - 1;
      end;
      if FDockTabSet.TabIndex = FTabIndex then
        FDockTabSet.TabIndex := -1;
      FDockTabSet.Tabs.Delete(FTabIndex);
      if Assigned(FDockTabSet.OnTabRemoved) then
        FDockTabSet.OnTabRemoved(FDockTabSet);
    end;
    FTabIndex := Value;
  end;
end;

procedure TDockTabSet.ShowDockClient(const Client: TControl);
var
  I: Integer;
  DockClientInfo: TDockClientInfo;
begin
  if Client.Visible then
  begin
    { Find the tab for this Client and show it }
    for I := 0 to FDockClients.Count - 1 do
    begin
      DockClientInfo := TDockClientInfo(FDockClients[I]);
      if DockClientInfo.DockClient = Client then
      begin
        if DockClientInfo.TabIndex = -1 then
          DockClientInfo.CreateTab;
        TabIndex := DockClientInfo.TabIndex;
        Break;
      end;
    end;
  end
  else
    Client.Visible := True; { Creates the tab, and shows the window }
end;

{ TTabDockPanel }

function TTabDockPanel.GetCaptionRect: TRect;
begin
  Result.Left := 1;
  Result.Top := 0;
  Result.Bottom := FDockCaption.Height - 1;
  Result.Right := FDockCaption.Width - 3;
end;

procedure TTabDockPanel.AutoHideTimerExec(Sender: TObject);
begin
  { If we aren't visible, or something is focused on us, then don't hide,
    and kill the timer }
  if (not Visible) or IsChild(Handle, GetFocus)  then
    FAutoHideTimer.Enabled := False
  else if (not FDockClientInfo.DockClient.Dragging) then
  begin
    if ShouldAutoHide then
    begin
      FAutoHideTimer.Enabled := False;
      Visible := False;
      FDockClientInfo.DockTabSet.TabIndex := -1; { Show nothing as "selected" }
    end;
  end;
end;

procedure TTabDockPanel.BeginAnimation;
begin
  { Supress some messages on XP, but not other OS's }
  FInAnimation := True;
  FFirstErase := True;
end;

procedure TTabDockPanel.CMShowingChanged(var Message: TMessage);
var
  Flags: Integer;
begin
  if (FDockClientInfo <> nil) and Assigned(AnimateWindowProc) then
  begin
    if Showing then
    begin
      FDockClientInfo.DockClient.Visible := True; { Make it visible first ! }
      if (LastDockTabSet <> nil) and (FDockClientInfo.DockTabSet <> LastDockTabSet) then
        LastDockTabSet.HideCurrentDockClient(100); { Hide the last one very fast }
      LastDockTabSet := FDockClientInfo.DockTabSet;
      Flags := AW_ACTIVATE or AW_SLIDE;
      case FDockClientInfo.FDockTabSet.Align of
        alBottom: Flags := Flags or AW_VER_NEGATIVE;
        alTop: Flags := Flags or AW_VER_POSITIVE;
        alLeft: Flags := Flags or AW_HOR_POSITIVE;
        alRight: Flags := Flags or AW_HOR_NEGATIVE;
      end;
    end
    else
    begin
      Flags := AW_HIDE or AW_SLIDE;
      case FDockClientInfo.FDockTabSet.Align of
        alBottom: Flags := Flags or AW_VER_POSITIVE;
        alTop: Flags := Flags or AW_VER_NEGATIVE;
        alLeft: Flags := Flags or AW_HOR_NEGATIVE;
        alRight: Flags := Flags or AW_HOR_POSITIVE;
      end;
    end;

    if (not FIsNotXP) then
    begin
      FBitmapPrintChache.Width := Width;
      FBitmapPrintChache.Height := Height;
      PaintTo(FBitmapPrintChache.Canvas, 0, 0);
    end;

    BeginAnimation;
    try
      AnimateWindowProc(Handle, FAnimateSpeed, Flags);
    finally
      EndAnimation;
    end;
  end
  else
    inherited;
  { Don't update the visible state if it isn't docked to us }
  if FDockClientInfo.DockClient.Parent = Self then
    FDockClientInfo.DockClient.Visible := Showing;
  if Showing then
    FAutoHideTimer.Enabled := True; 
end;

constructor TTabDockPanel.Create(AOwner: TComponent;
  DockClientInfo: TDockClientInfo);
begin
  inherited Create(AOwner);
  Visible := False;
                                                   
  FGrabberSize := GetSystemMetrics(SM_CYMENUSIZE);
  FSplitterWidth := 3;
  FAnimateSpeed := 200;

  FBitmapPrintChache := TBitmap.Create;

  FDockClientInfo := DockClientInfo;

  FSplitterPanel := TPanel.Create(Self);
  FSplitterPanel.Width := FSplitterWidth;
  FSplitterPanel.Height := FSplitterWidth;
  FSplitterPanel.BorderStyle := bsNone;
  FSplitterPanel.BevelInner := bvNone;
  FSplitterPanel.BevelOuter := bvNone;
  FSplitterPanel.OnMouseDown := SplitterMouseDown;
  FSplitterPanel.OnMouseMove := SplitterMouseMove;
  FSplitterPanel.Parent := Self;

  FDockCaptionPanel := TPanel.Create(Self); { For a window handle, and proper alignment }
  FDockCaptionPanel.Height := FGrabberSize;
  FDockCaptionPanel.BorderStyle := bsNone;
  FDockCaptionPanel.BevelInner := bvNone;
  FDockCaptionPanel.BevelOuter := bvNone;
  FDockCaptionPanel.Parent := Self;

  FDockCaption := TPaintBox.Create(Self);
  FDockCaption.Height := FGrabberSize;
  FDockCaption.OnPaint := PaintDockCaption;
  FDockCaption.Align := alClient;
  FDockCaption.Parent := FDockCaptionPanel;
  FDockCaption.OnMouseDown := DockCaptionMouseDown;
  FDockCaption.OnMouseUp := DockCaptionMouseUp;
  FDockCaption.OnMouseMove := DockCaptionMouseMove;
//  FDockCaption.ShowHint := True; { TODO -ocorbin : Make an option to turn on/off hints }

  FAutoHideTimer := TTimer.Create(Self);
  FAutoHideTimer.Enabled := False;
  FAutoHideTimer.Interval := 500;
  FAutoHideTimer.OnTimer := AutoHideTimerExec;

  FIsNotXP := not CheckWin32Version(5, 1);

  // DefaultDockTreeClass must be a TCaptionedDockTreeClass
  FDockCaptionDrawer := TCaptionedDockTreeClass(DefaultDockTreeClass).GetDockCaptionDrawer.Create(dcoHorizontal);

  UpdateDockCaptionPin;
end;

destructor TTabDockPanel.Destroy;
begin
  FDockCaptionDrawer.Free;
  FBitmapPrintChache.Free;
  inherited;
end;

procedure TTabDockPanel.DockCaptionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NowTick: Cardinal;
begin
  if Button = mbLeft then
  begin
    NowTick := GetTickCount;
    if (NowTick - FMouseDownTime) <= GetDoubleClickTime then
    begin
      { Undock, due to the double click }
      FDockClientInfo.FDockClient.ManualDock(nil);
    end
    else
    begin
      FMouseDownTime := NowTick;
      FDownPos := Point(X, Y);
    end;
  end;
end;

procedure TTabDockPanel.DockCaptionMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  DragThreshold: Integer;
begin
  DragThreshold := Mouse.DragThreshold;
  if (csLButtonDown in FDockCaption.ControlState) and
      ((Abs(FDownPos.X - X) >= DragThreshold) or
      (Abs(FDownPos.Y - Y) >= DragThreshold)) then
  begin
    { Remove the down state }
    FDockCaption.ControlState := FDockCaption.ControlState - [csLButtonDown];
    FDockClientInfo.DockClient.BeginDrag(True);
  end;
end;

procedure TTabDockPanel.DockCaptionMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  HitTest: TDockCaptionHitTest;
  Client: TControl;
  OldSpeed: Integer;
begin
  { See if we hit the close X }
  HitTest := FDockCaptionDrawer.DockCaptionHitTest(
    GetCaptionRect,
    Point(X, Y));
  if HitTest = dchtClose then
  begin
    { "Closing" will hide the panel, and then hide the tab. Hide it
      really fast }
    OldSpeed := FAnimateSpeed;
    FAnimateSpeed := 1;
    try
      Visible := False;
    finally
      FAnimateSpeed := OldSpeed;
    end;
    FDockClientInfo.DockClient.Visible := False; { Hides the control }
    FDockClientInfo.TabIndex := -1; { Removes the tab }
  end
  else if HitTest = dchtPin then
  begin
    { Undock from this site, and redock to the other site }
    with FDockClientInfo do
    begin
      Client := DockClient;
      Client.ManualDock(FDockTabSet.FDestDockSite);
      Client.Visible := True; { Make it visible again }
      if Client is TWinControl then
        TWinControl(Client).SetFocus
      else if Client.Parent <> nil then
        Client.Parent.SetFocus;
    end;
  end;
end;

procedure TTabDockPanel.EndAnimation;
begin
  FInAnimation := False;
end;

procedure TTabDockPanel.PaintDockCaption(Sender: TObject);
var
  State: TParentFormState;
begin
  { Always draw as focused, unless if the form containing the
    panel does not actually have focus }
  State := TCaptionedDockTreeClass(DefaultDockTreeClass).GetParentFormState(FDockClientInfo.DockClient);
  FDockCaptionDrawer.DrawDockCaption(FDockCaption.Canvas, GetCaptionRect,
    State);
end;

procedure TTabDockPanel.SplitterMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDownPos := FSplitterPanel.ClientToScreen(Point(X, Y));
  FStartingBounds := BoundsRect;
end;

procedure TTabDockPanel.SplitterMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
const
  cMinSize = 50;
var
  MaxSize: Integer;
  MinSize: Integer;
  NewBounds: TRect;
  ParentPoint: TPoint;
begin
  if csLButtonDown in FSplitterPanel.ControlState then
  begin
    ParentPoint := FSplitterPanel.ClientToScreen(Point(X, Y));
    NewBounds := FStartingBounds;
    { Resize the panel }
    with FDockClientInfo.FDockTabSet do
      case Align of
        alLeft:
        begin
          MinSize := Self.Left + cMinSize;
          NewBounds.Right := NewBounds.Right + ParentPoint.X - FDownPos.X;
          if NewBounds.Right > Parent.ClientWidth then
            NewBounds.Right := Parent.ClientWidth
          else if NewBounds.Right < MinSize then
            NewBounds.Right := MinSize;
        end;
        alRight:
        begin
          MaxSize := Self.Left + Self.Width - cMinSize;
          NewBounds.Left := NewBounds.Left + ParentPoint.X - FDownPos.X;
          if NewBounds.Left > MaxSize then
            NewBounds.Left := MaxSize
          else if NewBounds.Left < 0 then
            NewBounds.Left := 0;
        end;
        alTop:
        begin
          MinSize := Self.Top + cMinSize;
          NewBounds.Bottom := NewBounds.Bottom + ParentPoint.Y - FDownPos.Y;
          if NewBounds.Bottom > Parent.ClientHeight then
            NewBounds.Bottom := Parent.ClientHeight
          else if NewBounds.Bottom < MinSize then
            NewBounds.Bottom := MinSize;
        end;
        alBottom:
        begin
          MaxSize := Self.Top + Self.Height - cMinSize;
          NewBounds.Top := NewBounds.Top + ParentPoint.Y - FDownPos.Y;
          if NewBounds.Top < 0 then
            NewBounds.Top := 0
          else if NewBounds.Top > MaxSize then
            NewBounds.Top := MaxSize;
        end;
        else
          Assert(False); { panel won't be visible }
      end;
    BoundsRect := NewBounds;
  end
  else
  begin
    { Reset the auto hide timer, if enabled }
    if FAutoHideTimer.Enabled then
    begin
      FAutoHideTimer.Enabled := False;
      FAutoHideTimer.Enabled := True;
    end;
  end;
end;

procedure TTabDockPanel.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  if FIsNotXP or
    ((not FInAnimation or FFirstErase) or (not ThemeServices.ThemesEnabled)) then
  begin
    inherited;
    FFirstErase := False;
  end;
end;

procedure TTabDockPanel.UpdateDockCaptionPin;
begin
  if FDockClientInfo.DockTabSet.DestinationDockSite <> nil then
    FDockCaptionDrawer.DockCaptionPinButton := dcpbUp
  else
    FDockCaptionDrawer.DockCaptionPinButton := dcpbNone;
end;

procedure TTabDockPanel.WMNCPaint(var Message: TWMNCPaint);
begin
  if FIsNotXP or (not FInAnimation) then
    inherited;
end;

procedure TTabDockPanel.WMPrint(var Message: TWMPrint);
begin
  if (not FIsNotXP) and FInAnimation then
    with FBitmapPrintChache do
      BitBlt(Message.DC, 0, 0, Width, Height, Canvas.Handle, 0, 0, SRCCOPY)
  else
    PaintTo(Message.DC, 0, 0);
end;

procedure TTabDockPanel.WMPrintClient(var Message: TWMPrintClient);
begin
  if (not FIsNotXP) and FInAnimation then
    with FBitmapPrintChache do
      BitBlt(Message.DC, 0, 0, Width, Height, Canvas.Handle, 0, 0, SRCCOPY)
  else
    inherited;
end;

procedure TTabDockPanel.WMPaint(var Message: TWMPaint);
begin
  if FIsNotXP or (not FInAnimation) then
    inherited;
end;

function TTabDockPanel.ShouldAutoHide: Boolean;
begin
  { If the mouse is still over us, or the tabdock, then don't do anything }
  with FDockClientInfo do
    if Application.Active and { Not in the panel rect }
       (not Types.PtInRect(Rect(0, 0, Width, Height),
        ScreenToClient(Mouse.CursorPos))) and { Not in the tab dock }
       (not Types.PtInRect(Rect(0, 0, DockTabSet.Width, DockTabSet.Height),
        DockTabSet.ScreenToClient(Mouse.CursorPos))) then
          Result := FDockTabSet.ShouldAutoHide(FDockClient)
        else
          Result := False;
end;

{ TCaptionedTabDockTree }

function TCaptionedTabDockTree.PinHitTest(const MousePos: TPoint): TDockZone;
var
  ResultZone: TDockZone;

  procedure DoFindZone(Zone: TDockZone);
  var
    HitTest: TDockCaptionHitTest;
  begin
    if Zone.ChildControl <> nil then
    begin
      HitTest := InternalCaptionHitTest(Zone, MousePos);
      if HitTest = dchtPin then
      begin
        ResultZone := Zone;
        Exit; 
      end
      else if HitTest <> dchtNone then
        Exit; { Stop processing other zones }  
    end;
    { Recurse to next zone, if we didn't hit anything... }
    if (ResultZone = nil) and (Zone.NextVisible <> nil) then
      DoFindZone(Zone.NextVisible);
    if (ResultZone = nil) and (Zone.FirstVisibleChild <> nil) then
      DoFindZone(Zone.FirstVisibleChild);
  end;

var
  CtlAtPos: TControl;
begin
  ResultZone := nil;
  CtlAtPos := FindControlAtPos(MousePos);
  { If there is no control, see if we hit a caption in one of the zones }
  if (CtlAtPos = nil) and (TopZone.FirstVisibleChild <> nil) then
    DoFindZone(TopZone.FirstVisibleChild);
  Result := ResultZone;
end;

procedure TCaptionedTabDockTree.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; var Handled: Boolean);
var
  ChildZone, Zone: TDockZone;
  ChildControl: TControl;
begin
  if Button = mbLeft then
  begin
    { See if they clicked on the pin button }
    Zone := PinHitTest(Point(X, Y));
    if Zone <> nil then
    begin
      Handled := True;
      { Undock everything from here into the other dock host }
      ChildZone := Zone.FirstVisibleChild;
      while ChildZone <> nil do
      begin
        if ChildZone.ChildControl.Visible then
          ChildZone.ChildControl.ManualDock(FAlternateDockHost);
        ChildZone := ChildZone.NextVisible;
      end;
      if Zone.ChildControl.Visible then
      begin
        ChildControl := Zone.ChildControl;
        ChildControl.ManualDock(FAlternateDockHost);
        if (ChildControl is TWinControl) then
        begin
          if TWinControl(ChildControl).HandleAllocated then
            TWinControl(ChildControl).SetFocus;
        end
        else if ChildControl.Parent <> nil then
          ChildControl.Parent.SetFocus;
      end;
      ReleaseCapture; { Release the mouse capture from the dock host }
    end
    else
      inherited;
  end
  else
    inherited;
end;

procedure TCaptionedTabDockTree.SetAlternateDockHost(
  const DockHost: TWinControl);
begin
  FAlternateDockHost := DockHost;
  if FAlternateDockHost <> nil then
    DockCaptionDrawer.DockCaptionPinButton := dcpbDown
  else
    DockCaptionDrawer.DockCaptionPinButton := dcpbNone;
end;

initialization
  { The TDockTabSet needs a special dock tree to interact with it }
  DefaultDockTreeClass := TCaptionedTabDockTree;
end.
