unit NativeDictLoader;

interface

uses Types, IOUtils, SysUtils, DictLoaderInterface, EngineInterfaces, Dict;

type
  TNativeDictLoader = class(TInterfacedObject, IDictLoader)
  public
    function LoadDictionaries(aDirPath: String; aEngine: IbqEngineDicTraits): Boolean;
  end;

implementation

{ TNativeDictLoader }

function TNativeDictLoader.LoadDictionaries(aDirPath: String;
  aEngine: IbqEngineDicTraits): Boolean;
var
  DictFileList: TStringDynArray;
  j: Integer;
  DictIdxFileName, DictHtmlFileName: string;
  Dictionary: TDict;
begin
  Result := False;

  DictFileList := TDirectory.GetFiles(aDirPath, '*.idx');
  for j := 0 to Length(DictFileList) - 1 do
  begin

    DictIdxFileName := DictFileList[j];
    DictHtmlFileName := ChangeFileExt(DictIdxFileName, '.htm');

    Dictionary := TDict.Create;
    if not Dictionary.Initialize(DictIdxFileName, DictHtmlFileName) then exit;

    aEngine.AddDictionary(Dictionary);

  end;

  Result := True;

end;

end.
