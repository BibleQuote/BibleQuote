unit DictInterface;

interface

type

  IDict = interface
    ['{6601B354-9D14-4B4B-867A-CC5D17F5980F}']
    function GetWordCount(): Cardinal;
    function GetWord(aIndex: Cardinal): String;
    function GetName(): String;
    function Lookup(aWord: String): String;
  end;

implementation

end.
