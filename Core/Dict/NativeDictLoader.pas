unit NativeDictLoader;

interface

uses Types, IOUtils, SysUtils, DictLoaderInterface, EngineInterfaces, NativeDict;

type
  TNativeDictLoader = class(TInterfacedObject, IDictLoader)
  protected
    function LoadDictionary(aDictIdxFilePath : String): TNativeDict;

  public
    function LoadDictionaries(aDirPath: String; aEngine: IbqEngineDicTraits): Boolean;

  end;

implementation

{ TNativeDictLoader }
uses ExceptionFrm;

function TNativeDictLoader.LoadDictionaries(aDirPath: String;
  aEngine: IbqEngineDicTraits): Boolean;
var
  DictFileList: TStringDynArray;
  i: Integer;
  Dictionary: TNativeDict;

begin

  DictFileList := TDirectory.GetFiles(aDirPath, '*.idx');
  for i := 0 to Length(DictFileList) - 1 do
  begin

    Dictionary := LoadDictionary(DictFileList[i]);

    if Assigned(Dictionary) then
      aEngine.AddDictionary(Dictionary);

  end;

  Result := True;

end;

function TNativeDictLoader.LoadDictionary(aDictIdxFilePath: String): TNativeDict;
var
  DictHtmlFilePath: string;
  Dictionary: TNativeDict;
begin
  Result := nil;
  try

    DictHtmlFilePath := ChangeFileExt(aDictIdxFilePath, '.htm');

    Dictionary := TNativeDict.Create;
    if not Dictionary.Initialize(aDictIdxFilePath, DictHtmlFilePath) then
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
