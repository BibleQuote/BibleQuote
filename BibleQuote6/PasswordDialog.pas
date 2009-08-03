unit PasswordDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls;

type
  TfrmPassBox = class(TForm)
    lblPasswordNeeded: TTntLabel;
    btnOk: TTntButton;
    edPwd: TTntEdit;
    lblEnterPassword: TTntLabel;
    btnCancel: TTntButton;
    cbxSavePwd: TTntCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure edPwdKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPassBox: TfrmPassBox;

implementation
uses main;
{$R *.dfm}

procedure TfrmPassBox.edPwdKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key=13) then btnOk.Click();
end;

procedure TfrmPassBox.FormCreate(Sender: TObject);
begin
//lblPasswordNeeded:= Lang.SayDefault('PasswordNeeded',
//'Для открытия данного модуля нужно ввести пароль');
end;

end.
