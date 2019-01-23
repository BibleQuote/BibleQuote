unit DictLoaderFabric;

interface

uses Classes, DictLoaderInterface, NativeDictLoader, MyBibleDictLoader,
     Generics.Collections;

type

  TDictTypes = (
    dtNative,
    dtMyBible);

  TDictLoaderFabric = class

  private
    class function CreateNativeDictLoader(): TNativeDictLoader;
    class function CreateMyBibleDictLoader(): TMyBibleDictLoader;
    class procedure FillDictTypeAbbrs(aDictTypesMap: TDictionary<String, TDictTypes>);

  public
    class function SelectDictTypeByDirName(aDirPath: String): TDictTypes;
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

class procedure TDictLoaderFabric.FillDictTypeAbbrs(
  aDictTypesMap: TDictionary<String, TDictTypes>);
begin
  aDictTypesMap.Add('MB', dtMyBible);
end;

class function TDictLoaderFabric.SelectDictTypeByDirName(aDirPath: String): TDictTypes;
var
  DictDirName: String;
  Parts: TStringList;
  DictTypeAbbrs: TDictionary<String, TDictTypes>;
  DictTypeAbbr: String;
begin
  Result := dtNative;

  DictTypeAbbrs := TDictionary<String, TDictTypes>.Create();
  FillDictTypeAbbrs(DictTypeAbbrs);

  DictDirName := ExtractFileName(aDirPath);

  Parts := TStringList.Create;
  try
    ExtractStrings(['_'], [], PChar(DictDirName), Parts);

    if Parts.Count <= 4 then exit;

    DictTypeAbbr := Parts[3];

    if DictTypeAbbrs.ContainsKey(DictTypeAbbr) then
    begin
      Result := DictTypeAbbrs[DictTypeAbbr]
    end
    else
      raise Exception.Create(Format('Unexpected dictionary type abbreviation %s', [DictTypeAbbr]) );

  finally
    Parts.Free;
    DictTypeAbbrs.Free;
  end;

end;

end.
