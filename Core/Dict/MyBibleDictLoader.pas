unit MyBibleDictLoader;

interface

uses DictLoaderInterface, EngineInterfaces;

type
  TMyBibleDictLoader = class(TInterfacedObject, IDictLoader)
  public
    function LoadDictionaries(aDirPath: String; aEngine: IbqEngineDicTraits): Boolean;
  end;

implementation

{ TNativeDictLoader }

function TMyBibleDictLoader.LoadDictionaries(aDirPath: String;
  aEngine: IbqEngineDicTraits): Boolean;
begin
  Result := False;
end;

end.
