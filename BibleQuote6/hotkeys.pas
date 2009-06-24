unit hotkeys;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls,
  Forms, TntForms,
  StdCtrls, TntStdCtrls;

type
  THotKeyForm = class(TTntForm)
    Label10: TTntLabel;
    Label11: TTntLabel;
    Label8: TTntLabel;
    Label9: TTntLabel;
    Label6: TTntLabel;
    Label7: TTntLabel;
    Label3: TTntLabel;
    Label1: TTntLabel;
    Label2: TTntLabel;
    Label5: TTntLabel;
    HotCB1: TTntComboBox;
    HotCB2: TTntComboBox;
    HotCB3: TTntComboBox;
    HotCB4: TTntComboBox;
    HotCB5: TTntComboBox;
    HotCB6: TTntComboBox;
    HotCB7: TTntComboBox;
    HotCB8: TTntComboBox;
    HotCB9: TTntComboBox;
    HotCB0: TTntComboBox;
    HotKeyOKButton: TTntButton;
    HotKeyCancelButton: TTntButton;
    procedure HotKeyOKButtonClick(Sender: TObject);
    procedure HotKeyCancelButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HotKeyForm: THotKeyForm;

implementation

{$R *.DFM}

procedure THotKeyForm.HotKeyOKButtonClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure THotKeyForm.HotKeyCancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure THotKeyForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(27) then
    ModalResult := mrOK;
end;

end.
