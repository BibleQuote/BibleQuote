unit config;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls,
  Forms, TntForms,
  StdCtrls, TntStdCtrls,
  ComCtrls, TntComCtrls,
  TntFileCtrl, TntExtCtrls;

type
  TConfigForm = class(TTntForm)
    PageControl1: TTntPageControl;
    CopyOptionsTabSheet: TTntTabSheet;
    CopyVerseNumbers: TTntCheckBox;
    CopyFontParams: TTntCheckBox;
    AddReference: TTntCheckBox;
    AddReferenceRadio: TTntRadioGroup;
    AddModuleName: TTntCheckBox;
    AddLineBreaks: TTntCheckBox;
    FavoritesTabSheet: TTntTabSheet;
    OtherOptionsTabSheet: TTntTabSheet;
    Label1: TTntLabel;
    HotCB1: TTntComboBox;
    HotCB2: TTntComboBox;
    Label2: TTntLabel;
    Label5: TTntLabel;
    HotCB3: TTntComboBox;
    HotCB4: TTntComboBox;
    Label3: TTntLabel;
    Label7: TTntLabel;
    HotCB5: TTntComboBox;
    HotCB6: TTntComboBox;
    Label6: TTntLabel;
    Label9: TTntLabel;
    HotCB7: TTntComboBox;
    HotCB8: TTntComboBox;
    Label8: TTntLabel;
    Label11: TTntLabel;
    HotCB9: TTntComboBox;
    HotCB0: TTntComboBox;
    Label10: TTntLabel;
    OKButton: TTntButton;
    CancelButton: TTntButton;
    SelectSecondPathLabel: TTntLabel;
    SelectPathEdit: TTntEdit;
    SelectPathButton: TTntButton;
    DeleteButton: TTntButton;
    MinimizeToTray: TTntCheckBox;
    HotKeyChoice: TTntRadioGroup;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SelectPathButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
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

procedure TConfigForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TConfigForm.SelectPathButtonClick(Sender: TObject);
var
  s: WideString;
begin
  // ??? Как сработает ?
  if TntFileCtrl.WideSelectDirectory (
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
