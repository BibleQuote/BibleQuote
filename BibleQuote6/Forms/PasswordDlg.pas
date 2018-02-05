unit PasswordDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPasswordBox = class(TForm)
    lblPasswordNeeded: TLabel;
    btnOk: TButton;
    edPwd: TEdit;
    lblEnterPassword: TLabel;
    btnCancel: TButton;
    cbxSavePwd: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure edPwdKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PasswordBox: TPasswordBox;

implementation
uses MainFrm;
{$R *.dfm}

procedure TPasswordBox.edPwdKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key=13) then btnOk.Click();
end;

procedure TPasswordBox.FormCreate(Sender: TObject);
begin
//lblPasswordNeeded:= Lang.SayDefault('PasswordNeeded',
//'Для открытия данного модуля нужно ввести пароль');
end;

end.
