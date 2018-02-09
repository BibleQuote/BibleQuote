unit PasswordDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPasswordBox = class(TForm)
    lblPasswordNeeded: TLabel;
    btnOk: TButton;
    edtPwd: TEdit;
    lblEnterPassword: TLabel;
    btnCancel: TButton;
    chkSavePwd: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure edtPwdKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TPasswordBox.edtPwdKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 13) then
    btnOk.Click();
end;

procedure TPasswordBox.FormCreate(Sender: TObject);
begin
  // lblPasswordNeeded:= Lang.SayDefault('PasswordNeeded',
  // 'Для открытия данного модуля нужно ввести пароль');
end;

end.
