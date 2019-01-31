unit LayoutConfig;

interface
uses
  XMLDoc, XMLIntf, Classes, SysUtils, Generics.Collections, IOUtils,
  System.JSON, JclStrings;

type
  IJsonSerializable = interface
  ['{47095AC3-5717-4F2C-86DB-E3AB8BAC8C95}']
    function ToJson(): TJSONObject;
    procedure FromJson(jsonObj: TJSONObject);
  end;

  TTabSettings = class abstract(TInterfacedObject, IJsonSerializable)
  protected
    FActive: boolean;
    FIndex: integer;

    procedure WriteJsonBody(json: TJSONObject); virtual;
    procedure ReadJsonBody(json: TJSONObject); virtual;
  public
    property Active: boolean read FActive write FActive;
    property Index: integer read FIndex write FIndex;

    function ToJson(): TJSONObject;
    procedure FromJson(json: TJSONObject);
  end;

  TMemoTabSettings = class(TTabSettings)
  end;

  TLibraryTabSettings = class(TTabSettings)
  end;

  TBookmarksTabSettings = class(TTabSettings)
  end;

  TSearchTabSettings = class(TTabSettings)
  private
    FSearchText: string;
    FAnyWord, FPhrase, FExactPhrase, FParts, FMatchCase: boolean;
    FBookPath: string;
  protected
    procedure WriteJsonBody(json: TJSONObject); override;
    procedure ReadJsonBody(json: TJSONObject); override;
  public
    property SearchText: string read FSearchText write FSearchText;
    property AnyWord: boolean read FAnyWord write FAnyWord;
    property Phrase: boolean read FPhrase write FPhrase;
    property ExactPhrase: boolean read FExactPhrase write FExactPhrase;
    property Parts: boolean read FParts write FParts;
    property MatchCase: boolean read FMatchCase write FMatchCase;
    property BookPath: string read FBookPath write FBookPath;
  end;

  TBookTabSettings = class(TTabSettings)
  private
    FLocation: string;
    FSecondBible: string;
    FOptionsState: UInt64;
    FTitle: string;
    FHistory: string;
    FHistoryIndex: integer;
  protected
    procedure WriteJsonBody(json: TJSONObject); override;
    procedure ReadJsonBody(json: TJSONObject); override;
  public
    property Location: string read FLocation write FLocation;
    property SecondBible: string read FSecondBible write FSecondBible;
    property OptionsState: UInt64 read FOptionsState write FOptionsState;
    property Title: string read FTitle write FTitle;
    property History: string read FHistory write FHistory;
    property HistoryIndex: integer read FHistoryIndex write FHistoryIndex;
  end;

  TTSKTabSettings = class(TTabSettings)
  private
    FLocation: string;
    FBook, FChapter, FVerse: integer;
  protected
    procedure WriteJsonBody(json: TJSONObject); override;
    procedure ReadJsonBody(json: TJSONObject); override;
  public
    property Location: string read FLocation write FLocation;
    property Book: integer read FBook write FBook;
    property Chapter: integer read FChapter write FChapter;
    property Verse: integer read FVerse write FVerse;
  end;

  TTagsVersesTabSettings = class(TTabSettings)
  end;

  TDictionaryTabSettings = class(TTabSettings)
  end;

  TStrongTabSettings = class(TTabSettings)
  end;

  TCommentsTabSettings = class(TTabSettings)
  end;

  TWorkspaceSettings = class(TInterfacedObject, IJsonSerializable)
  private
    FBookTabs: TList<TBookTabSettings>;
    FMemoTabs: TList<TMemoTabSettings>;
    FLibraryTabs: TList<TLibraryTabSettings>;
    FBookmarksTabs: TList<TBookmarksTabSettings>;
    FSearchTabs: TList<TSearchTabSettings>;
    FTSKTabs: TList<TTSKTabSettings>;
    FTagsVersesTabs: TList<TTagsVersesTabSettings>;
    FDictionaryTabs: TList<TDictionaryTabSettings>;
    FStrongTabs: TList<TStrongTabSettings>;
    FCommentsTabs: TList<TCommentsTabSettings>;

    FActive: boolean;
    FViewName: string;
    FDocked: boolean;
    FLeft, FTop: integer;
    FWidth, FHeight: integer;

    function TabToJson(tabName: string; tabSettings: TTabSettings): TJSONObject;
    function TabFromJson(json: TJSONObject): TTabSettings;
  public
    property BookTabs: TList<TBookTabSettings> read FBookTabs write FBookTabs;
    property MemoTabs: TList<TMemoTabSettings> read FMemoTabs write FMemoTabs;
    property LibraryTabs: TList<TLibraryTabSettings> read FLibraryTabs write FLibraryTabs;
    property BookmarksTabs: TList<TBookmarksTabSettings> read FBookmarksTabs write FBookmarksTabs;
    property SearchTabs: TList<TSearchTabSettings> read FSearchTabs write FSearchTabs;
    property TSKTabs: TList<TTSKTabSettings> read FTSKTabs write FTSKTabs;
    property TagsVersesTabs: TList<TTagsVersesTabSettings> read FTagsVersesTabs write FTagsVersesTabs;
    property DictionaryTabs: TList<TDictionaryTabSettings> read FDictionaryTabs write FDictionaryTabs;
    property StrongTabs: TList<TStrongTabSettings> read FStrongTabs write FStrongTabs;
    property CommentsTabs: TList<TCommentsTabSettings> read FCommentsTabs write FCommentsTabs;

    property Active: boolean read FActive write FActive;
    property ViewName: string read FViewName write FViewName;
    property Docked: boolean read FDocked write FDocked;
    property Left: integer read FLeft write FLeft;
    property Top: integer read FTop write FTop;
    property Width: integer read FWidth write FWidth;
    property Height: integer read FHeight write FHeight;

    function GetOrderedTabSettings(): TList<TTabSettings>;
    constructor Create();
    procedure AddTabSettings(tabSettings: TTabSettings);

    function ToJson(): TJSONObject;
    procedure FromJson(json: TJSONObject);
  end;

type
  TLayoutConfig = class
  private
    FWorkspaceSettingsList: TList<TWorkspaceSettings>;
  public
    property WorkspaceSettingsList: TList<TWorkspaceSettings> read FWorkspaceSettingsList write FWorkspaceSettingsList;

    constructor Create();

    procedure Save(fileName: string);
    class function Load(fileName: string) : TLayoutConfig;
  end;

implementation

constructor TWorkspaceSettings.Create();
begin
  BookTabs := TList<TBookTabSettings>.Create();
  MemoTabs := TList<TMemoTabSettings>.Create();
  LibraryTabs := TList<TLibraryTabSettings>.Create();
  BookmarksTabs := TList<TBookmarksTabSettings>.Create();
  SearchTabs := TList<TSearchTabSettings>.Create();
  TSKTabs := TList<TTSKTabSettings>.Create();
  TagsVersesTabs := TList<TTagsVersesTabSettings>.Create();
  DictionaryTabs := TList<TDictionaryTabSettings>.Create();
  StrongTabs := TList<TStrongTabSettings>.Create();
  CommentsTabs := TList<TCommentsTabSettings>.Create();

  Active := false;
end;

procedure TWorkspaceSettings.AddTabSettings(tabSettings: TTabSettings);
begin
  if (tabSettings is TBookTabSettings) then
    BookTabs.Add(TBookTabSettings(tabSettings));

  if (tabSettings is TMemoTabSettings) then
    MemoTabs.Add(TMemoTabSettings(tabSettings));

  if (tabSettings is TLibraryTabSettings) then
    LibraryTabs.Add(TLibraryTabSettings(tabSettings));

  if (tabSettings is TBookmarksTabSettings) then
    BookmarksTabs.Add(TBookmarksTabSettings(tabSettings));

  if (tabSettings is TSearchTabSettings) then
    SearchTabs.Add(TSearchTabSettings(tabSettings));

  if (tabSettings is TTSKTabSettings) then
    TSKTabs.Add(TTSKTabSettings(tabSettings));

  if (tabSettings is TTagsVersesTabSettings) then
    TagsVersesTabs.Add(TTagsVersesTabSettings(tabSettings));

  if (tabSettings is TDictionaryTabSettings) then
    DictionaryTabs.Add(TDictionaryTabSettings(tabSettings));

  if (tabSettings is TStrongTabSettings) then
    StrongTabs.Add(TStrongTabSettings(tabSettings));

  if (tabSettings is TCommentsTabSettings) then
    CommentsTabs.Add(TCommentsTabSettings(tabSettings));
end;

function TWorkspaceSettings.GetOrderedTabSettings(): TList<TTabSettings>;
var
  count: integer;
  tabs: TList<TTabSettings>;
  tab: TTabSettings;
begin
  count := BookTabs.Count + MemoTabs.Count + LibraryTabs.Count +
    BookmarksTabs.Count + SearchTabs.Count + TSKTabs.Count +
    TagsVersesTabs.Count + DictionaryTabs.Count + StrongTabs.Count +
    CommentsTabs.Count;

  tabs := TList<TTabSettings>.Create;
  tabs.Count := count;

  for tab in BookTabs do
  begin
    tabs[tab.Index] := tab;
  end;

  for tab in MemoTabs do
  begin
    tabs[tab.Index] := tab;
  end;

  for tab in LibraryTabs do
  begin
    tabs[tab.Index] := tab;
  end;

  for tab in BookmarksTabs do
  begin
    tabs[tab.Index] := tab;
  end;

  for tab in SearchTabs do
  begin
    tabs[tab.Index] := tab;
  end;

  for tab in TSKTabs do
  begin
    tabs[tab.Index] := tab;
  end;

  for tab in TagsVersesTabs do
  begin
    tabs[tab.Index] := tab;
  end;

  for tab in DictionaryTabs do
  begin
    tabs[tab.Index] := tab;
  end;

  for tab in StrongTabs do
  begin
    tabs[tab.Index] := tab;
  end;

  for tab in CommentsTabs do
  begin
    tabs[tab.Index] := tab;
  end;

  Result := tabs;
end;

constructor TLayoutConfig.Create();
begin
  WorkspaceSettingsList := TList<TWorkspaceSettings>.Create();
end;

function TTabSettings.ToJson(): TJSONObject;
var
  json: TJSONObject;
begin
  json := TJSONObject.Create;

  json.AddPair('Active', BoolToStr(Active));
  json.AddPair('Index', IntToStr(Index));

  WriteJsonBody(json);

  Result := json;
end;

procedure TTabSettings.FromJson(json: TJSONObject);
begin
  Active := json.GetValue<boolean>('Active', false);
  Index := json.GetValue<integer>('Index', 0);

  ReadJsonBody(json);
end;

procedure TTabSettings.WriteJsonBody(json: TJSONObject);
begin
  // should be implemented in derived class
end;

procedure TTabSettings.ReadJsonBody(json: TJSONObject);
begin
  // should be implemented in derived class
end;

procedure TSearchTabSettings.WriteJsonBody(json: TJSONObject);
begin
  json.AddPair('SearchText', SearchText);
  json.AddPair('AnyWord', BoolToStr(AnyWord));
  json.AddPair('Phrase', BoolToStr(Phrase));
  json.AddPair('ExactPhrase', BoolToStr(ExactPhrase));
  json.AddPair('Parts', BoolToStr(Parts));
  json.AddPair('MatchCase', BoolToStr(MatchCase));
  json.AddPair('BookPath', BookPath);
end;

procedure TSearchTabSettings.ReadJsonBody(json: TJSONObject);
begin
  SearchText := json.GetValue<string>('SearchText', '');
  AnyWord := json.GetValue<boolean>('AnyWord', false);
  Phrase := json.GetValue<boolean>('Phrase', false);
  ExactPhrase := json.GetValue<boolean>('ExactPhrase', false);
  Parts := json.GetValue<boolean>('Parts', false);
  MatchCase := json.GetValue<boolean>('MatchCase', false);
  BookPath := json.GetValue<string>('BookPath', '');
end;

procedure TBookTabSettings.WriteJsonBody(json: TJSONObject);
begin
  json.AddPair('Location', TJSONString.Create(Location));
  json.AddPair('SecondBible', SecondBible);
  json.AddPair('OptionsState', UIntToStr(OptionsState));
  json.AddPair('Title', Title);
  json.AddPair('History', History);
  json.AddPair('HistoryIndex', IntToStr(HistoryIndex));
end;

procedure TBookTabSettings.ReadJsonBody(json: TJSONObject);
begin
  Location := json.GetValue<string>('Location', '');
  SecondBible := json.GetValue<string>('SecondBible', '');
  OptionsState := json.GetValue<UInt64>('OptionsState', 0);
  Title := json.GetValue<string>('Title', '');
  History := json.GetValue<string>('History', '');
  HistoryIndex := json.GetValue<integer>('HistoryIndex', 0);
end;

procedure TTSKTabSettings.WriteJsonBody(json: TJSONObject);
begin
  json.AddPair('Location', Location);
  json.AddPair('Book', IntToStr(Book));
  json.AddPair('Chapter', IntToStr(Chapter));
  json.AddPair('Verse', IntToStr(Verse));
end;

procedure TTSKTabSettings.ReadJsonBody(json: TJSONObject);
begin
  Location := json.GetValue<string>('Location', '');
  Book := json.GetValue<integer>('Book', 0);
  Chapter := json.GetValue<integer>('Chapter', 0);
  Verse := json.GetValue<integer>('Verse', 0);
end;

function TWorkspaceSettings.ToJson(): TJSONObject;
var
  json: TJSONObject;
  jsonTabs: TJSONArray;
  tab: TTabSettings;
begin
  json := TJSONObject.Create;

  json.AddPair('Active', BoolToStr(Active));
  json.AddPair('ViewName', ViewName);
  json.AddPair('Docked', BoolToStr(Docked));
  json.AddPair('Left', IntToStr(Left));
  json.AddPair('Top', IntToStr(Top));
  json.AddPair('Width', IntToStr(Width));
  json.AddPair('Height', IntToStr(Height));

  jsonTabs := TJSONArray.Create;
  for tab in BookTabs do
  begin
    jsonTabs.add(TabToJson('book', tab));
  end;

  for tab in MemoTabs do
  begin
    jsonTabs.add(TabToJson('memo', tab));
  end;

  for tab in LibraryTabs do
  begin
    jsonTabs.add(TabToJson('library', tab));
  end;

  for tab in BookmarksTabs do
  begin
    jsonTabs.add(TabToJson('bookmarks', tab));
  end;

  for tab in SearchTabs do
  begin
    jsonTabs.add(TabToJson('search', tab));
  end;

  for tab in TSKTabs do
  begin
    jsonTabs.add(TabToJson('tsk', tab));
  end;

  for tab in TagsVersesTabs do
  begin
    jsonTabs.add(TabToJson('tags', tab));
  end;

  for tab in DictionaryTabs do
  begin
    jsonTabs.add(TabToJson('dict', tab));
  end;

  for tab in StrongTabs do
  begin
    jsonTabs.add(TabToJson('strong', tab));
  end;

  for tab in CommentsTabs do
  begin
    jsonTabs.add(TabToJson('comments', tab));
  end;

  json.AddPair('tabs', jsonTabs);

  Result := json;
end;

function TWorkspaceSettings.TabToJson(tabName: string; tabSettings: TTabSettings): TJSONObject;
var
  json: TJSONObject;
begin
  json := TJSONObject.Create;
  json.AddPair('tab', tabName);
  json.AddPair('data', tabSettings.ToJson);
  Result := json;
end;

function TWorkspaceSettings.TabFromJson(json: TJSONObject): TTabSettings;
var
  tabName: string;
  jsonValue: TJSONValue;
  jsonBody: TJSONObject;
  tab: TTabSettings;
begin
  Result := nil;

  tabName := json.GetValue<string>('tab', '');
  if tabName.Length > 0 then
  begin
    jsonValue := json.GetValue('data');
    if (jsonValue is TJSONObject) then
    begin
      jsonBody := TJSONObject(jsonValue);
      tab := nil;
      case StrIndex(tabName, ['book', 'memo', 'library', 'bookmarks', 'search', 'tsk', 'tags', 'dict', 'strong', 'comments']) of
        0: tab := TBookTabSettings.Create;
        1: tab := TMemoTabSettings.Create;
        2: tab := TLibraryTabSettings.Create;
        3: tab := TBookmarksTabSettings.Create;
        4: tab := TSearchTabSettings.Create;
        5: tab := TTSKTabSettings.Create;
        6: tab := TTagsVersesTabSettings.Create;
        7: tab := TDictionaryTabSettings.Create;
        8: tab := TStrongTabSettings.Create;
        9: tab := TCommentsTabSettings.Create;
      end;

      if Assigned(tab) then
      begin
        tab.ReadJsonBody(jsonBody);
        Result := tab;
      end;
    end;
  end;
end;

procedure TWorkspaceSettings.FromJson(json: TJSONObject);
var
  jsonVal: TJSONValue;
  jsonTabs: TJSONArray;
  jsonTab: TJSONValue;
  tabName: string;
  tab: TTabSettings;
  jsonTabDataVal: TJSONValue;
  jsonTabData: TJSONObject;
begin
  Active := json.GetValue<boolean>('Active', false);
  ViewName := json.GetValue<string>('ViewName', '');
  Docked := json.GetValue<boolean>('Docked', false);
  Left := json.GetValue<integer>('Left', 0);
  Top := json.GetValue<integer>('Top', 0);
  Width := json.GetValue<integer>('Width', 0);
  Height := json.GetValue<integer>('Height', 0);

  jsonVal := json.GetValue('tabs');
  if jsonVal is TJSONArray then
  begin
    jsonTabs := TJSONArray(jsonVal);
    for jsonTab in jsonTabs do
    begin
      tabName := jsonTab.GetValue<string>('tab', '');
      if tabName.Length <= 0 then
        continue;

      jsonTabDataVal := TJSONObject(jsonTab).GetValue('data');
      if not(jsonTabDataVal is TJSONObject) then
        continue;

      jsonTabData := TJSONObject(jsonTabDataVal);

      tab := nil;
      case StrIndex(tabName, ['book', 'memo', 'library', 'bookmarks', 'search', 'tsk', 'tags', 'dict', 'strong', 'comments']) of
        0: tab := TBookTabSettings.Create;
        1: tab := TMemoTabSettings.Create;
        2: tab := TLibraryTabSettings.Create;
        3: tab := TBookmarksTabSettings.Create;
        4: tab := TSearchTabSettings.Create;
        5: tab := TTSKTabSettings.Create;
        6: tab := TTagsVersesTabSettings.Create;
        7: tab := TDictionaryTabSettings.Create;
        8: tab := TStrongTabSettings.Create;
        9: tab := TCommentsTabSettings.Create;
      end;

      if Assigned(tab) then
      begin
        tab.FromJson(jsonTabData);
        AddTabSettings(tab);
      end;
    end;
  end;
end;

class function TLayoutConfig.Load(fileName: string): TLayoutConfig;
var
  json: string;
  jsonObj: TJSONObject;
  jsonValue: TJSONValue;
  jsonViewsValue: TJSONValue;
  jsonViews: TJSONArray;
  jsonViewValue: TJSONValue;
  jsonView: TJSONObject;
  layoutConfig: TLayoutConfig;
  workspaceSettings: TWorkspaceSettings;
  s: string;
begin
  Result := nil;

  json := TFile.ReadAllText(fileName);
  jsonValue := TJSONObject.ParseJSONValue(json);
  if jsonValue is TJSONObject then
  begin
    jsonObj := TJSONObject(jsonValue);
    jsonViewsValue := jsonObj.GetValue('views');
    if (jsonViewsValue is TJSONArray) then
    begin
      jsonViews := TJSONArray(jsonViewsValue);
      layoutConfig := TLayoutConfig.Create;

      for jsonViewValue in jsonViews do
      begin
        if (jsonViewValue is TJSONObject) then
        begin
          jsonView := TJSONObject(jsonViewValue);
          s := jsonView.ToJSON;
          workspaceSettings := TWorkspaceSettings.Create;

          workspaceSettings.FromJson(jsonView);
          layoutConfig.WorkspaceSettingsList.Add(workspaceSettings);
        end;

      end;

      Result := layoutConfig;
    end;
  end;
end;

procedure TLayoutConfig.Save(fileName: string);
var
  json: string;
  jsonObj: TJSONObject;
  jsonViews: TJSONArray;
  workspaceSettings: TWorkspaceSettings;
begin
  jsonObj := TJSONObject.Create;
  jsonViews := TJSONArray.Create;

  for workspaceSettings in WorkspaceSettingsList do
  begin
    jsonViews.add(workspaceSettings.ToJson);
  end;

  jsonObj.AddPair('views', jsonViews);
  json := jsonObj.ToJson;

  TFile.WriteAllText(fileName, json);
end;

end.
