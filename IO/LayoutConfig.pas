unit LayoutConfig;

interface
uses
  XMLDoc, XMLIntf, Classes, SysUtils, Generics.Collections, Rest.Json, IOUtils;

type
  TTabSettings = class
  protected
    FActive: boolean;
    FIndex: integer;
  public
    property Active: boolean read FActive write FActive;
    property Index: integer read FIndex write FIndex;
  end;

  TMemoTabSettings = class(TTabSettings)
  end;

  TLibraryTabSettings = class(TTabSettings)
  end;

  TBookmarksTabSettings = class(TTabSettings)
  end;

  TBookTabSettings = class(TTabSettings)
  private
    FLocation: string;
    FSecondBible: string;
    FOptionsState: UInt64;
    FTitle: string;
    FHistory: string;
    FHistoryIndex: integer;
  public
    property Location: string read FLocation write FLocation;
    property SecondBible: string read FSecondBible write FSecondBible;
    property OptionsState: UInt64 read FOptionsState write FOptionsState;
    property Title: string read FTitle write FTitle;
    property History: string read FHistory write FHistory;
    property HistoryIndex: integer read FHistoryIndex write FHistoryIndex;
  end;

  TTabsViewSettings = class
  private
    FBookTabs: TList<TBookTabSettings>;
    FMemoTabs: TList<TMemoTabSettings>;
    FLibraryTabs: TList<TLibraryTabSettings>;
    FBookmarksTabs: TList<TBookmarksTabSettings>;

    FActive: boolean;
    FViewName: string;
    FDocked: boolean;
    FLeft, FTop: integer;
    FWidth, FHeight: integer;
  public
    property BookTabs: TList<TBookTabSettings> read FBookTabs write FBookTabs;
    property MemoTabs: TList<TMemoTabSettings> read FMemoTabs write FMemoTabs;
    property LibraryTabs: TList<TLibraryTabSettings> read FLibraryTabs write FLibraryTabs;
    property BookmarksTabs: TList<TBookmarksTabSettings> read FBookmarksTabs write FBookmarksTabs;

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
  end;

var
  LibFormWidth: integer = 400;
  LibFormHeight: integer = 600;
  LibFormTop: integer = 100;
  LibFormLeft: integer = 100;

type
  TLayoutConfig = class
  private
    FTabsViewList: TList<TTabsViewSettings>;
  public
    property TabsViewList: TList<TTabsViewSettings> read FTabsViewList write FTabsViewList;

    constructor Create();

    procedure Save(fileName: string);
    class function Load(fileName: string) : TLayoutConfig;
  end;

implementation

constructor TTabsViewSettings.Create();
begin
  BookTabs := TList<TBookTabSettings>.Create();
  MemoTabs := TList<TMemoTabSettings>.Create();
  LibraryTabs := TList<TLibraryTabSettings>.Create();
  BookmarksTabs := TList<TBookmarksTabSettings>.Create();

  Active := false;
end;

procedure TTabsViewSettings.AddTabSettings(tabSettings: TTabSettings);
begin
  if (tabSettings is TBookTabSettings) then
    BookTabs.Add(TBookTabSettings(tabSettings));

  if (tabSettings is TMemoTabSettings) then
    MemoTabs.Add(TMemoTabSettings(tabSettings));

  if (tabSettings is TLibraryTabSettings) then
    LibraryTabs.Add(TLibraryTabSettings(tabSettings));

  if (tabSettings is TBookmarksTabSettings) then
    BookmarksTabs.Add(TBookmarksTabSettings(tabSettings));
end;

function TTabsViewSettings.GetOrderedTabSettings(): TList<TTabSettings>;
var
  count: integer;
  tabs: TList<TTabSettings>;
  tab: TTabSettings;
begin
  count := BookTabs.Count + MemoTabs.Count + LibraryTabs.Count + BookmarksTabs.Count;
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

  Result := tabs;
end;

constructor TLayoutConfig.Create();
begin
  TabsViewList := TList<TTabsViewSettings>.Create();
end;

class function TLayoutConfig.Load(fileName: string): TLayoutConfig;
var
  json: string;
begin
  json := TFile.ReadAllText(fileName);
  Result := TJson.JsonToObject<TLayoutConfig>(json);
end;

procedure TLayoutConfig.Save(fileName: string);
var
  json: string;
begin
  json := TJson.ObjectToJsonString(self);
  TFile.WriteAllText(fileName, json);
end;

end.
