program ChromeTabsDemoXE5;

uses
  Forms,
  frmMainU in 'frmMainU.pas' {frmMain},
  ChromeTabsLog in '..\Lib\ChromeTabsLog.pas',
  frameChromeTabStyleU in 'frameChromeTabStyleU.pas' {frameChromeTabStyle: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
