{***********************************************

  BibleQuote 6.01

***********************************************}

unit main;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, Classes, WideStrUtils, WideStrings,
  ShlObj, contnrs, mousePan,
  Graphics, Controls,
  Forms, TntForms,
  ComCtrls, TntComCtrls,
  TntStdCtrls,
  Menus, TntMenus,
  ExtCtrls, TntExtCtrls,
  TntFileCtrl,
  Clipbrd, TntClipbrd,
  Buttons, TntButtons,
  MetaFilePrinter,
  ImgList, ShellAPI, CoolTrayIcon, Dialogs, TntDialogs, AlekPageControl,
  ToolWin, StdCtrls, Htmlview, Tabs, DockTabSet,
  links_parser, string_procs, MultiLanguage, Bible,
  Dict, SysHot, WCharWindows, WCharReader, AppEvnts, VirtualTrees, VersesDb,
  Grids, DBGrids, TntDBGrids, DB, SysUtils, BibleQuoteUtils, qNavTest,
  bqLinksParserIntf {VirtualTrees};

const
  ConstBuildCode: WideString = '2009.08.26';
  //  ConstBuildCode: WideString = '2005.03.25';
  ConstBuildTitle: WideString = 'BibleQuote 6.0.1b4';
  //  ConstBuildTitle: WideString = 'BibleQuote 5.5';
  //  ConstBuildTitle: WideString = 'BibleQuote 4.5 A Bible Research Software ';

const

  ZOOMFACTOR = 1.5;
  MAXHISTORY = 1000;
  {
    такие увеличенные размеры позволяют сохранять ПРОПОРЦИИ окна
    координаты окна программы вычисляются в относительных единицах
  }
  MAXWIDTH = 25600;                     // 25600 делится на 640, 800 и 1024
  MAXHEIGHT = 218400;                   // делится на 480, 600 и 728

  bsText = 0;
  bsFile = 1;
  bsBookmark = 2;
  bsMemo = 3;
  bsHistory = 4;
  bsSearch = 5;

  Skips20 =
    '<A NAME="#endofchapterNMFHJAHSTDGF123">' +
    '<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>' +
    '<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>';

  //  Skips20 = '<BR>';

  DefaultTextTemplate = '<h1>%HEAD%</h1>' + #13#10#13#10
    + '<font size=+1>' + #13#10 + '%TEXT%' + #13#10 + '</font>' + #13#10#13#10
    + Skips20;

  DefaultSelTextColor = '#FF0000';

type
  TXRef = record
    B, C, V, RB, RC, RV: byte;
  end;

  (*AlekId:Добавлено*)
type
  TViewTabInfo = class
  protected
    mHtmlViewer: THTMLViewer;
    mwsLocation, mwsTitleLocation, mwsTitleFont, mwsCopyrightNotice: WideString;
    //mBookIx, mChapterIx:integer;
    mBible, mSecondBible: TBible;
    mSatelliteName: WideString;
    mShowStrongs, mShowNotes, mResolvelinks: boolean;
    mReloadNeeded: boolean;
    mFirstVisiblePara, mLastVisiblePara:integer;
    mHLVerses:boolean;
  public
    property ReloadNeeded: boolean read mReloadNeeded write mReloadNeeded;
    property FirstVisiblePara:integer read mFirstVisiblePara;
    constructor Create(const aHtmlViewer: THTMLViewer; const bible: TBible;
      const awsLocation: WideString; const satelliteBibleName: WideString;
      showStrongs, showNotes, resolveLinks: boolean);
    procedure Init(const aHtmlViewer: THTMLViewer;
      const bible: TBible; const awsLocation: WideString; const satelliteBibleName:
      WideString; showStrongs, showNotes, resolveLinks: boolean);
  end;

  TfnFavouriveAdd = function(const modEntry: TModuleEntry; tag: integer = -1;
    addBibleTab: boolean = true): integer of object;
  TfnFavouriveDelete = function(const modEntry: TModuleEntry): boolean of object;
  TfnFavouriveReplace = function(const oldMod, newMod: TModuleEntry): boolean of object;
  TfnFavouriteInsert = function(newMe: TModuleEntry; ix: integer): integer of object;
  TfnForceLoadModules = procedure of object;

  TBQFavoriteModules = class
    mModuleEntries: TCachedModules;
    mExpectedCnt: integer;
    mLst: TWideStringList;
    mfnAddtoIface: TfnFavouriveAdd;
    mfnDelFromIface: TfnFavouriveDelete;
    mfnReplaceInIFace: TfnFavouriveReplace;
    mfnInsertIface: TfnFavouriteInsert;
    mfnForceLoadMods: TfnForceLoadModules;
    procedure SaveModules(const savePath: WideString);
    procedure LoadModules(modEntries: TCachedModules; const modulePath: WideString);
    procedure v2Load(modEntries: TCachedModules; const lst: TWideStringList);
    procedure v1Load(modEntries: TCachedModules; const lst: TWideStringList);
    function ReadPrefix(const lst: TWideStringList): integer;
    constructor Create(fnAddToIface: TfnFavouriveAdd; fnDelFromIFace: TfnFavouriveDelete;
      fnReplaceInIface: TfnFavouriveReplace; fnInsertIface: TfnFavouriteInsert;
      forceLoadModules: TfnForceLoadModules);
    destructor Destroy(); override;
    function AddModule(me: TModuleEntry): boolean;
    function DeleteModule(me: TModuleEntry): boolean;
    function Clear(): boolean;
    function ReplaceModule(oldMe, newMe: TModuleEntry): boolean;
    function xChg(me1, me2: TModuleEntry): boolean;
    function moveItem(me: TModuleEntry; ix: integer): boolean;

  end;

  TViewTabDragObject = class(TDragObjectEx)
  protected
    mViewTabInfo: TViewTabInfo;
  public
    constructor Create(aViewTabInfo: TViewTabInfo);
    property ViewTabInfo: TViewTabInfo read mViewTabInfo;
  end;
  TbqNavigateResult = (nrSuccess, nrEndVerseErr, nrStartVerseErr, nrChapterErr, nrBookErr, nrModuleFail);
  (*AlekId:/Добавлено*)
type
  TMainForm = class(TTntForm)
    OpenDialog1: TTntOpenDialog;
    SaveFileDialog: TTntSaveDialog;
    MainPanel: TTntPanel;
    BrowserPopupMenu: TTntPopupMenu;
    PrintDialog1: TPrintDialog;
    miCopySelection: TTntMenuItem;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    miCopyVerse: TTntMenuItem;
    Label4: TTntLabel;
    miCopyPassage: TTntMenuItem;
    PreviewBox: TTntScrollBox;
    ContainPanel: TTntPanel;
    PagePanel: TTntPanel;
    PB1: TTntPaintBox;
    N3: TTntMenuItem;
    miSearchWord: TTntMenuItem;
    miCompare: TTntMenuItem;
    MainPages: TTntPageControl;
    SearchTab: TTntTabSheet;
    SearchBrowser: THTMLViewer;
    DicTab: TTntTabSheet;
    StrongTab: TTntTabSheet;
    DicBrowser: THTMLViewer;
    StrongBrowser: THTMLViewer;
    CommentsTab: TTntTabSheet;
    CommentsBrowser: THTMLViewer;
    DicPanel: TTntPanel;
    StrongPanel: TTntPanel;
    StrongEdit: TTntEdit;
    StrongLB: TTntListBox;
    SearchBoxPanel: TTntPanel;
    SearchCB: TTntComboBox;
    CBList: TTntComboBox;
    FindButton: TTntButton;
    GoTab: TTntTabSheet;
    Panel2: TTntPanel;
    GoEdit: TTntEdit;
    CBAll: TTntCheckBox;
    CBPhrase: TTntCheckBox;
    CBParts: TTntCheckBox;
    CBCase: TTntCheckBox;
    CBExactPhrase: TTntCheckBox;
    XRefTab: TTntTabSheet;
    XRefBrowser: THTMLViewer;
    RefPopupMenu: TTntPopupMenu;
    miRefCopy: TTntMenuItem;
    miRefPrint: TTntMenuItem;
    CBQty: TTntComboBox;
    MemoTab: TTntTabSheet;
    TREMemo: TTntRichEdit;
    MemoPopupMenu: TTntPopupMenu;
    miMemoCopy: TTntMenuItem;
    Panel4: TTntPanel;
    BooksCB: TTntComboBox;
    CommentsCB: TTntComboBox;
    SearchOptionsButton: TTntButton;
    Panel3: TTntPanel;
    MemoLabel: TTntLabel;
    HistoryPopupMenu: TTntPopupMenu;
    Splitter1: TTntSplitter;
    BookLB: TTntListBox;
    ChapterLB: TTntListBox;
    AddressOKButton: TTntButton;
    miMemoPaste: TTntMenuItem;
    HistoryBookmarkPages: TTntPageControl;
    HistoryTab: TTntTabSheet;
    BookmarksTab: TTntTabSheet;
    HistoryLB: TTntListBox;
    EmptyPopupMenu: TTntPopupMenu;
    miMemoCut: TTntMenuItem;
    DicFilterCB: TTntComboBox;
    DicCBPanel: TTntPanel;
    DicCB: TTntComboBox;
    DicFoundSeveral: TTntLabel;
    BookmarksLB: TTntListBox;
    N2: TTntMenuItem;
    miAddBookmark: TTntMenuItem;
    BookmarkPanel: TTntPanel;
    BookmarkLabel: TTntLabel;
    miSearchWindow: TTntMenuItem;
    FindStrongNumberPanel: TTntPanel;
    miAddMemo: TTntMenuItem;
    N4: TTntMenuItem;
    miMemosToggle: TTntMenuItem;
    TrayIcon: TCoolTrayIcon;
    HelperButton: TTntButton;
    Splitter2: TTntSplitter;
    DicEdit: TTntComboBox;
    theMainMenu: TTntMainMenu;
    miFile: TTntMenuItem;
    miActions: TTntMenuItem;
    miFavorites: TTntMenuItem;
    miHelpMenu: TTntMenuItem;
    miLanguage: TTntMenuItem;
    miWebSites: TTntMenuItem;
    miPrint: TTntMenuItem;
    miPrintPreview: TTntMenuItem;
    miSave: TTntMenuItem;
    miOpen: TTntMenuItem;
    N11: TTntMenuItem;
    miOptions: TTntMenuItem;
    miFonts: TTntMenuItem;
    miColors: TTntMenuItem;
    N15: TTntMenuItem;
    miExit: TTntMenuItem;
    miFontConfig: TTntMenuItem;
    miRefFontConfig: TTntMenuItem;
    miDialogFontConfig: TTntMenuItem;
    miBGConfig: TTntMenuItem;
    miHrefConfig: TTntMenuItem;
    miFoundTextConfig: TTntMenuItem;
    miToggle: TTntMenuItem;
    miOpenPassage: TTntMenuItem;
    miQuickNav: TTntMenuItem;
    miSearch: TTntMenuItem;
    miQuickSearch: TTntMenuItem;
    miDic: TTntMenuItem;
    miStrong: TTntMenuItem;
    miComments: TTntMenuItem;
    miXref: TTntMenuItem;
    miNotepad: TTntMenuItem;
    N19: TTntMenuItem;
    miCopy: TTntMenuItem;
    miCopyOptions: TTntMenuItem;
    N22: TTntMenuItem;
    miSound: TTntMenuItem;
    miHotKey: TTntMenuItem;
 //   s: TTntMenuItem;
    miHelp: TTntMenuItem;
    miAbout: TTntMenuItem;
    JCRU_Home: TTntMenuItem;
    theImageList: TImageList;
    TntToolBar1: TTntToolBar;
    MemoOpen: TTntToolButton;
    MemoSave: TTntToolButton;
    MemoPrint: TTntToolButton;
    Sep21: TTntToolButton;
    MemoFont: TTntToolButton;
    Sep22: TTntToolButton;
    MemoBold: TTntToolButton;
    MemoItalic: TTntToolButton;
    MemoUnderline: TTntToolButton;
    Sep23: TTntToolButton;
    MemoPainter: TTntToolButton;
    ToolbarPanel: TAlekPanel;
    MainToolbar: TTntToolBar;
    ToggleButton: TTntToolButton;
    Sep01: TTntToolButton;
    BackButton: TTntToolButton;
    ForwardButton: TTntToolButton;
    Sep02: TTntToolButton;
    PrevChapterButton: TTntToolButton;
    NextChapterButton: TTntToolButton;
    Sep03: TTntToolButton;
    CopyButton: TTntToolButton;
    StrongNumbersButton: TTntToolButton;
    MemosButton: TTntToolButton;
    Sep04: TTntToolButton;
    PreviewButton: TTntToolButton;
    PrintButton: TTntToolButton;
    Sep05: TTntToolButton;
    SoundButton: TTntToolButton;
    CopyrightButton: TTntToolButton;
    SatelliteButton: TTntToolButton;
    NewTabButton: TTntToolButton;
    CloseTabButton: TTntToolButton;
    N1: TTntMenuItem;
    miNewTab: TTntMenuItem;
    miCloseTab: TTntMenuItem;
    mViewTabsPopup: TTntPopupMenu;
    miNewViewTab: TTntMenuItem;
    miCloseViewTab: TTntMenuItem;
    tbbMainPanelLastSeparator: TTntToolButton;
    tbQuickSearch: TTntTabSheet;
    SearchInWindowLabel: TTntLabel;
    SearchLabel: TTntLabel;
    QuickSearchPanel: TTntPanel;
    btnQuickSearchBack: TTntBitBtn;
    SearchEdit: TTntEdit;
    btnQuickSearchFwd: TTntBitBtn;
    LinksCB: TTntComboBox;
    mViewTabs: TAlekPageControl;
    mInitialViewPage: TTntTabSheet;
    FirstBrowser: THTMLViewer;
    miDeteleBibleTab: TTntMenuItem;
    tbLinksToolBar: TTntToolBar;
    lbTitleLabel: TTntLabel;
    lbCopyRightNotice: TTntLabel;
    miTechnoForum: TTntMenuItem;
    miOpenNewView: TTntMenuItem;
    miChooseSatelliteBible: TTntMenuItem;
    BQAppEvents: TApplicationEvents;
    tbList: TTntTabSheet;
    miAddBookmarkTagged: TTntMenuItem;
    miDownloadLatest: TTntMenuItem;
    tbtnLib: TTntToolButton;
    btmPaint: TPanel;
    mBibleTabsEx: TDockTabSet;
    imgLoadProgress: TTntImage;
    TRE: TTntRichEdit;
    TntToolBar2: TTntToolBar;
    tbtnAddNode: TTntToolButton;
    tbtnDelNode: TTntToolButton;
    vstBookMarkList: TVirtualDrawTree;
    vstDicList: TVirtualStringTree;
    miRecognizeBibleLinks: TTntMenuItem;
    tbtnResolveLinks: TTntToolButton;
    miCloseAllOtherTabs: TTntMenuItem;
    tmrCommonTimer: TTimer;
    miVerseHLBkgndCl: TTntMenuItem;

    procedure BibleTabsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure BibleTabsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure FirstBrowserHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure AddressOKButtonClick(Sender: TObject);
    procedure ChapterComboBoxKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure HistoryButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OpenButtonClick(Sender: TObject);
    procedure SearchButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure GoEditKeyPress(Sender: TObject; var Key: Char);
    procedure FindButtonClick(Sender: TObject);
    procedure MainBookSearchComplete(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GoEditDblClick(Sender: TObject);
    procedure GoEditChange(Sender: TObject);
    procedure ChapterComboBoxChange(Sender: TObject);
    procedure FirstBrowserKeyPress(Sender: TObject; var Key: Char);
    procedure miExitClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FirstBrowserKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miFontConfigClick(Sender: TObject);
    procedure miBGConfigClick(Sender: TObject);
    procedure miHrefConfigClick(Sender: TObject);
    procedure miFoundTextConfigClick(Sender: TObject);
    procedure miCopyVerseClick(Sender: TObject);
    procedure BrowserPopupMenuPopup(Sender: TObject);

    procedure miXrefClick(Sender: TObject);
    procedure SoundButtonClick(Sender: TObject);
    procedure miHotkeyClick(Sender: TObject);
    //    procedure miAddPassageBookmarkClick(Sender: TObject);
    procedure miDialogFontConfigClick(Sender: TObject);
    procedure miCopyPassageClick(Sender: TObject);

    procedure PreviewButtonClick(Sender: TObject);
    procedure PreviewBoxResize(Sender: TObject);
    procedure PB1Paint(Sender: TObject);
    procedure PB1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    {
        procedure BrowserPrintHeader(Sender: TObject; Canvas: TCanvas; NumPage,
          W, H: Integer; var StopPrinting: Boolean);
        procedure BrowserPrintFooter(Sender: TObject; Canvas: TCanvas; NumPage,
          W, H: Integer; var StopPrinting: Boolean);
    }
    procedure MainBookVerseFound(Sender: TObject; NumVersesFound, book,
      chapter, verse: Integer; s: WideString);
    procedure MainBookChangeModule(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FirstBrowserMouseDouble(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FirstBrowserKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    //    procedure BookmarkLBKeyDown(Sender: TObject; var Key: Word;
    //      Shift: TShiftState);
    procedure miPrintPreviewClick(Sender: TObject);
    procedure HistoryLBDblClick(Sender: TObject);
    procedure miStrongClick(Sender: TObject);

    procedure SearchBrowserHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure miSearchWordClick(Sender: TObject);

    procedure miCompareClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LinksCBChange(Sender: TObject);
    procedure DicBrowserHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure CommentsBrowserHotSpotClick(Sender: TObject;
      const SRC: string; var Handled: Boolean);
    procedure StrongBrowserMouseDouble(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DicLBDblClick(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure DicEditKeyPress(Sender: TObject; var Key: Char);
    procedure StrongEditKeyPress(Sender: TObject; var Key: Char);
    procedure ToggleButtonClick(Sender: TObject);
    procedure BooksCBChange(Sender: TObject);
    procedure StrongLBDblClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure SearchBrowserKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchBrowserKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DicEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BackButtonClick(Sender: TObject);
    procedure ForwardButtonClick(Sender: TObject);
    procedure DicLBKeyPress(Sender: TObject; var Key: Char);
    procedure DicBrowserMouseDouble(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure XRefBrowserHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    //    procedure BrowserMouseUp(Sender: TObject; Button: TMouseButton;
    //      Shift: TShiftState; X, Y: Integer);
    procedure miRefPrintClick(Sender: TObject);
    procedure miRefCopyClick(Sender: TObject);
    procedure MemoOpenClick(Sender: TObject);
    procedure MemoSaveClick(Sender: TObject);
    procedure MemoBoldClick(Sender: TObject);
    procedure MemoItalicClick(Sender: TObject);
    procedure MemoUnderlineClick(Sender: TObject);
    procedure MemoFontClick(Sender: TObject);
    procedure TREMemoChange(Sender: TObject);
    procedure MemoPainterClick(Sender: TObject);
    procedure miMemoCopyClick(Sender: TObject);
    procedure miNotepadClick(Sender: TObject);
    procedure CommentsCBChange(Sender: TObject);
    procedure miHelpClick(Sender: TObject);
    procedure SearchOptionsButtonClick(Sender: TObject);
    procedure CBExactPhraseClick(Sender: TObject);
    procedure DicCBChange(Sender: TObject);
    procedure HistoryLBClick(Sender: TObject);
    procedure NextChapterButtonClick(Sender: TObject);
    procedure PrevChapterButtonClick(Sender: TObject);
    procedure MainPagesChange(Sender: TObject);
//    procedure XrefBrowserMainHotSpotClick(Sender: TObject;
//      const SRC: string; var Handled: Boolean);
    procedure miDicClick(Sender: TObject);
    procedure miCommentsClick(Sender: TObject);
    procedure BookLBClick(Sender: TObject);
    procedure ChapterLBClick(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure miMemoPasteClick(Sender: TObject);
    procedure CBQtyChange(Sender: TObject);
    procedure miRefFontConfigClick(Sender: TObject);
    procedure miQuickNavClick(Sender: TObject);
    procedure miQuickSearchClick(Sender: TObject);
    procedure CopyrightButtonClick(Sender: TObject);
    procedure miMemoCutClick(Sender: TObject);
    procedure DicFilterCBChange(Sender: TObject);
    procedure miAddBookmarkClick(Sender: TObject);
    procedure BookmarksLBDblClick(Sender: TObject);
    procedure StrongBrowserHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure BookmarksLBClick(Sender: TObject);
    procedure BookmarksLBKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HistoryLBKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchBackwardClick(Sender: TObject);
    procedure btnQuickSearchFwdClick(Sender: TObject);
    procedure miSearchWindowClick(Sender: TObject);
    procedure FindStrongNumberPanelMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FindStrongNumberPanelMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FindStrongNumberPanelClick(Sender: TObject);
    procedure miCopyOptionsClick(Sender: TObject);
    procedure miOptionsClick(Sender: TObject);
    procedure miAddMemoClick(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure SysHotKeyHotKey(Sender: TObject; Index: Integer);
    procedure miMemosToggleClick(Sender: TObject);
    procedure HelperButtonClick(Sender: TObject);
    procedure JCRU_HomeClick(Sender: TObject);
    procedure MemoPrintClick(Sender: TObject);
    procedure Splitter2Moved(Sender: TObject);
    procedure SatelliteButtonClick(Sender: TObject);
    procedure SelectSatelliteBibleByName(const bibleName: WideString);
    procedure DicEditChange(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miNewTabClick(Sender: TObject);
    procedure miCloseTabClick(Sender: TObject);
    procedure mViewTabsChange(Sender: TObject);
    procedure mInitialViewPageContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure SearchEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mViewTabsStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure mViewTabsDeleteTab(sender: TAlekPageControl; index: Integer);
    procedure mViewTabsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mBibleTabsExDrawTab(Sender: TObject; TabCanvas: TCanvas; R: TRect;
      Index: Integer; Selected: Boolean);
    procedure mBibleTabsExChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure mBibleTabsExMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miDeteleBibleTabClick(Sender: TObject);

    procedure mBibleTabsExMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mBibleTabsExMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TntFormDeactivate(Sender: TObject);
    procedure FirstBrowserFileBrowse(Sender, Obj: TObject; var S: string);
    procedure FirstBrowserImageRequest(Sender: TObject; const SRC: string;
      var Stream: TMemoryStream);
    procedure BooksCBCloseUp(Sender: TObject);
    procedure TntFormActivate(Sender: TObject);
    procedure CommentsCBCloseUp(Sender: TObject);
    procedure FirstBrowserHotSpotCovered(Sender: TObject; const SRC: string);
    procedure FirstBrowserMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure LoadFontFromFolder(awsFolder: WideString);
    procedure miOpenNewViewClick(Sender: TObject);
    procedure RefPopupMenuPopup(Sender: TObject);
    procedure miChooseSatelliteBibleClick(Sender: TObject);
    procedure FirstBrowserMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BQAppEventsException(Sender: TObject; E: Exception);
    procedure BooksCBKeyPress(Sender: TObject; var Key: Char);
    procedure InitQNavList();
    procedure miAddBookmarkTaggedClick(Sender: TObject);
    procedure tbtnLibClick(Sender: TObject);
    function NavigateToInterfaceValues(): boolean;
    procedure MainPagesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mViewTabsChanging(Sender: TObject; var AllowChange: Boolean);
    procedure tbtnAddNodeClick(Sender: TObject);
    procedure vstBookMarkListMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    function PaintTokens(canv: TCanvas; rct: TRect;
      tkns: TObjectList; calc: boolean): integer;
    procedure vstBookMarkListDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure mViewTabsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure vstDicListGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    function LoadAnchor(wb: THTMLViewer; src, current, loc: WideString): boolean;
    procedure TntFormDblClick(Sender: TObject);
    procedure mBibleTabsExClick(Sender: TObject);
    procedure MainPagesMouseLeave(Sender: TObject);
    procedure SearchTabContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure mViewTabsDblClick(sender: TAlekPageControl; index: Integer);
    procedure miRecognizeBibleLinksClick(Sender: TObject);
    procedure BookLBMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tbtnResolveLinksClick(Sender: TObject);

    procedure mViewTabsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TntFormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure miCloseAllOtherTabsClick(Sender: TObject);
    procedure tmrCommonTimerTimer(Sender: TObject);
    procedure miVerseHLBkgndClClick(Sender: TObject);
//    procedure tbAddBibleLinkClick(Sender: TObject);
    //    procedure vstBooksInitNode(Sender: TBaseVirtualTree; ParentNode,
    //      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    //    procedure vstBooksInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode;
    //      var ChildCount: Cardinal);
    //    procedure vstBooksGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
    //      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    //    procedure tbtnAddCategoryClick(Sender: TObject);
    //    procedure vstBooksNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
    //      Column: TColumnIndex; NewText: WideString);

        //    procedure BrowserMouseMove(Sender: TObject; Shift: TShiftState; X,
        //      Y: Integer);
        //    procedure CommBrowserHotSpotClick(Sender: TObject; const SRC: String;
        //      var Handled: Boolean);
  private
    { Private declarations }

    Browser: THtmlViewer;
    FInShutdown: Boolean;

    MainBook: TBible;
    SecondBook: TBible;

    SysHotKey: TSysHotKey;

    FCurPreviewPage: integer;
    ZoomIndex: integer;
    Zoom: double;
    {AlekId: добавлено}
    mBrowserDefaultFontName: WideString;
    mFolderModulesScanned, mSecondFolderModulesScanned, mFolderCommentsScanned,
      mArchivedBiblesScanned, mArchivedCommentsScanned, mAllBkScanDone,
      mDictionariesAdded, mDictionariesFullyInitialized: boolean;
    mDefaultLocation: WideString;
    mBibleTabsInCtrlKeyDownState: boolean;
    mHTMLSelection: AnsiString;
    SearchTime: int64;
    mTags_n_VersesList: TObjectList;
    mDicList: TBQStringList;
    mIcn: TIcon;
    mFavorites: TBQFavoriteModules;
    mInterfaceLock: boolean;
//    mBibleLinkParser:TBibleLinkParser;
    mXRefMisUsed: boolean;
//    mBibleLinkParserAvail: boolean;
    mlbBooksLastIx: integer;
    mRefenceBible: TBible;
    mHotBibles: TCachedModules;
    mFirstVisibleVerse:integer;
    hint_expanded:integer;//0 -not set, 1-short , 2-expanded
//    mBibleTabsWideHelper:TWideControlHelper;
//    mBookCategories: TObjectList;
    {AlekId: /добавлено}
    procedure WMQueryEndSession(var Message: TWMQueryEndSession);
      message WM_QUERYENDSESSION;

    procedure DrawMetaFile(PB: TTntPaintBox; mf: TMetaFile);
    function ProcessCommand(s: WideString; hlVerses:TbqHLVerseOption): boolean;
    (*AlekId:Добавлено*)
    function _CreateNewBrowserInstanse(aBrowser: THTMLViewer; aOwner:
      TComponent;
      aParent: TWinControl): THTMLViewer;
    function _CreateNewBibleInstance(aBible: TBible; aOwner: TComponent):
      TBible;
    function GetActiveTabInfo(): TViewTabInfo;
    function TabInfoFromBrowser(browser: THTMLViewer): TViewTabInfo;
    procedure AdjustBibleTabs(awsNewModuleName: WideString = '');
    //при перемене модуля: навигация или смена таба
    procedure SafeProcessCommand(wsLocation: WideString; hlOption:TbqHLVerseOption);
    procedure UpdateUI();
//    function ActiveSatteliteMenu(): TTntMenuItem;
//    function SelectSatelliteMenuItem(aItem: TTntMenuItem): TTntMenuItem;
    procedure SetFirstTabInitialLocation(wsCommand, wsSecondaryView:
      WideString; showStrongs, showNotes, resolveLinks: boolean);
//    function SatelliteMenuItemFromModuleName(aName: WideString): TTntMenuItem;
    procedure SaveTabsToFile(path: WideString);
    procedure LoadTabsFromFile(path: WideString);
    function NewViewTab(const command, satellite: WideString;
      showStrongs, showNotes, resolveLinks: boolean): boolean;
    function FindTaggedTopMenuItem(tag: integer): TTntMenuItem;

    function AddArchivedModules(path: WideString; tempBook: TBible;
      background: boolean; addAsCommentaries: boolean = false): boolean;
    function AddFolderModules(path: WideString; tempBook: TBible;
      background: boolean; addAsCommentaries: boolean = false): boolean;
 //   function GetHotModuleCount(): integer;
//    function GetHotMenuItem(itemIndex: integer): TTntMenuItem;
    procedure InitBkScan();
    function LoadModules(background: boolean): boolean;
    function LoadHotModulesConfig(): boolean;
//    procedure DeleteInvalidHotModules();
    function SaveHotModulesConfig(aMUIEngine: TMultiLanguage): boolean;
    function AddHotModule(const modEntry: TModuleEntry; tag: integer;
      addBibleTab: boolean = true): integer;
    function FavouriteItemFromModEntry(const me: TModuleEntry): TTntMenuItem;
    function FavouriteTabFromModEntry(const me: TModuleEntry): integer;
    procedure DeleteHotModule(moduleTabIx: integer); overload;
    function DeleteHotModule(const me: TModuleEntry): boolean; overload;
    function ReplaceHotModule(const oldme, newMe: TModuleEntry): boolean;
    function InsertHotModule(newMe: TModuleEntry; ix: integer): integer;
    procedure SetFavouritesShortcuts();
    function AddDictionaries(maxLoad: integer = maxInt): boolean;
    function LoadDictionaries(maxAdd: integer): boolean;
    procedure UpdateDictionariesCombo();
    function LoadCachedModules(): boolean;
//    function CachedModuleIxFromFullname(const wsFullModuleName: WideString;
//      searchFromIndex: integer = 0): integer;

    function UpdateFromCashed(): boolean;
    procedure SaveCachedModules();
    procedure Idle(Sender: TObject; var Done: boolean);
    procedure ForceForegroundLoad();
    procedure UpdateAllBooks();
    function ModuleIndexByName(const awsModule: Widestring): integer;
    function DefaultLocation(): WideString;
    //    procedure LoadBookNodes();
    //    procedure SaveBookNodes();
    function ActivateFont(const fontPath: WideString): DWORD;
    function PrepareFont(const aFontName, aFontPath: WideString): boolean;
    function SuggestFont(const desiredFontName, desiredFontPath: WideString;
      desiredCharset: integer): WideString;
//    function NewTab(const location: WideString): boolean;
  type TgmtOption = (gmtBulletDelimited, gmtEffectiveAddress, gmtLookupRefBibles);
    TgmtOptions = set of TgmtOption;
function GetModuleText(cmd: WideString; out fontName: WideString;
  out bl: TBibleLink; out txt: WideString; options: TgmtOptions = []): integer;
function RefBiblesCount(): integer;
function GetRefBible(ix: integer): TModuleEntry;
procedure FontChanged(delta: integer);
procedure ShowHintEventHandler(var HintStr: string; var CanShow: Boolean;
  var HintInfo: THintInfo);
function DicScrollNode(nd: PVirtualNode): boolean;
procedure LoadUserMemos();
procedure LoadTaggedBookMarks();
procedure LoadSecondBookByName(const wsName: WideString);
//    procedure SetStrongsAndNotesState(showStrongs, showNotes:boolean; ti:TViewTabInfo);
    (*AlekId:/Добавлено*)
function GoAddress(var book, chapter, fromverse, toverse: integer): TbqNavigateResult;
procedure SearchListInit;

procedure GoPrevChapter;
procedure GoNextChapter;

procedure TranslateInterface(inifile: WideString);

procedure LoadConfiguration;
procedure SaveConfiguration;
    //    procedure InitHotModulesConfigPage(refreshModuleList: boolean = false);
//    procedure InitBibleTabs;
procedure SetBibleTabsHintsState(showHints: boolean = true);
procedure MainMenuInit(cacheupdate: boolean);
procedure GoModuleName(s: WideString);

procedure UpdateBooksAndChaptersBoxes;

procedure LanguageMenuClick(Sender: TObject);

function ChooseColor(color: TColor): TColor;
function LoadBibleToXref(cmd: WideString; const id: Widestring = ''): boolean;
    //    function LocateMemo(book,chapter,verse: integer; var cursor: integer): boolean;
//function MainFileExists(s: WideString): WideString;

procedure HotKeyClick(Sender: TObject);

function CopyPassage(fromverse, toverse: integer): WideString;

procedure GoRandomPlace;
procedure HistoryAdd(s: WideString);
procedure HistoryAdjust(const loc: WideString; const cmt: WideString);
procedure DisplayStrongs(num: integer; hebrew: boolean);
procedure DisplayDictionary(s: WideString);

procedure ConvertClipboard;

procedure DisplaySearchResults(page: integer);

function DictionaryStartup(maxAdd: integer = MaxInt): boolean;

procedure ShowXref;
procedure ShowComments;

function LocateDicItem: integer;
    // finds the closest match for a word in merged
    // dictionary word list

procedure ShowConfigDialog;
procedure ShowQNav(useDisposition: TBQUseDisposition = udMyLibrary);
procedure SetVScrollTracker(aBrwsr: THTMLViewer);
procedure VSCrollTracker(sender: TObject);
procedure EnableMenus(aEnabled: Boolean);
function CachedModuleIxFromFullname(const wsFullModuleName: WideString;
  searchFromIndex: integer): integer;
procedure MouseWheelHandler(var Message: TMessage); override;
function PreProcessAutoCommand(const cmd, prefModule: WideString): widestring;
procedure DeferredReloadViewPages();
procedure AppOnHintHandler(Sender: TObject);
procedure HintShowHideEvent(state:integer);
public
  mHandCur: TCursor;

    { Public declarations }
procedure SetCurPreviewPage(Val: integer);
function PassWordFormShowModal(const aModule: WideString;
  out Pwd: WideString; out savePwd: boolean): integer;
function DicSelectedItemIndex(out pn: PVirtualNode): integer; overload;
function DicSelectedItemIndex(): integer; overload;
property CurPreviewPage: integer read FCurPreviewPage write
  SetCurPreviewPage;

  end;
function CreateAndGetConfigFolder: WideString;

var
  MainForm: TMainForm;
  MFPrinter: TMetaFilePrinter;
  G_ControlKeyDown: boolean;
  LastLanguageFile: WideString;

implementation

uses copyright, input, config, PasswordDialog, BibleQuoteConfig,
  BQExceptionTracker, AboutForm, RichEdit, HTMLSubs, JCLDebug,
  TntClasses,  TntSysUtils, StrUtils, CommCtrl, TntControls, bqHintTools, sevenZipHelper,
  Types, BibleLinkParser;
type
//  TModuleType = (modtypeBible, modtypeBook, modtypeComment);
//  TModuleEntry = class
//    wsFullName, wsShortName, wsShortPath, wsFullPath: Widestring;
//    modType: TModuleType;
//    constructor Create(amodType: TModuleType; awsFullName, awsShortName,
//      awsShortPath, awsFullPath: Widestring);overload;
//    constructor Create(me:TModuleEntry);overload;
//    procedure Init(amodType: TModuleType; awsFullName, awsShortName,
//      awsShortPath, awsFullPath: Widestring);
//    procedure Assign(source:TModuleEntry);
//  end;

  TArchivedModules = class
    Names, Paths: TWideStrings;
    procedure Clear();
    constructor Create();
    destructor Destroy(); override;
    procedure Assign(source: TArchivedModules);
  end;

var
  Bibles, Books,
    Comments, CommentsPaths {,
  CacheModPaths, CacheDicPaths,
  CacheModTitles, CacheDicTitles // new for 24.07.2002 - cache for module and dictionary titles}
  : TWideStringList;                    // global module names
  mModules: TCachedModules;
  Dics: array[0..255] of TDict;
  DicsCount: integer;

  { Не найдено ни одного разумного объяснения,
  зачем вместо банальной строки используется
  столь сложный класс, как TStrings.
  Текст из *Source загружается и выгружается
  только целиком, без доступа к конкретным строкам.
  Короче, решено заменить эти переменные на WideString. }
  //BrowserSource: TWideStrings;
  //SearchBrowserSource: TWideStrings;
  //DicBrowserSource: TWideStrings;
  //StrongBrowserSource: TWideStrings;
  //CommentsBrowserSource: TWideStrings;
  //BrowserSource: WideString;
  //SearchBrowserSource: WideString;
  //DicBrowserSource: WideString;
  //StrongBrowserSource: WideString;
  //CommentsBrowserSource: WideString;

  BrowserSearchPosition: Longint;

  BrowserPosition: LongInt;             // this helps PgUp, PgDn to scroll chapters...
  SearchBrowserPosition: LongInt;       // list search results pages...
  SearchPage: integer;                  // what page we are in

  StrongHebrew, StrongGreek: TDict;
  StrongsDir: WideString;

//  DefaultModule: WideString;
  SatelliteBible: WideString;

  // FLAGS

  MainFormInitialized: boolean;         // for only one entrance into .FormShow

  HistoryOn: boolean;

  MemoFilename: WideString;

  StrongNumbersOn: boolean;

  SearchPageSize: integer;

  PrintFootNote: boolean;

  AddressFromMenus: boolean;
  IsSearching: boolean;

  MainFormMaximized: boolean;

  MemosOn: boolean;

  Memos: TWideStringList;
  Bookmarks: TWideStringList;

  LastAddress: WideString;

  //  DefaultEncoding: Integer;

  History: TWideStrings;
  SearchResults: TWideStrings;
  SearchWords: TWideStrings;

  LastSearchResultsPage: integer;       // to show/hide page results (Ctrl-F3)

  XRef: array[1..30000] of TXRef;
  XRefQty: integer;

  ModulesList: TWideStrings;            // list of all available modules -- loaded ONCE
  ModulesCodeList: TWideStrings;        // codes like KJV, NIV, RST...
  {AlekId: добавлено}
  S_ArchivedModuleList: TArchivedModules;
  {AlekId:/добавлено}


  HelpFileName: WideString;

//  TempDir: WideString; // temporary file storage -- should be emptied on exit
  TemplatePath: WideString;
  SelTextColor: WideString;             // color strings after search
  g_VerseBkHlColor:WideString;

  TextTemplate: WideString;             // displaying passages

  PrevButtonHint, NextButtonHint: WideString;

{  CBPartsCaptions: array[0..1] of WideString;
  CBAllCaptions: array[0..1] of WideString;
  CBPhraseCaptions: array[0..1] of WideString;
  CBCaseCaptions: array[0..1] of WideString;}

  MainShiftState: TShiftState;

  CurVerseNumber,
    CurSelStart, CurSelEnd: integer;

  CurFromVerse, CurToVerse,
    VersePosition: integer;
  // positionto(...) when changing modules you need to know which verse it was

// config
  MainFormLeft, MainFormTop, MainFormWidth, MainFormHeight,
    MainPagesWidth, Panel2Height: integer;

{  MainFormTempHeight: integer;}//AlekId:QA

  //  MainBookFontName: WideString;

  miHrefUnderlineChecked,
    CopyOptionsCopyVerseNumbersChecked,
    CopyOptionsCopyFontParamsChecked,
    CopyOptionsAddModuleNameChecked,
    CopyOptionsAddReferenceChecked,
    CopyOptionsAddLineBreaksChecked: boolean;
  mFlagFullcontextLinks:boolean;
  mFlagCommonProfile:boolean;
  CopyOptionsAddReferenceRadioItemIndex: integer;

  ConfigFormHotKeyChoiceItemIndex: integer;
  (*AlekId:Добавлено*)
  UserDir: WideString;
  (*AlekId:/Добавлено*)
  PasswordPolicy: TPasswordPolicy;
  S_cachedModules: TCachedModules;
  __addModulesSR: TSearchRec;
  __searchInitialized: boolean;
  __r: integer;
  __tmpBook: TBible = nil;
  G_XRefVerseCmd: string;
  (*AlekId:/Добавлено*)
{$R *.DFM}

function GetAppDataFolder: WideString;
var
  dBuffer: string;
begin
  Result := '';

  SetLength(dBuffer, 1024);
  if not ShlObj.SHGetSpecialFolderPath(0, PChar(dBuffer), CSIDL_APPDATA, False) then
    Exit;

  TrimNullTerminatedString(dBuffer);
  if dBuffer = '' then
    Exit;

  if Copy(dBuffer, Length(dBuffer), 1) <> '\' then
    dBuffer := dBuffer + '\';

  Result := dBuffer;
end;

function CreateAndGetConfigFolder: WideString;
var
  dUserName: WideString;
  dPath: WideString;
  wsPath:WideString;
begin
  wsPath:=WideExtractFileName(WideExtractFileDir(ExePath()));

  if Pos('Portable', wsPath)<>0 then dUserName:='CommonProfile'
  else  dUserName := WindowsUserName();

  Result := ExePath + 'users\' + DumpFileName(dUserName) + '\';
  if ForceDirectories(Result) then
    Exit;
//AlekId:Weird
//  Result := WindowsDirectory + 'biblequote\' + DumpFileName(dUserName) + '\';
//  if ForceDirectories(Result) then
//    Exit;

  dPath := GetAppDataFolder;
  if dPath <> '' then
  begin
    Result := dPath + 'BibleQuoteUni\';
    if ForceDirectories(Result) then
      Exit;
  end;
  MessageBoxW(0, 'Cannot Found BibleQute data folder', 'BibleQute Error', MB_OK
    or MB_ICONERROR);
  Result := '';

end;

procedure TMainForm.UpdateBooksAndChaptersBoxes();
var
  i: integer;
  offset: integer;
begin
  with BookLB do
  begin
    Items.BeginUpdate;
    Items.Clear;
    for i := 1 to MainBook.BookQty do
      Items.Add(MainBook.FullNames[i]);
    Items.EndUpdate;
    ItemIndex := MainBook.CurBook - 1;
  end;
  mlbBooksLastIx := -1;
  if MainBook.BookQty <= 0 then begin
    ChapterLB.Clear; exit end;
  with ChapterLB do
  begin
    Items.BeginUpdate;
    Items.Clear;

    offset := 0;
    if MainBook.ChapterZero then
      offset := 1;

    for i := 1 to MainBook.ChapterQtys[BookLB.ItemIndex + 1] do
      Items.Add(IntToStr(i - offset));

    Items.EndUpdate;
    ItemIndex := MainBook.CurChapter - 1;
  end;
end;

procedure TMainForm.HintShowHideEvent(state: integer);
begin
if state=SW_HIDE then
 hint_expanded:=0;
end;

procedure TMainForm.HistoryAdd(s: WideString);
begin
  if (not HistoryOn) or ((History.Count > 0) and (History[0] = s)) then
    Exit;

  if History.Count >= MAXHISTORY then
  begin
    History.Delete(History.Count - 1);
    HistoryLB.Items.Delete(HistoryLB.Items.Count - 1);
  end;

  History.Insert(0, s);

  HistoryLB.Items.Insert(0, Comment(s));
  HistoryLB.ItemIndex := 0;
end;

procedure TMainForm.HistoryAdjust(const loc: WideString; const cmt: WideString);
var cnt, i: integer;
  bl, nbl: TBibleLinkEx;
  r: boolean;
  newpath, path: WideString;
  likeness: TBibleLinkExLikeness;
begin
  r := nbl.FromBqStringLocation(loc);
  if not r then exit;

  cnt := History.Count - 1;
  if cnt > 20 then cnt := 20;

  for I := 0 to cnt do begin
    r := bl.FromBqStringLocation(History[i]);
    if not r then continue;
    likeness := nbl.GetLikeNess(bl);
    if (bllModName in likeness) and (bllBook in likeness) { and (bllChapter in likeness)} then begin
      path := nbl.VisualSig();
//    path:=WideFormat('%s:%d', [path,nbl.vstart]);//just misusing var
      HistoryLB.Items[i] := path;
      History[i] := loc + ' $$$' + path;
      exit;
    end;                                //branch
  end;                                  //for

end;                                    //proc

procedure TMainForm.GoRandomPlace;
var
  book, chapter, verse: integer;
begin
  Randomize();
  book := Random(MainBook.BookQty) + 1;
  //  Randomize;// AlekId: ни к чему
  chapter := Random(MainBook.ChapterQtys[book]) + 1;
  //  Randomize;// AlekId: ни к чему
  verse := Random(MainBook.CountVerses(book, chapter)) + 1;

  ProcessCommand(WideFormat('go %s %d %d %d', [MainBook.ShortPath, book,
    chapter, verse]), hlTrue );
end;

procedure TMainForm.HotKeyClick(Sender: TObject);
begin
  GoModuleName((Sender as TTntMenuItem).Caption);
end;



procedure TMainForm.LoadConfiguration;
var

  fname: WideString;
  HotList: TWideStrings;
  fnt: TFont;
  h: integer;
begin
  try
    UserDir := CreateAndGetConfigFolder;
    PasswordPolicy := TPasswordPolicy.Create(UserDir +
      C_PasswordPolicyFileName);
    MainCfgIni := TMultiLanguage.Create(Self);
    try
      MainCfgIni.IniFile := UserDir + C_ModuleIniName;
    except on e: Exception do
        BqShowException(e, 'Cannot Load Configuration file!');
    end;

    HotList := TWideStringList.Create;

    MainFormWidth := (StrToInt(MainCfgIni.SayDefault('MainFormWidth', '0')) *
      Screen.Width) div MAXWIDTH;
    MainFormHeight := (StrToInt(MainCfgIni.SayDefault('MainFormHeight', '0')) *
      Screen.Height) div MAXHEIGHT;
    MainFormLeft := (StrToInt(MainCfgIni.SayDefault('MainFormLeft', '0')) *
      Screen.Width)
      div MAXWIDTH;
    MainFormTop := (StrToInt(MainCfgIni.SayDefault('MainFormTop', '0')) * Screen.Height)
      div MAXHEIGHT;
    MainFormMaximized := MainCfgIni.SayDefault('MainFormMaximized', '0') = '1';

    MainPagesWidth := (StrToInt(MainCfgIni.SayDefault('MainPagesWidth', '0')) *
      Screen.Height) div MAXHEIGHT;
    Panel2Height := (StrToInt(MainCfgIni.SayDefault('Panel2Height', '0')) *
      Screen.Height)
      div MAXHEIGHT;

    fnt := TFont.Create;
    fnt.Name := MainCfgIni.SayDefault('MainFormFontName', 'Arial');
  //fnt.Charset := StrToInt(ini.SayDefault('MainFormFontCharset', '204'));
    fnt.Size := StrToInt(MainCfgIni.SayDefault('MainFormFontSize', '9'));

    miRecognizeBibleLinks.Enabled := true;
    tbtnResolveLinks.Enabled := true;
    MainForm.Font := fnt;

    Screen.HintFont.Assign(fnt);
    Screen.HintFont.Height := Screen.HintFont.Height * 5 div 4;
    Application.HintColor := $FDF9F4;
    mBibleTabsEx.Font.Assign(fnt);
    h := fnt.Height;
    if h < 0 then
      h := -h;
    mBibleTabsEx.Height := h + 13;
    MainForm.Update;
    fnt.Free;
    Prepare(WideExtractFilePath(tntApplication.ExeName) + 'biblebooks.cfg', Output);

    with Browser do
    begin
      DefFontName := MainCfgIni.SayDefault('DefFontName', 'Times New Roman');
      mBrowserDefaultFontName := DefFontName;
      DefFontSize := StrToInt(MainCfgIni.SayDefault('DefFontSize', '12'));
      DefFontColor := Hex2Color(MainCfgIni.SayDefault('DefFontColor', '#000000'));

    //DefaultCharset := 1251;
    //DefaultCharset := StrToInt(ini.SayDefault('Charset', '204'));

      DefBackGround := Hex2Color(MainCfgIni.SayDefault('DefBackground', '#EBE8E2'));
      DefHotSpotColor := Hex2Color(MainCfgIni.SayDefault('DefHotSpotColor',
        '#0000FF'));
      try
      g_VerseBkHlColor:=Color2Hex(Hex2Color(MainCfgIni.SayDefault('VerseBkHLColor', '#F5F5DC')));
      except  g_VerseBkHlColor:='#F5F5DC';
      end;
    end;

    with SearchBrowser do
    begin
      DefFontName := MainCfgIni.SayDefault('RefFontName', 'Times New Roman');
      DefFontSize := StrToInt(MainCfgIni.SayDefault('RefFontSize', '12'));
      DefFontColor := Hex2Color(MainCfgIni.SayDefault('RefFontColor', '#000000'));

      DefBackGround := Browser.DefBackGround;
      DefHotSpotColor := Browser.DefHotSpotColor;
    end;

    with DicBrowser do
    begin
      DefFontName := SearchBrowser.DefFontName;
      DefFontSize := SearchBrowser.DefFontSize;
      DefFontColor := SearchBrowser.DefFontColor;

      DefBackGround := SearchBrowser.DefBackGround;
      DefHotSpotColor := SearchBrowser.DefHotSpotColor;
    end;

    with StrongBrowser do
    begin
      DefFontName := SearchBrowser.DefFontName;
      DefFontSize := SearchBrowser.DefFontSize;
      DefFontColor := SearchBrowser.DefFontColor;

      DefBackGround := SearchBrowser.DefBackGround;
      DefHotSpotColor := SearchBrowser.DefHotSpotColor;
    end;

    with CommentsBrowser do
    begin
      DefFontName := SearchBrowser.DefFontName;
      DefFontSize := SearchBrowser.DefFontSize;
      DefFontColor := SearchBrowser.DefFontColor;

      DefBackGround := SearchBrowser.DefBackGround;
      DefHotSpotColor := SearchBrowser.DefHotSpotColor;
    end;

    with XRefBrowser do
    begin
      DefFontName := SearchBrowser.DefFontName;
      DefFontSize := SearchBrowser.DefFontSize;
      DefFontColor := SearchBrowser.DefFontColor;

      DefBackGround := SearchBrowser.DefBackGround;
      DefHotSpotColor := SearchBrowser.DefHotSpotColor;

    // this browser doesn't have underlines...
      htOptions := htOptions + [htNoLinkUnderline];
    end;

    LastLanguageFile := MainCfgIni.SayDefault('LastLanguageFile', '');
    LastAddress := MainCfgIni.SayDefault('LastAddress', '');
    G_SecondPath := MainCfgIni.SayDefault('SecondPath', '');

    SatelliteBible := MainCfgIni.SayDefault('SatelliteBible', '');
    mFavorites := TBQFavoriteModules.Create(AddHotModule, DeleteHotModule,
      ReplaceHotModule, InsertHotModule, ForceForegroundLoad);

    SaveFileDialog.InitialDir := MainCfgIni.SayDefault('SaveDirectory', 'c:\');
    SelTextColor := MainCfgIni.SayDefault('SelTextColor', DefaultSelTextColor);
    PrintFootNote := MainCfgIni.SayDefault('PrintFootNote', '1') = '1';

  // by default, these are checked
    miHrefUnderlineChecked := MainCfgIni.SayDefault('HrefUnderline', '0') = '1';
    mFlagFullcontextLinks:=MainCfgIni.SayDefault(C_opt_FullContextLinks,'1')='1';

  //  miCopyVerseNum.Checked := ini.SayDefault('CopyVerseNum', '0') = '1';
  //  miCopyRTF.Checked := ini.SayDefault('CopyRTF', '0') = '1';

    if miHrefUnderlineChecked then
      Browser.htOptions := Browser.htOptions - [htNoLinkUnderline]
    else
      Browser.htOptions := Browser.htOptions + [htNoLinkUnderline];

  //if ini.SayDefault('LargeToolbarButtons', '1') = '1'
  //then miLargeButtons.Click;
    try
      fname := UserDir + 'bibleqt_bookmarks.ini';
      if FileExists(fname) then
        Bookmarks.LoadFromFile(fname);
    except on e: Exception do BqShowException(e) end;
    LoadUserMemos();

{  fname := UserDir + 'bibleqt_memos.ini';
  if FileExists(fname) then
    Memos.LoadFromFile(fname);}
    try
      fname := UserDir + 'bibleqt_history.ini';
      if FileExists(fname) then
        History.LoadFromFile(fname);
    except on e: Exception do BqShowException(e) end;
  // COPYING OPTIONS
    CopyOptionsCopyVerseNumbersChecked :=
      MainCfgIni.SayDefault('CopyOptionsCopyVerseNumbers', '1') = '1';
    CopyOptionsCopyFontParamsChecked :=
      MainCfgIni.SayDefault('CopyOptionsCopyFontParams',
      '0') = '1';
    CopyOptionsAddReferenceChecked := MainCfgIni.SayDefault('CopyOptionsAddReference',
      '1') = '1';
    CopyOptionsAddReferenceRadioItemIndex :=
      StrToInt(MainCfgIni.SayDefault('CopyOptionsAddReferenceRadio', '1'));
    CopyOptionsAddLineBreaksChecked :=
      MainCfgIni.SayDefault('CopyOptionsAddLineBreaks',
      '1') = '1';
    CopyOptionsAddModuleNameChecked :=
      MainCfgIni.SayDefault('CopyOptionsAddModuleName',
      '0') = '1';

    ConfigFormHotKeyChoiceItemIndex :=
      StrToInt(MainCfgIni.SayDefault('ConfigFormHotKeyChoiceItemIndex', '0'));

    TrayIcon.MinimizeToTray := MainCfgIni.SayDefault('MinimizeToTray', '0') = '1';
    try
      LoadTaggedBookMarks();
    except on e: Exception do BqShowException(e) end;
    HotList.Free;

//    FreeAndNil(MainCfgIni);
  except on e: Exception do BqShowException(e) end;
end;

{:/AlekId:Добавлено}

function TMainForm.LoadDictionaries(maxAdd:
  integer): boolean;
var
  c: integer;
begin
  result := false;
  c := maxAdd;
  if not (mDictionariesAdded) then
  begin
    repeat
      mDictionariesAdded := AddDictionaries(maxAdd);
      dec(c);
    until (c <= 0) or (mDictionariesAdded);
    if not mDictionariesAdded then exit;
//    mDictionariesFullyInitialized := true;
    UpdateDictionariesCombo();
  end;

  if not (mDictionariesFullyInitialized) then
  begin
    if (maxAdd < maxInt) then
      maxAdd := maxAdd * 400;
    mDictionariesFullyInitialized := DictionaryStartup(maxAdd);
  end;
  result := mDictionariesFullyInitialized;
end;

procedure TMainForm.LoadFontFromFolder(awsFolder: WideString);
var
  sr: TSearchRec;
  r: integer;
begin
  try
    r := FindFirst(awsFolder + '*.ttf', faArchive or faReadOnly or faHidden,
      sr);
    if r <> 0 then abort;
    repeat
      PrepareFont(FileRemoveExtension(sr.Name), awsFolder);
      r := FindNext(sr);
    until r <> 0;

  finally
    FindClose(sr);
  end;

end;

function TMainForm.AddDictionaries(maxLoad: integer): boolean;

begin
  result := false;
  if not __searchInitialized then
  begin

    mIcn := TIcon.Create;
    theImageList.GetIcon(17, mIcn);

    imgLoadProgress.Picture.Graphic := mIcn;
    imgLoadProgress.Show();
    __r := FindFirst(ExePath + 'Dictionaries\*.idx', faAnyFile, __addModulesSR);
    __searchInitialized := true;

  end;
  try
    if (DicsCount > 0) and (not (Dics[DicsCount - 1].Initialized)) then begin
      Dics[DicsCount - 1].Initialize('', '', true);
    //if Dics[DicsCount].Initialized then  Inc(DicsCount);
      if Dics[DicsCount - 1].Initialized then
        __r := FindNext(__addModulesSR);
      exit
    end;

    if __r = 0 then begin

      Dics[DicsCount] := TDict.Create;
      Dics[DicsCount].Initialize(ExePath + 'Dictionaries\' +
        __addModulesSR.Name,
        Copy(ExePath + 'Dictionaries\' + __addModulesSR.Name, 1,
        Length(ExePath + 'Dictionaries\' + __addModulesSR.Name) - 3) + 'htm',
        true);
      Inc(DicsCount);
      if Dics[DicsCount - 1].Initialized then
        __r := FindNext(__addModulesSR);
    end
  except on e: Exception do
    begin Dics[DicsCount].Free(); BqShowException(e); end end;

//    until (__r <> 0) or (maxLoad <= 0);

  if (__r <> 0) then
  begin
    FindClose(__addModulesSR);
    __searchInitialized := false;
    result := true;

  end
end;

function TMainForm.LoadModules(background: boolean): boolean;
var
  compressedModulesDir: Widestring;
  //  done: boolean;
  icn: TICON;
begin
  result := false;
  try
    if not Assigned(__tmpBook) then begin
      __tmpBook := TBible.Create(self);
      icn := TIcon.Create;
      theImageList.GetIcon(33, icn);
      imgLoadProgress.Picture.Graphic := icn;
      imgLoadProgress.Show();
    end;
    try
      if not background then
      begin
        AddFolderModules(ExePath, __tmpBook, background);
        compressedModulesDir := ExePath + C_CompressedModulesSubPath;
        AddArchivedModules(compressedModulesDir, __tmpBook, background);
        if (G_SecondPath <> '') and (WideExtractFilePath(G_SecondPath) <>
          WideExtractFilePath(ExePath)) then
          AddFolderModules(G_SecondPath, __tmpBook, background);
        AddArchivedModules(ExePath + C_CommentariesSubPath, __tmpBook,
          background, true);
        AddFolderModules(ExePath + 'Commentaries\', __tmpBook, background,
          true);
        mAllBkScanDone := true;
        result := true;
      end
      else
      begin
        if not (mFolderModulesScanned) then
        begin
          mFolderModulesScanned := AddFolderModules(ExePath, __tmpBook,
            background);
          exit;
        end;
        if not mArchivedBiblesScanned then
        begin
          compressedModulesDir := ExePath + C_CompressedModulesSubPath;
          mArchivedBiblesScanned := AddArchivedModules(compressedModulesDir,
            __tmpBook, background);
          exit;
        end;
        if not mSecondFolderModulesScanned then
        begin
          if (G_SecondPath <> '') and (WideExtractFilePath(G_SecondPath) <>
            WideExtractFilePath(ExePath)) then
          begin
            mSecondFolderModulesScanned := AddFolderModules(G_SecondPath,
              __tmpBook, background);
            exit;
          end
          else
            mSecondFolderModulesScanned := true;
        end;                            //sencond folder
        if not mArchivedCommentsScanned then
        begin
          mArchivedCommentsScanned := AddArchivedModules(ExePath +
            C_CommentariesSubPath, __tmpBook, background, true);
          exit;
        end;
        if not mFolderCommentsScanned then
        begin
          mFolderCommentsScanned := AddFolderModules(ExePath + 'Commentaries\',
            __tmpBook, background, true);
          exit;
        end
        else
        begin
          mAllBkScanDone := true;
          result := true;
        end;
      end;                              //else --- background
    finally
      if mAllBkScanDone then begin
        S_cachedModules._Sort();
//        imgLoadProgress.Hide();
        if not Assigned(mModules) then mModules := TCachedModules.Create(true);
        mModules.Assign(S_cachedModules);
        ;                               //        FreeAndNil(__tmpBook);
      end;

    end;
  except
  end;
end;

procedure TMainForm.LoadSecondBookByName(const wsName: WideString);
var ix: integer;
  ini: WideString;
begin
  ix := mModules.FindByName(wsName);
  if ix >= 0 then begin
    ini := MainFileExists(mModules[ix].wsShortPath + '\bibleqt.ini');
    if ini <> SecondBook.IniFile then
      SecondBook.IniFile := MainFileExists(mModules[ix].wsShortPath + '\bibleqt.ini');
  end;
end;

//fn

function TMainForm.LoadHotModulesConfig(): boolean;
var
  hotList: TWideStringList;
  hotCount, i, hotIndex: integer;
  favouriteMenuItem, hotMenuItem: TTntMenuItem;
  hotMUITag, menuText: WideString;
  fn1, fn2: string;
  f1Exists, f2Exists: boolean;

  procedure DefaultHotModules();
  begin
  end;

begin
  try

    hotList := nil;
    Result := false;
    mBibleTabsEx.WideTabs.Clear();
    mBibleTabsEx.WideTabs.Add('***');
    fn1 := CreateAndGetConfigFolder() + C_HotModulessFileName;
    f1Exists := FileExists(fn1);
    if f1Exists then begin mFavorites.LoadModules(mModules, fn1) end
    else begin
      fn2 := ExePath + 'hotlist.txt';
      f2Exists := FileExists(fn2);
      if f2Exists then begin mFavorites.LoadModules(mModules, fn2) end
    end;

  except on e: Exception do begin BqShowException(e); Result := false; end end;

end;

function TMainForm.SaveHotModulesConfig(aMUIEngine: TMultiLanguage): boolean;
var
  favoriteMenuItem, currentMenuItem: TTntMenuItem;
  menuItemCount, i: integer;
  hotList: TWideStringList;
begin
  Result := false;
//  hotList := TWideStringList.Create();
//  try
//    try //for except
//      favoriteMenuItem := FindTaggedTopMenuItem(3333);
//      if (not Assigned(favoriteMenuItem)) then
//        exit;
//      menuItemCount := GetHotModuleCount - 1;
//      aMUIEngine.Learn('HotAddressCount', IntToStr(menuItemCount+1));
//      for I := 0 to menuItemCount do
//      begin
//        try
//          currentMenuItem := GetHotMenuItem(i);
//          if not assigned(currentMenuItem) or (length(currentMenuItem.Caption) =
//            0) then continue;
//          hotList.Add(currentMenuItem.Caption);
//          aMUIEngine.Learn('HotAddress'+inttostr(i),currentMenuItem.Caption);
//        except on e: exception do BqShowException(e) end;
//      end; //for
  mFavorites.SaveModules(CreateAndGetConfigFolder + C_HotModulessFileName);

  Result := true;

end;

procedure TMainForm.LoadTabsFromFile(path: WideString);
var
  tabStringList: TWideStringList;
  linesCount, tabIx, i, activeTabIx, strongs_notes_code, valErr: integer;
  location, second_bible: WideString;
  addTabResult, firstTabInitialized {, viewNotes, viewStrongs}: boolean;
begin
  tabStringList := nil;
  firstTabInitialized := false;
  try
    try
      if (not FileExists(path)) then
      begin
        SetFirstTabInitialLocation(LastAddress, '', false, true, false);
        exit;
      end;
      tabStringList := TWideStringList.Create();
      tabStringList.LoadFromFile(path);
      activeTabIx := -1;
      tabIx := 0;
      with tabStringList do
      begin
        linesCount := Count - 1;        //?;
        i := 0;
        if (linesCount < 1) then
          exit;
        repeat
          if (Strings[i]) = '+' then
          begin
            activeTabIx := tabIx;
            inc(i);
            if i >= linesCount then
              exit;
          end;
          location := Strings[i];
          inc(i);
          if ((i < linesCount) and (length(Strings[i]) > 0) and (Strings[i] <> '***')
            and not (CHAR(Strings[i][1]) in [#0..#9])) then
          begin
            second_bible := Strings[i];
          end
          else
            second_bible := '';
          inc(i);
          strongs_notes_code := 1;
          if ((i < linesCount) and (Strings[i] <> '***')) then begin
            val(Strings[i], strongs_notes_code, valErr);
            inc(i);
          end;
          if length(Trim(location)) > 0 then
          begin

            if (tabIx > 0) then
              addTabResult := NewViewTab(location, second_bible,
                (strongs_notes_code mod 100) >= 10, Odd(strongs_notes_code),
                strongs_notes_code >= 100)
            else
            begin
              addTabResult := true;
              SetFirstTabInitialLocation(location, second_bible,
                (strongs_notes_code mod 100) >= 10,
                Odd(strongs_notes_code), strongs_notes_code >= 100);
              firstTabInitialized := true;
            end;
          end
          else
            addTabResult := false;
          if (addTabResult) then
            Inc(TabIx);
          while ((i < linesCount) and (Strings[i] <> '***')) do
            inc(i);
          if (i < linesCount) then
            inc(i);
        until (i >= linesCount);

        if (activeTabIx < 0) or (activeTabIx >= mViewTabs.PageCount) then
          activeTabIx := 0;
        mViewTabs.ActivePageIndex := activeTabIx;
        mViewTabsChange(self);
      end;                              //with
    finally
      tabStringList.Free();
    end;                                //try
  except on E: Exception do BqShowException(e); end;

  if not firstTabInitialized then
    SetFirstTabInitialLocation(LastAddress, '', false, true, false);
end;

procedure TMainForm.LoadTaggedBookMarks;
var
  i, j, pc, c: integer;
  nd, tn: TVersesNodeData;
begin
  if not assigned(mTags_n_VersesList) then
    mTags_n_VersesList := TObjectList.Create(true);
  VersesDb.VerseListEngine.SeedNodes(mTags_n_VersesList);
  c := mTags_n_VersesList.Count;
  i := 0;
  while (i < c) and (TVersesNodeData(mTags_n_VersesList[i]).nodeType = bqvntTag) do begin
    nd := TVersesNodeData(mTags_n_VersesList[i]);
    PVirtualNode(nd.Parents) := vstBookMarkList.AddChild(nil, nd); inc(i); end;
  while (i < c) do begin
    nd := TVersesNodeData(mTags_n_VersesList[i]);
    if (assigned(nd.Parents)) and (nd.nodeType = bqvntVerse) then begin
      pc := nd.Parents.Count - 1;
      for j := 0 to pc do begin
        tn := TVersesNodeData(nd.Parents[j]);
        if not assigned(tn) then continue;
        vstBookMarkList.AddChild(PVirtualNode(tn.Parents), nd);
      end;

    end;
    inc(i);
  end;
end;

procedure TMainForm.LoadUserMemos;
var
  oldPath, newPath: WideString;
  sl: TStringList;
  i, c: integer;
  s: AnsiString;
begin
  try
    newPath := UserDir + 'UserMemos.mls';
    if FileExists(newPath) then begin
      Memos.LoadFromFile(newPath);
      exit;
    end;
    oldPath := UserDir + 'bibleqt_memos.ini';
    if not FileExists(oldPath) then exit;
    sl := nil;
    try
      sl := TStringList.Create();
      sl.LoadFromFile(oldPath);
      c := sl.Count - 1;
      Memos.Clear();
      for i := 0 to c do begin
        s := sl[i];
        if length(s) > 2 then Memos.Add(s);
      end;                              //for
    except on e: Exception do BqShowException(e) end;
    sl.Free();
  except on e: Exception do BqShowException(e) end;
end;

(*AlekId:Добавлено*)

procedure TMainForm.SaveCachedModules;
var
  modStringList: TWideStringList;
  count, i: integer;
  moduleEntry: TModuleEntry;
  wsFolder: WideString;
begin

  try
    modStringList := TWideStringList.Create();
    try
      count := S_cachedModules.Count - 1;
      if count <= 0 then
        exit;
      modStringList.Add('v3');
      for i := 0 to count do
      begin
        try
          moduleEntry := TModuleEntry(S_cachedModules[i]);
          with modStringList, moduleEntry do
          begin
            Add(IntToStr(ord(modType)));
            Add(wsFullName);
            Add(wsShortName);
            Add(wsShortPath);
            Add(wsFullPath);
            Add(UTF8Decode(modBookNames));
            Add(modCats);
            Add('***');
          end;                          //with tabInfo, tabStringList
        except
        end;
      end;                              //for
      wsFolder := GetCachedModulesListDir();
      modStringList.SaveToFile(wsFolder + C_CachedModsFileName);
    finally modStringList.Free()
    end;
  except
  end;
end;

(*AlekId:/Добавлено*)

procedure TMainForm.SaveConfiguration;
var
  ini: TMultiLanguage;
  fname: WideString;
  i: integer;
  {  Lst: TWideStrings;}
begin
  try
    UserDir := CreateAndGetConfigFolder;
  (*AlekId:Добавлено*)
    SaveTabsToFile(UserDir + 'viewtabs.cfg');
    SaveCachedModules();
    PasswordPolicy.SaveToFile(UserDir + C_PasswordPolicyFileName);
  //  SaveBookNodes();
    (*AlekId:/Добавлено*)
    ini := TMultiLanguage.Create(Self);
    ini.IniFile := UserDir + C_ModuleIniName;

    if MainForm.WindowState = wsMaximized then
      ini.Learn('MainFormMaximized', '1')
    else
    begin
      ini.Learn('MainFormWidth', IntToStr((MainForm.Width * MAXWIDTH) div
        Screen.Width));
      ini.Learn('MainFormHeight', IntToStr((MainForm.Height * MAXHEIGHT) div
        Screen.Height));
      ini.Learn('MainFormLeft', IntToStr((MainForm.Left * MAXWIDTH) div
        Screen.Width));
      ini.Learn('MainFormTop', IntToStr((MainForm.Top * MAXHEIGHT) div
        Screen.Height));

      ini.Learn('MainFormMaximized', '0');
    end;

  // width of nav window
    ini.Learn('MainPagesWidth', IntToStr((MainPages.Width * MAXHEIGHT) div
      Screen.Height));
  // height of nav window, above the history box
    ini.Learn('Panel2Height', IntToStr((Panel2.Height * MAXHEIGHT) div
      Screen.Height));

    ini.Learn('DefFontName', mBrowserDefaultFontName);
    ini.Learn('DefFontSize', IntToStr(Browser.DefFontSize));
    ini.Learn('DefFontColor', Color2Hex(Browser.DefFontColor));
    ini.Learn('VerseBkHLColor', g_VerseBkHlColor); 
  //  ini.Learn('Charset', IntToStr(DefaultCharset));

    ini.Learn('RefFontName', SearchBrowser.DefFontName);
    ini.Learn('RefFontSize', IntToStr(SearchBrowser.DefFontSize));
    ini.Learn('RefFontColor', Color2Hex(SearchBrowser.DefFontColor));

    ini.Learn('DefBackground', Color2Hex(Browser.DefBackground));
    ini.Learn('DefHotSpotColor', Color2Hex(Browser.DefHotSpotColor));
    ini.Learn('SelTextColor', SelTextColor);

  {  ini.Learn('HotAddress1', miHot1.Caption);
    ini.Learn('HotAddress2', miHot2.Caption);
    ini.Learn('HotAddress3', miHot3.Caption);
    ini.Learn('HotAddress4', miHot4.Caption);
    ini.Learn('HotAddress5', miHot5.Caption);
    ini.Learn('HotAddress6', miHot6.Caption);
    ini.Learn('HotAddress7', miHot7.Caption);
    ini.Learn('HotAddress8', miHot8.Caption);
    ini.Learn('HotAddress9', miHot9.Caption);
    ini.Learn('HotAddress0', miHot0.Caption);}
    {AlekId:Добавлено}
    try
      SaveHotModulesConfig(ini);        {/AlekId:Добавлено}
    except on e: Exception do BqShowException(e) end;
    ini.Learn('HrefUnderline', IntToStr(Ord(miHrefUnderlineChecked)));
  //  ini.Learn('CopyVerseNum', IntToStr(Ord(miCopyVerseNum.Checked)));
  //  ini.Learn('CopyRTF', IntToStr(Ord(miCopyRTF.Checked)));

    ini.Learn('CopyOptionsCopyVerseNumbers',
      IntToStr(Ord(ConfigForm.CopyVerseNumbers.Checked)));
    ini.Learn('CopyOptionsCopyFontParams',
      IntToStr(Ord(ConfigForm.CopyFontParams.Checked)));
    ini.Learn('CopyOptionsAddReference',
      IntToStr(Ord(ConfigForm.AddReference.Checked)));
    ini.Learn('CopyOptionsAddReferenceRadio',
      IntToStr(ConfigForm.AddReferenceRadio.ItemIndex));
    ini.Learn('CopyOptionsAddLineBreaks',
      IntToStr(Ord(ConfigForm.AddLineBreaks.Checked)));
    ini.Learn('CopyOptionsAddModuleName',
      IntToStr(Ord(ConfigForm.AddModuleName.Checked)));

    ini.Learn('ConfigFormHotKeyChoiceItemIndex',
      IntToStr(ConfigFormHotKeyChoiceItemIndex));

    ini.Learn('MinimizeToTray', IntToStr(Ord(TrayIcon.MinimizeToTray)));

//  for i := 0 to SatelliteMenu.Items.Count - 1 do
//    if SatelliteMenu.Items[i].Checked then
//    begin
//      if i > 0 then
//        ini.Learn('SatelliteBible', SatelliteMenu.Items[i].Caption)
//      else
//        ini.Learn('SatelliteBible', '');
//      break;
//    end;

  //if miLargeButtons.Checked
  //then ini.Learn('LargeToolbarButtons', '1')
  //else ini.Learn('LargeToolbarButtons', '0');

    ini.Learn('LastAddress', LastAddress);
    ini.Learn('LastLanguageFile', LastLanguageFile);
    ini.Learn('SecondPath', G_SecondPath);

    ini.Learn('MainFormFontName', MainForm.Font.Name);
    ini.Learn('MainFormFontSize', IntToStr(MainForm.Font.Size));
  //ini.Learn('MainFormFontCharset', IntToStr(MainForm.Font.Charset));

    ini.Learn('SaveDirectory', SaveFileDialog.InitialDir);
    if assigned(frmQNav) then begin
      ini.Learn(C_frmMyLibWidth, frmQNav.Width);
      ini.Learn(C_frmMyLibHeight, frmQNav.Height);
    end;
    ini.Learn(C_opt_FullContextLinks, ord(mFlagFullcontextLinks));
    try
      if (not FileExists(ini.IniFile))
        or (FileGetAttr(ini.IniFile) and faReadOnly <> faReadOnly) then
        ini.SaveToFile;
    finally
      ini.Destroy;
    end;

    i := History.Count - 1;

    repeat
      if (i >= 0) and (i < History.Count)
        and (Pos('file', History[i]) = 1) and (Pos('***', History[i]) > 0) then
        History.Delete(i);              // clear search results;

      Dec(i);
    until i < 0;
    try
      fname := UserDir + 'bibleqt_history.ini';
      if (not FileExists(fname))
        or (FileGetAttr(fname) and faReadOnly <> faReadOnly) then
        History.SaveToFile(fname);
    except on e: Exception do BqShowException(e) end;
    try
      fname := UserDir + 'bibleqt_bookmarks.ini';
      if (not FileExists(fname))
        or (FileGetAttr(fname) and faReadOnly <> faReadOnly) then
        Bookmarks.SaveToFile(fname);
    except on e: Exception do BqShowException(e) end;
    try
      fname := UserDir + 'UserMemos.mls';
      if (not FileExists(fname))
        or (FileGetAttr(fname) and faReadOnly <> faReadOnly) then
        Memos.SaveToFile(fname);
    except on e: Exception do BqShowException(e) end;
  except on e: Exception do BqShowException(e) end;
end;

procedure TMainForm.SaveTabsToFile(path: WideString);
var
  tabStringList: TWideStringList;
  tabCount, i: integer;
  tabInfo, activeTabInfo: TViewTabInfo;
begin
  tabStringList := nil;
  try
    tabStringList := TWideStringList.Create();
    tabCount := mViewTabs.PageCount - 1;
    activeTabInfo := TObject(mViewTabs.ActivePage.Tag) as TViewTabInfo;

    for i := 0 to tabCount do
    begin
      try
        tabInfo := TObject(mViewTabs.Pages[i].Tag) as TViewTabInfo;
        with tabStringList do
        begin
          if tabInfo = activeTabInfo then
            Add('+');
          Add(tabInfo.mwsLocation);
          Add(tabinfo.mSatelliteName);
          Add(InttoStr(ord(tabInfo.mShowStrongs) * 10 +
            ord(tabInfo.mShowNotes) + ord(tabInfo.mResolvelinks) * 100));
          Add('***');
        end;                            //with tabInfo, tabStringList
      except
      end;
    end;                                //for

    tabStringList.SaveToFile(path);

  except on e: Exception do BqShowException(e) end;
  tabStringList.Free();
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  F: TSearchRec;
  mi: TTntMenuItem;
  i {, b, c, v1, v2}: integer;          //AlekId:not used anymore
  foundmenu: boolean;
begin
  tbList.PageControl := nil;
  tbList.Parent := self;
  tbList.Visible := false;
  MainPages.DoubleBuffered := true;
  HistoryBookmarkPages.DoubleBuffered := true;
  mViewTabs.DoubleBuffered := true;
//  mBibleLinkParser:=TBibleLinkParser.Create();
//  mBibleLinkParser.PrepareBookNames();
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Application.HintHidePause := 1000 * 60;
  Application.OnHint:=AppOnHintHandler;

  theImageList.GetBitmap(4, btnQuickSearchBack.Glyph);
  theImageList.GetBitmap(6, btnQuickSearchFwd.Glyph);
  InitBkScan();
  FInShutdown := true;
  Application.OnShowHint := ShowHintEventHandler;
  HintWindowClass := bqHintTools.TbqHintWindow;
  //  TrayIcon.Visible := true;
  MainFormInitialized := false;         // prohibit re-entry into FormShow

  Browser := FirstBrowser;
  Browser.Align := alClient;
  SetVScrollTracker(Browser);
  MainBook := TBible.Create(mInitialViewPage);
  //AlekId: библия принадлежит табу
  SecondBook := TBible.Create(Self);
  mRefenceBible := TBible.Create(Self);

  MainBook.OnVerseFound := MainBookVerseFound;
  MainBook.OnChangeModule := MainBookChangeModule;
  MainBook.OnSearchComplete := MainBookSearchComplete;

  SysHotKey := TSysHotKey.Create(Self);
  SysHotKey.OnHotKey := SysHotKeyHotKey;
  SysHotKey.AddHotKey(vkQ, [hkExt]);
  SysHotKey.AddHotKey(vkB, [hkCtrl, hkAlt]);
  SysHotKey.Active := true;
  ConfigFormHotKeyChoiceItemIndex := 0;

//  DefaultModule := 'rststrong';

  //  if FileExists(ExePath + 'Strongs\grk.ttf') then
  //  begin
  //    AddFontResource(PChar(ExePath + 'Strongs\grk.ttf'));
  //    AddFontResource(PChar(ExePath + 'Strongs\heb.ttf'));
  //  end else begin
  //    AddFontResource(PChar(ExePath + 'grk.ttf'));
  //    AddFontResource(PChar(ExePath + 'heb.ttf'));
  //  end;
  InitTntEnvironment();
  Bibles := TWideStringList.Create;
  Books := TWideStringList.Create;
  Bibles.Sorted := true;
  Books.Sorted := true;

  Comments := TWideStringList.Create;
  CommentsPaths := TWideStringList.Create;

  S_cachedModules := TCachedModules.Create(true);
  //MainStatusBar.SimpleText := '   Something useful should be written here... Maybe TIPS and TRICKS would be good';

  // russian keyboard
  //ActivateKeyboardLayout(LoadKeyboardLayout('419', 0), KLF_ACTIVATE);

  //ActivateKeyboardLayout($419, 0);

  Lang := TMultiLanguage.Create(Self);

//  Screen.Cursors[crHandPoint] := LoadCursor(hInstance, 'ZOOMCURSOR');

  LastAddress := '';
  LastLanguageFile := '';
  G_SecondPath := '';

  HelpFileName := 'indexrus.htm';

  //BrowserSource := '';
  //SearchBrowserSource := '';
  //DicBrowserSource := '';
  //StrongBrowserSource := '';
  //CommentsBrowserSource := '';

  ModulesList := TWideStringList.Create();
  ModulesCodeList := TWideStringList.Create();
  S_ArchivedModuleList := TArchivedModules.Create();
  StrongNumbersOn := false;

  Memos := TWideStringList.Create;
  Memos.Sorted := true;

  MemosOn := false;
  miMemosToggle.Checked := MemosOn;

  Bookmarks := TWideStringList.Create;
  //Bookmarks.Sorted := true;

  History := TWideStringList.Create;
  HistoryOn := true;

  SearchResults := TWideStringList.Create;
  SearchWords := TWideStringList.Create;
  LastSearchResultsPage := 1;

  IsSearching := false;

  MainPages.ActivePage := GoTab;

  AddressFromMenus := true;

//  ExePath := ExtractFilePath(Application.ExeName);
  try
    if not assigned(VerseListEngine) then
      Application.CreateForm(TVerseListEngine, VerseListEngine);
    VerseListEngine.InitVerseListEngine(ExePath + 'TagsDb.bqd');
  except on e: Exception do BqShowException(e) end;

  //////////////////////////////////////////////
  //
  // LOADING CONFIGURATION
  //
  LoadConfiguration;
  //
  //
  //////////////////////////////////////////////
  MainPanel.Align := alClient;

  if MainPagesWidth <> 0 then
    MainPages.Width := MainPagesWidth;

  if Panel2Height <> 0 then
    Panel2.Height := Panel2Height;

  if MainFormWidth = 0 then
  begin
    MainForm.WindowState := wsMaximized;

    with MainForm do
    begin
      Left := (Screen.Width - Width) div 2;
      Top := (Screen.Height - Height) div 2;
    end;
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

  //MainForm.WindowState := wsMaximized;

  TemplatePath := ExePath + 'templates\default\';

//  TempDir := WindowsTempDirectory + 'BibleQuote\';
//  if not FileExists(TempDir) then
//    ForceDirectories(TempDir);

  if FileExists(TemplatePath + 'text.htm') then
    TextTemplate := TextFromFile(TemplatePath + 'text.htm')
  else
    TextTemplate := DefaultTextTemplate;

  //TextTemplate := TextTemplate + '<A NAME="#endofchapterNMFHJAHSTDGF123">';

  if not StrReplace(TextTemplate, 'background="', 'background="' + TemplatePath,
    false) then
    StrReplace(TextTemplate, 'background=', 'background=' + TemplatePath,
      false);
  if not StrReplace(TextTemplate, 'src="', 'src="' + TemplatePath, false) then
    StrReplace(TextTemplate, 'src=', 'src=' + TemplatePath, false);
  { why are we doing this: browser sets base to the module's directory, while
  templates can contain references to their background or inline images...}

  if FindFirst(ExePath + '*.lng', faAnyFile, F) = 0 then
  begin
    repeat                              { TODO -oAlekId -cqa : FindCLose }
      mi := TTntMenuItem.Create(Self);
      mi.Caption := UpperCaseFirstLetter(Copy(F.Name, 1, Length(F.Name) - 4));
      mi.OnClick := LanguageMenuClick;
      miLanguage.Add(mi);
    until FindNext(F) <> 0;
    FindClose(F);
  end;

  if LastLanguageFile <> '' then
    TranslateInterface(LastLanguageFile)
  else
  begin
    foundmenu := false;
    for i := 0 to miLanguage.Count - 1 do
      if (miLanguage.Items[i]).Caption = 'Russian' then
      begin
        foundmenu := true;
        break;
      end;

    if not foundmenu then
      (miLanguage.Items[miLanguage.Count - 1]).Click // choose last file
    else
      TranslateInterface('Russian.lng');
  end;

  MainMenuInit(false);
  // MAIN TABS INITIALIZATION

  HistoryLB.Items.BeginUpdate;
  for i := 0 to History.Count - 1 do
    HistoryLB.Items.Add(Comment(History[i]));
  HistoryLB.Items.EndUpdate;

  if HistoryLB.Items.Count > 0 then
    HistoryLB.ItemIndex := 0;

  BookmarksLB.Items.BeginUpdate;
  for i := 0 to Bookmarks.Count - 1 do
    BookmarksLB.Items.Add(Comment(Bookmarks[i]));
  BookmarksLB.Items.EndUpdate;

  BookmarkLabel.Caption := '';
  if Bookmarks.Count > 0 then
    BookmarkLabel.Caption := Comment(Bookmarks[0]);

  (*AlekId:Добавлено*)
  mViewTabs.CloseTabImage := LoadIcon(MainInstance, PAnsiChar(1233));
//  mViewTabs.CloseTabImage.LoadFromResourceID(MainInstance, 1233);
//  mViewTabs.CloseTabImage.TransparentColor := 0;
  mInitialViewPage.Tag := integer(TViewTabInfo.Create(FirstBrowser, MainBook,
    '', SatelliteBible, false, true, false));

  FirstBrowser := nil;
  (*AlekId:/Добавлено*)

  LoadTabsFromFile(UserDir + 'viewtabs.cfg');
  LoadHotModulesConfig();
  {  if LastAddress = '' then begin
      GoModuleName(miHot1.Caption);
      b := 1; c := 1; v1 := 1; v2 := 0;
      //MainForm.
      GoAddress(b, c, v1, v2);
    end
    else begin
      ProcessCommand(LastAddress);
      BooksCB.ItemIndex := BooksCB.Items.IndexOf(MainBook.Name);

      //ShowComments;
    end;}
//  LoadBookNodes();
  StrongsDir := 'Strongs';
  LoadFontFromFolder(ExePath + StrongsDir + '\');
  StrongHebrew := TDict.Create;
  if not (StrongHebrew.Initialize(
    ExePath + 'Strongs\hebrew.idx',
    ExePath + 'Strongs\hebrew.htm')) then
    WideShowMessage('Error in' + ExePath + 'Strongs\hebrew.*');

  StrongGreek := TDict.Create;
  if not (StrongGreek.Initialize(
    ExePath + 'Strongs\greek.idx',
    ExePath + 'Strongs\greek.htm')) then
    WideShowMessage('Error in' + ExePath + 'Strongs\greek.*');
  MainPagesChange(Self);
    //AlekId: чтобы правильно присвоит memoPopup
  Application.OnIdle := Self.Idle;
  Application.OnActivate := self.OnActivate;
  Application.OnDeactivate := self.OnDeactivate;
  vstDicList.DefaultNodeHeight := Canvas.TextHeight('X');
end;

(*AlekId:Добавлено*)

function TMainForm.GetActiveTabInfo(): TViewTabInfo;
begin
  try
    Result := (TObject(mViewTabs.ActivePage.Tag) as TViewTabInfo);
  except
    //just eat everything wrong
    Result := nil
  end;
end;

//proc   GetActiveTabInfo

{function TMainForm.GetHotMenuItem(itemIndex: integer): TTntMenuItem;
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
        result := favouriteMenuItem[i] as TTntMenuItem;
        break
      end;
  except //just to be safe
  end;
end;            }

{function TMainForm.GetHotModuleCount: integer;
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

end;}

function TMainForm.GetModuleText(cmd: WideString; out fontName: WideString;
  out bl: TBibleLink; out txt: WideString; options: TgmtOptions = []): integer;
var
  saveVstart, i, verseCount, start, c, status_valid: integer;
  value, path: WideString;
  fontFound, addEllipsis: boolean;
  ibl, effectiveLnk: TBibleLink;
  delimiter: WideString;
  currentBibleIx, prefBibleCount: integer;
label lblErrNotFnd;
  function NextRefBible(): boolean;
  var me: TModuleEntry;
  begin
    if currentBibleIx < prefBibleCount then begin
      me := GetRefBible(currentBibleIx);
      inc(currentBibleIx);
      mRefenceBible.IniFile := MainFileExists(me.getIniPath());
      result := true;
    end else result := false;

  end;

begin
  result := -1;
  try
//    txt := '';

//    HintWindowClass := bqHintTools.TbqHintWindow;
    ibl.FromBqStringLocation(cmd, path);

    if path <> C__bqAutoBible then begin
  //формируем путь к ini модуля
      path := MainFileExists(path + '\bibleqt.ini');
    // пытаемся подгрузить модуль
      mRefenceBible.IniFile := path;
    end else raise Exception.Create('Неверный аргумент GetModuleText:не указан модуль');
    if gmtLookupRefBibles in options then begin
      currentBibleIx := 0; prefBibleCount := RefBiblesCount(); end;
    repeat
      if not (gmtEffectiveAddress in options) then begin
        if mRefenceBible.InternalToAddress(ibl, effectiveLnk) < -1 then goto lblErrNotFnd;
      end else effectiveLnk := ibl;
      status_valid := mRefenceBible.LinkValidnessStatus(mRefenceBible.IniFile, effectiveLnk, false);
      if status_valid < -1 then goto lblErrNotFnd;
      mRefenceBible.SetHTMLFilterX('', true);
      mRefenceBible.OpenChapter(effectiveLnk.book, effectiveLnk.chapter); //already opened?
      verseCount := mRefenceBible.Lines.Count;
      if effectiveLnk.vend <= 0 then c := verseCount
      else c := effectiveLnk.vend;
      if (effectiveLnk.vstart > verseCount) then exit;
      if (effectiveLnk.vend > verseCount) then effectiveLnk.vend := verseCount;
//    if (bl.vend < bl.vstart) then   bl.vend := bl.vstart;
      if gmtBulletDelimited in options then delimiter := C_BulletChar + #32
      else delimiter := #13#10;
      Dec(c);
      if (c - effectiveLnk.vstart) > 10 then begin c := effectiveLnk.vstart + 10; addEllipsis := true end else addEllipsis := false;

      for i := effectiveLnk.vstart to c do begin
        txt := txt + DeleteStrongNumbers(mRefenceBible.Lines[i - 1]) + delimiter;
      end;
      txt := txt + DeleteStrongNumbers(mRefenceBible.Lines[c]);
      if addEllipsis then txt := txt + '...';

      if length(mRefenceBible.FontName) > 0 then begin
        fontFound := PrepareFont(mRefenceBible.FontName, mRefenceBible.Path);
        fontName := mRefenceBible.FontName; end
      else fontFound := false;
  (*если предподчтительного шрифта нет или он не найден и указана кодировка*)
      if not fontFound and (mRefenceBible.DesiredCharset >= 2) then
      begin
   {находим шрифт с нужной кодировкой учитывая предподчтительный и дефолтный}
        if length(mRefenceBible.FontName) > 0 then
          fontName := mRefenceBible.FontName
        else
          fontName := mBrowserDefaultFontName;
        fontname := FontFromCharset(self.Canvas.Handle, mRefenceBible.DesiredCharset,
          fontName);
      end;
      if length(fontName) = 0 then fontName := mBrowserDefaultFontName;
      result := 0;
      effectiveLnk.AssignTo(bl);
      break;
      lblErrNotFnd:

    until (not (gmtLookupRefBibles in options)) or (not nextRefBible());
  except
  end;
end;

function TMainForm.GetRefBible(ix: integer): TModuleEntry;
var i, cnt, bi: integer;
  me: TModuleEntry;
begin
  cnt := mFavorites.mModuleEntries.Count - 1; bi := 0;
  for i := 0 to cnt do begin
    me := mFavorites.mModuleEntries[i];
    if me.modType = modtypeBible then inc(bi);
    if bi > ix then begin break end;
  end;                                  //for
  if bi > ix then result := me else result := nil;
end;

(*AlekId:/Добавлено*)

function TMainForm.GoAddress(var book, chapter, fromverse, toverse: integer): TbqNavigateResult;
var
  paragraph, hlParaStart, hlParaEnd, hlstyle, title, head, text, s, strVerseNumber, ss: WideString;
  verse: integer;
  locVerseStart, locVerseEnd, bverse, everse: integer;
  i, ipos, b, c, v, ib, ic, iv: integer;
  UseParaBible, opened, multiHl: boolean;
  dBrowserSource: WideString;
  activeInfo: TViewTabInfo;             //AlekId:добавлено
  fontName: WideString;
  fistBookCell, SecondbookCell: WideString;
  mainbook_right_aligned, secondbook_right_aligned, hlCurrent: boolean;
  highlight_verse: TPoint;
  modEntry: TModuleEntry;
{  type ralignTypes=(open, close);
       tRalingTags=array[ralignTypes] of WideString;
  const ralign_tags:tRalingTags=('<DIV STYLE="text-align:right">','</DIV>');
  const ralign_tags_empty:tRalingTags =('','');
  var pFirstBookTags, pSecondBookTags:^tRalingTags;}

begin
  // провека и коррекция номера книги
  highlight_verse:=Point(fromverse,toverse);
  UseParaBible := false;
  result := nrSuccess;
  locVerseStart:=fromVerse; locVerseEnd:=toVerse;

  if book < 1 then begin result := nrBookErr; book := 1; end
  else if book > MainBook.BookQty then
  begin book := MainBook.BookQty; result := nrBookErr; end;

  //проверка и коррекция номера главы
  if chapter < 0 then begin
   result := nrChapterErr;
   chapter := 1;
  end;
  if chapter > MainBook.ChapterQtys[book] then begin
    if result = nrSuccess then Result := nrChapterErr;
   chapter := MainBook.ChapterQtys[book];
   end;

  if result<>nrSuccess then begin
   highlight_verse:=Point(0,0);
   fromverse:=0; toverse:=0;//reset verse on chapter err
   locVerseStart:=1; locVerseEnd:=0;
  end;

  // загружаем главу
  try
    MainBook.OpenChapter(book, chapter);
  except
    on e: EAbort do begin
      if result = nrSuccess then Result := nrChapterErr;
      raise;
    end;
  else
    begin
      if result = nrSuccess then Result := nrChapterErr;
      highlight_verse := Point(0,0);
      MainBook.OpenChapter(1, 1);
      book := 1;
      chapter := 1;
      fromverse := 0;
      locVerseStart:=1;
      toverse := 0;
      locVerseEnd:=0;
    end;
  end;
  mainbook_right_aligned := MainBook.UseRightAlignment;
  UseParaBible := false;

  // Поиск вторичной Библии, если первый модуль библейский
  if MainBook.isBible then
  begin
    //поиск отмеченного пункта меню
//    activeMenu := ActiveSatteliteMenu();
//    if (activeMenu = SatelliteMenu.Items[0]) then
//      UseParaBible := false
//    else
//    begin
//      s := activeMenu.Caption;
//      UseParaBible := false;
    activeInfo := GetActiveTabInfo();
    s := activeInfo.mSatelliteName;
    if s = '------' then UseParaBible := false
    else begin
      //поиск в списке модулей
      modEntry := mModules.ResolveModuleByNames(s, '');

      if assigned(modEntry) then
        {// now UseParaBible will be used if satellite text is found...}
      begin
        try
          //открываем вторичную
          SecondBook.IniFile :=
            MainFileExists(modEntry.getIniPath());
          UseParaBible := true;
        except
          // при неудаче открытия
          UseParaBible := false;
        end;                            //try
        secondbook_right_aligned := SecondBook.UseRightAlignment;
        // если первичный модуль показыввает ВЗ, а второй не содержит ВЗ
        if ((MainBook.CurBook < 40) and (MainBook.HasOldTestament) and (not
          SecondBook.HasOldTestament))
          or                            //или если в первичном модуль НЗ а второй не содержит НЗ
          ((MainBook.CurBook > 39) and (MainBook.HasNewTestament) and (not
          SecondBook.HasNewTestament)) then
          UseParaBible := false;        // отменить отображение
      end;                              // if UseParaBible- если найден в списке  модулей
    end;                                //если выбрана вторичная Библия
  end;                                  //если модуль Библейский

  // проверка и коррекция начального стиха
  if fromverse>MainBook.VerseQty then begin
    fromverse := 0; locVerseStart:=1; highlight_verse.X:=0;
    if result = nrSuccess then Result := nrStartVerseErr;
  end;
  //проверка и коррекция конечного стиха стиха
  if (toverse > MainBook.VerseQty) or (toverse < fromverse) then begin
    if (toverse<fromverse) and (toverse <= MainBook.VerseQty) then begin
      toverse:=highlight_verse.y;
      highlight_verse.y:=highlight_verse.x;
      highlight_verse.x:=toverse;
    end
    else highlight_verse.y:=0;
    toverse:=0;
    locVerseEnd:=0;
  if result = nrSuccess then Result := nrEndVerseErr;
  end;

  if MainBook.NoForcedLineBreaks then
    paragraph := ''
  else
  begin
    if (MainBook.isBible) then
      paragraph := ' <BR>'
    else {AlekId}                       //paragraph := '<P style="background-color:beige">';
      paragraph := '<P>';
  end;
  //??
  if toverse = 0 then
  begin                                 // если отображать всю главу??
    (*если в книге только одна глава *)
    if MainBook.ChapterQtys[book] = 1 then
      head := MainBook.FullNames[book]
    else
      head := MainBook.FullPassageSignature(book, chapter, 1, 0);
  end                                   //если отображать всю главу
  else
    head := MainBook.FullPassageSignature(book, chapter, fromverse, toverse);

  title := '<head>'#13#10'<title>' + head + '</title>'#13#10 + bqPageStyle + #13#10'</head>';
  head := '<font face="' + mBrowserDefaultFontName + '">' + head + '</font>';

  text := '';
  // коррекция начального стиха
  if locVerseStart = 0 then begin locVerseStart := 1;  end;
//  else if highlight_verse <> 0 then highlight_verse := 1;

  bverse := 1;
  if (locVerseStart > 0) and (not mFlagFullcontextLinks) then
    bverse := locVerseStart;

  //  everse := toverse; AlekId: неразумно
  if (locVerseEnd = 0) or (mFlagFullcontextLinks) then
    everse := MainBook.VerseQty
      (*AlekId: добавлено*)
  else 
    everse := locVerseEnd;{AlekId:/добавлено}

  CurFromVerse := bverse;
  CurToVerse := everse;

  opened := false;

  if UseParaBible then
  begin
    if MainBook.ChapterZero and (chapter = 1) then
      {если нулевая глава в первичном виде}
      UseParaBible := false;
    {AlekId:?? уже было вроде}
    if (MainBook.HasOldTestament and (book < 40)) and (not
      SecondBook.HasOldTestament) then
      UseParaBible := false;
    {если модуль содержит НЗ и нужно отобразить новозаветную книгу, а
    в во вторичном ее нет}
    if (MainBook.HasNewTestament and
      (((book > 0) and (MainBook.BookQty = 27)) or ((book > 39) and
      (MainBook.BookQty >= 66))))
      and (not SecondBook.HasNewTestament) then
      UseParaBible := false;
  end;
  if UseParaBible then begin
    if ((length(SecondBook.FontName) > 0))
      or (SecondBook.DesiredCharset > 2) then
      fontName := SuggestFont(SecondBook.FontName, SecondBook.Path,
        SecondBook.DesiredCharset)
    else fontName := mBrowserDefaultFontName;
    Browser.DefFontName := fontName;
  end;

  // Обработка текста по стихам
  text := MainBook.ChapterHead;

//  if (not MainBook.isBible) or (not UseParaBible) then
  for verse := bverse to everse do
  begin
    s := MainBook.Lines[verse - 1];
    if (highlight_verse.x>0) and (highlight_verse.y>0) then
    begin
    hlCurrent:=(verse<=highlight_verse.y) and (verse>=highlight_verse.x);
    end
    else if highlight_verse.x>0 then hlCurrent:=verse=highlight_verse.x
    else if highlight_verse.y>0 then hlCurrent:=verse=highlight_verse.y
    else hlCurrent:=false;
    if hlCurrent then begin
      hlstyle := 'background-color:'+g_VerseBkHlColor+';display:inline;';
      hlParaStart := '<span style="' + hlstyle + '">';
      hlParaEnd := '</span>';
    end else begin hlparaStart := ''; hlParaEnd := ''; hlstyle := ''; end;

    strVerseNumber := StrDeleteFirstNumber(s);

    //if (verse = fromverse) and (verse <> 1) then
    //  s0 := '<font color=' + SelTextColor + '>&gt;&gt;&gt;' + s0 + '</font>';

    if MainBook.isBible then begin
      strVerseNumber := '<a href="verse ' + strVerseNumber
        + '" CLASS=OmegaVerseNumber>' + //style="font-family:' + 'Helvetica">' +
        strVerseNumber + '</a>';
      if MainBook.NoForcedLineBreaks then
        strVerseNumber := '<sup>' + strVerseNumber + '</sup>';
    end;

    if MainBook.StrongNumbers then
    begin
      if (not StrongNumbersOn) then
        s := DeleteStrongNumbers(s)
      else
        s := FormatStrongNumbers(s, (MainBook.CurBook < 40) and
          (MainBook.HasOldTestament), true);
    end;
    //если модуль НЕбиблейский или нет вторичной Библии
    if (not MainBook.isBible) or (not UseParaBible) then
    begin                               // no satellite text
      if mainbook_right_aligned then
        text := text +
          WideFormat(#13#10'<DIV STYLE="text-align:right; %s"><F>%s</F><a name="%d">%s</a></DIV>',
          [hlstyle, s, verse, strVerseNumber])
      else begin
        if (MainBook.isBible) and (not MainBook.NoForcedLineBreaks) then
          text := text + WideFormat(#13#10'%s<a name="bqverse%d">%s <F>%s</F>%s</a>',
            [hlParaStart, verse,
            strVerseNumber, s, hlParaEnd])
        else
          text := text +
            WideFormat(#13#10'<div STYLE="text-align:justify; %s"><a name="bqverse%d">%s <F>%s</F></a></div>', [hlstyle, verse,
            strVerseNumber, s]);
        text := text + paragraph;
      end;
    end
    else
    begin
      if UseParaBible then
      begin                             // если найден подходящий текст во вторичной Библии
        try
          // синхронизация мест
          with MainBook do
            AddressToInternal(CurBook, CurChapter, verse, b, c, v);
          SecondBook.InternalToAddress(b, c, v, ib, ic, iv);

          if (ib <> SecondBook.CurBook) or (ic <> SecondBook.CurChapter)
            or (not opened) then
          begin
            SecondBook.OpenChapter(ib, ic);
            opened := true;
          end;
        except
          UseParaBible := false;
        end;
        //коррекция номера стиха снизу
        if iv <= 0 then
          iv := 1;
        if mainbook_right_aligned then
          fistBookCell := '<table width=100% border=0 cellspacing=5 cellpadding=0>'
            + '<tr style="' + hlstyle + '"><td valign=top width=50% align=right>'
            + WideFormat(#13#10'<a name="bqverse%d">%s <F>%s</F> ', [verse,
            strVerseNumber, s])
        else
          fistBookCell := '<table width=100% border=0 cellspacing=5 cellpadding=0>'
            + '<tr style="' + hlstyle + '"><td valign=top width=50% align=left>'
            + WideFormat(#13#10'<a name="bqverse%d">%s<F> %s</F></a>', [verse,
            strVerseNumber, s]);
        SecondbookCell := '';
        // если номер стиха в во вторичной библии не более кол-ва стихов
        if iv <= SecondBook.Lines.Count then
        begin
          ss := SecondBook.Lines[iv - 1];
          StrDeleteFirstNumber(ss);
          if SecondBook.StrongNumbers then ss := DeleteStrongNumbers(ss);
          if secondbook_right_aligned then
            SecondbookCell :=
              WideFormat('</td><td valign=top width=50%% align=right><font size=1>%d:%d</font><font face="%s">%s</font>',
              [ic, iv, fontname, ss]) + '</td></tr></table><p>' + #13#10
          else
            SecondbookCell :=
              WideFormat('</td><td valign=top width=50%%><font face="Arial" size=1>%d:%d </font><font face="%s">%s</font>',
              [ic, iv, fontname, ss]) + '</td></tr></table><p>' + #13#10;
        end;
        if length(SecondbookCell) <= 0 then
          SecondbookCell :=
            '</td><td valign=top width=50%></td></tr><table><p>';
        text := text + fistBookCell + SecondbookCell;

      end;
    end;
    //  memos...
    if MemosOn then
    begin                               //если всключены заметки
      with MainBook do                  // search for 'RST Быт.1:1 $$$' in Memos.
        i := FindString(Memos, ShortName + ' ' + ShortPassageSignature(CurBook,
          CurChapter, verse, verse) + ' $$$');

      if i > -1 then                    // found memo
        text := text + '<font color=' + SelTextColor + '>' + Comment(Memos[i]) +
          '</font>' + paragraph;
    end;                                // если включены заметки
  end;                                  // цикл итерации по стихам

  dBrowserSource := TextTemplate;
  StrReplace(dBrowserSource, '%HEAD%', head, false);
  StrReplace(dBrowserSource, '%TEXT%', text, false);
  if ((length(MainBook.FontName) > 0) and (MainBook.FontName =
    Browser.DefFontName)) then
    fontName := MainBook.FontName
  else fontname := '';
  //если указан шрифт и он еще не выбран в свойвах браузера или указана кодировка
  if (length(fontname) <= 0) and ((length(MainBook.FontName) > 0) or
    (MainBook.DesiredCharset > 2)) then
    fontName := SuggestFont(MainBook.FontName, MainBook.Path,
      MainBook.DesiredCharset);
  if length(fontName) <= 0 then fontName := mBrowserDefaultFontName;
  Browser.DefFontName := fontName;
  StrReplace(dBrowserSource, '<F>', '<font face="' + fontName + '">', true);
  StrReplace(dBrowserSource, '</F>', '</font>', true);
  {*/Обработка шрифтов*}

  dBrowserSource := '<HTML>' + title + dBrowserSource + '</HTML>';
  Browser.Base := MainBook.Path;

  //  if MainBook.FontCharset = -1
  //  then Browser.CharSet := DefaultCharset
  //  else Browser.Charset := MainBook.FontCharset;

  Browser.LoadFromString(dBrowserSource);

  Browser.Position := 0;
  multiHl:=(highlight_verse.x>0) AND (highlight_verse.y>0);
  if highlight_verse.x>0 then verse:=highlight_verse.x
  else if highlight_verse.y>0 then verse:=highlight_verse.y
  else verse:=0;

  if (verse>0) then
    Browser.PositionTo('bqverse' + IntToStr(verse), not multiHl);

  VersePosition := verse;

  s := MainBook.ShortName + ' '
    + MainBook.FullPassageSignature(book, chapter, fromverse, toverse);
  lbTitleLabel.Font.Name := fontName;
  lbTitleLabel.Caption := s;

  lbTitleLabel.Hint := s + '   ';
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
  MainBook.Lines.Clear(); SecondBook.Lines.Clear();
  lbCopyRightNotice.Caption := s;
  try
    GetActiveTabInfo().mwsCopyrightNotice := s;
  except end;
  {  if Length(lbTitleLabel.Hint) < 83 then
      lbTitleLabel.Caption := lbTitleLabel.Hint
    else
      lbTitleLabel.Caption := Copy(lbTitleLabel.Hint, 1, 80) + '...';}
  //  lbTitleLabel.Font.Style := [fsBold];
  CopyrightButton.Hint := s;
  //MainStatusBar.SimpleText := s;
  //XrefTab.Tag := fromverse;
  //ShowXref;
  //ShowComments;
  //ActiveControl := Browser;

end;
{procedure TMainForm.SaveBookNodes;
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
end;                           }

procedure TMainForm.SaveButtonClick(Sender: TObject);
var
  s: WideString;
begin
  SaveFileDialog.DefaultExt := '.htm';
  SaveFileDialog.Filter := 'HTML (*.htm,*.html)|*.htm;*.html';

  s := Browser.DocumentTitle;
  SaveFileDialog.FileName := DumpFileName(s) + '.htm';

  if SaveFileDialog.Execute then
  begin
    WChar_WriteHtmlFile(SaveFileDialog.FileName, Browser.DocumentSourceUtf16);
    SaveFileDialog.InitialDir := WideExtractFilePath(SaveFileDialog.FileName);
  end;
end;

procedure TMainForm.GoButtonClick(Sender: TObject);
begin
  BookLB.ItemIndex := MainBook.CurBook - 1;
  ChapterLB.ItemIndex := MainBook.CurChapter - 1;

  if ChapterLB.ItemIndex < 0 then
    ChapterLB.ItemIndex := 0;

  if not MainPages.Visible then
    ToggleButton.Click;
  MainPages.ActivePage := GoTab;
  ActiveControl := GoEdit;
end;

procedure TMainForm.CopyButtonClick(Sender: TObject);
var
  s: WideString;
  trCount: integer;
begin
  trCount := 7;
  repeat try
      if (Browser.SelLength <> 0) or ((Browser.SelLength = 0) and (Browser.Tag
        <>
        bsText)) then
      begin
        Browser.CopyToClipboard;
        if not (CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then begin
          if Browser.Tag <= bsText then
          begin
            s := TntClipboard.AsText;
            StrReplace(s, #13#10, ' ', true);
          // carriage returns are replaced by space
            StrReplace(s, '  ', ' ', true);
      // double spaces are replaced by single space
            TntClipboard.AsText := s;
          end
          else TntClipboard.AsText := CopyPassage(CurFromVerse, CurToVerse);
        end
      end;
      trCount := 0;
    except Dec(trCount); sleep(100); end;
  until trCount <= 0;
//  ConvertClipboard;
end;

procedure TMainForm.FirstBrowserFileBrowse(Sender, Obj: TObject; var S: string);
begin
  //
end;

procedure TMainForm.FirstBrowserHotSpotClick(Sender: TObject; const SRC: string;
  var Handled: Boolean);
var
  //  tb, tc, tv,
  num, code, first, last: integer;
  scode, unicodeSRC: WideString;
  cb: THTMLViewer;
  lr: boolean;
  ws: WideString;
  iscontrolDown: boolean;

begin

  unicodeSRC := UTF8Decode(SRC);
  iscontrolDown := IsDown(VK_CONTROL);
  if Pos('go ', unicodeSRC) = 1 then
    {// гиперссылка на стих}
  begin
    if iscontrolDown then begin
      if Browser.LinkAttributes.Count > 1 then begin
        ws := Browser.LinkAttributes[1];
        first := Pos('bqResLnk', ws);
        if first > 0 then begin
          ws := Copy(ws, first + 8, $FF);
          LoadBibleToXref(unicodeSRC, ws);
          handled := true;
          exit;
        end
      end
    end;
    if IsDown(VK_MENU) then
      NewViewTab(unicodeSRC, '',
        miStrong.Checked,
        miMemosToggle.Checked, miRecognizeBibleLinks.Checked) else
      ProcessCommand(unicodeSRC, hlDefault);
    Handled := true;
  end

  else if Pos('http://', unicodeSRC) = 1 then {// WWW}
  begin
    if WStrMessageBox(WideFormat(Lang.Say('GoingOnline'), [unicodeSRC]), 'WWW',
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
    XrefTab.Tag := StrToInt(Copy(unicodeSRC, 7, Length(unicodeSRC) - 6));
    CommentsTab.Tag := XrefTab.Tag;

    //    MainBook.KJV2RST(MainBook.CurBook, MainBook.CurChapter, XrefTab.Tag, tb,tc,tv);

    //    ShowMessage('This verse can be RST ' + IntToStr(tb) + ' ' +
    //      IntToStr(tc) + ' ' + IntToStr(tv));

    with MainBook do
      HistoryAdd(
        WideFormat(
        'go %s %d %d %d %d $$$%s %s',
        [
        ShortPath,
          CurBook,
          CurChapter,
          XrefTab.Tag,
          0,
          // history comment
        ShortName,
          FullPassageSignature(CurBook, CurChapter, XrefTab.Tag, 0)
          ]
          )
        );

    if iscontrolDown or (MainPages.Visible and (MainPages.ActivePage = CommentsTab)) then
      ShowComments
    else
    begin
      try
        ShowXref;
      finally
        ShowComments;
      end;
    end;

    if not MainPages.Visible then
      ToggleButton.Click;
    if ((MainPages.ActivePage <> XrefTab) or iscontrolDown) and (MainPages.ActivePage <>
      CommentsTab) then
      if iscontrolDown then MainPages.ActivePage := CommentsTab
      else MainPages.ActivePage := XrefTab;
  end
  else if Pos('s', unicodeSRC) = 1 then
  begin
    scode := Copy(unicodeSRC, 2, Length(unicodeSRC) - 1);
    Val(scode, num, code);
    if code = 0 then
      DisplayStrongs(num, (MainBook.CurBook < 40) and
        (MainBook.HasOldTestament));
  end
  else begin
    cb := sender as THTMLViewer;
    if Pos('BQNote', cb.LinkAttributes.Text) > 0 then begin
      Handled := true;
      lr := LoadAnchor(XRefBrowser, unicodeSRC, cb.CurrentFile, cb.HTMLExpandFilename(src));
      if lr then begin
        if not MainPages.Visible then ToggleButton.Click;
        MainPages.ActivePage := XrefTab;
      end;

    end;
  end                                   //else
  // во всех остальных случаях ссылка обрабатывается по правилам HTML :-)
end;

procedure TMainForm.FirstBrowserHotSpotCovered(Sender: TObject;
  const SRC: string);
var
  unicodeSRC: WideString;
  wstr, ws2, fontName, replaceModPath: WideString;
  bl: TBibleLink;
  ti: TViewTabInfo;
  br: THTMLViewer;
  bible: TBible;
  modIx, status: integer;
begin
  br := Sender as THTMLViewer;
  if src = '' then begin
    br.Hint := '';
    TntControl_SetHint(Browser, '');
    Application.CancelHint();
    exit
  end;

  unicodeSRC := UTF8Decode(SRC);
  wstr := DeleteFirstWord(unicodeSRC);
  if WideCompareText(wstr, 'go') <> 0 then exit;

  if length(wstr) <= 0 then exit;
  ti := GetActiveTabInfo();

  if (br <> Browser) and (ti.mBible.isBible) then
    replaceModPath := ti.mBible.ShortPath
  else begin
    modIx := mModules.FindByName(ti.mSatelliteName);
    if modIx >= 0 then begin
      replaceModPath := mModules[modIx].wsShortPath;
    end;
  end;
  if (replaceModPath = '') then begin
    br.Hint := '';
    TntControl_SetHint(Browser, 'Выберите библейский модуль' +
      ' для просмотра, или укажите параллельную Библию');
    exit;
  end;
  unicodeSRC := WideStringReplace(unicodeSRC, C__bqAutoBible, replaceModPath, []);
  status := GetModuleText(unicodeSRC, fontName, bl, ws2, [gmtBulletDelimited, gmtLookupRefBibles]);

  if status < 0 then wstr := '--не найдено--' else begin
    wstr := mRefenceBible.ShortPassageSignature(bl.book, bl.chapter,
      bl.vstart, bl.vend) +' (' +mRefenceBible.ShortName +')'#13#10;
    if ws2 <> '' then
      wstr := wstr + ws2
    else wstr := wstr + '--не найдено--';
  end;
  HintWindowClass := bqHintTools.TbqHintWindow;
  br.Hint := wstr;
  TntControl_SetHint(br, wstr);
  Application.CancelHint();
end;

procedure TMainForm.FirstBrowserImageRequest(Sender: TObject; const SRC: string;
  var Stream: TMemoryStream);
var
  vti: TViewTabInfo;
  archive: WideString;
  ix, sz: integer;
{$J+}
const
  ms: TMemoryStream = nil;
{$J-}
begin
  try
    vti := TabInfoFromBrowser(sender as THTMLViewer);

    if not assigned(vti) then
      exit;
    archive := vti.mBible.IniFile;
    if (length(archive) <= 0) or (archive[1] <> '?') then
      exit;
    getSevenZ().SZFileName := Copy(GetArchiveFromSpecial(archive), 2, $FFFFFF);
    ix := getSevenZ().GetIndexByFilename(SRC, @sz);
    if ix = 0 then
      exit;
    if not assigned(ms) then
      ms := TMemoryStream.Create;
    ms.Size := sz;
    getSevenZ().ExtracttoMem(ix, ms.Memory, ms.Size);
    if getSevenZ().ErrCode = 0 then
      Stream := ms;
  except
  end;
end;

(*AlekId:Добавлено*)

function TMainForm.ActivateFont(const fontPath: WideString): DWORD;
var
  tf: array[0..1023] of WideChar;
  fileIx, fileSz, tempPathLen: integer;
  wsArchive, wsFile: WideString;
  pFile: PChar;
  fileHandle: THandle;
  writeResult: BOOL;
  fileNeedsCleanUp: boolean;
  fontHandle: HFont;
  bytesWritten: DWORD;
begin
  result := 0;
  fontHandle := 0;
  FileNeedsCleanUp := false;
  wsArchive := fontPath;
  if fontPath[1] = '?' then
  begin
    wsArchive := GetArchiveFromSpecial(fontPath, wsFile);
    fileIx := getSevenZ().GetIndexByFilename(wsFile, @fileSz);
    if (fileIx < 0) or (fileSz <= 0) then exit;
    GetMem(pFile, fileSz);
    fileHandle := INVALID_HANDLE_VALUE;
    try
      getSevenZ().ExtracttoMem(fileIx, pFile, fileSz);
      if getSevenZ().ErrCode <> 0 then exit;
      if (Win32MajorVersion >= 5) and (assigned(G_AddFontMemResourceEx)) then
      begin
        fontHandle := G_AddFontMemResourceEx(pFile, fileSz, nil, @result);
      end;
      if result = 0 then
      begin                             //старая ось или не удалось в память
        tempPathLen := GetTempPathW(1023, tf);
        if tempPathLen > 1024 then exit;
        wsArchive := tf + wsFile;
        if not FileExists(wsArchive) then begin
          fileHandle := CreateFileW(PWideChar(Pointer(wsArchive)),
            GENERIC_WRITE,
            0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
          if fileHandle = INVALID_HANDLE_VALUE then exit;
          try
            writeResult := WriteFile(fileHandle, pFile^, fileSz, bytesWritten,
              nil);
          finally CloseHandle(fileHandle); end;
          fileNeedsCleanUp := true;
          if not writeResult then exit;
        end;
      end                               //если старая ось или не удалось в память

    finally FreeMem(pFile); end;
  end                                   //если в архиве
  else wsFile := FileRemoveExtension(WideExtractFileName(fontPath));
  if result = 0 then result := AddFontResourceW(PWideChar(Pointer(wsArchive)));

  if result <> 0 then begin
   // SendMessage(HWND_BROADCAST, WM_FONTCHANGE,0,0);
    Screen.Fonts.Add(ExctractName(wsFile));
    G_InstalledFonts.AddObject(ExctractName(wsFile),
      TBQInstalledFontInfo.Create(wsArchive, FileNeedsCleanUp, fontHandle));
  end;
end;

//function TMainForm.ActiveSatteliteMenu(): TTntMenuItem;
//var
//  i: integer;
//  found: boolean;
//  count: integer;
//begin
//  Result := nil;
//  found := false;
//  try
//    count := SatelliteMenu.Items.Count - 1;
//    for i := 0 to count do
//      if (SatelliteMenu.Items[i].Checked) then
//      begin
//        Result := SatelliteMenu.Items[i] as TTntMenuItem;
//        found := true;
//        break;
//      end;
//    if (not found) then
//    begin
//      Result := SatelliteMenu.Items[0] as TTntMenuItem;
//      Result.Checked := true;
//    end;
//  except
//  end;
//
//end;

{function TMainForm.AddArchivedDictionaries(path: WideString): integer;
var F: TSearchRec;
  wIdxPath, wHTMLPath: WideString;
begin
  Result := 0;
  if FindFirst(path + '\*.bqb', faAnyFile, F) = 0 then begin
    repeat
      try
        wIdxPath := '?' + path + '\' + F.Name + '??' + Copy(F.Name, 1, length(F.Name) - 3);
        wHTMLPath := wIdxPath + 'htm';
        wIdxPath := wIdxPath + 'idx';
        if (FileExistsEx(wIdxPath) >= 0) and (FileExistsEx(wHTMLPath) >= 0) then begin
          Dics[Result] := TDict.Create;
          Dics[Result].Initialize(wIdxPath, wHTMLPath);
          Inc(Result);
        end;
      except
        ;
      end;
    until FindNext(F) <> 0;
  end;
  FindClose(F);
end;}

function TMainForm.AddArchivedModules(path: WideString; tempBook: TBible;
  background: boolean; addAsCommentaries: boolean = false): boolean;
var
  count: integer;
  mt: TModuleType;
  modEntry: TModuleEntry;

begin
  //count - либо несколько либо все
  count := C_NumOfModulesToScan + (ord(not background) shl 12);
  if not DirectoryExists(path) then
  begin
    __searchInitialized := false;
    //на всякий случай сбросить флаг активного поиска
    result := true;
    exit                                //сканирование завершено
  end;
  if (not __searchInitialized) then
  begin
    //инициализация поиска, установка флага акт. поиска
    __r := FindFirst(path + '\*.bqb', faAnyFile, __addModulesSR);
    __searchInitialized := true;
  end;

  if __r = 0 then
    repeat
      try
        tempBook.IniFile := '?' + path + '\' + __addModulesSR.Name + '??' +
          C_ModuleIniName;
        //ТИП МОДУЛЯ
        if (addAsCommentaries) then
          mt := modtypeComment
        else
        begin
          if tempBook.isBible then
            mt := modtypeBible
          else
            mt := modtypeBook;
        end;
        modEntry := TModuleEntry.Create(mt, tempBook.Name, tempBook.ShortName,
          tempBook.ShortPath, path + '\' + __addModulesSR.Name, tempBook.GetStucture(),
          tempBook.Categories);
        S_cachedModules.Add(modEntry);
        if not background then
        begin
          S_ArchivedModuleList.Names.Add(modEntry.wsFullName);
          S_ArchivedModuleList.Paths.Add(modEntry.wsFullPath);
          ModulesList.Add(tempBook.Name + ' $$$ ' + tempBook.ShortPath);
          ModulesCodeList.Add(tempBook.ShortName);
          if addAsCommentaries then
          begin
            Comments.Add(tempBook.Name);
            CommentsPaths.Add(tempBook.ShortPath);
          end
          else
          begin
            if tempBook.isBible then
              Bibles.Add(tempBook.Name)
            else
              Books.Add(tempBook.Name);
          end;
        end                             //not background
      except
        on e: TBQException do
          MessageBoxW(self.Handle, PWideChar(Pointer(e.mWideMsg)), nil,
            MB_ICONERROR or MB_OK);
      else                              {подавить!}
      end;
      __r := FindNext(__addModulesSR);
      dec(count);
    until (__r <> 0) or (count <= 0);
  if __r <> 0 then
  begin                                 //если поиск завершен
    FindClose(__addModulesSR);
    __searchInitialized := false;
    result := true;
  end
  else
    result := false;
end;

function TMainForm.AddFolderModules(path: WideString; tempBook: TBible;
  background: boolean; addAsCommentaries: boolean = false): boolean;
var
  count: integer;
  modEntry: TModuleEntry;
  mt: TModuleType;
begin
  //count - либо несколько либо все
  count := C_NumOfModulesToScan + (ord(not background) shl 12);
  if not (__searchInitialized) then
  begin                                 //инициализация поиска
    __r := FindFirst(path + '*.*', faDirectory, __addModulesSR);
    __searchInitialized := true;
  end;

  if (__r = 0) then                     // если что-то найдено
    repeat
      if (__addModulesSR.Attr and faDirectory = faDirectory) and
        ((__addModulesSR.Name <> '.') and (__addModulesSR.Name <> '..')) and
        FileExists(path + __addModulesSR.Name + '\bibleqt.ini') then
      begin
        try
          tempBook.IniFile := path + __addModulesSR.Name + '\bibleqt.ini';
          //ТИП МОДУЛЯ
          if (addAsCommentaries) then
            mt := modtypeComment
          else
          begin
            if tempBook.isBible then
              mt := modtypeBible
            else
              mt := modtypeBook;
          end;

          modEntry := TModuleEntry.Create(mt, tempBook.Name, tempBook.ShortName,
            tempBook.ShortPath, EmptyWideStr, tempBook.GetStucture(), tempBook.Categories);
          S_cachedModules.Add(modEntry);

          {f}if not (background) then
          begin
            {o}ModulesList.Add(tempBook.Name + ' $$$ ' + tempBook.ShortPath);
            {r}ModulesCodeList.Add(tempBook.ShortName);
            {e}if addAsCommentaries then
            begin
              {g}Comments.Add(tempBook.Name);
              {r}CommentsPaths.Add(tempBook.ShortPath);
              {o}
            end
              {u}
            else
            begin
              {n}if tempBook.isBible then
                Bibles.Add(tempBook.Name)
                  {d}
              else
                Books.Add(tempBook.Name);
              { }
            end;
          end;                          //if not background
        except
        end;
      end;                              //if directory
      dec(count);
      __r := FindNext(__addModulesSR);
    until (__r <> 0) or (count <= 0);
  if (__r <> 0) then
  begin                                 //если сканирование завершено
    FindClose(__addModulesSR);
    __searchInitialized := false;
    result := true                      // то есть сканирование завершено
  end
  else
    result := false;                    // нужен повторный проход
end;
(*AlekId:/Добавлено*)

function TMainForm.AddHotModule(const modEntry: TModuleEntry; tag: integer;
  addBibleTab: boolean = true): integer;
var
  favouriteMenuItem, hotMenuItem: TTntMenuItem;
  ix: integer;
  shortName: WideString;
begin
  Result := -1;
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    if not Assigned(favouriteMenuItem) then
      exit;
    hotMenuItem := TTntMenuItem.Create(self);
    hotMenuItem.Tag := tag;
    hotMenuItem.Caption := modEntry.wsFullName;
    hotMenuItem.OnClick := HotKeyClick;
    favouriteMenuItem.Add(hotMenuItem);
    if not addBibleTab then
      exit;
    ix := mBibleTabsEx.WideTabs.Count - 1;

    mBibleTabsEx.WideTabs.Insert(ix, modEntry.VisualSignature());
    mBibleTabsEx.WideTabs.Objects[ix] := modEntry;
//     mBibleTabsEx.WideTabs.Objects[tag] :=modEntry;
  except
    on e: Exception do begin BqShowException(e); end;
  end;
end;
(*AlekId:/Добавлено*)

procedure TMainForm.AddressOKButtonClick(Sender: TObject);
var
  offset: integer;
  //  Lines: TWideStrings;
begin
  if true {not AddressFromMenus} then
  begin
    GoEditDblClick(Sender);
    Exit;
  end;

  {
  //JUNKY STUFF :-)
  //GUESS WHAT!
    if MainBook.ShortPath = 'rststrong' then
    begin
      Lines := TWideStringList.Create;
      for offset:= 1 to 66 do
      Lines.Add('''' + MainBook.VarShortNames[offset] + ''',');

      Lines.SaveToFile('c:\out.txt');
    end;
  }
  {  LinksCB.Visible := false;}tbLinksToolbar.Visible := false;

end;

procedure TMainForm.GoPrevChapter;
var
  cmd: WideString;
begin
  if PreviewBox.Visible then
  begin
    if CurPreviewPage > 0 then
      CurPreviewPage := CurPreviewPage - 1;
    Exit;
  end;

  if not PrevChapterButton.Enabled then
    Exit;

  with MainBook do
    if CurChapter > 1 then
      cmd := WideFormat('go %s %d %d', [ShortPath, CurBook, CurChapter - 1])
    else if CurBook > 1 then
      cmd := WideFormat('go %s %d %d', [ShortPath, CurBook - 1,
        ChapterQtys[CurBook - 1]]);

  HistoryOn := false;
  ProcessCommand(cmd, hlFalse);
  HistoryOn := true;

  //  ShowXref;
  CommentsTab.Tag := 0;
  ShowComments;
  ActiveControl := Browser;
end;

procedure TMainForm.GoNextChapter;
var
  cmd: WideString;
begin
  if PreviewBox.Visible then
  begin
    if CurPreviewPage < MFPrinter.LastAvailablePage - 1 then
      CurPreviewPage := CurPreviewPage + 1;
    Exit;
  end;

  if not NextChapterButton.Enabled then
    Exit;

  with MainBook do
    if CurChapter < ChapterQtys[CurBook] then
      cmd := WideFormat('go %s %d %d', [ShortPath, CurBook, CurChapter + 1])
    else if CurBook < BookQty then
      cmd := WideFormat('go %s %d %d', [ShortPath, CurBook + 1, 1]);

  HistoryOn := false;
  ProcessCommand(cmd, hlFalse);
  HistoryOn := true;

  //  ShowXref;
  CommentsTab.Tag := 0;
  ShowComments;
  ActiveControl := Browser;
end;

procedure SetButtonHint(aButton: TTntToolButton; aMenuItem: TTntMenuItem);
begin
  aButton.Hint := aMenuItem.Caption + ' (' + ShortCutToText(aMenuItem.ShortCut)
    +
    ')';
end;

procedure TMainForm.TranslateInterface(inifile: WideString);
var
  i: integer;
  s: WideString;
  fnt: TFont;
begin

  try
    if not Lang.LoadIniFile(ExePath + inifile) then
      Lang.LoadIniFile(miLanguage.Items[0].Caption + '.lng');
  except on e: Exception do begin
      BqShowException(e, 'In translate interface hard error');
      exit;
    end end;

  UpdateDictionariesCombo();
  if Assigned(frmQNav) then
    Lang.TranslateForm(frmQNav);
  for i := 0 to miLanguage.Count - 1 do
    with miLanguage.Items[i] do
      Checked := WideLowerCase(Caption + '.lng') = WideLowerCase(inifile);

  if Assigned(ConfigForm) then
  begin
    Lang.TranslateForm(ConfigForm);

    ConfigForm.CopyVerseNumbers.Checked := CopyOptionsCopyVerseNumbersChecked;
    ConfigForm.CopyFontParams.Checked := CopyOptionsCopyFontParamsChecked;
    ConfigForm.AddReference.Checked := CopyOptionsAddReferenceChecked;
    ConfigForm.AddReferenceRadio.ItemIndex :=
      CopyOptionsAddReferenceRadioItemIndex;
    ConfigForm.AddLineBreaks.Checked := CopyOptionsAddLineBreaksChecked;
    ConfigForm.AddModuleName.Checked := CopyOptionsAddModuleNameChecked;
    ConfigForm.AddReferenceRadio.Items[0] :=
      Lang.Say('CopyOptionsAddReference_ShortAtBeginning');
    ConfigForm.AddReferenceRadio.Items[1] :=
      Lang.Say('CopyOptionsAddReference_ShortAtEnd');
    ConfigForm.AddReferenceRadio.Items[2] :=
      Lang.Say('CopyOptionsAddReference_FullAtEnd');

    ConfigForm.FavouriteExTabSheet.Caption := Lang.SayDefault(
      'ConfigForm.FavouriteExTabSheet.Caption', 'Любимые модули');
    ConfigForm.lblAvailableModules.Caption := Lang.SayDefault(
      'ConfigForm.lblAvailableModules.Caption', 'Модули');
    ConfigForm.lblFavourites.Caption := Lang.SayDefault(
      'ConfigForm.lblFavourites.Caption', 'Избранные модули');

  end;

  Lang.TranslateForm(MainForm);

{  CBPartsCaptions[1] := CBParts.Caption;
  CBAllCaptions[1] := CBAll.Caption;
  CBCaseCaptions[1] := CBCase.Caption;
  CBPhraseCaptions[1] := CBPhrase.Caption;

  CBPartsCaptions[0] := Lang.Say('CBPartsNotCaption');
  CBAllCaptions[0] := Lang.Say('CBAllNotCaption');
  CBCaseCaptions[0] := Lang.Say('CBCaseNotCaption');
  CBPhraseCaptions[0] := Lang.Say('CBPhraseNotCaption');}

  miCopySelection.Caption := miCopy.Caption;

  // initialize Toolbar
  SetButtonHint(ToggleButton, miToggle);

  //SetButtonHint(PrevChapterButton, miPrevChapter);
  //SetButtonHint(NextChapterButton, miNextChapter);
  SetButtonHint(CopyButton, miCopy);
  //SetButtonHint(BookmarkButton, miBookmark);
  //SetButtonHint(HistoryButton, miHistory);
  SetButtonHint(PrintButton, miPrint);
  SetButtonHint(PreviewButton, miPrintPreview);
  SetButtonHint(SoundButton, miSound);

  SetButtonHint(StrongNumbersButton, miStrong);
  SetButtonHint(NewTabButton, miNewTab);
  SetButtonHint(CloseTabButton, miCloseTab);

  MemosButton.Hint := miMemosToggle.Caption + ' (' +
    ShortCutToText(miMemosToggle.ShortCut) + ')';

  ;

  //BackButton.Hint := miGoBack.Caption + ' (Backspace)';

  CBList.ItemIndex := 0;

  if Lang.Say('HelpFileName') <> 'HelpFileName' then
    HelpFileName := Lang.Say('HelpFileName');

  Application.Title := MainForm.Caption;
  TrayIcon.Hint := MainForm.Caption;

  if MainBook.IniFile <> '' then
  begin
    with MainBook do
      s := ShortName + ' ' + FullPassageSignature(CurBook, CurChapter,
        CurFromVerse, CurToVerse);

    if MainBook.Copyright <> '' then
      s := s + '; © ' + MainBook.Copyright
    else
      s := s + '; ' + Lang.Say('PublicDomainText');

    lbTitleLabel.Hint := s + '   ';

    if Length(lbTitleLabel.Hint) < 83 then
      lbTitleLabel.Caption := lbTitleLabel.Hint
    else
      lbTitleLabel.Caption := Copy(lbTitleLabel.Hint, 1, 80) + '...';

    lbTitleLabel.Font.Style := [fsBold];

    CopyrightButton.Hint := s;

    UpdateBooksAndChaptersBoxes();
    SearchListInit;
  end;

  if Copy(SearchInWindowLabel.Caption, 1, 4) <> '    ' then
    SearchInWindowLabel.Caption := '    ' + SearchInWindowLabel.Caption;

  fnt := TFont.Create;
  fnt.Name := MainForm.Font.Name;
  fnt.Size := MainForm.Font.Size;

  //s := Lang.Say('Charset');
  //if s = 'Charset' then s:='204';
  //fnt.Charset := StrToInt(s);

  MainForm.Font := fnt;

  Update;
  fnt.Free;
end;

procedure TMainForm.ChapterComboBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    AddressFromMenus := true;
    NavigateToInterfaceValues();
  end;
end;

procedure TMainForm.PrintButtonClick(Sender: TObject);
begin
  with PrintDialog1 do
    if Execute then
      Browser.Print(MinPage, MaxPage);
end;

// --------- preview begin

var
  refvisible: boolean;

procedure TMainForm.EnableMenus(aEnabled: Boolean);
var
  i: integer;
begin
  for i := 0 to MainForm.ComponentCount - 1 do
  begin
    if MainForm.Components[i] is TTntMenuItem then
      (MainForm.Components[i] as TTntMenuItem).Enabled := aEnabled;
  end;
end;

procedure TMainForm.PreviewButtonClick(Sender: TObject);
begin
  if PreviewBox.Visible then
  begin
    EnableMenus(true);

    PreviewBox.Visible := false;

    MainPanel.Visible := true;
    ActiveControl := Browser;

    MainPages.Visible := refvisible;

    Screen.Cursor := crDefault;
  end
  else
  begin
    refvisible := MainPages.Visible;




    MFPrinter := TMetaFilePrinter.Create(Self);
    Browser.PrintPreview(MFPrinter);

    ZoomIndex := 0;
    CurPreviewPage := 0;

    PreviewBox.OnResize := nil;

    MainPages.Visible := false;

    MainPanel.Visible := false;
    PreviewBox.OnResize := PreviewBoxResize;

    PreviewBox.Align := alClient;
    EnableMenus(false);
    miFile.Enabled := true;
    miPrintPreview.Enabled := true;
    PreviewBox.Visible := true;

    PB1.Cursor := crHandPoint;
  end;
end;

procedure TMainForm.PreviewBoxResize(Sender: TObject);
const
  BORD = 20;
var
  z: double;
  tmp, TotWid: integer;
begin
  case ZoomIndex of
    0: z := ((PreviewBox.ClientHeight - BORD) / PixelsPerInch) /
      (MFPrinter.PaperHeight / MFPrinter.PixelsPerInchY);
    1: z := ((PreviewBox.ClientWidth - BORD) / PixelsPerInch) /
      (MFPrinter.PaperWidth / MFPrinter.PixelsPerInchX);
    2: z := Zoom;
    3: z := 0.25;
    4: z := 0.50;
    5: z := 0.75;
    6: z := 1.00;
    7: z := 1.25;
    8: z := 1.50;
    9: z := 2.00;
    10: z := 3.00;
    11: z := 4.00;
  else
    z := 1;
  end;

  PagePanel.Height := TRUNC(PixelsPerInch * z * MFPrinter.PaperHeight /
    MFPrinter.PixelsPerInchY);
  PagePanel.Width := TRUNC(PixelsPerInch * z * MFPrinter.PaperWidth /
    MFPrinter.PixelsPerInchX);

  TotWid := PagePanel.Width + BORD;

  // Resize the Contain Panel
  tmp := PagePanel.Height + BORD;
  if tmp < PreviewBox.ClientHeight then
    tmp := PreviewBox.ClientHeight - 1;
  ContainPanel.Height := tmp;

  tmp := TotWid;
  if tmp < PreviewBox.ClientWidth then
    tmp := PreviewBox.ClientWidth - 1;
  ContainPanel.Width := tmp;

  // Center the Page Panel
  if PagePanel.Height + BORD < ContainPanel.Height then
    PagePanel.Top := ContainPanel.Height div 2 - PagePanel.Height div 2
  else
    PagePanel.Top := BORD div 2;

  if TotWid < ContainPanel.Width then
    PagePanel.Left := ContainPanel.Width div 2 - (TotWid - BORD) div 2
  else
    PagePanel.Left := BORD div 2;

  {Make sure the scroll bars are hidden if not needed}
  if (PagePanel.Width + BORD <= PreviewBox.Width) and
    (PagePanel.Height + BORD <= PreviewBox.Height) then
  begin
    PreviewBox.HorzScrollBar.Visible := False;
    PreviewBox.VertScrollBar.Visible := False;
  end
  else
  begin
    PreviewBox.HorzScrollBar.Visible := True;
    PreviewBox.VertScrollBar.Visible := True;
  end;

  Zoom := z;
end;

procedure TMainForm.SetBibleTabsHintsState(showHints: boolean);
var
  i, num, bibleTabsCount, curItem: integer;
  s: WideString;
  //  hotModuleMenuItem: TtntMenuItem;
  saveOnChange: TTabChangeEvent;
begin
  bibleTabsCount := mBibleTabsEx.WideTabs.Count - 1;
  curItem := mBibleTabsEx.TabIndex;
  if bibleTabsCount > 9 then
    bibleTabsCount := 9
  else
    Dec(bibleTabsCount);
  for i := 0 to bibleTabsCount do
  begin
    s := mBibleTabsEx.WideTabs[i];
    if showHints then
    begin
      if (i < 9) then
        num := i + 1
      else
        num := 0;
      mBibleTabsEx.WideTabs[i] := WideFormat('%d-%s', [num, s]);
    end
    else
    begin
      if (s[2] <> '-') or (not (Char(s[1]) in ['0'..'9'])) then
        break;
      mBibleTabsEx.WideTabs[i] := Copy(s, 3, $FFFFFF);
    end;
  end;                                  //for

  if showHints then
  begin
    mBibleTabsEx.FirstIndex := 0;
    mBibleTabsEx.TabIndex := curItem;
  end
  else
  begin
    saveOnChange := mBibleTabsEx.OnChange;
    mBibleTabsEx.OnChange := nil;
    if curItem > 0 then
      mBibleTabsEx.TabIndex := curItem - 1;
    mBibleTabsEx.TabIndex := curItem;
    mBibleTabsEx.OnChange := saveOnChange;
  end;

  mBibleTabsInCtrlKeyDownState := showHints;
end;

procedure TMainForm.SetCurPreviewPage(Val: integer);
begin
  FCurPreviewPage := Val;
  PB1.Invalidate;
end;

{AlekId: добавлено}{назначение горячих клавиш любимым модулям}

procedure TMainForm.SetFavouritesShortcuts();
var
  favouriteMenuItem, hotMenuItem: TTntMenuItem;
  i, j, hotCount: integer;
begin
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    hotcount := favouriteMenuItem.Count - 1;
    j := 0;
    for i := 0 to hotCount do
    begin
      hotMenuItem := favouriteMenuItem.items[i] as TTntMenuItem;
      if hotMenuItem.Tag < 7000 then
        continue;
//      hotMenuItem.Tag := 7000 + j;
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

procedure TMainForm.SetFirstTabInitialLocation(wsCommand,
  wsSecondaryView: WideString; showStrongs, showNotes, resolveLinks: boolean);
var
  menuItem: TTntMenuItem;
  vti: TViewTabInfo;
begin
  if length(wsCommand) > 0 then
    LastAddress := wsCommand;
//  menuItem := SatelliteMenuItemFromModuleName(wsSecondaryView);
//  if Assigned(menuItem) then
//    SelectSatelliteMenuItem(menuItem);
  {  if length(LastAddress)>1 then begin
     successed_load:=   ProcessCommand(LastAddress);
    // if successed_load then BooksCB.ItemIndex := BooksCB.Items.IndexOf(MainBook.Name);
    end
    else successed_load:=false;
    if not successed_load then begin
      GoModuleName(miHot1.Caption);
      b := 1; c := 1; v1 := 1; v2 := 0;
      GoAddress(b, c, v1, v2);
    end;}
//  StrongNumbersOn:=miStrong.Checked;
  try
    StrongNumbersOn := showStrongs;
    MemosOn := showNotes;
    MainBook.RecognizeBibleLinks := resolveLinks;
    vti := (TObject(mViewTabs.Pages[0].Tag) as TViewTabInfo);
    vti.mShowStrongs := showStrongs;
    vti.mShowNotes := showNotes;
    vti.mSatelliteName := wsSecondaryView;
    vti.mResolvelinks := resolveLinks;
  except end;
  SafeProcessCommand(LastAddress, hlDefault);
  UpdateUI();
end;

procedure TMainForm.SetVScrollTracker(aBrwsr: THTMLViewer);
begin
  try
    aBrwsr.VScrollBar.OnChange := self.VSCrollTracker;
  except on e: Exception do BqShowException(e) end;
end;
{procedure TMainForm.SetStrongsAndNotesState(showStrongs, showNotes: boolean;
  ti: TViewTabInfo);
begin
ti.mShowStrongs:=showStrongs;
ti.mShowNotes:=showNotes;
StrongNumbersOn:=showStrongs;
MemosOn:=showNotes;
{cti:= GetActiveTabInfo();
if assigned(cti) and cti=ti then begin

  StrongNumbersButton.Down:=showStrongs;
  miStrong.Checked:=showStrongs;
  miMemosToggle.Checked:=showNotes;
  MemosButton.Down:=showNotes;
end;
end;}

procedure TMainForm.DrawMetaFile(PB: TTntPaintBox; mf: TMetaFile);
begin
  PB.Canvas.Draw(0, 0, mf);
end;

procedure TMainForm.PB1Paint(Sender: TObject);
var
  PB: TTntPaintBox;
  Draw: boolean;
  Page: integer;
begin
  PB := Sender as TTntPaintBox;

  Draw := CurPreviewPage < MFPrinter.LastAvailablePage;
  Page := CurPreviewPage;

  SetMapMode(PB.Canvas.Handle, MM_ANISOTROPIC);
  SetWindowExtEx(PB.Canvas.Handle, MFPrinter.PaperWidth, MFPrinter.PaperHeight,
    nil);
  SetViewportExtEx(PB.Canvas.Handle, PB.Width, PB.Height, nil);
  SetWindowOrgEx(PB.Canvas.Handle, -MFPrinter.OffsetX, -MFPrinter.OffsetY, nil);
  if Draw then
    DrawMetaFile(PB, MFPrinter.MetaFiles[Page]);
end;
{AlekId:добавлено - функция отображения диалога ввода пароля}

function TMainForm.PaintTokens(canv: TCanvas; rct: TRect; tkns: TObjectList;
  calc: boolean): integer;

var
  i, c, fw, fh: integer;
  ws: WideString;
  sz: TSize;
  rects: array[0..9] of TRect;
begin
  c := tkns.Count - 1;
  if c > 9 then c := 9;

  rects[0].Left := rct.Left;
  rects[0].Right := rct.Right;
  rects[0].Top := rct.Top;
  rects[0].Bottom := rct.Bottom;
  sz := canv.TextExtent('X');
  fw := sz.cx;
  fh := canv.Font.Height;
  if fh < 0 then fh := -fh;

  for i := 0 to c do begin
    ws := TVersesNodeData(tkns[i]).getText;
    Windows.DrawTextW(canv.Handle,
      PWideChar(Pointer(ws)), -1, rects[i], DT_TOP or DT_CALCRECT or
      DT_SINGLELINE);
    if (rects[i].Right > rct.Right) and (rects[i].Left > rct.Left) then begin
      rects[i].Left := rct.Left;
      rects[i].Top := rects[i].Bottom + fh;
      Windows.DrawTextW(canv.Handle,
        PWideChar(Pointer(ws)), -1, rects[i], DT_TOP or DT_CALCRECT or
        DT_SINGLELINE);
    end;

    if i < c then begin
      rects[i + 1].Left := rects[i].RIGHT + fw * 4;
      rects[i + 1].Top := rects[i].Top;
      rects[i + 1].Bottom := rct.Bottom;
      rects[i + 1].Right := rct.Right;
    end;
  end;

  if not calc then for i := 0 to c do
      Windows.DrawTextW(canv.Handle,
        PWideChar(Pointer(ws)), -1, rects[i], DT_TOP or DT_SINGLELINE);

  result := rects[c].Bottom;

end;

function TMainForm.PassWordFormShowModal(const aModule: WideString;
  out Pwd: WideString; out savePwd: boolean): integer;
var                                     {modPath: WideString;}
  modName: WideString;
  i {, arcCount}: integer;
begin
  result := mrCancel;
  try
    i := S_ArchivedModuleList.Paths.IndexOf(aModule);
    if (i < 0) then
      modName := ' '
    else
      modName := S_ArchivedModuleList.Names[i];
    if not assigned(frmPassBox) then
      frmPassBox := TfrmPassBox.Create(self);
    with frmPassBox do
    begin
      Font.Assign(self.Font);
      lblPasswordNeeded.Caption := WideFormat(
        Lang.SayDefault('lblPasswordNeeded',
        'Для открытия модуля нужно ввести пароль (%s)'),
        [modName]);
      lblEnterPassword.Caption := Lang.SayDefault('lblPassword',
        'Пароль:');
      cbxSavePwd.Caption := Lang.SayDefault('cbxSavePwd',
        'Сохранить пароль');
      btnCancel.Caption := Lang.SayDefault('btnCancel', 'Отмена');
      edPwd.Text := '';
      cbxSavePwd.Checked := false;
      result := frmPassBox.ShowModal();
      if result = mrOk then
      begin
        Pwd := edPwd.Text;
        savePwd := cbxSavePwd.Checked;
      end;
    end;

  except
  end;

end;
{AlekId:/добавлено}

procedure TMainForm.PB1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  sx, sy: single;
  nx, ny: integer;
begin
  sx := X / PagePanel.Width;
  sy := Y / PagePanel.Height;

  if (ssLeft in Shift) and (Zoom < 20.0) then
    Zoom := Zoom * ZOOMFACTOR;
  if (ssRight in Shift) and (Zoom > 0.1) then
    Zoom := Zoom / ZOOMFACTOR;

  ZoomIndex := 2;
  PreviewBoxResize(nil);

  nx := TRUNC(sx * PagePanel.Width);
  ny := TRUNC(sy * PagePanel.Height);
  PreviewBox.HorzScrollBar.Position := nx - PreviewBox.Width div 2;
  PreviewBox.VertScrollBar.Position := ny - PreviewBox.Height div 2;
end;

// --------- preview end

function TMainForm.ProcessCommand(s: WideString; hlVerses:TbqHLVerseOption): boolean;
var
  value, dup, path, oldpath: WideString;
//  book, chapter, fromverse, toverse, focusVerse: integer;
 focusVerse: integer;
  i, j, oldbook, oldchapter: integer;
  wasSearchHistory, wasFile: boolean;
  browserpos: longint;
  offset: integer;
  dBrowserSource: WideString;
  oldSignature: WideString;
  navRslt: TbqNavigateResult;
  bibleLink: TBibleLinkEx;
label
  exitlabel;

  procedure revertToOldLocation();
  begin
    if oldpath = '' then
    begin
      oldPath := MainFileExists(mDefaultLocation + '\' + C_ModuleIniName);
      if Browser.GetTextLen() <= 0 then
      begin
        ProcessCommand(WideFormat('go %s 1 1 1', [mDefaultLocation]), hlFalse);
        exit
      end;
    end;
    MainBook.IniFile := oldpath;
    bibleLink.modName:=MainBook.ShortPath;
    bibleLink.book:=oldbook;
    bibleLink.chapter:=oldchapter;
    UpdateUI();
  end;
begin
  Result := false;

  if s = '' then
    Exit;                               //выйти, если команда пустая
  Screen.Cursor := crHourGlass;
  mInterfaceLock := true;
  try
    wasFile := false;
    browserpos := Browser.Position;
    Browser.Tag := bsText;

    oldpath := MainBook.IniFile;
    oldbook := MainBook.CurBook;
    oldchapter := MainBook.CurChapter;

    dup := s;                           //копия команды

    if bibleLink.FromBqStringLocation(dup) then
    begin
    //AlekId : search #0001

    //формируем путь к ini модуля
      if bibleLink.IsAutoBible() then begin
         dup:=PreProcessAutoCommand(dup, SecondBook.ShortPath);
         bibleLink.FromBqStringLocation(dup);
     end;


      path := MainFileExists( bibleLink.GetIniFileShortPath() );

    // ??! никогда ветвление это не сработает
      if length(path) < 1 then
        goto exitlabel;


      oldSignature := MainBook.FullPassageSignature(MainBook.CurBook,
        MainBook.CurChapter, 0, 0);

    // пытаемся подгрузить модуль
      if path <> MainBook.IniFile then
      try
        MainBook.IniFile := path;
      except                            // если что-то не так -- откат
      {MainBook.IniFile := oldpath;
      book := oldbook;
      chapter := oldchapter;}
        revertToOldLocation();
      end;
      try
//      HistoryAdjust(GetActiveTabInfo().mwsLocation,oldSignature );
      except end;

      try
      //читаем, отображаем адрес

        navRslt := GoAddress(bibleLink.book, bibleLink.chapter,
               bibleLink.vstart,bibleLink.vend);
      //записываем историю
        if navRslt > nrEndVerseErr then begin focusVerse := 0; end;

        with MainBook do
          if (bibleLink.vstart = 0) or (navRslt > nrEndVerseErr) then
          // если конечный стих не указан
  //выглядит как
  //"go module_folder book_no Chapter_no verse_start_no 0 mod_shortname

            s := WideFormat('go %s %d %d %d 0 $$$%s %s',
              [ShortPath, CurBook, CurChapter, focusverse,
            // history comment
              ShortName,
                FullPassageSignature(CurBook, CurChapter, bibleLink.vstart, 0)
                ])
          else
            s := WideFormat('go %s %d %d %d %d $$$%s %s',
              [ShortPath, CurBook, CurChapter, bibleLink.vstart, bibleLink.vend,
            // history comment
              ShortName,
                FullPassageSignature(CurBook, CurChapter, biblelink.vstart,
                   biblelink.vend)
                ]);

        HistoryAdd(s);
      (*AlekId:Добавлено*)
      //here we set proper name to tab
        with MainBook, mViewTabs do
        begin
          if Assigned(ActivePage) then
          try
            (ActivePage as TTntTabSheet).Caption := WideFormat('%.6s-%.6s:%d',
              [ShortName, ShortNames[CurBook], CurChapter - ord(ChapterZero)]);
            with (TObject(ActivePage.Tag) as TViewTabInfo) do
            begin
            //сохранить контекст
              mwsLocation := s;

            end;

          except                        //try frame
          end;
        end;                            //with MainBook, mMainViewTabs
      (*AlekId:/Добавлено*)
{
      with MainBook do
        MainStatusBar.SimpleText := StatusBarPrefix + Name + ', '
        + FullPassageSignature(CurBook,CurChapter,fromverse,toverse);
}
      //if LastAddress = s then Browser.Position := browserpos;
        LastAddress := s;
      except
        on e: TBQPasswordException do
        begin
          PasswordPolicy.InvalidatePassword(e.mArchive);
          MessageBoxW(self.Handle, PWideChar(Pointer(e.mWideMsg)), nil,
            MB_ICONERROR or MB_OK);
          revertToOldLocation();
        end;
        on e: TBqException do
        begin
          MessageBoxW(self.Handle, PWideChar(Pointer(e.mWideMsg)), nil,
            MB_ICONERROR or MB_OK);
          revertToOldLocation();
        end
      else
        revertToOldLocation();          //в любом случае
      end;

      goto exitlabel;
    end;                                //first word is go

    if FirstWord(dup) = 'file' then
    begin
      wasFile := true;                  // *** - not a favorite
      wasSearchHistory := false;
    // if a Bible path was stored with file... (after search procedure)
      i := Pos('***', dup);
      if i > 0 then
      begin
        j := Pos('$$$', dup);
        value := MainFileExists(Copy(dup, i + 3, j - i - 4) + '\bibleqt.ini');
        if MainBook.IniFile <> value then
          MainBook.IniFile := value;
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
        WideShowMessage(WideFormat(Lang.Say('FileNotFound'), [path]));
        goto exitlabel;
      end;

      Browser.Base := WideExtractFilePath(path);

    //    Browser.Charset := DefaultCharset;

      WChar_ReadHtmlFileTo(path, dBrowserSource);

      if wasSearchHistory then
      begin
        StrReplace(
          dBrowserSource, '<*>',
          '<font color="' + SelTextColor + '">', true
          );
        StrReplace(dBrowserSource, '</*>', '</font>', true);

      end;

      Browser.LoadFromString(dBrowserSource);

      if Browser.DocumentTitle <> '' then
        value := Browser.DocumentTitle
      else
        value := WideExtractFileName(path);
    {
        if wasSearchHistory then
          MainTabs.Tabs[MainTabs.TabIndex] := value
        else
          MainTabs.Tabs[MainTabs.TabIndex] := ExtractFileName(path);
    }
        //MainForm.Caption := Application.Title + ' — ' +
        //TitleLabel.Caption := '  ' + value;
        //TitleLabel.Font.Style := [fsBold];

    //    TabBuffers[MainTabs.TabIndex] := s;

      if (History.Count > 0) and (History[0] = s) then
        Browser.Position := browserpos;

      HistoryAdd(s);
      if wasSearchHistory then
        Browser.Tag := bsSearch
      else
        Browser.Tag := bsFile;
    (*AlekId:Добавлено*)
      mViewTabs.ActivePage.Caption := WideFormat('%.12s', [value]);
      (TObject(mViewTabs.ActivePage.Tag) as TViewTabInfo).mwsLocation := s;
    (*AlekId:/Добавлено*)
      goto exitlabel;
    end;                                //first word is "file"

    if WideExtractFileName(dup) = dup then
    try
      Browser.LoadFromFile(Browser.Base + dup);
    (*AlekId:Добавлено*)

      mViewTabs.ActivePage.Caption := WideFormat('%.12s', [s]);
      (TObject(mViewTabs.ActivePage.Tag) as TViewTabInfo).mwsLocation := s;

    (*AlekId:/Добавлено*)
    except
      ;
    end;

    exitlabel:

  //ActiveControl := Browser;
//  miStrong.Enabled := MainBook.StrongNumbers;
    if length(path) <= 0 then
      exit;
    Result := true;

    i := BooksCB.Items.IndexOf(MainBook.Name);
    if i <> BooksCB.ItemIndex then
      BooksCB.ItemIndex := i;
    i := MainBook.CurBook - 1;
    if MainBook.BookQty > 0 then begin
      if i <> BookLB.ItemIndex then
        BookLB.ItemIndex := i;

  //BookLBClick(Self);
  // copy of BookLBClick....
      if (oldpath <> bibleLink.modName) or (oldbook <> bibleLink.book)
         or (ChapterLB.Items.Count = 0) then
        with ChapterLB do
        begin
          Items.BeginUpdate;
          Items.Clear;

          offset := 0;
          if MainBook.ChapterZero then
            offset := 1;

          for i := 1 to MainBook.ChapterQtys[BookLB.ItemIndex + 1] do
            Items.Add(IntToStr(i - offset));
          Items.EndUpdate;
          ItemIndex := 0;
        end;
      i := MainBook.CurChapter - 1;
      if ChapterLB.ItemIndex <> i then
        ChapterLB.ItemIndex := i;
  //AlekId: этот код используется теперь дважды так что в процедуру его
  {  BibleTabs.OnChange := nil;

    if (not wasFile) and (BibleTabs.Tabs.IndexOf(MainBook.ShortName) <> -1) then
      BibleTabs.TabIndex := BibleTabs.Tabs.IndexOf(MainBook.ShortName)
    else
      BibleTabs.TabIndex := 10; // not a favorite book
    BibleTabs.OnChange := BibleTabsChange;}
    end;
    if (not wasFile) then
      AdjustBibleTabs();
    if HistoryLB.ItemIndex <> -1 then
    begin
      BackButton.Enabled := HistoryLB.ItemIndex < HistoryLB.Items.Count - 1;
      ForwardButton.Enabled := HistoryLB.ItemIndex > 0;
    end;
  finally
    mInterfaceLock := false;
    Screen.Cursor := crDefault;
  end;

{$IFOPT D+}
  //Caption:=Format('Отладочная сборка:',[AllocMemCount, AllocMemSize]);
{$ENDIF}
  //ActiveControl := Browser;
end;                                    //proc processcommand

{---}

procedure TMainForm.HistoryButtonClick(Sender: TObject);
begin
  if History.Count = 0 then
    Exit;
  //ResultPages.ActivePage := HistoryTab;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  OldKey: Word;
  hotMenuItem: TtntMenuItem;
  tryCount: integer;
label
  exitlabel;
begin
  if PreviewBox.Visible then
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
      PreviewBox.VertScrollBar.Position := 0;
    end
    else if Key = VK_END then
    begin
      PreviewBox.VertScrollBar.Position := PreviewBox.VertScrollBar.Range;
    end
    else if Key = VK_UP then
    begin
      if PreviewBox.VertScrollBar.Position > 50 then
        PreviewBox.VertScrollBar.Position := PreviewBox.VertScrollBar.Position -
          50
      else
        PreviewBox.VertScrollBar.Position := 0;
    end
    else if Key = VK_DOWN then
    begin
      if PreviewBox.VertScrollBar.Position < PreviewBox.VertScrollBar.Range - 50 then
        PreviewBox.VertScrollBar.Position := PreviewBox.VertScrollBar.Position +
          50
      else
        PreviewBox.VertScrollBar.Position := PreviewBox.VertScrollBar.Range;
    end
    else if Key = VK_LEFT then
    begin
      if PreviewBox.HorzScrollBar.Position > 50 then
        PreviewBox.HorzScrollBar.Position := PreviewBox.HorzScrollBar.Position -
          50
      else
        PreviewBox.HorzScrollBar.Position := 0;
    end
    else if Key = VK_RIGHT then
    begin
      if PreviewBox.HorzScrollBar.Position < PreviewBox.HorzScrollBar.Range - 50 then
        PreviewBox.HorzScrollBar.Position := PreviewBox.HorzScrollBar.Position +
          50
      else
        PreviewBox.HorzScrollBar.Position := PreviewBox.HorzScrollBar.Range;
    end
    else if (Key = Ord('Z')) and (Shift = [ssCtrl]) then
      GoPrevChapter
    else if (Key = Ord('X')) and (Shift = [ssCtrl]) then
      GoNextChapter
    else if (Key = Ord('V')) and (Shift = [ssCtrl]) then
      PreviewButton.Click
    else if (Key = Ord('P')) and (Shift = [ssCtrl]) then
      PrintButton.Click;

    Key := 0;
    goto exitlabel;
  end;                                  //if previewbox visible

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
      VK_F5: miCopyOptions.Click;
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
      //Ord('H'): HistoryButton.Click;

      Ord('Z'): if ActiveControl <> TREMemo then
          GoPrevChapter;
      Ord('X'): if ActiveControl <> TREMemo then
          GoNextChapter;
      Ord('T'): ToggleButton.Click;
      //    Ord('G'):
      //        begin
      //          MainPages.Visible := true;
      //          MainPages.ActivePage := GoTab;
      //          ActiveControl := GoEdit;
      //        end;

      //    Ord('F'):
      //        begin
      //          MainPages.Visible := true;
      //          MainPages.ActivePage := SearchTab;
      //          ActiveControl := SearchCB;
      //        end;
      Ord('C'), VK_INSERT:
        begin
          if ActiveControl = TREMemo then
            TREMemo.CopyToClipboard
          else if ActiveControl = Browser then
            CopyButton.Click
          else if ActiveControl is THTMLViewer then begin
            tryCount := 7;
            repeat try

//    if (CopyOptionsCopyVerseNumbersChecked xor (IsDown(VK_CONTROL))) then
                (ActiveControl as THTMLViewer).CopyToClipboard;
  //  else   TntClipboard.AsText := (ActiveControl as THTMLViewer).SelText;
                tryCount := 0;
              except dec(tryCount); end;
            until tryCount <= 0;
          end                           //if webbr
        end;
      //Ord('B'): BookmarkButton.Click;
      //Ord('D'): miAddPassageBookmark.Click;

      //Ord('N'): NewButton.Click;
      Ord('O'): miOpen.Click;
      Ord('S'): miSave.Click;
      Ord('P'): PrintButton.Click;
      Ord('W'): PreviewButton.Click;
      Ord('R'): GoRandomPlace;

      Ord('M'): miMemosToggle.Click;

      Ord('L'): SoundButton.Click;

      VK_F1: ToggleButton.Click;
      Ord('G'), VK_F2: miQuickNav.Click;
      Ord('F'), VK_F3: miQuickSearch.Click;
      //VK_F4: ToggleButton.Click;
      VK_F5: miCopy.Click;
      VK_F10: miSound.Click;

      VK_F11: miPrintPreview.Click;
      VK_F12: miOpen.Click;

      {Ord('1'): miHot1.Click;
      Ord('2'): miHot2.Click;
      Ord('3'): miHot3.Click;
      Ord('4'): miHot4.Click;
      Ord('5'): miHot5.Click;
      Ord('6'): miHot6.Click;
      Ord('7'): miHot7.Click;
      Ord('8'): miHot8.Click;
      Ord('9'): miHot9.Click;
      Ord('0'): miHot0.Click;}
      Ord('0'):
        begin
          if mFavorites.mModuleEntries.Count > 9 then
            hotMenuItem := FavouriteItemFromModEntry(
              TModuleEntry(mFavorites.mModuleEntries[10]));
          if assigned(hotMenuItem) then
            hotMenuItem.Click();
        end;

      Ord('1')..Ord('9'):
        begin
          if mFavorites.mModuleEntries.Count >= (ord(OldKey) - ord('0')) then
            hotMenuItem := FavouriteItemFromModEntry(
              TModuleEntry(mFavorites.mModuleEntries[ord(OldKey) - ord('0') - 1]));

          if assigned(hotMenuItem) then
            hotMenuItem.Click();
        end;
    else
      Key := OldKey;
    end;

    if Key = 0 then
      goto exitlabel;
  end;

  OldKey := Key;
  case OldKey of

    VK_F1: miHelp.Click;
    VK_F2: miOpenPassage.Click;
    VK_F3: miSearch.Click;
    VK_F4: miDic.Click;
    VK_F5: miStrong.Click;
    VK_F6: miComments.Click;
    VK_F7: miXref.Click;
    VK_F8: miNotepad.Click;
    VK_F9: miHotKey.Click;
    VK_F10: miOptions.Click;
    VK_F11: miPrint.Click;
    VK_F12: miSave.Click;

  end;

  exitlabel:
end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
begin
  with OpenDialog1 do
  begin
    if InitialDir = '' then
      InitialDir := ExePath;

    Filter := 'HTML (*.htm, *.html)|*.htm;*.html|*.*|*.*';

    if Execute then
    begin
      ProcessCommand('file ' + FileName + ' $$$' + FileName, hlDefault);
      InitialDir := WideExtractFilePath(FileName);
    end;
  end;
end;

procedure TMainForm.SearchButtonClick(Sender: TObject);
begin
  if not MainPages.Visible then
    ToggleButton.Click;

  MainPages.ActivePage := SearchTab;
  ActiveControl := SearchCB;
end;
{Alek}(*AlekId:Добавлено*)

procedure TMainForm.SearchEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
  begin
    ActiveControl := btnQuickSearchFwd;
    btnQuickSearchFwd.Click();
  end;
end;
(*AlekId:/Добавлено*)

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    if not MainPanel.Visible then
      {previewing}
      miPrintPreview.Click              // this turns preview off
    else
    begin
      if IsSearching then
        FindButtonClick(Sender)
      else
      begin
        Application.Minimize;
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
    if MainPages.ActivePage = SearchTab then
    begin
      Key := #0;
      FindButtonClick(Sender);
    end
    else if ActiveControl = HistoryLB then
    begin
      Key := #0;
      HistoryLBDblClick(Sender);
    end;
  end;
end;

procedure TMainForm.GoEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    GoEditDblClick(Sender);
  end;
end;

function TMainForm.FavouriteItemFromModEntry(
  const me: TModuleEntry): TTntMenuItem;
var favouriteMenuItem: TTntMenuItem;
  cnt, i: integer;
begin
  result := nil;
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    cnt := favouriteMenuItem.Count - 1;
    i := 0;
    while i <= cnt do begin
      result := TTntMenuItem(favouriteMenuItem.Items[i]);
      if result.Tag = integer(me) then break;
      inc(i);
    end;
    if i > cnt then result := nil;
  except on e: Exception do BqShowException(e); end;

end;

function TMainForm.FavouriteTabFromModEntry(const me: TModuleEntry): integer;
var i, cnt: integer;
begin
  result := -1;
  cnt := mBibleTabsEx.WideTabs.Count - 1; i := 0;
  while i <= cnt do begin
    if mBibleTabsEx.WideTabs.Objects[i] = me then break;
    inc(i);
  end;
  if i <= cnt then result := i;
end;

procedure TMainForm.FindButtonClick(Sender: TObject);
var
  s: set of 0..255;
  data, wrd, wrdnew: WideString;
  params: byte;
begin
  if CBQty.ItemIndex < CBQty.Items.Count - 1 then
    SearchPageSize := StrToInt(CBQty.Items[CBQty.ItemIndex])
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

    if (not MainBook.isBible) or
      (not MainBook.HasOldTestament) or (not MainBook.HasNewTestament) then
    begin
      if CBList.ItemIndex = 0 then
        s := [0..MainBook.BookQty - 1]
        //for i := 1 to MainBook.BookQty do s := s + [i-1];
      else
        s := [CBList.ItemIndex - 1];
    end
    else
    begin                               // FULL BIBLE SEARCH
      case CBList.ItemIndex of
        0: s := [0..65];
        1: s := [0..38];
        2: s := [39..65];
        3: s := [0..4];
        4: s := [5..21];
        5: s := [22..38];
        6: s := [39..43];
        7: s := [44..65];
        8:
          begin
            if MainBook.HasApocrypha then
              s := [66..MainBook.BookQty - 1]
            else
              s := [0];
          end;
      else
        s := [CBList.ItemIndex - 8 - Ord(MainBook.HasApocrypha)];
      // search in single book
      end;
    end;

    data := Trim(SearchCB.Text);
    StrReplace(data, '.', ' ', true);
    StrReplace(data, ',', ' ', true);
    StrReplace(data, ';', ' ', true);
    StrReplace(data, '?', ' ', true);
    StrReplace(data, '"', ' ', true);
    data := Trim(data);
  //SearchCB.Text := data;

    if data <> '' then
    begin
    //if SingleLetterDelete(data) then
    //  ShowMessage(Lang.Say('OneLetterWordsDeleted'));

    //SearchCB.Text := data;
      SearchCB.Items.Insert(0, data);

      SearchResults.Clear;
    //    SearchLB.Items.Clear;

      SearchWords.Clear;
      wrd := SearchCB.Text;

      if not CBExactPhrase.Checked then
      begin
        while wrd <> '' do
        begin
          wrdnew := DeleteFirstWord(wrd);

        //        if not CBCase.Checked then
        //        begin
        //          SearchWords.Add(UpperCaseFirstLetter(wrdnew)); // Господь
        //          SearchWords.Add(WideLowerCase(wrdnew)); // господь
        //          SearchWords.Add(WideUpperCase(wrdnew)); // LORD OF LORDS, in English :-)
        //        end
        //        else
          SearchWords.Add(wrdnew);
        end;
      end
      else
      begin
        wrdnew := Trim(wrd);
      //      SearchWords.Add(UpperCaseFirstLetter(wrdnew)); // Господь
      //      SearchWords.Add(WideLowerCase(wrdnew)); // господь
      //      SearchWords.Add(WideUpperCase(wrdnew)); // LORD OF LORDS, in English :-)
        SearchWords.Add(wrdnew);
      end;

      params :=
        spWordParts * (1 - Ord(CBParts.Checked)) +
        spContainAll * (1 - Ord(CBAll.Checked)) +
        spFreeOrder * (1 - Ord(CBPhrase.Checked)) +
        spAnyCase * (1 - Ord(CBCase.Checked)) +
        spExactPhrase * Ord(CBExactPhrase.Checked);

      if (params and spExactPhrase = spExactPhrase)
        and (params and spWordParts = spWordParts) then
        params := params - spWordParts;
      SearchTime := GetTickCount;
      MainBook.Search(data, params, s);
    end;
  finally Screen.Cursor := crDefault; end
end;

procedure TMainForm.MainBookSearchComplete(Sender: TObject);
begin
  IsSearching := false;
  SearchTime := GetTickCount - SearchTime;
  SearchLabel.Caption := SearchLabel.Caption + ' (' + IntToStr(SearchTime) +
    ')';
  DisplaySearchResults(1);
//    ProcessCommand(History[HistoryLB.Count-1]);
//  ProcessCommand(History[0]);
end;

procedure TMainForm.FontChanged(delta: integer);
var
  defFontSz, browserPos: integer;
begin
  defFontSz := Browser.DefFontSize;
  if ((delta > 0) and (defFontSz > 48)) or ((delta < 0) and (defFontSz < 6)) then
    exit;
  Inc(defFontSz, delta);
  Screen.Cursor := crHourGlass;
  try
    Browser.DefFontSize := defFontSz;
    browserPos := Browser.Position and $FFFF0000;
    Browser.LoadFromString(Browser.DocumentSource);
    Browser.Position := browserPos;

    browserPos := SearchBrowser.Position and $FFFF0000;
    SearchBrowser.DefFontSize := defFontSz;
    SearchBrowser.LoadFromString(SearchBrowser.DocumentSource);
    SearchBrowser.Position := browserPos;

    browserPos := DicBrowser.Position and $FFFF0000;
    DicBrowser.DefFontSize := defFontSz;
    DicBrowser.LoadFromString(DicBrowser.DocumentSource);
    DicBrowser.Position := browserPos;

    browserPos := StrongBrowser.Position and $FFFF0000;
    StrongBrowser.DefFontSize := defFontSz;
    StrongBrowser.LoadFromString(StrongBrowser.DocumentSource);
    StrongBrowser.Position := browserPos;

    browserPos := CommentsBrowser.Position and $FFFF0000;
    CommentsBrowser.DefFontSize := defFontSz;
    CommentsBrowser.LoadFromString(CommentsBrowser.DocumentSource);
    CommentsBrowser.Position := browserPos;

    browserPos := XRefBrowser.Position and $FFFF0000;
    XRefBrowser.DefFontSize := defFontSz;
    XRefBrowser.LoadFromString(XRefBrowser.DocumentSource);
    XRefBrowser.Position := browserPos;

  except end;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.ForceForegroundLoad;
begin
  if not mAllBkScanDone then
  begin
    repeat
      LoadModules(true);
    until mAllBkScanDone;

    Application.OnIdle := nil;
    Self.UpdateFromCashed();
    self.UpdateAllBooks();
    self.UpdateUI();
  end;

  if not mDictionariesFullyInitialized then
  begin
    mDictionariesFullyInitialized := LoadDictionaries(MaxInt);
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  F: TSearchRec;

  procedure _finalizeDics();
  var
    i: integer;
  begin
    for i := 0 to DicsCount - 1 do
      Dics[i].Free();
  end;

  procedure _finalizeViewTabs();
  var
    i, c: integer;
  begin
    c := mViewTabs.PageCount - 1;
    for i := 0 to c do
      (TObject(mViewTabs.Pages[i].Tag) as TViewTabInfo).Free();

  end;
begin
  if MainForm.Height < 100 then
    MainForm.Height := 420;

  // clearing temporary files directory
//  if FindFirst(TempDir + '*.*', faAnyFile, F) = 0 then
//    repeat
//      if (F.Name <> '.') and (F.Name <> '..') then
//        DeleteFile(TempDir + F.Name);
//    until FindNext(F) <> 0;
//
//  TempDir := Copy(TempDir, 1, Length(TempDir) - 1);
//  RemoveDir(TempDir);

  SaveConfiguration;
  (*AlekId:Добавлено*)
  try
    Bibles.Free();
    Books.Free();
    Comments.Free();
    CommentsPaths.Free();
    { CacheDicPaths.Free(); CacheDicTitles.Free(); CacheModPaths.Free();
     CacheModTitles.Free(); }ModulesList.Free();
    ModulesCodeList.Free();
    S_ArchivedModuleList.Free();
    Memos.Free();
    Bookmarks.Free();
    History.Free();
    SearchResults.Free();
    SearchWords.Free();
    StrongHebrew.Free();
    StrongGreek.Free();
    _finalizeDics();                    //CleanUp
    S_cachedModules.Free();
    _finalizeViewTabs();
    PasswordPolicy.Free();
    mModules.Free();
    mDicList.Free();
  except
  end;
  (*AlekId:/Добавлено*)
{
  ShowMessage('Saving properties');

  Memos.Clear;

  with MainForm do
  for i := 0 to ComponentCount-1 do
  begin
    if (Components[i] is TTntLabel)
    or (Components[i] is TTntButton)
    or (Components[i] is TTntCheckBox)
    then begin
      Memos.Add('MainForm.' + Components[i].Name + '.Caption = ');
      Memos.Add('MainForm.' + Components[i].Name + '.Hint = ');
    end
    else if (Components[i] is TTntMenuItem) then
      Memos.Add('MainForm.' + Components[i].Name + '.Caption = ');
  end;

  Memos.SaveToFile(ExePath + 'default.lng2');}
end;

procedure TMainForm.SearchListInit;
var
  i: integer;
begin
  if (not MainBook.isBible) or
    (not MainBook.HasOldTestament) or (not MainBook.HasNewTestament) then
    with CBList do
    begin
      Items.BeginUpdate;
      Items.Clear;

      Items.Add(Lang.Say('SearchAllBooks'));

      for i := 1 to MainBook.BookQty do
        Items.Add(MainBook.FullNames[i]);

      Items.EndUpdate;
      ItemIndex := 0;
      Exit;
    end;

  with CBList do
  begin
    Items.BeginUpdate;
    Items.Clear;

    Items.Add(Lang.Say('SearchWholeBible'));
    Items.Add(Lang.Say('SearchOT'));    // Old Testament
    Items.Add(Lang.Say('SearchNT'));    // New Testament
    Items.Add(Lang.Say('SearchPT'));    // Pentateuch
    Items.Add(Lang.Say('SearchHP'));    // Historical and Poetical
    Items.Add(Lang.Say('SearchPR'));    // Prophets
    Items.Add(Lang.Say('SearchGA'));    // Gospels and Acts
    Items.Add(Lang.Say('SearchER'));    // Epistles and Revelation

    if MainBook.HasApocrypha then
      Items.Add(Lang.Say('SearchAP'));  // Apocrypha

    for i := 1 to MainBook.BookQty do
      Items.Add(MainBook.FullNames[i]);

    Items.EndUpdate;
    ItemIndex := 0;
  end;
end;

procedure TMainForm.GoEditDblClick(Sender: TObject);
var
  book, chapter, fromverse, toverse: integer;
  Links: TWideStrings;
  i, ix, fc, pp: integer;
  openSuccess: boolean;
  modName, modPath: WideString;
begin
  if Trim(GoEdit.Text) = '' then
    Exit;

  Links := TWideStringList.Create;

  StrToLinks(GoEdit.Text, Links);
//  mBibleLinkParser.LazyLinks:=true;
//  mBibleLinkParser.ParseBuffer(GoEdit.Text, Links)   ;
  if Links.Count > 1 then
  begin
    LinksCB.Items.Clear;
    for i := 0 to Links.Count - 1 do
      LinksCB.Items.Add(Links[i]);
    LinksCB.ItemIndex := 0;
  end;

  //ComplexLinksPanel.Visible := (Links.Count > 1);
  tbLinksToolBar.Visible {LinksCB.Visible} := (Links.Count > 1);

  GoEdit.Text := Links[0];

  openSuccess := MainBook.OpenAddress(GoEdit.Text, book, chapter, fromverse,
    toverse);
  if not openSuccess then begin
    fc := mFavorites.mModuleEntries.Count - 1;
    if not assigned(__tmpBook) then __tmpBook := TBible.Create(self);
    for i := 0 to fc do
    begin
      try
        __tmpBook.IniFile := MainFileExists(TModuleEntry(mFavorites.mModuleEntries[i]).wsShortPath + '\bibleqt.ini');
        openSuccess := __tmpBook.OpenAddress(GoEdit.Text, book, chapter,
          fromverse, toverse);
        if openSuccess then
        begin MainBook.IniFile := __tmpBook.IniFile; break; end;
      except end;

    end;
    if not openSuccess then begin
      fc := Bibles.Count - 1;
      for i := 0 to fc do
      begin
        try
          ix := -1;
          modName := Bibles[i];
          ix := ModuleIndexByName(modName);
          pp := Pos(' $$$ ', ModulesList[ix]);
          modPath := Copy(ModulesList[ix], pp + 5, Length(ModulesList[ix]));
          __tmpBook.IniFile := MainFileExists(modPath + '\bibleqt.ini');
          openSuccess := __tmpBook.OpenAddress(GoEdit.Text, book, chapter,
            fromverse, toverse);
          if openSuccess then
          begin MainBook.IniFile := __tmpBook.IniFile; break; end;
        except end;
      end;

    end;
  end;
  if openSuccess then
    SafeProcessCommand(WideFormat('go %s %d %d %d %d',
      [MainBook.ShortPath, book, chapter, fromverse, toverse]), hlDefault)
  else
    SafeProcessCommand(GoEdit.Text,hlDefault);

  Links.Free;
end;

procedure TMainForm.GoEditChange(Sender: TObject);
begin
  AddressFromMenus := false;
end;

procedure TMainForm.ChapterComboBoxChange(Sender: TObject);
begin
  AddressFromMenus := true;
end;

procedure TMainForm.FirstBrowserKeyPress(Sender: TObject; var Key: Char);
//var
begin
  if Key = '+' then
  begin
    Key := #0;
{    i := Browser.DefFontSize;
    Inc(i);
    Browser.DefFontSize := i;
    Browser.LoadFromString(Browser.DocumentSourceUtf16);

    SearchBrowser.DefFontSize := i;
    SearchBrowser.LoadFromString(SearchBrowser.DocumentSourceUtf16);
    DicBrowser.DefFontSize := i;
    DicBrowser.LoadFromString(DicBrowser.DocumentSourceUtf16);
    StrongBrowser.DefFontSize := i;
    StrongBrowser.LoadFromString(StrongBrowser.DocumentSourceUtf16);
    CommentsBrowser.DefFontSize := i;
    CommentsBrowser.LoadFromString(CommentsBrowser.DocumentSourceUtf16);

    Exit;}
    FontChanged(1);
  end else
    if Key = '-' then
  begin
    Key := #0;
    {i := Browser.DefFontSize;
    Dec(i);
    Browser.DefFontSize := i;
    Browser.LoadFromString(Browser.DocumentSourceUtf16);
    //Browser.Reload();
    SearchBrowser.DefFontSize := i;
    SearchBrowser.LoadFromString(SearchBrowser.DocumentSourceUtf16);
    DicBrowser.DefFontSize := i;
    DicBrowser.LoadFromString(DicBrowser.DocumentSourceUtf16);
    StrongBrowser.DefFontSize := i;
    StrongBrowser.LoadFromString(StrongBrowser.DocumentSourceUtf16);
    CommentsBrowser.DefFontSize := i;
    CommentsBrowser.LoadFromString(CommentsBrowser.DocumentSourceUtf16);

    Exit;}
    FontChanged(-1);
  end;

end;

procedure TMainForm.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Idle(Sender: TObject; var Done: boolean);
begin
  //фоновая загрузка модулей

  if not mAllBkScanDone then begin
    LoadModules(true);
    if mAllBkScanDone then
    begin
      Self.UpdateFromCashed();
      self.UpdateAllBooks();
      self.UpdateUI();
    end
    else begin Done := false; exit; end;
  end;

  if not mDictionariesFullyInitialized then
  begin
    mDictionariesFullyInitialized := LoadDictionaries(1);
    Done := false;
    exit;
  end
  else begin Application.OnIdle := nil; end;
end;

{procedure TMainForm.InitBibleTabs;
var
  i, j, bibleTabsCount: integer;
  s: WideString;
  hotModuleMenuItem: TtntMenuItem;
begin
  bibleTabsCount := GetHotModuleCount() - 1;
  mBibleTabsEx.WideTabs.Clear();
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
      mBibleTabsEx.WideTabs.AddObject(ModulesCodeList[j],
        hotModuleMenuItem);
  end; //for
  mBibleTabsEx.WideTabs.AddObject('***', nil);
end;       }

procedure TMainForm.InitBkScan;
begin
  __searchInitialized := false;
  mFolderModulesScanned := false;
  mFolderCommentsScanned := false;
  mSecondFolderModulesScanned := false;
  mArchivedBiblesScanned := false;
  mArchivedCommentsScanned := false;
  mAllBkScanDone := false;
end;

procedure TMainForm.InitQNavList;
begin
  if not assigned(frmQNav) then frmQNav := TfrmQNav.Create(self);

end;

function TMainForm.InsertHotModule(newMe: TModuleEntry; ix: integer): integer;
var favouriteMenuItem, hotMenuItem: TTntMenuItem;
  cnt, i: integer;
begin
  Result := -1;
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    if not Assigned(favouriteMenuItem) then
      exit;
    i := 0; cnt := favouriteMenuItem.Count;
    while (i < cnt) do begin
      if (favouriteMenuItem.Items[i].Tag > 65536) then break;
      inc(i);
    end;
    if i >= cnt then exit;

    hotMenuItem := TTntMenuItem.Create(self);
    hotMenuItem.Tag := Integer(newMe);
    hotMenuItem.Caption := newMe.wsFullName;
    hotMenuItem.OnClick := HotKeyClick;

    favouriteMenuItem.Insert(ix + i, hotMenuItem);
    mBibleTabsEx.WideTabs.Insert(ix, newMe.VisualSignature());
    mBibleTabsEx.WideTabs.Objects[ix] := newMe;
    result := ix;
    mBibleTabsEx.Repaint();
  except
    on e: Exception do begin BqShowException(e); end;
  end;
end;

{procedure TMainForm.LoadBookNodes;
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
  pn:=vstBooks.AddChild(vstBooks.RootNode, bc);}
{  pn:=nil;
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
end;}

function TMainForm.LoadAnchor(wb: THTMLViewer; src, current, loc: WideString): boolean;
var i: integer;
  dest: WideString;
  ext: string;
begin
  result := false;
  try
    I := Pos('#', src);
    if I = 1 then loc := current + src;
    if I >= 1 then
    begin                               //found anchor
      I := Pos('#', loc);
      Dest := System.Copy(loc, I, Length(loc) - I + 1); {local destination}
      Src := System.Copy(loc, 1, I - 1); {the file name}
    end                                 //found anchor
    else                                //no achor
      dest := '';                       {no local destination}
    if wb.CurrentFile = src then wb.PositionTo(dest)
    else begin
      Ext := Uppercase(WideExtractFileExt(Src));
      if (Ext = '.HTM') or (Ext = '.HTML') then begin {an html file}
        wb.LoadFromFile(src + Dest); end
//        wb.AddVisitedLink(S+Dest);
      else if (Ext = '.BMP') or (Ext = '.GIF') or (Ext = '.JPG') or (Ext = '.JPEG')
        or (Ext = '.PNG') then
        wb.LoadImageFile(Src);
    end;
    result := true;
  except on e: Exception do begin BqShowException(e); end end;
end;

function TMainForm.LoadBibleToXref(cmd: WideString; const id: Widestring): boolean;
var docLen: integer;

  fn, ws, psg, psgh, doc: WideString;
  bl: TBibleLink;
  status_load: integer;

begin
  status_load := GetModuleText(cmd, fn, bl, ws, [gmtLookupRefBibles]);
  if status_load < 0 then begin messagebeep(MB_ICONEXCLAMATION); exit; end;

  psg := SecondBook.ShortPassageSignature(bl.book, bl.chapter, bl.vstart, bl.vend);
  doc := XRefBrowser.DocumentSourceUtf16;
  docLen := length(doc);

  ws := WideFormat(
    '%s '#13#10'<a href="bqnavMw:bqResLnk%s">%s</a><br>',
    [ws, id, psg]);
  XRefBrowser.LoadFromString(doc + ws);
  if MainPages.ActivePage <> XRefTab then MainPages.ActivePage := XRefTab;
//GetActiveTabInfo().
//ws:=WideFormat('<a href="%s>%s', [] );
//docLen:=XRefBrowser.DocumentSourceUtf16;
  XRefBrowser.Position := XRefBrowser.MaxVertical;

end;

function TMainForm.LoadCachedModules: boolean;
var
  cachedModulesList: TWideStringList;
  i, linecount, modIx: integer;
  modEntry: TModuleEntry;
  modType: TModuleType;
  cats: WideString;
begin
  cachedModulesList := nil;
  //result := false;
  try
    cachedModulesList := TWideStringList.Create();
    cachedModulesList.LoadFromFile(GetCachedModulesListDir() +
      C_CachedModsFileName);
    S_cachedModules.Clear();
    i := 1;
    if cachedModulesList[0] <> 'v3' then begin result := false; exit; end;
    linecount := cachedModulesList.Count - 1;
    if linecount < 7 then
      abort;
    repeat
      modIx := S_cachedModules.IndexOf(cachedModulesList[i + 1]);
      if modIx < 0 then
      begin
{$R+}
        modType := TModuleType(StrToInt(cachedModulesList[i]));
        cats := cachedModulesList[i + 6];

        if cats = '***' then cats := '';
        modEntry := TModuleEntry.Create(modType,
          cachedModulesList[i + 1], cachedModulesList[i + 2],
          cachedModulesList[i + 3], cachedModulesList[i + 4], UTF8Encode(cachedModulesList[i + 5]), cats);
{$R-}
        S_cachedModules.Add(modEntry);
      end;
      Inc(i, 6);
      while (i <= linecount) and (cachedModulesList[i] <> '***') do
        inc(i);
      inc(i);

    until (i + 7) > linecount;
    result := true;
  except
    S_cachedModules.Clear();
    result := false;
  end;
  cachedModulesList.Free();
  S_cachedModules._Sort();
end;

{procedure TMainForm.InitHotModulesConfigPage(refreshModuleList: boolean);
var
  cnt, i: integer;
  pwc: PWideString;
  favouriteMenuItem, hotItem: TtntMenuItem;
begin
  if refreshModuleList then try
    with config.ConfigForm do begin
      cnt := Bibles.Count - 1;
      for i := 0 to cnt do begin
        New(pwc); pwc^ := bibles[i]; end;
      cnt := Books.Count - 1;
      for i := 0 to cnt do begin
        New(pwc);
        pwc^ := books[i];

      end;

      cnt := Comments.IndexOf('---------') - 1;
      for i := 0 to cnt do begin
        New(pwc); pwc^ := Comments[i];

      end;
      favouriteMenuItem := FindTaggedTopMenuItem(3333);
      if not assigned(favouriteMenuItem) then exit;
      cnt := favouriteMenuItem.Count - 1;
      for i := 0 to cnt do begin
        hotItem := favouriteMenuItem.Items[i] as TTntMenuItem;
        if hotItem.Tag < 7000 then Continue;
        New(pwc); pwc^ := hotItem.Caption;

      end;
    end; //with
  except end;
end;}

procedure TMainForm.MainMenuInit(cacheupdate: boolean);
var
  r: boolean;
begin
  Bibles.Clear;
  Books.Clear;
  Comments.Clear;
  CommentsPaths.Clear;
  ModulesList.Clear;
  S_ArchivedModuleList.Clear();
  ModulesCodeList.Create;
  if cacheupdate then
  begin
    S_cachedModules.Clear();
    LoadModules(false);
  end
  else
  begin
    r := LoadCachedModules;
    if r then
      r := UpdateFromCashed();
    if not r then
    begin                               //не удалось загрузить или обновиться
      LoadModules(false);
    end
    else
      S_cachedModules.Clear();
  end;
  mDefaultLocation := DefaultLocation();
  DicsCount := 0;
  UpdateAllBooks();
//  DeleteInvalidHotModules();
end;

procedure TMainForm.LanguageMenuClick(Sender: TObject);
var
  i: integer;
begin
  LastLanguageFile := (Sender as TTntMenuItem).Caption + '.lng';

  TranslateInterface(LastLanguageFile);

  for i := 0 to miLanguage.Count - 1 do
    with miLanguage.Items[i] do
      Checked := (WideLowerCase(Caption + '.lng') =
        WideLowerCase(LastLanguageFile));
  { TODO -oAlekId -cQA : Кажется, вызов MainMenuInit лишний }
//  MainMenuInit(false);
end;

procedure TMainForm.GoModuleName(s: WideString);
var
  i, j: integer;
  book, chapter, fromverse, toverse, tb, tc: integer;
  wasBible: boolean;
  commentpath: WideString;
  me: TModuleEntry;
begin
  j := ModuleIndexByName(s);
  commentpath := ModulesList[j];
  i := mModules.FindByName(s);
  if j < 0 then
    exit;
//  if i >= Bibles.Count + Books.Count then
  me := TModuleEntry(mModules.Items[j]);
  if me.modType = modtypeComment then
    commentpath := 'Commentaries\'
  else
    commentpath := '';
  // remember old module's params
  wasBible := MainBook.isBible;
  //  MainBook.InternalToAddress(MainBook.CurBook,MainBook.CurChapter,VersePosition,
  //    book,chapter,fromverse);
  MainBook.AddressToInternal(MainBook.CurBook, MainBook.CurChapter,
    VersePosition,
    book, chapter, fromverse);
  toverse := 0;
  with MainBook do
    if (CurToVerse - CurFromVerse + 1 < VerseQty) then
      toverse := CurToVerse;
  if toverse > 0 then
    MainBook.AddressToInternal(MainBook.CurBook, MainBook.CurChapter, toverse,
      book, chapter, toverse);
  //ipos := Pos(' $$$ ', ModulesList[i]);
  try
    if not assigned(__tmpBook) then
      __tmpBook := TBible.Create(self);
    __tmpBook.IniFile :=
      MainFileExists(commentpath + me.wsShortPath + '\bibleqt.ini');
  except
  end;

  if __tmpBook.isBible and wasBible then
  begin
    tb := book;                         // save old values
    tc := chapter;
    //    MainBook.AddressToInternal(book,chapter,fromverse,book,chapter,fromverse);
    __tmpBook.InternalToAddress(book, chapter, fromverse, book, chapter,
      fromverse);

    if toverse > 0 then
      //    MainBook.AddressToInternal(tb,tc,toverse,tb,tc,toverse);
      __tmpBook.InternalToAddress(tb, tc, toverse, tb, tc, toverse);

    try
      ProcessCommand(WideFormat('go %s %d %d %d %d',
        [commentpath + __tmpBook.ShortPath, book, chapter, fromverse,
        toverse]), hlDefault);
    except
    end;
  end
  else
    SafeProcessCommand('go ' + commentpath + __tmpBook.ShortPath + ' 1 1 0', hlDefault);
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
  if (shift = []) and (not (ActiveControl is TCustomEdit))
    and (not (ActiveControl is TCustomCombo)) then
    case key of
      $47: showQNav();
      $48: miQuickNavClick(self);
    end;

end;

procedure TMainForm.FirstBrowserKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BrowserPosition := Browser.Position;

  if (Shift = [ssCtrl]) and (Key = VK_INSERT) then
  begin
    Key := 0;
    CopyButtonClick(Sender);
    Exit;
  end;

//  if ((Key = VK_BACK) and (Shift = []))
//    or ((Key = VK_LEFT) and (Shift = [ssAlt])) then
//  begin
//    Key := 0;
//    BackButton.Click;
//  end
//  else if ((Key = VK_RIGHT) and (Shift = [ssAlt])) then
//  begin
//    Key := 0;
//    ForwardButton.Click;
//  end;
end;

procedure TMainForm.miFontConfigClick(Sender: TObject);
var
  browserCount, i: Integer;
  viewTabInfo: TViewTabInfo;
begin
  with FontDialog1 do
  begin
    Font.Name := mBrowserDefaultFontName;
    Font.Color := Browser.DefFontColor;
    Font.Size := Browser.DefFontSize;
    //Font.Charset := DefaultCharset;
  end;

  if FontDialog1.Execute then
  begin
    browserCount := mViewTabs.PageCount - 1;
    for I := 0 to browserCount do
    begin
      try
        viewTabInfo := TObject(mViewTabs.Pages[i].Tag) as TViewTabInfo;
        with viewTabInfo, viewTabInfo.mHtmlViewer do
        begin
          if i <> mViewTabs.ActivePageIndex then
            ReloadNeeded := true;
          DefFontName := FontDialog1.Font.Name;
          mBrowserDefaultFontName := DefFontName;
          DefFontColor := FontDialog1.Font.Color;
          DefFontSize := FontDialog1.Font.Size;
        end                             //with
      except
      end;
    end;
    {
        SearchBrowser.DefFontColor := FontDialog1.Font.Color;
        DicBrowser.DefFontColor := FontDialog1.Font.Color;
        StrongBrowser.DefFontColor := FontDialog1.Font.Color;
        CommentsBrowser.DefFontColor := FontDialog1.Font.Color;
        XrefBrowser.DefFontColor := FontDialog1.Font.Color;
    }
    //    DefaultCharset := FontDialog1.Font.Charset;

    //ProcessCommand(History[HistoryLB.ItemIndex],hlDefault);
    viewTabInfo:=  GetActiveTabInfo();
    ProcessCommand(viewTabInfo.mwsLocation,
     TbqHLVerseOption(ord(viewTabInfo.mHLVerses)) );
  end;
end;

function TMainForm.ChooseColor(color: TColor): TColor;
begin
  Result := color;
  ColorDialog1.Color := color;

  if ColorDialog1.Execute then
    Result := ColorDialog1.Color;
end;

procedure TMainForm.miBGConfigClick(Sender: TObject);
var
  i, browserCount: integer;
  viewTabInfo: TViewTabInfo;
begin
  Browser.DefBackground := ChooseColor(Browser.DefBackground);
  Browser.Refresh;
  browserCount := mViewTabs.PageCount - 1;
  for I := 0 to browserCount do
  begin
    try
      viewTabInfo := TObject(mViewTabs.Pages[i].Tag) as TViewTabInfo;
      with viewTabInfo, viewTabInfo.mHtmlViewer do
      begin
        if i <> mViewTabs.ActivePageIndex then
        begin
          DefBackground := Browser.DefBackground;
          Refresh();
        end;
      end                               //with
    except
    end;
  end;

  with SearchBrowser do
  begin
    DefBackground := Browser.DefBackground;
    Refresh;
  end;
  with DicBrowser do
  begin
    DefBackground := Browser.DefBackground;
    Refresh;
  end;
  with StrongBrowser do
  begin
    DefBackground := Browser.DefBackground;
    Refresh;
  end;
  with CommentsBrowser do
  begin
    DefBackground := Browser.DefBackground;
    Refresh;
  end;
  with XrefBrowser do
  begin
    DefBackground := Browser.DefBackground;
    Refresh;
  end;
end;

procedure TMainForm.miHrefConfigClick(Sender: TObject);
var
  i, browserCount: integer;
  viewTabInfo: TViewTabInfo;

begin
  with Browser do
  begin
    DefHotSpotColor := ChooseColor(DefHotSpotColor);
    //    Browser.Repaint();//AlekId: увы, недостаточно
  end;
  viewTabInfo:=GetActiveTabInfo();
  ProcessCommand(viewTabInfo.mwsLocation,TbqHLVerseOption(ord(viewTabInfo.mHLVerses)) );
  browserCount := mViewTabs.PageCount - 1;
  for I := 0 to browserCount do
  begin
    try
      viewTabInfo := TObject(mViewTabs.Pages[i].Tag) as TViewTabInfo;
      with viewTabInfo, viewTabInfo.mHtmlViewer do
      begin
        if i <> mViewTabs.ActivePageIndex then
        begin
          DefHotSpotColor := Browser.DefHotSpotColor;
          ReloadNeeded := true;
        end;
      end                               //with
    except
    end;
  end;

  with SearchBrowser do
  begin
    DefHotSpotColor := Browser.DefHotSpotColor;
    Refresh;
  end;
  with DicBrowser do
  begin
    DefHotSpotColor := Browser.DefHotSpotColor;
    Refresh;
  end;
  with StrongBrowser do
  begin
    DefHotSpotColor := Browser.DefHotSpotColor;
    Refresh;
  end;
  with CommentsBrowser do
  begin
    DefHotSpotColor := Browser.DefHotSpotColor;
    Refresh;
  end;
  with XrefBrowser do
  begin
    DefHotSpotColor := Browser.DefHotSpotColor;
    Refresh;
  end;
end;

procedure TMainForm.miFoundTextConfigClick(Sender: TObject);

begin
  ColorDialog1.Color := Hex2Color(SelTextColor);

  if ColorDialog1.Execute then
  begin
    SelTextColor := Color2Hex(ColorDialog1.Color);
    DeferredReloadViewPages();
  end;
end;

function TMainForm.CopyPassage(fromverse, toverse: integer): WideString;
var
  i: integer;
  s: WideString;
begin
  Result := '';
  if MainBook.Lines.Count = 0 then
    MainBook.OpenChapter(MainBook.CurBook, MainBook.CurChapter);
  for i := fromverse to toverse do
  begin
    s := MainBook.Lines[i - 1];
    StrDeleteFirstNumber(s);

    if MainBook.StrongNumbers and (not StrongNumbersOn) then
      s := DeleteStrongNumbers(s);

    if (CopyOptionsCopyVerseNumbersChecked xor (IsDown(VK_CONTROL)))
      and (fromverse > 0) and (fromverse <> toverse) then
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
        s := IntToStr(i) + ' ' + s;
    end;

    if CopyOptionsAddLineBreaksChecked then
    begin
      if (CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then
        s := s + '<br>'
      else
        s := s + #13#10;
      Result := Result + s;
    end
    else
      Result := Result + ' ' + s;
  end;

  if CopyOptionsAddReferenceChecked and (CopyOptionsAddReferenceRadioItemIndex >
    0) then
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
  if (CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then begin
    mHTMLSelection := UTF8Encode(Result);
    InsertDefaultFontInfo(mHTMLSelection, Browser.DefFontName,
      Browser.DefFontSize);
//  if CopyOptionsAddLineBreaksChecked then
//    StringReplace(mHTMLSelection, #13#10, '<br>', [rfReplaceAll]);
  end
  else mHTMLSelection := '';
//  CopyHTMLToClipBoard(s, result);
  Result := s;
end;

procedure TMainForm.miCopyVerseClick(Sender: TObject);
var
  trCount: integer;
begin
  trCount := 7;
  repeat try
      TntClipboard.AsText := CopyPassage(CurVerseNumber, CurVerseNumber);
      ConvertClipboard;
      trCount := 0;
    except Dec(trCount); sleep(100); end;
  until trCount <= 0;
end;

procedure TMainForm.BrowserPopupMenuPopup(Sender: TObject);
var
  s, scap: WideString;
  i: integer;

  //  dMessage: WideString;
  //  dSrcPos: Integer;
  //  dPrevText: WideString;

begin
  if Browser.Tag <> bsText then
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

  {  dSrcPos := Browser.FindSourcePos (Browser.RightMouseClickPos);
    if dSrcPos > 500 then
      dPrevText := Copy (BrowserSource, dSrcPos - 500, 500)
    else
      dPrevText := Copy (BrowserSource, 1, dSrcPos);

    dMessage := IntToStr (Browser.RightMouseClickPos) + ', ' +
      IntToStr (dSrcPos) + #13 +
      dPrevText + '|' + #13 +
      Copy (BrowserSource, dSrcPos+1, 500);

    WStrMessageBox (dMessage);}
  CurVerseNumber := Get_ANAME_VerseNumber(
    Browser.DocumentSourceUtf16,
    CurFromVerse,
    Browser.FindSourcePos(Browser.RightMouseClickPos, true)
    );

  CurSelStart := Get_ANAME_VerseNumber(
    Browser.DocumentSourceUtf16,
    CurFromVerse,
    Browser.FindSourcePos(Browser.SelStart, true)
    );

  CurSelEnd := Get_ANAME_VerseNumber(
    Browser.DocumentSourceUtf16,
    CurFromVerse,
    Browser.FindSourcePos(Browser.SelStart + Browser.SelLength, true)
    );

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
        miCopyPassage.Caption :=
          WideFormat('%s  "%s"', [FirstWord(miCopyVerse.Caption),
          FullPassageSignature(CurBook, CurChapter, CurSelStart, CurSelEnd)]);

      miCopyVerse.Caption :=
        WideFormat('%s  "%s"', [FirstWord(miCopyVerse.Caption),
        FullPassageSignature(CurBook, CurChapter, CurVerseNumber,
          CurVerseNumber)]);

      scap := miAddBookmark.Caption;
      s := DeleteFirstWord(scap);
      s := s + ' ' + FirstWord(scap);
      miAddBookmark.Caption :=
        WideFormat('%s  "%s"', [s,
        FullPassageSignature(CurBook, CurChapter, CurVerseNumber,
          CurVerseNumber)]);

      scap := miAddMemo.Caption;
      s := DeleteFirstWord(scap);
      s := s + ' ' + FirstWord(scap);
      miAddMemo.Caption :=
        WideFormat('%s  "%s"', [s,
        FullPassageSignature(CurBook, CurChapter, CurVerseNumber,
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
  if not MainPages.Visible then
    ToggleButton.Click;

  XrefTab.Tag := 1;
  MainPages.ActivePage := XrefTab;
  ShowXref;
end;

function TMainForm.ModuleIndexByName(const awsModule: Widestring): integer;
var
  i, modulecount: integer;
begin
  result := -1;
  modulecount := ModulesList.Count - 1;
  for i := 0 to modulecount do
  begin
    if Pos(awsModule + ' $$$', ModulesList[i]) = 1 then
    begin
      result := i;
      break;
    end;
  end;

end;

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

function CustomControlAtPos(
  ParentControl: TWinControl; const Pos: TPoint; AllowDisabled,
  AllowWinControls, AllLevels: Boolean): TControl;
var
  p: TPoint;
  c: TControl;
  c2: TControl;
begin
  p := Pos;
  c := ParentControl.ControlAtPos(p, AllowDisabled, AllowWinControls, False);

  if c <> nil then
  begin
    if AllLevels and (c is TWinControl) then
    begin
      repeat
        p := c.ParentToClient(p);
        c2 := TWinControl(c).ControlAtPos(p, AllowDisabled, AllowWinControls, False);

        if c2 <> nil then
          c := c2;
      until c2 = nil;
    end;
  end;

  Result := c;
end;

procedure TMainForm.MouseWheelHandler(var Message: TMessage);
var mwm: ^TWMMouseWheel;                // absolute message;
  pt, screenPt: TPoint;
  ctrl: TControl;
  focusHwnd: HWND;
  focusedRect: TRect;
{$J+}
const oneEntry: boolean = false;
{$J-}
label tail;
begin
  if oneEntry then begin exit; end;
  oneEntry := true;
  mwm := @message;
  screenPt.X := mwm^.XPos; screenPt.y := mwm^.YPos;
  pt := ScreenToClient(screenPt);
  ctrl := CustomControlAtPos(self, pt, false, true, true);
  if not assigned(ctrl) then begin inherited MouseWheelHandler(Message); goto tail; end;

  if ctrl is TWinControl then begin
//focusHwnd:=GetFocus();
//if (focusHwnd<>0) and (focusHwnd <> TWinControl(ctrl).handle) then begin
    focusHwnd := WindowFromPoint(screenPt);
    if (focusHwnd <> 0) and (focusHwnd <> TWinControl(ctrl).handle) then begin

// if GetWindowRect(focusHWnd,focusedRect) and
//         PtInRect(focusedRect, screenPt) then begin
 //ooops
      inherited MouseWheelHandler(Message); goto tail;
    end;

    if not TWinControl(ctrl).Focused then begin
      FocusControl(TWinControl(ctrl));
      message.Result := 1;
      goto tail;
    end;
//SetFocusedControl();
//message.Result:=SendMessage(TWinControl(ctrl).Handle,Message.Msg, Message.WParam, Message.LParam)
  end;
//else message.Result:=ctrl.Perform(CM_MOUSEWHEEL, message.WParam, message.LParam);
  inherited;
  tail:
  oneEntry := false;
end;

procedure TMainForm.ShowXref;
var
  TI: TMultiLanguage;
  TF: TSearchRec;
  s, snew: WideString;
  verse, tmpverse,
    book, chapter, fromverse, toverse,
    //  rb,rc,rv,
  i, j: integer;
  RefLines: WideString;
  RefText: WideString;
  Links: TWideStrings;
  slink: WideString;
  //  was0: boolean;
  diff: integer;
begin

  if Bibles.IndexOf(MainBook.Name) = -1 then
    Exit;
  if not MainPages.Visible then
    Exit;

  if MainPages.ActivePage <> XrefTab then
    MainPages.ActivePage := XrefTab;

  if XrefTab.Tag = 0 then
    XrefTab.Tag := 1;

  RefLines := '';
  Links := TWideStringList.Create;

  //  with MainBook do
  //    RefLines.Add('<font size=-1>');

  SecondBook.IniFile := MainBook.IniFile;

  MainBook.AddressToEnglish(MainBook.CurBook, MainBook.CurChapter, XrefTab.Tag,
    book, chapter, verse);
  s := IntToStr(book);

  if Length(s) = 1 then
    s := '0' + s;
  if FindFirst(ExePath + 'TSK\' + s + '_*.ini', faAnyFile, TF) <> 0 then
    Exit;

  TI := TMultiLanguage.Create(nil);
  TI.Inifile := ExePath + 'TSK\' + TF.Name;

  SecondBook.OpenChapter(MainBook.CurBook, MainBook.CurChapter);

  tmpverse := XrefTab.Tag;

  if tmpverse > SecondBook.Lines.Count then
    tmpverse := SecondBook.Lines.Count;
  s := SecondBook.Lines[tmpverse - 1];
  StrDeleteFirstNumber(s);
  s := DeleteStrongNumbers(s);

  RefText :=
    WideFormat('<a name=%d><a href="go %s %d %d %d">%s%d:%d</a><br><font face="%s">%s</font><p>',
    [tmpverse, MainBook.ShortPath,
    MainBook.CurBook, MainBook.CurChapter, tmpverse,
      MainBook.ShortNames[MainBook.CurBook], MainBook.CurChapter, tmpverse,
      MainBook.FontName, s]);

  slink := TI.ReadString(IntToStr(chapter), IntToStr(verse), '');
  if slink = '' then
    AddLine(RefLines, RefText + '<b>.............</b>')
      //RefLines.Add(RefText + '<hr>')
  else
  begin
    StrToLinks(slink, Links);

    // get xrefs
    for i := 0 to Links.Count - 1 do
    begin
      if not SecondBook.OpenTSKAddress(Links[i], book, chapter, fromverse,
        toverse) then
        continue;

      diff := toverse - fromverse;
      SecondBook.ENG2RUS(book, chapter, fromverse, book, chapter, fromverse);

      if not SecondBook.InternalToAddress(book, chapter, fromverse, book,
        chapter, fromverse) then
        continue;                       // if this module doesn't have the link...

      toverse := fromverse + diff;

      if fromverse = 0 then
        fromverse := 1;
      if toverse < fromverse then
        toverse := fromverse;           // if one verse

      try
        SecondBook.OpenChapter(book, chapter);
      except
        continue;
      end;

      if fromverse > SecondBook.Lines.Count then
        continue;
      if toverse > SecondBook.Lines.Count then
        toverse := SecondBook.Lines.Count;

      s := '';
      for j := fromverse to toverse do
      begin
        snew := SecondBook.Lines[j - 1];
        s := s + ' ' + StrDeleteFirstNumber(snew);
        snew := DeleteStrongNumbers(snew);
        s := s + ' ' + snew;
      end;
      s := Trim(s);

      StrDeleteFirstNumber(s);

      if toverse = fromverse then
        RefText := RefText +
          WideFormat('<a href="go %s %d %d %d %d">%s</a> <font face="%s">%s</font><br>',
          [MainBook.ShortPath,
          book, chapter, fromverse, 0,
            SecondBook.ShortPassageSignature(book, chapter, fromverse, toverse),
            MainBook.FontName, s])
      else
        RefText := RefText +
          WideFormat(
          '<a href="go %s %d %d %d %d">%s</a> <font face="%s">%s</font><br>',
          [
          MainBook.ShortPath,
            book,
            chapter,
            fromverse,
            toverse,
            SecondBook.ShortPassageSignature(book, chapter, fromverse, toverse),
            MainBook.FontName,
            s
            ]
            );
    end;

    AddLine(RefLines, RefText);
  end;

  AddLine(RefLines, '</font><br><br>');

  //  XrefBrowser.CharSet := MainBook.FontCharset;
  XRefBrowser.DefFontName := Browser.DefFontName;
  mXRefMisUsed := false;
  XRefBrowser.LoadFromString(RefLines);

  //XrefBrowser.PositionTo(IntToStr(XrefTab.Tag));

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

  if XrefTab.Tag = 0 then XrefTab.Tag := 1;

  RefLines := TWideStringList.Create;

  with MainBook do
    RefLines.Add('<font size=-1>');

  XRefCur := 1;

  SecondBook.IniFile := MainBook.IniFile;

  book := MainBook.CurBook;
  chapter := MainBook.CurChapter;
  //numverses := MainBook.CountVerses(book, chapter);
  verse := XrefTab.Tag;

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

  XRefBrowser.LoadStrings(RefLines);
  XrefBrowser.CharSet := MainBook.FontCharset;

  XrefBrowser.PositionTo(IntToStr(XrefTab.Tag));
end;
}

procedure TMainForm.SoundButtonClick(Sender: TObject);
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
    Browser.LoadStrings(BrowserSource);
    Exit;
  }
  if not MainBook.isBible then
    Exit;

  MainBook.InternalToAddress(MainBook.CurBook, MainBook.CurChapter, 1, book,
    chapter, verse);

  if MainBook.SoundDirectory = '' then
  begin                                 // 3 digits
    fname3 := WideFormat('Sounds\%.2d\%.3d', [book, chapter]);
    fname2 := WideFormat('Sounds\%.2d\%.2d', [book, chapter]);
  end
  else
  begin                                 // 2 digits
    fname3 := WideFormat('%s\%.2d\%.3d', [MainBook.SoundDirectory, book,
      chapter]);
    fname2 := WideFormat('%s\%.2d\%.2d', [MainBook.SoundDirectory, book,
      chapter]);
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
    WideShowMessage(WideFormat(Lang.Say('SoundNotFound'),
      [Browser.DocumentTitle]));
    Exit;
  end
  else
  begin
    ShellExecute(Application.Handle, nil, PChar(find), nil, nil, SW_MINIMIZE);
    //ActiveControl := Browser;
  end;
end;

procedure TMainForm.miHotkeyClick(Sender: TObject);
begin
  ConfigForm.PageControl1.ActivePageIndex := 1;
  ShowConfigDialog;
  //ShowMessage('Просто перетащите корешок закладки той страницы,'
  //+#13#10' на которой отображается нужный модуль на закладку панели Любимых Модулей');
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

(*AlekId: добавлено*)

procedure TMainForm.miDeteleBibleTabClick(Sender: TObject);
var me: TModuleEntry;
begin
  if miDeteleBibleTab.Tag < 0 then
    exit;
  try
    me := (mBibleTabsEx.WideTabs.Objects[miDeteleBibleTab.Tag]) as TModuleEntry;
    mFavorites.DeleteModule(me);
  except
  end;
end;
(*AlekId:/добавлено*)

procedure TMainForm.miDialogFontConfigClick(Sender: TObject);
var
  fnt: TFont;
  h: integer;
begin
  with FontDialog1 do
  begin
    Font.Name := MainForm.Font.Name;
    Font.Size := MainForm.Font.Size;
    Font.Charset := MainForm.Font.Charset;
  end;

  if FontDialog1.Execute then
    with MainForm do
    begin
      fnt := TFont.Create;
      try
        fnt.Name := FontDialog1.Font.Name;
        fnt.Charset := FontDialog1.Font.Charset;
        fnt.Size := FontDialog1.Font.Size;

        self.Font := fnt;
        mBibleTabsEx.Font.Assign(fnt);
        Screen.HintFont := fnt;
        h := fnt.Height;
        if h < 0 then
          h := -h;
        mBibleTabsEx.Height := h + 13;
        Update;
        lbTitleLabel.Font.Assign(fnt);
        lbCopyRightNotice.Font.Assign(fnt);
        vstDicList.DefaultNodeHeight := Canvas.TextHeight('X') * 6 div 5;
        vstDicList.ReinitNode(vstDicList.RootNode, true);
        vstDicList.Invalidate();
        vstDicList.Repaint();
        if Assigned(frmQNav) then begin frmQNav.Font.Assign(Font);
          frmQNav.Font.Height := frmQNav.Font.Height * 5 div 4;
          frmQNav.Refresh();

        end;

      finally fnt.Free end

    end;

end;

procedure TMainForm.miCopyPassageClick(Sender: TObject);
var
  trCount: integer;
begin
  trCount := 7;
  repeat try
      TntClipboard.AsText := CopyPassage(CurSelStart, CurSelEnd);
      ConvertClipboard;
      trCount := 0;
    except Dec(trCount); sleep(100); end;
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
  AFont.Name := Browser.DefFontName;
  AFont.Charset := Browser.Charset;
  AFont.Size := 10;
  with Canvas do
  begin
    Font.Assign(AFont);
    SetBkMode(Handle, Transparent);
    SetTextAlign(Handle, TA_Top or TA_RIGHT);
    TextOut(W-50, 20, Browser.DocumentTitle);
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
  AFont.Name := Browser.DefFontName;
  AFont.Charset := Browser.Charset;
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

procedure TMainForm.MainBookVerseFound(Sender: TObject; NumVersesFound,
  book, chapter, verse: Integer; s: WideString);
var
  i: integer;
begin
  SearchLabel.Caption :=
    WideFormat('[%d] %s', [NumVersesFound, MainBook.FullNames[book]]);

  if s <> '' then
  begin
    s := ParseHTML(s, '');
    if MainBook.StrongNumbers and (not StrongNumbersOn) then
      s := DeleteStrongNumbers(s);
    StrDeleteFirstNumber(s);

    // color search result!!!

    for i := 0 to SearchWords.Count - 1 do
      StrColorUp(s, SearchWords[i], '<*>', '</*>', CBCase.Checked);

    SearchResults.Add(
      WideFormat('<a href="go %s %d %d %d 0">%s</a> <font face="%s">%s</font><br>',
      [MainBook.ShortPath, book, chapter, verse,
      MainBook.ShortPassageSignature(book, chapter, verse, verse),
        MainBook.FontName,
        s
        ]));
  end;

  Application.ProcessMessages;
end;

procedure TMainForm.MainBookChangeModule(Sender: TObject);
begin
  BooksCB.ItemIndex := BooksCB.Items.IndexOf(MainBook.Name);
  UpdateBooksAndChaptersBoxes();
  StrongNumbersButton.Enabled := MainBook.StrongNumbers;
  SearchListInit;
  Caption := MainBook.Name + ' — BibleQuote';

end;

procedure TMainForm.HelpButtonClick(Sender: TObject);
var
  s: WideString;
begin
  s := 'file ' + ExePath + 'help\' + HelpFileName
    + ' $$$' + Lang.Say('MainForm.HelpButton.Hint');

  ProcessCommand(s, hlFalse);
end;

procedure TMainForm.FirstBrowserMouseDouble(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  num, code: integer;
begin
  if not mDictionariesFullyInitialized then
  begin
    LoadDictionaries(MaxInt);
  end;

  Val(Trim(Browser.SelText), num, code);
  if code = 0 then
  begin
    DisplayStrongs(num, (MainBook.CurBook < 40) and (MainBook.HasOldTestament));
  end
  else
  begin
    DisplayDictionary(Trim(Browser.SelText));
  end;

  if not MainPages.Visible then
    ToggleButton.Click;
end;

procedure TMainForm.FirstBrowserMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  section, s: TSectionBase;
  topPos, index, i, c: integer;
  classname: string;
  sl: TSectionList;
begin
//
  section :=
    Browser.SectionList.FindSectionAtPosition(Browser.LeftMouseClickPos, topPos,
    index);
//repeat
  if section = nil then exit;
  classname := section.ClassName;
  OutputDebugString(Pointer(classname));
  sl := section.ParentSectionList;
  c := sl.Count;
  i := index;

{repeat
s:= sl.Items[i];
Dec(i);
OutputDebugString(Pointer(string(s.classname)));
until i<0;}
//section.ParentSectionList
//if section is TSection then

//until
end;

procedure TMainForm.FirstBrowserMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  fontSize: integer;
  delta: integer;

begin
  if not (ssCtrl in Shift) then exit;
  Handled := true;
  fontSize := Browser.DefFontSize;
  delta := round(fontSize / 10); if delta = 0 then delta := 1;
  if WheelDelta < 0 then delta := -delta;
  FontChanged(delta);
//ProcessCommand(History[HistoryLB.ItemIndex]);
end;

procedure TMainForm.DisplayDictionary(s: WideString);
var
  res: WideString;
  //  Key: Word;
  //  KeyChar: Char;
  i, j: integer;
  dc_ix: integer;
  nd: PVirtualNode;
begin
  if Trim(s) = '' then
    Exit;

  if DicEdit.Items.IndexOf(s) = -1 then
    DicEdit.Items.Insert(0, s);

  MainPages.ActivePage := DicTab;

  DicEdit.Text := s;

  dc_ix := LocateDicItem;               // find the word or closest...
  if dc_ix < 0 then begin MessageBeep(MB_ICONERROR); exit end;
  nd := PVirtualNode(mDIcList.Objects[dc_ix]);
  vstDicList.Selected[nd] := true;
  DicScrollNode(nd);
  DicCB.Items.BeginUpdate;
  try
    DicCB.Items.Clear;

    j := 0;

    for i := 0 to DicsCount - 1 do
    begin
      res := Dics[i].Lookup(mDicList[dc_ix]);
      if res <> '' then
        DicCB.Items.Add(Dics[i].Name);

      if Dics[i].Name = DicFilterCB.Items[DicFilterCB.ItemIndex] then
        j := DicCB.Items.Count - 1;
    end;

    if DicCB.Items.Count > 0 then
      DicCB.ItemIndex := j;
  finally
    DicCB.Items.EndUpdate;
  end;
  //DicCB.Enabled := not (DicCB.Items.Count = 1);
  //DicCBPanel.Visible := not (DicCB.Items.Count = 1);

  DicCB.Enabled := not (DicCB.Items.Count = 1);

  if DicCB.Items.Count = 1 then
    DicFoundSeveral.Caption := Lang.Say('FoundInOneDictionary')
  else
    DicFoundSeveral.Caption := Lang.Say('FoundInSeveralDictionaries');

  if DicCB.Items.Count > 0 then
    DicCBChange(Self)                   // invoke showing first dictionary result
    {
      else
      begin
        repeat
          DicEditKeyUp(nil, Key, []);
          if (DicEdit.Text <> '') and
          (WideLowerCase(DicEdit.Text) <> WideLowerCase(DicLB.Items[0])) and
          (DicLB.ItemIndex = 0) then
            DicEdit.Text := Copy(DicEdit.Text,1,Length(DicEdit.Text)-1);
        until (DicEdit.Text = '') or (DicLB.ItemIndex <> 0);

        //ActiveControl := DicEdit;
        KeyChar := #13;
        DicEditKeyPress(nil, KeyChar);
      end;
    }
end;

procedure TMainForm.DisplayStrongs(num: integer; hebrew: boolean);
var
  res, s, copyright: WideString;
  i: integer;
begin
  //if num = 0 then Exit;

  s := IntToStr(num);
  for i := Length(s) to 4 do
    s := '0' + s;

  if ((MainBook.StrongsDirectory = '') and (StrongsDir <> 'Strongs'))
    or ((MainBook.StrongsDirectory <> '') and (StrongsDir <>
    MainBook.StrongsDirectory)) then
  begin
    // re-initialize Strongs ....

    StrongsDir := MainBook.StrongsDirectory;
    if StrongsDir = '' then
      StrongsDir := 'Strongs';

    if not (StrongHebrew.Initialize(ExePath + StrongsDir + '\hebrew.idx',
      ExePath + StrongsDir + '\hebrew.htm')) then
      WideShowMessage('Error in' + ExePath + StrongsDir + '\hebrew.*');

    if not (StrongGreek.Initialize(ExePath + StrongsDir + '\greek.idx',
      ExePath + StrongsDir + '\greek.htm')) then
      WideShowMessage('Error in' + ExePath + StrongsDir + '\greek.*');
  end;

  if hebrew or (num = 0) then
  begin
    res := StrongHebrew.Lookup(s);
    copyright := StrongHebrew.Name;
  end
  else
  begin
    res := StrongGreek.Lookup(s);
    copyright := StrongGreek.Name;
  end;

  MainPages.ActivePage := StrongTab;

  if res <> '' then
  begin
    res := FormatStrongNumbers(res, false, false);

    AddLine(res, '<p><font size=-1>' + copyright + '</font>');
    StrongBrowser.LoadFromString(res);

    s := IntToStr(num);
    if hebrew then
      s := '0' + s;

    i := StrongLB.Items.IndexOf(s);
    if i = -1 then
    begin
      StrongLB.Items.Add(s);
      StrongLB.ItemIndex := StrongLB.Items.Count - 1;
    end
    else
      StrongLB.ItemIndex := i;
  end;

end;

procedure TMainForm.FirstBrowserKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  oxt, oct: integer;
begin
  if Copy(GetActiveTabInfo().mwsLocation, 1, 4) = 'file' then
    Exit;

  if (Key = VK_NEXT) and (Browser.Position = BrowserPosition) then begin
    GoNextChapter;
    exit;
  end;
  if (Key = VK_PRIOR) and (Browser.Position = BrowserPosition) then
  begin
    GoPrevChapter;
    if (MainBook.CurBook <> 1) or (MainBook.CurChapter <> 1) then
      Browser.PositionTo('endofchapterNMFHJAHSTDGF123');
    exit;
  end;
  if key = $4C then begin miRecognizeBibleLinks.Click(); exit end;

  if ssAlt in Shift then begin
    if Key = VK_LEFT then begin
      BackButton.Click; exit;
    end;
    if Key = VK_RIGHT then begin
      ForwardButton.Click; exit
    end;
  end;

  //Browser.AcceptClick(Sender, Browser.Width div 2, 10);
  if key = VK_SPACE then begin
    oxt := XrefTab.Tag;
    oct := CommentsTab.Tag;
    XrefTab.Tag := Get_ANAME_VerseNumber(
      Browser.DocumentSourceUtf16,
      CurFromVerse,
      Browser.FindSourcePos(Browser.CaretPos, true)
      );
    CommentsTab.Tag := XrefTab.Tag;
    if (MainPages.ActivePage = XrefTab) and (oxt <> XrefTab.Tag) then begin
      ShowXref;
      exit

    end;

    if (MainPages.ActivePage = CommentsTab) and (oct <> CommentsTab.Tag) then begin
      ShowComments;
      exit
    end;
  end;
end;

procedure TMainForm.miPrintPreviewClick(Sender: TObject);
begin
  PreviewButtonClick(Sender);
end;

procedure TMainForm.HistoryLBDblClick(Sender: TObject);
var
  s: WideString;
begin
  s := History[HistoryLB.ItemIndex];

  History.Delete(HistoryLB.ItemIndex);
  HistoryLB.Items.Delete(HistoryLB.ItemIndex);

  ProcessCommand(s,hlDefault);
  //ComplexLinksPanel.Visible := false;
  {LinksCB.Visible := false;}
  tbLinksToolBar.Visible := false;
end;

procedure TMainForm.miStrongClick(Sender: TObject);
var
  vti: TViewTabInfo;
begin
  miStrong.Checked := not miStrong.Checked;
  StrongNumbersOn := miStrong.Checked;
  StrongNumbersButton.Down := StrongNumbersOn;
  vti := GetActiveTabInfo();
  vti.mShowStrongs := StrongNumbersOn;
  if not MainBook.StrongNumbers then begin
    StrongNumbersButton.Enabled := false;
    Exit;
  end;
  ProcessCommand(vti.mwsLocation, TbqHLVerseOption(ord(vti.mHLVerses)));
  if MainPages.Visible and StrongNumbersOn then
    MainPages.ActivePage := StrongTab;
end;

procedure TMainForm.miVerseHLBkgndClClick(Sender: TObject);
var cl, newcl:TColor;
begin
try cl:=Hex2Color(g_VerseBkHlColor); except cl:=$F5F5DC; end;
newcl:= ChooseColor(cl);
if newcl<>cl then  begin g_VerseBkHlColor:=Color2Hex(newcl);
DeferredReloadViewPages();
end;
end;

procedure TMainForm.ConvertClipboard;
begin
  if not (CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then
    Exit;
//  TRE.SelectAll;
//  TRE.ClearSelection;
  //TRE.Lines.Clear;
  if MainBook.FontName <> '' then
    TRE.Font.Name := MainBook.FontName
  else
    TRE.Font.Name := Browser.DefFontName;

  TRE.Font.Size := Browser.DefFontSize;
  TRE.Lines.Add(TntClipboard.AsText);

  TRE.SelectAll;
  TRE.SelAttributes.Charset := Browser.Charset;
  TRE.SelAttributes.Name := TRE.Font.Name;

  if length(mHTMLSelection) > 0 then CopyHTMLToClipBoard('', mHTMLSelection)
  else TRE.CopyToClipboard;
end;

procedure TMainForm.DisplaySearchResults(page: integer);
var
  i, limit: integer;
  s: WideString;
  dSource: WideString;
begin

  if (SearchPageSize * (page - 1) > SearchResults.Count) or (SearchResults.Count
    = 0) then
  begin
    Screen.Cursor := crDefault;
    Exit;
  end;

  SearchPage := page;

  dSource := WideFormat(
    '<b>"<font face="%s">%s</font>"</b> (%d) <p>',
    [
    MainBook.FontName,
      SearchCB.Text,
      SearchResults.Count
      ]
      );

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
      s := s + WideFormat('<a href="%d">%d-%d</a> ', [i, SearchPageSize * (i - 1)
        + 1, SearchPageSize * i])
    else
      s := s + WideFormat('%d-%d ', [SearchPageSize * (i - 1) + 1, SearchPageSize
        * i]);
  end;

  if limit <> page then
    s := s + WideFormat('<a href="%d">%d-%d</a> ', [limit, SearchPageSize *
      (limit - 1) + 1, SearchResults.Count])
  else
    s := s + WideFormat('%d-%d ', [SearchPageSize * (limit - 1) + 1,
      SearchResults.Count]);

  //SearchBrowserSource.Add(s + '<p>');

  limit := SearchPageSize * page - 1;
  if limit >= SearchResults.Count then
    limit := SearchResults.Count - 1;

  for i := SearchPageSize * (page - 1) to limit do
    AddLine(dSource, '<font size=-1>' + IntToStr(i + 1) + '.</font> ' +
      SearchResults[i]);

  AddLine(dSource, '<a name="endofsearchresults"><p>' + s + '<br><p>');

  SearchBrowser.Charset := Browser.Charset;

  StrReplace(dSource, '<*>', '<font color=' + SelTextColor + '>', true);
  StrReplace(dSource, '</*>', '</font>', true);

  SearchBrowser.LoadFromString(dSource);

  LastSearchResultsPage := page;
  Screen.Cursor := crDefault;
  ActiveControl := SearchBrowser;
end;

procedure TMainForm.SearchBrowserHotSpotClick(Sender: TObject;
  const SRC: string; var Handled: Boolean);
var
  i, code: integer;
  book, chapter, fromverse, toverse: integer;
  wsrc, satBible: WideString;
  ti: TViewTabInfo;
begin
  wsrc := UTF8Decode(src);
  Val(wSRC, i, code);
  if code = 0 then
    DisplaySearchResults(i)
  else begin
    if (Copy(wSRC, 1, 3) <> 'go ') then begin
      if MainBook.OpenAddress(wSRC, book, chapter, fromverse, toverse) then
        wsrc := WideFormat('go %s %d %d %d %d',
          [MainBook.ShortPath, book, chapter, fromverse, toverse])
      else wsrc := '';
    end;
    if length(wsrc) > 0 then begin
      if IsDown(VK_MENU) then begin
        ti := GetActiveTabInfo();
        if assigned(ti) then
          satBible := ti.mSatelliteName
        else satBible := '------';

        NewViewTab(wSRC, satBible, miStrong.Checked,
          miMemosToggle.Checked, miRecognizeBibleLinks.Checked)

      end
      else
        ProcessCommand(wsrc, hlTrue );
    end;
  end;
  Handled := true;
end;

procedure TMainForm.miSearchWordClick(Sender: TObject);
begin
  if Browser.SelLength = 0 then
    Exit;

  IsSearching := false;
  SearchCB.Text := Trim(Browser.SelText);
  miSearch.Click;
  FindButtonClick(Sender);
end;

procedure TMainForm.miCompareClick(Sender: TObject);
var
  book, chapter, verse, ib, ic, iv: integer;
  imenu, i: integer;
  found: boolean;
  s: WideString;
  dBrowserSource: WideString;
  fontFound: boolean;
  fontName: WideString;
begin
  if not MainBook.isBible then
    Exit;
  //try
  dBrowserSource := '<font size=+1><table>';
  Browser.DefFontName := mBrowserDefaultFontName;
  MainBook.OpenChapter(MainBook.CurBook, MainBook.CurChapter);
  s := MainBook.Lines[CurVerseNumber - 1];
  StrDeleteFirstNumber(s);
  if not StrongNumbersOn then
    s := DeleteStrongNumbers(s);

  AddLine(dBrowserSource,
    WideFormat(
    '<tr><td valign=top><a href="go %s %d %d %d 0">%s&nbsp;%s</a>&nbsp;</td><td valign=top><font face="%s">%s</font></td>',
    [
    MainBook.ShortPath,
      MainBook.CurBook,
      MainBook.CurChapter,
      CurVerseNumber,
      MainBook.ShortName,
      MainBook.ShortPassageSignature(MainBook.CurBook, MainBook.CurChapter,
      CurVerseNumber, CurVerseNumber),
      MainBook.FontName,
      s
      ]
      )
    );

  AddLine(dBrowserSource,
    '<tr><td></td><td><hr width=100%></td></tr>'
    );

  for imenu := 0 to Bibles.Count - 1 do
  begin
    found := false;
    for i := 0 to ModulesList.Count - 1 do
    begin
      if Pos(Bibles[imenu] + ' $$$', ModulesList[i]) = 1 then
      begin
        found := true;
        break;
      end;
    end;
    if found then
    begin
      if ExePath + Comment(ModulesList[i]) + '\bibleqt.ini' = MainBook.IniFile then
        Continue;

      SecondBook.IniFile := MainFileExists(Comment(ModulesList[i]) +
        '\bibleqt.ini');

      // don't display New Testament mixed with Old Testament...

      if (MainBook.CurBook < 40) and (MainBook.HasOldTestament) and (not
        SecondBook.HasOldTestament) then
        Continue;

      if (MainBook.CurBook > 39) and (MainBook.HasNewTestament) and (not
        SecondBook.HasNewTestament) then
        Continue;

      with MainBook do
        AddressToInternal(CurBook, CurChapter, CurVerseNumber, book, chapter,
          verse);

      SecondBook.InternalToAddress(book, chapter, verse, ib, ic, iv);

      try
        SecondBook.OpenChapter(ib, ic);
      except
        continue;
      end;

      if iv > SecondBook.Lines.Count then
        continue;

      s := SecondBook.Lines[iv - 1];
      StrDeleteFirstNumber(s);

      if not StrongNumbersOn then
        s := DeleteStrongNumbers(s);

      if length(SecondBook.FontName) > 0 then begin
        fontFound := PrepareFont(SecondBook.FontName, SecondBook.Path);
        fontName := SecondBook.FontName; end
      else fontFound := false;
       (*если предподчтительного шрифта нет или он не найден и указана кодировка*)
      if not fontFound and (SecondBook.DesiredCharset >= 2) then
      begin
        {находим шрифт с нужной кодировкой учитывая предподчтительный и дефолтный}
        if length(SecondBook.FontName) > 0 then
          fontName := SecondBook.FontName
        else
          fontName := mBrowserDefaultFontName;
        fontname := FontFromCharset(self.Canvas.Handle,
          SecondBook.DesiredCharset,
          fontName);
      end;

      AddLine(dBrowserSource,
        WideFormat(
        '<tr><td valign=top><a href="go %s %d %d %d 0">%s&nbsp;%s</a>&nbsp;' +
        '<BR><SPAN STYLE="font-size:67%%">%s</SPAN></td><td valign=top><font face="%s">%s</font></td>',
        [
        SecondBook.ShortPath,
          ib,
          ic,
          iv,
          SecondBook.ShortName,
          SecondBook.ShortPassageSignature(ib, ic, iv, iv),
          SecondBook.Name,
          fontName,
          s
          ]
          )
        );
    end;
  end;

  AddLine(dBrowserSource, '</table>');

  //Browser.Charset := DefaultCharset;
  Browser.LoadFromString(dBrowserSource);
//  except MessageBeep(MB_ICONEXCLAMATION); end;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  i: integer;
begin
  if MainFormInitialized then
    Exit;                               // run only once...
  MainFormInitialized := true;

  //SearchBoxPanel.Height := CBAll.Top; // hide search options

  //ComplexLinksPanel.Visible := false;

  HistoryBookmarkPages.ActivePage := HistoryTab;

  //LinksCB.Visible := false;
  tbLinksToolBar.Visible := false;
  CBQty.ItemIndex := 0;

  ConfigForm.Font := MainForm.Font;
  ConfigForm.Font.Charset := MainForm.Font.Charset;

  Lang.TranslateForm(ConfigForm);

  ConfigForm.CopyVerseNumbers.Checked := CopyOptionsCopyVerseNumbersChecked;
  ConfigForm.CopyFontParams.Checked := CopyOptionsCopyFontParamsChecked;
  ConfigForm.AddReference.Checked := CopyOptionsAddReferenceChecked;
  ConfigForm.AddReferenceRadio.ItemIndex :=
    CopyOptionsAddReferenceRadioItemIndex;
  ConfigForm.AddLineBreaks.Checked := CopyOptionsAddLineBreaksChecked;
  ConfigForm.AddModuleName.Checked := CopyOptionsAddModuleNameChecked;

  ConfigForm.AddReferenceRadio.Items[0] :=
    Lang.Say('CopyOptionsAddReference_ShortAtBeginning');
  ConfigForm.AddReferenceRadio.Items[1] :=
    Lang.Say('CopyOptionsAddReference_ShortAtEnd');
  ConfigForm.AddReferenceRadio.Items[2] :=
    Lang.Say('CopyOptionsAddReference_FullAtEnd');
  //  InitHotModulesConfigPage(true);
  Splitter1Moved(Sender);
  Splitter2Moved(Sender);

  if SatelliteBible = '' then
    //SatelliteMenuItemClick(SatelliteMenu.Items[0])
  else
  begin
//    for i := 1 to SatelliteMenu.Items.Count - 1 do
//      if SatelliteMenu.Items[i].Caption = SatelliteBible then
//      begin
//        //SatelliteMenu.Items[i].Checked := true;
//        SatelliteMenuItemClick(SatelliteMenu.Items[i]);
//      end;
  end;
  try
    ActiveControl := Browser;
  except
  end;

end;

procedure TMainForm.LinksCBChange(Sender: TObject);
var
  book, chapter, fromverse, toverse: integer;
begin
  GoEdit.Text := LinksCB.Items[LinksCB.ItemIndex];

  if MainBook.OpenAddress(GoEdit.Text, book, chapter, fromverse, toverse) then
    ProcessCommand(WideFormat('go %s %d %d %d %d',
      [MainBook.ShortPath, book, chapter, fromverse, toverse]), hlDefault)
  else
    ProcessCommand(GoEdit.Text,hlDefault);
end;

function TMainForm.DefaultLocation: WideString;

var
  i, ix, fc, bi: integer;
  bible: WideString;
begin
  result := '';
  try
    if Bibles.Count = 0 then
      raise
        Exception.Create('Не найдено ни одного библейского модуля!');
    fc := mFavorites.mModuleEntries.Count - 1;
    bi := -1;
    for i := 0 to fc do
    begin
      bible := TModuleEntry(mFavorites.mModuleEntries[i]).wsFullName;
      bi := Bibles.IndexOf(bible);
      if bi >= 0 then break;
    end;
    if bi < 0 then begin
      bi := 0;
      bible := Bibles[0];
    end;
    ix := mModules.FindByName(bible);
    if ix < 0 then begin raise TBQException.Create('Cannot Find Bible');
    end;
    result := TModuleEntry(mModules[ix]).wsShortPath;
  except
    on e: Exception do begin
      BqShowException(e, 'Error calculating Default Location:');
      result := 'rststrong';
    end;
  end;
end;

procedure TMainForm.DeferredReloadViewPages;
var i,c:integer;
    ti, cti:TViewTabInfo;
begin
ti:=GetActiveTabInfo();
c:=mViewTabs.PageCount-1;
for i := 0 to c do begin
try
cti:=TViewTabInfo(TObject(mViewTabs.Pages[i].Tag) as TViewTabInfo);
if cti<>ti then cti.ReloadNeeded:=true;
except end;
end;
ProcessCommand(ti.mwsLocation,TbqHLVerseOption(ord(ti.mHLVerses)));
end;

procedure TMainForm.DeleteHotModule(moduleTabIx: integer);
var
  hotMenuItem, favouriteMenuItem: TTntMenuItem;

begin
  try
    hotMenuItem := mBibleTabsEx.WideTabs.Objects[moduleTabIx] as TTntMenuItem;

    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    if not Assigned(favouriteMenuItem) then
      exit;
    favouriteMenuItem.Remove(hotMenuItem);
    mBibleTabsEx.WideTabs.Delete(moduleTabIx);
    hotMenuItem.Free();
    AdjustBibleTabs(MainBook.ShortName);
    SetFavouritesShortcuts();
  except                                {}
  end;
end;

procedure TMainForm.DicBrowserHotSpotClick(Sender: TObject;
  const SRC: string; var Handled: Boolean);
  var cmd, prefBible: widestring;
  autocmd: boolean;
  currentModule:TBible;

begin
//AlekId
//  MainBook.IniFile := MainFileExists(mDefaultLocation + '\bibleqt.ini');
  cmd := UTF8Decode(SRC);
  autocmd := Pos(C__bqAutoBible, cmd) <> 0;
  if autocmd then begin
    currentModule:= GetActiveTabInfo().mBible;
    if currentModule.isBible then prefBible:=currentModule.ShortPath
    else prefBible:='';
    cmd := PreProcessAutoCommand(cmd, prefBible);
  end;

  Handled := True;
  if IsDown(VK_MENU) then begin
    if autocmd then G_XRefVerseCmd := UTF8Encode(cmd)
    else G_XRefVerseCmd := SRC;
    miOpenNewViewClick(sender);
  end
  else begin
   if autocmd then ProcessCommand(cmd, hlDefault)
   else begin
    GoEdit.Text := UTF8Decode(SRC);     //AlekId: и все дела!
    GoEditDblClick(nil);
    end
  end;
end;

procedure TMainForm.CommentsBrowserHotSpotClick(Sender: TObject;
  const SRC: string; var Handled: Boolean);
var cmd, prefBible: widestring;
  autocmd: boolean;
  currentModule:TBible;

begin
  Handled := True;
  cmd := UTF8Decode(SRC);
  autocmd := Pos(C__bqAutoBible, cmd) <> 0;
  if autocmd then begin
    currentModule:= GetActiveTabInfo().mBible;
    if currentModule.isBible then prefBible:=currentModule.ShortPath
    else prefBible:='';
    cmd := PreProcessAutoCommand(cmd, prefBible);
  end;
  if IsDown(VK_MENU) then begin
    if autocmd then G_XRefVerseCmd := UTF8Encode(cmd)
    else G_XRefVerseCmd := SRC;
    miOpenNewViewClick(sender);
  end
  else begin
    if autocmd then ProcessCommand(cmd, hlDefault)
    else begin
      GoEdit.Text := cmd;               //AlekId: и все дела!
      GoEditDblClick(nil);
    end;
  end;
end;

procedure TMainForm.StrongBrowserMouseDouble(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  num, code: integer;
begin
  Val(Trim(StrongBrowser.SelText), num, code);

  if code = 0 then
    DisplayStrongs(num, Copy(Trim(StrongBrowser.SelText), 1, 1) = '0')
  else
    DisplayDictionary(Trim(StrongBrowser.SelText));
end;

procedure TMainForm.DicLBDblClick(Sender: TObject);
var ix: integer;
begin
  ix := DicSelectedItemIndex();
  if ix >= 0 then
    DisplayDictionary(mDicList[ix]);
end;

procedure TMainForm.SplitterMoved(Sender: TObject);
begin
  vstDicList.Height := DicPanel.Height - DicEdit.Height - 15;
  vstDicList.Top := DicEdit.Top + 27;

  StrongLB.Height := StrongPanel.Height - StrongEdit.Height - 15;
  StrongLB.Top := StrongEdit.Top + 27;
end;

procedure TMainForm.DicEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    //    if (Length(DicEdit.Text) > 0) and (DicLB.ItemIndex > -1) then
    //      DisplayDictionary(DicLB.Items[DicLB.ItemIndex]);
    DisplayDictionary(DicEdit.Text);
  end;
end;

procedure TMainForm.StrongEditKeyPress(Sender: TObject; var Key: Char);
var
  num, code: integer;
begin
  if Key = #13 then
  begin
    Key := #0;

    Val(Trim(StrongEdit.Text), num, code);

    if code = 0 then
      DisplayStrongs(num, Copy(Trim(StrongEdit.Text), 1, 1) = '0')
  end;
end;

procedure TMainForm.WMQueryEndSession(var Message: TWMQueryEndSession);
begin
  FInShutdown := True;
  try
    inherited;
    MainForm.Close();
  finally
    FInShutdown := False;
  end;
end;

function TMainForm.TabInfoFromBrowser(browser: THTMLViewer): TViewTabInfo;
var
  pageCount, i: integer;
  vti: TViewTabInfo;
begin
  result := nil;
  pageCount := mViewTabs.PageCount - 1;
  for i := 0 to pageCount do
  try
    vti := TObject(mViewTabs.ActivePage.Tag) as TViewTabInfo;
    if vti.mHtmlViewer = browser then
    begin
      result := vti;
      break;
    end;
  except
  end;

end;
{function _escallback(dwCookie: Longint; pbBuff: PByte;
    cb: Longint; var pcb: Longint): Longint; stdcall;
begin

end;}

{procedure TMainForm.tbAddBibleLinkClick(Sender: TObject);
var es:TEditStream;
begin
//es.dwCookie=0;
//es.pfnCallback:=_escallback;
//SendMessage(TREMemo.Handle, EM_STREAMIN,SF_RTF, SFF_SELECTION, Longint(@es));
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
end;}

procedure TMainForm.TntFormActivate(Sender: TObject);
var
  ctrlIsDown: boolean;
begin
  ctrlIsDown := IsDown(VK_CONTROL);
  if ctrlIsDown = G_ControlKeyDown then exit;
  G_ControlKeyDown := ctrlIsDown;
  SetBibleTabsHintsState(ctrlIsDown);
end;

procedure TMainForm.TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := true;
end;

procedure TMainForm.TntFormDblClick(Sender: TObject);
begin
//
end;

procedure TMainForm.TntFormDeactivate(Sender: TObject);
begin
  if G_ControlKeyDown then begin
    SetBibleTabsHintsState(false);
    G_ControlKeyDown := false;
  end
end;

procedure TMainForm.TntFormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
//
//self.ControlAtPos
end;

procedure TMainForm.tbtnAddNodeClick(Sender: TObject);
begin
  InputForm.Tag := 0;                   // use TTntEdit
  InputForm.Caption := 'Тег';
  InputForm.Font := MainForm.Font;
  if InputForm.ShowModal <> mrOk then exit;
  VersesDb.VerseListEngine.AddTag(InputForm.Edit1.Text);
end;

procedure TMainForm.tbtnLibClick(Sender: TObject);
begin
  ShowQNav();
end;

procedure TMainForm.tbtnResolveLinksClick(Sender: TObject);
begin
  miRecognizeBibleLinks.Checked := not miRecognizeBibleLinks.Checked;
  miRecognizeBibleLinksClick(sender);
end;

procedure TMainForm.tmrCommonTimerTimer(Sender: TObject);
var pt:TPoint;
    rct:TRect;
    hit:boolean;
     it, tabIx, r:integer;
     chk:LongBool;
    hint_hwnd:HWND;
    ti:TViewTabInfo;
    bl,common_lnk:TBibleLink;
    modPath, fontName,txt,wstr:WideString;
    me:TModuleEntry;
begin
exit;
try
if hint_expanded<>1 then exit;
hint_hwnd:=TTntCustomHintWindow.hintHandle;
if not IsWindow(hint_hwnd) then exit;
if not IsWindowVisible(hint_hwnd) then exit;
pt:=Mouse.CursorPos;
chk:=GetWindowRect(mBibleTabsEx.Handle,rct);
if not chk then exit;
hit:=PtInRect( rct, pt);
if not hit then exit;
  if hint_expanded=1 then
  begin
    ti:=GetActiveTabInfo();
   if not bl.FromBqStringLocation(ti.mwsLocation,modPath) then begin
     exit;
   end;
   if (ti.mFirstVisiblePara<0) then begin
     exit;
   end;
   it:=ti.mLastVisiblePara;
   if it<0 then it:=ti.mFirstVisiblePara+10;
   bl.vstart:=ti.mFirstVisiblePara; bl.vend:=it;
   tabIx:=mBibleTabsEx.ItemAtPos(mBibleTabsEx.ScreenToClient(pt));
   if (tabIx<0) or (tabIx>=mBibleTabsEx.WideTabs.Count) then begin
     exit; end;

   me := mBibleTabsEx.WideTabs.Objects[tabIx] as TModuleEntry  ;

   r:=ti.mBible.AddressToInternal(bl,common_lnk);
   if r<-1 then exit;
   

   if GetModuleText(common_lnk.ToCommand(me.wsShortPath) , fontName, bl,txt,
   [gmtBulletDelimited])<0 then begin
     exit;
   end;

  end;
  wstr := mRefenceBible.ShortPassageSignature(bl.book, bl.chapter,
      bl.vstart, bl.vend) +' (' +mRefenceBible.ShortName +')'#13#10;
      wstr := wstr + txt;

  HintWindowClass := bqHintTools.TbqHintWindow;      
      mBibleTabsEx.hint:='';
     TntControl_SetHint(mBibleTabsEx, wstr);
     Application.CancelHint();
     hint_expanded:=2;
except end;

   //
//if Application.Hint then

end;

procedure TMainForm.ToggleButtonClick(Sender: TObject);
begin
  MainPages.Visible := not MainPages.Visible;
end;

procedure TMainForm.BooksCBChange(Sender: TObject);
begin
  if Copy(BooksCB.Items[BooksCB.ItemIndex], 1, 1) <> #151 then
    GoModuleName(BooksCB.Items[BooksCB.ItemIndex]);
end;

procedure TMainForm.BooksCBCloseUp(Sender: TObject);
begin
  try
  MainForm.FocusControl(Browser); except end;
end;

procedure TMainForm.BooksCBKeyPress(Sender: TObject; var Key: Char);
begin
//
end;

procedure TMainForm.StrongLBDblClick(Sender: TObject);
begin
  if StrongLB.ItemIndex <> -1 then
    DisplayStrongs(StrToInt(StrongLB.Items[StrongLB.ItemIndex]),
      Copy(StrongLB.Items[StrongLB.ItemIndex], 1, 1) = '0');
end;

function TMainForm.SuggestFont(const desiredFontName,
  desiredFontPath: WideString; desiredCharset: integer): WideString;
begin
  if length(desiredFontName) > 0 then
    if PrepareFont(desiredFontName, desiredFontPath) then begin
    //если шрифт установлен или его удалось подгрузить
      result := desiredFontName;
      exit;
    end;
//(*если предподчтительного шрифта нет или он не найден и указана кодировка*)
  if (desiredCharset >= 2) then
  begin
  {находим шрифт с нужной кодировкой учитывая предподчтительный и дефолтный}
    if length(desiredFontName) > 0 then
      result := desiredFontName
    else
      result := mBrowserDefaultFontName;
    result := FontFromCharset(self.Canvas.Handle, desiredCharset, result);
  end;
//если все еще не найден шрифт то берем исходный из настроек программы
  if (length(result) <= 0) then
    result := mBrowserDefaultFontName;

end;

procedure TMainForm.miAboutClick(Sender: TObject);
begin
  if not assigned(frmAbout) then frmAbout := TfrmAbout.Create(self);
  frmAbout.ShowModal();
end;

procedure TMainForm.SearchBrowserKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_NEXT) and (SearchBrowser.Position = SearchBrowserPosition) then
    DisplaySearchResults(SearchPage + 1);

  if (Key = VK_PRIOR) and (SearchBrowser.Position = SearchBrowserPosition) then
  begin
    if SearchPage = 1 then
      Exit;
    DisplaySearchResults(SearchPage - 1);
    SearchBrowser.PositionTo('endofsearchresults');
  end;
end;

procedure TMainForm.SearchBrowserKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  SearchBrowserPosition := SearchBrowser.Position;
end;

var
  __i, __j, __cnt: integer;

function __lstSort(List: TWideStringList; Index1, Index2: Integer): Integer;
begin
  result := OmegaCompareTxt(list[Index1], list[index2], -1, true);
end;

function TMainForm.DictionaryStartup(maxAdd: integer = MaxInt): boolean;
var
  dicCount, wordCount, i, c: integer;
  pvn: PVirtualNode;
begin
  result := false;
  if not __searchInitialized then
  begin
    __searchInitialized := true;
    if not assigned(mDicList) then mDicList := TBQStringList.Create
    else mDicList.Clear();
    mDicList.Sorted := true;

    __i := 0;
    __j := 0;
  end;

  dicCount := DicsCount;
  if __j < dicCount then begin
    //while __j < dicCount do
    repeat
      wordCount := Dics[__j].Words.Count;
      while __i < wordCount do
      begin
        mDicList.Add(Dics[__j].Words[__i]);
        inc(__i);
        dec(maxAdd);
        if maxAdd <= 0 then
          exit;
      end;
      inc(__j);
      __i := 0;
    until __j >= dicCount;
    //DicLB.Items.BeginUpdate;
    vstDicList.BeginUpdate();
    vstDicList.Clear();

    __i := 0;
  end;
    __cnt := mDicList.Count - 1;

    {  for j := 0 to DicsCount - 1 do
        for i := 0 to Dics[j].Words.Count - 1 do
          DicList.Add(Dics[j].Words[i]);

      // delete repeated words from MERGED wordlists
    {  i := 0;
      repeat
        if (i<DicLB.Items.Count-1) and (DicLB.Items[i] = DicLB.Items[i+1])
        then DicLB.Items.Delete(i);
        Inc(i);
      until i = DicLB.Items.Count;
    }
//    mDicList.Sorted:=false;
//    mDicList.CustomSort(@__lstSort);
  try
    if __i <= __cnt then
      repeat
//      for i := 0 to c do
//        DicLB.Items.Add(__DicList[__i]);

        pvn := vstDicList.AddChild(nil, Pointer(__i));
        mDicList.Objects[__i] := TObject(pvn);
        Dec(maxAdd);
        inc(__i)
      until (maxAdd <= 0) or (__i > __cnt);
//      DicLB.Items.AddStrings(__DicList);

  except on e: Exception do
    begin __i := __cnt + 1; BqShowException(e); end; end;
  if __i > __cnt then begin
    vstDicList.EndUpdate();
    imgLoadProgress.Hide();
    FreeAndNil(mIcn);
    result := true;
    __searchInitialized := false;
//      MessageBeep(MB_ICONHAND);
  end;

end;

procedure TMainForm.DicEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i, len: integer;
begin
{  len := Length(DicEdit.Text);

  if len > 0 then
    for i := 0 to DicLB.Items.Count - 1 do
    begin
      if WideLowerCase(Copy(DicLB.Items[i], 1, len))
        = WideLowerCase(DicEdit.Text) then
      begin
        DicLB.ItemIndex := i;
        //DicLBClick(Sender);
        Exit;
      end;
    end;

  DicLB.ItemIndex := 0;}
end;

(*AlekId:Добавлено*)
//при перемене модуля: навигация или смена таба

procedure TMainForm.AdjustBibleTabs(awsNewModuleName: WideString = '');
var
  i, tabCount, tabIx, offset: integer;
  ws: WideString;
begin
  if length(awsNewModuleName) = 0 then
    awsNewModuleName := MainBook.ShortName;
  offset := ord(mBibleTabsInCtrlKeyDownState) shl 1;
  tabCount := mBibleTabsEx.WideTabs.Count - 1;
  tabIx := -1;
  for i := 0 to tabCount do
  begin
    ws := mBibleTabsEx.WideTabs.Strings[i];
    if CompareStringW(LOCALE_SYSTEM_DEFAULT, 0,
      PWideChar(Pointer(awsNewModuleName)),
      -1, PWideChar(Pointer(ws)) + offset, -1) = CSTR_EQUAL then
    begin
      tabIx := i;
      break;
    end;
  end;
  mBibleTabsEx.OnChange := nil;
  if tabIx >= 0 then
    mBibleTabsEx.TabIndex := tabIx
  else
    mBibleTabsEx.TabIndex := mBibleTabsEx.WideTabs.Count - 1;
  // not a favorite book
  mBibleTabsEx.OnChange := mBibleTabsExChange;
end;

procedure TMainForm.AppOnHintHandler(Sender: TObject);
begin
//
//hint_expanded:=0;
end;

procedure TMainForm.BQAppEventsException(Sender: TObject; E: Exception);
begin
  BqShowException(e);
end;

//proc AdjustBibleTabs
(*AlekId:/Добавлено*)

procedure TMainForm.BackButtonClick(Sender: TObject);
begin
  HistoryOn := false;
  if HistoryLB.ItemIndex < HistoryLB.Items.Count - 1 then
  begin
    HistoryLB.ItemIndex := HistoryLB.ItemIndex + 1;
    ProcessCommand(History[HistoryLB.ItemIndex],hlDefault);
  end;
  HistoryOn := true;

//  try
//    ShowXref;
//  finally
//    ShowComments;
//  end;

  ActiveControl := Browser;
end;

procedure TMainForm.ForwardButtonClick(Sender: TObject);
begin
  HistoryOn := false;
  if HistoryLB.ItemIndex > 0 then
  begin
    HistoryLB.ItemIndex := HistoryLB.ItemIndex - 1;
    ProcessCommand(History[HistoryLB.ItemIndex], hlDefault);
  end;
  HistoryOn := true;

  try
//    ShowXref;
  finally
//    ShowComments;
  end;

  ActiveControl := Browser;
end;

procedure TMainForm.DicLBKeyPress(Sender: TObject; var Key: Char);
var ix: integer;
begin
  ix := DicSelectedItemIndex();
  if (Key = #13) and (ix >= 0) then
    DisplayDictionary(mDicList[ix]);
end;

function TMainForm.DicScrollNode(nd: PVirtualNode): boolean;
var r: TRect;
begin
  result := false;
  if not assigned(nd) then exit;
  r := vstDicList.GetDisplayRect(nd, -1, false);

  if (r.Top >= 0) and (r.Bottom <= vstDicList.ClientHeight) then exit;
  result := vstDicList.ScrollIntoView(nd, true);
end;

function TMainForm.DicSelectedItemIndex: integer;
var pn: PVirtualNode;
begin
  result := DicSelectedItemIndex(pn);
end;

function TMainForm.DicSelectedItemIndex(out pn: PVirtualNode): integer;

begin
  result := -1;
  pn := nil;
  pn := vstDicList.GetFirstSelected();
  if not assigned(pn) then exit;
  result := integer(vstDicList.GetNodeData(pn)^);
end;

procedure TMainForm.DicBrowserMouseDouble(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DisplayDictionary(Trim(DicBrowser.SelText));
end;

procedure TMainForm.XRefBrowserHotSpotClick(Sender: TObject;
  const SRC: string; var Handled: Boolean);
var
  ti: TViewTabInfo;
  wsrc, satBible: WideString;

begin
  wsrc := UTF8Decode(src);
  if IsDown(VK_MENU) then begin
    ti := GetActiveTabInfo();
    if assigned(ti) then
      satBible := ti.mSatelliteName
    else satBible := '------';
    NewViewTab(wsrc, satBible, miStrong.Checked,
      miMemosToggle.Checked, miRecognizeBibleLinks.Checked)

  end
  else
    ProcessCommand(wSRC, hlDefault);
  Handled := true;
end;
{
procedure TMainForm.BrowserMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (not MainBook.isBible) or (not (Button = mbLeft)) then Exit;

  XrefTab.Tag := Get_ANAME_VerseNumber(BrowserSource.Text,
    CurFromVerse, Browser.FindSourcePos(Browser.CaretPos));
  //if CBXrefSync.Checked then ShowXref;

  //CommentsBrowser.PositionTo(IntToStr(
  //  Get_ANAME_VerseNumber(BrowserSource.Text,
  //  CurFromVerse, Browser.FindSourcePos(Browser.CaretPos))));

  //ShowComments
end;
}

procedure TMainForm.miRefPrintClick(Sender: TObject);
begin
  with PrintDialog1 do
    if Execute then
      (RefPopupMenu.PopupComponent as THTMLViewer).Print(MinPage, MaxPage)
end;

procedure TMainForm.miRecognizeBibleLinksClick(Sender: TObject);
var nV: boolean;
  vti: TViewTabInfo;
begin
  nV := miRecognizeBibleLinks.Checked;
  vti := GetActiveTabInfo();
  vti.mResolvelinks := nv;
  tbtnResolveLinks.Down := nv;
  if MainBook.RecognizeBibleLinks <> nV then begin
    MainBook.RecognizeBibleLinks := nV;
    SafeProcessCommand(vti.mwsLocation,
         TbqHLVerseOption(ord(vti.mHLVerses)));
  end;

end;

procedure TMainForm.miRefCopyClick(Sender: TObject);
var
  trCount: integer;
begin
  trCount := 7;
  repeat try
      if not (CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then
        TntClipboard.AsText := (RefPopupMenu.PopupComponent as
          THTMLViewer).SelText
      else (RefPopupMenu.PopupComponent as THTMLViewer).CopyToClipboard();
      trCount := 0;
    except Dec(trCount); sleep(100); end;
  until trCount <= 0;
//  (RefPopupMenu.PopupComponent as THTMLViewer).SelStart
//  ConvertClipboard;
end;

procedure TMainForm.MemoOpenClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'RTF (*.rtf)|*.rtf|DOC (*.doc)|*.doc|*.*|*.*';
  OpenDialog1.Filename := MemoFileName;
  if OpenDialog1.Execute then
  begin
    TREMemo.Lines.LoadFromFile(OpenDialog1.FileName);
    TREMemo.Tag := 0;                   // not changed

    MemoFileName := OpenDialog1.Filename;
    MemoLabel.Caption := WideExtractFileName(MemoFileName);
  end;
end;

procedure TMainForm.MemoSaveClick(Sender: TObject);
var
  i: integer;
begin
  SaveFileDialog.DefaultExt := '.rtf';
  SaveFileDialog.Filter := 'RTF (*.rtf)|*.rtf|DOC (*.doc)|*.doc|*.*|*.*';
  SaveFileDialog.Filename := MemoFileName;
  if SaveFileDialog.Execute then
  begin
    MemoFileName := SaveFileDialog.Filename;
    i := Length(MemoFileName);

    if (SaveFileDialog.FilterIndex = 1) and (WideLowerCase(Copy(MemoFileName, i
      - 3, 4)) <> '.rtf') then
      MemoFileName := MemoFileName + '.rtf';
    if (SaveFileDialog.FilterIndex = 2) and (WideLowerCase(Copy(MemoFileName, i
      - 3, 4)) <> '.doc') then
      MemoFileName := MemoFileName + '.doc';

    TREMemo.Lines.SaveToFile(MemoFileName);
    TREMemo.Tag := 0;                   // not changed

    MemoLabel.Caption := WideExtractFileName(MemoFileName);
  end;
end;

procedure TMainForm.MemoBoldClick(Sender: TObject);
begin
  if fsBold in TREMemo.SelAttributes.Style then
    TREMemo.SelAttributes.Style := TREMemo.SelAttributes.Style - [fsBold]
  else
    TREMemo.SelAttributes.Style := TREMemo.SelAttributes.Style + [fsBold];
end;

procedure TMainForm.MemoItalicClick(Sender: TObject);
begin
  if fsItalic in TREMemo.SelAttributes.Style then
    TREMemo.SelAttributes.Style := TREMemo.SelAttributes.Style - [fsItalic]
  else
    TREMemo.SelAttributes.Style := TREMemo.SelAttributes.Style + [fsItalic];
end;

procedure TMainForm.MemoUnderlineClick(Sender: TObject);
begin
  if fsUnderline in TREMemo.SelAttributes.Style then
    TREMemo.SelAttributes.Style := TREMemo.SelAttributes.Style - [fsUnderline]
  else
    TREMemo.SelAttributes.Style := TREMemo.SelAttributes.Style + [fsUnderline];
end;

procedure TMainForm.MemoFontClick(Sender: TObject);
begin
  with TREMemo.SelAttributes do
  begin
    FontDialog1.Font.Name := Name;
    FontDialog1.Font.Charset := Charset;
    FontDialog1.Font.Size := Size;
    FontDialog1.Font.Style := Style;
    FontDialog1.Font.Color := Color;
  end;

  if FontDialog1.Execute then
    with TREMemo.SelAttributes do
    begin
      Name := FontDialog1.Font.Name;
      Charset := FontDialog1.Font.Charset;
      Size := FontDialog1.Font.Size;
      Style := FontDialog1.Font.Style;
      Color := FontDialog1.Font.Color;
    end;
end;

procedure TMainForm.TREMemoChange(Sender: TObject);
begin
  TREMemo.Tag := 1;
end;
(*AlekId:Добавлено*)

procedure TMainForm.UpdateAllBooks;
var
  i: integer;
  mi: TTntMenuItem;
  cnt: integer;
begin
  Comments.Add('---------');
  for i := 0 to Bibles.Count - 1 do
    Comments.Add(Bibles[i]);

  BooksCB.Items.BeginUpdate;
  BooksCB.Items.Clear;

  BooksCB.Items.Add('——— ' + Lang.Say('StrBibleTranslations') +
    ' ———');

  for i := 0 to Bibles.Count - 1 do begin
    BooksCB.Items.Add(Bibles[i]);
  end;
  BooksCB.Items.Add('——— ' + Lang.Say('StrBooks') + ' ———');
  for i := 0 to Books.Count - 1 do
    BooksCB.Items.Add(Books[i]);

  BooksCB.Items.Add('——— ' + Lang.Say('StrCommentaries') + ' ———');
  for i := 0 to ModulesList.Count - Bibles.Count - Books.Count - 1 do
    BooksCB.Items.Add(Comments[i]);

  if MainBook.Name <> '' then
    BooksCB.ItemIndex := BooksCB.Items.IndexOf(MainBook.Name);

  BooksCB.Items.EndUpdate;

  CommentsCB.Items.BeginUpdate;
  CommentsCB.Items.Clear;

  for i := 0 to Comments.Count - 1 do
    CommentsCB.Items.Add(Comments[i]);
  CommentsCB.Items.EndUpdate;

  CommentsCB.ItemIndex := 0;

//  for i := 0 to Bibles.Count - 1 do
//  begin
//    MI := TTntMenuItem.Create(Self);
//    MI.Caption := Bibles[i];
//    MI.OnClick := SatelliteMenuItemClick;
//    MI.Checked := false;
//    SatelliteMenu.Items.Add(MI);
//  end;
end;

procedure TMainForm.UpdateDictionariesCombo;
var
  i: integer;
begin
  DicFilterCB.Items.BeginUpdate;
  DicFilterCB.Items.Clear;
  DicFilterCB.Items.Add(Lang.Say('StrAllDictionaries'));

  for i := 0 to DicsCount - 1 do
    DicFilterCB.Items.Add(Dics[i].Name);

  DicFilterCB.ItemIndex := 0;
  DicFilterCB.Items.EndUpdate;

  //DicFilterCBChange(Self);
end;

function TMainForm.UpdateFromCashed(): boolean;
var
  i, modCount: integer;
  modEntry: TModuleEntry;
begin
  try
    modCount := S_cachedModules.count - 1;
    ModulesList.Clear();
    S_ArchivedModuleList.Clear();
    ModulesCodeList.Clear();
    Bibles.Clear();
    Books.Clear;
    Comments.Clear();
    CommentsPaths.Clear();
    if not assigned(mModules) then mModules := TCachedModules.Create(true);
    mModules.Assign(S_cachedModules);

    if assigned(frmQNav) then begin
      if frmQNav.mUseDisposition = udMyLibrary then
        frmQNav.UpdateList(mModules, -1, MainBook.Name)
      else frmQNav.UpdateList(mModules, -1, SecondBook.Name);
    end;
    for i := 0 to modCount do
    begin
      modEntry := TModuleEntry(S_cachedModules[i]);
      ModulesList.Add(modEntry.wsFullName + ' $$$ ' + modEntry.wsShortPath);
      S_ArchivedModuleList.Names.Add(modEntry.wsFullName);
      S_ArchivedModuleList.Paths.Add(modEntry.wsFullPath);
      ModulesCodeList.Add(modEntry.wsShortName);
      case modEntry.modType of
        modtypeBible:
          Bibles.Add(modEntry.wsFullName);
        modtypeBook:
          Books.Add(modEntry.wsFullName);
        modtypeComment:
          begin
            Comments.Add(modEntry.wsFullName);
            CommentsPaths.Add(modEntry.wsShortPath);
          end;
      end;                              //case
    end;                                //for

    result := true;
    mDefaultLocation := DefaultLocation();
  except result := false;
  end;
end;

procedure TMainForm.UpdateUI();
var
  saveEvent, saveEvent2: TNotifyEvent;
  tabInfo: TViewTabInfo;
  i, c: integer;
begin
  mInterfaceLock := true;
  try

    tabInfo := GetActiveTabInfo();
    if not Assigned(tabInfo) then
      exit;
    MainBook := tabInfo.mBible;
    Browser := tabInfo.mHtmlViewer;
    AdjustBibleTabs(MainBook.ShortName);
    StrongNumbersOn := tabInfo.mShowStrongs;
    miStrong.Checked := tabInfo.mShowStrongs;
    StrongNumbersButton.Down := tabInfo.mShowStrongs;
    SatelliteButton.Down := length(tabInfo.mSatelliteName) > 0;
    StrongNumbersButton.Enabled := MainBook.StrongNumbers;
    MemosOn := tabInfo.mShowNotes;
    miMemosToggle.Checked := MemosOn;
    miRecognizeBibleLinks.Checked := tabInfo.mResolvelinks;
    tbtnResolveLinks.Down := tabInfo.mResolvelinks;
    MemosButton.Down := MemosOn;
    if not MainBook.isBible then begin
      try
        LoadSecondBookByName(tabInfo.mSatelliteName);
      except on e: Exception do BqShowException(e); end;
    end;

  //комбо модулей
    with BooksCB do
    begin
      saveEvent := OnChange;
      OnChange := nil;
      ItemIndex := Items.IndexOf(MainBook.Name);
      OnChange := saveEvent;
    end;
  //списки книг и глав
    saveEvent := BookLB.OnClick;
    BookLB.OnClick := nil;
    saveEvent2 := ChapterLB.OnClick;
    ChapterLB.OnClick := nil;
    UpdateBooksAndChaptersBoxes();      //заполняем списки
    BookLB.OnClick := saveEvent;
    ChapterLB.OnClick := saveEvent2;
    SearchListInit();
  {  if MainBook.Copyright <> '' then begin}
    lbTitleLabel.Font.Name := tabInfo.mwsTitleFont;
    lbTitleLabel.Caption := tabInfo.mwsTitleLocation;
    lbCopyRightNotice.Caption := tabInfo.mwsCopyrightNotice;
    c := mBibleTabsEx.WideTabs.Count - 2;
    for i := 0 to c do begin
      TUnicodeTabList(mBibleTabsEx.WideTabs).tbStyles[i] := ord(
        (MainBook.isBible) and
        (TModuleEntry(mBibleTabsEx.WideTabs.Objects[i]).BibleBookPresent(MainBook.CurBook
        + Ord(not MainBook.HasOldTestament) * 66))
        );
    end;
    if c + 1 > 0 then
      TUnicodeTabList(mBibleTabsEx.WideTabs).tbStyles[c + 1] := 0;
  {  end
    else
      lbTitleLabel.Caption := tabInfo.mwsTitleLocation + '; ' +
        Lang.Say('PublicDomainText');}
//  SelectSatelliteMenuItem(tabInfo.mSatelliteMenuItem);
    if tabInfo.ReloadNeeded then
    begin
      tabInfo.ReloadNeeded := false;
      SafeProcessCommand(tabInfo.mwsLocation,
          TbqHLVerseOption(ord(tabInfo.ReloadNeeded)));
    end;
    Caption := tabInfo.mBible.Name + ' — BibleQuote';
  finally
    mInterfaceLock := false;
  end;
end;

procedure TMainForm.vstDicListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var ix: integer;
begin
  if not assigned(node) then exit;
  try
    ix := integer(sender.GetNodeData(node)^);
    CellText := mDicList[ix];
  except on e: Exception do begin BqShowException(e) end end;
//
end;

procedure TMainForm.VSCrollTracker(sender: TObject);
var
  sectionIx, sectionCnt, sourcePos, scrollPos, BottomPos, vn, ch,ve,delta: integer;
  sct, next: TSectionBase;
  positionLst:TList;
  className: ShortString;
  ds, s: string;

  bl: TBibleLink;
  path: WideString;
  sectIx:integer;
  scte:TSectionBase;
  activeTabinfo:TViewTabInfo;
  function find_verse(sp:integer):integer;
  var   pfind: PChar;
      i:integer;
  begin
  result:=-1;
   pfind := searchbuf(PChar(pointer(ds)), sourcePos - 1, sourcePos - 1,
      0, '<a name="bqverse', [soMatchCase]);
    if not assigned(pfind) then exit;
    i := length('<a name="bqverse');
    result := 0;
    repeat
      ch := Ord((pfind + i)^) - ord('0');
      if (ch < 0) or (ch > 9) then break;
      result := result * 10 + ch;
      inc(i);
    until false;
  end;

begin
  try
    vn:=-1;  ve:=vn;
    scrollPos := integer(Browser.VScrollBar.Position);
    if scrollPos=0 then vn:=1;
    
    sct := Browser.SectionList.FindSectionAtPosition(scrollPos, vn, ch);

    if delta<0 then delta:=-delta;

    BottomPos:=scrollPos+Browser.__PaintPanel.Height;
    scte:=Browser.SectionList.FindSectionAtPosition(BottomPos, ve, ch);
    ds := Browser.DocumentSource;
    if  assigned(sct) and (sct is TSectionBase) then begin
     delta:=sct.DrawHeight div 2;
     positionLst:=browser.SectionList.PositionList;
    if sct.YPosition+delta<scrollPos then begin
        //try to find first fully visible section
        sectionIx:=positionLst.IndexOf(sct);
        sectionCnt:=positionLst.Count-1;
        repeat
         inc(sectionIx);
        until (sectionIx>=sectionCnt) or
         (TSectionBase(positionLst[sectionIx]).YPosition +(TSectionBase(positionLst[sectionIx]).DrawHeight div 2)>scrollPos);

        if sectionIx<sectionCnt then sct:=TSectionBase(positionLst[sectionIx]);
    end;
   if scte.YPosition+(scte.DrawHeight div 2)>BottomPos then begin
        //try to find first fully visible section

        sectionIx:=positionLst.IndexOf(scte);
//        sectionCnt:=positionLst.Count-1;
        repeat
         dec(sectionIx);
        until (sectionIx<0) or
         (TSectionBase(positionLst[sectionIx]).YPosition
              +(TSectionBase(positionLst[sectionIx]).DrawHeight div 2)<BottomPos);
        if sectionIx>=0 then scte:=TSectionBase(positionLst[sectionIx]);
    end;

    sourcePos := sct.FindSourcePos(sct.StartCurs);
    vn:=-1;
    if sourcePos >= 0 then begin
          vn:=find_verse(sourcePos);
    end;
   end;
    if  assigned(scte) and (scte is TSectionBase) then begin
    sourcePos := scte.FindSourcePos(scte.StartCurs);
    ve:=-1;
    if sourcePos >= 0 then begin
          ve:=find_verse(sourcePos);
    end;
   end;

//TSection(sct).

    activeTabinfo:=GetActiveTabInfo();
   if vn>0 then  begin
   activeTabinfo.mFirstVisiblePara:=vn;
    if bl.FromBqStringLocation(activeTabinfo.mwsLocation, path) then begin
      bl.vstart := vn;
        activeTabinfo.mwsLocation := bl.ToCommand(path, [blpLimitChapterTxt]);
      end;
    end;
   if (ve>0) and (ve>=vn) then activeTabinfo.mLastVisiblePara:=ve
   else begin
     activeTabinfo.mLastVisiblePara:=-1;
     ve:=0;
   end;
   if (vn>0) and (ve>0) then
   
   lbTitleLabel.Caption := MainBook.ShortName + ' '
      + MainBook.FullPassageSignature(MainBook.CurBook,
      MainBook.Curchapter, vn, ve);

  except end;
end;

procedure TMainForm.vstBookMarkListDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
var nd: TVersesNodeData;
  rct: TRect;
  h, dlt, flgs: integer;
  ws: WideString;
  cl1, cl2: TColor;
begin

  if PaintInfo.Node = nil then exit;
  nd := TVersesNodeData((Sender.GetNodeData(PaintInfo.Node))^);
  rct := PaintInfo.ContentRect;
  PaintInfo.Canvas.Font := Sender.Font;
  dlt := Sender.Font.Height;
  if dlt < 0 then dlt := -dlt;
  dlt := dlt div 4;
  if dlt = 0 then dlt := 1;
  if nd.nodeType = bqvntTag then begin
    flgs := DT_WORDBREAK or DT_VCENTER;

    InflateRect(rct, -2, -2);
    if Sender.FocusedNode = PaintInfo.Node then cl1 := vstBookMarkList.Colors.FocusedSelectionColor
    else cl1 := $00F2D6BD;

    PaintInfo.Canvas.Brush.Color := cl1;
    PaintInfo.Canvas.RoundRect(rct.Left, rct.Top, rct.Right, rct.Bottom, 10, 10);
    Inc(rct.Left, 12);
    Dec(rct.Right, 2);
  end else flgs := DT_WORDBREAK;

  ws := nd.getText;

  Inc(rct.Top, dlt);
  PaintInfo.Canvas.Font.Color := clWindowText;
  if (not (nd.nodeType = bqvntTag)) and (vsSelected in PaintInfo.Node^.States) then begin
    if vstBookMarkList.Focused then
      PaintInfo.Canvas.Brush.Color := vstBookMarkList.Colors.FocusedSelectionColor;
  end;

  h := Windows.DrawTextW(PaintInfo.Canvas.Handle,
    PWideChar(Pointer(ws)), -1, rct, flgs);

  if (nd.nodeType = bqvntTag) or (not assigned(nd.Parents)) then exit;
//Inc(rct.Top,h+dlt);

  PaintInfo.Canvas.Font.Color := clHighlight;
  PaintInfo.Canvas.Font.Height := PaintInfo.Canvas.Font.Height * 4 div 5;
  PaintInfo.Canvas.Font.Style := [fsUnderline];
  PaintTokens(PaintInfo.Canvas, rct, nd.Parents, false);
end;

procedure TMainForm.vstBookMarkListMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
var
  nd: TVersesNodeData;
  rct: TRect;
  h, dlt, vmarg: integer;
  ws: WideString;
begin
  if (node = nil) or (csDestroying in Self.ComponentState) then exit;

  try
    TargetCanvas.Font := Sender.Font;
    dlt := Sender.Font.Height;
    if dlt < 0 then dlt := -dlt;
    dlt := dlt div 2;
    if dlt = 0 then dlt := 2;

    nd := TVersesNodeData((Sender.GetNodeData(Node))^);
    ws := nd.cachedTxt;

    rct.Left := 0; rct.Top := 0; rct.Bottom := 200;
    rct.Right := vstBookMarkList.Width - GetSystemMetrics(SM_CXVSCROLL) -
      vstBookMarkList.TextMargin * 2 - 2;

    h := Windows.DrawTextW(TargetCanvas.Handle,
      PWideChar(Pointer(ws)), -1, rct, DT_CALCRECT or DT_WORDBREAK);
    NodeHeight := h;
    vmarg := dlt;
    if (nd.nodeType = bqvntTag) then begin
      inc(vmarg, 4);
      Inc(NodeHeight, vmarg); exit; end;

    rct.Left := vstBookMarkList.TextMargin;
    rct.Right := vstBookMarkList.Width - GetSystemMetrics(SM_CXVSCROLL) -
      vstBookMarkList.TextMargin - 2;

    dlt := TargetCanvas.Font.Height * 4 div 5;
    TargetCanvas.Font.Height := dlt;

    TargetCanvas.Font.Style := [fsUnderline];
    if dlt < 0 then dlt := -dlt;
    rct.Top := h + (dlt div 2);
    rct.Bottom := rct.Top + 300;

    NodeHeight := PaintTokens(TargetCanvas, rct, nd.Parents, true) + (vmarg);
  except                                {on e:Exception do BqShowException(e);}
  end;

end;

{procedure TMainForm.vstBooksGetText(Sender: TBaseVirtualTree;
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
end;}

(*AlekId:/Добавлено*)

procedure TMainForm.MemoPainterClick(Sender: TObject);
begin
  ColorDialog1.Color := TREMemo.Font.Color;

  if ColorDialog1.Execute then
    TREMemo.SelAttributes.Color := ColorDialog1.Color;
end;

procedure TMainForm.miMemoCopyClick(Sender: TObject);
begin
  if MemoPopupMenu.PopupComponent = TREMemo then
    TREMemo.CopyToClipboard
  else if MemoPopupMenu.PopupComponent is TTntEdit then
    (MemoPopupMenu.PopupComponent as TTntEdit).CopyToClipboard
  else if MemoPopupMenu.PopupComponent is TTntComboBox then
    TntClipboard.AsText := (MemoPopupMenu.PopupComponent as TTntComboBox).Text;
end;

procedure TMainForm.miNotepadClick(Sender: TObject);
begin
  if not MainPages.Visible then
    ToggleButton.Click;
  MainPages.ActivePage := MemoTab;

end;

procedure TMainForm.ShowComments;
var
  b, c, v, ib, ic, iv,
    i, ipos: integer;
  Lines: WideString;
  iscomm, found, resolveLinks: boolean;
  s, aname: WideString;
  //  offset: integer;
begin
  if not MainBook.isBible then
    Exit;
  if (not MainPages.Visible) or (MainPages.ActivePage <> CommentsTab) then
    Exit;

  if CommentsTab.Tag = 0 then
    CommentsTab.Tag := 1;

  if CommentsCB.ItemIndex = CommentsPaths.Count then
  begin
    CommentsCB.ItemIndex := CommentsPaths.Count + 1;
    CommentsCBChange(Self);
    Exit;
  end;

  Lines := '';

  if CommentsCB.ItemIndex < CommentsPaths.Count then
  begin                                 // ordinary commentaries
    s := MainFileExists(CommentsPaths[CommentsCB.ItemIndex] + '\bibleqt.ini');
    if length(s) < 1 then
      exit;
    try
      SecondBook.IniFile := s;
    except exit;
    end;
    {ExePath + 'Commentaries\'
     + CommentsPaths[CommentsCB.ItemIndex]
     + '\bibleqt.ini}
  end
  else if (CommentsCB.ItemIndex > CommentsPaths.Count) then
  begin
    found := false;

    for i := 0 to Bibles.Count + Books.Count - 1 do
    begin
      if Pos(CommentsCB.Items[CommentsCB.ItemIndex] + ' $$$', ModulesList[i]) = 1 then
      begin
        found := true;
        break;
      end;
    end;
    if not found then
      Exit;

    ipos := Pos(' $$$ ', ModulesList[i]);

    try
      SecondBook.IniFile :=
        MainFileExists(Copy(ModulesList[i], ipos + 5, Length(ModulesList[i])) +
        '\bibleqt.ini');
    except
      Exit;
    end;
  end;

  MainBook.AddressToInternal(MainBook.CurBook, MainBook.CurChapter, 1, ib, ic,
    iv);
  SecondBook.InternalToAddress(ib, ic, iv, b, c, v);

  //  offset := 0;
  //  if SecondBook.ChapterQtys[ib] > MainBook.ChapterQtys[MainBook.CurBook] then
  //    offset := 1;

  iscomm := (CommentsCB.ItemIndex < CommentsPaths.Count);
  {
        If this is a commentary, we 1) SHOW verse numbers
        2) add HIDDEN links to uncommented verses...
  }

  // if it's a commentary or it has chapter zero (introduction to book)
  // and it's chapter 1, show chapter 0, too :-)
  resolveLinks := false;
  try
    resolveLinks := GetActiveTabInfo().mResolvelinks;
  except on e: Exception do BqShowException(e) end;

  if SecondBook.ChapterZero and (c = 2) then
  begin
    SecondBook.OpenChapter(b, 1, resolveLinks);
    for i := 0 to SecondBook.Lines.Count - 1 do
    begin
      s := SecondBook.Lines[i];
      //StrReplace(s, '<b>', '<br><b>', false); // add spaces
      if not iscomm then
      begin
        StrDeleteFirstNumber(s);
        if SecondBook.StrongNumbers then
          s := DeleteStrongNumbers(s);

        AddLine(Lines, WideFormat(
          '<a name=%d>%d <font face="%s">%s</font><br>',
          [
          i + 1,
            i + 1,
            SecondBook.FontName,
            s
            ]
            ));

      end
      else
      begin
        aname := StrGetFirstNumber(s);
        AddLine(Lines, WideFormat(
          '<a name=%s><font face="%s">%s</font><br>',
          [aname, SecondBook.FontName, s]
          ));
      end;
    end;
    //Lines.Add('<p>');
  end;

  try
    SecondBook.OpenChapter(b, c, resolveLinks);
  except
    on e: TBQPasswordException do
    begin
      PasswordPolicy.InvalidatePassword(e.mArchive);
      MessageBoxW(self.Handle, PWideChar(Pointer(e.mWideMsg)), nil, MB_ICONERROR
        or MB_OK);
    end
  else
    SecondBook.OpenChapter(1, 1, resolveLinks);
  end;

  //Lines.Add('<b>' + SecondBook.FullPassageSignature(ib,ic,0,0) + '</b><p>');

  for i := 0 to SecondBook.Lines.Count - 1 do
  begin
    s := SecondBook.Lines[i];
    if not iscomm then
    begin
      StrDeleteFirstNumber(s);
      if SecondBook.StrongNumbers then
        s := DeleteStrongNumbers(s);

      AddLine(Lines, WideFormat(
        '<a name=%d>%d <font face="%s">%s</font><br>',
        [i + 1, i + 1, SecondBook.FontName, s]
        ));

    end
    else
    begin
      aname := StrGetFirstNumber(s);
      AddLine(Lines, WideFormat(
        '<a name=%s><font face="%s">%s</font><br>',
        [aname, SecondBook.FontName, s]
        ));
    end;
  end;
  AddLine(Lines,
    '<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>');

  CommentsBrowser.Base := SecondBook.Path;
  CommentsBrowser.LoadFromString(Lines);

  for i := 1 to CommentsTab.Tag do
    CommentsBrowser.PositionTo(IntToStr(i));
end;

procedure TMainForm.CommentsCBChange(Sender: TObject);
begin
  ShowComments;
  CommentsBrowser.PositionTo(IntToStr(CommentsTab.Tag));
end;

procedure TMainForm.CommentsCBCloseUp(Sender: TObject);
begin
  try
    MainForm.FocusControl(CommentsBrowser);
  except end;
end;

procedure TMainForm.miHelpClick(Sender: TObject);
var
  s: WideString;
begin
  s := 'file ' + ExePath + 'help\' + HelpFileName
    + ' $$$' + Lang.Say('MainForm.HelpButton.Hint');

  ProcessCommand(s,hlFalse);
end;

procedure TMainForm.SearchOptionsButtonClick(Sender: TObject);
begin
  if SearchBoxPanel.Height > CBCase.Top + CBCase.Height then
  begin                                 // wrap it
    SearchBoxPanel.Height := CBAll.Top;
    SearchOptionsButton.Caption := '>';
  end
  else
  begin
    SearchBoxPanel.Height := SearchLabel.Top + SearchLabel.Height + 10;
    SearchOptionsButton.Caption := '<';
  end;

  ActiveControl := SearchCB;
end;

procedure TMainForm.SearchTabContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

//function TMainForm.SelectSatelliteMenuItem(aItem: TTntMenuItem): TTntMenuItem;
//var
//  i, itemIx, itemCount: integer;
//begin
//  itemIx := -1;
//  itemCount := SatelliteMenu.Items.Count - 1;
//  for i := 0 to itemCount do
//  begin
//    if SatelliteMenu.Items[i] = aItem then
//      itemIx := i - 1;
//    SatelliteMenu.Items[i].Checked := false;
//  end;
//  Result := TTntMenuItem(SatelliteMenu.Items[itemIx + 1]);
//  Result.Checked := true;
//end;

function TMainForm.CachedModuleIxFromFullname(
  const wsFullModuleName: WideString; searchFromIndex: integer): integer;
var
  i, cachedModuleListCount: integer;
begin
  result := -1;
  cachedModuleListCount := S_cachedModules.Count - 1;
  for i := 0 to cachedModuleListCount do
    if (TModuleEntry(S_cachedModules.Items[i]).wsFullName = wsFullModuleName) then
    begin
      result := i;
      break
    end;
end;

procedure TMainForm.CBExactPhraseClick(Sender: TObject);
begin
  if CBExactPhrase.Checked then
  begin
    CBAll.Checked := false;
    CBPhrase.Checked := false;
    CBParts.Checked := false;
    CBCase.Checked := false;
  end;
end;

procedure TMainForm.DicCBChange(Sender: TObject);
var
  i: integer;
  res, tt: WideString;
begin
  for i := 0 to DicsCount - 1 do
    if Dics[i].Name = DicCB.Items[DicCB.ItemIndex] then
    begin

      res := Dics[i].Lookup(mDicList[DicSelectedItemIndex()]);
      break;
    end;
  tt := ResolveLnks(res);
  DicBrowser.LoadFromString(tt);
  MainPages.ActivePage := DicTab;

  //DicLB.ItemIndex := DicLB.Items.IndexOf(DicEdit.Text);
end;

procedure TMainForm.HistoryLBClick(Sender: TObject);
begin
  HistoryOn := false;
  ProcessCommand(History[HistoryLB.ItemIndex], hlDefault);

  //ComplexLinksPanel.Visible := false;
//  LinksCB.Visible := false;
  tbLinksToolBar.Visible := false;
  HistoryOn := true;
end;

{function TMainForm.NewTab(const location: WideString): boolean;
var
  Tab1: TTntTabSheet;
  newBrowser, saveBrowser: THtmlViewer;
  tabInfo: TViewTabInfo;
  newBible, saveMainBible: TBible;
begin
  Tab1 := nil;
  newBrowser := nil;
  newBible := nil;
  saveBrowser := Browser;
  saveMainBible := MainBook;
  result := false;
  try
    Tab1 := TTntTabSheet.Create(MainForm);
    Tab1.OnContextPopup := mInitialViewPageContextPopup;
    newBrowser := _CreateNewBrowserInstanse(Browser, Tab1, Tab1);
    if not Assigned(newBrowser) then abort;
    Tab1.PageControl := mViewTabs;
    Browser := newBrowser;
    (*AlekId:Добавлено*)
    //конструируем TBible
    newBible := _CreateNewBibleInstance(MainBook, Tab1);
    if not Assigned(newBible) then abort;

    tabInfo := TViewTabInfo.Create(newBrowser, newBible, '', TTntMenuItem(SatelliteMenu.Items[0]),
    miStrong.Checked, miMemosToggle.Checked);
    Tab1.Tag := Integer(tabInfo);
    //какждой вкладке по броузеру
    MainBook := newBible;
    mViewTabs.ActivePageIndex := mViewTabs.PageCount - 1;
    SelectSatelliteMenuItem(tabInfo.mSatelliteMenuItem);

    SafeProcessCommand(location);
    UpdateUI();
    result := true;
  except
    Browser := saveBrowser;
    MainBook := saveMainBible;
    newBible.Free();
    newBrowser.Free();
    Tab1.Free();
  end;
end;}

function TMainForm.NavigateToInterfaceValues: boolean;
begin
///  offset := 1;

  result := ProcessCommand(
    WideFormat(
    'go %s %d %d',
    [
    MainBook.ShortPath,
      BookLB.ItemIndex + 1,
      ChapterLB.ItemIndex + 1
      ]
      )
    ,hlDefault );

end;

function TMainForm.NewViewTab(const command, satellite: WideString;
  showStrongs, showNotes, resolveLinks: boolean): boolean;
var
  Tab1: TTntTabSheet;
  tabInfo: TViewTabInfo;
  newBrowser, saveBrowser: THTMLViewer;
  newBible: TBible;

  saveMainBook: TBible;
begin
  //
  Tab1 := nil;
  newBrowser := nil;
  newBible := nil;
  saveBrowser := Browser;
  saveMainBook := MainBook;
  Result := true;
  try
    Tab1 := TTntTabSheet.Create(MainForm);
    Tab1.PageControl := mViewTabs;
    Tab1.OnContextPopup := mInitialViewPageContextPopup;
    newBrowser := _CreateNewBrowserInstanse(Browser, Tab1, Tab1);
    if not Assigned(newBrowser) then
      abort;
    Browser := newBrowser;
    //конструируем TBible
    newBible := _CreateNewBibleInstance(MainBook, Tab1);
    if not Assigned(newBible) then
      abort;
//    satelliteMenuItem := SatelliteMenuItemFromModuleName(satellite);
//    if not Assigned(satelliteMenuItem) then
//      if SatelliteMenu.Items.Count > 0 then
//        satelliteMenuItem := SatelliteMenu.Items[0] as TTntMenuItem
//      else abort;

    tabInfo := TViewTabInfo.Create(newBrowser, newBible, command,
      satellite, showStrongs, showNotes, resolveLinks);
    Tab1.Tag := Integer(tabInfo);

    //какждой вкладке по броузеру
    MainBook := newBible;
    mViewTabs.ActivePage := Tab1;
    StrongNumbersOn := showStrongs;
    MainBook.RecognizeBibleLinks := resolveLinks;
    MemosOn := showNotes;
//    SelectSatelliteMenuItem(satelliteMenuItem);
    SafeProcessCommand(command,hlDefault);

    UpdateUI();
  except
    result := false;
    MainBook := saveMainBook;
    Browser := saveBrowser;
    newBrowser.Free();
    newBible.Free();
    Tab1.Free();
  end;

end;

procedure TMainForm.NextChapterButtonClick(Sender: TObject);
begin
  GoNextChapter;
end;

function TMainForm.PrepareFont(const aFontName, aFontPath: WideString): boolean;
begin
  result := FontExists(aFontName);
  if (not result) then
    result := ActivateFont(aFontPath + aFontName + '.ttf') > 0;
end;

function TMainForm.PreProcessAutoCommand(const cmd, prefModule: WideString): widestring;
label fail;
var ps, refCnt, refIx, stat, prefModIx: integer;
  me: TModuleEntry;
  bl, moduleEffectiveLink: TBibleLink;
  dp: WideString;
begin
  if Pos('go', Trim(cmd)) <> 1 then goto fail;
  ps := Pos(C__bqAutoBible, cmd);
  if ps = 0 then goto fail;
  if not bl.FromBqStringLocation(cmd, dp) then goto fail;
  prefModIx:=mModules.FindByFolder(prefModule);
  if prefModIx>=0 then begin
    me:=mModules[prefModIx];

    stat:=mRefenceBible.LinkValidnessStatus(me.getIniPath(), bl, true);
  end;

  if stat<-1 then begin
    refCnt := RefBiblesCount() - 1;
    stat := -2;
    for refIx := 0 to Refcnt do begin
      me := GetRefBible(refIx);
      stat := mRefenceBible.LinkValidnessStatus(me.getIniPath(), bl, true);
      if stat > -2 then break;
    end;
  end;
  if stat > -2 then begin
    mRefenceBible.InternalToAddress(bl,moduleEffectiveLink);
    result := moduleEffectiveLink.ToCommand(me.wsShortPath);
    exit;
  end;
  fail:
  result := cmd;
end;

procedure TMainForm.PrevChapterButtonClick(Sender: TObject);
begin
  GoPrevChapter;
end;

procedure TMainForm.MainPagesChange(Sender: TObject);
var
  saveCursor: TCursor;
begin
  if (MainPages.ActivePage = DicTab) and (not mDictionariesFullyInitialized) then
  begin
    saveCursor := self.Cursor;
    Screen.Cursor := crHourGlass;
    try
      ForceForegroundLoad();
//      mDictionariesFullyInitialized := LoadDictionaries(maxInt);
    except
    end;
    Screen.Cursor := saveCursor;
  end;
  //if (MainPages.ActivePage = CommentsTab) and (CommentsBrowserSource.Count = 0)
  //then ShowComments;

  case MainPages.ActivePageIndex of
    0: MemoPopupMenu.PopupComponent := GoEdit;
    1: MemoPopupMenu.PopupComponent := SearchCB;
    2: MemoPopupMenu.PopupComponent := DicEdit;
    3: MemoPopupMenu.PopupComponent := StrongEdit;
    4: MemoPopupMenu.PopupComponent := CommentsBrowser;
    5: MemoPopupMenu.PopupComponent := XRefBrowser;
    6: MemoPopupMenu.PopupComponent := TREMemo;
  end;
end;

function FindPageforTabIndex(pagecontrol: TTntPageControl; tabindex: Integer):
  TTabSheet;
var
  i: Integer;
begin
  Assert(Assigned(pagecontrol));
  Assert((tabindex >= 0) and (tabindex < pagecontrol.pagecount));
  Result := nil;
  for i := 0 to pagecontrol.pagecount - 1 do
    if pagecontrol.pages[i].tabVisible then begin
      Dec(tabindex);
      if tabindex < 0 then begin
        result := pagecontrol.pages[i];
        break;
      end;
    end;
end;

function HintForTab(pc: TTntPageControl; tabindex: Integer): WideString;
var
  tabsheet: TTabsheet;
begin
  // tabindex may be <> pageindex if some pages have tabvisible = false!
  tabsheet := FindPageforTabIndex(pc, tabindex);
  if assigned(tabsheet) then
    result := tabsheet.hint
  else
    result := '';
end;

procedure TMainForm.MainPagesMouseLeave(Sender: TObject);
begin
//
end;

procedure TMainForm.MainPagesMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  tabindex: Integer;
  pc: TTntPageControl;
  newhint: string;
  r: TRect;
  show: boolean;
  pt: TPoint;
begin

  pc := sender as TTntPageControl;
  tabindex := pc.IndexOfTabAt(X, Y);
  show := false;
  if tabindex >= 0 then begin

    if SendMessage(pc.Handle, TCM_GETITEMRECT, tabindex,
      LPARAM(@r)) <> 0 then begin
      pt.X := x; pt.y := y;
      if PtInRect(r, pt) then begin
        newhint := HintForTab(pc, tabindex);
      end else newhint := '';
      if newhint <> pc.Hint then begin
        pc.Hint := newhint;
        application.CancelHint;
      end;
    end;
  end
  else
    pc.Hint := '';
end;

procedure TMainForm.mBibleTabsExChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var
  i, modIx: integer;
  found: boolean;
  s: WideString;
  pwsNewModuleText: PWideChar;
  me: TModuleEntry;
  ti: TViewTabInfo;
begin
  found := false;
  if mInterfaceLock then exit;
  try

//  i := ord(mBibleTabsInCtrlKeyDownState) shl 1;
    if newtab >= mBibleTabsEx.WideTabs.Count - 1 then begin
      AllowChange := false;
      exit;
    end
    else begin
      if IsDown(VK_Shift) or isDown(VK_MENU) then begin
        AllowChange := false; exit;
      end;
      me := mBibleTabsEx.WideTabs.Objects[newtab] as TModuleEntry;

//  s := mBibleTabsEx.WideTabs[NewTab];
//  pwsNewModuleText := PWideChar(Pointer(s)) + i;
//  moduleCodelistCount := ModulesCodeList.Count - 1;
//  for i := 0 to moduleCodelistCount do
//  begin
//
//    if CompareStringW(LOCALE_SYSTEM_DEFAULT, 0, pwsNewModuleText, -1,
//      PWideChar(Pointer(ModulesCodeList[i])), -1) = CSTR_EQUAL then
//    begin
//      found := true;
//      break;
//    end;
//  end;
//  if not found then
//  begin
//    AllowChange := false;
//    exit;
//  end;
//  s := ModulesList[i];
//  i := Pos('$$$', s);
  //  HistoryOn := false;
  // GoModuleName(Copy(s, 1, i - 2));
  //  HistoryOn := true;
//  LinksCB.Visible := false;

      GoModuleName(me.wsFullName);
    end;
  except on e: Exception do BqShowException(e); end;

  tbLinksToolBar.Visible := false;
end;

procedure TMainForm.mBibleTabsExClick(Sender: TObject);
var pt: TPoint;
  it, modIx: integer;
  me: TModuleEntry;
  ti: TViewTabInfo;
  s: WideString;
begin
  if mInterfaceLock then exit;
  pt := mBibleTabsEx.ScreenToClient(Mouse.CursorPos);
  it := mBibleTabsEx.ItemAtPos(pt);
  if (it < 0) or (it >= mBibleTabsEx.WideTabs.Count) then exit;
  if (it = mBibleTabsEx.WideTabs.Count - 1) then begin
    if isdown(VK_SHIFT) then begin
      SelectSatelliteBibleByName('');
      exit;
    end;
    modIx := mModules.FindByFolder(GetActiveTabInfo().mBible.ShortPath);
    if modIx >= 0 then begin
      me := TModuleEntry(mModules.Items[modIx]);
      if mFavorites.AddModule(me) then AdjustBibleTabs();
    end;
    exit;
  end;

  me := mBibleTabsEx.WideTabs.Objects[it] as TModuleEntry;
  if IsDown(VK_SHIFT) then begin
    SelectSatelliteBibleByName(me.wsFullName);
    exit;
  end;
  if IsDown(VK_MENU) then begin
    ti := GetActiveTabInfo();
    s := ti.mwsLocation;
    StrReplace(s, MainBook.ShortPath, me.wsShortPath, false);
    NewViewTab(s, ti.mSatelliteName, ti.mShowStrongs, ti.mShowNotes,
      ti.mResolvelinks);
    exit;
  end;
end;

procedure TMainForm.mBibleTabsExDrawTab(Sender: TObject; TabCanvas: TCanvas;
  R: TRect; Index: Integer; Selected: Boolean);
begin                                   //
end;

(*AlekId:Добавлено*)
{AlekId: вызывает контекстное меню }

procedure TMainForm.mBibleTabsExMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  ix: integer;
begin
  if Button <> mbLeft then
    exit;
  pt.X := X;
  pt.Y := Y;
  ix := mBibleTabsEx.ItemAtPos(pt);
  mBibleTabsEx.Tag := ix;
  if (ix < 0) or (ix >= mBibleTabsEx.WideTabs.Count - 1) then
    exit;
  mBibleTabsEx.BeginDrag(false, 20);
end;

procedure TMainForm.mBibleTabsExMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
{$J+}
const
  last_mouse_pos: TPoint = (X: 0; Y: 0);
  last_mouse_time: Cardinal = Cardinal(0);
  
  last_ix: integer = -1;
var
  deltaX, deltaY: integer;
  tm: Cardinal;
  ps: TPoint;
  it: integer;
  me: TModuleEntry;
  ws, txt, modPath, fontName: WideString;
  bl,common_lnk:TBibleLink;

  ti:TViewTabInfo;
begin
  ps.X := x; ps.y := y;
  tm := GetTickCount();
  it := mBibleTabsEx.ItemAtPos(ps);
  if (it = last_ix){ and (tm-last_mouse_time<1000)} then exit;
  last_mouse_time:=tm;

//  deltaX := X - last_mouse_pos.X;
//  if deltaX < 0 then
//    deltaX := -deltaX;
//  deltaY := Y - last_mouse_pos.Y;
//  if deltaY < 0 then
//    deltaX := -deltaY;
//  tm := GetTickCount();
//  if (deltaX + deltaY) > 15 then
//  begin
//    last_mouse_time := tm;
//    last_mouse_pos.X := X;
//    last_mouse_pos.Y := Y;
//    exit;
//  end;
//  if (tm - last_mouse_time) < 300 then
//    exit;
  if last_ix<>it then begin
   last_ix := it;
   hint_expanded:=0;
  end
  else if hint_expanded>=1 then exit;//same tab hint already expanded



  if (it < 0) or (it = mBibleTabsEx.WideTabs.Count - 1) then
  begin TntControl_SetHint(mBibleTabsEx, ''); exit end;

  me := mBibleTabsEx.WideTabs.Objects[it] as TModuleEntry;
  ws := me.wsFullName;

//   ws:=ws+#13#10+txt;
   if hint_expanded=0 then  hint_expanded:=1;
  TntControl_SetHint(mBibleTabsEx, ws);
  Application.CancelHint();
//  OutputDebugStringW('mmove')
  { TODO 3 -oAlekId -cdev : добавить hint }
  ///mBibleTabsEx.ShowHint:=true;
end;

procedure TMainForm.mBibleTabsExMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  itemIx: integer;
begin
  miDeteleBibleTab.Tag := 0;
  if Button <> mbRight then
    exit;
  pt.X := X;
  pt.Y := Y;
  itemIx := mBibleTabsEx.ItemAtPos(pt);
  if ((itemIx < 0) or (itemIx >= mBibleTabsEx.WideTabs.Count - 1))
    or (mBibleTabsEx.WideTabs.Count <= 2) then
    exit;
  miDeteleBibleTab.Tag := ItemIx;
  pt := mBibleTabsEx.ClientToScreen(pt);
  EmptyPopupMenu.Popup(pt.X, pt.Y);
end;

//set Browser to currently active browser

procedure TMainForm.mViewTabsChange(Sender: TObject);
begin
  try                                   //this does
    //переключение контекста
    //обновить
    try
      GetActiveTabInfo().mHtmlViewer.NoScollJump := true;
      UpdateUI();
    finally
      GetActiveTabInfo().mHtmlViewer.NoScollJump := false; end;
  except on e: Exception do BqShowException(e) {just eat everything wrong}
  end;
end;

procedure TMainForm.mViewTabsChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
 //
end;

{AlekId:добавлено}

procedure TMainForm.mViewTabsDblClick(sender: TAlekPageControl; index: Integer);
var ti: TViewTabInfo;
begin
  ti := TObject(mViewTabs.Pages[index].Tag) as TViewTabInfo;
  if not assigned(ti) then exit;
  NewViewTab(ti.mwsLocation, ti.mSatelliteName, ti.mShowStrongs, ti.mShowNotes,
    ti.mResolvelinks)
end;

procedure TMainForm.mViewTabsDeleteTab(sender: TAlekPageControl;
  index: Integer);
begin
  //
  mViewTabs.Tag := index;
  miCloseTabClick(sender);
end;

procedure TMainForm.mViewTabsDragDrop(Sender, Source: TObject; X, Y: Integer);
var dropTix, dragTix: integer;
  dropTs, dragTs, curTs: TTntTabSheet;
begin
  dropTix := mViewTabs.IndexOfTabAt(x, y);
  if dropTix < 0 then exit;
  dragTs := TObject(mViewTabs.Tag) as TTntTabSheet;
  dropTs := mViewTabs.Pages[dropTix] as TTntTabSheet;
  dragTix := dragTs.PageIndex;
//dropTs.PageIndex:=dragTix;
  dragTs.PageIndex := dropTix;
end;

procedure TMainForm.mViewTabsDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var i: integer;
begin
//
  if source <> mViewTabs then exit;
  accept := true;
//i:= pc.IndexOfTabAt(X, Y);

end;

procedure TMainForm.mViewTabsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    mViewTabs.BeginDrag(false, 10);
end;

{/AlekId:добавлено}

procedure TMainForm.mViewTabsStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
  mousePos: TPoint;
var
  ix: integer;
begin
  //
  try
    mousePos := Mouse.CursorPos;
    with mViewTabs do
    begin
      mousePos := ScreenToClient(mousePos);
      ix := IndexOfTabAt(mousePos.X, mousePos.Y);
      if ((ix < 0) or (ix >= PageCount)) then
      begin
        CancelDrag();
        exit;
      end;
      mViewTabs.Tag := integer(Pages[ix]);
    end;
  except

  end;
end;

//этот обработчик вызывается при правом щелчке на на закладках видов

procedure TMainForm.mInitialViewPageContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  ix: integer;
begin
  ix := mViewTabs.IndexOfTabAt(MousePos.X, MousePos.Y);
  try
    if ix >= 0 then
      ix := integer(mViewTabs.Pages[ix])
    else
      ix := 0;
  except
    ix := 0;
  end;
  mViewTabs.Tag := ix;
end;

//proc on context

//proc   mMainViewTabsChange
(*AlekId:/Добавлено*)

function TMainForm.LocateDicItem: integer;
var
  s: WideString;
  i, list_ix, len: integer;
  nd: PVirtualNode;
begin
  {AlekId:добавлено}
  {это чтобы избежать ненужных "рывков" в списке при двойном щелчке}
  list_ix := DicSelectedItemIndex();
  if (list_ix >= 0) and (list_ix < mDicList.Count)
    and (mDicList[list_ix] = DicEdit.Text) then begin
    result := list_ix; exit; end;
  {//AlekId:добавлено}
  s := Trim(DicEdit.Text);
  if length(s) <= 0 then begin
    nd := vstDicList.GetFirst();
    vstDicList.Selected[nd] := true;
    DicScrollNode(nd);
  end;
  len := Length(s);
  repeat
    list_ix := mDicList.LocateLastStartedWith(s, 0);
    if list_ix >= 0 then
    begin
      result := list_ix;
      Exit;
    end;
    Dec(len);
    s := Copy(s, 1, len);
  until len <= 0;
  result := 0;
end;

{procedure TMainForm.XrefBrowserMainHotSpotClick(Sender: TObject;
  const SRC: string; var Handled: Boolean);
begin
  ProcessCommand(SRC);
  Handled := true;
end;}

(*AlekId:Добавлено*)

function TMainForm._CreateNewBibleInstance(aBible: TBible;
  aOwner: TComponent): TBible;
begin
  Result := nil;
  try
    Result := TBible.Create(aOwner);
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

function TMainForm._CreateNewBrowserInstanse(
  aBrowser: THTMLViewer; aOwner: TComponent; aParent: TWinControl): THTMLViewer;
begin
  Result := nil;
  try
    Result := THtmlViewer.Create(aOwner); //AlekId
    Result.Parent := aParent;
    Result.Scrollbars := ssBoth;
    with Result do
    begin
      DefFontName := mBrowserDefaultFontName {Browser.DefFontName};
      DefFontSize := Browser.DefFontSize;
      DefFontColor := Browser.DefFontColor;
      //DefaultCharset := Browser.DefaultCharset;
      DefBackGround := Browser.DefBackGround;
      DefHotSpotColor := Browser.DefHotSpotColor;
      BorderStyle := Browser.BorderStyle;
      Align := alClient;
      htOptions := Browser.htOptions;
      OnKeyDown := FirstBrowserKeyDown;
      OnKeyPress := FirstBrowserKeyPress;
      OnKeyUp := FirstBrowserKeyUp;
      OnMouseDouble := FirstBrowserMouseDouble;
      OnImageRequest := FirstBrowserImageRequest;
      PopupMenu := BrowserPopupMenu;
      OnHotSpotClick := FirstBrowserHotSpotClick;
      OnHotSpotCovered := FirstBrowserHotSpotCovered;
      OnMouseWheel := FirstBrowserMouseWheel;
      VScrollBar.OnChange := Self.VSCrollTracker;
    end;

  except on e: Exception do begin Result.Free(); BqShowException(e) end
  end;
end;
(*AlekId:/Добавлено*)

procedure TMainForm.miDicClick(Sender: TObject);
begin
  if not MainPages.Visible then
    ToggleButton.Click;

  MainPages.ActivePage := DicTab;
end;

procedure TMainForm.miNewTabClick(Sender: TObject);
var
//  newBrowser, saveBrowser: THtmlViewer;
  ActiveTabInfo: TViewTabInfo;
  satBibleName: WideString;
begin
{  newBrowser := nil;
  newBible := nil;}

  try
    try
      if mViewTabs.Tag >= 64 * 1024 then
        ActiveTabInfo := TObject((TObject(mViewTabs.Tag) as TTntTabSheet).tag)
          as
          TViewTabInfo
      else
        ActiveTabInfo := GetActiveTabInfo();
    except
      ActiveTabInfo := GetActiveTabInfo();
    end;

    satBibleName := ActiveTabInfo.mSatelliteName;
    NewViewTab(ActiveTabInfo.mwsLocation, satBibleName,
      ActiveTabInfo.mShowStrongs, ActiveTabInfo.mShowNotes,
      ActiveTabInfo.mResolvelinks);
(*    Tab1 := TTntTabSheet.Create(MainForm);
    Tab1.PageControl := mViewTabs;
    Tab1.OnContextPopup := mInitialViewPageContextPopup;
    newBrowser := _CreateNewBrowserInstanse(Browser, Tab1, Tab1);
    if not Assigned(newBrowser) then abort;
    Browser := newBrowser;
      //конструируем TBible
    newBible := _CreateNewBibleInstance(MainBook, Tab1);
    if not Assigned(newBible) then
      abort;
    {with ActiveTabInfo.mBible do
    begin
      if IniFile = '' then
        newBible.IniFile := MainFileExists(mDefaultLocation + '\' +
          C_ModuleIniName)
      else
      begin
        newBible.IniFile := IniFile;
        //newBible.OpenChapter(CurBook, CurChapter);//AlekId: по видимому, ни к чему
        // так как далее следует ProcessCommand
      end;
    end;}

    tabInfo := TViewTabInfo.Create(newBrowser, newBible, ActiveTabInfo.mwsLocation,
      ActiveTabInfo.mSatelliteMenuItem, ActiveTabInfo.mShowStrongs, ActiveTabInfo.mShowNotes);
    Tab1.Tag := Integer(tabInfo);
    //какждой вкладке по броузеру
    MainBook := newBible;
    mViewTabs.ActivePageIndex := mViewTabs.PageCount - 1;
    SelectSatelliteMenuItem(ActiveTabInfo.mSatelliteMenuItem);
    StrongNumbersOn:=ActiveTabInfo.mShowStrongs;
    MemosOn:=ActiveTabInfo.mShowNotes;
    SafeProcessCommand(ActiveTabInfo.mwsLocation);
    UpdateUI();
  except
    Browser := saveBrowser;
    MainBook := saveMainBible;
    newBible.Free();
    newBrowser.Free();
    Tab1.Free();
  end;*)
  (*AlekId:/Добавлено*)
  except end;
end;

procedure TMainForm.miChooseSatelliteBibleClick(Sender: TObject);
begin
  SatelliteButton.Click();
end;

procedure TMainForm.miCloseAllOtherTabsClick(Sender: TObject);
var savetab, curTab: TTntTabSheet;
  tabInfo: TViewTabInfo;
  i, c: integer;
begin
  try
    Integer(savetab) := -1;
    if (mViewTabs.PageCount <= 1) then begin MessageBeep(MB_ICONEXCLAMATION); exit; end;
    if (mViewTabs.Tag < 65536) then savetab := TTntTabSheet(mViewTabs.ActivePage)
    else

    try
      savetab := TObject(mViewTabs.Tag) as TTntTabSheet;
    finally
      mViewTabs.Tag := 0;               //now is done
    end;                                //finally
//  if Integer(savetab) = -1 then exit;

    mViewTabs.ActivePage := savetab;
    c := mViewTabs.PageCount - 1;
    try
      repeat
        curTab := TTntTabSheet(mViewTabs.Pages[c]);
        dec(c);
        if curTab = savetab then continue;
        tabInfo := TObject(curTab.Tag) as TViewTabInfo;
        curTab.Free();
        tabInfo.Free();
      until c < 0;
    finally
      mViewTabsChange(nil);
      mViewTabs.Repaint();
    end;
  except on e: Exception do BqShowException(e, WideFormat('mViewTabs.Tag:%d', [mViewTabs.Tag]));
  end;                                  //except
end;

procedure TMainForm.miCloseTabClick(Sender: TObject);
var
  tabInfo: TViewTabInfo;
  tab: TTabSheet;
  tabIx: integer;
begin
  //AlekId: закомментировано
  { if mMainViewTabs.PageCount > 1 then
   try
      i := mMainViewTabs.ActivePageIndex;
      mMainViewTabs.Pages[mMainViewTabs.ActivePageIndex].Destroy;
      if i > mMainViewTabs.PageCount - 1 then
        mMainViewTabs.ActivePageIndex := mMainViewTabs.PageCount - 1
      else
        mMainViewTabs.ActivePageIndex := i;
    finally
      // find the browser component on the current tab
      for i := 0 to mMainViewTabs.Pages[mMainViewTabs.ActivePageIndex].ComponentCount - 1 do begin
        if mMainViewTabs.Pages[mMainViewTabs.ActivePageIndex].Components[i].ClassName = 'THtmlViewer' then begin
          Browser := Pointer(mMainViewTabs.Pages[mMainViewTabs.ActivePageIndex].Components[i]);
          break;
        end;
      end;
    end;}

  (*AlekId:Добавлено*)
  if mViewTabs.PageCount > 1 then
  try
    if (Sender = miCloseViewTab) and (mViewTabs.Tag <> 0) then
    begin
      //close tab under cursor
      try
        tab := TObject(mViewTabs.Tag) as TTntTabSheet;
        mViewTabs.Tag := 0;             //now is done
      except                            //some goes wrong
        tab := TTntTabSheet(mViewTabs.ActivePage);
      end;
    end                                 //if (Sender=mmiCloseViewTab)
    else
    begin                               //close active tab
      tab := TTntTabSheet(mViewTabs.ActivePage);
    end;
    tabIx := tab.TabIndex;
    tabinfo := TObject(tab.Tag) as TViewTabInfo;
    tab.Free();
    if tabIx = mViewTabs.PageCount then
      mViewTabs.ActivePageIndex := tabIx - 1;
    //if active tab is being closed, another one is activated, but on OnChange
    // event of TPageControl is NOT triggered
    mViewTabsChange(nil);
    tabInfo.Free();
    if mViewTabs.PageCount <= 1 then
      mViewTabs.Repaint();
  except                                {do nothing,eat}
  end;
  (*AlekId:/Добавлено*)
end;

procedure TMainForm.miCommentsClick(Sender: TObject);
begin
  if not MainPages.Visible then
    ToggleButton.Click;

  MainPages.ActivePage := CommentsTab;
end;

procedure TMainForm.BookLBClick(Sender: TObject);
var
  offset, i: integer;
begin
  AddressFromMenus := true;

  with ChapterLB do
  begin
    Items.BeginUpdate;
    Items.Clear;

    offset := 0;
    if MainBook.ChapterZero then
      offset := 1;

    for i := 1 to MainBook.ChapterQtys[BookLB.ItemIndex + 1] do
      Items.Add(IntToStr(i - offset));

    Items.EndUpdate;
    ItemIndex := 0;
  end;

  NavigateToInterfaceValues();
end;

procedure TMainForm.BookLBMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var p: TPoint;
  it: integer;
begin
  p.x := x; p.y := y;
  it := BookLB.ItemAtPos(p, true);
  if (it < 0) then exit;
  if mlbBooksLastIx < 0 then mlbBooksLastIx := it
  else if (mlbBooksLastIx = it) then exit;
  mlbBooksLastIx := it;
  TntControl_SetHint(BookLB, BookLB.Items[it]);
  Application.CancelHint();

end;

procedure TMainForm.ChapterLBClick(Sender: TObject);
begin
  AddressFromMenus := true;
  NavigateToInterfaceValues();
end;

function TMainForm.DeleteHotModule(const me: TModuleEntry): boolean;
var
  hotMenuItem, favouriteMenuItem: TTntMenuItem;
  i, cnt: integer;
begin
  try
    favouriteMenuItem := FindTaggedTopMenuItem(3333);
    hotMenuItem := FavouriteItemFromModEntry(me);
    if assigned(hotMenuItem) then begin
      favouriteMenuItem.Remove(hotMenuItem);
      hotMenuItem.Free();
    end;
    SetFavouritesShortcuts();
  except on e: Exception do BqShowException(e); end;
  try
    i := FavouriteTabFromModEntry(me);
    if i >= 0 then mBibleTabsEx.WideTabs.Delete(i);
    AdjustBibleTabs(MainBook.ShortName);
  except on e: Exception do BqShowException(e); end;

end;

{procedure TMainForm.DeleteInvalidHotModules();
var
  i, favouriteCount, moduleIndex, hotIndex: integer;
  favouriteMenuItem, mi: TTntMenuItem;
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
end;}

procedure TMainForm.Splitter2Moved(Sender: TObject);
begin
//  GroupBox1.Height := Panel2.Height;
//  BookLB.Height := Panel2.Height - GoEdit.Height - BooksCB.Height - 26;
//  ChapterLB.Height := BookLB.Height;
end;

procedure TMainForm.Splitter1Moved(Sender: TObject);
begin
  // Navigation Tab elements

//  GroupBox1.Width := MainPages.Width - 10;
//  BooksCB.Width := GroupBox1.Width - 10;
//  BookLB.Width := BooksCB.Width - ChapterLB.Width - 5;
//  ChapterLB.Left := BookLB.Width + 10;
//
//  GoEdit.Width := BookLB.Width - HelperButton.Width;
//  HelperButton.Left := GoEdit.Left + GoEdit.Width + 3;
//  AddressOKButton.Left := ChapterLB.Left;

  // Search Tab elements

//  SearchCB.Width := SearchTab.Width - CBQty.Width - 10;
//  CBQty.Left := SearchCB.Width + 7;
  //CBList.Width := SearchCB.Width - 22;
//  FindButton.Left := CBQty.Left;

  // Dic Tab & Strong Tab

//  DicEdit.Width := DicTab.Width - 10;
//  vstDicList.Width := DicEdit.Width;
//  DicCB.Width := DicEdit.Width;
//  DicFilterCB.Width := DicEdit.Width;
//  StrongEdit.Width := StrongTab.Width - 10;
//  StrongLB.Width := StrongEdit.Width;

//  CommentsCB.Width := DicEdit.Width + 5;
end;

procedure TMainForm.BibleTabsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  tabIndex, sourceTabIx, modIx: integer;
  viewTabInfo: TViewTabInfo;
  mi: TTntMenuItem;
  dragDropPoint: TPoint;
  i, count, firstHotMenuItemPos: integer;
  me, me2, xch: TModuleEntry;
begin
  dragDropPoint.X := X;
  dragDropPoint.Y := Y;
  tabIndex := mBibleTabsEx.ItemAtPos(dragDropPoint);
  if (tabIndex < 0) or (tabIndex >= mBibleTabsEx.WideTabs.Count) then
    exit;

  if Source is TAlekPageControl then
  begin
    try
      viewTabInfo := TObject((TObject((Source as TAlekPageControl).Tag) as
        TTntTabSheet).Tag) as TViewTabInfo;
      if tabIndex = mBibleTabsEx.WideTabs.Count - 1 then
      begin
        // drop on *** - last tab, adding new tab
        modIx := mModules.FindByFolder(viewTabInfo.mBible.ShortPath);
        if modIx >= 0 then begin
          me := TModuleEntry(mModules.Items[modIx]);
          mFavorites.AddModule(me);
          AdjustBibleTabs(MainBook.ShortName);
        end;
        exit;
      end;
      //cp:=viewTabInfo.mBible.Name;
      //replace
      modIx := mModules.FindByFolder(viewTabInfo.mBible.ShortPath);
      if modIx < 0 then exit;
      me := TModuleEntry(mModules.Items[modIx]);
      if not assigned(me) then exit;
      mFavorites.ReplaceModule(TModuleEntry(
        mBibleTabsEx.WideTabs.Objects[tabIndex]), me);
      AdjustBibleTabs(MainBook.ShortName);
    except
    end;
  end
  else if source is TDockTabSet then
  begin                                 //move/exchange
    if (tabIndex = mBibleTabsEx.WideTabs.Count) then
      exit;

    sourceTabIx := mBibleTabsEx.Tag;
    if (sourceTabIx < 0) or (sourceTabIx >= mBibleTabsEx.WideTabs.Count) or
      (sourceTabIx = tabIndex) then exit;
    me := TModuleEntry(mBibleTabsEx.WideTabs.Objects[sourceTabIx]);
    me2 := TModuleEntry(mBibleTabsEx.WideTabs.Objects[tabIndex]);

//    if tabIndex<sourceTabIx then begin
//      xch:=me2; me2:=me; me:=xch;
//    end;
//    mFavorites.xChg(me,me2);
    mFavorites.moveItem(me, tabIndex);
//    mBibleTabsEx.WideTabs.Move(sourceTabIx, tabIndex);
//    count := mBibleTabsEx.WideTabs.Count - 2;
//    firstHotMenuItemPos := GetHotMenuItem(0).MenuIndex;
//    for i := 0 to count do
//    begin
//      mi := mBibleTabsEx.WideTabs.Objects[i] as TTntMenuItem;
//      mi.MenuIndex := firstHotMenuItemPos + i;
//    end;

    AdjustBibleTabs(MainBook.ShortName);
    SetFavouritesShortcuts();
  end;                                  //else if

end;

procedure TMainForm.BibleTabsDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  tabIx, delta: integer;
  dragOverPoint: TPoint;
begin
  dragOverPoint.X := X;
  dragOverPoint.Y := Y;
  tabIx := mBibleTabsEx.ItemAtPos(dragOverPoint);
  if Source is TDockTabSet then
    delta := 1
  else
    delta := 0;
  Accept := (tabIx >= 0) and (tabIx < mBibleTabsEx.WideTabs.Count - delta);
end;

procedure TMainForm.miMemoPasteClick(Sender: TObject);
begin
  if MemoPopupMenu.PopupComponent = TREMemo then
    TREMemo.PasteFromClipboard
  else if MemoPopupMenu.PopupComponent is TTntEdit then
    (MemoPopupMenu.PopupComponent as TTntEdit).PasteFromClipboard
  else if MemoPopupMenu.PopupComponent is TTntComboBox then
    (MemoPopupMenu.PopupComponent as TTntComboBox).Text := TntClipboard.AsText;
end;

procedure TMainForm.CBQtyChange(Sender: TObject);
begin
  if CBQty.ItemIndex < CBQty.Items.Count - 1 then
    SearchPageSize := StrToInt(CBQty.Items[CBQty.ItemIndex])
  else
    SearchPageSize := 50000;
  DisplaySearchResults(1);
end;

procedure TMainForm.miRefFontConfigClick(Sender: TObject);
begin
  with FontDialog1 do
  begin
    Font.Name := SearchBrowser.DefFontName;
    Font.Color := SearchBrowser.DefFontColor;
    Font.Size := SearchBrowser.DefFontSize;
    //Font.Charset := DefaultCharset;
  end;

  if FontDialog1.Execute then
  begin
    //DefaultCharset := FontDialog1.Font.Charset;

    with SearchBrowser do
    begin
      DefFontName := FontDialog1.Font.Name;
      DefFontColor := FontDialog1.Font.Color;
      DefFontSize := FontDialog1.Font.Size;
      LoadFromString(DocumentSourceUtf16);
    end;

    with DicBrowser do
    begin
      DefFontName := SearchBrowser.DefFontName;
      DefFontColor := SearchBrowser.DefFontColor;
      DefFontSize := SearchBrowser.DefFontSize;
      LoadFromString(DocumentSourceUtf16);
    end;

    with StrongBrowser do
    begin
      DefFontName := SearchBrowser.DefFontName;
      DefFontColor := SearchBrowser.DefFontColor;
      DefFontSize := SearchBrowser.DefFontSize;
      LoadFromString(DocumentSourceUtf16);
    end;

    with XrefBrowser do
    begin
      DefFontName := SearchBrowser.DefFontName;
      DefFontColor := SearchBrowser.DefFontColor;
      DefFontSize := SearchBrowser.DefFontSize;
    end;

    with CommentsBrowser do
    begin
      DefFontName := SearchBrowser.DefFontName;
      DefFontColor := SearchBrowser.DefFontColor;
      DefFontSize := SearchBrowser.DefFontSize;
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
  InputForm.Tag := 0;                   // use TTntEdit
  InputForm.Caption := miQuickNav.Caption;
  InputForm.Font := MainForm.Font;
  with MainBook do
    if CurFromVerse > 1 then
      InputForm.Edit1.Text := ShortPassageSignature(CurBook, CurChapter,
        CurFromVerse, CurToVerse)
    else
      InputForm.Edit1.Text := ShortPassageSignature(CurBook, CurChapter, 1, 0);
  InputForm.Edit1.SelectAll();
  if InputForm.ShowModal = mrOK then
  begin
    GoEdit.Text := InputForm.Edit1.Text;
    InputForm.Edit1.Text := '';
    AddressOKButton.Click;
    ActiveControl := Browser;
  end;
end;

procedure TMainForm.miQuickSearchClick(Sender: TObject);
begin
  InputForm.Tag := 0;                   // use TTntEdit
  InputForm.Caption := miQuickSearch.Caption;
  InputForm.Font := MainForm.Font;

  with MainBook do
    InputForm.Edit1.Text := SearchCB.Text;

  if InputForm.ShowModal = mrOK then
  begin
    if not MainPages.Visible then
      ToggleButton.Click;
    MainPages.ActivePage := SearchTab;

    SearchCB.Text := InputForm.Edit1.Text;
    FindButton.Click;
  end;
end;

procedure TMainForm.CopyrightButtonClick(Sender: TObject);
begin
  if MainBook.Copyright = '' then
    WideShowMessage(Copy(CopyrightButton.Hint, 2, $FFFFFF))
  else
  begin
    if not assigned(CopyrightForm) then
      CopyrightForm := TCopyrightForm.Create(self);
    CopyrightForm.Caption := 'Copyright (c) ' + MainBook.Copyright;
    if FileExists(MainBook.Path + 'copyright.htm') then
    begin
      CopyrightForm.Browser.LoadFromFile(MainBook.Path + 'copyright.htm');
      CopyrightForm.ShowModal;
    end
    else
      WideShowMessage('File not found: ' + MainBook.Path + 'copyright.htm');
  end;
end;

procedure TMainForm.miMemoCutClick(Sender: TObject);
begin
  if MemoPopupMenu.PopupComponent = TREMemo then
    TREMemo.CutToClipboard
  else if MemoPopupMenu.PopupComponent is TTntEdit then
    (MemoPopupMenu.PopupComponent as TTntEdit).CutToClipboard
  else if MemoPopupMenu.PopupComponent is TTntComboBox then
  begin
    TntClipboard.AsText := (MemoPopupMenu.PopupComponent as TTntComboBox).Text;
    (MemoPopupMenu.PopupComponent as TTntComboBox).Text := '';
  end;
end;

procedure TMainForm.DicFilterCBChange(Sender: TObject);
var
  pvn: PVirtualNode;
  i, j, c: integer;
begin
  if DicFilterCB.ItemIndex <> 0 then
  begin
    vstDicList.BeginUpdate();
    try
      vstDicList.Clear;
      if not assigned(mDicList) then mDicList := TBQStringList.Create
      else mDicList.Clear();
      mDicList.Sorted := true;

      j := DicFilterCB.ItemIndex - 1;

      for i := 0 to Dics[j].Words.Count - 1 do
        mDicList.Add(Dics[j].Words[i]);
      Application.ProcessMessages();
      c := mDicList.Count - 1;
      for i := 0 to c do begin
        pvn := vstDicList.AddChild(nil, Pointer(i));
        mDicList.Objects[i] := TObject(pvn);
//      DicLB.Items.Add(DicList[i]);
        if i and $FFF = $FFF then Application.ProcessMessages;

      end;
//    DicLB.Items.AddStrings(DicList);
    finally
      vstDicList.EndUpdate();
    end;
//    MessageBeep(MB_ICONINFORMATION);

  end
  else
  begin
    DictionaryStartup();
  end;
end;

procedure TMainForm.miAddBookmarkClick(Sender: TObject);
var
  newstring: WideString;
begin
  InputForm.Tag := 1;                   // use TMemo
  InputForm.Caption := miAddBookmark.Caption;
  InputForm.Font := MainForm.Font;
  if MainBook.Lines.Count = 0 then
    MainBook.OpenChapter(MainBook.CurBook, MainBook.CurChapter);
  if MainBook.StrongNumbers then
    newstring := Trim(DeleteStrongNumbers(MainBook.Lines[CurVerseNumber -
      CurFromVerse]))
  else
    newstring := Trim(MainBook.Lines[CurVerseNumber - CurFromVerse]);

  StrDeleteFirstNumber(newstring);

  InputForm.Memo1.Text := newstring;

  if InputForm.ShowModal = mrOK then
  begin
    with MainBook do
      newstring := ShortName + ' ' + ShortPassageSignature(CurBook, CurChapter,
        CurVerseNumber, CurVerseNumber)
        + ' ' + InputForm.Memo1.Text;

    StrReplace(newstring, #13#10, ' ', true);

    BookmarksLB.Items.Insert(0, newstring);

    with MainBook do
      Bookmarks.Insert(0,
        WideFormat('go %s %d %d %d %d $$$%s',
        [ShortPath, CurBook, CurChapter, CurVerseNumber, 0, newstring]));
  end;
end;

procedure TMainForm.miAddBookmarkTaggedClick(Sender: TObject);
var pn: PVirtualNode;
  nd: TVersesNodeData;
  f, t: integer;
begin
  InputForm.Tag := 0;
  pn := vstBookMarkList.GetFirstSelected();
  if not assigned(pn) then exit;
  nd := TVersesNodeData(vstBookMarkList.GetNodeData(pn)^);
  if not assigned(nd) then exit;
  if (nd.nodeType <> bqvntTag) then exit;
  if CurSelStart < CurSelEnd then begin f := CurSelStart; t := CurSelEnd; end
  else begin f := CurVerseNumber; t := 0; end;

  VerseListEngine.AddTagged(nd.SelfId, MainBook.CurBook, MainBook.CurChapter, f, t);
end;

procedure TMainForm.BookmarksLBDblClick(Sender: TObject);
begin
  ProcessCommand(Bookmarks[BookmarksLB.ItemIndex], hlDefault );
end;

procedure TMainForm.StrongBrowserHotSpotClick(Sender: TObject;
  const SRC: string; var Handled: Boolean);
var
  num, code: integer;
  scode: WideString;
begin
  if Pos('s', SRC) = 1 then
  begin
    scode := Copy(SRC, 2, Length(SRC) - 1);
    Val(scode, num, code);
    if code = 0 then
      DisplayStrongs(num, (Copy(scode, 1, 1) = '0'));
  end;
end;

procedure TMainForm.BookmarksLBClick(Sender: TObject);
begin
  BookmarkLabel.Caption := Comment(Bookmarks[BookmarksLB.ItemIndex]);
end;

procedure TMainForm.BookmarksLBKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i: integer;
begin
  if BookmarksLB.Items.Count = 0 then
    Exit;

  if Key = VK_DELETE then
  begin
    if Application.MessageBox('Удалить закладку?',
      'Подтвердите удаление', MB_YESNO + MB_DEFBUTTON1) <>
      ID_YES then
      Exit;

    i := BookmarksLB.ItemIndex;
    Bookmarks.Delete(i);
    BookmarksLB.Items.Delete(i);
    if i = BookmarksLB.Items.Count then
      i := i - 1;

    if i < 0 then
      Exit;

    BookmarksLB.ItemIndex := i;
    BookmarksLBClick(Sender);
  end;
end;

procedure TMainForm.HistoryLBKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i: integer;
begin
  if HistoryLB.Items.Count = 0 then
    Exit;

  if Key = VK_DELETE then
  begin
    if Application.MessageBox('Удалить запись в истории?',
      'Подтвердите удаление', MB_YESNO + MB_DEFBUTTON1) <>
      ID_YES then
      Exit;

    i := HistoryLB.ItemIndex;
    History.Delete(i);
    HistoryLB.Items.Delete(i);
    if i = HistoryLB.Items.Count then
      i := i - 1;

    if i < 0 then
      Exit;

    HistoryLB.ItemIndex := i;
    HistoryLBClick(Sender);
  end;
end;

procedure TMainForm.SearchBackwardClick(Sender: TObject);
var
  i, dx, dy: integer;
  x, y: LongInt;
begin
  i := LastPos(
    WideLowerCase(SearchEdit.Text),
    WideLowerCase(Copy(Browser.DocumentSourceUtf16, 1, BrowserSearchPosition -
    1))
    );

  if i > 0 then
  begin
    dx := Browser.FindDisplayPos(i, true);
    dy := Browser.FindDisplayPos(i + Length(SearchEdit.Text), true);

    Browser.SelStart := dx - 1;
    Browser.SelLength := dy - dx;

    BrowserSearchPosition := i;

    Browser.DisplayPosToXY(dx, x, y);

    if y > 10 then
      Browser.VScrollBarPosition := y - 10
    else
      Browser.VScrollBarPosition := y;
  end
  else
    BrowserSearchPosition := 0;
end;

procedure TMainForm.btnQuickSearchFwdClick(Sender: TObject);
var
  i, dx, dy: integer;
  x, y: LongInt;
begin
  if BrowserSearchPosition = 0 then
  begin
    BrowserSearchPosition := Pos('</title>', Browser.DocumentSourceUtf16);
    if BrowserSearchPosition > 0 then
      Inc(BrowserSearchPosition, Length('</title>'));
  end;

  i := Pos(
    WideLowerCase(SearchEdit.Text),
    WideLowerCase(Copy(Browser.DocumentSourceUtf16, BrowserSearchPosition + 1,
    Length(Browser.DocumentSourceUtf16)))
    );

  if i > 0 then
  begin
    i := BrowserSearchPosition + i;
    dx := Browser.FindDisplayPos(i, true);
    dy := Browser.FindDisplayPos(i + Length(SearchEdit.Text), true);

    Browser.SelStart := dx - 1;
    Browser.SelLength := dy - dx;

    BrowserSearchPosition := i;

    Browser.DisplayPosToXY(dx, x, y);
    if y > 10 then
      Browser.VScrollBarPosition := y - 10
    else
      Browser.VScrollBarPosition := y;
  end
  else
    BrowserSearchPosition := 0;         //AlekId:??
end;

procedure TMainForm.miSearchWindowClick(Sender: TObject);
begin
  {AlekId: теперь по другому}
  {  SearchToolbar.Visible := not SearchToolbar.Visible;
    miSearchWindow.Checked := SearchToolbar.Visible;
    //AlekId: не понятна логика сл. строки
   if SearchToolbar.Visible then ActiveControl := SearchEdit;}
  (*AlekId:Добавлено*)
  MainPages.ActivePageIndex := 0;       //на первую вкладку
  HistoryBookmarkPages.ActivePageIndex := 2;
  //на вкладку быстрого поиска
  ActiveControl := SearchEdit;
  (*AlekId:/Добавлено*)

  if Browser.SelLength <> 0 then
  begin
    SearchEdit.Text := Trim(Browser.SelText);
    btnQuickSearchFwd.Click;
  end;
end;

procedure TMainForm.FindStrongNumberPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FindStrongNumberPanel.BevelOuter := bvNone;
end;

procedure TMainForm.FindStrongNumberPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FindStrongNumberPanel.BevelOuter := bvRaised;
end;

function TMainForm.FindTaggedTopMenuItem(tag: integer): TTntMenuItem;
var
  menuItemCount, i: integer;
begin
  Result := nil;
  menuItemCount := theMainMenu.Items.Count - 1;
  for i := 0 to menuItemCount do
  begin
    if (theMainMenu.Items[i].Tag = tag) then
    begin
      Result := theMainMenu.Items[i] as TTntMenuItem;
      break
    end                                 //if
  end;                                  //for
end;

// find selected Strongs number in the whole Bible...

procedure TMainForm.FindStrongNumberPanelClick(Sender: TObject);
begin
  if StrongLB.ItemIndex < 0 then
    Exit;

  MainPages.ActivePage := SearchTab;

  SearchCB.Text := StrongLB.Items[StrongLB.ItemIndex];
  CBParts.Checked := true;

  if Copy(SearchCB.Text, 1, 1) = '0' then begin
//    SearchCB.Text:=Copy(SearchCB.Text,2,$FFF);
    CBList.ItemIndex := 1               // old testament
  end
  else
    CBList.ItemIndex := 2;              // new testament

  FindButton.Click;
end;

procedure TMainForm.miCopyOptionsClick(Sender: TObject);
begin
  ConfigForm.PageControl1.ActivePageIndex := 0;
  ShowConfigDialog;
end;

procedure TMainForm.miOpenNewViewClick(Sender: TObject);
var
  addr: WideString;
  ti: TViewTabInfo;
  satBible: WideString;

begin
//
  addr := UTF8Decode(Trim(G_XRefVerseCmd));
  if length(addr) <= 0 then exit;
  ti := GetActiveTabInfo();
  if assigned(ti) then
    satBible := ti.mSatelliteName
  else satBible := '------';

  NewViewTab(addr, satBible, miStrong.Checked,
    miMemosToggle.Checked, miRecognizeBibleLinks.Checked);
  if Pos('go ', addr) <> 1 then begin
    GoEdit.Text := addr;
    GoEditDblClick(nil);
  end;

end;

procedure TMainForm.miOptionsClick(Sender: TObject);
begin
  ConfigForm.PageControl1.ActivePageIndex := 2;
  ShowConfigDialog;
end;

procedure TMainForm.ShowConfigDialog;
var
  i, moduleCount, favMenuItemCount: integer;
  favMenuItem, mi: TTntMenuItem;
  sl: TWideStringList;
begin
  ForceForegroundLoad();
  with ConfigForm do
  begin
    Font.Assign(Self.Font);
    Left := (Screen.Width - Width) div 2;
    Top := (Screen.Height - Height) div 2;
    SelectPathEdit.Text := G_SecondPath;
    MinimizeToTray.Checked := TrayIcon.MinimizeToTray;
    cbFullContextOnRestrictedLinks.Checked:=mFlagFullcontextLinks;
    HotKeyChoice.ItemIndex := ConfigFormHotKeyChoiceItemIndex;
    moduleCount := ModulesList.Count - 1;
    cbxAvailableModules.Clear();
    sl := TWideStringList.Create;
    try
      sl.Sorted := true;
      sl.BeginUpdate;
      for i := 0 to moduleCount do
      begin
        sl.Add(ExtractModuleName(ModulesList[i]));
      end;
      sl.EndUpdate();
      cbxAvailableModules.Items.BeginUpdate;
      try
        cbxAvailableModules.Items.Clear;
        for i := 0 to sl.Count - 1 do
          cbxAvailableModules.Items.add(sl[i]);
      finally cbxAvailableModules.Items.EndUpdate(); end;

    finally
      sl.Free;
    end;
    if moduleCount >= 0 then
      cbxAvailableModules.ItemIndex := 0;

    moduleCount := mFavorites.mModuleEntries.Count - 1;
    lbxFavourites.Clear();
    lbxFavourites.Items.BeginUpdate();
    for i := 0 to moduleCount do
    begin
      lbxFavourites.Items.Add(TModuleEntry(mFavorites.mModuleEntries[i]).wsFullName);
    end;
    lbxFavourites.Items.EndUpdate();
  end;

  if ConfigForm.ShowModal = mrCancel then
    Exit;
  moduleCount := ConfigForm.lbxFavourites.Count - 1;
  mFavorites.Clear();
//  mBibleTabsEx.WideTabs.Clear();
  for i := 0 to moduleCount do begin
    mFavorites.AddModule(mModules.ResolveModuleByNames(
      ConfigForm.lbxFavourites.Items[i], ''));
  end;
//  mBibleTabsEx.WideTabs.Add('***');
//  favMenuItemCount := GetHotModuleCount();
//  favMenuItem := FindTaggedTopMenuItem(3333);
//  for i := 0 to moduleCount do
//  begin
//    if (i < favMenuItemCount) then
//    begin
//      GetHotMenuItem(i).Caption := ConfigForm.lbxFavourites.Items[i];
//    end
//    else
//    begin
//      mi := TTntMenuItem.Create(self);
//      mi.Tag := 7000 + i;
//      mi.Caption := ConfigForm.lbxFavourites.Items[i];
//      favMenuItem.Add(mi);
//    end;
//  end;
//  Inc(moduleCount);
//  Dec(favMenuItemCount);
//  for i := moduleCount to favMenuItemCount do
//  begin
//    mi := GetHotMenuItem(i);
//    favMenuItem.Remove(mi);
//    mi.Free();
//  end;
//
  SetFavouritesShortcuts();
  AdjustBibleTabs(MainBook.ShortName);
//  InitBibleTabs();

  CopyOptionsCopyVerseNumbersChecked := ConfigForm.CopyVerseNumbers.Checked;
  CopyOptionsCopyFontParamsChecked := ConfigForm.CopyFontParams.Checked;
  CopyOptionsAddReferenceChecked := ConfigForm.AddReference.Checked;
  CopyOptionsAddReferenceRadioItemIndex :=
    ConfigForm.AddReferenceRadio.ItemIndex;
  CopyOptionsAddLineBreaksChecked := ConfigForm.AddLineBreaks.Checked;
  CopyOptionsAddModuleNameChecked := ConfigForm.AddModuleName.Checked;
  ConfigFormHotKeyChoiceItemIndex := ConfigForm.HotKeyChoice.ItemIndex;
  TrayIcon.MinimizeToTray := ConfigForm.MinimizeToTray.Checked;
  mFlagFullcontextLinks:=ConfigForm.cbFullContextOnRestrictedLinks.Checked;
  if ConfigForm.SelectPathEdit.Text <> G_SecondPath then
  begin
    G_SecondPath := ConfigForm.SelectPathEdit.Text;
    MainMenuInit(true);
  end;
end;

procedure TMainForm.ShowHintEventHandler(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
var
  s, name: string;
  ix: integer;
begin
//  s := HintInfo.HintControl.ClassName;
//  name:=HintInfo.HintControl.Name;
//  if name='BookLB' then begin
//     ix:=BookLB.ItemAtPos(HintInfo.CursorPos,true);
//    if ix>=0 then begin
//
//    end;
//
//  end;
end;

procedure TMainForm.ShowQNav(useDisposition: TBQUseDisposition = udMyLibrary);
var ws, wcap, wbtn: WideString;
begin
  if not assigned(frmQNav) then frmQNav := TfrmQNav.Create(self);
  case useDisposition of
    udParabibles: begin ws := GetActiveTabInfo().mSatelliteName;
        wcap := Lang.SayDefault('SelectParaBible', 'Select secondary bible');
        wbtn := Lang.SayDefault('btnDeselectSec', 'Deselect');
        ws := SecondBook.Name;
      end;
    udMyLibrary: begin ws := MainBook.Name;
        wcap := Lang.SayDefault('MyLib', 'My Library');
        wbtn := Lang.SayDefault('frmQNav.btnCollapse.Caption', 'Collapse all');
      end;
  end;
  frmQNav.Caption := wcap;
  frmQNav.btnCollapse.Caption := wbtn;
  frmQNav.mUseDisposition := useDisposition;
  frmQNav.mCellText := EmptyWideStr;
  frmQNav.UpdateList(mModules, -1, ws);
  frmQNav.ShowModal();
  if (frmQNav.ModalResult <> mrOk) or (length(frmQNav.mCellText) <= 0) then
  begin
    SatelliteButton.Down := GetActiveTabInfo().mSatelliteName <> '------';
    exit;
  end;
  case useDisposition of
    udParabibles: SelectSatelliteBibleByName(frmQNav.mCellText);
    udMyLibrary: begin
        GoModuleName(frmQNav.mCellText);
        if frmQNav.mBookIx > 0 then begin
          BookLB.ItemIndex := frmQNav.mBookIx - 1;
          BookLBClick(self);
        end;
      end;
  end;
end;

procedure TMainForm.miAddMemoClick(Sender: TObject);
var
  newstring, signature: WideString;
  i: integer;
begin
  InputForm.Tag := 1;                   // use TMemo
  InputForm.Caption := miAddMemo.Caption;
  InputForm.Font := MainForm.Font;

  with MainBook do
    signature := ShortName + ' ' + ShortPassageSignature(CurBook, CurChapter,
      CurVerseNumber, CurVerseNumber) + ' $$$';

  // search for 'RST Быт.1:1 $$$' in Memos.
  i := FindString(Memos, signature);

  if i > -1 then                        // found memo
    newstring := Comment(Memos[i])
  else
    newstring := '';

  InputForm.Memo1.Text := newstring;

  if InputForm.ShowModal = mrOK then
  begin
    newstring := InputForm.Memo1.Text;
    StrReplace(newstring, #13#10, ' ', true);

    if i > -1 then
      Memos.Delete(i);                  // for SORTED WideString, first delete it...

    if Trim(newstring) <> '' then
      Memos.Add(signature + newstring);

    if not MemosOn then
      miMemosToggle.Click
    else
    begin
      miMemosToggle.Click;              // off
      miMemosToggle.Click;              // on - to show new memos...
    end;
  end;
end;

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
  if MainForm.Visible then
    TrayIcon.HideMainForm
  else
    TrayIcon.ShowMainForm;
end;

procedure TMainForm.SysHotKeyHotKey(Sender: TObject; Index: Integer);
begin
  if Index <> ConfigFormHotKeyChoiceItemIndex then
    Exit;

  if TrayIcon.MinimizeToTray then
  begin
    if MainForm.Visible then
    begin
      if Application.Active then
        Application.Minimize
      else
        Application.BringToFront;
    end
    else
      TrayIcon.ShowMainForm;
  end
  else
  begin                                 // if not minimizing to tray, hot key only activates or minimizes the app
    if Application.Active then
      Application.Minimize
    else
    begin
      Application.Restore;
      Application.BringToFront;
    end;
  end;
end;

procedure TMainForm.miMemosToggleClick(Sender: TObject);
var ti:TViewTabInfo;
begin
  miMemosToggle.Checked := not miMemosToggle.Checked;
  MemosOn := miMemosToggle.Checked;
  ti:=GetActiveTabInfo();
  ti.mShowNotes := miMemosToggle.Checked;

  ProcessCommand(ti.mwsLocation, TbqHLVerseOption(ord(ti.mHLVerses) ) );
//  ProcessCommand(History[HistoryLB.ItemIndex]);
end;

procedure TMainForm.HelperButtonClick(Sender: TObject);
var
  Lines: WideString;
  i, cc: integer;

begin
  Lines := '<body bgcolor=#EBE8E2>';

  AddLine(Lines, '<h2>' + MainBook.Name + '</h2>');
  cc := MainBook.Categories.Count - 1;
  if cc >= 0 then begin
    AddLine(Lines, '<font Size=-1><b>Метки:</b><br><i>' +
      TokensToStr(MainBook.Categories, '<br>     ', false) + '</i></font><br>');
  end;

  AddLine(Lines, '<b>Location:</b> '
    + Copy(MainBook.Path, 1, length(MainBook.Path) - 1) +
    ' <a href="editini=' + MainBook.Path + 'bibleqt.ini">ini</a><br>');
  for i := 1 to MainBook.BookQty do
    AddLine(Lines,
      '<b>' + MainBook.FullNames[i] +
      ':</b> ' +
      MainBook.VarShortNames[i] +
      '<br>'
      );

  AddLine(Lines, '<br><br><br>');
  if not assigned(CopyrightForm) then
    CopyrightForm := TCopyrightForm.Create(self);
  CopyrightForm.lbBQModName.Caption := MainBook.Name;
  if Length(Trim(MainBook.Copyright)) = 0 then
    CopyrightForm.lblCopyRightNotice.Caption := Lang.Say('PublicDomainText')
  else CopyrightForm.lblCopyRightNotice.Caption := MainBook.Copyright;

  CopyrightForm.Caption := MainBook.Name;
  CopyrightForm.Browser.LoadFromString(Lines);
  CopyrightForm.ActiveControl := CopyrightForm.Browser;
  CopyrightForm.ShowModal;

end;

procedure TMainForm.JCRU_HomeClick(Sender: TObject);
var
  s: AnsiString;
begin
  s := (Sender as TTntMenuItem).Name;
  if s = 'JCRU_Home' then
    s := 'http://jesuschrist.ru/'
  else if s = 'miTechnoForum' then s := C_BQTechnoForumAddr
  else if s = 'miDownloadLatest' then s := C_BQQuickLoad
  else
    s := 'http://jesuschrist.ru/' + LowerCase(Copy(s, 6, Length(s))) + '/';

  if WStrMessageBox(WideFormat(Lang.Say('GoingOnline'), [s]), 'JesusChrist.ru',
    MB_OKCancel + MB_DEFBUTTON1) <> ID_OK then
    Exit;

  ShellExecute(Application.Handle, nil, PChar(s), nil, nil, SW_NORMAL);
end;

procedure TMainForm.MemoPrintClick(Sender: TObject);
var
  opt: TPrintDialogOptions;
begin
  with PrintDialog1 do
  begin
    opt := Options;
    Options := [];
    if Execute then
      TREMemo.Print('Printed by BibleQuote, http://JesusChrist.ru');
    Options := opt;
  end;
end;

procedure TMainForm.SafeProcessCommand(wsLocation: WideString; hlOption:TbqHLVerseOption);
var
  succeeded: boolean;
begin
  if length(trim(wsLocation)) > 1 then
  begin
    succeeded := ProcessCommand(wsLocation, hlOption);
    if succeeded then
      exit;
  end;

  if length(trim(LastAddress)) > 1 then
  begin
    succeeded := ProcessCommand(LastAddress, hlOption);
    if succeeded then
      exit;
  end;
  ProcessCommand(WideFormat('go %s %d %d %d', [mDefaultLocation, 1, 1, 1]), hlDefault);
end;

procedure TMainForm.SatelliteButtonClick(Sender: TObject);
var
  P: TPoint;
begin
//  P.X := MainToolbar.Left + 15 * MainToolbar.Height + 5;
//  P.Y := MainToolbar.Top + MainToolbar.Height * 2 + 10;
//  P := ClientToScreen(P);
//SatelliteMenu.Popup(P.X, P.Y);
  ShowQNav(udParabibles);
end;

//function TMainForm.SatelliteMenuItemFromModuleName(aName: WideString):
//  TTntMenuItem;
//var
//  i, itemIx, itemCount: integer;
//begin
//  itemIx := -1;
//  itemCount := SatelliteMenu.Items.Count - 1;
//  for i := 0 to itemCount do
//  begin
//    if SatelliteMenu.Items[i].Caption = aName then
//    begin
//      itemIx := i;
//      break;
//    end;
//  end;
//  if itemIx >= 0 then
//    Result := TTntMenuItem(SatelliteMenu.Items[itemIx])
//  else
//    Result := nil;
//end;

procedure TMainForm.SelectSatelliteBibleByName(const bibleName: WideString);
var
  tabInfo: TViewTabInfo;
  ix: integer;
begin
  {  num := -1;//AlekId:исправлено было 0
    for i := 0 to SatelliteMenu.Items.Count - 1 do begin
      if SatelliteMenu.Items[i] = Sender then num := i - 1;
      SatelliteMenu.Items[i].Checked := false;
    end;
    satMenuItem:=TTntMenuItem( SatelliteMenu.Items[num + 1]);
    satMenuItem.Checked := true;}

  try
    tabInfo := GetActiveTabInfo();
    tabInfo.mSatelliteName := bibleName;
    if tabInfo.mBible.isBible then begin
      ProcessCommand(tabInfo.mwsLocation, TbqHLVerseOption(ord(tabInfo.mHLVerses)) {History[HistoryLB.ItemIndex]});
    end
    else begin try
        LoadSecondBookByName(bibleName);
      except on e: Exception do BqShowException(e); end;

    end;                                //else
    //перегрузить
    SatelliteButton.Down := bibleName <> '------';
  except

  end;
end;

procedure TMainForm.DicEditChange(Sender: TObject);
var
  i, newi, len, cnt, fromIx, r, fin: integer;
  name: WideString;
  nd: PVirtualNode;
begin
  if DicEdit.ItemIndex >= 0 then begin
    {DisplayDictionary(DicEdit.Items[DicEdit.ItemIndex]);}exit; end;
  len := Length(DicEdit.Text);

  if len > 0 then begin
    cnt := mDicList.Count;
    if cnt <= 0 then exit;
    name := DicEdit.Text;
    r := mDicList.LocateLastStartedWith(name);
//    fromIx:=0;
//    name:=DicEdit.Text;
//
//  i:=fromix + ((cnt-fromix)div 2);
//  fin:=cnt-1;
//  repeat
//  r:=OmegaCompareTxt(name, DicLB.Items[i],length(name));
//  if r=0 then break;
//  if r<0 then fin:=i else fromIx:=i;
//  newi:=(fromix+fin) div 2; if i=newi then break;
//  i:=newi;
//  until false;
//  if r<>0 then r:=-1
//  else begin
//    dec(i);
//    while (i>=0) and (OmegaCompareTxt(name, DicLB.Items[i],length(name))=0 ) do dec(i);
//    inc(i);
//    r:=i;
//  end;

    if r >= 0 then begin                //DicLB.ItemIndex:=r;
      nd := PVirtualNode(mDicList.Objects[r]);
      vstDicList.Selected[nd] := true;
      DicScrollNode(nd);
    end;

//    for i := 0 to DicLB.Items.Count - 1 do
//    begin
//      if WideLowerCase(Copy(DicLB.Items[i], 1, len))
//        = WideLowerCase(DicEdit.Text) then
//      begin
//        DicLB.ItemIndex := i;
//        //DicLBClick(Sender);
//        Exit;
//      end;
//    end;
  end;
  //DicLB.ItemIndex := 0;

end;

{ TrecMainViewTabInfo }

constructor TViewTabInfo.Create(const aHtmlViewer: THTMLViewer;
  const bible: TBible; const awsLocation: WideString; const satelliteBibleName:
  WideString; showStrongs, showNotes, resolveLinks: boolean);
begin
  Init(aHtmlViewer, bible, awsLocation, satelliteBibleName, showStrongs,
    showNotes, resolveLinks);

end;

procedure TViewTabInfo.Init(const aHtmlViewer: THTMLViewer;
  const bible: TBible; const awsLocation: WideString; const satelliteBibleName:
  WideString; showStrongs, showNotes, resolveLinks: boolean);
begin
  mHtmlViewer := aHtmlViewer;
  mBible := bible;
  mwsLocation := awsLocation;
  mSatelliteName := satelliteBibleName;
  mReloadNeeded := false;
  mShowStrongs := showStrongs;
  mShowNotes := showNotes;
  mResolvelinks := resolveLinks;
  mLastVisiblePara:=-1;
end;

{ TViewTabDragObject }

constructor TViewTabDragObject.Create(aViewTabInfo: TViewTabInfo);
begin
  inherited Create();
  mViewTabInfo := aViewTabInfo;
end;

{ TArchivedModules }

procedure TArchivedModules.Assign(source: TArchivedModules);
var
  cnt, i: integer;
begin
  inherited;
  cnt := Names.Count - 1;
  Clear();
  for i := 0 to cnt do begin
    Names.Add(source.Names[i]);
    Paths.Add(source.Paths[i]);
  end;
end;

procedure TArchivedModules.Clear();
begin
  Names.Clear();
  Paths.Clear();
end;

constructor TArchivedModules.Create;
begin
  Names := TWideStringList.Create();
  Paths := TWideStringList.Create();
end;

destructor TArchivedModules.Destroy;
begin
  Names.Free();
  Paths.Free();
  inherited;
end;

function TMainForm.RefBiblesCount: integer;
var i, cnt: integer;
  me: TModuleEntry;
begin
  cnt := mFavorites.mModuleEntries.Count - 1;
  result := 0;
  for i := 0 to cnt do if mFavorites.mModuleEntries[i].modType = modtypeBible then
      inc(result);
end;

procedure TMainForm.RefPopupMenuPopup(Sender: TObject);
begin
  if (MainPages.ActivePage = XRefTab) then begin
    miOpenNewView.Visible := true;
//  miOpenNewView.Visible := MainPages.ActivePage = XRefTab;
    G_XRefVerseCmd := Get_AHREF_VerseCommand(XRefBrowser.DocumentSource,
      XRefBrowser.SectionList.FindSourcePos(XRefBrowser.RightMouseClickPos));
  end
  else if (MainPages.ActivePage = SearchTab) then begin
    miOpenNewView.Visible := true;
    G_XRefVerseCmd := Get_AHREF_VerseCommand(SearchBrowser.DocumentSource,
      SearchBrowser.SectionList.FindSourcePos(SearchBrowser.RightMouseClickPos));
  end
  else if (MainPages.ActivePage = DicTab) then begin
    miOpenNewView.Visible := true;
    G_XRefVerseCmd := Get_AHREF_VerseCommand(DicBrowser.DocumentSource,
      DicBrowser.SectionList.FindSourcePos(DicBrowser.RightMouseClickPos));
  end
  else miOpenNewView.Visible := false;
end;

function TMainForm.ReplaceHotModule(const oldme, newMe: TModuleEntry): boolean;
var hotMi: TTntMenuItem;
  ix: integer;
begin
//favMi:=FindTaggedTopMenuItem(3333);
  result := true;
  hotMi := FavouriteItemFromModEntry(oldMe);
  if assigned(hotMi) then begin
    hotMi.Caption := newMe.wsFullName;
    hotMi.Tag := integer(newMe);
  end;
  ix := FavouriteTabFromModEntry(oldMe);
  if ix >= 0 then begin
    mBibleTabsEx.WideTabs[ix] := newMe.VisualSignature();
    mBibleTabsEx.WideTabs.Objects[ix] := newMe;
  end;

end;

{ TBQFavoriteModules }

function TBQFavoriteModules.AddModule(me: TModuleEntry): boolean;
var foundIx: integer;
  newMod: TModuleEntry;
begin
  result := false;
  foundIx := mModuleEntries.FindByFolder(me.wsShortPath);
  if foundIx >= 0 then exit;
  newMod := TModuleEntry.Create(me);
  foundIx := mModuleEntries.Add(newMod);
  mfnAddtoIface(newMod, integer(newMod), true);
  result := true;
end;

function TBQFavoriteModules.DeleteModule(me: TModuleEntry): boolean;
var foundIx: integer;
begin
  result := false;
  foundIx := mModuleEntries.IndexOf(me);
  if foundIx < 0 then exit;
  mfnDelFromIface(me);
  mModuleEntries.Delete(foundIx);
end;

function TBQFavoriteModules.Clear: boolean;
var i, c: integer;
begin
  c := mModuleEntries.Count - 1;
  try
    for i := 0 to c do mfnDelFromIface(TModuleEntry(
        mModuleEntries.Items[i]));
  except on e: exception do BqShowException(e) end;
  mModuleEntries.Clear();
end;

constructor TBQFavoriteModules.Create
  (fnAddToIface: TfnFavouriveAdd; fnDelFromIFace: TfnFavouriveDelete;
  fnReplaceInIface: TfnFavouriveReplace; fnInsertIface: TfnFavouriteInsert;
  forceLoadModules: TfnForceLoadModules);
begin
  mfnAddtoIface := fnAddToIface; mfnDelFromIface := fnDelFromIFace;
  mfnReplaceInIFace := fnReplaceInIface;
  mfnInsertIface := fnInsertIface;
  mModuleEntries := TCachedModules.Create(true);
  mfnForceLoadMods := forceLoadModules;
end;

destructor TBQFavoriteModules.Destroy;
begin
  try
    FreeAndNil(mModuleEntries);
  except on e: Exception do BqShowException(e); end;
  inherited;
end;

procedure TBQFavoriteModules.LoadModules(modEntries: TCachedModules; const modulePath: WideString);
var
  vrs: integer;
  doload: boolean;
begin
  if not Assigned(mLst) then begin
    mLst := TWideStringList.Create(); doload := true end
  else doload := false;
  try
    Clear();
    if doload then begin mExpectedCnt := 0; mLst.LoadFromFile(modulePath); end;
    if mLst.Count <= 0 then exit;
    vrs := ReadPrefix(mLst);
    if vrs = 2 then v2Load(modEntries, mLst)
    else begin
      v1Load(modEntries, mLst);
    end;

  except end;

end;

function TBQFavoriteModules.moveItem(me: TModuleEntry; ix: integer): boolean;
var si: integer;
begin
  result := false;
  try
    si := mModuleEntries.IndexOf(me);
    if si < 0 then exit;
    mModuleEntries.Move(si, ix);
//if ix>=si then Dec(ix);
//mModuleEntries.Items[si]:=nil;
//mModuleEntries.Delete(si);
//mModuleEntries.Insert(ix, me);

    mfnDelFromIface(me);
    mfnInsertIface(me, ix);
  except on e: Exception do BqShowException(e); end;
end;

function TBQFavoriteModules.ReadPrefix(const lst: TWideStringList): integer;
var ws: WideString;
begin
  ws := lst[0];
  if (ws <> 'v2.0') or (lst.Count < 2) then begin result := 0; mExpectedCnt := 0; end
  else begin
    mExpectedCnt := StrToIntDef(lst[1], 0);
    result := 2;
  end;
end;

function TBQFavoriteModules.ReplaceModule(oldMe, newMe: TModuleEntry): boolean;
var ix: integer;
begin
  ix := mModuleEntries.IndexOf(oldMe);
  if ix < 0 then begin result := false; exit end;
  mfnReplaceInIFace(oldMe, newMe);
  mModuleEntries.Items[ix] := newMe;
end;

procedure TBQFavoriteModules.SaveModules(const savePath: WideString);
var i, c: integer;
  me: TModuleEntry;
  lst: TWideStringList;
begin
  c := mModuleEntries.Count - 1;
  lst := TWideStringList.Create;
  try
    lst.Add('v2.0');
    lst.Add(IntToStr(c));

    for i := 0 to c do begin
      try

        me := TModuleEntry(mModuleEntries.Items[i]);
        lst.Add('***');
        lst.Add(me.wsFullName);
        lst.Add(me.wsShortName);
      except on e: Exception do BqShowException(e); end;

    end;
  except end;
  lst.SaveToFile(savePath);
  lst.Free();
end;

procedure TBQFavoriteModules.v1Load(modEntries: TCachedModules;
  const lst: TWideStringList);
var i, c: integer;
  wsModName, wsModShortName: WideString;
  fin: boolean;
  me: TModuleEntry;
begin
  c := lst.Count - 1;
  for i := 0 to c do begin
    me := modEntries.ResolveModuleByNames(lst[i], '');
    if not assigned(me) then begin
      WideShowMessageFmt('Can''t resolve favourite module:'#13#10' %s(%s)',
        [wsModName, wsModShortName]);
    end
    else AddModule(me);
  end;
end;

procedure TBQFavoriteModules.v2Load(modEntries: TCachedModules; const lst: TWideStringList);
var i, c, prevI: integer;
  wsModName, wsModShortName: WideString;
  fin: boolean;
  me: TModuleEntry;
  modsLoaded: boolean;
begin
  c := lst.Count - 1;
  i := 3;
  modsLoaded := false;
  while i <= c do begin
    fin := false;
    wsModName := lst[i];
    prevI := i;
    inc(i);
    if (i <= c) then begin wsModShortName := lst[i]; inc(i); end else wsModShortName := '';
    if wsModShortName = '***' then begin
      wsModShortName := ''; fin := true;
    end;
    me := modEntries.ResolveModuleByNames(wsModName, wsModShortName);
    if not assigned(me) then begin
      if not modsLoaded then begin
        mfnForceLoadMods(); i := prevI; modsLoaded := true; continue
      end
      else
        WideShowMessageFmt('Can''t resolve favourite module:'#13#10' %s(%s)',
          [wsModName, wsModShortName]);
    end
    else AddModule(me);

    if (i <= c) and (lst[i] <> '***') then
      repeat inc(i);
      until (i > c) or (lst[i] = '***');

    inc(i);
    if i > c then break;
  end;                                  //line iteration loop

end;

function TBQFavoriteModules.xChg(me1, me2: TModuleEntry): boolean;
begin
  mfnReplaceInIFace(me2, me1);
  mfnReplaceInIFace(me1, me2);

  mModuleEntries.Exchange(mModuleEntries.IndexOf(me1),
    mModuleEntries.IndexOf(me2));
end;

end.
//AlekId refactoring #0001:removed from processcommand
//replaced with  TBibleLink
(*    //стандартный переход
      DeleteFirstWord(dup);
    //читаем имя папки
      path := DeleteFirstWord(dup);

    //читаем номер книги
      value := DeleteFirstWord(dup);
      if value <> '' then
        book := StrToInt(value)
      else
        book := 1;

    //читаем номер главы
      value := DeleteFirstWord(dup);
      if value <> '' then
        chapter := StrToInt(value)
      else
        chapter := 1;
    //читаем номер начального стиха
      value := DeleteFirstWord(dup);
      if value <> '' then
        fromverse := StrToInt(value)
      else
        fromverse := 0;

    // читаем номер конечного стиха
      value := DeleteFirstWord(dup);
      if value <> '' then
        toverse := StrToInt(value)
      else
        toverse := 0;
      focusverse := fromverse;  *)

