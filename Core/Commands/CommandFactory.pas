unit CommandFactory;

interface

uses CommandInterface, CommandFactoryInterface, LinksParserIntf, StringProcs,
  MainFrm, BookFra, TabData, DockTabsFrm, SysUtils;

type
  TCommandFactory = class(TInterfacedObject, ICommandFactory)
  private
    FBookView: TBookFrame;
    FMainView: TMainForm;
    FWorkspace: IWorkspace;
  public
    constructor Create(MainView: TMainForm; Workspace: IWorkspace; BookView: TBookFrame);
    function CreateCommand(BookTabInfo: TBookTabInfo; Command: String): ICommand;
  end;

implementation

uses GoCommand, FileCommand, FileNameCommand;

constructor TCommandFactory.Create(MainView: TMainForm; Workspace: IWorkspace; BookView: TBookFrame);
begin
  FMainView := MainView;
  FWorkspace := Workspace;
  FBookView := BookView;
end;

function TCommandFactory.CreateCommand(BookTabInfo: TBookTabInfo; Command: String): ICommand;
var
  BibleLink: TBibleLink;
  Path: String;
begin
  if BibleLink.FromBqStringLocation(Command, Path) then
    Result := TGoCommand.Create(FMainView, FWorkspace, FBookView, BookTabInfo, Command)
  else if (FirstWord(Command) = 'file') then
    Result := TFileCommand.Create(FMainView, FWorkspace, FBookView, BookTabInfo, Command)
  else if (ExtractFileName(Command) = Command) then
    Result := TFileNameCommand.Create(FMainView, FWorkspace, FBookView, BookTabInfo, Command)
  else
    Result := nil;
end;

end.
