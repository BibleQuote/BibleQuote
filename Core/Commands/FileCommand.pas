unit FileCommand;

interface

uses
  Winapi.Windows, Winapi.Messages, Dialogs, IOProcs, AppIni, ExceptionFrm,
  CommandInterface, CommandBase, MainFrm, BookFra, TabData, BibleQuoteUtils,
  DockTabsFrm, IOUtils, StringProcs, SysUtils, BibleLinkParser;

type
  TFileCommand = class(TCommandBase)
  private
  protected

  public
    constructor Create(MainView: TMainForm; Workspace: IWorkspace; BookView: TBookFrame; BookTabInfo: TBookTabInfo; Command: String);
    destructor Destroy(); override;

    function Execute(hlVerses: TbqHLVerseOption): Boolean; override;
  end;

implementation

constructor TFileCommand.Create(MainView: TMainForm; Workspace: IWorkspace; BookView: TBookFrame; BookTabInfo: TBookTabInfo; Command: String);
begin
  inherited Create(MainView, Workspace, BookView, BookTabInfo, Command);
end;

destructor TFileCommand.Destroy;
begin
  inherited;
end;

function TFileCommand.Execute(hlVerses: TbqHLVerseOption): Boolean;
var
  wasSearchHistory: Boolean;
  i, j: Integer;
  browserpos: Integer;
  dup, value: String;
  path: String;
  dBrowserSource: String;
begin
  browserpos := FBookView.bwrHtml.Position;

  wasSearchHistory := false;
  dup := FCommand;
  // if a Bible path was stored with file... (after search procedure)
  i := Pos('***', dup);
  if i > 0 then
  begin
    j := Pos('$$$', dup);
    value := ResolveFullPath(TPath.Combine(Copy(dup, i + 3, j - i - 4), 'bibleqt.ini'));

    if FBookTabInfo.Bible.InfoSource.FileName <> value then
      FBookTabInfo.Bible.SetInfoSource(value);

    wasSearchHistory := true;
  end;

  DeleteFirstWord(dup);

  i := Pos('***', dup);
  if i = 0 then
    i := Length(dup);
  j := Pos('$$$', dup);

  if i > j then
    path := Copy(dup, 1, j - 1)
  else
    path := Copy(dup, 1, i - 1);

  if not FileExists(path) then
  begin
    ShowMessage(Format(Lang.Say('FileNotFound'), [path]));
    Result := False;
    Exit;
  end;

  FBookView.bwrHtml.Base := ExtractFilePath(path);
  ReadHtmlTo(path, dBrowserSource, TEncoding.GetEncoding(1251));

  if wasSearchHistory then
  begin
    StrReplace(dBrowserSource, '<*>', '<font color="' + Color2Hex(AppConfig.SelTextColor) + '">', true);
    StrReplace(dBrowserSource, '</*>', '</font>', true);
  end;

  if FBookTabInfo[vtisResolveLinks] then
  begin
    dBrowserSource := ResolveLinks(dBrowserSource, FBookTabInfo[vtisFuzzyResolveLinks]);
  end;

  with FBookView do
  begin
    bwrHtml.LoadFromString(dBrowserSource);
    value := '';
    if Trim(bwrHtml.DocumentTitle) <> '' then
      value := bwrHtml.DocumentTitle
    else
      value := ExtractFileName(path);
  end;

  if Length(value) <= 0 then
    try
      value := 'Unknown';
      raise Exception.Create('File open- cannot extract valid name');
    except
      on E: Exception do
        BqShowException(E);
    end;

  if (FBookTabInfo.History.Count > 0) and (FBookTabInfo.History[0] = FCommand) then
    FBookView.bwrHtml.Position := browserpos;

  FBookView.HistoryAdd(FCommand);

  if wasSearchHistory then
    FBookView.bwrHtml.tag := bsSearch
  else
    FBookView.bwrHtml.tag := bsFile;

  FBookTabInfo.Title := Format('%.12s', [value]);
  FBookTabInfo.Location := FCommand;
  FBookTabInfo.LocationType := vtlFile;

  FBookTabInfo.IsCompareTranslation := false;
  FBookTabInfo.CompareTranslationText := '';

  Result := True;
end;

end.
