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
    FBrokenDicts: TList<String>;
    FDictTokens: TBQStringList;
  public
    constructor Create(); overload;
    constructor Create(Dicts: TList<IDict>; BrokenDicts: TList<String>; Tokens: TBQStringList); overload;

    procedure Assign(DictData: TDictData);
    procedure Clear();

    property Dictionaries: TList<IDict> read FDicts;
    property BrokenDictionaries: TList<String> read FBrokenDicts;
    property DictTokens: TBQStringList read FDictTokens;
  end;

  TModulesData = class
  private
    FModules: TCachedModules;
    FBrokenModules: TList<String>;
  public
    constructor Create(); overload;
    constructor Create(Modules: TCachedModules; BrokenModules: TList<String>); overload;

    procedure Assign(Data: TModulesData);
    procedure Clear();

    property Modules: TCachedModules read FModules;
    property BrokenModules: TList<String> read FBrokenModules;
  end;

type
  TModulesScanner = class
  private
    FSecondDirectory: String;
    FTempBook: TBible;
    FLimit: Integer;

    procedure ScanArchives(Data: TModulesData; Directory: string; AsCommentaries: Boolean = False);
    procedure ScanDirectory(Data: TModulesData; Directory: string; ModType: TModuleType);
    function IsLimit(Data: TModulesData): Boolean;
  public
    constructor Create(TempBook: TBible; Limit: Integer = -1);

    property SecondDirectory: String read FSecondDirectory write FSecondDirectory;
    property Limit: Integer read FLimit;

    function TryLoadCachedModules(var Data: TModulesData): Boolean;

    function Scan(): TModulesData;
  end;

type
  TDictScanner = class
  private
    procedure LoadDictionaries(Path: String; var Dics: TList<IDict>; var BrokedDicts: TList<String>);
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
  FBrokenDicts := TList<String>.Create();
  FDictTokens := TBQStringList.Create();
end;

constructor TDictData.Create(Dicts: TList<IDict>; BrokenDicts: TList<String>; Tokens: TBQStringList);
begin
  inherited Create;

  FDictTokens := Tokens;
  FDicts := Dicts;
  FBrokenDicts := BrokenDicts;
end;

procedure TDictData.Assign(DictData: TDictData);
begin
  Clear();
  FDicts.AddRange(DictData.Dictionaries);
  FBrokenDicts.AddRange(DictData.BrokenDictionaries);
  FDictTokens.AddStrings(DictData.DictTokens);
end;

procedure TDictData.Clear();
begin
  FDicts.Clear;
  FBrokenDicts.Clear;
  FDictTokens.Clear;
end;

constructor TModulesData.Create();
begin
  inherited Create;

  FModules := TCachedModules.Create;
  FBrokenModules := TList<String>.Create;
end;

constructor TModulesData.Create(Modules: TCachedModules; BrokenModules: TList<String>);
begin
  FModules := Modules;
  FBrokenModules := BrokenModules;
end;

procedure TModulesData.Assign(Data: TModulesData);
begin
  FModules.Assign(Data.Modules);
  FBrokenModules.Clear;
  FBrokenModules.AddRange(Data.BrokenModules);
end;

procedure TModulesData.Clear();
begin
  FModules.Clear;
  FBrokenModules.Clear;
end;

constructor TDictScanner.Create;
begin
  inherited Create();
end;

procedure TDictScanner.LoadDictionaries(Path: String; var Dics: TList<IDict>; var BrokedDicts: TList<String>);
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
          LoadDictionaries(FileEntryPath, Dics, BrokedDicts);

        Continue;
      end;

      Dict := DictLoader.LoadDictionary(FileEntryPath);
      if not Assigned(Dict) then
      begin
        BrokedDicts.Add(FileEntryPath);
        Continue;
      end;

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
  BrokedDicts: TList<String>;
  Tokens: TBQStringList;
begin
  Dics := TList<IDict>.Create();
  BrokedDicts := TList<String>.Create();
  LoadDictionaries(TLibraryDirectories.Dictionaries, Dics, BrokedDicts);
  Tokens := InitDictionaryTokens(Dics);

  Result := TDictData.Create(Dics, BrokedDicts, Tokens);
end;

constructor TModulesScanner.Create(TempBook: TBible; Limit: Integer = -1);
begin
  FTempBook := TempBook;
  FLimit := Limit;
end;

function TModulesScanner.Scan(): TModulesData;
var
  Data: TModulesData;
begin
  Data := TModulesData.Create;

  ScanDirectory(Data, TLibraryDirectories.Bibles, modtypeBible);
  ScanDirectory(Data, TLibraryDirectories.Books, modtypeBook);

  ScanArchives(Data, TLibraryDirectories.CompressedModules);

  if (SecondDirectory <> '') and (ExtractFilePath(SecondDirectory) <> ExtractFilePath(TLibraryDirectories.Root))
  then
  begin
    ScanDirectory(Data, TPath.Combine(SecondDirectory, C_BiblesSubDirectory), modtypeBible);
    ScanDirectory(Data, TPath.Combine(SecondDirectory, C_BooksSubDirectory), modtypeBook);
  end;

  ScanDirectory(Data, TLibraryDirectories.Commentaries, modtypeComment);
  ScanArchives(Data, TPath.Combine(TLibraryDirectories.CompressedModules, C_CommentariesSubDirectory), True);

  ScanDirectory(Data, TLibraryDirectories.Dictionaries, modtypeDictionary);
  ScanArchives(Data, TPath.Combine(TLibraryDirectories.CompressedModules, C_DictionariesSubDirectory), True);

  Data.Modules._Sort;
  Result := Data;
end;

procedure TModulesScanner.ScanArchives(Data: TModulesData; Directory: string; AsCommentaries: Boolean = False);
var
  ModType: TModuleType;
  ModEntry: TModuleEntry;
  SearchRec: TSearchRec;
  SearchResult: Integer;
begin
  if (IsLimit(Data)) then
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

        Data.Modules.Add(ModEntry);
        if (IsLimit(Data)) then
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

procedure TModulesScanner.ScanDirectory(Data: TModulesData; Directory: string; ModType: TModuleType);
var
  ModEntry: TModuleEntry;
  ModulePath: string;
  SearchRec: TSearchRec;
  SearchResult: Integer;
  IsDirectory: Boolean;
begin
  if (IsLimit(Data)) then
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

          Data.Modules.Add(ModEntry);
          if (IsLimit(Data)) then
            Exit;
        end
        else
        begin
          // failed to identify the module from the search record

          // scan subdirectory
          IsDirectory := (SearchRec.Attr and faDirectory) = faDirectory;
          if (IsDirectory) then
            ScanDirectory(Data, ModulePath, ModType);
        end;
      except
        on E: Exception do
          // failed to load module, skip it
      end;

      SearchResult := FindNext(SearchRec);

    until (SearchResult <> 0);

  if (SearchResult <> 0) then
    FindClose(SearchRec);
end;

function TModulesScanner.IsLimit(Data: TModulesData): Boolean;
begin
  with Data.Modules do
    Result := (FLimit > 0) and (FLimit < Count);
end;

function TModulesScanner.TryLoadCachedModules(var Data: TModulesData): Boolean;
var
  ModulesList: TStringList;
  I, LineCount, ModIx: Integer;
  ModEntry: TModuleEntry;
  ModType: TModuleType;
  Cats: string;
  BookNames: string;
  HasStrong: Boolean;
  CachedModsFilePath: string;
  Modules: TCachedModules;
begin
  Modules := Data.Modules;
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
