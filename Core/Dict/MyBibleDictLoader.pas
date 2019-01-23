unit MyBibleDictLoader;

interface

uses Classes, DictLoaderInterface, EngineInterfaces, IOUtils, Types, FireDAC.Comp.Client,
     MyBibleDict;

type
  TMyBibleDictLoader = class(TInterfacedObject, IDictLoader)
  protected
    function LoadDictionary(aDictFilePath: String; aSQLiteConnection: TFDConnection): TMyBibleDict;
    function GetDictName(aSQLiteQuery: TFDQuery): String;
    procedure FillWords(aWords: TStrings; aSQLiteQuery: TFDQuery);
  public
    function LoadDictionaries(aDirPath: String; aEngine: IbqEngineDicTraits): Boolean;
  end;

implementation

{ TNativeDictLoader }
uses ExceptionFrm, SysUtils;

procedure TMyBibleDictLoader.FillWords(aWords: TStrings;
  aSQLiteQuery: TFDQuery);
begin
  aSQLiteQuery.SQL.Text := 'SELECT topic FROM [dictionary]';
  aSQLiteQuery.Open();

  try

    while not aSQLiteQuery.Eof do
    begin
      aWords.Add(aSQLiteQuery.FieldByName('topic').AsString);

      aSQLiteQuery.Next();
    end;

  finally
    aSQLiteQuery.Close;
  end;
end;

function TMyBibleDictLoader.GetDictName(aSQLiteQuery: TFDQuery): String;
begin
  Result := '';

  aSQLiteQuery.SQL.Text := 'SELECT value FROM [info] where Name="description"';
  aSQLiteQuery.Open();

  try

    if aSQLiteQuery.Eof then raise Exception.Create('Missing description for dictionary');

    Result := aSQLiteQuery.FieldByName('value').AsString;

  finally
    aSQLiteQuery.Close;
  end;
end;

function TMyBibleDictLoader.LoadDictionaries(aDirPath: String;
  aEngine: IbqEngineDicTraits): Boolean;
var
  DictFileList: TStringDynArray;
  i: Integer;
  SQLiteConnection: TFDConnection;
  Dictionary: TMyBibleDict;
begin

  DictFileList := TDirectory.GetFiles(aDirPath, '*.sqlite3');
  SQLiteConnection := TFDConnection.Create(nil);
  SQLiteConnection.DriverName := 'SQLite';

  try

    for i := 0 to Length(DictFileList) - 1 do
    begin

      Dictionary := LoadDictionary(DictFileList[i], SQLiteConnection);

      if Assigned(Dictionary) then
        aEngine.AddDictionary(Dictionary);

    end;


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

      DictName := GetDictName(SQLiteQuery);

      FillWords(Words, SQLiteQuery);

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
