unit DictLoaderFabric;

interface

uses DictLoaderInterface, NativeDictLoader, MyBibleDictLoader;

type

  TDictTypes = (
    dtNative,
    dtMyBible);

  TDictLoaderFabric = class

  private
    class function CreateNativeDictLoader(): TNativeDictLoader;
    class function CreateMyBibleDictLoader(): TMyBibleDictLoader;

  public
    class function SelectDictTypeByDirName(aDirPath: String): TDictTypes;
    class function CreateDictLoader(aDictType: TDictTypes): IDictLoader;

  end;

implementation

{ TDictFabric }

class function TDictLoaderFabric.CreateDictLoader(aDictType: TDictTypes): IDictLoader;
begin

  case aDictType of
    dtNative: Result := CreateNativeDictLoader();
    dtMyBible: Result := CreateMyBibleDictLoader();
    else
      Result := nil;
  end;
end;

class function TDictLoaderFabric.CreateMyBibleDictLoader(): TMyBibleDictLoader;
begin
  Result := TMyBibleDictLoader.Create();
end;

class function TDictLoaderFabric.CreateNativeDictLoader(): TNativeDictLoader;
begin
  Result := TNativeDictLoader.Create();
end;

class function TDictLoaderFabric.SelectDictTypeByDirName(aDirPath: String): TDictTypes;
begin
  Result := dtNative;
end;

end.
