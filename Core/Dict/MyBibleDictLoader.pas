unit MyBibleDictLoader;

interface

uses Classes, DictLoaderInterface, EngineInterfaces, IOUtils, Types, FireDAC.Comp.Client,
     MyBibleDict, MyBibleUtils;

type
  TMyBibleDictLoader = class(TInterfacedObject, IDictLoader)
  protected
    function LoadDictionary(aDictFilePath: String; aSQLiteConnection: TFDConnection): TMyBibleDict;
  public
    function LoadDictionaries(aFileEntryPath: String; aEngine: IbqEngineDicTraits): Boolean;
  end;

implementation

{ TNativeDictLoader }
uses ExceptionFrm, SysUtils;


function TMyBibleDictLoader.LoadDictionaries(aFileEntryPath: String;
  aEngine: IbqEngineDicTraits): Boolean;
var
  SQLiteConnection: TFDConnection;
  Dictionary: TMyBibleDict;
begin

  SQLiteConnection := TFDConnection.Create(nil);
  SQLiteConnection.DriverName := 'SQLite';

  try

    Dictionary := LoadDictionary(aFileEntryPath, SQLiteConnection);

    if Assigned(Dictionary) then
      aEngine.AddDictionary(Dictionary);

  finally
    SQLiteConnection.Close;
    SQLiteConnection.Free;
  end;

  Result := True;
end;

function TMyBibleDictLoader.LoadDictionary(aDictFilePath: String;
  aSQLiteConnection: TFDConnection): TMyBibleDict;
var
  Dictionary: TMyBibleDict;
  SQLiteQuery: TFDQuery;
  DictName: String;
  Words: TStringList;
begin
  Result := nil;

  if aSQLiteConnection.Connected then aSQLiteConnection.Close;

  aSQLiteConnection.Params.Values['Database'] := aDictFilePath;
  aSQLiteConnection.Open();

  SQLiteQuery := TFDQuery.Create(nil);
  SQLiteQuery.Connection := aSQLiteConnection;
  Words := TStringList.Create();

  try
    try

      DictName := TMyBibleUtils.GetDictName(SQLiteQuery);

      TMyBibleUtils.FillWords(Words, SQLiteQuery);

      Dictionary := TMyBibleDict.Create;
      Dictionary.Initialize(DictName, Words, aDictFilePath);

      Result := Dictionary;

    except
      on e: Exception do
      begin
        BqShowException(e);
      end;
    end;

  finally
    aSQLiteConnection.Close();
    SQLiteQuery.Close();
    SQLiteQuery.Free();
    Words.Free();
  end;


end;

end.
