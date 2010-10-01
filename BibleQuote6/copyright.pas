unit copyright;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics,
  Controls, Forms, TntForms, Dialogs,
  Htmlview, ShellAPI, StdCtrls, TntStdCtrls, ExtCtrls;

type
  TCopyrightForm = class(TTntForm)
    Browser: THTMLViewer;
    Shape1: TShape;
    imgModule: TImage;
    lbBQModName: TTntLabel;
    Shape2: TShape;
    Shape3: TShape;
    lblCopyRightNotice: TTntLabel;
    imgCopyRight: TImage;
    procedure BrowserHotSpotClick(Sender: TObject; const SRC: String;
      var Handled: Boolean);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormKeyPress(Sender: TObject; var Key: Char);
    procedure TntFormCreate(Sender: TObject);
    procedure BrowserKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CopyrightForm: TCopyrightForm;

implementation
uses main;
{$R *.DFM}

procedure TCopyrightForm.BrowserHotSpotClick(Sender: TObject;
  const SRC: String; var Handled: Boolean);
  var wsrc:WideString;
begin
  wsrc:=UTF8Decode(src);
  if Pos('editini=',src)=1 then begin
  wsrc:=Copy(wsrc,9,$FFF);
  ShellExecuteW(Application.Handle, nil, PWideChar(wSRC), nil, nil, SW_NORMAL);
  end
  else if Pos('http://', SRC) = 1 then // WWW
  begin
    ShellExecuteW(Application.Handle, nil, PWideChar(wSRC), nil, nil, SW_NORMAL);
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

procedure TCopyrightForm.BrowserKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case key of
VK_INSERT,$43: Browser.CopyToClipboard(); 
end;
end;

procedure TCopyrightForm.TntFormCreate(Sender: TObject);
var Icn:TIcon;
begin
Icn:=TIcon.Create;
MainForm.theImageList.GetIcon(38,Icn);
imgCopyRight.Picture.Graphic:=Icn;
Icn.Free;
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
