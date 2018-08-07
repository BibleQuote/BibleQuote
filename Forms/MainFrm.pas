unit MainFrm;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, Classes,
  ShlObj, contnrs, Clipbrd,
  Graphics, Controls,
  Forms, System.UITypes,
  ComCtrls, Generics.Collections,
  Menus, IOUtils, Math, SystemInfo,
  ExtCtrls, AppEvnts, ImgList, CoolTrayIcon, Dialogs,
  VirtualTrees, ToolWin, StdCtrls, rkGlassButton, IOProcs,
  Buttons, DockTabSet, Htmlview, SysUtils, SysHot, HTMLViewerSite,
  Bible, BibleQuoteUtils, ICommandProcessor, WinUIServices, TagsDb,
  VdtEditlink, bqGradientPanel, ModuleProcs,
  Engine, MultiLanguage, LinksParserIntf, MyLibraryFrm, HTMLEmbedInterfaces,
  MetaFilePrinter, Dict, Vcl.Tabs, System.ImageList, HTMLUn2, FireDAC.DatS,
  TabData, Favorites, ThinCaptionedDockTree,
  Vcl.CaptionedDockTree, LayoutConfig,
  ChromeTabs, ChromeTabsTypes, ChromeTabsUtils, ChromeTabsControls, ChromeTabsClasses,
  ChromeTabsLog, FontManager;

const

  ZOOMFACTOR = 1.5;
  MAXHISTORY = 1000;
  {
    такие увеличенные размеры позволяют сохранять ПРОПОРЦИИ окна
    координаты окна программы вычисляются в относительных единицах
  }
  MAXWIDTH = 25600; // 25600 делится на 640, 800 и 1024
  MAXHEIGHT = 218400; // делится на 480, 600 и 728

  bsText = 0;
  bsFile = 1;
  bsBookmark = 2;
  bsMemo = 3;
  bsHistory = 4;
  bsSearch = 5;

  Skips20 = '<A NAME="#endofchapterNMFHJAHSTDGF123">' +
    '<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>';

  DefaultTextTemplate = '<h1>%HEAD%</h1>' + #13#10#13#10 + '<font size=+1>' +
    #13#10 + '%TEXT%' + #13#10 + '</font>' + #13#10#13#10 + Skips20;

  DefaultSelTextColor = '#FF0000';

  DefaultLanguage = 'Русский';
  DefaultLanguageFile = 'Русский.lng';

type
  TBookNodeType = (btChapter, btBook);
  PBookNodeData = ^TBookNodeData;

  TBookNodeData = record
    Caption: string;
    NodeType: TBookNodeType;
  end;

  TNavigateResult = (
    nrSuccess,
    nrEndVerseErr,
    nrStartVerseErr,
    nrChapterErr,
    nrBookErr,
    nrModuleFail);

  TgmtOption = (gmtBulletDelimited, gmtEffectiveAddress, gmtLookupRefBibles);
  TgmtOptions = set of TgmtOption;

type
  TMainForm = class(TForm, IBibleQuoteCommandProcessor, IBibleWinUIServices, IuiVerseOperations, IVDTInfo)
    OpenDialog: TOpenDialog;
    SaveFileDialog: TSaveDialog;
    pnlModules: TPanel;
    PrintDialog: TPrintDialog;
    ColorDialog: TColorDialog;
    FontDialog: TFontDialog;
    sbxPreview: TScrollBox;
    pnlContainer: TPanel;
    pnlPage: TPanel;
    pbPreview: TPaintBox;
    pgcMain: TPageControl;
    tbSearch: TTabSheet;
    bwrSearch: THTMLViewer;
    tbDic: TTabSheet;
    tbStrong: TTabSheet;
    bwrDic: THTMLViewer;
    bwrStrong: THTMLViewer;
    tbComments: TTabSheet;
    bwrComments: THTMLViewer;
    pnlDic: TPanel;
    pnlStrong: TPanel;
    edtStrong: TEdit;
    lbStrong: TListBox;
    pnlSearch: TPanel;
    cbSearch: TComboBox;
    cbList: TComboBox;
    btnFind: TButton;
    tbGo: TTabSheet;
    pnlGo: TPanel;
    chkAll: TCheckBox;
    chkPhrase: TCheckBox;
    chkParts: TCheckBox;
    chkCase: TCheckBox;
    chkExactPhrase: TCheckBox;
    tbXRef: TTabSheet;
    bwrXRef: THTMLViewer;
    pmRef: TPopupMenu;
    miRefCopy: TMenuItem;
    miRefPrint: TMenuItem;
    cbQty: TComboBox;
    tbMemo: TTabSheet;
    reMemo: TRichEdit;
    pnlComments: TPanel;
    cbModules: TComboBox;
    cbComments: TComboBox;
    btnSearchOptions: TButton;
    pnlMemo: TPanel;
    lblMemo: TLabel;
    pmHistory: TPopupMenu;
    splMain: TSplitter;
    pgcHistoryBookmarks: TPageControl;
    tbHistory: TTabSheet;
    tbBookmarks: TTabSheet;
    lbHistory: TListBox;
    pmEmpty: TPopupMenu;
    cbDicFilter: TComboBox;
    pnlSelectDic: TPanel;
    cbDic: TComboBox;
    lblDicFoundSeveral: TLabel;
    lbBookmarks: TListBox;
    pnlBookmarks: TPanel;
    lblBookmark: TLabel;
    pnlFindStrongNumber: TPanel;
    trayIcon: TCoolTrayIcon;
    splGo: TSplitter;
    edtDic: TComboBox;
    mmGeneral: TMainMenu;
    miFile: TMenuItem;
    miActions: TMenuItem;
    miFavorites: TMenuItem;
    miHelpMenu: TMenuItem;
    miLanguage: TMenuItem;
    miPrint: TMenuItem;
    miPrintPreview: TMenuItem;
    miSave: TMenuItem;
    miOpen: TMenuItem;
    miFileSep1: TMenuItem;
    miOptions: TMenuItem;
    miFonts: TMenuItem;
    miColors: TMenuItem;
    miFileSep3: TMenuItem;
    miExit: TMenuItem;
    miFontConfig: TMenuItem;
    miRefFontConfig: TMenuItem;
    miDialogFontConfig: TMenuItem;
    miBGConfig: TMenuItem;
    miHrefConfig: TMenuItem;
    miFoundTextConfig: TMenuItem;
    miToggle: TMenuItem;
    miOpenPassage: TMenuItem;
    miQuickNav: TMenuItem;
    miSearch: TMenuItem;
    miQuickSearch: TMenuItem;
    miDic: TMenuItem;
    miStrong: TMenuItem;
    miComments: TMenuItem;
    miXref: TMenuItem;
    miNotepad: TMenuItem;
    miActionsSep1: TMenuItem;
    miCopy: TMenuItem;
    miCopyOptions: TMenuItem;
    miActionsSep2: TMenuItem;
    miSound: TMenuItem;
    miHotKey: TMenuItem;
    miAbout: TMenuItem;
    ilImages: TImageList;
    tlbMemo: TToolBar;
    tbtnMemoOpen: TToolButton;
    tbtnMemoSave: TToolButton;
    tbtnMemoPrint: TToolButton;
    tbtnSep1: TToolButton;
    tbtnMemoFont: TToolButton;
    tbtnSep2: TToolButton;
    tbtnMemoBold: TToolButton;
    tbtnMemoItalic: TToolButton;
    tbtnMemoUnderline: TToolButton;
    tbtnSep3: TToolButton;
    tbtnMemoPainter: TToolButton;
    tlbPanel: TGradientPanel;
    tlbMain: TToolBar;
    tbtnToggle: TToolButton;
    tbtnSep01: TToolButton;
    tbtnSep04: TToolButton;
    tbtnPreview: TToolButton;
    tbtnPrint: TToolButton;
    tbtnSep05: TToolButton;
    tbtnSound: TToolButton;
    tbtnCopyright: TToolButton;
    tbtnSatellite: TToolButton;
    tbtnNewTab: TToolButton;
    tbtnCloseTab: TToolButton;
    miFileSep2: TMenuItem;
    miNewTab: TMenuItem;
    miCloseTab: TMenuItem;
    tbtnLastSeparator: TToolButton;
    lblSearch: TLabel;
    cbLinks: TComboBox;
    miDeteleBibleTab: TMenuItem;
    tbLinksToolBar: TToolBar;
    lblTitle: TLabel;
    lblCopyRightNotice: TLabel;
    miOpenNewView: TMenuItem;
    miChooseSatelliteBible: TMenuItem;
    appEvents: TApplicationEvents;
    tbList: TTabSheet;
    tbtnLib: TToolButton;
    reClipboard: TRichEdit;
    tlbTags: TToolBar;
    tbtnAddNode: TToolButton;
    tbtnDelNode: TToolButton;
    vdtTagsVerses: TVirtualDrawTree;
    vstDicList: TVirtualStringTree;
    miRecognizeBibleLinks: TMenuItem;
    tbtnResolveLinks: TToolButton;
    miVerseHighlightBG: TMenuItem;
    ilPictures24: TImageList;
    miMyLibrary: TMenuItem;
    cbTagsFilter: TComboBox;
    btnOnlyMeaningful: TrkGlassButton;
    pmRecLinksOptions: TPopupMenu;
    miStrictLogic: TMenuItem;
    miFuzzyLogic: TMenuItem;
    tlbResolveLnks: TToolBar;
    tbtnSpace1: TToolButton;
    tbtnSpace2: TToolButton;
    miShowSignatures: TMenuItem;
    miView: TMenuItem;
    vdtModules: TVirtualStringTree;
    pnlStatusBar: TPanel;
    imgLoadProgress: TImage;
    tbtnNewForm: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure CopySelectionClick(Sender: TObject);
    procedure ChapterComboBoxKeyPress(Sender: TObject; var Key: Char);
    procedure tbtnPrintClick(Sender: TObject);
    procedure HistoryButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OpenButtonClick(Sender: TObject);
    procedure SearchButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnFindClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChapterComboBoxChange(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure miFontConfigClick(Sender: TObject);
    procedure miBGConfigClick(Sender: TObject);
    procedure miHrefConfigClick(Sender: TObject);
    procedure miFoundTextConfigClick(Sender: TObject);
    procedure miXrefClick(Sender: TObject);
    procedure tbtnSoundClick(Sender: TObject);
    procedure miHotkeyClick(Sender: TObject);
    procedure miDialogFontConfigClick(Sender: TObject);
    procedure miCopyPassageClick(Sender: TObject);
    procedure tbtnPreviewClick(Sender: TObject);
    procedure sbxPreviewResize(Sender: TObject);
    procedure pbPreviewPaint(Sender: TObject);
    procedure pbPreviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure miPrintPreviewClick(Sender: TObject);
    procedure lbHistoryDblClick(Sender: TObject);
    procedure miStrongClick(Sender: TObject);

    procedure bwrSearchHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);

    procedure FormShow(Sender: TObject);
    procedure cbLinksChange(Sender: TObject);
    procedure bwrDicHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure bwrCommentsHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure bwrStrongMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure DicLBDblClick(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure edtDicKeyPress(Sender: TObject; var Key: Char);
    procedure edtStrongKeyPress(Sender: TObject; var Key: Char);
    procedure tbtnToggleClick(Sender: TObject);
    procedure cbModulesChange(Sender: TObject);
    procedure lbStrongDblClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure bwrSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bwrSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtDicKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DicLBKeyPress(Sender: TObject; var Key: Char);
    procedure bwrDicMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure bwrXRefHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure miRefPrintClick(Sender: TObject);
    procedure miRefCopyClick(Sender: TObject);
    procedure tbtnMemoOpenClick(Sender: TObject);
    procedure tbtnMemoSaveClick(Sender: TObject);
    procedure tbtnMemoBoldClick(Sender: TObject);
    procedure tbtnMemoItalicClick(Sender: TObject);
    procedure tbtnMemoUnderlineClick(Sender: TObject);
    procedure tbtnMemoFontClick(Sender: TObject);
    procedure reMemoChange(Sender: TObject);
    procedure tbtnMemoPainterClick(Sender: TObject);
    procedure miNotepadClick(Sender: TObject);
    procedure cbCommentsChange(Sender: TObject);
    procedure btnSearchOptionsClick(Sender: TObject);
    procedure chkExactPhraseClick(Sender: TObject);
    procedure cbDicChange(Sender: TObject);
    procedure lbHistoryClick(Sender: TObject);
    procedure pgcMainChange(Sender: TObject);
    procedure miDicClick(Sender: TObject);
    procedure miCommentsClick(Sender: TObject);
    procedure cbQtyChange(Sender: TObject);
    procedure miRefFontConfigClick(Sender: TObject);
    procedure miQuickNavClick(Sender: TObject);
    procedure miQuickSearchClick(Sender: TObject);
    procedure tbtnCopyrightClick(Sender: TObject);
    procedure cbDicFilterChange(Sender: TObject);
    procedure lbBookmarksDblClick(Sender: TObject);
    procedure bwrStrongHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure lbBookmarksClick(Sender: TObject);
    procedure lbBookmarksKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbHistoryKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pnlFindStrongNumberMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure pnlFindStrongNumberMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure pnlFindStrongNumberClick(Sender: TObject);
    procedure miCopyOptionsClick(Sender: TObject);
    procedure miOptionsClick(Sender: TObject);
    procedure trayIconClick(Sender: TObject);
    procedure SysHotKeyHotKey(Sender: TObject; Index: integer);
    procedure tbtnMemoPrintClick(Sender: TObject);
    procedure tbtnSatelliteClick(Sender: TObject);
    procedure SelectSatelliteBibleByName(const bibleName: string);
    procedure edtDicChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miNewTabClick(Sender: TObject);
    procedure miDeteleBibleTabClick(Sender: TObject);

    procedure FormDeactivate(Sender: TObject);
    procedure cbModulesCloseUp(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbCommentsCloseUp(Sender: TObject);
    procedure LoadFontFromFolder(awsFolder: string);
    procedure miOpenNewViewClick(Sender: TObject);
    procedure pmRefPopup(Sender: TObject);
    procedure miChooseSatelliteBibleClick(Sender: TObject);
    procedure appEventsException(Sender: TObject; E: Exception);
    procedure InitQNavList();

    procedure tbtnLibClick(Sender: TObject);
    function OpenChapter(): Boolean;
    procedure NavigateToMainBookNode(book: TBible);
    function GetChildNodeByIndex(parentNode: PVirtualNode; Index: integer): PVirtualNode;
    function GetCurrentBookNode(): PVirtualNode;
    function IsPsalms(bookNodeIndex: integer): Boolean;
    procedure pgcMainMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure tbtnAddTagClick(Sender: TObject);

    procedure vdtTagsVersesMeasureItem(
    Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas;
      Node: PVirtualNode;
      var NodeHeight: integer);

    function PaintTokens(canv: TCanvas; rct: TRect; tkns: TObjectList; calc: Boolean): integer;
    procedure vdtTagsVersesDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
    function LoadAnchor(wb: THTMLViewer; SRC, current, loc: string): Boolean;
    procedure pgcMainMouseLeave(Sender: TObject);
    procedure miRecognizeBibleLinksClick(Sender: TObject);
    procedure miVerseHighlightBGClick(Sender: TObject);
    procedure cbListDropDown(Sender: TObject);
    procedure tbtnDelNodeClick(Sender: TObject);
    procedure cbSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vdtTagsVersesCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vdtTagsVersesResize(Sender: TObject);
    procedure vdtTagsVersesMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure vdtTagsVersesShowScrollBar(Sender: TBaseVirtualTree; Bar: integer; Show: Boolean);
    procedure vdtTagsVersesDblClick(Sender: TObject);
    procedure vdtTagsVersesInitNode(
      Sender: TBaseVirtualTree;
      parentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);

    procedure vdtTagsVersesScroll(Sender: TBaseVirtualTree; DeltaX, DeltaY: integer);
    procedure vdtTagsVersesStateChange(Sender: TBaseVirtualTree; Enter, Leave: TVirtualTreeStates);
    procedure vdtTagsVersesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vdtTagsVersesCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);

    procedure vdtTagsVersesGetNodeWidth(
      Sender: TBaseVirtualTree;
      HintCanvas: TCanvas;
      Node: PVirtualNode;
      Column: TColumnIndex;
      var NodeWidth: integer);

    procedure vdtTagsVersesEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);

    procedure cbTagsFilterChange(Sender: TObject);
    procedure btnOnlyMeaningfulClick(Sender: TObject);
    procedure tbtnResolveLinksClick(Sender: TObject);
    procedure miChooseLogicClick(Sender: TObject);
    procedure pmRecLinksOptionsChange(Sender: TObject; Source: TMenuItem; Rebuild: Boolean);
    procedure tbtnSatelliteMouseEnter(Sender: TObject);
    procedure imgLoadProgressClick(Sender: TObject);
    procedure cbCommentsDropDown(Sender: TObject);

    procedure vdtTagsVersesCompareNodes(
      Sender: TBaseVirtualTree;
      Node1, Node2: PVirtualNode;
      Column: TColumnIndex;
      var Result: integer);

    procedure vstDicListAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure miShowSignaturesClick(Sender: TObject);

    procedure vstDicListGetText(
      Sender: TBaseVirtualTree;
      Node: PVirtualNode;
      Column: TColumnIndex;
      TextType: TVSTTextType;
      var CellText: string);

    procedure vdtTagsVersesIncrementalSearch(
      Sender: TBaseVirtualTree;
      Node: PVirtualNode;
      const SearchText: string;
      var Result: integer);

    function CreateTabsView(viewName: string): ITabsView;
    procedure CreateInitialTabsView();
    function GenerateTabsViewName(): string;
    procedure OnTabsFormActivate(Sender: TObject);
    procedure OnTabsFormClose(Sender: TObject; var Action: TCloseAction);
    procedure CompareTranslations();
    procedure DictionariesLoading(Sender: TObject);
    procedure DictionariesLoaded(Sender: TObject);
    procedure ModulesScanDone(Sender: TObject);
    procedure ArchiveModuleLoadFailed(Sender: TObject; E: TBQException);

    procedure vdtModulesGetText(
      Sender: TBaseVirtualTree;
      Node: PVirtualNode;
      Column: TColumnIndex;
      TextType: TVSTTextType;
      var CellText: string);

    procedure vdtModulesInitNode(
      Sender: TBaseVirtualTree;
      parentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);

    procedure vdtModulesFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vdtModulesInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vdtModulesAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure bwrDicHotSpotCovered(Sender: TObject; const SRC: string);
    procedure bwrSearchHotSpotCovered(Sender: TObject; const SRC: string);
    procedure miCloseTabClick(Sender: TObject);
    procedure tbtnNewFormClick(Sender: TObject);

    procedure BookVerseFound(Sender: TObject; NumVersesFound, book, chapter, verse: integer; s: string);
    procedure BookChangeModule(Sender: TObject);
    procedure BookSearchComplete(Sender: TObject);
  public
    SysHotKey: TSysHotKey;

    FCurPreviewPage: integer;
    ZoomIndex: integer;
    Zoom: double;

    mBrowserDefaultFontName: string;
    mDictionariesFullyInitialized, mTaggedBookmarksLoaded: Boolean;
    mDefaultLocation: string;
    mBibleTabsInCtrlKeyDownState: Boolean;
    mHTMLSelection: string;
    SearchTime: int64;

    mIcn: TIcon;
    mFavorites: TFavoriteModules;
    mInterfaceLock: Boolean;
    mXRefMisUsed: Boolean;
    hint_expanded: integer; // 0 -not set, 1-short , 2-expanded
    mblSearchBooksDDAltered: Boolean;
    mslSearchBooksCache: TStringList;
    msbPosition: integer;
    mScrollAcc: integer;
    mscrollbarX: integer;
    mHTMLViewerSite: THTMLViewerSite;
    mFilterTagsTimer: TTimer;
    mBqEngine: TBibleQuoteEngine;
    mModuleLoader: TModuleLoader;
    mTranslated: Boolean;

    mTabsView: ITabsView;
    mTabsViews: TList<ITabsView>;

    // OLD VARABLES START
    mModules: TCachedModules;

    BrowserPosition: Longint; // this helps PgUp, PgDn to scroll chapters...
    SearchBrowserPosition: Longint; // list search results pages...
    SearchPage: integer; // what page we are in

    StrongHebrew, StrongGreek: TDict;
    StrongsDir: string;

    SatelliteBible: string;

    // FLAGS

    MainFormInitialized: Boolean; // for only one entrance into .FormShow

    HistoryOn: Boolean;

    MemoFilename: string;

    StrongNumbersOn: Boolean;

    SearchPageSize: integer;

    PrintFootNote: Boolean;

    AddressFromMenus: Boolean;
    IsSearching: Boolean;

    MainFormMaximized: Boolean;

    MemosOn: Boolean;

    Memos: TStringList;
    Bookmarks: TStringList;

    LastAddress: string;

    History: TStrings;
    SearchResults: TStrings;
    SearchWords: TStrings;

    LastSearchResultsPage: integer; // to show/hide page results (Ctrl-F3)

    HelpFileName: string;

    TemplatePath: string;
    SelTextColor: string; // color strings after search
    g_VerseBkHlColor: string;

    TextTemplate: string; // displaying passages

    PrevButtonHint, NextButtonHint: string;

    MainShiftState: TShiftState;

    CurVerseNumber, CurSelStart, CurSelEnd: integer;

    CurFromVerse, CurToVerse, VersePosition: integer;

    // config
    MainFormLeft, MainFormTop, MainFormWidth, MainFormHeight, MainPagesWidth,  Panel2Height: integer;

    miHrefUnderlineChecked, CopyOptionsCopyVerseNumbersChecked,
      CopyOptionsCopyFontParamsChecked, CopyOptionsAddModuleNameChecked,
      CopyOptionsAddReferenceChecked, CopyOptionsAddLineBreaksChecked: Boolean;

    mFlagFullcontextLinks: Boolean;
    mFlagHighlightVerses: Boolean;
    mFlagCommonProfile: Boolean;
    CopyOptionsAddReferenceRadioItemIndex: integer;

    mFontManager: TFontManager;

    ConfigFormHotKeyChoiceItemIndex: integer;
    UserDir: string;
    PasswordPolicy: TPasswordPolicy;
    tempBook: TBible;
    G_XRefVerseCmd: string;
    // OLD VARABLES END

    procedure WMQueryEndSession(var Message: TWMQueryEndSession);
      message WM_QUERYENDSESSION;

    procedure DrawMetaFile(PB: TPaintBox; mf: TMetaFile);
    function CreateNewBibleInstance(): TBible;

    procedure UpdateUI();

    procedure SetFirstTabInitialLocation(
      wsCommand, wsSecondaryView: string;
      const Title: string;
      state: TBookTabInfoState;
      visual: Boolean);

    procedure SaveTabsViews();
    procedure LoadTabsViews();

    function NewBookTab(
      const command: string;
      const satellite: string;
      const browserbase: string;
      state: TBookTabInfoState;
      const Title: string;
      visual: Boolean): Boolean;

    function FindTaggedTopMenuItem(tag: integer): TMenuItem;

    procedure AddBookmark(caption: string);
    procedure AddBookmarkTagged();
    function AddMemo(caption: string): Boolean;
    procedure CopyPassageToClipboard();

    function LoadDictionaries(foreground: Boolean): Boolean;
    function LoadModules(background: Boolean): Boolean;
    function LoadHotModulesConfig(): Boolean;
    procedure SaveHotModulesConfig(aMUIEngine: TMultiLanguage);
    function AddHotModule(const modEntry: TModuleEntry; tag: integer; addBibleTab: Boolean = true): integer;
    function FavoriteItemFromModEntry(const me: TModuleEntry): TMenuItem;
    function FavoriteTabFromModEntry(tabsView: ITabsView; const me: TModuleEntry): integer;
    procedure DeleteHotModule(moduleTabIx: integer); overload;
    function DeleteHotModule(const me: TModuleEntry): Boolean; overload;
    function ReplaceHotModule(const oldMe, newMe: TModuleEntry): Boolean;
    function InsertHotModule(newMe: TModuleEntry; ix: integer): integer;
    procedure SetFavouritesShortcuts();

    procedure UpdateDictionariesCombo();

    function UpdateFromCashed(): Boolean;

    procedure SaveMru();
    procedure LoadMru();
    procedure Idle(Sender: TObject; var Done: Boolean);
    procedure ForceForegroundLoad();
    procedure UpdateAllBooks();
    function DefaultLocation(): string;

    function RefBiblesCount(): integer;
    procedure FontChanged(delta: integer);
    function DicScrollNode(nd: PVirtualNode): Boolean;
    procedure LoadUserMemos();
    function LoadTaggedBookMarks(): Boolean;
    procedure SearchListInit;

    procedure GoPrevChapter;
    procedure GoNextChapter;

    function TranslateInterface(locFile: string): Boolean;

    procedure LoadConfiguration;
    procedure SaveConfiguration;
    procedure SetBibleTabsHintsState(showHints: Boolean = true);
    procedure MainMenuInit(cacheupdate: Boolean);
    procedure GoModuleName(s: string);

    procedure UpdateBooksAndChaptersBoxes(book: TBible);

    procedure LanguageMenuClick(Sender: TObject);

    function ChooseColor(color: TColor): TColor;

    procedure HotKeyClick(Sender: TObject);

    function CopyPassage(fromverse, toverse: integer): string;

    procedure HistoryAdd(s: string);
    procedure DisplayStrongs(num: integer; hebrew: Boolean);
    procedure DisplayDictionary(const s: string);

    procedure ConvertClipboard;

    procedure DisplaySearchResults(page: integer);

    function DictionaryStartup(maxAdd: integer = maxInt): Boolean;

    procedure ShowXref;
    procedure ShowComments;
    procedure ShowSearchTab();
    procedure ShowTagsTab();

    // finds the closest match for a word in merged
    // dictionary word list
    function LocateDicItem: integer;

    procedure ShowConfigDialog;
    procedure ShowQNav(useDisposition: TBQUseDisposition = udMyLibrary);
    procedure ShowQuickSearch();
    procedure SetVScrollTracker(aBrwsr: THTMLViewer);
    procedure VSCrollTracker(Sender: TObject);
    procedure EnableMenus(aEnabled: Boolean);
    procedure DeferredReloadViewPages();
    procedure AppOnHintHandler(Sender: TObject);
    procedure TagAdded(tagId: int64; const txt: string; Show: Boolean);
    procedure TagRenamed(tagId: int64; const newTxt: string);
    procedure TagDeleted(id: int64; const txt: string);
    procedure VerseAdded(verseId, tagId: int64; const cmd: string; Show: Boolean);
    procedure VerseDeleted(verseId, tagId: int64);
    function GetMainWindow(): TForm; // IbibleQuoteWinUIServices
    function GetIViewerBase(): IHtmlViewerBase; // IbibleQuoteWinUIServices

    procedure GetTextInfo(tree: TVirtualDrawTree; Node: PVirtualNode; Column: TColumnIndex; const AFont: TFont; var R: TRect; var Text: string);
    procedure SetNodeText(tree: TVirtualDrawTree; Node: PVirtualNode; Column: TColumnIndex; const Text: string);
    procedure InitializeTaggedBookMarks();
    procedure ReCalculateTagTree();
    function GetTagFilterTimer(): TTimer;
    procedure TagFilterTimerProc(Sender: TObject);
    procedure FilterTags(const FilterText: string);
    procedure InitHotkeysSupport();
    procedure CheckModuleInstall();
    function InstallModule(const path: string): integer;
    function FilterCommentariesCombo(): integer;
    function InstallFont(const specialPath: string): HRESULT;
    procedure TranslateConfigForm;
    procedure FillLanguageMenu;
    function GetLocalizationDirectory(): string;
    function ApplyInitialTranslation(): Boolean;
    procedure TranslateControl(form: TWinControl; fname: string = '');
    procedure ShowReferenceInfo();
    procedure GoReference();
    function DefaultBookTabState(): TBookTabInfoState;
    procedure CopyVerse();

    procedure SelectModuleTreeNode(bible: TBible);
    property FontManager: TFontManager read mFontManager;
  public
    mHandCur: TCursor;

    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure SetCurPreviewPage(Val: integer);
    function PassWordFormShowModal(const aModule: WideString; out Pwd: WideString; out savePwd: Boolean): integer;
    function DicSelectedItemIndex(out pn: PVirtualNode): integer; overload;
    function DicSelectedItemIndex(): integer; overload;
    property CurPreviewPage: integer read FCurPreviewPage write SetCurPreviewPage;

    function GetAutoTxt(
      const cmd: string;
      maxWords: integer;
      out fnt: string;
      out passageSignature: string): string;
  end;

var
  MainForm: TMainForm;
  MFPrinter: TMetaFilePrinter;
  G_ControlKeyDown: Boolean;
  LastLanguageFile: string;

implementation

uses CopyrightFrm, InputFrm, ConfigFrm, PasswordDlg,
  BibleQuoteConfig,
  ExceptionFrm, AboutFrm, ShellAPI,
  StrUtils, CommCtrl, DockTabsFrm,

  HintTools, sevenZipHelper, BookFra,
  Types, BibleLinkParser, IniFiles, PlainUtils, GfxRenderers, CommandProcessor,
  EngineInterfaces, StringProcs, LinksParser;

{$R *.DFM}

function GetTabsView(mainForm: TMainForm): TDockTabsForm;
begin
  if not Assigned(mainForm.mTabsView) then
    Result := nil
  else
    Result := mainForm.mTabsView as TDockTabsForm;
end;

function GetBookView(mainForm: TMainForm): TBookFrame;
var dockView: TDockTabsForm;
begin
  dockView := GetTabsView(mainForm);
  if not Assigned(dockView) then
    Result := nil
  else
    Result := dockView.BookView as TBookFrame;
end;

procedure ClearVolatileStateData(var state: TBookTabInfoState);
begin
  state := state * [vtisShowNotes, vtisShowStrongs, vtisResolveLinks, vtisFuzzyResolveLinks];
end;

function TMainForm.DefaultBookTabState(): TBookTabInfoState;
begin
  Result := [vtisShowNotes, vtisResolveLinks];
end;

procedure TMainForm.UpdateBooksAndChaptersBoxes(book: TBible);
var
  uifont: string;
begin
  vdtModules.Clear;

  if (Length(book.DesiredUIFont) > 0) then
    begin
      uifont := mFontManager.SuggestFont(self.Canvas.Handle, book.DesiredUIFont, book.path, $0007F);
    end
    else
    begin
      uifont := self.Font.Name
    end;

  if vdtModules.Font.Name <> uifont then
    vdtModules.Font.Name := uifont;

  vdtModules.RootNodeCount := book.BookQty;
  NavigateToMainBookNode(book);
end;

procedure TMainForm.HistoryAdd(s: string);
begin
  if (not HistoryOn) or ((History.Count > 0) and (History[0] = s)) then
    Exit;

  if History.Count >= MAXHISTORY then
  begin
    History.Delete(History.Count - 1);
    lbHistory.Items.Delete(lbHistory.Items.Count - 1);
  end;

  History.Insert(0, s);

  lbHistory.Items.Insert(0, Comment(s));
  lbHistory.ItemIndex := 0;
end;

procedure TMainForm.HotKeyClick(Sender: TObject);
begin
  GoModuleName((Sender as TMenuItem).Caption);
end;

procedure TMainForm.LoadConfiguration;
var
  fname: string;
  fnt: TFont;
begin
  try
    UserDir := CreateAndGetConfigFolder;
    try
      PasswordPolicy := TPasswordPolicy.Create(UserDir + C_PasswordPolicyFileName);
    except
      on E: Exception do
      begin
        BqShowException(E, '', true);

      end;
    end;
    MainCfgIni := TMultiLanguage.Create(self);
    try
      MainCfgIni.inifile := UserDir + C_ModuleIniName;
    except
      on E: Exception do
        BqShowException(E, 'Cannot Load Configuration file!');
    end;

    mBrowserDefaultFontName := MainCfgIni.SayDefault('DefFontName', 'Microsoft Sans Serif');
    g_VerseBkHlColor := Color2Hex(Hex2Color(MainCfgIni.SayDefault('VerseBkHLColor', Color2Hex(clInfoBk)))); // '#F5F5DC'

    MainFormWidth := (StrToInt(MainCfgIni.SayDefault('MainFormWidth', '0')) * Screen.Width) div MAXWIDTH;
    MainFormHeight := (StrToInt(MainCfgIni.SayDefault('MainFormHeight', '0')) * Screen.Height) div MAXHEIGHT;
    MainFormLeft := (StrToInt(MainCfgIni.SayDefault('MainFormLeft', '0')) * Screen.Width) div MAXWIDTH;
    MainFormTop := (StrToInt(MainCfgIni.SayDefault('MainFormTop', '0')) * Screen.Height) div MAXHEIGHT;
    MainFormMaximized := MainCfgIni.SayDefault('MainFormMaximized', '0') = '1';

    MainPagesWidth := (StrToInt(MainCfgIni.SayDefault('MainPagesWidth', '0')) * Screen.Height) div MAXHEIGHT;
    Panel2Height := (StrToInt(MainCfgIni.SayDefault('Panel2Height', '0')) * Screen.Height) div MAXHEIGHT;

    fnt := TFont.Create;
    fnt.Name := MainCfgIni.SayDefault('MainFormFontName', 'Microsoft Sans Serif');

    fnt.Size := StrToInt(MainCfgIni.SayDefault('MainFormFontSize', '9'));

    miRecognizeBibleLinks.Enabled := true;
    tbtnResolveLinks.Enabled := true;
    MainForm.Font := fnt;

    Screen.HintFont.Assign(fnt);
    Screen.HintFont.Height := Screen.HintFont.Height * 5 div 4;
    Application.HintColor := $FDF9F4;

    MainForm.Update;
    fnt.Free;

    Prepare(ExtractFilePath(Application.ExeName) + 'biblebooks.cfg', Output);

    with bwrSearch do
    begin
      DefFontName := MainCfgIni.SayDefault('RefFontName', 'Microsoft Sans Serif');
      DefFontSize := StrToInt(MainCfgIni.SayDefault('RefFontSize', '12'));
      DefFontColor := Hex2Color(MainCfgIni.SayDefault('RefFontColor', Color2Hex(clWindowText)));

      DefBackGround := Hex2Color(MainCfgIni.SayDefault('DefBackground', Color2Hex(clWindow))); // '#EBE8E2'
      DefHotSpotColor := Hex2Color(MainCfgIni.SayDefault('DefHotSpotColor', Color2Hex(clHotLight))); // '#0000FF'
    end;

    with bwrDic do
    begin
      DefFontName := bwrSearch.DefFontName;
      DefFontSize := bwrSearch.DefFontSize;
      DefFontColor := bwrSearch.DefFontColor;

      DefBackGround := bwrSearch.DefBackGround;
      DefHotSpotColor := bwrSearch.DefHotSpotColor;
    end;

    with bwrStrong do
    begin
      DefFontName := bwrSearch.DefFontName;
      DefFontSize := bwrSearch.DefFontSize;
      DefFontColor := bwrSearch.DefFontColor;

      DefBackGround := bwrSearch.DefBackGround;
      DefHotSpotColor := bwrSearch.DefHotSpotColor;
    end;

    with bwrComments do
    begin
      DefFontName := bwrSearch.DefFontName;
      DefFontSize := bwrSearch.DefFontSize;
      DefFontColor := bwrSearch.DefFontColor;

      DefBackGround := bwrSearch.DefBackGround;
      DefHotSpotColor := bwrSearch.DefHotSpotColor;
    end;

    with bwrXRef do
    begin
      DefFontName := bwrSearch.DefFontName;
      DefFontSize := bwrSearch.DefFontSize;
      DefFontColor := bwrSearch.DefFontColor;

      DefBackGround := bwrSearch.DefBackGround;
      DefHotSpotColor := bwrSearch.DefHotSpotColor;

      // this browser doesn't have underlines...
      htOptions := htOptions + [htNoLinkUnderline];
    end;

    LastLanguageFile := MainCfgIni.SayDefault('LastLanguageFile', '');
    LastAddress := MainCfgIni.SayDefault('LastAddress', '');
    G_SecondPath := MainCfgIni.SayDefault('SecondPath', '');

    SatelliteBible := MainCfgIni.SayDefault('SatelliteBible', '');
    mFavorites := TFavoriteModules.Create(AddHotModule, DeleteHotModule,
      ReplaceHotModule, InsertHotModule, ForceForegroundLoad);

    SaveFileDialog.InitialDir := MainCfgIni.SayDefault('SaveDirectory', GetMyDocuments);
    SelTextColor := MainCfgIni.SayDefault('SelTextColor', Color2Hex(clRed));
    PrintFootNote := MainCfgIni.SayDefault('PrintFootNote', '1') = '1';

    // by default, these are checked
    miHrefUnderlineChecked := MainCfgIni.SayDefault('HrefUnderline', '0') = '1';
    mFlagFullcontextLinks := MainCfgIni.SayDefault(C_opt_FullContextLinks, '1') = '1';
    mFlagHighlightVerses := MainCfgIni.SayDefault(C_opt_HighlightVerseHits, '1') = '1';

    try
      fname := UserDir + 'bibleqt_bookmarks.ini';
      if FileExists(fname) then
        Bookmarks.LoadFromFile(fname);
    except
      on E: Exception do
        BqShowException(E)
    end;
    LoadUserMemos();
    mslSearchBooksCache := TStringList.Create();
    LoadMru();

    try
      fname := UserDir + 'bibleqt_history.ini';
      if FileExists(fname) then
        History.LoadFromFile(fname);
    except
      on E: Exception do
        BqShowException(E)
    end;
    // COPYING OPTIONS
    CopyOptionsCopyVerseNumbersChecked :=  MainCfgIni.SayDefault('CopyOptionsCopyVerseNumbers', '1') = '1';
    CopyOptionsCopyFontParamsChecked := MainCfgIni.SayDefault('CopyOptionsCopyFontParams', '0') = '1';
    CopyOptionsAddReferenceChecked := MainCfgIni.SayDefault('CopyOptionsAddReference', '1') = '1';
    CopyOptionsAddReferenceRadioItemIndex := StrToInt(MainCfgIni.SayDefault('CopyOptionsAddReferenceRadio', '1'));
    CopyOptionsAddLineBreaksChecked := MainCfgIni.SayDefault('CopyOptionsAddLineBreaks', '1') = '1';
    CopyOptionsAddModuleNameChecked := MainCfgIni.SayDefault('CopyOptionsAddModuleName', '0') = '1';

    ConfigFormHotKeyChoiceItemIndex := StrToInt(MainCfgIni.SayDefault('ConfigFormHotKeyChoiceItemIndex', '0'));

    trayIcon.MinimizeToTray := MainCfgIni.SayDefault('MinimizeToTray', '0') = '1';
  except
    on E: Exception do
      BqShowException(E)
  end;
end;

function TMainForm.GetAutoTxt(
  const cmd: string;
  maxWords: integer;
  out fnt: string;
  out passageSignature: string): string;
var
  bookView: TBookFrame;
begin
  Result := '';
  bookView := GetBookView(self);
  if Assigned(bookView) then
    Result := bookView.GetAutoTxt(cmd, maxWords, fnt, passageSignature);
end;

function TMainForm.CreateTabsView(viewName: string): ITabsView;
var
  tabsForm: TDockTabsForm;
  h: Integer;
begin
  tabsForm := TDockTabsForm.Create(self, self);
  tabsForm.SetViewName(viewName);

  TranslateControl(tabsForm.BookView as TBookFrame, 'DockTabsForm');

  with tabsForm.Browser do
  begin
    DefFontName := mBrowserDefaultFontName;
    DefFontSize := StrToInt(MainCfgIni.SayDefault('DefFontSize', '12'));
    DefFontColor := Hex2Color(MainCfgIni.SayDefault('DefFontColor', Color2Hex(clWindowText))); // '#000000'
    DefBackGround := Hex2Color(MainCfgIni.SayDefault('DefBackground', Color2Hex(clWindow))); // '#EBE8E2'
    DefHotSpotColor := Hex2Color(MainCfgIni.SayDefault('DefHotSpotColor', Color2Hex(clHotLight))); // '#0000FF'
  end;

  if miHrefUnderlineChecked then
     tabsForm.Browser.htOptions := tabsForm.Browser.htOptions - [htNoLinkUnderline]
  else
     tabsForm.Browser.htOptions := tabsForm.Browser.htOptions + [htNoLinkUnderline];

  SetVScrollTracker(tabsForm.Browser);

  (tabsForm.BookView as TBookFrame).miMemosToggle.Checked := MemosOn;
  tabsForm.BibleTabs.Font.Assign(self.Font);

  h := self.Font.Height;
  if h < 0 then
    h := -h;

  tabsForm.BibleTabs.Height := h + 13;
  tabsForm.Caption := '';
  tabsForm.OnActivate := self.OnTabsFormActivate;
  tabsForm.OnClose := self.OnTabsFormClose;

  mTabsViews.Add(tabsForm as ITabsView);

  Result := tabsForm;
end;

function TMainForm.GenerateTabsViewName(): string;
var guid: TGUID;
begin
  CreateGUID(guid);
  Result := 'DockTabsForm_' + Format('%0.8X%0.4X%0.4X%0.2X%0.2X%0.2X%0.2X%0.2X%0.2X%0.2X%0.2X',
       [guid.D1, guid.D2, guid.D3,
       guid.D4[0], guid.D4[1], guid.D4[2], guid.D4[3],
       guid.D4[4], guid.D4[5], guid.D4[6], guid.D4[7]]);
end;

procedure TMainForm.CreateInitialTabsView();
var
  tabsForm: TDockTabsForm;
  tabInfo: TBookTabInfo;
  book, secondBook, refBook: TBible;
begin
  tabsForm := CreateTabsView(GenerateTabsViewName()) as TDockTabsForm;

  book := CreateNewBibleInstance();
  secondBook := TBible.Create(self);
  refBook := TBible.Create(self);

  tabInfo := TBookTabInfo.Create(book, '', SatelliteBible, '', DefaultBookTabState());
  tabInfo.SecondBible := secondBook;
  tabInfo.ReferenceBible := refBook;

  tabsForm.AddBookTab(tabInfo, book.Name);

  tabsForm.ManualDock(pnlModules);
  tabsForm.Show;

  mTabsView := tabsForm;
end;

procedure TMainForm.OnTabsFormClose(Sender: TObject; var Action: TCloseAction);
var
  tabsView: TDockTabsForm;
begin
  if (Sender is TDockTabsForm) then
  begin
    tabsView := Sender as TDockTabsForm;
    mTabsViews.Remove(tabsView as ITabsView);

    if (mTabsViews.Count > 0) then
    begin
      if (mTabsViews[0] is TDockTabsForm) then
        OnTabsFormActivate(mTabsViews[0] as TDockTabsForm);
    end;
  end;
end;

procedure TMainForm.OnTabsFormActivate(Sender: TObject);
var
  tabsForm: TDockTabsForm;
  tabInfo: IViewTabInfo;
begin
  tabsForm := Sender as TDockTabsForm;

  if Assigned(tabsForm) then
  begin
    if (mTabsView <> tabsForm as ITabsView) then
    begin
      mTabsView := tabsForm;

      // sync main form UI
      UpdateUI();

      // restore active tab state
      tabInfo := tabsForm.GetActiveTabInfo();
      if Assigned(tabInfo) then
        tabInfo.RestoreState(tabsForm);
    end;
  end;
end;

procedure TMainForm.LoadFontFromFolder(awsFolder: string);
var
  sr: TSearchRec;
  R: integer;
  searchPath: string;
begin
  try
    searchPath := TPath.Combine(awsFolder, '*.ttf');
    R := FindFirst(searchPath, faArchive or faReadOnly or faHidden, sr);
    if R <> 0 then
      Exit; // abort;
    repeat
      mFontManager.PrepareFont(FileRemoveExtension(sr.Name), awsFolder);
      R := FindNext(sr);
    until R <> 0;

  finally
    FindClose(sr);
  end;

end;

function TMainForm.LoadHotModulesConfig(): Boolean;
var
  fn1, fn2: string;
  f1Exists, f2Exists: Boolean;
  tabsView: ITabsView;
begin
  try

    Result := false;
    for tabsView in mTabsViews do
    begin
        tabsView.BibleTabs.Tabs.Clear();
        tabsView.BibleTabs.Tabs.Add('***');
    end;

    fn1 := CreateAndGetConfigFolder() + C_HotModulessFileName;
    f1Exists := FileExists(fn1);
    if f1Exists then
    begin
      mFavorites.LoadModules(mModules, fn1)
    end
    else
    begin
      fn2 := ExePath + 'hotlist.txt';
      f2Exists := FileExists(fn2);
      if f2Exists then
      begin
        mFavorites.LoadModules(mModules, fn2)
      end
    end;

  except
    on E: Exception do
    begin
      BqShowException(E);
      Result := false;
    end
  end;

end;

procedure TMainForm.SaveHotModulesConfig(aMUIEngine: TMultiLanguage);
begin
  mFavorites.SaveModules(CreateAndGetConfigFolder + C_HotModulessFileName);
end;

function TMainForm.LoadDictionaries(foreground: Boolean): Boolean;
begin
  Result := mBqEngine[bqsDictionariesLoaded];
  if not Result then
  begin
    if mBqEngine[bqsDictionariesLoading] then
    begin
      if not foreground then
        Exit; // just wait
    end;

    mIcn := TIcon.Create;
    ilImages.GetIcon(17, mIcn);
    imgLoadProgress.Picture.Graphic := mIcn;
    imgLoadProgress.Show();

    mBqEngine.LoadDictionaries(TPath.Combine(ModulesDirectory, C_DictionariesSubDirectory), foreground);
    if not foreground then
      Exit;
  end;
  // init dic tokens list
  Result := mBqEngine[bqsDictionariesListCreated];
  if not Result then
  begin
    if mBqEngine[bqsDictionariesListCreating] and (not foreground) then
    begin
      Exit; // just wait
    end;
    mBqEngine.InitDictionaryItemsList(foreground);
    if not foreground then
      Exit;
  end;

  UpdateDictionariesCombo();
  DictionaryStartup();

  mDictionariesFullyInitialized := true;
  Result := true;

  imgLoadProgress.Hide();
  FreeAndNil(mIcn);
end;

function TMainForm.LoadModules(background: Boolean): Boolean;
var
  icn: TIcon;
begin
  Result := false;
  try
    if not Assigned(tempBook) then
    begin
      tempBook := TBible.Create(self);

      icn := TIcon.Create;
      ilImages.GetIcon(33, icn);
      imgLoadProgress.Picture.Graphic := icn;
      imgLoadProgress.Show();
    end;

    Result := mModuleLoader.LoadModules(tempBook, background);
  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;

procedure TMainForm.DictionariesLoading(Sender: TObject);
begin
  mIcn := TIcon.Create;
  ilImages.GetIcon(17, mIcn);
  imgLoadProgress.Picture.Graphic := mIcn;
  imgLoadProgress.Show();
end;

procedure TMainForm.DictionariesLoaded(Sender: TObject);
begin
  UpdateDictionariesCombo();
  DictionaryStartup();
  mDictionariesFullyInitialized := true;

  imgLoadProgress.Hide();
  FreeAndNil(mIcn);
end;

procedure TMainForm.ModulesScanDone(Sender: TObject);
begin
  if not Assigned(mModules) then
    mModules := TCachedModules.Create(true);

  mModules.Assign(mModuleLoader.CachedModules);
end;

procedure TMainForm.ArchiveModuleLoadFailed(Sender: TObject; E: TBQException);
begin
  MessageBoxW(self.Handle, PWideChar(Pointer(E.mMessage)), nil, MB_ICONERROR or MB_OK);
end;

procedure TMainForm.SaveMru;
var
  mi: TMemIniFile;

  procedure WriteLst(lst: TStrings; const section: string);
  var
    i, C: integer;
    sc: string;

  begin
    try
      C := lst.Count - 1;
      sc := section;

      for i := 0 to C do
      begin
        mi.WriteString(sc, Format('Item%.3d', [i]), lst[i]);
      end;
    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;
  end;

begin
  mi := nil;

  mi := TMemIniFile.Create(UserDir + 'mru.lst', TEncoding.UTF8);
  mi.Clear();
  try

    WriteLst(cbSearch.Items, cbSearch.Name);
    WriteLst(mslSearchBooksCache, 'SearchBooks');
    mi.UpdateFile();
  finally
    mi.Free();
  end;

end;

procedure TMainForm.LoadMru;
var
  mi: TMemIniFile;
  sl: TStringList;
  sectionVals: TStringList;

  procedure LoadLst(lst: TStrings; const section: string);
  var
    i, C: integer;
    sc: string;
    Val: string;
  begin
    try
      lst.Clear();
      sc := section;
      mi.ReadSectionValues(sc, sectionVals);
      C := sectionVals.Count - 1;
      if C > 400 then
        C := 400;

      for i := 0 to C do
      begin
        Val := sectionVals.ValueFromIndex[i];
        if lst.IndexOf(Val) < 0 then
          lst.Add(Val);
      end;

    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;
  end;

begin
  mi := nil;
  mi := TMemIniFile.Create(UserDir + 'mru.lst', TEncoding.UTF8);
  sl := TStringList.Create();
  sectionVals := TStringList.Create();
  try

    LoadLst(cbSearch.Items, cbSearch.Name);
    LoadLst(mslSearchBooksCache, 'SearchBooks');

  finally
    mi.Free();
    sl.Free();
    sectionVals.Free();
  end;

end;

function DecodeBookTabState(Val: UInt64): TBookTabInfoState;
var
  trimmed: UInt64;
begin
  if Val > 1000 then
    Result := [vtisFuzzyResolveLinks]
  else
    Result := [];
  trimmed := (Val mod 1000); // effectively extract fist 3 digits
  if (trimmed > 100) then
    Include(Result, vtisResolveLinks);
  if (trimmed mod 100) >= 10 then
    Include(Result, vtisShowStrongs);
  if odd(trimmed) then
    Include(Result, vtisShowNotes);
end;

procedure TMainForm.LoadTabsViews();
var
  tabIx, i, activeTabIx: integer;
  strongNotesCode: UInt64;
  location, secondBible, Title: string;
  addTabResult, firstTabInitialized: Boolean;
  initTabInfo: TBookTabInfo;
  tabViewState: TBookTabInfoState;
  layoutConfig: TLayoutConfig;
  tabSettings: TTabSettings;
  tabsViewSettings: TTabsViewSettings;
  isFirstTabsView: boolean;
  tabsForm: TDockTabsForm;
  fileStream: TFileStream;
  tabsConfigPath, layoutConfigPath: string;
  newTab: TChromeTab;
  book: TBible;
begin
  tabsConfigPath := UserDir + 'layout_tabs.json';
  layoutConfigPath := UserDir + 'layout_forms.dat';

  firstTabInitialized := false;
  try
    if (not FileExists(tabsConfigPath)) then
    begin
      CreateInitialTabsView();
      SetFirstTabInitialLocation(LastAddress, '', '', DefaultBookTabState(), true);
      Exit;
    end;

    layoutConfig := TLayoutConfig.Load(tabsConfigPath);
    isFirstTabsView := true;

    for tabsViewSettings in layoutConfig.TabsViewList do
    begin
      activeTabIx := -1;
      tabIx := 0;
      i := 0;

      if (not isFirstTabsView) then
      begin
        tabsForm := CreateTabsView(tabsViewSettings.ViewName) as TDockTabsForm;
      end
      else
      begin
        tabsForm := CreateTabsView(tabsViewSettings.ViewName) as TDockTabsForm;
        book := CreateNewBibleInstance();

        initTabInfo := TBookTabInfo.Create(book, '', SatelliteBible, '', DefaultBookTabState());
        initTabInfo.SecondBible := TBible.Create(self);
        initTabInfo.ReferenceBible := TBible.Create(self);

        tabsForm.AddBookTab(initTabInfo, book.Name);
      end;

      if (tabsViewSettings.Docked) then
        tabsForm.ManualDock(pnlModules)
      else
      begin
        tabsForm.Left := tabsViewSettings.Left;
        tabsForm.Top := tabsViewSettings.Top;
        tabsForm.Height := tabsViewSettings.Height;
        tabsForm.Width := tabsViewSettings.Width;
      end;

      tabsForm.Show;
      mTabsView := tabsForm;

      for tabSettings in tabsViewSettings.TabSettingsList do
      begin
        if (tabSettings.Active) then
          activeTabIx := i;

        secondBible := tabSettings.SecondBible;
        Title := tabSettings.Title;
        strongNotesCode := tabSettings.StrongNotesCode;
        if (strongNotesCode <= 0) then
          strongNotesCode := 101;

        tabViewState := DecodeBookTabState(strongNotesCode);

        location := tabSettings.Location;
        if Length(Trim(location)) > 0 then
        begin
          if ((tabIx > 0) or not isFirstTabsView) then
            addTabResult := NewBookTab(location, secondBible, '', tabViewState, Title, (tabIx = activeTabIx) or ((Length(Title) = 0)))
          else
          begin
            addTabResult := true;
            SetFirstTabInitialLocation(location, secondBible, Title, tabViewState, (tabIx = activeTabIx) or ((Length(Title) = 0)));
            firstTabInitialized := true;
          end;
        end
        else
          addTabResult := false;

        if (addTabResult) then
          inc(tabIx);

        inc(i);
      end;

      if (activeTabIx < 0) or (activeTabIx >= mTabsView.ChromeTabs.Tabs.Count) then
          activeTabIx := 0;

      mTabsView.ChromeTabs.ActiveTabIndex := activeTabIx;
      mTabsView.UpdateBookView();

      isFirstTabsView := false;
    end;

    if (firstTabInitialized and TFile.Exists(layoutConfigPath)) then
    begin
        fileStream := TFileStream.Create(layoutConfigPath, fmOpenRead);
        pnlModules.DockManager.LoadFromStream(fileStream);
        fileStream.Free;
    end;

  except
    on E: Exception do
      BqShowException(E);
  end;

  if not firstTabInitialized then
  begin
    CreateInitialTabsView();
    SetFirstTabInitialLocation(LastAddress, '', '', DefaultBookTabState(), true);
  end;
end;

function TMainForm.LoadTaggedBookMarks(): Boolean;
var
  i, j, pc, C: integer;
  nd, tn: TVersesNodeData;
  failed: boolean;

  procedure Fail();
  begin
    tbList.PageControl := nil;
    pgcMain.ActivePageIndex := 0;
    GetBookView(self).miAddBookmarkTagged.Visible := false;
  end;

begin
  failed := false;
  Result := false;
  try
    if mTaggedBookmarksLoaded then
    begin
      Result := true;
      Exit;
    end;

    if not mBqEngine[bqsVerseListEngineInitialized] then
      mBqEngine.InitVerseListEngine(self, true);

    if not TagsDbEngine.fdTagsConnection.Connected then
    begin
      Fail();
      Exit;
    end;
    if mBqEngine.CacheTagNames() <> S_OK then
    begin
      Fail();
      Exit
    end;

    vdtTagsVerses.BeginUpdate();
    try
      vdtTagsVerses.Clear();
      C := mBqEngine.VersesTagsList.Count;
      i := 0;
      while (i < C) and (TVersesNodeData(mBqEngine.VersesTagsList[i])
        .nodeType = bqvntTag) do
      begin
        nd := TVersesNodeData(mBqEngine.VersesTagsList[i]);
        PVirtualNode(nd.Parents) := vdtTagsVerses.InsertNode(nil, amAddChildLast, nd);
        inc(i);
      end;

      while (i < C) do
      begin
        nd := TVersesNodeData(mBqEngine.VersesTagsList[i]);
        if (Assigned(nd.Parents)) and (nd.nodeType = bqvntVerse) then
        begin
          pc := nd.Parents.Count - 1;
          for j := 0 to pc do
          begin
            tn := TVersesNodeData(nd.Parents[j]);
            if not Assigned(tn) then
              continue;
            vdtTagsVerses.InsertNode(PVirtualNode(tn.Parents), amAddChildLast, nd);
          end;

        end;
        inc(i);
      end;
    finally
      vdtTagsVerses.EndUpdate();
    end;
    mTaggedBookmarksLoaded := true;
  except
    on E: Exception do
    begin
      Fail();
      failed := true;
      BqShowException(E, 'LoadTaggedBookmarks failed');
    end;
  end;
  vdtTagsVerses.Sort(nil, -1, sdAscending);
  if not failed then
    Result := true;
end;

procedure TMainForm.LoadUserMemos;
var
  oldPath, newpath: string;
  sl: TStringList;
  i, C: integer;
  s: string;
begin
  try
    newpath := UserDir + 'UserMemos.mls';
    if FileExists(newpath) then
    begin
      Memos.LoadFromFile(newpath);
      Exit;
    end;
    oldPath := UserDir + 'bibleqt_memos.ini';
    if not FileExists(oldPath) then
      Exit;
    sl := nil;
    try
      sl := TStringList.Create();
      sl.LoadFromFile(oldPath);
      C := sl.Count - 1;
      Memos.Clear();
      for i := 0 to C do
      begin
        s := sl[i];
        if Length(s) > 2 then
          Memos.Add(s);
      end; // for
    except
      on E: Exception do
        BqShowException(E)
    end;
    sl.Free();
  except
    on E: Exception do
      BqShowException(E)
  end;
end;

procedure TMainForm.SaveConfiguration;
var
  ini: TMultiLanguage;
  fname: string;
  i: integer;
begin
  try

    UserDir := CreateAndGetConfigFolder;
    writeln(NowDateTimeString(), ':SaveConfiguration, userdir:', UserDir);

    SaveTabsViews();
    try
      mModuleLoader.SaveCachedModules();
    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;
    PasswordPolicy.SaveToFile(UserDir + C_PasswordPolicyFileName);

    ini := TMultiLanguage.Create(self);
    ini.inifile := UserDir + C_ModuleIniName;

    if MainForm.WindowState = wsMaximized then
      ini.Learn('MainFormMaximized', '1')
    else
    begin
      ini.Learn('MainFormWidth', IntToStr((MainForm.Width * MAXWIDTH) div Screen.Width));
      ini.Learn('MainFormHeight', IntToStr((MainForm.Height * MAXHEIGHT) div Screen.Height));
      ini.Learn('MainFormLeft', IntToStr((MainForm.Left * MAXWIDTH) div Screen.Width));
      ini.Learn('MainFormTop', IntToStr((MainForm.Top * MAXHEIGHT) div Screen.Height));

      ini.Learn('MainFormMaximized', '0');
    end;

    // width of nav window
    ini.Learn('MainPagesWidth', IntToStr((pgcMain.Width * MAXHEIGHT) div Screen.Height));

    // height of nav window, above the history box
    ini.Learn('Panel2Height', IntToStr((pnlGo.Height * MAXHEIGHT) div Screen.Height));

    ini.Learn('DefFontName', mBrowserDefaultFontName);
    ini.Learn('DefFontSize', IntToStr(mTabsView.Browser.DefFontSize));

    if (Color2Hex(mTabsView.Browser.DefFontColor) <> Color2Hex(clWindowText)) then
      ini.Learn('DefFontColor', Color2Hex(mTabsView.Browser.DefFontColor));

    if (g_VerseBkHlColor <> Color2Hex(clHighlight)) then
      ini.Learn('VerseBkHLColor', g_VerseBkHlColor);

    ini.Learn('RefFontName', bwrSearch.DefFontName);
    ini.Learn('RefFontSize', IntToStr(bwrSearch.DefFontSize));

    if (Color2Hex(bwrSearch.DefFontColor) <> Color2Hex(clWindowText)) then
      ini.Learn('RefFontColor', Color2Hex(bwrSearch.DefFontColor));

    if (Color2Hex(mTabsView.Browser.DefBackGround) <> Color2Hex(clWindow)) then
      ini.Learn('DefBackground', Color2Hex(mTabsView.Browser.DefBackGround));
    if (Color2Hex(mTabsView.Browser.DefHotSpotColor) <> Color2Hex(clHotLight)) then
      ini.Learn('DefHotSpotColor', Color2Hex(mTabsView.Browser.DefHotSpotColor));

    if (SelTextColor <> Color2Hex(clRed)) then
      ini.Learn('SelTextColor', SelTextColor);

    try
      SaveHotModulesConfig(ini);
    except
      on E: Exception do
        BqShowException(E)
    end;
    ini.Learn('HrefUnderline', IntToStr(ord(miHrefUnderlineChecked)));

    ini.Learn('CopyOptionsCopyVerseNumbers',
      IntToStr(ord(ConfigForm.chkCopyVerseNumbers.Checked)));
    ini.Learn('CopyOptionsCopyFontParams',
      IntToStr(ord(ConfigForm.chkCopyFontParams.Checked)));
    ini.Learn('CopyOptionsAddReference',
      IntToStr(ord(ConfigForm.chkAddReference.Checked)));
    ini.Learn('CopyOptionsAddReferenceRadio',
      IntToStr(ConfigForm.rgAddReference.ItemIndex));
    ini.Learn('CopyOptionsAddLineBreaks',
      IntToStr(ord(ConfigForm.chkAddLineBreaks.Checked)));
    ini.Learn('CopyOptionsAddModuleName',
      IntToStr(ord(ConfigForm.chkAddModuleName.Checked)));

    ini.Learn('ConfigFormHotKeyChoiceItemIndex',
      IntToStr(ConfigFormHotKeyChoiceItemIndex));

    ini.Learn('MinimizeToTray', IntToStr(ord(trayIcon.MinimizeToTray)));

    ini.Learn('LastAddress', LastAddress);
    ini.Learn('LastLanguageFile', LastLanguageFile);
    ini.Learn('SecondPath', G_SecondPath);

    ini.Learn('MainFormFontName', MainForm.Font.Name);
    ini.Learn('MainFormFontSize', IntToStr(MainForm.Font.Size));

    ini.Learn('SaveDirectory', SaveFileDialog.InitialDir);
    if Assigned(MyLibraryForm) then
    begin
      ini.Learn(C_frmMyLibWidth, MyLibraryForm.Width);
      ini.Learn(C_frmMyLibHeight, MyLibraryForm.Height);
    end;
    ini.Learn(C_opt_FullContextLinks, ord(mFlagFullcontextLinks));
    ini.Learn(C_opt_HighlightVerseHits, ord(mFlagHighlightVerses));
    try
      if (not FileExists(ini.inifile)) or
        (FileGetAttr(ini.inifile) and faReadOnly <> faReadOnly) then
        ini.SaveToFile;
    finally
      ini.Destroy;
    end;

    i := History.Count - 1;

    repeat
      if (i >= 0) and (i < History.Count) and (Pos('file', History[i]) = 1) and
        (Pos('***', History[i]) > 0) then
        History.Delete(i); // clear search results;

      Dec(i);
    until i < 0;
    try
      fname := UserDir + 'bibleqt_history.ini';
      if (not FileExists(fname)) or
        (FileGetAttr(fname) and faReadOnly <> faReadOnly) then
        History.SaveToFile(fname, TEncoding.UTF8);
    except
      on E: Exception do
        BqShowException(E)
    end;
    try
      fname := UserDir + 'bibleqt_bookmarks.ini';
      if (not FileExists(fname)) or
        (FileGetAttr(fname) and faReadOnly <> faReadOnly) then
        Bookmarks.SaveToFile(fname, TEncoding.UTF8);
    except
      on E: Exception do
        BqShowException(E)
    end;
    try
      fname := UserDir + 'UserMemos.mls';
      if (not FileExists(fname)) or
        (FileGetAttr(fname) and faReadOnly <> faReadOnly) then
        Memos.SaveToFile(fname, TEncoding.UTF8);
    except
      on E: Exception do
        BqShowException(E)
    end;
    try
      SaveMru();
    except
      on E: Exception do
        BqShowException(E)
    end;
  except
    on E: Exception do
      BqShowException(E)
  end;
end;

function EncodeToValue(const bookTabInfo: TBookTabInfo): UInt64;
begin
  Result := ord(bookTabInfo[vtisShowNotes]);
  inc(Result, 10 * ord(bookTabInfo[vtisShowStrongs]));
  inc(Result, 100 * ord(bookTabInfo[vtisResolveLinks]));
  inc(Result, 1000 * ord(bookTabInfo[vtisFuzzyResolveLinks]));
end;

procedure TMainForm.SaveTabsViews();
var
  tabCount, i: integer;
  tabInfo, activeTabInfo: IViewTabInfo;
  bookTabInfo: TBookTabInfo;
  bookTabsEncoded: UInt64;
  layoutConfig: TLayoutConfig;
  tabsViewSettings: TTabsViewSettings;
  tabSettings: TTabSettings;
  tabsForm: TDockTabsForm;
  tabsView: ITabsView;
  fileStream: TFileStream;
  data: TObject;
begin
  try
    layoutConfig := TLayoutConfig.Create;
    for tabsView in mTabsViews do
    begin
      tabsForm := tabsView as TDockTabsForm;
      tabsViewSettings := TTabsViewSettings.Create;

      tabCount := tabsView.ChromeTabs.Tabs.Count - 1;
      activeTabInfo := mTabsView.GetActiveTabInfo();
      if (tabsView = mTabsView) then
        tabsViewSettings.Active := true;

      tabsViewSettings.ViewName := tabsForm.ViewName;
      tabsViewSettings.Docked := not tabsForm.Floating;
      if not (tabsViewSettings.Docked) then
      begin
        tabsViewSettings.Left := tabsForm.Left;
        tabsViewSettings.Top := tabsForm.Top;
        tabsViewSettings.Width := tabsForm.Width;
        tabsViewSettings.Height := tabsForm.Height;
      end;

      for i := 0 to tabCount do
      begin
        try
          data := tabsView.ChromeTabs.Tabs[i].Data;
          if not Supports(data, IViewTabInfo, tabInfo) then
            continue;

          if not (data is TBookTabInfo) then
            continue;

          bookTabInfo := TBookTabInfo(data);

          tabSettings := TTabSettings.Create;

          if tabInfo = activeTabInfo then
          begin
            tabSettings.Active := true;
          end;

          bookTabsEncoded := EncodeToValue(bookTabInfo);
          tabSettings.Location := bookTabInfo.Location;
          tabSettings.SecondBible := bookTabInfo.SatelliteName;
          tabSettings.StrongNotesCode := bookTabsEncoded;
          tabSettings.Title := bookTabInfo.Title;

          tabsViewSettings.TabSettingsList.Add(tabSettings);
        except
        end;
      end; // for
      layoutConfig.TabsViewList.Add(tabsViewSettings);
    end;

    layoutConfig.Save(UserDir + 'layout_tabs.json');

    fileStream := TFileStream.Create(UserDir + 'layout_forms.dat', fmCreate);
    pnlModules.DockManager.SaveToStream(fileStream);
    fileStream.Free;

  except
    on E: Exception do
      BqShowException(E)
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  mFontManager := TFontManager.Create();
  mBqEngine := TBibleQuoteEngine.Create();
  mModuleLoader := TModuleLoader.Create();

  mModuleLoader.OnScanDone := ModulesScanDone;
  mModuleLoader.OnArchiveModuleLoadFailed := ArchiveModuleLoadFailed;

  MainFormInitialized := false; // prohibit re-entry into FormShow
  mTabsViews := TList<ITabsView>.Create;

  CheckModuleInstall();

  pgcMain.DoubleBuffered := true;
  pgcHistoryBookmarks.DoubleBuffered := true;

  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Application.HintHidePause := 1000 * 60;
  Application.OnHint := AppOnHintHandler;

  InitializeTaggedBookMarks();

  HintWindowClass := HintTools.TbqHintWindow;

  InitHotkeysSupport();

  Lang := TMultiLanguage.Create(self);

  LastAddress := '';
  LastLanguageFile := '';
  G_SecondPath := '';

  HelpFileName := 'indexrus.htm';

  StrongNumbersOn := false;

  Memos := TStringList.Create;
  Memos.Sorted := true;

  MemosOn := false;

  Bookmarks := TStringList.Create;

  History := TStringList.Create;
  HistoryOn := true;

  SearchResults := TStringList.Create;
  SearchWords := TStringList.Create;
  LastSearchResultsPage := 1;

  IsSearching := false;

  pgcMain.ActivePage := tbGo;

  AddressFromMenus := true;

  // LOADING CONFIGURATION
  LoadConfiguration;

  if MainPagesWidth <> 0 then
    pgcMain.Width := MainPagesWidth;

  if Panel2Height <> 0 then
    pnlGo.Height := Panel2Height;

  if MainFormWidth = 0 then
  begin
    MainForm.WindowState := wsMaximized;
  end
  else
  begin
    MainForm.Width := MainFormWidth;
    MainForm.Height := MainFormHeight;
    MainForm.Left := MainFormLeft;
    MainForm.Top := MainFormTop;

    if MainFormMaximized then
      MainForm.WindowState := wsMaximized;
  end;

  TemplatePath := ExePath + 'templates\default\';

  if FileExists(TemplatePath + 'text.htm') then
    TextTemplate := TextFromFile(TemplatePath + 'text.htm')
  else
    TextTemplate := DefaultTextTemplate;

  if not StrReplace(TextTemplate, 'background="', 'background="' + TemplatePath,false) then
    StrReplace(TextTemplate, 'background=', 'background=' + TemplatePath, false);

  if not StrReplace(TextTemplate, 'src="', 'src="' + TemplatePath, false) then
    StrReplace(TextTemplate, 'src=', 'src=' + TemplatePath, false);

  FillLanguageMenu();

  // MAIN TABS INITIALIZATION
  lbHistory.Items.BeginUpdate;
  for i := 0 to History.Count - 1 do
    lbHistory.Items.Add(Comment(History[i]));
  lbHistory.Items.EndUpdate;

  if lbHistory.Items.Count > 0 then
    lbHistory.ItemIndex := 0;

  lbBookmarks.Items.BeginUpdate;
  for i := 0 to Bookmarks.Count - 1 do
    lbBookmarks.Items.Add(Comment(Bookmarks[i]));
  lbBookmarks.Items.EndUpdate;

  lblBookmark.Caption := '';
  if Bookmarks.Count > 0 then
    lblBookmark.Caption := Comment(Bookmarks[0]);

  MainMenuInit(false);

  LoadTabsViews();
  LoadHotModulesConfig();

  StrongsDir := C_StrongsSubDirectory;
  LoadFontFromFolder(TPath.Combine(ModulesDirectory, StrongsDir));
  mTranslated := ApplyInitialTranslation();

  StrongHebrew := TDict.Create;
  StrongGreek := TDict.Create;

  pgcMainChange(self);

  mslSearchBooksCache.Duplicates := dupIgnore;

  Application.OnIdle := self.Idle;
  Application.OnActivate := self.OnActivate;
  Application.OnDeactivate := self.OnDeactivate;
  vstDicList.DefaultNodeHeight := Canvas.TextHeight('X');

  // Let the tree know how much data space we need.
  vdtModules.NodeDataSize := SizeOf(TBookNodeData);
end;

function TMainForm.GetIViewerBase(): IHtmlViewerBase;
begin
  if not Assigned(mHTMLViewerSite) then
    mHTMLViewerSite := THTMLViewerSite.Create(self, self);

  Result := mHTMLViewerSite;

end;

function TMainForm.GetMainWindow: TForm;
begin
  Result := self;
end;

function TMainForm.GetTagFilterTimer: TTimer;
begin
  if not Assigned(mFilterTagsTimer) then
  begin
    mFilterTagsTimer := TTimer.Create(self);
    mFilterTagsTimer.OnTimer := TagFilterTimerProc;
    mFilterTagsTimer.Interval := 1000;
  end;
  Result := mFilterTagsTimer;
end;

procedure TMainForm.GetTextInfo(
  tree: TVirtualDrawTree;
  Node: PVirtualNode;
  Column: TColumnIndex;
  const AFont: TFont;
  var R: TRect;
  var Text: string);
var
  vnd: TVersesNodeData;
begin
  if tree <> vdtTagsVerses then
    Exit;
  vnd := TVersesNodeData(tree.GetNodeData(Node)^);
  if vnd = nil then
    Exit;
  R := tree.GetDisplayRect(Node, Column, false);
  InflateRect(R, 0, -4);
  Text := vnd.getText();
end;

procedure TMainForm.SaveButtonClick(Sender: TObject);
var
  s: string;
begin
  SaveFileDialog.DefaultExt := '.htm';
  SaveFileDialog.Filter := 'HTML (*.htm,*.html)|*.htm;*.html';

  s := mTabsView.Browser.DocumentTitle;
  SaveFileDialog.FileName := DumpFileName(s) + '.htm';

  if SaveFileDialog.Execute then
  begin
    WriteHtml(SaveFileDialog.FileName, mTabsView.Browser.DocumentSource);
    SaveFileDialog.InitialDir := ExtractFilePath(SaveFileDialog.FileName);
  end;
end;

procedure TMainForm.GoButtonClick(Sender: TObject);
var bookView: TBookFrame;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  NavigateToMainBookNode(bookView.BookTabInfo.Bible);

  if not pgcMain.Visible then
    tbtnToggle.Click;
  pgcMain.ActivePage := tbGo;

  Windows.SetFocus(bookView.tedtReference.Handle);
end;

procedure TMainForm.CopySelectionClick(Sender: TObject);
begin
  GetBookView(self).CopyBrowserSelectionToClipboard();
end;

function TMainForm.AddHotModule(const modEntry: TModuleEntry; tag: integer; addBibleTab: Boolean = true): integer;
var
  favouriteMenuItem, hotMenuItem: TMenuItem;
  ix: integer;
  tabsView: ITabsView;
begin
  Result := -1;
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    if not Assigned(favouriteMenuItem) then
      Exit;
    hotMenuItem := TMenuItem.Create(self);
    hotMenuItem.tag := tag;
    hotMenuItem.Caption := modEntry.mFullName;
    hotMenuItem.OnClick := HotKeyClick;
    favouriteMenuItem.Add(hotMenuItem);
    if not addBibleTab then
      Exit;

    for tabsView in mTabsViews do
    begin
      ix := tabsView.BibleTabs.Tabs.Count - 1;

      tabsView.BibleTabs.Tabs.Insert(ix, modEntry.VisualSignature());
      tabsView.BibleTabs.Tabs.Objects[ix] := modEntry;
    end;
  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;

procedure TMainForm.GoPrevChapter;
var
  cmd: string;
  bookView: TBookFrame;
begin
  bookView := GetBookView(self);

  mScrollAcc := 0;
  if sbxPreview.Visible then
  begin
    if CurPreviewPage > 0 then
      CurPreviewPage := CurPreviewPage - 1;
    Exit;
  end;

  if not bookView.tbtnPrevChapter.Enabled then
    Exit;

  with bookView.BookTabInfo.Bible do
    if CurChapter > 1 then
      cmd := Format('go %s %d %d', [ShortPath, CurBook, CurChapter - 1])
    else if CurBook > 1 then
      cmd := Format('go %s %d %d', [ShortPath, CurBook - 1, ChapterQtys[CurBook - 1]]);

  HistoryOn := false;
  bookView.ProcessCommand(cmd, hlFalse);
  HistoryOn := true;

  // ShowXref;
  tbComments.tag := 0;
  ShowComments;

  Windows.SetFocus(mTabsView.Browser.Handle);
end;

procedure TMainForm.GoNextChapter;
var
  cmd: string;
  bookView: TBookFrame;
begin
  bookView := GetBookView(self);

  mScrollAcc := 0;
  if sbxPreview.Visible then
  begin
    if CurPreviewPage < MFPrinter.LastAvailablePage - 1 then
      CurPreviewPage := CurPreviewPage + 1;
    Exit;
  end;

  if not bookView.tbtnNextChapter.Enabled then
    Exit;

  with bookView.BookTabInfo.Bible do
    if CurChapter < ChapterQtys[CurBook] then
      cmd := Format('go %s %d %d', [ShortPath, CurBook, CurChapter + 1])
    else if CurBook < BookQty then
      cmd := Format('go %s %d %d', [ShortPath, CurBook + 1, 1]);

  HistoryOn := false;
  bookView.ProcessCommand(cmd, hlFalse);
  HistoryOn := true;

  // ShowXref;
  tbComments.tag := 0;
  ShowComments;

  Windows.SetFocus(mTabsView.Browser.Handle);
end;

procedure SetButtonHint(aButton: TToolButton; aMenuItem: TMenuItem);
begin
  aButton.Hint := aMenuItem.Caption + ' (' + ShortCutToText(aMenuItem.ShortCut) + ')';
end;

function TMainForm.TranslateInterface(locFile: string): Boolean;
var
  i: integer;
  s: string;
  fnt: TFont;
  locDirectory: string;
  locFilePath: string;
  tabsView: ITabsView;
  tabsForm: TDockTabsForm;
  bookView: TBookFrame;
begin
  result := false;

  locDirectory := GetLocalizationDirectory();
  locFilePath := TPath.Combine(locDirectory, locFile);
  try
    result := Lang.LoadIniFile(locFilePath);
    if (not result) and (miLanguage.Count > 0) then
    begin
      locFilePath := TPath.Combine(locDirectory, miLanguage.Items[0].Caption + '.lng');
      result := Lang.LoadIniFile(locFilePath);
    end;
  except
    on E: Exception do
    begin
      BqShowException(E, 'In translate interface hard error');
      Exit;
    end
  end;

  if not result then
    Exit;

  UpdateDictionariesCombo();

  TranslateControl(MyLibraryForm);
  TranslateControl(ExceptionForm);
  TranslateControl(AboutForm);

  for tabsView in mTabsViews do
  begin
    if (tabsView is TDockTabsForm) then
    begin
      tabsForm := tabsView as TDockTabsForm;
      TranslateControl(tabsForm, 'DockTabsForm');

      if (tabsForm.BookView is TBookFrame) then
        TranslateControl(tabsForm.BookView as TBookFrame, 'DockTabsForm');
    end;
  end;

  for i := 0 to miLanguage.Count - 1 do
    with miLanguage.Items[i] do
      Checked := LowerCase(Caption + '.lng') = LowerCase(locFile);

  TranslateConfigForm;

  LockWindowUpdate(self.Handle);

  try
    Lang.TranslateControl(MainForm);
  finally
    LockWindowUpdate(0);
  end;

  bookView := GetBookView(self);
  bookView.miCopySelection.Caption := miCopy.Caption;

  // initialize Toolbar
  SetButtonHint(tbtnToggle, miToggle);
  SetButtonHint(bookView.tbtnCopy, miCopy);
  SetButtonHint(tbtnPrint, miPrint);
  SetButtonHint(tbtnPreview, miPrintPreview);
  SetButtonHint(tbtnSound, miSound);

  SetButtonHint(bookView.tbtnStrongNumbers, miStrong);
  SetButtonHint(tbtnNewTab, miNewTab);
  SetButtonHint(tbtnCloseTab, miCloseTab);

  bookView.tbtnMemos.Hint := bookView.miMemosToggle.Caption + ' (' + ShortCutToText(bookView.miMemosToggle.ShortCut) + ')';

  cbList.ItemIndex := 0;

  if Lang.Say('HelpFileName') <> 'HelpFileName' then
    HelpFileName := Lang.Say('HelpFileName');

  Application.Title := MainForm.Caption;
  trayIcon.Hint := MainForm.Caption;

  if bookView.BookTabInfo.Bible.inifile <> '' then
  begin
    with bookView.BookTabInfo.Bible do
      s := ShortName + ' ' + FullPassageSignature(CurBook, CurChapter, CurFromVerse, CurToVerse);

    if bookView.BookTabInfo.Bible.Copyright <> '' then
      s := s + '; © ' + bookView.BookTabInfo.Bible.Copyright
    else
      s := s + '; ' + Lang.Say('PublicDomainText');

    lblTitle.Hint := s + '   ';

    if Length(lblTitle.Hint) < 83 then
      lblTitle.Caption := lblTitle.Hint
    else
      lblTitle.Caption := Copy(lblTitle.Hint, 1, 80) + '...';

    tbtnCopyright.Hint := s;

    UpdateBooksAndChaptersBoxes(bookView.BookTabInfo.Bible);
    SearchListInit;
  end;

  fnt := TFont.Create;
  fnt.Name := MainForm.Font.Name;
  fnt.Size := MainForm.Font.Size;

  MainForm.Font := fnt;

  Update;
  fnt.Free;

end;

procedure TMainForm.ChapterComboBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    AddressFromMenus := true;
    OpenChapter();
  end;
end;

procedure TMainForm.tbtnPrintClick(Sender: TObject);
begin
  with PrintDialog do
    if Execute then
      mTabsView.Browser.Print(MinPage, MaxPage);
end;

var
  refvisible: Boolean;

procedure TMainForm.EnableMenus(aEnabled: Boolean);
var
  i: integer;
begin
  for i := 0 to MainForm.ComponentCount - 1 do
  begin
    if MainForm.Components[i] is TMenuItem then
      (MainForm.Components[i] as TMenuItem).Enabled := aEnabled;
  end;
end;

procedure TMainForm.tbtnPreviewClick(Sender: TObject);
begin
  if sbxPreview.Visible then
  begin
    EnableMenus(true);

    sbxPreview.Visible := false;

    GetTabsView(self).pnlMain.Visible := true;
    Windows.SetFocus(mTabsView.Browser.Handle);

    pgcMain.Visible := refvisible;

    Screen.Cursor := crDefault;
  end
  else
  begin
    refvisible := pgcMain.Visible;

    MFPrinter := TMetaFilePrinter.Create(self);
    mTabsView.Browser.PrintPreview(MFPrinter);

    ZoomIndex := 0;
    CurPreviewPage := 0;

    sbxPreview.OnResize := nil;

    pgcMain.Visible := false;

    GetTabsView(self).pnlMain.Visible := false;
    sbxPreview.OnResize := sbxPreviewResize;

    sbxPreview.Align := alClient;
    EnableMenus(false);
    miFile.Enabled := true;
    miPrintPreview.Enabled := true;
    sbxPreview.Visible := true;

    pbPreview.Cursor := crHandPoint;
  end;
end;

procedure TMainForm.sbxPreviewResize(Sender: TObject);
const
  BORD = 20;
var
  z: double;
  tmp, TotWid: integer;
begin
  case ZoomIndex of
    0:
      z := ((sbxPreview.ClientHeight - BORD) / PixelsPerInch) /
        (MFPrinter.PaperHeight / MFPrinter.PixelsPerInchY);
    1:
      z := ((sbxPreview.ClientWidth - BORD) / PixelsPerInch) /
        (MFPrinter.PaperWidth / MFPrinter.PixelsPerInchX);
    2:
      z := Zoom;
    3:
      z := 0.25;
    4:
      z := 0.50;
    5:
      z := 0.75;
    6:
      z := 1.00;
    7:
      z := 1.25;
    8:
      z := 1.50;
    9:
      z := 2.00;
    10:
      z := 3.00;
    11:
      z := 4.00;
  else
    z := 1;
  end;

  pnlPage.Height := TRUNC(PixelsPerInch * z * MFPrinter.PaperHeight /
    MFPrinter.PixelsPerInchY);
  pnlPage.Width := TRUNC(PixelsPerInch * z * MFPrinter.PaperWidth /
    MFPrinter.PixelsPerInchX);

  TotWid := pnlPage.Width + BORD;

  // Resize the Contain Panel
  tmp := pnlPage.Height + BORD;
  if tmp < sbxPreview.ClientHeight then
    tmp := sbxPreview.ClientHeight - 1;
  pnlContainer.Height := tmp;

  tmp := TotWid;
  if tmp < sbxPreview.ClientWidth then
    tmp := sbxPreview.ClientWidth - 1;
  pnlContainer.Width := tmp;

  // Center the Page Panel
  if pnlPage.Height + BORD < pnlContainer.Height then
    pnlPage.Top := pnlContainer.Height div 2 - pnlPage.Height div 2
  else
    pnlPage.Top := BORD div 2;

  if TotWid < pnlContainer.Width then
    pnlPage.Left := pnlContainer.Width div 2 - (TotWid - BORD) div 2
  else
    pnlPage.Left := BORD div 2;

  { Make sure the scroll bars are hidden if not needed }
  if (pnlPage.Width + BORD <= sbxPreview.Width) and
    (pnlPage.Height + BORD <= sbxPreview.Height) then
  begin
    sbxPreview.HorzScrollBar.Visible := false;
    sbxPreview.VertScrollBar.Visible := false;
  end
  else
  begin
    sbxPreview.HorzScrollBar.Visible := true;
    sbxPreview.VertScrollBar.Visible := true;
  end;

  Zoom := z;
end;

procedure TMainForm.SetBibleTabsHintsState(showHints: Boolean);
var
  i, num, bibleTabsCount, curItem: integer;
  s: string;
  saveOnChange: TTabChangeEvent;
  tabsView: ITabsView;
begin
  for tabsView in mTabsViews do
  begin
    bibleTabsCount := tabsView.BibleTabs.Tabs.Count - 1;
    curItem := tabsView.BibleTabs.TabIndex;
    if bibleTabsCount > 9 then
      bibleTabsCount := 9
    else
      Dec(bibleTabsCount);
    for i := 0 to bibleTabsCount do
    begin
      s := tabsView.BibleTabs.Tabs[i];
      if showHints then
      begin
        if (i < 9) then
          num := i + 1
        else
          num := 0;
        tabsView.BibleTabs.Tabs[i] := Format('%d-%s', [num, s]);
      end
      else
      begin
        if (s[2] <> '-') or (not CharInSet(Char(s[1]), ['0' .. '9'])) then
          break;
        tabsView.BibleTabs.Tabs[i] := Copy(s, 3, $FFFFFF);
      end;
    end; // for

    if showHints then
    begin
      tabsView.BibleTabs.FirstIndex := 0;
      tabsView.BibleTabs.TabIndex := curItem;
    end
    else
    begin
      saveOnChange := tabsView.BibleTabs.OnChange;
      tabsView.BibleTabs.OnChange := nil;
      if curItem > 0 then
        tabsView.BibleTabs.TabIndex := curItem - 1;
      tabsView.BibleTabs.TabIndex := curItem;
      tabsView.BibleTabs.OnChange := saveOnChange;
    end;

  end;

  mBibleTabsInCtrlKeyDownState := showHints;
end;

procedure TMainForm.SetCurPreviewPage(Val: integer);
begin
  FCurPreviewPage := Val;
  pbPreview.Invalidate;
end;

procedure TMainForm.SetFavouritesShortcuts();
var
  favouriteMenuItem, hotMenuItem: TMenuItem;
  i, j, hotCount: integer;
begin
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    hotCount := favouriteMenuItem.Count - 1;
    j := 0;
    for i := 0 to hotCount do
    begin
      hotMenuItem := favouriteMenuItem.Items[i] as TMenuItem;
      if hotMenuItem.tag < 7000 then
        continue;
      if j < 9 then
        hotMenuItem.ShortCut := ShortCut($31 + j, [ssCtrl])
      else if j = 9 then
        hotMenuItem.ShortCut := ShortCut($30, [ssCtrl])
      else
        hotMenuItem.ShortCut := 0;
      inc(j)
    end;

  except
    // do nothing
  end;
end;

procedure TMainForm.SetFirstTabInitialLocation(
  wsCommand, wsSecondaryView: string;
  const Title: string;
  state: TBookTabInfoState;
  visual: Boolean);
var
  vti: TBookTabInfo;
  bookView: TBookFrame;
begin
  if Length(wsCommand) > 0 then
    LastAddress := wsCommand;

  bookView := GetBookView(self);

  ClearVolatileStateData(state);

  vti := bookView.BookTabInfo;
  vti.SatelliteName := wsSecondaryView;
  vti.State := state;
  vti.Title := Title;
  vti.Location := LastAddress;
  mTabsView.ChromeTabs.Tabs[0].Caption := Title;
  //mTabsView.ViewTabs.Tabs[0].Data := vti;

  if visual then
  begin
    StrongNumbersOn := vtisShowStrongs in state;
    MemosOn := vtisShowNotes in state;
    vti.Bible.RecognizeBibleLinks := vtisResolveLinks in state;
    vti.Bible.FuzzyResolve := vtisFuzzyResolveLinks in state;
    bookView.SafeProcessCommand(LastAddress, hlDefault);
    UpdateUI();
  end
  else
  begin
    vti.StateEntryStatus[vtisPendingReload] := true;
  end;

end;

procedure TMainForm.SetNodeText(tree: TVirtualDrawTree; Node: PVirtualNode; Column: TColumnIndex; const Text: string);
var
  vnd: TVersesNodeData;
  rslt: HRESULT;

begin
  vnd := TVersesNodeData(tree.GetNodeData(Node)^);
  if (vnd = nil) or (vnd.nodeType <> bqvntTag) then
    Exit;

  rslt := TagsDbEngine.RenameTag(vnd.SelfId, Text);
  if rslt <> 0 then
  begin
    if rslt = -1 then
      MessageBox(
        self.Handle,
        Pointer(Lang.SayDefault('bqVerseTagNotUnique', C_TagRenameError)),
        Pointer(Lang.SayDefault('bqError', 'Error')),
        MB_OK or MB_ICONERROR)

    else if rslt = -2 then
      MessageBox(
        self.Handle,
        Pointer(Lang.SayDefault('bqErrorUnknown', 'Unknown Error')),
        Pointer(Lang.SayDefault('bqError', 'Error')),
        MB_OK or MB_ICONERROR);

  end;

end;

procedure TMainForm.SetVScrollTracker(aBrwsr: THTMLViewer);
begin
  try
    aBrwsr.VScrollBar.OnChange := self.VSCrollTracker;
  except
    on E: Exception do
      BqShowException(E)
  end;
end;

procedure TMainForm.DrawMetaFile(PB: TPaintBox; mf: TMetaFile);
begin
  PB.Canvas.Draw(0, 0, mf);
end;

procedure TMainForm.pbPreviewPaint(Sender: TObject);
var
  PB: TPaintBox;
  Draw: Boolean;
  page: integer;
begin
  PB := Sender as TPaintBox;

  Draw := CurPreviewPage < MFPrinter.LastAvailablePage;
  page := CurPreviewPage;

  SetMapMode(PB.Canvas.Handle, MM_ANISOTROPIC);
  SetWindowExtEx(PB.Canvas.Handle, MFPrinter.PaperWidth, MFPrinter.PaperHeight, nil);
  SetViewportExtEx(PB.Canvas.Handle, PB.Width, PB.Height, nil);
  SetWindowOrgEx(PB.Canvas.Handle, -MFPrinter.OffsetX, -MFPrinter.OffsetY, nil);

  if Draw then
    DrawMetaFile(PB, MFPrinter.MetaFiles[page]);
end;

procedure TMainForm.pmRecLinksOptionsChange(Sender: TObject; Source: TMenuItem; Rebuild: Boolean);
begin
  //
end;

function TMainForm.PaintTokens(canv: TCanvas; rct: TRect; tkns: TObjectList; calc: Boolean): integer;
var
  i, C, fw, fh: integer;
  ws: string;
  sz: TSize;
  rects: array [0 .. 9] of TRect;
begin
  C := tkns.Count - 1;
  if C > 9 then
    C := 9;

  rects[0].Left := rct.Left;
  rects[0].Right := rct.Right;
  rects[0].Top := rct.Top;
  rects[0].Bottom := rct.Bottom;
  sz := canv.TextExtent('X');
  fw := sz.cx;
  fh := canv.Font.Height;
  if fh < 0 then
    fh := -fh;

  for i := 0 to C do
  begin
    ws := TVersesNodeData(tkns[i]).getText;
    Windows.DrawText(canv.Handle, PChar(Pointer(ws)), -1, rects[i], DT_TOP or DT_CALCRECT or DT_SINGLELINE);
    if (rects[i].Right > rct.Right) and (rects[i].Left > rct.Left) then
    begin
      rects[i].Left := rct.Left;
      rects[i].Top := rects[i].Bottom + fh;
      Windows.DrawText(canv.Handle, PChar(Pointer(ws)), -1, rects[i], DT_TOP or DT_CALCRECT or DT_SINGLELINE);
    end;

    if i < C then
    begin
      rects[i + 1].Left := rects[i].Right + fw * 4;
      rects[i + 1].Top := rects[i].Top;
      rects[i + 1].Bottom := rct.Bottom;
      rects[i + 1].Right := rct.Right;
    end;
  end;

  if not calc then
    for i := 0 to C do
      Windows.DrawText(canv.Handle, PChar(Pointer(ws)), -1, rects[i], DT_TOP or DT_SINGLELINE);

  Result := rects[C].Bottom;

end;

function TMainForm.PassWordFormShowModal(const aModule: WideString; out Pwd: WideString; out savePwd: Boolean): integer;
var
  modName: string;
  i: integer;
  modShortPath: string;
begin
  Result := mrCancel;
  try
    modShortPath := (ExtractFileName(aModule));
    modShortPath := Copy(modShortPath, 1, Length(modShortPath) - 4);
    i := mModules.FindByFolder(modShortPath);
    if (i < 0) then
      modName := ' '
    else
      modName := mModules[i].mFullName;
    if not Assigned(PasswordBox) then
      PasswordBox := TPasswordBox.Create(self);
    with PasswordBox do
    begin
      Font.Assign(self.Font);
      lblPasswordNeeded.Caption :=
        Format(Lang.SayDefault('lblPasswordNeeded', 'Для открытия модуля нужно ввести пароль (%s)'), [modName]);

      lblEnterPassword.Caption := Lang.SayDefault('lblPassword', 'Пароль:');
      chkSavePwd.Caption := Lang.SayDefault('chkSavePwd', 'Сохранить пароль');
      btnCancel.Caption := Lang.SayDefault('btnCancel', 'Отмена');
      edtPwd.Text := '';
      chkSavePwd.Checked := false;
      Result := PasswordBox.ShowModal();
      if Result = mrOk then
      begin
        Pwd := edtPwd.Text;
        savePwd := chkSavePwd.Checked;
      end;
    end;

  except
  end;

end;

procedure TMainForm.pbPreviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  sx, sy: single;
  nx, ny: integer;
begin
  sx := X / pnlPage.Width;
  sy := Y / pnlPage.Height;

  if (ssLeft in Shift) and (Zoom < 20.0) then
    Zoom := Zoom * ZOOMFACTOR;
  if (ssRight in Shift) and (Zoom > 0.1) then
    Zoom := Zoom / ZOOMFACTOR;

  ZoomIndex := 2;
  sbxPreviewResize(nil);

  nx := TRUNC(sx * pnlPage.Width);
  ny := TRUNC(sy * pnlPage.Height);
  sbxPreview.HorzScrollBar.Position := nx - sbxPreview.Width div 2;
  sbxPreview.VertScrollBar.Position := ny - sbxPreview.Height div 2;
end;

procedure TMainForm.SelectModuleTreeNode(bible: TBible);
var
  i: Integer;
  bookNode: PVirtualNode;
  chapterNode: PVirtualNode;
begin
  i := cbModules.Items.IndexOf(bible.Name);

  if i <> cbModules.ItemIndex then
    cbModules.ItemIndex := i;

  i := bible.CurBook - 1;
  if bible.BookQty > 0 then
  begin
    bookNode := GetChildNodeByIndex(nil, i);
    if Assigned(bookNode) then
    begin
      i := bible.CurChapter - 1;
      if (i < 0) then
        i := 0;
      chapterNode := GetChildNodeByIndex(bookNode, i);
      if Assigned(chapterNode) then
      begin
        if (vdtModules.Selected[chapterNode] = False) then
        begin
          if (vdtModules.Expanded[bookNode] = False) then
            vdtModules.Expanded[bookNode] := True;
          vdtModules.Selected[chapterNode] := True;
          vdtModules.FocusedNode := chapterNode;
        end;
      end
      else
      begin
        vdtModules.Selected[bookNode] := True;
        vdtModules.FocusedNode := bookNode;
      end;
    end;
  end;
end;

procedure TMainForm.HistoryButtonClick(Sender: TObject);
begin
  if History.Count = 0 then
    Exit;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  OldKey: Word;
  hotMenuItem: TMenuItem;
label
  exitlabel;
begin
  hotMenuItem := nil;
  if sbxPreview.Visible then
  begin
    if Key = VK_NEXT then
    begin
      if CurPreviewPage < MFPrinter.LastAvailablePage - 1 then
        CurPreviewPage := CurPreviewPage + 1;
    end
    else if Key = VK_PRIOR then
    begin
      if CurPreviewPage > 0 then
        CurPreviewPage := CurPreviewPage - 1;
    end
    else if Key = VK_HOME then
    begin
      sbxPreview.VertScrollBar.Position := 0;
    end
    else if Key = VK_END then
    begin
      sbxPreview.VertScrollBar.Position := sbxPreview.VertScrollBar.Range;
    end
    else if Key = VK_UP then
    begin
      if sbxPreview.VertScrollBar.Position > 50 then
        sbxPreview.VertScrollBar.Position :=
          sbxPreview.VertScrollBar.Position - 50
      else
        sbxPreview.VertScrollBar.Position := 0;
    end
    else if Key = VK_DOWN then
    begin
      if sbxPreview.VertScrollBar.Position < sbxPreview.VertScrollBar.Range - 50
      then
        sbxPreview.VertScrollBar.Position :=
          sbxPreview.VertScrollBar.Position + 50
      else
        sbxPreview.VertScrollBar.Position := sbxPreview.VertScrollBar.Range;
    end
    else if Key = VK_LEFT then
    begin
      if sbxPreview.HorzScrollBar.Position > 50 then
        sbxPreview.HorzScrollBar.Position :=
          sbxPreview.HorzScrollBar.Position - 50
      else
        sbxPreview.HorzScrollBar.Position := 0;
    end
    else if Key = VK_RIGHT then
    begin
      if sbxPreview.HorzScrollBar.Position < sbxPreview.HorzScrollBar.Range - 50
      then
        sbxPreview.HorzScrollBar.Position :=
          sbxPreview.HorzScrollBar.Position + 50
      else
        sbxPreview.HorzScrollBar.Position := sbxPreview.HorzScrollBar.Range;
    end
    else if (Key = ord('Z')) and (Shift = [ssCtrl]) then
      GoPrevChapter
    else if (Key = ord('X')) and (Shift = [ssCtrl]) then
      GoNextChapter
    else if (Key = ord('V')) and (Shift = [ssCtrl]) then
      tbtnPreview.Click
    else if (Key = ord('P')) and (Shift = [ssCtrl]) then
      tbtnPrint.Click;

    Key := 0;
    goto exitlabel;
  end; // if sbxPreview visible

  if Key = VK_CONTROL then
  begin
    if not G_ControlKeyDown then
    begin
      G_ControlKeyDown := true;
      SetBibleTabsHintsState(true);
    end
  end;

  MainShiftState := Shift;

  if Shift = [ssShift] then
  begin
    OldKey := Key;
    Key := 0;

    case OldKey of
      VK_F5:
        miCopyOptions.Click;
    else
      Key := OldKey;
    end;

    if Key = 0 then
      goto exitlabel;
  end;

  if (Shift = [ssCtrl]) and (Key <> VK_CONTROL) then
  begin
    OldKey := Key;
    Key := 0;

    case OldKey of
      // Ord('H'): HistoryButton.Click;

      ord('Z'):
        if ActiveControl <> reMemo then
          GoPrevChapter;
      ord('X'):
        if ActiveControl <> reMemo then
          GoNextChapter;
      ord('T'):
        tbtnToggle.Click;
      // Ord('G'):
      // begin
      // pgcMain.Visible := true;
      // pgcMain.ActivePage := tbGo;
      // ActiveControl := edtGo;
      // end;

      // Ord('F'):
      // begin
      // pgcMain.Visible := true;
      // pgcMain.ActivePage := tbSearch;
      // ActiveControl := cbSearch;
      // end;
      ord('C'), VK_INSERT:
        begin
          if ActiveControl = reMemo then
            reMemo.CopyToClipboard
          else if GetTabsView(self).ActiveControl = mTabsView.Browser then
            GetBookView(self).tbtnCopy.Click
          else if ActiveControl is THTMLViewer then
            (ActiveControl as THTMLViewer).CopyToClipboard
          else if GetTabsView(self).ActiveControl is THTMLViewer then
          begin
            (GetTabsView(self).ActiveControl as THTMLViewer).CopyToClipboard;
          end; // if webbr
        end;
      // Ord('B'): BookmarkButton.Click;
      // Ord('D'): miAddPassageBookmark.Click;

      // Ord('N'): NewButton.Click;
      ord('O'):
        miOpen.Click;
      ord('S'):
        miSave.Click;
      ord('P'):
        tbtnPrint.Click;
      ord('W'):
        tbtnPreview.Click;
      ord('R'):
        GetBookView(self).GoRandomPlace;
      ord('F'):
        ShowQuickSearch();
      ord('M'):
        GetBookView(self).miMemosToggle.Click;

      ord('L'):
        tbtnSound.Click;

      VK_F1:
        tbtnToggle.Click;
      ord('G'), VK_F2:
        miQuickNav.Click;
      VK_F3:
        miQuickSearch.Click;
      // VK_F4: tbtnToggle.Click;
      VK_F5:
        miCopy.Click;
      VK_F10:
        miSound.Click;

      VK_F11:
        miPrintPreview.Click;
      VK_F12:
        miOpen.Click;

      { Ord('1'): miHot1.Click;
        Ord('2'): miHot2.Click;
        Ord('3'): miHot3.Click;
        Ord('4'): miHot4.Click;
        Ord('5'): miHot5.Click;
        Ord('6'): miHot6.Click;
        Ord('7'): miHot7.Click;
        Ord('8'): miHot8.Click;
        Ord('9'): miHot9.Click;
        Ord('0'): miHot0.Click; }
      ord('0'):
        begin
          if mFavorites.mModuleEntries.Count > 9 then
            hotMenuItem := FavoriteItemFromModEntry(TModuleEntry(mFavorites.mModuleEntries[10]));
          if Assigned(hotMenuItem) then
            hotMenuItem.Click();
        end;

      ord('1') .. ord('9'):
        begin
          if mFavorites.mModuleEntries.Count >= (ord(OldKey) - ord('0')) then
            hotMenuItem := FavoriteItemFromModEntry(TModuleEntry(mFavorites.mModuleEntries[ord(OldKey) - ord('0') - 1]));

          if Assigned(hotMenuItem) then
            hotMenuItem.Click();
        end;
    else
      Key := OldKey;
    end;

    if Key = 0 then
      goto exitlabel;
  end; // if control pressed

  OldKey := Key;
  case OldKey of

//    VK_F1:
//      miHelp.Click;
    VK_F2:
      miOpenPassage.Click;
    VK_F3:
      miSearch.Click;
    VK_F4:
      miDic.Click;
    VK_F5:
      miStrong.Click;
    VK_F6:
      miComments.Click;
    VK_F7:
      miXref.Click;
    VK_F8:
      miNotepad.Click;
    VK_F9:
      miHotKey.Click;
    VK_F10:
      miOptions.Click;
    VK_F11:
      miPrint.Click;
    VK_F12:
      miSave.Click;

  end;

exitlabel:
end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
var bookView: TBookFrame;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  with OpenDialog do
  begin
    if InitialDir = '' then
      InitialDir := ExePath;

    Filter := 'HTML (*.htm, *.html)|*.htm;*.html|*.*|*.*';

    if Execute then
    begin
      bookView.ProcessCommand('file ' + FileName + ' $$$' + FileName, hlDefault);
      InitialDir := ExtractFilePath(FileName);
    end;
  end;
end;

procedure TMainForm.SearchButtonClick(Sender: TObject);
begin
  ShowSearchTab();
end;

procedure TMainForm.cbSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  s: TComboBox;
begin
  if Key = VK_RETURN then
  begin
    s := (Sender as TComboBox);
    if s.DroppedDown then
      s.DroppedDown := false;
  end;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  tabsView: TDockTabsForm;
  bookView: TBookFrame;
begin
  if Key = #27 then
  begin
    tabsView := GetTabsView(self);
    Key := #0;
    if not tabsView.pnlMain.Visible then
      { previewing }
      miPrintPreview.Click // this turns preview off
    else
    begin
      if IsSearching then
        btnFindClick(Sender)
      else
      begin
        // exit from edtGo (F2) or cbSearch (F3) to Browser
        bookView := GetBookView(self);
        if (tabsView.ActiveControl = bookView.tedtReference) or (ActiveControl = cbSearch) then
          tabsView.ActiveControl := mTabsView.Browser;
      end;
    end;
    Exit;
  end;

  if Key = #13 then
  begin
    if pgcMain.ActivePage = tbSearch then
    begin
      Key := #0;
      btnFindClick(Sender);
    end
    else if ActiveControl = lbHistory then
    begin
      Key := #0;
      lbHistoryDblClick(Sender);
    end;
  end;
end;

function TMainForm.FavoriteItemFromModEntry(const me: TModuleEntry): TMenuItem;
var
  favoriteMenuItem: TMenuItem;
  cnt, i: integer;
begin
  Result := nil;
  try
    favoriteMenuItem := FindTaggedTopMenuItem(3333);
    cnt := favoriteMenuItem.Count - 1;
    i := 0;
    while i <= cnt do
    begin
      Result := TMenuItem(favoriteMenuItem.Items[i]);
      if Result.tag = integer(me) then
        break;
      inc(i);
    end;
    if i > cnt then
      Result := nil;
  except
    on E: Exception do
      BqShowException(E);
  end;
end;

function TMainForm.FavoriteTabFromModEntry(tabsView: ITabsView; const me: TModuleEntry): integer;
var
  i, cnt: integer;
begin
  Result := -1;
  cnt := tabsView.BibleTabs.Tabs.Count - 1;
  i := 0;
  while i <= cnt do
  begin
    if tabsView.BibleTabs.Tabs.Objects[i] = me then
      break;
    inc(i);
  end;
  if i <= cnt then
    Result := i;
end;

function TMainForm.FilterCommentariesCombo: integer;
var
  vti: TBookTabInfo;
  bl: TBibleLinkEx;
  ibl: TBibleLink;
  getAddress, doFilter: Boolean;
  linkValidStatus, addIndex, selIndex: integer;
  commentaryModule: TModuleEntry;
  lastCmt: WideString;
begin
  Result := -1;
  doFilter := btnOnlyMeaningful.Down;
  vti := GetBookView(self).BookTabInfo;
  if (vti = nil) then
    Exit;
  getAddress := bl.FromBqStringLocation(vti.Location);
  if getAddress then
  begin
    linkValidStatus := vti.Bible.ReferenceToInternal(bl, ibl);
    if linkValidStatus = -2 then
      getAddress := false;
  end;

  commentaryModule := mModules.ModTypedAsFirst(modtypeComment);
  lastCmt := cbComments.Text;

  cbComments.Items.BeginUpdate;
  cbComments.Items.Clear();
  try
    selIndex := -1;
    while Assigned(commentaryModule) do
    begin
      try
        vti.SecondBible.inifile := commentaryModule.getIniPath();
        linkValidStatus := vti.SecondBible.LinkValidnessStatus(vti.SecondBible.inifile, ibl, true, false);
        if (linkValidStatus > -2) or (not getAddress) or (not doFilter) then
        begin
          addIndex := cbComments.Items.Add(commentaryModule.mFullName);
          if OmegaCompareTxt(commentaryModule.mFullName, lastCmt, -1, true) = 0
          then
            selIndex := addIndex;

        end;
        commentaryModule := mModules.ModTypedAsNext(modtypeComment);
      except
      end;
    end; // while
  finally
    cbComments.Items.EndUpdate();
  end;
  if selIndex >= 0 then
    cbComments.ItemIndex := selIndex;
end;

procedure TMainForm.FilterTags(const FilterText: string);
var
  pvn: PVirtualNode;
  vnd: TVersesNodeData;
  ix: integer;
  tree: TBaseVirtualTree;
  isNotEmptyFilterStr, filterNode, prevFiltered, expanded: Boolean;

  procedure filter_siblings(Node: PVirtualNode; value: Boolean);
  begin
    while Node <> nil do
    begin
      tree.IsFiltered[Node] := value;
      Node := tree.GetNextSibling(Node);
    end;
  end;

begin
  tree := vdtTagsVerses;
  tree.BeginUpdate();
  isNotEmptyFilterStr := Length(FilterText) > 0;
  try
    pvn := tree.GetFirstChild(nil);

    while pvn <> nil do
    begin
      vnd := TVersesNodeData(tree.GetNodeData(pvn)^);
      if (vnd <> nil) and (vnd.nodeType = bqvntTag) then
      begin
        expanded := tree.expanded[pvn];
        prevFiltered := tree.IsFiltered[pvn];
        if isNotEmptyFilterStr then
        begin
          ix := UpperPosCI(FilterText, vnd.getText());
          filterNode := (ix <= 0);
          tree.IsFiltered[pvn] := filterNode;
          if expanded then
            if filterNode then // now filtered out
              filter_siblings(tree.GetFirstChild(pvn), true)
            else if prevFiltered then { was filtered but not now }
              filter_siblings(tree.GetFirstChild(pvn), false);
        end
        else
        begin // empty filter str
          tree.IsFiltered[pvn] := false;
          if prevFiltered then
            filter_siblings(tree.GetFirstChild(pvn), false);
        end;
      end;
      pvn := tree.GetNextSibling(pvn);
    end;
  finally
    tree.EndUpdate();
  end;
end;

procedure TMainForm.btnFindClick(Sender: TObject);
var
  s: set of 0 .. 255;
  data, wrd, wrdnew, books: string;
  params: byte;
  lnks: TStringList;
  book, chapter, v1, v2, linksCnt, i: integer;
  bookView: TBookFrame;
  bible: TBible;

  function metabook(const bible: TBible; const str: WideString): Boolean;
  var
    wl: string;
  label success;
  begin
    wl := LowerCase(str);
    if (Pos('нз', wl) = 1) or (Pos('nt', wl) = 1) then
    begin

      if bible.Trait[bqmtNewCovenant] and bible.InternalToReference(40, 1, 1, book, chapter, v1) then
      begin
        s := s + [39 .. 65];
      end;
      goto success;
    end
    else if (Pos('вз', wl) = 1) or (Pos('ot', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] and bible.InternalToReference(1, 1, 1, book, chapter, v1) then
      begin
        s := s + [0 .. 38];
      end;
      goto success;
    end
    else if (Pos('пят', wl) = 1) or (Pos('pent', wl) = 1) or
      (Pos('тор', wl) = 1) or (Pos('tor', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] and bible.InternalToReference(1, 1, 1, book, chapter, v1) then
      begin
        s := s + [0 .. 4];
      end;
      goto success;
    end
    else if (Pos('ист', wl) = 1) or (Pos('hist', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] then
      begin
        s := s + [0 .. 15];
      end;
      goto success;
    end
    else if (Pos('уч', wl) = 1) or (Pos('teach', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] then
      begin
        s := s + [16 .. 21];
      end;
      goto success;
    end
    else if (Pos('бпрор', wl) = 1) or (Pos('bproph', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] then
      begin
        s := s + [22 .. 26];
      end;
      goto success;
    end
    else if (Pos('мпрор', wl) = 1) or (Pos('mproph', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] then
      begin
        s := s + [27 .. 38];
      end;
      goto success;
    end
    else if (Pos('прор', wl) = 1) or (Pos('proph', wl) = 1) then
    begin
      if bible.Trait[bqmtOldCovenant] then
      begin
        s := s + [22 .. 38];
        if bible.Trait[bqmtNewCovenant] and bible.InternalToReference(66, 1, 1, book, chapter, v1) then
        begin
          Include(s, 65);
        end;
        goto success;
      end
    end
    else if (Pos('ева', wl) = 1) or (Pos('gos', wl) = 1) then
    begin
      if bible.Trait[bqmtNewCovenant] then
      begin
        s := s + [39 .. 42];
      end;
      goto success;
    end
    else if (Pos('пав', wl) = 1) or (Pos('paul', wl) = 1) then
    begin
      if bible.Trait[bqmtNewCovenant] and bible.InternalToReference(52, 1, 1, book, chapter, v1) then
      begin
        s := s + [book - 1 .. book + 12];
      end;
      goto success;
    end;

    Result := false;
    Exit;
  success:
    Result := true;
  end;

begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  bible := bookView.BookTabInfo.Bible;

  if cbQty.ItemIndex < cbQty.Items.Count - 1 then
    SearchPageSize := StrToInt(cbQty.Items[cbQty.ItemIndex])
  else
    SearchPageSize := 50000;

  if IsSearching then
  begin
    IsSearching := false;
    bible.StopSearching;
    Screen.Cursor := crDefault;
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    IsSearching := true;

    s := [];

    if (not bible.isBible)
    then
    begin
      if (cbList.ItemIndex <= 0) then
        s := [0 .. bible.BookQty - 1]
      else
        s := [cbList.ItemIndex - 1];
    end
    else
    begin // FULL BIBLE SEARCH
      data := Trim(cbList.Text);
      linksCnt := cbList.Items.Count - 1;
      if not mblSearchBooksDDAltered then
        if (cbList.ItemIndex < 0) then
          for i := 0 to linksCnt do
            if SysUtils.CompareText(cbList.Items[i], data) = 0 then
            begin
              cbList.ItemIndex := i;
              break;
            end;

      if (cbList.ItemIndex < 0) or (mblSearchBooksDDAltered) then
      begin
        lnks := TStringList.Create;
        try
          books := '';
          StrToLinks(data, lnks);
          linksCnt := lnks.Count - 1;
          for i := 0 to linksCnt do
          begin
            if metabook(bible, lnks[i]) then
            begin

              books := books + FirstWord(lnks[i]) + ' ';
              continue
            end
            else if bible.OpenReference(lnks[i], book, chapter, v1, v2) and
              (book > 0) and (book < 77) then
            begin
              Include(s, book - 1);
              if Pos(bible.ShortNames[book], books) <= 0 then
              begin

                books := books + bible.ShortNames[book] + ' ';
              end;

            end;

          end;
          books := Trim(books);
          if (Length(books) > 0) and (mslSearchBooksCache.IndexOf(books) < 0)
          then
          begin
            mslSearchBooksCache.Add(books);
          end;

        finally
          lnks.Free();
        end;
      end
      else
        case integer(cbList.Items.Objects[cbList.ItemIndex]) of
          0:
            s := [0 .. 65];
          -1:
            s := [0 .. 38];
          -2:
            s := [39 .. 65];
          -3:
            s := [0 .. 4];
          -4:
            s := [5 .. 21];
          -5:
            s := [22 .. 38];
          -6:
            s := [39 .. 43];
          -7:
            s := [44 .. 65];
          -8:
            begin
              if bible.Trait[bqmtApocrypha] then
                s := [66 .. bible.BookQty - 1]
              else
                s := [0];
            end;
        else
          s := [cbList.ItemIndex - 8 - ord(bible.Trait[bqmtApocrypha])];
          // search in single book
        end;
    end;

    data := Trim(cbSearch.Text);
    StrReplace(data, '.', ' ', true);
    StrReplace(data, ',', ' ', true);
    StrReplace(data, ';', ' ', true);
    StrReplace(data, '?', ' ', true);
    StrReplace(data, '"', ' ', true);
    data := Trim(data);

    if data <> '' then
    begin
      if cbSearch.Items.IndexOf(data) < 0 then
        cbSearch.Items.Insert(0, data);

      SearchResults.Clear;

      SearchWords.Clear;
      wrd := cbSearch.Text;

      if not chkExactPhrase.Checked then
      begin
        while wrd <> '' do
        begin
          wrdnew := DeleteFirstWord(wrd);

          SearchWords.Add(wrdnew);
        end;
      end
      else
      begin
        wrdnew := Trim(wrd);
        SearchWords.Add(wrdnew);
      end;

      params :=
        spWordParts * (1 - ord(chkParts.Checked)) +
        spContainAll * (1 - ord(chkAll.Checked)) +
        spFreeOrder * (1 - ord(chkPhrase.Checked)) +
        spAnyCase * (1 - ord(chkCase.Checked)) +
        spExactPhrase * ord(chkExactPhrase.Checked);

      if (params and spExactPhrase = spExactPhrase) and (params and spWordParts = spWordParts) then
        params := params - spWordParts;

      SearchTime := GetTickCount;
      bible.Search(data, params, s);
    end;
  finally
    Screen.Cursor := crDefault;
  end
end;

procedure TMainForm.FontChanged(delta: integer);
var
  defFontSz, browserpos: integer;
begin
  defFontSz := mTabsView.Browser.DefFontSize;
  if ((delta > 0) and (defFontSz > 48)) or ((delta < 0) and (defFontSz < 6))
  then
    Exit;
  inc(defFontSz, delta);
  Screen.Cursor := crHourGlass;
  try
    mTabsView.Browser.DefFontSize := defFontSz;
    browserpos := mTabsView.Browser.Position and $FFFF0000;

    mTabsView.Browser.LoadFromString(mTabsView.Browser.DocumentSource);
    mTabsView.Browser.Position := browserpos;

    browserpos := bwrSearch.Position and $FFFF0000;
    bwrSearch.DefFontSize := defFontSz;
    bwrSearch.LoadFromString(bwrSearch.DocumentSource);
    bwrSearch.Position := browserpos;

    browserpos := bwrDic.Position and $FFFF0000;
    bwrDic.DefFontSize := defFontSz;
    bwrDic.LoadFromString(bwrDic.DocumentSource);
    bwrDic.Position := browserpos;

    browserpos := bwrStrong.Position and $FFFF0000;
    bwrStrong.DefFontSize := defFontSz;
    bwrStrong.LoadFromString(bwrStrong.DocumentSource);
    bwrStrong.Position := browserpos;

    browserpos := bwrComments.Position and $FFFF0000;
    bwrComments.DefFontSize := defFontSz;
    bwrComments.LoadFromString(bwrComments.DocumentSource);
    bwrComments.Position := browserpos;

    browserpos := bwrXRef.Position and $FFFF0000;
    bwrXRef.DefFontSize := defFontSz;
    bwrXRef.LoadFromString(bwrXRef.DocumentSource);
    bwrXRef.Position := browserpos;

  except
  end;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.ForceForegroundLoad;
begin
  if not mModuleLoader.ScanDone then
  begin
    repeat
      LoadModules(false);
    until mModuleLoader.ScanDone;

    Application.OnIdle := nil;
    self.UpdateFromCashed();
    self.UpdateAllBooks();
    self.UpdateUI();
  end;

  if not mDictionariesFullyInitialized then
  begin
    mDictionariesFullyInitialized := LoadDictionaries(true);
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  tabsView: ITabsView;
begin
  if MainForm.Height < 100 then
    MainForm.Height := 420;

  writeln(NowDateTimeString(), 'FormClose entered');
  SaveConfiguration;

  for tabsView in mTabsViews do
  begin
    if (tabsView is TDockTabsForm) then
      (tabsView as TDockTabsForm).Close;
  end;

  Flush(Output);
  mBqEngine.Finalize();
  mBqEngine := nil;
  BibleLinkParser.FinalizeParser();
  try
    GfxRenderers.TbqTagsRenderer.Done();
    FreeAndNil(Memos);
    FreeAndNil(Bookmarks);
    FreeAndNil(History);
    FreeAndNil(SearchResults);
    FreeAndNil(SearchWords);
    FreeAndNil(StrongHebrew);
    FreeAndNil(StrongGreek);
    FreeAndNil(PasswordPolicy);
    FreeAndNil(mModules);
    FreeAndNil(mFavorites);
    FreeAndNil(mslSearchBooksCache);
    cleanUpInstalledFonts();

    if Assigned(SysHotKey) then
      SysHotKey.Active := false;
    FreeAndNil(SysHotKey);
  except
  end;
end;

procedure TMainForm.SearchListInit;
var
  i: integer;
  bookView: TBookFrame;
  bible: TBible;
begin
  bookView := GetBookView(self);
  bible := bookView.BookTabInfo.Bible;

  if (not bible.isBible) then
    with cbList do
    begin
      Items.BeginUpdate;
      Items.Clear;

      Items.AddObject(Lang.Say('SearchAllBooks'), TObject(0));

      for i := 1 to bible.BookQty do
        Items.AddObject(bible.FullNames[i], TObject(i));

      Items.EndUpdate;
      ItemIndex := 0;
      Exit;
    end;

  with cbList do
  begin
    Items.BeginUpdate;
    Items.Clear;

    Items.AddObject(Lang.Say('SearchWholeBible'), TObject(0));
    if bible.Trait[bqmtOldCovenant] and bible.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchOT'), TObject(-1)); // Old Testament
    if bible.Trait[bqmtNewCovenant] and bible.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchNT'), TObject(-2)); // New Testament
    if bible.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchPT'), TObject(-3)); // Pentateuch
    if bible.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchHP'), TObject(-4));
    // Historical and Poetical
    if bible.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchPR'), TObject(-5)); // Prophets
    if bible.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchGA'), TObject(-6)); // Gospels and Acts
    if bible.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchER'), TObject(-7)); // Epistles and Revelation
    if bible.Trait[bqmtApocrypha] then
      Items.AddObject(Lang.Say('SearchAP'), TObject(-8)); // Apocrypha

    for i := 1 to bible.BookQty do
      Items.AddObject(bible.FullNames[i], TObject(i));

    Items.EndUpdate;
    ItemIndex := 0;
  end;
end;

procedure TMainForm.ChapterComboBoxChange(Sender: TObject);
begin
  AddressFromMenus := true;
end;

procedure TMainForm.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Idle(Sender: TObject; var Done: Boolean);
begin
  // background modules loading
  if not mModuleLoader.ScanDone then
  begin
    LoadModules(true);
    if mModuleLoader.ScanDone then
    begin
      self.UpdateFromCashed();
      self.UpdateAllBooks();
      self.UpdateUI();
    end
    else
    begin
      Done := false;
      Exit;
    end;
  end;

  if not mDictionariesFullyInitialized then
  begin
    mDictionariesFullyInitialized := LoadDictionaries(false);
    Done := false;
    Exit;
  end;
  if not mBqEngine[bqsVerseListEngineInitialized] then
  begin
    if not mBqEngine[bqsVerseListEngineInitializing] then
      mBqEngine.InitVerseListEngine(self, false);
  end
  else
  begin
    Done := true;
  end;
end;

procedure TMainForm.imgLoadProgressClick(Sender: TObject);
begin
  //
end;

procedure TMainForm.InitHotkeysSupport;
begin
  SysHotKey := TSysHotKey.Create(self);
  SysHotKey.OnHotKey := SysHotKeyHotKey;
  if ConfigFormHotKeyChoiceItemIndex = 0 then
    SysHotKey.AddHotKey(vkQ, [hkExt])
  else
    SysHotKey.AddHotKey(vkB, [hkCtrl, hkAlt]);
  SysHotKey.Active := true;
end;

procedure TMainForm.InitializeTaggedBookMarks;
begin
  TbqTagsRenderer.Init(self, self, self.Font, self.Font);
  TbqTagsRenderer.VMargin := abs(vdtTagsVerses.Font.Height div 4);

  TbqTagsRenderer.hMargin := vdtTagsVerses.TextMargin;
  TbqTagsRenderer.CurveRadius := vdtTagsVerses.SelectionCurveRadius;
end;

procedure TMainForm.InitQNavList;
begin
  if not Assigned(MyLibraryForm) then
    MyLibraryForm := TMyLibraryForm.Create(self);
end;

function TMainForm.InsertHotModule(newMe: TModuleEntry; ix: integer): integer;
var
  favouriteMenuItem, hotMenuItem: TMenuItem;
  cnt, i: integer;
  tabsView: ITabsView;
begin
  Result := -1;
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    if not Assigned(favouriteMenuItem) then
      Exit;
    i := 0;
    cnt := favouriteMenuItem.Count;
    while (i < cnt) do
    begin
      if (favouriteMenuItem.Items[i].tag > 65536) then
        break;
      inc(i);
    end;
    if i >= cnt then
      Exit;

    hotMenuItem := TMenuItem.Create(self);
    hotMenuItem.tag := integer(newMe);
    hotMenuItem.Caption := newMe.mFullName;
    hotMenuItem.OnClick := HotKeyClick;

    favouriteMenuItem.Insert(ix + i, hotMenuItem);
    for tabsView in mTabsViews do
    begin
      tabsView.BibleTabs.Tabs.Insert(ix, newMe.VisualSignature());
      tabsView.BibleTabs.Tabs.Objects[ix] := newMe;
      Result := ix;
      tabsView.BibleTabs.Repaint();
    end;
  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;

function TMainForm.InstallFont(const specialPath: string): HRESULT;
var
  wsName, wsFolder: string;
  rslt: Boolean;
begin
  wsName := ExtractFileName(specialPath);
  wsFolder := ExtractFilePath(specialPath);
  rslt := mFontManager.PrepareFont(FileRemoveExtension(wsName), wsFolder);
  Result := -1 + ord(rslt);
end;

function TMainForm.InstallModule(const path: string): integer;
var
  shfOP: _SHFILEOPSTRUCTW;
begin
  Result := -1;
  try
    shfOP.Wnd := 0;
    shfOP.wFunc := FO_COPY;
    shfOP.pFrom := Pointer(path + #0);
    shfOP.pTo := Pointer(ExePath + 'compressed\modules\' +
      ExtractFileName(path) + #0);
    shfOP.fFlags := FOF_ALLOWUNDO or FOF_FILESONLY;
    shfOP.fAnyOperationsAborted := false;
    shfOP.hNameMappings := nil;
    shfOP.lpszProgressTitle := 'Module Installation';

    Result := SHFileOperationW(shfOP);
  except
    on E: Exception do
      BqShowException(E);
  end;
end;

function TMainForm.LoadAnchor(wb: THTMLViewer; SRC, current, loc: string): Boolean;
var
  i: integer;
  dest: string;
  ext: string;
  wstrings: TStrings;
  wsResolvedTxt: string;
  ti: TBookTabInfo;
begin
  Result := false;

  try
    i := Pos('#', SRC);
    ti := GetBookView(self).BookTabInfo;
    if i = 1 then
      loc := current + SRC;
    if i >= 1 then
    begin // found anchor
      i := Pos('#', loc);
      dest := System.Copy(loc, i, Length(loc) - i + 1); { local destination }
      SRC := System.Copy(loc, 1, i - 1); { the file name }
    end // found anchor
    else // no achor
      dest := ''; { no local destination }
    if (wb.CurrentFile = SRC) and (Assigned(ti) and not ti[vtisPendingReload])
    then
      wb.PositionTo(dest)
    else
    begin
      ext := UpperCase(ExtractFileExt(SRC));
      if (ext = '.HTM') or (ext = '.HTML') then
      begin { an html file }
        if Assigned(ti) and ti[vtisResolveLinks] then
        begin
          if not FileExistsEx(SRC) >= 0 then
            Exit;
          try

            wstrings := ReadHtml(SRC, ti.Bible.DefaultEncoding);

            wsResolvedTxt := ResolveLinks(wstrings.Text, ti[vtisFuzzyResolveLinks]);
            wb.LoadFromString(wsResolvedTxt);
            wb.PositionTo(dest);
            wb.__SetFileName(SRC);

          finally
            FreeAndNil(wstrings);
            wsResolvedTxt := '';
          end;
        end
        else
          wb.LoadFromFile(SRC + dest);
      end

      else if (ext = '.BMP') or (ext = '.GIF') or (ext = '.JPG') or (ext = '.JPEG') or (ext = '.PNG') then
        wb.LoadImageFile(SRC);
    end;
    Result := true;
  except
    on E: Exception do
    begin
      BqShowException(E);
    end
  end;
end;

procedure TMainForm.MainMenuInit(cacheupdate: Boolean);
var
  R: Boolean;
begin
  if cacheupdate then
  begin
    mModuleLoader.CachedModules.Clear();
    LoadModules(false);
  end
  else
  begin
    R := mModuleLoader.LoadCachedModules;
    if R then
      R := UpdateFromCashed();
    if not R then
    begin // failed to load and update
      LoadModules(false);
    end
    else
      mModuleLoader.CachedModules.Clear();
  end;
  mDefaultLocation := DefaultLocation();
  UpdateAllBooks();
  // DeleteInvalidHotModules();
end;

procedure TMainForm.LanguageMenuClick(Sender: TObject);
begin
  LastLanguageFile := (Sender as TMenuItem).Caption + '.lng';

  TranslateInterface(LastLanguageFile);
end;

procedure TMainForm.GoModuleName(s: string);
var
  i: integer;
  firstVisibleVerse: integer;
  wasBible: Boolean;
  commentpath: string;
  me: TModuleEntry;
  bl, obl: TBibleLink;
  blValidAddressExtracted: Boolean;
  path: string;
  hlVerses: TbqHLVerseOption;
  R: integer;
  iniPath: string;
  bookView: TBookFrame;
  bookTabInfo: TBookTabInfo;
  bible: TBible;
begin

  i := mModules.FindByName(s);
  if i < 0 then
  begin
    g_ExceptionContext.Add
      ('In GoModuleName: cannot find specified module name:' + s);
    raise Exception.Create('Exception mModules.FindByName failed!');
  end;
  me := mModules.Items[i];

  hlVerses := hlFalse;
  bookView := GetBookView(self);
  bookTabInfo := bookView.BookTabInfo;
  bible := bookTabInfo.Bible;

  // remember old module's params
  wasBible := bible.isBible;
  blValidAddressExtracted := bl.FromBqStringLocation(bookTabInfo.Location, path);
  if not blValidAddressExtracted then
  begin
    bl.Build(bible.CurBook, bible.CurChapter, bookTabInfo.FirstVisiblePara, 0);
    blValidAddressExtracted := true;
  end
  else
    hlVerses := hlTrue;

  if blValidAddressExtracted then
  begin
    // if valid address
    R := bible.ReferenceToInternal(bl, obl);
    if R <= -2 then
    begin
      obl.Build(1, 1, 0, 0);
      hlVerses := hlFalse;
    end
    else if R = -1 then
    begin
      obl.vend := 0;
    end;
  end;

  try
    if not Assigned(tempBook) then
      tempBook := TBible.Create(self);

    iniPath := TPath.Combine(me.mShortPath, 'bibleqt.ini');
    tempBook.inifile := MainFileExists(iniPath);
  except
  end;

  if tempBook.isBible and wasBible then
  begin
    R := tempBook.InternalToReference(obl, bl);
    if R <= -2 then
      hlVerses := hlFalse;
    try
      if (bookTabInfo.FirstVisiblePara > 0) and
        (bookTabInfo.FirstVisiblePara < bible.verseCount()) then
        firstVisibleVerse := bookTabInfo.FirstVisiblePara
      else
        firstVisibleVerse := -1;
      bookView.ProcessCommand(bl.ToCommand(TPath.Combine(commentpath, tempBook.ShortPath)), hlVerses);
      if firstVisibleVerse > 0 then
      begin
        mTabsView.Browser.PositionTo('bqverse' + IntToStr(firstVisibleVerse), false);
      end;
    except
    end;
  end // both previuous and current are bibles
  else
  begin
    bookView.SafeProcessCommand('go ' + TPath.Combine(commentpath, tempBook.ShortPath) + ' 1 1 0', hlFalse);
  end;
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  MainShiftState := Shift;
  if (Key = VK_CONTROL) then
  begin
    if G_ControlKeyDown then
      SetBibleTabsHintsState(false);
    G_ControlKeyDown := false;
  end;
  if (Shift = []) and (not(ActiveControl is TCustomEdit)) and
    (not(ActiveControl is TCustomCombo)) and (not(ActiveControl = vdtTagsVerses))
  then
    case Key of
      $47:
        ShowQNav(); // G key
      $48:
        miQuickNavClick(self); // H key
      $46:
        begin
          ShowSearchTab();
        end; // F key
    end;

end;

procedure TMainForm.miFontConfigClick(Sender: TObject);
var
  browserCount, i: integer;
  tabInfo: IViewTabInfo;
  bookView: TBookFrame;
  bookTabInfo: TBookTabInfo;
begin
  with FontDialog do
  begin
    Font.Name := mBrowserDefaultFontName;
    Font.color := mTabsView.Browser.DefFontColor;
    Font.Size := mTabsView.Browser.DefFontSize;
  end;

  bookView := GetBookView(self);
  if FontDialog.Execute then
  begin
    browserCount := mTabsView.ChromeTabs.Tabs.Count - 1;
    for i := 0 to browserCount do
    begin
      try
        tabInfo := mTabsView.GetTabInfo(i);
        if not (tabInfo is TBookTabInfo) then
          continue;

        bookTabInfo := tabInfo as TBookTabInfo;
        with bookTabInfo do
        begin
          if i <> mTabsView.ChromeTabs.ActiveTabIndex then
            StateEntryStatus[vtisPendingReload] := true;

          mTabsView.Browser.DefFontName := FontDialog.Font.Name;
          mBrowserDefaultFontName := mTabsView.Browser.DefFontName;
          mTabsView.Browser.DefFontColor := FontDialog.Font.color;
          mTabsView.Browser.DefFontSize := FontDialog.Font.Size;
        end // with
      except
      end;
    end;

    if Assigned(bookView) then
      bookView.ProcessCommand(bookView.BookTabInfo.Location, TbqHLVerseOption(ord(bookView.BookTabInfo[vtisHighLightVerses])));
  end;
end;

function TMainForm.ChooseColor(color: TColor): TColor;
begin
  Result := color;
  ColorDialog.color := color;

  if ColorDialog.Execute then
    Result := ColorDialog.color;
end;

procedure TMainForm.miBGConfigClick(Sender: TObject);
var
  i, browserCount: integer;
  newColor: TColor;
begin
  newColor := ChooseColor(mTabsView.Browser.DefBackGround);

  mTabsView.Browser.DefBackGround := newColor;
  mTabsView.Browser.Refresh;

  browserCount := mTabsView.ChromeTabs.Tabs.Count - 1;
  for i := 0 to browserCount do
  begin
    try
      if i <> mTabsView.ChromeTabs.ActiveTabIndex then
      begin
        Refresh();
      end;
    except
    end;
  end;

  bwrSearch.DefBackGround := newColor;
  bwrSearch.Refresh;

  bwrDic.DefBackGround := newColor;
  bwrDic.Refresh;

  bwrStrong.DefBackGround := newColor;
  bwrStrong.Refresh;

  bwrComments.DefBackGround := newColor;
  bwrComments.Refresh;

  bwrXRef.DefBackGround := newColor;
  bwrXRef.Refresh;
end;

procedure TMainForm.miHrefConfigClick(Sender: TObject);
var
  i, browserCount: integer;
  bookTabInfo, bTabInfo: TBookTabInfo;
  tabInfo: IViewTabInfo;
  newColor: TColor;
  bookView: TBookFrame;
begin
  with mTabsView.Browser do
  begin
    newColor := ChooseColor(DefHotSpotColor);
    DefHotSpotColor := newColor;
  end;

  bookView := GetBookView(self);
  bookTabInfo := bookView.BookTabInfo;

  bookView.ProcessCommand(bookTabInfo.Location, TbqHLVerseOption(ord(bookTabInfo[vtisHighLightVerses])));

  browserCount := mTabsView.ChromeTabs.Tabs.Count - 1;
  for i := 0 to browserCount do
  begin
    try
      tabInfo := mTabsView.GetTabInfo(i);
      if not (tabInfo is TBookTabInfo) then
        continue;

      bTabInfo := tabInfo as TBookTabInfo;
      with bTabInfo do
      begin
        if i <> mTabsView.ChromeTabs.ActiveTabIndex then
        begin
          StateEntryStatus[vtisPendingReload] := true;
        end;
      end // with
    except
    end;
  end;

  bwrSearch.DefHotSpotColor := newColor;
  bwrSearch.Refresh;

  bwrDic.DefHotSpotColor := newColor;
  bwrDic.Refresh;

  bwrStrong.DefHotSpotColor := newColor;
  bwrStrong.Refresh;

  bwrComments.DefHotSpotColor := newColor;
  bwrComments.Refresh;

  bwrXRef.DefHotSpotColor := newColor;
  bwrXRef.Refresh;
end;

procedure TMainForm.miFoundTextConfigClick(Sender: TObject);

begin
  ColorDialog.color := Hex2Color(SelTextColor);

  if ColorDialog.Execute then
  begin
    SelTextColor := Color2Hex(ColorDialog.color);
    DeferredReloadViewPages();
  end;
end;

function TMainForm.CopyPassage(fromverse, toverse: integer): string;
var
  i: integer;
  s: string;
  shiftDown: Boolean;
  bible: TBible;
begin
  bible := GetBookView(self).BookTabInfo.Bible;

  Result := '';
  for i := fromverse to toverse do
  begin
    s := bible.Verses[i - 1];
    StrDeleteFirstNumber(s);

    if bible.Trait[bqmtStrongs] and (not StrongNumbersOn) then
      s := DeleteStrongNumbers(s);

    if (CopyOptionsCopyVerseNumbersChecked xor (IsDown(VK_CONTROL))) and
      (fromverse > 0) and (fromverse <> toverse) then
    begin
      if CopyOptionsAddReferenceChecked and
        (CopyOptionsAddReferenceRadioItemIndex = 0) then
      begin
        with bible do
          s := ShortPassageSignature(CurBook, CurChapter, i, i) + ' ' + s;

        if CopyOptionsAddModuleNameChecked then
          s := bible.ShortName + ' ' + s;
      end
      else
      begin
        if not IsSpaceEndedString(s) then
          s := s + ' ';

        s := IntToStr(i) + ' ' + s;
      end;
    end;

    if CopyOptionsAddLineBreaksChecked then
    begin
      shiftDown := IsDown(VK_SHIFT);
      if (CopyOptionsCopyFontParamsChecked xor shiftDown) then
      begin
        s := s + '<br>'#13#10;
      end
      else
        s := s + #13#10;
      Result := Result + s;
    end
    else
      Result := Result + ' ' + s;
  end;

  if CopyOptionsAddReferenceChecked and
    (CopyOptionsAddReferenceRadioItemIndex > 0) then
  begin
    if not CopyOptionsAddLineBreaksChecked then
      Result := Result + ' ('
    else
      Result := Result + '(';

    if CopyOptionsAddModuleNameChecked then
      Result := Result + bible.ShortName + ' ';

    with bible do
      if CopyOptionsAddReferenceRadioItemIndex = 1 then
        Result := Result + ShortPassageSignature(CurBook, CurChapter, fromverse, toverse) + ')'
      else
        Result := Result + FullPassageSignature(CurBook, CurChapter, fromverse, toverse) + ')';
  end;

  s := ParseHTML(Result, '');

  if not CopyOptionsAddLineBreaksChecked then
    StrReplace(s, #13#10, ' ', true);

  StrReplace(s, '  ', ' ', true);
  StrReplace(s, '  ', ' ', true);
  StrReplace(s, '  ', ' ', true);
  if (CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then
  begin
    mHTMLSelection := Result;
    InsertDefaultFontInfo(mHTMLSelection, mTabsView.Browser.DefFontName, mTabsView.Browser.DefFontSize);
  end
  else
    mHTMLSelection := '';

  Result := s;
end;

procedure TMainForm.CopyVerse();
var
  trCount: integer;
begin
  trCount := 7;
  repeat
    try
      Clipboard.AsText := CopyPassage(CurVerseNumber, CurVerseNumber);
      ConvertClipboard;
      trCount := 0;
    except
      Dec(trCount);
      sleep(100);
    end;
  until trCount <= 0;
end;

procedure TMainForm.miXrefClick(Sender: TObject);
begin
  if not pgcMain.Visible then
    tbtnToggle.Click;

  tbXRef.tag := 1;
  pgcMain.ActivePage := tbXRef;
  ShowXref;
end;

function CustomControlAtPos(
  ParentControl: TWinControl;
  const Pos: TPoint;
  AllowDisabled, AllowWinControls, AllLevels: Boolean): TControl;
var
  p: TPoint;
  C: TControl;
  c2: TControl;
begin
  p := Pos;
  C := ParentControl.ControlAtPos(p, AllowDisabled, AllowWinControls, false);

  if C <> nil then
  begin
    if AllLevels and (C is TWinControl) then
    begin
      repeat
        p := C.ParentToClient(p);
        c2 := TWinControl(C).ControlAtPos(p, AllowDisabled, AllowWinControls, false);

        if c2 <> nil then
          C := c2;
      until c2 = nil;
    end;
  end;

  Result := C;
end;

procedure TMainForm.MouseWheelHandler(var Message: TMessage);
var
  mwm: ^TWMMouseWheel; // absolute message;
  pt, screenPt: TPoint;
  ctrl: TControl;
  focusHwnd: HWND;
{$J+}
const
  oneEntry: Boolean = false;
{$J-}
label tail;
begin
  if oneEntry then
  begin
    Exit;
  end;
  oneEntry := true;
  mwm := @message;
  screenPt.X := mwm^.XPos;
  screenPt.Y := mwm^.YPos;
  pt := ScreenToClient(screenPt);
  ctrl := CustomControlAtPos(self, pt, false, true, true);
  if not Assigned(ctrl) then
  begin
    inherited MouseWheelHandler(Message);
    goto tail;
  end;

  if ctrl is TWinControl then
  begin
    focusHwnd := WindowFromPoint(screenPt);
    if (focusHwnd <> 0) and (focusHwnd <> TWinControl(ctrl).Handle) then
    begin

      inherited MouseWheelHandler(Message);
      goto tail;
    end;

    if not TWinControl(ctrl).Focused then
    begin
      try
        FocusControl(TWinControl(ctrl));
      except
      end;
      message.Result := 1;
      goto tail;
    end;
  end;

  inherited;
tail:
  oneEntry := false;
end;

procedure TMainForm.ShowXref;
var
  ti: TMultiLanguage;
  tf: TSearchRec;
  s, snew, passageSig: string;
  verse, tmpverse, book, chapter, fromverse, toverse,
  i, j: integer;
  RefLines: string;
  RefText: string;
  Links: TStrings;
  slink: string;
  diff: integer;
  path: string;
  bookTabInfo: TBookTabInfo;
  mainBible, secBible: TBible;
begin
  bookTabInfo := GetBookView(self).BookTabInfo;
  mainBible := bookTabInfo.Bible;
  secBible := bookTabInfo.SecondBible;

  if mModules.IndexOf(mainBible.Name) = -1 then
    Exit;

  if not pgcMain.Visible then
    Exit;

  if pgcMain.ActivePage <> tbXRef then
    pgcMain.ActivePage := tbXRef;

  if tbXRef.tag = 0 then
    tbXRef.tag := 1;

  RefLines := '';
  Links := TStringList.Create;

  secBible.inifile := mainBible.inifile;

  mainBible.ReferenceToEnglish(mainBible.CurBook, mainBible.CurChapter, tbXRef.tag, book, chapter, verse);
  s := IntToStr(book);

  if Length(s) = 1 then
    s := '0' + s;

  path := TPath.Combine(ModulesDirectory, C_TSKSubDirectory);
  path := TPath.Combine(path, s + '_*.ini');

  if FindFirst(path, faAnyFile, tf) <> 0 then
    Exit;

  ti := TMultiLanguage.Create(nil);

  path := TPath.Combine(ModulesDirectory, C_TSKSubDirectory);
  ti.inifile := TPath.Combine(path, tf.Name);

  secBible.OpenChapter(mainBible.CurBook, mainBible.CurChapter);

  tmpverse := tbXRef.tag;

  if tmpverse > secBible.verseCount() then
    tmpverse := secBible.verseCount();
  s := secBible[tmpverse - 1];
  StrDeleteFirstNumber(s);
  s := DeleteStrongNumbers(s);

  RefText := Format
    ('<a name=%d><a href="go %s %d %d %d"><font face=%s>%s%d:%d</font></a><br><font face="%s">%s</font><p>',
    [tmpverse, mainBible.ShortPath, mainBible.CurBook, mainBible.CurChapter,
    tmpverse, mBrowserDefaultFontName, mainBible.ShortNames[mainBible.CurBook],
    mainBible.CurChapter, tmpverse, mainBible.fontName, s]);

  slink := ti.ReadString(IntToStr(chapter), IntToStr(verse), '');
  if slink = '' then
    AddLine(RefLines, RefText + '<b>.............</b>')
  else
  begin
    StrToLinks(slink, Links);

    // get xrefs
    for i := 0 to Links.Count - 1 do
    begin
      if not secBible.OpenTSKReference(Links[i], book, chapter, fromverse, toverse) then
        continue;

      diff := toverse - fromverse;
      secBible.ENG2RUS(book, chapter, fromverse, book, chapter, fromverse);

      if not secBible.InternalToReference(book, chapter, fromverse, book, chapter, fromverse) then
        continue; // if this module doesn't have the link...

      toverse := fromverse + diff;

      if fromverse = 0 then
        fromverse := 1;
      if toverse < fromverse then
        toverse := fromverse; // if one verse

      try
        secBible.OpenChapter(book, chapter);
      except
        continue;
      end;

      if fromverse > secBible.verseCount() then
        continue;
      if toverse > secBible.verseCount then
        toverse := secBible.verseCount;

      s := '';
      for j := fromverse to toverse do
      begin
        snew := secBible.Verses[j - 1];
        s := s + ' ' + StrDeleteFirstNumber(snew);
        snew := DeleteStrongNumbers(snew);
        s := s + ' ' + snew;
      end;
      s := Trim(s);

      StrDeleteFirstNumber(s);
      passageSig := Format('<font face="%s">%s</font>',
        [mBrowserDefaultFontName, secBible.ShortPassageSignature(book, chapter, fromverse, toverse)]);
      if toverse = fromverse then
        RefText := RefText +
          Format
          ('<a href="go %s %d %d %d %d">%s</a> <font face="%s">%s</font><br>',
          [mainBible.ShortPath, book, chapter, fromverse, 0, passageSig, mainBible.fontName, s])
      else
        RefText := RefText +
          Format
          ('<a href="go %s %d %d %d %d">%s</a> <font face="%s">%s</font><br>',
          [mainBible.ShortPath, book, chapter, fromverse, toverse, passageSig, mainBible.fontName, s]);
    end;

    AddLine(RefLines, RefText);
  end;

  AddLine(RefLines, '</font><br><br>');

  bwrXRef.DefFontName := mTabsView.Browser.DefFontName;
  mXRefMisUsed := false;
  bwrXRef.LoadFromString(RefLines);

  Links.Free;
end;

procedure TMainForm.tbtnSoundClick(Sender: TObject);
var
  book, chapter, verse: integer;
  fname3, fname2: string;
  find: string;
  bible: TBible;
begin
  bible := GetBookView(self).BookTabInfo.Bible;

  if not bible.isBible then
    Exit;

  bible.InternalToReference(bible.CurBook, bible.CurChapter, 1, book, chapter, verse);

  if bible.SoundDirectory = '' then
  begin // 3 digits
    fname3 := Format('Sounds\%.2d\%.3d', [book, chapter]);
    fname2 := Format('Sounds\%.2d\%.2d', [book, chapter]);
  end
  else
  begin // 2 digits
    fname3 := Format('%s\%.2d\%.3d', [bible.SoundDirectory, book, chapter]);
    fname2 := Format('%s\%.2d\%.2d', [bible.SoundDirectory, book, chapter]);
  end;

  find := MainFileExists(fname3 + '.wav');
  if find = '' then
    find := MainFileExists(fname3 + '.mp3');
  if find = '' then
    find := MainFileExists(fname2 + '.wav');
  if find = '' then
    find := MainFileExists(fname2 + '.mp3');

  if find = '' then
    ShowMessage(Format(Lang.Say('SoundNotFound'), [mTabsView.Browser.DocumentTitle]))
  else
    ShellExecute(Application.Handle, nil, PChar(find), nil, nil, SW_MINIMIZE);
end;

procedure TMainForm.miHotkeyClick(Sender: TObject);
begin
  ConfigForm.pgcOptions.ActivePageIndex := 1;
  ShowConfigDialog;
end;

procedure TMainForm.miDeteleBibleTabClick(Sender: TObject);
var
  me: TModuleEntry;
begin
  if miDeteleBibleTab.tag < 0 then
    Exit;
  try
    me := (mTabsView.BibleTabs.Tabs.Objects[miDeteleBibleTab.tag]) as TModuleEntry;
    mFavorites.DeleteModule(me);
  except
  end;
end;

procedure TMainForm.miDialogFontConfigClick(Sender: TObject);
var
  fnt: TFont;
  h: integer;
begin
  with FontDialog do
  begin
    Font.Name := MainForm.Font.Name;
    Font.Size := MainForm.Font.Size;
    Font.CharSet := MainForm.Font.CharSet;
  end;

  if FontDialog.Execute then
    with MainForm do
    begin
      fnt := TFont.Create;
      try
        fnt.Name := FontDialog.Font.Name;
        fnt.CharSet := FontDialog.Font.CharSet;
        fnt.Size := FontDialog.Font.Size;

        self.Font := fnt;
        mTabsView.BibleTabs.Font.Assign(fnt);
        Screen.HintFont := fnt;
        h := fnt.Height;

        if h < 0 then
          h := -h;

        mTabsView.BibleTabs.Height := h + 13;
        Update;
        lblTitle.Font.Assign(fnt);
        lblCopyRightNotice.Font.Assign(fnt);
        vstDicList.DefaultNodeHeight := Canvas.TextHeight('X') * 6 div 5;
        vstDicList.ReinitNode(vstDicList.RootNode, true);
        vstDicList.Invalidate();
        vstDicList.Repaint();

        if Assigned(MyLibraryForm) then
        begin
          MyLibraryForm.Font.Assign(Font);
          MyLibraryForm.Font.Height := MyLibraryForm.Font.Height * 5 div 4;
          MyLibraryForm.Refresh();
        end;

      finally
        fnt.Free
      end

    end;

end;

procedure TMainForm.CopyPassageToClipboard();
var
  trCount: integer;
begin
  trCount := 7;
  repeat
    try
      Clipboard.AsText := CopyPassage(CurSelStart, CurSelEnd);
      ConvertClipboard;
      trCount := 0;
    except
      Dec(trCount);
      sleep(100);
    end;
  until trCount <= 0;
end;

procedure TMainForm.miCopyPassageClick(Sender: TObject);
begin
  CopyPassageToClipboard();
end;

procedure TMainForm.DisplayDictionary(const s: string);
var
  res: string;
  i, j: integer;
  dc_ix: integer;
  dicCount: integer;
  nd: PVirtualNode;
begin
  if Trim(s) = '' then
    Exit;

  if edtDic.Items.IndexOf(s) = -1 then
    edtDic.Items.Insert(0, s);
  if not(pgcMain.ActivePage = tbDic) then
    pgcMain.ActivePage := tbDic;

  edtDic.Text := s;

  dc_ix := LocateDicItem; // find the word or closest...
  if dc_ix < 0 then
  begin
    MessageBeep(MB_ICONERROR);
    Exit
  end;

  nd := PVirtualNode(mBqEngine.DictionaryTokens.Objects[dc_ix]);
  vstDicList.Selected[nd] := true;
  DicScrollNode(nd);
  cbDic.Items.BeginUpdate;
  try
    cbDic.Items.Clear;

    j := 0;
    dicCount := mBqEngine.DictionariesCount - 1;
    for i := 0 to dicCount do
    begin
      res := mBqEngine.Dictionaries[i].Lookup(mBqEngine.DictionaryTokens[dc_ix]);
      if res <> '' then
        cbDic.Items.Add(mBqEngine.Dictionaries[i].Name);

      if mBqEngine.Dictionaries[i].Name = cbDicFilter.Items[cbDicFilter.ItemIndex] then
        j := cbDic.Items.Count - 1;
    end;

    if cbDic.Items.Count > 0 then
      cbDic.ItemIndex := j;
  finally
    cbDic.Items.EndUpdate;
  end;

  cbDic.Enabled := not(cbDic.Items.Count = 1);

  if cbDic.Items.Count = 1 then
    lblDicFoundSeveral.Caption := Lang.Say('FoundInOneDictionary')
  else
    lblDicFoundSeveral.Caption := Lang.Say('FoundInSeveralDictionaries');

  if cbDic.Items.Count > 0 then
    cbDicChange(self) // invoke showing first dictionary result
end;

procedure TMainForm.DisplayStrongs(num: integer; hebrew: Boolean);
var
  res, s, Copyright: string;
  i: integer;
  fullDir: string;
  bible: TBible;
begin
  s := IntToStr(num);
  for i := Length(s) to 4 do
    s := '0' + s;

  bible := GetBookView(self).BookTabInfo.Bible;

  StrongsDir := bible.StrongsDirectory;

  if StrongsDir = '' then
    StrongsDir := C_StrongsSubDirectory;

  fullDir := TPath.Combine(ModulesDirectory, StrongsDir);

  try
    if hebrew or (num = 0) then
    begin
      if not(StrongHebrew.Initialize(TPath.Combine(fullDir, 'hebrew.idx'), TPath.Combine(fullDir, 'hebrew.htm'))) then
        ShowMessage('Error in' + TPath.Combine(fullDir, 'hebrew.*'));

      res := StrongHebrew.Lookup(s);
      StrReplace(res, '<h4>', '<h4>H', false);
      Copyright := StrongHebrew.Name;
    end
    else
    begin
      if not(StrongGreek.Initialize(TPath.Combine(fullDir, 'greek.idx'), TPath.Combine(fullDir, 'greek.htm'))) then
        ShowMessage('Error in' + TPath.Combine(fullDir, 'greek.*'));

      res := StrongGreek.Lookup(s);
      StrReplace(res, '<h4>', '<h4>G', false);
      Copyright := StrongGreek.Name;
    end;
  except
    on e: Exception do
    begin

      BqShowException(e);
    end;
  end;

  pgcMain.ActivePage := tbStrong;

  if res <> '' then
  begin
    res := FormatStrongNumbers(res, false, false);

    AddLine(res, '<p><font size=-1>' + Copyright + '</font>');
    bwrStrong.LoadFromString(res);

    s := IntToStr(num);
    if hebrew then
      s := 'H' + s
    else
      s := 'G' + s;

    i := lbStrong.Items.IndexOf(s);
    if i = -1 then
    begin
      lbStrong.Items.Add(s);
      lbStrong.ItemIndex := lbStrong.Items.Count - 1;
    end
    else
      lbStrong.ItemIndex := i;
  end;

end;

procedure TMainForm.miPrintPreviewClick(Sender: TObject);
begin
  tbtnPreviewClick(Sender);
end;

procedure TMainForm.lbHistoryDblClick(Sender: TObject);
var
  s: string;
  bookView: TBookFrame;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  s := History[lbHistory.ItemIndex];

  History.Delete(lbHistory.ItemIndex);
  lbHistory.Items.Delete(lbHistory.ItemIndex);

  bookView.ProcessCommand(s, hlDefault);
  tbLinksToolBar.Visible := false;
end;

procedure TMainForm.miStrongClick(Sender: TObject);
begin
  GetBookView(self).ToggleStrongNumbers();
end;

procedure TMainForm.miVerseHighlightBGClick(Sender: TObject);
var
  cl, newcl: TColor;
begin
  try
    cl := Hex2Color(g_VerseBkHlColor);
  except
    cl := $F5F5DC;
  end;
  newcl := ChooseColor(cl);
  if newcl <> cl then
  begin
    g_VerseBkHlColor := Color2Hex(newcl);
    DeferredReloadViewPages();
  end;
end;

procedure TMainForm.ConvertClipboard;
var
  bookView: TBookFrame;
  bible: TBible;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  bible := bookView.BookTabInfo.Bible;

  if not(CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then
    Exit;

  if bible.fontName <> '' then
    reClipboard.Font.Name := bible.fontName
  else
    reClipboard.Font.Name := mTabsView.Browser.DefFontName;

  reClipboard.Font.Size := mTabsView.Browser.DefFontSize;
  reClipboard.Lines.Add(Clipboard.AsText);

  reClipboard.SelectAll;
  reClipboard.SelAttributes.CharSet := mTabsView.Browser.CharSet;
  reClipboard.SelAttributes.Name := reClipboard.Font.Name;

  if Length(mHTMLSelection) > 0 then
    CopyHTMLToClipBoard('', mHTMLSelection)
  else
    reClipboard.CopyToClipboard;
end;

procedure TMainForm.DisplaySearchResults(page: integer);
var
  i, limit: integer;
  s: string;
  dSource: string;
  bookView: TBookFrame;
begin

  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  if (SearchPageSize * (page - 1) > SearchResults.Count) or (SearchResults.Count = 0) then
  begin
    Screen.Cursor := crDefault;
    Exit;
  end;

  SearchPage := page;

  dSource := Format('<b>"<font face="%s">%s</font>"</b> (%d) <p>', [bookView.BookTabInfo.Bible.fontName, cbSearch.Text, SearchResults.Count]);

  limit := SearchResults.Count div SearchPageSize + 1;
  if SearchPageSize * (limit - 1) = SearchResults.Count then
    limit := limit - 1;

  s := '';
  for i := 1 to limit - 1 do
  begin
    if i <> page then
      s := s + Format('<a href="%d">%d-%d</a> ', [i, SearchPageSize * (i - 1) + 1, SearchPageSize * i])
    else
      s := s + Format('%d-%d ', [SearchPageSize * (i - 1) + 1, SearchPageSize * i]);
  end;

  if limit <> page then
    s := s + Format('<a href="%d">%d-%d</a> ',
      [limit, SearchPageSize * (limit - 1) + 1, SearchResults.Count])
  else
    s := s + Format('%d-%d ', [SearchPageSize * (limit - 1) + 1, SearchResults.Count]);

  limit := SearchPageSize * page - 1;
  if limit >= SearchResults.Count then
    limit := SearchResults.Count - 1;

  for i := SearchPageSize * (page - 1) to limit do
    AddLine(dSource, '<font size=-1>' + IntToStr(i + 1) + '.</font> ' + SearchResults[i]);

  AddLine(dSource, '<a name="endofsearchresults"><p>' + s + '<br><p>');

  bwrSearch.CharSet := mTabsView.Browser.CharSet;

  StrReplace(dSource, '<*>', '<font color=' + SelTextColor + '>', true);
  StrReplace(dSource, '</*>', '</font>', true);

  bwrSearch.LoadFromString(dSource);

  LastSearchResultsPage := page;
  Screen.Cursor := crDefault;
  ActiveControl := bwrSearch;
end;

procedure TMainForm.bwrSearchHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  i, code: integer;
  book, chapter, fromverse, toverse: integer;
  wsrc, satBible: string;
  bookTabInfo: TBookTabInfo;
  bookView: TBookFrame;
  bible: TBible;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  bookTabInfo := bookView.BookTabInfo;
  bible := bookTabInfo.Bible;

  wsrc := SRC;
  Val(wsrc, i, code);
  if code = 0 then
    DisplaySearchResults(i)
  else
  begin
    if (Copy(wsrc, 1, 3) <> 'go ') then
    begin
      if bible.OpenReference(wsrc, book, chapter, fromverse, toverse) then
        wsrc := Format('go %s %d %d %d %d', [bible.ShortPath, book, chapter, fromverse, toverse])
      else
        wsrc := '';
    end;
    if Length(wsrc) > 0 then
    begin
      if IsDown(VK_MENU) then
      begin
        if Assigned(bookTabInfo) then
          satBible := bookTabInfo.SatelliteName
        else
          satBible := '------';

        NewBookTab(wsrc, satBible, mTabsView.Browser.Base, bookTabInfo.State, '', true);

      end
      else
       bookView.ProcessCommand(wsrc, hlTrue);
    end;
  end;
  Handled := true;
end;

procedure TMainForm.bwrSearchHotSpotCovered(Sender: TObject; const SRC: string);
begin
  GetBookView(self).BrowserHotSpotCovered(Sender as THTMLViewer, SRC);
end;

procedure TMainForm.miShowSignaturesClick(Sender: TObject);
var
  bookView: TBookFrame;
  vti: TBookTabInfo;
  savePosition: integer;
begin
  miShowSignatures.Checked := not miShowSignatures.Checked;

  bookView := GetBookView(self);
  vti := bookView.BookTabInfo;
  vti[vtisShowStrongs] := StrongNumbersOn;
  savePosition := mTabsView.Browser.Position;
  bookView.ProcessCommand(vti.Location, TbqHLVerseOption(ord(vti[vtisHighLightVerses])));
  mTabsView.Browser.Position := savePosition;
end;

procedure TMainForm.CompareTranslations();
var
  book, chapter, verse, ib, ic, iv: integer;
  openSuccess: Boolean;
  s: string;
  dBrowserSource: string;
  fontFound: Boolean;
  fontName: string;
  bibleModuleEntry: TModuleEntry;
  bookTabInfo: TBookTabInfo;
  bible, secBible: TBible;
label LoopTail;
begin
  bookTabInfo := GetBookView(self).BookTabInfo;
  if (not Assigned(bookTabInfo)) then
    Exit;

  bible := bookTabInfo.Bible;
  if not bible.isBible then
    Exit;

  if (mTabsView.ChromeTabs.ActiveTabIndex < 0) then
    Exit;

  secBible := bookTabInfo.SecondBible;

  // try
  dBrowserSource := '<font size=+1><table>';
  mTabsView.Browser.DefFontName := mBrowserDefaultFontName;
  bible.OpenChapter(bible.CurBook, bible.CurChapter);
  s := bible.Verses[CurVerseNumber - 1];
  StrDeleteFirstNumber(s);

  if not StrongNumbersOn then
    s := DeleteStrongNumbers(s);

  AddLine(dBrowserSource,
    Format
    ('<tr><td valign=top><a href="go %s %d %d %d 0">%s&nbsp;%s</a>&nbsp;</td><td valign=top><font face="%s">%s</font></td>'#13#10,
    [bible.ShortPath, bible.CurBook, bible.CurChapter, CurVerseNumber,
    bible.ShortName, bible.ShortPassageSignature(bible.CurBook,
    bible.CurChapter, CurVerseNumber, CurVerseNumber),
    bible.fontName, s]));

  AddLine(dBrowserSource, '<tr><td></td><td><hr width=100%></td></tr>'#13#10);
  bibleModuleEntry := mModules.ModTypedAsFirst(modtypeBible);
  while Assigned(bibleModuleEntry) do
  begin
    s := bibleModuleEntry.getIniPath();
    secBible.inifile := s;

    // don't display New Testament mixed with Old Testament...
    if (bible.CurBook < 40) and (bible.Trait[bqmtOldCovenant]) and (not secBible.Trait[bqmtOldCovenant]) then
      goto LoopTail;

    if (bible.CurBook > 39) and (bible.Trait[bqmtNewCovenant]) and (not secBible.Trait[bqmtNewCovenant]) then
      goto LoopTail;

    with bible do
      ReferenceToInternal(CurBook, CurChapter, CurVerseNumber, book, chapter, verse);

    secBible.InternalToReference(book, chapter, verse, ib, ic, iv);

    try
      openSuccess := secBible.OpenChapter(ib, ic);
    except
      openSuccess := false

    end;
    if not openSuccess then
      goto LoopTail;
    if iv > secBible.verseCount() then
      goto LoopTail;

    s := secBible.Verses[iv - 1];
    StrDeleteFirstNumber(s);

    if not StrongNumbersOn then
      s := DeleteStrongNumbers(s);

    if Length(secBible.fontName) > 0 then
    begin
      fontFound := mFontManager.PrepareFont(secBible.fontName, secBible.path);
      fontName := secBible.fontName;
    end
    else
      fontFound := false;
    // if there is no preferred font or it is not found and the encoding is specified
    if not fontFound and (secBible.desiredCharset >= 2) then
    begin
      // find the font with the desired encoding
      if Length(secBible.fontName) > 0 then
        fontName := secBible.fontName
      else
        fontName := mBrowserDefaultFontName;
      fontName := FontFromCharset(self.Canvas.Handle, secBible.desiredCharset, fontName);
    end;

    AddLine(dBrowserSource,
      Format('<tr><td valign=top><a href="go %s %d %d %d 0">%s&nbsp;%s</a>&nbsp;' +
      '<BR><SPAN STYLE="font-size:67%%">%s</SPAN></td><td valign=top><font face="%s">%s</font></td></tr>'#13#10,
      [secBible.ShortPath, ib, ic, iv, secBible.ShortName,
      secBible.ShortPassageSignature(ib, ic, iv, iv), secBible.Name,
      fontName, s]));
  LoopTail:
    bibleModuleEntry := mModules.ModTypedAsNext(modtypeBible);
  end;

  AddLine(dBrowserSource, '</table>');
  mTabsView.Browser.LoadFromString(dBrowserSource);

  bookTabInfo.IsCompareTranslation := true;
  bookTabInfo.CompareTranslationText := dBrowserSource;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  tabsView: ITabsView;
  tabsForm: TDockTabsForm;
begin
  if MainFormInitialized then
    Exit; // run only once...
  MainFormInitialized := true;

  if (not mTranslated) then
  begin
    MessageDlg('No localization file.', mtWarning, [mbOk], 0);
  end;

  pgcHistoryBookmarks.ActivePage := tbHistory;

  tbLinksToolBar.Visible := false;
  cbQty.ItemIndex := 0;

  TranslateControl(ExceptionForm);
  TranslateControl(AboutForm);

  ConfigForm.Font := MainForm.Font;
  ConfigForm.Font.CharSet := MainForm.Font.CharSet;

  TranslateConfigForm;

  for tabsView in mTabsViews do
  begin
    if (tabsView is TDockTabsForm) then
    begin
      tabsForm := tabsView as TDockTabsForm;
      tabsForm.BringToFront;
    end;
  end;

end;

procedure TMainForm.cbLinksChange(Sender: TObject);
var
  book, chapter, fromverse, toverse: integer;
  bookView: TBookFrame;
  bible: TBible;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  bible := bookView.BookTabInfo.Bible;
  bookView.tedtReference.Text := cbLinks.Items[cbLinks.ItemIndex];

  if bible.OpenReference(bookView.tedtReference.Text, book, chapter, fromverse, toverse) then
    bookView.ProcessCommand(Format('go %s %d %d %d %d', [bible.ShortPath, book, chapter, fromverse, toverse]), hlDefault)
  else
    bookView.ProcessCommand(bookView.tedtReference.Text, hlDefault);
end;

function TMainForm.DefaultLocation: string;
var
  i, fc: integer;
  bibleModuleEntry: TModuleEntry;
begin
  Result := '';
  try
    bibleModuleEntry := nil;
    fc := mFavorites.mModuleEntries.Count - 1;
    for i := 0 to fc do
    begin
      if mFavorites.mModuleEntries[i].modType = modtypeBible then
      begin
        bibleModuleEntry := mFavorites.mModuleEntries[i];
        break;
      end;
    end;

    if not Assigned(bibleModuleEntry) then
    begin
      bibleModuleEntry := mModules.ModTypedAsFirst(modtypeBible);
    end;
    if not Assigned(bibleModuleEntry) then
      raise Exception.Create
        ('Не найдено ни одного библейского модуля! Проверьте правильность установки exe файла Ц.'
        + #13#10'Он должен быть в папке, содержащей вложенные в нее папки модулей');

    Result := bibleModuleEntry.mShortPath;
  except
    on E: Exception do
    begin
      BqShowException(E, 'Error calculating Default Location:');
      Result := 'rststrong';
    end;
  end;
end;

procedure TMainForm.DeferredReloadViewPages;
var
  i, C: integer;
  bookView: TBookFrame;
  cti: IViewTabInfo;
  bookTabInfo, bti: TBookTabInfo;
begin
  bookView := GetBookView(self);
  bookTabInfo := bookView.BookTabInfo;
  C := mTabsView.ChromeTabs.Tabs.Count - 1;
  for i := 0 to C do
  begin
    try
      cti := mTabsView.GetTabInfo(i);
      if not (cti is TBookTabInfo) then
        continue;

      bti := cti as TBookTabInfo;
      if bookTabInfo <> bti then
        bti[vtisPendingReload] := true;
    except
    end;
  end;
  bookView.ProcessCommand(bookTabInfo.Location, TbqHLVerseOption(ord(bookTabInfo[vtisHighLightVerses])));
end;

procedure TMainForm.DeleteHotModule(moduleTabIx: integer);
var
  hotMenuItem, favouriteMenuItem: TMenuItem;
  tabsView: ITabsView;
  bookView: TBookFrame;
begin
  try
    bookView := GetBookView(self);
    hotMenuItem := mTabsView.BibleTabs.Tabs.Objects[moduleTabIx] as TMenuItem;

    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    if not Assigned(favouriteMenuItem) then
      Exit;
    favouriteMenuItem.Remove(hotMenuItem);

    for tabsView in mTabsViews do
    begin
      tabsView.BibleTabs.Tabs.Delete(moduleTabIx);
    end;

    hotMenuItem.Free();
    bookView.AdjustBibleTabs(bookView.BookTabInfo.Bible.ShortName);
    SetFavouritesShortcuts();
  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;

procedure TMainForm.bwrDicHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  cmd, prefBible, ConcreteCmd: string;
  autoCmd: Boolean;
  bookView: TBookFrame;
  bible: TBible;
  status: integer;
begin
  bookView := GetBookView(self);

  cmd := SRC;
  Handled := true;
  autoCmd := Pos(C__bqAutoBible, cmd) <> 0;
  if autoCmd then
  begin
    bible := bookView.BookTabInfo.Bible;
    if bible.isBible then
      prefBible := bible.ShortPath
    else
      prefBible := '';

    status := bookView.PreProcessAutoCommand(cmd, prefBible, ConcreteCmd);
    if status <= -2 then
      Exit;
  end;

  if not IsDown(VK_CONTROL) then
  begin
    if autoCmd then
      G_XRefVerseCmd := ConcreteCmd
    else
      G_XRefVerseCmd := SRC;
    miOpenNewViewClick(Sender);
  end
  else
  begin
    if autoCmd then
      bookView.ProcessCommand(ConcreteCmd, hlDefault)
    else
    begin
      bookView.tedtReference.Text := SRC;
      GoReference();
    end
  end;
end;

procedure TMainForm.bwrDicHotSpotCovered(Sender: TObject; const SRC: string);
begin
  GetBookView(self).BrowserHotSpotCovered(Sender as THTMLViewer, SRC);
end;

procedure TMainForm.bwrCommentsHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  cmd, prefBible, ConcreteCmd: string;
  autoCmd: Boolean;
  bible: TBible;
  bookView: TBookFrame;
  status: integer;
begin
  bookView := GetBookView(self);

  Handled := true;
  cmd := SRC;
  autoCmd := Pos(C__bqAutoBible, cmd) <> 0;
  if autoCmd then
  begin
    bible := bookView.BookTabInfo.Bible;
    if bible.isBible then
      prefBible := bible.ShortPath
    else
      prefBible := '';
    status := bookView.PreProcessAutoCommand(cmd, prefBible, ConcreteCmd);
    if status <= -2 then
      Exit;
  end;
  if not IsDown(VK_CONTROL) then
  begin
    if autoCmd then
      G_XRefVerseCmd := ConcreteCmd
    else
      G_XRefVerseCmd := SRC;
    miOpenNewViewClick(Sender);
  end
  else
  begin
    if autoCmd then
      bookView.ProcessCommand(ConcreteCmd, hlDefault)
    else
    begin
      bookView.tedtReference.Text := cmd;
      GoReference();
    end;
  end;
end;

procedure TMainForm.bwrStrongMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  num, code: integer;
begin
  Val(Trim(bwrStrong.SelText), num, code);

  if code = 0 then
    DisplayStrongs(num, Copy(Trim(bwrStrong.SelText), 1, 1) = '0')
  else
    DisplayDictionary(Trim(bwrStrong.SelText));
end;

procedure TMainForm.DicLBDblClick(Sender: TObject);
var
  ix: integer;
begin
  ix := DicSelectedItemIndex();
  if ix >= 0 then
    DisplayDictionary(mBqEngine.DictionaryTokens[ix]);
end;

procedure TMainForm.SplitterMoved(Sender: TObject);
begin
  vstDicList.Height := pnlDic.Height - edtDic.Height - 15;
  vstDicList.Top := edtDic.Top + 27;

  lbStrong.Height := pnlStrong.Height - edtStrong.Height - 15;
  lbStrong.Top := edtStrong.Top + 27;
end;

procedure TMainForm.edtDicKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    DisplayDictionary(edtDic.Text);
  end;
end;

procedure TMainForm.edtStrongKeyPress(Sender: TObject; var Key: Char);
var
  num, code: integer;
  hebrew: Boolean;
  stext: string;
begin
  if Key = #13 then
  begin
    Key := #0;

    stext := Trim(edtStrong.Text);

    if Copy(stext, 1, 1) = '0' then
      hebrew := true
    else if Copy(stext, 1, 1) = 'H' then
    begin
      hebrew := true;
      stext := Copy(stext, 2, Length(stext) - 1);
    end
    else if Copy(stext, 1, 1) = 'G' then
    begin
      hebrew := false;
      stext := Copy(stext, 2, Length(stext) - 1);
    end
    else
      hebrew := false;

    try
      Val(Trim(stext), num, code);
    finally
    end;

    if code = 0 then
      DisplayStrongs(num, hebrew)
  end;
end;

procedure TMainForm.WMQueryEndSession(var Message: TWMQueryEndSession);
begin
  inherited;
  writeln(NowDateTimeString(), ': Close Query-WMQueryEndSession');
  Flush(Output);
  MainForm.Close();
  Message.Result := 1;
end;

procedure TMainForm.TagAdded(tagId: int64; const txt: string; Show: Boolean);
var
  vnd: TVersesNodeData;
  pvn: PVirtualNode;
begin
  vnd := TVersesNodeData.Create(tagId, txt, bqvntTag);
  mBqEngine.VersesTagsList.Add(vnd);
  pvn := vdtTagsVerses.InsertNode(nil, amAddChildLast, vnd);
  vnd.Parents := TObjectList(pvn);
  vdtTagsVerses.Sort(nil, -1, sdAscending);

  if Show then
  begin
    vdtTagsVerses.FullyVisible[pvn] := true;
    vdtTagsVerses.Selected[pvn] := true;
    vdtTagsVerses.ScrollIntoView(pvn, false);
  end;
end;

procedure TMainForm.TagDeleted(id: int64; const txt: string);
var
  vnd: TVersesNodeData;
  pvn: PVirtualNode;
begin
  vnd := mBqEngine.VersesTagsList.FindTagItem(txt);

  if (not Assigned(vnd)) or (not Assigned(vnd.Parents)) then
  begin
    MessageBeep(MB_ICONERROR);
    Exit;
  end;
  pvn := PVirtualNode(vnd.Parents);
  vdtTagsVerses.DeleteNode(pvn);
end;

procedure TMainForm.TagFilterTimerProc(Sender: TObject);
begin
  GetTagFilterTimer().Enabled := false;
  FilterTags(cbTagsFilter.Text);
end;

procedure TMainForm.TagRenamed(tagId: int64; const newTxt: string);
var
  vnd: TVersesNodeData;
  pvn: PVirtualNode;
  ix: integer;
begin
  ix := TVersesNodeData.FindNodeById(mBqEngine.VersesTagsList, tagId, bqvntTag, vnd);
  if ix < 0 then
    Exit;
  vnd.cachedTxt := newTxt;
  pvn := PVirtualNode(vnd.Parents);
  vdtTagsVerses.InvalidateNode(pvn);
end;

procedure TMainForm.FormActivate(Sender: TObject);
var
  ctrlIsDown: Boolean;
begin
  ctrlIsDown := IsDown(VK_CONTROL);
  if ctrlIsDown = G_ControlKeyDown then
    Exit;
  G_ControlKeyDown := ctrlIsDown;
  SetBibleTabsHintsState(ctrlIsDown);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := true;
end;

procedure TMainForm.FormDeactivate(Sender: TObject);
begin
  if G_ControlKeyDown then
  begin
    SetBibleTabsHintsState(false);
    G_ControlKeyDown := false;
  end
end;

procedure TMainForm.tbtnAddTagClick(Sender: TObject);
var
  dummyTag: int64;
begin
  InputForm.tag := 0; // use TEdit
  InputForm.Caption := 'Тег';
  InputForm.edtValue.SelectAll();
  InputForm.Font := MainForm.Font;

  if InputForm.ShowModal <> mrOk then
    Exit;
  if not mTaggedBookmarksLoaded then
    LoadTaggedBookMarks();
  TagsDb.TagsDbEngine.AddTag(InputForm.edtValue.Text, dummyTag);
end;

procedure TMainForm.tbtnDelNodeClick(Sender: TObject);
var
  pvn: PVirtualNode;
  vnd, vndParent: TVersesNodeData;
  del_ix: integer;
begin
  pvn := vdtTagsVerses.GetFirstSelected();

  if not Assigned(pvn) then
    Exit;

  vnd := TVersesNodeData(vdtTagsVerses.GetNodeData(pvn)^);
  if vnd.nodeType = bqvntTag then
  begin
    TagsDb.TagsDbEngine.DeleteTag(vnd.getText(), vnd.SelfId, true);
    del_ix := mBqEngine.VersesTagsList.IndexOf(vnd);
    vdtTagsVerses.DeleteNode(pvn);
    if del_ix >= 0 then
    begin
      mBqEngine.VersesTagsList.Delete(del_ix);
    end;

  end
  else if vnd.nodeType = bqvntVerse then
  begin
    pvn := vdtTagsVerses.NodeParent[pvn];
    if not Assigned(pvn) then
      Exit;
    vndParent := TVersesNodeData(vdtTagsVerses.GetNodeData(pvn)^);
    if vndParent.nodeType <> bqvntTag then
      Exit;
      TagsDb.TagsDbEngine.DeleteVerseFromTag(vnd.SelfId,
      vndParent.getText(), false);
  end;

end;

procedure TMainForm.tbtnLibClick(Sender: TObject);
begin
  ShowQNav();
end;

procedure TMainForm.tbtnResolveLinksClick(Sender: TObject);
begin
  miRecognizeBibleLinks.Click();
end;

procedure TMainForm.tbtnToggleClick(Sender: TObject);
begin
  pgcMain.Visible := not pgcMain.Visible;
end;

procedure TMainForm.cbModulesChange(Sender: TObject);
begin
  if Copy(cbModules.Items[cbModules.ItemIndex], 1, 1) <> #151 then
    GoModuleName(cbModules.Items[cbModules.ItemIndex]);
end;

procedure TMainForm.cbModulesCloseUp(Sender: TObject);
begin
  try
    MainForm.FocusControl(mTabsView.Browser);
  except
  end;
end;

procedure TMainForm.lbStrongDblClick(Sender: TObject);
var
  num, code: integer;
  hebrew: Boolean;
  stext: string;
begin

  if lbStrong.ItemIndex <> -1 then
  begin

    stext := Trim(lbStrong.Items[lbStrong.ItemIndex]);

    if Copy(stext, 1, 1) = '0' then
      hebrew := true
    else if Copy(stext, 1, 1) = 'H' then
    begin
      hebrew := true;
      stext := Copy(stext, 2, Length(stext) - 1);
    end
    else if Copy(stext, 1, 1) = 'G' then
    begin
      hebrew := false;
      stext := Copy(stext, 2, Length(stext) - 1);
    end
    else
      hebrew := false;

    try
      Val(Trim(stext), num, code);
    finally
    end;

    if code = 0 then
      DisplayStrongs(num, hebrew);

  end;
end;

procedure TMainForm.miAboutClick(Sender: TObject);
begin
  if not Assigned(AboutForm) then
    AboutForm := TAboutForm.Create(self);
  AboutForm.ShowModal();
end;

procedure TMainForm.bwrSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_NEXT) and (bwrSearch.Position = SearchBrowserPosition) then
    DisplaySearchResults(SearchPage + 1);

  if (Key = VK_PRIOR) and (bwrSearch.Position = SearchBrowserPosition) then
  begin
    if SearchPage = 1 then
      Exit;
    DisplaySearchResults(SearchPage - 1);
    bwrSearch.PositionTo('endofsearchresults');
  end;
end;

procedure TMainForm.bwrSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  SearchBrowserPosition := bwrSearch.Position;
end;

function TMainForm.DictionaryStartup(maxAdd: integer = maxInt): Boolean;
var
  wordCount, i: integer;
  pvn: PVirtualNode;
  tokens: TBQStringList;
begin
  Result := false;

  vstDicList.BeginUpdate();

  try
    tokens := mBqEngine.DictionaryTokens;
    wordCount := tokens.Count - 1;
    vstDicList.Clear();

    for i := 0 to wordCount do
    begin
      pvn := vstDicList.InsertNode(nil, amAddChildLast, Pointer(i));
      tokens.Objects[i] := TObject(pvn);
    end; // for

  finally
    vstDicList.EndUpdate();
  end;

end;

procedure TMainForm.edtDicKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //
end;

procedure TMainForm.AppOnHintHandler(Sender: TObject);
begin
  //
end;

procedure TMainForm.appEventsException(Sender: TObject; E: Exception);
begin
  BqShowException(E);
end;

procedure TMainForm.DicLBKeyPress(Sender: TObject; var Key: Char);
var
  ix: integer;
begin
  ix := DicSelectedItemIndex();
  if (Key = #13) and (ix >= 0) then
    DisplayDictionary(mBqEngine.DictionaryTokens[ix]);
end;

function TMainForm.DicScrollNode(nd: PVirtualNode): Boolean;
var
  R: TRect;
begin
  Result := false;
  if not Assigned(nd) then
    Exit;
  R := vstDicList.GetDisplayRect(nd, -1, false);

  if (R.Top >= 0) and (R.Bottom <= vstDicList.ClientHeight) then
    Exit;
  Result := vstDicList.ScrollIntoView(nd, true);
end;

function TMainForm.DicSelectedItemIndex: integer;
var
  pn: PVirtualNode;
begin
  Result := DicSelectedItemIndex(pn);
end;

procedure TMainForm.GoReference();
  var
  book, chapter, fromverse, toverse: integer;
  linktxt: string;
  Links: TStrings;
  i, fc: integer;
  openSuccess: Boolean;
  modName, modPath: string;
  moduleEntry: TModuleEntry;
  bookView: TBookFrame;
  bible: TBible;
label lblTail;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  if Trim(bookView.tedtReference.Text) = '' then
    Exit;

  bible := bookView.BookTabInfo.Bible;

  linktxt := bookView.tedtReference.Text;
  StrReplace(linktxt, '(', '', true);
  StrReplace(linktxt, ')', '', true);
  StrReplace(linktxt, '[', '', true);
  StrReplace(linktxt, ']', '', true);
  StrReplace(linktxt, '!', '', true);

  Links := TStringList.Create;
  try
    StrToLinks(linktxt, Links);

    if Links.Count <= 0 then
    begin
      MessageBeep(MB_ICONERROR);
      goto lblTail
    end
    else if Links.Count > 1 then
    begin

      cbLinks.Items.Clear;
      for i := 0 to Links.Count - 1 do
        cbLinks.Items.Add(Links[i]);
      cbLinks.ItemIndex := 0;
    end;

    tbLinksToolBar.Visible := (Links.Count > 1);
    bookView.tedtReference.Text := Links[0];
    openSuccess := bible.OpenReference(bookView.tedtReference.Text, book, chapter, fromverse, toverse);

    if not openSuccess then
    begin
      fc := mFavorites.mModuleEntries.Count - 1;

      if not Assigned(tempBook) then
        tempBook := TBible.Create(self);

      for i := 0 to fc do
      begin
        try
          tempBook.inifile :=
            MainFileExists(TModuleEntry(mFavorites.mModuleEntries[i]).mShortPath + '\bibleqt.ini');

          openSuccess := tempBook.OpenReference(bookView.tedtReference.Text, book, chapter, fromverse, toverse);

          if openSuccess then
          begin
            bible.inifile := tempBook.inifile;
            break;
          end;
        except
        end;

      end;
      if not openSuccess then
      begin
        moduleEntry := mModules.ModTypedAsFirst(modtypeBible);
        while Assigned(moduleEntry) do
        begin
          try

            modName := moduleEntry.mFullName;

            modPath := moduleEntry.mShortPath;
            tempBook.inifile := MainFileExists(TPath.Combine(modPath, 'bibleqt.ini'));
            openSuccess := tempBook.OpenReference(bookView.tedtReference.Text, book, chapter, fromverse, toverse);
            if openSuccess then
            begin
              bible.inifile := tempBook.inifile;
              break;
            end;
          except
          end;
          moduleEntry := mModules.ModTypedAsNext(modtypeBible);
        end;

      end;
    end;
    if openSuccess then
      bookView.SafeProcessCommand(Format('go %s %d %d %d %d', [bible.ShortPath, book, chapter, fromverse, toverse]), hlDefault)
    else
      bookView.SafeProcessCommand(bookView.tedtReference.Text, hlDefault);
  lblTail:
  finally
    Links.Free;
  end;
end;

procedure TMainForm.ShowReferenceInfo;
var
  Lines: string;
  cc: Integer;
  i: Integer;
  bookView: TBookFrame;
  bible: TBible;
begin
  Lines := '<body bgcolor=#EBE8E2>';
  bookView := GetBookView(self);
  bible := bookView.BookTabInfo.Bible;

  AddLine(Lines, '<h2>' + bible.Name + '</h2>');
  cc := bible.Categories.Count - 1;

  if cc >= 0 then
  begin
    AddLine(Lines, '<font Size=-1><b>Метки:</b><br><i>' + TokensToStr(bible.Categories, '<br>     ', false) + '</i></font><br>');
  end;

  AddLine(Lines, '<b>Location:</b> ' + Copy(bible.path, 1, Length(bible.path) - 1) + ' <a href="editini=' + bible.path + 'bibleqt.ini">ini</a><br>');

  for i := 1 to bible.BookQty do
    AddLine(Lines, '<b>' + bible.FullNames[i] + ':</b> ' + bible.ShortNamesVars[i] + '<br>');
  AddLine(Lines, '<br><br><br>');

  if not Assigned(CopyrightForm) then
    CopyrightForm := TCopyrightForm.Create(self);
  CopyrightForm.lblModName.Caption := bible.Name;

  if Length(Trim(bible.Copyright)) = 0 then
    CopyrightForm.lblCopyRightNotice.Caption := Lang.Say('PublicDomainText')
  else
    CopyrightForm.lblCopyRightNotice.Caption := bible.Copyright;

  CopyrightForm.Caption := bible.Name;
  CopyrightForm.bwrCopyright.LoadFromString(Lines);
  CopyrightForm.ActiveControl := CopyrightForm.bwrCopyright;
  CopyrightForm.ShowModal;
end;

procedure TMainForm.TranslateControl(form: TWinControl; fname: string = '');
begin
  try
    if Assigned(form) then
      Lang.TranslateControl(form, fname);
  except
    on E: Exception do
    begin
      // Failed to translate exception form
      // Suppress the exception
    end;
  end;
end;

function TMainForm.ApplyInitialTranslation(): Boolean;
var
  foundmenu: Boolean;
  i: Integer;
  locDirectory: string;
  locFilePath: string;
  translated: Boolean;
begin
  translated := false;

  locDirectory := GetLocalizationDirectory();
  locFilePath := TPath.Combine(locDirectory, LastLanguageFile);

  if (LastLanguageFile <> '') and (TFile.Exists(locFilePath)) then
    translated := TranslateInterface(LastLanguageFile);

  if (not translated) then
  begin
    foundmenu := false;
    for i := 0 to miLanguage.Count - 1 do
    begin
      if (miLanguage.Items[i]).Caption = DefaultLanguage then
      begin
        foundmenu := true;
        break;
      end;
    end;

    if foundmenu then
    begin
      translated := TranslateInterface(DefaultLanguageFile);
    end;

    if (not translated) and (miLanguage.Count > 0) then
    begin
      LastLanguageFile := miLanguage.Items[miLanguage.Count - 1].Caption + '.lng';

      translated := TranslateInterface(LastLanguageFile);
    end;

  end;

  result := translated;

end;

function TMainForm.GetLocalizationDirectory(): string;
begin
  result := TPath.Combine(ExePath, 'Localization');
end;

procedure TMainForm.FillLanguageMenu;
var
  F: TSearchRec;
  mi: TMenuItem;
  locDirectory, langPattern: string;
begin
  locDirectory := GetLocalizationDirectory;
  langPattern := TPath.Combine(locDirectory, '*.lng');

  if FindFirst(langPattern, faAnyFile, F) = 0 then
  begin
    repeat
      mi := TMenuItem.Create(self);
      mi.Caption := UpperCaseFirstLetter(Copy(F.Name, 1, Length(F.Name) - 4));
      mi.OnClick := LanguageMenuClick;
      miLanguage.Add(mi);
    until FindNext(F) <> 0;
    FindClose(F);
  end;
end;

procedure TMainForm.TranslateConfigForm;
begin
  if Assigned(ConfigForm) then
  begin
    Lang.TranslateControl(ConfigForm);
    ConfigForm.chkCopyVerseNumbers.Checked := CopyOptionsCopyVerseNumbersChecked;
    ConfigForm.chkCopyFontParams.Checked := CopyOptionsCopyFontParamsChecked;
    ConfigForm.chkAddReference.Checked := CopyOptionsAddReferenceChecked;
    ConfigForm.rgAddReference.ItemIndex := CopyOptionsAddReferenceRadioItemIndex;
    ConfigForm.chkAddLineBreaks.Checked := CopyOptionsAddLineBreaksChecked;
    ConfigForm.chkAddModuleName.Checked := CopyOptionsAddModuleNameChecked;
    ConfigForm.rgAddReference.Items[0] := Lang.Say('CopyOptionsAddReference_ShortAtBeginning');
    ConfigForm.rgAddReference.Items[1] := Lang.Say('CopyOptionsAddReference_ShortAtEnd');
    ConfigForm.rgAddReference.Items[2] := Lang.Say('CopyOptionsAddReference_FullAtEnd');
    ConfigForm.tsFavouriteEx.Caption := Lang.SayDefault('ConfigForm.tsFavouriteEx.Caption', 'Любимые модули');
    ConfigForm.lblAvailableModules.Caption := Lang.SayDefault('ConfigForm.lblAvailableModules.Caption', 'Модули');
    ConfigForm.lblFavourites.Caption := Lang.SayDefault('ConfigForm.lblFavourites.Caption', 'Избранные модули');
  end;
end;

function TMainForm.DicSelectedItemIndex(out pn: PVirtualNode): integer;

begin
  Result := -1;
  pn := nil;
  pn := vstDicList.GetFirstSelected();
  if not Assigned(pn) then
    Exit;
  Result := integer(vstDicList.GetNodeData(pn)^);
end;

procedure TMainForm.bwrDicMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  DisplayDictionary(Trim(bwrDic.SelText));
end;

procedure TMainForm.bwrXRefHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  bookView: TBookFrame;
  ti: TBookTabInfo;
  wsrc, satBible: string;
begin
  bookView := GetBookView(self);
  wsrc := SRC;
  if IsDown(VK_MENU) then
  begin
    ti := bookView.BookTabInfo;
    if Assigned(ti) then
      satBible := ti.SatelliteName
    else
      satBible := '------';

    NewBookTab(wsrc, satBible, mTabsView.Browser.Base, ti.State, '', true)

  end
  else
    bookView.ProcessCommand(wsrc, hlDefault);

  Handled := true;
end;

procedure TMainForm.miRefPrintClick(Sender: TObject);
begin
  with PrintDialog do
    if Execute then
      (pmRef.PopupComponent as THTMLViewer).Print(MinPage, MaxPage)
end;

procedure TMainForm.miRecognizeBibleLinksClick(Sender: TObject);
var
  nV: Boolean;
  vti: TBookTabInfo;
  bookView: TBookFrame;
  imageIx, browserpos: integer;
begin
  nV := miRecognizeBibleLinks.Checked;
  bookView := GetBookView(self);
  vti := bookView.BookTabInfo;
  vti[vtisResolveLinks] := nV;

  if nV then
  begin
    if vti[vtisFuzzyResolveLinks] then
      imageIx := 13
    else
      imageIx := 11;
  end
  else
    imageIx := 12;

  tbtnResolveLinks.ImageIndex := imageIx;

  if (vti.Bible.RecognizeBibleLinks <> nV) or (vti[vtisPendingReload]) then
  begin
    browserpos := mTabsView.Browser.Position;
    vti.Bible.FuzzyResolve := vti[vtisFuzzyResolveLinks];
    vti.Bible.RecognizeBibleLinks := nV;
    bookView.SafeProcessCommand(vti.Location, TbqHLVerseOption(ord(vti[vtisHighLightVerses])));
    vti[vtisPendingReload] := false;
    mTabsView.Browser.Position := browserpos;
  end;

end;

procedure TMainForm.miRefCopyClick(Sender: TObject);
var
  trCount: integer;
begin
  trCount := 7;
  repeat
    try
      if not(CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then
        Clipboard.AsText := (pmRef.PopupComponent as THTMLViewer).SelText
      else
        (pmRef.PopupComponent as THTMLViewer).CopyToClipboard();
      trCount := 0;
    except
      Dec(trCount);
      sleep(100);
    end;
  until trCount <= 0;
end;

procedure TMainForm.tbtnMemoOpenClick(Sender: TObject);
begin
  OpenDialog.Filter := 'RTF (*.rtf)|*.rtf|DOC (*.doc)|*.doc|*.*|*.*';
  OpenDialog.FileName := MemoFilename;
  if OpenDialog.Execute then
  begin
    reMemo.Lines.LoadFromFile(OpenDialog.FileName);
    reMemo.tag := 0; // not changed

    MemoFilename := OpenDialog.FileName;
    lblMemo.Caption := ExtractFileName(MemoFilename);
  end;
end;

procedure TMainForm.tbtnMemoSaveClick(Sender: TObject);
var
  i: integer;
begin
  SaveFileDialog.DefaultExt := '.rtf';
  SaveFileDialog.Filter := 'RTF (*.rtf)|*.rtf|DOC (*.doc)|*.doc|*.*|*.*';
  SaveFileDialog.FileName := MemoFilename;
  if SaveFileDialog.Execute then
  begin
    MemoFilename := SaveFileDialog.FileName;
    i := Length(MemoFilename);

    if (SaveFileDialog.FilterIndex = 1) and
      (WideLowerCase(Copy(MemoFilename, i - 3, 4)) <> '.rtf') then
      MemoFilename := MemoFilename + '.rtf';
    if (SaveFileDialog.FilterIndex = 2) and
      (WideLowerCase(Copy(MemoFilename, i - 3, 4)) <> '.doc') then
      MemoFilename := MemoFilename + '.doc';

    reMemo.Lines.SaveToFile(MemoFilename, TEncoding.UTF8);
    reMemo.tag := 0; // not changed

    lblMemo.Caption := ExtractFileName(MemoFilename);
  end;
end;

procedure TMainForm.tbtnMemoBoldClick(Sender: TObject);
begin
  if fsBold in reMemo.SelAttributes.Style then
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style - [fsBold]
  else
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style + [fsBold];
end;

procedure TMainForm.tbtnMemoItalicClick(Sender: TObject);
begin
  if fsItalic in reMemo.SelAttributes.Style then
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style - [fsItalic]
  else
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style + [fsItalic];
end;

procedure TMainForm.tbtnMemoUnderlineClick(Sender: TObject);
begin
  if fsUnderline in reMemo.SelAttributes.Style then
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style - [fsUnderline]
  else
    reMemo.SelAttributes.Style := reMemo.SelAttributes.Style + [fsUnderline];
end;

procedure TMainForm.tbtnNewFormClick(Sender: TObject);
var
  tabsForm: TDockTabsForm;
  bookView: TBookFrame;
  bookTabInfo: TBookTabInfo;
  I: Integer;
begin
  bookView := GetBookView(self);
  bookTabInfo := bookView.BookTabInfo;

  tabsForm := CreateTabsView(GenerateTabsViewName()) as TDockTabsForm;

  tabsForm.BibleTabs.Tabs.Clear();
  tabsForm.BibleTabs.Tabs.Add('***');
  for I := 0 to mFavorites.mModuleEntries.Count - 1 do
  begin
    tabsForm.BibleTabs.Tabs.Insert(I, mFavorites.mModuleEntries[I].VisualSignature());
    tabsForm.BibleTabs.Tabs.Objects[I] := mFavorites.mModuleEntries[I];
  end;

  tabsForm.ManualDock(pnlModules);
  tabsForm.Show;
  mTabsView := tabsForm;

  Windows.SetFocus(tabsForm.Handle);

  if (bookTabInfo <> nil) then
  begin
    NewBookTab(bookTabInfo.Location, bookTabInfo.SatelliteName, '', bookTabInfo.State, '', true);
  end;
end;

procedure TMainForm.tbtnMemoFontClick(Sender: TObject);
begin
  with reMemo.SelAttributes do
  begin
    FontDialog.Font.Name := Name;
    FontDialog.Font.CharSet := CharSet;
    FontDialog.Font.Size := Size;
    FontDialog.Font.Style := Style;
    FontDialog.Font.color := color;
  end;

  if FontDialog.Execute then
    with reMemo.SelAttributes do
    begin
      Name := FontDialog.Font.Name;
      CharSet := FontDialog.Font.CharSet;
      Size := FontDialog.Font.Size;
      Style := FontDialog.Font.Style;
      color := FontDialog.Font.color;
    end;
end;

procedure TMainForm.reMemoChange(Sender: TObject);
begin
  reMemo.tag := 1;
end;

procedure TMainForm.UpdateAllBooks;
var
  moduleEntry: TModuleEntry;
  bookView: TBookFrame;
  bible: TBible;
begin

  cbModules.Items.BeginUpdate;
  try
    cbModules.Items.Clear;

    cbModules.Items.Add('——— ' + Lang.Say('StrBibleTranslations') + ' ———');
    moduleEntry := mModules.ModTypedAsFirst(modtypeBible);
    while Assigned(moduleEntry) do
    begin
      cbModules.Items.Add(moduleEntry.mFullName);
      moduleEntry := mModules.ModTypedAsNext(modtypeBible);
    end;
    cbModules.Items.Add('——— ' + Lang.Say('StrBooks') + ' ———');
    moduleEntry := mModules.ModTypedAsFirst(modtypeBook);

    while Assigned(moduleEntry) do
    begin
      cbModules.Items.Add(moduleEntry.mFullName);
      moduleEntry := mModules.ModTypedAsNext(modtypeBook);
    end;

    cbModules.Items.Add('——— ' + Lang.Say('StrCommentaries') + ' ———');
    moduleEntry := mModules.ModTypedAsFirst(modtypeComment);
    while Assigned(moduleEntry) do
    begin
      cbModules.Items.Add(moduleEntry.mFullName);
      moduleEntry := mModules.ModTypedAsNext(modtypeComment);
    end;

    bookView := GetBookView(self);
    if Assigned(bookView) and (bookView.BookTabInfo <> nil) then
    begin
      bible := bookView.BookTabInfo.Bible;
      if Assigned(bible) and (bible.Name <> '') then
        cbModules.ItemIndex := cbModules.Items.IndexOf(bible.Name);
    end;
  finally
    cbModules.Items.EndUpdate;
  end;

  cbComments.Items.BeginUpdate;
  try
    cbComments.Items.Clear;
    moduleEntry := mModules.ModTypedAsFirst(modtypeComment);
    while Assigned(moduleEntry) do
    begin
      cbComments.Items.Add(moduleEntry.mFullName);
      moduleEntry := mModules.ModTypedAsNext(modtypeComment);
    end;

  finally
    cbComments.Items.EndUpdate;
  end;

  cbComments.ItemIndex := 0;
end;

procedure TMainForm.UpdateDictionariesCombo;
var
  dicCount, dicIx: integer;
begin
  cbDicFilter.Items.BeginUpdate;
  try
    cbDicFilter.Items.Clear;
    cbDicFilter.Items.Add(Lang.Say('StrAllDictionaries'));
    dicCount := mBqEngine.DictionariesCount - 1;
    for dicIx := 0 to dicCount do
      cbDicFilter.Items.Add(mBqEngine.Dictionaries[dicIx].Name);

    cbDicFilter.ItemIndex := 0;
  finally
    cbDicFilter.Items.EndUpdate;
  end;
end;

function TMainForm.UpdateFromCashed(): Boolean;
var
  bookView: TBookFrame;
  bookTabInfo: TBookTabInfo;
begin
  try
    if not Assigned(mModules) then
      mModules := TCachedModules.Create(true);
    mModules.Assign(mModuleLoader.CachedModules);

    if Assigned(MyLibraryForm) then
    begin
      bookView := GetBookView(self);
      bookTabInfo := bookView.BookTabInfo;
      if MyLibraryForm.mUseDisposition = udMyLibrary then
        MyLibraryForm.UpdateList(mModules, -1, bookTabInfo.Bible.Name)
      else
        MyLibraryForm.UpdateList(mModules, -1, bookTabInfo.SecondBible.Name);
    end;

    Result := true;
    mDefaultLocation := DefaultLocation();
  except
    Result := false;
  end;
end;

procedure TMainForm.UpdateUI();
var
  tabInfo: TBookTabInfo;
  i: integer;
  bookView: TBookFrame;
begin
  mInterfaceLock := true;
  mScrollAcc := 0;
  try
    bookView := GetBookView(self);
    tabInfo := bookView.BookTabInfo;
    if not Assigned(tabInfo) then
      Exit;

    bookView.AdjustBibleTabs(tabInfo.Bible.ShortName);
    StrongNumbersOn := tabInfo[vtisShowStrongs];
    miStrong.Checked := tabInfo[vtisShowStrongs];
    bookView.tbtnStrongNumbers.Down := tabInfo[vtisShowStrongs];
    tbtnSatellite.Down := (Length(tabInfo.SatelliteName) > 0) and (tabInfo.SatelliteName <> '------');

    bookView.tbtnStrongNumbers.Enabled := tabInfo.Bible.Trait[bqmtStrongs];
    MemosOn := tabInfo[vtisShowNotes];
    bookView.miMemosToggle.Checked := MemosOn;

    if tabInfo[vtisResolveLinks] then
    begin
      if tabInfo[vtisFuzzyResolveLinks] then
        i := 13
      else
        i := 11;
    end
    else
      i := 12;

    tbtnResolveLinks.ImageIndex := i;

    miRecognizeBibleLinks.Checked := tabInfo[vtisResolveLinks];

    bookView.tbtnMemos.Down := MemosOn;

    if not tabInfo.Bible.isBible then
    begin
      cbList.Style := csDropDownList;
      try
        bookView.LoadSecondBookByName(tabInfo.SatelliteName);
      except
        on E: Exception do
          BqShowException(E);
      end;
    end
    else
      cbList.Style := csDropDown;

    with cbModules do
    begin
      ItemIndex := Items.IndexOf(tabInfo.Bible.Name);
    end;
    UpdateBooksAndChaptersBoxes(tabInfo.Bible); // fill lists
    SearchListInit();

    lblTitle.Font.Name := tabInfo.TitleFont;
    lblTitle.Caption := tabInfo.TitleLocation;
    lblCopyRightNotice.Caption := tabInfo.CopyrightNotice;

    if tabInfo[vtisPendingReload] then
    begin
      tabInfo[vtisPendingReload] := false;
      bookView.SafeProcessCommand(tabInfo.Location, TbqHLVerseOption(ord(tabInfo[vtisHighLightVerses])));
    end;
    if (tabInfo.LocationType = vtlModule) and Assigned(tabInfo.Bible) and (tabInfo.Bible.isBible) then
      Caption := tabInfo.Bible.Name + ' — BibleQuote';
  finally
    mInterfaceLock := false;
  end;
end;

procedure TMainForm.vstDicListAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  //
end;

procedure TMainForm.vstDicListGetText(
  Sender: TBaseVirtualTree;
  Node: PVirtualNode;
  Column: TColumnIndex;
  TextType: TVSTTextType;
  var CellText: string);
var
  ix: integer;
begin
  if not Assigned(Node) then
    Exit;
  try
    ix := integer(Sender.GetNodeData(Node)^);
    CellText := mBqEngine.DictionaryTokens[ix];
  except
    on E: Exception do
    begin
      BqShowException(E)
    end
  end;
end;

procedure TMainForm.VerseAdded(verseId, tagId: int64; const cmd: string;
  Show: Boolean);
var
  ix: integer;
  vnd, vnd_verse: TVersesNodeData;
  pvnTag, pvnVerse: PVirtualNode;

begin
  ix := TVersesNodeData.FindNodeById(mBqEngine.VersesTagsList, tagId, bqvntTag, vnd);
  if ix < 0 then
    Exit;
  pvnTag := PVirtualNode(vnd.Parents);
  if not Assigned(pvnTag) then
    Exit;
  if TVersesNodeData.FindNodeById(mBqEngine.VersesTagsList, verseId, bqvntVerse, vnd_verse) < 0 then
  begin
    vnd_verse := TVersesNodeData.Create(verseId, '', bqvntVerse);
    vnd_verse.Parents.Add(vnd);
    mBqEngine.VersesTagsList.Add(vnd_verse);
  end
  else
  begin
    if vnd_verse.Parents.IndexOf(vnd) < 0 then
      vnd_verse.Parents.Add(vnd);
  end;
  pvnVerse := vdtTagsVerses.InsertNode(pvnTag, amAddChildLast, vnd_verse);
  vdtTagsVerses.Sort(pvnTag, -1, sdAscending);
  if Show then
  begin
    vdtTagsVerses.FullyVisible[pvnVerse] := true;
    vdtTagsVerses.Selected[pvnVerse] := true;
    vdtTagsVerses.ScrollIntoView(pvnVerse, false);
  end;
end;

procedure TMainForm.VerseDeleted(verseId, tagId: int64);
var
  ix, tagIx: integer;
  vnd, tag_vnd, vnd2: TVersesNodeData;
  pvnVerse: PVirtualNode;
  fndNode: Boolean;
begin
  ix := TVersesNodeData.FindNodeById(mBqEngine.VersesTagsList, verseId, bqvntVerse, vnd);

  if ix < 0 then
    Exit;

  if vnd.nodeType <> bqvntVerse then
    raise Exception.Create('Invalid data(nodetype ) in VerseDeleted!');
  tagIx := TVersesNodeData.FindNodeById(vnd.Parents, tagId, bqvntTag, tag_vnd);
  if tagIx >= 0 then
  begin
    vnd.Parents.Remove(tag_vnd);
  end
  else
    raise Exception.Create('corrupt mBqEngine.VersesTagsList cache!');
  pvnVerse := vdtTagsVerses.GetFirstChild(PVirtualNode(tag_vnd.Parents));
  fndNode := false;
  while pvnVerse <> nil do
  begin
    vnd2 := TVersesNodeData(vdtTagsVerses.GetNodeData(pvnVerse)^);
    if vnd2 = vnd then
    begin
      fndNode := true;
      break;
    end;
    pvnVerse := vdtTagsVerses.GetNextSibling(pvnVerse);
  end;
  if fndNode then
  begin
    vdtTagsVerses.DeleteNode(pvnVerse);
    if (vnd.Parents.Count <= 0) then
    begin
      mBqEngine.VersesTagsList.Remove(vnd);
    end;
  end;

end;

procedure TMainForm.VSCrollTracker(Sender: TObject);
var
  sectionIx, sectionCnt, sourcePos, scrollPos, BottomPos, vn, ch, ve, delta: integer;
  sct: TSectionBase;
  positionLst: TList;
  ds: string;

  bl: TBibleLink;
  path: string;
  scte: TSectionBase;
  bookView: TBookFrame;
  bookTabInfo: TBookTabInfo;
  bible: TBible;

  function find_verse(sp: integer): integer;
  var
    pfind: PChar;
    i: integer;
  begin

    Result := -1;
    pfind := searchbuf(PChar(Pointer(ds)), sourcePos - 1, sourcePos - 1, 0, '<a name="bqverse', [soMatchCase]);

    if not Assigned(pfind) then
      Exit;
    i := Length('<a name="bqverse');
    Result := 0;
    repeat
      ch := ord((pfind + i)^) - ord('0');
      if (ch < 0) or (ch > 9) then
        break;
      Result := Result * 10 + ch;
      inc(i);
    until false;
  end;

begin
  try
    vn := -1;
    ve := vn;
    scrollPos := integer(mTabsView.Browser.VScrollBar.Position);
    msbPosition := scrollPos;
    if scrollPos = 0 then
      vn := 1;

    sct := mTabsView.Browser.SectionList.FindSectionAtPosition(scrollPos, vn, ch);

    BottomPos := scrollPos + mTabsView.Browser.__PaintPanel.Height;
    scte := mTabsView.Browser.SectionList.FindSectionAtPosition(BottomPos, ve, ch);
    ds := mTabsView.Browser.DocumentSource;
    if Assigned(sct) and (sct is TSectionBase) then
    begin
      delta := sct.DrawHeight div 2;
      positionLst := mTabsView.Browser.SectionList.PositionList;
      if sct.YPosition + delta < scrollPos then
      begin
        // try to find first fully visible section
        sectionIx := positionLst.IndexOf(sct);
        sectionCnt := positionLst.Count - 1;
        repeat
          inc(sectionIx);
        until (sectionIx >= sectionCnt) or
          (TSectionBase(positionLst[sectionIx]).YPosition +
          (TSectionBase(positionLst[sectionIx]).DrawHeight div 2) > scrollPos);

        if sectionIx < sectionCnt then
          sct := TSectionBase(positionLst[sectionIx]);
      end;
      if scte.YPosition + (scte.DrawHeight div 2) > BottomPos then
      begin
        // try to find first fully visible section

        sectionIx := positionLst.IndexOf(scte);
        repeat
          Dec(sectionIx);
        until (sectionIx < 0) or (TSectionBase(positionLst[sectionIx]).YPosition
          + (TSectionBase(positionLst[sectionIx]).DrawHeight div 2) <
          BottomPos);
        if sectionIx >= 0 then
          scte := TSectionBase(positionLst[sectionIx]);
      end;

      sourcePos := sct.FindSourcePos(sct.StartCurs);
      vn := -1;
      if sourcePos >= 0 then
      begin
        vn := find_verse(sourcePos);
      end;
    end;
    if Assigned(scte) and (scte is TSectionBase) then
    begin
      sourcePos := scte.FindSourcePos(scte.StartCurs);
      ve := -1;
      if sourcePos >= 0 then
      begin
        ve := find_verse(sourcePos);
      end;
    end;

    // TSection(sct).
    bookView := GetBookView(self);
    bookTabInfo := bookView.BookTabInfo;
    bible := bookTabInfo.Bible;
    if vn > 0 then
    begin
      bookTabInfo.FirstVisiblePara := vn;
      if bl.FromBqStringLocation(bookTabInfo.Location, path) then
      begin
        bl.vstart := vn;
      end;
    end;
    if (ve > 0) and (ve >= vn) then
      bookTabInfo.LastVisiblePara := ve
    else
    begin
      bookTabInfo.LastVisiblePara := -1;
      ve := 0;
    end;
    if (vn > 0) and (ve > 0) then
      bible := bookTabInfo.Bible;
      lblTitle.Caption := bible.ShortName + ' ' + bible.FullPassageSignature(bible.CurBook, bible.CurChapter, vn, ve);

  except
    on E: EAccessViolation do
    begin
      BqShowException(E);
    end
  end;
end;

procedure TMainForm.vdtModulesAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  OpenChapter();
end;

procedure TMainForm.vdtModulesFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PBookNodeData;
begin
  Data := Sender.GetNodeData(Node);
  // Explicitely free the string, the VCL cannot know that there is one but needs to free
  // it nonetheless. For more fields in such a record which must be freed use Finalize(Data^) instead touching
  // every member individually.
  Finalize(Data^);
end;

procedure TMainForm.vdtModulesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PBookNodeData;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    CellText := Data.Caption;
end;

procedure TMainForm.vdtModulesInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var
  Level: Integer;
  bible: TBible;
begin
  Level := Sender.GetNodeLevel(Node);
  bible := GetBookView(self).BookTabInfo.Bible;
  ChildCount := IfThen(Level = 0, bible.ChapterQtys[Node.Index + 1], 0);
end;

procedure TMainForm.vdtModulesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PBookNodeData;
  Level: Integer;
  chapterIndex: integer;
  chapterString: string;
  bible: TBible;
  bookView: TBookFrame;
begin
  with Sender do
  begin
    Level := GetNodeLevel(Node);
    Data := GetNodeData(Node);

    if Level < 1 then
      Include(InitialStates, ivsHasChildren);

    bookView := GetBookView(self);
    bible := bookView.BookTabInfo.Bible;

    if (Level = 0) then
    begin
      Data.Caption := bible.FullNames[Node.Index + 1];
      Data.NodeType := btBook;
    end
    else
    begin
      chapterIndex := Integer(Node.Index) + IfThen(bible.Trait[bqmtZeroChapter], 0, 1);

      if (chapterIndex = 0) and (Length(Trim(bible.ChapterZeroString)) > 0) then
      begin
        chapterString := Trim(bible.ChapterZeroString);
      end
      else
      begin
        if (IsPsalms(Node.Parent.Index + 1)) then
          chapterString := Trim(bible.ChapterStringPs)
        else
          chapterString := Trim(bible.ChapterString);

        if (Length(chapterString) > 0) then
          chapterString := chapterString + ' ';

        chapterString := chapterString + IntToStr(chapterIndex);
      end;

      Data.Caption := chapterString;
      Data.NodeType := btChapter;
    end;
  end;
end;

procedure TMainForm.vdtTagsVersesCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  vnd: TVersesNodeData;
  p: Pointer;
  pvn: PVirtualNode;
begin
  p := vdtTagsVerses.GetNodeData(Node);
  if p = nil then
    Exit;
  vnd := TVersesNodeData(p^);
  if not Assigned(vnd) or (vnd.nodeType <> bqvntTag) then
    Exit;
  pvn := vdtTagsVerses.GetFirstChild(Node);
  while (pvn <> nil) do
  begin
    p := vdtTagsVerses.GetNodeData(pvn);
    if (p <> nil) then
    begin
      vnd := TVersesNodeData(p^);
      if Assigned(vnd) then
      begin
        vnd.cachedTxt := '';
      end;
    end;
    pvn := vdtTagsVerses.GetNextSibling(pvn);
  end;

end;

procedure TMainForm.vdtTagsVersesCompareNodes(
  Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode;
  Column: TColumnIndex;
  var Result: integer);
var
  vnd1, vnd2: TVersesNodeData;
  ble1, ble2: TBibleLinkEx;
begin
  try
    vnd1 := TObject(Sender.GetNodeData(Node1)^) as TVersesNodeData;
    vnd2 := TObject(Sender.GetNodeData(Node2)^) as TVersesNodeData;
    Result := ord(vnd1.nodeType) - ord(vnd2.nodeType);
    if Result <> 0 then
      Exit;
    if vnd1.nodeType = bqvntTag then
    begin
      Result := OmegaCompareTxt(vnd1.getText(), vnd2.getText, -1, true);
      Exit;
    end;
    if vnd1.nodeType = bqvntVerse then
    begin
      ble1 := vnd1.getBibleLinkEx();
      ble2 := vnd2.getBibleLinkEx();
      Result := ble1.book - ble2.book;
      if Result <> 0 then
        Exit;
      Result := ble1.chapter - ble2.chapter;
      if Result <> 0 then
        Exit;
      Result := ble1.vstart - ble2.vstart;
      if Result <> 0 then
        Exit;
      Result := ble1.vend - ble2.vend;
      Exit;
    end;

  except
  end;
end;

procedure TMainForm.vdtTagsVersesCreateEditor(
  Sender: TBaseVirtualTree;
  Node: PVirtualNode;
  Column: TColumnIndex;
  out EditLink: IVTEditLink);
begin
  EditLink := TbqVDTEditLink.Create(self);
end;

procedure TMainForm.vdtTagsVersesDblClick(Sender: TObject);
var
  vdt: TVirtualDrawTree;
  nodeTop, levelIndent: integer;
  pvn: PVirtualNode;
  nd: TVersesNodeData;
  R: TbqTagVersesContent;
  rct: TRect;
  pt: TPoint;
  ble: TBibleLinkEx;
begin
  if not(Sender is TVirtualDrawTree) then
  begin
    Exit;
  end;
  vdt := TVirtualDrawTree(Sender);
  pt := vdt.ScreenToClient(Mouse.CursorPos);
  pvn := vdt.GetNodeAt(pt.X, pt.Y, true, nodeTop);

  if not Assigned(pvn) or (pvn = vdt.RootNode) then
  begin
    Exit;
  end;

  nd := TVersesNodeData(vdt.GetNodeData(pvn)^);
  if nd.nodeType <> bqvntVerse then
    Exit;

  levelIndent := (vdt.Indent * vdt.GetNodeLevel(pvn));
  rct := Rect(0, 0, vdt.ClientWidth - levelIndent - vdt.Margin - vdt.TextMargin, 500);
  vdt.Canvas.Font := vdt.Font;

  R := GfxRenderers.TbqTagsRenderer.GetContentTypeAt
    (pt.X - vdt.Margin - levelIndent, pt.Y - nodeTop, vdt.Canvas, nd, rct);

  if R <> tvcPlainTxt then
    Exit;

  ble := nd.getBibleLinkEx();
  GetBookView(self).ProcessCommand(ble.ToCommand(), hlTrue);
end;

procedure TMainForm.vdtTagsVersesEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  nodedata: TVersesNodeData;
begin
  if Node = nil then
    Exit;
  nodedata := TObject(Sender.GetNodeData(Node)^) as TVersesNodeData;
  if (not Assigned(nodedata)) or (nodedata.nodeType <> bqvntTag) then
    Exit;
  Sender.Sort(nil, -1, sdAscending);
end;

procedure TMainForm.vdtTagsVersesEditing(
  Sender: TBaseVirtualTree;
  Node: PVirtualNode;
  Column: TColumnIndex;
  var Allowed: Boolean);
begin
  Allowed := Sender.NodeParent[Node] = nil;
end;

procedure TMainForm.vdtTagsVersesGetNodeWidth(
  Sender: TBaseVirtualTree;
  HintCanvas: TCanvas;
  Node: PVirtualNode;
  Column: TColumnIndex;
  var NodeWidth: integer);
var
  str: string;
  nd: TVersesNodeData;
  rct: TRect;
begin
  nd := TVersesNodeData((Sender.GetNodeData(Node))^);
  HintCanvas.Font := Sender.Font;
  str := Format('%s (%d)', [nd.getText(), vdtTagsVerses.ChildCount[Node]]);
  rct := Rect(0, 0, Sender.ClientWidth - mscrollbarX - vdtTagsVerses.TextMargin * 2 - 5, 40);
  NodeWidth := rct.Right;
end;

procedure TMainForm.vdtTagsVersesIncrementalSearch(
  Sender: TBaseVirtualTree;
  Node: PVirtualNode;
  const SearchText:
  string; var Result: integer);
var
  vnd: TVersesNodeData;
  posIx: integer;
begin
  Result := -1;
  if Sender.NodeParent[Node] <> nil then
    Exit;
  vnd := TVersesNodeData(Sender.GetNodeData(Node)^);
  if (vnd = nil) or (vnd.nodeType <> bqvntTag) then
    Exit;
  posIx := UpperPosCI(SearchText, vnd.getText());
  if posIx > 0 then
    Result := 0;

end;

procedure TMainForm.vdtTagsVersesInitNode(
  Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  vnd: TVersesNodeData;
  pnd: Pointer;
  searchIx: integer;
  foundCnt: Cardinal;
begin
  if (Node = nil) or (Node = Sender.RootNode) then
    Exit;
  pnd := Sender.GetNodeData(Node);

  if pnd = nil then
  begin
    Exit;
  end;
  vnd := TVersesNodeData(pnd^);
  if not Assigned(vnd) then
  begin
    // here come not initialized children =verse nodes
    pnd := Sender.GetNodeData(ParentNode);
    if pnd = nil then
      Exit;
    vnd := TVersesNodeData(pnd^);
    if not Assigned(vnd) then
      Exit;
    foundCnt := 0;
    searchIx := mBqEngine.VersesTagsList.FindItemByTagPointer(vnd, 0);
    if searchIx >= 0 then
      repeat

        if foundCnt = Node^.Index then
        begin
          TVersesNodeData(Sender.GetNodeData(Node)^) :=
            TVersesNodeData(mBqEngine.VersesTagsList[searchIx]);

          Exit; // break;
        end;
        inc(searchIx);
        inc(foundCnt);
        searchIx := mBqEngine.VersesTagsList.FindItemByTagPointer(vnd, searchIx);
      until (searchIx < 0);
    Exit;
  end;
end;

procedure TMainForm.vdtTagsVersesMeasureItem(
  Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas;
  Node: PVirtualNode;
  var NodeHeight: integer);
var
  nd: TVersesNodeData;
  rct: TRect;
  h, dlt, vmarg: integer;
  ws: string;
  right: integer;
  vdt: TVirtualDrawTree;
begin
  if (Node = nil) or (csDestroying in self.ComponentState) then
    Exit;
  if not(Sender is TVirtualDrawTree) then
    Exit;
  vdt := TVirtualDrawTree(Sender);
  try
    nd := TVersesNodeData((vdt.GetNodeData(Node))^);
    TargetCanvas.Font := vdt.Font;
    right := vdt.ClientWidth - integer(vdt.Indent * vdt.GetNodeLevel(Node));
    rct := Rect(0, 0, right, 500);

    if (nd = nil) then Exit;

    if (nd.nodeType = bqvntVerse) then
    begin
      TargetCanvas.Font := vdt.Font;
      NodeHeight := TbqTagsRenderer.RenderVerseNode(TargetCanvas, nd, true, rct);
      Exit;
    end
    else
    begin
      ws := Format('%s (%.2d)', [nd.getText(), vdtTagsVerses.ChildCount[Node]]);
      NodeHeight := TbqTagsRenderer.RenderTagNode(TargetCanvas, nd, ws, false, true, rct);
      Exit;
    end;

    if dlt < 0 then
      dlt := -dlt;
    dlt := dlt div 2;
    if dlt = 0 then
      dlt := 2;

    rct.Left := 0;
    rct.Top := 0;
    rct.Bottom := 200;
    rct.Right := vdtTagsVerses.ClientWidth - mscrollbarX - vdtTagsVerses.TextMargin * 2 - 5;

    h := DrawText(TargetCanvas.Handle, PChar(Pointer(ws)), -1, rct, DT_CALCRECT or DT_WORDBREAK);

    NodeHeight := h;
    vmarg := dlt;
    if (nd.nodeType = bqvntTag) then
    begin
      inc(vmarg, 4);
      inc(NodeHeight, vmarg);
      Exit;
    end;

    rct.Left := vdtTagsVerses.TextMargin;
    rct.Right := vdtTagsVerses.Width - GetSystemMetrics(SM_CXVSCROLL) - vdtTagsVerses.TextMargin - 2;

    dlt := TargetCanvas.Font.Height * 4 div 5;
    TargetCanvas.Font.Height := dlt;

    TargetCanvas.Font.Style := [fsUnderline];
    if dlt < 0 then
      dlt := -dlt;
    rct.Top := h + (dlt div 2);
    rct.Bottom := rct.Top + 300;

    NodeHeight := PaintTokens(TargetCanvas, rct, nd.Parents, true) + (vmarg);
  except
    // do nothing
  end;

end;

procedure TMainForm.vdtTagsVersesDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
var
  nd: TVersesNodeData;
  rct: TRect;
  dlt, flgs, rectInflateValue, rectCurveRadius: integer;
  ws, fn: string;
  TagNodeColor, TagNodeBorder, save_brushColor, savePenColor: TColor;
  vdt: TVirtualDrawTree;
begin

  if PaintInfo.Node = nil then
    Exit;

  if not(Sender is TVirtualDrawTree) then
    Exit;

  vdt := TVirtualDrawTree(Sender);
  nd := TVersesNodeData((Sender.GetNodeData(PaintInfo.Node))^);

  PaintInfo.Canvas.Font := Sender.Font;
  save_brushColor := PaintInfo.Canvas.Brush.color;
  savePenColor := PaintInfo.Canvas.Pen.color;
  if (nd.nodeType = bqvntVerse) then
  begin
    rct := PaintInfo.CellRect;

    PaintInfo.Canvas.Font := vdt.Font;
    TbqTagsRenderer.RenderVerseNode(PaintInfo.Canvas, nd, false, rct);
    PaintInfo.Canvas.Brush.color := save_brushColor;
    PaintInfo.Canvas.Pen.color := savePenColor;
    Exit;
  end
  else if (nd.nodeType = bqvntTag) then
  begin
    if not(bqvnsInitialized in nd.nodeState) then
    begin
      Sender.BeginUpdate();
      try
        TagsDb.TagsDbEngine.InitNodeChildren(nd, mBqEngine.VersesTagsList);
      finally
        Sender.EndUpdate();
      end;
    end;
    rct := PaintInfo.CellRect;
    ws := Format('%s (%.2d)', [nd.getText(), vdtTagsVerses.ChildCount[PaintInfo.Node]]);
    TbqTagsRenderer.RenderTagNode(PaintInfo.Canvas, nd, ws, Sender.Selected[PaintInfo.Node], false, rct);
    Exit;
  end;
  if not(bqvnsInitialized in nd.nodeState) then
  begin
    Sender.BeginUpdate();
    try
      TagsDb.TagsDbEngine.InitNodeChildren(nd, mBqEngine.VersesTagsList);
    finally
      Sender.EndUpdate();
    end;
  end;
  dlt := PaintInfo.Canvas.Font.Height;
  if dlt < 0 then
    dlt := -dlt;
  dlt := dlt div 4;
  if dlt = 0 then
    dlt := 1;
  if nd.nodeType = bqvntTag then
  begin
    flgs := DT_WORDBREAK or DT_VCENTER;

    TagNodeColor := $0D9EAFB;
    TagNodeBorder := $000A98ED;
    if Sender.Selected[PaintInfo.Node] then
    begin
      rectInflateValue := -1;
      TagNodeBorder := $0096C7F3;
      TagNodeColor := $0096C7F3;
    end
    else
    begin
      rectInflateValue := -2;
      inc(rct.Bottom, 1);
    end;

    InflateRect(rct, rectInflateValue, rectInflateValue);
    rectCurveRadius := TVirtualDrawTree(Sender).SelectionCurveRadius;

    PaintInfo.Canvas.Brush.color := TagNodeColor;
    PaintInfo.Canvas.Pen.color := TagNodeBorder;
    PaintInfo.Canvas.RoundRect(rct.Left, rct.Top, rct.Right, rct.Bottom, rectCurveRadius, rectCurveRadius);
    inc(rct.Left, vdt.TextMargin);
    Dec(rct.Right, vdt.TextMargin);
  end
  else
    flgs := DT_WORDBREAK;

  inc(rct.Top, dlt);
  if Length(fn) > 0 then
  begin
    PaintInfo.Canvas.Font.Name := fn;
  end;
  PaintInfo.Canvas.Font.color := clWindowText;

  Windows.DrawText(PaintInfo.Canvas.Handle, PChar(Pointer(ws)), -1, rct, flgs);
  PaintInfo.Canvas.Brush.color := save_brushColor;
  PaintInfo.Canvas.Pen.color := savePenColor;

  Exit;
end;

procedure TMainForm.vdtTagsVersesMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  vdt: TVirtualDrawTree;
  nodeTop, levelIndent: integer;
  pvn: PVirtualNode;
  nd: TVersesNodeData;
  R: TbqTagVersesContent;
  rct: TRect;
begin
  if not(Sender is TVirtualDrawTree) then
  begin
    Exit;
  end;
  vdt := TVirtualDrawTree(Sender);
  pvn := vdt.GetNodeAt(X, Y, true, nodeTop);
  if not Assigned(pvn) or (pvn = vdt.RootNode) then
  begin
    Exit;
  end;

  nd := TVersesNodeData(vdt.GetNodeData(pvn)^);
  levelIndent := (vdt.Indent * vdt.GetNodeLevel(pvn));
  rct := Rect(0, 0, vdt.ClientWidth - levelIndent - vdt.Margin - vdt.TextMargin, 500);

  vdt.Canvas.Font := vdt.Font;
  R := GfxRenderers.TbqTagsRenderer.GetContentTypeAt
    (X - vdt.Margin - levelIndent, Y - nodeTop, vdt.Canvas, nd, rct);
  case R of
    tvcLink:
      vdt.Cursor := crHandPoint;

  else
    vdt.Cursor := crDefault;
  end;

end;

procedure TMainForm.vdtTagsVersesResize(Sender: TObject);
begin
  ReCalculateTagTree();
end;

procedure TMainForm.vdtTagsVersesScroll(Sender: TBaseVirtualTree; DeltaX, DeltaY: integer);
var
  Node: PVirtualNode;
  vnd: TVersesNodeData;
begin
  Node := Sender.GetFirstVisible();
  if Node <> nil then
  begin
    vdtTagsVerses.BeginUpdate();
    try
      repeat
        if Sender.NodeParent[Node] = nil then
        begin
          vnd := TVersesNodeData(Sender.GetNodeData(Node)^);
          if vnd.nodeType = bqvntTag then
          begin
            if not(bqvnsInitialized in vnd.nodeState) then
            begin
              // VersesDb.VerseListEngine.InitNodeChildren(vnd, mBqEngine.VersesTagsList);

            end;
          end;
        end;
        Node := Sender.GetNextVisible(Node);
      until Node = nil;
    finally
      vdtTagsVerses.EndUpdate();
    end;
  end;
end;

procedure TMainForm.vdtTagsVersesShowScrollBar(Sender: TBaseVirtualTree; Bar: integer; Show: Boolean);
var
  old: integer;
begin
  if Bar = SB_VERT then
  begin
    old := mscrollbarX;
    mscrollbarX := ord(Show) * GetSystemMetrics(SM_CXVSCROLL);
    if old <> mscrollbarX then
    begin
      ReCalculateTagTree();
    end;

  end;
end;

procedure TMainForm.vdtTagsVersesStateChange(Sender: TBaseVirtualTree; Enter, Leave: TVirtualTreeStates);
begin
  //
end;

procedure TMainForm.tbtnMemoPainterClick(Sender: TObject);
begin
  ColorDialog.color := reMemo.Font.color;

  if ColorDialog.Execute then
    reMemo.SelAttributes.color := ColorDialog.color;
end;

procedure TMainForm.miNotepadClick(Sender: TObject);
begin
  if not pgcMain.Visible then
    tbtnToggle.Click;
  pgcMain.ActivePage := tbMemo;
end;

procedure TMainForm.ShowComments;
var
  B, C, V, ib, ic, iv, verseIx, commentaryIx, verseCount: integer;
  Lines: string;
  iscomm, resolveLinks, blFailed: Boolean;
  s, aname: string;
  commentaryModule: TModuleEntry;
  bookTabInfo: TBookTabInfo;
  bookView: TBookFrame;

  function FailedToLoadComment(const reason: string): string;
  begin
    Result := Lang.SayDefault('comFailedLoad', 'Failed to display commentary') + '<br>' + Lang.Say(reason);
  end;

label lblSetOutput;
begin
  bookView := GetBookView(self);
  bookTabInfo := bookView.BookTabInfo;
  if not bookTabInfo.Bible.isBible then
    Exit;
  if (not pgcMain.Visible) or (pgcMain.ActivePage <> tbComments) then
    Exit;

  if tbComments.tag = 0 then
    tbComments.tag := 1;

  Lines := '';
  if Length(Trim(cbComments.Text)) = 0 then
  begin
    if cbComments.Items.Count > 0 then
    begin
      commentaryIx := cbComments.Items.IndexOf(mBqEngine.mLastUsedComment);
      if commentaryIx >= 0 then
        cbComments.ItemIndex := commentaryIx
      else
        cbComments.ItemIndex := 0;
    end
    else
      Exit;
  end;

  commentaryIx := mModules.IndexOf(cbComments.Text);
  if commentaryIx < 0 then
  begin
    raise Exception.CreateFmt
      ('Cannot locate module for comments, module name: %s', [cbComments.Text])
  end;
  commentaryModule := mModules[commentaryIx];
  bookTabInfo.SecondBible.inifile := commentaryModule.getIniPath();

  bookTabInfo.Bible.ReferenceToInternal(bookTabInfo.Bible.CurBook, bookTabInfo.Bible.CurChapter, 1, ib, ic, iv);
  blFailed := not bookTabInfo.SecondBible.InternalToReference(ib, ic, iv, B, C, V);
  if blFailed then
  begin
    Lines := FailedToLoadComment('Cannot find matching comment');
    goto lblSetOutput;
  end;

  iscomm := commentaryModule.modType = modtypeComment;

  // if it's a commentary or it has chapter zero (introduction to book)
  // and it's chapter 1, show chapter 0, too :-)
  resolveLinks := false;
  if Assigned(bookTabInfo) then
  begin
    resolveLinks := bookTabInfo[vtisResolveLinks];
    if resolveLinks then
      bookTabInfo.SecondBible.FuzzyResolve := bookTabInfo[vtisFuzzyResolveLinks];
  end;

  if bookTabInfo.SecondBible.Trait[bqmtZeroChapter] and (C = 2) then
  begin
    blFailed := true;
    try
      blFailed := not bookTabInfo.SecondBible.OpenChapter(B, 1, resolveLinks);
    except
      on E: TBQPasswordException do
      begin
        PasswordPolicy.InvalidatePassword(E.mArchive);
        MessageBoxW(self.Handle, PWideChar(Pointer(E.mMessage)), nil, MB_ICONERROR or MB_OK);
      end
    end;
    if not blFailed then
    begin

      verseCount := bookTabInfo.SecondBible.verseCount - 1;
      for verseIx := 0 to verseCount do
      begin
        s := bookTabInfo.SecondBible.Verses[verseIx];

        if not iscomm then
        begin
          StrDeleteFirstNumber(s);
          if bookTabInfo.SecondBible.Trait[bqmtStrongs] then
            s := DeleteStrongNumbers(s);

          AddLine(
            Lines, Format('<a name=%d>%d <font face="%s">%s</font><br>',
            [verseIx + 1, verseIx + 1, bookTabInfo.SecondBible.fontName, s])
          );

        end // if not commentary
        else
        begin // if it's commentary
          aname := StrGetFirstNumber(s);
          AddLine(Lines, Format('<a name=%s><font face="%s">%s</font><br>', [aname, bookTabInfo.SecondBible.fontName, s]));
        end;
      end;
    end;

    AddLine(Lines, '<hr>');
  end;
  blFailed := true;
  try
    blFailed := not bookTabInfo.SecondBible.OpenChapter(B, C, resolveLinks);
  except
    on E: TBQPasswordException do
    begin
      PasswordPolicy.InvalidatePassword(E.mArchive);
      MessageBoxW(self.Handle, PWideChar(Pointer(E.mMessage)), nil, MB_ICONERROR or MB_OK);
    end
  end;
  if blFailed then
  begin
    Lines := FailedToLoadComment('Failed to open chapter');
    goto lblSetOutput;
  end;

  verseCount := bookTabInfo.SecondBible.verseCount() - 1;
  for verseIx := 0 to verseCount do
  begin
    s := bookTabInfo.SecondBible.Verses[verseIx];
    if not iscomm then
    begin
      StrDeleteFirstNumber(s);
      if bookTabInfo.SecondBible.Trait[bqmtStrongs] then
        s := DeleteStrongNumbers(s);

      AddLine(Lines, Format('<a name=%d>%d <font face="%s">%s</font><br>',
        [verseIx + 1, verseIx + 1, bookTabInfo.SecondBible.fontName, s]));

    end
    else
    begin
      aname := StrGetFirstNumber(s);
      AddLine(Lines, Format('<a name=%s><font face="%s">%s</font><br>', [aname, bookTabInfo.SecondBible.fontName, s]));
    end;
  end;
  AddLine(Lines,
    '<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>');

  bwrComments.Base := bookTabInfo.SecondBible.path;
  mBqEngine.mLastUsedComment := bookTabInfo.SecondBible.Name;

lblSetOutput:
  bwrComments.LoadFromString(Lines);

  for verseIx := 1 to tbComments.tag do
    bwrComments.PositionTo(IntToStr(verseIx)); // ??

end;

procedure TMainForm.cbCommentsChange(Sender: TObject);
begin
  ShowComments;
  bwrComments.PositionTo(IntToStr(tbComments.tag));
end;

procedure TMainForm.cbCommentsCloseUp(Sender: TObject);
begin
  try
    MainForm.FocusControl(bwrComments);
  except
  end;
end;

procedure TMainForm.cbCommentsDropDown(Sender: TObject);
begin
  FilterCommentariesCombo();
end;

procedure TMainForm.btnSearchOptionsClick(Sender: TObject);
begin
  if pnlSearch.Height > chkCase.Top + chkCase.Height then
  begin // wrap it
    pnlSearch.Height := chkAll.Top;
    btnSearchOptions.Caption := '>';
  end
  else
  begin
    pnlSearch.Height := lblSearch.Top + lblSearch.Height + 10;
    btnSearchOptions.Caption := '<';
  end;

  ActiveControl := cbSearch;
end;

procedure TMainForm.cbTagsFilterChange(Sender: TObject);
var
  timer: TTimer;
begin
  timer := GetTagFilterTimer();
  timer.Enabled := true;
end;

procedure TMainForm.chkExactPhraseClick(Sender: TObject);
begin
  if chkExactPhrase.Checked then
  begin
    chkAll.Checked := false;
    chkPhrase.Checked := false;
    chkParts.Checked := false;
    chkCase.Checked := false;
  end;
end;

procedure TMainForm.cbListDropDown(Sender: TObject);
var
  bible: TBible;
begin
  bible := GetBookView(self).BookTabInfo.Bible;
  if IsDown(VK_MENU) and (bible.isBible) and (mslSearchBooksCache.Count > 0)
  then
  begin
    cbList.Items.Assign(mslSearchBooksCache);
    mblSearchBooksDDAltered := true;
  end
  else
  begin
    if mblSearchBooksDDAltered then
      SearchListInit();
    mblSearchBooksDDAltered := false;
  end;
end;

procedure TMainForm.cbDicChange(Sender: TObject);
var
  i: integer;
  res, tt: string;
  bookTabInfo: TBookTabInfo;
  blResolveLinks, blFuzzy: Boolean;
  dicCount: integer;
begin
  dicCount := mBqEngine.DictionariesCount - 1;
  for i := 0 to dicCount do
    if mBqEngine.Dictionaries[i].Name = cbDic.Items[cbDic.ItemIndex] then
    begin
      res := mBqEngine.Dictionaries[i].Lookup(mBqEngine.DictionaryTokens[DicSelectedItemIndex()]);
      break;
    end;
  blResolveLinks := false;
  blFuzzy := false;
  bookTabInfo := GetBookView(self).BookTabInfo;
  if Assigned(bookTabInfo) then
  begin
    blResolveLinks := bookTabInfo[vtisResolveLinks];
    blFuzzy := bookTabInfo[vtisFuzzyResolveLinks];
  end;
  if blResolveLinks then
    tt := ResolveLinks(res, blFuzzy)
  else
    tt := res;

  bwrDic.LoadFromString(tt);
  pgcMain.ActivePage := tbDic;
end;

procedure TMainForm.lbHistoryClick(Sender: TObject);
begin
  HistoryOn := false;
  GetBookView(self).ProcessCommand(History[lbHistory.ItemIndex], hlDefault);

  tbLinksToolBar.Visible := false;
  HistoryOn := true;
end;

procedure TMainForm.NavigateToMainBookNode(book: TBible);
var
  bookNode, chapterNode: PVirtualNode;
  chapterIndex, bookIndex: integer;
begin
  vdtModules.ClearSelection;

  bookIndex := book.CurBook - 1;
  if (bookIndex < 0) then
    bookIndex := 0;

  bookNode := GetChildNodeByIndex(nil, bookIndex);
  if Assigned(bookNode) then
  begin
    chapterIndex := book.CurChapter - 1;
    if (chapterIndex < 0) then
      chapterIndex := 0;

    chapterNode := GetChildNodeByIndex(bookNode, chapterIndex);

    if Assigned(chapterNode) then
    begin
      if (vdtModules.Selected[chapterNode] = False) then
      begin
        if (vdtModules.Expanded[bookNode] = False) then
          vdtModules.Expanded[bookNode] := True;

        vdtModules.Selected[chapterNode] := True;
        vdtModules.FocusedNode := chapterNode;
      end;
    end
    else
    begin
      vdtModules.Selected[bookNode] := True;
      vdtModules.FocusedNode := bookNode;
    end;
  end;

end;

function TMainForm.GetCurrentBookNode(): PVirtualNode;
var
  currentNodes: TNodeArray;
  data: PBookNodeData;
begin
  Result := nil;
  currentNodes := vdtModules.GetSortedSelection(false);
  if (Length(currentNodes) > 0) then
  begin
    data := vdtModules.GetNodeData(currentNodes[0]);
    if (data.NodeType = btBook) then
    begin
      Result := currentNodes[0];
    end
    else
    begin
      Result := currentNodes[0].Parent;
    end;
  end;
end;

function TMainForm.IsPsalms(bookNodeIndex: integer): Boolean;
var
  totalPsalms: integer;
  bible: TBible;
begin
  try
    bible := GetBookView(self).BookTabInfo.Bible;
    totalPsalms := 150;
    if (bible.Trait[bqmtZeroChapter]) then
      totalPsalms := totalPsalms + 1; // extra introduction chapter

    Result := (bookNodeIndex = 19) and (bible.ChapterQtys[19] = totalPsalms);
  except
    Result := False;
  end;
end;

function TMainForm.GetChildNodeByIndex(parentNode: PVirtualNode; index: Integer): PVirtualNode;
begin
  Result := nil;
  if (parentNode = nil) then
  begin
    Result := vdtModules.GetFirst();
    while (index <> 0) do
    begin
      Result := vdtModules.GetNextSibling(Result);
      Dec(index);
    end;
    exit;
  end;

  if (vsHasChildren in parentNode.States) then
  begin
    Result := vdtModules.GetFirstChild(parentNode);
    while (Assigned(Result) and (index <> 0)) do
    begin
      Result := vdtModules.GetNextSibling(Result);
      Dec(index);
    end;
  end;
end;

function TMainForm.OpenChapter: Boolean;
var
  data: PBookNodeData;
  node: PVirtualNode;
  bookIndex: integer;
  chapterIndex: integer;
  command: string;
  bookView: TBookFrame;
  bible: TBible;
begin
  Result := false;
  node := vdtModules.GetFirstSelected();
  if Assigned(node) then
  begin
    data := vdtModules.GetNodeData(node);

    if (data.NodeType = btBook) then
    begin
      bookIndex := node.Index + 1;
      chapterIndex := 1;
    end
    else
    begin
      bookIndex := node.Parent.Index + 1;
      chapterIndex := node.Index + 1;
    end;

    AddressFromMenus := true;

    bookView := GetBookView(self);
    bible := bookView.BookTabInfo.Bible;
    command := Format('go %s %d %d', [bible.ShortPath, bookIndex, chapterIndex]);
    Result := bookView.ProcessCommand(command, hlDefault);
  end;
end;

function TMainForm.NewBookTab(
  const command: string;
  const satellite: string;
  const browserbase: string;
  state: TBookTabInfoState;
  const Title: string;
  visual: Boolean): Boolean;
var
  curTabInfo, newTabInfo: TBookTabInfo;
  newBible: TBible;
begin
  newBible := nil;
  ClearVolatileStateData(state);
  Result := true;
  try
    newBible := CreateNewBibleInstance();
    if not Assigned(newBible) then
      abort;

    if (mTabsView.ChromeTabs.ActiveTabIndex >= 0) then
    begin
      // save current tab state
      curTabInfo := GetBookView(self).BookTabInfo;
      if (Assigned(curTabInfo)) then
      begin
         curTabInfo.SaveState(GetTabsView(self));
      end;
    end;

    newTabInfo := TBookTabInfo.Create(newBible, command, satellite, Title, state);

    newTabInfo.SecondBible := TBible.Create(self);
    newTabInfo.ReferenceBible := TBible.Create(self);

    mTabsView.AddBookTab(newTabInfo, Title);

    if visual then
    begin
      mTabsView.ChromeTabs.ActiveTabIndex := mTabsView.ChromeTabs.Tabs.Count - 1;

      StrongNumbersOn := vtisShowStrongs in state;
      newTabInfo.Bible.RecognizeBibleLinks := vtisResolveLinks in state;
      newTabInfo.Bible.FuzzyResolve := vtisFuzzyResolveLinks in state;
      MemosOn := vtisShowNotes in state;

      GetBookView(self).SafeProcessCommand(command, hlDefault);
    end
    else
    begin
      newTabInfo.StateEntryStatus[vtisPendingReload] := true;
    end;
  except
    on E: Exception do
    begin
      BqShowException(E);
      Result := false;
      newBible.Free();
    end;
  end;

end;

procedure TMainForm.pgcMainChange(Sender: TObject);
var
  saveCursor: TCursor;
begin
  if (pgcMain.ActivePage = tbDic) and (not mDictionariesFullyInitialized) then
  begin
    saveCursor := self.Cursor;
    Screen.Cursor := crHourGlass;
    try
      LoadDictionaries(true);
    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;
    Screen.Cursor := saveCursor;
  end;
  if (pgcMain.ActivePage = tbList) then
  begin
    try
      if not mTaggedBookmarksLoaded then
        LoadTaggedBookMarks();
    except
      on E: Exception do
        BqShowException(E)
    end;
  end
  else if pgcMain.ActivePage = tbSearch then
  begin
    if Length(cbSearch.Text) > 0 then
      cbSearch.SelectAll();
  end;

  case pgcMain.ActivePageIndex of
    0:
      GetBookView(self).pmMemo.PopupComponent := GetBookView(self).tedtReference;
    1:
      begin
        GetBookView(self).pmMemo.PopupComponent := cbSearch;
      end;
    2:
      GetBookView(self).pmMemo.PopupComponent := edtDic;
    3:
      GetBookView(self).pmMemo.PopupComponent := edtStrong;
    4:
      begin
        GetBookView(self).pmMemo.PopupComponent := bwrComments;
        FilterCommentariesCombo;
      end;
    5:
      GetBookView(self).pmMemo.PopupComponent := bwrXRef;
    6:
      GetBookView(self).pmMemo.PopupComponent := reMemo;

  end;
end;

function FindPageforTabIndex(PageControl: TPageControl; TabIndex: integer): TTabSheet;
var
  i: integer;
begin
  Assert(Assigned(PageControl));
  Assert((TabIndex >= 0) and (TabIndex < PageControl.PageCount));
  Result := nil;
  for i := 0 to PageControl.PageCount - 1 do
    if PageControl.Pages[i].tabVisible then
    begin
      Dec(TabIndex);
      if TabIndex < 0 then
      begin
        Result := PageControl.Pages[i];
        break;
      end;
    end;
end;

function HintForTab(pc: TPageControl; TabIndex: integer): WideString;
var
  tabsheet: TTabSheet;
begin
  // tabindex may be <> pageindex if some pages have tabvisible = false!
  tabsheet := FindPageforTabIndex(pc, TabIndex);
  if Assigned(tabsheet) then
    Result := tabsheet.Hint
  else
    Result := '';
end;

procedure TMainForm.pgcMainMouseLeave(Sender: TObject);
begin
  //
end;

procedure TMainForm.pgcMainMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  TabIndex: integer;
  pc: TPageControl;
  newhint: string;
  R: TRect;
  pt: TPoint;
begin

  pc := Sender as TPageControl;
  TabIndex := pc.IndexOfTabAt(X, Y);
  if TabIndex >= 0 then
  begin

    if SendMessage(pc.Handle, TCM_GETITEMRECT, TabIndex, LPARAM(@R)) <> 0 then
    begin
      pt.X := X;
      pt.Y := Y;
      if PtInRect(R, pt) then
      begin
        newhint := HintForTab(pc, TabIndex);
      end
      else
        newhint := '';
      if newhint <> pc.Hint then
      begin
        pc.Hint := newhint;
        Application.CancelHint;
      end;
    end;
  end
  else
    pc.Hint := '';
end;

function TMainForm.LocateDicItem: integer;
var
  s: string;
  list_ix, len: integer;
  nd: PVirtualNode;
begin
  list_ix := DicSelectedItemIndex();
  if (list_ix >= 0) and (list_ix < integer(mBqEngine.DictionariesCount)) and
    (mBqEngine.DictionaryTokens[list_ix] = edtDic.Text) then
  begin
    Result := list_ix;
    Exit;
  end;
  s := Trim(edtDic.Text);
  if Length(s) <= 0 then
  begin
    nd := vstDicList.GetFirst();
    vstDicList.Selected[nd] := true;
    DicScrollNode(nd);
  end;

  if (mBqEngine.DictionaryTokens.Count = 0) then
  begin
    Result := -1;
    Exit;
  end;

  len := Length(s);
  repeat
    list_ix := mBqEngine.DictionaryTokens.LocateLastStartedWith(s, 0);
    if list_ix >= 0 then
    begin
      Result := list_ix;
      Exit;
    end;
    Dec(len);
    s := Copy(s, 1, len);
  until len <= 0;
  Result := 0;
end;

function TMainForm.CreateNewBibleInstance(): TBible;
begin
  Result := nil;
  try
    Result := TBible.Create(self);
    with Result do
    begin
      OnVerseFound := BookVerseFound;
      OnChangeModule := BookChangeModule;
      OnSearchComplete := BookSearchComplete;
    end;
  except
    Result.Free();
  end;
end;

procedure TMainForm.miDicClick(Sender: TObject);
begin
  if not pgcMain.Visible then
    tbtnToggle.Click;

  pgcMain.ActivePage := tbDic;
end;

procedure TMainForm.miNewTabClick(Sender: TObject);
var
  bookTabInfo: TBookTabInfo;
begin
  bookTabInfo := GetBookView(self).BookTabInfo;
  if (bookTabInfo <> nil) then
  begin
    NewBookTab(bookTabInfo.Location, bookTabInfo.SatelliteName, '', bookTabInfo.State, '', true);
  end;
end;

procedure TMainForm.miChooseLogicClick(Sender: TObject);
var
  mi: TMenuItem;
  ti: TBookTabInfo;
  reload: Boolean;
begin
  mi := Sender as TMenuItem;
  ti := GetBookView(self).BookTabInfo;
  reload := (ti[vtisFuzzyResolveLinks] xor (Sender = miFuzzyLogic));

  if (Assigned(ti)) then
  begin
    if not ti[vtisResolveLinks] then
      ti[vtisResolveLinks] := true;
    ti[vtisFuzzyResolveLinks] := mi = miFuzzyLogic;
    if reload then
    begin
      miRecognizeBibleLinks.Checked := true;
      ti[vtisPendingReload] := true;
      miRecognizeBibleLinksClick(self);
    end;
  end;
end;

procedure TMainForm.miChooseSatelliteBibleClick(Sender: TObject);
begin
  tbtnSatellite.Click();
end;

procedure TMainForm.miCloseTabClick(Sender: TObject);
begin
  mTabsView.CloseActiveTab();
end;

procedure TMainForm.miCommentsClick(Sender: TObject);
begin
  if not pgcMain.Visible then
    tbtnToggle.Click;

  pgcMain.ActivePage := tbComments;
end;

procedure TMainForm.CheckModuleInstall;
var
  pCommandLine, pCurrent: PChar;
  len: integer;
  cChar, saveChar: Char;
  ws, ext: string;
  blQuoted: Boolean;
begin
  pCommandLine := GetCommandLineW();
  pCurrent := pCommandLine;

  pCurrent := GetTokenFromString(pCurrent, ' ', len);
  while pCurrent <> nil do
  begin
    cChar := pCurrent^;
    blQuoted := (cChar = '"') or (cChar = '''');
    if blQuoted then
    begin
      inc(pCurrent);
      pCurrent := GetTokenFromString(pCurrent, cChar, len);
      if pCurrent = nil then
        break;
    end;
    saveChar := (pCurrent + len)^;
    (pCurrent + len)^ := #0;
    ws := pCurrent;
    (pCurrent + len)^ := saveChar;
    ext := ExtractFileExt(ws);
    if ext = '.bqb' then
    begin
      InstallModule(ws);
    end;

    inc(pCurrent, len + ord(blQuoted));

    pCurrent := GetTokenFromString(pCurrent, ' ', len)
  end;

end;

function TMainForm.DeleteHotModule(const me: TModuleEntry): Boolean;
var
  hotMenuItem, favouriteMenuItem: TMenuItem;
  i: integer;
  tabsView: ITabsView;
  bookView: TBookFrame;
begin
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    hotMenuItem := FavoriteItemFromModEntry(me);
    if Assigned(hotMenuItem) then
    begin
      favouriteMenuItem.Remove(hotMenuItem);
      hotMenuItem.Free();
    end;
    SetFavouritesShortcuts();
  except
    on E: Exception do
      BqShowException(E);
  end;
  try
    for tabsView in mTabsViews do
    begin
      i := FavoriteTabFromModEntry(tabsView, me);
      if i >= 0 then
        tabsView.BibleTabs.Tabs.Delete(i);
      bookView := GetBookView(self);
      bookView.AdjustBibleTabs(bookView.BookTabInfo.Bible.ShortName);
    end;
  except
    on E: Exception do
      BqShowException(E);
  end;
  Result := true;
end;

procedure TMainForm.cbQtyChange(Sender: TObject);
begin
  if cbQty.ItemIndex < cbQty.Items.Count - 1 then
    SearchPageSize := StrToInt(cbQty.Items[cbQty.ItemIndex])
  else
    SearchPageSize := 50000;
  DisplaySearchResults(1);
end;

procedure TMainForm.miRefFontConfigClick(Sender: TObject);
begin
  with FontDialog do
  begin
    Font.Name := bwrSearch.DefFontName;
    Font.color := bwrSearch.DefFontColor;
    Font.Size := bwrSearch.DefFontSize;
  end;

  if FontDialog.Execute then
  begin
    with bwrSearch do
    begin
      DefFontName := FontDialog.Font.Name;
      DefFontColor := FontDialog.Font.color;
      DefFontSize := FontDialog.Font.Size;
      LoadFromString(DocumentSource);
    end;

    with bwrDic do
    begin
      DefFontName := bwrSearch.DefFontName;
      DefFontColor := bwrSearch.DefFontColor;
      DefFontSize := bwrSearch.DefFontSize;
      LoadFromString(DocumentSource);
    end;

    with bwrStrong do
    begin
      DefFontName := bwrSearch.DefFontName;
      DefFontColor := bwrSearch.DefFontColor;
      DefFontSize := bwrSearch.DefFontSize;
      LoadFromString(DocumentSource);
    end;

    with bwrXRef do
    begin
      DefFontName := bwrSearch.DefFontName;
      DefFontColor := bwrSearch.DefFontColor;
      DefFontSize := bwrSearch.DefFontSize;
    end;

    with bwrComments do
    begin
      DefFontName := bwrSearch.DefFontName;
      DefFontColor := bwrSearch.DefFontColor;
      DefFontSize := bwrSearch.DefFontSize;
    end;

    try
      ShowXref;
    finally
      ShowComments;
    end;
  end;
end;

procedure TMainForm.miQuickNavClick(Sender: TObject);
var
  bible: TBible;
begin
  InputForm.tag := 0; // use TEdit
  InputForm.Caption := miQuickNav.Caption;
  InputForm.Font := MainForm.Font;

  bible := GetBookView(self).BookTabInfo.Bible;
  with bible do
    if CurFromVerse > 1 then
      InputForm.edtValue.Text := ShortPassageSignature(CurBook, CurChapter, CurFromVerse, CurToVerse)
    else
      InputForm.edtValue.Text := ShortPassageSignature(CurBook, CurChapter, 1, 0);

  InputForm.edtValue.SelectAll();

  if InputForm.ShowModal = mrOk then
  begin
    GetBookView(self).tedtReference.Text := InputForm.edtValue.Text;
    InputForm.edtValue.Text := '';
    GoReference();

    Windows.SetFocus(mTabsView.Browser.Handle);
  end;
end;

procedure TMainForm.miQuickSearchClick(Sender: TObject);
begin
  InputForm.tag := 0; // use TEdit
  InputForm.Caption := miQuickSearch.Caption;
  InputForm.Font := MainForm.Font;

  with GetBookView(self).BookTabInfo.Bible do
    InputForm.edtValue.Text := cbSearch.Text;

  if InputForm.ShowModal = mrOk then
  begin
    if not pgcMain.Visible then
      tbtnToggle.Click;
    pgcMain.ActivePage := tbSearch;

    cbSearch.Text := InputForm.edtValue.Text;
    btnFind.Click;
  end;
end;

procedure TMainForm.tbtnCopyrightClick(Sender: TObject);
var
  bible: TBible;
begin
  bible := GetBookView(self).BookTabInfo.Bible;
  if bible.Copyright = '' then
    ShowMessage(Copy(tbtnCopyright.Hint, 2, $FFFFFF))
  else
  begin
    if not Assigned(CopyrightForm) then
      CopyrightForm := TCopyrightForm.Create(self);
    CopyrightForm.Caption := 'Copyright (c) ' + bible.Copyright;
    if FileExists(bible.path + 'copyright.htm') then
    begin
      CopyrightForm.bwrCopyright.LoadFromFile(bible.path + 'copyright.htm');
      CopyrightForm.ShowModal;
    end
    else
      ShowMessage('File not found: ' + bible.path + 'copyright.htm');
  end;
end;

procedure TMainForm.cbDicFilterChange(Sender: TObject);
var
  pvn: PVirtualNode;
  wordIx, wordCount: integer;
  lst: TBQStringList;
  dictionary: TDict;
begin
  if cbDicFilter.ItemIndex <> 0 then
  begin
    dictionary := mBqEngine.Dictionaries[cbDicFilter.ItemIndex - 1];
    vstDicList.BeginUpdate();
    try
      vstDicList.Clear;
      lst := mBqEngine.DictionaryTokens;
      lst.BeginUpdate();
      try
        lst.Clear();
        lst.Sorted := true;
        wordCount := dictionary.Words.Count - 1;
        for wordIx := 0 to wordCount do
          lst.Add(dictionary.Words[wordIx]);
      finally
        lst.EndUpdate;
      end;
      wordCount := lst.Count - 1;
      for wordIx := 0 to wordCount do
      begin
        pvn := vstDicList.InsertNode(nil, amAddChildLast, Pointer(wordIx));
        lst.Objects[wordIx] := TObject(pvn);
        if wordIx and $FFF = $FFF then
          Application.ProcessMessages;
      end;
    finally
      vstDicList.EndUpdate();
    end;
  end
  else
  begin
    mBqEngine.InitDictionaryItemsList(true);
    DictionaryStartup();
  end;
end;

procedure TMainForm.AddBookmark(caption: string);
var
  newstring: string;
  bible: TBible;
begin
  InputForm.tag := 1; // use TMemo
  InputForm.Caption := caption;
  InputForm.Font := MainForm.Font;

  bible := GetBookView(self).BookTabInfo.Bible;
  if bible.verseCount() = 0 then
    bible.OpenChapter(bible.CurBook, bible.CurChapter);
  if bible.Trait[bqmtStrongs] then
    newstring := Trim(DeleteStrongNumbers(bible.Verses[CurVerseNumber - CurFromVerse]))
  else
    newstring := Trim(bible.Verses[CurVerseNumber - CurFromVerse]);

  StrDeleteFirstNumber(newstring);

  InputForm.memValue.Text := newstring;

  if InputForm.ShowModal = mrOk then
  begin
    with bible do
      newstring :=
        ShortName + ' ' +
        ShortPassageSignature(CurBook, CurChapter, CurVerseNumber, CurVerseNumber) + ' ' +
        InputForm.memValue.Text;

    StrReplace(newstring, #13#10, ' ', true);

    lbBookmarks.Items.Insert(0, newstring);

    with bible do
      Bookmarks.Insert(0, Format('go %s %d %d %d %d $$$%s',
        [ShortPath, CurBook, CurChapter, CurVerseNumber, 0, newstring]));
  end;
end;

procedure TMainForm.AddBookmarkTagged();
var
  pn, ParentNode: PVirtualNode;
  nd: TVersesNodeData;
  F, t: integer;
  bible: TBible;
begin
  InputForm.tag := 0;
  ShowTagsTab();
  pn := vdtTagsVerses.GetFirstSelected();
  if not Assigned(pn) then
  begin
    ShowMessage('Прежде нужно выбрать тег!');
    Exit;
  end;
  ParentNode := vdtTagsVerses.NodeParent[pn];
  if Assigned(ParentNode) and (ParentNode <> vdtTagsVerses.RootNode) then
  begin
    pn := ParentNode;
  end;

  nd := TVersesNodeData(vdtTagsVerses.GetNodeData(pn)^);
  if not Assigned(nd) then
    Exit;
  if (nd.nodeType <> bqvntTag) then
    Exit;
  if CurSelStart < CurSelEnd then
  begin
    F := CurSelStart;
    t := CurSelEnd;
  end
  else
  begin
    F := CurVerseNumber;
    t := CurVerseNumber;
  end;

  bible := GetBookView(self).BookTabInfo.Bible;
  TagsDbEngine.AddVerseTagged(nd.getText(), bible.CurBook, bible.CurChapter, F, t, bible.ShortPath, true);
end;

procedure TMainForm.lbBookmarksDblClick(Sender: TObject);
begin
  GetBookView(self).ProcessCommand(Bookmarks[lbBookmarks.ItemIndex], hlDefault);
end;

procedure TMainForm.bwrStrongHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  num, code: integer;
  scode: string;
begin
  if Pos('s', SRC) = 1 then
  begin
    scode := Copy(SRC, 2, Length(SRC) - 1);
    Val(scode, num, code);
    if code = 0 then
      DisplayStrongs(num, (Copy(scode, 1, 1) = '0'));
  end;
end;

procedure TMainForm.lbBookmarksClick(Sender: TObject);
begin
  lblBookmark.Caption := Comment(Bookmarks[lbBookmarks.ItemIndex]);
end;

procedure TMainForm.lbBookmarksKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: integer;
begin
  if lbBookmarks.Items.Count = 0 then
    Exit;

  if Key = VK_DELETE then
  begin
    if Application.MessageBox('Удалить закладку?', 'Подтвердите удаление',
      MB_YESNO + MB_DEFBUTTON1) <> ID_YES then
      Exit;

    i := lbBookmarks.ItemIndex;
    Bookmarks.Delete(i);
    lbBookmarks.Items.Delete(i);
    if i = lbBookmarks.Items.Count then
      i := i - 1;

    if i < 0 then
      Exit;

    lbBookmarks.ItemIndex := i;
    lbBookmarksClick(Sender);
  end;
end;

procedure TMainForm.lbHistoryKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: integer;
begin
  if lbHistory.Items.Count = 0 then
    Exit;

  if Key = VK_DELETE then
  begin
    if Application.MessageBox(
      'Удалить запись в истории?',
      'Подтвердите удаление', MB_YESNO + MB_DEFBUTTON1) <> ID_YES then
      Exit;

    i := lbHistory.ItemIndex;
    History.Delete(i);
    lbHistory.Items.Delete(i);
    if i = lbHistory.Items.Count then
      i := i - 1;

    if i < 0 then
      Exit;

    lbHistory.ItemIndex := i;
    lbHistoryClick(Sender);
  end;
end;

procedure TMainForm.btnOnlyMeaningfulClick(Sender: TObject);
var
  btn: TrkGlassButton;
begin
  btn := Sender as TrkGlassButton;
  btn.Down := not btn.Down;
  FilterCommentariesCombo();
end;

procedure TMainForm.pnlFindStrongNumberMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  pnlFindStrongNumber.BevelOuter := bvNone;
end;

procedure TMainForm.pnlFindStrongNumberMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  pnlFindStrongNumber.BevelOuter := bvRaised;
end;

function TMainForm.FindTaggedTopMenuItem(tag: integer): TMenuItem;
var
  menuItemCount, i: integer;
begin
  Result := nil;
  menuItemCount := mmGeneral.Items.Count - 1;
  for i := 0 to menuItemCount do
  begin
    if (mmGeneral.Items[i].tag = tag) then
    begin
      Result := mmGeneral.Items[i] as TMenuItem;
      break
    end // if
  end; // for
end;

// find selected Strongs number in the whole Bible...
procedure TMainForm.pnlFindStrongNumberClick(Sender: TObject);
var
  bible: TBible;
begin
  if lbStrong.ItemIndex < 0 then
    Exit;

  pgcMain.ActivePage := tbSearch;
  cbSearch.Text := lbStrong.Items[lbStrong.ItemIndex];

  bible := GetBookView(self).BookTabInfo.Bible;
  if bible.StrongsPrefixed then
    cbList.ItemIndex := 0 // full book
  else
  begin
    if Copy(lbStrong.Items[lbStrong.ItemIndex], 1, 1) = 'H' then
      cbSearch.Text := '0' + Copy(lbStrong.Items[lbStrong.ItemIndex], 2, 100)
    else if Copy(lbStrong.Items[lbStrong.ItemIndex], 1, 1) = 'G' then
      cbSearch.Text := Copy(lbStrong.Items[lbStrong.ItemIndex], 2, 100)
    else
      cbSearch.Text := lbStrong.Items[lbStrong.ItemIndex];

    if Copy(cbSearch.Text, 1, 1) = '0' then
      cbList.ItemIndex := 1 // old testament
    else
      cbList.ItemIndex := 2; // new testament
  end;

  chkParts.Checked := true;
  btnFind.Click;
end;

procedure TMainForm.miCopyOptionsClick(Sender: TObject);
begin
  ConfigForm.pgcOptions.ActivePageIndex := 0;
  ShowConfigDialog;
end;

procedure TMainForm.miOpenNewViewClick(Sender: TObject);
var
  addr: string;
  ti: TBookTabInfo;
  satBible: string;
begin
  G_XRefVerseCmd := Trim(G_XRefVerseCmd);
  addr := G_XRefVerseCmd;
  if Length(addr) <= 0 then
    Exit;
  ti := GetBookView(self).BookTabInfo;
  if Assigned(ti) then
    satBible := ti.SatelliteName
  else
    satBible := '------';

  NewBookTab(addr, satBible, '', ti.State, '', true);
  if GetCommandType(G_XRefVerseCmd) = bqctInvalid then
  begin
    GetBookView(self).tedtReference.Text := addr;
    GoReference();
  end;

end;

procedure TMainForm.miOptionsClick(Sender: TObject);
begin
  ConfigForm.pgcOptions.ActivePageIndex := 2;
  ShowConfigDialog;
end;

procedure TMainForm.ShowConfigDialog;
var
  i, moduleCount: integer;
  sl: TStringList;
  reload: Boolean;
  bookView: TBookFrame;
  bible: TBible;
begin
  reload := false;
  ForceForegroundLoad();
  with ConfigForm do
  begin
    Font.Assign(self.Font);
    Left := (Screen.Width - Width) div 2;
    Top := (Screen.Height - Height) div 2;
    edtSelectPath.Text := G_SecondPath;
    chkMinimizeToTray.Checked := trayIcon.MinimizeToTray;
    chkFullContextOnRestrictedLinks.Checked := mFlagFullcontextLinks;
    chkHighlightVerseHits.Checked := mFlagHighlightVerses;
    rgHotKeyChoice.ItemIndex := ConfigFormHotKeyChoiceItemIndex;
    moduleCount := mModules.Count - 1;
    cbAvailableModules.Clear();
    sl := TStringList.Create;
    try
      sl.Sorted := true;
      sl.BeginUpdate;
      try
        for i := 0 to moduleCount do
        begin
          sl.Add(mModules[i].mFullName);
        end;
      finally
        sl.EndUpdate();
      end;
      cbAvailableModules.Items.BeginUpdate;
      try
        cbAvailableModules.Items.Clear;
        for i := 0 to sl.Count - 1 do
          cbAvailableModules.Items.Add(sl[i]);
      finally
        cbAvailableModules.Items.EndUpdate();
      end;

    finally
      sl.Free;
    end;
    if moduleCount >= 0 then
      cbAvailableModules.ItemIndex := 0;

    moduleCount := mFavorites.mModuleEntries.Count - 1;
    lbFavourites.Clear();
    lbFavourites.Items.BeginUpdate();
    for i := 0 to moduleCount do
    begin
      lbFavourites.Items.Add(mFavorites.mModuleEntries[i].mFullName);
    end;
    lbFavourites.Items.EndUpdate();
  end;

  if ConfigForm.ShowModal = mrCancel then
    Exit;

  moduleCount := ConfigForm.lbFavourites.Count - 1;
  mFavorites.Clear();

  for i := 0 to moduleCount do
  begin
    try
      mFavorites.AddModule(mModules.ResolveModuleByNames
        (ConfigForm.lbFavourites.Items[i], ''));
    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;
  end;

  SetFavouritesShortcuts();
  bookView := GetBookView(self);
  bible := bookView.BookTabInfo.Bible;
  bookView.AdjustBibleTabs(bible.ShortName);

  CopyOptionsCopyVerseNumbersChecked := ConfigForm.chkCopyVerseNumbers.Checked;
  CopyOptionsCopyFontParamsChecked := ConfigForm.chkCopyFontParams.Checked;
  CopyOptionsAddReferenceChecked := ConfigForm.chkAddReference.Checked;
  CopyOptionsAddReferenceRadioItemIndex := ConfigForm.rgAddReference.ItemIndex;
  CopyOptionsAddLineBreaksChecked := ConfigForm.chkAddLineBreaks.Checked;
  CopyOptionsAddModuleNameChecked := ConfigForm.chkAddModuleName.Checked;
  ConfigFormHotKeyChoiceItemIndex := ConfigForm.rgHotKeyChoice.ItemIndex;
  trayIcon.MinimizeToTray := ConfigForm.chkMinimizeToTray.Checked;
  if mFlagFullcontextLinks <> ConfigForm.chkFullContextOnRestrictedLinks.Checked
  then
  begin
    mFlagFullcontextLinks := ConfigForm.chkFullContextOnRestrictedLinks.Checked;
    reload := true;
  end;
  if mFlagHighlightVerses <> ConfigForm.chkHighlightVerseHits.Checked then
  begin
    mFlagHighlightVerses := ConfigForm.chkHighlightVerseHits.Checked;
    reload := true;
  end;
  if ConfigForm.edtSelectPath.Text <> G_SecondPath then
  begin
    G_SecondPath := ConfigForm.edtSelectPath.Text;
    MainMenuInit(true);
  end;
  if reload then
    DeferredReloadViewPages();

end;

procedure TMainForm.ShowQNav(useDisposition: TBQUseDisposition = udMyLibrary);
var
  ws, wcap, wbtn: string;
  bookNode: PVirtualNode;
  bookTabInfo: TBookTabInfo;
begin
  if not Assigned(MyLibraryForm) then
    MyLibraryForm := TMyLibraryForm.Create(self);

  TranslateControl(MyLibraryForm);
  bookTabInfo := GetBookView(self).BookTabInfo;
  case useDisposition of
    udParabibles:
      begin
        ws := bookTabInfo.SatelliteName;
        wcap := Lang.SayDefault('SelectParaBible', 'Select secondary bible');
        wbtn := Lang.SayDefault('DeselectSec', 'Deselect');
        ws := bookTabInfo.SecondBible.Name;
      end;
    udMyLibrary:
      begin
        ws := bookTabInfo.Bible.Name;
        wcap := Lang.SayDefault('MyLib', 'My Library');
        wbtn := Lang.SayDefault('CollapseAll', 'Collapse all');
      end;
  end;

  MyLibraryForm.Caption := wcap;
  MyLibraryForm.btnCollapse.Caption := wbtn;

  MyLibraryForm.mUseDisposition := useDisposition;
  MyLibraryForm.mCellText := EmptyWideStr;
  MyLibraryForm.UpdateList(mModules, -1, ws);
  MyLibraryForm.ShowModal();
  if (MyLibraryForm.ModalResult <> mrOk) or
    (Length(MyLibraryForm.mCellText) <= 0) then
  begin
    tbtnSatellite.Down := bookTabInfo.SatelliteName <> '------';
    Exit;
  end;
  case useDisposition of
    udParabibles:
      SelectSatelliteBibleByName(MyLibraryForm.mCellText);
    udMyLibrary:
      begin
        GoModuleName(MyLibraryForm.mCellText);
        if MyLibraryForm.mBookIx > 0 then
        begin
          bookNode := GetChildNodeByIndex(nil, MyLibraryForm.mBookIx - 1);
          if Assigned(bookNode) then
          begin
            vdtModules.Selected[bookNode] := true;
            vdtModules.FocusedNode := bookNode;
          end;
        end;
      end;
  end;
end;

procedure TMainForm.ShowQuickSearch;
var bookView: TBookFrame;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  if not pgcMain.Visible then
    tbtnToggle.Click;
  if pgcMain.ActivePage <> tbGo then
  begin
    pgcMain.ActivePage := tbGo;
    pgcMainChange(self);
  end;
  bookView.ToggleQuickSearchPanel(true);
  try
    FocusControl(bookView.tedtQuickSearch);
  except
  end;
  if Length(bookView.tedtQuickSearch.Text) > 0 then
    bookView.tedtQuickSearch.SelectAll();
end;

procedure TMainForm.ShowSearchTab;
begin
  if not pgcMain.Visible then
    tbtnToggle.Click;
  if pgcMain.ActivePage <> tbSearch then
  begin
    pgcMain.ActivePage := tbSearch;
    pgcMainChange(self);
  end;
  ActiveControl := cbSearch;

end;

procedure TMainForm.ShowTagsTab;
begin
  if not pgcMain.Visible then
    tbtnToggle.Click;
  if pgcMain.ActivePage <> tbList then
  begin
    pgcMain.ActivePage := tbList;
    pgcMainChange(self);
  end;
  ActiveControl := cbTagsFilter;

end;

function TMainForm.AddMemo(caption: string): Boolean;
var
  newstring, signature: string;
  i: integer;
begin
  Result := false;
  InputForm.tag := 1; // use TMemo
  InputForm.Caption := caption;
  InputForm.Font := MainForm.Font;

  with GetBookView(self).BookTabInfo.Bible do
    signature := ShortName + ' ' + ShortPassageSignature(CurBook, CurChapter, CurVerseNumber, CurVerseNumber) + ' $$$';

  // search for 'RST Быт.1:1 $$$' in Memos.
  i := FindString(Memos, signature);

  if i > -1 then // found memo
    newstring := Comment(Memos[i])
  else
    newstring := '';

  InputForm.memValue.Text := newstring;

  if InputForm.ShowModal = mrOk then
  begin
    newstring := InputForm.memValue.Text;
    StrReplace(newstring, #13#10, ' ', true);

    if i > -1 then
      Memos.Delete(i); // for SORTED WideString, first delete it...

    if Trim(newstring) <> '' then
      Memos.Add(signature + newstring);

    Result := true;
  end;
end;

procedure TMainForm.trayIconClick(Sender: TObject);
begin
  if MainForm.Visible then
    trayIcon.HideMainForm
  else
    trayIcon.ShowMainForm;
end;

procedure TMainForm.SysHotKeyHotKey(Sender: TObject; Index: integer);
begin
  if trayIcon.MinimizeToTray then
  begin
    if MainForm.Visible then
    begin
      if Application.Active then
        Application.Minimize
      else
        Application.BringToFront;
    end
    else
      trayIcon.ShowMainForm;
  end
  else
  begin // if not minimizing to tray, hot key only activates or minimizes the app
    if Application.Active then
      Application.Minimize
    else
    begin
      Application.Restore;
      Application.BringToFront;
    end;
  end;
end;

procedure TMainForm.tbtnMemoPrintClick(Sender: TObject);
var
  opt: TPrintDialogOptions;
begin
  with PrintDialog do
  begin
    opt := options;
    options := [];
    if Execute then
      reMemo.Print('Printed by BibleQuote, http://JesusChrist.ru');
    options := opt;
  end;
end;

procedure TMainForm.tbtnSatelliteClick(Sender: TObject);
var
  ti: TBookTabInfo;
  vhl: TbqHLVerseOption;
begin
  ti := GetBookView(self).BookTabInfo;
  if not Assigned(ti) then
    Exit;
  if ti.SatelliteName <> '------' then
  begin
    ti.SatelliteName := '------';
    if ti.LocationType in [vtlUnspecified, vtlModule] then
    begin
      if ti[vtisHighLightVerses] then
        vhl := hlTrue
      else
        vhl := hlFalse;
      GetBookView(self).ProcessCommand(ti.Location, vhl);
    end;
    Exit;
  end;
  ShowQNav(udParabibles);
end;

procedure TMainForm.tbtnSatelliteMouseEnter(Sender: TObject);
var
  ti: TBookTabInfo;
begin
  if tbtnSatellite.Down then
  begin
    ti := GetBookView(self).BookTabInfo;
    tbtnSatellite.Hint := ti.SatelliteName;
  end
  else
  begin
    tbtnSatellite.Hint := Lang.SayDefault(
      'MainForm.tbtnSatellite.Hint',
      'Choose sencodary Bible');
  end;
end;

procedure TMainForm.SelectSatelliteBibleByName(const bibleName: string);
var
  tabInfo: TBookTabInfo;
  broserPos: integer;
  bookView: TBookFrame;
begin
  try
    bookView := GetBookView(self);
    tabInfo := bookView.BookTabInfo;
    tabInfo.SatelliteName := bibleName;
    if tabInfo.Bible.isBible then
    begin
      broserPos := mTabsView.Browser.Position;
      bookView.ProcessCommand(tabInfo.Location, TbqHLVerseOption(ord(tabInfo[vtisHighLightVerses])));
      mTabsView.Browser.Position := broserPos;
    end
    else
    begin
      try
        bookView.LoadSecondBookByName(bibleName);
      except
        on E: Exception do
          BqShowException(E);
      end;

    end; // else
    tbtnSatellite.Down := bibleName <> '------';
  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;

procedure TMainForm.edtDicChange(Sender: TObject);
var
  len, cnt, R: integer;
  Name: string;
  nd: PVirtualNode;
  lst: TBQStringList;
begin
  len := Length(edtDic.Text);

  if len > 0 then
  begin
    lst := mBqEngine.DictionaryTokens;
    cnt := lst.Count;
    if cnt <= 0 then
      Exit;
    name := edtDic.Text;
    R := lst.LocateLastStartedWith(name);
    if R >= 0 then
    begin // DicLB.ItemIndex:=r;
      nd := PVirtualNode(lst.Objects[R]);
      vstDicList.Selected[nd] := true;
      DicScrollNode(nd);
    end;
  end;
end;

procedure TMainForm.ReCalculateTagTree;
begin
  if (not Assigned(tbList)) or (not tbList.Visible) or
    (not Assigned(TagsDbEngine)) or (not Assigned(TagsDbEngine.fdTagsConnection))
  then
    Exit;
  if (not tbList.Visible) or (not TagsDbEngine.fdTagsConnection.Connected) then
    Exit;

  GfxRenderers.TbqTagsRenderer.InvalidateRenderers();
  vdtTagsVerses.Invalidate();
  vdtTagsVerses.ReinitNode(vdtTagsVerses.RootNode, true);

end;

function TMainForm.RefBiblesCount: integer;
var
  i, cnt: integer;
begin
  cnt := mFavorites.mModuleEntries.Count - 1;
  Result := 0;
  for i := 0 to cnt do
    if mFavorites.mModuleEntries[i].modType = modtypeBible then
      inc(Result);
end;

procedure TMainForm.pmRefPopup(Sender: TObject);
begin
  if (pgcMain.ActivePage = tbXRef) then
  begin
    miOpenNewView.Visible := true;
    G_XRefVerseCmd := Get_AHREF_VerseCommand(
      bwrXRef.DocumentSource,
      bwrXRef.SectionList.FindSourcePos(bwrXRef.RightMouseClickPos));
  end
  else if (pgcMain.ActivePage = tbSearch) then
  begin
    miOpenNewView.Visible := true;
    G_XRefVerseCmd := Get_AHREF_VerseCommand(
      bwrSearch.DocumentSource,
      bwrSearch.SectionList.FindSourcePos(bwrSearch.RightMouseClickPos));
  end
  else if (pgcMain.ActivePage = tbDic) then
  begin
    miOpenNewView.Visible := true;
    G_XRefVerseCmd := Get_AHREF_VerseCommand(
      bwrDic.DocumentSource,
      bwrDic.SectionList.FindSourcePos(bwrDic.RightMouseClickPos));
  end
  else
    miOpenNewView.Visible := false;
end;

function TMainForm.ReplaceHotModule(const oldMe, newMe: TModuleEntry): Boolean;
var
  hotMi: TMenuItem;
  ix: integer;
  tabsView: ITabsView;
begin
  Result := true;
  hotMi := FavoriteItemFromModEntry(oldMe);
  if Assigned(hotMi) then
  begin
    hotMi.Caption := newMe.mFullName;
    hotMi.tag := integer(newMe);
  end;

  for tabsView in mTabsViews do
  begin
    ix := FavoriteTabFromModEntry(tabsView, oldMe);
    if ix >= 0 then
    begin
      tabsView.BibleTabs.Tabs[ix] := newMe.VisualSignature();
      tabsView.BibleTabs.Tabs.Objects[ix] := newMe;
    end;
  end;
end;

procedure TMainForm.BookVerseFound(Sender: TObject; NumVersesFound, book, chapter, verse: integer; s: string);
var
  i: integer;
  bible: TBible;
begin
  bible := Sender as TBible;
  if not Assigned(bible) then
    Exit;

  lblSearch.Caption := Format('[%d] %s', [NumVersesFound, bible.FullNames[book]]);

  if s <> '' then
  begin
    s := ParseHTML(s, '');
    if bible.Trait[bqmtStrongs] and (not StrongNumbersOn) then
      s := DeleteStrongNumbers(s);

    StrDeleteFirstNumber(s);

    // color search result!!!
    for i := 0 to SearchWords.Count - 1 do
      StrColorUp(s, SearchWords[i], '<*>', '</*>', chkCase.Checked);

    SearchResults.Add(
      Format('<a href="go %s %d %d %d 0">%s</a> <font face="%s">%s</font><br>',
      [bible.ShortPath, book, chapter, verse,
      bible.ShortPassageSignature(book, chapter, verse, verse),
      bible.fontName, s]));
  end;

  Application.ProcessMessages;
end;

procedure TMainForm.BookChangeModule(Sender: TObject);
var book: TBible;
begin
  book := Sender as TBible;
  if Assigned(book) then
  begin
    cbModules.ItemIndex := cbModules.Items.IndexOf(book.Name);
    UpdateBooksAndChaptersBoxes(book);
    GetBookView(self).tbtnStrongNumbers.Enabled := book.Trait[bqmtStrongs];
    SearchListInit;

    Caption := book.Name + ' — BibleQuote';
  end;
end;

procedure TMainForm.BookSearchComplete(Sender: TObject);
begin
  IsSearching := false;
  SearchTime := GetTickCount - SearchTime;
  lblSearch.Caption := lblSearch.Caption + ' (' + IntToStr(SearchTime) + ')';
  DisplaySearchResults(1);
end;

initialization

DefaultDockTreeClass := TThinCaptionedDockTree;

finalization

end.
