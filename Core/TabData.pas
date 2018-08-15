unit TabData;

interface

uses System.UITypes, System.Classes, Winapi.Windows, SysUtils,
     Vcl.Controls, Vcl.Graphics, Bible, HtmlView,
     Vcl.Tabs, Vcl.DockTabSet, ChromeTabs, ChromeTabsTypes, ChromeTabsUtils,
     ChromeTabsControls, ChromeTabsClasses, ChromeTabsLog;

type
  TViewTabType = (
    vttBook,
    vttMemo);

  IBookView = interface
  ['{8015DBB1-AC95-49F3-9E00-B49BEF9A60F6}']
  end;

  IMemoView = interface
  ['{372AF297-B27E-4A91-A215-36B8564BF797}']
  end;

  ITabsView = interface; // forward declaration

  IViewTabInfo = interface
  ['{AF0866F3-5841-445E-A830-8EBD678B59A8}']
    procedure SaveState(const tabsView: ITabsView);
    procedure RestoreState(const tabsView: ITabsView);

    function GetViewType(): TViewTabType;
  end;

  TBookTabLocType = (vtlUnspecified, vtlModule, vtlFile);

  TBookTabInfoStateEntries = (
    vtisShowStrongs,
    vtisShowNotes,
    vtisHighLightVerses,
    vtisResolveLinks,
    vtisFuzzyResolveLinks,
    vtisPendingReload);

  TBookTabInfoState = set of TBookTabInfoStateEntries;

  TBookTabBrowserState = class
  private
    mSelStart: integer;
    mSelLenght: integer;
    mHScrollPos: integer;
    mVScrollPos: integer;
  public
    property SelStart: integer read mSelStart write mSelStart;
    property SelLenght: integer read mSelLenght write mSelLenght;
    property HScrollPos: integer read mHScrollPos write mHScrollPos;
    property VScrollPos: integer read mVScrollPos write mVScrollPos;

    constructor Create();
  end;

  TBookTabInfo = class(TInterfacedObject, IViewTabInfo)
  private
    mLocation, mTitleLocation: string;
    mTitleFont: string;
    mCopyrightNotice: string;
    mTitle: string;
    mBible, mSecondBible: TBible;
    mReferenceBible: TBible;

    mSatelliteName: string;
    mFirstVisiblePara, mLastVisiblePara: integer;

    mState: TBookTabInfoState;
    mLocationType: TBookTabLocType;
    mBrowserState: TBookTabBrowserState;

    mIsCompareTranslation: Boolean;
    mCompareTranslationText: string;

    function GetStateEntryStatus(stateEntry: TBookTabInfoStateEntries): Boolean; inline;
    procedure SetStateEntry(stateEntry: TBookTabInfoStateEntries; value: Boolean);
  public
    property State: TBookTabInfoState read mState write mState;

    property Location: string read mLocation write mLocation;
    property TitleLocation: string read mTitleLocation write mTitleLocation;
    property TitleFont: string read mTitleFont write mTitleFont;
    property CopyrightNotice: string read mCopyrightNotice write mCopyrightNotice;
    property Title: string read mTitle write mTitle;
    property SatelliteName: string read mSatelliteName write mSatelliteName;

    property FirstVisiblePara: integer read mFirstVisiblePara write mFirstVisiblePara;
    property LastVisiblePara: integer read mLastVisiblePara  write mLastVisiblePara;

    property Bible: TBible read mBible;
    property SecondBible: TBible read mSecondBible write mSecondBible;
    property ReferenceBible: TBible read mReferenceBible write mReferenceBible;

    property LocationType: TBookTabLocType read mLocationType write mLocationType;
    property BrowserState: TBookTabBrowserState read mBrowserState;
    property IsCompareTranslation: Boolean read mIsCompareTranslation write mIsCompareTranslation;
    property CompareTranslationText: string read mCompareTranslationText write mCompareTranslationText;

    property StateEntryStatus[i: TBookTabInfoStateEntries]: Boolean
      read GetStateEntryStatus write SetStateEntry; default;

    procedure SaveBrowserState(const aHtmlViewer: THTMLViewer);
    procedure RestoreBrowserState(const aHtmlViewer: THTMLViewer);

    constructor Create(
      const bible: TBible;
      const location: string;
      const satelliteBibleName: string;
      const title: string;
      const state: TBookTabInfoState);

    procedure Init(
      const bible: TBible;
      const location: string;
      const satelliteBibleName: string;
      const title: string;
      const state: TBookTabInfoState);

    procedure SaveState(const tabsView: ITabsView);
    procedure RestoreState(const tabsView: ITabsView);
    function GetViewType(): TViewTabType;
  end;

  TMemoTabInfo = class(TInterfacedObject, IViewTabInfo)
    procedure SaveState(const tabsView: ITabsView);
    procedure RestoreState(const tabsView: ITabsView);
    function GetViewType(): TViewTabType;
  end;

  TViewTabDragObject = class(TDragObjectEx)
  protected
    mViewTabInfo: TBookTabInfo;
  public
    constructor Create(aViewTabInfo: TBookTabInfo);
    property ViewTabInfo: TBookTabInfo read mViewTabInfo;
  end;

  ITabsView = interface
  ['{DEADBEEF-31AB-4F3A-B16F-57B47258402A}']

    procedure CloseActiveTab();
    function GetActiveTabInfo(): IViewTabInfo;
    procedure UpdateBookView();
    function AddBookTab(newTabInfo: TBookTabInfo; const title: string): TChromeTab;
    function AddMemoTab(newTabInfo: TMemoTabInfo): TChromeTab;
    procedure MakeActive();

    // getters
    function GetBrowser: THTMLViewer;
    function GetBookView: IBookView;
    function GetChromeTabs: TChromeTabs;
    function GetBibleTabs: TDockTabSet;
    function GetViewName: string;
    function GetTabInfo(tabIndex: integer): IViewTabInfo;

    // setters
    procedure SetViewName(viewName: string);

    // properties
    property ChromeTabs: TChromeTabs read GetChromeTabs;
    property Browser: THTMLViewer read GetBrowser;
    property BookView: IBookView read GetBookView;
    property BibleTabs: TDockTabSet read GetBibleTabs;
    property ViewName: string read GetViewName write SetViewName;
  end;

implementation

uses BookFra;

constructor TBookTabBrowserState.Create;
begin
  SelStart := -1;
  SelLenght := -1;
  HScrollPos := -1;
  VScrollPos := -1;
end;

{ TBookTabInfo }

constructor TBookTabInfo.Create(
  const bible: TBible;
  const location: string;
  const satelliteBibleName: string;
  const title: string;
  const state: TBookTabInfoState);
begin
  Init(bible, location, satelliteBibleName, title, state);
end;

function TBookTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttBook;
end;

procedure TBookTabInfo.SaveState(const tabsView: ITabsView);
begin
  SaveBrowserState((tabsView.BookView as TBookFrame).bwrHtml);
end;

procedure TBookTabInfo.RestoreState(const tabsView: ITabsView);
begin
  RestoreBrowserState((tabsView.BookView as TBookFrame).bwrHtml);
end;

procedure TBookTabInfo.SaveBrowserState(const aHtmlViewer: THTMLViewer);
begin
  mBrowserState.SelStart := aHtmlViewer.SelStart;
  mBrowserState.SelLenght := aHtmlViewer.SelLength;
  mBrowserState.HScrollPos := aHtmlViewer.HScrollBarPosition;
  mBrowserState.VScrollPos := aHtmlViewer.VScrollBarPosition;
end;

procedure TBookTabInfo.RestoreBrowserState(const aHtmlViewer: THTMLViewer);
begin
  if mBrowserState = nil then
    Exit;

  if (mBrowserState.SelStart >= 0) then
  begin
    aHtmlViewer.SelStart := mBrowserState.SelStart;
    aHtmlViewer.SelLength := mBrowserState.SelLenght;
  end;

  if (mBrowserState.HScrollPos >= 0) then
     aHtmlViewer.HScrollBarPosition := mBrowserState.HScrollPos;

  if (mBrowserState.VScrollPos >= 0) then
     aHtmlViewer.VScrollBarPosition := mBrowserState.VScrollPos;
end;

function TBookTabInfo.GetStateEntryStatus(stateEntry: TBookTabInfoStateEntries): Boolean;
begin
  Result := stateEntry in mState;
end;

procedure TBookTabInfo.Init(
  const bible: TBible;
  const location: string;
  const satelliteBibleName: string;
  const title: string;
  const state: TBookTabInfoState);
begin
  mBrowserState := TBookTabBrowserState.Create;
  mBible := bible;
  mLocation := location;
  mSatelliteName := satelliteBibleName;
  mState := state;
  mLocationType := vtlUnspecified;
  mLastVisiblePara := -1;
  mTitle := title;
  mIsCompareTranslation := false;
  mCompareTranslationText := '';
end;

procedure TBookTabInfo.SetStateEntry(stateEntry: TBookTabInfoStateEntries; value: Boolean);
begin
  if value then
    Include(mState, stateEntry)
  else
    Exclude(mState, stateEntry);
end;

{ TMemoTabInfo }

function TMemoTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttMemo;
end;

procedure TMemoTabInfo.SaveState(const tabsView: ITabsView);
begin
// nothing to save
end;

procedure TMemoTabInfo.RestoreState(const tabsView: ITabsView);
begin
// nothing to save
end;

{ TViewTabDragObject }

constructor TViewTabDragObject.Create(aViewTabInfo: TBookTabInfo);
begin
  inherited Create();
  mViewTabInfo := aViewTabInfo;
end;

end.

