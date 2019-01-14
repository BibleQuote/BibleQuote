unit InputFrm;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  StdCtrls, AppIni;

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
    mMemo: boolean;
  public
    procedure SetFont(name: string; size: integer);
    procedure SelectInputText();
    function GetValue(): string;

    property IsMemo: boolean read mMemo write mMemo;
    class function CreateNew(caption: string; isMemo: boolean; defValue: string = ''): TInputForm; static;
    class function CreateText(caption: string; defValue: string = ''): TInputForm; static;
    class function CreateMemo(caption: string; defValue: string = ''): TInputForm; static;
  end;

implementation

{$R *.DFM}

class function TInputForm.CreateNew(caption: string; isMemo: boolean; defValue: string = ''): TInputForm;
var
  inputForm: TInputForm;
begin
  inputForm := TInputForm.Create(Application);
  inputForm.SetFont(AppConfig.MainFormFontName, AppConfig.MainFormFontSize);

  inputForm.IsMemo := isMemo;
  inputForm.Caption := caption;

  if isMemo then
    inputForm.memValue.Text := defValue
  else
    inputForm.edtValue.Text := defValue;

  Result := inputForm;
end;

class function TInputForm.CreateText(caption: string; defValue: string = ''): TInputForm;
begin
  Result := CreateNew(caption, false, defValue);
end;

class function TInputForm.CreateMemo(caption: string; defValue: string = ''): TInputForm;
begin
  Result := CreateNew(caption, true, defValue);
end;

function TInputForm.GetValue(): string;
begin
  if (isMemo) then
    Result := memValue.Text
  else
    Result := edtValue.Text;
end;

procedure TInputForm.SelectInputText();
begin
  if (isMemo) then
    memValue.SelectAll()
  else
    edtValue.SelectAll();
end;

procedure TInputForm.SetFont(name: string; size: integer);
begin
  Font.Name := name;
  Font.Size := size;
end;

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
  if not IsMemo then // TEdit
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

  Height := btnOK.Top + btnOK.Height + 35;

  if edtValue.Visible then
  begin
    ActiveControl := edtValue;
  end else
    ActiveControl := memValue;
    
end;

end.
