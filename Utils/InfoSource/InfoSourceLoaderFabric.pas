unit InfoSourceLoaderFabric;

interface

uses Classes, InfoSourceLoaderInterface, NativeInfoSourceLoader, MyBibleInfoSourceLoader,
     Generics.Collections, SelectEntityType;

type

  TInfoSourceLoaderFabric = class

  private
    class function CreateNativeInfoSourceLoader(): TNativeInfoSourceLoader;
    class function CreateMyBibleInfoSourceLoader(): TMyBibleInfoSourceLoader;

  public

    class function CreateInfoSourceLoader(aInfoSourceType: TInfoSourceTypes): IInfoSourceLoader;

  end;

implementation

{ TDictFabric }
uses SysUtils;

class function TInfoSourceLoaderFabric.CreateInfoSourceLoader(aInfoSourceType: TInfoSourceTypes): IInfoSourceLoader;
begin

  case aInfoSourceType of
    isNative: Result := CreateNativeInfoSourceLoader();
    isMyBible: Result := CreateMyBibleInfoSourceLoader();
    else
      Result := nil;
  end;
end;

class function TInfoSourceLoaderFabric.CreateMyBibleInfoSourceLoader(): TMyBibleInfoSourceLoader;
begin
  Result := TMyBibleInfoSourceLoader.Create();
end;

class function TInfoSourceLoaderFabric.CreateNativeInfoSourceLoader(): TNativeInfoSourceLoader;
begin
  Result := TNativeInfoSourceLoader.Create();
end;

end.
