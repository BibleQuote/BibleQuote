program CoolTrayTest;

uses
  Forms,
  WinProcs,
  CtMain in 'CtMain.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'CoolTrayIcon Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
