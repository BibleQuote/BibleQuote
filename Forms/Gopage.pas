unit Gopage;

interface

uses
  Classes, Graphics, Forms, Controls, Buttons, StdCtrls, ExtCtrls, Spin;

type
  TGoPageForm = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    Bevel1: TBevel;
    numPage: TSpinEdit;
    procedure numPageEnter(Sender: TObject);
    procedure numPageKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GoPageForm: TGoPageForm;

implementation

{$R *.DFM}

procedure TGoPageForm.numPageEnter(Sender: TObject);
begin
  numPage.SelectAll;
end;

procedure TGoPageForm.numPageKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
  Begin
    Key := 0;
    btnOK.Click;
  end;
end;

end.
