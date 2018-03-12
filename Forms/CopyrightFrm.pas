unit CopyrightFrm;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics,
  Controls, Forms, Dialogs,
  Htmlview, ShellAPI, StdCtrls, ExtCtrls, HTMLUn2, HTMLEmbedInterfaces;

type
  TCopyrightForm = class(TForm)
    bwrCopyright: THtmlViewer;
    shpHeader: TShape;
    imgModule: TImage;
    lblModName: TLabel;
    shpBody: TShape;
    shpFooter: TShape;
    lblCopyrightNotice: TLabel;
    imgCopyRight: TImage;
    procedure bwrCopyrightHotSpotClick(Sender: TObject; const SRC: String;
      var Handled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure bwrCopyrightKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CopyrightForm: TCopyrightForm;

implementation

uses MainFrm;
{$R *.DFM}

procedure TCopyrightForm.bwrCopyrightHotSpotClick(Sender: TObject;
  const SRC: String; var Handled: Boolean);
var
  wsrc: WideString;
begin
  wsrc := SRC;
  if Pos('editini=', SRC) = 1 then
  begin
    wsrc := Copy(wsrc, 9, $FFF);
    ShellExecuteW(Application.Handle, nil, PWideChar(wsrc), nil, nil,
      SW_NORMAL);
  end
  else if Pos('http://', SRC) = 1 then // WWW
  begin
    ShellExecuteW(Application.Handle, nil, PWideChar(wsrc), nil, nil,
      SW_NORMAL);
    Handled := true;
  end

end;

procedure TCopyrightForm.FormShow(Sender: TObject);
begin
  with CopyrightForm do
  begin
    Left := (Screen.Width - Width) div 2;
    Top := (Screen.Height - Height) div 2;
  end;
end;

procedure TCopyrightForm.bwrCopyrightKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_INSERT, $43:
      bwrCopyright.CopyToClipboard();
  end;
end;

procedure TCopyrightForm.FormCreate(Sender: TObject);
var
  Icn: TIcon;
begin
  Icn := TIcon.Create;
  MainForm.ilImages.GetIcon(38, Icn);
  imgCopyRight.Picture.Graphic := Icn;
  Icn.Free;
end;

procedure TCopyrightForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    Close;
  end;
end;

end.
