unit copyright;

interface

uses
  Windows, Messages, SysUtils, Classes, 
  Graphics,
  Controls, Forms, TntForms, Dialogs,
  Htmlview, ShellAPI;

type
  TCopyrightForm = class(TTntForm)
    Browser: THTMLViewer;
    procedure BrowserHotSpotClick(Sender: TObject; const SRC: String;
      var Handled: Boolean);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CopyrightForm: TCopyrightForm;

implementation

{$R *.DFM}

procedure TCopyrightForm.BrowserHotSpotClick(Sender: TObject;
  const SRC: String; var Handled: Boolean);
begin
  if Pos('http://', SRC) = 1 then // WWW
  begin
    ShellExecute(Application.Handle, nil, PChar(SRC), nil, nil, SW_NORMAL);
    Handled := true;
  end
end;

procedure TCopyrightForm.TntFormShow(Sender: TObject);
begin
  with CopyrightForm do
  begin
    Left := (Screen.Width-Width) div 2;
    Top := (Screen.Height-Height) div 2;
  end;
end;

procedure TCopyrightForm.TntFormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    Close;
  end;
end;

end.
