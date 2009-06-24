{*****************************************************************}
{ This is a component for placing icons in the notification area  }
{ of the Windows taskbar (aka. the traybar).                      }
{                                                                 }
{ The component is freeware. Feel free to use and improve it.     }
{ I would be pleased to hear what you think.                      }
{                                                                 }
{ Troels Jakobsen - delphiuser@get2net.dk                         }
{ Copyright (c) 2002                                              }
{                                                                 }
{ Portions by Jouni Airaksinen - mintus@codefield.com             }
{*****************************************************************}

unit CoolTrayIcon;

{$T-}  // Use untyped pointers as we override TNotifyIconData with TNotifyIconDataEx

{ Some methods have moved to the Classes unit in D6 and are thus deprecated.
  Using the following compiler directives we handle that situation. }
{$IFDEF VER140}
  {$DEFINE DELPHI_6}
{$ENDIF}
{$IFDEF VER180}
  {$DEFINE DELPHI_6_UP}
{$ENDIF}
{$IFDEF DELPHI_6}
  {$DEFINE DELPHI_6_UP}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Menus, ShellApi, ExtCtrls, SimpleTimer, ImgList;

const
  { Define user-defined message sent by the trayicon. We avoid low user-defined
    messages that are used by Windows itself (eg. WM_USER+1 = DM_SETDEFID). }
  WM_TRAYNOTIFY         = WM_USER + 1024;
  // Constants used for balloon hint feature
  _NIIF_NONE            = $00000000;
  _NIIF_INFO            = $00000001;
  _NIIF_WARNING         = $00000002;
  _NIIF_ERROR           = $00000003;
  _NIIF_ICON_MASK       = $0000000F;   // Reserved for WinXP
  _NIIF_NOSOUND         = $00000010;   // Reserved for WinXP
  // Events returned by balloon hint
  _NIN_BALLOONSHOW      = WM_USER + 2;
  _NIN_BALLOONHIDE      = WM_USER + 3;
  _NIN_BALLOONTIMEOUT   = WM_USER + 4;
  _NIN_BALLOONUSERCLICK = WM_USER + 5;
  // Additional uFlags constants for TNotifyIconDataEx
  _NIF_STATE            = $00000008;
  _NIF_INFO             = $00000010;
  _NIF_GUID             = $00000020;
  // Additional dwMessage constants for Shell_NotifyIcon
  _NIM_SETFOCUS         = $00000003;
  _NIM_SETVERSION       = $00000004;

var
  WM_TASKBARCREATED: Cardinal;
  SHELL_VERSION: Integer;

type
  { You can use the TNotifyIconData record structure defined in shellapi.pas.
    However, WinME, Win2000, and WinXP have expanded this structure, so in
    order to implement their new features we define a similar structure,
    TNotifyIconDataEx. }
  { The old TNotifyIconData record contains a field called Wnd in Delphi
    and hWnd in C++ Builder. The compiler directive DFS_CPPB_3_UP was used
    to distinguish between the two situations, but is no longer necessary
    when we define our own record, TNotifyIconDataEx. }
  TNotifyIconDataEx = record
    cbSize: DWORD;
    hWnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..127] of AnsiChar;  // Previously 64 chars, now 128
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of AnsiChar;
    case Integer of         // 0: Before Win2000; 1: Win2000 and up
      0: (uTimeout: UINT;
          szInfoTitle: array[0..63] of AnsiChar;
          dwInfoFlags: DWORD);
      1: (uVersion: UINT;   // Only used when sending a NIM_SETVERSION message
{$IFDEF _WIN32_IE_600)}
          guidItem: TGUID;  // Reserved for WinXP; define _WIN32_IE_600 if needed
{$ENDIF}
         )
  end;

  TBalloonHintIcon = (bitNone, bitInfo, bitWarning, bitError);
  TBalloonHintTimeOut = 10..60;   // Windows defines 10-60 secs. as min-max

  THintString = String[127];      // 128 bytes, last char should be #0

  TCycleEvent = procedure(Sender: TObject; NextIndex: Integer) of object;
  TStartupEvent = procedure(Sender: TObject; var ShowMainForm: Boolean) of object;

  TCoolTrayIcon = class(TComponent)
  private
    FEnabled: Boolean;
    FIcon: TIcon;
    FIconID: Cardinal;
    FIconVisible: Boolean;
    FHint: THintString;
    FShowHint: Boolean;
    FPopupMenu: TPopupMenu;
    FLeftPopup: Boolean;
    FOnClick,
    FOnDblClick: TNotifyEvent;
    FOnCycle: TCycleEvent;
    FOnStartup: TStartupEvent;
    FOnMouseDown,
    FOnMouseUp: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseExit: TNotifyEvent;
    FOnBalloonHintClick: TNotifyEvent;
    FOnBalloonHintHide: TNotifyEvent;
    FOnBalloonHintTimeout: TNotifyEvent;
    FMinimizeToTray: Boolean;
    FClickStart: Boolean;
    FClickReady: Boolean;
    CycleTimer: TSimpleTimer;          // For icon cycling
    ClickTimer: TSimpleTimer;          // For distinguishing click and dbl.click
    ExitTimer: TSimpleTimer;           // For OnMouseExit event
    LastMoveX, LastMoveY: Integer;
    FDidExit: Boolean;
    FWantEnterExitEvents: Boolean;
    IsDblClick: Boolean;
    FIconIndex: Integer;               // Current index in imagelist
    FDesignPreview: Boolean;
    SettingPreview: Boolean;           // Internal status flag
    SettingMDIForm: Boolean;           // Internal status flag
    FIconList: TCustomImageList;
    FCycleIcons: Boolean;
    FCycleInterval: Cardinal;
    OldAppProc, NewAppProc: Pointer;   // Procedure variables
    OldWndProc, NewWndProc: Pointer;   // Procedure variables
    procedure SetDesignPreview(Value: Boolean);
    procedure SetCycleIcons(Value: Boolean);
    procedure SetCycleInterval(Value: Cardinal);
    function InitIcon: Boolean;
    procedure SetIcon(Value: TIcon);
    procedure SetIconVisible(Value: Boolean);
    procedure SetIconList(Value: TCustomImageList);
    procedure SetIconIndex(Value: Integer);
    procedure SetHint(Value: THintString);
    procedure SetShowHint(Value: Boolean);
    procedure SetWantEnterExitEvents(Value: Boolean);
    procedure IconChanged(Sender: TObject);
    // Hook methods
    procedure HookApp;
    procedure UnhookApp;
    procedure HookAppProc(var Msg: TMessage);
    procedure HookForm;
    procedure UnhookForm;
    procedure HookFormProc(var Msg: TMessage);
  protected
    IconData: TNotifyIconDataEx;       // Data of the tray icon wnd.
    procedure Loaded; override;
    function LoadDefaultIcon: Boolean; virtual;
    function ShowIcon: Boolean; virtual;
    function HideIcon: Boolean; virtual;
    function ModifyIcon: Boolean; virtual;
    procedure Click; dynamic;
    procedure DblClick; dynamic;
    procedure CycleIcon; dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); dynamic;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseEnter; dynamic;
    procedure MouseExit; dynamic;
    procedure DoMinimizeToTray; dynamic;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    property Handle: HWND read IconData.hWnd;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Refresh: Boolean;
    function ShowBalloonHint(Title: String; Text: String; IconType: TBalloonHintIcon;
      TimeoutSecs: TBalloonHintTimeOut): Boolean;
    function HideBalloonHint: Boolean;
    procedure PopupAtCursor;
    function BitmapToIcon(const Bitmap: TBitmap; const Icon: TIcon;
      MaskColor: TColor): Boolean;
    function GetClientIconPos(X, Y: Integer): TPoint;
    function GetTooltipHandle: HWND;
    //----- SPECIAL: methods that only apply when owner is a form -----
    procedure ShowMainForm;
    procedure HideMainForm;
    //----- END SPECIAL -----
  published
    // Properties:
    property DesignPreview: Boolean read FDesignPreview write SetDesignPreview
      default False;
    property IconList: TCustomImageList read FIconList write SetIconList;
    property CycleIcons: Boolean read FCycleIcons write SetCycleIcons
      default False;
    property CycleInterval: Cardinal read FCycleInterval write SetCycleInterval;
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property Hint: THintString read FHint write SetHint;
    property ShowHint: Boolean read FShowHint write SetShowHint default True;
    property Icon: TIcon read FIcon write SetIcon;
    property IconVisible: Boolean read FIconVisible write SetIconVisible
      default False;
    property IconIndex: Integer read FIconIndex write SetIconIndex;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property LeftPopup: Boolean read FLeftPopup write FLeftPopup default False;
    property WantEnterExitEvents: Boolean read FWantEnterExitEvents
      write SetWantEnterExitEvents default False;
    //----- SPECIAL: properties that only apply when owner is a form -----
    property MinimizeToTray: Boolean read FMinimizeToTray write FMinimizeToTray
      default False;             // Minimize main form to tray when minimizing?
    //----- END SPECIAL -----
    // Events:
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseExit: TNotifyEvent read FOnMouseExit write FOnMouseExit;
    property OnCycle: TCycleEvent read FOnCycle write FOnCycle;
    property OnBalloonHintClick: TNotifyEvent read FOnBalloonHintClick
      write FOnBalloonHintClick;
    property OnBalloonHintHide: TNotifyEvent read FOnBalloonHintHide
      write FOnBalloonHintHide;
    property OnBalloonHintTimeout: TNotifyEvent read FOnBalloonHintTimeout
      write FOnBalloonHintTimeout;
    //----- SPECIAL: events that only apply when owner is a form -----
    property OnStartup: TStartupEvent read FOnStartup write FOnStartup;
    //----- END SPECIAL -----
  end;


implementation

uses
  ComCtrls;

const
  // Tooltip constants
  TOOLTIPS_CLASS = 'tooltips_class32';
  TTS_NOPREFIX = 2;

type
  TTrayIconHandler = class(TObject)
  private
    RefCount: Cardinal;
    FHandle: HWND;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add;
    procedure Remove;
    procedure HandleIconMessage(var Msg: TMessage);
  end;

var
  TrayIconHandler: TTrayIconHandler = nil;

{------------------ TTrayIconHandler ------------------}

constructor TTrayIconHandler.Create;
begin
  inherited Create;
  RefCount := 0;
{$IFDEF DELPHI_6_UP}
  FHandle := Classes.AllocateHWnd(HandleIconMessage);
{$ELSE}
  FHandle := AllocateHWnd(HandleIconMessage);
{$ENDIF}
end;


destructor TTrayIconHandler.Destroy;
begin
{$IFDEF DELPHI_6_UP}
  Classes.DeallocateHWnd(FHandle);     // Free the tray window
{$ELSE}
  DeallocateHWnd(FHandle);             // Free the tray window
{$ENDIF}
  inherited Destroy;
end;


procedure TTrayIconHandler.Add;
begin
  Inc(RefCount);
end;


procedure TTrayIconHandler.Remove;
begin
  if RefCount > 0 then
    Dec(RefCount);
end;


{ HandleIconMessage handles messages that go to the shell notification
  window (tray icon) itself. Most messages are passed through WM_TRAYNOTIFY.
  In these cases we use lParam to get the actual message, eg. WM_MOUSEMOVE.
  The method fires the appropriate event methods like OnClick and OnMouseMove. }

{ The message always goes through the container, TrayIconHandler.
  Msg.wParam contains the ID of the TCoolTrayIcon instance, which we stored
  as the object pointer Self in the TCoolTrayIcon constructor. It is therefore
  safe to cast wParam to a TCoolTrayIcon instance. }

procedure TTrayIconHandler.HandleIconMessage(var Msg: TMessage);

  function ShiftState: TShiftState;
  // Return the state of the shift, ctrl, and alt keys
  begin
    Result := [];
    if GetAsyncKeyState(VK_SHIFT) < 0 then
      Include(Result, ssShift);
    if GetAsyncKeyState(VK_CONTROL) < 0 then
      Include(Result, ssCtrl);
    if GetAsyncKeyState(VK_MENU) < 0 then
      Include(Result, ssAlt);
  end;

var
  Pt: TPoint;
  Shift: TShiftState;
  I: Integer;
  M: TMenuItem;
begin
  if Msg.Msg = WM_TRAYNOTIFY then
  // Take action if a message from the tray icon comes through
  begin
    with TCoolTrayIcon(Msg.wParam) do  // Cast to a TCoolTrayIcon instance
    begin
      case Msg.lParam of

        WM_MOUSEMOVE:
          if FEnabled then
          begin
            // MouseEnter event
            if FWantEnterExitEvents then
              if FDidExit then
              begin
                MouseEnter;
                FDidExit := False;
              end;
            // MouseMove event
            Shift := ShiftState;
            GetCursorPos(Pt);
            MouseMove(Shift, Pt.x, Pt.y);
            LastMoveX := Pt.x;
            LastMoveY := Pt.y;
          end;

        WM_LBUTTONDOWN:
          if FEnabled then
          begin
            { If we have no OnDblClick event fire the Click event immediately.
              Otherwise start a timer and wait for a short while to see if user
              clicks again. If he does click again inside this period we have
              a double click in stead of a click. }
            if Assigned(FOnDblClick) then
              ClickTimer.Start(GetDoubleClickTime);
            Shift := ShiftState + [ssLeft];
            GetCursorPos(Pt);
            MouseDown(mbLeft, Shift, Pt.x, Pt.y);
            FClickStart := True;
            if FLeftPopup then
              PopupAtCursor;
          end;

        WM_RBUTTONDOWN:
          if FEnabled then
          begin
            Shift := ShiftState + [ssRight];
            GetCursorPos(Pt);
            MouseDown(mbRight, Shift, Pt.x, Pt.y);
            PopupAtCursor;
          end;

        WM_MBUTTONDOWN:
          if FEnabled then
          begin
            Shift := ShiftState + [ssMiddle];
            GetCursorPos(Pt);
            MouseDown(mbMiddle, Shift, Pt.x, Pt.y);
          end;

        WM_LBUTTONUP:
          if FEnabled then
          begin
            Shift := ShiftState + [ssLeft];
            GetCursorPos(Pt);

            if FClickStart then   // Then WM_LBUTTONDOWN was called before
              FClickReady := True;

            if FClickStart and (not ClickTimer.Active) then
            begin
              { At this point we know a mousedown occured, and the dblclick timer
                timed out. We have a delayed click. }
              FClickStart := False;
              FClickReady := False;
              Click;              // We have a click
            end;

            FClickStart := False;

            MouseUp(mbLeft, Shift, Pt.x, Pt.y);
          end;

        WM_RBUTTONUP:
          if FEnabled then
          begin
            Shift := ShiftState + [ssRight];
            GetCursorPos(Pt);
            MouseUp(mbRight, Shift, Pt.x, Pt.y);
          end;

        WM_MBUTTONUP:
          if FEnabled then
          begin
            Shift := ShiftState + [ssMiddle];
            GetCursorPos(Pt);
            MouseUp(mbMiddle, Shift, Pt.x, Pt.y);
          end;

        WM_LBUTTONDBLCLK:
          if FEnabled then
          begin
            FClickReady := False;
            IsDblClick := True;
            DblClick;
            { Handle default menu items. But only if LeftPopup is false, or it
              will conflict with the popupmenu, when it is called by a click event. }
            M := nil;
            if Assigned(FPopupMenu) then
              if (FPopupMenu.AutoPopup) and (not FLeftPopup) then
                for I := PopupMenu.Items.Count -1 downto 0 do
                begin
                  if PopupMenu.Items[I].Default then
                    M := PopupMenu.Items[I];
                end;
            if M <> nil then
              M.Click;
          end;

        _NIN_BALLOONSHOW: begin
          // Do nothing
        end;

        _NIN_BALLOONHIDE:
          if Assigned(FOnBalloonHintHide) then
            FOnBalloonHintHide(Self);

        _NIN_BALLOONTIMEOUT:
          if Assigned(FOnBalloonHintTimeout) then
            FOnBalloonHintTimeout(Self);

        _NIN_BALLOONUSERCLICK:
          if Assigned(FOnBalloonHintClick) then
            FOnBalloonHintClick(Self);

      end;
    end;
  end

  else             // Messages that didn't go through the icon
    case Msg.Msg of
      { Windows sends us a WM_QUERYENDSESSION message when it prepares for
        shutdown. Msg.Result must not return 0, or the system will be unable
        to shut down. The same goes for other specific system messages. }
      WM_CLOSE, WM_QUIT, WM_DESTROY, WM_NCDESTROY: begin
        Msg.Result := 1;
      end;
      WM_QUERYENDSESSION, WM_ENDSESSION, WM_USERCHANGED: begin
        Msg.Result := 1;
      end;

    else      // Handle all other messages with the default handler
      Msg.Result := DefWindowProc(FHandle, Msg.Msg, Msg.wParam, Msg.lParam);
    end;
end;

{---------------- Container management ----------------}

procedure AddTrayIcon;
begin
  if not Assigned(TrayIconHandler) then
    // Create new handler
    TrayIconHandler := TTrayIconHandler.Create;
  TrayIconHandler.Add;
end;


procedure RemoveTrayIcon;
begin
  if Assigned(TrayIconHandler) then
  begin
    TrayIconHandler.Remove;
    if TrayIconHandler.RefCount = 0 then
      FreeAndNil(TrayIconHandler);           // Destroy handler
  end;
end;

{----------------- Callback methods -------------------}

procedure ClickTimerProc(AOwner: TComponent); stdcall;
begin
  with (AOwner as TCoolTrayIcon) do
  begin
    ClickTimer.Stop;
    if (not IsDblClick) then
      if FClickReady then
      begin
        FClickReady := False;
        Click;
      end;
    IsDblClick := False;
  end;
end;


procedure CycleTimerProc(AOwner: TComponent); stdcall;
begin
  with (AOwner as TCoolTrayIcon) do
  begin
    if Assigned(FIconList) then
    begin
      FIconList.GetIcon(FIconIndex, FIcon);
//      IconChanged(AOwner);
      CycleIcon;             // Call event method

      if FIconIndex < FIconList.Count-1 then
        SetIconIndex(FIconIndex+1)
      else
        SetIconIndex(0);
    end;
  end;
end;


procedure MouseExitTimerProc(AOwner: TComponent); stdcall;
var
  Pt: TPoint;
begin
  with (AOwner as TCoolTrayIcon) do
  begin
    if FDidExit then
      Exit;
    GetCursorPos(Pt);
    if (Pt.x < LastMoveX) or (Pt.y < LastMoveY) or
       (Pt.x > LastMoveX) or (Pt.y > LastMoveY) then
    begin
      FDidExit := True;
      MouseExit;
    end;
  end;
end;

{------------------- TCoolTrayIcon --------------------}

constructor TCoolTrayIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  AddTrayIcon;               // Container management
  FIconID := Cardinal(Self); // Use Self object pointer as ID

  SettingMDIForm := True;
  FEnabled := True;          // Enabled by default
  FShowHint := True;         // Show hint by default
  SettingPreview := False;

  FIcon := TIcon.Create;
  FIcon.OnChange := IconChanged;
  FillChar(IconData, SizeOf(IconData), 0);
  IconData.cbSize := SizeOf(TNotifyIconDataEx);
  { IconData.hWnd points to procedure to receive callback messages from the icon.
    We set it to our TrayIconHandler instance. }
  IconData.hWnd := TrayIconHandler.FHandle;
  // Add an id for the tray icon
  IconData.uId := FIconID;
  // We want icon, message handling, and tooltips by default
  IconData.uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
  // Message to send to IconData.hWnd when event occurs
  IconData.uCallbackMessage := WM_TRAYNOTIFY;

  // Create SimpleTimers for later use
  CycleTimer := TSimpleTimer.Create(Self, @CycleTimerProc);
  ClickTimer := TSimpleTimer.Create(Self, @ClickTimerProc);
  ExitTimer := TSimpleTimer.Create(Self, @MouseExitTimerProc);

  FDidExit := True;          // Prevents MouseExit from firing at startup

  SetDesignPreview(FDesignPreview);

  // Set hook(s)
  if not (csDesigning in ComponentState) then
  begin
    HookApp;                 // Hook into the app.'s message handling
    if Owner is TWinControl then
      HookForm;              // Hook into the main form's message handling
  end;
end;


destructor TCoolTrayIcon.Destroy;
begin
  SetIconVisible(False);     // Remove the icon from the tray
  SetDesignPreview(False);   // Remove any DesignPreview icon
  FIcon.Free;                // Free the icon
  CycleTimer.Free;
  ClickTimer.Free;
  ExitTimer.Free;
  // It is important to unhook any hooked processes
  if not (csDesigning in ComponentState) then
  begin
    UnhookApp;
    if Owner is TWinControl then
      UnhookForm;
  end;
  RemoveTrayIcon;             // Container management
  inherited Destroy;
end;


procedure TCoolTrayIcon.Loaded;
{ This method is called when all properties of the component have been
  initialized. The method SetIconVisible must be called here, after the
  tray icon (FIcon) has loaded itself. Otherwise, the tray icon will
  be blank (no icon image).
  Other boolean values must also be set here. }
var
  Show: Boolean;
begin
  inherited Loaded;          // Always call inherited Loaded first

  if Owner is TWinControl then
    if not (csDesigning in ComponentState) then
    begin
      Show := True;
      if Assigned(FOnStartup) then
        FOnStartup(Self, Show);
      if not Show then
      begin
        Application.ShowMainForm := False;
        HideMainForm;
      end;
    end;

  ModifyIcon;
  SetIconVisible(FIconVisible);
  SetCycleIcons(FCycleIcons);
  SetWantEnterExitEvents(FWantEnterExitEvents);
end;


function TCoolTrayIcon.LoadDefaultIcon: Boolean;
{ This method is called to determine whether to assign a default icon to
  the component. Descendant classes (like TextTrayIcon) can override the
  method to change this behavior. }
begin
  Result := True;
end;


procedure TCoolTrayIcon.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  // Check if either the imagelist or the popup menu is about to be deleted
  if (AComponent = IconList) and (Operation = opRemove) then
  begin
    FIconList := nil;
    IconList := nil;
  end;
  if (AComponent = PopupMenu) and (Operation = opRemove) then
  begin
    FPopupMenu := nil;
    PopupMenu := nil;
  end;
end;


procedure TCoolTrayIcon.IconChanged(Sender: TObject);
begin
  ModifyIcon;
end;


{ For MinimizeToTray to work, we need to know when the form is minimized
  (happens when either the application or the main form minimizes).
  The straight-forward way is to make TCoolTrayIcon trap the
  Application.OnMinimize event. However, if you also make use of this
  event in the application, the OnMinimize code used by TCoolTrayIcon
  is discarded.
  The solution is to hook into the app.'s message handling (via HookApp).
  You can then catch any message that goes through the app. and still
  use the OnMinimize event. }

procedure TCoolTrayIcon.HookApp;
begin
  // Hook the application
  OldAppProc := Pointer(GetWindowLong(Application.Handle, GWL_WNDPROC));
{$IFDEF DELPHI_6_UP}
  NewAppProc := Classes.MakeObjectInstance(HookAppProc);
{$ELSE}
  NewAppProc := MakeObjectInstance(HookAppProc);
{$ENDIF}
  SetWindowLong(Application.Handle, GWL_WNDPROC, LongInt(NewAppProc));
end;


procedure TCoolTrayIcon.UnhookApp;
begin
  if Assigned(OldAppProc) then
    SetWindowLong(Application.Handle, GWL_WNDPROC, LongInt(OldAppProc));
  if Assigned(NewAppProc) then
{$IFDEF DELPHI_6_UP}
    Classes.FreeObjectInstance(NewAppProc);
{$ELSE}
    FreeObjectInstance(NewAppProc);
{$ENDIF}
  NewAppProc := nil;
  OldAppProc := nil;
end;


{ All app. messages pass through HookAppProc. You can override the messages
  by not passing them along to Windows (via CallWindowProc). }

procedure TCoolTrayIcon.HookAppProc(var Msg: TMessage);
var
  Show: Boolean;
begin
  case Msg.Msg of

    WM_SIZE:
      // Handle MinimizeToTray by capturing app's minimize events
      if Msg.wParam = SIZE_MINIMIZED then
      begin
        if FMinimizeToTray then
          DoMinimizeToTray;
        { You could insert a call to a custom minimize event here, but it would
          behave exactly like Application.OnMinimize, so I see no need for it. }
      end;

    WM_WINDOWPOSCHANGED: begin
      { Handle MDI forms: MDI children cause the app. to be redisplayed on the
        taskbar. We hide it again. This may cause a quick flicker. }
      if SettingMDIForm then
        if Application.MainForm <> nil then
        begin

          if Application.MainForm.FormStyle = fsMDIForm then
          begin
            Show := True;
            if Assigned(FOnStartup) then
              FOnStartup(Self, Show);
            if not Show then
              ShowWindow(Application.Handle, SW_HIDE);
          end;

          SettingMDIForm := False;     // So we only do this once
        end;
    end;

  end;

  // Show the tray icon if the taskbar has been re-created after an Explorer crash
  if Msg.Msg = WM_TASKBARCREATED then
    if FIconVisible then
      ShowIcon;

  // Pass the message on
  Msg.Result := CallWindowProc(OldAppProc, Application.Handle,
                Msg.Msg, Msg.wParam, Msg.lParam);
end;


{ You can hook into the main form (or any other window) just as easily as
  hooking into the app., allowing you to handle any message that window processes.
  This is necessary in order to properly handle when the user minimizes the form
  using the TASKBAR icon. }

procedure TCoolTrayIcon.HookForm;
begin
  if (Owner as TWinControl) <> nil then
  begin
    // Hook the parent window
    OldWndProc := Pointer(GetWindowLong((Owner as TWinControl).Handle, GWL_WNDPROC));
{$IFDEF DELPHI_6_UP}
    NewWndProc := Classes.MakeObjectInstance(HookFormProc);
{$ELSE}
    NewWndProc := MakeObjectInstance(HookFormProc);
{$ENDIF}
    SetWindowLong((Owner as TWinControl).Handle, GWL_WNDPROC, LongInt(NewWndProc));
  end;
end;


procedure TCoolTrayIcon.UnhookForm;
begin
  if ((Owner as TWinControl) <> nil) and (Assigned(OldWndProc)) then
    SetWindowLong((Owner as TWinControl).Handle, GWL_WNDPROC, LongInt(OldWndProc));
  if Assigned(NewWndProc) then
{$IFDEF DELPHI_6_UP}
    Classes.FreeObjectInstance(NewWndProc);
{$ELSE}
    FreeObjectInstance(NewWndProc);
{$ENDIF}
  NewWndProc := nil;
  OldWndProc := nil;
end;

{ All main form messages pass through HookFormProc. You can override the
  messages by not passing them along to Windows (via CallWindowProc).
  You should be careful with the graphical messages, though. }

procedure TCoolTrayIcon.HookFormProc(var Msg: TMessage);
begin
  case Msg.Msg of

    WM_SHOWWINDOW: begin
      if (Msg.lParam = 0) and (Msg.wParam = 1) then
      begin
        // Show the taskbar icon (Windows may have shown it already)
        ShowWindow(Application.Handle, SW_RESTORE);
        // Bring the taskbar icon and the main form to the foreground
        SetForegroundWindow(Application.Handle);
        SetForegroundWindow((Owner as TWinControl).Handle);
      end;
    end;

    WM_ACTIVATE: begin
      // Bring any modal forms owned by the main form to the foreground
      if Assigned(Screen.ActiveControl) then
        if (Msg.WParamLo = WA_ACTIVE) or (Msg.WParamLo = WA_CLICKACTIVE) then
          if Assigned(Screen.ActiveControl.Parent) then
          begin
            // Control on modal form is active
            if HWND(Msg.lParam) <> Screen.ActiveControl.Parent.Handle then
              SetFocus(Screen.ActiveControl.Handle);
          end
          else
          begin
            // Modal form itself is active
            if HWND(Msg.lParam) <> Screen.ActiveControl.Handle then
              SetFocus(Screen.ActiveControl.Handle);
          end;
    end;

  end;
{
  case Msg.Msg of
    WM_QUERYENDSESSION: begin
      Msg.Result := 1;
    end;
  else
}
    // Pass the message on
    Msg.Result := CallWindowProc(OldWndProc, (Owner as TWinControl).Handle,
                  Msg.Msg, Msg.wParam, Msg.lParam);
{
  end;
}
end;


procedure TCoolTrayIcon.SetIcon(Value: TIcon);
begin
  FIcon.OnChange := nil;
  FIcon.Assign(Value);
  FIcon.OnChange := IconChanged;
  ModifyIcon;
end;


procedure TCoolTrayIcon.SetIconVisible(Value: Boolean);
begin
  if Value then
    ShowIcon
  else
    HideIcon;
end;


procedure TCoolTrayIcon.SetDesignPreview(Value: Boolean);
begin
  FDesignPreview := Value;
  SettingPreview := True;         // Raise flag
  { Assign a default icon if Icon property is empty. This will assign
    an icon to the component when it is created for the very first time.
    When the user assigns another icon it will not be overwritten next
    time the project loads. HOWEVER, if the user has decided explicitly
    to have no icon a default icon will be inserted regardless.
    I figured this was a tolerable price to pay. }
  if (csDesigning in ComponentState) then
    if FIcon.Handle = 0 then
      if LoadDefaultIcon then
        FIcon.Handle := LoadIcon(0, IDI_WINLOGO);
  { It is tempting to assign the application's icon (Application.Icon)
    as a default icon. The problem is there's no Application instance
    at design time. Or is there? Yes there is: the Delphi editor!
    Application.Icon is the icon found in delphi32.exe. How to use:
      FIcon.Assign(Application.Icon);
    Seems to work, but I don't recommend doing it. }
  SetIconVisible(Value);
  SettingPreview := False;        // Clear flag
end;


procedure TCoolTrayIcon.SetCycleIcons(Value: Boolean);
begin
  FCycleIcons := Value;
  if Value then
    SetIconIndex(0);
  if Value then
    CycleTimer.Start(FCycleInterval)
  else
    CycleTimer.Stop;
end;


procedure TCoolTrayIcon.SetCycleInterval(Value: Cardinal);
begin
  FCycleInterval := Value;
  SetCycleIcons(FCycleIcons);
end;


procedure TCoolTrayIcon.SetIconList(Value: TCustomImageList);
begin
  FIconList := Value;
{
  // Set CycleIcons = false if IconList is nil
  if Value = nil then
    SetCycleIcons(False);
}
  SetIconIndex(0);
end;


procedure TCoolTrayIcon.SetIconIndex(Value: Integer);
begin
  if FIconList <> nil then
  begin
    FIconIndex := Value;
    if Value >= FIconList.Count then
      FIconIndex := FIconList.Count -1;
    FIconList.GetIcon(FIconIndex, FIcon);
  end
  else
    FIconIndex := 0;

  ModifyIcon;
end;


procedure TCoolTrayIcon.SetHint(Value: THintString);
begin
  FHint := Value;
  ModifyIcon;
end;


procedure TCoolTrayIcon.SetShowHint(Value: Boolean);
begin
  FShowHint := Value;
  ModifyIcon;
end;


procedure TCoolTrayIcon.SetWantEnterExitEvents(Value: Boolean);
begin
  FWantEnterExitEvents := Value;
  if Value then
  begin
    ExitTimer.Start(20);
  end
  else
    ExitTimer.Stop;
end;


function TCoolTrayIcon.InitIcon: Boolean;
// Set icon and tooltip
var
  ok: Boolean;
begin
  Result := False;
  ok := True;
  if (csDesigning in ComponentState) then
    ok := (SettingPreview or FDesignPreview);

  if ok then
  begin
    IconData.hIcon := FIcon.Handle;
    if (FHint <> '') and (FShowHint) then
      StrLCopy(IconData.szTip, PChar(String(FHint)), SizeOf(IconData.szTip)-1)
      { StrLCopy must be used since szTip is only 128 bytes. }
      { In IE ver. 5 szTip is 128 chars, before that only 64 chars. I suppose
        I could use GetComCtlVersion to check the version and then truncate
        the string accordingly, but Windows seems to handle this ok by itself. }
    else
      IconData.szTip := '';
    Result := True;
  end;
end;


function TCoolTrayIcon.ShowIcon: Boolean;
// Add/show the icon on the tray
begin
  Result := False;
  if not SettingPreview then
    FIconVisible := True;
  begin
    if (csDesigning in ComponentState) then
    begin
      if SettingPreview then
        if InitIcon then
          Result := Shell_NotifyIcon(NIM_ADD, @IconData);
    end
    else
    if InitIcon then
      Result := Shell_NotifyIcon(NIM_ADD, @IconData);
  end;
end;


function TCoolTrayIcon.HideIcon: Boolean;
// Remove/hide the icon from the tray
begin
  Result := False;
  if not SettingPreview then
    FIconVisible := False;
  begin
    if (csDesigning in ComponentState) then
    begin
      if SettingPreview then
        if InitIcon then
          Result := Shell_NotifyIcon(NIM_DELETE, @IconData);
    end
    else
    if InitIcon then
      Result := Shell_NotifyIcon(NIM_DELETE, @IconData);
  end;
end;


function TCoolTrayIcon.ModifyIcon: Boolean;
// Change icon or tooltip if icon already placed
begin
  Result := False;
  if InitIcon then
    Result := Shell_NotifyIcon(NIM_MODIFY, @IconData);
end;


function TCoolTrayIcon.ShowBalloonHint(Title: String; Text: String;
  IconType: TBalloonHintIcon; TimeoutSecs: TBalloonHintTimeOut): Boolean;
// Show balloon hint. Return false if error.
const
  aBalloonIconTypes: array[TBalloonHintIcon] of Byte =
    (_NIIF_NONE, _NIIF_INFO, _NIIF_WARNING, _NIIF_ERROR);
begin
  // Remove old balloon hint
  HideBalloonHint;
  // Display new balloon hint
  with IconData do
  begin
    uFlags := uFlags or _NIF_INFO;
    StrLCopy(szInfo, PChar(Text), SizeOf(szInfo)-1);
    StrLCopy(szInfoTitle, PChar(Title), SizeOf(szInfoTitle)-1);
    uTimeout := TimeoutSecs * 1000;
    dwInfoFlags := aBalloonIconTypes[IconType];
  end;
  Result := ModifyIcon;
  { Remove _NIF_INFO before next call to ModifyIcon (or the balloon hint
    will redisplay itself) }
  with IconData do
    uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
end;


function TCoolTrayIcon.HideBalloonHint: Boolean;
// Hide balloon hint. Return false if error.
begin
  with IconData do
  begin
    uFlags := uFlags or _NIF_INFO;
    StrPCopy(szInfo, '');
  end;
  Result := ModifyIcon;
end;


function TCoolTrayIcon.BitmapToIcon(const Bitmap: TBitmap;
  const Icon: TIcon; MaskColor: TColor): Boolean;
{ Render an icon from a 16x16 bitmap. Return false if error.
  MaskColor is a color that will be rendered transparently. Use clNone for
  no transparency. }
var
  BitmapImageList: TImageList;
begin
  BitmapImageList := TImageList.CreateSize(16, 16);
  try
    Result := False;
    BitmapImageList.AddMasked(Bitmap, MaskColor);
    BitmapImageList.GetIcon(0, Icon);
    Result := True;
  finally
    BitmapImageList.Free;
  end;
end;


function TCoolTrayIcon.GetClientIconPos(X, Y: Integer): TPoint;
// Return the cursor position inside the tray icon
const
  IconBorder = 1;
//  IconSize = 16;
var
  H: HWND;
  P: TPoint;
  IconSize: Integer;
begin
{ The CoolTrayIcon.Handle property is not the window handle of the tray icon.
  We can find the window handle via WindowFromPoint when the mouse is over
  the tray icon. (It can probably be found via GetWindowLong as well).

  BTW: The parent of the tray icon is the TASKBAR - not the traybar, which
  contains the tray icons and the clock. The traybar seems to be a canvas,
  not a real window (?). }

  // Get the icon size
  IconSize := GetSystemMetrics(SM_CYCAPTION) - 3;

  P.X := X;
  P.Y := Y;
  H := WindowFromPoint(P);
  { Convert current cursor X,Y coordinates to tray client coordinates.
    Add borders to tray icon size in the calculations. }
  Windows.ScreenToClient(H, P);
  P.X := (P.X mod ((IconBorder*2)+IconSize)) -1;
  P.Y := (P.Y mod ((IconBorder*2)+IconSize)) -1;
  Result := P;
end;


function TCoolTrayIcon.GetTooltipHandle: HWND;
{ All tray icons (but not the clock) share the same tooltip.
  Return the tooltip handle or 0 if error. }
var
  wnd, lTaskBar: HWND;
  pidTaskBar, pidWnd: DWORD;
begin
  // Get the TaskBar handle
  lTaskBar := FindWindowEx(0, 0, 'Shell_TrayWnd', nil);
  // Get the TaskBar Process ID
  GetWindowThreadProcessId(lTaskBar, @pidTaskBar);

  // Enumerate all tooltip windows
  wnd := FindWindowEx(0, 0, TOOLTIPS_CLASS, nil);
  while wnd <> 0 do
  begin
    // Get the tooltip process ID
    GetWindowThreadProcessId(wnd, @pidWnd);
    { Compare the process ID of the taskbar and the tooltip.
      If they are the same we have one of the taskbar tooltips. }
    if pidTaskBar = pidWnd then
       { Get the tooltip style. The tooltip for tray icons does not have the
         TTS_NOPREFIX style. }
      if (GetWindowLong(wnd, GWL_STYLE) and TTS_NOPREFIX) = 0 then
        Break;

    wnd := FindWindowEx(0, wnd, TOOLTIPS_CLASS, nil);
  end;
  Result := wnd;
end;


function TCoolTrayIcon.Refresh: Boolean;
// Refresh the icon
begin
  Result := ModifyIcon;
end;


procedure TCoolTrayIcon.PopupAtCursor;
var
  CursorPos: TPoint;
begin
  if Assigned(PopupMenu) then
    if PopupMenu.AutoPopup then
      if GetCursorPos(CursorPos) then
      begin
        // Bring the main form (or its modal dialog) to the foreground
        SetForegroundWindow(Application.Handle);
        { Win98 (unlike other Windows versions) empties a popup menu before
          closing it. This is a problem when the menu is about to display
          while it already is active (two click-events in succession). The
          menu will flicker annoyingly. Calling ProcessMessages fixes this. }
        Application.ProcessMessages;
        // Now make the menu pop up
        PopupMenu.PopupComponent := Self;
        PopupMenu.Popup(CursorPos.X, CursorPos.Y);
        // Remove the popup again in case user deselects it
        if Owner is TWinControl then   // Owner might be of type TService
          // Post an empty message to the owner form so popup menu disappears
          PostMessage((Owner as TWinControl).Handle, WM_NULL, 0, 0)
{
        else
          // Owner is not a form; send the empty message to the app.
          PostMessage(Application.Handle, WM_NULL, 0, 0);
}
      end;
end;


procedure TCoolTrayIcon.Click;
begin
  // Execute user-assigned method
  if Assigned(FOnClick) then
    FOnClick(Self);
end;


procedure TCoolTrayIcon.DblClick;
begin
  // Execute user-assigned method
  if Assigned(FOnDblClick) then
    FOnDblClick(Self);
end;


procedure TCoolTrayIcon.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  // Execute user-assigned method
  if Assigned(FOnMouseDown) then
    FOnMouseDown(Self, Button, Shift, X, Y);
end;


procedure TCoolTrayIcon.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  // Execute user-assigned method
  if Assigned(FOnMouseUp) then
    FOnMouseUp(Self, Button, Shift, X, Y);
end;


procedure TCoolTrayIcon.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  // Execute user-assigned method
  if Assigned(FOnMouseMove) then
    FOnMouseMove(Self, Shift, X, Y);
end;


procedure TCoolTrayIcon.MouseEnter;
begin
  // Execute user-assigned method
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;


procedure TCoolTrayIcon.MouseExit;
begin
  // Execute user-assigned method
  if Assigned(FOnMouseExit) then
    FOnMouseExit(Self);
end;


procedure TCoolTrayIcon.CycleIcon;
var
  NextIconIndex: Integer;
begin
  // Execute user-assigned method
  NextIconIndex := 0;
  if FIconList <> nil then
    if FIconIndex < FIconList.Count then
      NextIconIndex := FIconIndex +1;

  if Assigned(FOnCycle) then
    FOnCycle(Self, NextIconIndex);
end;


procedure TCoolTrayIcon.DoMinimizeToTray;
begin
  // Override this method to change automatic tray minimizing behavior
  HideMainForm;
  IconVisible := True;
end;


procedure TCoolTrayIcon.ShowMainForm;
begin
  if Owner is TWinControl then         // Owner might be of type TService
    if Application.MainForm <> nil then
    begin
      // Show application's TASKBAR icon (not the tray icon)
      Application.MainForm.Visible := True;
      ShowWindow(Application.Handle, SW_RESTORE);
//        ShowWindow(Application.Handle, SW_SHOWNORMAL);
//        Application.Restore;
      // Show the form itself
//      Application.MainForm.Visible := True;
//        ShowWindow((Owner as TWinControl).Handle, SW_RESTORE);
      if Application.MainForm.WindowState = wsMinimized then
        Application.MainForm.WindowState := wsNormal;
      // Bring the main form (or its modal dialog) to the foreground
      SetForegroundWindow(Application.Handle);
    end;
end;


procedure TCoolTrayIcon.HideMainForm;
begin
  if Owner is TWinControl then         // Owner might be of type TService
    if Application.MainForm <> nil then
    begin
      // Hide the form itself (and thus any child windows)
      Application.MainForm.Visible := False;
      { Hide application's TASKBAR icon (not the tray icon). Do this AFTER
        the mainform is hidden, or any child windows will redisplay the
        taskbar icon if they are visible. }
      ShowWindow(Application.Handle, SW_HIDE);
    end;
end;


initialization
  // Get shell version
  SHELL_VERSION := GetComCtlVersion;
  // Use the TaskbarCreated message available from Win98/IE4+
  if SHELL_VERSION >= ComCtlVersionIE4 then
    WM_TASKBARCREATED := RegisterWindowMessage('TaskbarCreated');

finalization
  if Assigned(TrayIconHandler) then
    FreeAndNil(TrayIconHandler);

end.

