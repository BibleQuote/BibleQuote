unit MyBibleUtils;

interface

uses Classes, FireDAC.Comp.Client;

type

  TMyBibleUtils = class
  public
    class function GetDictName(aSQLiteQuery: TFDQuery): String;
    class function GetStrong(aSQLiteQuery: TFDQuery): Boolean;
    class procedure FillWords(aWords: TStrings;
                    aSQLiteQuery: TFDQuery);
  end;

implementation

uses SysUtils;

class function TMyBibleUtils.GetDictName(aSQLiteQuery: TFDQuery): String;
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

class function TMyBibleUtils.GetStrong(aSQLiteQuery: TFDQuery): Boolean;
begin
  Result := False;

  aSQLiteQuery.SQL.Text := 'SELECT value FROM [info] where Name="is_strong"';
  aSQLiteQuery.Open();

  try

    if aSQLiteQuery.Eof then raise Exception.Create('Missing description for dictionary');

    Result := aSQLiteQuery.FieldByName('value').AsString = 'true';

  finally
    aSQLiteQuery.Close;
  end;
end;

class procedure TMyBibleUtils.FillWords(aWords: TStrings;
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


end.
