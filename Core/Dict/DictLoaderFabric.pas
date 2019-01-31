unit DictLoaderFabric;

interface

uses Classes, DictLoaderInterface, NativeDictLoader, MyBibleDictLoader,
     Generics.Collections, SelectEntityType;

type

  TDictLoaderFabric = class

  private
    class function CreateNativeDictLoader(): TNativeDictLoader;
    class function CreateMyBibleDictLoader(): TMyBibleDictLoader;

  public

    class function CreateDictLoader(aDictType: TDictTypes): IDictLoader;

  end;

implementation

{ TDictFabric }
uses SysUtils;

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

end.
