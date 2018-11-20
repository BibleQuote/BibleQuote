unit AboutFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Vcl.Imaging.PngImage, Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg;

type
  TAboutForm = class(TForm)
    imgBackground: TImage;
    lblDevs: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure imgBackgroundClick(Sender: TObject);
    procedure lblDevsClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses AppInfo;
{$R *.DFM}

procedure TAboutForm.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  lblDevs.Caption := String.Join(sLineBreak,
    ['Версия ' + GetAppVersionStr(),
     '',
     'Благодарности:',
     'Александр Снигерев, Samuel A. Kim, Тимофей Ха']);
end;

procedure TAboutForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
  if Key = VK_RETURN then Close;
end;

procedure TAboutForm.imgBackgroundClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutForm.lblDevsClick(Sender: TObject);
begin
  Close;
end;

end.
