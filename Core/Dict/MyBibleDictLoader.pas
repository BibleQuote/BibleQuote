unit MyBibleDictLoader;

interface

uses Classes, DictLoaderInterface, IOUtils, Types, FireDAC.Comp.Client,
     MyBibleDict, MyBibleUtils, DictInterface;

type
  TMyBibleDictLoader = class(TInterfacedObject, IDictLoader)
  public
    function LoadDictionary(aFileEntryPath: String): IDict; overload;
    function LoadDictionary(Dictionary: TMyBibleDict; aDictFilePath: String): Boolean; overload;
  end;

implementation

{ TNativeDictLoader }
uses ExceptionFrm, SysUtils;


function TMyBibleDictLoader.LoadDictionary(aFileEntryPath: String): IDict;
var
  Dictionary: TMyBibleDict;
begin
  Result := nil;
  Dictionary := TMyBibleDict.Create;

  try
    if LoadDictionary(Dictionary, aFileEntryPath) then
      Result := Dictionary;
  except
    // Error while loading the dictionary
    // Return nil as the result
  end;
end;

function TMyBibleDictLoader.LoadDictionary(Dictionary: TMyBibleDict; aDictFilePath: String): Boolean;
var
  SQLiteQuery: TFDQuery;
  DictName, Style: String;
  Words: TStringList;
  SQLiteConnection: TFDConnection;
begin
  Words := TStringList.Create();

  SQLiteConnection := nil;
  SQLiteQuery := nil;
  try
    SQLiteConnection := TMyBibleUtils.OpenDatabase(aDictFilePath);

    SQLiteQuery := TFDQuery.Create(nil);
    SQLiteQuery.Connection := SQLiteConnection;

    if not TMyBibleUtils.IsTableExists(SQLiteQuery, 'dictionary') then
    begin
      Result := False;
      Exit;
    end;

    DictName := TMyBibleUtils.GetDictName(SQLiteQuery);
    Style := TMyBibleUtils.GetStyle(SQLiteQuery);

    TMyBibleUtils.FillWords(Words, SQLiteQuery);

    Dictionary.Initialize(DictName, Words, aDictFilePath, Style);

    Result := True;
  finally
    if Assigned(SQLiteQuery) then
    begin
      SQLiteQuery.Close();
      SQLiteQuery.Free();
    end;

    if Assigned(SQLiteConnection) then
    begin
      SQLiteConnection.Close();
      SQLiteConnection.Free();
    end;

    Words.Free();
  end;

end;

end.
