unit CommandFactoryInterface;

interface
uses CommandInterface, TabData;

type

  ICommandFactory = interface
    ['{15214224-1789-4CD3-8E83-44FE979B65A7}']
    function CreateCommand(BookTabInfo: TBookTabInfo; Command: String): ICommand;
  end;

implementation

end.
