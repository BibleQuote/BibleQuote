unit BQExceptionTracker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntStdCtrls,WideStrings, StdCtrls;

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
function StackLst(codePtr,stackTop:Pointer):WideString;
var
  bqExceptionForm: TbqExceptionForm;

implementation
uses TntClasses, JclDebug, BibleQuoteUtils,BibleQuoteConfig,bqPlainUtils;
{$R *.dfm}
 var bqExceptionLog:TbqTextFileWriter;

function getExceptionLog():TbqTextFileWriter;
begin
  if not assigned(bqExceptionLog) then bqExceptionLog:=TbqTextFileWriter.Create(CreateAndGetConfigFolder()+'bqErr.log', );
  result:=bqExceptionLog;
end;

function CloseLog():HRESULT;
begin
if assigned(bqExceptionLog) then begin FreeAndNil(bqExceptionLog);result:=S_OK;end
else result:=S_FALSE;
end;
procedure BqShowException(e: Exception;addInfo:WideString=''; nonContinuable:boolean=false);
var
  lns: TTntStrings;
  iv:TIdleEvent;
  exceptionLog:TbqTextFileWriter;
begin

  if not assigned(bqExceptionForm) then
  bqExceptionForm := TbqExceptionForm.Create(Application);
  exceptionLog:= getExceptionLog();
  bqExceptionForm.ErrMemo.Lines.clear();
  lns := TTntStringList.Create();
  iv:=Application.OnIdle; Application.OnIdle:=nil;
  try
  bqExceptionForm.mNonContinuable:=  bqExceptionForm.mNonContinuable or nonContinuable;
  lns.Clear;
  JclLastExceptStackListToStrings(lns.AnsiStrings,
    true, True, True, False);
  lns.Insert(0, WideFormat('Exception:%s, msg:%s', [E.ClassName, E.Message]));
  if g_ExceptionContext.Count>0 then
  lns.Insert(1, 'Context:'#13#10+g_ExceptionContext.Text);
  if length(addInfo)>0 then  lns.Insert(0,addInfo);
  bqExceptionForm.btnOK.Enabled:=not nonContinuable;
  lns.Add('OS info:'+WinInfoString());
  lns.Add('bqVersion: '+C_bqVersion+' ('+C_bqDate+')');
  bqExceptionForm.ErrMemo.Lines.AddStrings(lns);
  exceptionLog.WriteUnicodeLine(bqNowDateTimeString()+':');
  exceptionLog.WriteUnicodeLine(lns.Text);
  exceptionLog.WriteUnicodeLine('--------');
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

function StackLst(codePtr,stackTop:Pointer):WideString;
var stackInfo:TJclStackInfoList;
    sl:TStringList;
begin
sl:=nil;
result:='';
stackInfo:=JclDebug.TJclStackInfoList.Create(True,3,codePtr,False,nil, stackTop);

if assigned (stackInfo) then begin try
sl:=TStringList.Create();
stackInfo.AddToStrings(sl,true,true,true);
result:=sl.text;
finally stackInfo.Free(); sl.Free(); end;
end;


end;

procedure TbqExceptionForm.btnHaltClick(Sender: TObject);
begin

CloseLog();
Halt(1);
end;
initialization
finalization
CloseLog();
end.
