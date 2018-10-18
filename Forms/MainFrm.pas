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
  Engine, MultiLanguage, LinksParserIntf, HTMLEmbedInterfaces,
  MetaFilePrinter, Dict, Vcl.Tabs, System.ImageList, HTMLUn2, FireDAC.DatS,
  TabData, Favorites, ThinCaptionedDockTree,
  Vcl.CaptionedDockTree, LayoutConfig,
  ChromeTabs, ChromeTabsTypes, ChromeTabsUtils, ChromeTabsControls, ChromeTabsClasses,
  ChromeTabsLog, FontManager, BroadcastList;

const

  ZOOMFACTOR = 1.5;
  MAXHISTORY = 100;
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
  TControlProc = reference to procedure (const AControl: TControl);
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
    tbXRef: TTabSheet;
    bwrXRef: THTMLViewer;
    pmRef: TPopupMenu;
    miRefCopy: TMenuItem;
    miRefPrint: TMenuItem;
    pnlComments: TPanel;
    cbComments: TComboBox;
    splMain: TSplitter;
    pmEmpty: TPopupMenu;
    cbDicFilter: TComboBox;
    pnlSelectDic: TPanel;
    cbDic: TComboBox;
    lblDicFoundSeveral: TLabel;
    pnlFindStrongNumber: TPanel;
    trayIcon: TCoolTrayIcon;
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
    tbtnAddBookTab: TToolButton;
    tbtnCloseTab: TToolButton;
    miFileSep2: TMenuItem;
    miNewTab: TMenuItem;
    miCloseTab: TMenuItem;
    tbtnLastSeparator: TToolButton;
    cbLinks: TComboBox;
    miDeteleBibleTab: TMenuItem;
    tbLinksToolBar: TToolBar;
    lblTitle: TLabel;
    lblCopyRightNotice: TLabel;
    miOpenNewView: TMenuItem;
    miChooseSatelliteBible: TMenuItem;
    appEvents: TApplicationEvents;
    tbList: TTabSheet;
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
    pnlStatusBar: TPanel;
    imgLoadProgress: TImage;
    tbtnNewForm: TToolButton;
    tbtnAddMemoTab: TToolButton;
    tbtnAddLibraryTab: TToolButton;
    tbtnAddBookmarksTab: TToolButton;
    tbtnAddSearchTab: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure CopySelectionClick(Sender: TObject);
    procedure tbtnPrintClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OpenButtonClick(Sender: TObject);
    procedure SearchButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
    procedure miStrongClick(Sender: TObject);

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
    procedure lbStrongDblClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure edtDicKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DicLBKeyPress(Sender: TObject; var Key: Char);
    procedure bwrDicMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure bwrXRefHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure miRefPrintClick(Sender: TObject);
    procedure miRefCopyClick(Sender: TObject);
    procedure miNotepadClick(Sender: TObject);
    procedure cbCommentsChange(Sender: TObject);
    procedure cbDicChange(Sender: TObject);
    procedure pgcMainChange(Sender: TObject);
    procedure miDicClick(Sender: TObject);
    procedure miCommentsClick(Sender: TObject);
    procedure miRefFontConfigClick(Sender: TObject);
    procedure miQuickNavClick(Sender: TObject);
    procedure miQuickSearchClick(Sender: TObject);
    procedure tbtnCopyrightClick(Sender: TObject);
    procedure cbDicFilterChange(Sender: TObject);
    procedure bwrStrongHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure pnlFindStrongNumberMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure pnlFindStrongNumberMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure pnlFindStrongNumberClick(Sender: TObject);
    procedure miCopyOptionsClick(Sender: TObject);
    procedure miOptionsClick(Sender: TObject);
    procedure trayIconClick(Sender: TObject);
    procedure SysHotKeyHotKey(Sender: TObject; Index: integer);
    procedure edtDicChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miAddBookTabClick(Sender: TObject);
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
    procedure tbtnDelNodeClick(Sender: TObject);
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

    function CreateNewBookTabInfo(): TBookTabInfo;
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

    procedure bwrDicHotSpotCovered(Sender: TObject; const SRC: string);
    procedure miCloseTabClick(Sender: TObject);
    procedure tbtnNewFormClick(Sender: TObject);

    procedure BookChangeModule(Sender: TObject);
    procedure tbtnAddMemoTabClick(Sender: TObject);
    procedure tbtnAddLibraryTabClick(Sender: TObject);
    procedure tbtnAddBookmarksTabClick(Sender: TObject);
    procedure tbtnAddSearchTabClick(Sender: TObject);
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

    mIcn: TIcon;
    mFavorites: TFavoriteModules;
    mInterfaceLock: Boolean;
    mXRefMisUsed: Boolean;
    hint_expanded: integer; // 0 -not set, 1-short , 2-expanded

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

    StrongHebrew, StrongGreek: TDict;
    StrongsDir: string;

    SatelliteBible: string;

    // FLAGS

    MainFormInitialized: Boolean; // for only one entrance into .FormShow

    PrintFootNote: Boolean;

    MainFormMaximized: Boolean;

    MemosOn: Boolean;

    Memos: TStringList;
    Bookmarks: TBroadcastStringList;

    LastAddress: string;

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
    MainFormLeft, MainFormTop, MainFormWidth, MainFormHeight, MainPagesWidth: integer;

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

    procedure UpdateBookView();
    procedure ClearCopyrights();

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
      state: TBookTabInfoState;
      const Title: string;
      visual: Boolean;
      history: TStrings = nil;
      historyIndex: integer = -1): Boolean;

    procedure OpenOrCreateBookTab(const command: string; const satellite: string; state: TBookTabInfoState);
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

    procedure GoPrevChapter;
    procedure GoNextChapter;

    function TranslateInterface(locFile: string): Boolean;
    function LoadLocalizationFile(locFile: string): boolean;
    function LoadLocalization(): boolean;

    procedure LoadConfiguration;
    procedure SaveConfiguration;
    procedure SetBibleTabsHintsState(showHints: Boolean = true);
    procedure MainMenuInit(cacheupdate: Boolean);
    procedure GoModuleName(s: string; fromBeginning: Boolean = false);

    procedure LanguageMenuClick(Sender: TObject);

    function ChooseColor(color: TColor): TColor;

    procedure HotKeyClick(Sender: TObject);

    function CopyPassage(fromverse, toverse: integer): string;

    procedure DisplayStrongs(num: integer; hebrew: Boolean);
    procedure DisplayDictionary(const s: string);

    procedure ConvertClipboard;

    function DictionaryStartup(maxAdd: integer = maxInt): Boolean;

    procedure ShowXref;
    procedure ShowComments;
    procedure ShowSearchTab();
    procedure ShowTagsTab();
    procedure UpdateUIForType(tabType: TViewTabType);
    procedure EnableBookTools(enable: boolean);

    procedure ModifyControl(const AControl: TControl; const ARef: TControlProc);
    procedure SyncChildrenEnabled(const AControl: TControl);

    // finds the closest match for a word in merged
    // dictionary word list
    function LocateDicItem: integer;

    procedure ShowConfigDialog;
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
    procedure TranslateControl(form: TWinControl; fname: string = '');
    procedure ShowReferenceInfo();
    procedure GoReference();
    function DefaultBookTabState(): TBookTabInfoState;
    procedure CopyVerse();

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

    LibFormWidth := StrToInt(MainCfgIni.SayDefault('LibFormWidth', '400'));
    LibFormHeight := StrToInt(MainCfgIni.SayDefault('LibFormHeight', '600'));
    LibFormTop := StrToInt(MainCfgIni.SayDefault('LibFormTop', '100'));
    LibFormLeft := StrToInt(MainCfgIni.SayDefault('LibFormLeft', '100'));

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

    with bwrDic do
    begin
      DefFontName := MainCfgIni.SayDefault('RefFontName', 'Microsoft Sans Serif');
      DefFontSize := StrToInt(MainCfgIni.SayDefault('RefFontSize', '12'));
      DefFontColor := Hex2Color(MainCfgIni.SayDefault('RefFontColor', Color2Hex(clWindowText)));

      DefBackGround := Hex2Color(MainCfgIni.SayDefault('DefBackground', Color2Hex(clWindow))); // '#EBE8E2'
      DefHotSpotColor := Hex2Color(MainCfgIni.SayDefault('DefHotSpotColor', Color2Hex(clHotLight))); // '#0000FF'
    end;

    with bwrStrong do
    begin
      DefFontName := bwrDic.DefFontName;
      DefFontSize := bwrDic.DefFontSize;
      DefFontColor := bwrDic.DefFontColor;

      DefBackGround := bwrDic.DefBackGround;
      DefHotSpotColor := bwrDic.DefHotSpotColor;
    end;

    with bwrComments do
    begin
      DefFontName := bwrDic.DefFontName;
      DefFontSize := bwrDic.DefFontSize;
      DefFontColor := bwrDic.DefFontColor;

      DefBackGround := bwrDic.DefBackGround;
      DefHotSpotColor := bwrDic.DefHotSpotColor;
    end;

    with bwrXRef do
    begin
      DefFontName := bwrDic.DefFontName;
      DefFontSize := bwrDic.DefFontSize;
      DefFontColor := bwrDic.DefFontColor;

      DefBackGround := bwrDic.DefBackGround;
      DefHotSpotColor := bwrDic.DefHotSpotColor;

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

    LoadMru();

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
begin
  tabsForm := CreateTabsView(GenerateTabsViewName()) as TDockTabsForm;

  tabInfo := CreateNewBookTabInfo();

  mTabsView := tabsForm;
  tabsForm.AddBookTab(tabInfo);

  tabsForm.ManualDock(pnlModules);
  tabsForm.Show;
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
      UpdateBookView();

      // restore active tab state
      tabInfo := tabsForm.GetActiveTabInfo();
      if Assigned(tabInfo) then
        tabInfo.RestoreState(tabsForm);

      UpdateUIForType(tabInfo.GetViewType);
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

    mBqEngine.LoadDictionaries(TPath.Combine(LibraryDirectory, C_DictionariesSubDirectory), foreground);
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

  // TODO: Save search requests
//  mi := TMemIniFile.Create(UserDir + 'mru.lst', TEncoding.UTF8);
//  mi.Clear();
//  try
//
//    WriteLst(cbSearch.Items, cbSearch.Name);
//    WriteLst(mslSearchBooksCache, 'SearchBooks');
//    mi.UpdateFile();
//  finally
//    mi.Free();
//  end;

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
  // TODO: Load search requests
//  mi := TMemIniFile.Create(UserDir + 'mru.lst', TEncoding.UTF8);
//  sl := TStringList.Create();
//  sectionVals := TStringList.Create();
//  try
//
//    LoadLst(cbSearch.Items, cbSearch.Name);
//    LoadLst(mslSearchBooksCache, 'SearchBooks');
//
//  finally
//    mi.Free();
//    sl.Free();
//    sectionVals.Free();
//  end;

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
  location, secondBible, Title: string;
  addTabResult, firstTabInitialized: Boolean;
  tabViewState: TBookTabInfoState;
  layoutConfig: TLayoutConfig;
  tabSettings: TTabSettings;
  tabsViewSettings: TTabsViewSettings;
  tabsForm: TDockTabsForm;
  fileStream: TFileStream;
  tabsConfigPath, layoutConfigPath: string;
  tabState: UInt64;
  bookTabSettings: TBookTabSettings;
  history: TStrings;
begin
  tabsConfigPath := UserDir + 'tabs_config.json';
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
    for tabsViewSettings in layoutConfig.TabsViewList do
    begin
      activeTabIx := -1;
      tabIx := 0;
      i := 0;

      tabsForm := CreateTabsView(tabsViewSettings.ViewName) as TDockTabsForm;

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

      for tabSettings in tabsViewSettings.GetOrderedTabSettings() do
      begin
        if (tabSettings.Active) then
          activeTabIx := i;

        addTabResult := false;
        if (tabSettings is TBookTabSettings) then
        begin
          bookTabSettings := TBookTabSettings(tabSettings);

          secondBible := bookTabSettings.SecondBible;
          Title := bookTabSettings.Title;
          tabState := bookTabSettings.OptionsState;
          if (tabState <= 0) then
            tabState := 101;

          tabViewState := DecodeBookTabState(tabState);

          location := bookTabSettings.Location;
          history := TStringList.Create;

          if (bookTabSettings.History.Length > 0) then
          begin
            history.Delimiter := '|';
            history.DelimitedText := bookTabSettings.History;
          end;

          addTabResult := NewBookTab(location, secondBible, tabViewState, Title, (tabIx = activeTabIx) or ((Length(Title) = 0)), history, bookTabSettings.HistoryIndex);
        end
        else if (tabSettings is TMemoTabSettings) then
        begin
          mTabsView.AddMemoTab(TMemoTabInfo.Create());
          addTabResult := true;
        end
        else if (tabSettings is TLibraryTabSettings) then
        begin
          mTabsView.AddLibraryTab(TLibraryTabInfo.Create());
          addTabResult := true;
        end
        else if (tabSettings is TBookmarksTabSettings) then
        begin
          mTabsView.AddBookmarksTab(TBookmarksTabInfo.Create());
          addTabResult := true;
        end
        else if (tabSettings is TSearchTabSettings) then
        begin
          mTabsView.AddSearchTab(TSearchTabInfo.Create(TSearchTabSettings(tabSettings)));
          addTabResult := true;
        end;

        firstTabInitialized := true;
        if (addTabResult) then
          inc(tabIx);

        inc(i);
      end;

      if (activeTabIx < 0) or (activeTabIx >= mTabsView.ChromeTabs.Tabs.Count) then
          activeTabIx := 0;

      mTabsView.ChromeTabs.ActiveTabIndex := activeTabIx;
      mTabsView.UpdateBookView();
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

function TMainForm.CreateNewBookTabInfo(): TBookTabInfo;
var
  book: TBible;
  tabInfo: TBookTabInfo;
begin
  book := CreateNewBibleInstance();

  tabInfo := TBookTabInfo.Create(book, '', SatelliteBible, '', DefaultBookTabState());
  tabInfo.SecondBible := TBible.Create(self);
  tabInfo.ReferenceBible := TBible.Create(self);

  Result := tabInfo;
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

    ini.Learn('DefFontName', mBrowserDefaultFontName);
    ini.Learn('DefFontSize', IntToStr(mTabsView.Browser.DefFontSize));

    if (Color2Hex(mTabsView.Browser.DefFontColor) <> Color2Hex(clWindowText)) then
      ini.Learn('DefFontColor', Color2Hex(mTabsView.Browser.DefFontColor));

    if (g_VerseBkHlColor <> Color2Hex(clHighlight)) then
      ini.Learn('VerseBkHLColor', g_VerseBkHlColor);

    ini.Learn('RefFontName', bwrDic.DefFontName);
    ini.Learn('RefFontSize', IntToStr(bwrDic.DefFontSize));

    ini.Learn('LibFormWidth', LibFormWidth);
    ini.Learn('LibFormHeight', LibFormHeight);
    ini.Learn('LibFormTop', LibFormTop);
    ini.Learn('LibFormLeft', LibFormLeft);

    if (Color2Hex(bwrDic.DefFontColor) <> Color2Hex(clWindowText)) then
      ini.Learn('RefFontColor', Color2Hex(bwrDic.DefFontColor));

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
    ini.Learn(C_opt_FullContextLinks, ord(mFlagFullcontextLinks));
    ini.Learn(C_opt_HighlightVerseHits, ord(mFlagHighlightVerses));
    try
      if (not FileExists(ini.inifile)) or
        (FileGetAttr(ini.inifile) and faReadOnly <> faReadOnly) then
        ini.SaveToFile;
    finally
      ini.Destroy;
    end;

    try
      fname := UserDir + 'bibleqt_bookmarks.ini';
      if (not FileExists(fname)) or (FileGetAttr(fname) and faReadOnly <> faReadOnly) then
        Bookmarks.SaveToFile(fname, TEncoding.UTF8);
    except
      on E: Exception do
        BqShowException(E)
    end;
    try
      fname := UserDir + 'UserMemos.mls';
      if (not FileExists(fname)) or (FileGetAttr(fname) and faReadOnly <> faReadOnly) then
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

procedure TMainForm.SaveTabsViews();
var
  tabCount, i: integer;
  tabInfo, activeTabInfo: IViewTabInfo;
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

      if (tabsView.ChromeTabs.Tabs.Count = 0) then
        continue;

      tabCount := tabsView.ChromeTabs.Tabs.Count;

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

      for i := 0 to tabCount - 1 do
      begin
        try
          data := tabsView.ChromeTabs.Tabs[i].Data;
          if not Supports(data, IViewTabInfo, tabInfo) then
            continue;

          tabSettings := tabInfo.GetSettings;

          if tabInfo = activeTabInfo then
          begin
            tabSettings.Active := true;
          end;
          tabSettings.Index := i;
          tabsViewSettings.AddTabSettings(tabSettings);
        except
        end;
      end; // for
      layoutConfig.TabsViewList.Add(tabsViewSettings);
    end;

    layoutConfig.Save(UserDir + 'tabs_config.json');

    fileStream := TFileStream.Create(UserDir + 'layout_forms.dat', fmCreate);
    pnlModules.DockManager.SaveToStream(fileStream);
    fileStream.Free;

  except
    on E: Exception do
      BqShowException(E)
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
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

  Memos := TStringList.Create;
  Memos.Sorted := true;

  MemosOn := false;

  Bookmarks := TBroadcastStringList.Create;

  pgcMain.ActivePage := tbDic;

  // LOADING CONFIGURATION
  LoadConfiguration;

  if MainPagesWidth <> 0 then
    pgcMain.Width := MainPagesWidth;

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

  LoadLocalization();

  MainMenuInit(false);

  LoadTabsViews();
  LoadHotModulesConfig();

  StrongsDir := C_StrongsSubDirectory;
  LoadFontFromFolder(TPath.Combine(LibraryDirectory, StrongsDir));

  mTranslated := TranslateInterface(LastLanguageFile);

  StrongHebrew := TDict.Create;
  StrongGreek := TDict.Create;

  pgcMainChange(self);

  Application.OnIdle := self.Idle;
  Application.OnActivate := self.OnActivate;
  Application.OnDeactivate := self.OnDeactivate;
  vstDicList.DefaultNodeHeight := Canvas.TextHeight('X');
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

  bookView.UpdateModuleTreeSelection(bookView.BookTabInfo.Bible);

  if not pgcMain.Visible then
    tbtnToggle.Click;

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

  if not Assigned(bookView.BookTabInfo) then
    Exit;

  with bookView.BookTabInfo.Bible do
    if CurChapter > 1 then
      cmd := Format('go %s %d %d', [ShortPath, CurBook, CurChapter - 1])
    else if CurBook > 1 then
      cmd := Format('go %s %d %d', [ShortPath, CurBook - 1, ChapterQtys[CurBook - 1]]);

  bookView.ProcessCommand(bookView.BookTabInfo, cmd, hlFalse, true);

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

  if not Assigned(bookView.BookTabInfo) then
    Exit;

  with bookView.BookTabInfo.Bible do
    if CurChapter < ChapterQtys[CurBook] then
      cmd := Format('go %s %d %d', [ShortPath, CurBook, CurChapter + 1])
    else if CurBook < BookQty then
      cmd := Format('go %s %d %d', [ShortPath, CurBook + 1, 1]);

  bookView.ProcessCommand(bookView.BookTabInfo, cmd, hlFalse, true);

  // ShowXref;
  tbComments.tag := 0;
  ShowComments;

  Windows.SetFocus(mTabsView.Browser.Handle);
end;

procedure SetButtonHint(aButton: TToolButton; aMenuItem: TMenuItem);
begin
  aButton.Hint := aMenuItem.Caption + ' (' + ShortCutToText(aMenuItem.ShortCut) + ')';
end;

function TMainForm.LoadLocalization(): boolean;
var
  foundmenu: Boolean;
  i: Integer;
  locDirectory: string;
  locFilePath: string;
  loaded: Boolean;
begin
  loaded := false;

  locDirectory := GetLocalizationDirectory();
  locFilePath := TPath.Combine(locDirectory, LastLanguageFile);

  if (LastLanguageFile <> '') and (TFile.Exists(locFilePath)) then
    loaded := LoadLocalizationFile(LastLanguageFile);

  if (not loaded) then
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
      loaded := LoadLocalizationFile(DefaultLanguageFile);
    end;

    if (not loaded) and (miLanguage.Count > 0) then
    begin
      LastLanguageFile := miLanguage.Items[miLanguage.Count - 1].Caption + '.lng';

      loaded := LoadLocalizationFile(LastLanguageFile);
    end;

  end;

  Result := loaded;
end;

function TMainForm.LoadLocalizationFile(locFile: string): boolean;
var
  locDirectory: string;
  locFilePath: string;
begin
  Result := false;
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
end;

function TMainForm.TranslateInterface(locFile: string): Boolean;
var
  i: integer;
  s: string;
  fnt: TFont;
  tabsView: ITabsView;
  tabsForm: TDockTabsForm;
  bookView: TBookFrame;
begin
  result := LoadLocalizationFile(locFile);

  if not result then
    Exit;

  UpdateDictionariesCombo();

  TranslateControl(ExceptionForm);
  TranslateControl(AboutForm);

  for tabsView in mTabsViews do
  begin
    if (tabsView is TDockTabsForm) then
    begin
      tabsForm := tabsView as TDockTabsForm;
      tabsForm.Translate;
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
  SetButtonHint(tbtnAddBookTab, miNewTab);
  SetButtonHint(tbtnCloseTab, miCloseTab);

  bookView.tbtnMemos.Hint := bookView.miMemosToggle.Caption + ' (' + ShortCutToText(bookView.miMemosToggle.ShortCut) + ')';

  if Lang.Say('HelpFileName') <> 'HelpFileName' then
    HelpFileName := Lang.Say('HelpFileName');

  Application.Title := MainForm.Caption;
  trayIcon.Hint := MainForm.Caption;

  if Assigned(bookView.BookTabInfo) then
  begin
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

      bookView.UpdateModuleTree(bookView.BookTabInfo.Bible);
    end;
  end;

  fnt := TFont.Create;
  fnt.Name := MainForm.Font.Name;
  fnt.Size := MainForm.Font.Size;

  MainForm.Font := fnt;

  Update;
  fnt.Free;

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

  vti.Bible.RecognizeBibleLinks := vtisResolveLinks in state;
  vti.Bible.FuzzyResolve := vtisFuzzyResolveLinks in state;

  mTabsView.ChromeTabs.Tabs[0].Caption := Title;

  if visual then
  begin
    MemosOn := vtisShowNotes in state;
    bookView.SafeProcessCommand(vti, LastAddress, hlDefault);
    UpdateBookView();
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
          GoPrevChapter;
      ord('X'):
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
          if GetTabsView(self).ActiveControl = mTabsView.Browser then
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
      bookView.ProcessCommand(bookView.BookTabInfo, 'file ' + FileName + ' $$$' + FileName, hlDefault);
      InitialDir := ExtractFilePath(FileName);
    end;
  end;
end;

procedure TMainForm.SearchButtonClick(Sender: TObject);
begin
  ShowSearchTab();
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  tabsView: TDockTabsForm;
begin
  if Key = #27 then
  begin
    tabsView := GetTabsView(self);
    Key := #0;
    if not tabsView.pnlMain.Visible then
      miPrintPreview.Click; // this turns preview off
    Exit;
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

procedure TMainForm.tbtnAddLibraryTabClick(Sender: TObject);
var
  newTabInfo: TLibraryTabInfo;
begin
  newTabInfo := TLibraryTabInfo.Create();
  mTabsView.AddLibraryTab(newTabInfo);
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

    // TODO: change font of all search tabs
//    browserpos := bwrSearch.Position and $FFFF0000;
//    bwrSearch.DefFontSize := defFontSz;
//    bwrSearch.LoadFromString(bwrSearch.DocumentSource);
//    bwrSearch.Position := browserpos;

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
    //self.UpdateUI();
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
    FreeAndNil(StrongHebrew);
    FreeAndNil(StrongGreek);
    FreeAndNil(PasswordPolicy);
    FreeAndNil(mModules);
    FreeAndNil(mFavorites);

    cleanUpInstalledFonts();

    if Assigned(SysHotKey) then
      SysHotKey.Active := false;
    FreeAndNil(SysHotKey);
  except
  end;
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
      self.UpdateBookView();
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
    shfOP.pTo := Pointer(CompressedModulesDirectory() + '\' + ExtractFileName(path) + #0);
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

procedure TMainForm.GoModuleName(s: string; fromBeginning: Boolean = false);
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
    g_ExceptionContext.Add('In GoModuleName: cannot find specified module name:' + s);
    raise Exception.Create('Exception mModules.FindByName failed!');
  end;
  me := mModules.Items[i];

  hlVerses := hlFalse;
  bookView := GetBookView(self);
  bookTabInfo := bookView.BookTabInfo;
  if Assigned(bookTabInfo) then
  begin
    bible := bookTabInfo.Bible;
  end
  else
  begin
    bookTabInfo := CreateNewBookTabInfo();
    NewBookTab(bookTabInfo.Location, bookTabInfo.SatelliteName, bookTabInfo.State, '', false);

    bookTabInfo := bookView.BookTabInfo;
    bible := bookTabInfo.Bible;

    bookView.AdjustBibleTabs(bible.ShortName);
  end;

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

  if tempBook.isBible and wasBible and not fromBeginning then
  begin
    R := tempBook.InternalToReference(obl, bl);
    if R <= -2 then
      hlVerses := hlFalse;
    try
      if (bookTabInfo.FirstVisiblePara > 0) and (bookTabInfo.FirstVisiblePara < bible.verseCount()) then
        firstVisibleVerse := bookTabInfo.FirstVisiblePara
      else
        firstVisibleVerse := -1;
      bookView.ProcessCommand(bookTabInfo, bl.ToCommand(TPath.Combine(commentpath, tempBook.ShortPath)), hlVerses);
      if firstVisibleVerse > 0 then
      begin
        mTabsView.Browser.PositionTo('bqverse' + IntToStr(firstVisibleVerse), false);
      end;
    except
    end;
  end // both previous and current are bibles
  else
  begin
    bookView.SafeProcessCommand(bookTabInfo, 'go ' + TPath.Combine(commentpath, tempBook.ShortPath) + ' 1 1 0', hlFalse);
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
        tbtnAddLibraryTabClick(self); // G key
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

    if Assigned(bookView) and Assigned(bookView.BookTabInfo) then
      bookView.ProcessCommand(bookView.BookTabInfo, bookView.BookTabInfo.Location, TbqHLVerseOption(ord(bookView.BookTabInfo[vtisHighLightVerses])));
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

  // TODO: update background of all search tabs
  //bwrSearch.DefBackGround := newColor;
  //bwrSearch.Refresh;

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

  bookView.ProcessCommand(bookTabInfo, bookTabInfo.Location, TbqHLVerseOption(ord(bookTabInfo[vtisHighLightVerses])));

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

  // TODO: update hot spot color of all search tabs
  //bwrSearch.DefHotSpotColor := newColor;
  //bwrSearch.Refresh;

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
  bookTabInfo: TBookTabInfo;
begin
  bookTabInfo := GetBookView(self).BookTabInfo;
  bible := bookTabInfo.Bible;

  Result := '';
  for i := fromverse to toverse do
  begin
    s := bible.Verses[i - 1];
    StrDeleteFirstNumber(s);

    if bible.Trait[bqmtStrongs] and not (vtisShowStrongs in bookTabInfo.State) then
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

  path := TPath.Combine(LibraryDirectory, C_TSKSubDirectory);
  path := TPath.Combine(path, s + '_*.ini');

  if FindFirst(path, faAnyFile, tf) <> 0 then
    Exit;

  ti := TMultiLanguage.Create(nil);

  path := TPath.Combine(LibraryDirectory, C_TSKSubDirectory);
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

procedure TMainForm.tbtnAddSearchTabClick(Sender: TObject);
var
  newTabInfo: TSearchTabInfo;
begin
  newTabInfo := TSearchTabInfo.Create();
  mTabsView.AddSearchTab(newTabInfo);
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

  fullDir := TPath.Combine(LibraryDirectory, StrongsDir);

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

procedure TMainForm.miShowSignaturesClick(Sender: TObject);
var
  bookView: TBookFrame;
  vti: TBookTabInfo;
  savePosition: integer;
begin
  miShowSignatures.Checked := not miShowSignatures.Checked;

  bookView := GetBookView(self);
  vti := bookView.BookTabInfo;
  vti[vtisShowStrongs] := miShowSignatures.Checked;
  savePosition := mTabsView.Browser.Position;
  bookView.ProcessCommand(vti, vti.Location, TbqHLVerseOption(ord(vti[vtisHighLightVerses])));
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

  if not (vtisShowStrongs in bookTabInfo.State) then
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

    if not (vtisShowStrongs in bookTabInfo.State) then
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

  tbLinksToolBar.Visible := false;

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
    bookView.ProcessCommand(bookView.BookTabInfo, Format('go %s %d %d %d %d', [bible.ShortPath, book, chapter, fromverse, toverse]), hlDefault)
  else
    bookView.ProcessCommand(bookView.BookTabInfo, bookView.tedtReference.Text, hlDefault);
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
  bookView.ProcessCommand(bookTabInfo, bookTabInfo.Location, TbqHLVerseOption(ord(bookTabInfo[vtisHighLightVerses])));
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
  prefBible := '';
  bookView := GetBookView(self);
  if Assigned(bookView) and Assigned(bookView.BookTabInfo) then
  begin
    bible := bookView.BookTabInfo.Bible;
    if bible.isBible then
      prefBible := bible.ShortPath
    else
      prefBible := '';
  end;

  cmd := SRC;
  Handled := true;
  autoCmd := Pos(C__bqAutoBible, cmd) <> 0;
  if autoCmd then
  begin
    status := bookView.PreProcessAutoCommand(bookView.BookTabInfo, cmd, prefBible, ConcreteCmd);
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
      bookView.ProcessCommand(bookView.BookTabInfo, ConcreteCmd, hlDefault)
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
    status := bookView.PreProcessAutoCommand(bookView.BookTabInfo, cmd, prefBible, ConcreteCmd);
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
      bookView.ProcessCommand(bookView.BookTabInfo, ConcreteCmd, hlDefault)
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

procedure TMainForm.tbtnResolveLinksClick(Sender: TObject);
begin
  miRecognizeBibleLinks.Click();
end;

procedure TMainForm.tbtnToggleClick(Sender: TObject);
begin
  pgcMain.Visible := not pgcMain.Visible;
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
      bookView.SafeProcessCommand(bookView.BookTabInfo, Format('go %s %d %d %d %d', [bible.ShortPath, book, chapter, fromverse, toverse]), hlDefault)
    else
      bookView.SafeProcessCommand(bookView.BookTabInfo, bookView.tedtReference.Text, hlDefault);
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

    NewBookTab(wsrc, satBible, ti.State, '', true)

  end
  else
    bookView.ProcessCommand(bookView.BookTabInfo, wsrc, hlDefault);

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
    bookView.SafeProcessCommand(vti, vti.Location, TbqHLVerseOption(ord(vti[vtisHighLightVerses])));
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

procedure TMainForm.tbtnAddBookmarksTabClick(Sender: TObject);
var
  newTabInfo: TBookmarksTabInfo;
begin
  newTabInfo := TBookmarksTabInfo.Create();
  mTabsView.AddBookmarksTab(newTabInfo);
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

  mTabsView := tabsForm;

  tabsForm.BibleTabs.Tabs.Clear();
  tabsForm.BibleTabs.Tabs.Add('***');
  for I := 0 to mFavorites.mModuleEntries.Count - 1 do
  begin
    tabsForm.BibleTabs.Tabs.Insert(I, mFavorites.mModuleEntries[I].VisualSignature());
    tabsForm.BibleTabs.Tabs.Objects[I] := mFavorites.mModuleEntries[I];
  end;

  tabsForm.Translate;
  tabsForm.ManualDock(pnlModules);
  tabsForm.Show;

  Windows.SetFocus(tabsForm.Handle);

  if not Assigned(bookTabInfo) then
  begin
    bookTabInfo := CreateNewBookTabInfo();
  end;

  if Assigned(bookTabInfo) then
  begin
    NewBookTab(bookTabInfo.Location, bookTabInfo.SatelliteName, bookTabInfo.State, '', true);
  end;
end;

procedure TMainForm.tbtnAddMemoTabClick(Sender: TObject);
var
  newTabInfo: TMemoTabInfo;
begin
  newTabInfo := TMemoTabInfo.Create();
  mTabsView.AddMemoTab(newTabInfo);
end;

procedure TMainForm.UpdateAllBooks;
var
  moduleEntry: TModuleEntry;
begin
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
begin
  try
    if not Assigned(mModules) then
      mModules := TCachedModules.Create(true);
    mModules.Assign(mModuleLoader.CachedModules);

    Result := true;
    mDefaultLocation := DefaultLocation();
  except
    Result := false;
  end;
end;

procedure TMainForm.ClearCopyrights();
begin
  lblTitle.Caption := '';
  lblCopyRightNotice.Caption := '';
  tbtnCopyright.Hint := '';
end;

procedure TMainForm.UpdateBookView();
var
  tabInfo: TBookTabInfo;
  i: integer;
  bookView: TBookFrame;
begin
  mInterfaceLock := true;
  mScrollAcc := 0;
  try
    bookView := GetBookView(self);
    if not Assigned(bookView) then
      Exit;

    tabInfo := bookView.BookTabInfo;
    if not Assigned(tabInfo) then
      Exit;

    bookView.AdjustBibleTabs(tabInfo.Bible.ShortName);
    miStrong.Checked := tabInfo[vtisShowStrongs];
    bookView.tbtnStrongNumbers.Down := tabInfo[vtisShowStrongs];
    bookView.tbtnSatellite.Down := (Length(tabInfo.SatelliteName) > 0) and (tabInfo.SatelliteName <> '------');

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
      try
        bookView.LoadSecondBookByName(tabInfo.SatelliteName);
      except
        on E: Exception do
          BqShowException(E);
      end;
    end;

    bookView.UpdateModuleTree(tabInfo.Bible); // fill lists
    bookView.HistoryClear();
    bookView.UpdateHistory();

    lblTitle.Font.Name := tabInfo.TitleFont;
    lblTitle.Caption := tabInfo.TitleLocation;
    lblCopyRightNotice.Caption := tabInfo.CopyrightNotice;

    if tabInfo[vtisPendingReload] then
    begin
      tabInfo[vtisPendingReload] := false;
      bookView.SafeProcessCommand(tabInfo, tabInfo.Location, TbqHLVerseOption(ord(tabInfo[vtisHighLightVerses])));
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
    if not Assigned(bookTabInfo) then
      Exit;

    bible := bookTabInfo.Bible;
    if not Assigned(bible) then
      Exit;

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
  bookView: TBookFrame;
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

  bookView := GetBookView(self);
  bookView.ProcessCommand(bookView.BookTabInfo, ble.ToCommand(), hlTrue);
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

procedure TMainForm.miNotepadClick(Sender: TObject);
begin
  if not pgcMain.Visible then
    tbtnToggle.Click;
  tbtnAddMemoTabClick(self);
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
  if not Assigned(bookTabInfo) then
    Exit;
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

procedure TMainForm.cbTagsFilterChange(Sender: TObject);
var
  timer: TTimer;
begin
  timer := GetTagFilterTimer();
  timer.Enabled := true;
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

procedure TMainForm.OpenOrCreateBookTab(const command: string; const satellite: string; state: TBookTabInfoState);
var
  i: integer;
  tabInfo: IViewTabInfo;
  bookTabInfo: TBookTabInfo;
  bookView: TBookFrame;
  wasUpdateSet: boolean;
  srcPath, dstPath: string;
  link: TBibleLink;
begin
  ClearVolatileStateData(state);

  // get module path from the target command
  link.FromBqStringLocation(command, srcPath);

  for i := 0 to mTabsView.ChromeTabs.Tabs.Count - 1 do
  begin
    tabInfo := mTabsView.GetTabInfo(i);
    if not (tabInfo is TBookTabInfo) then
      continue;

    bookTabInfo := TBookTabInfo(tabInfo);

    // get module path from the tab's command
    if (link.FromBqStringLocation(bookTabInfo.Location, dstPath)) then
    begin
      // compare if tab's module path matches to target module path
      if (CompareText(srcPath, dstPath) <> 0) then
        continue; // paths are not equal, skip the tab
    end;

    bookView := GetBookView(self);

    wasUpdateSet := mTabsView.UpdateOnTabChange;
    mTabsView.UpdateOnTabChange := false;
    try
      mTabsView.ChromeTabs.ActiveTabIndex := i;
    finally
      mTabsView.UpdateOnTabChange := wasUpdateSet;
    end;

    MemosOn := vtisShowNotes in state;

    bookView.SafeProcessCommand(bookTabInfo, command, hlDefault);
    mTabsView.UpdateCurrentTabContent;
    Exit;
  end;

  // no matching tab found, open new tab
  NewBookTab(command, satellite, state, '', true);
end;

function TMainForm.NewBookTab(
  const command: string;
  const satellite: string;
  state: TBookTabInfoState;
  const Title: string;
  visual: Boolean;
  history: TStrings = nil;
  historyIndex: integer = -1): Boolean;
var
  curTabInfo, newTabInfo: TBookTabInfo;
  newBible: TBible;
  bookView: TBookFrame;
  cmd: string;
begin
  newBible := nil;
  ClearVolatileStateData(state);
  Result := true;
  try
    newBible := CreateNewBibleInstance();
    if not Assigned(newBible) then
      abort;

    bookView := GetBookView(self);
    if (mTabsView.ChromeTabs.ActiveTabIndex >= 0) then
    begin
      // save current tab state
      curTabInfo := bookView.BookTabInfo;
      if (Assigned(curTabInfo)) then
      begin
         curTabInfo.SaveState(GetTabsView(self));
      end;
    end;

    newTabInfo := TBookTabInfo.Create(newBible, command, satellite, Title, state);

    newTabInfo.SecondBible := TBible.Create(self);
    newTabInfo.ReferenceBible := TBible.Create(self);
    newTabInfo.Bible.RecognizeBibleLinks := vtisResolveLinks in state;
    newTabInfo.Bible.FuzzyResolve := vtisFuzzyResolveLinks in state;

    if Assigned(history) then
      newTabInfo.History.AddStrings(history);

    mTabsView.AddBookTab(newTabInfo);

    if visual then
    begin
      mTabsView.ChromeTabs.ActiveTabIndex := mTabsView.ChromeTabs.Tabs.Count - 1;

      MemosOn := vtisShowNotes in state;
      cmd := command;
      if ((newTabInfo.History.Count > historyIndex) and (historyIndex >= 0)) then
        cmd := newTabInfo.History[historyIndex];

      bookView.SafeProcessCommand(newTabInfo, cmd, hlDefault);
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
  end;

  // TODO: review this
  case pgcMain.ActivePageIndex of
    0:
      GetBookView(self).pmMemo.PopupComponent := GetBookView(self).tedtReference;
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
      OnChangeModule := BookChangeModule;
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

procedure TMainForm.miAddBookTabClick(Sender: TObject);
var
  bookTabInfo: TBookTabInfo;
begin
  bookTabInfo := GetBookView(self).BookTabInfo;
  if not Assigned(bookTabInfo) then
  begin
    bookTabInfo := CreateNewBookTabInfo();
  end;

  if (bookTabInfo <> nil) then
  begin
    NewBookTab(bookTabInfo.Location, bookTabInfo.SatelliteName, bookTabInfo.State, '', true);
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
var
  ti: TBookTabInfo;
begin
  ti := GetBookView(self).BookTabInfo;
  if not Assigned(ti) then
    Exit;

  GetBookView(self).SelectSatelliteModule();
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
      if Assigned(bookView.BookTabInfo) then
        bookView.AdjustBibleTabs(bookView.BookTabInfo.Bible.ShortName);
    end;
  except
    on E: Exception do
      BqShowException(E);
  end;
  Result := true;
end;

procedure TMainForm.miRefFontConfigClick(Sender: TObject);
begin
  with FontDialog do
  begin
    Font.Name := bwrDic.DefFontName;
    Font.color := bwrDic.DefFontColor;
    Font.Size := bwrDic.DefFontSize;
  end;

  if FontDialog.Execute then
  begin
    with bwrDic do
    begin
      DefFontName := FontDialog.Font.Name;
      DefFontColor := FontDialog.Font.color;
      DefFontSize := FontDialog.Font.Size;
      LoadFromString(DocumentSource);
    end;

    with bwrDic do
    begin
      DefFontName := bwrDic.DefFontName;
      DefFontColor := bwrDic.DefFontColor;
      DefFontSize := bwrDic.DefFontSize;
      LoadFromString(DocumentSource);
    end;

    with bwrStrong do
    begin
      DefFontName := bwrDic.DefFontName;
      DefFontColor := bwrDic.DefFontColor;
      DefFontSize := bwrDic.DefFontSize;
      LoadFromString(DocumentSource);
    end;

    with bwrXRef do
    begin
      DefFontName := bwrDic.DefFontName;
      DefFontColor := bwrDic.DefFontColor;
      DefFontSize := bwrDic.DefFontSize;
    end;

    with bwrComments do
    begin
      DefFontName := bwrDic.DefFontName;
      DefFontColor := bwrDic.DefFontColor;
      DefFontSize := bwrDic.DefFontSize;
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
var
  bookFrame: TBookFrame;
begin
  InputForm.tag := 0; // use TEdit
  InputForm.Caption := miQuickSearch.Caption;
  InputForm.Font := MainForm.Font;

  if InputForm.ShowModal = mrOk then
  begin
    bookFrame := GetBookView(self);
    if Assigned(bookFrame.BookTabInfo) then
    begin
      bookFrame.NavigateToSearch(InputForm.edtValue.Text);
    end;
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
        ShortPassageSignature(CurBook, CurChapter, CurVerseNumber, CurVerseNumber) + ' ' +
        ShortName + ' ' +
        InputForm.memValue.Text;

    StrReplace(newstring, #13#10, ' ', true);

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

// TODO: search all occurrences of the strong number
//  pgcMain.ActivePage := tbSearch;
//  cbSearch.Text := lbStrong.Items[lbStrong.ItemIndex];
//
//  bible := GetBookView(self).BookTabInfo.Bible;
//  if bible.StrongsPrefixed then
//    cbList.ItemIndex := 0 // full book
//  else
//  begin
//    if Copy(lbStrong.Items[lbStrong.ItemIndex], 1, 1) = 'H' then
//      cbSearch.Text := '0' + Copy(lbStrong.Items[lbStrong.ItemIndex], 2, 100)
//    else if Copy(lbStrong.Items[lbStrong.ItemIndex], 1, 1) = 'G' then
//      cbSearch.Text := Copy(lbStrong.Items[lbStrong.ItemIndex], 2, 100)
//    else
//      cbSearch.Text := lbStrong.Items[lbStrong.ItemIndex];
//
//    if Copy(cbSearch.Text, 1, 1) = '0' then
//      cbList.ItemIndex := 1 // old testament
//    else
//      cbList.ItemIndex := 2; // new testament
//  end;
//
//  chkParts.Checked := true;
//  btnFind.Click;
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
  state: TBookTabInfoState;
  satBible: string;
begin
  G_XRefVerseCmd := Trim(G_XRefVerseCmd);
  addr := G_XRefVerseCmd;
  if Length(addr) <= 0 then
    Exit;
  ti := GetBookView(self).BookTabInfo;
  if Assigned(ti) then
  begin
    satBible := ti.SatelliteName;
    state := ti.State;
  end
  else
  begin
    satBible := '------';
    state := DefaultBookTabState;
  end;

  NewBookTab(addr, satBible, state, '', true);
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
      mFavorites.AddModule(mModules.ResolveModuleByNames(ConfigForm.lbFavourites.Items[i], ''));
    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;
  end;

  SetFavouritesShortcuts();
  bookView := GetBookView(self);
  if Assigned(bookView.BookTabInfo) then
  begin
    bible := bookView.BookTabInfo.Bible;
    bookView.AdjustBibleTabs(bible.ShortName);
  end;

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

procedure TMainForm.ShowQuickSearch;
var bookView: TBookFrame;
begin
  bookView := GetBookView(self);
  if not Assigned(bookView) then
    Exit;

  if not pgcMain.Visible then
    tbtnToggle.Click;

  bookView.ToggleQuickSearchPanel(true);
  try
    FocusControl(bookView.tedtQuickSearch);
  except
  end;
  if Length(bookView.tedtQuickSearch.Text) > 0 then
    bookView.tedtQuickSearch.SelectAll();
end;

procedure TMainForm.ShowSearchTab;
var
  newTabInfo: TSearchTabInfo;
begin
  newTabInfo := TSearchTabInfo.Create();
  mTabsView.AddSearchTab(newTabInfo);
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

  if (cbTagsFilter.Enabled) then
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
    signature := ShortPassageSignature(CurBook, CurChapter, CurVerseNumber, CurVerseNumber) + ' ' + ShortName + ' $$$';

  // search for 'Быт.1:1 RST $$$' in Memos.
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
// TODO: figure out this
//  else if (pgcMain.ActivePage = tbSearch) then
//  begin
//    miOpenNewView.Visible := true;
//    G_XRefVerseCmd := Get_AHREF_VerseCommand(
//      bwrSearch.DocumentSource,
//      bwrSearch.SectionList.FindSourcePos(bwrSearch.RightMouseClickPos));
//  end
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

procedure TMainForm.BookChangeModule(Sender: TObject);
var
  book: TBible;
  bookView: TBookFrame;
begin
  book := Sender as TBible;
  if Assigned(book) then
  begin
    bookView := GetBookView(self);
    bookView.UpdateModuleTree(book);

    bookView.tbtnStrongNumbers.Enabled := book.Trait[bqmtStrongs];

    Caption := book.Name + ' — BibleQuote';
  end;
end;

procedure TMainForm.UpdateUIForType(tabType: TViewTabType);
begin
  case tabType of
    vttBook: begin
      EnableBookTools(true);
    end;
    vttMemo: begin
      EnableBookTools(false);
    end;
    vttLibrary: begin
      EnableBookTools(false);
    end;
    vttBookmarks: begin
      EnableBookTools(false);
    end;
    vttSearch: begin
      EnableBookTools(false);
    end;
  end;
end;

procedure TMainForm.EnableBookTools(enable: boolean);
begin
  tbList.Enabled := enable;
  SyncChildrenEnabled(tbList);

  tbXRef.Enabled := enable;
  SyncChildrenEnabled(tbXRef);

  tbStrong.Enabled := enable;
  SyncChildrenEnabled(tbStrong);

  tbComments.Enabled := enable;
  SyncChildrenEnabled(tbComments);

  miOpenPassage.Enabled := enable;
  miQuickNav.Enabled := enable;
  miStrong.Enabled := enable;
  miQuickSearch.Enabled := enable;
  miXref.Enabled := enable;
  miRecognizeBibleLinks.Enabled := enable;
  miShowSignatures.Enabled := enable;
  miCopy.Enabled := enable;
  miSound.Enabled := enable;

  tbtnSound.Enabled := enable;
  tbtnCopyright.Enabled := enable;
  miChooseSatelliteBible.Enabled := enable;
  tbtnResolveLinks.Enabled := enable;

  miPrint.Enabled := enable;
  tbtnPrint.Enabled := enable;

  miPrintPreview.Enabled := enable;
  tbtnPreview.Enabled := enable;
end;

procedure TMainForm.ModifyControl(const AControl: TControl; const ARef: TControlProc);
var
  i : Integer;
begin
  if AControl = nil then
    Exit;

  if AControl is TWinControl then begin
    for i := 0 to TWinControl(AControl).ControlCount - 1 do
      ModifyControl(TWinControl(AControl).Controls[i], ARef);
  end;
  ARef(AControl);
end;

procedure TMainForm.SyncChildrenEnabled(const AControl: TControl);
begin
  ModifyControl(AControl,
    procedure (const AChildControl: TControl)
    begin
      AChildControl.Enabled := AControl.Enabled;
    end
  );
end;
initialization

DefaultDockTreeClass := TThinCaptionedDockTree;

finalization

end.
