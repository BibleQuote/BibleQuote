unit FileNameCommand;

interface
uses
  Winapi.Windows, Winapi.Messages, Dialogs, IOProcs, AppIni, ExceptionFrm,
  CommandInterface, CommandBase, MainFrm, BookFra, TabData, BibleQuoteUtils,
  DockTabsFrm, IOUtils, StringProcs, SysUtils, BibleLinkParser;

type
  TFileNameCommand = class(TCommandBase)
  private
  protected

  public
    constructor Create(MainView: TMainForm; Workspace: IWorkspace; BookView: TBookFrame; BookTabInfo: TBookTabInfo; Command: String);
    destructor Destroy(); override;

    function Execute(hlVerses: TbqHLVerseOption): Boolean; override;
  end;

implementation

constructor TFileNameCommand.Create(MainView: TMainForm; Workspace: IWorkspace; BookView: TBookFrame; BookTabInfo: TBookTabInfo; Command: String);
begin
  inherited Create(MainView, Workspace, BookView, BookTabInfo, Command);
end;

destructor TFileNameCommand.Destroy;
begin
  inherited;
end;

function TFileNameCommand.Execute(hlVerses: TbqHLVerseOption): Boolean;
begin
  try
    with FBookView do
    begin
      bwrHtml.LoadFromFile(bwrHtml.Base + FCommand);
      FBookTabInfo.Title := Format('%.12s', [FCommand]);

      FBookTabInfo.Location := FCommand;
      FBookTabInfo.LocationType := vtlFile;

      FBookTabInfo.IsCompareTranslation := False;
      FBookTabInfo.CompareTranslationText := '';
    end;
  except
    on E: Exception do
      BqShowException(E);
  end;
  Result := True;
end;

end.
