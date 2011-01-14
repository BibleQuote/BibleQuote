unit BQExceptionTracker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls;

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
procedure BqShowException(e: Exception;addInfo:WideString='');
var
  bqExceptionForm: TbqExceptionForm;

implementation
uses TntClasses, JclDebug, TntControls;
{$R *.dfm}
procedure BqShowException(e: Exception;addInfo:WideString='');
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
  if length(addInfo)>0 then  lns.Insert(0,addInfo);
  iv:=Application.OnIdle; Application.OnIdle:=nil;
  bqExceptionForm.ShowModal();
  Application.OnIdle:=iv;
end;

procedure TbqExceptionForm.btnHaltClick(Sender: TObject);
begin
Halt(1);
end;

end.
