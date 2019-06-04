unit MyBibleDictLoader;

interface

uses Classes, DictLoaderInterface, EngineInterfaces, IOUtils, Types, FireDAC.Comp.Client,
     MyBibleDict, MyBibleUtils;

type
  TMyBibleDictLoader = class(TInterfacedObject, IDictLoader)
  public
    function LoadDictionaries(aFileEntryPath: String; aEngine: IbqEngineDicTraits): Boolean;
    procedure LoadDictionary(Dictionary: TMyBibleDict; aDictFilePath: String);
  end;

implementation

{ TNativeDictLoader }
uses ExceptionFrm, SysUtils;


function TMyBibleDictLoader.LoadDictionaries(aFileEntryPath: String;
  aEngine: IbqEngineDicTraits): Boolean;
var
  Dictionary: TMyBibleDict;
begin
  Dictionary := TMyBibleDict.Create;
  LoadDictionary(Dictionary, aFileEntryPath);

  if Assigned(Dictionary) then
    aEngine.AddDictionary(Dictionary);

  Result := True;
end;

procedure TMyBibleDictLoader.LoadDictionary(Dictionary: TMyBibleDict; aDictFilePath: String);
var
  SQLiteQuery: TFDQuery;
  DictName: String;
  Words: TStringList;
  SQLiteConnection: TFDConnection;
begin

  try
    SQLiteConnection := TMyBibleUtils.OpenDatabase(aDictFilePath);

    SQLiteQuery := TFDQuery.Create(nil);
    SQLiteQuery.Connection := SQLiteConnection;
    Words := TStringList.Create();
    try

      DictName := TMyBibleUtils.GetDictName(SQLiteQuery);

      TMyBibleUtils.FillWords(Words, SQLiteQuery);

      Dictionary.Initialize(DictName, Words, aDictFilePath);

    except
      on e: Exception do
      begin
        BqShowException(e);
      end;
    end;

  finally
    if Assigned(SQLiteQuery) then
    begin
      SQLiteQuery.Close();
      SQLiteQuery.Free();
    end;

    SQLiteConnection.Close();
    SQLiteConnection.Free();
    Words.Free();
  end;

end;

end.
