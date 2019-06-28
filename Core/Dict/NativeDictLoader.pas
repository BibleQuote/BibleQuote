unit NativeDictLoader;

interface

uses Types, IOUtils, SysUtils, DictLoaderInterface, NativeDict,
     InfoSource, DictInterface;

type
  TNativeDictLoader = class(TInterfacedObject, IDictLoader)
  protected
    function LoadDictionary(aDictIdxFilePath : String; aInfoSource: TInfoSource): TNativeDict; overload;

  public
    function LoadDictionary(aFileEntryPath: String): IDict; overload;

  end;

implementation

{ TNativeDictLoader }
uses ExceptionFrm, NativeInfoSourceLoader;

function TNativeDictLoader.LoadDictionary(aFileEntryPath: String): IDict;
var
  DictFileList: TStringDynArray;
  Dictionary: TNativeDict;
  InfoSource: TInfoSource;
begin
  Result := nil;

  InfoSource := TNativeInfoSourceLoader.LoadNativeInfoSource(aFileEntryPath);
  try

    DictFileList := TDirectory.GetFiles(aFileEntryPath, '*.idx');
    if Length(DictFileList) > 0 then
    begin

      Dictionary := LoadDictionary(DictFileList[0], InfoSource);

      if Assigned(Dictionary) then
        Result := Dictionary;

    end;
  finally
    if Assigned(InfoSource) then
      FreeAndNil(InfoSource);
  end;

end;

function TNativeDictLoader.LoadDictionary(aDictIdxFilePath: String;
  aInfoSource: TInfoSource): TNativeDict;
var
  DictHtmlFilePath: string;
  Dictionary: TNativeDict;
begin
  Result := nil;
  try

    DictHtmlFilePath := ChangeFileExt(aDictIdxFilePath, '.htm');

    Dictionary := TNativeDict.Create;
    if not Dictionary.Initialize(aDictIdxFilePath, DictHtmlFilePath, aInfoSource) then
    begin
      raise Exception.Create('Error loading '+ExtractFileName(aDictIdxFilePath)+ 'dictionary');
    end;

    Result := Dictionary;

  except
    on e: Exception do
    begin
      BqShowException(e);
    end;

  end;

end;

end.
