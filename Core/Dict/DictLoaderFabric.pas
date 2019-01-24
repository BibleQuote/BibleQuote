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
    class function IsNativeFileEntry(aFileEntryPath: String): Boolean;
    class function IsMyBibleFileEntry(aFileEntryPath: String): Boolean;

  public
    class function SelectDictTypeByDirName(aFileEntryPath: String): TDictTypes;
    class function CreateDictLoader(aDictType: TDictTypes): IDictLoader;

  end;

implementation

{ TDictFabric }
uses SysUtils, RegularExpressions;

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

class function TDictLoaderFabric.IsMyBibleFileEntry(
  aFileEntryPath: String): Boolean;
begin
  Result := FileExists(aFileEntryPath) and TRegEx.IsMatch(aFileEntryPath, '^.*\.dictionary\.SQLite3$')
end;

class function TDictLoaderFabric.IsNativeFileEntry(
  aFileEntryPath: String): Boolean;
begin
  Result := DirectoryExists(aFileEntryPath);
end;

class function TDictLoaderFabric.SelectDictTypeByDirName(aFileEntryPath: String): TDictTypes;
begin

  if IsMyBibleFileEntry(aFileEntryPath) then
  begin
    Result := dtMyBible;
    exit;
  end;

  if IsNativeFileEntry(aFileEntryPath) then
  begin
    Result := dtNative;
    exit;
  end;

  raise Exception.Create('Missing type of file entry: '+aFileEntryPath);

end;

end.
