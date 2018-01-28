unit config;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, 
  Forms, FileCtrl, ExtCtrls, Buttons, StdCtrls, ComCtrls;

type
  TConfigForm = class(TForm)
    PageControl1: TPageControl;
    CopyOptionsTabSheet: TTabSheet;
    CopyVerseNumbers: TCheckBox;
    CopyFontParams: TCheckBox;
    AddReference: TCheckBox;
    AddReferenceRadio: TRadioGroup;
    AddModuleName: TCheckBox;
    AddLineBreaks: TCheckBox;
    OtherOptionsTabSheet: TTabSheet;
    OKButton: TButton;
    CancelButton: TButton;
    SelectSecondPathLabel: TLabel;
    SelectPathEdit: TEdit;
    SelectPathButton: TButton;
    DeleteButton: TButton;
    MinimizeToTray: TCheckBox;
    HotKeyChoice: TRadioGroup;
    FavouriteExTabSheet: TTabSheet;
    lblAvailableModules: TLabel;
    lblFavourites: TLabel;
    lbxFavourites: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbxAvailableModules: TComboBox;
    BitBtn3: TBitBtn;
    btnAddHotModule: TBitBtn;
    cbFullContextOnRestrictedLinks: TCheckBox;
    cbUseVerseHL: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SelectPathButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure LBButtonClick(Sender: TObject);
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

procedure TConfigForm.OKButtonClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;




procedure TConfigForm.LBButtonClick(Sender: TObject);
var itemIx, newItemIx, itemCount:integer;
     op:integer;
begin
itemIx:= lbxFavourites.ItemIndex; itemCount:=lbxFavourites.Count-1;
if (itemIx<0) or (itemIx>itemCount) then exit;
op:=(Sender as TBitBtn).Tag;
if op=0 then begin
 lbxFavourites.Items.Delete(itemIx);
 Dec(itemCount);
  if (itemCount>=0)then begin
    if  (itemIx>itemCount) then itemIx:=itemCount;
    lbxFavourites.ItemIndex:=itemIx;
 end;
 exit end;
newItemIx:=itemIx+ op;
if (newItemIx<0) or (newItemIx>itemCount) then exit;
lbxFavourites.Items.Move(itemIx, newItemIx);
lbxFavourites.ItemIndex:=newItemIx;
end;

procedure TConfigForm.btnAddHotModuleClick(Sender: TObject);
var ix, cnt:integer;
begin
cnt:=cbxAvailableModules.Items.Count;
ix:=cbxAvailableModules.ItemIndex;
if (ix<0) or (ix>=cnt) then exit;
ix:=lbxFavourites.Items.Add(cbxAvailableModules.Items[ix]);
lbxFavourites.ItemIndex:=ix;
end;

procedure TConfigForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TConfigForm.SelectPathButtonClick(Sender: TObject);
var
  s: string;
begin
  // ??? Как сработает ?
  if SelectDirectory(
    SelectSecondPathLabel.Caption,
    SelectPathEdit.Text,
    s
  ) then
  begin
    if s[Length(s)] <> '\' then
      s := s + '\';

    SelectPathEdit.Text := s;

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








procedure TConfigForm.DeleteButtonClick(Sender: TObject);
begin
  SelectPathEdit.Text := '';
end;

end.
