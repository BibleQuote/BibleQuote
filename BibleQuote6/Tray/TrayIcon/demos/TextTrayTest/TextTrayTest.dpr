program TextTrayTest;

uses
  Forms,
  WinProcs,
  TtMain in 'TtMain.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'TextTrayIcon Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
