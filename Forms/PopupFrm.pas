unit PopupFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, Types, ComCtrls;

type
  TPopupMode = (pmStandard, pmCustom);

  TPopupMenu = class(Menus.TPopupMenu)
  private
    FPopupForm: TForm;
    FPopupMode: TPopupMode;
    FPopupCount: Integer;
    FPopupOpen: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Popup(X, Y: Integer); override;
    procedure PopupHide(Sender: TObject);

    property PopupForm: TForm read FPopupForm write FPopupForm;
    property PopupMode: TPopupMode read FPopupMode write FPopupMode;
    property PopupCount: Integer read FPopupCount write FPopupCount;
  end;

type
  TMenuItem = class(Menus.TMenuItem)
  end;

  TPopupForm = class(TForm)
  private
    FListBox: TListBox;
    FPopupForm: TForm;
    FPopupMenu: TPopupMenu;
    FPopupCount: Integer;
    FMouseCaptured: boolean;
    procedure WMActivate(var AMessage: TWMActivate); message WM_ACTIVATE;
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure ListBoxMeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
    procedure ListBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent; APopupForm: TForm; APopupMenu: TPopupMenu; APopupCount: Integer); reintroduce;

    property ListBox: TListBox read FListBox;
  end;

var
  PopupForm: TPopupForm;

implementation

{$R *.dfm}

{ TPopupForm }

constructor TPopupForm.Create(AOwner: TComponent; APopupForm: TForm; APopupMenu: TPopupMenu; APopupCount: Integer);
var
  I: Integer;
  MaxWidth: Integer;
  MaxHeight: Integer;
  ItemWidth: Integer;
  ItemHeight: Integer;
begin
  inherited Create(AOwner);
  BorderStyle := bsNone;

  FPopupForm := APopupForm;
  FPopupMenu := APopupMenu;
  FPopupCount := APopupCount;
  FMouseCaptured := false;

  FListBox := TListBox.Create(Self);
  FListBox.Parent := Self;
  FListBox.BorderStyle := bsNone;
  FListBox.Style := lbOwnerDrawVariable;
  FListBox.Color := clMenu;
  FListBox.Top := 2;
  FListBox.Left := 2;

  MaxWidth := 0;
  MaxHeight := 0;

  FListBox.Items.BeginUpdate;
  try
    FListBox.Items.Clear;
    for I := 0 to FPopupMenu.Items.Count - 1 do
    begin
      TMenuItem(FPopupMenu.Items[I]).MeasureItem(FListBox.Canvas, ItemWidth, ItemHeight);

      if ItemWidth > MaxWidth then
        MaxWidth := ItemWidth;

      if I < FPopupCount then
        MaxHeight := MaxHeight + ItemHeight;

      FListBox.Items.Add('');
    end;
  finally
    FListBox.Items.EndUpdate;
  end;

  if FPopupMenu.Items.Count > FPopupCount then
    MaxWidth := MaxWidth + GetSystemMetrics(SM_CXVSCROLL) + 16;

  FListBox.Width := MaxWidth;
  FListBox.Height := MaxHeight;
  FListBox.ItemHeight := ItemHeight;
  FListBox.OnMouseDown := ListBoxMouseDown;
  FListBox.OnMouseUp := ListBoxMouseUp;
  FListBox.OnDrawItem := ListBoxDrawItem;
  FListBox.OnKeyDown := ListBoxKeyDown;
  FListBox.OnMeasureItem := ListBoxMeasureItem;
  FListBox.OnMouseMove := ListBoxMouseMove;

  ClientWidth := FListBox.Width + 4;
  ClientHeight := FListBox.Height + 4;
end;

procedure TPopupForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure TPopupForm.ListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  DrawMenuItem(FPopupMenu.Items[Index], FListBox.Canvas, Rect, State);
end;

procedure TPopupForm.ListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Close;
    VK_RETURN:
    begin
      Close;
      if FListBox.ItemIndex <> -1 then
        FPopupMenu.Items[FListBox.ItemIndex].Click;
    end;
  end;
end;

procedure TPopupForm.ListBoxMeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
var
  ItemWidth: Integer;
begin
  TMenuItem(FPopupMenu.Items[Index]).MeasureItem(FListBox.Canvas, ItemWidth, Height);
end;

procedure TPopupForm.ListBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetCapture(FListBox.Handle);
  FMouseCaptured := true;
end;

procedure TPopupForm.ListBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  ItemIndex: Integer;
begin
  ItemIndex := FListBox.ItemAtPos(Point(X, Y), True);

  if ItemIndex <> FListBox.ItemIndex then
    FListBox.ItemIndex := ItemIndex;
end;

procedure TPopupForm.ListBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FMouseCaptured) then
  begin
    Close;
    if FListBox.ItemIndex <> -1 then
      FPopupMenu.Items[FListBox.ItemIndex].Click;
  end;

  FMouseCaptured := false;
end;

procedure TPopupForm.Paint;
begin
  inherited;
  Canvas.Pen.Color := clSilver;
  Canvas.Rectangle(ClientRect);
end;

procedure TPopupForm.WMActivate(var AMessage: TWMActivate);
begin
  SendMessage(FPopupForm.Handle, WM_NCACTIVATE, 1, 0);
  inherited;
  if AMessage.Active = WA_INACTIVE then
    Release;
end;

{ TPopupMenu }

constructor TPopupMenu.Create(AOwner: TComponent);
begin
  inherited;
  FPopupMode := pmStandard;
  FPopupCount := 5;
  FPopupOpen := false;
end;

procedure TPopupMenu.PopupHide(Sender: TObject);
begin
  FPopupOpen := false;
end;

procedure TPopupMenu.Popup(X, Y: Integer);
var
  LMonitor: TMonitor;
  APoint: TPoint;
  Popup: TPopupForm;
begin
  case FPopupMode of
    pmCustom: begin
      if (FPopupOpen) then
      begin
        FPopupOpen := false;
        Exit;
      end;

      Popup := TPopupForm.Create(nil, FPopupForm, Self, FPopupCount);
      with Popup do
      begin
        OnHide := PopupHide;
        APoint := TPoint.Create(X, Y);
        LMonitor := Screen.MonitorFromPoint(APoint);

        if (LMonitor <> nil) and ((GetSystemMetrics(SM_CYMENU) * Items.Count) + APoint.Y > LMonitor.Height) then
          Inc(APoint.Y, 22);

        Top := APoint.Y;
        Left := APoint.X;

        DoPopup(Popup);
        FPopupOpen := true;
        Show;
      end;
    end;
    pmStandard: inherited;
  end;
end;

end.

