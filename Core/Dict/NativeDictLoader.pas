unit NativeDictLoader;

interface

uses Types, IOUtils, SysUtils, DictLoaderInterface, EngineInterfaces, NativeDict,
     InfoSource;

type
  TNativeDictLoader = class(TInterfacedObject, IDictLoader)
  protected
    function LoadDictionary(aDictIdxFilePath : String; aInfoSource: TInfoSource): TNativeDict;

  public
    function LoadDictionaries(aFileEntryPath: String; aEngine: IbqEngineDicTraits): Boolean;

  end;

implementation

{ TNativeDictLoader }
uses ExceptionFrm, NativeInfoSourceLoader;

function TNativeDictLoader.LoadDictionaries(aFileEntryPath: String;
  aEngine: IbqEngineDicTraits): Boolean;
var
  DictFileList: TStringDynArray;
  Dictionary: TNativeDict;
  InfoSource: TInfoSource;
begin

  InfoSource := TNativeInfoSourceLoader.LoadNativeInfoSource(aFileEntryPath);
  try

    DictFileList := TDirectory.GetFiles(aFileEntryPath, '*.idx');
    if Length(DictFileList) > 0 then
    begin

      Dictionary := LoadDictionary(DictFileList[0], InfoSource);

      if Assigned(Dictionary) then
        aEngine.AddDictionary(Dictionary);

    end;

    Result := True;
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
