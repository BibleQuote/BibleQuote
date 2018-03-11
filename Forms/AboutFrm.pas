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
    imgLogo: TImage;
    memDevs: TMemo;
    btnOK: TButton;
    pnlForum: TPanel;
    pnlDownloadLatest: TPanel;
    procedure pnlDownloadLatestMouseEnter(Sender: TObject);
    procedure pnlDownloadLatestMouseLeave(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnlForumClick(Sender: TObject);
    procedure pnlDownloadLatestClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses MainFrm, BibleQuoteUtils, BibleQuoteConfig;
{$R *.DFM}

procedure TAboutForm.pnlDownloadLatestClick(Sender: TObject);
begin
  MainForm.JCRU_HomeClick(MainForm.miDownloadLatest);
end;

procedure TAboutForm.pnlDownloadLatestMouseEnter(Sender: TObject);
begin
  Screen.Cursor := crHandPoint;
end;

procedure TAboutForm.pnlDownloadLatestMouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TAboutForm.pnlForumClick(Sender: TObject);
begin
  MainForm.JCRU_HomeClick(MainForm.miTechnoForum);
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  // DrawIconEx(Image1.Picture.Bitmap.Canvas.Handle, 0,0, Application.Icon.Handle,
  // 32,32,0,0,DI_NORMAL);
  // Image1.Picture.Icon.Assign(Application.Icon);
  memDevs.Lines.Insert(0, WideFormat('Версия %s (%s) BETA',
    [C_bqVersion, C_bqDate]));
  memDevs.Lines.Add('');
  memDevs.Lines.Add('OS:' + WinInfoString());

end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  if Pos('Russian', LastLanguageFile) <> 0 then
  begin
    lblTitle.Caption := 'Цитата из Библии 6';
  end
  else
  begin
    lblTitle.Caption := 'BibleQuote 6';
  end;
end;

end.
