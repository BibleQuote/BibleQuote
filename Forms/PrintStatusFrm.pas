unit PrintStatusFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, HTMLView, MetaFilePrinter, MultiLanguage, BibleQuoteUtils;

type
  TPrnStatusForm = class(TForm)
    lblStatus: TLabel;
    btnCancel: TBitBtn;
    procedure btnCancelClick(Sender: TObject);
  private
    Viewer: ThtmlViewer;
    Canceled: boolean;
    MFPrinter: TMetaFilePrinter;
    FromPage, ToPage: integer;
    procedure PageEvent(Sender: TObject; PageNum: integer; var Stop: boolean);
  public
    procedure DoPreview(AViewer: ThtmlViewer; AMFPrinter: TMetaFilePrinter; var Abort: boolean);
    procedure DoPrint(AViewer: ThtmlViewer; FromPg, ToPg: integer; var Abort: boolean);
  end;

var
  PrnStatusForm: TPrnStatusForm;

implementation

{$R *.DFM}

procedure TPrnStatusForm.DoPreview(AViewer: ThtmlViewer;
  AMFPrinter: TMetaFilePrinter; var Abort: boolean);
begin
  Viewer := AViewer;
  MFPrinter := AMFPrinter;

  Viewer.OnPageEvent := PageEvent;

  try
    Show;
    Viewer.PrintPreview(MFPrinter);
    Hide;
    Abort := Canceled;
  finally
    Viewer.OnPageEvent := Nil;
  end;
end;

procedure TPrnStatusForm.DoPrint(AViewer: ThtmlViewer; FromPg, ToPg: integer; var Abort: boolean);
begin
  Viewer := AViewer;
  FromPage := FromPg;
  ToPage := ToPg;

  Viewer.OnPageEvent := PageEvent;

  try
    Show;
    Viewer.Print(FromPage, ToPage);
    Hide;
    Abort := Canceled;
  finally
    Viewer.OnPageEvent := Nil;
  end;
end;

procedure TPrnStatusForm.PageEvent(Sender: TObject; PageNum: integer; var Stop: boolean);
var
  S: String;
begin
  if Canceled then
    Stop := True
  else if PageNum = 0 then
    lblStatus.Caption := Lang.SayDefault('PrintStatusFormatting', 'Formatting...')
  else
  begin
    S := Lang.SayDefault('PrintStatusPage', 'Page Number %d');
    lblStatus.Caption := Format(S, [PageNum]);
  end;

  Update;
end;

procedure TPrnStatusForm.btnCancelClick(Sender: TObject);
begin
  Canceled := True;
end;

end.
