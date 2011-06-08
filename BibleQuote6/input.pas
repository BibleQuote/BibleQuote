unit input;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, TntForms, Dialogs,
  TntStdCtrls, StdCtrls;

type
  TInputForm = class(TTntForm)
    Edit1: TTntEdit;
    OKButton: TTntButton;
    Memo1: TTntMemo;
    procedure TntFormShow(Sender: TObject);
    procedure TntFormKeyPress(Sender: TObject; var Key: Char);
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
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

procedure TInputForm.OKButtonClick(Sender: TObject);
begin
ModalResult := mrOK;
end;

procedure TInputForm.TntFormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    CancelButtonClick(Sender);
  end;

  if Edit1.Visible and (Key = #13) then
  begin
     Key := #0;
     OKButtonClick(Sender);
  end;
end;

procedure TInputForm.TntFormShow(Sender: TObject);
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
    Edit1.Visible := true;
    Memo1.Visible := false;

    Edit1.Top := 8;
    OKButton.Top := Edit1.Top + Edit1.Height + 10;
  end
  else begin
    Edit1.Visible := false;
    Memo1.Visible := true;

    Memo1.Top := 8;
    OKButton.Top := Memo1.Top + Memo1.Height + 10;
  end;

  InputForm.Height := OKButton.Top + OKButton.Height + 35;

  if Edit1.Visible then
  begin
    ActiveControl := Edit1;
  end else
    ActiveControl := Memo1;
    
end;

end.
