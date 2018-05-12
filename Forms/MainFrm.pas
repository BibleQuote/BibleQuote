{ ***********************************************

  BibleQuote 6.01

  *********************************************** }

// test

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
  Menus, IOUtils, Math,
  ExtCtrls, AppEvnts, ImgList, CoolTrayIcon, Dialogs,
  VirtualTrees, ToolWin, StdCtrls, rkGlassButton, IOProcs,
  Buttons, DockTabSet, Htmlview, SysUtils, SysHot, HTMLViewerSite,
  Bible, BibleQuoteUtils, ICommandProcessor, WinUIServices, TagsDb,
  VdtEditlink, bqGradientPanel, bqClosableTabControl, ModuleProcs,
  Engine, MultiLanguage, LinksParserIntf, MyLibraryFrm, HTMLEmbedInterfaces,
  MetaFilePrinter, Dict, Vcl.Tabs, System.ImageList, HTMLUn2, FireDAC.DatS;

const
  ConstBuildCode: string = '2011.09.08';
  // ConstBuildCode: WideString = '2005.03.25';
  ConstBuildTitle: string = 'BibleQuote 6.0.20110908';
  // ConstBuildTitle: WideString = 'BibleQuote 5.5';
  // ConstBuildTitle: WideString = 'BibleQuote 4.5 A Bible Research Software ';

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
    '<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>' { +
    '<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>' };

  // Skips20 = '<BR>';

  DefaultTextTemplate = '<h1>%HEAD%</h1>' + #13#10#13#10 + '<font size=+1>' +
    #13#10 + '%TEXT%' + #13#10 + '</font>' + #13#10#13#10 + Skips20;

  DefaultSelTextColor = '#FF0000';

  DefaultLanguage = 'Русский';
  DefaultLanguageFile = 'Русский.lng';

type
  TXRef = record
    B, C, V, RB, RC, RV: byte;
  end;

  (* AlekId:Добавлено *)
type
  TViewTabLocType = (vtlUnspecified, vtlModule, vtlFile);

  TViewtabInfoStateEntries = (vtisShowStrongs, vtisShowNotes,
    vtisHighLightVerses, vtisResolveLinks, vtisFuzzyResolveLinks,
    vtisPendingReload);

  TViewtabInfoState = set of TViewtabInfoStateEntries;

  TViewTabBrowserState = class
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

  TViewTabInfo = class
  private

  protected
    mwsLocation, mwsTitleLocation, mwsTitleFont, mwsCopyrightNotice, mwsTitle: string;
    // mBookIx, mChapterIx:integer;
    mBible, mSecondBible: TBible;
    mSatelliteName: string;
    // mShowStrongs, mShowNotes, mResolvelinks: boolean;
    // mReloadNeeded: boolean;
    mFirstVisiblePara, mLastVisiblePara: integer;
    // mHLVerses: boolean;
    mState: TViewtabInfoState;
    mLocationType: TViewTabLocType;
    mBrowserState: TViewTabBrowserState;

    mIsCompareTranslation: Boolean;
    mCompareTranslationText: string;

    procedure SetState(const state: TViewtabInfoState);
    function getStateEntryStatus(stateEntry: TViewtabInfoStateEntries): Boolean; inline;
    procedure setStateEntry(stateEntry: TViewtabInfoStateEntries; value: Boolean);
  public
    property state: TViewtabInfoState read mState write SetState;
    property StateEntryStatus[i: TViewtabInfoStateEntries]: Boolean
      read getStateEntryStatus write setStateEntry; default;
    property FirstVisiblePara: integer read mFirstVisiblePara;

    procedure SaveBrowserState(const aHtmlViewer: THTMLViewer);
    procedure RestoreBrowserState(const aHtmlViewer: THTMLViewer);

    constructor Create(const Bible: TBible;
      const awsLocation: string; const satelliteBibleName: string;
      const Title: string; const state: TViewtabInfoState);

    procedure Init(const Bible: TBible;
      const awsLocation: string; const satelliteBibleName: string;
      const Title: string; const state: TViewtabInfoState);
  end;

  TfnFavouriveAdd = function(const modEntry: TModuleEntry; tag: integer = -1; addBibleTab: Boolean = true): integer of object;
  TfnFavouriveDelete = function(const modEntry: TModuleEntry) : Boolean of object;
  TfnFavouriveReplace = function(const oldMod, newMod: TModuleEntry) : Boolean of object;
  TfnFavouriteInsert = function(newMe: TModuleEntry; ix: integer) : integer of object;
  TfnForceLoadModules = procedure of object;

  TBQFavoriteModules = class
    mModuleEntries: TCachedModules;
    mExpectedCnt: integer;
    mLst: TStringList;
    mfnAddtoIface: TfnFavouriveAdd;
    mfnDelFromIface: TfnFavouriveDelete;
    mfnReplaceInIFace: TfnFavouriveReplace;
    mfnInsertIface: TfnFavouriteInsert;
    mfnForceLoadMods: TfnForceLoadModules;
    procedure SaveModules(const savePath: string);
    procedure LoadModules(modEntries: TCachedModules; const modulePath: string);
    procedure v2Load(modEntries: TCachedModules; const lst: TStringList);
    procedure v1Load(modEntries: TCachedModules; const lst: TStringList);
    function ReadPrefix(const lst: TStringList): integer;
    constructor Create(fnAddToIface: TfnFavouriveAdd;
      fnDelFromIFace: TfnFavouriveDelete; fnReplaceInIface: TfnFavouriveReplace;
      fnInsertIface: TfnFavouriteInsert; forceLoadModules: TfnForceLoadModules);
    destructor Destroy(); override;
    function AddModule(me: TModuleEntry): Boolean;
    function DeleteModule(me: TModuleEntry): Boolean;
    procedure Clear();
    function ReplaceModule(oldMe, newMe: TModuleEntry): Boolean;
    procedure xChg(me1, me2: TModuleEntry);
    function moveItem(me: TModuleEntry; ix: integer): Boolean;

  end;

  TViewTabDragObject = class(TDragObjectEx)
  protected
    mViewTabInfo: TViewTabInfo;
  public
    constructor Create(aViewTabInfo: TViewTabInfo);
    property ViewTabInfo: TViewTabInfo read mViewTabInfo;
  end;

  TbqNavigateResult = (nrSuccess, nrEndVerseErr, nrStartVerseErr, nrChapterErr,
    nrBookErr, nrModuleFail);

  (* AlekId:/Добавлено *)
type
  TMainForm = class(TForm, IBibleQuoteCommandProcessor, IBibleWinUIServices,
    IuiVerseOperations, IVDTInfo)
    OpenDialog: TOpenDialog;
    SaveFileDialog: TSaveDialog;
    pnlMain: TPanel;
    pmBrowser: TPopupMenu;
    PrintDialog: TPrintDialog;
    miCopySelection: TMenuItem;
    ColorDialog: TColorDialog;
    FontDialog: TFontDialog;
    miCopyVerse: TMenuItem;
    lblCtrl1: TLabel;
    miCopyPassage: TMenuItem;
    sbxPreview: TScrollBox;
    pnlContainer: TPanel;
    pnlPage: TPanel;
    pbPreview: TPaintBox;
    N3: TMenuItem;
    miSearchWord: TMenuItem;
    miCompare: TMenuItem;
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
    edtGo: TEdit;
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
    pmMemo: TPopupMenu;
    miMemoCopy: TMenuItem;
    pnlComments: TPanel;
    cbModules: TComboBox;
    cbComments: TComboBox;
    btnSearchOptions: TButton;
    pnlMemo: TPanel;
    lblMemo: TLabel;
    pmHistory: TPopupMenu;
    splMain: TSplitter;
    lbBook: TListBox;
    lbChapter: TListBox;
    btnAddressOK: TButton;
    miMemoPaste: TMenuItem;
    pgcHistoryBookmarks: TPageControl;
    tbHistory: TTabSheet;
    tbBookmarks: TTabSheet;
    lbHistory: TListBox;
    pmEmpty: TPopupMenu;
    miMemoCut: TMenuItem;
    cbDicFilter: TComboBox;
    pnlSelectDic: TPanel;
    cbDic: TComboBox;
    lblDicFoundSeveral: TLabel;
    lbBookmarks: TListBox;
    N2: TMenuItem;
    miAddBookmark: TMenuItem;
    pnlBookmarks: TPanel;
    lblBookmark: TLabel;
    miSearchWindow: TMenuItem;
    pnlFindStrongNumber: TPanel;
    miAddMemo: TMenuItem;
    N4: TMenuItem;
    miMemosToggle: TMenuItem;
    trayIcon: TCoolTrayIcon;
    splGo: TSplitter;
    edtDic: TComboBox;
    mmGeneral: TMainMenu;
    miFile: TMenuItem;
    miActions: TMenuItem;
    miFavorites: TMenuItem;
    miHelpMenu: TMenuItem;
    miLanguage: TMenuItem;
    miWebSites: TMenuItem;
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
    // s: TMenuItem;
    miHelp: TMenuItem;
    miAbout: TMenuItem;
    JCRU_Home: TMenuItem;
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
    tbtnBack: TToolButton;
    tbtnForward: TToolButton;
    tbtnSep02: TToolButton;
    tbtnPrevChapter: TToolButton;
    tbtnNextChapter: TToolButton;
    tbtnSep03: TToolButton;
    tbtnCopy: TToolButton;
    tbtnStrongNumbers: TToolButton;
    tbtnMemos: TToolButton;
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
    mViewTabsPopup: TPopupMenu;
    miNewViewTab: TMenuItem;
    miCloseViewTab: TMenuItem;
    tbtnLastSeparator: TToolButton;
    lblSearch: TLabel;
    cbLinks: TComboBox;
    pgcViewTabs: TClosableTabControl;
    bwrHtml: THTMLViewer;
    miDeteleBibleTab: TMenuItem;
    tbLinksToolBar: TToolBar;
    lblTitle: TLabel;
    lblCopyRightNotice: TLabel;
    miTechnoForum: TMenuItem;
    miOpenNewView: TMenuItem;
    miChooseSatelliteBible: TMenuItem;
    appEvents: TApplicationEvents;
    tbList: TTabSheet;
    miAddBookmarkTagged: TMenuItem;
    miDownloadLatest: TMenuItem;
    tbtnLib: TToolButton;
    pnlPaint: TPanel;
    reClipboard: TRichEdit;
    tlbTags: TToolBar;
    tbtnAddNode: TToolButton;
    tbtnDelNode: TToolButton;
    vdtTagsVerses: TVirtualDrawTree;
    vstDicList: TVirtualStringTree;
    miRecognizeBibleLinks: TMenuItem;
    tbtnResolveLinks: TToolButton;
    miCloseAllOtherTabs: TMenuItem;
    tmCommon: TTimer;
    miVerseHighlightBG: TMenuItem;
    btbtnHelp: TBitBtn;
    ilPictures24: TImageList;
    miMyLibrary: TMenuItem;
    cbTagsFilter: TComboBox;
    btnOnlyMeaningful: TrkGlassButton;
    pmRecLinksOptions: TPopupMenu;
    miStrictLogic: TMenuItem;
    miFuzzyLogic: TMenuItem;
    dtsBible: TDockTabSet;
    imgLoadProgress: TImage;
    tlbResolveLnks: TToolBar;
    tbtnSpace1: TToolButton;
    tbtnSpace2: TToolButton;
    miShowSignatures: TMenuItem;
    miView: TMenuItem;
    tlbViewPage: TToolBar;
    pnlMainView: TPanel;
    pnlViewPageToolbar: TPanel;
    tlbQuickSearch: TToolBar;
    tbtnQuickSearchPrev: TToolButton;
    tedtQuickSearch: TEdit;
    tbtnQuickSearchNext: TToolButton;
    tbtnSep07: TToolButton;
    tbtnQuickSearch: TToolButton;
    tbtnSep08: TToolButton;
    tbtnMatchCase: TToolButton;
    tbtnMatchWholeWord: TToolButton;
    procedure BibleTabsDragDrop(Sender, Source: TObject; X, Y: integer);
    procedure BibleTabsDragOver(Sender, Source: TObject; X, Y: integer;
      state: TDragState; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure CopySelectionClick(Sender: TObject);
    procedure bwrHtmlHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure btnAddressOKClick(Sender: TObject);
    procedure ChapterComboBoxKeyPress(Sender: TObject; var Key: Char);
    procedure tbtnPrintClick(Sender: TObject);
    procedure HistoryButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OpenButtonClick(Sender: TObject);
    procedure SearchButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtGoKeyPress(Sender: TObject; var Key: Char);
    procedure btnFindClick(Sender: TObject);
    procedure MainBookSearchComplete(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtGoDblClick(Sender: TObject);
    procedure edtGoChange(Sender: TObject);
    procedure ChapterComboBoxChange(Sender: TObject);
    procedure bwrHtmlKeyPress(Sender: TObject; var Key: Char);
    procedure miExitClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bwrHtmlKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miFontConfigClick(Sender: TObject);
    procedure miBGConfigClick(Sender: TObject);
    procedure miHrefConfigClick(Sender: TObject);
    procedure miFoundTextConfigClick(Sender: TObject);
    procedure miCopyVerseClick(Sender: TObject);
    procedure pmBrowserPopup(Sender: TObject);

    procedure miXrefClick(Sender: TObject);
    procedure tbtnSoundClick(Sender: TObject);
    procedure miHotkeyClick(Sender: TObject);
    // procedure miAddPassageBookmarkClick(Sender: TObject);
    procedure miDialogFontConfigClick(Sender: TObject);
    procedure miCopyPassageClick(Sender: TObject);

    procedure tbtnPreviewClick(Sender: TObject);
    procedure sbxPreviewResize(Sender: TObject);
    procedure pbPreviewPaint(Sender: TObject);
    procedure pbPreviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);

    {
      procedure BrowserPrintHeader(Sender: TObject; Canvas: TCanvas; NumPage,
      W, H: Integer; var StopPrinting: Boolean);
      procedure BrowserPrintFooter(Sender: TObject; Canvas: TCanvas; NumPage,
      W, H: Integer; var StopPrinting: Boolean);
    }
    procedure MainBookVerseFound(Sender: TObject; NumVersesFound, book, chapter,
      verse: integer; s: string);
    procedure MainBookChangeModule(Sender: TObject);
    procedure bwrHtmlMouseDouble(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure bwrHtmlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    // procedure BookmarkLBKeyDown(Sender: TObject; var Key: Word;
    // Shift: TShiftState);
    procedure miPrintPreviewClick(Sender: TObject);
    procedure lbHistoryDblClick(Sender: TObject);
    procedure miStrongClick(Sender: TObject);

    procedure bwrSearchHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure miSearchWordClick(Sender: TObject);

    procedure miCompareClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbLinksChange(Sender: TObject);
    procedure bwrDicHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure bwrCommentsHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure bwrStrongMouseDouble(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DicLBDblClick(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure edtDicKeyPress(Sender: TObject; var Key: Char);
    procedure edtStrongKeyPress(Sender: TObject; var Key: Char);
    procedure tbtnToggleClick(Sender: TObject);
    procedure cbModulesChange(Sender: TObject);
    procedure lbStrongDblClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure bwrSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bwrSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDicKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tbtnBackClick(Sender: TObject);
    procedure tbtnForwardClick(Sender: TObject);
    procedure DicLBKeyPress(Sender: TObject; var Key: Char);
    procedure bwrDicMouseDouble(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure bwrXRefHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    // procedure BrowserMouseUp(Sender: TObject; Button: TMouseButton;
    // Shift: TShiftState; X, Y: Integer);
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
    procedure miMemoCopyClick(Sender: TObject);
    procedure miNotepadClick(Sender: TObject);
    procedure cbCommentsChange(Sender: TObject);
    procedure miHelpClick(Sender: TObject);
    procedure btnSearchOptionsClick(Sender: TObject);
    procedure chkExactPhraseClick(Sender: TObject);
    procedure cbDicChange(Sender: TObject);
    procedure lbHistoryClick(Sender: TObject);
    procedure tbtnNextChapterClick(Sender: TObject);
    procedure tbtnPrevChapterClick(Sender: TObject);
    procedure pgcMainChange(Sender: TObject);
    // procedure bwrXRefMainHotSpotClick(Sender: TObject;
    // const SRC: string; var Handled: Boolean);
    procedure miDicClick(Sender: TObject);
    procedure miCommentsClick(Sender: TObject);
    procedure lbBookClick(Sender: TObject);
    procedure lbChapterClick(Sender: TObject);
    procedure splMainMoved(Sender: TObject);
    procedure miMemoPasteClick(Sender: TObject);
    procedure cbQtyChange(Sender: TObject);
    procedure miRefFontConfigClick(Sender: TObject);
    procedure miQuickNavClick(Sender: TObject);
    procedure miQuickSearchClick(Sender: TObject);
    procedure tbtnCopyrightClick(Sender: TObject);
    procedure miMemoCutClick(Sender: TObject);
    procedure cbDicFilterChange(Sender: TObject);
    procedure miAddBookmarkClick(Sender: TObject);
    procedure lbBookmarksDblClick(Sender: TObject);
    procedure bwrStrongHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure lbBookmarksClick(Sender: TObject);
    procedure lbBookmarksKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbHistoryKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure miSearchWindowClick(Sender: TObject);
    procedure pnlFindStrongNumberMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure pnlFindStrongNumberMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure pnlFindStrongNumberClick(Sender: TObject);
    procedure miCopyOptionsClick(Sender: TObject);
    procedure miOptionsClick(Sender: TObject);
    procedure miAddMemoClick(Sender: TObject);
    procedure trayIconClick(Sender: TObject);
    procedure SysHotKeyHotKey(Sender: TObject; Index: integer);
    procedure miMemosToggleClick(Sender: TObject);
    procedure btbtnHelpClick(Sender: TObject);
    procedure JCRU_HomeClick(Sender: TObject);
    procedure tbtnMemoPrintClick(Sender: TObject);
    procedure splGoMoved(Sender: TObject);
    procedure tbtnSatelliteClick(Sender: TObject);
    procedure SelectSatelliteBibleByName(const bibleName: string);
    procedure edtDicChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miNewTabClick(Sender: TObject);
    procedure miCloseTabClick(Sender: TObject);
    procedure pgcViewTabsChange(Sender: TObject);
    procedure tbInitialViewPageContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure edtSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pgcViewTabsStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure pgcViewTabsDeleteTab(Sender: TClosableTabControl; Index: integer);
    procedure pgcViewTabsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure dtsBibleDrawTab(Sender: TObject; TabCanvas: TCanvas; R: TRect;
      Index: integer; Selected: Boolean);
    procedure dtsBibleChange(Sender: TObject; NewTab: integer;
      var AllowChange: Boolean);
    procedure dtsBibleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure miDeteleBibleTabClick(Sender: TObject);

    procedure dtsBibleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure dtsBibleMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure FormDeactivate(Sender: TObject);
    procedure bwrHtmlFileBrowse(Sender, Obj: TObject; var s: string);
    procedure bwrHtmlImageRequest(Sender: TObject; const SRC: string;
      var Stream: TMemoryStream);
    procedure cbModulesCloseUp(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbCommentsCloseUp(Sender: TObject);
    procedure bwrHtmlHotSpotCovered(Sender: TObject; const SRC: string);
    procedure bwrHtmlMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: integer; MousePos: TPoint; var Handled: Boolean);
    procedure LoadFontFromFolder(awsFolder: string);
    procedure miOpenNewViewClick(Sender: TObject);
    procedure pmRefPopup(Sender: TObject);
    procedure miChooseSatelliteBibleClick(Sender: TObject);
    procedure bwrHtmlMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure appEventsException(Sender: TObject; E: Exception);
    procedure cbModulesKeyPress(Sender: TObject; var Key: Char);
    procedure InitQNavList();
    procedure miAddBookmarkTaggedClick(Sender: TObject);
    procedure tbtnLibClick(Sender: TObject);
    function NavigateToInterfaceValues(): Boolean;
    procedure pgcMainMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure pgcViewTabsChanging(Sender: TObject; var AllowChange: Boolean);
    procedure tbtnAddTagClick(Sender: TObject);
    procedure vdtTagsVersesMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: integer);
    function PaintTokens(canv: TCanvas; rct: TRect; tkns: TObjectList;
      calc: Boolean): integer;
    procedure vdtTagsVersesDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure pgcViewTabsDragOver(Sender, Source: TObject; X, Y: integer;
      state: TDragState; var Accept: Boolean);
    function LoadAnchor(wb: THTMLViewer; SRC, current, loc: string): Boolean;
    procedure FormDblClick(Sender: TObject);
    procedure dtsBibleClick(Sender: TObject);
    procedure pgcMainMouseLeave(Sender: TObject);
    procedure pgcViewTabsDblClick(Sender: TClosableTabControl; Index: integer);
    procedure miRecognizeBibleLinksClick(Sender: TObject);
    procedure lbBookMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure pgcViewTabsDragDrop(Sender, Source: TObject; X, Y: integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: integer; MousePos: TPoint; var Handled: Boolean);
    procedure miCloseAllOtherTabsClick(Sender: TObject);
    procedure tmCommonTimer(Sender: TObject);
    procedure miVerseHighlightBGClick(Sender: TObject);
    procedure cbListDropDown(Sender: TObject);
    procedure edtGoEnter(Sender: TObject);
    procedure tbtnDelNodeClick(Sender: TObject);
    procedure cbSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vdtTagsVersesCollapsed(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vdtTagsVersesResize(Sender: TObject);
    procedure vdtTagsVersesMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure vdtTagsVersesShowScrollBar(Sender: TBaseVirtualTree; Bar: integer;
      Show: Boolean);
    procedure vdtTagsVersesDblClick(Sender: TObject);
    /// procedure vdtTagsVersesInitChildren(Sender: TBaseVirtualTree;
    // Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vdtTagsVersesInitNode(Sender: TBaseVirtualTree;
      ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure vdtTagsVersesScroll(Sender: TBaseVirtualTree;
      DeltaX, DeltaY: integer);
    procedure vdtTagsVersesStateChange(Sender: TBaseVirtualTree;
      Enter, Leave: TVirtualTreeStates);
    procedure vdtTagsVersesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure vdtTagsVersesCreateEditor(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vdtTagsVersesGetNodeWidth(Sender: TBaseVirtualTree;
      HintCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      var NodeWidth: integer);
    procedure vdtTagsVersesEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    // TODO procedure vdtTagsVersesIncrementalSearch1(Sender: TBaseVirtualTree;
    // Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
    procedure cbTagsFilterChange(Sender: TObject);
    procedure btnOnlyMeaningfulClick(Sender: TObject);
    procedure tbtnResolveLinksClick(Sender: TObject);
    procedure miChooseLogicClick(Sender: TObject);
    procedure pmRecLinksOptionsChange(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure tbtnSatelliteMouseEnter(Sender: TObject);
    procedure imgLoadProgressClick(Sender: TObject);
    procedure cbCommentsDropDown(Sender: TObject);
    procedure vdtTagsVersesCompareNodes(Sender: TBaseVirtualTree;
      Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: integer);
    procedure vstDicListAddToSelection(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure miShowSignaturesClick(Sender: TObject);
    procedure vstDicListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vdtTagsVersesIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: string; var Result: integer);
    procedure tbtnMemosClick(Sender: TObject);
    procedure SetMemosVisible(showMemos: Boolean);

    procedure CompareTranslations();
    procedure DictionariesLoading(Sender: TObject);
    procedure DictionariesLoaded(Sender: TObject);
    procedure ModulesScanDone(Sender: TObject);
    procedure ArchiveModuleLoadFailed(Sender: TObject; E: TBQException);
    procedure pgcViewTabsGetImageIndex(Sender: TObject; TabIndex: Integer; var ImageIndex: Integer);
    procedure tbtnQuickSearchClick(Sender: TObject);
    procedure tbtnQuickSearchPrevClick(Sender: TObject);
    procedure tbtnQuickSearchNextClick(Sender: TObject);

    // procedure tbAddBibleLinkClick(Sender: TObject);
    // procedure vstBooksInitNode(Sender: TBaseVirtualTree; ParentNode,
    // Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    // procedure vstBooksInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode;
    // var ChildCount: Cardinal);
    // procedure vstBooksGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
    // Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    // procedure tbtnAddCategoryClick(Sender: TObject);
    // procedure vstBooksNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
    // Column: TColumnIndex; NewText: WideString);

    // procedure BrowserMouseMove(Sender: TObject; Shift: TShiftState; X,
    // Y: Integer);
    // procedure CommBrowserHotSpotClick(Sender: TObject; const SRC: String;
    // var Handled: Boolean);
  private
    { Private declarations }

    MainBook: TBible;
    SecondBook: TBible;

    SysHotKey: TSysHotKey;

    FCurPreviewPage: integer;
    ZoomIndex: integer;
    Zoom: double;
    { AlekId: добавлено }
    mBrowserDefaultFontName: string;
    mDictionariesFullyInitialized, mTaggedBookmarksLoaded: Boolean;
    mDefaultLocation: string;
    mBibleTabsInCtrlKeyDownState: Boolean;
    mHTMLSelection: string;
    SearchTime: int64;

    mIcn: TIcon;
    mFavorites: TBQFavoriteModules;
    mInterfaceLock: Boolean;
    // mBibleLinkParser:TBibleLinkParser;
    mXRefMisUsed: Boolean;
    // mBibleLinkParserAvail: boolean;
    mlbBooksLastIx: integer;
    mRefenceBible: TBible;
    // mHotBibles: TCachedModules;
    // mFirstVisibleVerse: integer;
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

    // mBibleTabsWideHelper:TWideControlHelper;
    // mBookCategories: TObjectList;
    { AlekId: /добавлено }
    procedure WMQueryEndSession(var Message: TWMQueryEndSession);
      message WM_QUERYENDSESSION;

    procedure DrawMetaFile(PB: TPaintBox; mf: TMetaFile);
    function ProcessCommand(s: string; hlVerses: TbqHLVerseOption): Boolean;
    function CreateNewBibleInstance(aBible: TBible): TBible;
    function GetActiveTabInfo(): TViewTabInfo;
    procedure AdjustBibleTabs(awsNewModuleName: string = '');
    // при перемене модуля: навигация или смена таба
    procedure SafeProcessCommand(wsLocation: string; hlOption: TbqHLVerseOption);
    procedure UpdateUI();
    // function ActiveSatteliteMenu(): TMenuItem;
    // function SelectSatelliteMenuItem(aItem: TMenuItem): TMenuItem;
    procedure SetFirstTabInitialLocation(wsCommand, wsSecondaryView: string;
      const Title: string; state: TViewtabInfoState; visual: Boolean);
    // function SatelliteMenuItemFromModuleName(aName: WideString): TMenuItem;
    procedure SaveTabsToFile(path: string);
    procedure LoadTabsFromFile(path: string);
    function NewViewTab(const command: string; const satellite: string;
      const browserbase: string; state: TViewtabInfoState;
      const Title: string; visual: Boolean): Boolean;
    function FindTaggedTopMenuItem(tag: integer): TMenuItem;

    function LoadDictionaries(foreground: Boolean): Boolean;
    function LoadModules(background: Boolean): Boolean;
    function LoadHotModulesConfig(): Boolean;
    // procedure DeleteInvalidHotModules();
    procedure SaveHotModulesConfig(aMUIEngine: TMultiLanguage);
    function AddHotModule(const modEntry: TModuleEntry; tag: integer;
      addBibleTab: Boolean = true): integer;
    function FavouriteItemFromModEntry(const me: TModuleEntry): TMenuItem;
    function FavouriteTabFromModEntry(const me: TModuleEntry): integer;
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
    // function ModuleIndexByName(const awsModule: Widestring): integer;
    function DefaultLocation(): string;
    // procedure LoadBookNodes();
    // procedure SaveBookNodes();
    function ActivateFont(const fontPath: string): DWORD;
    function PrepareFont(const aFontName, aFontPath: string): Boolean;
    function SuggestFont(const desiredFontName, desiredFontPath: string;
      desiredCharset: integer): string;

    // function NewTab(const location: WideString): boolean;
  type
    TgmtOption = (gmtBulletDelimited, gmtEffectiveAddress, gmtLookupRefBibles);
    TgmtOptions = set of TgmtOption;
  function GetModuleText(cmd: string; out fontName: string; out bl: TBibleLink;
    out txt: string; out passageSignature: string; options: TgmtOptions = [];
    maxWords: integer = 0): integer;
  function RefBiblesCount(): integer;
  function GetRefBible(ix: integer): TModuleEntry;
  procedure FontChanged(delta: integer);
  function DicScrollNode(nd: PVirtualNode): Boolean;
  procedure LoadUserMemos();
  function LoadTaggedBookMarks(): Boolean;
  procedure LoadSecondBookByName(const wsName: string);
  // procedure SetStrongsAndNotesState(showStrongs, showNotes:boolean; ti:TViewTabInfo);
  (* AlekId:/Добавлено *)
  function GoAddress(var book, chapter, fromverse, toverse: integer;
    var hlVerses: TbqHLVerseOption): TbqNavigateResult;
  procedure SearchListInit;

  procedure GoPrevChapter;
  procedure GoNextChapter;

  function TranslateInterface(locFile: string): Boolean;

  procedure LoadConfiguration;
  procedure SaveConfiguration;
  // procedure InitHotModulesConfigPage(refreshModuleList: boolean = false);
  // procedure InitBibleTabs;
  procedure SetBibleTabsHintsState(showHints: Boolean = true);
  procedure MainMenuInit(cacheupdate: Boolean);
  procedure GoModuleName(s: string);

  procedure UpdateBooksAndChaptersBoxes;

  procedure LanguageMenuClick(Sender: TObject);

  function ChooseColor(color: TColor): TColor;
  function LoadBibleToXref(cmd: string; const id: string = ''): Boolean;
  // function LocateMemo(book,chapter,verse: integer; var cursor: integer): boolean;
  // function MainFileExists(s: WideString): WideString;

  procedure HotKeyClick(Sender: TObject);

  function CopyPassage(fromverse, toverse: integer): string;

  procedure GoRandomPlace;
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
  function LocateDicItem: integer;
  // finds the closest match for a word in merged
  // dictionary word list

  procedure ShowConfigDialog;
  procedure ShowQNav(useDisposition: TBQUseDisposition = udMyLibrary);
  procedure ShowQuickSearch();
  procedure SetVScrollTracker(aBrwsr: THTMLViewer);
  procedure VSCrollTracker(Sender: TObject);
  procedure EnableMenus(aEnabled: Boolean);
  function PreProcessAutoCommand(const cmd: string; const prefModule: string;
    out ConcreteCmd: string): HRESULT;
  procedure DeferredReloadViewPages();
  procedure AppOnHintHandler(Sender: TObject);
  procedure TagAdded(tagId: int64; const txt: string; Show: Boolean);
  procedure TagRenamed(tagId: int64; const newTxt: string);
  procedure TagDeleted(id: int64; const txt: string);
  procedure VerseAdded(verseId, tagId: int64; const cmd: string;
    Show: Boolean);
  procedure VerseDeleted(verseId, tagId: int64);
  function GetAutoTxt(const cmd: string; maxWords: integer; out fnt: string;
    out passageSignature: string): string;
  function GetMainWindow(): TForm; // IbibleQuoteWinUIServices
  function GetIViewerBase(): IHtmlViewerBase; // IbibleQuoteWinUIServices

  procedure GetTextInfo(tree: TVirtualDrawTree; Node: PVirtualNode;
    Column: TColumnIndex; const AFont: TFont; var R: TRect;
    var Text: string);
  procedure SetNodeText(tree: TVirtualDrawTree; Node: PVirtualNode;
    Column: TColumnIndex; const Text: string);
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
  procedure TranslateForm(form: TForm);
  procedure ToggleQuickSearchPanel(const enable: Boolean);
  procedure SearchForward();
  procedure SearchBackward();

  public
    mHandCur: TCursor;

    { Public declarations }
    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure SetCurPreviewPage(Val: integer);
    function PassWordFormShowModal(const aModule: WideString; out Pwd: WideString; out savePwd: Boolean): integer;
    function DicSelectedItemIndex(out pn: PVirtualNode): integer; overload;
    function DicSelectedItemIndex(): integer; overload;
    property CurPreviewPage: integer read FCurPreviewPage
      write SetCurPreviewPage;

  end;

const
  oleaut32 = 'oleaut32.dll';
function SysAllocStringLen(psz: PWideChar; len: integer): PWideChar; stdcall;
  external oleaut32 name 'SysAllocString';
procedure SysFreeString(bstr: PWideChar); stdcall;
  external oleaut32 name 'SysFreeString';

var
  MainForm: TMainForm;
  MFPrinter: TMetaFilePrinter;
  G_ControlKeyDown: Boolean;
  LastLanguageFile: string;

implementation

uses jclUnicode, CopyrightFrm, InputFrm, ConfigFrm, PasswordDlg,
  BibleQuoteConfig,
  ExceptionFrm, AboutFrm, ShellAPI,
  StrUtils, CommCtrl,

  HintTools, sevenZipHelper,
  Types, BibleLinkParser, IniFiles, PlainUtils, GfxRenderers, CommandProcessor,
  EngineInterfaces, StringProcs, WCharWindows, LinksParser;

type
  // TModuleType = (modtypeBible, modtypeBook, modtypeComment);
  // TModuleEntry = class
  // wsFullName, wsShortName, wsShortPath, wsFullPath: Widestring;
  // modType: TModuleType;
  // constructor Create(amodType: TModuleType; awsFullName, awsShortName,
  // awsShortPath, awsFullPath: Widestring);overload;
  // constructor Create(me:TModuleEntry);overload;
  // procedure Init(amodType: TModuleType; awsFullName, awsShortName,
  // awsShortPath, awsFullPath: Widestring);
  // procedure Assign(source:TModuleEntry);
  // end;

  TArchivedModules = class
    Names, Paths: TStrings;
    procedure Clear();
    constructor Create();
    destructor Destroy(); override;
    procedure Assign(Source: TArchivedModules);
  end;

var
  // Bibles, Books,
  // Comments, CommentsPaths {,
  // CacheModPaths, CacheDicPaths,
  // CacheModTitles, CacheDicTitles // new for 24.07.2002 - cache for module and dictionary titles}
  // : WideStrings.TWideStringList;                    // global module names
  mModules: TCachedModules;

  { Не найдено ни одного разумного объяснения,
    зачем вместо банальной строки используется
    столь сложный класс, как TStrings.
    Текст из *Source загружается и выгружается
    только целиком, без доступа к конкретным строкам.
    Короче, решено заменить эти переменные на WideString. }
  // BrowserSource: TWideStrings;
  // SearchBrowserSource: TWideStrings;
  // DicBrowserSource: TWideStrings;
  // StrongBrowserSource: TWideStrings;
  // CommentsBrowserSource: TWideStrings;
  // BrowserSource: WideString;
  // SearchBrowserSource: WideString;
  // DicBrowserSource: WideString;
  // StrongBrowserSource: WideString;
  // CommentsBrowserSource: WideString;

  BrowserSearchPosition: Longint;

  BrowserPosition: Longint; // this helps PgUp, PgDn to scroll chapters...
  SearchBrowserPosition: Longint; // list search results pages...
  SearchPage: integer; // what page we are in

  StrongHebrew, StrongGreek: TDict;
  StrongsDir: string;

  // DefaultModule: WideString;
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

  // DefaultEncoding: Integer;

  History: TStrings;
  SearchResults: TStrings;
  SearchWords: TStrings;

  LastSearchResultsPage: integer; // to show/hide page results (Ctrl-F3)

  // ModulesList: TWideStrings;            // list of all available modules -- loaded ONCE
  // ModulesCodeList: TWideStrings;        // codes like KJV, NIV, RST...
  { AlekId: добавлено }
  // S_ArchivedModuleList: TArchivedModules;
  { AlekId:/добавлено }

  HelpFileName: string;

  // TempDir: string; // temporary file storage -- should be emptied on exit
  TemplatePath: string;
  SelTextColor: string; // color strings after search
  g_VerseBkHlColor: string;

  TextTemplate: string; // displaying passages

  PrevButtonHint, NextButtonHint: string;

  { CBPartsCaptions: array[0..1] of WideString;
    CBAllCaptions: array[0..1] of WideString;
    CBPhraseCaptions: array[0..1] of WideString;
    CBCaseCaptions: array[0..1] of WideString; }

  MainShiftState: TShiftState;

  CurVerseNumber, CurSelStart, CurSelEnd: integer;

  CurFromVerse, CurToVerse, VersePosition: integer;
  // positionto(...) when changing modules you need to know which verse it was

  // config
  MainFormLeft, MainFormTop, MainFormWidth, MainFormHeight, MainPagesWidth,
    Panel2Height: integer;

  { MainFormTempHeight: integer; }// AlekId:QA

  // MainBookFontName: WideString;

  miHrefUnderlineChecked, CopyOptionsCopyVerseNumbersChecked,
    CopyOptionsCopyFontParamsChecked, CopyOptionsAddModuleNameChecked,
    CopyOptionsAddReferenceChecked, CopyOptionsAddLineBreaksChecked: Boolean;
  mFlagFullcontextLinks: Boolean;
  mFlagHighlightVerses: Boolean;
  mFlagCommonProfile: Boolean;
  CopyOptionsAddReferenceRadioItemIndex: integer;

  ConfigFormHotKeyChoiceItemIndex: integer;
  (* AlekId:Добавлено *)
  UserDir: string;
  (* AlekId:/Добавлено *)
  PasswordPolicy: TPasswordPolicy;
  tempBook: TBible = nil;
  G_XRefVerseCmd: string;
  (* AlekId:/Добавлено *)
{$R *.DFM}

function GetAppDataFolder: string;
var
  dBuffer: string;
begin
  Result := '';

  SetLength(dBuffer, 1024);
  if not ShlObj.SHGetSpecialFolderPath(0, PChar(dBuffer), CSIDL_APPDATA, false)
  then
    Exit;

  TrimNullTerminatedString(dBuffer);
  if dBuffer = '' then
    Exit;

  if Copy(dBuffer, Length(dBuffer), 1) <> '\' then
    dBuffer := dBuffer + '\';

  Result := dBuffer;
end;

procedure ClearVolatileStateData(var state: TViewtabInfoState);
begin
  state := state * [vtisShowNotes, vtisShowStrongs, vtisResolveLinks,
    vtisFuzzyResolveLinks];
end;

function DefaultViewTabState(): TViewtabInfoState;
begin
  Result := [vtisShowNotes, vtisResolveLinks];
end;

procedure TMainForm.UpdateBooksAndChaptersBoxes();
var
  i: integer;
  offset: integer;
  uifont: string;
begin
  with lbBook do
  begin
    Items.BeginUpdate;
    Items.Clear;
    if (Length(MainBook.DesiredUIFont) > 0) then
    begin
      uifont := SuggestFont(MainBook.DesiredUIFont, MainBook.path, $0007F);
    end
    else
    begin
      uifont := self.Font.Name
    end;

    if lbBook.Font.Name <> uifont then
      lbBook.Font.Name := uifont;

    for i := 1 to MainBook.BookQty do
      Items.Add(MainBook.FullNames[i]);
    Items.EndUpdate;
    ItemIndex := MainBook.CurBook - 1;
  end;
  mlbBooksLastIx := -1;
  if MainBook.BookQty <= 0 then
  begin
    lbChapter.Clear;
    Exit
  end;
  with lbChapter do
  begin
    Items.BeginUpdate;
    Items.Clear;

    offset := 0;
    if MainBook.Trait[bqmtZeroChapter] then
      offset := 1;

    for i := 1 to MainBook.ChapterQtys[lbBook.ItemIndex + 1] do
      Items.Add(IntToStr(i - offset));

    Items.EndUpdate;
    ItemIndex := MainBook.CurChapter - 1;
  end;
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

procedure TMainForm.GoRandomPlace;
var
  book, chapter, verse: integer;
begin
  Randomize();
  book := Random(MainBook.BookQty) + 1;
  // Randomize;// AlekId: ни к чему
  chapter := Random(MainBook.ChapterQtys[book]) + 1;
  // Randomize;// AlekId: ни к чему
  verse := Random(MainBook.CountVerses(book, chapter)) + 1;

  ProcessCommand(Format('go %s %d %d %d', [MainBook.ShortPath, book, chapter, verse]), hlTrue);
end;

procedure TMainForm.HotKeyClick(Sender: TObject);
begin
  GoModuleName((Sender as TMenuItem).Caption);
end;

procedure TMainForm.LoadConfiguration;
var
  fname: string;
  fnt: TFont;
  h: integer;
begin
  try
    UserDir := CreateAndGetConfigFolder;
    try
      PasswordPolicy := TPasswordPolicy.Create
        (UserDir + C_PasswordPolicyFileName);
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

    MainFormWidth := (StrToInt(MainCfgIni.SayDefault('MainFormWidth', '0')) *
      Screen.Width) div MAXWIDTH;
    MainFormHeight := (StrToInt(MainCfgIni.SayDefault('MainFormHeight', '0')) *
      Screen.Height) div MAXHEIGHT;
    MainFormLeft := (StrToInt(MainCfgIni.SayDefault('MainFormLeft', '0')) *
      Screen.Width) div MAXWIDTH;
    MainFormTop := (StrToInt(MainCfgIni.SayDefault('MainFormTop', '0')) *
      Screen.Height) div MAXHEIGHT;
    MainFormMaximized := MainCfgIni.SayDefault('MainFormMaximized', '0') = '1';

    MainPagesWidth := (StrToInt(MainCfgIni.SayDefault('MainPagesWidth', '0')) *
      Screen.Height) div MAXHEIGHT;
    Panel2Height := (StrToInt(MainCfgIni.SayDefault('Panel2Height', '0')) *
      Screen.Height) div MAXHEIGHT;

    fnt := TFont.Create;
    fnt.Name := MainCfgIni.SayDefault('MainFormFontName',
      'Microsoft Sans Serif');
    // fnt.Charset := StrToInt(ini.SayDefault('MainFormFontCharset', '204'));
    fnt.Size := StrToInt(MainCfgIni.SayDefault('MainFormFontSize', '9'));

    miRecognizeBibleLinks.Enabled := true;
    tbtnResolveLinks.Enabled := true;
    MainForm.Font := fnt;

    Screen.HintFont.Assign(fnt);
    Screen.HintFont.Height := Screen.HintFont.Height * 5 div 4;
    Application.HintColor := $FDF9F4;
    dtsBible.Font.Assign(fnt);
    h := fnt.Height;
    if h < 0 then
      h := -h;
    dtsBible.Height := h + 13;
    MainForm.Update;
    fnt.Free;

    Prepare(ExtractFilePath(Application.ExeName) + 'biblebooks.cfg', Output);

    with bwrHtml do
    begin
      DefFontName := MainCfgIni.SayDefault('DefFontName', 'Microsoft Sans Serif');
      mBrowserDefaultFontName := DefFontName;
      DefFontSize := StrToInt(MainCfgIni.SayDefault('DefFontSize', '12'));
      DefFontColor := Hex2Color(MainCfgIni.SayDefault('DefFontColor',
        Color2Hex(clWindowText))); // '#000000'

      // ShowMessage(IntToStr(ColorToRGB(clWindow)));
      // ShowMessage(IntToStr(ColorToRGB(clWhite)));
      // ShowMessage('clWindowText = ' + Color2Hex(clWindowText));
      // ShowMessage('clWindow = ' + Color2Hex(clWindow));
      // ShowMessage('clWhite = ' + Color2Hex(clWhite));
      // ShowMessage('clBlack = ' + Color2Hex(clBlack));

      // DefaultCharset := 1251;
      // DefaultCharset := StrToInt(ini.SayDefault('Charset', '204'));

      DefBackGround := Hex2Color(MainCfgIni.SayDefault('DefBackground',
        Color2Hex(clWindow))); // '#EBE8E2'
      DefHotSpotColor := Hex2Color(MainCfgIni.SayDefault('DefHotSpotColor',
        Color2Hex(clHotLight))); // '#0000FF'
      // try
      g_VerseBkHlColor :=
        Color2Hex(Hex2Color(MainCfgIni.SayDefault('VerseBkHLColor',
        Color2Hex(clInfoBk)))); // '#F5F5DC'
      // except g_VerseBkHlColor := '#F5F5DC';
      // end;
    end;

    with bwrSearch do
    begin
      DefFontName := MainCfgIni.SayDefault('RefFontName',
        'Microsoft Sans Serif');
      DefFontSize := StrToInt(MainCfgIni.SayDefault('RefFontSize', '12'));
      DefFontColor := Hex2Color(MainCfgIni.SayDefault('RefFontColor',
        Color2Hex(clWindowText)));

      DefBackGround := bwrHtml.DefBackGround;
      DefHotSpotColor := bwrHtml.DefHotSpotColor;
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
    mFavorites := TBQFavoriteModules.Create(AddHotModule, DeleteHotModule,
      ReplaceHotModule, InsertHotModule, ForceForegroundLoad);

    SaveFileDialog.InitialDir := MainCfgIni.SayDefault('SaveDirectory',
      GetMyDocuments);
    SelTextColor := MainCfgIni.SayDefault('SelTextColor', Color2Hex(clRed));
    PrintFootNote := MainCfgIni.SayDefault('PrintFootNote', '1') = '1';

    // by default, these are checked
    miHrefUnderlineChecked := MainCfgIni.SayDefault('HrefUnderline', '0') = '1';
    mFlagFullcontextLinks := MainCfgIni.SayDefault(C_opt_FullContextLinks, '1') = '1';
    mFlagHighlightVerses := MainCfgIni.SayDefault(C_opt_HighlightVerseHits, '1') = '1';
    // miCopyVerseNum.Checked := ini.SayDefault('CopyVerseNum', '0') = '1';
    // miCopyRTF.Checked := ini.SayDefault('CopyRTF', '0') = '1';

    if miHrefUnderlineChecked then
      bwrHtml.htOptions := bwrHtml.htOptions - [htNoLinkUnderline]
    else
      bwrHtml.htOptions := bwrHtml.htOptions + [htNoLinkUnderline];

    // if ini.SayDefault('LargeToolbarButtons', '1') = '1'
    // then miLargeButtons.Click;
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
    { fname := UserDir + 'bibleqt_memos.ini';
      if FileExists(fname) then
      Memos.LoadFromFile(fname); }
    try
      fname := UserDir + 'bibleqt_history.ini';
      if FileExists(fname) then
        History.LoadFromFile(fname);
    except
      on E: Exception do
        BqShowException(E)
    end;
    // COPYING OPTIONS
    CopyOptionsCopyVerseNumbersChecked :=
      MainCfgIni.SayDefault('CopyOptionsCopyVerseNumbers', '1') = '1';
    CopyOptionsCopyFontParamsChecked :=
      MainCfgIni.SayDefault('CopyOptionsCopyFontParams', '0') = '1';
    CopyOptionsAddReferenceChecked :=
      MainCfgIni.SayDefault('CopyOptionsAddReference', '1') = '1';
    CopyOptionsAddReferenceRadioItemIndex :=
      StrToInt(MainCfgIni.SayDefault('CopyOptionsAddReferenceRadio', '1'));
    CopyOptionsAddLineBreaksChecked :=
      MainCfgIni.SayDefault('CopyOptionsAddLineBreaks', '1') = '1';
    CopyOptionsAddModuleNameChecked :=
      MainCfgIni.SayDefault('CopyOptionsAddModuleName', '0') = '1';

    ConfigFormHotKeyChoiceItemIndex :=
      StrToInt(MainCfgIni.SayDefault('ConfigFormHotKeyChoiceItemIndex', '0'));

    trayIcon.MinimizeToTray := MainCfgIni.SayDefault('MinimizeToTray', '0') = '1';

    // FreeAndNil(MainCfgIni);
  except
    on E: Exception do
      BqShowException(E)
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
      PrepareFont(FileRemoveExtension(sr.Name), awsFolder);
      R := FindNext(sr);
    until R <> 0;

  finally
    FindClose(sr);
  end;

end;

procedure TMainForm.LoadSecondBookByName(const wsName: string);
var
  ix: integer;
  ini: string;
begin
  ix := mModules.FindByName(wsName);
  if ix >= 0 then
  begin
    ini := MainFileExists(TPath.Combine(mModules[ix].wsShortPath, 'bibleqt.ini'));
    if ini <> SecondBook.inifile then
      SecondBook.inifile := MainFileExists(TPath.Combine(mModules[ix].wsShortPath, 'bibleqt.ini'));
  end;
end;

// fn

function TMainForm.LoadHotModulesConfig(): Boolean;
var
  fn1, fn2: string;
  f1Exists, f2Exists: Boolean;

  procedure DefaultHotModules();
  begin
  end;

begin
  try

    Result := false;
    dtsBible.Tabs.Clear();
    dtsBible.Tabs.Add('***');
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
  MessageBoxW(self.Handle, PWideChar(Pointer(E.mWideMsg)), nil, MB_ICONERROR or MB_OK);
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

function DecodeViewtabState(Val: UInt64): TViewtabInfoState;
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

procedure TMainForm.LoadTabsFromFile(path: string);
var
  tabStringList: TStringList;
  linesCount, tabIx, i, activeTabIx, valErr: integer;
  strongs_notes_code: UInt64;
  location, second_bible, Title: string;
  addTabResult, firstTabInitialized { , viewNotes, viewStrongs } : Boolean;
  tabViewState: TViewtabInfoState;
begin
  tabStringList := nil;
  firstTabInitialized := false;
  try
    try
      if (not FileExists(path)) then
      begin
        SetFirstTabInitialLocation(LastAddress, '', '', DefaultViewTabState(), true);
        Exit;
      end;
      tabStringList := TStringList.Create();
      tabStringList.LoadFromFile(path);
      activeTabIx := -1;
      tabIx := 0;
      with tabStringList do
      begin
        linesCount := Count - 1; // ?;
        i := 0;
        if (linesCount < 1) then
          Exit;
        repeat
          if (Strings[i]) = '+' then
          begin
            activeTabIx := tabIx;
            inc(i);
            if i >= linesCount then
              Exit;
          end;
          location := Strings[i];
          inc(i);
          if ((i < linesCount) and (Length(Strings[i]) > 0) and
            (Strings[i] <> '***') and not(CharInSet(Char(Strings[i][1]), [#0 .. #9])))
          then
          begin
            second_bible := Strings[i];
          end
          else
            second_bible := '';

          inc(i);
          strongs_notes_code := 101; // default: show notes and strict links
          if ((i < linesCount) and (Strings[i] <> '***')) then
          begin
            Val(Strings[i], strongs_notes_code, valErr);
            inc(i);
          end;
          tabViewState := DecodeViewtabState(strongs_notes_code);

          if ((i < linesCount) and (Strings[i] <> '***')) then
          begin
            Title := Strings[i];
            inc(i);
          end;

          if Length(Trim(location)) > 0 then
          begin

            if (tabIx > 0) then
              addTabResult := NewViewTab(location, second_bible, '', tabViewState, Title, (tabIx = activeTabIx) or ((Length(Title) = 0)))
            else
            begin
              addTabResult := true;
              SetFirstTabInitialLocation(location, second_bible, Title, tabViewState, (tabIx = activeTabIx) or ((Length(Title) = 0)));
              firstTabInitialized := true;
            end;
          end
          else
            addTabResult := false;
          if (addTabResult) then
            inc(tabIx);
          while ((i < linesCount) and (Strings[i] <> '***')) do
            inc(i);
          if (i < linesCount) then
            inc(i);
        until (i >= linesCount);

        if (activeTabIx < 0) or (activeTabIx >= pgcViewTabs.Tabs.Count) then
          activeTabIx := 0;
        pgcViewTabs.TabIndex := activeTabIx;
        pgcViewTabsChange(self);
      end; // with
    finally
      tabStringList.Free();
    end; // try
  except
    on E: Exception do
      BqShowException(E);
  end;

  if not firstTabInitialized then
    SetFirstTabInitialLocation(LastAddress, '', '',
      DefaultViewTabState(), true);
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
    miAddBookmarkTagged.Visible := false;
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
        PVirtualNode(nd.Parents) := vdtTagsVerses.AddChild(nil, nd);
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
            vdtTagsVerses.AddChild(PVirtualNode(tn.Parents), nd);
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

(* AlekId:/Добавлено *)

procedure TMainForm.SaveConfiguration;
var
  ini: TMultiLanguage;
  fname: string;
  i: integer;
begin
  try

    UserDir := CreateAndGetConfigFolder;
    writeln(bqNowDateTimeString(), ':SaveConfiguration, userdir:', UserDir);
    (* AlekId:Добавлено *)
    SaveTabsToFile(UserDir + 'viewtabs.cfg');
    try
      mModuleLoader.SaveCachedModules();
    except
      on E: Exception do
      begin
        BqShowException(E);
      end;
    end;
    PasswordPolicy.SaveToFile(UserDir + C_PasswordPolicyFileName);
    // SaveBookNodes();
    (* AlekId:/Добавлено *)
    ini := TMultiLanguage.Create(self);
    ini.inifile := UserDir + C_ModuleIniName;

    if MainForm.WindowState = wsMaximized then
      ini.Learn('MainFormMaximized', '1')
    else
    begin
      ini.Learn('MainFormWidth',
        IntToStr((MainForm.Width * MAXWIDTH) div Screen.Width));
      ini.Learn('MainFormHeight', IntToStr((MainForm.Height * MAXHEIGHT)
        div Screen.Height));
      ini.Learn('MainFormLeft',
        IntToStr((MainForm.Left * MAXWIDTH) div Screen.Width));
      ini.Learn('MainFormTop', IntToStr((MainForm.Top * MAXHEIGHT)
        div Screen.Height));

      ini.Learn('MainFormMaximized', '0');
    end;

    // width of nav window
    ini.Learn('MainPagesWidth', IntToStr((pgcMain.Width * MAXHEIGHT)
      div Screen.Height));
    // height of nav window, above the history box
    ini.Learn('Panel2Height', IntToStr((pnlGo.Height * MAXHEIGHT)
      div Screen.Height));

    ini.Learn('DefFontName', mBrowserDefaultFontName);
    ini.Learn('DefFontSize', IntToStr(bwrHtml.DefFontSize));

    if (Color2Hex(bwrHtml.DefFontColor) <> Color2Hex(clWindowText)) then
      ini.Learn('DefFontColor', Color2Hex(bwrHtml.DefFontColor));

    if (g_VerseBkHlColor <> Color2Hex(clHighlight)) then
      ini.Learn('VerseBkHLColor', g_VerseBkHlColor);
    // ini.Learn('Charset', IntToStr(DefaultCharset));

    ini.Learn('RefFontName', bwrSearch.DefFontName);
    ini.Learn('RefFontSize', IntToStr(bwrSearch.DefFontSize));

    if (Color2Hex(bwrSearch.DefFontColor) <> Color2Hex(clWindowText)) then
      ini.Learn('RefFontColor', Color2Hex(bwrSearch.DefFontColor));

    if (Color2Hex(bwrHtml.DefBackGround) <> Color2Hex(clWindow)) then
      ini.Learn('DefBackground', Color2Hex(bwrHtml.DefBackGround));
    if (Color2Hex(bwrHtml.DefHotSpotColor) <> Color2Hex(clHotLight)) then
      ini.Learn('DefHotSpotColor', Color2Hex(bwrHtml.DefHotSpotColor));

    if (SelTextColor <> Color2Hex(clRed)) then
      ini.Learn('SelTextColor', SelTextColor);

    { ini.Learn('HotAddress1', miHot1.Caption);
      ini.Learn('HotAddress2', miHot2.Caption);
      ini.Learn('HotAddress3', miHot3.Caption);
      ini.Learn('HotAddress4', miHot4.Caption);
      ini.Learn('HotAddress5', miHot5.Caption);
      ini.Learn('HotAddress6', miHot6.Caption);
      ini.Learn('HotAddress7', miHot7.Caption);
      ini.Learn('HotAddress8', miHot8.Caption);
      ini.Learn('HotAddress9', miHot9.Caption);
      ini.Learn('HotAddress0', miHot0.Caption); }
    { AlekId:Добавлено }
    try
      SaveHotModulesConfig(ini); { /AlekId:Добавлено }
    except
      on E: Exception do
        BqShowException(E)
    end;
    ini.Learn('HrefUnderline', IntToStr(ord(miHrefUnderlineChecked)));
    // ini.Learn('CopyVerseNum', IntToStr(Ord(miCopyVerseNum.Checked)));
    // ini.Learn('CopyRTF', IntToStr(Ord(miCopyRTF.Checked)));

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

    // for i := 0 to SatelliteMenu.Items.Count - 1 do
    // if SatelliteMenu.Items[i].Checked then
    // begin
    // if i > 0 then
    // ini.Learn('SatelliteBible', SatelliteMenu.Items[i].Caption)
    // else
    // ini.Learn('SatelliteBible', '');
    // break;
    // end;

    // if miLargeButtons.Checked
    // then ini.Learn('LargeToolbarButtons', '1')
    // else ini.Learn('LargeToolbarButtons', '0');

    ini.Learn('LastAddress', LastAddress);
    ini.Learn('LastLanguageFile', LastLanguageFile);
    ini.Learn('SecondPath', G_SecondPath);

    ini.Learn('MainFormFontName', MainForm.Font.Name);
    ini.Learn('MainFormFontSize', IntToStr(MainForm.Font.Size));
    // ini.Learn('MainFormFontCharset', IntToStr(MainForm.Font.Charset));

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

function EncodeToValue(const ViewTabInfo: TViewTabInfo): UInt64;
begin
  Result := ord(ViewTabInfo[vtisShowNotes]);
  inc(Result, 10 * ord(ViewTabInfo[vtisShowStrongs]));
  inc(Result, 100 * ord(ViewTabInfo[vtisResolveLinks]));
  inc(Result, 1000 * ord(ViewTabInfo[vtisFuzzyResolveLinks]));
end;

procedure TMainForm.SaveTabsToFile(path: string);
var
  tabStringList: TStringList;
  tabCount, i: integer;
  tabInfo, activeTabInfo: TViewTabInfo;
  viewTabsEncoded: UInt64;
begin
  tabStringList := nil;
  try
    tabStringList := TStringList.Create();
    tabCount := pgcViewTabs.Tabs.Count - 1;
    activeTabInfo := TViewTabInfo(pgcViewTabs.Tabs.Objects[pgcViewTabs.TabIndex]);
    for i := 0 to tabCount do
    begin
      try
        tabInfo := TViewTabInfo(pgcViewTabs.Tabs.Objects[i]);
        with tabStringList do
        begin
          if tabInfo = activeTabInfo then
            Add('+');

          viewTabsEncoded := EncodeToValue(tabInfo);
          Add(tabInfo.mwsLocation);
          Add(tabInfo.mSatelliteName);
          Add(IntToStr(viewTabsEncoded));
          Add(tabInfo.mwsTitle);
          Add('***');
        end; // with tabInfo, tabStringList
      except
      end;
    end; // for

    tabStringList.SaveToFile(path, TEncoding.UTF8);

  except
    on E: Exception do
      BqShowException(E)
  end;
  tabStringList.Free();
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i { , b, c, v1, v2 } : integer; // AlekId:not used anymore
  viewTabState: TViewtabInfoState;
  tabInfo: TViewTabInfo;
begin
  // tbList.PageControl := nil;
  // tbList.Parent := self;
  // tbList.Visible := false;
  mBqEngine := TBibleQuoteEngine.Create();
  mModuleLoader := TModuleLoader.Create();

  mModuleLoader.OnScanDone := ModulesScanDone;
  mModuleLoader.OnArchiveModuleLoadFailed := ArchiveModuleLoadFailed;

  MainFormInitialized := false; // prohibit re-entry into FormShow
  // InitEnvironment();
  CheckModuleInstall();

  pgcMain.DoubleBuffered := true;
  pgcHistoryBookmarks.DoubleBuffered := true;
  pgcViewTabs.DoubleBuffered := true;
  // mBibleLinkParser:=TBibleLinkParser.Create();
  // mBibleLinkParser.PrepareBookNames();
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Application.HintHidePause := 1000 * 60;
  Application.OnHint := AppOnHintHandler;

  InitializeTaggedBookMarks();

  // Application.OnShowHint := ShowHintEventHandler;
  HintWindowClass := HintTools.TbqHintWindow;
  // TrayIcon.Visible := true;

  bwrHtml.Align := alClient;
  SetVScrollTracker(bwrHtml);
 
  MainBook := TBible.Create(self);
  // AlekId: библия принадлежит табу
  SecondBook := TBible.Create(self);
  mRefenceBible := TBible.Create(self);

  MainBook.OnVerseFound := MainBookVerseFound;
  MainBook.OnChangeModule := MainBookChangeModule;
  MainBook.OnSearchComplete := MainBookSearchComplete;

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
  miMemosToggle.Checked := MemosOn;

  Bookmarks := TStringList.Create;
  // Bookmarks.Sorted := true;

  History := TStringList.Create;
  HistoryOn := true;

  SearchResults := TStringList.Create;
  SearchWords := TStringList.Create;
  LastSearchResultsPage := 1;

  IsSearching := false;

  pgcMain.ActivePage := tbGo;

  AddressFromMenus := true;

  /// ///////////////////////////////////////////
  //
  // LOADING CONFIGURATION
  //
  LoadConfiguration;
  //
  //
  /// ///////////////////////////////////////////
  pnlMain.Align := alClient;

  if MainPagesWidth <> 0 then
    pgcMain.Width := MainPagesWidth;

  if Panel2Height <> 0 then
    pnlGo.Height := Panel2Height;

  if MainFormWidth = 0 then
  begin
    MainForm.WindowState := wsMaximized;

    // with MainForm do
    // begin
    // Left := (Screen.Width - Width) div 2;
    // Top := (Screen.Height - Height) div 2;
    // end;
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

  // MainForm.WindowState := wsMaximized;

  TemplatePath := ExePath + 'templates\default\';

  // TempDir := WindowsTempDirectory + 'BibleQuote\';
  // if not FileExists(TempDir) then
  // ForceDirectories(TempDir);

  if FileExists(TemplatePath + 'text.htm') then
    TextTemplate := TextFromFile(TemplatePath + 'text.htm')
  else
    TextTemplate := DefaultTextTemplate;

  // TextTemplate := TextTemplate + '<A NAME="#endofchapterNMFHJAHSTDGF123">';

  if not StrReplace(TextTemplate, 'background="', 'background="' + TemplatePath,
    false) then
    StrReplace(TextTemplate, 'background=',
      'background=' + TemplatePath, false);
  if not StrReplace(TextTemplate, 'src="', 'src="' + TemplatePath, false) then
    StrReplace(TextTemplate, 'src=', 'src=' + TemplatePath, false);

  FillLanguageMenu();
  mTranslated := ApplyInitialTranslation();

  MainMenuInit(false);
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

  (* AlekId:Добавлено *)
  //pgcViewTabs.CloseTabImage := LoadIcon(MainInstance, PChar(1233));
  // pgcViewTabs.CloseTabImage.LoadFromResourceID(MainInstance, 1233);
  // pgcViewTabs.CloseTabImage.TransparentColor := 0;
  viewTabState := DefaultViewTabState();
  tabInfo := TViewTabInfo.Create(MainBook, '', SatelliteBible, '', viewTabState);
  pgcViewTabs.Tabs.AddObject(MainBook.Name, tabInfo);

  (* AlekId:/Добавлено *)

  LoadTabsFromFile(UserDir + 'viewtabs.cfg');
  LoadHotModulesConfig();
  { if LastAddress = '' then begin
    GoModuleName(miHot1.Caption);
    b := 1; c := 1; v1 := 1; v2 := 0;
    //MainForm.
    GoAddress(b, c, v1, v2);
    end
    else begin
    ProcessCommand(LastAddress);
    BooksCB.ItemIndex := BooksCB.Items.IndexOf(MainBook.Name);

    //ShowComments;
    end; }
  // LoadBookNodes();
  StrongsDir := C_StrongsSubDirectory;
  LoadFontFromFolder(TPath.Combine(ModulesDirectory, StrongsDir));

  StrongHebrew := TDict.Create;
  StrongGreek := TDict.Create;

  pgcMainChange(self);

  mslSearchBooksCache.Duplicates := dupIgnore;
  // AlekId: чтобы правильно присвоит memoPopup
  Application.OnIdle := self.Idle;
  Application.OnActivate := self.OnActivate;
  Application.OnDeactivate := self.OnDeactivate;
  vstDicList.DefaultNodeHeight := Canvas.TextHeight('X');
end;

(* AlekId:Добавлено *)

function TMainForm.GetActiveTabInfo(): TViewTabInfo;
var
  tabIndex: integer;
begin
  Result := nil;
  tabIndex := pgcViewTabs.TabIndex;
  try
    if (tabIndex >= 0) and (tabIndex < pgcViewTabs.Tabs.Count) then
    begin
      Result := pgcViewTabs.Tabs.Objects[pgcViewTabs.TabIndex] as TViewTabInfo;
    end;
  except
    // just eat everything wrong
  end;
end;

function TMainForm.GetAutoTxt(const cmd: string; maxWords: integer; out fnt: string; out passageSignature: string): string;
var
  autoCmd: Boolean;
  currentModule: TBible;
  prefBible, txt: string;
  bl: TBibleLink;
  status_GetModTxt: integer;

begin
  status_GetModTxt := 1;
  autoCmd := Pos(C__bqAutoBible, cmd) <> 0;
  if autoCmd then
  begin
    currentModule := GetActiveTabInfo().mBible;
    if (currentModule.ModuleType = bqmBible) then
      prefBible := currentModule.ShortPath
    else
      prefBible := '';
    status_GetModTxt := PreProcessAutoCommand(cmd, prefBible, Result);
  end
  else
    Result := cmd;
  if status_GetModTxt > -2 then
    status_GetModTxt := GetModuleText(Result, fnt, bl, txt, passageSignature,
      [gmtBulletDelimited, gmtEffectiveAddress, gmtLookupRefBibles], maxWords);

  if status_GetModTxt >= 0 then
  begin
    Result := txt;

  end
  else
  begin
    Result := 'Не найдено подходящей Библии для отображения отрывка(' +
      IntToStr(ord(autoCmd)) + ')';
  end;

end;

function TMainForm.GetIViewerBase(): IHtmlViewerBase;
begin
  if not Assigned(mHTMLViewerSite) then
    mHTMLViewerSite := THTMLViewerSite.Create(self, self);

  Result := mHTMLViewerSite;

end;

// proc   GetActiveTabInfo

{ function TMainForm.GetHotMenuItem(itemIndex: integer): TMenuItem;
  var
  favouriteMenuItem: TMenuItem;
  itemCount, i: integer;
  begin
  result := nil;
  try
  favouriteMenuItem := FindTaggedTopMenuItem(3333);
  if (favouriteMenuItem = nil) then
  exit;
  itemCount := favouriteMenuItem.Count - 1;
  for I := 0 to itemCount do
  if (favouriteMenuItem[i].Tag = itemIndex + 7000) then
  begin
  result := favouriteMenuItem[i] as TMenuItem;
  break
  end;
  except //just to be safe
  end;
  end; }

{ function TMainForm.GetHotModuleCount: integer;
  var
  favouriteMenuItem: TMenuItem;
  itemCount, i: integer;
  begin
  result := 0;
  try
  favouriteMenuItem := FindTaggedTopMenuItem(3333);
  if (favouriteMenuItem = nil) then
  exit;
  itemCount := favouriteMenuItem.Count - 1;
  for I := 0 to itemCount do
  if (favouriteMenuItem[i].Tag >= 7000) then
  Inc(result);
  except on e:Exception do begin BqShowException(e) end end;

  end; }

function TMainForm.GetMainWindow: TForm;
begin
  Result := self;
end;

function TMainForm.GetModuleText(cmd: string; out fontName: string;
  out bl: TBibleLink; out txt: string; out passageSignature: string;
  options: TgmtOptions = []; maxWords: integer = 0): integer;
var
  i, verseCount, C, status_valid: integer;
  path: string;
  fontFound, addEllipsis, limited, linkValid: Boolean;
  ibl, effectiveLnk: TBibleLink;
  delimiter, line: string;
  currentBibleIx, prefBibleCount, wordCounter, wordsAdded: integer;
label lblErrNotFnd;
  function NextRefBible(): Boolean;
  var
    me: TModuleEntry;
  begin
    if currentBibleIx < prefBibleCount then
    begin
      me := GetRefBible(currentBibleIx);
      inc(currentBibleIx);
      mRefenceBible.inifile := MainFileExists(me.getIniPath());
      Result := true;
    end
    else
      Result := false;

  end;

begin
  Result := -1;
  try
    // txt := '';

    // HintWindowClass := bqHintTools.TbqHintWindow;
    linkValid := ibl.FromBqStringLocation(cmd, path);
    if not linkValid then
    begin
      txt := 'Неверный аргумент GetModuleText:' + StackLst(GetCallerEIP(), nil);
      Exit;
    end;

    if path <> C__bqAutoBible then
    begin
      // формируем путь к ini модуля
      path := MainFileExists(TPath.Combine(path, 'bibleqt.ini'));
      // пытаемся подгрузить модуль
      mRefenceBible.inifile := path;
    end
    else
      raise Exception.Create
        ('Неверный аргумент GetModuleText:не указан модуль');
    if gmtLookupRefBibles in options then
    begin
      currentBibleIx := 0;
      prefBibleCount := RefBiblesCount();
    end;
    repeat
      if not(gmtEffectiveAddress in options) then
      begin
        if mRefenceBible.InternalToReference(ibl, effectiveLnk) < -1 then
          goto lblErrNotFnd;
      end
      else
        effectiveLnk := ibl;

      status_valid := mRefenceBible.LinkValidnessStatus(mRefenceBible.inifile,
        effectiveLnk, false);
      effectiveLnk.AssignTo(bl);
      if status_valid < -1 then
        goto lblErrNotFnd;
      mRefenceBible.SetHTMLFilterX('', true);
      mRefenceBible.OpenChapter(effectiveLnk.book, effectiveLnk.chapter);
      // already opened?
      passageSignature := mRefenceBible.ShortPassageSignature(effectiveLnk.book,
        effectiveLnk.chapter, effectiveLnk.vstart, effectiveLnk.vend);
      verseCount := mRefenceBible.verseCount();
      if effectiveLnk.vstart = 0 then
        effectiveLnk.vstart := 1;
      if effectiveLnk.vend <= 0 then
        C := verseCount
      else
        C := effectiveLnk.vend;
      if (effectiveLnk.vstart > verseCount) then
        Exit;
      if (effectiveLnk.vend > verseCount) then
        effectiveLnk.vend := verseCount;
      // if (bl.vend < bl.vstart) then   bl.vend := bl.vstart;
      if gmtBulletDelimited in options then
        delimiter := C_BulletChar + #32
      else
        delimiter := #13#10;
      Dec(C);
      if (C - effectiveLnk.vstart) > 10 then
      begin
        C := effectiveLnk.vstart + 10;
        addEllipsis := true
      end
      else
        addEllipsis := false;
      wordCounter := 0;

      for i := effectiveLnk.vstart to C do
      begin
        if maxWords = 0 then
          txt := txt + DeleteStrongNumbers(mRefenceBible.Verses[i - 1]) +
            delimiter
        else
        begin
          line := StrLimitToWordCnt
            (DeleteStrongNumbers(mRefenceBible.Verses[i - 1]),
            maxWords - wordCounter, wordsAdded, limited);
          inc(wordCounter, wordsAdded);

          txt := txt + line;
          if not limited then
            txt := txt + delimiter
          else
            break;
        end;
      end;
      if maxWords = 0 then
        txt := txt + DeleteStrongNumbers(mRefenceBible.Verses[C])
      else
      begin
        if not limited then
        begin
          line := StrLimitToWordCnt(DeleteStrongNumbers(mRefenceBible.Verses[C]
            ), maxWords - wordCounter, wordsAdded, limited);
          txt := txt + line;
        end;
        addEllipsis := limited;
      end;
      if addEllipsis then
        txt := txt + '...';

      if Length(mRefenceBible.fontName) > 0 then
      begin
        fontFound := PrepareFont(mRefenceBible.fontName, mRefenceBible.path);
        fontName := mRefenceBible.fontName;
      end
      else
        fontFound := false;
      (* если предподчтительного шрифта нет или он не найден и указана кодировка *)
      if not fontFound and (mRefenceBible.desiredCharset >= 2) then
      begin
        { находим шрифт с нужной кодировкой учитывая предподчтительный и дефолтный }
        if Length(mRefenceBible.fontName) > 0 then
          fontName := mRefenceBible.fontName
        else
          fontName := '';
        fontName := FontFromCharset(self.Canvas.Handle, mRefenceBible.desiredCharset, bwrHtml.DefFontName);
      end;
      if Length(fontName) = 0 then
        fontName := mBrowserDefaultFontName;
      Result := 0;
      // effectiveLnk.AssignTo(bl);
      break;
    lblErrNotFnd:

    until (not(gmtLookupRefBibles in options)) or (not NextRefBible());
  except
  end;
end;

function TMainForm.GetRefBible(ix: integer): TModuleEntry;
var
  i, cnt, bi: integer;
  me: TModuleEntry;
begin
  cnt := mFavorites.mModuleEntries.Count - 1;
  bi := 0;
  me := nil;

  for i := 0 to cnt do
  begin
    me := mFavorites.mModuleEntries[i];
    if me.modType = modtypeBible then
      inc(bi);
    if bi > ix then
    begin
      break
    end;
  end; // for
  if bi > ix then
    Result := me
  else
    Result := nil;
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

procedure TMainForm.GetTextInfo(tree: TVirtualDrawTree; Node: PVirtualNode;
  Column: TColumnIndex; const AFont: TFont; var R: TRect;
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

(* AlekId:/Добавлено *)

function TMainForm.GoAddress(var book, chapter, fromverse, toverse: integer;
  var hlVerses: TbqHLVerseOption): TbqNavigateResult;
var
  paragraph, hlParaStart, hlParaEnd, hlstyle, Title, head, Text, s,
    strVerseNumber, ss: string;
  verse: integer;
  locVerseStart, locVerseEnd, bverse, everse: integer;
  i, ipos, B, C, V, ib, ic, iv, chapterCount: integer;
  UseParaBible, opened, multiHl, isCommentary, showStrongs: Boolean;
  dBrowserSource, wsMemoTxt: string;
  activeInfo: TViewTabInfo; // AlekId:добавлено
  fontName, uiFontName: string;
  fistBookCell, SecondbookCell: string;
  mainbook_right_aligned, secondbook_right_aligned, hlCurrent: Boolean;
  hlVerseStyle: integer;
  highlight_verse: TPoint;
  modEntry: TModuleEntry;
  { type ralignTypes=(open, close);
    tRalingTags=array[ralignTypes] of WideString;
    const ralign_tags:tRalingTags=('<DIV STYLE="text-align:right">','</DIV>');
    const ralign_tags_empty:tRalingTags =('','');
    var pFirstBookTags, pSecondBookTags:^tRalingTags; }

begin
  // провека и коррекция номера книги
  highlight_verse := Point(fromverse, toverse);
  UseParaBible := false;
  Result := nrSuccess;
  locVerseStart := fromverse;
  locVerseEnd := toverse;
  // проверка и коррекция книги
  if book < 1 then
  begin
    Result := nrBookErr;
    book := 1;
  end
  else if book > MainBook.BookQty then
  begin
    book := MainBook.BookQty;
    Result := nrBookErr;
  end;

  // проверка и коррекция номера главы
  if chapter < 0 then
  begin
    Result := nrChapterErr;
    chapter := 1;
  end
  else if chapter > MainBook.ChapterQtys[book] then
  begin
    if Result = nrSuccess then
      Result := nrChapterErr;
    chapter := MainBook.ChapterQtys[book];
  end;

  if Result <> nrSuccess then
  begin
    highlight_verse := Point(0, 0);
    fromverse := 0;
    toverse := 0; // reset verse on chapter err
    locVerseStart := 1;
    locVerseEnd := 0;
  end;

  // загружаем главу
  try
    opened := MainBook.OpenChapter(book, chapter);
    if not opened then
      raise Exception.CreateFmt('invaid chapter %d for book %d',
        [chapter, book]);

  except
    on E: EAbort do
    begin
      raise;
    end;
    else
    begin
      if Result = nrSuccess then
        Result := nrChapterErr;
      highlight_verse := Point(0, 0);
      MainBook.OpenChapter(1, 1);
      book := 1;
      chapter := 1;
      fromverse := 0;
      locVerseStart := 1;
      toverse := 0;
      locVerseEnd := 0;
    end;
  end;

  chapterCount := MainBook.ChapterCountForBook(MainBook.CurBook, false);
  mainbook_right_aligned := MainBook.UseRightAlignment;

  // Поиск вторичной Библии, если первый модуль библейский
  if MainBook.isBible then
  begin
    isCommentary := MainBook.isCommentary;
    showStrongs := GetActiveTabInfo()[vtisShowStrongs];
    activeInfo := GetActiveTabInfo();
    s := activeInfo.mSatelliteName;
    if (s = '------') or isCommentary then
      UseParaBible := false
    else
    begin
      // поиск в списке модулей
      try
        modEntry := mModules.ResolveModuleByNames(s, '');
      except
        on E: Exception do
        begin
          BqShowException(E, Format('GoAddress err: mod=%s | book=%d | chapter=%d',
            [MainBook.Name, book, chapter]));
        end;
      end;
      if Assigned(modEntry) then
      { // now UseParaBible will be used if satellite text is found... }
      begin

        SecondBook.inifile := modEntry.getIniPath();

        secondbook_right_aligned := SecondBook.UseRightAlignment;
        UseParaBible := SecondBook.ModuleType = bqmBible;
        // если первичный модуль показыввает ВЗ, а второй не содержит ВЗ
        if (((MainBook.CurBook < 40) and (MainBook.Trait[bqmtOldCovenant])) and
          (not SecondBook.Trait[bqmtOldCovenant])) or
        // или если в первичном модуль НЗ а второй не содержит НЗ
          (((MainBook.CurBook > 39) or (MainBook.Trait[bqmtNewCovenant] and
          (not MainBook.Trait[bqmtOldCovenant]))) and
          (not SecondBook.Trait[bqmtNewCovenant])) then
          UseParaBible := false; // отменить отображение
      end; // if UseParaBible- если найден в списке  модулей
    end; // если выбрана вторичная Библия
  end // если модуль Библейский

  else
    isCommentary := false;
  // проверка и коррекция начального стиха
  if fromverse > MainBook.VerseQty then
  begin
    fromverse := 0;
    locVerseStart := 1;
    highlight_verse.X := 0;
    if Result = nrSuccess then
      Result := nrStartVerseErr;
  end;
  // проверка и коррекция конечного стиха стиха
  if (toverse > MainBook.VerseQty) or (toverse < fromverse) then
  begin
    if (toverse < fromverse) and (toverse <= MainBook.VerseQty) then
    begin
      toverse := highlight_verse.Y;
      highlight_verse.Y := highlight_verse.X;
      highlight_verse.X := toverse;
    end
    else
      highlight_verse.Y := highlight_verse.X;
    toverse := 0;
    locVerseEnd := 0;
    if Result = nrSuccess then
      Result := nrEndVerseErr;
  end; // если конечный стих больше количества

  if (highlight_verse.X <= 0) and (highlight_verse.Y > 0) then
    highlight_verse.X := highlight_verse.Y;

  if hlVerses = hlFalse then
    highlight_verse := Point(-1, -1);

  if MainBook.Trait[bqmtNoForcedLineBreaks] then
    paragraph := ''
  else
  begin
    if (MainBook.isBible) then
      paragraph := ' <BR>'
    else { AlekId }
      // paragraph := '<P style="background-color:beige">';
      paragraph := '<P>';
  end;

  // ??
  if toverse = 0 then
  begin // если отображать всю главу??
    (* если в книге только одна глава *)
    if MainBook.ChapterQtys[book] = 1 then
      head := MainBook.FullNames[book]
    else
      head := MainBook.FullPassageSignature(book, chapter, 1, 0);
  end // если отображать всю главу
  else
    head := MainBook.FullPassageSignature(book, chapter, fromverse, toverse);

  Title := '<head>'#13#10'<title>' + head + '</title>'#13#10 + bqPageStyle +
    #13#10'</head>';
  if Length(MainBook.DesiredUIFont) > 0 then
    uiFontName := MainBook.DesiredUIFont
  else
    uiFontName := mBrowserDefaultFontName;
  head := '<font face="' + uiFontName + '">' + head + '</font>';

  Text := '';
  // коррекция начального стиха
  if locVerseStart = 0 then
  begin
    locVerseStart := 1;
  end;
  // else if highlight_verse <> 0 then highlight_verse := 1;

  bverse := 1;
  if (locVerseStart > 0) and (not mFlagFullcontextLinks) then
    bverse := locVerseStart;

  // everse := toverse; AlekId: неразумно
  if (locVerseEnd = 0) or (mFlagFullcontextLinks) then
    everse := MainBook.VerseQty
    (* AlekId: добавлено *)
  else
    everse := locVerseEnd; { AlekId:/добавлено }

  CurFromVerse := bverse;
  CurToVerse := everse;

  opened := false;

  if UseParaBible then
  begin
    if MainBook.Trait[bqmtZeroChapter] and (chapter = 1) then
      { если нулевая глава в первичном виде }
      UseParaBible := false;
  end;

  if UseParaBible then
  begin
    if ((Length(SecondBook.fontName) > 0)) or (SecondBook.desiredCharset > 2)
    then
      fontName := SuggestFont(SecondBook.fontName, SecondBook.path,
        SecondBook.desiredCharset)
    else
      fontName := mBrowserDefaultFontName;
    bwrHtml.DefFontName := fontName;
  end;

  // Обработка текста по стихам
  Text := MainBook.ChapterHead;

  // if (not MainBook.isBible) or (not UseParaBible) then
  for verse := bverse to everse do
  begin
    s := MainBook.Verses[verse - 1];
    if (highlight_verse.X > 0) and (highlight_verse.Y > 0) and
      (mFlagHighlightVerses) then
    begin
      hlCurrent := (verse <= highlight_verse.Y) and
        (verse >= highlight_verse.X);
      hlVerseStyle := ord(verse = highlight_verse.X) +
        (ord(verse = highlight_verse.Y) shl 1);
    end
    // else if highlight_verse.x>0 then hlCurrent:=verse=highlight_verse.x
    // else if highlight_verse.y>0 then hlCurrent:=verse=highlight_verse.y
    else
    begin
      hlCurrent := false;
      hlVerseStyle := 0;
    end;
    if hlCurrent then
    begin
      hlstyle := 'background-color:' + g_VerseBkHlColor + ';';
      if MainBook.Trait[bqmtNoForcedLineBreaks] then
      begin
        hlParaStart := '<span style="';
        hlParaEnd := '</span>';
      end
      else
      begin
        hlParaStart := '<div style="';
        hlParaEnd := '</div>';
      end;
      hlParaStart := hlParaStart + hlstyle + '">';

    end
    else
    begin
      hlParaStart := '';
      hlParaEnd := '';
      hlstyle := '';
    end;

    strVerseNumber := StrDeleteFirstNumber(s);

    // if (verse = fromverse) and (verse <> 1) then
    // s0 := '<font color=' + SelTextColor + '>&gt;&gt;&gt;' + s0 + '</font>';

    if (MainBook.isBible) and (not isCommentary) then
    begin // if bible display verse numbers

      if MainForm.miShowSignatures.Checked then
        ss := MainBook.ShortNames[MainBook.CurBook] +
          IntToStr(MainBook.CurChapter) + ':'
      else
        ss := '';

      strVerseNumber := '<a href="verse ' + strVerseNumber
      // + '">'
        + '" CLASS=OmegaVerseNumber>' +
      // style="font-family:' + 'Helvetica">' +
        ss + strVerseNumber + '</a>';
      if MainBook.Trait[bqmtNoForcedLineBreaks] then
        strVerseNumber := '<sup>' + strVerseNumber + '</sup>';
      if MainBook.Trait[bqmtStrongs] then
      begin
        if (not showStrongs) then
          s := DeleteStrongNumbers(s)
        else
          s := FormatStrongNumbers(s, (MainBook.CurBook < 40) and
            (MainBook.Trait[bqmtOldCovenant]), true);
      end;
    end;
    // если модуль НЕбиблейский или нет вторичной Библии
    if (not MainBook.isBible) or (not UseParaBible) then
    begin // no satellite text
      if mainbook_right_aligned then
        Text := Text + Format
          (#13#10'%s<F>%s</F><a name="bqverse%d">%s</a>%s',
          [hlParaStart, s, verse, strVerseNumber, hlParaEnd])
      else
      begin
        if (MainBook.isBible) and (not MainBook.Trait[bqmtNoForcedLineBreaks])
        then
          Text := Text + Format
            (#13#10'%s<a name="bqverse%d">%s <F>%s</F></a>%s',
            [hlParaStart, verse, strVerseNumber, s, hlParaEnd])
        else
          Text := Text + Format
            (#13#10'%s<a name="bqverse%d">%s <F>%s</F></a>%s',
            [hlParaStart, verse, strVerseNumber, s, hlParaEnd]);
      end;
      if (not hlCurrent) or ((hlVerseStyle and 2 > 0) and not MainBook.isBible)
      then
        Text := Text + paragraph;
    end
    else
    begin
      if UseParaBible then
      begin // если найден подходящий текст во вторичной Библии
        try
          // синхронизация мест
          with MainBook do
            ReferenceToInternal(CurBook, CurChapter, verse, B, C, V);
          SecondBook.InternalToReference(B, C, V, ib, ic, iv);
          if (ib <> SecondBook.CurBook) or (ic <> SecondBook.CurChapter) or
            (not opened) then
          begin
            opened := SecondBook.OpenChapter(ib, ic);
            UseParaBible := opened;
          end;
        except
          UseParaBible := false;
        end;
        // коррекция номера стиха снизу
        if iv <= 0 then
          iv := 1;
        if mainbook_right_aligned then
          fistBookCell :=
            '<table width=100% cellpadding=0 border=0 cellspacing=10em >' +
            '<tr style="' + hlstyle + '"><td valign=top width=50% align=right>'
            + Format(#13#10'<a name="bqverse%d">%s <F>%s</F> ',
            [verse, strVerseNumber, s])
        else
          fistBookCell :=
            '<table width=100% cellpadding=0 border=0 cellspacing=10em >' +
            '<tr style="' + hlstyle + '"><td valign=top width=50% align=left>' +
            Format(#13#10'<a name="bqverse%d">%s<F> %s</F></a>',
            [verse, strVerseNumber, s]);
        SecondbookCell := '';
        // если номер стиха в во вторичной библии не более кол-ва стихов
        if iv <= SecondBook.verseCount() then
        begin
          ss := SecondBook.Verses[iv - 1];
          StrDeleteFirstNumber(ss);
          if SecondBook.Trait[bqmtStrongs] then
            if showStrongs then
              ss := FormatStrongNumbers(ss, B < 40, true)
            else
              ss := DeleteStrongNumbers(ss);
          if secondbook_right_aligned then
            SecondbookCell :=
              Format
              ('</td><td valign=top width=50%% align=right><font size=1>%d:%d</font><font face="%s">%s</font>',
              [ic, iv, fontName, ss]) + '</td></tr></table>' + #13#10
          else
            SecondbookCell :=
              Format
              ('</td><td valign=top width=50%%><font face="Arial" size=1>%d:%d </font><font face="%s">%s</font>',
              [ic, iv, fontName, ss]) + '</td></tr></table>' + #13#10;
        end;
        if Length(SecondbookCell) <= 0 then
          SecondbookCell :=
            '</td><td valign=top width=50%> </td></tr></table>'#13#10;

        Text := Text + fistBookCell + SecondbookCell;

      end;
    end;

    // memos...
    if MemosOn then
    begin // если всключены заметки
      with MainBook do // search for 'RST Быт.1:1 $$$' in Memos.
        i := FindString(Memos, ShortName + ' ' + ShortPassageSignature(CurBook,
          CurChapter, verse, verse) + ' $$$');

      if i > -1 then
      begin // found memo
        wsMemoTxt := '<font color=' + SelTextColor + '>' + Comment(Memos[i]) +
          '</font>' + paragraph;
        if activeInfo[vtisResolveLinks] then
          wsMemoTxt := ResolveLnks(wsMemoTxt,
            activeInfo[vtisFuzzyResolveLinks]);

        Text := Text + wsMemoTxt;
      end;
    end; // если включены заметки
  end; // цикл итерации по стихам
  if not UseParaBible then
  begin
    if mainbook_right_aligned then
      Text := '<div style="text-align:right">' + Text + '</div>'
    else
      Text := '<div style="text-align:justify">' + Text + '</div>'
  end;

  dBrowserSource := TextTemplate;
  StrReplace(dBrowserSource, '%HEAD%', head, false);
  StrReplace(dBrowserSource, '%TEXT%', Text, false);
  if ((Length(MainBook.fontName) > 0) and
    (MainBook.fontName = bwrHtml.DefFontName)) then
    fontName := MainBook.fontName
  else
    fontName := '';
  // если указан шрифт и он еще не выбран в свойвах браузера или указана кодировка
  if (Length(fontName) <= 0) and ((Length(MainBook.fontName) > 0) or
    (MainBook.desiredCharset > 2)) then
    fontName := SuggestFont(MainBook.fontName, MainBook.path,
      MainBook.desiredCharset);
  if Length(fontName) <= 0 then
    fontName := mBrowserDefaultFontName;
  bwrHtml.DefFontName := fontName;
  StrReplace(dBrowserSource, '<F>', '<font face="' + fontName + '">', true);
  StrReplace(dBrowserSource, '</F>', '</font>', true);
  { */Обработка шрифтов* }

  dBrowserSource := '<HTML>' + Title + dBrowserSource + '</HTML>';
  bwrHtml.Base := MainBook.path;

  for i := 1 downto 0 do
  begin
    try
      bwrHtml.LoadFromString(dBrowserSource);
      break;
    except
      on E: Exception do
      begin
        BqShowException(E, 'LoadFromString failed!');
        if i = 0 then
          raise;
      end;
    end;
  end;
  bwrHtml.Position := 0;
  multiHl := (highlight_verse.X > 0) and (highlight_verse.Y > 0) and
    (highlight_verse.Y <> highlight_verse.X);
  if highlight_verse.X > 0 then
    verse := highlight_verse.X
  else if highlight_verse.Y > 0 then
    verse := highlight_verse.Y
  else
    verse := 0;
  hlVerses := TbqHLVerseOption(ord(verse > 0));
  if (hlVerses = hlTrue) then
    bwrHtml.PositionTo('bqverse' + IntToStr(verse), not multiHl);

  VersePosition := verse;

  s := MainBook.ShortName + ' ' + MainBook.FullPassageSignature(book, chapter, fromverse, toverse);
  lblTitle.Font.Name := fontName;
  lblTitle.Caption := s;

  lblTitle.Hint := s + '   ';
  try
    GetActiveTabInfo().mwsTitleLocation := s;
    GetActiveTabInfo().mwsTitleFont := fontName;
  except
  end;
  if MainBook.Copyright <> '' then
  begin
    s := '; © ' + MainBook.Copyright;
  end
  else
    s := '; ' + Lang.Say('PublicDomainText');
  // MainBook.Lines.Clear(); SecondBook.Lines.Clear();
  lblCopyRightNotice.Caption := s;
  try
    GetActiveTabInfo().mwsCopyrightNotice := s;
  except
  end;
  { if Length(lblTitle.Hint) < 83 then
    lblTitle.Caption := lblTitle.Hint
    else
    lblTitle.Caption := Copy(lblTitle.Hint, 1, 80) + '...'; }
  // lblTitle.Font.Style := [fsBold];
  tbtnCopyright.Hint := s;
  // MainStatusBar.SimpleText := s;
  // tbXRef.Tag := fromverse;
  // ShowXref;
  // ShowComments;
  // ActiveControl := Browser;

end;
{ procedure TMainForm.SaveBookNodes;
  var
  pvn: PVirtualNode;
  catFile: THandle;
  fn: WideString;
  var
  nodetext: WideString;
  bytesWritten: Cardinal;

  function GetNodeText(pn: PVirtualNode): WideString;
  begin
  result := '';
  if pn = nil then
  exit;
  try
  result := (TObject(vstBooks.GetNodeData(pn)^) as TBookCategory).name;
  except end;
  end; //fn

  procedure write_node(pn: PVirtualNode);
  var
  _pvn: PVirtualNode;
  begin
  repeat
  nodetext := GetNodeText(pn);
  WriteFile(catFile, Pointer(nodetext)^,
  length(nodetext) * 2, bytesWritten, nil);
  WriteFile(catFile, C_crlf[0], 4, bytesWritten, nil);
  if (pn^.ChildCount > 0) then
  begin
  WriteFile(catFile, C_plus, 2, bytesWritten, nil);
  write_node(pn^.FirstChild);
  end;
  pn := pn^.NextSibling;
  until pn = nil;
  WriteFile(catFile, C_minus, 2, bytesWritten, nil);
  end;

  begin
  pvn := vstBooks.RootNode;
  if pvn^.ChildCount <= 0 then
  exit;
  fn := CreateAndGetConfigFolder() + C_CategoriesFile;
  catFile := CreateFileW(PWideChar(Pointer(fn)), GENERIC_WRITE, 0,
  nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if catFile = INVALID_HANDLE_VALUE then
  begin
  WideShowMessage(
  'Не удается сохранить структуру модулей книг');
  exit;
  end;
  pvn := pvn^.FirstChild;
  write_node(pvn);
  CloseHandle(catFile);
  end; }

procedure TMainForm.SaveButtonClick(Sender: TObject);
var
  s: string;
begin
  SaveFileDialog.DefaultExt := '.htm';
  SaveFileDialog.Filter := 'HTML (*.htm,*.html)|*.htm;*.html';

  s := bwrHtml.DocumentTitle;
  SaveFileDialog.FileName := DumpFileName(s) + '.htm';

  if SaveFileDialog.Execute then
  begin
    WriteHtml(SaveFileDialog.FileName, bwrHtml.DocumentSource);
    SaveFileDialog.InitialDir := ExtractFilePath(SaveFileDialog.FileName);
  end;
end;

procedure TMainForm.GoButtonClick(Sender: TObject);
begin
  lbBook.ItemIndex := MainBook.CurBook - 1;
  lbChapter.ItemIndex := MainBook.CurChapter - 1;

  if lbChapter.ItemIndex < 0 then
    lbChapter.ItemIndex := 0;

  if not pgcMain.Visible then
    tbtnToggle.Click;
  pgcMain.ActivePage := tbGo;
  ActiveControl := edtGo;
end;

procedure TMainForm.CopySelectionClick(Sender: TObject);
var
  s: string;
  trCount: integer;
begin
  trCount := 7;
  repeat
    try
      if (bwrHtml.SelLength <> 0) or
        ((bwrHtml.SelLength = 0) and (bwrHtml.tag <> bsText)) then
      begin
        bwrHtml.CopyToClipboard;
        if not(CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then
        begin
          if bwrHtml.tag <= bsText then
          begin
            s := Clipboard.AsText;
            // StrReplace(s, #13#10, ' ', true);
            // carriage returns are replaced by space
            StrReplace(s, '  ', ' ', true);
            // double spaces are replaced by single space
            Clipboard.AsText := s;
          end
          else
            Clipboard.AsText := CopyPassage(CurFromVerse, CurToVerse);
        end
      end;
      trCount := 0;
    except
      Dec(trCount);
      sleep(100);
    end;
  until trCount <= 0;
  // ConvertClipboard;
end;

procedure TMainForm.bwrHtmlFileBrowse(Sender, Obj: TObject; var s: string);
begin
  //
end;

procedure TMainForm.bwrHtmlHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  first: integer;
  scode, unicodeSRC: string;
  cb: THTMLViewer;
  lr: Boolean;
  ws: string;
  iscontrolDown: Boolean;
  tabInfo: TViewTabInfo;
  viewTabState: TViewtabInfoState;
  Key: Char;
begin
  unicodeSRC := SRC;
  iscontrolDown := IsDown(VK_CONTROL);
  if GetCommandType(SRC) = bqctGoCommand then
  { // гиперссылка на стих }
  begin
    if iscontrolDown then
    begin
      if bwrHtml.LinkAttributes.Count > 1 then
      begin
        ws := bwrHtml.LinkAttributes[1];
        first := Pos('bqResLnk', ws);
        if first > 0 then
        begin
          ws := Copy(ws, first + 8, $FF);
          LoadBibleToXref(unicodeSRC, ws);
          Handled := true;
          Exit;
        end
      end
    end;
    if IsDown(VK_MENU) then
    begin
      tabInfo := GetActiveTabInfo();
      if not Assigned(tabInfo) then
      begin
        viewTabState := DefaultViewTabState;
      end
      else
        viewTabState := tabInfo.state;

      NewViewTab(unicodeSRC, '', bwrHtml.Base, viewTabState, '', true);

    end
    else
    begin

      ProcessCommand(unicodeSRC, hlDefault);
    end;
    Handled := true;
  end

  else if Pos('http://', unicodeSRC) = 1 then { // WWW }
  begin
    if WStrMessageBox(Format(Lang.Say('GoingOnline'), [unicodeSRC]), 'WWW',
      MB_OKCancel + MB_DEFBUTTON1) = ID_OK then
      ShellExecuteW(Application.Handle, nil, PWideChar(unicodeSRC), nil, nil,
        SW_NORMAL);
    Handled := true;
  end
  else if Pos('mailto:', unicodeSRC) = 1 then
  begin
    ShellExecuteW(Application.Handle, nil, PWideChar(unicodeSRC), nil, nil,
      SW_NORMAL);
    Handled := true;
  end
  else if Pos('verse ', unicodeSRC) = 1 then
  begin
    tbXRef.tag := StrToInt(Copy(unicodeSRC, 7, Length(unicodeSRC) - 6));
    tbComments.tag := tbXRef.tag;

    // MainBook.KJV2RST(MainBook.CurBook, MainBook.CurChapter, tbXRef.Tag, tb,tc,tv);

    // ShowMessage('This verse can be RST ' + IntToStr(tb) + ' ' +
    // IntToStr(tc) + ' ' + IntToStr(tv));

    with MainBook do
      HistoryAdd(Format('go %s %d %d %d %d $$$%s %s', [ShortPath, CurBook,
        CurChapter, tbXRef.tag, 0,
        // history comment
        ShortName, FullPassageSignature(CurBook, CurChapter, tbXRef.tag, 0)]));

    if iscontrolDown or (pgcMain.Visible and (pgcMain.ActivePage = tbComments))
    then
      ShowComments
    else
    begin
      try
        ShowXref;
      finally
        ShowComments;
      end;
    end;

    if not pgcMain.Visible then
      tbtnToggle.Click;
    if ((pgcMain.ActivePage <> tbXRef) or iscontrolDown) and
      (pgcMain.ActivePage <> tbComments) then
      if iscontrolDown then
        pgcMain.ActivePage := tbComments
      else
        pgcMain.ActivePage := tbXRef;
  end
  else if Pos('s', unicodeSRC) = 1 then
  begin
    scode := Copy(unicodeSRC, 2, Length(unicodeSRC) - 1);
    (* *
      Val(scode, num, code);
      if code = 0 then
      DisplayStrongs(num, (MainBook.CurBook < 40) and
      (MainBook.Trait[bqmtOldCovenant]));
      * *)
    edtStrong.Text := scode;
    Key := #13;
    edtStrongKeyPress(Sender, Key);
  end
  else
  begin
    cb := Sender as THTMLViewer;
    if Pos('BQNote', cb.LinkAttributes.Text) > 0 then
    begin
      Handled := true;
      bwrXRef.CharSet := MainBook.desiredCharset;
      try
        if EndsStr('??', cb.Base) then
        begin
          unicodeSRC := ReplaceStr(cb.HtmlExpandFilename(SRC), '??\', '??');
        end
        else
          unicodeSRC := cb.HtmlExpandFilename(SRC);

        lr := LoadAnchor(bwrComments, unicodeSRC, cb.CurrentFile, unicodeSRC);
        if lr then
        begin
          if not pgcMain.Visible then
            tbtnToggle.Click;
          pgcMain.ActivePage := tbComments;
        end;
      except
        g_ExceptionContext.Add('src:' + SRC);
        g_ExceptionContext.Add('base:' + cb.Base);
        g_ExceptionContext.Add('unicodeSrc:' + unicodeSRC);
        g_ExceptionContext.Add('cFile:' + cb.CurrentFile);
        raise;
      end;
    end;
  end // else
  // во всех остальных случаях ссылка обрабатывается по правилам HTML :-)
end;

procedure TMainForm.bwrHtmlHotSpotCovered(Sender: TObject; const SRC: string);
var
  unicodeSRC, ConcreteCmd: string;
  wstr, ws2, fontName, replaceModPath: string;
  bl: TBibleLink;
  ti: TViewTabInfo;
  br: THTMLViewer;
  modIx, status: integer;
begin
  br := Sender as THTMLViewer;
  if (SRC = '') or (br.LinkAttributes.Count < 3) then
  begin
    br.Hint := '';
    bwrHtml.Hint := '';
    Application.CancelHint();
    Exit
  end;
  if Pos(br.LinkAttributes[2], 'CLASS=bqResolvedLink') <= 0 then
    Exit;

  unicodeSRC := SRC;
  wstr := PeekToken(Pointer(unicodeSRC), ' ');
  if SysUtils.WideCompareText(wstr, 'go') <> 0 then
    Exit;

  if Length(wstr) <= 0 then
    Exit;
  ti := GetActiveTabInfo();

  if (br <> bwrHtml) and (ti.mBible.isBible) then
    replaceModPath := ti.mBible.ShortPath
  else
  begin
    modIx := mModules.FindByName(ti.mSatelliteName);
    if modIx >= 0 then
    begin
      replaceModPath := mModules[modIx].wsShortPath;
    end;
  end;
  status := PreProcessAutoCommand(unicodeSRC, replaceModPath, ConcreteCmd);
  if status > -2 then
    status := GetModuleText(ConcreteCmd, fontName, bl, ws2, wstr,
      [gmtBulletDelimited, gmtLookupRefBibles, gmtEffectiveAddress]);

  if status < 0 then
    wstr := ConcreteCmd + #13#10'--не найдено--'
  else
  begin
    wstr := wstr + ' (' + mRefenceBible.ShortName + ')'#13#10;
    if ws2 <> '' then
      wstr := wstr + ws2
    else
      wstr := wstr + '--не найдено--';
  end;

  br.Hint := '';
  br.Hint := wstr;
  HintWindowClass := HintTools.TbqHintWindow;
  Application.CancelHint();
  HintWindowClass := HintTools.TbqHintWindow;
end;

procedure TMainForm.bwrHtmlImageRequest(Sender: TObject; const SRC: string; var Stream: TMemoryStream);
var
  vti: TViewTabInfo;
  archive: string;
  ix, sz: integer;
{$J+}
const
  ms: TMemoryStream = nil;
{$J-}
begin
  try
    vti := pgcViewTabs.Tabs.Objects[pgcViewTabs.TabIndex] as TViewTabInfo;

    if not Assigned(vti) then
      Exit;
    archive := vti.mBible.inifile;
    if (Length(archive) <= 0) or (archive[1] <> '?') then
      Exit;
    getSevenZ().SZFileName := Copy(GetArchiveFromSpecial(archive), 2, $FFFFFF);
    ix := getSevenZ().GetIndexByFilename(SRC, @sz);
    if ix = 0 then
      Exit;
    if not Assigned(ms) then
      ms := TMemoryStream.Create;
    ms.Size := sz;
    getSevenZ().ExtracttoMem(ix, ms.Memory, ms.Size);
    if getSevenZ().ErrCode = 0 then
      Stream := ms;
  except
  end;
end;

(* AlekId:Добавлено *)

function TMainForm.ActivateFont(const fontPath: string): DWORD;
var
  tf: array [0 .. 1023] of Char;
  fileIx, fileSz, tempPathLen: integer;
  wsArchive, wsFile: string;
  pFile: PChar;
  fileHandle: THandle;
  writeResult: BOOL;
  fileNeedsCleanUp: Boolean;
  fontHandle: HFont;
  bytesWritten: DWORD;
begin
  Result := 0;
  fontHandle := 0;
  fileNeedsCleanUp := false;
  wsArchive := fontPath;
  if fontPath[1] = '?' then
  begin
    wsArchive := GetArchiveFromSpecial(fontPath, wsFile);
    fileIx := getSevenZ().GetIndexByFilename(wsFile, @fileSz);
    if (fileIx < 0) or (fileSz <= 0) then
      Exit;
    GetMem(pFile, fileSz);
    try
      getSevenZ().ExtracttoMem(fileIx, pFile, fileSz);
      if getSevenZ().ErrCode <> 0 then
        Exit;
      if (Win32MajorVersion >= 5) and (Assigned(G_AddFontMemResourceEx)) then
      begin
        fontHandle := G_AddFontMemResourceEx(pFile, fileSz, nil, @Result);
      end;
      if Result = 0 then
      begin // старая ось или не удалось в память
        tempPathLen := GetTempPathW(1023, tf);
        if tempPathLen > 1024 then
          Exit;
        wsArchive := tf + wsFile;
        if not FileExists(wsArchive) then
        begin
          fileHandle := CreateFileW(PWideChar(Pointer(wsArchive)),
            GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
          if fileHandle = INVALID_HANDLE_VALUE then
            Exit;
          try
            writeResult := WriteFile(fileHandle, pFile^, fileSz,
              bytesWritten, nil);
          finally
            CloseHandle(fileHandle);
          end;
          fileNeedsCleanUp := true;
          if not writeResult then
            Exit;
        end;
      end // если старая ось или не удалось в память

    finally
      FreeMem(pFile);
    end;
  end // если в архиве
  else
    wsFile := FileRemoveExtension(ExtractFileName(fontPath));
  if Result = 0 then
    Result := AddFontResourceW(PWideChar(Pointer(wsArchive)));

  if Result <> 0 then
  begin
    // SendMessage(HWND_BROADCAST, WM_FONTCHANGE,0,0);
    Screen.Fonts.Add(ExctractName(wsFile));
    G_InstalledFonts.AddObject(ExctractName(wsFile),
      TBQInstalledFontInfo.Create(wsArchive, fileNeedsCleanUp, fontHandle));
  end;
end;

function TMainForm.AddHotModule(const modEntry: TModuleEntry; tag: integer;
  addBibleTab: Boolean = true): integer;
var
  favouriteMenuItem, hotMenuItem: TMenuItem;
  ix: integer;
begin
  Result := -1;
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    if not Assigned(favouriteMenuItem) then
      Exit;
    hotMenuItem := TMenuItem.Create(self);
    hotMenuItem.tag := tag;
    hotMenuItem.Caption := modEntry.wsFullName;
    hotMenuItem.OnClick := HotKeyClick;
    favouriteMenuItem.Add(hotMenuItem);
    if not addBibleTab then
      Exit;
    ix := dtsBible.Tabs.Count - 1;

    dtsBible.Tabs.Insert(ix, modEntry.VisualSignature());
    dtsBible.Tabs.Objects[ix] := modEntry;
    // dtsBible.WideTabs.Objects[tag] :=modEntry;
  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;
(* AlekId:/Добавлено *)

procedure TMainForm.btnAddressOKClick(Sender: TObject);
begin
  edtGoDblClick(Sender);
end;

procedure TMainForm.GoPrevChapter;
var
  cmd: string;
begin
  mScrollAcc := 0;
  if sbxPreview.Visible then
  begin
    if CurPreviewPage > 0 then
      CurPreviewPage := CurPreviewPage - 1;
    Exit;
  end;

  if not tbtnPrevChapter.Enabled then
    Exit;

  with MainBook do
    if CurChapter > 1 then
      cmd := Format('go %s %d %d', [ShortPath, CurBook, CurChapter - 1])
    else if CurBook > 1 then
      cmd := Format('go %s %d %d', [ShortPath, CurBook - 1, ChapterQtys[CurBook - 1]]);

  HistoryOn := false;
  ProcessCommand(cmd, hlFalse);
  HistoryOn := true;

  // ShowXref;
  tbComments.tag := 0;
  ShowComments;
  ActiveControl := bwrHtml;
end;

procedure TMainForm.GoNextChapter;
var
  cmd: string;
begin
  mScrollAcc := 0;
  if sbxPreview.Visible then
  begin
    if CurPreviewPage < MFPrinter.LastAvailablePage - 1 then
      CurPreviewPage := CurPreviewPage + 1;
    Exit;
  end;

  if not tbtnNextChapter.Enabled then
    Exit;

  with MainBook do
    if CurChapter < ChapterQtys[CurBook] then
      cmd := Format('go %s %d %d', [ShortPath, CurBook, CurChapter + 1])
    else if CurBook < BookQty then
      cmd := Format('go %s %d %d', [ShortPath, CurBook + 1, 1]);

  HistoryOn := false;
  ProcessCommand(cmd, hlFalse);
  HistoryOn := true;

  // ShowXref;
  tbComments.tag := 0;
  ShowComments;
  ActiveControl := bwrHtml;
end;

procedure SetButtonHint(aButton: TToolButton; aMenuItem: TMenuItem);
begin
  aButton.Hint := aMenuItem.Caption + ' (' +
    ShortCutToText(aMenuItem.ShortCut) + ')';
end;

function TMainForm.TranslateInterface(locFile: string): Boolean;
var
  i: integer;
  s: string;
  fnt: TFont;
  locDirectory: string;
  locFilePath: string;
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

  TranslateForm(MyLibraryForm);
  TranslateForm(ExceptionForm);
  TranslateForm(AboutForm);

  for i := 0 to miLanguage.Count - 1 do
    with miLanguage.Items[i] do
      Checked := LowerCase(Caption + '.lng') = LowerCase(locFile);

  TranslateConfigForm;

  LockWindowUpdate(self.Handle);

  try
    Lang.TranslateForm(MainForm);
  finally
    LockWindowUpdate(0);
  end;

  miCopySelection.Caption := miCopy.Caption;

  // initialize Toolbar
  SetButtonHint(tbtnToggle, miToggle);

  // SetButtonHint(tbtnPrevChapter, miPrevChapter);
  // SetButtonHint(tbtnNextChapter, miNextChapter);
  SetButtonHint(tbtnCopy, miCopy);
  // SetButtonHint(BookmarkButton, miBookmark);
  // SetButtonHint(HistoryButton, miHistory);
  SetButtonHint(tbtnPrint, miPrint);
  SetButtonHint(tbtnPreview, miPrintPreview);
  SetButtonHint(tbtnSound, miSound);

  SetButtonHint(tbtnStrongNumbers, miStrong);
  SetButtonHint(tbtnNewTab, miNewTab);
  SetButtonHint(tbtnCloseTab, miCloseTab);

  tbtnMemos.Hint := miMemosToggle.Caption + ' (' +
    ShortCutToText(miMemosToggle.ShortCut) + ')';

  cbList.ItemIndex := 0;

  if Lang.Say('HelpFileName') <> 'HelpFileName' then
    HelpFileName := Lang.Say('HelpFileName');

  Application.Title := MainForm.Caption;
  trayIcon.Hint := MainForm.Caption;

  if MainBook.inifile <> '' then
  begin
    with MainBook do
      s := ShortName + ' ' + FullPassageSignature(
        CurBook, CurChapter, CurFromVerse, CurToVerse);

    if MainBook.Copyright <> '' then
      s := s + '; © ' + MainBook.Copyright
    else
      s := s + '; ' + Lang.Say('PublicDomainText');

    lblTitle.Hint := s + '   ';

    if Length(lblTitle.Hint) < 83 then
      lblTitle.Caption := lblTitle.Hint
    else
      lblTitle.Caption := Copy(lblTitle.Hint, 1, 80) + '...';

    tbtnCopyright.Hint := s;

    UpdateBooksAndChaptersBoxes();
    SearchListInit;
  end;

  fnt := TFont.Create;
  fnt.Name := MainForm.Font.Name;
  fnt.Size := MainForm.Font.Size;

  // s := Lang.Say('Charset');
  // if s = 'Charset' then s:='204';
  // fnt.Charset := StrToInt(s);

  MainForm.Font := fnt;

  Update;
  fnt.Free;
  // MainMenu := Self.Menu.Handle;

  // GET Help Menu Item Info


  // i:=mmGeneral.Items.IndexOf(miLanguage);
  // ModifyMenuW(mmGeneral.Handle, i, MF_BYPOSITION or MF_RIGHTJUSTIFY,
  // i, 'UI Language');

end;

procedure TMainForm.ChapterComboBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    AddressFromMenus := true;
    NavigateToInterfaceValues();
  end;
end;

procedure TMainForm.tbtnPrintClick(Sender: TObject);
begin
  with PrintDialog do
    if Execute then
      bwrHtml.Print(MinPage, MaxPage);
end;

procedure TMainForm.tbtnQuickSearchClick(Sender: TObject);
begin
  ToggleQuickSearchPanel(tbtnQuickSearch.Down);
end;

procedure TMainForm.tbtnQuickSearchNextClick(Sender: TObject);
begin
  SearchForward();
end;

procedure TMainForm.tbtnQuickSearchPrevClick(Sender: TObject);
begin
  SearchBackward();
end;

// --------- preview begin

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

    pnlMain.Visible := true;
    ActiveControl := bwrHtml;

    pgcMain.Visible := refvisible;

    Screen.Cursor := crDefault;
  end
  else
  begin
    refvisible := pgcMain.Visible;

    MFPrinter := TMetaFilePrinter.Create(self);
    bwrHtml.PrintPreview(MFPrinter);

    ZoomIndex := 0;
    CurPreviewPage := 0;

    sbxPreview.OnResize := nil;

    pgcMain.Visible := false;

    pnlMain.Visible := false;
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
begin
  bibleTabsCount := dtsBible.Tabs.Count - 1;
  curItem := dtsBible.TabIndex;
  if bibleTabsCount > 9 then
    bibleTabsCount := 9
  else
    Dec(bibleTabsCount);
  for i := 0 to bibleTabsCount do
  begin
    s := dtsBible.Tabs[i];
    if showHints then
    begin
      if (i < 9) then
        num := i + 1
      else
        num := 0;
      dtsBible.Tabs[i] := Format('%d-%s', [num, s]);
    end
    else
    begin
      if (s[2] <> '-') or (not CharInSet(Char(s[1]), ['0' .. '9'])) then
        break;
      dtsBible.Tabs[i] := Copy(s, 3, $FFFFFF);
    end;
  end; // for

  if showHints then
  begin
    dtsBible.FirstIndex := 0;
    dtsBible.TabIndex := curItem;
  end
  else
  begin
    saveOnChange := dtsBible.OnChange;
    dtsBible.OnChange := nil;
    if curItem > 0 then
      dtsBible.TabIndex := curItem - 1;
    dtsBible.TabIndex := curItem;
    dtsBible.OnChange := saveOnChange;
  end;

  mBibleTabsInCtrlKeyDownState := showHints;
end;

procedure TMainForm.SetCurPreviewPage(Val: integer);
begin
  FCurPreviewPage := Val;
  pbPreview.Invalidate;
end;

{ AlekId: добавлено }{ назначение горячих клавиш любимым модулям }

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
      // hotMenuItem.Tag := 7000 + j;
      if j < 9 then
        hotMenuItem.ShortCut := ShortCut($31 + j, [ssCtrl])
      else if j = 9 then
        hotMenuItem.ShortCut := ShortCut($30, [ssCtrl])
      else
        hotMenuItem.ShortCut := 0;
      inc(j)
    end;

  except
  end;
end;

procedure TMainForm.SetFirstTabInitialLocation(wsCommand, wsSecondaryView
  : string; const Title: string; state: TViewtabInfoState;
  visual: Boolean);
var
  vti: TViewTabInfo;
begin
  if Length(wsCommand) > 0 then
    LastAddress := wsCommand;

  ClearVolatileStateData(state);
  vti := TViewTabInfo(pgcViewTabs.Tabs.Objects[0]);
  vti.mSatelliteName := wsSecondaryView;
  vti.mState := state;
  vti.mwsTitle := Title;
  vti.mwsLocation := LastAddress;
  pgcViewTabs.Tabs[0] := Title;
  pgcViewTabs.Tabs.Objects[0] := vti;
  if visual then
  begin

    StrongNumbersOn := vtisShowStrongs in state;
    MemosOn := vtisShowNotes in state;
    MainBook.RecognizeBibleLinks := vtisResolveLinks in state;
    MainBook.FuzzyResolve := vtisFuzzyResolveLinks in state;
    SafeProcessCommand(LastAddress, hlDefault);
    UpdateUI();
  end
  else
  begin
    Include(vti.mState, vtisPendingReload);
  end;

end;

procedure TMainForm.SetNodeText(tree: TVirtualDrawTree; Node: PVirtualNode;
  Column: TColumnIndex; const Text: string);
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
      MessageBoxW(self.Handle, Pointer(Lang.SayDefault('bqVerseTagNotUnique',
        C_TagRenameError)), Pointer(Lang.SayDefault('bqError', 'Error')),
        MB_OK or MB_ICONERROR)

    else if rslt = -2 then
      MessageBoxW(self.Handle, Pointer(Lang.SayDefault('bqErrorUnknown',
        'Unknown Error')), Pointer(Lang.SayDefault('bqError', 'Error')),
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
{ procedure TMainForm.SetStrongsAndNotesState(showStrongs, showNotes: boolean;
  ti: TViewTabInfo);
  begin
  ti.mShowStrongs:=showStrongs;
  ti.mShowNotes:=showNotes;
  StrongNumbersOn:=showStrongs;
  MemosOn:=showNotes;
  {cti:= GetActiveTabInfo();
  if assigned(cti) and cti=ti then begin

  tbtnStrongNumbers.Down:=showStrongs;
  miStrong.Checked:=showStrongs;
  miMemosToggle.Checked:=showNotes;
  tbtnMemos.Down:=showNotes;
  end;
  end; }

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
  SetWindowExtEx(PB.Canvas.Handle, MFPrinter.PaperWidth,
    MFPrinter.PaperHeight, nil);
  SetViewportExtEx(PB.Canvas.Handle, PB.Width, PB.Height, nil);
  SetWindowOrgEx(PB.Canvas.Handle, -MFPrinter.OffsetX, -MFPrinter.OffsetY, nil);
  if Draw then
    DrawMetaFile(PB, MFPrinter.MetaFiles[page]);
end;

procedure TMainForm.pmRecLinksOptionsChange(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
begin

end;

{ AlekId:добавлено - функция отображения диалога ввода пароля }

function TMainForm.PaintTokens(canv: TCanvas; rct: TRect; tkns: TObjectList;
  calc: Boolean): integer;

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
    Windows.DrawTextW(canv.Handle, PWideChar(Pointer(ws)), -1, rects[i],
      DT_TOP or DT_CALCRECT or DT_SINGLELINE);
    if (rects[i].Right > rct.Right) and (rects[i].Left > rct.Left) then
    begin
      rects[i].Left := rct.Left;
      rects[i].Top := rects[i].Bottom + fh;
      Windows.DrawTextW(canv.Handle, PWideChar(Pointer(ws)), -1, rects[i],
        DT_TOP or DT_CALCRECT or DT_SINGLELINE);
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
      Windows.DrawTextW(canv.Handle, PWideChar(Pointer(ws)), -1, rects[i],
        DT_TOP or DT_SINGLELINE);

  Result := rects[C].Bottom;

end;

function TMainForm.PassWordFormShowModal(const aModule: WideString; out Pwd: WideString; out savePwd: Boolean): integer;
var { modPath: WideString; }
  modName: string;
  i { , arcCount } : integer;
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
      modName := mModules[i].wsFullName;
    if not Assigned(PasswordBox) then
      PasswordBox := TPasswordBox.Create(self);
    with PasswordBox do
    begin
      Font.Assign(self.Font);
      lblPasswordNeeded.Caption :=
        Format(Lang.SayDefault('lblPasswordNeeded',
        'Для открытия модуля нужно ввести пароль (%s)'), [modName]);
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
{ AlekId:/добавлено }

procedure TMainForm.pbPreviewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
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

// --------- preview end

function TMainForm.ProcessCommand(s: string; hlVerses: TbqHLVerseOption): Boolean;
var
  value, dup, path, oldPath, ConcreteCmd: string;
  // book, chapter, fromverse, toverse, focusVerse: integer;
  focusVerse: integer;
  i, j, oldbook, oldchapter, status: integer;
  wasSearchHistory, wasFile: Boolean;
  browserpos: Longint;
  offset: integer;
  dBrowserSource: string;
  oldSignature: string;
  navRslt: TbqNavigateResult;
  bibleLink: TBibleLinkEx;
  ti: TViewTabInfo;
label
  exitlabel;

  procedure revertToOldLocation();
  begin
    if oldPath = '' then
    begin
      oldPath := MainFileExists(TPath.Combine(mDefaultLocation, C_ModuleIniName));
      if bwrHtml.GetTextLen() <= 0 then
      begin
        ProcessCommand(Format('go %s 1 1 1', [mDefaultLocation]), hlFalse);
        Exit
      end;
    end;

    MainBook.inifile := oldPath;
    bibleLink.modName := MainBook.ShortPath;
    bibleLink.book := oldbook;
    bibleLink.chapter := oldchapter;
    UpdateUI();
  end;

begin
  Result := false;

  if s = '' then
    Exit; // выйти, если команда пустая
  Screen.Cursor := crHourGlass;
  mInterfaceLock := true;
  try
    wasFile := false;
    browserpos := bwrHtml.Position;
    bwrHtml.tag := bsText;

    oldPath := MainBook.inifile;
    oldbook := MainBook.CurBook;
    oldchapter := MainBook.CurChapter;

    dup := s; // копия команды

    if bibleLink.FromBqStringLocation(dup) then
    begin
      // AlekId : search #0001

      // формируем путь к ini модуля
      if bibleLink.IsAutoBible() then
      begin
        if MainBook.isBible then
          value := MainBook.ShortPath
        else if SecondBook.isBible then
          value := SecondBook.ShortPath
        else
          value := '';
        status := PreProcessAutoCommand(dup, value, ConcreteCmd);
        if status <= -2 then
          Exit; // fail
        bibleLink.FromBqStringLocation(ConcreteCmd);
      end;

      path := MainFileExists(bibleLink.GetIniFileShortPath());

      // ??! никогда ветвление это не сработает
      if Length(path) < 1 then
        goto exitlabel;

      oldSignature := MainBook.FullPassageSignature(MainBook.CurBook, MainBook.CurChapter, 0, 0);

      // пытаемся подгрузить модуль
      if path <> MainBook.inifile then
        try
          MainBook.inifile := path;
        except // если что-то не так -- откат
          revertToOldLocation();
        end;

      try
        // читаем, отображаем адрес

        navRslt := GoAddress(bibleLink.book, bibleLink.chapter, bibleLink.vstart, bibleLink.vend, hlVerses);
        // записываем историю
        if navRslt > nrEndVerseErr then
        begin
          focusVerse := 0;
        end;

        with MainBook do
          if (bibleLink.vstart = 0) or (navRslt > nrEndVerseErr) then
            // если конечный стих не указан
            // выглядит как
            // "go module_folder book_no Chapter_no verse_start_no 0 mod_shortname

            s := Format('go %s %d %d %d 0 $$$%s %s',
              [ShortPath, CurBook, CurChapter, focusVerse,
              // history comment
              ShortName, FullPassageSignature(CurBook, CurChapter, bibleLink.vstart, 0)])
          else
            s := Format('go %s %d %d %d %d $$$%s %s',
              [ShortPath, CurBook, CurChapter, bibleLink.vstart, bibleLink.vend,
              // history comment
              ShortName,
              FullPassageSignature(CurBook, CurChapter, bibleLink.vstart, bibleLink.vend)]
            );

        HistoryAdd(s);
        (* AlekId:Добавлено *)
        // here we set proper name to tab
        with MainBook, pgcViewTabs do
        begin
          if pgcViewTabs.TabIndex >= 0 then
            try

              ti := GetActiveTabInfo();
              // сохранить контекст
              ti.mwsLocation := s;
              ti.mLocationType := vtlModule;

              ti.mIsCompareTranslation := false;
              ti.mCompareTranslationText := '';

              if navRslt <= nrEndVerseErr then
                ti[vtisHighLightVerses] := hlVerses = hlTrue
              else
                ti[vtisHighLightVerses] := false;
              ti.mwsTitle := Format('%.6s-%.6s:%d', [ShortName, ShortNames[CurBook], CurChapter - ord(Trait[bqmtZeroChapter])]);
              pgcViewTabs.Tabs[pgcViewTabs.TabIndex] := ti.mwsTitle;

            except
              on E: Exception do
                BqShowException(E);
            end;
        end; // with MainBook, mMainViewTabs

        LastAddress := s;
      except
        on E: TBQPasswordException do
        begin
          PasswordPolicy.InvalidatePassword(E.mArchive);
          MessageBoxW(self.Handle, PWideChar(Pointer(E.mWideMsg)), nil, MB_ICONERROR or MB_OK);
          revertToOldLocation();
        end;
        on E: TBQException do
        begin
          MessageBoxW(self.Handle, PWideChar(Pointer(E.mWideMsg)), nil, MB_ICONERROR or MB_OK);
          revertToOldLocation();
        end
        else
          revertToOldLocation(); // в любом случае
      end;

      goto exitlabel;
    end; // first word is go

    if FirstWord(dup) = 'file' then
    begin
      wasFile := true; // *** - not a favorite
      wasSearchHistory := false;
      // if a Bible path was stored with file... (after search procedure)
      i := Pos('***', dup);
      if i > 0 then
      begin
        j := Pos('$$$', dup);
        value := MainFileExists(TPath.Combine(Copy(dup, i + 3, j - i - 4), 'bibleqt.ini'));
        if MainBook.inifile <> value then
          MainBook.inifile := value;
        wasSearchHistory := true;
      end;

      DeleteFirstWord(dup);

      i := Pos('***', dup);
      if i = 0 then
        i := Length(dup);
      j := Pos('$$$', dup);

      if i > j then
        path := Copy(dup, 1, j - 1)
      else
        path := Copy(dup, 1, i - 1);

      if not FileExists(path) then
      begin
        ShowMessage(Format(Lang.Say('FileNotFound'), [path]));
        goto exitlabel;
      end;

      bwrHtml.Base := ExtractFilePath(path);

      ReadHtmlTo(path, dBrowserSource, TEncoding.GetEncoding(1251));

      if wasSearchHistory then
      begin
        StrReplace(dBrowserSource, '<*>', '<font color="' + SelTextColor + '">', true);
        StrReplace(dBrowserSource, '</*>', '</font>', true);

      end;
      ti := GetActiveTabInfo();
      if ti[vtisResolveLinks] then
      begin
        dBrowserSource := ResolveLnks(dBrowserSource, ti[vtisFuzzyResolveLinks]);
      end;
      bwrHtml.LoadFromString(dBrowserSource);
      value := '';
      if Trim(bwrHtml.DocumentTitle) <> '' then
        value := bwrHtml.DocumentTitle
      else
        value := ExtractFileName(path);

      if Length(value) <= 0 then
        try
          value := 'Unknown';
          raise Exception.Create('File open- cannot extract valid name');
        except
          on E: Exception do
            BqShowException(E);
        end;
      {
        if wasSearchHistory then
        MainTabs.Tabs[MainTabs.TabIndex] := value
        else
        MainTabs.Tabs[MainTabs.TabIndex] := ExtractFileName(path);
      }
      // MainForm.Caption := Application.Title + ' — ' +
      // TitleLabel.Caption := '  ' + value;
      // TitleLabel.Font.Style := [fsBold];

      // TabBuffers[MainTabs.TabIndex] := s;

      if (History.Count > 0) and (History[0] = s) then
        bwrHtml.Position := browserpos;

      HistoryAdd(s);
      if wasSearchHistory then
        bwrHtml.tag := bsSearch
      else
        bwrHtml.tag := bsFile;
      (* AlekId:Добавлено *)
      ti := GetActiveTabInfo();
      ti.mwsTitle := Format('%.12s', [value]);
      pgcViewTabs.Tabs[pgcViewTabs.TabIndex] := ti.mwsTitle;
      ti.mwsLocation := s;
      ti.mLocationType := vtlFile;

      ti.mIsCompareTranslation := false;
      ti.mCompareTranslationText := '';

      (* AlekId:/Добавлено *)
      goto exitlabel;
    end; // first word is "file"

    if ExtractFileName(dup) = dup then
      try
        bwrHtml.LoadFromFile(bwrHtml.Base + dup);
        (* AlekId:Добавлено *)
        ti := GetActiveTabInfo();
        ti.mwsTitle := Format('%.12s', [s]);
        pgcViewTabs.Tabs[pgcViewTabs.TabIndex] := ti.mwsTitle;

        ti.mwsLocation := s;
        ti.mLocationType := vtlFile;

        ti.mIsCompareTranslation := false;
        ti.mCompareTranslationText := '';

        (* AlekId:/Добавлено *)
      except
        on E: Exception do
          BqShowException(E);
      end;

  exitlabel:

    // ActiveControl := Browser;
    // miStrong.Enabled := MainBook.StrongNumbers;
    if Length(path) <= 0 then
      Exit;
    Result := true;

    i := cbModules.Items.IndexOf(MainBook.Name);
    if i <> cbModules.ItemIndex then
      cbModules.ItemIndex := i;

    i := MainBook.CurBook - 1;
    if MainBook.BookQty > 0 then
    begin
      if i <> lbBook.ItemIndex then
        lbBook.ItemIndex := i;

      // lbBookClick(Self);
      // copy of lbBookClick....
      if (oldPath <> bibleLink.modName) or (oldbook <> bibleLink.book) or
        (lbChapter.Items.Count = 0) then
        with lbChapter do
        begin
          Items.BeginUpdate;
          Items.Clear;

          offset := 0;
          if MainBook.Trait[bqmtZeroChapter] then
            offset := 1;

          for i := 1 to MainBook.ChapterQtys[lbBook.ItemIndex + 1] do
            Items.Add(IntToStr(i - offset));
          Items.EndUpdate;
          ItemIndex := 0;
        end;
      i := MainBook.CurChapter - 1;
      if lbChapter.ItemIndex <> i then
      begin
        // j:=GetScrollPos(lbChapter.Handle,SB_VERT);
        lbChapter.ItemIndex := i;
        // if j>0 then SetScrollPos(lbChapter.Handle,SB_VERT, j, false);
        if i > 5 then
          lbChapter.TopIndex := i - 5;

      end;
    end;
    if (not wasFile) then
      AdjustBibleTabs();
    if lbHistory.ItemIndex <> -1 then
    begin
      tbtnBack.Enabled := lbHistory.ItemIndex < lbHistory.Items.Count - 1;
      tbtnForward.Enabled := lbHistory.ItemIndex > 0;
    end;
  finally
    mInterfaceLock := false;
    Screen.Cursor := crDefault;
  end;
end; // proc processcommand

procedure TMainForm.HistoryButtonClick(Sender: TObject);
begin
  if History.Count = 0 then
    Exit;
  // ResultPages.ActivePage := tbHistory;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  OldKey: Word;
  hotMenuItem: TMenuItem;
  tryCount: integer;
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
          else if ActiveControl = bwrHtml then
            tbtnCopy.Click
          else if ActiveControl is THTMLViewer then
          begin
            tryCount := 7;
            repeat
              try

                // if (CopyOptionsCopyVerseNumbersChecked xor (IsDown(VK_CONTROL))) then
                (ActiveControl as THTMLViewer).CopyToClipboard;
                // else   TntClipboard.AsText := (ActiveControl as THTMLViewer).SelText;
                tryCount := 0;
              except
                Dec(tryCount);
              end;
            until tryCount <= 0;
          end // if webbr
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
        GoRandomPlace;
      ord('F'):
        ShowQuickSearch();
      ord('M'):
        miMemosToggle.Click;

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
            hotMenuItem := FavouriteItemFromModEntry
              (TModuleEntry(mFavorites.mModuleEntries[10]));
          if Assigned(hotMenuItem) then
            hotMenuItem.Click();
        end;

      ord('1') .. ord('9'):
        begin
          if mFavorites.mModuleEntries.Count >= (ord(OldKey) - ord('0')) then
            hotMenuItem := FavouriteItemFromModEntry
              (TModuleEntry(mFavorites.mModuleEntries[ord(OldKey) -
              ord('0') - 1]));

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

    VK_F1:
      miHelp.Click;
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
begin
  with OpenDialog do
  begin
    if InitialDir = '' then
      InitialDir := ExePath;

    Filter := 'HTML (*.htm, *.html)|*.htm;*.html|*.*|*.*';

    if Execute then
    begin
      ProcessCommand('file ' + FileName + ' $$$' + FileName, hlDefault);
      InitialDir := ExtractFilePath(FileName);
    end;
  end;
end;

procedure TMainForm.SearchButtonClick(Sender: TObject);
begin
  ShowSearchTab();
end;

procedure TMainForm.cbSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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

{ Alek }(* AlekId:Добавлено *)

procedure TMainForm.edtSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    SearchForward();
  end;
end;
(* AlekId:/Добавлено *)

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    if not pnlMain.Visible then
      { previewing }
      miPrintPreview.Click // this turns preview off
    else
    begin
      if IsSearching then
        btnFindClick(Sender)
      else
      begin
        // exit from edtGo (F2) or cbSearch (F3) to Browser
        if (ActiveControl = edtGo) or (ActiveControl = cbSearch) then
          ActiveControl := bwrHtml;

        // Application.Minimize;
        { wrap to title bar like KDE/Linux
          if MainForm.Height > 100 then
          begin
          MainFormTempHeight := MainForm.Height;
          MainForm.Height := 0;
          //          MainForm.FormStyle := fsStayOnTop;
          end else
          begin
          MainForm.Height := MainFormTempHeight;
          //          MainForm.FormStyle := fsNormal;
          end;
        }
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

procedure TMainForm.edtGoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    edtGoDblClick(Sender);
  end;
end;

function TMainForm.FavouriteItemFromModEntry(const me: TModuleEntry): TMenuItem;
var
  favouriteMenuItem: TMenuItem;
  cnt, i: integer;
begin
  Result := nil;
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    cnt := favouriteMenuItem.Count - 1;
    i := 0;
    while i <= cnt do
    begin
      Result := TMenuItem(favouriteMenuItem.Items[i]);
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

function TMainForm.FavouriteTabFromModEntry(const me: TModuleEntry): integer;
var
  i, cnt: integer;

begin
  Result := -1;
  cnt := dtsBible.Tabs.Count - 1;
  i := 0;
  while i <= cnt do
  begin
    if dtsBible.Tabs.Objects[i] = me then
      break;
    inc(i);
  end;
  if i <= cnt then
    Result := i;
end;

function TMainForm.FilterCommentariesCombo: integer;
var
  vti: TViewTabInfo;
  bl: TBibleLinkEx;
  ibl: TBibleLink;
  getAddress, doFilter: Boolean;
  linkValidStatus, addIndex, selIndex: integer;
  commentaryModule: TModuleEntry;
  lastCmt: WideString;
begin
  Result := -1;
  doFilter := btnOnlyMeaningful.Down;
  vti := GetActiveTabInfo();
  if (vti = nil) then
    Exit;
  getAddress := bl.FromBqStringLocation(vti.mwsLocation);
  if getAddress then
  begin
    linkValidStatus := MainBook.ReferenceToInternal(bl, ibl);
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
        SecondBook.inifile := commentaryModule.getIniPath();
        linkValidStatus := SecondBook.LinkValidnessStatus(SecondBook.inifile,
          ibl, true, false);
        if (linkValidStatus > -2) or (not getAddress) or (not doFilter) then
        begin
          addIndex := cbComments.Items.Add(commentaryModule.wsFullName);
          if OmegaCompareTxt(commentaryModule.wsFullName, lastCmt, -1, true) = 0
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
          ix := bqWidePosCI(FilterText, vnd.getText());
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

  function metabook(const str: WideString): Boolean;
  var
    wl: string;

  label success;
  begin
    wl := WideLowerCase(str);
    if (Pos('нз', wl) = 1) or (Pos('nt', wl) = 1) then
    begin

      if MainBook.Trait[bqmtNewCovenant] and MainBook.InternalToReference(40, 1,
        1, book, chapter, v1) then
      begin
        s := s + [39 .. 65];
      end;
      goto success;
    end
    else if (Pos('вз', wl) = 1) or (Pos('ot', wl) = 1) then
    begin
      if MainBook.Trait[bqmtOldCovenant] and MainBook.InternalToReference(1, 1, 1,
        book, chapter, v1) then
      begin
        s := s + [0 .. 38];
      end;
      goto success;
    end
    else if (Pos('пят', wl) = 1) or (Pos('pent', wl) = 1) or
      (Pos('тор', wl) = 1) or (Pos('tor', wl) = 1) then
    begin
      if MainBook.Trait[bqmtOldCovenant] and MainBook.InternalToReference(1, 1, 1,
        book, chapter, v1) then
      begin
        s := s + [0 .. 4];
      end;
      goto success;
    end
    else if (Pos('ист', wl) = 1) or (Pos('hist', wl) = 1) then
    begin
      if MainBook.Trait[bqmtOldCovenant] then
      begin
        s := s + [0 .. 15];
      end;
      goto success;
    end
    else if (Pos('уч', wl) = 1) or (Pos('teach', wl) = 1) then
    begin
      if MainBook.Trait[bqmtOldCovenant] then
      begin
        s := s + [16 .. 21];
      end;
      goto success;
    end
    else if (Pos('бпрор', wl) = 1) or (Pos('bproph', wl) = 1) then
    begin
      if MainBook.Trait[bqmtOldCovenant] then
      begin
        s := s + [22 .. 26];
      end;
      goto success;
    end
    else if (Pos('мпрор', wl) = 1) or (Pos('mproph', wl) = 1) then
    begin
      if MainBook.Trait[bqmtOldCovenant] then
      begin
        s := s + [27 .. 38];
      end;
      goto success;
    end
    else if (Pos('прор', wl) = 1) or (Pos('proph', wl) = 1) then
    begin
      if MainBook.Trait[bqmtOldCovenant] then
      begin
        s := s + [22 .. 38];
        if MainBook.Trait[bqmtNewCovenant] and MainBook.InternalToReference(66, 1,
          1, book, chapter, v1) then
        begin
          Include(s, 65);
        end;
        goto success;
      end
    end
    else if (Pos('ева', wl) = 1) or (Pos('gos', wl) = 1) then
    begin
      if MainBook.Trait[bqmtNewCovenant] then
      begin
        s := s + [39 .. 42];
      end;
      goto success;
    end
    else if (Pos('пав', wl) = 1) or (Pos('paul', wl) = 1) then
    begin
      if MainBook.Trait[bqmtNewCovenant] and MainBook.InternalToReference(52, 1,
        1, book, chapter, v1) then
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
  if cbQty.ItemIndex < cbQty.Items.Count - 1 then
    SearchPageSize := StrToInt(cbQty.Items[cbQty.ItemIndex])
  else
    SearchPageSize := 50000;

  if IsSearching then
  begin
    IsSearching := false;
    MainBook.StopSearching;
    Screen.Cursor := crDefault;
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    IsSearching := true;

    s := [];

    if (not MainBook.isBible) { or
      (not MainBook.Trait[bqmtOldCovenant]) or (not MainBook.Trait[bqmtNewCovenant]) }
    then
    begin
      if (cbList.ItemIndex <= 0) then
        s := [0 .. MainBook.BookQty - 1]
        // for i := 1 to MainBook.BookQty do s := s + [i-1];
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
            if SysUtils.WideCompareText(cbList.Items[i], data) = 0 then
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
            if metabook(lnks[i]) then
            begin

              books := books + FirstWord(lnks[i]) + ' ';
              continue
            end
            else if MainBook.OpenReference(lnks[i], book, chapter, v1, v2) and
              (book > 0) and (book < 77) then
            begin
              Include(s, book - 1);
              if Pos(MainBook.ShortNames[book], books) <= 0 then
              begin

                books := books + MainBook.ShortNames[book] + ' ';
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
              if MainBook.Trait[bqmtApocrypha] then
                s := [66 .. MainBook.BookQty - 1]
              else
                s := [0];
            end;
        else
          s := [cbList.ItemIndex - 8 - ord(MainBook.Trait[bqmtApocrypha])];
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
    // cbSearch.Text := data;

    if data <> '' then
    begin
      // if SingleLetterDelete(data) then
      // ShowMessage(Lang.Say('OneLetterWordsDeleted'));

      // cbSearch.Text := data;
      if cbSearch.Items.IndexOf(data) < 0 then
        cbSearch.Items.Insert(0, data);

      SearchResults.Clear;
      // SearchLB.Items.Clear;

      SearchWords.Clear;
      wrd := cbSearch.Text;

      if not chkExactPhrase.Checked then
      begin
        while wrd <> '' do
        begin
          wrdnew := DeleteFirstWord(wrd);

          // if not chkCase.Checked then
          // begin
          // SearchWords.Add(UpperCaseFirstLetter(wrdnew)); // Господь
          // SearchWords.Add(WideLowerCase(wrdnew)); // господь
          // SearchWords.Add(WideUpperCase(wrdnew)); // LORD OF LORDS, in English :-)
          // end
          // else
          SearchWords.Add(wrdnew);
        end;
      end
      else
      begin
        wrdnew := Trim(wrd);
        // SearchWords.Add(UpperCaseFirstLetter(wrdnew)); // Господь
        // SearchWords.Add(WideLowerCase(wrdnew)); // господь
        // SearchWords.Add(WideUpperCase(wrdnew)); // LORD OF LORDS, in English :-)
        SearchWords.Add(wrdnew);
      end;

      params := spWordParts * (1 - ord(chkParts.Checked)) + spContainAll *
        (1 - ord(chkAll.Checked)) + spFreeOrder * (1 - ord(chkPhrase.Checked)) +
        spAnyCase * (1 - ord(chkCase.Checked)) + spExactPhrase *
        ord(chkExactPhrase.Checked);

      if (params and spExactPhrase = spExactPhrase) and
        (params and spWordParts = spWordParts) then
        params := params - spWordParts;
      SearchTime := GetTickCount;
      MainBook.Search(data, params, s);
    end;
  finally
    Screen.Cursor := crDefault;
  end
end;

procedure TMainForm.MainBookSearchComplete(Sender: TObject);
begin
  IsSearching := false;
  SearchTime := GetTickCount - SearchTime;
  lblSearch.Caption := lblSearch.Caption + ' (' + IntToStr(SearchTime) + ')';
  DisplaySearchResults(1);
  // ProcessCommand(History[lbHistory.Count-1]);
  // ProcessCommand(History[0]);
end;

procedure TMainForm.FontChanged(delta: integer);
var
  defFontSz, browserpos: integer;
begin
  defFontSz := bwrHtml.DefFontSize;
  if ((delta > 0) and (defFontSz > 48)) or ((delta < 0) and (defFontSz < 6))
  then
    Exit;
  inc(defFontSz, delta);
  Screen.Cursor := crHourGlass;
  try
    bwrHtml.DefFontSize := defFontSz;
    browserpos := bwrHtml.Position and $FFFF0000;

    bwrHtml.LoadFromString(bwrHtml.DocumentSource);
    bwrHtml.Position := browserpos;

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

  procedure _finalizeViewTabs();
  var
    i, C: integer;
  begin
    C := pgcViewTabs.Tabs.Count - 1;
    for i := 0 to C do
    begin
      (TObject(pgcViewTabs.Tabs.Objects[i]) as TViewTabInfo).Free();
    end;
  end;

begin
  if MainForm.Height < 100 then
    MainForm.Height := 420;

  writeln(bqNowDateTimeString(), 'FormClose entered');
  SaveConfiguration;
  Flush(Output);
  // mBqEngine.Free();
  // mBqEngine.Free();
  mBqEngine.Finalize();
  mBqEngine := nil;
  BibleLinkParser.FinalizeParser();
  (* AlekId:Добавлено *)
  try
    { CacheDicPaths.Free(); CacheDicTitles.Free(); CacheModPaths.Free();
      CacheModTitles.Free(); }// ModulesList.Free();
    // ModulesCodeList.Free();
    GfxRenderers.TbqTagsRenderer.Done();
    FreeAndNil(Memos);
    FreeAndNil(Bookmarks);
    FreeAndNil(History);
    FreeAndNil(SearchResults);
    FreeAndNil(SearchWords);
    FreeAndNil(StrongHebrew);
    FreeAndNil(StrongGreek);
    _finalizeViewTabs();
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
begin
  if (not MainBook.isBible) then
    with cbList do
    begin
      Items.BeginUpdate;
      Items.Clear;

      Items.AddObject(Lang.Say('SearchAllBooks'), TObject(0));

      for i := 1 to MainBook.BookQty do
        Items.AddObject(MainBook.FullNames[i], TObject(i));

      Items.EndUpdate;
      ItemIndex := 0;
      Exit;
    end;

  with cbList do
  begin
    Items.BeginUpdate;
    Items.Clear;

    Items.AddObject(Lang.Say('SearchWholeBible'), TObject(0));
    if MainBook.Trait[bqmtOldCovenant] and MainBook.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchOT'), TObject(-1)); // Old Testament
    if MainBook.Trait[bqmtNewCovenant] and MainBook.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchNT'), TObject(-2)); // New Testament
    if MainBook.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchPT'), TObject(-3)); // Pentateuch
    if MainBook.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchHP'), TObject(-4));
    // Historical and Poetical
    if MainBook.Trait[bqmtOldCovenant] then
      Items.AddObject(Lang.Say('SearchPR'), TObject(-5)); // Prophets
    if MainBook.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchGA'), TObject(-6)); // Gospels and Acts
    if MainBook.Trait[bqmtNewCovenant] then
      Items.AddObject(Lang.Say('SearchER'), TObject(-7));
    // Epistles and Revelation

    if MainBook.Trait[bqmtApocrypha] then
      Items.AddObject(Lang.Say('SearchAP'), TObject(-8)); // Apocrypha

    for i := 1 to MainBook.BookQty do
      Items.AddObject(MainBook.FullNames[i], TObject(i));

    Items.EndUpdate;
    ItemIndex := 0;
  end;
end;

procedure TMainForm.edtGoDblClick(Sender: TObject);
var
  book, chapter, fromverse, toverse: integer;
  linktxt: string;
  Links: TStrings;
  i, fc: integer;
  openSuccess: Boolean;
  modName, modPath: string;
  moduleEntry: TModuleEntry;
label lblTail;
begin
  if Trim(edtGo.Text) = '' then
    Exit;

  linktxt := edtGo.Text;
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

    // ComplexLinksPanel.Visible := (Links.Count > 1);
    tbLinksToolBar.Visible { cbLinks.Visible } := (Links.Count > 1);

    edtGo.Text := Links[0];

    openSuccess := MainBook.OpenReference(edtGo.Text, book, chapter,
      fromverse, toverse);
    if not openSuccess then
    begin
      fc := mFavorites.mModuleEntries.Count - 1;
      if not Assigned(tempBook) then
        tempBook := TBible.Create(self);
      for i := 0 to fc do
      begin
        try
          tempBook.inifile :=
            MainFileExists(TModuleEntry(mFavorites.mModuleEntries[i])
            .wsShortPath + '\bibleqt.ini');
          openSuccess := tempBook.OpenReference(edtGo.Text, book, chapter,
            fromverse, toverse);
          if openSuccess then
          begin
            MainBook.inifile := tempBook.inifile;
            break;
          end;
        except
        end;

      end;
      if not openSuccess then
      begin
        // fc := mModules.Mo //Bibles.Count - 1;
        moduleEntry := mModules.ModTypedAsFirst(modtypeBible);
        while Assigned(moduleEntry) do
        // for i := 0 to fc do
        begin
          try

            modName := moduleEntry.wsFullName;

            // pp := Pos(' $$$ ', mModules[ix]);
            // modPath := Copy(ModulesList[ix], pp + 5, Length(ModulesList[ix]));
            modPath := moduleEntry.wsShortPath;
            tempBook.inifile := MainFileExists(TPath.Combine(modPath, 'bibleqt.ini'));
            openSuccess := tempBook.OpenReference(edtGo.Text, book, chapter, fromverse, toverse);
            if openSuccess then
            begin
              MainBook.inifile := tempBook.inifile;
              break;
            end;
          except
          end;
          moduleEntry := mModules.ModTypedAsNext(modtypeBible);
        end;

      end;
    end;
    if openSuccess then
      SafeProcessCommand(Format('go %s %d %d %d %d', [MainBook.ShortPath, book, chapter, fromverse, toverse]), hlDefault)
    else
      SafeProcessCommand(edtGo.Text, hlDefault);
  lblTail:
  finally
    Links.Free;
  end;
end;

procedure TMainForm.edtGoEnter(Sender: TObject);
begin
  // edtGo.SelectAll();
  PostMessageW(edtGo.Handle, EM_SETSEL, 0, -1);
end;

procedure TMainForm.edtGoChange(Sender: TObject);
begin
  AddressFromMenus := false;
end;

procedure TMainForm.ChapterComboBoxChange(Sender: TObject);
begin
  AddressFromMenus := true;
end;

procedure TMainForm.bwrHtmlKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = '+' then
  begin
    Key := #0;
    FontChanged(1);
  end
  else if Key = '-' then
  begin
    Key := #0;
    FontChanged(-1);
  end;

end;

procedure TMainForm.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Idle(Sender: TObject; var Done: Boolean);
begin
  // фоновая загрузка модулей

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

end;

{ procedure TMainForm.InitBibleTabs;
  var
  i, j, bibleTabsCount: integer;
  s: WideString;
  hotModuleMenuItem: TMenuItem;
  begin
  bibleTabsCount := GetHotModuleCount() - 1;
  dtsBible.Tabs.Clear();
  for i := 0 to bibleTabsCount do
  begin
  hotModuleMenuItem := GetHotMenuItem(i);
  if not Assigned(hotModuleMenuItem) then
  continue;
  s := hotModuleMenuItem.Caption;
  if length(s) <= 0 then
  continue;
  j := ModuleIndexByName(s);
  if j >= 0 then
  dtsBible.Tabs.AddObject(ModulesCodeList[j],
  hotModuleMenuItem);
  end; //for
  dtsBible.Tabs.AddObject('***', nil);
  end; }

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
    hotMenuItem.Caption := newMe.wsFullName;
    hotMenuItem.OnClick := HotKeyClick;

    favouriteMenuItem.Insert(ix + i, hotMenuItem);
    dtsBible.Tabs.Insert(ix, newMe.VisualSignature());
    dtsBible.Tabs.Objects[ix] := newMe;
    Result := ix;
    dtsBible.Repaint();
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
  rslt := PrepareFont(FileRemoveExtension(wsName), wsFolder);
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

{ procedure TMainForm.LoadBookNodes;
  var
  usrPath: WideString;
  bc: TBookCategory;
  fileHandle:THandle;
  pn:PVirtualNode;
  sz, byteRead:Cardinal;
  pMemory, pCurrent, pFence:PWideChar;

  procedure AddChild(_pn:PVirtualNode);
  var pWc: PWideChar;
  strsz:integer;
  pCurNode:PVirtualNode;
  begin
  repeat
  pWc:=StrPosW(pCurrent, C_crlf);
  if not assigned(pWc) then abort;
  strsz:=pWc-pCurrent;
  bc:=TBookCategory.Create(Copy(pCurrent, 1, strsz));
  pCurNode:= vstBooks.AddChild(_pn, bc);
  Inc(pCurrent, strsz+2);
  if (pCurrent>=pFence) then exit;
  if pCurrent^='+' then begin Inc(pCurrent); AddChild(pCurNode); end;
  if pCurrent^='-' then begin Inc(pCurrent); exit end;
  until (pCurrent>=pFence);

  end;

  begin
  {  bc := TBookCategory.Create('Книги');
  mBookCategories.Add(bc);
  pn:=vstBooks.AddChild(vstBooks.RootNode, bc); }
{ pn:=nil;
  usrPath := CreateAndGetConfigFolder() + C_CategoriesFile;
  fileHandle := CreateFileW(PWideChar(Pointer(usrPath)), GENERIC_READ, 0,
  nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if fileHandle = INVALID_HANDLE_VALUE then begin exit end;
  sz:=GetFileSize(fileHandle, nil);
  if sz>0 then begin

  GetMem(pMemory,sz);
  ReadFile(fileHandle, pMemory^, sz,byteRead,nil);
  pCurrent:=pMemory; pFence:=pMemory+ (sz div 2);
  try
  try
  AddChild(pn);
  finally FreeMemory(pMemory); end;
  except end;
  CloseHandle(fileHandle);
  end;//if sz
  end; }

function TMainForm.LoadAnchor(wb: THTMLViewer;
  SRC, current, loc: string): Boolean;
var
  i: integer;
  dest: string;
  ext: string;
  wstrings: TStrings;
  wsResolvedTxt: string;
  ti: TViewTabInfo;
begin
  Result := false;

  try
    i := Pos('#', SRC);
    ti := GetActiveTabInfo();
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
      ext := WideUpperCase(ExtractFileExt(SRC));
      if (ext = '.HTM') or (ext = '.HTML') then
      begin { an html file }
        if Assigned(ti) and ti[vtisResolveLinks] then
        begin
          if not FileExistsEx(SRC) >= 0 then
            Exit;
          try

            wstrings := ReadHtml(SRC, TEncoding.GetEncoding(1251));

            wsResolvedTxt := ResolveLnks(wstrings.Text,
              ti[vtisFuzzyResolveLinks]);
            wb.LoadFromString(wsResolvedTxt);
            wb.PositionTo(dest);
            wb.__SetFileName(SRC);
            // wb.DefVisitedLinkColor
          finally
            FreeAndNil(wstrings);
            wsResolvedTxt := '';
          end;
        end
        else
          wb.LoadFromFile(SRC + dest);

      end
      // wb.AddVisitedLink(S+Dest);
      else if (ext = '.BMP') or (ext = '.GIF') or (ext = '.JPG') or
        (ext = '.JPEG') or (ext = '.PNG') then
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

function TMainForm.LoadBibleToXref(cmd: string; const id: string): Boolean;
var
  fn, ws, psg, doc, ConcreteCmd: string;
  bl: TBibleLink;
  status_load: integer;

begin
  Result := false;
  status_load := PreProcessAutoCommand(cmd, SecondBook.ShortPath, ConcreteCmd);
  if status_load <= -2 then
    Exit;
  status_load := GetModuleText(ConcreteCmd, fn, bl, ws, psg,
    [gmtLookupRefBibles]);
  if status_load < 0 then
  begin
    MessageBeep(MB_ICONEXCLAMATION);
    Exit;
  end;

  // psg := SecondBook.ShortPassageSignature(bl.book, bl.chapter, bl.vstart, bl.vend);
  doc := bwrXRef.DocumentSource;

  ws := Format('%s '#13#10'<a href="bqnavMw:bqResLnk%s">%s</a><br><hr align=left width=80%%>', [ws, id, psg]);
  bwrXRef.LoadFromString(doc + ws);
  if pgcMain.ActivePage <> tbXRef then
    pgcMain.ActivePage := tbXRef;

  bwrXRef.Position := bwrXRef.MaxVertical;

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
    begin // не удалось загрузить или обновиться
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
  ti: TViewTabInfo;
  bl, obl: TBibleLink;
  blValidAddressExtracted: Boolean;
  path: string;
  hlVerses: TbqHLVerseOption;
  R: integer;
  iniPath: string;
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
  // remember old module's params
  wasBible := MainBook.isBible;
  ti := GetActiveTabInfo();
  blValidAddressExtracted := bl.FromBqStringLocation(ti.mwsLocation, path);
  if not blValidAddressExtracted then
  begin
    bl.Build(MainBook.CurBook, MainBook.CurChapter, ti.mFirstVisiblePara, 0);
    blValidAddressExtracted := true;
  end
  else
    hlVerses := hlTrue;

  if blValidAddressExtracted then
  begin
    // if valid address
    R := MainBook.ReferenceToInternal(bl, obl);
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
      tempBook := TBible.Create( self);

    iniPath := TPath.Combine(me.wsShortPath, 'bibleqt.ini');
    tempBook.inifile := MainFileExists(iniPath);
  except
  end;

  if tempBook.isBible and wasBible then
  begin
    R := tempBook.InternalToReference(obl, bl);
    if R <= -2 then
      hlVerses := hlFalse;
    try
      if (ti.mFirstVisiblePara > 0) and
        (ti.mFirstVisiblePara < MainBook.verseCount()) then
        firstVisibleVerse := ti.mFirstVisiblePara
      else
        firstVisibleVerse := -1;
      ProcessCommand(bl.ToCommand(TPath.Combine(commentpath, tempBook.ShortPath)), hlVerses);
      if firstVisibleVerse > 0 then
      begin
        bwrHtml.PositionTo('bqverse' + IntToStr(firstVisibleVerse), false);
      end;
    except
    end;
  end // both previuous and current are bibles
  else
  begin
    SafeProcessCommand('go ' + TPath.Combine(commentpath, tempBook.ShortPath) + ' 1 1 0', hlFalse);
  end;
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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

procedure TMainForm.bwrHtmlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BrowserPosition := bwrHtml.Position;

  if (Shift = [ssCtrl]) then
  begin
    if (Key = VK_INSERT) then
    begin
      Key := 0;
      CopySelectionClick(Sender);
      Exit;
    end;
    if Key = $41 then
    begin
      bwrHtml.SelectAll();
      UpdateWindow(bwrHtml.Handle);
      Exit
    end;
  end;
  if Key = $43 { THE C KEY } then
  begin
    bwrHtml.RightMouseClickPos := bwrHtml.LeftMouseClickPos;
    pmBrowserPopup(self);

    if miCopyPassage.Visible then
    begin
      miCopyPassageClick(self);
    end
    else if miCopyVerse.Visible then
    begin
      miCopyVerseClick(self);
    end;

  end;

  // if ((Key = VK_BACK) and (Shift = []))
  // or ((Key = VK_LEFT) and (Shift = [ssAlt])) then
  // begin
  // Key := 0;
  // tbtnBack.Click;
  // end
  // else if ((Key = VK_RIGHT) and (Shift = [ssAlt])) then
  // begin
  // Key := 0;
  // ForwardButton.Click;
  // end;
end;

procedure TMainForm.miFontConfigClick(Sender: TObject);
var
  browserCount, i: integer;
  tabInfo: TViewTabInfo;
begin
  with FontDialog do
  begin
    Font.Name := mBrowserDefaultFontName;
    Font.color := bwrHtml.DefFontColor;
    Font.Size := bwrHtml.DefFontSize;
    // Font.Charset := DefaultCharset;
  end;

  if FontDialog.Execute then
  begin
    browserCount := pgcViewTabs.Tabs.Count - 1;
    for i := 0 to browserCount do
    begin
      try
        tabInfo := pgcViewTabs.Tabs.Objects[i] as TViewTabInfo;
        with tabInfo do
        begin
          if i <> pgcViewTabs.TabIndex then
            StateEntryStatus[vtisPendingReload] := true;

          bwrHtml.DefFontName := FontDialog.Font.Name;
          mBrowserDefaultFontName := bwrHtml.DefFontName;
          bwrHtml.DefFontColor := FontDialog.Font.color;
          bwrHtml.DefFontSize := FontDialog.Font.Size;
        end // with
      except
      end;
    end;

    tabInfo := GetActiveTabInfo();
    ProcessCommand(tabInfo.mwsLocation, TbqHLVerseOption(ord(tabInfo[vtisHighLightVerses])));
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
begin
  bwrHtml.DefBackGround := ChooseColor(bwrHtml.DefBackGround);
  bwrHtml.Refresh;
  browserCount := pgcViewTabs.Tabs.Count - 1;
  for i := 0 to browserCount do
  begin
    try
      if i <> pgcViewTabs.TabIndex then
      begin
        Refresh();
      end;
    except
    end;
  end;

  with bwrSearch do
  begin
    DefBackGround := bwrHtml.DefBackGround;
    Refresh;
  end;
  with bwrDic do
  begin
    DefBackGround := bwrHtml.DefBackGround;
    Refresh;
  end;
  with bwrStrong do
  begin
    DefBackGround := bwrHtml.DefBackGround;
    Refresh;
  end;
  with bwrComments do
  begin
    DefBackGround := bwrHtml.DefBackGround;
    Refresh;
  end;
  with bwrXRef do
  begin
    DefBackGround := bwrHtml.DefBackGround;
    Refresh;
  end;
end;

procedure TMainForm.miHrefConfigClick(Sender: TObject);
var
  i, browserCount: integer;
  tabInfo: TViewTabInfo;
begin
  with bwrHtml do
  begin
    DefHotSpotColor := ChooseColor(DefHotSpotColor);
  end;
  tabInfo := GetActiveTabInfo();
  ProcessCommand(tabInfo.mwsLocation, TbqHLVerseOption(ord(tabInfo[vtisHighLightVerses])));
  browserCount := pgcViewTabs.Tabs.Count - 1;
  for i := 0 to browserCount do
  begin
    try
      tabInfo := pgcViewTabs.Tabs.Objects[i] as TViewTabInfo;
      with tabInfo do
      begin
        if i <> pgcViewTabs.TabIndex then
        begin
          StateEntryStatus[vtisPendingReload] := true;
        end;
      end // with
    except
    end;
  end;

  with bwrSearch do
  begin
    DefHotSpotColor := bwrHtml.DefHotSpotColor;
    Refresh;
  end;
  with bwrDic do
  begin
    DefHotSpotColor := bwrHtml.DefHotSpotColor;
    Refresh;
  end;
  with bwrStrong do
  begin
    DefHotSpotColor := bwrHtml.DefHotSpotColor;
    Refresh;
  end;
  with bwrComments do
  begin
    DefHotSpotColor := bwrHtml.DefHotSpotColor;
    Refresh;
  end;
  with bwrXRef do
  begin
    DefHotSpotColor := bwrHtml.DefHotSpotColor;
    Refresh;
  end;
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
begin
  Result := '';
  for i := fromverse to toverse do
  begin
    s := MainBook.Verses[i - 1];
    StrDeleteFirstNumber(s);

    if MainBook.Trait[bqmtStrongs] and (not StrongNumbersOn) then
      s := DeleteStrongNumbers(s);

    if (CopyOptionsCopyVerseNumbersChecked xor (IsDown(VK_CONTROL))) and
      (fromverse > 0) and (fromverse <> toverse) then
    begin
      if CopyOptionsAddReferenceChecked and
        (CopyOptionsAddReferenceRadioItemIndex = 0) then
      begin
        with MainBook do
          s := ShortPassageSignature(CurBook, CurChapter, i, i) + ' ' + s;

        if CopyOptionsAddModuleNameChecked then
          s := MainBook.ShortName + ' ' + s;
      end
      else
      begin
        if not WideIsSpaceEndedString(s) then
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
      Result := Result + MainBook.ShortName + ' ';

    with MainBook do
      if CopyOptionsAddReferenceRadioItemIndex = 1 then
        Result := Result + ShortPassageSignature(CurBook, CurChapter, fromverse,
          toverse) + ')'
      else
        Result := Result + FullPassageSignature(CurBook, CurChapter, fromverse,
          toverse) + ')';
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
    InsertDefaultFontInfo(mHTMLSelection, bwrHtml.DefFontName, bwrHtml.DefFontSize);
    // if CopyOptionsAddLineBreaksChecked then
    // StringReplace(mHTMLSelection, #13#10, '<br>', [rfReplaceAll]);
  end
  else
    mHTMLSelection := '';
  // CopyHTMLToClipBoard(s, result);
  Result := s;
end;

procedure TMainForm.miCopyVerseClick(Sender: TObject);
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

procedure TMainForm.pmBrowserPopup(Sender: TObject);
var
  s, scap: string;
  i: integer;

  // dMessage: WideString;
  // dSrcPos: Integer;
  // dPrevText: WideString;

begin
  if bwrHtml.tag <> bsText then
  begin
    miCopyPassage.Visible := false;
    miCopyVerse.Visible := false;
    Exit;
  end
  else
  begin
    miCopyPassage.Visible := true;
    miCopyVerse.Visible := true;
  end;

  { dSrcPos := bwrHtml.FindSourcePos (bwrHtml.RightMouseClickPos);
    if dSrcPos > 500 then
    dPrevText := Copy (BrowserSource, dSrcPos - 500, 500)
    else
    dPrevText := Copy (BrowserSource, 1, dSrcPos);

    dMessage := IntToStr (bwrHtml.RightMouseClickPos) + ', ' +
    IntToStr (dSrcPos) + #13 +
    dPrevText + '|' + #13 +
    Copy (BrowserSource, dSrcPos+1, 500);

    WStrMessageBox (dMessage); }
  CurVerseNumber := Get_ANAME_VerseNumber(bwrHtml.DocumentSource, CurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.RightMouseClickPos, true));

  CurSelStart := Get_ANAME_VerseNumber(bwrHtml.DocumentSource, CurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.SelStart, true));

  CurSelEnd := Get_ANAME_VerseNumber(bwrHtml.DocumentSource, CurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.SelStart + bwrHtml.SelLength, true));

  if CurSelStart > CurSelEnd then
  begin
    i := CurSelStart;
    CurSelStart := CurSelEnd;
    CurSelEnd := i;
  end;

  miCopyPassage.Visible := (CurSelStart < CurSelEnd);

  if CurVerseNumber = 0 then
  begin
    miCompare.Visible := false;
    miCopyVerse.Visible := false;
  end
  else
    with MainBook do
    begin
      if miCopyPassage.Visible then
        miCopyPassage.Caption := Format('%s  "%s"',
          [FirstWord(miCopyVerse.Caption), FullPassageSignature(CurBook,
          CurChapter, CurSelStart, CurSelEnd)]);

      miCopyVerse.Caption := Format('%s  "%s"',
        [FirstWord(miCopyVerse.Caption), FullPassageSignature(CurBook,
        CurChapter, CurVerseNumber, CurVerseNumber)]);

      scap := miAddBookmark.Caption;
      s := DeleteFirstWord(scap);
      s := s + ' ' + FirstWord(scap);
      miAddBookmark.Caption := Format('%s  "%s"',
        [s, FullPassageSignature(CurBook, CurChapter, CurVerseNumber,
        CurVerseNumber)]);

      scap := miAddMemo.Caption;
      s := DeleteFirstWord(scap);
      s := s + ' ' + FirstWord(scap);
      miAddMemo.Caption := Format('%s  "%s"',
        [s, FullPassageSignature(CurBook, CurChapter, CurVerseNumber,
        CurVerseNumber)]);
      {
        scap := miGoBack.Caption;
        s := DeleteFirstWord(scap);
        s := s + ' ' + FirstWord(scap);

        miGoBack.Enabled := History.Count > 1;

        if miGoBack.Enabled then
        miGoBack.Caption := s + ' ' + Comment(History[History.Count-2]);
      }
    end;
end;

procedure TMainForm.miXrefClick(Sender: TObject);
begin
  if not pgcMain.Visible then
    tbtnToggle.Click;

  tbXRef.tag := 1;
  pgcMain.ActivePage := tbXRef;
  ShowXref;
end;

// function TMainForm.ModuleIndexByName(const awsModule: Widestring): integer;
// var
// i, modulecount: integer;
// begin
// result := -1;
//
// modulecount := mModules.Count-1;
// for i := 0 to modulecount do
// begin
// if Pos(awsModule, ModulesList[i].) = 1 then
// begin
// result := i;
// break;
// end;
// end;
//
// end;

(*
  Report #:  82143     	 Status:  Open
  TWinControl.ControlAtPos doesn't work with nested TWinControl descendant child controls
  Project:  Delphi 	Build #:  21218
  Version:    12.3 	Submitted By:   Ondrej Kelle
  Report Type:  Basic functionality failure 	Date Reported:  2/15/2010 4:39:25 AM
  Severity:    Commonly encountered problem 	Last Updated: 2/15/2010 6:46:38 PM
  Platform:    All platforms 	Internal Tracking #:   275027
  Resolution: None (Resolution Comments) 	Resolved in Build: : None
*)

function CustomControlAtPos(ParentControl: TWinControl; const Pos: TPoint;
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
        c2 := TWinControl(C).ControlAtPos(p, AllowDisabled,
          AllowWinControls, false);

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
    // focusHwnd:=GetFocus();
    // if (focusHwnd<>0) and (focusHwnd <> TWinControl(ctrl).handle) then begin
    focusHwnd := WindowFromPoint(screenPt);
    if (focusHwnd <> 0) and (focusHwnd <> TWinControl(ctrl).Handle) then
    begin

      // if GetWindowRect(focusHWnd,focusedRect) and
      // PtInRect(focusedRect, screenPt) then begin
      // ooops
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
    // SetFocusedControl();
    // message.Result:=SendMessage(TWinControl(ctrl).Handle,Message.Msg, Message.WParam, Message.LParam)
  end;
  // else message.Result:=ctrl.Perform(CM_MOUSEWHEEL, message.WParam, message.LParam);
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
  // rb,rc,rv,
  i, j: integer;
  RefLines: string;
  RefText: string;
  Links: TStrings;
  slink: string;
  // was0: boolean;
  diff: integer;
  path: string;
begin
  if mModules.IndexOf(MainBook.Name) = -1 then
    Exit;
  // if Bibles.IndexOf(MainBook.Name) = -1 then
  // Exit;
  if not pgcMain.Visible then
    Exit;

  if pgcMain.ActivePage <> tbXRef then
    pgcMain.ActivePage := tbXRef;

  if tbXRef.tag = 0 then
    tbXRef.tag := 1;

  RefLines := '';
  Links := TStringList.Create;

  // with MainBook do
  // RefLines.Add('<font size=-1>');

  SecondBook.inifile := MainBook.inifile;

  MainBook.ReferenceToEnglish(MainBook.CurBook, MainBook.CurChapter, tbXRef.tag, book, chapter, verse);
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

  SecondBook.OpenChapter(MainBook.CurBook, MainBook.CurChapter);

  tmpverse := tbXRef.tag;

  if tmpverse > SecondBook.verseCount() then
    tmpverse := SecondBook.verseCount();
  s := SecondBook[tmpverse - 1];
  StrDeleteFirstNumber(s);
  s := DeleteStrongNumbers(s);

  RefText := Format
    ('<a name=%d><a href="go %s %d %d %d"><font face=%s>%s%d:%d</font></a><br><font face="%s">%s</font><p>',
    [tmpverse, MainBook.ShortPath, MainBook.CurBook, MainBook.CurChapter,
    tmpverse, mBrowserDefaultFontName, MainBook.ShortNames[MainBook.CurBook],
    MainBook.CurChapter, tmpverse, MainBook.fontName, s]);

  slink := ti.ReadString(IntToStr(chapter), IntToStr(verse), '');
  if slink = '' then
    AddLine(RefLines, RefText + '<b>.............</b>')
    // RefLines.Add(RefText + '<hr>')
  else
  begin
    StrToLinks(slink, Links);

    // get xrefs
    for i := 0 to Links.Count - 1 do
    begin
      if not SecondBook.OpenTSKReference(Links[i], book, chapter, fromverse, toverse) then
        continue;

      diff := toverse - fromverse;
      SecondBook.ENG2RUS(book, chapter, fromverse, book, chapter, fromverse);

      if not SecondBook.InternalToReference(book, chapter, fromverse, book,
        chapter, fromverse) then
        continue; // if this module doesn't have the link...

      toverse := fromverse + diff;

      if fromverse = 0 then
        fromverse := 1;
      if toverse < fromverse then
        toverse := fromverse; // if one verse

      try
        SecondBook.OpenChapter(book, chapter);
      except
        continue;
      end;

      if fromverse > SecondBook.verseCount() then
        continue;
      if toverse > SecondBook.verseCount then
        toverse := SecondBook.verseCount;

      s := '';
      for j := fromverse to toverse do
      begin
        snew := SecondBook.Verses[j - 1];
        s := s + ' ' + StrDeleteFirstNumber(snew);
        snew := DeleteStrongNumbers(snew);
        s := s + ' ' + snew;
      end;
      s := Trim(s);

      StrDeleteFirstNumber(s);
      passageSig := Format('<font face="%s">%s</font>',
        [mBrowserDefaultFontName, SecondBook.ShortPassageSignature(book,
        chapter, fromverse, toverse)]);
      if toverse = fromverse then
        RefText := RefText +
          Format
          ('<a href="go %s %d %d %d %d">%s</a> <font face="%s">%s</font><br>',
          [MainBook.ShortPath, book, chapter, fromverse, 0, passageSig,
          MainBook.fontName, s])
      else
        RefText := RefText +
          Format
          ('<a href="go %s %d %d %d %d">%s</a> <font face="%s">%s</font><br>',
          [MainBook.ShortPath, book, chapter, fromverse, toverse, passageSig,
          MainBook.fontName, s]);
    end;

    AddLine(RefLines, RefText);
  end;

  AddLine(RefLines, '</font><br><br>');

  // bwrXRef.CharSet := MainBook.FontCharset;
  bwrXRef.DefFontName := bwrHtml.DefFontName;
  mXRefMisUsed := false;
  bwrXRef.LoadFromString(RefLines);

  // bwrXRef.PositionTo(IntToStr(tbXRef.Tag));

  Links.Free;
end;

{
  procedure TMainForm.ShowXref;
  var
  book,chapter,verse,ibook,ichapter,iverse,rbook,rchapter,rverse: integer;
  XrefCur: integer;
  foundxref: boolean;
  RefLines: TWideStrings;
  s, RefText: WideString;
  begin
  if not MainBook.isBible then Exit;

  if tbXRef.Tag = 0 then tbXRef.Tag := 1;

  RefLines := TWideStringList.Create;

  with MainBook do
  RefLines.Add('<font size=-1>');

  XRefCur := 1;

  SecondBook.IniFile := MainBook.IniFile;

  book := MainBook.CurBook;
  chapter := MainBook.CurChapter;
  //numverses := MainBook.CountVerses(book, chapter);
  verse := tbXRef.Tag;

  //  for verse := 1 to numverses do
  //  begin
  foundxref := MainBook.isBible
  and MainBook.InternalToAddress(book,chapter,verse,ibook,ichapter,iverse)
  and LocateXref(ibook,ichapter,iverse,XRefCur);
  // delphi check boolean values from left to right :-)

  SecondBook.OpenChapter(book,chapter);
  if verse > SecondBook.Lines.Count then verse := SecondBook.Lines.Count;
  s := SecondBook.Lines[verse-1];
  StrDeleteFirstNumber(s);
  s := DeleteStrongNumbers(s);

  RefText := Format('<a name=%d><a href="go %s %d %d %d">%s%d:%d</a><br><font face="%s">%s</font><p>',
  [verse,MainBook.ShortPath,
  book,chapter,verse,MainBook.ShortNames[book],chapter,verse,
  MainBook.FontName, s]);

  if foundxref then
  begin
  repeat
  if MainBook.AddressToInternal(
  XRef[XRefCur].RB, XRef[XRefCur].RC, XRef[XRefCur].RV,
  rbook,rchapter,rverse) then

  SecondBook.OpenChapter(rbook,rchapter);
  if rverse > SecondBook.Lines.Count then rverse := SecondBook.Lines.Count;
  s := SecondBook.Lines[rverse-1];
  StrDeleteFirstNumber(s);
  s := DeleteStrongNumbers(s);

  RefText := RefText + Format('<a href="go %s %d %d %d">%s%d:%d</a> <font face="%s">%s</font><br>',
  [MainBook.ShortPath,
  rbook,rchapter,rverse,MainBook.ShortNames[rbook],rchapter,rverse,
  MainBook.FontName, s]);

  Inc(XRefCur);
  until (XRefCur > XRefQty) or not ((XRef[XRefCur].B = ibook)
  and (XRef[XRefCur].C = ichapter)
  and (XRef[XRefCur].V = iverse));

  //RefText := Copy(RefText,1,Length(RefText)-6) + '</a>'; // delete last ', ' combination
  RefLines.Add(RefText);               ыв
  end
  else RefLines.Add(RefText + '<b>.............</b>');
  //  end;

  RefLines.Add('</font><br><br>');

  bwrXRef.LoadStrings(RefLines);
  bwrXRef.CharSet := MainBook.FontCharset;

  bwrXRef.PositionTo(IntToStr(tbXRef.Tag));
  end;
}

procedure TMainForm.tbtnSoundClick(Sender: TObject);
var
  book, chapter, verse: integer;
  fname3, fname2: WideString;
  find: string;
begin
  {
    find := '';
    for chapter := 1 to 150 do
    find := find + IntToStr(MainBook.CountVerses(19, chapter)) + ', ';
    BrowserSource.Text := find;
    bwrHtml.LoadStrings(BrowserSource);
    Exit;
  }
  if not MainBook.isBible then
    Exit;

  MainBook.InternalToReference(MainBook.CurBook, MainBook.CurChapter, 1, book,
    chapter, verse);

  if MainBook.SoundDirectory = '' then
  begin // 3 digits
    fname3 := Format('Sounds\%.2d\%.3d', [book, chapter]);
    fname2 := Format('Sounds\%.2d\%.2d', [book, chapter]);
  end
  else
  begin // 2 digits
    fname3 := Format('%s\%.2d\%.3d', [MainBook.SoundDirectory, book, chapter]);
    fname2 := Format('%s\%.2d\%.2d', [MainBook.SoundDirectory, book, chapter]);
  end;

  find := MainFileExists(fname3 + '.wav');
  if find = '' then
    find := MainFileExists(fname3 + '.mp3');
  if find = '' then
    find := MainFileExists(fname2 + '.wav');
  if find = '' then
    find := MainFileExists(fname2 + '.mp3');

  if find = '' then
  begin
    ShowMessage(Format(Lang.Say('SoundNotFound'), [bwrHtml.DocumentTitle]));
    Exit;
  end
  else
  begin
    ShellExecute(Application.Handle, nil, PChar(find), nil, nil, SW_MINIMIZE);
    // ActiveControl := Browser;
  end;
end;

procedure TMainForm.miHotkeyClick(Sender: TObject);
begin
  ConfigForm.pgcOptions.ActivePageIndex := 1;
  ShowConfigDialog;
  // ShowMessage('Просто перетащите корешок закладки той страницы,'
  // +#13#10' на которой отображается нужный модуль на закладку панели Любимых Модулей');
end;

{ TODO -oAlekId -cQA : проверить зачем закомментирована функция }{
  procedure TMainForm.miAddPassageBookmarkClick(Sender: TObject);
  var
  s,s1: WideString;
  begin
  CurVerseNumber := VersePosition;

  s := miAddBookmark.Caption;
  s1 := DeleteFirstWord(s);
  s := s1 + ' ' + FirstWord(s);

  with MainBook do
  if CurToVerse - CurFromVerse + 1 = VerseQty then
  miAddBookmark.Caption :=
  Format('%s  "%s"', [s,
  ShortName + ' ' + ShortPassageSignature(CurBook, CurChapter, VersePosition, 0)]
  )
  else
  miAddBookmark.Caption :=
  Format('%s  "%s"', [s,
  ShortName + ' ' + ShortPassageSignature(CurBook, CurChapter, CurFromVerse, CurToVerse)]
  );

  //  miAddBookmarkClick(Sender);
  end;
}

(* AlekId: добавлено *)

procedure TMainForm.miDeteleBibleTabClick(Sender: TObject);
var
  me: TModuleEntry;
begin
  if miDeteleBibleTab.tag < 0 then
    Exit;
  try
    me := (dtsBible.Tabs.Objects[miDeteleBibleTab.tag]) as TModuleEntry;
    mFavorites.DeleteModule(me);
  except
  end;
end;
(* AlekId:/добавлено *)

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
        dtsBible.Font.Assign(fnt);
        Screen.HintFont := fnt;
        h := fnt.Height;
        if h < 0 then
          h := -h;
        dtsBible.Height := h + 13;
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

procedure TMainForm.miCopyPassageClick(Sender: TObject);
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

{
  procedure TMainForm.BrowserPrintHeader(Sender: TObject; Canvas: TCanvas;
  NumPage, W, H: Integer; var StopPrinting: Boolean);
  var
  AFont: TFont;
  begin
  if (NumPage = 1) or (Pos('file ', History[0]) = 1) then Exit;

  AFont := TFont.Create;
  AFont.Name := bwrHtml.DefFontName;
  AFont.Charset := bwrHtml.Charset;
  AFont.Size := 10;
  with Canvas do
  begin
  Font.Assign(AFont);
  SetBkMode(Handle, Transparent);
  SetTextAlign(Handle, TA_Top or TA_RIGHT);
  TextOut(W-50, 20, bwrHtml.DocumentTitle);
  end;
  AFont.Free;
  end;

  procedure TMainForm.BrowserPrintFooter(Sender: TObject; Canvas: TCanvas;
  NumPage, W, H: Integer; var StopPrinting: Boolean);
  var
  AFont: TFont;
  begin
  if NumPage = 1 then Exit;

  AFont := TFont.Create;
  AFont.Name := bwrHtml.DefFontName;
  AFont.Charset := bwrHtml.Charset;
  AFont.Size := 10;
  with Canvas do
  begin
  Font.Assign(AFont);
  SetTextAlign(Handle, TA_Bottom or TA_Center);
  TextOut(W div 2, 20, IntToStr(NumPage));

  if PrintFootNote and (NumPage = 2) or (NumPage = 17) then
  begin
  SetTextAlign(Handle, TA_Bottom or TA_Right);
  TextOut(W-50, 20, 'http://biblerussia.org/freeware');
  end;
  end;
  AFont.Free;
  end;
}

procedure TMainForm.MainBookVerseFound(Sender: TObject;
  NumVersesFound, book, chapter, verse: integer; s: string);
var
  i: integer;
begin
  lblSearch.Caption := Format('[%d] %s',
    [NumVersesFound, MainBook.FullNames[book]]);

  if s <> '' then
  begin
    s := ParseHTML(s, '');
    if MainBook.Trait[bqmtStrongs] and (not StrongNumbersOn) then
      s := DeleteStrongNumbers(s);
    StrDeleteFirstNumber(s);

    // color search result!!!

    for i := 0 to SearchWords.Count - 1 do
      StrColorUp(s, SearchWords[i], '<*>', '</*>', chkCase.Checked);

    SearchResults.Add(
      Format('<a href="go %s %d %d %d 0">%s</a> <font face="%s">%s</font><br>',
      [MainBook.ShortPath, book, chapter, verse,
      MainBook.ShortPassageSignature(book, chapter, verse, verse),
      MainBook.fontName, s]));
  end;

  Application.ProcessMessages;
end;

procedure TMainForm.MainBookChangeModule(Sender: TObject);
begin
  cbModules.ItemIndex := cbModules.Items.IndexOf(MainBook.Name);
  UpdateBooksAndChaptersBoxes();
  tbtnStrongNumbers.Enabled := MainBook.Trait[bqmtStrongs];
  SearchListInit;
  // ReCalculateTagTree();
  if pgcMain.ActivePage = tbComments then
  begin
    // FilterCommentariesCombo();
  end;
  Caption := MainBook.Name + ' — BibleQuote';

end;

procedure TMainForm.bwrHtmlMouseDouble(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  num, code: integer;
begin
  if not mDictionariesFullyInitialized then
  begin
    LoadDictionaries(true);
  end;

  Val(Trim(bwrHtml.SelText), num, code);
  if code = 0 then
  begin
    DisplayStrongs(num, (MainBook.CurBook < 40) and
      (MainBook.Trait[bqmtOldCovenant]));
  end
  else
  begin
    DisplayDictionary(Trim(bwrHtml.SelText));
  end;

  if not pgcMain.Visible then
    tbtnToggle.Click;
end;

procedure TMainForm.bwrHtmlMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  section: TSectionBase;
  topPos, Index: integer;
  classname: string;
begin
  section := bwrHtml.SectionList.FindSectionAtPosition(bwrHtml.LeftMouseClickPos, topPos, index);

  if section = nil then
    Exit;

  classname := section.classname;
  OutputDebugString(Pointer(classname));

end;

procedure TMainForm.bwrHtmlMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: integer; MousePos: TPoint; var Handled: Boolean);
var
  fontSize: integer;
  delta, tm: integer;
{$J+}
const
  lastWheelTime: integer = 0;
{$J-}
begin
  tm := GetTickCount();
  if abs(tm - lastWheelTime) < 1000 then
  begin
    Handled := true;
    Exit;
  end;
  if not(ssCtrl in Shift) then
  begin
    if WheelDelta < 0 then
    begin
      if (bwrHtml.VScrollBarPosition >= (bwrHtml.VScrollBarRange)) and
        (bwrHtml.VScrollBarPosition >= msbPosition) then
      begin
        if mScrollAcc > 2 then
        begin
          lastWheelTime := tm;
          GoNextChapter();
          Handled := true;

        end
        else
          inc(mScrollAcc);
      end
      else
        mScrollAcc := 0;
    end
    else if WheelDelta > 0 then
    begin
      if (bwrHtml.VScrollBarPosition <= 0) and
        (bwrHtml.VScrollBarPosition <= msbPosition) then
      begin
        if mScrollAcc > 2 then
        begin
          lastWheelTime := tm;
          GoPrevChapter();
          bwrHtml.PositionTo('endofchapterNMFHJAHSTDGF123');
          Handled := true;
        end
        else
          inc(mScrollAcc);

      end;

    end;
    Exit;
  end;
  Handled := true;
  fontSize := bwrHtml.DefFontSize;
  delta := round(fontSize / 10);
  if delta = 0 then
    delta := 1;
  if WheelDelta < 0 then
    delta := -delta;
  FontChanged(delta);
  // ProcessCommand(History[lbHistory.ItemIndex]);
end;

procedure TMainForm.DisplayDictionary(const s: string);
var
  res: WideString;
  // Key: Word;
  // KeyChar: Char;
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
      res := mBqEngine.Dictionaries[i]
        .Lookup(mBqEngine.DictionaryTokens[dc_ix]);
      if res <> '' then
        cbDic.Items.Add(mBqEngine.Dictionaries[i].Name);

      if mBqEngine.Dictionaries[i].Name = cbDicFilter.Items
        [cbDicFilter.ItemIndex] then
        j := cbDic.Items.Count - 1;
    end;

    if cbDic.Items.Count > 0 then
      cbDic.ItemIndex := j;
  finally
    cbDic.Items.EndUpdate;
  end;
  // cbDic.Enabled := not (cbDic.Items.Count = 1);
  // pnlSelectDic.Visible := not (cbDic.Items.Count = 1);

  cbDic.Enabled := not(cbDic.Items.Count = 1);

  if cbDic.Items.Count = 1 then
    lblDicFoundSeveral.Caption := Lang.Say('FoundInOneDictionary')
  else
    lblDicFoundSeveral.Caption := Lang.Say('FoundInSeveralDictionaries');

  if cbDic.Items.Count > 0 then
    cbDicChange(self) // invoke showing first dictionary result
    {
      else
      begin
      repeat
      edtDicKeyUp(nil, Key, []);
      if (edtDic.Text <> '') and
      (WideLowerCase(edtDic.Text) <> WideLowerCase(DicLB.Items[0])) and
      (DicLB.ItemIndex = 0) then
      edtDic.Text := Copy(edtDic.Text,1,Length(edtDic.Text)-1);
      until (edtDic.Text = '') or (DicLB.ItemIndex <> 0);

      //ActiveControl := edtDic;
      KeyChar := #13;
      edtDicKeyPress(nil, KeyChar);
      end;
    }
end;

procedure TMainForm.DisplayStrongs(num: integer; hebrew: Boolean);
var
  res, s, Copyright: string;
  i: integer;
  fullDir: string;
begin
  // if num = 0 then Exit;

  s := IntToStr(num);
  for i := Length(s) to 4 do
    s := '0' + s;

  StrongsDir := MainBook.StrongsDirectory;

  if StrongsDir = '' then
    StrongsDir := C_StrongsSubDirectory;

  fullDir := TPath.Combine(ModulesDirectory, StrongsDir);

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

  // end;

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

procedure TMainForm.bwrHtmlKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  oxt, oct: integer;
begin
  if GetActiveTabInfo().mLocationType = vtlFile then
    Exit;

  if (Key = VK_NEXT) and (bwrHtml.Position = BrowserPosition) then
  begin
    GoNextChapter;
    Exit;
  end;
  if (Key = VK_PRIOR) and (bwrHtml.Position = BrowserPosition) then
  begin
    GoPrevChapter;
    if (MainBook.CurBook <> 1) or (MainBook.CurChapter <> 1) then
      bwrHtml.PositionTo('endofchapterNMFHJAHSTDGF123');
    Exit;
  end;
  if Key = VK_HOME then
  begin
    bwrHtml.Position := 0;
    Exit;
  end;
  if Key = VK_END then
  begin
    bwrHtml.PositionTo('endofchapterNMFHJAHSTDGF123');
  end;

  if Key = $4C { THE L KEY } then
  begin
    miRecognizeBibleLinks.Click();
    Exit
  end;

  if ssAlt in Shift then
  begin
    if Key = VK_LEFT then
    begin
      tbtnBack.Click;
      Exit;
    end;
    if Key = VK_RIGHT then
    begin
      tbtnForward.Click;
      Exit
    end;
  end;

  if Key = VK_SPACE then
  begin
    oxt := tbXRef.tag;
    oct := tbComments.tag;
    tbXRef.tag := Get_ANAME_VerseNumber(bwrHtml.DocumentSource, CurFromVerse,
      bwrHtml.FindSourcePos(bwrHtml.CaretPos, true));
    tbComments.tag := tbXRef.tag;
    if (pgcMain.ActivePage = tbXRef) and (oxt <> tbXRef.tag) then
    begin
      ShowXref;
      Exit

    end;

    if (pgcMain.ActivePage = tbComments) and (oct <> tbComments.tag) then
    begin
      ShowComments;
      Exit
    end;
  end;
end;

procedure TMainForm.miPrintPreviewClick(Sender: TObject);
begin
  tbtnPreviewClick(Sender);
end;

procedure TMainForm.lbHistoryDblClick(Sender: TObject);
var
  s: string;
begin
  s := History[lbHistory.ItemIndex];

  History.Delete(lbHistory.ItemIndex);
  lbHistory.Items.Delete(lbHistory.ItemIndex);

  ProcessCommand(s, hlDefault);
  // ComplexLinksPanel.Visible := false;
  { cbLinks.Visible := false; }
  tbLinksToolBar.Visible := false;
end;

procedure TMainForm.miStrongClick(Sender: TObject);
var
  vti: TViewTabInfo;
  savePosition: integer;
begin
  miStrong.Checked := not miStrong.Checked;
  StrongNumbersOn := miStrong.Checked;
  tbtnStrongNumbers.Down := StrongNumbersOn;
  vti := GetActiveTabInfo();
  vti[vtisShowStrongs] := StrongNumbersOn;

  if not MainBook.Trait[bqmtStrongs] then
  begin
    tbtnStrongNumbers.Enabled := false;
    Exit;
  end;
  savePosition := bwrHtml.Position;
  ProcessCommand(vti.mwsLocation, TbqHLVerseOption(ord(vti[vtisHighLightVerses])));
  bwrHtml.Position := savePosition;
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
begin
  if not(CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then
    Exit;
  // reClipboard.SelectAll;
  // reClipboard.ClearSelection;
  // reClipboard.Lines.Clear;
  if MainBook.fontName <> '' then
    reClipboard.Font.Name := MainBook.fontName
  else
    reClipboard.Font.Name := bwrHtml.DefFontName;

  reClipboard.Font.Size := bwrHtml.DefFontSize;
  reClipboard.Lines.Add(Clipboard.AsText);

  reClipboard.SelectAll;
  reClipboard.SelAttributes.CharSet := bwrHtml.CharSet;
  reClipboard.SelAttributes.Name := reClipboard.Font.Name;

  if Length(mHTMLSelection) > 0 then
    CopyHTMLToClipBoard('', mHTMLSelection)
  else
    reClipboard.CopyToClipboard;
end;

procedure TMainForm.DisplaySearchResults(page: integer);
var
  i, limit: integer;
  s: WideString;
  dSource: string;
begin

  if (SearchPageSize * (page - 1) > SearchResults.Count) or
    (SearchResults.Count = 0) then
  begin
    Screen.Cursor := crDefault;
    Exit;
  end;

  SearchPage := page;

  dSource := Format('<b>"<font face="%s">%s</font>"</b> (%d) <p>',
    [MainBook.fontName, cbSearch.Text, SearchResults.Count]);

  limit := SearchResults.Count div SearchPageSize + 1;
  if SearchPageSize * (limit - 1) = SearchResults.Count then
    limit := limit - 1;
  {
    if page > 2 then s := s + Format('<a href="%d">-200</a>', [page-2]);
    if page > 1 then s := s + Format('<a href="%d">-100</a>', [page-1]);
    if page < limit-1 then s := s + Format('<a href="%d">+100</a>', [page+1]);
    if page < limit then s := s + Format('<a href="%d">+200</a>', [page+2]);
  }

  s := '';
  for i := 1 to limit - 1 do
  begin
    if i <> page then
      s := s + Format('<a href="%d">%d-%d</a> ',
        [i, SearchPageSize * (i - 1) + 1, SearchPageSize * i])
    else
      s := s + Format('%d-%d ', [SearchPageSize * (i - 1) + 1,
        SearchPageSize * i]);
  end;

  if limit <> page then
    s := s + Format('<a href="%d">%d-%d</a> ',
      [limit, SearchPageSize * (limit - 1) + 1, SearchResults.Count])
  else
    s := s + Format('%d-%d ', [SearchPageSize * (limit - 1) + 1,
      SearchResults.Count]);

  // SearchBrowserSource.Add(s + '<p>');

  limit := SearchPageSize * page - 1;
  if limit >= SearchResults.Count then
    limit := SearchResults.Count - 1;

  for i := SearchPageSize * (page - 1) to limit do
    AddLine(dSource, '<font size=-1>' + IntToStr(i + 1) + '.</font> ' +
      SearchResults[i]);

  AddLine(dSource, '<a name="endofsearchresults"><p>' + s + '<br><p>');

  bwrSearch.CharSet := bwrHtml.CharSet;

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
  wsrc, satBible: WideString;
  ti: TViewTabInfo;
begin
  wsrc := SRC;
  Val(wsrc, i, code);
  if code = 0 then
    DisplaySearchResults(i)
  else
  begin
    if (Copy(wsrc, 1, 3) <> 'go ') then
    begin
      if MainBook.OpenReference(wsrc, book, chapter, fromverse, toverse) then
        wsrc := Format('go %s %d %d %d %d', [MainBook.ShortPath, book, chapter, fromverse, toverse])
      else
        wsrc := '';
    end;
    if Length(wsrc) > 0 then
    begin
      if IsDown(VK_MENU) then
      begin
        ti := GetActiveTabInfo();
        if Assigned(ti) then
          satBible := ti.mSatelliteName
        else
          satBible := '------';

        NewViewTab(wsrc, satBible, bwrHtml.Base, GetActiveTabInfo().state, '', true);

      end
      else
        ProcessCommand(wsrc, hlTrue);
    end;
  end;
  Handled := true;
end;

procedure TMainForm.miSearchWordClick(Sender: TObject);
begin
  if bwrHtml.SelLength = 0 then
    Exit;

  IsSearching := false;
  cbSearch.Text := Trim(bwrHtml.SelText);
  miSearch.Click;
  btnFindClick(Sender);
end;

procedure TMainForm.miShowSignaturesClick(Sender: TObject);
var
  vti: TViewTabInfo;
  savePosition: integer;
begin
  miShowSignatures.Checked := not miShowSignatures.Checked;

  vti := GetActiveTabInfo();
  vti[vtisShowStrongs] := StrongNumbersOn;
  savePosition := bwrHtml.Position;
  ProcessCommand(vti.mwsLocation, TbqHLVerseOption(ord(vti[vtisHighLightVerses])));
  bwrHtml.Position := savePosition;
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
  tabInfo: TViewTabInfo;
label LoopTail;
begin
  if not MainBook.isBible then
    Exit;

  if (pgcViewTabs.TabIndex < 0) then
    Exit;

  tabInfo := pgcViewTabs.Tabs.Objects[pgcViewTabs.TabIndex] as TViewTabInfo;

  if (not Assigned(tabInfo)) then
    Exit;

  // try
  dBrowserSource := '<font size=+1><table>';
  bwrHtml.DefFontName := mBrowserDefaultFontName;
  MainBook.OpenChapter(MainBook.CurBook, MainBook.CurChapter);
  s := MainBook.Verses[CurVerseNumber - 1];
  StrDeleteFirstNumber(s);

  if not StrongNumbersOn then
    s := DeleteStrongNumbers(s);

  AddLine(dBrowserSource,
    Format
    ('<tr><td valign=top><a href="go %s %d %d %d 0">%s&nbsp;%s</a>&nbsp;</td><td valign=top><font face="%s">%s</font></td>'#13#10,
    [MainBook.ShortPath, MainBook.CurBook, MainBook.CurChapter, CurVerseNumber,
    MainBook.ShortName, MainBook.ShortPassageSignature(MainBook.CurBook,
    MainBook.CurChapter, CurVerseNumber, CurVerseNumber),
    MainBook.fontName, s]));

  AddLine(dBrowserSource, '<tr><td></td><td><hr width=100%></td></tr>'#13#10);
  bibleModuleEntry := mModules.ModTypedAsFirst(modtypeBible);
  while Assigned(bibleModuleEntry) do
  begin
    s := bibleModuleEntry.getIniPath();
    SecondBook.inifile := s;

    // don't display New Testament mixed with Old Testament...

    if (MainBook.CurBook < 40) and (MainBook.Trait[bqmtOldCovenant]) and (not SecondBook.Trait[bqmtOldCovenant]) then
      goto LoopTail;

    if (MainBook.CurBook > 39) and (MainBook.Trait[bqmtNewCovenant]) and (not SecondBook.Trait[bqmtNewCovenant]) then
      goto LoopTail;

    with MainBook do
      ReferenceToInternal(CurBook, CurChapter, CurVerseNumber, book, chapter, verse);

    SecondBook.InternalToReference(book, chapter, verse, ib, ic, iv);

    try
      openSuccess := SecondBook.OpenChapter(ib, ic);
    except
      openSuccess := false

    end;
    if not openSuccess then
      goto LoopTail;
    if iv > SecondBook.verseCount() then
      goto LoopTail;

    s := SecondBook.Verses[iv - 1];
    StrDeleteFirstNumber(s);

    if not StrongNumbersOn then
      s := DeleteStrongNumbers(s);

    if Length(SecondBook.fontName) > 0 then
    begin
      fontFound := PrepareFont(SecondBook.fontName, SecondBook.path);
      fontName := SecondBook.fontName;
    end
    else
      fontFound := false;
    (* если предподчтительного шрифта нет или он не найден и указана кодировка *)
    if not fontFound and (SecondBook.desiredCharset >= 2) then
    begin
      { находим шрифт с нужной кодировкой учитывая предподчтительный и дефолтный }
      if Length(SecondBook.fontName) > 0 then
        fontName := SecondBook.fontName
      else
        fontName := mBrowserDefaultFontName;
      fontName := FontFromCharset(self.Canvas.Handle, SecondBook.desiredCharset, fontName);
    end;

    AddLine(dBrowserSource,
      Format('<tr><td valign=top><a href="go %s %d %d %d 0">%s&nbsp;%s</a>&nbsp;' +
      '<BR><SPAN STYLE="font-size:67%%">%s</SPAN></td><td valign=top><font face="%s">%s</font></td></tr>'#13#10,
      [SecondBook.ShortPath, ib, ic, iv, SecondBook.ShortName,
      SecondBook.ShortPassageSignature(ib, ic, iv, iv), SecondBook.Name,
      fontName, s]));
  LoopTail:
    bibleModuleEntry := mModules.ModTypedAsNext(modtypeBible);
  end;

  AddLine(dBrowserSource, '</table>');
  bwrHtml.LoadFromString(dBrowserSource);

  tabInfo.mIsCompareTranslation := true;
  tabInfo.mCompareTranslationText := dBrowserSource;
end;

procedure TMainForm.miCompareClick(Sender: TObject);
begin
  CompareTranslations();
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  // Application.ActivateHint(Mouse.CursorPos);
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

  TranslateForm(ExceptionForm);
  TranslateForm(AboutForm);

  ConfigForm.Font := MainForm.Font;
  ConfigForm.Font.CharSet := MainForm.Font.CharSet;

  TranslateConfigForm;

  // InitHotModulesConfigPage(true);
  splMainMoved(Sender);
  splGoMoved(Sender);

  try
    if (bwrHtml <> nil) then
      ActiveControl := bwrHtml
  except
    on E: Exception do
      BqShowException(E);
  end;

end;

procedure TMainForm.cbLinksChange(Sender: TObject);
var
  book, chapter, fromverse, toverse: integer;
begin
  edtGo.Text := cbLinks.Items[cbLinks.ItemIndex];

  if MainBook.OpenReference(edtGo.Text, book, chapter, fromverse, toverse) then
    ProcessCommand(Format('go %s %d %d %d %d', [MainBook.ShortPath, book, chapter, fromverse, toverse]), hlDefault)
  else
    ProcessCommand(edtGo.Text, hlDefault);
end;

function TMainForm.DefaultLocation: string;

var
  i, fc: integer;
  bibleModuleEntry: TModuleEntry;
begin
  Result := '';
  try

    // if Bibles.Count = 0 then
    // raise
    // Exception.Create('Не найдено ни одного библейского модуля!');
    bibleModuleEntry := nil;
    fc := mFavorites.mModuleEntries.Count - 1;
    for i := 0 to fc do
    begin

      if mFavorites.mModuleEntries[i].modType = modtypeBible then
      begin
        bibleModuleEntry := mFavorites.mModuleEntries[i];
        break;
      end;
      // bible := TModuleEntry(mFavorites.mModuleEntries[i]).wsFullName;
      // bi := Bibles.IndexOf(bible);
      // if bi >= 0 then break;
    end;
    // if bi < 0 then begin
    // bi := 0;
    // bible := Bibles[0];
    // end;
    /// ix := mModules.FindByName(bible);
    // if ix < 0 then begin raise TBQException.Create('Cannot Find Bible');
    // end;

    if not Assigned(bibleModuleEntry) then
    begin
      bibleModuleEntry := mModules.ModTypedAsFirst(modtypeBible);
    end;
    if not Assigned(bibleModuleEntry) then
      raise Exception.Create
        ('Не найдено ни одного библейского модуля! Проверьте правильность установки exe файла Ц.'
        + #13#10'Он должен быть в папке, содержащей вложенные в нее папки модулей');

    Result := bibleModuleEntry.wsShortPath;
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
  ti, cti: TViewTabInfo;
begin
  ti := GetActiveTabInfo();
  C := pgcViewTabs.Tabs.Count - 1;
  for i := 0 to C do
  begin
    try
      cti := pgcViewTabs.Tabs.Objects[i] as TViewTabInfo;
      if cti <> ti then
        cti[vtisPendingReload] := true;
    except
    end;
  end;
  ProcessCommand(ti.mwsLocation, TbqHLVerseOption(ord(ti[vtisHighLightVerses])));
end;

procedure TMainForm.DeleteHotModule(moduleTabIx: integer);
var
  hotMenuItem, favouriteMenuItem: TMenuItem;

begin
  try
    hotMenuItem := dtsBible.Tabs.Objects[moduleTabIx] as TMenuItem;

    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    if not Assigned(favouriteMenuItem) then
      Exit;
    favouriteMenuItem.Remove(hotMenuItem);
    dtsBible.Tabs.Delete(moduleTabIx);
    hotMenuItem.Free();
    AdjustBibleTabs(MainBook.ShortName);
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
  currentModule: TBible;
  status: integer;
begin
  // AlekId
  // MainBook.IniFile := MainFileExists(mDefaultLocation + '\bibleqt.ini');
  cmd := SRC;
  Handled := true;
  autoCmd := Pos(C__bqAutoBible, cmd) <> 0;
  if autoCmd then
  begin
    currentModule := GetActiveTabInfo().mBible;
    if currentModule.isBible then
      prefBible := currentModule.ShortPath
    else
      prefBible := '';

    status := PreProcessAutoCommand(cmd, prefBible, ConcreteCmd);
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
      ProcessCommand(ConcreteCmd, hlDefault)
    else
    begin
      edtGo.Text := SRC; // AlekId: и все дела!
      edtGoDblClick(nil);
    end
  end;
end;

procedure TMainForm.bwrCommentsHotSpotClick(Sender: TObject; const SRC: string;
  var Handled: Boolean);
var
  cmd, prefBible, ConcreteCmd: string;
  autoCmd: Boolean;
  currentModule: TBible;
  status: integer;
begin
  Handled := true;
  cmd := SRC;
  autoCmd := Pos(C__bqAutoBible, cmd) <> 0;
  if autoCmd then
  begin
    currentModule := GetActiveTabInfo().mBible;
    if currentModule.isBible then
      prefBible := currentModule.ShortPath
    else
      prefBible := '';
    status := PreProcessAutoCommand(cmd, prefBible, ConcreteCmd);
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
      ProcessCommand(ConcreteCmd, hlDefault)
    else
    begin
      edtGo.Text := cmd; // AlekId: и все дела!
      edtGoDblClick(nil);
    end;
  end;
end;

procedure TMainForm.bwrStrongMouseDouble(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
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
    // if (Length(edtDic.Text) > 0) and (DicLB.ItemIndex > -1) then
    // DisplayDictionary(DicLB.Items[DicLB.ItemIndex]);
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
  writeln(bqNowDateTimeString(), ': Close Query-WMQueryEndSession');
  Flush(Output);
  MainForm.Close();
  Message.Result := 1;
end;

procedure TMainForm.TagAdded(tagId: int64; const txt: string;
  Show: Boolean);
var
  vnd: TVersesNodeData;
  pvn: PVirtualNode;
begin
  vnd := TVersesNodeData.Create(tagId, txt, bqvntTag);
  mBqEngine.VersesTagsList.Add(vnd);
  pvn := vdtTagsVerses.AddChild(nil, vnd);
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
  ix := TVersesNodeData.FindNodeById(mBqEngine.VersesTagsList, tagId,
    bqvntTag, vnd);
  if ix < 0 then
    Exit;
  vnd.cachedTxt := newTxt;
  pvn := PVirtualNode(vnd.Parents);
  vdtTagsVerses.InvalidateNode(pvn);
  // vdtTagsVerses.Sort(nil,-1,sdAscending);
end;

{ function _escallback(dwCookie: Longint; pbBuff: PByte;
  cb: Longint; var pcb: Longint): Longint; stdcall;
  begin

  end; }

{ procedure TMainForm.tbAddBibleLinkClick(Sender: TObject);
  var es:TEditStream;
  begin
  //es.dwCookie=0;
  //es.pfnCallback:=_escallback;
  //SendMessage(reMemo.Handle, EM_STREAMIN,SF_RTF, SFF_SELECTION, Longint(@es));
  end;

  {procedure TMainForm.tbtnAddCategoryClick(Sender: TObject);
  var
  pvn, pnewNode: PVirtualNode;
  cat: TBookCategory;
  begin
  cat := TBookCategory.Create('');
  mBookCategories.Add(cat);
  pvn := vstBooks.GetFirstSelected();
  pNewNode := vstBooks.AddChild(pvn, cat);
  vstBooks.EditNode(pNewNode, -1);
  end; }

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

procedure TMainForm.FormDblClick(Sender: TObject);
begin
  //
end;

procedure TMainForm.FormDeactivate(Sender: TObject);
begin
  if G_ControlKeyDown then
  begin
    SetBibleTabsHintsState(false);
    G_ControlKeyDown := false;
  end
end;

procedure TMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: integer; MousePos: TPoint; var Handled: Boolean);
begin
  //
  // self.ControlAtPos
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
  /// LoadTaggedBookMarks();

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

procedure TMainForm.tmCommonTimer(Sender: TObject);
var
  pt: TPoint;
  rct: TRect;
  hit: Boolean;
  it, tabIx, R: integer;
  chk: LongBool;
  // hint_hwnd: HWND;
  ti: TViewTabInfo;
  bl, common_lnk: TBibleLink;
  modPath, fontName, txt, wstr, psg: string;
  me: TModuleEntry;
begin
  Exit;
  try
    if hint_expanded <> 1 then
      Exit;
    // hint_hwnd := THintWindow.;
    // if not IsWindow(hint_hwnd) then exit;
    // if not IsWindowVisible(hint_hwnd) then exit;
    pt := Mouse.CursorPos;
    chk := GetWindowRect(dtsBible.Handle, rct);
    if not chk then
      Exit;
    hit := PtInRect(rct, pt);
    if not hit then
      Exit;
    if hint_expanded = 1 then
    begin
      ti := GetActiveTabInfo();
      if not bl.FromBqStringLocation(ti.mwsLocation, modPath) then
      begin
        Exit;
      end;
      if (ti.mFirstVisiblePara < 0) then
      begin
        Exit;
      end;
      it := ti.mLastVisiblePara;
      if it < 0 then
        it := ti.mFirstVisiblePara + 10;
      bl.vstart := ti.mFirstVisiblePara;
      bl.vend := it;
      tabIx := dtsBible.ItemAtPos(dtsBible.ScreenToClient(pt));
      if (tabIx < 0) or (tabIx >= dtsBible.Tabs.Count) then
      begin
        Exit;
      end;

      me := dtsBible.Tabs.Objects[tabIx] as TModuleEntry;

      R := ti.mBible.ReferenceToInternal(bl, common_lnk);
      if R < -1 then
        Exit;

      if GetModuleText(common_lnk.ToCommand(me.wsShortPath), fontName, bl, txt,
        psg, [gmtBulletDelimited]) < 0 then
      begin
        Exit;
      end;

    end;
    wstr := psg + ' (' + mRefenceBible.ShortName + ')'#13#10;
    wstr := wstr + txt;

    HintWindowClass := HintTools.TbqHintWindow;
    dtsBible.Hint := wstr;
    Application.CancelHint();
    hint_expanded := 2;
  except
  end;

  //
  // if Application.Hint then

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
    MainForm.FocusControl(bwrHtml);
  except
  end;
end;

procedure TMainForm.cbModulesKeyPress(Sender: TObject; var Key: Char);
begin
  //
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

function TMainForm.SuggestFont(const desiredFontName, desiredFontPath: string;
  desiredCharset: integer): string;
begin
  if Length(desiredFontName) > 0 then
    if PrepareFont(desiredFontName, desiredFontPath) then
    begin
      // если шрифт установлен или его удалось подгрузить
      Result := desiredFontName;
      Exit;
    end;
  // (*если предподчтительного шрифта нет или он не найден и указана кодировка*)
  if (desiredCharset >= 2) then
  begin
    { находим шрифт с нужной кодировкой учитывая предподчтительный и дефолтный }
    if Length(desiredFontName) > 0 then
      Result := desiredFontName
    else
      Result := mBrowserDefaultFontName;
    Result := FontFromCharset(self.Canvas.Handle, desiredCharset, Result);
  end;
  // если все еще не найден шрифт то берем исходный из настроек программы
  if (Length(Result) <= 0) then
    Result := mBrowserDefaultFontName;

end;

procedure TMainForm.miAboutClick(Sender: TObject);
begin
  if not Assigned(AboutForm) then
    AboutForm := TAboutForm.Create(self);
  AboutForm.ShowModal();
end;

procedure TMainForm.bwrSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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

procedure TMainForm.bwrSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  SearchBrowserPosition := bwrSearch.Position;
end;

var
  __i, __j, __cnt: integer;

function __lstSort(List: TStringList; Index1, Index2: integer): integer;
begin
  Result := OmegaCompareTxt(List[Index1], List[Index2], -1, true);
end;

function TMainForm.DictionaryStartup(maxAdd: integer = maxInt): Boolean;
var
  wordCount, i: integer;
  pvn: PVirtualNode;
  tokens: TBQStringList;
begin
  Result := false;

  vstDicList.BeginUpdate();

  // __i := 0;
  // __cnt := mDicList.Count - 1;
  try
    tokens := mBqEngine.DictionaryTokens;
    wordCount := tokens.Count - 1;
    vstDicList.Clear();

    for i := 0 to wordCount do
    begin
      pvn := vstDicList.AddChild(nil, Pointer(i));
      tokens.Objects[i] := TObject(pvn);
    end; // for

  finally
    vstDicList.EndUpdate();
  end;

end;

procedure TMainForm.edtDicKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  { len := Length(edtDic.Text);

    if len > 0 then
    for i := 0 to DicLB.Items.Count - 1 do
    begin
    if WideLowerCase(Copy(DicLB.Items[i], 1, len))
    = WideLowerCase(edtDic.Text) then
    begin
    DicLB.ItemIndex := i;
    //DicLBClick(Sender);
    Exit;
    end;
    end;

    DicLB.ItemIndex := 0; }
end;

(* AlekId:Добавлено *)
// при перемене модуля: навигация или смена таба

procedure TMainForm.AdjustBibleTabs(awsNewModuleName: string = '');
var
  i, tabCount, tabIx, offset: integer;
  ws: string;
begin
  if Length(awsNewModuleName) = 0 then
    awsNewModuleName := MainBook.ShortName;
  offset := ord(mBibleTabsInCtrlKeyDownState) shl 1;
  tabCount := dtsBible.Tabs.Count - 1;
  tabIx := -1;
  for i := 0 to tabCount do
  begin
    ws := dtsBible.Tabs.Strings[i];
    if CompareStringW(LOCALE_SYSTEM_DEFAULT, 0,PWideChar(Pointer(awsNewModuleName)), -1, PWideChar(Pointer(ws)) + offset,-1) = CSTR_EQUAL then
    begin
      tabIx := i;
      break;
    end;
  end;
  dtsBible.OnChange := nil;
  if tabIx >= 0 then
    dtsBible.TabIndex := tabIx
  else
    dtsBible.TabIndex := dtsBible.Tabs.Count - 1;
  // not a favorite book
  dtsBible.OnChange := dtsBibleChange;
end;

procedure TMainForm.AppOnHintHandler(Sender: TObject);
begin
  //
  // hint_expanded:=0;
end;

procedure TMainForm.appEventsException(Sender: TObject; E: Exception);
begin
  BqShowException(E);
end;

procedure TMainForm.tbtnBackClick(Sender: TObject);
begin
  HistoryOn := false;
  if lbHistory.ItemIndex < lbHistory.Items.Count - 1 then
  begin
    lbHistory.ItemIndex := lbHistory.ItemIndex + 1;
    ProcessCommand(History[lbHistory.ItemIndex], hlDefault);
  end;
  HistoryOn := true;

  ActiveControl := bwrHtml;
end;

procedure TMainForm.tbtnForwardClick(Sender: TObject);
begin
  HistoryOn := false;
  if lbHistory.ItemIndex > 0 then
  begin
    lbHistory.ItemIndex := lbHistory.ItemIndex - 1;
    ProcessCommand(History[lbHistory.ItemIndex], hlDefault);
  end;
  HistoryOn := true;

  ActiveControl := bwrHtml;
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

procedure TMainForm.SearchBackward();
var
  searchText: string;
  searchOptions: TStringSearchOptions;
  i: Integer;
  dx, dy: Integer;
  X, Y: Integer;
begin
  searchText := tedtQuickSearch.Text;

  searchOptions := [];
  if (tbtnMatchCase.Down) then
    Include(searchOptions, soMatchCase);
  if (tbtnMatchWholeWord.Down) then
    Include(searchOptions, soWholeWord);

  i := FindPosition(bwrHtml.DocumentSource, searchText, BrowserSearchPosition - 1, searchOptions);
  if i > 0 then
  begin
    BrowserSearchPosition := i;
    dx := bwrHtml.FindDisplayPos(i, true);
    dy := bwrHtml.FindDisplayPos(i + Length(searchText), true);
    bwrHtml.SelStart := dx - 1;
    bwrHtml.SelLength := dy - dx;
    bwrHtml.DisplayPosToXY(dx, X, Y);
    if (Y > 10) then
      bwrHtml.VScrollBarPosition := Y - 10
    else
      bwrHtml.VScrollBarPosition := Y;
  end
  else
  begin
    if (Length(bwrHtml.DocumentSource) > 0) then
      BrowserSearchPosition := bwrHtml.DocumentSource.Length - 1
    else
      BrowserSearchPosition := 0;
  end;
end;

procedure TMainForm.SearchForward();
var
  searchText: string;
  searchOptions: TStringSearchOptions;
  i: Integer;
  dx, dy: Integer;
  X, Y: Integer;
begin
  searchText := tedtQuickSearch.Text;

  searchOptions := [soDown];
  if (tbtnMatchCase.Down) then
    Include(searchOptions, soMatchCase);
  if (tbtnMatchWholeWord.Down) then
    Include(searchOptions, soWholeWord);

  if BrowserSearchPosition = 0 then
  begin
    BrowserSearchPosition := Pos('</title>', string(bwrHtml.DocumentSource));
    if BrowserSearchPosition > 0 then
      inc(BrowserSearchPosition, Length('</title>'));
  end;

  i := FindPosition(bwrHtml.DocumentSource, searchText, BrowserSearchPosition + 1, searchOptions);
  if i > 0 then
  begin
    BrowserSearchPosition := i;
    dx := bwrHtml.FindDisplayPos(i, true);
    dy := bwrHtml.FindDisplayPos(i + Length(searchText), true);
    bwrHtml.SelStart := dx - 1;
    bwrHtml.SelLength := dy - dx;
    bwrHtml.DisplayPosToXY(dx, X, Y);
    if (Y > 10) then
      bwrHtml.VScrollBarPosition := Y - 10
    else
      bwrHtml.VScrollBarPosition := Y;
  end
  else
    BrowserSearchPosition := 0;
end;

procedure TMainForm.ToggleQuickSearchPanel(const enable: Boolean);
begin
  tbtnQuickSearch.Down := enable;
  tlbQuickSearch.Visible := enable;
  tlbQuickSearch.Height := IfThen(enable, tlbViewPage.Height, 0);

  if (enable) then
    ActiveControl := tedtQuickSearch;

end;

procedure TMainForm.TranslateForm(form: TForm);
begin
  try
    if Assigned(form) then
      Lang.TranslateForm(form);
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
    Lang.TranslateForm(ConfigForm);
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

procedure TMainForm.bwrDicMouseDouble(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  DisplayDictionary(Trim(bwrDic.SelText));
end;

procedure TMainForm.bwrXRefHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  ti: TViewTabInfo;
  wsrc, satBible: WideString;

begin
  wsrc := SRC;
  if IsDown(VK_MENU) then
  begin
    ti := GetActiveTabInfo();
    if Assigned(ti) then
      satBible := ti.mSatelliteName
    else
      satBible := '------';
    NewViewTab(wsrc, satBible, bwrHtml.Base, GetActiveTabInfo().state, '', true)

  end
  else
    ProcessCommand(wsrc, hlDefault);
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
  vti: TViewTabInfo;
  imageIx, browserpos: integer;
begin
  nV := miRecognizeBibleLinks.Checked;
  vti := GetActiveTabInfo();
  vti[vtisResolveLinks] := nV;
  // tbtnResolveLinks.Down:=nV;

  if nV then
  begin
    if vti[vtisFuzzyResolveLinks] then
      imageIx := 43
    else
      imageIx := 42;
  end
  else
    imageIx := 41;

  tbtnResolveLinks.ImageIndex := imageIx;

  if (MainBook.RecognizeBibleLinks <> nV) or (vti[vtisPendingReload]) then
  begin
    browserpos := bwrHtml.Position;
    MainBook.FuzzyResolve := vti[vtisFuzzyResolveLinks];
    MainBook.RecognizeBibleLinks := nV;
    SafeProcessCommand(vti.mwsLocation,
      TbqHLVerseOption(ord(vti[vtisHighLightVerses])));
    vti[vtisPendingReload] := false;
    bwrHtml.Position := browserpos;
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
  // (pmRef.PopupComponent as THTMLViewer).SelStart
  // ConvertClipboard;
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
(* AlekId:Добавлено *)

procedure TMainForm.UpdateAllBooks;
var
  moduleEntry: TModuleEntry;
begin

  cbModules.Items.BeginUpdate;
  try
    cbModules.Items.Clear;

    cbModules.Items.Add('——— ' + Lang.Say('StrBibleTranslations') + ' ———');
    moduleEntry := mModules.ModTypedAsFirst(modtypeBible);
    while Assigned(moduleEntry) do
    begin
      // for i := 0 to Bibles.Count - 1 do begin
      cbModules.Items.Add(moduleEntry.wsFullName);
      moduleEntry := mModules.ModTypedAsNext(modtypeBible);
    end;
    cbModules.Items.Add('——— ' + Lang.Say('StrBooks') + ' ———');
    moduleEntry := mModules.ModTypedAsFirst(modtypeBook);
    // for i := 0 to Books.Count - 1 do
    while Assigned(moduleEntry) do
    begin
      cbModules.Items.Add(moduleEntry.wsFullName);
      moduleEntry := mModules.ModTypedAsNext(modtypeBook);
    end;

    cbModules.Items.Add('——— ' + Lang.Say('StrCommentaries') + ' ———');
    moduleEntry := mModules.ModTypedAsFirst(modtypeComment);
    while Assigned(moduleEntry) do
    begin
      // for i := 0 to ModulesList.Count - Bibles.Count - Books.Count - 1 do
      cbModules.Items.Add(moduleEntry.wsFullName);
      moduleEntry := mModules.ModTypedAsNext(modtypeComment);
    end;

    if MainBook.Name <> '' then
      cbModules.ItemIndex := cbModules.Items.IndexOf(MainBook.Name);
  finally
    cbModules.Items.EndUpdate;
  end;

  cbComments.Items.BeginUpdate;
  try
    cbComments.Items.Clear;
    moduleEntry := mModules.ModTypedAsFirst(modtypeComment);
    while Assigned(moduleEntry) do
    begin
      // for i := 0 to Comments.Count - 1 do
      cbComments.Items.Add(moduleEntry.wsFullName);
      moduleEntry := mModules.ModTypedAsNext(modtypeComment);
    end;

  finally
    cbComments.Items.EndUpdate;
  end;

  cbComments.ItemIndex := 0;

  // for i := 0 to Bibles.Count - 1 do
  // begin
  // MI := TMenuItem.Create(Self);
  // MI.Caption := Bibles[i];
  // MI.OnClick := SatelliteMenuItemClick;
  // MI.Checked := false;
  // SatelliteMenu.Items.Add(MI);
  // end;
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

  // cbDicFilterChange(Self);
end;

function TMainForm.UpdateFromCashed(): Boolean;
begin
  try
    if not Assigned(mModules) then
      mModules := TCachedModules.Create(true);
    mModules.Assign(mModuleLoader.CachedModules);

    if Assigned(MyLibraryForm) then
    begin
      if MyLibraryForm.mUseDisposition = udMyLibrary then
        MyLibraryForm.UpdateList(mModules, -1, MainBook.Name)
      else
        MyLibraryForm.UpdateList(mModules, -1, SecondBook.Name);
    end;

    Result := true;
    mDefaultLocation := DefaultLocation();
  except
    Result := false;
  end;
end;

procedure TMainForm.UpdateUI();
var
  saveEvent, saveEvent2: TNotifyEvent;
  tabInfo: TViewTabInfo;
  i: integer;
begin
  mInterfaceLock := true;
  mScrollAcc := 0;
  try
    tabInfo := GetActiveTabInfo();
    if not Assigned(tabInfo) then
      Exit;

    MainBook := tabInfo.mBible;
    AdjustBibleTabs(MainBook.ShortName);
    StrongNumbersOn := tabInfo[vtisShowStrongs];
    miStrong.Checked := tabInfo[vtisShowStrongs];
    tbtnStrongNumbers.Down := tabInfo[vtisShowStrongs];
    tbtnSatellite.Down := (Length(tabInfo.mSatelliteName) > 0) and (tabInfo.mSatelliteName <> '------');

    tbtnStrongNumbers.Enabled := MainBook.Trait[bqmtStrongs];
    MemosOn := tabInfo[vtisShowNotes];
    miMemosToggle.Checked := MemosOn;

    if tabInfo[vtisResolveLinks] then
    begin
      if tabInfo[vtisFuzzyResolveLinks] then
        i := 43
      else
        i := 42;
    end
    else
      i := 41;

    tbtnResolveLinks.ImageIndex := i;

    miRecognizeBibleLinks.Checked := tabInfo[vtisResolveLinks];

    tbtnMemos.Down := MemosOn;

    if not MainBook.isBible then
    begin
      cbList.Style := csDropDownList;
      try
        LoadSecondBookByName(tabInfo.mSatelliteName);
      except
        on E: Exception do
          BqShowException(E);
      end;
    end
    else
      cbList.Style := csDropDown;

    // комбо модулей
    with cbModules do
    begin
      saveEvent := OnChange;
      OnChange := nil;
      ItemIndex := Items.IndexOf(MainBook.Name);
      OnChange := saveEvent;
    end;
    // списки книг и глав
    saveEvent := lbBook.OnClick;
    lbBook.OnClick := nil;
    saveEvent2 := lbChapter.OnClick;
    lbChapter.OnClick := nil;
    UpdateBooksAndChaptersBoxes(); // заполняем списки
    lbBook.OnClick := saveEvent;
    lbChapter.OnClick := saveEvent2;
    SearchListInit();

    lblTitle.Font.Name := tabInfo.mwsTitleFont;
    lblTitle.Caption := tabInfo.mwsTitleLocation;
    lblCopyRightNotice.Caption := tabInfo.mwsCopyrightNotice;

    if tabInfo[vtisPendingReload] then
    begin
      tabInfo[vtisPendingReload] := false;
      SafeProcessCommand(tabInfo.mwsLocation, TbqHLVerseOption(ord(tabInfo[vtisHighLightVerses])));
    end;
    if (tabInfo.mLocationType = vtlModule) and Assigned(tabInfo.mBible) and (tabInfo.mBible.isBible) then
      Caption := tabInfo.mBible.Name + ' — BibleQuote';
  finally
    mInterfaceLock := false;
  end;
end;

procedure TMainForm.vstDicListAddToSelection(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  //
end;

procedure TMainForm.vstDicListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
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
  //
end;

procedure TMainForm.VerseAdded(verseId, tagId: int64; const cmd: string;
  Show: Boolean);
var
  ix: integer;
  vnd, vnd_verse: TVersesNodeData;
  pvnTag, pvnVerse: PVirtualNode;

begin
  ix := TVersesNodeData.FindNodeById(mBqEngine.VersesTagsList, tagId,
    bqvntTag, vnd);
  if ix < 0 then
    Exit;
  pvnTag := PVirtualNode(vnd.Parents);
  if not Assigned(pvnTag) then
    Exit;
  if TVersesNodeData.FindNodeById(mBqEngine.VersesTagsList, verseId, bqvntVerse,
    vnd_verse) < 0 then
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
  pvnVerse := vdtTagsVerses.AddChild(pvnTag, vnd_verse);
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
  ix := TVersesNodeData.FindNodeById(mBqEngine.VersesTagsList, verseId,
    bqvntVerse, vnd);
  if ix < 0 then
    Exit;
  // vnd:=TVersesNodeData( mBqEngine.VersesTagsList.Items[ix]);
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
  activeTabInfo: TViewTabInfo;
  function find_verse(sp: integer): integer;
  var
    pfind: PChar;
    i: integer;
  begin
    Result := -1;
    pfind := searchbuf(PChar(Pointer(ds)), sourcePos - 1, sourcePos - 1, 0,
      '<a name="bqverse', [soMatchCase]);
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
    scrollPos := integer(bwrHtml.VScrollBar.Position);
    msbPosition := scrollPos;
    if scrollPos = 0 then
      vn := 1;

    sct := bwrHtml.SectionList.FindSectionAtPosition(scrollPos, vn, ch);

    BottomPos := scrollPos + bwrHtml.__PaintPanel.Height;
    scte := bwrHtml.SectionList.FindSectionAtPosition(BottomPos, ve, ch);
    ds := bwrHtml.DocumentSource;
    if Assigned(sct) and (sct is TSectionBase) then
    begin
      delta := sct.DrawHeight div 2;
      positionLst := bwrHtml.SectionList.PositionList;
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
        // sectionCnt:=positionLst.Count-1;
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

    activeTabInfo := GetActiveTabInfo();
    if vn > 0 then
    begin
      activeTabInfo.mFirstVisiblePara := vn;
      if bl.FromBqStringLocation(activeTabInfo.mwsLocation, path) then
      begin
        bl.vstart := vn;
        // activeTabinfo.mwsLocation := bl.ToCommand(path, [blpLimitChapterTxt]);
      end;
    end;
    if (ve > 0) and (ve >= vn) then
      activeTabInfo.mLastVisiblePara := ve
    else
    begin
      activeTabInfo.mLastVisiblePara := -1;
      ve := 0;
    end;
    if (vn > 0) and (ve > 0) then

      lblTitle.Caption := MainBook.ShortName + ' ' +
        MainBook.FullPassageSignature(MainBook.CurBook,
        MainBook.CurChapter, vn, ve);

  except
    on E: EAccessViolation do
    begin
      BqShowException(E);
    end
  end;
end;

procedure TMainForm.vdtTagsVersesCollapsed(Sender: TBaseVirtualTree;
  Node: PVirtualNode);

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

procedure TMainForm.vdtTagsVersesCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: integer);
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
  //
end;

procedure TMainForm.vdtTagsVersesCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);

begin
  //
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
  rct := Rect(0, 0, vdt.ClientWidth - levelIndent - vdt.Margin -
    vdt.TextMargin, 500);
  vdt.Canvas.Font := vdt.Font;
  R := GfxRenderers.TbqTagsRenderer.GetContentTypeAt
    (pt.X - vdt.Margin - levelIndent, pt.Y - nodeTop, vdt.Canvas, nd, rct);
  if R <> tvcPlainTxt then
    Exit;
  ble := nd.getBibleLinkEx();
  ProcessCommand(ble.ToCommand(), hlTrue);
end;

procedure TMainForm.vdtTagsVersesEdited(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  nodedata: TVersesNodeData;
begin
  //
  if Node = nil then
    Exit;
  nodedata := TObject(Sender.GetNodeData(Node)^) as TVersesNodeData;
  if (not Assigned(nodedata)) or (nodedata.nodeType <> bqvntTag) then
    Exit;
  Sender.Sort(nil, -1, sdAscending);
end;

procedure TMainForm.vdtTagsVersesEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Sender.NodeParent[Node] = nil;

  //
end;

procedure TMainForm.vdtTagsVersesGetNodeWidth(Sender: TBaseVirtualTree;
  HintCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  var NodeWidth: integer);
var
  ws: WideString;
  nd: TVersesNodeData;
  rct: TRect;
begin
  //
  nd := TVersesNodeData((Sender.GetNodeData(Node))^);
  HintCanvas.Font := Sender.Font;
  ws := Format('%s (%d)', [nd.getText(), vdtTagsVerses.ChildCount[Node]]);
  rct := Rect(0, 0, Sender.ClientWidth - mscrollbarX - vdtTagsVerses.TextMargin
    * 2 - 5, 40);
  // Windows.DrawTextW(HintCanvas.Handle,
  // PWideChar(Pointer(ws)), -1, rct, DT_CALCRECT or DT_WORDBREAK);
  NodeWidth := rct.Right;
end;

// procedure TMainForm.vdtTagsVersesInitChildren(Sender: TBaseVirtualTree;
// Node: PVirtualNode; var ChildCount: Cardinal);
// var vnd:TVersesNodeData;
// firstChildCacheIx:integer;
// begin
// if (Node=nil) or (Node=Sender.RootNode) then
// exit;
// if childCount>0 then exit;
//
// vnd:=TVersesNodeData(sender.GetNodeData(Node)^);
// childcount:=VersesDb.VerseListEngine.InitNode(vnd,mBqEngine.VersesTagsList,firstChildCacheIx );
//
// end;

procedure TMainForm.vdtTagsVersesIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: string; var Result: integer);
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
  posIx := bqWidePosCI(SearchText, vnd.getText());
  if posIx > 0 then
    Result := 0;

end;

procedure TMainForm.vdtTagsVersesInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
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

    // if parentnode=nil then exit; //alredy checked in next call
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
        searchIx := mBqEngine.VersesTagsList.FindItemByTagPointer(vnd,
          searchIx);
      until (searchIx < 0);
    Exit;
  end;
  // if (vnd.nodeType=bqvntTag) and (not (vsHasChildren in node.States) ) then include(InitialStates,ivsHasChildren);

end;

procedure TMainForm.vdtTagsVersesMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: integer);
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
      NodeHeight := TbqTagsRenderer.RenderVerseNode(TargetCanvas, nd,
        true, rct);
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
    rct.Right := vdtTagsVerses.ClientWidth - mscrollbarX -
      vdtTagsVerses.TextMargin * 2 - 5;
    // NodeHeight:=TbqTagsRenderer.RenderVerseNode(TargetCanvas,nd, true, rct);

    h := Windows.DrawTextW(TargetCanvas.Handle, PWideChar(Pointer(ws)), -1, rct,
      DT_CALCRECT or DT_WORDBREAK);
    NodeHeight := h;
    vmarg := dlt;
    if (nd.nodeType = bqvntTag) then
    begin
      inc(vmarg, 4);
      inc(NodeHeight, vmarg);
      Exit;
    end;

    rct.Left := vdtTagsVerses.TextMargin;
    rct.Right := vdtTagsVerses.Width - GetSystemMetrics(SM_CXVSCROLL) -
      vdtTagsVerses.TextMargin - 2;

    dlt := TargetCanvas.Font.Height * 4 div 5;
    TargetCanvas.Font.Height := dlt;

    TargetCanvas.Font.Style := [fsUnderline];
    if dlt < 0 then
      dlt := -dlt;
    rct.Top := h + (dlt div 2);
    rct.Bottom := rct.Top + 300;

    NodeHeight := PaintTokens(TargetCanvas, rct, nd.Parents, true) + (vmarg);
  except { on e:Exception do BqShowException(e); }
  end;

end;

procedure TMainForm.vdtTagsVersesDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
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
    // Inc(rct.Left,vdt.TextMargin );
    // Dec(rct.Right );
    // rct:=Rect(0,0,vdtTagsVerses.Width - GetSystemMetrics(SM_CXVSCROLL) -
    // vdtTagsVerses.TextMargin * 2 - 5,500);
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
    PaintInfo.Canvas.RoundRect(rct.Left, rct.Top, rct.Right, rct.Bottom,
      rectCurveRadius, rectCurveRadius);
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

  Windows.DrawTextW(PaintInfo.Canvas.Handle, PWideChar(Pointer(ws)), -1,
    rct, flgs);
  PaintInfo.Canvas.Brush.color := save_brushColor;
  PaintInfo.Canvas.Pen.color := savePenColor;

  Exit;
end;

procedure TMainForm.vdtTagsVersesMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
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
  rct := Rect(0, 0, vdt.ClientWidth - levelIndent - vdt.Margin -
    vdt.TextMargin, 500);
  // rct:=Rect(vdt.Indent,0,vdt.Width-vdt.Indent, 500);
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
  //
  ReCalculateTagTree();

end;

procedure TMainForm.vdtTagsVersesScroll(Sender: TBaseVirtualTree;
  DeltaX, DeltaY: integer);
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

procedure TMainForm.vdtTagsVersesShowScrollBar(Sender: TBaseVirtualTree;
  Bar: integer; Show: Boolean);
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

procedure TMainForm.vdtTagsVersesStateChange(Sender: TBaseVirtualTree;
  Enter, Leave: TVirtualTreeStates);
begin
  //
end;

{ procedure TMainForm.vstBooksGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
  var
  p: Pointer;
  cat: TBookCategory;
  begin
  if Node = nil then
  exit;
  p := Sender.GetNodeData(Node);
  if (p = nil) then
  exit;
  try
  cat := TObject(p^) as TBookCategory;
  CellText := cat.name;
  except end;
  end;

  procedure TMainForm.vstBooksInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
  begin
  //
  end;

  procedure TMainForm.vstBooksInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  begin
  //
  end;

  procedure TMainForm.vstBooksNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
  var
  p: Pointer;
  cat: TBookCategory;
  begin
  if Node = nil then
  exit;
  p := Sender.GetNodeData(Node);
  if (p = nil) then
  exit;
  try
  cat := TObject(p^) as TBookCategory;
  cat.name := NewText;
  except end;
  end; }

(* AlekId:/Добавлено *)

procedure TMainForm.tbtnMemoPainterClick(Sender: TObject);
begin
  ColorDialog.color := reMemo.Font.color;

  if ColorDialog.Execute then
    reMemo.SelAttributes.color := ColorDialog.color;
end;

procedure TMainForm.miMemoCopyClick(Sender: TObject);
begin
  if pmMemo.PopupComponent = reMemo then
    reMemo.CopyToClipboard
  else if pmMemo.PopupComponent is TEdit then
    (pmMemo.PopupComponent as TEdit).CopyToClipboard
  else if pmMemo.PopupComponent is TComboBox then
    Clipboard.AsText := (pmMemo.PopupComponent as TComboBox).Text;
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
  tabInfo: TViewTabInfo;
  function FailedToLoadComment(const strReason: string): string;
  begin
    Result := Lang.SayDefault('comFailedLoad', 'Failed to display commentary') +
      '<br>' + Lang.Say(strReason);
  end;

// offset: integer;
label lblSetOutput;
begin

  if not MainBook.isBible then
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
  SecondBook.inifile := commentaryModule.getIniPath();

  MainBook.ReferenceToInternal(MainBook.CurBook, MainBook.CurChapter, 1,
    ib, ic, iv);
  blFailed := not SecondBook.InternalToReference(ib, ic, iv, B, C, V);
  if blFailed then
  begin
    Lines := FailedToLoadComment('Cannot find matching comment');
    goto lblSetOutput;
  end;


  // offset := 0;
  // if SecondBook.ChapterQtys[ib] > MainBook.ChapterQtys[MainBook.CurBook] then
  // offset := 1;

  iscomm := commentaryModule.modType = modtypeComment;
  // (cbComments.ItemIndex < CommentsPaths.Count);
  {
    If this is a commentary, we 1) SHOW verse numbers
    2) add HIDDEN links to uncommented verses...
  }

  // if it's a commentary or it has chapter zero (introduction to book)
  // and it's chapter 1, show chapter 0, too :-)
  resolveLinks := false;
  tabInfo := GetActiveTabInfo();
  if Assigned(tabInfo) then
  begin
    resolveLinks := tabInfo[vtisResolveLinks];
    if resolveLinks then
      SecondBook.FuzzyResolve := tabInfo[vtisFuzzyResolveLinks];
  end;

  if SecondBook.Trait[bqmtZeroChapter] and (C = 2) then
  begin
    blFailed := true;
    try
      blFailed := not SecondBook.OpenChapter(B, 1, resolveLinks);
    except
      on E: TBQPasswordException do
      begin
        PasswordPolicy.InvalidatePassword(E.mArchive);
        MessageBoxW(self.Handle, PWideChar(Pointer(E.mWideMsg)), nil,
          MB_ICONERROR or MB_OK);
      end
    end;
    if not blFailed then
    begin

      verseCount := SecondBook.verseCount - 1;
      for verseIx := 0 to verseCount do
      begin
        s := SecondBook.Verses[verseIx];
        // StrReplace(s, '<b>', '<br><b>', false); // add spaces
        if not iscomm then
        begin
          StrDeleteFirstNumber(s);
          if SecondBook.Trait[bqmtStrongs] then
            s := DeleteStrongNumbers(s);

          AddLine(
            Lines, Format('<a name=%d>%d <font face="%s">%s</font><br>',
            [verseIx + 1, verseIx + 1, SecondBook.fontName, s])
          );

        end // if not commentary
        else
        begin // if it's commentary
          aname := StrGetFirstNumber(s);
          AddLine(Lines, Format('<a name=%s><font face="%s">%s</font><br>', [aname, SecondBook.fontName, s]));
        end;
      end;
    end;
    // Lines.Add('<p>');
    AddLine(Lines, '<hr>');
  end;
  blFailed := true;
  try
    blFailed := not SecondBook.OpenChapter(B, C, resolveLinks);
  except
    on E: TBQPasswordException do
    begin
      PasswordPolicy.InvalidatePassword(E.mArchive);
      MessageBoxW(self.Handle, PWideChar(Pointer(E.mWideMsg)), nil,
        MB_ICONERROR or MB_OK);
    end
  end;
  if blFailed then
  begin
    Lines := FailedToLoadComment('Failed to open chapter');
    goto lblSetOutput;
  end;
  // Lines.Add('<b>' + SecondBook.FullPassageSignature(ib,ic,0,0) + '</b><p>');

  verseCount := SecondBook.verseCount() - 1;
  for verseIx := 0 to verseCount do
  begin
    s := SecondBook.Verses[verseIx];
    if not iscomm then
    begin
      StrDeleteFirstNumber(s);
      if SecondBook.Trait[bqmtStrongs] then
        s := DeleteStrongNumbers(s);

      AddLine(Lines, Format('<a name=%d>%d <font face="%s">%s</font><br>',
        [verseIx + 1, verseIx + 1, SecondBook.fontName, s]));

    end
    else
    begin
      aname := StrGetFirstNumber(s);
      AddLine(Lines, Format('<a name=%s><font face="%s">%s</font><br>',
        [aname, SecondBook.fontName, s]));
    end;
  end;
  AddLine(Lines,
    '<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>');

  bwrComments.Base := SecondBook.path;
  mBqEngine.mLastUsedComment := SecondBook.Name;
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
  //
  FilterCommentariesCombo();
end;

procedure TMainForm.miHelpClick(Sender: TObject);
var
  s: WideString;
begin
  s := 'file ' + ExePath + 'help\' + HelpFileName + ' $$$' +
    Lang.Say('HelpDocumentation');

  ProcessCommand(s, hlFalse);
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
begin
  if IsDown(VK_MENU) and (MainBook.isBible) and (mslSearchBooksCache.Count > 0)
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
  res, tt: WideString;
  ti: TViewTabInfo;
  blResolveLinks, blFuzzy: Boolean;
  dicCount: integer;
begin
  dicCount := mBqEngine.DictionariesCount - 1;
  for i := 0 to dicCount do
    if mBqEngine.Dictionaries[i].Name = cbDic.Items[cbDic.ItemIndex] then
    begin
      res := mBqEngine.Dictionaries[i]
        .Lookup(mBqEngine.DictionaryTokens[DicSelectedItemIndex()]);
      break;
    end;
  blResolveLinks := false;
  blFuzzy := false;
  ti := GetActiveTabInfo();
  if Assigned(ti) then
  begin
    blResolveLinks := ti[vtisResolveLinks];
    blFuzzy := ti[vtisFuzzyResolveLinks];
  end;
  if blResolveLinks then
    tt := ResolveLnks(res, blFuzzy)
  else
    tt := res;

  bwrDic.LoadFromString(tt);
  pgcMain.ActivePage := tbDic;

  // DicLB.ItemIndex := DicLB.Items.IndexOf(edtDic.Text);
end;

procedure TMainForm.lbHistoryClick(Sender: TObject);
begin
  HistoryOn := false;
  ProcessCommand(History[lbHistory.ItemIndex], hlDefault);

  tbLinksToolBar.Visible := false;
  HistoryOn := true;
end;

function TMainForm.NavigateToInterfaceValues: Boolean;
begin
  Result := ProcessCommand(
    Format('go %s %d %d', [MainBook.ShortPath, lbBook.ItemIndex + 1, lbChapter.ItemIndex + 1]),
    hlDefault
  );
end;

function TMainForm.NewViewTab(
  const command: string; const satellite: string;
  const browserbase: string; state: TViewtabInfoState; const Title: string; visual: Boolean): Boolean;
var
  curTabInfo, newTabInfo: TViewTabInfo;
  newBible: TBible;
  saveMainBook: TBible;
begin
  newBible := nil;
  saveMainBook := MainBook;
  ClearVolatileStateData(state);
  Result := true;
  try
    // конструируем TBible
    newBible := CreateNewBibleInstance(MainBook);
    if not Assigned(newBible) then
      abort;

    if (pgcViewTabs.TabIndex >= 0) then
    begin
      // save current tab state
      curTabInfo := pgcViewTabs.Tabs.Objects[pgcViewTabs.TabIndex] as TViewTabInfo;
      if (Assigned(curTabInfo)) then
      begin
         curTabInfo.SaveBrowserState(bwrHtml);
      end;
    end;

    newTabInfo := TViewTabInfo.Create(newBible, command, satellite, Title, state);

    MainBook := newBible;
    pgcViewTabs.Tabs.AddObject(Title, newTabInfo);

    if visual then
    begin
      pgcViewTabs.TabIndex := pgcViewTabs.Tabs.Count - 1;

      StrongNumbersOn := vtisShowStrongs in state;
      MainBook.RecognizeBibleLinks := vtisResolveLinks in state;
      MainBook.FuzzyResolve := vtisFuzzyResolveLinks in state;
      MemosOn := vtisShowNotes in state;
      // SelectSatelliteMenuItem(satelliteMenuItem);
      SafeProcessCommand(command, hlDefault);

      UpdateUI();
    end
    else
    begin
      Include(newTabInfo.mState, vtisPendingReload);
    end;
  except
    on E: Exception do
    begin
      BqShowException(E);
      Result := false;
      MainBook := saveMainBook;
      newBible.Free();
    end;
  end;

end;

procedure TMainForm.tbtnNextChapterClick(Sender: TObject);
begin
  GoNextChapter;
end;

function TMainForm.PrepareFont(const aFontName, aFontPath: string): Boolean;
var
  fontFullPath: string;
begin
  Result := FontExists(aFontName);
  if Result then
    Exit;
  fontFullPath := TPath.Combine(aFontPath, aFontName);
  if FileExistsEx(fontFullPath + '.otf') >= 0 then
    fontFullPath := fontFullPath + '.otf'
  else
    fontFullPath := fontFullPath + '.ttf';

  Result := ActivateFont(fontFullPath) > 0;
end;

function TMainForm.PreProcessAutoCommand(const cmd: string;
  const prefModule: string; out ConcreteCmd: string): HRESULT;
label Fail;
var
  ps, refCnt, refIx, prefModIx: integer;
  me: TModuleEntry;
  bl, moduleEffectiveLink: TBibleLink;
  dp: string;
begin
  me := nil;
  try
    if Pos('go', Trim(cmd)) <> 1 then
      goto Fail;
    ps := Pos(C__bqAutoBible, cmd);
    if ps = 0 then
      goto Fail;
    if not bl.FromBqStringLocation(cmd, dp) then
      goto Fail;
    prefModIx := mModules.FindByFolder(prefModule);
    if prefModIx >= 0 then
    begin
      me := mModules[prefModIx];
      if me.modType = modtypeBible then
        Result := mRefenceBible.LinkValidnessStatus(me.getIniPath(), bl, true)
      else
        Result := -2;
    end
    else
      Result := -2;

    if Result < -1 then
    begin
      refCnt := RefBiblesCount() - 1;
      Result := -2;
      for refIx := 0 to refCnt do
      begin
        me := GetRefBible(refIx);
        Result := mRefenceBible.LinkValidnessStatus(me.getIniPath(), bl, true);
        if Result > -2 then
          break;
      end;
    end;
    if Result > -2 then
    begin
      mRefenceBible.InternalToReference(bl, moduleEffectiveLink);
      if (me <> nil) then
        ConcreteCmd := moduleEffectiveLink.ToCommand(me.wsShortPath);
      Exit;
    end;
  Fail:
    Result := -2;
    ConcreteCmd := cmd;
  except
    g_ExceptionContext.Add('PreProcessAutoCommand.cmd' + cmd);
    g_ExceptionContext.Add('PreProcessAutoCommand.prefModule' + prefModule);
    raise;
  end;
end;

procedure TMainForm.tbtnPrevChapterClick(Sender: TObject);
begin
  GoPrevChapter;
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
    // vdtTagsVersesScroll(vdtTagsVerses,0,0);
  end
  else if pgcMain.ActivePage = tbSearch then
  begin
    if Length(cbSearch.Text) > 0 then
      cbSearch.SelectAll();
  end;

  // if (pgcMain.ActivePage = tbComments) and (CommentsBrowserSource.Count = 0)
  // then ShowComments;

  case pgcMain.ActivePageIndex of
    0:
      pmMemo.PopupComponent := edtGo;
    1:
      begin
        pmMemo.PopupComponent := cbSearch;
      end;
    2:
      pmMemo.PopupComponent := edtDic;
    3:
      pmMemo.PopupComponent := edtStrong;
    4:
      begin
        pmMemo.PopupComponent := bwrComments;
        FilterCommentariesCombo;
      end;
    5:
      pmMemo.PopupComponent := bwrXRef;
    6:
      pmMemo.PopupComponent := reMemo;

  end;
end;

function FindPageforTabIndex(PageControl: TPageControl; TabIndex: integer)
  : TTabSheet;
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

procedure TMainForm.dtsBibleChange(Sender: TObject; NewTab: integer;
  var AllowChange: Boolean);
var
  me: TModuleEntry;
begin
  if mInterfaceLock then
    Exit;
  try

    if NewTab >= dtsBible.Tabs.Count - 1 then
    begin
      AllowChange := false;
      Exit;
    end
    else
    begin
      if IsDown(VK_SHIFT) or IsDown(VK_MENU) then
      begin
        AllowChange := false;
        Exit;
      end;
      me := dtsBible.Tabs.Objects[NewTab] as TModuleEntry;
      GoModuleName(me.wsFullName);
    end;
  except
    on E: Exception do
      BqShowException(E);
  end;

  tbLinksToolBar.Visible := false;
end;

procedure TMainForm.dtsBibleClick(Sender: TObject);
var
  pt: TPoint;
  it, modIx: integer;
  me: TModuleEntry;
  ti: TViewTabInfo;
  s: string;
begin
  if mInterfaceLock then
    Exit;
  pt := dtsBible.ScreenToClient(Mouse.CursorPos);
  it := dtsBible.ItemAtPos(pt);
  if (it < 0) or (it >= dtsBible.Tabs.Count) then
    Exit;
  if (it = dtsBible.Tabs.Count - 1) then
  begin
    if IsDown(VK_SHIFT) then
    begin
      SelectSatelliteBibleByName('');
      Exit;
    end;
    modIx := mModules.FindByFolder(GetActiveTabInfo().mBible.ShortPath);
    if modIx >= 0 then
    begin
      me := TModuleEntry(mModules.Items[modIx]);
      if mFavorites.AddModule(me) then
        AdjustBibleTabs();
    end;
    Exit;
  end;

  me := dtsBible.Tabs.Objects[it] as TModuleEntry;
  if IsDown(VK_SHIFT) then
  begin
    SelectSatelliteBibleByName(me.wsFullName);
    Exit;
  end;
  if IsDown(VK_MENU) then
  begin
    ti := GetActiveTabInfo();
    s := ti.mwsLocation;
    StrReplace(s, MainBook.ShortPath, me.wsShortPath, false);
    NewViewTab(s, ti.mSatelliteName, '', ti.state, '', true);
    Exit;
  end;
end;

procedure TMainForm.dtsBibleDrawTab(Sender: TObject; TabCanvas: TCanvas;
  R: TRect; Index: integer; Selected: Boolean);
begin //
end;

(* AlekId:Добавлено *)
{ AlekId: вызывает контекстное меню }

procedure TMainForm.dtsBibleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  pt: TPoint;
  ix: integer;
begin
  if Button <> mbLeft then
    Exit;
  pt.X := X;
  pt.Y := Y;
  ix := dtsBible.ItemAtPos(pt);
  dtsBible.tag := ix;
  if (ix < 0) or (ix >= dtsBible.Tabs.Count - 1) then
    Exit;
  dtsBible.BeginDrag(false, 20);
end;

procedure TMainForm.dtsBibleMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
{$J+}
const
  last_mouse_pos: TPoint = (X: 0; Y: 0);
  last_mouse_time: Cardinal = Cardinal(0);

  last_ix: integer = -1;
var
  tm: Cardinal;
  ps: TPoint;
  it: integer;
  me: TModuleEntry;
  ws: string;
begin
  ps.X := X;
  ps.Y := Y;
  tm := GetTickCount();
  it := dtsBible.ItemAtPos(ps);
  if (it = last_ix) { and (tm-last_mouse_time<1000) } then
    Exit;
  last_mouse_time := tm;

  if last_ix <> it then
  begin
    last_ix := it;
    hint_expanded := 0;
  end
  else if hint_expanded >= 1 then
    Exit; // same tab hint already expanded

  if (it < 0) or (it = dtsBible.Tabs.Count - 1) then
  begin
    dtsBible.Hint := '';
    Exit
  end;

  me := dtsBible.Tabs.Objects[it] as TModuleEntry;
  ws := me.wsFullName;

  if hint_expanded = 0 then
    hint_expanded := 1;
  dtsBible.Hint := ws;
  Application.CancelHint();
end;

procedure TMainForm.dtsBibleMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  pt: TPoint;
  itemIx: integer;
begin
  miDeteleBibleTab.tag := 0;
  if Button <> mbRight then
    Exit;
  pt.X := X;
  pt.Y := Y;
  itemIx := dtsBible.ItemAtPos(pt);
  if ((itemIx < 0) or (itemIx >= dtsBible.Tabs.Count - 1)) or
    (dtsBible.Tabs.Count <= 2) then
    Exit;
  miDeteleBibleTab.tag := itemIx;
  pt := dtsBible.ClientToScreen(pt);
  pmEmpty.Popup(pt.X, pt.Y);
end;

// set Browser to currently active browser

procedure TMainForm.pgcViewTabsChange(Sender: TObject);
var
  tabInfo: TViewTabInfo;
begin
  try
    tabInfo := GetActiveTabInfo();
    try
      bwrHtml.NoScollJump := true;
      UpdateUI();

      if (tabInfo.mIsCompareTranslation) then
      begin
        bwrHtml.LoadFromString(tabInfo.mCompareTranslationText);
      end
      else
      begin
        ProcessCommand(tabInfo.mwsLocation, TbqHLVerseOption(ord(tabInfo[vtisHighLightVerses])));
      end;

      tabInfo.RestoreBrowserState(bwrHtml);
    finally
      bwrHtml.NoScollJump := false;
    end;
  except
    on E: Exception do
      BqShowException(E) { just eat everything wrong }
  end;
end;

procedure TMainForm.pgcViewTabsChanging(Sender: TObject; var AllowChange: Boolean);
var
  tabInfo: TViewTabInfo;
begin
  if (pgcViewTabs.TabIndex >= 0) then
  begin
    tabInfo := pgcViewTabs.Tabs.Objects[pgcViewTabs.TabIndex] as TViewTabInfo;
    if not Assigned(tabInfo) then
      Exit;

    tabInfo.SaveBrowserState(bwrHtml);
  end;
end;

procedure TMainForm.pgcViewTabsDblClick(Sender: TClosableTabControl; Index: integer);
var
  ti: TViewTabInfo;
begin
  ti := pgcViewTabs.Tabs.Objects[index] as TViewTabInfo;
  if not Assigned(ti) then
    Exit;
  NewViewTab(ti.mwsLocation, ti.mSatelliteName, '', ti.state, '', true)
end;

procedure TMainForm.pgcViewTabsDeleteTab(Sender: TClosableTabControl; Index: integer);
begin
  pgcViewTabs.tag := index;
  miCloseTabClick(Sender);
end;

procedure TMainForm.pgcViewTabsDragDrop(Sender, Source: TObject; X, Y: integer);
var
  dropIndex: integer;
  startIndex: integer;
begin
  dropIndex := pgcViewTabs.IndexOfTabAt(X, Y);
  startIndex := pgcViewTabs.tag;
  if (dropIndex >= 0) and (startIndex >= 0) and (startIndex < pgcViewTabs.Tabs.Count) then
  begin
    if dropIndex = startIndex then
      pgcViewTabs.TabIndex := dropindex
    else
    begin
      pgcViewTabs.Tabs.Exchange(startIndex, dropindex);
      pgcViewTabs.TabIndex := dropindex;
    end;
  end;
end;

procedure TMainForm.pgcViewTabsDragOver(Sender, Source: TObject; X, Y: integer; state: TDragState; var Accept: Boolean);
begin
  if Source <> pgcViewTabs then
    Exit;
  Accept := true;
end;

procedure TMainForm.pgcViewTabsGetImageIndex(Sender: TObject; TabIndex: Integer; var ImageIndex: Integer);
begin
  // disable tab icons
  ImageIndex := -1;
end;

procedure TMainForm.pgcViewTabsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if Button = mbLeft then
    pgcViewTabs.BeginDrag(false, 10);
end;

{ /AlekId:добавлено }

procedure TMainForm.pgcViewTabsStartDrag(Sender: TObject; var DragObject: TDragObject);
var
  MousePos: TPoint;
  tabIdx: integer;
begin
  try
    MousePos := Mouse.CursorPos;
    with pgcViewTabs do
    begin
      MousePos := ScreenToClient(MousePos);
      tabIdx := IndexOfTabAt(MousePos.X, MousePos.Y);
      if ((tabIdx < 0) or (tabIdx >= Tabs.Count)) then
      begin
        CancelDrag();
        Exit;
      end;
      pgcViewTabs.tag := tabIdx;
    end;
  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;
end;

procedure TMainForm.tbInitialViewPageContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  pgcViewTabs.tag := pgcViewTabs.IndexOfTabAt(MousePos.X, MousePos.Y);;
end;

function TMainForm.LocateDicItem: integer;
var
  s: string;
  list_ix, len: integer;
  nd: PVirtualNode;
begin
  { AlekId:добавлено }
  { это чтобы избежать ненужных "рывков" в списке при двойном щелчке }
  list_ix := DicSelectedItemIndex();
  if (list_ix >= 0) and (list_ix < integer(mBqEngine.DictionariesCount)) and
    (mBqEngine.DictionaryTokens[list_ix] = edtDic.Text) then
  begin
    Result := list_ix;
    Exit;
  end;
  { //AlekId:добавлено }
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

{ procedure TMainForm.bwrXRefMainHotSpotClick(Sender: TObject;
  const SRC: string; var Handled: Boolean);
  begin
  ProcessCommand(SRC);
  Handled := true;
  end; }

(* AlekId:Добавлено *)

function TMainForm.CreateNewBibleInstance(aBible: TBible): TBible;
begin
  Result := nil;
  try
    Result := TBible.Create(self);
    with Result do
    begin
      OnVerseFound := MainBook.OnVerseFound;
      OnChangeModule := MainBook.OnChangeModule;
      OnSearchComplete := MainBook.OnSearchComplete;
      OnPasswordRequired := MainBook.OnPasswordRequired;
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
  activeTabInfo: TViewTabInfo;
  tabIndex: integer;
begin
  try
    tabIndex := pgcViewTabs.tag;
    if (tabIndex >= 0) then
    begin
      activeTabInfo := pgcViewTabs.Tabs.Objects[tabIndex] as TViewTabInfo;

      if (activeTabInfo <> nil) then
      begin
        NewViewTab(activeTabInfo.mwsLocation, activeTabInfo.mSatelliteName, '', activeTabInfo.state, '', true);
      end;
    end;
  except
  end;
end;

procedure TMainForm.miChooseLogicClick(Sender: TObject);
var
  mi: TMenuItem;
  ti: TViewTabInfo;
  reload: Boolean;
begin
  mi := Sender as TMenuItem;
  ti := GetActiveTabInfo();
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

procedure TMainForm.miCloseAllOtherTabsClick(Sender: TObject);
var
  saveTabIndex: integer;
  curTab: TViewTabInfo;
  C: integer;
begin
  try
    if (pgcViewTabs.Tabs.Count <= 1) then
    begin
      MessageBeep(MB_ICONEXCLAMATION);
      Exit;
    end;

    saveTabIndex := pgcViewTabs.tag;
    if (saveTabIndex >= 0) and (saveTabIndex < pgcViewTabs.Tabs.Count) then
    begin
      try
        C := pgcViewTabs.Tabs.Count - 1;
        try
          while C > saveTabIndex do          
          begin
            curTab := pgcViewTabs.Tabs.Objects[C] as TViewTabInfo;
            pgcViewTabs.Tabs.Delete(C);
            Dec(C);
            curTab.Free();
          end;

          C := 0;
          while C < saveTabIndex do   
          begin
            curTab := pgcViewTabs.Tabs.Objects[0] as TViewTabInfo;
            pgcViewTabs.Tabs.Delete(0);
            Inc(C);
            curTab.Free();
          end;

        finally
          pgcViewTabsChange(nil);
          pgcViewTabs.Repaint();
        end;

        pgcViewTabs.TabIndex := 0;
      finally
        pgcViewTabs.tag := -1;
      end;

    end;
  except
    on E: Exception do
      BqShowException(E, Format('pgcViewTabs.Tag:%d', [pgcViewTabs.tag]));
  end; // except
end;

procedure TMainForm.miCloseTabClick(Sender: TObject);
var
  tabInfo: TViewTabInfo;
  tabIndex: integer;
begin
  if pgcViewTabs.Tabs.Count > 1 then
  begin
    tabIndex := pgcViewTabs.tag;
    if (tabIndex >= 0) and (tabIndex < pgcViewTabs.Tabs.Count) then
    begin
      // close tab under cursor
      try
        tabInfo := pgcViewTabs.Tabs.Objects[tabIndex] as TViewTabInfo;

        FreeAndNil(tabInfo.mBible);
        pgcViewTabs.Tabs.Delete(tabIndex);

        pgcViewTabs.TabIndex := IfThen(tabIndex = pgcViewTabs.Tabs.Count, tabIndex - 1, tabIndex);

        pgcViewTabsChange(nil);
        tabInfo.Free();
        if pgcViewTabs.Tabs.Count <= 1 then
          pgcViewTabs.Repaint();

      except
        pgcViewTabs.tag := -1; // now is done
      end;
    end;
  end;
end;

procedure TMainForm.miCommentsClick(Sender: TObject);
begin
  if not pgcMain.Visible then
    tbtnToggle.Click;

  pgcMain.ActivePage := tbComments;
end;

procedure TMainForm.lbBookClick(Sender: TObject);
var
  offset, i: integer;
begin
  AddressFromMenus := true;

  with lbChapter do
  begin
    Items.BeginUpdate;
    Items.Clear;

    offset := 0;
    if MainBook.Trait[bqmtZeroChapter] then
      offset := 1;

    for i := 1 to MainBook.ChapterQtys[lbBook.ItemIndex + 1] do
      Items.Add(IntToStr(i - offset));

    Items.EndUpdate;
    ItemIndex := 0;
  end;

  NavigateToInterfaceValues();
end;

procedure TMainForm.lbBookMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  p: TPoint;
  it: integer;
begin
  p.X := X;
  p.Y := Y;
  it := lbBook.ItemAtPos(p, true);
  if (it < 0) then
    Exit;
  if mlbBooksLastIx < 0 then
    mlbBooksLastIx := it
  else if (mlbBooksLastIx = it) then
    Exit;
  mlbBooksLastIx := it;
  lbBook.Hint := lbBook.Items[it];
  Application.CancelHint();
end;

procedure TMainForm.lbChapterClick(Sender: TObject);
begin
  AddressFromMenus := true;
  NavigateToInterfaceValues();
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
begin
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    hotMenuItem := FavouriteItemFromModEntry(me);
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
    i := FavouriteTabFromModEntry(me);
    if i >= 0 then
      dtsBible.Tabs.Delete(i);
    AdjustBibleTabs(MainBook.ShortName);
  except
    on E: Exception do
      BqShowException(E);
  end;
  Result := true;
end;

{ procedure TMainForm.DeleteInvalidHotModules();
  var
  i, favouriteCount, moduleIndex, hotIndex: integer;
  favouriteMenuItem, mi: TMenuItem;
  begin
  favouriteCount := GetHotModuleCount() - 1;
  hotIndex := 0;
  favouriteMenuItem := FindTaggedTopMenuItem(3333);
  for i := 0 to favouriteCount do
  begin
  mi := GetHotMenuItem(i);
  moduleIndex := ModuleIndexByName(mi.Caption);
  if moduleIndex < 0 then
  begin
  favouriteMenuItem.Remove(mi);
  end
  else
  begin
  mi.Tag := 7000 + hotIndex; Inc(hotIndex); end;

  end;
  SetFavouritesShortcuts();
  InitBibleTabs();
  end; }

procedure TMainForm.splGoMoved(Sender: TObject);
begin
  // GroupBox1.Height := pnlGo.Height;
  // lbBook.Height := pnlGo.Height - edtGo.Height - BooksCB.Height - 26;
  // lbChapter.Height := lbBook.Height;
end;

procedure TMainForm.splMainMoved(Sender: TObject);
begin
  // Navigation Tab elements

  // GroupBox1.Width := pgcMain.Width - 10;
  // BooksCB.Width := GroupBox1.Width - 10;
  // lbBook.Width := BooksCB.Width - lbChapter.Width - 5;
  // lbChapter.Left := lbBook.Width + 10;
  //
  // edtGo.Width := lbBook.Width - HelperButton.Width;
  // HelperButton.Left := edtGo.Left + edtGo.Width + 3;
  // btnAddressOK.Left := lbChapter.Left;

  // Search Tab elements

  // cbSearch.Width := tbSearch.Width - cbQty.Width - 10;
  // cbQty.Left := cbSearch.Width + 7;
  // CBList.Width := cbSearch.Width - 22;
  // btnFind.Left := cbQty.Left;

  // Dic Tab & Strong Tab

  // edtDic.Width := tbDic.Width - 10;
  // vstDicList.Width := edtDic.Width;
  // cbDic.Width := edtDic.Width;
  // cbDicFilter.Width := edtDic.Width;
  // edtStrong.Width := tbStrong.Width - 10;
  // lbStrong.Width := edtStrong.Width;

  // cbComments.Width := edtDic.Width + 5;
end;

procedure TMainForm.BibleTabsDragDrop(Sender, Source: TObject; X, Y: integer);
var
  TabIndex, sourceTabIx, modIx: integer;
  ViewTabInfo: TViewTabInfo;
  dragDropPoint: TPoint;
  me: TModuleEntry;
begin
  dragDropPoint.X := X;
  dragDropPoint.Y := Y;
  TabIndex := dtsBible.ItemAtPos(dragDropPoint);
  if (TabIndex < 0) or (TabIndex >= dtsBible.Tabs.Count) then
    Exit;

  if Source is TClosableTabControl then
  begin
    try
      // TODO: fix this
      ViewTabInfo := TObject((TObject((Source as TClosableTabControl).tag) as TTabSheet).tag) as TViewTabInfo;
      if TabIndex = dtsBible.Tabs.Count - 1 then
      begin
        // drop on *** - last tab, adding new tab
        modIx := mModules.FindByFolder(ViewTabInfo.mBible.ShortPath);
        if modIx >= 0 then
        begin
          me := TModuleEntry(mModules.Items[modIx]);
          mFavorites.AddModule(me);
          AdjustBibleTabs(MainBook.ShortName);
        end;
        Exit;
      end;
      // cp:=viewTabInfo.mBible.Name;
      // replace
      modIx := mModules.FindByFolder(ViewTabInfo.mBible.ShortPath);
      if modIx < 0 then
        Exit;
      me := TModuleEntry(mModules.Items[modIx]);
      if not Assigned(me) then
        Exit;
      mFavorites.ReplaceModule
        (TModuleEntry(dtsBible.Tabs.Objects[TabIndex]), me);
      AdjustBibleTabs(MainBook.ShortName);
    except
    end;
  end
  else if Source is TDockTabSet then
  begin // move/exchange
    if (TabIndex = dtsBible.Tabs.Count) then
      Exit;

    sourceTabIx := dtsBible.tag;
    if (sourceTabIx < 0) or (sourceTabIx >= dtsBible.Tabs.Count) or
      (sourceTabIx = TabIndex) then
      Exit;

    me := TModuleEntry(dtsBible.Tabs.Objects[sourceTabIx]);

    mFavorites.moveItem(me, TabIndex);

    AdjustBibleTabs(MainBook.ShortName);
    SetFavouritesShortcuts();
  end;

end;

procedure TMainForm.BibleTabsDragOver(Sender, Source: TObject; X, Y: integer;
  state: TDragState; var Accept: Boolean);
var
  tabIx, delta: integer;
  dragOverPoint: TPoint;
begin
  dragOverPoint.X := X;
  dragOverPoint.Y := Y;
  tabIx := dtsBible.ItemAtPos(dragOverPoint);
  if Source is TDockTabSet then
    delta := 1
  else
    delta := 0;
  Accept := (tabIx >= 0) and (tabIx < dtsBible.Tabs.Count - delta);
end;

procedure TMainForm.miMemoPasteClick(Sender: TObject);
begin
  if pmMemo.PopupComponent = reMemo then
    reMemo.PasteFromClipboard
  else if pmMemo.PopupComponent is TEdit then
    (pmMemo.PopupComponent as TEdit).PasteFromClipboard
  else if pmMemo.PopupComponent is TComboBox then
  begin
    // (pmMemo.PopupComponent as TComboBox).con
    // (pmMemo.PopupComponent as TComboBox).Text :=  (pmMemo.PopupComponent as TComboBox).Text+TntClipboard.AsText;
  end;
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
    // Font.Charset := DefaultCharset;
  end;

  if FontDialog.Execute then
  begin
    // DefaultCharset := FontDialog.Font.Charset;

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
begin
  InputForm.tag := 0; // use TEdit
  InputForm.Caption := miQuickNav.Caption;
  InputForm.Font := MainForm.Font;
  with MainBook do
    if CurFromVerse > 1 then
      InputForm.edtValue.Text := ShortPassageSignature(CurBook, CurChapter,
        CurFromVerse, CurToVerse)
    else
      InputForm.edtValue.Text := ShortPassageSignature(CurBook,
        CurChapter, 1, 0);
  InputForm.edtValue.SelectAll();
  if InputForm.ShowModal = mrOk then
  begin
    edtGo.Text := InputForm.edtValue.Text;
    InputForm.edtValue.Text := '';
    btnAddressOK.Click;
    ActiveControl := bwrHtml;
  end;
end;

procedure TMainForm.miQuickSearchClick(Sender: TObject);
begin
  InputForm.tag := 0; // use TEdit
  InputForm.Caption := miQuickSearch.Caption;
  InputForm.Font := MainForm.Font;

  with MainBook do
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
begin
  if MainBook.Copyright = '' then
    ShowMessage(Copy(tbtnCopyright.Hint, 2, $FFFFFF))
  else
  begin
    if not Assigned(CopyrightForm) then
      CopyrightForm := TCopyrightForm.Create(self);
    CopyrightForm.Caption := 'Copyright (c) ' + MainBook.Copyright;
    if FileExists(MainBook.path + 'copyright.htm') then
    begin
      CopyrightForm.bwrCopyright.LoadFromFile(MainBook.path + 'copyright.htm');
      CopyrightForm.ShowModal;
    end
    else
      ShowMessage('File not found: ' + MainBook.path + 'copyright.htm');
  end;
end;

procedure TMainForm.miMemoCutClick(Sender: TObject);
begin
  if pmMemo.PopupComponent = reMemo then
    reMemo.CutToClipboard
  else if pmMemo.PopupComponent is TEdit then
    (pmMemo.PopupComponent as TEdit).CutToClipboard
  else if pmMemo.PopupComponent is TComboBox then
  begin
    Clipboard.AsText := (pmMemo.PopupComponent as TComboBox).Text;
    (pmMemo.PopupComponent as TComboBox).Text := '';
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
        pvn := vstDicList.AddChild(nil, Pointer(wordIx));
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

procedure TMainForm.miAddBookmarkClick(Sender: TObject);
var
  newstring: string;
begin
  InputForm.tag := 1; // use TMemo
  InputForm.Caption := miAddBookmark.Caption;
  InputForm.Font := MainForm.Font;
  if MainBook.verseCount() = 0 then
    MainBook.OpenChapter(MainBook.CurBook, MainBook.CurChapter);
  if MainBook.Trait[bqmtStrongs] then
    newstring := Trim(DeleteStrongNumbers(MainBook.Verses[CurVerseNumber -
      CurFromVerse]))
  else
    newstring := Trim(MainBook.Verses[CurVerseNumber - CurFromVerse]);

  StrDeleteFirstNumber(newstring);

  InputForm.memValue.Text := newstring;

  if InputForm.ShowModal = mrOk then
  begin
    with MainBook do
      newstring := ShortName + ' ' + ShortPassageSignature(CurBook, CurChapter,
        CurVerseNumber, CurVerseNumber) + ' ' + InputForm.memValue.Text;

    StrReplace(newstring, #13#10, ' ', true);

    lbBookmarks.Items.Insert(0, newstring);

    with MainBook do
      Bookmarks.Insert(0, Format('go %s %d %d %d %d $$$%s',
        [ShortPath, CurBook, CurChapter, CurVerseNumber, 0, newstring]));
  end;
end;

procedure TMainForm.miAddBookmarkTaggedClick(Sender: TObject);
var
  pn, ParentNode: PVirtualNode;
  nd: TVersesNodeData;
  F, t: integer;
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
  TagsDbEngine.AddVerseTagged(nd.getText(), MainBook.CurBook,
    MainBook.CurChapter, F, t, MainBook.ShortPath, true);

end;

procedure TMainForm.lbBookmarksDblClick(Sender: TObject);
begin
  ProcessCommand(Bookmarks[lbBookmarks.ItemIndex], hlDefault);
end;

procedure TMainForm.bwrStrongHotSpotClick(Sender: TObject; const SRC: string;
  var Handled: Boolean);
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

procedure TMainForm.lbBookmarksKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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

procedure TMainForm.lbHistoryKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i: integer;
begin
  if lbHistory.Items.Count = 0 then
    Exit;

  if Key = VK_DELETE then
  begin
    if Application.MessageBox('Удалить запись в истории?',
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

procedure TMainForm.miSearchWindowClick(Sender: TObject);
begin
  { AlekId: теперь по другому }
  { SearchToolbar.Visible := not SearchToolbar.Visible;
    miSearchWindow.Checked := SearchToolbar.Visible;
    //AlekId: не понятна логика сл. строки
    if SearchToolbar.Visible then ActiveControl := edtSearch; }
  (* AlekId:Добавлено *)
  pgcMain.ActivePageIndex := 0; // на первую вкладку
  pgcHistoryBookmarks.ActivePageIndex := 2;
  // на вкладку быстрого поиска
  ActiveControl := tedtQuickSearch;
  (* AlekId:/Добавлено *)

  if bwrHtml.SelLength <> 0 then
  begin
    tedtQuickSearch.Text := Trim(bwrHtml.SelText);
    SearchForward();
  end;
end;

procedure TMainForm.pnlFindStrongNumberMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  pnlFindStrongNumber.BevelOuter := bvNone;
end;

procedure TMainForm.pnlFindStrongNumberMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
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
begin
  if lbStrong.ItemIndex < 0 then
    Exit;

  pgcMain.ActivePage := tbSearch;
  cbSearch.Text := lbStrong.Items[lbStrong.ItemIndex];

  if MainBook.StrongsPrefixed then
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
  ti: TViewTabInfo;
  satBible: string;

begin
  //
  G_XRefVerseCmd := Trim(G_XRefVerseCmd);
  addr := G_XRefVerseCmd;
  if Length(addr) <= 0 then
    Exit;
  ti := GetActiveTabInfo();
  if Assigned(ti) then
    satBible := ti.mSatelliteName
  else
    satBible := '------';

  NewViewTab(addr, satBible, '', ti.state, '', true);
  if GetCommandType(G_XRefVerseCmd) = bqctInvalid then
  begin
    edtGo.Text := addr;
    edtGoDblClick(nil);
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
          sl.Add(mModules[i].wsFullName);
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
      lbFavourites.Items.Add(mFavorites.mModuleEntries[i].wsFullName);
    end;
    lbFavourites.Items.EndUpdate();
  end;

  if ConfigForm.ShowModal = mrCancel then
    Exit;

  moduleCount := ConfigForm.lbFavourites.Count - 1;
  mFavorites.Clear();
  // dtsBible.Tabs.Clear();
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
  // dtsBible.Tabs.Add('***');
  // favMenuItemCount := GetHotModuleCount();
  // favMenuItem := FindTaggedTopMenuItem(3333);
  // for i := 0 to moduleCount do
  // begin
  // if (i < favMenuItemCount) then
  // begin
  // GetHotMenuItem(i).Caption := ConfigForm.lbxFavourites.Items[i];
  // end
  // else
  // begin
  // mi := TMenuItem.Create(self);
  // mi.Tag := 7000 + i;
  // mi.Caption := ConfigForm.lbxFavourites.Items[i];
  // favMenuItem.Add(mi);
  // end;
  // end;
  // Inc(moduleCount);
  // Dec(favMenuItemCount);
  // for i := moduleCount to favMenuItemCount do
  // begin
  // mi := GetHotMenuItem(i);
  // favMenuItem.Remove(mi);
  // mi.Free();
  // end;
  //
  SetFavouritesShortcuts();
  AdjustBibleTabs(MainBook.ShortName);
  // InitBibleTabs();

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
begin
  if not Assigned(MyLibraryForm) then
    MyLibraryForm := TMyLibraryForm.Create(self);

  TranslateForm(MyLibraryForm);

  case useDisposition of
    udParabibles:
      begin
        ws := GetActiveTabInfo().mSatelliteName;
        wcap := Lang.SayDefault('SelectParaBible', 'Select secondary bible');
        wbtn := Lang.SayDefault('DeselectSec', 'Deselect');
        ws := SecondBook.Name;
      end;
    udMyLibrary:
      begin
        ws := MainBook.Name;
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
    tbtnSatellite.Down := GetActiveTabInfo().mSatelliteName <> '------';
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
          lbBook.ItemIndex := MyLibraryForm.mBookIx - 1;
          lbBookClick(self);
        end;
      end;
  end;
end;

procedure TMainForm.ShowQuickSearch;
begin
  if not pgcMain.Visible then
    tbtnToggle.Click;
  if pgcMain.ActivePage <> tbGo then
  begin
    pgcMain.ActivePage := tbGo;
    pgcMainChange(self);
  end;
  ToggleQuickSearchPanel(true);
  try
    FocusControl(tedtQuickSearch);
  except
  end;
  if Length(tedtQuickSearch.Text) > 0 then
    tedtQuickSearch.SelectAll();
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

procedure TMainForm.miAddMemoClick(Sender: TObject);
var
  newstring, signature: string;
  i: integer;
begin
  InputForm.tag := 1; // use TMemo
  InputForm.Caption := miAddMemo.Caption;
  InputForm.Font := MainForm.Font;

  with MainBook do
    signature := ShortName + ' ' + ShortPassageSignature(CurBook, CurChapter,
      CurVerseNumber, CurVerseNumber) + ' $$$';

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

    if not MemosOn then
      miMemosToggle.Click
    else
    begin
      miMemosToggle.Click; // off
      miMemosToggle.Click; // on - to show new memos...
    end;
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
  // if Index <> ConfigFormHotKeyChoiceItemIndex then
  // Exit;

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

procedure TMainForm.SetMemosVisible(showMemos: Boolean);
var
  ti: TViewTabInfo;
begin
  miMemosToggle.Checked := showMemos;
  tbtnMemos.Down := showMemos;

  MemosOn := showMemos;
  ti := GetActiveTabInfo();
  ti[vtisShowNotes] := showMemos;

  ProcessCommand(ti.mwsLocation, TbqHLVerseOption(ord(ti[vtisHighLightVerses])));
end;

procedure TMainForm.tbtnMemosClick(Sender: TObject);
begin
  SetMemosVisible(tbtnMemos.Down);
end;

procedure TMainForm.miMemosToggleClick(Sender: TObject);
begin
  SetMemosVisible(miMemosToggle.Checked);
end;

procedure TMainForm.btbtnHelpClick(Sender: TObject);
var
  Lines: string;
  i, cc: integer;

begin
  Lines := '<body bgcolor=#EBE8E2>';

  AddLine(Lines, '<h2>' + MainBook.Name + '</h2>');
  cc := MainBook.Categories.Count - 1;
  if cc >= 0 then
  begin
    AddLine(Lines, '<font Size=-1><b>Метки:</b><br><i>' +
      TokensToStr(MainBook.Categories, '<br>     ', false) + '</i></font><br>');
  end;

  AddLine(Lines, '<b>Location:</b> ' + Copy(MainBook.path, 1,
    Length(MainBook.path) - 1) + ' <a href="editini=' + MainBook.path +
    'bibleqt.ini">ini</a><br>');
  for i := 1 to MainBook.BookQty do
    AddLine(Lines, '<b>' + MainBook.FullNames[i] + ':</b> ' +
      MainBook.ShortNamesVars[i] + '<br>');

  AddLine(Lines, '<br><br><br>');
  if not Assigned(CopyrightForm) then
    CopyrightForm := TCopyrightForm.Create(self);
  CopyrightForm.lblModName.Caption := MainBook.Name;
  if Length(Trim(MainBook.Copyright)) = 0 then
    CopyrightForm.lblCopyRightNotice.Caption := Lang.Say('PublicDomainText')
  else
    CopyrightForm.lblCopyRightNotice.Caption := MainBook.Copyright;

  CopyrightForm.Caption := MainBook.Name;
  CopyrightForm.bwrCopyright.LoadFromString(Lines);
  CopyrightForm.ActiveControl := CopyrightForm.bwrCopyright;
  CopyrightForm.ShowModal;

end;

procedure TMainForm.JCRU_HomeClick(Sender: TObject);
var
  s: string;
begin
  s := (Sender as TMenuItem).Name;
  if s = 'JCRU_Home' then
    s := 'http://jesuschrist.ru/'
  else if s = 'miTechnoForum' then
    s := C_BQTechnoForumAddr
  else if s = 'miDownloadLatest' then
    s := C_BQQuickLoad
  else
    s := 'http://jesuschrist.ru/' + LowerCase(Copy(s, 6, Length(s))) + '/';

  if WStrMessageBox(Format(Lang.Say('GoingOnline'), [s]), 'JesusChrist.ru',
    MB_OKCancel + MB_DEFBUTTON1) <> ID_OK then
    Exit;

  ShellExecute(Application.Handle, nil, PChar(s), nil, nil, SW_NORMAL);
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

procedure TMainForm.SafeProcessCommand(wsLocation: string; hlOption: TbqHLVerseOption);
var
  succeeded: Boolean;
begin
  if Length(Trim(wsLocation)) > 1 then
  begin
    succeeded := ProcessCommand(wsLocation, hlOption);
    if succeeded then
      Exit;
  end;

  if Length(Trim(LastAddress)) > 1 then
  begin
    succeeded := ProcessCommand(LastAddress, hlOption);
    if succeeded then
      Exit;
  end;
  ProcessCommand(Format('go %s %d %d %d', [mDefaultLocation, 1, 1, 1]), hlDefault);
end;

procedure TMainForm.tbtnSatelliteClick(Sender: TObject);
var
  ti: TViewTabInfo;
  vhl: TbqHLVerseOption;
begin
  // P.X := tlbMain.Left + 15 * tlbMain.Height + 5;
  // P.Y := tlbMain.Top + tlbMain.Height * 2 + 10;
  // P := ClientToScreen(P);
  // SatelliteMenu.Popup(P.X, P.Y);
  ti := GetActiveTabInfo();
  if not Assigned(ti) then
    Exit;
  if ti.mSatelliteName <> '------' then
  begin
    ti.mSatelliteName := '------';
    if ti.mLocationType in [vtlUnspecified, vtlModule] then
    begin
      if ti[vtisHighLightVerses] then
        vhl := hlTrue
      else
        vhl := hlFalse;
      ProcessCommand(ti.mwsLocation, vhl);
    end;
    Exit;
  end;
  // if ti.mSatelliteName
  ShowQNav(udParabibles);
end;

procedure TMainForm.tbtnSatelliteMouseEnter(Sender: TObject);
var
  ti: TViewTabInfo;
begin
  if tbtnSatellite.Down then
  begin
    ti := GetActiveTabInfo();
    tbtnSatellite.Hint := ti.mSatelliteName;
  end
  else
  begin
    tbtnSatellite.Hint := Lang.SayDefault('MainForm.tbtnSatellite.Hint',
      'Choose sencodary Bible');

  end;
end;

// function TMainForm.SatelliteMenuItemFromModuleName(aName: WideString):
// TMenuItem;
// var
// i, itemIx, itemCount: integer;
// begin
// itemIx := -1;
// itemCount := SatelliteMenu.Items.Count - 1;
// for i := 0 to itemCount do
// begin
// if SatelliteMenu.Items[i].Caption = aName then
// begin
// itemIx := i;
// break;
// end;
// end;
// if itemIx >= 0 then
// Result := TMenuItem(SatelliteMenu.Items[itemIx])
// else
// Result := nil;
// end;

procedure TMainForm.SelectSatelliteBibleByName(const bibleName: string);
var
  tabInfo: TViewTabInfo;
  broserPos: integer;
begin
  { num := -1;//AlekId:исправлено было 0
    for i := 0 to SatelliteMenu.Items.Count - 1 do begin
    if SatelliteMenu.Items[i] = Sender then num := i - 1;
    SatelliteMenu.Items[i].Checked := false;
    end;
    satMenuItem:=TMenuItem( SatelliteMenu.Items[num + 1]);
    satMenuItem.Checked := true; }

  try
    tabInfo := GetActiveTabInfo();
    tabInfo.mSatelliteName := bibleName;
    if tabInfo.mBible.isBible then
    begin
      broserPos := bwrHtml.Position;
      ProcessCommand(tabInfo.mwsLocation, TbqHLVerseOption(ord(tabInfo[vtisHighLightVerses])));
      bwrHtml.Position := broserPos;
    end
    else
    begin
      try
        LoadSecondBookByName(bibleName);
      except
        on E: Exception do
          BqShowException(E);
      end;

    end; // else
    // перегрузить
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

    // for i := 0 to DicLB.Items.Count - 1 do
    // begin
    // if WideLowerCase(Copy(DicLB.Items[i], 1, len))
    // = WideLowerCase(edtDic.Text) then
    // begin
    // DicLB.ItemIndex := i;
    // //DicLBClick(Sender);
    // Exit;
    // end;
    // end;
  end;
  // DicLB.ItemIndex := 0;

end;

constructor TViewTabBrowserState.Create;
begin
  SelStart := -1;
  SelLenght := -1;
  HScrollPos := -1;
  VScrollPos := -1;
end;
{ TrecMainViewTabInfo }

constructor TViewTabInfo.Create(
  const Bible: TBible; const awsLocation: string;
  const satelliteBibleName: string; const Title: string;
  const state: TViewtabInfoState);
begin
  Init(Bible, awsLocation, satelliteBibleName, Title, state);

end;

procedure TViewTabInfo.SaveBrowserState(const aHtmlViewer: THTMLViewer);
begin
  mBrowserState.SelStart := aHtmlViewer.SelStart;
  mBrowserState.SelLenght := aHtmlViewer.SelLength;
  mBrowserState.HScrollPos := aHtmlViewer.HScrollBarPosition;
  mBrowserState.VScrollPos := aHtmlViewer.VScrollBarPosition;
end;

procedure TViewTabInfo.RestoreBrowserState(const aHtmlViewer: THTMLViewer);
begin
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

function TViewTabInfo.getStateEntryStatus(stateEntry
  : TViewtabInfoStateEntries): Boolean;
begin
  Result := stateEntry in mState;
end;

procedure TViewTabInfo.Init(const Bible: TBible;
  const awsLocation: string; const satelliteBibleName: string;
  const Title: string; const state: TViewtabInfoState);
begin
  mBrowserState := TViewTabBrowserState.Create;
  mBible := Bible;
  mwsLocation := awsLocation;
  mSatelliteName := satelliteBibleName;
  mState := state;
  mLocationType := vtlUnspecified;
  mLastVisiblePara := -1;
  mwsTitle := Title;
  mIsCompareTranslation := false;
  mCompareTranslationText := '';
end;

procedure TViewTabInfo.SetState(const state: TViewtabInfoState);
begin
  mState := state;
end;

procedure TViewTabInfo.setStateEntry(stateEntry: TViewtabInfoStateEntries; value: Boolean);
begin
  if value then
    Include(mState, stateEntry)
  else
    Exclude(mState, stateEntry);
end;

{ TViewTabDragObject }

constructor TViewTabDragObject.Create(aViewTabInfo: TViewTabInfo);
begin
  inherited Create();
  mViewTabInfo := aViewTabInfo;
end;

{ TArchivedModules }

procedure TArchivedModules.Assign(Source: TArchivedModules);
var
  cnt, i: integer;
begin
  inherited;
  cnt := Names.Count - 1;
  Clear();
  for i := 0 to cnt do
  begin
    Names.Add(Source.Names[i]);
    Paths.Add(Source.Paths[i]);
  end;
end;

procedure TArchivedModules.Clear();
begin
  Names.Clear();
  Paths.Clear();
end;

constructor TArchivedModules.Create;
begin
  Names := TStringList.Create();
  Paths := TStringList.Create();
end;

destructor TArchivedModules.Destroy;
begin
  Names.Free();
  Paths.Free();
  inherited;
end;

procedure TMainForm.ReCalculateTagTree;
begin
  if (not Assigned(tbList)) or (not tbList.Visible) or
    (not Assigned(TagsDbEngine)) or (not Assigned(TagsDbEngine.fdTagsConnection))
  then
    Exit;
  if (not tbList.Visible) or (not TagsDbEngine.fdTagsConnection.Connected) then
    Exit;

  // VerseNodesEraseCachedText();
  GfxRenderers.TbqTagsRenderer.InvalidateRenderers();
  vdtTagsVerses.Invalidate();
  vdtTagsVerses.ReinitNode(vdtTagsVerses.RootNode, true);

  if pgcMain.ActivePage = tbList then
  begin
    // vdtTagsVerses.Repaint();
  end;

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
    // miOpenNewView.Visible := pgcMain.ActivePage = tbXRef;
    G_XRefVerseCmd := Get_AHREF_VerseCommand(bwrXRef.DocumentSource,
      bwrXRef.SectionList.FindSourcePos(bwrXRef.RightMouseClickPos));
  end
  else if (pgcMain.ActivePage = tbSearch) then
  begin
    miOpenNewView.Visible := true;
    G_XRefVerseCmd := Get_AHREF_VerseCommand(bwrSearch.DocumentSource,
      bwrSearch.SectionList.FindSourcePos(bwrSearch.RightMouseClickPos));
  end
  else if (pgcMain.ActivePage = tbDic) then
  begin
    miOpenNewView.Visible := true;
    G_XRefVerseCmd := Get_AHREF_VerseCommand(bwrDic.DocumentSource,
      bwrDic.SectionList.FindSourcePos(bwrDic.RightMouseClickPos));
  end
  else
    miOpenNewView.Visible := false;
end;

function TMainForm.ReplaceHotModule(const oldMe, newMe: TModuleEntry): Boolean;
var
  hotMi: TMenuItem;
  ix: integer;
begin
  // favMi:=FindTaggedTopMenuItem(3333);
  Result := true;
  hotMi := FavouriteItemFromModEntry(oldMe);
  if Assigned(hotMi) then
  begin
    hotMi.Caption := newMe.wsFullName;
    hotMi.tag := integer(newMe);
  end;
  ix := FavouriteTabFromModEntry(oldMe);
  if ix >= 0 then
  begin
    dtsBible.Tabs[ix] := newMe.VisualSignature();
    dtsBible.Tabs.Objects[ix] := newMe;
  end;

end;

{ TBQFavoriteModules }

function TBQFavoriteModules.AddModule(me: TModuleEntry): Boolean;
var
  foundIx: integer;
  newMod: TModuleEntry;
begin
  Result := false;
  foundIx := mModuleEntries.FindByFolder(me.wsShortPath);
  if foundIx >= 0 then
    Exit;
  newMod := TModuleEntry.Create(me);
  mModuleEntries.Add(newMod);
  mfnAddtoIface(newMod, integer(newMod), true);
  Result := true;
end;

function TBQFavoriteModules.DeleteModule(me: TModuleEntry): Boolean;
var
  foundIx: integer;
begin
  Result := false;
  foundIx := mModuleEntries.IndexOf(me);
  if foundIx < 0 then
    Exit;
  mfnDelFromIface(me);
  mModuleEntries.Delete(foundIx);
end;

procedure TBQFavoriteModules.Clear;
var
  i, C: integer;
begin
  C := mModuleEntries.Count - 1;
  try
    for i := 0 to C do
      mfnDelFromIface(TModuleEntry(mModuleEntries.Items[i]));
  except
    on E: Exception do
      BqShowException(E)
  end;
  mModuleEntries.Clear();
end;

constructor TBQFavoriteModules.Create(fnAddToIface: TfnFavouriveAdd;
  fnDelFromIFace: TfnFavouriveDelete; fnReplaceInIface: TfnFavouriveReplace;
  fnInsertIface: TfnFavouriteInsert; forceLoadModules: TfnForceLoadModules);
begin
  mfnAddtoIface := fnAddToIface;
  mfnDelFromIface := fnDelFromIFace;
  mfnReplaceInIFace := fnReplaceInIface;
  mfnInsertIface := fnInsertIface;
  mModuleEntries := TCachedModules.Create(true);
  mfnForceLoadMods := forceLoadModules;
end;

destructor TBQFavoriteModules.Destroy;
begin
  try
    FreeAndNil(mModuleEntries);
    FreeAndNil(mLst);
  except
    on E: Exception do
      BqShowException(E);
  end;
  inherited;
end;

procedure TBQFavoriteModules.LoadModules(modEntries: TCachedModules;
  const modulePath: string);
var
  vrs: integer;
  doload: Boolean;
begin
  if not Assigned(mLst) then
  begin
    mLst := TStringList.Create();
    doload := true
  end
  else
    doload := false;
  try
    Clear();
    if doload then
    begin
      mExpectedCnt := 0;
      mLst.LoadFromFile(modulePath);
    end;
    if mLst.Count <= 0 then
      Exit;
    vrs := ReadPrefix(mLst);
    if vrs = 2 then
      v2Load(modEntries, mLst)
    else
    begin
      v1Load(modEntries, mLst);
    end;

  except
    on E: Exception do
    begin
      BqShowException(E);
    end;
  end;

end;

function TBQFavoriteModules.moveItem(me: TModuleEntry; ix: integer): Boolean;
var
  si: integer;
begin
  Result := false;
  try
    si := mModuleEntries.IndexOf(me);
    if si < 0 then
      Exit;
    mModuleEntries.Move(si, ix);
    // if ix>=si then Dec(ix);
    // mModuleEntries.Items[si]:=nil;
    // mModuleEntries.Delete(si);
    // mModuleEntries.Insert(ix, me);

    mfnDelFromIface(me);
    mfnInsertIface(me, ix);
  except
    on E: Exception do
      BqShowException(E);
  end;
end;

function TBQFavoriteModules.ReadPrefix(const lst: TStringList): integer;
var
  ws: string;
begin
  ws := lst[0];
  if (ws <> 'v2.0') or (lst.Count < 2) then
  begin
    Result := 0;
    mExpectedCnt := 0;
  end
  else
  begin
    mExpectedCnt := StrToIntDef(lst[1], 0);
    Result := 2;
  end;
end;

function TBQFavoriteModules.ReplaceModule(oldMe, newMe: TModuleEntry): Boolean;
var
  ix: integer;
begin
  ix := mModuleEntries.IndexOf(oldMe);
  if ix < 0 then
  begin
    Result := false;
    Exit
  end;
  mfnReplaceInIFace(oldMe, newMe);
  mModuleEntries.Items[ix] := newMe;
  Result := true;
end;

procedure TBQFavoriteModules.SaveModules(const savePath: string);
var
  i, C: integer;
  me: TModuleEntry;
  lst: TStringList;
begin
  C := mModuleEntries.Count - 1;
  lst := TStringList.Create;
  try
    lst.Add('v2.0');
    lst.Add(IntToStr(C));

    for i := 0 to C do
    begin
      try

        me := TModuleEntry(mModuleEntries.Items[i]);
        lst.Add('***');
        lst.Add(me.wsFullName);
        lst.Add(me.wsShortName);
      except
        on E: Exception do
          BqShowException(E);
      end;

    end;
  except
  end;
  lst.SaveToFile(savePath, TEncoding.UTF8);
  lst.Free();
end;

procedure TBQFavoriteModules.v1Load(modEntries: TCachedModules;
  const lst: TStringList);
var
  i, C: integer;
  wsModName, wsModShortName: string;
  me: TModuleEntry;
begin
  C := lst.Count - 1;
  for i := 0 to C do
  begin
    try
      me := modEntries.ResolveModuleByNames(lst[i], '');
      if not Assigned(me) then
      begin
        ShowMessageFmt('Can''t resolve favourite module:'#13#10' %s(%s)',
          [wsModName, wsModShortName]);
      end
      else
        AddModule(me);
    except
      on E: Exception do
      begin
        BqShowException(E, 'lst[i]=' + lst[i]);
      end;
    end;
  end;
end;

procedure TBQFavoriteModules.v2Load(modEntries: TCachedModules;
  const lst: TStringList);
var
  i, C, prevI: integer;
  wsModName, wsModShortName: string;
  me: TModuleEntry;
  modsLoaded: Boolean;
begin
  C := lst.Count - 1;
  i := 3;
  modsLoaded := false;
  while i <= C do
  begin
    wsModName := lst[i];
    prevI := i;
    inc(i);
    if (i <= C) then
    begin
      wsModShortName := lst[i];
      inc(i);
    end
    else
      wsModShortName := '';
    if wsModShortName = '***' then
    begin
      wsModShortName := '';
    end;
    try
      me := modEntries.ResolveModuleByNames(wsModName, wsModShortName);

      if not Assigned(me) then
      begin
        if not modsLoaded then
        begin
          mfnForceLoadMods();
          i := prevI;
          modsLoaded := true;
          continue
        end
        else
          ShowMessageFmt('Can''t resolve favourite module:'#13#10' %s(%s)',
            [wsModName, wsModShortName]);
      end
      else
        AddModule(me);

      if (i <= C) and (lst[i] <> '***') then
        repeat
          inc(i);
        until (i > C) or (lst[i] = '***');

      inc(i);
      if i > C then
        break;
    except
      on E: Exception do
      begin
        BqShowException(E, 'wsModName=' + wsModName);
      end;
    end;
  end; // line iteration loop

end;

procedure TBQFavoriteModules.xChg(me1, me2: TModuleEntry);
begin
  mfnReplaceInIFace(me2, me1);
  mfnReplaceInIFace(me1, me2);

  mModuleEntries.Exchange(mModuleEntries.IndexOf(me1),
    mModuleEntries.IndexOf(me2));
end;

end.
