unit InputFrm;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TInputForm = class(TForm)
    edtValue: TEdit;
    btnOK: TButton;
    memValue: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CancelButtonClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InputForm: TInputForm;

implementation

{$R *.DFM}

procedure TInputForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TInputForm.btnOKClick(Sender: TObject);
begin
ModalResult := mrOK;
end;

procedure TInputForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    CancelButtonClick(Sender);
  end;

  if edtValue.Visible and (Key = #13) then
  begin
     Key := #0;
     btnOKClick(Sender);
  end;
end;

procedure TInputForm.FormShow(Sender: TObject);
begin
  {
     this input form can be used for entering text in TEdit or TMemo
     when tag = 0, it uses TEdit, and when tag = 1, it uses TMemo...

     the OK button's position and form height is set according to chosen option
  }

//  with InputForm do begin
//    Left := (Screen.Width-Width) div 2;
//    Top := (Screen.Height-Height) div 2;
//  end;

  if InputForm.Tag = 0 then // TEdit
  begin
    edtValue.Visible := true;
    memValue.Visible := false;

    edtValue.Top := 8;
    btnOK.Top := edtValue.Top + edtValue.Height + 10;
  end
  else begin
    edtValue.Visible := false;
    memValue.Visible := true;

    memValue.Top := 8;
    btnOK.Top := memValue.Top + memValue.Height + 10;
  end;

  InputForm.Height := btnOK.Top + btnOK.Height + 35;

  if edtValue.Visible then
  begin
    ActiveControl := edtValue;
  end else
    ActiveControl := memValue;
    
end;

end.
