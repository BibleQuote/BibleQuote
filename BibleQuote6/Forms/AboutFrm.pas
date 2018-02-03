﻿unit AboutFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, PngImage1, Vcl.Imaging.jpeg, Vcl.Imaging.GIFImg ;

type
  TAboutForm = class(TForm)
    Shape1: TShape;
    lbBQName: TLabel;
    Image1: TImage;
    memDevs: TMemo;
    btnOK: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure TntLabel1Click(Sender: TObject);
    procedure Panel2MouseEnter(Sender: TObject);
    procedure Panel2MouseLeave(Sender: TObject);

    procedure TntFormShow(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);

  private
  cnt:integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation
  uses MainFrm,BibleQuoteUtils,BibleQuoteConfig;
{$R *.DFM}

procedure TAboutForm.Panel2MouseEnter(Sender: TObject);
begin
Screen.Cursor:=crHandPoint;

end;

procedure TAboutForm.Panel2MouseLeave(Sender: TObject);
begin
Screen.Cursor:=crDefault;
end;





procedure TAboutForm.TntFormCreate(Sender: TObject);
begin
//DrawIconEx(Image1.Picture.Bitmap.Canvas.Handle, 0,0, Application.Icon.Handle,
//32,32,0,0,DI_NORMAL);
//Image1.Picture.Icon.Assign(Application.Icon);
memDevs.Lines.Insert(0,
       WideFormat('Версия %s (%s) BETA', [C_bqVersion,C_bqDate])   );
memDevs.Lines.Add('');
memDevs.Lines.Add('OS:'+WinInfoString());

end;

procedure TAboutForm.TntFormShow(Sender: TObject);
begin
if Pos('Russian',LastLanguageFile)<>0 then begin
lbBQName.Caption:='Цитата из Библии 6';
end
else begin
lbBQName.Caption:='BibleQuote 6';
end;
end;

procedure TAboutForm.TntLabel1Click(Sender: TObject);
begin
if (sender as TComponent).Tag=1 then
MainForm.JCRU_HomeClick(MainForm.miDownloadLatest)
else
MainForm.JCRU_HomeClick(MainForm.miTechnoForum);

end;

end.
