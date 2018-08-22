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

  TBookTabSettings = class(TTabSettings)
  private
    FLocation: string;
    FSecondBible: string;
    FStrongNotesCode: UInt64;
    FTitle: string;
  public
    property Location: string read FLocation write FLocation;
    property SecondBible: string read FSecondBible write FSecondBible;
    property StrongNotesCode: UInt64 read FStrongNotesCode write FStrongNotesCode;
    property Title: string read FTitle write FTitle;
  end;

  TTabsViewSettings = class
  private
    FBookTabs: TList<TBookTabSettings>;
    FMemoTabs: TList<TMemoTabSettings>;

    FActive: boolean;
    FViewName: string;
    FDocked: boolean;
    FLeft, FTop: integer;
    FWidth, FHeight: integer;
  public
    property BookTabs: TList<TBookTabSettings> read FBookTabs write FBookTabs;
    property MemoTabs: TList<TMemoTabSettings> read FMemoTabs write FMemoTabs;
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
  Active := false;
end;

procedure TTabsViewSettings.AddTabSettings(tabSettings: TTabSettings);
begin
  if (tabSettings is TBookTabSettings) then
    BookTabs.Add(TBookTabSettings(tabSettings));

  if (tabSettings is TMemoTabSettings) then
    MemoTabs.Add(TMemoTabSettings(tabSettings));
end;

function TTabsViewSettings.GetOrderedTabSettings(): TList<TTabSettings>;
var
  count: integer;
  tabs: TList<TTabSettings>;
  tab: TTabSettings;
begin
  count := BookTabs.Count + MemoTabs.Count;
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
