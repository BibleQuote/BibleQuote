unit DictLoaderInterface;

interface

uses EngineInterfaces;

type

  IDictLoader = interface
    ['{81908DE8-B605-43E1-97C5-4FA93E744458}']
    function LoadDictionaries(aDirPath: String; aEngine: IbqEngineDicTraits): Boolean;
  end;

implementation

end.
