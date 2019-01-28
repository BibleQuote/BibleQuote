unit NativeDictLoader;

interface

uses Types, IOUtils, SysUtils, DictLoaderInterface, EngineInterfaces, NativeDict,
     BibleqtIni;

type
  TNativeDictLoader = class(TInterfacedObject, IDictLoader)
  protected
    function LoadDictionary(aDictIdxFilePath : String; aBibleqtIni: TBibleqtIni): TNativeDict;

  public
    function LoadDictionaries(aFileEntryPath: String; aEngine: IbqEngineDicTraits): Boolean;

  end;

implementation

{ TNativeDictLoader }
uses ExceptionFrm;

function TNativeDictLoader.LoadDictionaries(aFileEntryPath: String;
  aEngine: IbqEngineDicTraits): Boolean;
var
  DictFileList: TStringDynArray;
  i: Integer;
  Dictionary: TNativeDict;
  BibleqtIni: TBibleqtIni;
begin

  BibleqtIni := TBibleqtIni.GetBibleqtIni(aFileEntryPath);
  try

    DictFileList := TDirectory.GetFiles(aFileEntryPath, '*.idx');
    for i := 0 to Length(DictFileList) - 1 do
    begin

      Dictionary := LoadDictionary(DictFileList[i], BibleqtIni);

      if Assigned(Dictionary) then
        aEngine.AddDictionary(Dictionary);

    end;

    Result := True;
  finally
    if Assigned(BibleqtIni) then
      FreeAndNil(BibleqtIni);
  end;

end;

function TNativeDictLoader.LoadDictionary(aDictIdxFilePath: String;
  aBibleqtIni: TBibleqtIni): TNativeDict;
var
  DictHtmlFilePath: string;
  Dictionary: TNativeDict;
begin
  Result := nil;
  try

    DictHtmlFilePath := ChangeFileExt(aDictIdxFilePath, '.htm');

    Dictionary := TNativeDict.Create;
    if not Dictionary.Initialize(aDictIdxFilePath, DictHtmlFilePath, aBibleqtIni) then
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
