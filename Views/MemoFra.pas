unit MemoFra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TabData, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ToolWin, System.ImageList, Vcl.ImgList,
  Vcl.Menus, System.UITypes;

type
  TMemoFrame = class(TFrame, IMemoView)
    ilImages: TImageList;
    ilPictures24: TImageList;
    tlbMemo: TToolBar;
    tbtnMemoOpen: TToolButton;
    tbtnMemoSave: TToolButton;
    tbtnMemoPrint: TToolButton;
    tbtnSep1: TToolButton;
    tbtnMemoFont: TToolButton;
    tbtnSep2: TToolButton;
    tbtnMemoBold: TToolButton;
    tbtnMemoItalic: TToolButton;
    tbtnMemoUnderline: TToolButton;
    tbtnSep3: TToolButton;
    tbtnMemoPainter: TToolButton;
    pnlMemo: TPanel;
    lblMemo: TLabel;
    reMemo: TRichEdit;
    OpenDialog: TOpenDialog;
    SaveFileDialog: TSaveDialog;
    ColorDialog: TColorDialog;
    FontDialog: TFontDialog;
    PrintDialog: TPrintDialog;
    pmMemo: TPopupMenu;
    miMemoCopy: TMenuItem;
    miMemoCut: TMenuItem;
    miMemoPaste: TMenuItem;
    procedure reMemoChange(Sender: TObject);
    procedure tbtnMemoOpenClick(Sender: TObject);
    procedure tbtnMemoSaveClick(Sender: TObject);
    procedure tbtnMemoPrintClick(Sender: TObject);
    procedure tbtnMemoFontClick(Sender: TObject);
    procedure tbtnMemoBoldClick(Sender: TObject);
    procedure tbtnMemoItalicClick(Sender: TObject);
    procedure tbtnMemoUnderlineClick(Sender: TObject);
    procedure tbtnMemoPainterClick(Sender: TObject);
    procedure miMemoCopyClick(Sender: TObject);
    procedure miMemoCutClick(Sender: TObject);
    procedure miMemoPasteClick(Sender: TObject);
  private
    { Private declarations }

    MemoFilename: string;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TMemoFrame.miMemoCopyClick(Sender: TObject);
begin
  reMemo.CopyToClipboard
end;

procedure TMemoFrame.miMemoCutClick(Sender: TObject);
begin
  reMemo.CutToClipboard
end;

procedure TMemoFrame.miMemoPasteClick(Sender: TObject);
begin
  reMemo.PasteFromClipboard
end;

procedure TMemoFrame.reMemoChange(Sender: TObject);
begin
  reMemo.tag := 1;
end;

procedure TMemoFrame.tbtnMemoBoldClick(Sender: TObject);
begin
  if fsBold in reMemo.SelAttributes.Style then
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style - [fsBold]
  else
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style + [fsBold];
end;

procedure TMemoFrame.tbtnMemoFontClick(Sender: TObject);
begin
  with reMemo.SelAttributes do
  begin
    FontDialog.Font.Name := Name;
    FontDialog.Font.CharSet := CharSet;
    FontDialog.Font.Size := Size;
    FontDialog.Font.Style := Style;
    FontDialog.Font.color := color;
  end;

  if FontDialog.Execute then
    with reMemo.SelAttributes do
    begin
      Name := FontDialog.Font.Name;
      CharSet := FontDialog.Font.CharSet;
      Size := FontDialog.Font.Size;
      Style := FontDialog.Font.Style;
      color := FontDialog.Font.color;
    end;
end;

procedure TMemoFrame.tbtnMemoItalicClick(Sender: TObject);
begin
  if fsItalic in reMemo.SelAttributes.Style then
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style - [fsItalic]
  else
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style + [fsItalic];
end;

procedure TMemoFrame.tbtnMemoOpenClick(Sender: TObject);
begin
  OpenDialog.Filter := 'RTF (*.rtf)|*.rtf|DOC (*.doc)|*.doc|*.*|*.*';
  OpenDialog.FileName := MemoFilename;
  if OpenDialog.Execute then
  begin
    reMemo.Lines.LoadFromFile(OpenDialog.FileName);
    reMemo.tag := 0; // not changed

    MemoFilename := OpenDialog.FileName;
    lblMemo.Caption := ExtractFileName(MemoFilename);
  end;
end;

procedure TMemoFrame.tbtnMemoPainterClick(Sender: TObject);
begin
  ColorDialog.color := reMemo.Font.color;

  if ColorDialog.Execute then
    reMemo.SelAttributes.color := ColorDialog.color;
end;

procedure TMemoFrame.tbtnMemoPrintClick(Sender: TObject);
var
  opt: TPrintDialogOptions;
begin
  with PrintDialog do
  begin
    opt := options;
    options := [];
    if Execute then
      reMemo.Print('Printed by BibleQuote, http://JesusChrist.ru');
    options := opt;
  end;
end;

procedure TMemoFrame.tbtnMemoSaveClick(Sender: TObject);
var
  i: integer;
begin
  SaveFileDialog.DefaultExt := '.rtf';
  SaveFileDialog.Filter := 'RTF (*.rtf)|*.rtf|DOC (*.doc)|*.doc|*.*|*.*';
  SaveFileDialog.FileName := MemoFilename;
  if SaveFileDialog.Execute then
  begin
    MemoFilename := SaveFileDialog.FileName;
    i := Length(MemoFilename);

    if (SaveFileDialog.FilterIndex = 1) and (LowerCase(Copy(MemoFilename, i - 3, 4)) <> '.rtf') then
      MemoFilename := MemoFilename + '.rtf';

    if (SaveFileDialog.FilterIndex = 2) and (LowerCase(Copy(MemoFilename, i - 3, 4)) <> '.doc') then
      MemoFilename := MemoFilename + '.doc';

    reMemo.Lines.SaveToFile(MemoFilename, TEncoding.UTF8);
    reMemo.tag := 0; // not changed

    lblMemo.Caption := ExtractFileName(MemoFilename);
  end;
end;

procedure TMemoFrame.tbtnMemoUnderlineClick(Sender: TObject);
begin
  if fsUnderline in reMemo.SelAttributes.Style then
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style - [fsUnderline]
  else
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style + [fsUnderline];
end;

end.
