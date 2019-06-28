unit DataScanning;

interface

uses
  Classes, SyncObjs, System.Types, System.SysUtils, IOUtils, Contnrs,
  bible, BibleQuoteUtils, BibleQuoteConfig, AppPaths, AppIni, DictInterface,
  System.Generics.Collections, DictLoaderInterface, SelectEntityType,
  DictLoaderFabric, IOProcs;

type
  TDictData = class
  private
    FDicts: TList<IDict>;
    FDictTokens: TBQStringList;
  public
    constructor Create(); overload;
    constructor Create(Dicts: TList<IDict>; Tokens: TBQStringList); overload;

    procedure Assign(DictData: TDictData);
    procedure Clear();

    property Dictionaries: TList<IDict> read FDicts;
    property DictTokens: TBQStringList read FDictTokens;
  end;

type
  TModulesScanner = class
  private
    FSecondDirectory: String;
    FTempBook: TBible;
    FLimit: Integer;

    procedure ScanArchives(Modules: TCachedModules; Directory: string; AsCommentaries: Boolean = False);
    procedure ScanDirectory(Modules: TCachedModules; Directory: string; ModType: TModuleType);
    function IsLimit(Modules: TCachedModules): Boolean;
  public
    constructor Create(TempBook: TBible; Limit: Integer = -1);

    property SecondDirectory: String read FSecondDirectory write FSecondDirectory;
    property Limit: Integer read FLimit;

    function TryLoadCachedModules(var Modules: TCachedModules): Boolean;

    function Scan(): TCachedModules;
  end;

type
  TDictScanner = class
  private
    procedure LoadDictionaries(Path: String; var Dics: TList<IDict>);
    function InitDictionaryTokens(Dics: TList<IDict>): TBQStringList;
  public
    constructor Create();

    function Scan(): TDictData;
  end;

implementation

constructor TDictData.Create();
begin
  inherited Create;

  FDicts := TList<IDict>.Create();
  FDictTokens := TBQStringList.Create();
end;

constructor TDictData.Create(Dicts: TList<IDict>; Tokens: TBQStringList);
begin
  inherited Create;

  FDictTokens := Tokens;
  FDicts := Dicts;
end;

procedure TDictData.Assign(DictData: TDictData);
begin
  Clear();
  FDicts.AddRange(DictData.Dictionaries);
  FDictTokens.AddStrings(DictData.DictTokens);
end;

procedure TDictData.Clear();
begin
  FDicts.Clear;
  FDictTokens.Clear;
end;

constructor TDictScanner.Create;
begin
  inherited Create();
end;

procedure TDictScanner.LoadDictionaries(Path: String; var Dics: TList<IDict>);
var
  FileEntries: TStringDynArray;
  FileEntryPath: String;

  I: Integer;
  DictLoader: IDictLoader;
  DictType: TDictTypes;
  Dict: IDict;
begin
  FileEntries := TDirectory.GetFileSystemEntries(Path);

  if (Length(FileEntries) > 0) then
  begin
    for I := 0 to Length(FileEntries) - 1 do
    begin
      FileEntryPath := FileEntries[i];

      DictType := TSelectEntityType.SelectDictType(FileEntryPath);
      DictLoader := TDictLoaderFabric.CreateDictLoader(DictType);

      if not Assigned(DictLoader) then
      begin
        if (IsDirectory(FileEntryPath) and DirectoryExists(FileEntryPath)) then
          LoadDictionaries(FileEntryPath, Dics);

        Continue;
      end;

      Dict := DictLoader.LoadDictionary(FileEntryPath);
      if not Assigned(Dict) then
        Continue;

      Dics.Add(Dict);

    end;
  end;
end;

function TDictScanner.InitDictionaryTokens(Dics: TList<IDict>): TBQStringList;
var
  List: TBQStringList;
  DicCount, DictIdx, WordIdx, WordCount: Integer;
  Dict: IDict;
begin
  List := TBQStringList.Create;
  List.Sorted := true;

  DicCount := Dics.Count - 1;
  for DictIdx := 0 to dicCount do
  begin
    Dict := Dics[DictIdx];
    WordCount := Dict.GetWordCount() - 1;
    for WordIdx := 0 to WordCount do
      List.Add(Dict.GetWord(WordIdx));

  end;

  Result := List;
end;

function TDictScanner.Scan(): TDictData;
var
  Dics: TList<IDict>;
  Tokens: TBQStringList;
begin
  Dics := TList<IDict>.Create();
  LoadDictionaries(TLibraryDirectories.Dictionaries, Dics);
  Tokens := InitDictionaryTokens(Dics);

  Result := TDictData.Create(Dics, Tokens);
end;

constructor TModulesScanner.Create(TempBook: TBible; Limit: Integer = -1);
begin
  FTempBook := TempBook;
  FLimit := Limit;
end;

function TModulesScanner.Scan(): TCachedModules;
var
  Modules: TCachedModules;
begin
  Modules := TCachedModules.Create();

  ScanDirectory(Modules, TLibraryDirectories.Bibles, modtypeBible);
  ScanDirectory(Modules, TLibraryDirectories.Books, modtypeBook);

  ScanArchives(Modules, TLibraryDirectories.CompressedModules);

  if (SecondDirectory <> '') and (ExtractFilePath(SecondDirectory) <> ExtractFilePath(TLibraryDirectories.Root))
  then
  begin
    ScanDirectory(Modules, TPath.Combine(SecondDirectory, C_BiblesSubDirectory), modtypeBible);
    ScanDirectory(Modules, TPath.Combine(SecondDirectory, C_BooksSubDirectory), modtypeBook);
  end;

  ScanDirectory(Modules, TLibraryDirectories.Commentaries, modtypeComment);
  ScanArchives(Modules, TPath.Combine(TLibraryDirectories.CompressedModules, C_CommentariesSubDirectory), True);

  ScanDirectory(Modules, TLibraryDirectories.Dictionaries, modtypeDictionary);
  ScanArchives(Modules, TPath.Combine(TLibraryDirectories.CompressedModules, C_DictionariesSubDirectory), True);

  Modules._Sort;
  Result := Modules;
end;

procedure TModulesScanner.ScanArchives(Modules: TCachedModules; Directory: string; AsCommentaries: Boolean = False);
var
  ModType: TModuleType;
  ModEntry: TModuleEntry;
  SearchRec: TSearchRec;
  SearchResult: Integer;
begin
  if (IsLimit(Modules)) then
    Exit;

  if not DirectoryExists(Directory) then
    Exit;

  SearchResult := FindFirst(TPath.Combine(Directory, '*.bqb'), faAnyFile, SearchRec);

  if SearchResult = 0 then
    repeat
      try
        FTempBook.SetInfoSource('?' + Directory + '\' + SearchRec.Name + '??' + C_ModuleIniName);
        if (AsCommentaries) then
          ModType := modtypeComment
        else
        begin
          if FTempBook.isBible then
            ModType := modtypeBible
          else
            ModType := modtypeBook;
        end;

        ModEntry := TModuleEntry.Create(
          ModType,
          FTempBook.Name,
          FTempBook.ShortName,
          FTempBook.ShortPath,
          Directory + '\' + SearchRec.Name,
          FTempBook.GetStucture(),
          FTempBook.Categories,
          FTempBook.Author,
          FTempBook.ModuleVersion,
          FTempBook.ModuleImage,
          FTempBook.trait[bqmtStrongs]);

        Modules.Add(ModEntry);
        if (IsLimit(Modules)) then
          Exit;
      except
        on E: TBQException do
          // failed to load module, skip it
      end;
      SearchResult := FindNext(SearchRec);
    until (SearchResult <> 0);

  if SearchResult <> 0 then
    FindClose(SearchRec);
end;

procedure TModulesScanner.ScanDirectory(Modules: TCachedModules; Directory: string; ModType: TModuleType);
var
  ModEntry: TModuleEntry;
  ModulePath: string;
  SearchRec: TSearchRec;
  SearchResult: Integer;
  IsDirectory: Boolean;
begin
  if (IsLimit(Modules)) then
    Exit;

  SearchResult := FindFirst(TPath.Combine(Directory, '*.*'), faAnyFile, SearchRec);

  if (SearchResult = 0) then // search results are not empty
    repeat
      if (SearchRec.Name = '.') or (SearchRec.Name = '..') then
      begin
        SearchResult := FindNext(SearchRec);

        Continue;
      end;


      try
        ModulePath := TPath.Combine(Directory, SearchRec.Name);

        if FTempBook.SetInfoSource(ModulePath) then
        begin

          ModEntry := TModuleEntry.Create(
            ModType,
            FTempBook.Name,
            FTempBook.ShortName,
            FTempBook.ShortPath,
            EmptyWideStr,
            FTempBook.GetStucture(),
            FTempBook.Categories,
            FTempBook.Author,
            FTempBook.ModuleVersion,
            FTempBook.ModuleImage,
            FTempBook.trait[bqmtStrongs]);

          Modules.Add(ModEntry);
          if (IsLimit(Modules)) then
            Exit;
        end
        else
        begin
          // failed to identify the module from the search record

          // scan subdirectory
          IsDirectory := (SearchRec.Attr and faDirectory) = faDirectory;
          if (IsDirectory) then
            ScanDirectory(Modules, ModulePath, ModType);
        end;
      except
        on E: TBQException do
          // failed to load module, skip it
      end;

      SearchResult := FindNext(SearchRec);

    until (SearchResult <> 0);

  if (SearchResult <> 0) then
    FindClose(SearchRec);
end;

function TModulesScanner.IsLimit(Modules: TCachedModules): Boolean;
begin
  Result := (FLimit > 0) and (FLimit < Modules.Count);
end;

function TModulesScanner.TryLoadCachedModules(var Modules: TCachedModules): Boolean;
var
  ModulesList: TStringList;
  I, LineCount, ModIx: Integer;
  ModEntry: TModuleEntry;
  ModType: TModuleType;
  Cats: string;
  BookNames: string;
  HasStrong: Boolean;
  CachedModsFilePath: string;
begin
  try
    ModulesList := TStringList.Create();
    try
      CachedModsFilePath := TPath.Combine(TAppDirectories.UserSettings, C_CachedModsFileName);

      if not FileExists(CachedModsFilePath) then
      begin
        Result := False;
        Exit;
      end;

      ModulesList.LoadFromFile(CachedModsFilePath);
      I := 1;

      if ModulesList[0] <> 'v5' then
      begin
        Result := False;
        Exit;
      end;

      LineCount := ModulesList.Count - 1;
      if LineCount < 10 then
        abort;
      repeat
        ModIx := Modules.IndexOf(ModulesList[I + 1]);
        if ModIx < 0 then
        begin
{$R+}
          ModType := TModuleType(StrToInt(ModulesList[I]));
          Cats := ModulesList[I + 6];
          HasStrong := StrToBool(ModulesList[I + 9]);

          if Cats = '***' then
            Cats := '';
          BookNames := ModulesList[I + 5];

          ModEntry := TModuleEntry.Create(ModType, ModulesList[I + 1],
            ModulesList[I + 2], ModulesList[I + 3],
            ModulesList[I + 4], BookNames, Cats, ModulesList[I + 7],
            // todo: figure out ModuleVersion
            'ModuleVersion', ModulesList[I + 8], HasStrong);
{$R-}
          Modules.Add(ModEntry);
        end;
        inc(I, 9);
        while (I <= LineCount) and (ModulesList[I] <> '***') do
          inc(I);
        inc(I);

      until (I + 10) > LineCount;
      Modules._Sort();
      Result := True;
    finally
      ModulesList.Free();
    end;

  except
    Modules.Clear();
    Result := False;
  end;

end;

end.
