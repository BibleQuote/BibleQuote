unit BQExceptionTracker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls,WideStringsMod;

type
  TbqExceptionForm = class(TForm)
    ErrMemo: TTntMemo;
    lblLog: TTntLabel;
    btnOK: TTntButton;
    btnHalt: TTntButton;
    procedure btnHaltClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure BqShowException(e: Exception;addInfo:WideString=''; nonContinuable:boolean=false);
var
  bqExceptionForm: TbqExceptionForm;

implementation
uses TntClasses, JclDebug, TntControls,BibleQuoteUtils, JclSysInfo;
{$R *.dfm}
procedure BqShowException(e: Exception;addInfo:WideString=''; nonContinuable:boolean=false);
var
  lns: TTntStrings;
  iv:TIdleEvent;
begin
  if not assigned(bqExceptionForm) then
    bqExceptionForm := TbqExceptionForm.Create(Application);
  lns := bqExceptionForm.ErrMemo.Lines;
  lns.Clear;
  JclLastExceptStackListToStrings(bqExceptionForm.ErrMemo.Lines.AnsiStrings,
    False, True, True, False);
  lns.Insert(0, WideFormat('Exception:%s, msg:%s', [E.ClassName, E.Message]));
  if g_ExceptionContext.Count>0 then
  lns.Insert(1, 'Context:'#13#10+g_ExceptionContext.Text);
  if length(addInfo)>0 then  lns.Insert(0,addInfo);
  iv:=Application.OnIdle; Application.OnIdle:=nil;
  bqExceptionForm.btnOK.Enabled:=not nonContinuable;
  lns.Add('OS info:'+WinInfoString());
  bqExceptionForm.ShowModal();
  if nonContinuable then halt(1);
  g_ExceptionContext.Clear();
  Application.OnIdle:=iv;
end;

procedure TbqExceptionForm.btnHaltClick(Sender: TObject);
begin
Halt(1);
end;

end.
