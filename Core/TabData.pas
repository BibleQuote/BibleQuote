unit TabData;

interface

uses System.UITypes, System.Classes, Winapi.Windows, SysUtils,
     Vcl.Controls, Vcl.Graphics, Bible, HtmlView,
     Vcl.Tabs, Vcl.DockTabSet, ChromeTabs, ChromeTabsTypes, ChromeTabsUtils,
     ChromeTabsControls, ChromeTabsClasses, ChromeTabsLog, LayoutConfig,
     BibleQuoteUtils, AppIni, Types.Extensions, UITools;

type
  TViewTabType = (
    vttBook,
    vttMemo,
    vttLibrary,
    vttBookmarks,
    vttSearch,
    vttTSK,
    vttTagsVerses,
    vttDictionary,
    vttStrong,
    vttComments);

  ITabView = interface
  ['{85A340FA-D5E5-4F37-ABDD-A75A7B3B494C}']
    procedure Translate();
    procedure ApplyConfig(appConfig, oldConfig: TAppConfig);
    procedure EventFrameKeyDown(var Key: Char);
  end;

  IBookView = interface(ITabView)
  ['{8015DBB1-AC95-49F3-9E00-B49BEF9A60F6}']
  end;

  IMemoView = interface(ITabView)
  ['{372AF297-B27E-4A91-A215-36B8564BF797}']
  end;

  ILibraryView = interface(ITabView)
  ['{48FA0988-E4BA-4A39-9119-34D163959863}']
  end;

  IBookmarksView = interface(ITabView)
  ['{4C0D791C-E62D-4EC0-8B32-6019D89CB95A}']
  end;

  ISearchView = interface(ITabView)
  ['{FA56F7B8-1976-4A01-A041-3D4A91C53B8A}']
  end;

  ITSKView = interface(ITabView)
  ['{4FDFF734-6243-4A50-A867-9DA7F27C5A50}']
  end;

  ITagsVersesView = interface(ITabView)
  ['{B8822B40-4C89-4943-8461-84ADDCB92401}']
  end;

  IDictionaryView = interface(ITabView)
  ['{C3D8CC95-1D9D-4F01-A31A-5133BADFA598}']
  end;

  IStrongView = interface(ITabView)
  ['{840F8BE2-3C68-4853-8E43-B048DE7E6855}']
  end;

  ICommentsView = interface(ITabView)
  ['{5474F1F8-E735-406A-A7CC-95A8C8E9E61B}']
  end;

  IWorkspace = interface; // forward declaration

  IViewTabInfo = interface
  ['{AF0866F3-5841-445E-A830-8EBD678B59A8}']
    procedure SaveState(const workspace: IWorkspace);
    procedure RestoreState(const workspace: IWorkspace);

    function GetViewType(): TViewTabType;
    function GetSettings(): TTabSettings;
    function GetCaption(): string;
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

  TBrowserState = class
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

    mHistory: TStrings;
    mHistoryIndex: integer;

    mSatelliteName: string;
    mFirstVisiblePara, mLastVisiblePara: integer;

    mState: TBookTabInfoState;
    mLocationType: TBookTabLocType;
    mBrowserState: TBrowserState;

    mIsCompareTranslation: Boolean;
    mCompareTranslationText: string;

    function GetStateEntryStatus(stateEntry: TBookTabInfoStateEntries): Boolean; inline;
    procedure SetStateEntry(stateEntry: TBookTabInfoStateEntries; value: Boolean);
    function EncodeToValue(): UInt64;
  public
    property State: TBookTabInfoState read mState write mState;

    property Location: string read mLocation write mLocation;
    property TitleLocation: string read mTitleLocation write mTitleLocation;
    property TitleFont: string read mTitleFont write mTitleFont;
    property CopyrightNotice: string read mCopyrightNotice write mCopyrightNotice;
    property Title: string read mTitle write mTitle;
    property SatelliteName: string read mSatelliteName write mSatelliteName;
    property History: TStrings read mHistory write mHistory;
    property HistoryIndex: integer read mHistoryIndex write mHistoryIndex;

    property FirstVisiblePara: integer read mFirstVisiblePara write mFirstVisiblePara;
    property LastVisiblePara: integer read mLastVisiblePara  write mLastVisiblePara;

    property Bible: TBible read mBible;
    property SecondBible: TBible read mSecondBible write mSecondBible;

    property LocationType: TBookTabLocType read mLocationType write mLocationType;
    property BrowserState: TBrowserState read mBrowserState;
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

    procedure SaveState(const workspace: IWorkspace);
    procedure RestoreState(const workspace: IWorkspace);
    function GetViewType(): TViewTabType;
    function GetSettings(): TTabSettings;
    function GetCaption(): string;

    destructor Destroy(); override;
  end;

  TMemoTabInfo = class(TInterfacedObject, IViewTabInfo)
    procedure SaveState(const workspace: IWorkspace);
    procedure RestoreState(const workspace: IWorkspace);
    function GetViewType(): TViewTabType;
    function GetSettings(): TTabSettings;
    function GetCaption(): string;
  end;

  TLibraryTabInfo = class(TInterfacedObject, IViewTabInfo)
  private
    mViewMode: TLibraryViewMode;
    mModuleIndex: Integer;
    mModuleTypeIndex: Integer;
  public
    property ViewMode: TLibraryViewMode read mViewMode write mViewMode;
    property ModuleIndex: Integer read mModuleIndex write mModuleIndex;
    property ModuleTypeIndex: Integer read mModuleTypeIndex write mModuleTypeIndex;

    procedure SaveState(const workspace: IWorkspace);
    procedure RestoreState(const workspace: IWorkspace);
    function GetViewType(): TViewTabType;
    function GetSettings(): TTabSettings;
    function GetCaption(): string;

    constructor Create(); overload;
    constructor Create(settings: TLibraryTabSettings); overload;
  end;

  TBookmarksTabInfo = class(TInterfacedObject, IViewTabInfo)
    procedure SaveState(const workspace: IWorkspace);
    procedure RestoreState(const workspace: IWorkspace);
    function GetViewType(): TViewTabType;
    function GetSettings(): TTabSettings;
    function GetCaption(): string;
  end;

  TStrongTabInfo = class(TInterfacedObject, IViewTabInfo)
  private
    mBookPath: string;
    mSelectedStrong: string;
    mSearchText: string;
    mStrongText: string;
  public
    property SelectedStrong: string read mSelectedStrong write mSelectedStrong;
    property SearchText: string read mSearchText write mSearchText;
    property StrongText: string read mStrongText write mStrongText;

    procedure SaveState(const workspace: IWorkspace);
    procedure RestoreState(const workspace: IWorkspace);
    function GetViewType(): TViewTabType;
    function GetSettings(): TTabSettings;
    function GetCaption(): string;

    constructor Create(); overload;
    constructor Create(settings: TStrongTabSettings); overload;
  end;

  TSearchTabState = class
  private
    mSearchPageSize: integer;
    mIsSearching: Boolean;
    mSearchResults: TStrings;
    mSearchWords: TStrings;
    mSearchTime: int64;
    mSearchPage: integer; // what page we are in
    mSearchBrowserPosition: Longint; // list search results pages...
    mLastSearchResultsPage: integer; // to show/hide page results (Ctrl-F3)

    mblSearchBooksDDAltered: Boolean;
    mslSearchBooksCache: TStringList;
  public
    property SearchPageSize: integer read mSearchPageSize write mSearchPageSize;
    property IsSearching: boolean read mIsSearching write mIsSearching;
    property SearchResults: TStrings read mSearchResults write mSearchResults;
    property SearchWords: TStrings read mSearchWords write mSearchWords;
    property SearchTime: int64 read mSearchTime write mSearchTime;
    property SearchPage: integer read mSearchPage write mSearchPage;
    property SearchBrowserPosition: integer read mSearchBrowserPosition write mSearchBrowserPosition;
    property LastSearchResultsPage: integer read mLastSearchResultsPage write mLastSearchResultsPage;
    property SearchBooksDDAltered: boolean read mblSearchBooksDDAltered write mblSearchBooksDDAltered;
    property SearchBooksCache: TStringList read mslSearchBooksCache write mslSearchBooksCache;

    constructor Create(); overload;
    constructor Create(srcObj: TSearchTabState); overload;
    destructor Destroy(); override;
  end;

  TSearchTabInfo = class(TInterfacedObject, IViewTabInfo)
  private
    mSearchText, mSearchInfo: string;
    mAnyWord, mPhrase, mExactPhrase, mParts, mMatchCase: boolean;
    mSelectedBook: string;

    mSearchState: TSearchTabState;
    mBookPath: string;
  public
    property SearchInfo: string read mSearchInfo write mSearchInfo;
    property SearchText: string read mSearchText write mSearchText;
    property AnyWord: boolean read mAnyWord write mAnyWord;
    property Phrase: boolean read mPhrase write mPhrase;
    property ExactPhrase: boolean read mExactPhrase write mExactPhrase;
    property Parts: boolean read mParts write mParts;
    property MatchCase: boolean read mMatchCase write mMatchCase;
    property SelectedBook: string read mSelectedBook write mSelectedBook;

    property SearchState: TSearchTabState read mSearchState write mSearchState;

    procedure SaveState(const workspace: IWorkspace);
    procedure RestoreState(const workspace: IWorkspace);
    function GetViewType(): TViewTabType;
    function GetSettings(): TTabSettings;
    function GetCaption(): string;

    constructor Create(); overload;
    constructor Create(settings: TSearchTabSettings); overload;
  end;

  TTSKTabInfo = class(TInterfacedObject, IViewTabInfo)
  private
    mBiblePath: string;
    mBook, mChapter: integer;
    mVerse: integer;
  public
    procedure SaveState(const workspace: IWorkspace);
    procedure RestoreState(const workspace: IWorkspace);
    function GetViewType(): TViewTabType;
    function GetSettings(): TTabSettings;
    function GetCaption(): string;

    constructor Create(); overload;
    constructor Create(settings: TTSKTabSettings); overload;
  end;

  TTagsVersesTabInfo = class(TInterfacedObject, IViewTabInfo)
    procedure SaveState(const workspace: IWorkspace);
    procedure RestoreState(const workspace: IWorkspace);
    function GetViewType(): TViewTabType;
    function GetSettings(): TTabSettings;
    function GetCaption(): string;

    constructor Create(); overload;
    constructor Create(settings: TTagsVersesTabSettings); overload;
  end;

  TDictionaryTabInfo = class(TInterfacedObject, IViewTabInfo)
  private
    mDictionaryIndex: integer;
    mSearchText: string;
    mFoundDictionaryIndex: integer;
  public
    procedure SaveState(const workspace: IWorkspace);
    procedure RestoreState(const workspace: IWorkspace);
    function GetViewType(): TViewTabType;
    function GetSettings(): TTabSettings;
    function GetCaption(): string;

    constructor Create(); overload;
    constructor Create(settings: TDictionaryTabSettings); overload;
  end;

  TCommentsTabInfo = class(TInterfacedObject, IViewTabInfo)
  private
    FMeaningfulOnly: Boolean;
    FCommentaryBookIndex: integer;
    FBrowserState: TBrowserState;
  public
    procedure SaveState(const workspace: IWorkspace);
    procedure RestoreState(const workspace: IWorkspace);
    function GetViewType(): TViewTabType;
    function GetSettings(): TTabSettings;
    function GetCaption(): string;

    procedure SaveBrowserState(const HtmlViewer: THTMLViewer);
    procedure RestoreBrowserState(const HtmlViewer: THTMLViewer);
    property BrowserState: TBrowserState read FBrowserState;

    constructor Create(); overload;
    constructor Create(settings: TCommentsTabSettings); overload;
  end;

  TViewTabDragObject = class(TDragObjectEx)
  protected
    mViewTabInfo: TBookTabInfo;
  public
    constructor Create(aViewTabInfo: TBookTabInfo);
    property ViewTabInfo: TBookTabInfo read mViewTabInfo;
  end;

  IWorkspace = interface
  ['{DEADBEEF-31AB-4F3A-B16F-57B47258402A}']

    procedure CloseActiveTab();
    function GetActiveTabInfo(): IViewTabInfo;
    procedure UpdateBookView();
    procedure UpdateCurrentTabContent(restoreState: boolean = true);

    function AddBookTab(newTabInfo: TBookTabInfo; Reload: Boolean = True): TChromeTab;
    function AddMemoTab(newTabInfo: TMemoTabInfo): TChromeTab;
    function AddLibraryTab(newTabInfo: TLibraryTabInfo): TChromeTab;
    function AddBookmarksTab(newTabInfo: TBookmarksTabInfo): TChromeTab;
    function AddSearchTab(newTabInfo: TSearchTabInfo): TChromeTab;
    function AddTSKTab(newTabInfo: TTSKTabInfo): TChromeTab;
    function AddTagsVersesTab(newTabInfo: TTagsVersesTabInfo): TChromeTab;
    function AddDictionaryTab(newTabInfo: TDictionaryTabInfo): TChromeTab;
    function AddStrongTab(newTabInfo: TStrongTabInfo): TChromeTab;
    function AddCommentsTab(newTabInfo: TCommentsTabInfo): TChromeTab;

    procedure MakeActive();
    procedure UpdateBookTabHeader();
    procedure ChangeTabIndex(Index: Integer);

    // getters
    function GetBrowser: THTMLViewer;
    function GetBookView: IBookView;
    function GetMemoView: IMemoView;
    function GetLibraryView: ILibraryView;
    function GetBookmarksView: IBookmarksView;
    function GetSearchView: ISearchView;
    function GetTSKView: ITSKView;
    function GetDictionaryView: IDictionaryView;
    function GetStrongView: IStrongView;
    function GetTagsVersesView: ITagsVersesView;
    function GetCommentsView: ICommentsView;
    function GetChromeTabs: TChromeTabs;
    function GetBibleTabs: TDockTabSet;
    function GetViewName: string;
    function GetTabInfo(tabIndex: integer): IViewTabInfo;
    function GetUpdateOnTabChange: boolean;
    procedure SetUpdateOnTabChange(b: boolean);

    // setters
    procedure SetViewName(viewName: string);

    // properties
    property ChromeTabs: TChromeTabs read GetChromeTabs;
    property Browser: THTMLViewer read GetBrowser;
    property BookView: IBookView read GetBookView;
    property MemoView: IMemoView read GetMemoView;
    property LibraryView: ILibraryView read GetLibraryView;
    property SearchView: ISearchView read GetSearchView;
    property BookmarksView: IBookmarksView read GetBookmarksView;
    property TSKView: ITSKView read GetTSKView;
    property TagsVerserView: ITagsVersesView read GetTagsVersesView;
    property DictionaryView: IDictionaryView read GetDictionaryView;
    property CommentsView: ICommentsView read GetCommentsView;
    property StrongView: IStrongView read GetStrongView;
    property BibleTabs: TDockTabSet read GetBibleTabs;
    property ViewName: string read GetViewName write SetViewName;
    property UpdateOnTabChange: boolean read GetUpdateOnTabChange write SetUpdateOnTabChange;
  end;

implementation

uses BookFra, SearchFra, TSKFra, DictionaryFra, StrongFra, CommentsFra,
     LibraryFra;

constructor TBrowserState.Create;
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

destructor TBookTabInfo.Destroy;
begin
  if Assigned(mHistory) then
    FreeAndNil(mHistory);

  if Assigned(mBible) then
    mBible.Free;

  if Assigned(mSecondBible) then
    mSecondBible.Free;

  inherited;
end;

function TBookTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttBook;
end;

function TBookTabInfo.GetCaption(): string;
begin
  Result := Title;
end;

function TBookTabInfo.GetSettings(): TTabSettings;
var
  tabSettings: TBookTabSettings;
  bookTabsEncoded: UInt64;
begin
  tabSettings := TBookTabSettings.Create;
  bookTabsEncoded := EncodeToValue();
  tabSettings.Location := Location;
  tabSettings.SecondBible := SatelliteName;
  tabSettings.OptionsState := bookTabsEncoded;
  tabSettings.Title := Title;

  tabSettings.History := History.DelimitedText;
  tabSettings.HistoryIndex := HistoryIndex;

  Result := tabSettings;
end;

function TBookTabInfo.EncodeToValue(): UInt64;
begin
  Result := ord(self[vtisShowNotes]);
  inc(Result, 10 * ord(self[vtisShowStrongs]));
  inc(Result, 100 * ord(self[vtisResolveLinks]));
  inc(Result, 1000 * ord(self[vtisFuzzyResolveLinks]));
end;

procedure TBookTabInfo.SaveState(const workspace: IWorkspace);
begin
  SaveBrowserState((workspace.BookView as TBookFrame).bwrHtml);
end;

procedure TBookTabInfo.RestoreState(const workspace: IWorkspace);
begin
  RestoreBrowserState((workspace.BookView as TBookFrame).bwrHtml);
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
  mBrowserState := TBrowserState.Create;
  mBible := bible;
  mLocation := location;
  mSatelliteName := satelliteBibleName;
  mState := state;
  mLocationType := vtlUnspecified;
  mLastVisiblePara := -1;
  mTitle := title;
  mIsCompareTranslation := false;
  mCompareTranslationText := '';

  mHistory := TStringList.Create;
  mHistory.Delimiter := '|';
  mHistoryIndex := -1;
end;

procedure TBookTabInfo.SetStateEntry(stateEntry: TBookTabInfoStateEntries; value: Boolean);
begin
  if value then
    Include(mState, stateEntry)
  else
    Exclude(mState, stateEntry);
end;

{ TMemoTabInfo }

function TMemoTabInfo.GetCaption(): string;
begin
  Result := Lang.SayDefault('TabMemos', 'Memos');
end;

function TMemoTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttMemo;
end;

function TMemoTabInfo.GetSettings(): TTabSettings;
begin
  Result := TMemoTabSettings.Create;
end;

procedure TMemoTabInfo.SaveState(const workspace: IWorkspace);
begin
// nothing to save
end;

procedure TMemoTabInfo.RestoreState(const workspace: IWorkspace);
begin
// nothing to save
end;

{ TLibraryTabInfo }

constructor TLibraryTabInfo.Create();
begin
  inherited Create();

  mModuleIndex := -1;
  mViewMode := lvmDetail;
end;

constructor TLibraryTabInfo.Create(settings: TLibraryTabSettings);
begin
  inherited Create();

  mModuleIndex := -1;
  mViewMode := TExtensions.StringToEnum(settings.ViewMode, lvmDetail);
end;

function TLibraryTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttLibrary;
end;

function TLibraryTabInfo.GetCaption(): string;
begin
  Result := Lang.SayDefault('TabLibrary', 'My Library');
end;

function TLibraryTabInfo.GetSettings(): TTabSettings;
var
  tabSettings: TLibraryTabSettings;
begin
  tabSettings := TLibraryTabSettings.Create;

  tabSettings.ViewMode := TExtensions.EnumToString<TLibraryViewMode>(mViewMode);

  Result := tabSettings;
end;

procedure TLibraryTabInfo.SaveState(const workspace: IWorkspace);
var
  libraryFrame: TLibraryFrame;
begin
  libraryFrame := workspace.LibraryView as TLibraryFrame;
  mViewMode := libraryFrame.GetViewMode();
  mModuleIndex := libraryFrame.GetSelectedIndex();
  mModuleTypeIndex := libraryFrame.GetModuleTypeIndex();
end;

procedure TLibraryTabInfo.RestoreState(const workspace: IWorkspace);
var
  libraryFrame: TLibraryFrame;
begin
  libraryFrame := workspace.LibraryView as TLibraryFrame;
  if Assigned(libraryFrame) then
  begin
    libraryFrame.SelectModuleTypeIndex(mModuleTypeIndex);
    libraryFrame.SelectViewMode(mViewMode);
    libraryFrame.SelectItem(mModuleIndex);
  end;
end;

{ TBookmarksTabInfo }

function TBookmarksTabInfo.GetCaption(): string;
begin
  Result := Lang.SayDefault('TabBookmarks', 'Bookmarks');
end;

function TBookmarksTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttBookmarks;
end;

function TBookmarksTabInfo.GetSettings(): TTabSettings;
begin
  Result := TBookmarksTabSettings.Create;
end;

procedure TBookmarksTabInfo.SaveState(const workspace: IWorkspace);
begin
// nothing to save
end;

procedure TBookmarksTabInfo.RestoreState(const workspace: IWorkspace);
begin
// nothing to save
end;

{ TSearchTabInfo }

constructor TSearchTabInfo.Create();
begin
  mSearchState := TSearchTabState.Create;
end;

constructor TSearchTabInfo.Create(settings: TSearchTabSettings);
begin
  mSearchState := TSearchTabState.Create;

  SearchText := settings.SearchText;
  AnyWord := settings.AnyWord;
  Phrase := settings.Phrase;
  ExactPhrase := settings.ExactPhrase;
  Parts := settings.Parts;
  MatchCase := settings.MatchCase;

  mBookPath := settings.BookPath;
end;

function TSearchTabInfo.GetCaption(): string;
begin
  Result := Lang.SayDefault('TabSearch', 'Search');
end;

function TSearchTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttSearch;
end;

function TSearchTabInfo.GetSettings(): TTabSettings;
var
  tabSettings: TSearchTabSettings;
begin
  tabSettings := TSearchTabSettings.Create;

  tabSettings.SearchText := SearchText;
  tabSettings.AnyWord := AnyWord;
  tabSettings.Phrase := Phrase;
  tabSettings.ExactPhrase := ExactPhrase;
  tabSettings.Parts := Parts;
  tabSettings.MatchCase := MatchCase;
  tabSettings.BookPath := mBookPath;
  
  Result := tabSettings;
end;

procedure TSearchTabInfo.SaveState(const workspace: IWorkspace);
var
  searchFrame: TSearchFrame;
begin
  searchFrame := workspace.SearchView as TSearchFrame;
  with searchFrame do
  begin
    mBookPath := GetBookPath();

    mSearchInfo := lblSearch.Caption;
    mSearchText := cbSearch.Text;
    mAnyWord := chkAll.Checked;
    mPhrase := chkPhrase.Checked;
    mExactPhrase := chkExactPhrase.Checked;
    mParts := chkParts.Checked;
    mMatchCase := chkCase.Checked;
    mSelectedBook := cbList.Text;

    mSearchState := TSearchTabState.Create(searchFrame.SearchState);
  end;
end;

procedure TSearchTabInfo.RestoreState(const workspace: IWorkspace);
var
  searchFrame: TSearchFrame;
  idx: integer;
begin
  searchFrame := workspace.SearchView as TSearchFrame;
  with searchFrame do
  begin
    lblSearch.Caption := mSearchInfo;
    if (lblSearch.Caption = '') then
      lblSearch.Caption := Lang.SayDefault('DockTabsForm.lblSearch.Caption', '');

    cbSearch.Text := mSearchText;
    chkAll.Checked := mAnyWord;
    chkPhrase.Checked := mPhrase;
    chkExactPhrase.Checked := mExactPhrase;
    chkParts.Checked := mParts;
    chkCase.Checked := mMatchCase;

    SetCurrentBook(mBookPath);

    for idx := 0 to cbList.Items.Count - 1 do
    begin
      if (CompareText(cbList.Items[idx], mSelectedBook) = 0) then
      begin
        cbList.ItemIndex := idx;
        break;
      end;
    end;

    searchFrame.SearchState := TSearchTabState.Create(mSearchState);

    DisplaySearchResults(mSearchState.LastSearchResultsPage);
  end;
end;

{ TSearchTabState }

constructor TSearchTabState.Create(srcObj: TSearchTabState);
begin
  SearchResults := TStringList.Create;
  SearchWords := TStringList.Create;
  SearchBooksCache := TStringList.Create();
  SearchBooksCache.Duplicates := dupIgnore;

  SearchResults.AddStrings(srcObj.SearchResults);
  SearchWords.AddStrings(srcObj.SearchWords);
  SearchBooksCache.AddStrings(srcObj.SearchBooksCache);

  LastSearchResultsPage := srcObj.LastSearchResultsPage;
  SearchPageSize := srcObj.SearchPageSize;
  SearchTime := srcObj.SearchTime;
  SearchPage := srcObj.SearchPage;
  SearchBrowserPosition := srcObj.SearchBrowserPosition;
  SearchBooksDDAltered := srcObj.SearchBooksDDAltered;
  IsSearching := srcObj.IsSearching;
end;

constructor TSearchTabState.Create();
begin
  inherited Create();

  SearchResults := TStringList.Create;
  SearchWords := TStringList.Create;
  SearchBooksCache := TStringList.Create();
  SearchBooksCache.Duplicates := dupIgnore;

  LastSearchResultsPage := 1;
  IsSearching := false;
end;

destructor TSearchTabState.Destroy;
begin
  if Assigned(mSearchResults) then
    FreeAndNil(mSearchResults);

  if Assigned(mSearchWords) then
    FreeAndNil(mSearchWords);

  if Assigned(mslSearchBooksCache) then
    FreeAndNil(mslSearchBooksCache);

  inherited;
end;

{ TTSKTabInfo }

constructor TTSKTabInfo.Create();
begin
  inherited Create();

  mBiblePath := '';
  mBook := 0;
  mChapter := 0;
  mVerse := 0;
end;

constructor TTSKTabInfo.Create(settings: TTSKTabSettings);
begin
  inherited Create();

  mBiblePath := settings.Location;
  mBook := settings.Book;
  mChapter := settings.Chapter;
  mVerse := settings.Verse;
end;

function TTSKTabInfo.GetCaption(): string;
begin
  Result := Lang.SayDefault('TabTSK', 'TSK');
end;

function TTSKTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttTSK;
end;

function TTSKTabInfo.GetSettings(): TTabSettings;
var
  tabSettings: TTSKTabSettings;
begin
  tabSettings := TTSKTabSettings.Create;

  tabSettings.Location := mBiblePath;
  tabSettings.Book := mBook;
  tabSettings.Chapter := mChapter;
  tabSettings.Verse := mVerse;

  Result := tabSettings;
end;

procedure TTSKTabInfo.SaveState(const workspace: IWorkspace);
var
  tskFrame: TTSKFrame;
begin
  tskFrame := workspace.TSKView as TTSKFrame;
  with tskFrame do
  begin
    mBiblePath := BiblePath;
    mBook := Book;
    mChapter := Chapter;
    mVerse := Verse;
  end;
end;

procedure TTSKTabInfo.RestoreState(const workspace: IWorkspace);
var
  tskFrame: TTSKFrame;
begin
  tskFrame := workspace.TSKView as TTSKFrame;
  with tskFrame do
  begin
    tskFrame.ShowXref(mBiblePath, mBook, mChapter, mVerse);
  end;
end;

{ TTagsVersesTabInfo }

constructor TTagsVersesTabInfo.Create();
begin
  inherited Create();
end;

constructor TTagsVersesTabInfo.Create(settings: TTagsVersesTabSettings);
begin
  inherited Create();
end;

function TTagsVersesTabInfo.GetCaption(): string;
begin
  Result := Lang.SayDefault('TabTagsVerses', 'Themed bookmarks');
end;

function TTagsVersesTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttTagsVerses;
end;

function TTagsVersesTabInfo.GetSettings(): TTabSettings;
begin
  Result := TTagsVersesTabSettings.Create;
end;

procedure TTagsVersesTabInfo.SaveState(const workspace: IWorkspace);
begin
// nothing to save
end;

procedure TTagsVersesTabInfo.RestoreState(const workspace: IWorkspace);
begin
// nothing to save
end;

{ TDictionaryTabInfo }

constructor TDictionaryTabInfo.Create();
begin
  inherited Create();
end;

constructor TDictionaryTabInfo.Create(settings: TDictionaryTabSettings);
begin
  inherited Create();
end;

function TDictionaryTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttDictionary;
end;

function TDictionaryTabInfo.GetCaption(): string;
begin
  Result := Lang.SayDefault('TabDictionary', 'Dictionary');
end;

function TDictionaryTabInfo.GetSettings(): TTabSettings;
begin
  Result := TDictionaryTabSettings.Create;
end;

procedure TDictionaryTabInfo.SaveState(const workspace: IWorkspace);
var
  dicFrame: TDictionaryFrame;
begin
  dicFrame := workspace.DictionaryView as TDictionaryFrame;
  with dicFrame do
  begin
    mSearchText := edtDic.Text;
    mDictionaryIndex := cbDicFilter.ItemIndex;
    mFoundDictionaryIndex := cbDic.ItemIndex;
  end;
end;

procedure TDictionaryTabInfo.RestoreState(const workspace: IWorkspace);
var
  dicFrame: TDictionaryFrame;
begin
  dicFrame := workspace.DictionaryView as TDictionaryFrame;
  dicFrame.UpdateSearch(mSearchText, mDictionaryIndex, mFoundDictionaryIndex);
end;

{ TStrongTabInfo }

constructor TStrongTabInfo.Create();
begin
  inherited Create();
end;

constructor TStrongTabInfo.Create(settings: TStrongTabSettings);
begin
  inherited Create();
end;

function TStrongTabInfo.GetCaption(): string;
begin
  Result := Lang.SayDefault('TabStrong', 'Strong');
end;

function TStrongTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttStrong;
end;

function TStrongTabInfo.GetSettings(): TTabSettings;
begin
  Result := TStrongTabSettings.Create;
end;

procedure TStrongTabInfo.SaveState(const workspace: IWorkspace);
var
  strongFrame: TStrongFrame;
begin
  strongFrame := workspace.StrongView as TStrongFrame;
  with strongFrame do
  begin
    mSearchText := edtStrong.Text;
    mStrongText := bwrStrong.DocumentSource;
    mSelectedStrong := GetSelectedStrong();
    mBookPath := GetBookPath();
  end;
end;

procedure TStrongTabInfo.RestoreState(const workspace: IWorkspace);
var
  strongFrame: TStrongFrame;
begin
  strongFrame := workspace.StrongView as TStrongFrame;
  with strongFrame do
  begin
    edtStrong.Text := mSearchText;
    bwrStrong.LoadFromString(mStrongText);

    SelectStrongWord(mSelectedStrong);
    SetCurrentBook(mBookPath);
  end;
end;

{ TCommentsTabInfo }

constructor TCommentsTabInfo.Create();
begin
  inherited Create();
  FBrowserState := TBrowserState.Create;
end;

constructor TCommentsTabInfo.Create(settings: TCommentsTabSettings);
begin
  Create();
end;

function TCommentsTabInfo.GetCaption(): string;
begin
  Result := Lang.SayDefault('TabCommentaries', 'Commentaries');
end;

function TCommentsTabInfo.GetViewType(): TViewTabType;
begin
  Result := vttComments;
end;

function TCommentsTabInfo.GetSettings(): TTabSettings;
begin
  Result := TCommentsTabSettings.Create;
end;

procedure TCommentsTabInfo.SaveState(const workspace: IWorkspace);
var
  commentsFrame: TCommentsFrame;
begin
  commentsFrame := workspace.CommentsView as TCommentsFrame;
  with commentsFrame do
  begin
    FMeaningfulOnly := sbtnMeaningfulOnly.Down;

    FCommentaryBookIndex := cbCommentSource.ItemIndex;

    SaveBrowserState(bwrComments);
  end;
end;

procedure TCommentsTabInfo.RestoreState(const workspace: IWorkspace);
var
  commentsFrame: TCommentsFrame;
begin
  commentsFrame := workspace.CommentsView as TCommentsFrame;
  with commentsFrame do
  begin
    sbtnMeaningfulOnly.Down := FMeaningfulOnly;

    FilterCommentSources();
    ShowComments();
    cbCommentSource.ItemIndex := FCommentaryBookIndex;

    RestoreBrowserState(bwrComments);
  end;
end;

procedure TCommentsTabInfo.SaveBrowserState(const HtmlViewer: THTMLViewer);
begin
  FBrowserState.SelStart := HtmlViewer.SelStart;
  FBrowserState.SelLenght := HtmlViewer.SelLength;
  FBrowserState.HScrollPos := HtmlViewer.HScrollBarPosition;
  FBrowserState.VScrollPos := HtmlViewer.VScrollBarPosition;
end;

procedure TCommentsTabInfo.RestoreBrowserState(const HtmlViewer: THTMLViewer);
begin
  if FBrowserState = nil then
    Exit;

  if (FBrowserState.SelStart >= 0) then
  begin
    HtmlViewer.SelStart := FBrowserState.SelStart;
    HtmlViewer.SelLength := FBrowserState.SelLenght;
  end;

  if (FBrowserState.HScrollPos >= 0) then
     HtmlViewer.HScrollBarPosition := FBrowserState.HScrollPos;

  if (FBrowserState.VScrollPos >= 0) then
     HtmlViewer.VScrollBarPosition := FBrowserState.VScrollPos;
end;

{ TViewTabDragObject }

constructor TViewTabDragObject.Create(aViewTabInfo: TBookTabInfo);
begin
  inherited Create();
  mViewTabInfo := aViewTabInfo;
end;

end.

