unit CommandBase;

interface

uses CommandInterface, TabData, BookFra, IOUtils, SysUtils, BibleQuoteConfig,
  MainFrm, LinksParserIntf, BibleQuoteUtils, DockTabsFrm;

type
  TCommandBase = class(TInterfacedObject, ICommand)
  protected
    FBookView: TBookFrame;
    FMainView: TMainForm;
    FWorkspace: IWorkspace;
    FCommand: String;

    FBibleLink: TBibleLinkEx;
    FBookTabInfo: TBookTabInfo;
    FOldPath: String;
    FOldBook, FOldChapter: Integer;
  public
    constructor Create(MainView: TMainForm; Workspace: IWorkspace; BookView: TBookFrame; BookTabInfo: TBookTabInfo; Command: String);
    destructor Destroy; override;

    function Execute(hlVerses: TbqHLVerseOption): Boolean; virtual; abstract;
    procedure RevertLocation(BibleLink: TBibleLinkEx);
  end;

implementation

constructor TCommandBase.Create(MainView: TMainForm; Workspace: IWorkspace; BookView: TBookFrame; BookTabInfo: TBookTabInfo; Command: String);
begin
  FMainView := MainView;
  FWorkspace := Workspace;
  FBookView := BookView;
  FBookTabInfo := BookTabInfo;
  FCommand := Command;

  with BookTabInfo.Bible do
  begin
    FOldPath := InfoSource.FileName;
    FOldBook := CurBook;
    FoldChapter := CurChapter;
  end;
end;

destructor TCommandBase.Destroy;
begin
  inherited;
end;

procedure TCommandBase.RevertLocation(BibleLink: TBibleLinkEx);
var Path: String;
begin
  Path := FOldPath;
  if Path = '' then
  begin
    Path := ResolveFullPath(TPath.Combine(FMainView.mDefaultLocation, C_ModuleIniName));
    if FBookView.bwrHtml.GetTextLen() <= 0 then
    begin
      try
        FBookView.ProcessCommand(FBookTabInfo, Format('go %s 1 1 1', [FMainView.mDefaultLocation]), hlFalse);
      except
        // skip error
      end;
      Exit;
    end;
  end;

  FBookTabInfo.Bible.SetInfoSource(Path);
  BibleLink.modName := FBookTabInfo.Bible.ShortPath;
  BibleLink.book := FOldBook;
  BibleLink.chapter := FOldChapter;

  FMainView.UpdateBookView();
end;


end.
