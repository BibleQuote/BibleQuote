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
    mNonContinuable:boolean;
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

  lns := TTntStringList.Create();
  try
  bqExceptionForm.mNonContinuable:=  bqExceptionForm.mNonContinuable or nonContinuable;
  lns.Clear;
  JclLastExceptStackListToStrings(lns.AnsiStrings,
    False, True, True, False);
  lns.Insert(0, WideFormat('Exception:%s, msg:%s', [E.ClassName, E.Message]));
  if g_ExceptionContext.Count>0 then
  lns.Insert(1, 'Context:'#13#10+g_ExceptionContext.Text);
  if length(addInfo)>0 then  lns.Insert(0,addInfo);
  iv:=Application.OnIdle; Application.OnIdle:=nil;
  bqExceptionForm.btnOK.Enabled:=not nonContinuable;
  lns.Add('OS info:'+WinInfoString());
  bqExceptionForm.ErrMemo.Lines.AddStrings(lns);
  if not bqExceptionForm.visible then begin
    bqExceptionForm.ShowModal();
    if nonContinuable then halt(1);
  end;

  finally
  bqExceptionForm.mNonContinuable:=false;
  lns.free();
  g_ExceptionContext.Clear();
  Application.OnIdle:=iv;
  end;
end;

procedure TbqExceptionForm.btnHaltClick(Sender: TObject);
begin
Halt(1);
end;

end.
