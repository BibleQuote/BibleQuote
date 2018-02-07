unit ConfigFrm;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls,
  Forms, FileCtrl, ExtCtrls, Buttons, StdCtrls, ComCtrls;

type
  TConfigForm = class(TForm)
    pgcOptions: TPageControl;
    tsCopyOptions: TTabSheet;
    chkCopyVerseNumbers: TCheckBox;
    chkCopyFontParams: TCheckBox;
    chkAddReference: TCheckBox;
    rgAddReference: TRadioGroup;
    chkAddModuleName: TCheckBox;
    chkAddLineBreaks: TCheckBox;
    tsOtherOptions: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    lblSelectSecondPath: TLabel;
    edtSelectPath: TEdit;
    btnSelectPath: TButton;
    btnDeletePath: TButton;
    chkMinimizeToTray: TCheckBox;
    rgHotKeyChoice: TRadioGroup;
    tsFavouriteEx: TTabSheet;
    lblAvailableModules: TLabel;
    lblFavourites: TLabel;
    lbFavourites: TListBox;
    bbtnUp: TBitBtn;
    bbtnDown: TBitBtn;
    cbAvailableModules: TComboBox;
    bbtnDelete: TBitBtn;
    btnAddHotModule: TBitBtn;
    chkFullContextOnRestrictedLinks: TCheckBox;
    chkHighlightVerseHits: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSelectPathClick(Sender: TObject);
    procedure btnDeletePathClick(Sender: TObject);
    procedure favouritesBitBtnClick(Sender: TObject);
    procedure btnAddHotModuleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfigForm: TConfigForm;

implementation

{$R *.DFM}

procedure TConfigForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(27) then
    ModalResult := mrCancel;
end;

procedure TConfigForm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TConfigForm.favouritesBitBtnClick(Sender: TObject);
var
  itemIx, newItemIx, itemCount: integer;
  op: integer;
begin
  itemIx := lbFavourites.ItemIndex;
  itemCount := lbFavourites.Count - 1;
  if (itemIx < 0) or (itemIx > itemCount) then
    exit;
  op := (Sender as TBitBtn).Tag;
  if op = 0 then
  begin
    lbFavourites.Items.Delete(itemIx);
    Dec(itemCount);
    if (itemCount >= 0) then
    begin
      if (itemIx > itemCount) then
        itemIx := itemCount;
      lbFavourites.ItemIndex := itemIx;
    end;
    exit
  end;
  newItemIx := itemIx + op;
  if (newItemIx < 0) or (newItemIx > itemCount) then
    exit;
  lbFavourites.Items.Move(itemIx, newItemIx);
  lbFavourites.ItemIndex := newItemIx;
end;

procedure TConfigForm.btnAddHotModuleClick(Sender: TObject);
var
  ix, cnt: integer;
begin
  cnt := cbAvailableModules.Items.Count;
  ix := cbAvailableModules.ItemIndex;
  if (ix < 0) or (ix >= cnt) then
    exit;
  ix := lbFavourites.Items.Add(cbAvailableModules.Items[ix]);
  lbFavourites.ItemIndex := ix;
end;

procedure TConfigForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TConfigForm.btnSelectPathClick(Sender: TObject);
var
  s: string;
begin
  // ??? Как сработает ?
  if SelectDirectory(lblSelectSecondPath.Caption, edtSelectPath.Text, s) then
  begin
    if s[Length(s)] <> '\' then
      s := s + '\';

    edtSelectPath.Text := s;

  end;

  {
    with BrowseDir1 do
    begin
    Caption := Application.Title;
    Title := SelectSecondPathLabel.Caption;
    Selection := SelectPathEdit.Text;
    end;

    if BrowseDir1.Execute then
    begin
    s := BrowseDir1.Selection;

    if s[Length(s)] <> '\'
    then s := s + '\';

    SelectPathEdit.Text := s;
    end;
  }
end;

procedure TConfigForm.btnDeletePathClick(Sender: TObject);
begin
  edtSelectPath.Text := '';
end;

end.
