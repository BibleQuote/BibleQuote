{ ************************************************************* }
{ *                                                           * }
{ *  Thanks to Chris Wallace for most of the ideas and        * }
{ *  code associated with Print Preview and the Preview Form  * }
{ *                                                           * }
{ ************************************************************* }

unit PreviewFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, MetaFilePrinter, HTMLView, PrintStatusFrm,
  MultiLanguage, BibleQuoteUtils;

const
  crZoom = 40;
  crHandDrag = 41;
  ZOOMFACTOR = 1.5;

type
  TPreviewForm = class(TForm)
    ToolBarPanel: TPanel;
    btnGrid: TSpeedButton;
    btnZoomCursor: TSpeedButton;
    btnHandCursor: TSpeedButton;
    btnOnePage: TSpeedButton;
    btnTwoPage: TSpeedButton;
    btnPrint: TBitBtn;
    btnNextPage: TBitBtn;
    btnPrevPage: TBitBtn;
    btnClose: TBitBtn;
    bxZoom: TComboBox;
    StatBarPanel: TPanel;
    lblCurPage: TPanel;
    lblZoom: TPanel;
    Panel1: TPanel;
    lblHint: TLabel;
    MoveButPanel: TPanel;
    spdFirstPage: TSpeedButton;
    spdPrevPage: TSpeedButton;
    spdNextPage: TSpeedButton;
    spdLastPage: TSpeedButton;
    spdPageNum: TSpeedButton;
    ScrollBox1: TScrollBox;
    ContainPanel: TPanel;
    PagePanel: TPanel;
    PB1: TPaintBox;
    PagePanel2: TPanel;
    PB2: TPaintBox;
    dlgPrint: TPrintDialog;
    btnFitPage: TSpeedButton;
    btnFitWidth: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    bxUnits: TComboBox;
    Bevel7: TBevel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ScrollBox1Resize(Sender: TObject);
    procedure PBPaint(Sender: TObject);
    procedure btnGridClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bxZoomChange(Sender: TObject);
    procedure btnTwoPageClick(Sender: TObject);
    procedure btnNextPageClick(Sender: TObject);
    procedure btnPrevPageClick(Sender: TObject);
    procedure spdFirstPageClick(Sender: TObject);
    procedure spdLastPageClick(Sender: TObject);
    procedure btnZoomCursorClick(Sender: TObject);
    procedure btnHandCursorClick(Sender: TObject);
    procedure PB1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PB1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PB1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnPrintClick(Sender: TObject);
    procedure spdPageNumClick(Sender: TObject);
    procedure btnOnePageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnFitPageClick(Sender: TObject);
    procedure btnFitWidthClick(Sender: TObject);
    procedure bxUnitsChange(Sender: TObject);
  private
    Viewer: ThtmlViewer;
  protected
    FCurPage: Integer;
    OldHint: TNotifyEvent;
    DownX, DownY: Integer;
    Moving: boolean;
    MFPrinter: TMetaFilePrinter;
    procedure DrawMetaFile(PB: TPaintBox; mf: TMetaFile);
    procedure OnHint(Sender: TObject);
    procedure SetCurPage(Val: Integer);
    procedure CheckEnable;
    property CurPage: Integer read FCurPage write SetCurPage;

    procedure FillZoomItems();
    procedure FillUnitItems();
  public
    Zoom: double;
    constructor CreateIt(AOwner: TComponent; AViewer: ThtmlViewer; var Abort: boolean);
    destructor Destroy; override;
  end;

implementation

uses
  Gopage;

{$R *.DFM}
{$R GRID.RES}

constructor TPreviewForm.CreateIt(AOwner: TComponent; AViewer: ThtmlViewer; var Abort: boolean);
var
  StatusForm: TPrnStatusForm;
begin
  inherited Create(AOwner);

  Lang.TranslateControl(Self, 'PreviewForm');
  FillZoomItems();
  FillUnitItems();

  bxZoom.ItemIndex := 0;
  bxUnits.ItemIndex := 0;

  Screen.Cursors[crZoom] := LoadCursor(hInstance, 'ZOOM_CURSOR');
  Screen.Cursors[crHandDrag] := LoadCursor(hInstance, 'HAND_CURSOR');

  btnZoomCursorClick(nil);

  Viewer := AViewer;
  MFPrinter := TMetaFilePrinter.Create(Self);
  StatusForm := TPrnStatusForm.Create(Self);

  Lang.TranslateControl(StatusForm, 'PrnStatusForm');

  try
    StatusForm.DoPreview(Viewer, MFPrinter, Abort);
  finally
    StatusForm.Free;
  end;
end;

destructor TPreviewForm.Destroy;
begin
  inherited;
end;

procedure TPreviewForm.FillZoomItems();
begin
  bxZoom.Clear;
  bxZoom.Items.Add(Lang.SayDefault('ZoomFitToPage', 'Fit To Page'));
  bxZoom.Items.Add(Lang.SayDefault('ZoomFitToWidth', 'Fit To Width'));
  bxZoom.Items.Add(Lang.SayDefault('ZoomCustom', 'Custom'));
  bxZoom.Items.AddStrings(['25%', '50%', '75%', '100%', '125%', '150%', '200%', '300%', '400%']);
end;

procedure TPreviewForm.FillUnitItems();
begin
  bxUnits.Clear;
  bxUnits.Items.Add(Lang.SayDefault('UnitsInches', 'Inches'));
  bxUnits.Items.Add(Lang.SayDefault('UnitsCentimeters', 'Centimeters'));
end;

procedure TPreviewForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TPreviewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Application.OnHint := OldHint;
  MFPrinter.Free;
end;

procedure TPreviewForm.ScrollBox1Resize(Sender: TObject);
const
  BORD = 20;
var
  z: double;
  tmp: Integer;
  TotWid: Integer;
begin
  case bxZoom.ItemIndex of
    0:
      btnFitPage.Down := True;
    1:
      btnFitWidth.Down := True;
  else
    begin
      btnFitPage.Down := False;
      btnFitWidth.Down := False;
    end;
  end;

  if bxZoom.ItemIndex = -1 then
    bxZoom.ItemIndex := 0;

  Case bxZoom.ItemIndex of
    0:
      z := ((ScrollBox1.ClientHeight - BORD) / PixelsPerInch) /
        (MFPrinter.PaperHeight / MFPrinter.PixelsPerInchY);
    1:
      z := ((ScrollBox1.ClientWidth - BORD) / PixelsPerInch) /
        (MFPrinter.PaperWidth / MFPrinter.PixelsPerInchX);
    2:
      z := Zoom;
    3:
      z := 0.25;
    4:
      z := 0.50;
    5:
      z := 0.75;
    6:
      z := 1.00;
    7:
      z := 1.25;
    8:
      z := 1.50;
    9:
      z := 2.00;
    10:
      z := 3.00;
    11:
      z := 4.00;
  else
    z := 1;
  end;

  if bxZoom.ItemIndex <> 0 then
    btnOnePage.Down := True;

  PagePanel.Height := TRUNC(PixelsPerInch * z * MFPrinter.PaperHeight /
    MFPrinter.PixelsPerInchY);
  PagePanel.Width := TRUNC(PixelsPerInch * z * MFPrinter.PaperWidth /
    MFPrinter.PixelsPerInchX);

  PagePanel2.Visible := btnTwoPage.Down;
  if btnTwoPage.Down then
  begin
    PagePanel2.Width := PagePanel.Width;
    PagePanel2.Height := PagePanel.Height;
  end;

  TotWid := PagePanel.Width + BORD;
  if btnTwoPage.Down then
    TotWid := TotWid + PagePanel2.Width + BORD;

  // Resize the Contain Panel
  tmp := PagePanel.Height + BORD;
  if tmp < ScrollBox1.ClientHeight then
    tmp := ScrollBox1.ClientHeight - 1;
  ContainPanel.Height := tmp;

  tmp := TotWid;
  if tmp < ScrollBox1.ClientWidth then
    tmp := ScrollBox1.ClientWidth - 1;
  ContainPanel.Width := tmp;

  // Center the Page Panel
  if PagePanel.Height + BORD < ContainPanel.Height then
    PagePanel.Top := ContainPanel.Height div 2 - PagePanel.Height div 2
  else
    PagePanel.Top := BORD div 2;
  PagePanel2.Top := PagePanel.Top;

  if TotWid < ContainPanel.Width then
    PagePanel.Left := ContainPanel.Width div 2 - (TotWid - BORD) div 2
  else
    PagePanel.Left := BORD div 2;
  PagePanel2.Left := PagePanel.Left + PagePanel.Width + BORD;

  { Make sure the scroll bars are hidden if not needed }
  if (PagePanel.Width + BORD <= ScrollBox1.Width) and
    (PagePanel.Height + BORD <= ScrollBox1.Height) then
  begin
    ScrollBox1.HorzScrollBar.Visible := False;
    ScrollBox1.VertScrollBar.Visible := False;
  end
  else
  begin
    ScrollBox1.HorzScrollBar.Visible := True;
    ScrollBox1.VertScrollBar.Visible := True;
  end;

  // Set the Zoom Variable
  Zoom := z;
  lblZoom.Caption := Format('%1.0n', [z * 100]) + '%';
end;

procedure TPreviewForm.DrawMetaFile(PB: TPaintBox; mf: TMetaFile);
begin
  PB.Canvas.Draw(0, 0, mf);
end;

procedure TPreviewForm.PBPaint(Sender: TObject);
var
  PB: TPaintBox;
  x1, y1: Integer;
  X, Y: Integer;
  Factor: double;
  Draw: boolean;
  Page: Integer;
begin
  PB := Sender as TPaintBox;

  if PB = PB1 then
  begin
    Draw := CurPage < MFPrinter.LastAvailablePage;
    Page := CurPage;
  end
  else
  begin
    // PB2
    Draw := btnTwoPage.Down and (CurPage + 1 < MFPrinter.LastAvailablePage);
    Page := CurPage + 1;
  end;

  SetMapMode(PB.Canvas.Handle, MM_ANISOTROPIC);
  SetWindowExtEx(PB.Canvas.Handle, MFPrinter.PaperWidth,
    MFPrinter.PaperHeight, nil);
  SetViewportExtEx(PB.Canvas.Handle, PB.Width, PB.Height, nil);
  SetWindowOrgEx(PB.Canvas.Handle, -MFPrinter.OffsetX, -MFPrinter.OffsetY, nil);
  if Draw then
    DrawMetaFile(PB, MFPrinter.MetaFiles[Page]);

  if btnGrid.Down then
  begin
    SetWindowOrgEx(PB.Canvas.Handle, 0, 0, nil);
    PB.Canvas.Pen.Color := clLtGray;
    if bxUnits.ItemIndex = 0 then
      Factor := 1.0
    else
      Factor := 2.54;

    for X := 1 to Round(MFPrinter.PaperWidth / MFPrinter.PixelsPerInchX *
      Factor) do
    begin
      x1 := Round(MFPrinter.PixelsPerInchX * X / Factor);
      PB.Canvas.MoveTo(x1, 0);
      PB.Canvas.LineTo(x1, MFPrinter.PaperHeight);
    end;

    for Y := 1 to Round(MFPrinter.PaperHeight / MFPrinter.PixelsPerInchY *
      Factor) do
    begin
      y1 := Round(MFPrinter.PixelsPerInchY * Y / Factor);
      PB.Canvas.MoveTo(0, y1);
      PB.Canvas.LineTo(MFPrinter.PaperWidth, y1);
    end;
  end;
end;

procedure TPreviewForm.btnGridClick(Sender: TObject);
begin
  PB1.Invalidate;
  PB2.Invalidate;
end;

procedure TPreviewForm.OnHint(Sender: TObject);
begin
  lblHint.Caption := Application.Hint;
end;

procedure TPreviewForm.FormShow(Sender: TObject);
begin
  CurPage := 0;
  OldHint := Application.OnHint;
  Application.OnHint := OnHint;
  CheckEnable;

  ScrollBox1Resize(Nil); { make sure it gets sized }
end;

procedure TPreviewForm.SetCurPage(Val: Integer);
var
  tmp: Integer;
begin
  FCurPage := Val;
  tmp := 0;
  if MFPrinter <> nil then
    tmp := MFPrinter.LastAvailablePage;
  lblCurPage.Caption := Format(Lang.SayDefault('PageOfPage', 'Page %d of %d'), [Val + 1, tmp]);
  PB1.Invalidate;
  PB2.Invalidate;
end;

procedure TPreviewForm.bxZoomChange(Sender: TObject);
begin
  ScrollBox1Resize(nil);
  ScrollBox1Resize(nil);
end;

procedure TPreviewForm.btnTwoPageClick(Sender: TObject);
begin
  bxZoom.ItemIndex := 0;
  ScrollBox1Resize(nil);
end;

procedure TPreviewForm.btnNextPageClick(Sender: TObject);
begin
  CurPage := CurPage + 1;
  CheckEnable;
end;

procedure TPreviewForm.btnPrevPageClick(Sender: TObject);
begin
  CurPage := CurPage - 1;
  CheckEnable;
end;

procedure TPreviewForm.CheckEnable;
begin
  btnNextPage.Enabled := CurPage + 1 < MFPrinter.LastAvailablePage;
  btnPrevPage.Enabled := CurPage > 0;

  spdNextPage.Enabled := btnNextPage.Enabled;
  spdPrevPage.Enabled := btnPrevPage.Enabled;

  spdFirstPage.Enabled := btnPrevPage.Enabled;
  spdLastPage.Enabled := btnNextPage.Enabled;

  spdPageNum.Enabled := MFPrinter.LastAvailablePage > 1;
end;

procedure TPreviewForm.spdFirstPageClick(Sender: TObject);
begin
  CurPage := 0;
  CheckEnable;
end;

procedure TPreviewForm.spdLastPageClick(Sender: TObject);
begin
  CurPage := MFPrinter.LastAvailablePage - 1;
  CheckEnable;
end;

procedure TPreviewForm.btnZoomCursorClick(Sender: TObject);
begin
  PB1.Cursor := crZoom;
  PB2.Cursor := crZoom;
end;

procedure TPreviewForm.btnHandCursorClick(Sender: TObject);
begin
  PB1.Cursor := crHandDrag;
  PB2.Cursor := crHandDrag;
end;

procedure TPreviewForm.PB1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  sx, sy: single;
  nx, ny: Integer;
begin
  if btnZoomCursor.Down then
  begin
    sx := X / PagePanel.Width;
    sy := Y / PagePanel.Height;

    if (ssLeft in Shift) and (Zoom < 20.0) then
      Zoom := Zoom * ZOOMFACTOR;
    if (ssRight in Shift) and (Zoom > 0.1) then
      Zoom := Zoom / ZOOMFACTOR;
    bxZoom.ItemIndex := 2;
    ScrollBox1Resize(nil);

    nx := TRUNC(sx * PagePanel.Width);
    ny := TRUNC(sy * PagePanel.Height);
    ScrollBox1.HorzScrollBar.Position := nx - ScrollBox1.Width div 2;
    ScrollBox1.VertScrollBar.Position := ny - ScrollBox1.Height div 2;
  end;

  if btnHandCursor.Down then
  begin
    DownX := X;
    DownY := Y;
    Moving := True;
  end;
end;

procedure TPreviewForm.PB1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if Moving then
  begin
    ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Position + (DownX - X);
    ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position + (DownY - Y);
  end;
end;

procedure TPreviewForm.PB1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Moving := False;
end;

procedure TPreviewForm.btnPrintClick(Sender: TObject);
var
  StatusForm: TPrnStatusForm;
  Dummy: boolean;
begin
  with dlgPrint do
  begin
    MaxPage := 9999;
    ToPage := 1;
    Options := [poPageNums];
    StatusForm := TPrnStatusForm.Create(Self);
    if Execute then
      if PrintRange = prAllPages then
        StatusForm.DoPrint(Viewer, FromPage, 9999, Dummy)
      else
        StatusForm.DoPrint(Viewer, FromPage, ToPage, Dummy);
    StatusForm.Free;
  end;
end;

procedure TPreviewForm.spdPageNumClick(Sender: TObject);
var
  gp: TGoPageForm;
begin
  gp := TGoPageForm.Create(Self);
  Lang.TranslateControl(gp, 'Gopage');

  gp.numPage.MaxValue := MFPrinter.LastAvailablePage;
  gp.numPage.Value := CurPage + 1;

  if gp.ShowModal = mrOK then
  begin
    CurPage := gp.numPage.Value - 1;
    CheckEnable;
  end;
  gp.Free;
end;

procedure TPreviewForm.btnOnePageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  bxZoom.ItemIndex := 0;
  ScrollBox1Resize(nil);
end;

procedure TPreviewForm.btnFitPageClick(Sender: TObject);
begin
  bxZoom.ItemIndex := 0;
  bxZoomChange(nil);
end;

procedure TPreviewForm.btnFitWidthClick(Sender: TObject);
begin
  bxZoom.ItemIndex := 1;
  bxZoomChange(nil);
end;

procedure TPreviewForm.bxUnitsChange(Sender: TObject);
begin
  if btnGrid.Down then
  begin
    PB1.Invalidate;
    PB2.Invalidate;
  end;
end;

end.
