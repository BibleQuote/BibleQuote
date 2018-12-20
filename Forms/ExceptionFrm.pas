unit ExceptionFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SystemInfo, IOUtils, System.ImageList, Vcl.ImgList,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

const
  HEIGHT_EXPANDED  = 400;
  HEIGHT_COLLAPSED = 170;

type
  TExceptionForm = class(TForm)
    imgError: TImage;
    btnOk: TButton;
    btnDetails: TButton;
    memDetails: TMemo;
    imgIcons: TImageList;
    lblStacktrace: TLabel;
    lblMessage: TLabel;
    procedure btnDetailsClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    mNonContinuable: boolean;
    procedure ToggleDetails(show: boolean);
  end;

procedure BqShowException(e: Exception; addInfo: string = ''; nonContinuable: boolean = false);
function StackLst(codePtr, stackTop: Pointer): string;

var
  ExceptionForm: TExceptionForm;

implementation

uses JclDebug, BibleQuoteUtils, PlainUtils, AppInfo, AppPaths;
{$R *.dfm}

var
  bqExceptionLog: TbqTextFileWriter;

function getExceptionLog(): TbqTextFileWriter;
begin
  if not assigned(bqExceptionLog) then
    bqExceptionLog := TbqTextFileWriter.Create(TPath.Combine(TAppDirectories.UserSettings, 'bqErr.log'));

  result := bqExceptionLog;
end;

function CloseLog(): HRESULT;
begin
  if assigned(bqExceptionLog) then
  begin
    FreeAndNil(bqExceptionLog);
    result := S_OK;
  end
  else
    result := S_FALSE;
end;

procedure BqShowException(e: Exception; addInfo: string = ''; nonContinuable: boolean = false);
var
  lines: TStrings;
  idle: TIdleEvent;
  exceptionLog: TbqTextFileWriter;
begin
  if not Assigned(ExceptionForm) then
  begin
    ExceptionForm := TExceptionForm.Create(Application);
    Lang.TranslateControl(ExceptionForm);
  end;

  exceptionLog := getExceptionLog();
  ExceptionForm.ToggleDetails(false);
  ExceptionForm.memDetails.Lines.clear();
  lines := TStringList.Create();
  idle := Application.OnIdle;
  Application.OnIdle := nil;
  try
    ExceptionForm.mNonContinuable := ExceptionForm.mNonContinuable or nonContinuable;

    ExceptionForm.lblMessage.Caption := E.Message;
    lines.clear;
    JclLastExceptStackListToStrings(lines, true, true, true, false);
    lines.Insert(0, Format('Exception:%s, msg:%s', [e.ClassName, e.Message]));

    if g_ExceptionContext.Count > 0 then
      lines.Insert(1, 'Context:'#13#10 + g_ExceptionContext.Text);

    if length(addInfo) > 0 then
      lines.Insert(0, addInfo);

    lines.Add('OS info:' + WinInfoString());
    lines.Add('version: ' + GetAppVersionStr());

    ExceptionForm.memDetails.Lines.AddStrings(lines);

    exceptionLog.WriteLine(NowDateTimeString() + ':');
    exceptionLog.WriteLine(lines.Text);
    exceptionLog.WriteLine('--------');

    if not ExceptionForm.Visible then
    begin
      ExceptionForm.ShowModal();
      if nonContinuable then
        halt(1);
    end;

  finally
    ExceptionForm.mNonContinuable := false;
    lines.Free();
    g_ExceptionContext.Clear();
    Application.OnIdle := idle;
  end;
end;

function StackLst(codePtr, stackTop: Pointer): string;
var
  stackInfo: TJclStackInfoList;
  sl: TStringList;
begin
  sl := nil;
  result := '';
  stackInfo := TJclStackInfoList.Create(true, 3, codePtr, false, nil, stackTop);

  if Assigned(stackInfo) then
  begin
    try
      sl := TStringList.Create();
      stackInfo.AddToStrings(sl, true, true, true);
      result := sl.Text;
    finally
      stackInfo.free();
      sl.free();
    end;
  end;

end;

procedure TExceptionForm.btnDetailsClick(Sender: TObject);
begin
  ToggleDetails(not memDetails.Visible);
end;

procedure TExceptionForm.btnOKClick(Sender: TObject);
begin
  if mNonContinuable then
  begin
    CloseLog();
    Halt(1);
  end;

  ModalResult := mrOk;
end;

procedure TExceptionForm.ToggleDetails(show: boolean);
begin
  memDetails.Visible := show;
  lblStacktrace.Visible := show;
  if (show) then
  begin
    self.Height := HEIGHT_EXPANDED;
    btnDetails.ImageIndex := 1;
  end
  else
  begin
    self.Height := HEIGHT_COLLAPSED;
    btnDetails.ImageIndex := 0;
  end;
  btnDetails.Invalidate;
  Invalidate;
end;

initialization

finalization

CloseLog();

end.
