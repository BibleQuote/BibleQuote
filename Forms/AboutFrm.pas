unit AboutFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Vcl.Imaging.PngImage, Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg;

type
  TAboutForm = class(TForm)
    shpHeader: TShape;
    lblTitle: TLabel;
    memDevs: TMemo;
    btnOK: TButton;

    procedure FormCreate(Sender: TObject);

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

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  memDevs.Lines.Insert(0, 'Версия ' + GetAppVersionStr());
end;

end.
