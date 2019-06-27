unit DictLoaderInterface;

interface

uses DictInterface;

type

  IDictLoader = interface
    ['{81908DE8-B605-43E1-97C5-4FA93E744458}']
    function LoadDictionaries(aFileEntryPath: String): IDict;
  end;

implementation

end.
