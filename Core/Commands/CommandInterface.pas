unit CommandInterface;

interface
  uses BibleQuoteUtils;

type

  ICommand = interface
    ['{2127A906-E879-4C1D-9F62-75FE72CD5781}']
    function Execute(hlVerses: TbqHLVerseOption): Boolean;
  end;

implementation

end.
