unit PasswordDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls;

type
  TfrmPassBox = class(TForm)
    lblPasswordNeeded: TTntLabel;
    btnOk: TTntButton;
    TntEdit1: TTntEdit;
    lblEnterPassword: TTntLabel;
    btnAcqirePassword: TTntButton;
    btnCancel: TTntButton;
    procedure FormCreate(Sender: TObject);
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

procedure TfrmPassBox.FormCreate(Sender: TObject);
begin
//lblPasswordNeeded:= Lang.SayDefault('PasswordNeeded',
//'Для открытия данного модуля нужно ввести пароль');
end;

end.
