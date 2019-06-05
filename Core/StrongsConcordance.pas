unit StrongsConcordance;

interface

uses Windows, Classes, SysUtils, IOUtils, IOProcs, MyBibleDict, AppPaths, StrUtils,
     SyncObjs, StringProcs, MyBibleDictLoader, Math;

type
  TStrongWordList = class(TStringList)
   function CompareStrings(const S1, S2: string): Integer; override;
  end;

  TStrongsConcordance = class
  private
    FStrongDict: TMyBibleDict;
    FLock: TCriticalSection;
    FStrongLoaded: boolean;
    function InitializeDictionary(Dictionary: TMyBibleDict; filename: string): boolean;
  public
    constructor Create;
    destructor Destroy(); override;

    function EnsureStrongLoaded(): boolean;
    function GetTotalWords(): integer;
    function Lookup(number: string): string; overload;

    property StrongDict: TMyBibleDict read FStrongDict;
    property TotalWords: integer read GetTotalWords;
  end;

implementation

uses MyBibleInfoSourceLoader, InfoSource;

function TStrongWordList.CompareStrings(const S1, S2: string): Integer;
var
  H1, H2: Boolean;
  Num1, Num2: Integer;
begin
  if (StrongVal(S1, Num1, H1) and StrongVal(S2, Num2, H2)) then
  begin
    if (H1 xor H2) then
      Result := IfThen(H1, -1, 1)
    else
      Result := Num1 - Num2;
  end
  else
    Result := inherited CompareStrings(S1, S2);
end;

constructor TStrongsConcordance.Create;
var
  Words: TStrongWordList;
begin
  inherited Create;

  FLock := TCriticalSection.Create;

  Words := TStrongWordList.Create;
  Words.Sorted := True;
  FStrongDict := TMyBibleDict.Create(Words);
  FStrongLoaded := False;
end;

destructor TStrongsConcordance.Destroy;
begin
  FreeAndNil(FLock);
  FreeAndNil(FStrongDict);

  inherited;
end;

function TStrongsConcordance.EnsureStrongLoaded(): boolean;
begin
  if not FStrongLoaded then
    FStrongLoaded := InitializeDictionary(FStrongDict, 'Лексикон.dictionary.SQLite3');

  Result := FStrongLoaded;
end;

function TStrongsConcordance.InitializeDictionary(Dictionary: TMyBibleDict; filename: string): boolean;
var
  SqlitePath: string;
  Loader: TMyBibleDictLoader;
begin
  Result := False;
  SqlitePath := TPath.Combine(TLibraryDirectories.Strong, filename);
  Loader := TMyBibleDictLoader.Create;

  FLock.Acquire;
  try
    Loader.LoadDictionary(Dictionary, SqlitePath);

    Result := True;
  finally
    FLock.Release;
  end;
end;

function TStrongsConcordance.GetTotalWords(): integer;
begin
  FLock.Acquire;
  try
    Result := StrongDict.GetWordCount();
  finally
    FLock.Release;
  end;
end;

function TStrongsConcordance.Lookup(number: string): string;
begin
  EnsureStrongLoaded;
  Result := StrongDict.Lookup(number);
end;

end.

