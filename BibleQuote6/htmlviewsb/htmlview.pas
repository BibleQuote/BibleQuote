{
Version   10.2
Copyright (c) 1995-2008 by L. David Baldwin, 2008-2010 by HtmlViewer Team

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Note that the source modules HTMLGIF1.PAS and DITHERUNIT.PAS
are covered by separate copyright notices located in those modules.

********************************************************************************

Bernd Gabriel, 12.09.2010: reducing circular dependencies between the core units.

Before reducing circular dependencies this was the old unit hierarchy:

  Level 1) GDIPL2A, HtmlGif1, HtmlGlobals, UrlSubs, vwPrint
  Level 2) DitherUnit, HtmlGif2, MetaFilePrinter
  Level 3) HtmlSbs1, HtmlSubs, HtmlUn2, HtmlView, ReadHtml, StylePars, StyleUn
  Level 4) FramView
  Level 5) FramBrwz
  Level 6) FrameViewerReg, HtmlCompEdit

In Level 3 nearly all units were using each other.

After reducing circular dependencies this is the new unit hierarchy:

  Level 1) GDIPL2A, HtmlGif1, HtmlGlobals, UrlSubs, vwPrint
  Level 2) DitherUnit, HtmlGif2, MetaFilePrinter, StyleUn
  Level 3) StylePars
  Level 4) HtmlUn2
  Level 5) HtmlSbs1, HtmlSubs
  Level 6) HtmlView, ReadHtml
  Level 7) FramView
  Level 8) FramBrwz
  Level 9) FrameViewerReg, HtmlCompEdit
  
Only two mutually usages remain: HtmlSbs1/HtmlSubs and HtmlView/ReadHtml.
These will be removed later.
}

{$I htmlcons.inc}

unit Htmlview;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, StdCtrls, ExtCtrls,
{$ifdef LCL}
  Interfaces,
  LMessages,
{$endif}
  UrlSubs,
  MetafilePrinter,
  vwPrint,
  HtmlGlobals,
  HTMLUn2,
  ReadHTML,
  HTMLSubs,
  StyleUn,HTMLEmbedInterfaces;
const
  wm_FormSubmit = wm_User + 100;
  wm_MouseScroll = wm_User + 102;
  wm_UrlAction = wm_User + 103;

type
  THTMLViewer = class;

  THTMLBorderStyle = (htFocused, htNone, htSingle);
  TRightClickParameters = class(TObject)
    URL, Target: string;
    Image: TImageObj;
    ImageX, ImageY: Integer;
    ClickWord: WideString;
  end;
  TRightClickEvent = procedure(Sender: TObject; Parameters: TRightClickParameters) of object;
  THotSpotEvent = procedure(Sender: TObject; const SRC: string) of object;
  THotSpotClickEvent = procedure(Sender: TObject; const SRC: string; var Handled: boolean) of object;
  TProcessingEvent = procedure(Sender: TObject; ProcessingOn: boolean) of object;
  TPagePrinted = procedure(Sender: TObject; Canvas: TCanvas; NumPage, W, H: Integer; var StopPrinting: Boolean) of object;
  ThtmlPagePrinted = procedure(Sender: TObject; HFViewer: ThtmlViewer; NumPage: Integer; LastPage: boolean; var XL, XR: Integer; var StopPrinting: Boolean) of object;
  TImageClickEvent = procedure(Sender, Obj: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TImageOverEvent = procedure(Sender, Obj: TObject; Shift: TShiftState; X, Y: Integer) of object;
  TMetaRefreshType = procedure(Sender: TObject; Delay: Integer; const URL: string) of object;
  TParseEvent = procedure(Sender: TObject; var Source: string) of object;
  TFilenameExpanded = procedure(Sender: TObject; var Filename: string) of object;

  THtmlViewerOption = (
    htOverLinksActive, htNoLinkUnderline, htPrintTableBackground,
    htPrintBackground, htPrintMonochromeBlack, htShowDummyCaret,
    htShowVScroll, htNoWheelMouse, htNoLinkHilite,
    htNoFocusRect //MK20091107
    );
  THtmlViewerOptions = set of THtmlViewerOption;
  ThtProgressEvent = procedure(Sender: TObject; Stage: TProgressStage; PercentDone: Integer) of object;

  THTMLViewPrinted = TNotifyEvent;
  THTMLViewPrinting = procedure(Sender: TObject; var StopPrinting: Boolean) of object;

  TPaintPanel = class(TCustomPanel)
  PRIVATE
    FOnPaint: TNotifyEvent;
    FViewer: ThtmlViewer;
    Canvas2: TCanvas;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); MESSAGE WM_EraseBkgnd;
    procedure WMLButtonDblClk(var Message: TWMMouse); MESSAGE WM_LButtonDblClk;
    procedure DoBackground(ACanvas: TCanvas);
    {AlekId}
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    {/AlekId}
    property OnPaint: TNotifyEvent READ FOnPaint WRITE FOnPaint;
  PUBLIC
    constructor CreateIt(AOwner: TComponent; Viewer: THtmlViewer);
    procedure Paint; OVERRIDE;
  end;

//  T32ScrollBar = class(TScrollBar) {a 32 bit scrollbar}
//  private
//    FPosition: Integer;
//    FMin, FMax, FPage: Integer;
//    procedure SetPosition(Value: Integer);
//    procedure SetMin(Value: Integer);
//    procedure SetMax(Value: Integer);
//{$ifdef LCL}
//    procedure CNVScroll(var Message: TLMVScroll); message LM_VSCROLL;
//{$else}
//    procedure CNVScroll(var Message: TWMVScroll); message CN_VSCROLL;
//{$endif}
//  public
//    property Position: Integer read FPosition write SetPosition;
//    property Min: Integer read FMin write SetMin;
//    property Max: Integer read FMax write SetMax;
//    procedure SetParams(APosition, APage, AMin, AMax: Integer);
//  end;

  ThtmlFileType = (HTMLType, TextType, ImgType, OtherType);

  THtmlViewerStateBit = (
    vsBGFixed,
    vsDontDraw,
    vsCreating,
    vsProcessing,
    vsLocalBitmapList,
    vsHotSpotAction,
    vsMouseScrolling,
    vsLeftButtonDown,
    vsMiddleScrollOn,
    vsHiliting);
  THtmlViewerState = set of THtmlViewerStateBit;

  THTMLViewer = class(THtmlViewerBase{AlekId}{/AlekId})
  PRIVATE
    FViewerState: THtmlViewerState;
    FBackGround: TColor;
    FBase: string;
    FBaseEx: string;
    FBaseTarget: String;
    FBorderStyle: THTMLBorderStyle;
    FCaretPos: Integer;
    FCharset: TFontCharset; {see htmlun2.pas for Delphi 2 TFontCharSet definition}
    FCodePage: Integer;
    FCurrentFile: String;
    FCurrentFileType: ThtmlFileType;
    FDocumentSource: string;
    FFontColor: TColor;
    FFontName: TFontName;
    FFontSize: Integer;
    FHistory, FTitleHistory: TStrings;
    FHistoryIndex: Integer;
    FHistoryMaxCount: Integer;
    FHotSpotColor, FVisitedColor, FOverColor: TColor;
    FImageCacheCount: Integer;
    FImageStream: TMemoryStream;
    FLinkAttributes: TStringList;
    FLinkStart: TPoint;
    FLinkText: WideString;
    FMarginHeight, FMarginWidth: Integer;
    FMaxVertical: Integer;
    FNameList: TStringList;
    FNoSelect: Boolean;
    FOnDragDrop: TDragDropEvent;
    FOnDragOver: TDragOverEvent;
    FOnFilenameExpanded: TFilenameExpanded; //BG, 19.09.2010: Issue 7: Slow UNC Lookups for Images
    FOnFormSubmit: TFormSubmitEvent;
    FOnHistoryChange: TNotifyEvent;
    FOnHotSpotClick: THotSpotClickEvent;
    FOnHotSpotCovered: THotSpotEvent;
    FOnhtStreamRequest: TGetStreamEvent;
    FOnImageClick: TImageClickEvent;
    FOnImageOver: TImageOverEvent;
    FOnInclude: TIncludeType;
    FOnLink: TLinkType;
    FOnLinkDrawn: TLinkDrawnEvent;
    FOnMeta: TMetaType;
    FOnMetaRefresh: TMetaRefreshType;
    FOnMouseDouble: TMouseEvent;
    FOnObjectTag: TObjectTagEvent;
    FOnPageEvent: TPageEvent;
    FOnParseBegin: TParseEvent;
    FOnParseEnd: TNotifyEvent;
    FOnPrinted: THTMLViewPrinted;
    FOnPrintHeader, FOnPrintFooter: TPagePrinted;
    FOnPrintHTMLHeader, FOnPrintHTMLFooter: ThtmlPagePrinted;
    FOnPrinting: THTMLViewPrinting;
    FOnProcessing: TProcessingEvent;
    FOnProgress: ThtProgressEvent;
    FOnRightClick: TRightClickEvent;
    FOnSoundRequest: TSoundType;
    FOptions: THtmlViewerOptions;
    FPage: Integer;
    FPositionHistory: TFreeList;
    FPreFontName: String;
    FPrintedSize: TPoint;
    FPrintMarginBottom: double;
    FPrintMarginLeft: Double;
    FPrintMarginRight: Double;
    FPrintMarginTop: Double;
    FPrintScale: Double;
    FRefreshDelay: Integer;
    FRefreshURL: string;
    FScaleX, FScaleY: single;
    FScrollBars: TScrollStyle;
    FSectionList: TSectionList;
    FServerRoot: string;
    FTarget: string;
    FTitle: string;
    FTitleAttr: string;
    FURL: string;
    FVisitedMaxCount: Integer;
    FWidthRatio: double;

    // Added by vvd
    // Correct LoadFromString (WideString, ...) support.

    FIsUtf16Source: Boolean;
    FDocumentSourceUtf16: WideString;

    // End of Added by vvd
    HTMLTimer: TTimer;
    MiddleY: Integer;
    NoJump: Boolean;
    sbWidth: Integer;
    vwP, OldPrinter: TvwPrinter;
// child components
    BorderPanel: TPanel;
    PaintPanel: TPaintPanel;
//
    Sel1: Integer;
// These fields are set in SubmitForm and read in WMFormSubmit
    FAction, FFormTarget, FEncType, FMethod: string;
    FStringList: ThtStringList;
//
    {ALekId}
     FRightMouseClickPos: Integer;
    // timothy  Longint
    {AlekId}
    FLeftMouseClickPos:integer;
    {/AlekId}


    procedure CMHintShow(var Message: TMessage); MESSAGE CM_HINTSHOW;
//    procedure AcceptClick(Sender: TObject; X, Y: Integer);//AlekId:hint
    {AlekId}
    function CreateHeaderFooter: ThtmlViewer;
    function GetBase: string;
    function GetBaseTarget: string;
    function GetCurrentFile: string;
    function GetCursor: TCursor;
    function GetDragDrop: TDragDropEvent;
    function GetDragOver: TDragOverEvent;
    function GetFormControlList: TList;
    function GetFormData: TFreeList;
    function GetHScrollBarRange: Integer;
    function GetHScrollPos: Integer;
    function GetIDControl(const ID: string): TObject;
    function GetIDDisplay(const ID: string): TPropDisplay;

    function GetNameList: TStringList;
    function GetOnBitmapRequest: TGetBitmapEvent;
    function GetOnExpandName: TExpandNameEvent;
    function GetOnFileBrowse: TFileBrowseEvent;
    function GetOnImageRequest: TGetImageEvent;
    function GetOnImageRequested: TGottenImageEvent;
    function GetOnObjectBlur: ThtObjectEvent;
    function GetOnObjectChange: ThtObjectEvent;
    function GetOnObjectClick: TObjectClickEvent;
    function GetOnObjectFocus: ThtObjectEvent;
    function GetOnPanelCreate: TPanelCreateEvent;
    function GetOnPanelDestroy: TPanelDestroyEvent;
    function GetOnPanelPrint: TPanelPrintEvent;
    function GetOnScript: TScriptEvent;
    function GetOurPalette: HPalette;
    function GetPosition: Integer;
    function GetPreFontName: TFontName;
    function GetScrollBarRange: Integer;
    function GetScrollPos: Integer;
    function GetSelLength: Integer;
    function GetSelText: WideString;
    function GetTitle: string;
    //function GetViewerStateBit(Index: THtmlViewerStateBit): Boolean;
    function GetViewImages: Boolean;
    function GetWordAtCursor(X, Y: Integer; var St, En: Integer; var AWord: WideString): Boolean;
    procedure BackgroundChange(Sender: TObject);
    procedure DoHilite(X, Y: Integer); VIRTUAL;
    procedure DoImage(Sender: TObject; const SRC: string; var Stream: TMemoryStream);

    procedure DoScrollBars;
    procedure Draw(Canvas: TCanvas; YTop, FormatWidth, Width, Height: Integer);
    procedure DrawBorder;
    procedure FormControlEnterEvent(Sender: TObject);
    procedure HandleMeta(Sender: TObject; const HttpEq, Name, Content: string);
    procedure HTMLDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure HTMLDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure HTMLTimerTimer(Sender: TObject);
    procedure InitLoad;
    procedure Layout;
    procedure ScrollHorz(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure ScrollTo(Y: Integer);
    procedure ScrollVert(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure SetActiveColor(Value: TColor);
    procedure SetBase(Value: string);
    procedure SetBorderStyle(Value: THTMLBorderStyle);
    procedure SetCaretPos(Value: Integer);
    procedure SetCharset(Value: TFontCharset);
    procedure SetDefBackground(Value: TColor);
    procedure SetDragDrop(const Value: TDragDropEvent);
    procedure SetDragOver(const Value: TDragOverEvent);
    procedure SetFontSize(Value: Integer);
    procedure SetFormData(T: TFreeList);
    procedure SetHistoryIndex(Value: Integer);
    procedure SetHistoryMaxCount(Value: Integer);
    procedure SetHotSpotColor(Value: TColor);
    procedure SetHScrollPos(Value: Integer);
    procedure SetIDDisplay(const ID: string; Value: TPropDisplay);
    procedure SetImageCacheCount(Value: Integer);
    procedure SetNoSelect(Value: Boolean);
    procedure SetOnBitmapRequest(Handler: TGetBitmapEvent);
    procedure SetOnExpandName(Handler: TExpandNameEvent);
    procedure SetOnFileBrowse(Handler: TFileBrowseEvent);
    procedure SetOnFormSubmit(Handler: TFormSubmitEvent);
    procedure SetOnImageRequest(Handler: TGetImageEvent);
    procedure SetOnImageRequested(Handler: TGottenImageEvent);
    procedure SetOnObjectBlur(Handler: ThtObjectEvent);
    procedure SetOnObjectChange(Handler: ThtObjectEvent);
    procedure SetOnObjectClick(Handler: TObjectClickEvent);
    procedure SetOnObjectFocus(Handler: ThtObjectEvent);
    procedure SetOnPanelCreate(Handler: TPanelCreateEvent);
    procedure SetOnPanelDestroy(Handler: TPanelDestroyEvent);
    procedure SetOnPanelPrint(Handler: TPanelPrintEvent);
    procedure SetOptions(Value: THtmlViewerOptions);
    procedure SetOurPalette(Value: HPalette);
    procedure SetPosition(Value: Integer);
    procedure SetPreFontName(Value: TFontName);
    procedure SetPrintScale(Value: double);
    procedure SetProcessing(Value: Boolean);
    procedure SetScrollBars(Value: TScrollStyle);
    procedure SetScrollPos(Value: Integer);
    procedure SetSelLength(Value: Integer);
    procedure SetSelStart(Value: Integer);
    procedure SetServerRoot(Value: string);
    procedure SetupAndLogic;
    procedure SetViewerStateBit(Index: THtmlViewerStateBit; Value: Boolean);
    procedure SetViewImages(Value: Boolean);
    procedure SetVisitedColor(Value: TColor);
    procedure SetVisitedMaxCount(Value: Integer);
    procedure SubmitForm(Sender: IHtmlViewerBase; const Action, Target, EncType, Method: string; Results: ThtStringList);
    procedure UpdateImageCache;
    procedure WMFormSubmit(var Message: TMessage); MESSAGE WM_FormSubmit;
    procedure WMGetDlgCode(var Message: TMessage); MESSAGE WM_GETDLGCODE;
    procedure WMMouseScroll(var Message: TMessage); MESSAGE WM_MouseScroll;
    procedure WMSize(var Message: TWMSize); MESSAGE WM_SIZE;
    procedure WMUrlAction(var Message: TMessage); MESSAGE WM_UrlAction;
  PROTECTED
    ScrollWidth: Integer;
{AlekId}
    SellNeedAdjust: boolean;
{/AlekId}
    function GetPalette: HPALETTE; OVERRIDE;
    function HotSpotClickHandled: Boolean; DYNAMIC;
    procedure DoBackground1(ACanvas: TCanvas; ATop, AWidth, AHeight, FullHeight: Integer);
    procedure DoBackground2(ACanvas: TCanvas; ALeft, ATop, AWidth, AHeight: Integer; AColor: TColor);
    procedure DrawBackground2(ACanvas: TCanvas; ARect: TRect; XStart, YStart, XLast, YLast: Integer; Image: TGpObject; Mask: TBitmap; BW, BH: Integer; BGColor: TColor);
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; OVERRIDE;
    procedure HTMLMouseDblClk(Message: TWMMouse);
    procedure HTMLMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); VIRTUAL;
    procedure HTMLMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); VIRTUAL;
    procedure HTMLMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); VIRTUAL;
    procedure HTMLMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint);
    procedure HTMLPaint(Sender: TObject); VIRTUAL;
    procedure LoadFile(const FileName: string; ft: ThtmlFileType); VIRTUAL;
    procedure LoadString(const Source, Reference: string; ft: ThtmlFileType);
    procedure PaintWindow(DC: HDC); OVERRIDE;
    procedure SetCursor(Value: TCursor); {$ifdef LCL} OVERRIDE; {$endif LCL}
    procedure SetOnScript(Handler: TScriptEvent); OVERRIDE;


  PUBLIC
    FrameOwner: TObject;
    HScrollBar: TScrollBar;
    Visited: TStringList;     {visited URLs}
    VScrollBar: TScrollBar;
    {alekid}
    procedure DoLogic;
    function getMarginHeight():integer;override;
    function getMarginWidth():integer;override;
    procedure __SetFileName(const fn:Utf8String);
    {/Alekid}

    constructor Create(AOwner: TComponent); OVERRIDE;
    destructor Destroy; OVERRIDE;
    function GetLinkList: TList;override;
    function DisplayPosToXy(DisplayPos: Integer; var X, Y: Integer): Boolean;
    function Find(const S: WideString; MatchCase: boolean): boolean;
    function FindDisplayPos(SourcePos: Integer; Prev: Boolean): Integer;
    function FindEx(const S: WideString; MatchCase, Reverse: boolean): boolean;
    function PositionTo(Dest: string{AlekId}; vcenter: boolean = FALSE{/AlekID}): boolean;
    function FindSourcePos(DisplayPos: Integer; vvdfix: boolean = FALSE): Integer;
    function FullDisplaySize(FormatWidth: Integer): TSize;
    function GetCharAtPos(Pos: Integer; var Ch: WideChar; var Font: TFont): Boolean;
    function GetSelTextBuf(Buffer: PWideChar; BufSize: Integer): Integer;
    function GetTextByIndices(AStart, ALast: Integer): WideString;
    function GetURL(X, Y: Integer; var UrlTarg: TUrlTarget; var FormControl: TIDObject {TImageFormControlObj}; var ATitle: string): guResultType;
    function HtmlExpandFilename(const Filename: string): string; OVERRIDE;
    function InsertImage(const Src: string; Stream: TMemoryStream): boolean;
    function MakeBitmap(YTop, FormatWidth, Width, Height: Integer): TBitmap;
{$ifndef FPC_TODO_PRINTING}
    function MakeMetaFile(YTop, FormatWidth, Width, Height: Integer): TMetaFile;
    function MakePagedMetaFiles(Width, Height: Integer): TList;
{$endif}
    function NumPrinterPages(out WidthRatio: Double): Integer; OVERLOAD;
    function NumPrinterPages: Integer; OVERLOAD;
//    function PositionTo(Dest: string): Boolean;
    function PrintPreview(MFPrinter: TMetaFilePrinter; NoOutput: Boolean = FALSE): Integer; VIRTUAL;
    function PtInObject(X, Y: Integer; var Obj: TObject): boolean;  {X, Y, are client coord}
    function ShowFocusRect: Boolean; OVERRIDE;
    function XYToDisplayPos(X, Y: Integer): Integer;
    procedure AbortPrint;
    procedure AddVisitedLink(const S: string);
    procedure BumpHistory(const FileName, Title: string; OldPos: Integer; OldFormData: TFreeList; ft: ThtmlFileType);
    procedure CheckVisitedLinks;
    procedure Clear; VIRTUAL;
    procedure ClearHistory;
    procedure ClosePrint;
    procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); OVERRIDE;
    procedure CopyToClipboard;
    procedure DoEnter; OVERRIDE;
    procedure DoExit; OVERRIDE;
    procedure htProgress(Percent: Integer); OVERRIDE;
    procedure htProgressEnd;
    procedure htProgressInit;
    procedure KeyDown(var Key: Word; Shift: TShiftState); OVERRIDE;
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromString(const S: AnsiString; const Reference: string = ''); OVERLOAD;
    procedure LoadFromString(const S: WideString; const Reference: string = ''); OVERLOAD;
    procedure LoadFromBuffer(Buffer: PChar; BufLenTChars: Integer; const Reference: string = '');
    procedure LoadFromStream(const AStream: TStream; const Reference: string = '');
    procedure LoadStrings(const Strings: TStrings; const Reference: string = '');
    procedure LoadImageFile(const FileName: string);
    procedure LoadStream(const URL: string; AStream: TMemoryStream; ft: ThtmlFileType);
    procedure LoadTextFile(const FileName: string);
    procedure LoadTextFromString(const S: string);
    procedure LoadTextStrings(Strings: TStrings);
    procedure NumPrinterPages(MFPrinter: TMetaFilePrinter; out Width, Height: Integer); OVERLOAD;
    procedure OpenPrint;
    procedure Print(FromPage, ToPage: Integer);
    procedure Reformat;
    procedure Reload;
    procedure Repaint; OVERRIDE;
    procedure ReplaceImage(const NameID: string; NewImage: TStream);
    procedure SelectAll;
    procedure SetStringBitmapList(BitmapList: TStringBitmapList);
    procedure TriggerUrlAction;
    procedure UrlAction;

    property Base: string READ GetBase WRITE SetBase;
    property BaseTarget: string READ GetBaseTarget;
    property CaretPos: Integer READ FCaretPos WRITE SetCaretPos;
    property CodePage: Integer READ FCodePage WRITE FCodePage;
    property CurrentFile: string READ GetCurrentFile;
    property DocumentSource: string READ FDocumentSource;
    property DocumentTitle: string READ GetTitle;
    property FormControlList: TList READ GetFormControlList;
    property FormData: TFreeList READ GetFormData WRITE SetFormData;
    property History: TStrings READ FHistory;
    property HistoryIndex: Integer READ FHistoryIndex WRITE SetHistoryIndex;
    property HScrollBarPosition: Integer READ GetHScrollPos WRITE SetHScrollPos;
    property HScrollBarRange: Integer READ GetHScrollBarRange;
    property IDControl[const ID: string]: TObject READ GetIDControl;
    property IDDisplay[const ID: string]: TPropDisplay READ GetIDDisplay WRITE SetIDDisplay;
    property LinkAttributes: TStringList READ FLinkAttributes;
    property LinkList: TList READ GetLinkList;
    property LinkStart: TPoint READ FLinkStart;
    property LinkText: WideString READ FLinkText WRITE FLinkText;
    property MaxVertical: Integer READ FMaxVertical;
    property NameList: TStringList READ GetNameList;
    property OnExpandName: TExpandNameEvent READ GetOnExpandName WRITE SetOnExpandName;
    property OnLinkDrawn: TLinkDrawnEvent READ FOnLinkDrawn WRITE FOnLinkDrawn;
    property OnPageEvent: TPageEvent READ FOnPageEvent WRITE FOnPageEvent;
    property Palette: HPalette READ GetOurPalette WRITE SetOurPalette;
    property Position: Integer READ GetPosition WRITE SetPosition;
    //property Processing: Boolean index vsProcessing read GetViewerStateBit;
    property SectionList: TSectionList READ FSectionList;
    // added by Timothy
    property RightMouseClickPos: Integer READ FRightMouseClickPos write FRightMouseClickPos;
    property LeftMouseClickPos: Integer READ FLeftMouseClickPos;
    property NoScollJump: boolean READ NoJump WRITE NoJump;
	//
    property SelLength: Integer READ GetSelLength WRITE SetSelLength;
    property SelStart: Integer READ FCaretPos WRITE SetSelStart;
    property SelText: WideString READ GetSelText;
    property Target: string READ FTarget WRITE FTarget;
    // Added by vvd
    property DocumentSourceUtf16: WideString READ FDocumentSourceUtf16;
    property IsUtf16Source: Boolean READ FIsUtf16Source;
    // End fo Added by vvd
    property __PaintPanel:TPaintPanel read PaintPanel;
    property TitleAttr: string READ FTitleAttr;
    property TitleHistory: TStrings READ FTitleHistory;
    property URL: string READ FURL WRITE FURL;
    property ViewerState: THtmlViewerState READ FViewerState;
    property VScrollBarPosition: Integer READ GetScrollPos WRITE SetScrollPos;
    property VScrollBarRange: Integer READ GetScrollBarRange;
  PUBLISHED
    property Enabled;
    property TabStop;
    property TabOrder;
    property Align;
    property Name;
    property Tag;
    property PopupMenu;
    property ShowHint;
    property Anchors;
    property Height DEFAULT 150;
    property Width DEFAULT 150;
    property Visible;
    property BorderStyle: THTMLBorderStyle READ FBorderStyle WRITE SetBorderStyle;
    property CharSet: TFontCharset READ FCharSet WRITE SetCharset;
    property DefBackground: TColor READ FBackground WRITE SetDefBackground DEFAULT clBtnFace;
    property DefFontColor: TColor READ FFontColor WRITE FFontColor DEFAULT clBtnText;
    property DefFontName: TFontName READ FFontName WRITE FFontName;
    property DefFontSize: Integer READ FFontSize WRITE SetFontSize DEFAULT 12;
    property DefHotSpotColor: TColor READ FHotSpotColor WRITE SetHotSpotColor DEFAULT clBlue;
    property DefOverLinkColor: TColor READ FOverColor WRITE SetActiveColor DEFAULT clBlue;
    property DefPreFontName: TFontName READ GetPreFontName WRITE SetPreFontName;
    property DefVisitedLinkColor: TColor READ FVisitedColor WRITE SetVisitedColor DEFAULT clPurple;
    property HistoryMaxCount: Integer READ FHistoryMaxCount WRITE SetHistoryMaxCount;
    property HtOptions: THtmlViewerOptions READ FOptions WRITE SetOptions
      DEFAULT [htPrintTableBackground, htPrintMonochromeBlack];
    property ImageCacheCount: Integer READ FImageCacheCount WRITE SetImageCacheCount DEFAULT 5;
    property MarginHeight: Integer READ FMarginHeight WRITE FMarginHeight DEFAULT 5;
    property MarginWidth: Integer READ FMarginWidth WRITE FMarginWidth DEFAULT 10;
    property NoSelect: Boolean READ FNoSelect WRITE SetNoSelect;
    property PrintMarginBottom: Double READ FPrintMarginBottom WRITE FPrintMarginBottom;
    property PrintMarginLeft: double READ FPrintMarginLeft WRITE FPrintMarginLeft;
    property PrintMarginRight: double READ FPrintMarginRight WRITE FPrintMarginRight;
    property PrintMarginTop: double READ FPrintMarginTop WRITE FPrintMarginTop;
    property PrintScale: double READ FPrintScale WRITE SetPrintScale;
    property ScrollBars: TScrollStyle READ FScrollBars WRITE SetScrollBars DEFAULT ssBoth;
    property ServerRoot: string READ FServerRoot WRITE SetServerRoot;
    property ViewImages: Boolean READ GetViewImages WRITE SetViewImages DEFAULT TRUE;
    property VisitedMaxCount: Integer READ FVisitedMaxCount WRITE SetVisitedMaxCount DEFAULT 50;

    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseDown;
    property OnMouseWheel;
    property OnBitmapRequest: TGetBitmapEvent READ GetOnBitmapRequest WRITE SetOnBitmapRequest;
    property OnDragDrop: TDragDropEvent READ GetDragDrop WRITE SetDragDrop;
    property OnDragOver: TDragOverEvent READ GetDragOver WRITE SetDragOver;
    property OnFileBrowse: TFileBrowseEvent READ GetOnFileBrowse WRITE SetOnFileBrowse;
    property OnFilenameExpanded: TFilenameExpanded READ FOnFilenameExpanded WRITE FOnFilenameExpanded;
    property OnFormSubmit: TFormSubmitEvent READ FOnFormSubmit WRITE SetOnFormSubmit;
    property OnHistoryChange: TNotifyEvent READ FOnHistoryChange WRITE FOnHistoryChange;
    property OnHotSpotClick: THotSpotClickEvent READ FOnHotSpotClick WRITE FOnHotSpotClick;
    property OnHotSpotCovered: THotSpotEvent READ FOnHotSpotCovered WRITE FOnHotSpotCovered;
    property OnhtStreamRequest: TGetStreamEvent READ FOnhtStreamRequest WRITE FOnhtStreamRequest;
    property OnImageClick: TImageClickEvent READ FOnImageClick WRITE FOnImageClick;
    property OnImageOver: TImageOverEvent READ FOnImageOver WRITE FOnImageOver;
    property OnImageRequest: TGetImageEvent READ GetOnImageRequest WRITE SetOnImageRequest;
    property OnImageRequested: TGottenImageEvent READ GetOnImageRequested WRITE SetOnImageRequested;
    property OnInclude: TIncludeType READ FOnInclude WRITE FOnInclude;
    property OnLink: TLinkType READ FOnLink WRITE FOnLink;
    property OnMeta: TMetaType READ FOnMeta WRITE FOnMeta;
    property OnMetaRefresh: TMetaRefreshType READ FOnMetaRefresh WRITE FOnMetaRefresh;
    property OnMouseDouble: TMouseEvent READ FOnMouseDouble WRITE FOnMouseDouble;
    property OnObjectBlur: ThtObjectEvent READ GetOnObjectBlur WRITE SetOnObjectBlur;
    property OnObjectChange: ThtObjectEvent READ GetOnObjectChange WRITE SetOnObjectChange;
    property OnObjectClick: TObjectClickEvent READ GetOnObjectClick WRITE SetOnObjectClick;
    property OnObjectFocus: ThtObjectEvent READ GetOnObjectFocus WRITE SetOnObjectFocus;
    property OnObjectTag: TObjectTagEvent READ FOnObjectTag WRITE FOnObjectTag;
    property OnPanelCreate: TPanelCreateEvent READ GetOnPanelCreate WRITE SetOnPanelCreate;
    property OnPanelDestroy: TPanelDestroyEvent READ GetOnPanelDestroy WRITE SetOnPanelDestroy;
    property OnPanelPrint: TPanelPrintEvent READ GetOnPanelPrint WRITE SetOnPanelPrint;
    property OnParseBegin: TParseEvent READ FOnParseBegin WRITE FOnParseBegin;
    property OnParseEnd: TNotifyEvent READ FOnParseEnd WRITE FOnParseEnd;
    property OnPrinted: THTMLViewPrinted READ FOnPrinted WRITE FOnPrinted;
    property OnPrintFooter: TPagePrinted READ FOnPrintFooter WRITE FOnPrintFooter;
    property OnPrintHeader: TPagePrinted READ FOnPrintHeader WRITE FOnPrintHeader;
    property OnPrintHTMLFooter: ThtmlPagePrinted READ FOnPrintHTMLFooter WRITE FOnPrintHTMLFooter;
    property OnPrintHTMLHeader: ThtmlPagePrinted READ FOnPrintHTMLHeader WRITE FOnPrintHTMLHeader;
    property OnPrinting: THTMLViewPrinting READ FOnPrinting WRITE FOnPrinting;
    property OnProcessing: TProcessingEvent READ FOnProcessing WRITE FOnProcessing;
    property OnProgress: ThtProgressEvent READ FOnProgress WRITE FOnProgress;
    property OnRightClick: TRightClickEvent READ FOnRightClick WRITE FOnRightClick;
    property OnScript: TScriptEvent READ GetOnScript WRITE SetOnScript;
    property OnSoundRequest: TSoundType READ FOnSoundRequest WRITE FOnSoundRequest;
{$ifdef LCL}
    property Cursor DEFAULT crIBeam;
{$else}
    property Cursor: TCursor READ GetCursor WRITE SetCursor DEFAULT crIBeam;
{$endif}
  end;

function IsHtmlExt(const Ext: string): Boolean;
function IsImageExt(const Ext: string): Boolean;
function IsTextExt(const Ext: string): Boolean;
function getFileType(const S: string): THtmlFileType;

implementation

uses
  SysUtils, Math, Clipbrd, Forms, Printers, {$IFDEF UNICODE}AnsiStrings, {$ENDIF}
  htmlgif2 {$IFNDEF NoGDIPlus}, GDIPL2A{$ENDIF};
const
  ScrollGap = 20;

type
  PositionObj = class(TObject)
    Pos: Integer;
    FileType: ThtmlFileType;
    FormData: TFreeList;
    destructor Destroy; OVERRIDE;
  end;

//-- BG ---------------------------------------------------------- 23.09.2010 --
function IsHtmlExt(const Ext: string): Boolean;
begin
  Result := (Ext = '.html') or (Ext = '.css') or (Ext = '.htm') or (Ext = '.php');
end;

//-- BG ---------------------------------------------------------- 23.09.2010 --
function IsImageExt(const Ext: string): Boolean;
begin
  Result := (Ext = '.gif') or (Ext = '.jpg') or (Ext = '.jpeg') or (Ext = '.png') or (Ext = '.bmp');
end;

//-- BG ---------------------------------------------------------- 23.09.2010 --
function IsTextExt(const Ext: string): Boolean;
begin
  Result := (Ext = '.txt');
end;

//-- BG ---------------------------------------------------------- 23.09.2010 --
function getFileType(const S: string): THtmlFileType;
var
  Ext: string;
begin
  Ext := LowerCase(ExtractFileExt(S));
  if IsHtmlExt(Ext) then
    Result := HTMLType
  else
  if IsImageExt(Ext) then
    Result := ImgType
  else
  if IsTextExt(Ext) then
    Result := TextType
  else
    Result := OtherType;
end;
// Added by vvd

function GetPos_UnicodeToUtf8(aSource: PWideChar; aSourcePos: Integer): Integer;
var
  i: Integer;
  c: Cardinal;
begin
  Result := 0;
  if aSource = NIL then
    Exit;
  if aSourcePos <= 0 then
    Exit;

  i := 0;

  while i < aSourcePos do
  begin
    c := Integer(aSource[i]);
    Inc(i);
    if c > $7F then
    begin
      if c > $7FF then
        Inc(Result);
      Inc(Result);
    end;
    Inc(Result);
  end;

end;

function GetPos_Utf8ToUnicode(aSource: PChar; aSourcePos: Integer): Integer;
var
  i: Integer;
  c: Byte;
begin
  Result := 0;
  if aSource = NIL then
    Exit;

  i := 0;

  while (i < aSourcePos) do
  begin
    c := Byte(aSource[i]);
    Inc(i);
    Inc(Result);

    if (c and $80) <> 0 then
    begin
      if i >= aSourcePos then
        Exit;          // incomplete multibyte char

      c := c and $3F;
      if (c and $20) <> 0 then
      begin
        c := Byte(aSource[i]);
        Inc(i);
        if (c and $C0) <> $80 then
          Exit;      // malformed trail byte or out of range char
        if i >= aSourcePos then
          Exit;        // incomplete multibyte char

      end;

      c := Byte(aSource[i]);
      Inc(i);
      if (c and $C0) <> $80 then
        Exit;       // malformed trail byte

    end;

  end;

end;
// End of Added by vvd

constructor THTMLViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents, csSetCaption, csDoubleClicks];
  Include(FViewerState, vsCreating);
  Height := 150;
  Width := 150;
  SetCursor(crIBeam);
  FPrintMarginLeft := 2.0;
  FPrintMarginRight := 2.0;
  FPrintMarginTop := 2.0;
  FPrintMarginBottom := 2.0;
  FPrintScale := 1.0;
  FCharset := DEFAULT_CHARSET;
  FMarginHeight := 5;
  FMarginWidth := 10;

  BorderPanel := TPanel.Create(Self);
  BorderPanel.BevelInner := bvNone;
  BorderPanel.BevelOuter := bvNone;
  BorderPanel.Align := alClient;
{$ifndef LCL}
  BorderPanel.Ctl3D := FALSE;
  BorderPanel.ParentCtl3D := FALSE;
{$ifdef delphi7_plus}
  BorderPanel.ParentBackground := FALSE;
{$endif}
{$endif}
  BorderPanel.Parent := Self;

  PaintPanel := TPaintPanel.CreateIt(Self, Self);
  PaintPanel.ParentFont := FALSE;
  PaintPanel.Parent := Self;
  PaintPanel.BevelOuter := bvNone;
  PaintPanel.BevelInner := bvNone;
{$ifndef LCL}
  PaintPanel.ctl3D := FALSE;
{$endif}
  PaintPanel.OnPaint := HTMLPaint;
  PaintPanel.OnMouseDown := HTMLMouseDown;
  PaintPanel.OnMouseMove := HTMLMouseMove;
  PaintPanel.OnMouseUp := HTMLMouseUp;

  VScrollBar := TScrollBar.Create(Self);
  VScrollBar.Kind := sbVertical;
  VScrollBar.SmallChange := 16;
  VScrollBar.OnScroll := ScrollVert;
  VScrollBar.Visible := FALSE;
  VScrollBar.TabStop := FALSE;
  sbWidth := VScrollBar.Width;
  VScrollBar.Parent := Self;

  HScrollBar := TScrollBar.Create(Self);
  HScrollBar.Kind := sbHorizontal;
  HScrollBar.SmallChange := 15;
  HScrollBar.OnScroll := ScrollHorz;
  HScrollBar.Visible := FALSE;
  HScrollBar.TabStop := FALSE;
  HScrollBar.Parent := Self;

  FScrollBars := ssBoth;

  FSectionList := TSectionList.Create(Self, PaintPanel);
  FSectionList.ControlEnterEvent := FormControlEnterEvent;
  FSectionList.OnBackgroundChange := BackgroundChange;
  FSectionList.ShowImages := TRUE;
  FSectionList.TheOwner:=self;
  FNameList := FSectionList.IDNameList;

  DefBackground := clBtnFace;
  DefFontColor := clBtnText;
  DefHotSpotColor := clBlue;
  DefOverLinkColor := clBlue;
  DefVisitedLinkColor := clPurple;
  FVisitedMaxCount := 50;
  DefFontSize := 12;
  DefFontName := 'Times New Roman';
  DefPreFontName := 'Courier New';
  SetImageCacheCount(5);
  SetOptions([htPrintTableBackground, htPrintMonochromeBlack]);

  FHistory := TStringList.Create;
  FPositionHistory := TFreeList.Create;
  FTitleHistory := TStringList.Create;

  Visited := TStringList.Create;
  HTMLTimer := TTimer.Create(Self);
  HTMLTimer.Enabled := FALSE;
  HTMLTimer.Interval := 200;
  HTMLTimer.OnTimer := HTMLTimerTimer;
  FLinkAttributes := TStringList.Create;

{$ifdef LCL}
  // BG, 24.10.2010: there is no initial WMSize message, thus size child components now:
  DoScrollBars;
{$endif}
  Exclude(FViewerState, vsCreating);
end;

destructor ThtmlViewer.Destroy;
begin
  Exclude(FViewerState, vsMiddleScrollOn);
  if vsLocalBitmapList in FViewerState then
  begin
    FSectionList.Clear;
    FSectionList.BitmapList.Free;
  end;
  FSectionList.Free;
  FHistory.Free;
  FPositionHistory.Free;
  FTitleHistory.Free;
  Visited.Free;
  HTMLTimer.Free;
  FLinkAttributes.Free;
{$ifndef FPC_TODO_PRINTING}
  AbortPrint;
{$endif}
  inherited Destroy;
end;

procedure THtmlViewer.SetupAndLogic;
begin
  FTitle := HtmlSubs.Title;
  if HtmlSubs.Base <> '' then
    FBase := HtmlSubs.Base
  else
    FBase := FBaseEx;
  FBaseTarget := HtmlSubs.BaseTarget;
  if Assigned(FOnParseEnd) then
    FOnParseEnd(Self);
  try
    Include(FViewerState, vsDontDraw);
  {Load the background bitmap if any and if ViewImages set}
    FSectionList.GetBackgroundBitmap;

    DoLogic;

  finally
    Exclude(FViewerState, vsDontDraw);
  end;
end;

procedure ThtmlViewer.LoadFile(const FileName: string; ft: ThtmlFileType);
var
  Dest, FName, OldFile: string;
  SBuffer: string;
  OldCursor: TCursor;
begin
  with Screen do
  begin
    OldCursor := Cursor;
    Cursor := crHourGlass;
  end;
  IOResult;   {eat up any pending errors}
  SplitDest(FileName, FName, Dest);
  if FName <> '' then
    FName := ExpandFileName(FName);
  FRefreshDelay := 0;
  try
    SetProcessing(TRUE);
    if not FileExists(FName) then
      raise(EInOutError.Create('Can''t locate file: ' + FName));
    FSectionList.ProgressStart := 75;
    htProgressInit;
    Include(FViewerState, vsDontDraw);
    InitLoad;
    CaretPos := 0;
    Sel1 := -1;
    try
      OldFile := FCurrentFile;
      FCurrentFile := FName;
      FCurrentFileType := ft;
      if ft in [HTMLType, TextType] then
	   begin
        FDocumentSource := LoadStringFromFile(FName)  ;
    // Added by vvd
      FDocumentSourceUtf16 := '';
      FIsUtf16Source := FALSE;
    // End of Added by vvd
      end
      else
        FDocumentSource := '';

      if Assigned(FOnParseBegin) then
        FOnParseBegin(Self, FDocumentSource);

      if ft = HTMLType then
      begin
        if Assigned(FOnSoundRequest) then
          FOnSoundRequest(Self, '', 0, TRUE);
        ParseHTMLString(FDocumentSource, FSectionList, FOnInclude, FOnSoundRequest, HandleMeta, FOnLink);
      end
      else
      if ft = TextType then
        ParseTextString(FDocumentSource, FSectionList)
      else
      begin
        SBuffer := '<img src="' + FName + '">';
        ParseHTMLString(SBuffer, FSectionList, NIL, NIL, NIL, NIL);
      end;
    finally
      SetupAndLogic;
      CheckVisitedLinks;
      if (Dest <> '') and PositionTo(Dest) then  {change position, if applicable}
      else
      if FCurrentFile <> OldFile then
      begin
        ScrollTo(0);
        HScrollBar.Position := 0;
      end;
    {else if same file leave position alone}
      Exclude(FViewerState, vsDontDraw);
      PaintPanel.Invalidate;
    end;
  finally
    Screen.Cursor := OldCursor;
    htProgressEnd;
    SetProcessing(FALSE);
  end;
  if (FRefreshDelay > 0) and Assigned(FOnMetaRefresh) then
    FOnMetaRefresh(Self, FRefreshDelay, FRefreshURL);
end;

procedure ThtmlViewer.LoadFromFile(const FileName: string);
var
  OldFile, OldTitle: string;
  OldPos: Integer;
  OldType: ThtmlFileType;
  OldFormData: TFreeList;
  (*Stream: TMemoryStream;  //debugging aid
  Indent, Tree: string; *)
begin
  if vsProcessing in FViewerState then
    Exit;
  if Filename <> '' then
  begin
    OldFile := FCurrentFile;
    OldTitle := FTitle;
    OldPos := Position;
    OldType := FCurrentFileType;
    OldFormData := GetFormData;
    try
      LoadFile(FileName, HTMLType);

    (*Indent := '';     //debugging aid
    Tree := '';
    FSectionList.FormTree(Indent, Tree);

    Stream := TMemoryStream.Create;
    Stream.Size := Length(Tree);
    Move(Tree[1], Stream.Memory^, Length(Tree));
    Stream.SaveToFile('C:\css2\exec\Tree.txt');
    Stream.Free; *)


      if (OldFile <> FCurrentFile) or (OldType <> FCurrentFileType) then
        BumpHistory(OldFile, OldTitle, OldPos, OldFormData, OldType)
      else
        OldFormData.Free;
    except
      OldFormData.Free;
      raise;
    end;
  end;
end;

{----------------ThtmlViewer.LoadTextFile}

procedure ThtmlViewer.LoadTextFile(const FileName: string);
var
  OldFile, OldTitle: string;
  OldPos: Integer;
  OldType: ThtmlFileType;
  OldFormData: TFreeList;
begin
  if vsProcessing in FViewerState then
    Exit;
  if Filename <> '' then
  begin
    OldFile := FCurrentFile;
    OldTitle := FTitle;
    OldPos := Position;
    OldType := FCurrentFileType;
    OldFormData := GetFormData;
    try
      LoadFile(FileName, TextType);
      if (OldFile <> FCurrentFile) or (OldType <> FCurrentFileType) then
        BumpHistory(OldFile, OldTitle, OldPos, OldFormData, OldType)
      else
        OldFormData.Free;
    except
      OldFormData.Free;
      raise;
    end;
  end;
end;

{----------------ThtmlViewer.LoadImageFile}

procedure ThtmlViewer.LoadImageFile(const FileName: string);
var
  OldFile, OldTitle: string;
  OldPos: Integer;
  OldType: ThtmlFileType;
  OldFormData: TFreeList;
begin
  if vsProcessing in FViewerState then
    Exit;
  if Filename <> '' then
  begin
    OldFile := FCurrentFile;
    OldTitle := FTitle;
    OldPos := Position;
    OldType := FCurrentFileType;
    OldFormData := GetFormData;
    try
      LoadFile(FileName, ImgType);
      if (OldFile <> FCurrentFile) or (OldType <> FCurrentFileType) then
        BumpHistory(OldFile, OldTitle, OldPos, OldFormData, OldType)
      else
        OldFormData.Free;
    except
      OldFormData.Free;
      raise;
    end;
  end;
end;

{----------------THtmlViewer.LoadStrings}

procedure THtmlViewer.LoadStrings(const Strings: TStrings; const Reference: string);
begin
  LoadString(Strings.Text, Reference, HTMLType);
// Added by vvd
  FDocumentSourceUtf16 := '';
  FIsUtf16Source := FALSE;
// End of Added by vvd
  if (FRefreshDelay > 0) and Assigned(FOnMetaRefresh) then
    FOnMetaRefresh(Self, FRefreshDelay, FRefreshURL);
end;

{----------------THtmlViewer.LoadTextStrings}

procedure THtmlViewer.LoadTextStrings(Strings: TStrings);
begin
  LoadString(Strings.Text, '', TextType);
// Added by vvd
  FDocumentSourceUtf16 := '';
  FIsUtf16Source := FALSE;
// End of Added by vvd
end;

{----------------ThtmlViewer.LoadFromBuffer}

procedure THtmlViewer.LoadFromBuffer(Buffer: PChar; BufLenTChars: Integer; const Reference: string);
var
  S: string;
begin
  SetString(S, Buffer, BufLenTChars); // Yunqa.de: SetString() is faster than SetLength().
  LoadString(S, Reference, HTMLType);
// Added by vvd
  FDocumentSourceUtf16 := '';
  FIsUtf16Source := FALSE;
// End of Added by vvd
  if (FRefreshDelay > 0) and Assigned(FOnMetaRefresh) then
    FOnMetaRefresh(Self, FRefreshDelay, FRefreshURL);
end;

{----------------ThtmlViewer.LoadTextFromString}

procedure ThtmlViewer.LoadTextFromString(const S: string);
begin
  LoadString(S, '', TextType);
// Added by vvd
  FDocumentSourceUtf16 := '';
  FIsUtf16Source := FALSE;
// End of Added by vvd
end;

{----------------ThtmlViewer.LoadFromString}
{$ifdef UNICODE}
procedure THtmlViewer.LoadFromString(const S: AnsiString; const Reference: string);
begin
  LoadFromString(MultibyteToWideString(CodePage, S), Reference);
end;

procedure THtmlViewer.LoadFromString(const S: WideString; const Reference: string);
begin
  LoadString(S, Reference, HTMLType);
  if (FRefreshDelay > 0) and Assigned(FOnMetaRefresh) then
    FOnMetaRefresh(Self, FRefreshDelay, FRefreshURL);
end;
{$else}
procedure THtmlViewer.LoadFromString(const S: AnsiString; const Reference: string);
begin
  LoadString(S, Reference, HTMLType);
// Added by vvd
  FDocumentSourceUtf16 := '';
  FIsUtf16Source := FALSE;
// End of Added by vvd
  if (FRefreshDelay > 0) and Assigned(FOnMetaRefresh) then
    FOnMetaRefresh(Self, FRefreshDelay, FRefreshURL);
end;

{$ifdef Delphi6_Plus}

procedure THtmlViewer.LoadFromString(const S: WideString; const Reference: string);
begin
  LoadFromString(#$EF + #$BB + #$BF + UTF8Encode(S), Reference);
// Added by vvd
  FDocumentSourceUtf16 := s;
  FIsUtf16Source := TRUE;
// End of Added by vvd
end;
{$endif}
{$endif}

{----------------ThtmlViewer.LoadString}

procedure ThtmlViewer.LoadString(const Source, Reference: string; ft: ThtmlFileType);
var
  I: Integer;
  Dest, FName, OldFile: string;
begin
  if vsProcessing in FViewerState then
    Exit;
  SetProcessing(TRUE);
  FRefreshDelay := 0;
  FName := Reference;
  I := Pos('#', FName);
  if I > 0 then
  begin
    Dest := Copy(FName, I + 1, Length(FName) - I);  {positioning information}
    FName := Copy(FName, 1, I - 1);
  end
  else
    Dest := '';
  Include(FViewerState, vsDontDraw);
  try
    OldFile := FCurrentFile;
    FCurrentFile := ExpandFileName(FName);
    FCurrentFileType := ft;
    FSectionList.ProgressStart := 75;
    htProgressInit;
    InitLoad;
    CaretPos := 0;
    Sel1 := -1;
    if Assigned(FOnSoundRequest) then
      FOnSoundRequest(Self, '', 0, TRUE);
    FDocumentSource := Source;
    if Assigned(FOnParseBegin) then
      FOnParseBegin(Self, FDocumentSource);
    if Ft = HTMLType then
      ParseHTMLString(FDocumentSource, FSectionList, FOnInclude, FOnSoundRequest, HandleMeta, FOnLink)
    else
      ParseTextString(FDocumentSource, FSectionList);
    SetupAndLogic;
    CheckVisitedLinks;
    if (Dest <> '') and PositionTo(Dest) then  {change position, if applicable}
    else
    if (FCurrentFile = '') or (FCurrentFile <> OldFile) then
    begin
      ScrollTo(0);
      HScrollBar.Position := 0;
    end;
  {else if same file leave position alone}
    PaintPanel.Invalidate;
  finally
    htProgressEnd;
    SetProcessing(FALSE);
    Exclude(FViewerState, vsDontDraw);
  end;
end;

{----------------ThtmlViewer.LoadFromStream}

procedure ThtmlViewer.LoadFromStream(const AStream: TStream; const Reference: string);
var
  S: string;
begin
  S := LoadStringFromStream(AStream);
    LoadString(S, Reference, HTMLType);
  // Added by vvd
    FDocumentSourceUtf16 := '';
    FIsUtf16Source := FALSE;
  // End of Added by vvd
    if (FRefreshDelay > 0) and Assigned(FOnMetaRefresh) then
      FOnMetaRefresh(Self, FRefreshDelay, FRefreshURL);
end;

procedure ThtmlViewer.DoImage(Sender: TObject; const SRC: string; var Stream: TMemoryStream);
begin
  Stream := FImageStream;
end;

{----------------ThtmlViewer.LoadStream}

procedure ThtmlViewer.LoadStream(const URL: string; AStream: TMemoryStream; ft: ThtmlFileType);
var
  SaveOnImageRequest: TGetImageEvent;
  SBuffer: string;
begin
  if (vsProcessing in FViewerState) or not Assigned(AStream) then
    Exit;
  SetProcessing(TRUE);
  FRefreshDelay := 0;
  Include(FViewerState, vsDontDraw);
  try
    FSectionList.ProgressStart := 75;
    htProgressInit;
    InitLoad;
    CaretPos := 0;
    Sel1 := -1;

    AStream.Position := 0;
    if ft in [HTMLType, TextType] then
    begin
      FDocumentSource := LoadStringFromStream(AStream);
    end
    else
 FDocumentSource := '';
  // Added by vvd
    FDocumentSourceUtf16 := '';
    FIsUtf16Source := FALSE;
  // End of Added by vvd
    if Assigned(FOnParseBegin) then
      FOnParseBegin(Self, FDocumentSource);

    case ft of
      HTMLType:
    begin
      if Assigned(FOnSoundRequest) then
        FOnSoundRequest(Self, '', 0, TRUE);
      ParseHTMLString(FDocumentSource, FSectionList, FOnInclude, FOnSoundRequest, HandleMeta, FOnLink);
      SetupAndLogic;
      end;

      TextType:
    begin
      ParseTextString(FDocumentSource, FSectionList);
      SetupAndLogic;
      end;
    else
      SaveOnImageRequest := OnImageRequest;
      SetOnImageRequest(DoImage);
      FImageStream := AStream;
      SBuffer := '<img src="' + URL + '">';
      try
        ParseHTMLString(SBuffer, FSectionList, NIL, NIL, NIL, NIL);
        SetupAndLogic;
      finally
        SetOnImageRequest(SaveOnImageRequest);
      end;
    end;
    ScrollTo(0);
    HScrollBar.Position := 0;
    PaintPanel.Invalidate;
    FCurrentFile := URL;
  finally
    htProgressEnd;
    Exclude(FViewerState, vsDontDraw);
    SetProcessing(FALSE);
  end;
  if (FRefreshDelay > 0) and Assigned(FOnMetaRefresh) then
    FOnMetaRefresh(Self, FRefreshDelay, FRefreshURL);
end;

{----------------ThtmlViewer.DoScrollBars}

procedure ThtmlViewer.DoScrollBars;

  procedure SetPageSizeAndMax(SB: TScrollBar; PageSize, Max: Integer);
  begin
    //BG, 19.02.2011: you can set neither a pagesize > max nor a max < pagesize
    // thus set in different order for growing and shrinking:
    if PageSize < SB.Max then
    begin
      SB.PageSize := PageSize;
      SB.Max := Max;
    end
    else
    begin
      SB.Max := Max;
      SB.PageSize := PageSize;
    end;
  end;
var
  VBar, VBar1, HBar: boolean;
  Wid, HWidth, WFactor, WFactor2, VHeight: Integer;
begin
  ScrollWidth := Min(ScrollWidth, MaxHScroll);
  if (FBorderStyle = htNone) and not (csDesigning in ComponentState) then
  begin
    WFactor2 := 0;
    BorderPanel.Visible := FALSE;
  end
  else
  begin
    WFactor2 := BorderPanel.Width - BorderPanel.ClientWidth;
    BorderPanel.Visible := FALSE;
    BorderPanel.Visible := TRUE;
  end;
  WFactor := WFactor2 div 2;
  PaintPanel.Top := WFactor;
  PaintPanel.Left := WFactor;

  VBar := FALSE;
  VBar1 := FALSE;
  if (not (htShowVScroll in htOptions) and (FMaxVertical <= Height - WFactor2) and (ScrollWidth <= Width - WFactor2)) or (FScrollBars = ssNone) then
  {there are no scrollbars}
    HBar := FALSE
  else
  if FScrollBars in [ssBoth, ssVertical] then
  begin  {assume a vertical scrollbar}
    VBar1 := (FMaxVertical >= Height - WFactor2) or
      ((FScrollBars in [ssBoth, ssHorizontal]) and
      (FMaxVertical >= Height - WFactor2 - sbWidth) and
      (ScrollWidth > Width - sbWidth - WFactor2));
    HBar := (FScrollBars in [ssBoth, ssHorizontal]) and
      ((ScrollWidth > Width - WFactor2) or
      ((VBar1 or (htShowVScroll in FOptions)) and
      (ScrollWidth > Width - sbWidth - WFactor2)));
    VBar := Vbar1 or (htShowVScroll in htOptions);
  end
  else
    {there is no vertical scrollbar}
    HBar := (FScrollBars = ssHorizontal) and (ScrollWidth > Width - WFactor2);

  if VBar or ((htShowVScroll in FOptions) and (FScrollBars in [ssBoth, ssVertical])) then
    Wid := Width - sbWidth
  else
    Wid := Width;
  PaintPanel.Width := Wid - WFactor2;
  if HBar then
  begin
    PaintPanel.Height := Height - WFactor2 - sbWidth;
    VHeight := Height - sbWidth - WFactor2;
  end
  else
  begin
    PaintPanel.Height := Height - WFactor2;
    VHeight := Height - WFactor2;
  end;
  HWidth := Max(ScrollWidth, Wid - WFactor2);

  HScrollBar.Visible := HBar;
  if HScrollBar.Visible then
  begin
    HScrollBar.LargeChange := Max(1, Wid - 20);
  HScrollBar.SetBounds(WFactor, Height - sbWidth - WFactor, Wid - WFactor, sbWidth);
    SetPageSizeAndMax(HScrollBar, Wid, Max(Wid, HWidth));
  end;

  if htShowVScroll in FOptions then
  begin
    VScrollBar.Visible := (FScrollBars in [ssBoth, ssVertical]);
    VScrollBar.Enabled := VBar1;
  end
  else
    VScrollBar.Visible := VBar;
  if VScrollBar.Visible then
  begin
    VScrollBar.LargeChange := PaintPanel.Height - VScrollBar.SmallChange;
    VScrollBar.SetBounds(Width - sbWidth - WFactor, WFactor, sbWidth, VHeight);
    SetPageSizeAndMax(VScrollBar, PaintPanel.Height + 1, Max(PaintPanel.Height + 1, FMaxVertical));
  end;
end;

{----------------ThtmlViewer.DoLogic}

procedure ThtmlViewer.DoLogic;
var
  Wid, WFactor: Integer;

  function HasVScrollbar: boolean;
  begin
    Result := (FMaxVertical > Height - WFactor) or
      ((FScrollBars in [ssBoth, ssHorizontal]) and
      (FMaxVertical >= Height - WFactor - sbWidth) and
      (ScrollWidth > Width - sbWidth - WFactor));
  end;

  function HasVScrollbar1: boolean;
  begin
    Result := (FMaxVertical > Height - WFactor) or
      ((FScrollBars in [ssBoth, ssHorizontal]) and
      (FMaxVertical >= Height - WFactor - sbWidth) and
      (ScrollWidth > Width - WFactor));
  end;

  function FSectionListDoLogic(Width: Integer): Integer;
  var
    Curs: Integer;
  begin
    Curs := 0;
    ScrollWidth := 0;
    Result := FSectionList.DoLogic(PaintPanel.Canvas, 0,
      Width, ClientHeight - WFactor, 0, ScrollWidth, Curs);
  end;
begin
  HandleNeeded;
  Include(FViewerState, vsDontDraw);
  try
    if FBorderStyle = htNone then
      WFactor := 0
    else
      WFactor := BorderPanel.Width - BorderPanel.ClientWidth;
    Wid := Width - WFactor;
    if FScrollBars in [ssBoth, ssVertical] then
    begin
      if not (htShowVScroll in FOptions) and (Length(FDocumentSource) < 10000) then
      begin   {see if there is a vertical scrollbar with full width}
        FMaxVertical := FSectionListDoLogic(Wid);
        if HasVScrollBar then {yes, there is vertical scrollbar, allow for it}
        begin
          FMaxVertical := FSectionListDoLogic(Wid - sbWidth);
          if not HasVScrollBar1 then
            FMaxVertical := FSectionListDoLogic(Wid);
        end;
      end
      else {assume a vertical scrollbar}
        FMaxVertical := FSectionListDoLogic(Wid - sbWidth);
    end
    else {there is no vertical scrollbar}
      FMaxVertical := FSectionListDoLogic(Wid);

    DoScrollbars;
  finally
    Exclude(FViewerState, vsDontDraw);
  end;
end;

procedure ThtmlViewer.HTMLPaint(Sender: TObject);
var
  ARect: TRect;
begin
  if vsDontDraw in FViewerState then
    exit;
    ARect := Rect(0, 1, PaintPanel.Width, PaintPanel.Height);
    FSectionList.Draw(PaintPanel.Canvas2, ARect, MaxHScroll, -HScrollBar.Position, 0, 0, 0);
end;

procedure ThtmlViewer.WMSize(var Message: TWMSize);
begin
  inherited;
  if vsCreating in FViewerState then
    Exit;
  if vsProcessing in FViewerState then
    DoScrollBars
  else
    Layout;
  if FMaxVertical < PaintPanel.Height then
    Position := 0
  else
    ScrollTo(VScrollBar.Position); {keep aligned to limits}
  with HScrollBar do
    Position := Math.Min(Position, Max - PaintPanel.Width);
end;

procedure THtmlViewer.ScrollHorz(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
{only the horizontal scrollbar comes here}
begin
  ScrollPos := Min(ScrollPos, HScrollBar.Max - PaintPanel.Width);
  PaintPanel.Invalidate;
end;

procedure ThtmlViewer.ScrollTo(Y: Integer);
begin
  Y := Min(Y, FMaxVertical - PaintPanel.Height);
  Y := Max(Y, 0);
  VScrollBar.Position := Y;
  FSectionList.SetYOffset(Y);
  Invalidate;
end;

//-- BG ---------------------------------------------------------- 19.02.2011 --
// thanks to Alex at grundis.de
procedure THtmlViewer.ScrollVert(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  TheChange: Integer;
begin
  FSectionList.SetYOffset(ScrollPos);
  if vsBGFixed in FViewerState then
    PaintPanel.Invalidate
  else
  begin {scroll background}
    TheChange := VScrollBar.Position - ScrollPos;
    ScrollWindow(PaintPanel.Handle, 0, TheChange, NIL, NIL);
    PaintPanel.Update;
  end;
end;

procedure ThtmlViewer.Layout;
var
  OldPos: Integer;
begin
  if vsProcessing in FViewerState then
    Exit;
  SetProcessing(TRUE);
  try
    OldPos := Position;
    FSectionList.ProgressStart := 0;
    htProgressInit;
    DoLogic;
    Position := OldPos;   {return to old position after width change}
  finally
    htProgressEnd;
    SetProcessing(FALSE);
  end;
end;

function ThtmlViewer.HotSpotClickHandled: boolean;
begin
  Result := FALSE;
  if Assigned(FOnHotSpotClick) then
    FOnHotSpotClick(Self, URL, Result);
end;

procedure ThtmlViewer.TriggerUrlAction;
begin
  PostMessage(Handle, wm_UrlAction, 0, 0);
end;

procedure ThtmlViewer.WMUrlAction(var Message: TMessage);
begin
  UrlAction;
end;

procedure ThtmlViewer.URLAction;
var
  S, Dest: string;
  I: Integer;
  OldPos: Integer;
begin
  if not HotSpotClickHandled then
  begin
    OldPos := Position;
    S := URL;
    I := Pos('#', S);  {# indicates a position within the document}
    if I = 1 then
    begin
      if PositionTo(S) then    {no filename with this one}
      begin
        BumpHistory(FCurrentFile, FTitle, OldPos, NIL, FCurrentFileType);
        AddVisitedLink(FCurrentFile + S);
      end;
    end
    else
    begin
      if I >= 1 then
      begin
        Dest := System.Copy(S, I, Length(S) - I + 1);  {local destination}
        S := System.Copy(S, 1, I - 1);     {the file name}
      end
      else
        Dest := '';    {no local destination}
      S := HTMLExpandFileName(S);
      case GetFileType(S) of

        HTMLType:
        if S <> FCurrentFile then
        begin
          LoadFromFile(S + Dest);
          AddVisitedLink(S + Dest);
        end
        else
        if PositionTo(Dest) then   {file already loaded, change position}
        begin
          BumpHistory(FCurrentFile, FTitle, OldPos, NIL, HTMLType);
          AddVisitedLink(S + Dest);
        end;

        ImgType:
        LoadImageFile(S);

        TextType:
          LoadTextFile(S);
      end;
    end;
    {Note: Self may not be valid here}
  end;
end;

{----------------ThtmlViewer.AddVisitedLink}

procedure ThtmlViewer.AddVisitedLink(const S: string);
var
  I, J: Integer;
  S1, UrlTmp: string;
begin
  if Assigned(FrameOwner) or (FVisitedMaxCount = 0) then
    Exit;      {TFrameViewer will take care of visited links}
  I := Visited.IndexOf(S);
  if I = 0 then
    Exit
  else
  if I < 0 then
  begin
    for J := 0 to SectionList.LinkList.Count - 1 do
      with TFontObj(SectionList.LinkList[J]) do
      begin
        UrlTmp := Url;
        if Length(UrlTmp) > 0 then
        begin
          if Url[1] = '#' then
            S1 := FCurrentFile + UrlTmp
          else
            S1 := HTMLExpandFilename(UrlTmp);
          // Yunqa.de: Except for the domain, URLs might be case sensitive!
          if S = S1 then
            Visited := TRUE;
        end;
      end;
  end
  else
    Visited.Delete(I); {thus moving it to the top}
  Visited.Insert(0, S);
  for I := Visited.Count - 1 downto FVisitedMaxCount do
    Visited.Delete(I);
end;

{----------------ThtmlViewer.CheckVisitedLinks}

procedure ThtmlViewer.CheckVisitedLinks;
var
  I, J: Integer;
  S, S1: string;
begin
  if FVisitedMaxCount = 0 then
    Exit;
  for I := 0 to Visited.Count - 1 do
  begin
    S := Visited[I];
    for J := 0 to SectionList.LinkList.Count - 1 do
      with TFontObj(SectionList.LinkList[J]) do
      begin
        if (Url <> '') and (Url[1] = '#') then
          S1 := FCurrentFile + Url
        else
          S1 := HTMLExpandFilename(Url);
        if CompareText(S, S1) = 0 then
          Visited := TRUE;
      end;
  end;
end;

{procedure ThtmlViewer.AcceptClick(Sender: TObject; X, Y: Integer);
begin
  HTMLMouseDown(Sender, mbLeft, [], X, Y);
  HTMLMouseUp(Sender, mbLeft, [], X, Y);
end;}//AlekId:Hint

{----------------ThtmlViewer.HTMLMouseDown}

procedure ThtmlViewer.HTMLMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  XR, CaretHt: Integer;
  YR: Integer;
  InText: boolean;
  Dummy: TUrlTarget;
  DummyFC: TIDObject {TImageFormControlObj};
  DummyTitle: string;
begin
  inherited MouseDown(Button, Shift, X, Y);

  SetFocus;
  Exclude(FViewerState, vsHotSpotAction);
  if vsMiddleScrollOn in FViewerState then
  begin
    Exclude(FViewerState, vsMiddleScrollOn);
    Exclude(FViewerState, vsMouseScrolling);
    PaintPanel.Cursor := Cursor;
  end
  else
  if (Button = mbMiddle) and not (htNoWheelMouse in htOptions) then  {comment this out to disable mouse middle button scrolling}
  begin
    Include(FViewerState, vsMiddleScrollOn);
    MiddleY := Y;
    PaintPanel.Cursor := UpDownCursor;
  end
  else
  if (Button = mbLeft) then
  begin
    Include(FViewerState, vsLeftButtonDown);
    if not (htNoLinkHilite in FOptions) or not (guUrl in GetURL(X, Y, Dummy, DummyFC, DummyTitle)) then
      Include(FViewerState, vsHiLiting);
    with FSectionList do
    begin
      Sel1 := FindCursor(PaintPanel.Canvas, X, Y + YOff, XR, YR, CaretHt, InText);
      if Sel1 > -1 then
      begin
      {AlekId}

        FLeftMouseClickPos := Sel1;
        SellNeedAdjust := not InText;
      {/AlekId}
        if (SelB <> SelE) or (ssShift in Shift) then
          InvalidateRect(PaintPanel.Handle, NIL, TRUE);
        if (ssShift in Shift) then
          if Sel1 < CaretPos then
          begin
            SelE := CaretPos;
            SelB := Sel1;
          end
          else
          begin
            SelB := CaretPos;
            SelE := Sel1;
          end
        else
        begin
          SelB := Sel1;
          SelE := Sel1;
          CaretPos := Sel1;
        end;
      end;
      LButtonDown(TRUE);   {signal to TSectionList}
    end;
  end
// added AlekId
  else
  if (Button = mbRight) then
  begin
    with FSectionList do
    begin
      Sel1 := FindCursor(PaintPanel.Canvas, X, Y + YOff, XR, YR, CaretHt, InText);
      if Sel1 > -1 then
      begin
        FRightMouseClickPos := Sel1;
        Dec(FRightMouseClickPos, ord(not (Intext)) * 2);
      end;//if
    end;//with
  end;//btn
// end of added

end;

procedure ThtmlViewer.HTMLTimerTimer(Sender: TObject);
var
  Pt: TPoint;
begin
  if GetCursorPos(Pt) and (WindowFromPoint(Pt) <> PaintPanel.Handle) then
  begin
    SectionList.CancelActives;
    HTMLTimer.Enabled := FALSE;
    if FURL <> '' then
    begin
      FURL := '';
      FTarget := '';
      if Assigned(FOnHotSpotCovered) then
        FOnHotSpotCovered(Self, '');
    end;
  end;
end;

function ThtmlViewer.PtInObject(X, Y: Integer; var Obj: TObject): boolean;  {X, Y, are client coord} {css}
var
  IX, IY: Integer;
begin
  Result := PtInRect(ClientRect, Point(X, Y)) and
    FSectionList.PtInObject(X, Y + FSectionList.YOff, Obj, IX, IY);
end;

procedure ThtmlViewer.ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Dummy: TUrlTarget;
  DummyFC: TIDObject {TImageFormControlObj};
begin
  if Sender is TFormControlObj then
    with TFormControlObj(Sender), TheControl do
    begin
      FTitleAttr := Title;
      if FTitleAttr = '' then
      begin
        Dummy := NIL;
        GetURL(X + Left, Y + Top, Dummy, DummyFC, FTitleAttr);
        if Assigned(Dummy) then
          Dummy.Free;
      end;
      inherited MouseMove(Shift, X, Y);
    end;
end;

function ThtmlViewer.GetTextByIndices(AStart, ALast: Integer): WideString;
var
  SaveSelB: Integer;
  SaveSelE: Integer;
begin
  if (AStart >= 0) and (ALast >= 0) and (ALast > AStart) then
    with FSectionList do
    begin
      SaveSelB := SelB;
      SaveSelE := SelE;
      SelB := Self.FindDisplayPos(AStart, FALSE);
      SelE := Self.FindDisplayPos(ALast, FALSE);
      Result := GetSelText;
      DisplayPosToXY(SelB, FLinkStart.X, FLinkStart.Y);
      Dec(FLinkStart.Y, VScrollBar.Position);
      SelB := SaveSelB;
      SelE := SaveSelE;
    end
  else
    Result := '';
end;

{----------------ThtmlViewer.HTMLMouseMove}

procedure ThtmlViewer.HTMLMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  UrlTarget: TUrlTarget;
  Url, Target: string;
  FormControl: TIDObject {TImageFormControlObj};
  Obj: TObject;
  IX, IY: Integer;
  XR, CaretHt: Integer;
  YR: Integer;
  InText: boolean;
  NextCursor: TCursor;
  guResult: guResultType;
begin
  inherited MouseMove(Shift, X, Y);

  if vsMiddleScrollOn in FViewerState then
  begin
    if not (vsMouseScrolling in FViewerState) and (Abs(Y - MiddleY) > ScrollGap) then
    begin
      Include(FViewerState, vsMouseScrolling);
      PostMessage(Handle, wm_MouseScroll, 0, 0);
    end;
    Exit;
  end;

  UrlTarget := NIL;
  URL := '';
  NextCursor := crArrow;
  FTitleAttr := '';
  guResult := GetURL(X, Y, UrlTarget, FormControl, FTitleAttr);
  if guUrl in guResult then
  begin
    NextCursor := HandCursor;
    Url := UrlTarget.Url;
    Target := UrlTarget.Target;
    FLinkAttributes.Text := UrlTarget.Attr;
    FLinkText := GetTextByIndices(UrlTarget.Start, UrlTarget.Last);
    UrlTarget.Free;
  end;
  if guControl in guResult then
    NextCursor := HandCursor;
  if (Assigned(FOnImageClick) or Assigned(FOnImageOver)) and
    FSectionList.PtInObject(X, Y + FSectionList.YOff, Obj, IX, IY) then
  begin
    if NextCursor <> HandCursor then  {in case it's also a Link}
      NextCursor := crArrow;
    if Assigned(FOnImageOver) then
      FOnImageOver(Self, Obj, Shift, IX, IY);
  end
  else
  if (FSectionList.FindCursor(PaintPanel.Canvas, X, Y + FSectionList.YOff, XR, YR, CaretHt, InText) >= 0) and InText and (NextCursor <> HandCursor) then
    NextCursor := Cursor;

  PaintPanel.Cursor := NextCursor;

  if ((NextCursor = HandCursor) or (SectionList.ActiveImage <> NIL)) then
    HTMLTimer.Enabled := TRUE
  else
    HTMLTimer.Enabled := FALSE;

  if (URL <> FURL) or (Target <> FTarget) then
  begin
    FURL := URL;
    FTarget := Target;
    if Assigned(FOnHotSpotCovered) then
      FOnHotSpotCovered(Self, URL);
  end;
  if (ssLeft in Shift) and not (vsMouseScrolling in FViewerState) and ((Y <= 0) or (Y >= Self.Height)) then
  begin
    Include(FViewerState, vsMouseScrolling);
    PostMessage(Handle, wm_MouseScroll, 0, 0);
  end;
  if (ssLeft in Shift) and not FNoSelect then
    DoHilite(X, Y);
end;

procedure ThtmlViewer.HTMLMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  UrlTarget: TUrlTarget;
  FormControl: TIDObject {TImageFormControlObj};
  Obj: TObject;
  IX, IY: Integer;
  InImage, TmpLeft: boolean;
  Parameters: TRightClickParameters;
  AWord: WideString;
  St, En: Integer;
  guResult: guResultType;
  I, ThisID: Integer;
  ParentForm: TCustomForm;
begin
  if vsMiddleScrollOn in FViewerState then
  begin
  {cancel unless it's middle button and has moved}
    if (Button <> mbMiddle) or (Y <> MiddleY) then
    begin
      Exclude(FViewerState, vsMiddleScrollOn);
      PaintPanel.Cursor := Cursor;
    end;
    Exit;
  end;

  inherited MouseUp(Button, Shift, X, Y);

  if Assigned(FOnImageClick) or Assigned(FOnRightClick) then
  begin
    InImage := FSectionList.PtInObject(X, Y + FSectionList.YOff, Obj, IX, IY);
    if Assigned(FOnImageClick) and InImage then
      FOnImageClick(Self, Obj, Button, Shift, IX, IY);
    if (Button = mbRight) and Assigned(FOnRightClick) then
    begin
      Parameters := TRightClickParameters.Create;
      try
        if InImage then
        begin
          Parameters.Image := Obj as TImageObj;
          Parameters.ImageX := IX;
          Parameters.ImageY := IY;
        end;
        if guUrl in GetURL(X, Y, UrlTarget, FormControl, FTitleAttr) then
        begin
          Parameters.URL := UrlTarget.Url;
          Parameters.Target := UrlTarget.Target;
          UrlTarget.Free;
        end;
        if GetWordAtCursor(X, Y, St, En, AWord) then
          Parameters.ClickWord := AWord;
        HTMLTimer.Enabled := FALSE;
        FOnRightClick(Self, Parameters);
      finally
        HTMLTimer.Enabled := TRUE;
        Parameters.Free;
      end;
    end;
  end;

  if (Button = mbLeft) and not (ssShift in Shift) then
  begin
    Exclude(FViewerState, vsMouseScrolling);
    DoHilite(X, Y);
    Exclude(FViewerState, vsHiliting);
    FSectionList.LButtonDown(FALSE);
    TmpLeft := vsLeftButtonDown in FViewerState;
    Exclude(FViewerState, vsLeftButtonDown);
    if TmpLeft and (FSectionList.SelE <= FSectionList.SelB) then
    begin
      guResult := GetURL(X, Y, UrlTarget, FormControl, FTitleAttr);
      if guControl in guResult then
        TImageFormControlObj(FormControl).ImageClick(NIL)
      else
      if guUrl in guResult then
      begin
        FURL := UrlTarget.Url;
        FTarget := UrlTarget.Target;
        FLinkAttributes.Text := UrlTarget.Attr;
        FLinkText := GetTextByIndices(UrlTarget.Start, UrlTarget.Last);
        ThisID := UrlTarget.ID;
        for I := 0 to LinkList.Count - 1 do
          with TFontObj(LinkList.Items[I]) do
            if (ThisID = UrlTarget.ID) and Assigned(TabControl) then
            begin
              ParentForm := GetParentForm(TabControl);
              if Assigned(ParentForm) and TabControl.CanFocus then
              begin
                NoJump := TRUE;    {keep doc from jumping position on mouse click}
                try
                  ParentForm.ActiveControl := TabControl;
                finally
                  NoJump := FALSE;
                end;
              end;
              break;
            end;
        UrlTarget.Free;
        Include(FViewerState, vsHotSpotAction); {prevent Double click action}
        URLAction;
      {Note:  Self pointer may not be valid after URLAction call (TFrameViewer, HistoryMaxCount=0)}
      end;
    end;
  end;
end;

{----------------ThtmlViewer.HTMLMouseWheel}
{$ifdef ver120_plus}

procedure ThtmlViewer.HTMLMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint);
var
  Lines: Integer;
begin
  Lines := Mouse.WheelScrollLines;
  if Lines > 0 then
    if WheelDelta > 0 then
      VScrollBarPosition := VScrollBarPosition - (Lines * 16)
    else
      VScrollBarPosition := VScrollBarPosition + (Lines * 16)
  else
    VScrollBarPosition := VScrollBarPosition - WheelDelta div 2;
end;

function ThtmlViewer.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  result := inherited DoMouseWheel(shift, wheelDelta, mousePos);
  if not result and not (htNoWheelMouse in htOptions) then
  begin
    HTMLMouseWheel(Self, Shift, WheelDelta, MousePos);
    Result := TRUE;
  end;
end;
{$endif}

 {----------------ThtmlViewer.XYToDisplayPos}

function ThtmlViewer.XYToDisplayPos(X, Y: Integer): Integer;
var
  InText: boolean;
  XR, YR, CaretHt: Integer;
begin
  with SectionList do
    Result := FindCursor(PaintPanel.Canvas, X, Y + YOff, XR, YR, CaretHt, InText);
  if not InText then
    Result := -1;
end;

{----------------ThtmlViewer.GetCharAtPos}

function ThtmlViewer.GetCharAtPos(Pos: Integer; var Ch: WideChar; var Font: TFont): boolean;
var
  Obj: TObject;
  FO: TFontObj;
  Index: Integer;
begin
  Result := FSectionList.GetChAtPos(Pos, Ch, Obj);
  if Result and (Obj is TSection) then
    with TSection(Obj) do
    begin
      FO := Fonts.GetFontObjAt(Pos - StartCurs, Index);
      Font := FO.TheFont;
    end;
end;

{----------------ThtmlViewer.GetWordAtCursor}

function ThtmlViewer.GetWordAtCursor(X, Y: Integer; var St, En: Integer; var AWord: WideString): boolean;
var
  XR, X1, CaretHt: Integer;
  YR, Y1: Integer;
  Obj: TObject;
  Ch: WideChar;
  InText: boolean;
  Tmp: WideString;

  function AlphaNum(Ch: WideChar): boolean;
  begin
    Result := (Ch in [WideChar('a')..WideChar('z'), WideChar('A')..WideChar('Z'), WideChar('0')..WideChar('9')]) or (Ch >= #192);
  end;

  function GetCh(Pos: Integer): WideChar;
  var
    Ch: WideChar;
    Obj1: TObject;
  begin
    Result := ' ';
    if not FSectionList.GetChAtPos(Pos, Ch, Obj1) or (Obj1 <> Obj) then
      Exit;
    Result := Ch;
  end;
begin
  Result := FALSE;
  AWord := '';
  with FSectionList do
  begin
    InText := FALSE;
    CaretPos := FindCursor(PaintPanel.Canvas, X,
      Y + YOff, XR, YR, CaretHt, InText);
    CursorToXy(PaintPanel.Canvas, CaretPos, X1, Y1);
    if InText then   {else cursor is past end of row}
    begin
      en := CaretPos;
      st := en - 1;
      if GetChAtPos(en, Ch, Obj) and AlphaNum(Ch) then
      begin
        AWord := Ch;
        Result := TRUE;
        Inc(en);
        Ch := GetCh(en);
        while AlphaNum(Ch) do
        begin
          Tmp := Ch;     {Delphi 3 needs this nonsense}
          AWord := AWord + Tmp;
          Inc(en);
          Ch := GetCh(en);
        end;
        if St >= 0 then
        begin
          Ch := GetCh(st);
          while (st >= 0) and AlphaNum(Ch) do
          begin
            System.Insert(Ch, AWord, 1);
            Dec(st);
            if St >= 0 then
              Ch := GetCh(St);
          end;
        end;
      end;
    end;
  end;
end;

{----------------ThtmlViewer.HTMLMouseDblClk}

procedure ThtmlViewer.HTMLMouseDblClk(Message: TWMMouse);
var
  st, en: Integer;
  AWord: WideString;
begin
  FSectionList.LButtonDown(TRUE);
  if FViewerState * [vsProcessing, vsHotSpotAction] <> [] then
    Exit;
  if not FNoSelect and GetWordAtCursor(Message.XPos, Message.YPos, St, En, AWord) then
  begin
    FSectionList.SelB := st + 1;
    FSectionList.SelE := en;
    FCaretPos := st + 1;
    InvalidateRect(PaintPanel.Handle, NIL, TRUE);
  end;
  if Assigned(FOnMouseDouble) then
    with Message do
      FOnMouseDouble(Self, mbLeft, KeysToShiftState(Keys), XPos, YPos);
end;

procedure ThtmlViewer.DoHilite(X, Y: Integer);
var
  Curs, YR, YWin: Integer;
  XR, CaretHt: Integer;
  InText: boolean;
begin
  if (vsHiliting in FViewerState) and (Sel1 >= 0) then
    with FSectionList do
    begin
      YWin := Min(Max(0, Y), Height);
      Curs := FindCursor(PaintPanel.Canvas, X, YWin + YOff, XR, YR, CaretHt, InText);
      if (Curs >= 0) and not FNoSelect then
      begin
        if Curs > Sel1 then
        begin
          dec(Curs, ord(not InText));
          SelE := curs;
          SelB := Sel1;
          SellNeedAdjust := FALSE;
        end
        else
        begin
          SelB := Curs;
          SelE := Sel1;
        end;
        InvalidateRect(PaintPanel.Handle, NIL, TRUE);
      end;
      CaretPos := Curs;
    end;
end;

{----------------ThtmlViewer.WMMouseScroll}

procedure ThtmlViewer.WMMouseScroll(var Message: TMessage);
const
  Ticks: DWord = 0;
var
  Pos: Integer;
  Pt: TPoint;
begin
  GetCursorPos(Pt);
  Ticks := 0;
  with VScrollBar do
  begin
    Pt := PaintPanel.ScreenToClient(Pt);
    while (vsMouseScrolling in FViewerState) and
      ((vsLeftButtonDown in FViewerState) and ((Pt.Y <= 0) or (Pt.Y > Self.Height))) or
      ((vsMiddleScrollOn in FViewerState) and (Abs(Pt.Y - MiddleY) > ScrollGap)) do
    begin
      //BG, 23.10.2010; Issue 34: Possible to get AV in THtmlViewer.WMMouseScroll
      // What steps will reproduce the problem?
      //  1. Code enters THtmlViewer.WMMouseScroll (due to scrolling)
      //  2. That code contains a bad busy-loop and calls to Application.ProcessMessages
      //  3. The calls to Application.ProcessMessages could cause the component and fields in it to be freed.
      //  4. Next time in the loop when FSectionList.SetYOffset(Pos) is called FSectionList is nil and it crashes with an AV
      // Thus stop looping, if document (FSectionList) has been nilled:
      if FSectionList = NIL then
        break;
      if GetTickCount > Ticks + 100 then
      begin
        Ticks := GetTickCount;
        if vsLeftButtonDown in FViewerState then
        begin
          if Pt.Y < -15 then
            Pos := Position - Integer(SmallChange * 8)
          else
          if Pt.Y <= 0 then
            Pos := Position - SmallChange
          else
          if Pt.Y > Self.Height + 15 then
            Pos := Position + Integer(SmallChange * 8)
          else
            Pos := Position + SmallChange;
        end
        else
        begin   {MiddleScrollOn}
          Pos := Pt.Y - MiddleY;
          if Pos > 0 then
          begin
            Dec(Pos, ScrollGap - 4);
            PaintPanel.Cursor := DownOnlyCursor;
          end
          else
          begin
            Inc(Pos, ScrollGap - 4);
            PaintPanel.Cursor := UpOnlyCursor
        end;
          Pos := Position + Pos div 4;
        end;
        Pos := Math.Max(0, Math.Min(Pos, FMaxVertical - PaintPanel.Height));
        FSectionList.SetYOffset(Pos);
        SetPosition(Pos);
        DoHilite(Pt.X, Pt.Y);
        PaintPanel.Invalidate;
        GetCursorPos(Pt);
        Pt := PaintPanel.ScreenToClient(Pt);
      end;
      Application.ProcessMessages;
      Application.ProcessMessages;
      Application.ProcessMessages;
      Application.ProcessMessages;
    end;
  end;
  Exclude(FViewerState, vsMouseScrolling);
  if vsMiddleScrollOn in FViewerState then
    PaintPanel.Cursor := UpDownCursor;
end;

function ThtmlViewer.PositionTo(Dest: string;{AlekID}vcenter: boolean = FALSE{/AlekID}): boolean;
var
  I: Integer;
  Obj: TObject;
begin
  Result := FALSE;
  if Dest = '' then
    Exit;
  if Dest[1] = '#' then
    System.Delete(Dest, 1, 1);
  I := FNameList.IndexOf(UpperCase(Dest));
  if I > -1 then
  begin
    Obj := FNameList.Objects[I];
    if (Obj is TIDObject) then
      ScrollTo(TIDObject(Obj).YPosition - (ord(vcenter) * PaintPanel.Height div 2));

    HScrollBar.Position := 0;
    Result := TRUE;
    AddVisitedLink(FCurrentFile + '#' + Dest);
  end;
end;

function THtmlViewer.GetURL(X, Y: Integer; var UrlTarg: TUrlTarget; var FormControl: TIDObject {TImageFormControlObj}; var ATitle: string): guResultType;
begin
  Result := FSectionList.GetURL(PaintPanel.Canvas, X, Y + FSectionList.YOff,
    UrlTarg, FormControl, ATitle);
end;

//BG, 25.11.2010: C++Builder fails handling enumeration indexed properties
////-- BG ---------------------------------------------------------- 23.11.2010 --
//function THtmlViewer.GetViewerStateBit(Index: THtmlViewerStateBit): Boolean;
//begin
//  Result := Index in FViewerState;
//end;

//-- BG ---------------------------------------------------------- 23.11.2010 --
procedure THtmlViewer.SetViewerStateBit(Index: THtmlViewerStateBit; Value: Boolean);
begin
  if Value then
    Include(FViewerState, Index)
  else
    Exclude(FViewerState, Index);
end;

procedure THTMLViewer.SetViewImages(Value: boolean);
var
  OldPos: Integer;
  OldCursor: TCursor;
begin
  if vsProcessing in FViewerState then
    exit;
  if Value <> FSectionList.ShowImages then
  begin
    OldCursor := Screen.Cursor;
    try
      Screen.Cursor := crHourGlass;
      SetProcessing(TRUE);
      FSectionList.ShowImages := Value;
      if FSectionList.Count > 0 then
      begin
        FSectionList.GetBackgroundBitmap;    {load any background bitmap}
        OldPos := Position;
        DoLogic;
        Position := OldPos;
        Invalidate;
      end;
    finally
      Screen.Cursor := OldCursor;
      SetProcessing(FALSE);
    end;
  end;
end;

{----------------ThtmlViewer.InsertImage}

function ThtmlViewer.InsertImage(const Src: string; Stream: TMemoryStream): boolean;
var
  OldPos: Integer;
  ReFormat: boolean;
begin
  Result := FALSE;
  if vsProcessing in FViewerState then
    Exit;
  try
    SetProcessing(TRUE);
    FSectionList.InsertImage(Src, Stream, Reformat);
    FSectionList.GetBackgroundBitmap;     {in case it's the one placed}
    if Reformat then
      if FSectionList.Count > 0 then
      begin
        FSectionList.GetBackgroundBitmap;    {load any background bitmap}
        OldPos := Position;
        DoLogic;
        Position := OldPos;
      end;
    Invalidate;
  finally
    SetProcessing(FALSE);
    Result := TRUE;
  end;
end;

function THTMLViewer.GetBase: string;
begin
  Result := FBase;
end;

procedure THTMLViewer.SetBase(Value: string);
begin
  FBase := Value;
  FBaseEx := Value;
end;

function THTMLViewer.GetBaseTarget: string;
begin
  Result := FBaseTarget;
end;

function THTMLViewer.GetTitle: string;
begin
  Result := FTitle;
end;

function THTMLViewer.GetCurrentFile: string;
begin
  Result := FCurrentFile;
end;

function THTMLViewer.GetViewImages: boolean;
begin
  Result := FSectionList.ShowImages;
end;

procedure THtmlViewer.SetDefBackground(Value: TColor);
begin
  if vsProcessing in FViewerState then
    Exit;
  FBackground := Value;
  FSectionList.Background := Value;
  PaintPanel.Color := Value;
  Invalidate;
end;

procedure THTMLViewer.SetBorderStyle(Value: THTMLBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    DrawBorder;
  end;
end;

procedure ThtmlViewer.KeyDown(var Key: Word; Shift: TShiftState);
var
  Pos: Integer;
  OrigPos: Integer;
  TheChange: Integer;
begin
  inherited KeyDown(Key, Shift);

  if vsMiddleScrollOn in FViewerState then
  begin
    Exclude(FViewerState, vsMiddleScrollOn);
    PaintPanel.Cursor := Cursor;
    Exit;
  end;
  with VScrollBar do
    begin
      Pos := Position;
      OrigPos := Pos;
      case Key of

        VK_PRIOR:
        if Shift = [] then
          Dec(Pos, LargeChange);

        VK_NEXT:
        if Shift = [] then
          Inc(Pos, LargeChange);

        VK_UP:
        if Shift = [] then
          Dec(Pos, SmallChange);

        VK_DOWN:
        if Shift = [] then
          Inc(Pos, SmallChange);

        VK_Home:
        if Shift = [ssCtrl] then
          Pos := 0;

        VK_End:
        if Shift = [ssCtrl] then
          Pos := FMaxVertical;

      VK_SPACE:
        if Shift = [] then
          Inc(Pos, LargeChange)
        else
        if Shift = [ssShift] then
          Dec(Pos, LargeChange);
      end;
      if Pos < 0 then
        Pos := 0;
    Pos := Math.Max(0, Math.Min(Pos, FMaxVertical - PaintPanel.Height));

    if Pos <> OrigPos then
    begin
      Position := Pos;
      FSectionList.SetYOffset(Pos);

      TheChange := OrigPos - Pos;
      if not (vsBGFixed in FViewerState) and (abs(TheChange) = SmallChange) then
      begin  {update only the scrolled part}
        ScrollWindow(PaintPanel.Handle, 0, TheChange, NIL, NIL);
        PaintPanel.Update;
      end
      else
        PaintPanel.Invalidate;
    end;
    end;

  with HScrollBar do
    begin
      Pos := Position;
    OrigPos := Pos;
      case Key of
        VK_LEFT:
        if Shift = [] then
          Dec(Pos, SmallChange);

        VK_RIGHT:
        if Shift = [] then
          Inc(Pos, SmallChange);
      end;
      if Pos < 0 then
        Pos := 0;
    Pos := Math.Min(Pos, Max - PaintPanel.Width);

    if Pos <> OrigPos then
    begin
      Position := Pos;
      PaintPanel.Invalidate;
    end;
end;
end;

procedure ThtmlViewer.WMGetDlgCode(var Message: TMessage);
begin
  Message.Result := DLGC_WantArrows;  {else don't get the arrow keys}
end;

function ThtmlViewer.GetPosition: Integer;
var
  Index: Integer;
  TopPos, Pos: Integer;
  S: TSectionBase;
begin
  Pos := Integer(VScrollBar.Position);
  S := FSectionList.FindSectionAtPosition(Pos, TopPos, Index);
  if Assigned(S) then
    Result := Integer(Index + 1) shl 16 + ((Pos - TopPos) and $FFFF)
  else
    Result := Pos;
{Hiword is section # plus 1, Loword is displacement from top of section
 HiWord = 0 is top of display}
end;

procedure ThtmlViewer.SetPosition(Value: Integer);
var
  TopPos: Integer;
begin
  if HiWord(Value) = 0 then
    ScrollTo(LoWord(Value))
  else
  if (Hiword(Value) - 1 < FSectionList.PositionList.Count) then
  begin
    TopPos := TSectionBase(FSectionList.PositionList[HiWord(Value) - 1]).YPosition;
    ScrollTo(TopPos + LoWord(Value));
  end;
end;

function ThtmlViewer.GetScrollPos: Integer;
begin
  Result := VScrollBar.Position;
end;

procedure ThtmlViewer.SetScrollPos(Value: Integer);
begin
  if Value < 0 then
    Value := 0;
  Value := Min(Value, FMaxVertical - PaintPanel.Height);
  if Value <> GetScrollPos then
    ScrollTo(Value);
end;

function ThtmlViewer.GetScrollBarRange: Integer;
begin
  Result := FMaxVertical - PaintPanel.Height;
end;

function ThtmlViewer.GetHScrollPos: Integer;
begin
  Result := HScrollBar.Position;
end;

procedure ThtmlViewer.SetHScrollPos(Value: Integer);
begin
  if Value < 0 then
    Value := 0;
  Value := Min(Value, HScrollBar.Max - PaintPanel.Width);
  HScrollbar.Position := Value;
  Invalidate;
end;

function ThtmlViewer.GetHScrollBarRange: Integer;
begin
  Result := HScrollBar.Max - PaintPanel.Width;
end;

function ThtmlViewer.GetPalette: HPALETTE;
begin
  if ThePalette <> 0 then
    Result := ThePalette
  else
    Result := inherited GetPalette;
  Invalidate;
end;

function ThtmlViewer.HTMLExpandFilename(const Filename: string): string;
begin
{pass http: and other protocols except for file:///}
  if (Pos('://', Filename) > 1) and (Pos('file://', Lowercase(Filename)) = 0) then
    Result := Filename
  else
  begin
    Result := HTMLServerToDos(Filename, FServerRoot);
    if Pos('\', Result) = 1 then
      Result := ExpandFilename(Result)
    else
    if (Pos(':', Result) <> 2) and (Pos('\\', Result) <> 1) then
      if CompareText(FBase, 'DosPath') = 0 then  {let Dos find the path}
      else
      if FBase <> '' then
        Result := CombineDos(HTMLToDos(FBase), Result)
      else
        Result := ExpandFilename(ExtractFilePath(FCurrentFile) + Result);
  end;

  //BG, 19.09.2010: Issue 7: Slow UNC Lookups for Images
  //  An event allows to modify the resulting filename:
  if assigned(FOnFilenameExpanded) then
    FOnFilenameExpanded(self, Result);
end;

{----------------ThtmlViewer.BumpHistory}

procedure ThtmlViewer.BumpHistory(const FileName, Title: string; OldPos: Integer; OldFormData: TFreeList; ft: ThtmlFileType);
var
  I: Integer;
  PO: PositionObj;
  SameName: boolean;
begin
  SameName := FileName = FCurrentFile;
  if (FHistoryMaxCount > 0) and (FCurrentFile <> '') and
    ((not SameName) or (FCurrentFileType <> ft) or (OldPos <> Position)) then
    with FHistory do
    begin
      if (Count > 0) and (Filename <> '') then
      begin
        Strings[FHistoryIndex] := Filename;
        with PositionObj(FPositionHistory[FHistoryIndex]) do
        begin
          Pos := OldPos;
          FileType := ft;
          if not SameName then  {only stored when documents changed}
            FormData := OldFormData
          else
            OldFormData.Free;
        end;
        FTitleHistory[FHistoryIndex] := Title;
        for I := 0 to FHistoryIndex - 1 do
        begin
          Delete(0);
          FTitleHistory.Delete(0);
          PositionObj(FPositionHistory[0]).Free;
          FPositionHistory.Delete(0);
        end;
      end;
      FHistoryIndex := 0;
      Insert(0, FCurrentFile);
      PO := PositionObj.Create;
      PO.Pos := Position;
      PO.FileType := FCurrentFileType;
      FPositionHistory.Insert(0, PO);
      FTitleHistory.Insert(0, FTitle);
      if Count > FHistoryMaxCount then
      begin
        Delete(FHistoryMaxCount);
        FTitleHistory.Delete(FHistoryMaxCount);
        PositionObj(FPositionHistory[FHistoryMaxCount]).Free;
        FPositionHistory.Delete(FHistoryMaxCount);
      end;
      if Assigned(FOnHistoryChange) then
        FOnHistoryChange(Self);
    end
  else
    OldFormData.Free;
end;

procedure ThtmlViewer.SetHistoryIndex(Value: Integer);
var
  I: Integer;

  function GetLowestSameFileIndex(Start: Integer): Integer;
  begin
    Result := Start;
    while (Result > 0) and (FHistory[Result - 1] = FCurrentFile) do
      Dec(Result);
  end;
begin
  if vsProcessing in FViewerState then
    exit;
  with FHistory do
    if (Value <> FHistoryIndex) and (Value >= 0) and (Value < Count) then
    begin
      if FCurrentFile <> '' then
      begin          {save the current information}
        Strings[FHistoryIndex] := FCurrentFile;
        with PositionObj(FPositionHistory[FHistoryIndex]) do
        begin
          Pos := Position;
          FileType := FCurrentFileType;
          I := GetLowestSameFileIndex(FHistoryIndex);
          PositionObj(FPositionHistory[I]).FormData := GetFormData;
        end;
        FTitleHistory[FHistoryIndex] := FTitle;
      end;
      with PositionObj(FPositionHistory[Value]) do
      begin                 {reestablish the new desired history position}
        if (FCurrentFile <> Strings[Value]) or (FCurrentFileType <> FileType) then
          Self.LoadFile(Strings[Value], FileType);
        Position := Pos;
        I := GetLowestSameFileIndex(Value);
        with PositionObj(FPositionHistory[I]) do
        begin
          SetFormData(FormData);    {reload the forms if any}
          FormData.Free;
          FormData := NIL;
        end;
      end;
      FHistoryIndex := Value;
      if Assigned(FOnHistoryChange) then
        FOnHistoryChange(Self);
    end;
end;

procedure ThtmlViewer.SetHistoryMaxCount(Value: Integer);
begin
  if (Value = FHistoryMaxCount) or (Value < 0) then
    Exit;
  if Value < FHistoryMaxCount then
    ClearHistory;
  FHistoryMaxCount := Value;
end;

procedure ThtmlViewer.ClearHistory;
var
  CountWas: Integer;
begin
  CountWas := FHistory.Count;
  FHistory.Clear;
  FTitleHistory.Clear;
  FPositionHistory.Clear;
  FHistoryIndex := 0;
  FCurrentFile := '';
  if (CountWas > 0) and Assigned(FOnHistoryChange) then
    FOnHistoryChange(Self);
end;

function ThtmlViewer.GetPreFontName: TFontName;
begin
  Result := FPreFontName;
end;

procedure ThtmlViewer.SetPreFontName(Value: TFontName);
begin
  if CompareText(Value, FSectionList.PreFontName) <> 0 then
  begin
    FPreFontName := Value;
    FSectionList.PreFontName := Value;
  end;
end;

procedure ThtmlViewer.SetFontSize(Value: Integer);
begin
  FFontSize := Value;
end;

procedure ThtmlViewer.SetCharset(Value: TFontCharset);
begin
  FCharset := Value;
end;

function ThtmlViewer.GetFormControlList: TList;
begin
  Result := FSectionList.FormControlList;
end;

function ThtmlViewer.GetNameList: TStringList;
begin
  Result := FNameList;
end;

function ThtmlViewer.GetLinkList: TList;
begin
  Result := FSectionList.LinkList;
end;

function THTMLViewer.getMarginHeight: Integer;
begin
  result := FMarginHeight;
end;
procedure THTMLViewer.__SetFileName(const fn:Utf8String);
begin
FCurrentFile:=fn;
end;

function THTMLViewer.getMarginWidth: Integer;
begin
  result := FMarginWidth;
end;

procedure ThtmlViewer.SetHotSpotColor(Value: TColor);
begin
  FHotSpotColor := Value;
  FSectionList.HotSpotColor := Value;
end;

procedure ThtmlViewer.SetVisitedColor(Value: TColor);
begin
  FVisitedColor := Value;
  FSectionList.LinkVisitedColor := Value;
end;

procedure ThtmlViewer.SetActiveColor(Value: TColor);
begin
  FOverColor := Value;
  FSectionList.LinkActiveColor := Value;
end;

procedure ThtmlViewer.SetVisitedMaxCount(Value: Integer);
var
  I: Integer;
begin
  Value := Max(Value, 0);
  if Value <> FVisitedMaxCount then
  begin
    FVisitedMaxCount := Value;
    if FVisitedMaxCount = 0 then
    begin
      Visited.Clear;
      for I := 0 to SectionList.LinkList.Count - 1 do
        TFontObj(LinkList[I]).Visited := FALSE;
      Invalidate;
    end
    else
    begin
      FVisitedMaxCount := Value;
      for I := Visited.Count - 1 downto FVisitedMaxCount do
        Visited.Delete(I);
    end;
  end;
end;

//-- BG ---------------------------------------------------------- 12.09.2010 --
function THtmlViewer.ShowFocusRect: Boolean;
begin
  Result := not (htNoFocusRect in htOptions);
end;

function ThtmlViewer.GetCursor: TCursor;
begin
  Result := inherited Cursor;
end;

procedure ThtmlViewer.SetCursor(Value: TCursor);
begin
  if Value = OldThickIBeamCursor then   {no longer used}
    Value := crIBeam;
{$ifdef LCL}
  inherited setCursor(Value);
{$else}
  inherited Cursor := Value;
{$endif}
end;

function ThtmlViewer.FullDisplaySize(FormatWidth: Integer): TSize;
var
  Curs: Integer;
  CopyList: TSectionList;
begin
  Result.cx := 0;  {error return}
  Result.cy := 0;
  if FormatWidth > 0 then
  begin
    CopyList := TSectionList.CreateCopy(FSectionList);
    try
      Curs := 0;
      Result.cy := CopyList.DoLogic(PaintPanel.Canvas, 0, FormatWidth, 300, 0, Result.cx, Curs);
    finally
      CopyList.Free;
    end;
  end;
end;

{----------------CalcBackgroundLocationAndTiling}

procedure CalcBackgroundLocationAndTiling(const PRec: PtPositionRec; ARect: TRect; XOff, YOff, IW, IH, BW, BH: Integer; var X, Y, X2, Y2: Integer);

{PRec has the CSS information on the background image, it's starting location and
 whether it is tiled in x, y, neither, or both.
 ARect is the cliprect, no point in drawing tiled images outside it.
 XOff, YOff are offsets which allow for the fact that the viewable area may not be at 0,0.
 IW, IH are the total width and height of the document if you could see it all at once.
 BW, BH are bitmap dimensions used to calc tiling.
 X, Y are the position (window coordinates) where the first background iamge will be drawn.
 X2, Y2 are tiling limits.  X2 and Y2 may be such that 0, 1, or many images will
   get drawn.  They're calculated so that only images within ARect are drawn.
}
var
  I: Integer;
  P: array[1..2] of Integer;
begin
{compute the location of the prime background image. Tiling can go either way
 from this image}
  P[1] := 0;  P[2] := 0;
  for I := 1 to 2 do   {I = 1 is X info, I = 2 is Y info}
    with PRec[I] do
    begin
      case PosType of
        pTop:
          P[I] := -YOff;
        pCenter:
          if I = 1 then
            P[1] := IW div 2 - BW div 2 - XOff
          else
            P[2] := IH div 2 - BH div 2 - YOff;
        pBottom:
          P[I] := IH - BH - YOff;
        pLeft:
          P[I] := -XOff;
        pRight:
          P[I] := IW - BW - XOff;
        PPercent:
          if I = 1 then
            P[1] := ((IW - BW) * Value) div 100 - XOff
          else
            P[2] := ((IH - BH) * Value div 100) - YOff;
        pDim:
          if I = 1 then
            P[I] := Value - XOff
          else
            P[I] := Value - YOff;
      end;
    end;

{Calculate the tiling keeping it within the cliprect boundaries}
  X := P[1];
  Y := P[2];
  if PRec[2].RepeatD then
  begin    {y repeat}
  {figure a starting point for tiling.  This will be less that one image height
   outside the cliprect}
    if Y < ARect.Top then
      Y := Y + ((ARect.Top - Y) div BH) * BH
    else
    if Y > ARect.Top then
      Y := Y - ((Y - ARect.Top) div BH) * BH - BH;
    Y2 := ARect.Bottom;
  end
  else
  begin   {a single image or row}
    Y2 := Y; {assume it's not in the cliprect and won't be output}
    if not ((Y > ARect.Bottom) or (Y + BH < ARect.Top)) then
      Inc(Y2); {it is in the clip rect, show it}
  end;
  if PRec[1].RepeatD then
  begin       {x repeat}
  {figure a starting point for tiling.  This will be less that one image width
   outside the cliprect}
    if X < ARect.Left then
      X := X + ((ARect.Left - X) div BW) * BW
    else
    if X > ARect.Left then
      X := X - ((X - ARect.Left) div BW) * BW - BW;
    X2 := ARect.Right;
  end
  else
  begin    {single image or column}
    X2 := X;  {assume it's not in the cliprect and won't be output}
    if not ((X > ARect.Right) or (X + BW < ARect.Left)) then
      Inc(X2); {it is in the clip rect, show it}
  end;
end;

{----------------DrawBackground}

procedure DrawBackground(ACanvas: TCanvas; ARect: TRect; XStart, YStart, XLast, YLast: Integer; Image: TGpObject; Mask: TBitmap; AniGif: TGifImage; BW, BH: Integer; BGColor: TColor);
{draw the background color and any tiled images on it}
{ARect, the cliprect, drawing outside this will not show but images may overhang
 XStart, YStart are first image position already calculated for the cliprect and parameters.
 XLast, YLast   Tiling stops here.
 BW, BH  bitmap dimensions.
}
var
  X, Y: Integer;
  OldBrush: HBrush;
  OldPal: HPalette;
  DC: HDC;
  OldBack, OldFore: TColor;
  Bitmap: TBitmap;
  {$IFNDEF NoGDIPlus}
  graphics: TGpGraphics;
  {$ENDIF NoGDIPlus}
begin
  DC := ACanvas.handle;
  if DC <> 0 then
  begin
    OldPal := SelectPalette(DC, ThePalette, FALSE);
    RealizePalette(DC);
    ACanvas.Brush.Color := BGColor or PalRelative;
    OldBrush := SelectObject(DC, ACanvas.Brush.Handle);
    OldBack := SetBkColor(DC, clWhite);
    OldFore := SetTextColor(DC, clBlack);
    try
      ACanvas.FillRect(ARect);   {background color}
      if Assigned(AniGif) then   {tile the animated gif}
      begin
        Y := YStart;
        while Y < YLast do
        begin
          X := XStart;
          while X < XLast do
          begin
            AniGif.Draw(ACanvas, X, Y, BW, BH);
            Inc(X, BW);
          end;
          Inc(Y, BH);
        end;
      end
      else
      if Assigned(Image) then   {tile the bitmap}
        if Image is TBitmap then
        begin
          Bitmap := TBitmap(Image);
          Y := YStart;
          while Y < YLast do
          begin
            X := XStart;
            while X < XLast do
            begin
              if Mask = NIL then
                BitBlt(DC, X, Y, BW, BH, Bitmap.Canvas.Handle, 0, 0, SRCCOPY)
              else
              begin
                BitBlt(dc, X, Y, BW, BH, Bitmap.Canvas.Handle, 0, 0, SrcInvert);
                BitBlt(dc, X, Y, BW, BH, Mask.Canvas.Handle, 0, 0, SrcAnd);
                BitBlt(dc, X, Y, BW, BH, Bitmap.Canvas.Handle, 0, 0, SrcPaint);
              end;
              Inc(X, BW);
            end;
            Inc(Y, BH);
          end;
        end
      {$ifndef NoMetafile}
        else
        if Image is ThtMetafile then
        begin
          Y := YStart;
          try
            while Y < YLast do
            begin
              X := XStart;
              while X < XLast do
              begin
                ACanvas.Draw(X, Y, ThtMetaFile(Image));
                Inc(X, BW);
              end;
              Inc(Y, BH);
            end;
          except
          end;
        end
{$ENDIF !NoMetafile}
{$IFNDEF NoGDIPlus}
        else
        begin
          Y := YStart;
          graphics := TGPGraphics.Create(DC);
          try
            while Y < YLast do
            begin
              X := XStart;
              while X < XLast do
              begin
                graphics.DrawImage(TGpImage(Image), X, Y, BW, BH);
                Inc(X, BW);
              end;
              Inc(Y, BH);
            end;
          except
          end;
          Graphics.Free;
        end;
{$ENDIF !NoGDIPlus}
    finally
      SelectObject(DC, OldBrush);
      SelectPalette(DC, OldPal, FALSE);
      RealizePalette(DC);
      SetBkColor(DC, OldBack);
      SetTextColor(DC, OldFore);
    end;
  end;
end;

{----------------ThtmlViewer.DrawBackground2}

procedure ThtmlViewer.DrawBackground2(ACanvas: TCanvas; ARect: TRect; XStart, YStart, XLast, YLast: Integer; Image: TGpObject; Mask: TBitmap; BW, BH: Integer; BGColor: TColor);
{Called by DoBackground2 (Print and PrintPreview)}
{draw the background color and any tiled images on it}
{ARect, the cliprect, drawing outside this will not show but images may overhang
 XStart, YStart are first image position already calculated for the cliprect and parameters.
 XLast, YLast   Tiling stops here.
 BW, BH  Image dimensions.
}
var
  X, Y: Integer;
  OldBrush: HBrush;
  OldPal: HPalette;
  DC: HDC;
  OldBack, OldFore: TColor;
  Bitmap: TBitmap;
begin
  DC := ACanvas.handle;
  if DC <> 0 then
  begin
    OldPal := SelectPalette(DC, ThePalette, FALSE);
    RealizePalette(DC);
    ACanvas.Brush.Color := BGColor or PalRelative;
    OldBrush := SelectObject(DC, ACanvas.Brush.Handle);
    OldBack := SetBkColor(DC, clWhite);
    OldFore := SetTextColor(DC, clBlack);
    try
      ACanvas.FillRect(ARect);   {background color}
      if Assigned(Image) then   {tile the Image}
        if Image is TBitmap then
        begin
          Bitmap := TBitmap(Image);
          Y := YStart;
          while Y < YLast do
          begin
            X := XStart;
            while X < XLast do
            begin
              if Mask = NIL then
                PrintBitmap(ACanvas, X, Y, BW, BH, Bitmap)
              else
              begin
                PrintTransparentBitmap3(ACanvas, X, Y, BW, BH, Bitmap, Mask, 0, Bitmap.Height);
              end;
              Inc(X, BW);
            end;
            Inc(Y, BH);
          end;
        end
      {$ifndef NoMetafile}
        else
        if Image is ThtMetafile then
        begin
          Y := YStart;
          try
            while Y < YLast do
            begin
              X := XStart;
              while X < XLast do
              begin
                ACanvas.Draw(X, Y, ThtMetaFile(Image));
                Inc(X, BW);
              end;
              Inc(Y, BH);
            end;
          except
          end;
        end
{$ENDIF !NoMetafile}
{$IFNDEF NoGDIPlus}
        else
        begin
          Y := YStart;
          try
            while Y < YLast do
            begin
              X := XStart;
              while X < XLast do
              begin
                StretchPrintGpImageOnColor(ACanvas, TGPImage(Image), X, Y, BW, BH, BGColor);
                Inc(X, BW);
              end;
              Inc(Y, BH);
            end;
          except
          end;
        end
        {$ENDIF !NoGDIPlus};
    finally
      SelectObject(DC, OldBrush);
      SelectPalette(DC, OldPal, FALSE);
      RealizePalette(DC);
      SetBkColor(DC, OldBack);
      SetTextColor(DC, OldFore);
    end;
  end;
end;

procedure ThtmlViewer.DoBackground1(ACanvas: TCanvas; ATop, AWidth, AHeight, FullHeight: Integer);
var
  ARect: TRect;
  Image: TGpObject;
  Mask: TBitmap;
  PRec: PtPositionRec;
  BW, BH, X, Y, X2, Y2, IW, IH, XOff, YOff: Integer;
  Fixed: boolean;
begin
  ARect := Rect(0, 0, AWidth, AHeight);
  Image := FSectionList.BackgroundBitmap;
  if FSectionList.ShowImages and Assigned(Image) then
  begin
    Mask := FSectionList.BackgroundMask;
    BW := GetImageWidth(Image);
    BH := GetImageHeight(Image);
    PRec := FSectionList.BackgroundPRec;
    Fixed := PRec[1].Fixed;
    if Fixed then
    begin  {fixed background}
      XOff := 0;
      YOff := 0;
      IW := AWidth;
      IH := AHeight;
    end
    else
    begin   {scrolling background}
      XOff := 0;
      YOff := ATop;
      IW := AWidth;
      IH := FullHeight;
    end;

  {Calculate where the tiled background images go}
    CalcBackgroundLocationAndTiling(PRec, ARect, XOff, YOff, IW, IH, BW, BH, X, Y, X2, Y2);

    DrawBackground(ACanvas, ARect, X, Y, X2, Y2, Image, Mask, NIL, BW, BH, PaintPanel.Color);
  end
  else
  begin  {no background image, show color only}
    DrawBackground(ACanvas, ARect, 0, 0, 0, 0, NIL, NIL, NIL, 0, 0, PaintPanel.Color);
  end;
end;

procedure ThtmlViewer.DoBackground2(ACanvas: TCanvas; ALeft, ATop, AWidth, AHeight: Integer; AColor: TColor);
{called by Print and PrintPreview}
var
  ARect: TRect;
  Image: TGpObject;
  Mask: TBitmap;
  PRec: PtPositionRec;
  BW, BH, X, Y, X2, Y2, IW, IH, XOff, YOff: Integer;
  NewBitmap, NewMask: TBitmap;
begin
  ARect := Rect(ALeft, ATop, ALeft + AWidth, ATop + AHeight);
  Image := FSectionList.BackgroundBitmap;
  if FSectionList.ShowImages and Assigned(Image) then
  begin
    Mask := FSectionList.BackgroundMask;
    BW := GetImageWidth(Image);
    BH := GetImageHeight(Image);
    PRec := FSectionList.BackgroundPRec;
    XOff := -ALeft;
    YOff := -ATop;
    IW := AWidth;
    IH := AHeight;

  {Calculate where the tiled background images go}
    CalcBackgroundLocationAndTiling(PRec, ARect, XOff, YOff, IW, IH, BW, BH, X, Y, X2, Y2);

    if (BW = 1) or (BH = 1) then
    begin  {this is for people who try to tile 1 pixel images}
      NewBitmap := EnlargeImage(Image, X2 - X, Y2 - Y);
      try
        if Assigned(Mask) then
          NewMask := TBitmap(EnlargeImage(Mask, X2 - X, Y2 - Y))
        else
          NewMask := NIL;
        try
          DrawBackground2(ACanvas, ARect, X, Y, X2, Y2, NewBitmap, NewMask, NewBitmap.Width, NewBitmap.Height, AColor);
        finally
          NewMask.Free;
        end;
      finally
        NewBitmap.Free;
      end;
    end
    else
      DrawBackground2(ACanvas, ARect, X, Y, X2, Y2, Image, Mask, BW, BH, AColor);
  end
  else
  begin  {no background image, show color only}
    DrawBackground2(ACanvas, ARect, 0, 0, 0, 0, NIL, NIL, 0, 0, AColor);
  end;
end;

type
  EExcessiveSizeError = class(Exception);

//-- BG ---------------------------------------------------------- 20.11.2010 --
// extracted from MakeBitmap() and MakeMetaFile()
procedure THtmlViewer.Draw(Canvas: TCanvas; YTop, FormatWidth, Width, Height: Integer);
var
  CopyList: TSectionList;
  Dummy: Integer;
  Curs: Integer;
  DocHeight: Integer;
begin
  CopyList := TSectionList.CreateCopy(FSectionList);
  try
    Curs := 0;
    DocHeight := CopyList.DoLogic(Canvas, 0, FormatWidth, Height, 300, Dummy, Curs);
    DoBackground1(Canvas, YTop, Width, Height, DocHeight);

    CopyList.SetYOffset(Max(0, YTop));
    CopyList.Draw(Canvas, Rect(0, 0, Width, Height), MaxHScroll, 0, 0, 0, 0);
  finally
    CopyList.Free;
  end;
end;

function THtmlViewer.MakeBitmap(YTop, FormatWidth, Width, Height: Integer): TBitmap;
begin
  Result := NIL;
  if (vsProcessing in FViewerState) or (FSectionList.Count = 0) then
    Exit;
  if Height > 4000 then
    raise EExcessiveSizeError.Create('Vertical Height exceeds 4000');
  Result := TBitmap.Create;
  try
    Result.HandleType := bmDIB;
    Result.PixelFormat := pf24Bit;
    Result.Width := Width;
    Result.Height := Height;
    Draw(Result.Canvas, YTop, FormatWidth, Width, Height);
  except
    Result.Free;
    raise;
    //Result := nil;
  end;
end;

{$ifndef LCL}

function THtmlViewer.MakeMetaFile(YTop, FormatWidth, Width, Height: Integer): TMetaFile;
var
  Canvas: TMetaFileCanvas;
begin
  Result := NIL;
  if (vsProcessing in FViewerState) or (FSectionList.Count = 0) then
    Exit;
  if Height > 4000 then
    raise EExcessiveSizeError.Create('Vertical Height exceeds 4000');
    Result := TMetaFile.Create;
    Result.Width := Width;
    Result.Height := Height;
    Canvas := TMetaFileCanvas.Create(Result, 0);
    try
    try
      Draw(Canvas, YTop, FormatWidth, Width, Height);
    except
      Result.Free;
      raise;
      //Result := nil;
    end;
  finally
    Canvas.Free;
  end;
end;

function ThtmlViewer.MakePagedMetaFiles(Width, Height: Integer): TList;
var
  ARect, CRect: TRect;
  CopyList: TSectionList;
  HTop, OldTop, Dummy, Curs, I: Integer;
  Done: boolean;
  VPixels: Integer;
  Canvas: TMetaFileCanvas;
  MF: TMetaFile;
  TablePart: TablePartType;
  SavePageBottom: Integer;
  hrgnClip1: hRgn;

  procedure PaintBackground(Canvas: TCanvas; Top, Bot: Integer);
  begin
    Canvas.Brush.Color := CopyList.Background;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(Rect(0, Top, Width + 1, Bot));
  end;
begin
  Done := FALSE;
  Result := NIL;
  TablePartRec := NIL;
  if (vsProcessing in FViewerState) or (SectionList.Count = 0) then
    Exit;
  CopyList := TSectionList.CreateCopy(SectionList);
  try
    CopyList.NoOutput := FALSE;
    CopyList.Printing := TRUE;
    CopyList.LinkDrawnEvent := FOnLinkDrawn;
    Result := TList.Create;
    try
      HTop := 0;
      OldTop := 0;
      Curs := 0;
      VPixels := 0;
      ARect := Rect(0, 0, Width, Height);
      while not Done do
      begin
        MF := TMetaFile.Create;
        try
          MF.Width := Width;
          MF.Height := Height;
          Canvas := TMetaFileCanvas.Create(MF, 0);
          try
            if HTop = 0 then  {DoLogic the first time only}
              VPixels := CopyList.DoLogic(Canvas, 0, Width, Height, 0, Dummy, Curs);
            CopyList.SetYOffset(HTop);
            PaintBackground(Canvas, 0, Height);

            repeat
              if Assigned(TablePartRec) then
                TablePart := TablePartRec.TablePart
              else
                TablePart := Normal;
              case TablePart of
                Normal:
                begin
                  CopyList.Draw(Canvas, ARect, Width, 0, 0, 0, 0);
                  PaintBackground(Canvas, CopyList.PageBottom - HTop, Height + 1);
                end;
                DoHead:
                begin
                  CopyList.SetYOffset(TablePartRec.PartStart);
                  CRect := ARect;
                  CRect.Bottom := CRect.Top + TablePartRec.PartHeight;
                  hrgnClip1 := CreateRectRgn(0, 0, Width + 1, CRect.Bottom);
                  SelectClipRgn(Canvas.Handle, hrgnClip1);
                  DeleteObject(hrgnClip1);
                  CopyList.Draw(Canvas, CRect, Width, 0, 0, 0, 0);
                end;
                DoBody1, DoBody3:
                begin
                  CRect := ARect;
                  CRect.Top := CopyList.PageBottom - 1 - CopyList.YOff;
                  CopyList.SetYOffset(TablePartRec.PartStart - CRect.top);
                  CopyList.Draw(Canvas, CRect, Width, 0 + 3 * Width, 0, 0, 0);      {off page}

                  TablePartRec.TablePart := DoBody2;
                  CRect.Bottom := CopyList.PageBottom - CopyList.YOff + 1;
                  hrgnClip1 := CreateRectRgn(0, CRect.Top, Width + 1, CRect.Bottom);
                  SelectClipRgn(Canvas.Handle, hrgnClip1);
                  DeleteObject(hrgnClip1);
                  CopyList.Draw(Canvas, CRect, Width, 0, 0, 0, 0);      {onpage}
                  if not Assigned(TablePartRec) or not (TablePartRec.TablePart in [Normal]) then
                    PaintBackground(Canvas, CopyList.PageBottom - CopyList.YOff, Height + 1);
                end;
                DoFoot:
                begin
                  SavePageBottom := CopyList.PageBottom;
                  CRect := ARect;
                  CRect.Top := CopyList.PageBottom - CopyList.YOff;
                  CRect.Bottom := CRect.Top + TablePartRec.PartHeight;
                  hrgnClip1 := CreateRectRgn(0, CRect.Top, Width + 1, CRect.Bottom);
                  SelectClipRgn(Canvas.Handle, hrgnClip1);
                  DeleteObject(hrgnClip1);
                  CopyList.SetYOffset(TablePartRec.PartStart - CRect.top);
                  CopyList.Draw(Canvas, CRect, Width, 0, 0, 0, 0);
                  CopyList.PageBottom := SavePageBottom;
                end;
              end;
            until not Assigned(TablePartRec) or (TablePartRec.TablePart in [Normal, DoHead, DoBody3]);
          finally
            Canvas.Free;
          end;
        except
          MF.Free;
          raise;
        end;
        Result.Add(MF);
        HTop := CopyList.PageBottom;
        Inc(CopyList.LinkPage);
        Application.ProcessMessages;
        if (HTop >= VPixels) or (HTop <= OldTop) then  {see if done or endless loop}
          Done := TRUE;
        OldTop := HTop;
      end;
    except
      for I := 0 to Result.Count - 1 do
        TMetaFile(Result.Items[I]).Free;
      FreeAndNil(Result);
      raise;
    end;
  finally
    CopyList.Free;
  end;
end;

{$endif}

function ThtmlViewer.CreateHeaderFooter: ThtmlViewer;
begin
{
  was: Result := THtmlViewer.Create(Nil);

  If the html viewer itself is invisible and created parented this would
  break. Better create the header and footer parented to support background
  preparation.

  2008-May-26 by Arvid Winkelsdorf
}
  Result := THtmlViewer.CreateParented(HWND(HWND_MESSAGE));
  Result.Visible := FALSE;
  Result.Parent := Parent;
  Result.DefBackground := DefBackground;
  Result.DefFontName := DefFontName;
  Result.DefFontSize := DefFontSize;
  Result.DefFontColor := DefFontColor;
  Result.CharSet := Charset;
  Result.MarginHeight := 0;
  with Result.FSectionList do
  begin
    PrintBackground := TRUE;
    PrintTableBackground := TRUE;
  end;
end;

{-$ifndef FPC_TODO_PRINTING}
procedure ThtmlViewer.Print(FromPage, ToPage: Integer);
var
  ARect, CRect: TRect;
  PrintList: TSectionList;
  P1 {=XDpi}, P2 {=WDpi}, P3 {=YDpi}, W, H, HTop, OldTop, Dummy: Integer;
  Curs: Integer;
  Done: boolean;
  DC: HDC;
  PrinterOpen: boolean;

  UpperLeftPagePoint, { these will contain Top/Left and Bottom/Right unprintable area}
  LowerRightPagePoint: TPoint;
  MLeft: Integer;
  MLeftPrn: Integer;
  MRightPrn: Integer;
  MTopPrn: Integer;
  MBottomPrn: Integer;
  TopPixels, TopPixelsPrn, HPrn, WPrn: Integer;
  hrgnClip, hrgnClip1: THandle;
  savedFont: TFont;
  savedPen: TPen;
  savedBrush: TBrush;
  Align, ScaledPgHt, ScaledPgWid, VPixels: Integer;
  FootViewer, HeadViewer: ThtmlViewer;

  DeltaMarginTop: Double;
  SavePrintMarginTop: Double;
  DeltaPixelsPrn: Integer;
  DeltaPixels: Integer;
  OrigTopPixels: Integer;
  OrigTopPixelsPrn: Integer;
  OrigHprn: Integer;
  OrigH: Integer;
  LastPrintMarginTop: Double;
  MLeftSide: Integer;
  TablePart: TablePartType;
  SavePageBottom: Integer;

  procedure SaveCanvasItems(Canvas: TCanvas);
  begin { preserve current settings of the Canvas}
    SavedPen.Assign(Canvas.Pen);
    SavedFont.Assign(Canvas.Font);
    SavedBrush.Assign(Canvas.Brush);
  end;

  procedure RestoreCanvasItems(Canvas: TCanvas);
  begin { restore initial Canvas settings }
    Canvas.Pen.Assign(SavedPen);
    Canvas.Font.Assign(SavedFont);
    Canvas.Brush.Assign(SavedBrush);
  end;

//BG, 01.12.2006: beg of modification
var
  HPages: Integer;
  HPageIndex: Integer;
  ScrollWidth: Integer;
  XOrigin: Integer;
//BG, 01.12.2006: end of modification

  procedure WhiteoutArea(Canvas: TCanvas; Y: Integer);
  {White out excess printing.  Y is top of the bottom area to be blanked.}
  begin
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Color := clWhite;
    Canvas.Rectangle(MLeft, 0, W + MLeft + 1, TopPixels - 1);
    Canvas.Rectangle(MLeft, Y, W + MLeft + 1, TopPixels + H + 1);
    if (htPrintBackground in FOptions) and (Y - TopPixels < H) then
    begin   {need to reprint background in whited out area}
      hrgnClip1 := CreateRectRgn(MLeftPrn, MulDiv(Y, P3, P2) - 2,
        MLeftPrn + WPrn, TopPixelsPrn + HPrn);
      SelectClipRgn(Canvas.Handle, hrgnClip1);
      DeleteObject(hrgnClip1);
//BG, 01.12.2006: beg of modification
      DoBackground2(Canvas, MLeft + XOrigin, TopPixels, W, H, PaintPanel.Color);
//BG, 01.12.2006: end of modification
    end;
    RestoreCanvasItems(Canvas);
  end;

  procedure DoHTMLHeaderFooter(Footer: boolean; Event: ThtmlPagePrinted; HFViewer: ThtmlViewer);
  var
    YOrigin, YOff, Ht: Integer;
    HFCopyList: TSectionList;
    BRect: TRect;
    DocHeight, XL, XR: Integer;
  begin
    if not Assigned(Event) then
      Exit;
    try
      XL := MLeft;
      XR := MLeft + W;
      Event(Self, HFViewer, FPage, PrintList.PageBottom > VPixels, XL, XR, Done);  {call event handler}
      HFCopyList := TSectionList.CreateCopy(HFViewer.SectionList);
      try
        HFCopyList.Printing := TRUE;
        HFCopyList.ScaleX := fScaleX;
        HFCopyList.ScaleY := fScaleY;
        Curs := 0;
        DocHeight := HFCopyList.DoLogic(vwP.Canvas, 0, XR - XL, 300, 0, Dummy, Curs);
        if not Footer then
        begin  {Header}
          YOrigin := 0;
          Ht := TopPixels;
          YOff := DocHeight - TopPixels;
        end
        else
        begin   {Footer}
          YOrigin := -(TopPixels + H);
          Ht := Min(ScaledPgHt - (TopPixels + H), DocHeight);
          YOff := 0;
        end;
        SetWindowOrgEx(DC, 0, YOrigin, NIL);
        HFViewer.DoBackground2(vwP.Canvas, XL, -YOff, XR - XL, DocHeight, HFViewer.PaintPanel.Color);
        HFCopyList.SetYOffset(YOff);
        BRect := Rect(XL, 0, XR, Ht);
        HFCopyList.Draw(vwP.Canvas, BRect, XR - XL, XL, 0, 0, 0);
      finally
        HFCopyList.Free;
      end;
    except
    end;
  end;
begin
  Done := FALSE;
  FootViewer := NIL;
  HeadViewer := NIL;
//BG, 01.12.2006: beg of modification
  if assigned(FOnPrinting) then
    FOnPrinting(self, Done);
  if Done then
    exit;
//BG, 01.12.2006: end of modification
  TablePartRec := NIL;
  if Assigned(FOnPageEvent) then
    FOnPageEvent(Self, 0, Done);
  FPage := 0;
  if (vsProcessing in FViewerState) or (FSectionList.Count = 0) then
    Exit;
  PrintList := TSectionList.CreateCopy(FSectionList);
  PrintList.SetYOffset(0);
  SavePrintMarginTop := FPrintMarginTop;
  try
    savedFont := TFont.Create;
    savedPen := TPen.Create;
    savedBrush := TBrush.Create;
    try
      PrintList.Printing := TRUE;
      PrintList.SetBackground(clWhite);
      if not assigned(vwP) then
      begin
        vwP := TvwPrinter.Create;
        OldPrinter := vwSetPrinter(vwP);
        PrinterOpen := FALSE;
      end
      else
        PrinterOpen := TRUE;
      FPage := 1;
      hrgnClip := 0;
      try
        with vwP do
        begin
          if (DocumentTitle <> '') then
            vwP.Title := DocumentTitle;
          if not Printing then
            BeginDoc
          else
            NewPage;
          SaveCanvasItems(Canvas);
          DC := Canvas.Handle;
          P3 := GetDeviceCaps(DC, LOGPIXELSY);
          P1 := GetDeviceCaps(DC, LOGPIXELSX);
          P2 := Round(Screen.PixelsPerInch * FPrintScale);
          fScaleX := 100.0 / P3;
          fScaleY := 100.0 / P1;
          PrintList.ScaleX := fScaleX;
          PrintList.ScaleY := fScaleY;
          SetMapMode(DC, mm_AnIsotropic);
          SetWindowExtEx(DC, P2, P2, NIL);
          SetViewPortExtEx(DC, P1, P3, NIL);


        { calculate the amount of space that is non-printable }

{$ifdef LCL}
          LowerRightPagePoint.X := Printer.PaperSize.PaperRect.WorkRect.Right;
          LowerRightPagePoint.Y := Printer.PaperSize.PaperRect.WorkRect.Bottom;
          UpperLeftPagePoint.X := Printer.PaperSize.PaperRect.WorkRect.Left;
          UpperLeftPagePoint.Y := Printer.PaperSize.PaperRect.WorkRect.Top;
{$else}
        { get PHYSICAL page width }
          LowerRightPagePoint.X := GetDeviceCaps(Printer.Handle, PhysicalWidth);
          LowerRightPagePoint.Y := GetDeviceCaps(Printer.Handle, PhysicalHeight);
        { get upper left physical offset for the printer... ->
          printable area <> paper size }
          UpperLeftPagePoint.X := GetDeviceCaps(Printer.Handle, PhysicalOffsetX);
          UpperLeftPagePoint.Y := GetDeviceCaps(Printer.Handle, PhysicalOffsetY);

              { now compute a complete unprintable area rectangle
               (composed of 2*width, 2*height) in pixels...}
          with LowerRightPagePoint do
          begin
            Y := Y - Printer.PageHeight;
            X := X - Printer.PageWidth;
          end;


        { now that we know the TOP and LEFT offset we finally can
          compute the BOTTOM and RIGHT offset: }
          with LowerRightPagePoint do
          begin
            x := x - UpperLeftPagePoint.x;
          { we don't want to have negative values}
            if x < 0 then
              x := 0; { assume no right printing offset }

            y := y - UpperLeftPagePoint.y;
          { we don't want to have negative values}
            if y < 0 then
              y := 0; { assume no bottom printing offset }
          end;
{$endif}
        { which results in LowerRightPoint containing the BOTTOM
          and RIGHT unprintable
          area offset; using these we modify the (logical, true)
          borders...}

          MLeftPrn := trunc(FPrintMarginLeft / 2.54 * P1);
          MLeftPrn := MLeftPrn - UpperLeftPagePoint.x; { subtract physical offset }
          MLeft := MulDiv(MLeftPrn, P2, P1);

          MRightPrn := trunc(FPrintMarginRight / 2.54 * P1);
          MRightPrn := MRightPrn - LowerRightPagePoint.x; { subtract physical offset }

          WPrn := PageWidth - (MLeftPrn + MRightPrn);

          W := MulDiv(WPrn, P2, P1);

          MTopPrn := trunc(FPrintMarginTop / 2.54 * P3);
          MTopPrn := MTopPrn - UpperLeftPagePoint.y; { subtract physical offset }

          MBottomPrn := trunc(FPrintMarginBottom / 2.54 * P3);
          MBottomPrn := MBottomPrn - LowerRightPagePoint.y; { subtract physical offset }

          TopPixelsPrn := MTopPrn;
          TopPixels := MulDiv(TopPixelsPrn, P2, P3);

          HPrn := PageHeight - (MTopPrn + MBottomPrn);
          H := MulDiv(HPrn, P2, P3);  {scaled pageHeight}

          Curs := 0;
//BG, 01.12.2006: beg of modification
          VPixels := PrintList.DoLogic(Canvas, 0, W, H, 0, {Dummy} ScrollWidth, Curs);
//BG, 01.12.2006: end of modification

          Done := FALSE;
          HTop := 0;
          OldTop := 0;
          ScaledPgHt := MulDiv(PageHeight, P2, P3);
          ScaledPgWid := MulDiv(PageWidth, P2, P3);
          hrgnClip := CreateRectRgn(MLeftPrn, TopPixelsPrn - 1, WPrn + MLeftPrn + 2,
            TopPixelsPrn + HPrn + 2);
          Application.ProcessMessages;
          if Assigned(FOnPageEvent) then
            FOnPageEvent(Self, FPage, Done);
          ARect := Rect(MLeft, TopPixels, W + MLeft, TopPixels + H);

          if Assigned(FOnPrintHTMLHeader) then
            HeadViewer := CreateHeaderFooter;
          if Assigned(FOnPrintHTMLFooter) then
            FootViewer := CreateHeaderFooter;

          OrigTopPixels := TopPixels;
          OrigTopPixelsPrn := TopPixelsPrn;
          OrigHPrn := HPrn;
          OrigH := H;
          LastPrintMarginTop := FPrintMarginTop;

//BG, 01.12.2006: beg of modification
          HPages := ceil(ScrollWidth / W);
//BG, 01.12.2006: end of modification
          while (FPage <= ToPage) and not Done do
          begin
            PrintList.SetYOffset(HTop - TopPixels);
            SetMapMode(DC, mm_AnIsotropic);
            SetWindowExtEx(DC, P2, P2, NIL);
            SetViewPortExtEx(DC, P1, P3, NIL);
//BG, 01.12.2006: beg of modification
          {SetWindowOrgEx(DC, 0, 0, Nil);}
//BG, 01.12.2006: end of modification
            SelectClipRgn(DC, hrgnClip);

//BG, 01.12.2006: beg of modification
            for HPageIndex := 0 to HPages - 1 do
            begin
              XOrigin := HPageIndex * W;
              SetWindowOrgEx(DC, XOrigin, 0, NIL);
//BG, 01.12.2006: end of modification
            if FPage >= FromPage then
            begin
              if (htPrintBackground in FOptions) then
//BG, 01.12.2006: beg of modification
                  DoBackground2(Canvas, MLeft + XOrigin, TopPixels, W, H, PaintPanel.Color);
//BG, 01.12.2006: end of modification
              MLeftSide := MLeft;
            end
              else
                MLeftSide := MLeft + 3 * W; {to print off page}

            repeat
              if Assigned(TablePartRec) then
                TablePart := TablePartRec.TablePart
                else
                  TablePart := Normal;
              case TablePart of
                Normal:
                begin
                  PrintList.Draw(Canvas, ARect, W, MLeftSide, 0, 0, 0);
                  WhiteoutArea(Canvas, PrintList.PageBottom - PrintList.YOff);
                end;
                DoHead:
                begin
                  PrintList.SetYOffset(TablePartRec.PartStart - TopPixels);
                  CRect := ARect;
                  CRect.Bottom := CRect.Top + TablePartRec.PartHeight;
                  hrgnClip1 := CreateRectRgn(MLeftPrn, TopPixelsPrn, WPrn + MLeftPrn + 2,
                    MulDiv(CRect.Bottom, P3, P2));
                  SelectClipRgn(DC, hrgnClip1);
                  DeleteObject(hrgnClip1);
                  PrintList.Draw(Canvas, CRect, W, MLeftSide, 0, 0, 0);
                end;
                DoBody1, DoBody3:
                begin
                  CRect := ARect;
                  CRect.Top := PrintList.PageBottom - 1 - PrintList.YOff;
                  PrintList.SetYOffset(TablePartRec.PartStart - CRect.top);
                  PrintList.Draw(Canvas, CRect, W, MLeftSide + 3 * W, 0, 0, 0);      {off page}

                  TablePartRec.TablePart := DoBody2;
                  CRect.Bottom := PrintList.PageBottom - PrintList.YOff + 1;
                  hrgnClip1 := CreateRectRgn(MLeftPrn, MulDiv(CRect.Top, P3, P2),
                    WPrn + MLeftPrn + 2, MulDiv(CRect.Bottom, P3, P2));
                  SelectClipRgn(DC, hrgnClip1);
                  DeleteObject(hrgnClip1);
                  PrintList.Draw(Canvas, CRect, W, MLeftSide, 0, 0, 0);      {onpage}
                  if not Assigned(TablePartRec) or not (TablePartRec.TablePart in [Normal]) then
                    WhiteoutArea(Canvas, PrintList.PageBottom - PrintList.YOff);
                end;
                DoFoot:
                begin
                  SavePageBottom := PrintList.PageBottom;
                  CRect := ARect;
                  CRect.Top := PrintList.PageBottom - PrintList.YOff;
                  CRect.Bottom := CRect.Top + TablePartRec.PartHeight;
                  hrgnClip1 := CreateRectRgn(MLeftPrn, MulDiv(CRect.Top, P3, P2),
                    WPrn + MLeftPrn + 2, MulDiv(CRect.Bottom, P3, P2));
                  SelectClipRgn(DC, hrgnClip1);
                  DeleteObject(hrgnClip1);
                  PrintList.SetYOffset(TablePartRec.PartStart - CRect.top);
                  PrintList.Draw(Canvas, CRect, W, MLeftSide, 0, 0, 0);
                  PrintList.PageBottom := SavePageBottom;
                end;
              end;
            until not Assigned(TablePartRec) or (TablePartRec.TablePart in [Normal, DoHead, DoBody3]);

{.$Region 'Do HeaderFooter'}
            SelectClipRgn(DC, 0);
            if (FPage <= ToPage) then  {print header and footer}
            begin
              Canvas.Pen.Assign(savedPen);
              Align := SetTextAlign(DC, TA_Top or TA_Left or TA_NOUPDATECP);
              if Assigned(FOnPrintHeader) then
              begin
//BG, 01.12.2006: beg of modification
                  SetWindowOrgEx(DC, XOrigin, 0, NIL);
//BG, 01.12.2006: end of modification
                FOnPrintHeader(Self, Canvas, FPage, ScaledPgWid, TopPixels, Done);
              end;
              if Assigned(FOnPrintFooter) then
              begin
//BG, 01.12.2006: beg of modification
                  SetWindowOrgEx(DC, XOrigin, -(TopPixels + H), NIL);
//BG, 01.12.2006: end of modification
                FOnPrintFooter(Self, Canvas, FPage, ScaledPgWid,
                  ScaledPgHt - (TopPixels + H), Done);
              end;
              DoHTMLHeaderFooter(FALSE, FOnPrintHTMLHeader, HeadViewer);
              DoHTMLHeaderFooter(TRUE, FOnPrintHTMLFooter, FootViewer);
              SetTextAlign(DC, Align);

            end;
              RestoreCanvasItems(Canvas);
            if FPrintMarginTop <> LastPrintMarginTop then
            begin
              DeltaMarginTop := FPrintMarginTop - SavePrintMarginTop;
              DeltaPixelsPrn := Trunc(DeltaMarginTop / 2.54 * P3);
              DeltaPixels := Trunc(DeltaMarginTop / 2.54 * P2);
              TopPixels := OrigTopPixels + DeltaPixels;
              TopPixelsPrn := OrigTopPixelsPrn + DeltaPixelsPrn;
              HPrn := OrigHprn - DeltaPixelsPrn;
              H := OrigH - DeltaPixels;
              ARect := Rect(MLeft, TopPixels, W + MLeft, TopPixels + H);
              hrgnClip := CreateRectRgn(MLeftPrn, TopPixelsPrn, WPrn + MLeftPrn + 2,
                TopPixelsPrn + HPrn);
              LastPrintMarginTop := FPrintMarginTop;
            end;
{.$EndRegion}
//BG, 01.12.2006: beg of modification
              if HPageIndex < HPages - 1 then
                NewPage;
            end;
//BG, 01.12.2006: end of modification
            HTop := PrintList.PageBottom;
            Application.ProcessMessages;
            if Assigned(FOnPageEvent) then
              FOnPageEvent(Self, FPage, Done);
            if (HTop >= VPixels - MarginHeight) or (HTop <= OldTop) then  {see if done or endless loop}
              Done := TRUE;
            OldTop := HTop;
            if not Done and (FPage >= FromPage) and (FPage < ToPage) then
              NewPage;
            Inc(FPage);
          end;
        end;
      finally
        FreeAndNil(HeadViewer);
        FreeAndNil(FootViewer);
        if hRgnClip <> 0 then
          DeleteObject(hrgnClip);
        if not PrinterOpen then
        begin
          if (FromPage > FPage) then
            vwPrinter.Abort
          else
            vwPrinter.EndDoc;
          vwSetPrinter(OldPrinter);
          FreeAndNil(vwP);
        end;
        Dec(FPage);
      end;
    finally
      savedFont.Free;
      savedPen.Free;
      savedBrush.Free;
    end;
  finally
    FPrintMarginTop := SavePrintMarginTop;
    PrintList.Free;
  end;
//BG, 01.12.2006: beg of modification
  if assigned(FOnPrinted) then
    FOnPrinted(self);
//BG, 01.12.2006: end of modification
end;

procedure ThtmlViewer.OpenPrint;
begin
  if not assigned(vwP) then
  begin
    vwP := TvwPrinter.Create;
    OldPrinter := vwSetPrinter(vwP);
  end;
end;

procedure ThtmlViewer.ClosePrint;
begin
  if Assigned(vwP) then
  begin
    if vwP.Printing then
      vwPrinter.EndDoc;
    vwSetPrinter(OldPrinter);
    FreeAndNil(vwP);
  end;
end;

procedure THTMLViewer.CMHintShow(var Message: TMessage);
begin
  inherited;
  with TCMHintShow(Message) do begin
    HintInfo.HintData := HintInfo;
    HintInfo.HintStr := GetShortHint(HintInfo.HintControl.Hint);
  end;
end;

procedure ThtmlViewer.AbortPrint;
begin
  if Assigned(vwP) then
  begin
    if vwP.Printing then
      vwPrinter.Abort;
    vwSetPrinter(OldPrinter);
    FreeAndNil(vwP);
  end;
end;

function ThtmlViewer.NumPrinterPages: Integer;
var
  Dummy: double;
begin
  Result := NumPrinterPages(Dummy);
end;

function THtmlViewer.NumPrinterPages(out WidthRatio: Double): Integer;
var
  MFPrinter: TMetaFilePrinter;
begin
  MFPrinter := TMetaFilePrinter.Create(NIL);
  FOnPageEvent := NIL;
  try
    PrintPreview(MFPrinter, TRUE);
    Result := MFPrinter.LastAvailablePage;
    WidthRatio := FWidthRatio;
  finally
    MFPrinter.Free;
  end;
end;

//BG, 01.12.2006: beg of modification

procedure THtmlViewer.NumPrinterPages(MFPrinter: TMetaFilePrinter; out Width, Height: Integer);
var
  LOnPageEvent: TPageEvent;
begin
  LOnPageEvent := FOnPageEvent;
  FOnPageEvent := NIL;
  try
    PrintPreview(MFPrinter, FALSE);
    Width := FPrintedSize.X;
    Height := FPrintedSize.Y;
  finally
    FOnPageEvent := LOnPageEvent;
  end;
end;
//BG, 01.12.2006: end of modification


function ThtmlViewer.PrintPreview(MFPrinter: TMetaFilePrinter; NoOutput: boolean = FALSE): Integer;
var
  ARect, CRect: TRect;
  PrintList: TSectionList;
  P1, P2, P3: Integer; // XDpi, WDpi, YDpi
  W, H: Integer;
  HTop: Integer;
  OldTop: Integer;
  ScrollWidth: Integer;
  Curs: Integer;
  Done: boolean;
  DC: HDC;
  //PrnDC: HDC; {metafile printer's DC}

  UpperLeftPagePoint, { these will contain Top/Left and Bottom/Right unprintable area}
  LowerRightPagePoint: TPoint;

  MLeft: Integer;
  MLeftPrn: Integer;
  MRightPrn: Integer;
  MTopPrn: Integer;
  MBottomPrn: Integer;
  TopPixels: Integer;
  TopPixelsPrn: Integer;
  HPrn, WPrn: Integer;
  hrgnClip: THandle;
  hrgnClip1: THandle;
  hrgnClip2: THandle;
  SavedFont: TFont;
  SavedPen: TPen;
  SavedBrush: TBrush;
  Align: Integer;
  ScaledPgHt: Integer;
  ScaledPgWid: Integer;
  VPixels: Integer;
  FootViewer, HeadViewer: ThtmlViewer;

  DeltaMarginTop: Double;
  SavePrintMarginTop: Double;
  DeltaPixelsPrn: Integer;
  DeltaPixels: Integer;
  OrigTopPixels: Integer;
  OrigTopPixelsPrn: Integer;
  OrigHprn: Integer;
  OrigH: Integer;
  LastPrintMarginTop: Double;
  SavePageBottom: Integer;
  TablePart: TablePartType;

  procedure Fill(Canvas: TCanvas);
  var
    BrushColor: TColor;
  begin
    BrushColor := Canvas.Brush.Color;
    Canvas.Brush.Color := $eeeeff;
    Canvas.Rectangle(MLeft, 0, W + MLeft + 200, 4000);
    Canvas.Brush.Color := BrushColor;
  end;

  procedure SaveCanvasItems(Canvas: TCanvas);
  begin { preserve current settings of the Canvas}
    SavedPen.Assign(Canvas.Pen);
    SavedFont.Assign(Canvas.Font);
    SavedBrush.Assign(Canvas.Brush);
  end;

  procedure RestoreCanvasItems(Canvas: TCanvas);
  begin { restore initial Canvas settings }
    Canvas.Pen.Assign(SavedPen);
    Canvas.Font.Assign(SavedFont);
    Canvas.Brush.Assign(SavedBrush);
  end;

//BG, 01.12.2006: beg of modification
var
  HPages: Integer;
  HPageIndex: Integer;
  XOrigin: Integer;
//BG, 01.12.2006: end of modification

  procedure WhiteoutArea(Canvas: TCanvas; Y: Integer);
  {White out excess printing.  Y is top of the bottom area to be blanked.}
  begin
    if NoOutput then
      exit;
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Color := clWhite;
    Canvas.Rectangle(MLeft, 0, W + MLeft + 1, TopPixels - 2);
    Canvas.Rectangle(MLeft, Y, W + MLeft + 1, TopPixels + H + 1);
    if (htPrintBackground in FOptions) and (Y - TopPixels < H) then
    begin   {need to reprint background in whited out area}
      hrgnClip1 := CreateRectRgn(MLeftPrn, MulDiv(Y, P3, P2) + 2, MLeftPrn + WPrn, TopPixelsPrn + HPrn);
      SelectClipRgn(Canvas.Handle, hrgnClip1);
      DeleteObject(hrgnClip1);
//BG, 01.12.2006: beg of modification
      DoBackground2(Canvas, MLeft + XOrigin, TopPixels, W, H, PaintPanel.Color);
//BG, 01.12.2006: end of modification
    end;
    RestoreCanvasItems(Canvas);
  end;

  procedure DoHTMLHeaderFooter(Footer: boolean; Event: ThtmlPagePrinted; HFViewer: ThtmlViewer);
  var
    YOrigin, YOff, Ht: Integer;
    HFCopyList: TSectionList;
    BRect: TRect;
    DocHeight, XL, XR: Integer;
  begin
    if not Assigned(Event) then
      Exit;
    try
      XL := MLeft;
      XR := MLeft + W;
      Event(Self, HFViewer, FPage, PrintList.PageBottom > VPixels, XL, XR, Done);  {call event handler}
      HFCopyList := TSectionList.CreateCopy(HFViewer.SectionList);
      try
        HFCopyList.Printing := TRUE;
        HFCopyList.NoOutput := NoOutput;
        HFCopyList.ScaleX := fScaleX;
        HFCopyList.ScaleY := fScaleY;
        Curs := 0;
        DocHeight := HFCopyList.DoLogic(MFPrinter.Canvas, 0, XR - XL, 300, 0, ScrollWidth, Curs);
        if not Footer then
        begin  {Header}
          YOrigin := 0;
          Ht := TopPixels;
          YOff := DocHeight - TopPixels;
        end
        else
        begin   {Footer}
          YOrigin := -(TopPixels + H);
          Ht := Min(ScaledPgHt - (TopPixels + H), DocHeight);
          YOff := 0;
        end;
        SetWindowOrgEx(DC, 0, YOrigin, NIL);
        HFViewer.DoBackground2(MFPrinter.Canvas, XL, -YOff, XR - XL, DocHeight, HFViewer.PaintPanel.Color);
        HFCopyList.SetYOffset(YOff);
        BRect := Rect(XL, 0, XR, Ht);
        HFCopyList.Draw(MFPrinter.Canvas, BRect, XR - XL, XL, 0, 0, 0);
      finally
        HFCopyList.Free;
      end;
    except
    end;
  end;
begin
  Done := FALSE;
  FootViewer := NIL;
  HeadViewer := NIL;
  TablePartRec := NIL;
  if Assigned(FOnPageEvent) then
    FOnPageEvent(Self, 0, Done);
  FPage := 0;
  Result := 0;
  if (vsProcessing in FViewerState) or (SectionList.Count = 0) then
    Exit;
  PrintList := TSectionList.CreateCopy(SectionList);
  PrintList.SetYOffset(0);
  SavePrintMarginTop := FPrintMarginTop;
  try
    SavedPen := TPen.Create;
    SavedFont := TFont.Create;
    SavedBrush := TBrush.Create;
    try
      PrintList.Printing := TRUE;
      PrintList.NoOutput := NoOutput;
      PrintList.SetBackground(clWhite);

      FPage := 1;
      hrgnClip := 0;
      hrgnClip2 := 0;
      try
        with MFPrinter do
        begin
          if DocumentTitle <> '' then
            Title := DocumentTitle;

          BeginDoc;
          DC := Canvas.Handle;

          P3 := PixelsPerInchY;
          P1 := PixelsPerInchX;
          P2 := Round(Screen.PixelsPerInch * FPrintScale);
          fScaleX := 100.0 / P3;
          fScaleY := 100.0 / P1;
          PrintList.ScaleX := fScaleX;
          PrintList.ScaleY := fScaleY;
          SetMapMode(DC, mm_AnIsotropic);
          SetWindowExtEx(DC, P2, P2, NIL);
          SetViewPortExtEx(DC, P1, P3, NIL);

        { calculate the amount of space that is non-printable }

        { get PHYSICAL page width }
          LowerRightPagePoint.X := PaperWidth;
          LowerRightPagePoint.Y := PaperHeight;

        { now compute a complete unprintable area rectangle
         (composed of 2*width, 2*height) in pixels...}
          with LowerRightPagePoint do
          begin
            Y := Y - MFPrinter.PageHeight;
            X := X - MFPrinter.PageWidth;
          end;

        { get upper left physical offset for the printer... ->
          printable area <> paper size }
          UpperLeftPagePoint.X := OffsetX;
          UpperLeftPagePoint.Y := OffsetY;

        { now that we know the TOP and LEFT offset we finally can
          compute the BOTTOM and RIGHT offset: }
          with LowerRightPagePoint do
          begin
            X := X - UpperLeftPagePoint.X;
          { we don't want to have negative values}
            if X < 0 then
              X := 0; { assume no right printing offset }

            Y := Y - UpperLeftPagePoint.Y;
          { we don't want to have negative values}
            if Y < 0 then
              Y := 0; { assume no bottom printing offset }
          end;

        { which results in LowerRightPoint containing the BOTTOM
          and RIGHT unprintable area offset; using these we modify
          the (logical, true) borders...}

          MLeftPrn := Trunc(FPrintMarginLeft / 2.54 * P1);
          MLeftPrn := MLeftPrn - UpperLeftPagePoint.X;  { subtract physical offset }
          MLeft := MulDiv(MLeftPrn, P2, P1);

          MRightPrn := Trunc(FPrintMarginRight / 2.54 * P1);
          MRightPrn := MRightPrn - LowerRightPagePoint.X;  { subtract physical offset }

          WPrn := PageWidth - (MLeftPrn + MRightPrn);

          W := MulDiv(WPrn, P2, P1);

          MTopPrn := Trunc(FPrintMarginTop / 2.54 * P3);
          MTopPrn := MTopPrn - UpperLeftPagePoint.Y;  { subtract physical offset }

          MBottomPrn := Trunc(FPrintMarginBottom / 2.54 * P3);
          MBottomPrn := MBottomPrn - LowerRightPagePoint.Y;  { subtract physical offset }

          TopPixelsPrn := MTopPrn;
          TopPixels := MulDiv(TopPixelsPrn, P2, P3);

          HPrn := PageHeight - (MTopPrn + MBottomPrn);
          H := MulDiv(HPrn, P2, P3);  {scaled pageHeight}
          HTop := 0;
          OldTop := 0;

          Curs := 0;
          VPixels := PrintList.DoLogic(Canvas, 0, W, H, 0, ScrollWidth, Curs);
//BG, 01.12.2006: beg of modification
          FPrintedSize.X := ScrollWidth;
          FPrintedSize.Y := VPixels;
//BG, 01.12.2006: end of modification
          FWidthRatio := ScrollWidth / W;
          if FWidthRatio > 1.0 then
            FWidthRatio := Round(P2 * FWidthRatio + 0.5) / P2;

          ScaledPgHt := MulDiv(PageHeight, P2, P3);
          ScaledPgWid := MulDiv(PageWidth, P2, P3);

        {This one clips to the allowable print region so that the preview is
         limited to that region also}
          hrgnClip2 := CreateRectRgn(0, 0, MFPrinter.PageWidth, MFPrinter.PageHeight);
        {This one is primarily used to clip the top and bottom margins to insure
         nothing is output there.  It's also constrained to the print region
         in case the margins are misadjusted.}
          hrgnClip := CreateRectRgn(MLeftPrn, Max(0, TopPixelsPrn),
            Min(MFPrinter.PageWidth, WPrn + MLeftPrn + 2),
            Min(MFPrinter.PageHeight, TopPixelsPrn + HPrn));
          Application.ProcessMessages;
          if Assigned(FOnPageEvent) then
            FOnPageEvent(Self, FPage, Done);
          ARect := Rect(MLeft, TopPixels, W + MLeft, TopPixels + H);

          if Assigned(FOnPrintHTMLHeader) then
            HeadViewer := CreateHeaderFooter;
          if Assigned(FOnPrintHTMLFooter) then
            FootViewer := CreateHeaderFooter;

          OrigTopPixels := TopPixels;
          OrigTopPixelsPrn := TopPixelsPrn;
          OrigHPrn := HPrn;
          OrigH := H;
          LastPrintMarginTop := FPrintMarginTop;

//BG, 01.12.2006: beg of modification
          //BG, 05.03.2006
          HPages := ceil(ScrollWidth / W);
          XOrigin := 0;
//BG, 01.12.2006: end of modification
          while not Done do
          begin
            PrintList.SetYOffset(HTop - TopPixels);

//BG, 01.12.2006: beg of modification
            for HPageIndex := 0 to HPages - 1 do
            begin
              XOrigin := HPageIndex * W;
//              V_XOrigin := XOrigin;
//BG, 01.12.2006: end of modification
          {next line is necessary because the canvas changes with each new page }
            DC := Canvas.Handle;
            SaveCanvasItems(Canvas);

            SetMapMode(DC, mm_AnIsotropic);
            SetWindowExtEx(DC, P2, P2, NIL);
            SetViewPortExtEx(DC, P1, P3, NIL);
//BG, 01.12.2006: beg of modification
              SetWindowOrgEx(DC, XOrigin, 0, NIL);
//BG, 01.12.2006: end of modification
            SelectClipRgn(DC, hrgnClip);

            if (htPrintBackground in FOptions) then
//BG, 01.12.2006: beg of modification
                DoBackground2(Canvas, MLeft + XOrigin, TopPixels, W, H, PaintPanel.Color);
//BG, 01.12.2006: end of modification

            repeat
              if Assigned(TablePartRec) then
                TablePart := TablePartRec.TablePart
                else
                  TablePart := Normal;
              case TablePart of
                Normal:
                begin
                  PrintList.Draw(Canvas, ARect, W, MLeft, 0, 0, 0);
                  WhiteoutArea(Canvas, PrintList.PageBottom - PrintList.YOff);
                end;

                DoHead:
                begin
                  PrintList.SetYOffset(TablePartRec.PartStart - TopPixels);
                  CRect := ARect;
                  CRect.Bottom := CRect.Top + TablePartRec.PartHeight;
                  hrgnClip1 := CreateRectRgn(MLeftPrn, TopPixelsPrn, WPrn + MLeftPrn + 2,
                    MulDiv(CRect.Bottom, P3, P2));
                  SelectClipRgn(DC, hrgnClip1);
                  DeleteObject(hrgnClip1);
                  PrintList.Draw(Canvas, CRect, W, MLeft, 0, 0, 0);
                end;

                DoBody1, DoBody3:
                begin
                  CRect := ARect;
                  CRect.Top := PrintList.PageBottom - 1 - PrintList.YOff;
                  PrintList.SetYOffset(TablePartRec.PartStart - CRect.top);
                  PrintList.Draw(Canvas, CRect, W, MLeft + 3 * W, 0, 0, 0);      {off page}

                  TablePartRec.TablePart := DoBody2;
                  CRect.Bottom := PrintList.PageBottom - PrintList.YOff + 1;
                  hrgnClip1 := CreateRectRgn(MLeftPrn, MulDiv(CRect.Top, P3, P2),
                    WPrn + MLeftPrn + 2, MulDiv(CRect.Bottom, P3, P2));
                  SelectClipRgn(DC, hrgnClip1);
                  DeleteObject(hrgnClip1);
                  PrintList.Draw(Canvas, CRect, W, MLeft, 0, 0, 0);      {onpage}
                  if not Assigned(TablePartRec) or not (TablePartRec.TablePart in [Normal]) then
                    WhiteoutArea(Canvas, PrintList.PageBottom - PrintList.YOff);
                end;

                DoFoot:
                begin
                  SavePageBottom := PrintList.PageBottom;
                  CRect := ARect;
                  CRect.Top := PrintList.PageBottom - PrintList.YOff;
                  CRect.Bottom := CRect.Top + TablePartRec.PartHeight;
                  hrgnClip1 := CreateRectRgn(MLeftPrn, MulDiv(CRect.Top, P3, P2),
                    WPrn + MLeftPrn + 2, MulDiv(CRect.Bottom, P3, P2));
                  SelectClipRgn(DC, hrgnClip1);
                  DeleteObject(hrgnClip1);
                  PrintList.SetYOffset(TablePartRec.PartStart - CRect.top);
                  PrintList.Draw(Canvas, CRect, W, MLeft, 0, 0, 0);
                  PrintList.PageBottom := SavePageBottom;
                end;
              end;
            until not Assigned(TablePartRec) or (TablePartRec.TablePart in [Normal, DoHead, DoBody3]);

{.$Region 'HeaderFooter'}
            SelectClipRgn(DC, 0);
            Align := SetTextAlign(DC, TA_Top or TA_Left or TA_NOUPDATECP);
            SelectClipRgn(DC, hrgnClip2);

            if Assigned(FOnPrintHeader) then
            begin
//BG, 01.12.2006: beg of modification
                SetWindowOrgEx(DC, XOrigin, 0, NIL);
//BG, 01.12.2006: end of modification
              FOnPrintHeader(Self, Canvas, FPage, ScaledPgWid, TopPixels, Done);
            end;

            if Assigned(FOnPrintFooter) then
            begin
//BG, 01.12.2006: beg of modification
                SetWindowOrgEx(DC, XOrigin, -(TopPixels + H), NIL);
//BG, 01.12.2006: end of modification
                FOnPrintFooter(Self, Canvas, FPage, ScaledPgWid, ScaledPgHt - (TopPixels + H), Done);
            end;
            DoHTMLHeaderFooter(FALSE, FOnPrintHTMLHeader, HeadViewer);
            DoHTMLHeaderFooter(TRUE, FOnPrintHTMLFooter, FootViewer);
            SetTextAlign(DC, Align);
            SelectClipRgn(DC, 0);

            if FPrintMarginTop <> LastPrintMarginTop then
            begin
              DeltaMarginTop := FPrintMarginTop - SavePrintMarginTop;
              DeltaPixelsPrn := Trunc(DeltaMarginTop / 2.54 * P3);
              DeltaPixels := Trunc(DeltaMarginTop / 2.54 * P2);
              TopPixels := OrigTopPixels + DeltaPixels;
              TopPixelsPrn := OrigTopPixelsPrn + DeltaPixelsPrn;
              HPrn := OrigHprn - DeltaPixelsPrn;
              H := OrigH - DeltaPixels;
//BG, 01.12.2006: beg of modification
                ARect := Rect(MLeft + XOrigin, TopPixels, W + MLeft + XOrigin, TopPixels + H);
//BG, 01.12.2006: end of modification
                hrgnClip := CreateRectRgn(MLeftPrn, Max(0, TopPixelsPrn),
                  Min(MFPrinter.PageWidth, WPrn + MLeftPrn + 2),
                  Min(MFPrinter.PageHeight, TopPixelsPrn + HPrn));
              LastPrintMarginTop := FPrintMarginTop;
            end;
{.$EndRegion}
//BG, 01.12.2006: beg of modification
              if HPageIndex < HPages - 1 then
              begin
                NewPage;
                inc(FPage);
              end;
            end;
//            V_XOrigin := 0;
//BG, 01.12.2006: end of modification
            HTop := PrintList.PageBottom;
            Application.ProcessMessages;
            if Assigned(FOnPageEvent) then
              FOnPageEvent(Self, FPage, Done);
            if (HTop >= VPixels - MarginHeight) or (HTop <= OldTop) then  {see if done or endless loop}
              Done := TRUE;
            OldTop := HTop;
            if not Done then
              NewPage;
            Inc(FPage);
          end;
          EndDoc;
        end;
      finally
        FreeAndNil(HeadViewer);
        FreeAndNil(FootViewer);
        if hRgnClip <> 0 then
          DeleteObject(hrgnClip);
        if hRgnClip2 <> 0 then
          DeleteObject(hrgnClip2);
        Dec(FPage);
      end;
    finally
      SavedPen.Free;
      SavedFont.Free;
      SavedBrush.Free;
    end;
  finally
    FPrintMarginTop := SavePrintMarginTop;
    PrintList.Free;
    Result := FPage;
  end;
end;

procedure ThtmlViewer.BackgroundChange(Sender: TObject);
begin
  PaintPanel.Color := (Sender as TSectionList).Background or PalRelative;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnBitmapRequest: TGetBitmapEvent;
begin
  Result := FSectionList.GetBitmap;
end;

procedure ThtmlViewer.SetOnBitmapRequest(Handler: TGetBitmapEvent);
begin
  //FOnBitmapRequest := Handler;
  FSectionList.GetBitmap := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnExpandName: TExpandNameEvent;
begin
  Result := FSectionList.ExpandName;
end;

procedure ThtmlViewer.SetOnExpandName(Handler: TExpandNameEvent);
begin
  //FOnExpandName := Handler;
  FSectionList.ExpandName := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnFileBrowse: TFileBrowseEvent;
begin
  Result := FSectionList.FileBrowse;
end;

procedure ThtmlViewer.SetOnFileBrowse(Handler: TFileBrowseEvent);
begin
  //FOnFileBrowse := Handler;
  FSectionList.FileBrowse := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnImageRequest: TGetImageEvent;
begin
  Result := FSectionList.GetImage;
end;

procedure THtmlViewer.SetOnImageRequest(Handler: TGetImageEvent);
begin
  //FOnImageRequest := Handler;
  FSectionList.GetImage := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnImageRequested: TGottenImageEvent;
begin
  Result := FSectionList.GottenImage;
end;

procedure THtmlViewer.SetOnImageRequested(Handler: TGottenImageEvent);
begin
  //FOnImageRequested := Handler;
  FSectionList.GottenImage := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnObjectBlur: ThtObjectEvent;
begin
  Result := FSectionList.ObjectBlur;
end;

procedure ThtmlViewer.SetOnObjectBlur(Handler: ThtObjectEvent);
begin
  //FOnObjectBlur := Handler;
  FSectionList.ObjectBlur := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnObjectChange: ThtObjectEvent;
begin
  Result := FSectionList.ObjectChange;
end;

procedure ThtmlViewer.SetOnObjectChange(Handler: ThtObjectEvent);
begin
  //FOnObjectChange := Handler;
  FSectionList.ObjectChange := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnObjectClick: TObjectClickEvent;
begin
  Result := FSectionList.ObjectClick;
end;

procedure THtmlViewer.SetOnObjectClick(Handler: TObjectClickEvent);
begin
  //FOnObjectClick := Handler;
  FSectionList.ObjectClick := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnObjectFocus: ThtObjectEvent;
begin
  Result := FSectionList.ObjectFocus;
end;

procedure THtmlViewer.SetOnObjectFocus(Handler: ThtObjectEvent);
begin
  //FOnObjectFocus := Handler;
  FSectionList.ObjectFocus := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnPanelCreate: TPanelCreateEvent;
begin
  Result := FSectionList.PanelCreateEvent;
end;

procedure ThtmlViewer.SetOnPanelCreate(Handler: TPanelCreateEvent);
begin
  //FOnPanelCreate := Handler;
  FSectionList.PanelCreateEvent := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnPanelDestroy: TPanelDestroyEvent;
begin
  Result := FSectionList.PanelDestroyEvent;
end;

procedure ThtmlViewer.SetOnPanelDestroy(Handler: TPanelDestroyEvent);
begin
  //FOnPanelDestroy := Handler;
  FSectionList.PanelDestroyEvent := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnPanelPrint: TPanelPrintEvent;
begin
  Result := FSectionList.PanelPrintEvent;
end;

procedure ThtmlViewer.SetOnPanelPrint(Handler: TPanelPrintEvent);
begin
  //FOnPanelPrint := Handler;
  FSectionList.PanelPrintEvent := Handler;
end;

//-- BG ---------------------------------------------------------- 20.11.2010 --
function THtmlViewer.GetOnScript: TScriptEvent;
begin
  Result := FSectionList.ScriptEvent;
end;

procedure THtmlViewer.SetOnScript(Handler: TScriptEvent);
begin
  //FOnScript := Handler;
  FSectionList.ScriptEvent := Handler;
end;

procedure ThtmlViewer.SetOnFormSubmit(Handler: TFormSubmitEvent);
begin
  FOnFormSubmit := Handler;
  if Assigned(Handler) then
    FSectionList.SubmitForm := SubmitForm
  else
    FSectionList.SubmitForm := NIL;
end;

procedure THtmlViewer.SubmitForm(Sender: IHtmlViewerBase; const Action, Target, EncType, Method: string; Results: ThtStringList);
begin
  if Assigned(FOnFormSubmit) then
  begin
    FAction := Action;
    FMethod := Method;
    FFormTarget := Target;
    FEncType := EncType;
    FStringList := Results;
    PostMessage(Handle, wm_FormSubmit, 0, 0);
  end
  //BG, 03.01.2010: memory leak:
  else
    Results.Free;
end;

procedure ThtmlViewer.WMFormSubmit(var Message: TMessage);
begin
  FOnFormSubmit(Self, FAction, FFormTarget, FEncType, FMethod, FStringList);
end;     {user disposes of the TStringList}

function ThtmlViewer.Find(const S: WideString; MatchCase: boolean): boolean;
begin
  Result := FindEx(S, MatchCase, FALSE);
end;

function ThtmlViewer.FindEx(const S: WideString; MatchCase, Reverse: boolean): boolean;
var
  Curs: Integer;
  X: Integer;
  Y, Pos: Integer;
  S1: WideString;
begin
  Result := FALSE;
  if S = '' then
    Exit;
  with FSectionList do
  begin
    if MatchCase then
      S1 := S
    else
      S1 := WideLowerCase1(S);
    if Reverse then
      Curs := FindStringR(CaretPos, S1, MatchCase)
    else
      Curs := FindString(CaretPos, S1, MatchCase);
    if Curs >= 0 then
    begin
      Result := TRUE;
      SelB := Curs;
      SelE := Curs + Length(S);
      if Reverse then
        CaretPos := SelB
      else
        CaretPos := SelE;
      if CursorToXY(PaintPanel.Canvas, Curs, X, Y) then
      begin
        Pos := VScrollBarPosition;
        if (Y < Pos) or
          (Y > Pos + ClientHeight - 20) then
          VScrollBarPosition := (Y - ClientHeight div 2);

        Pos := HScrollBarPosition;
        if (X < Pos) or
          (X > Pos + ClientWidth - 50) then
          HScrollBarPosition := (X - ClientWidth div 2);
        Invalidate;
      end;
    end;
  end;
end;

procedure ThtmlViewer.FormControlEnterEvent(Sender: TObject);
var
  Y, Pos: Integer;
begin
  if Sender is TFormControlObj then
  begin
    Y := TFormControlObj(Sender).YValue;
    Pos := VScrollBarPosition;
    if (Y < Pos) or (Y > Pos + ClientHeight - 20) then
    begin
      VScrollBarPosition := (Y - ClientHeight div 2);
      Invalidate;
    end;
  end
  else
  if Sender is TFontObj and not NoJump then
  begin
    Y := TFontObj(Sender).YValue;
    Pos := VScrollBarPosition;
    if (Y < Pos) then
      VScrollBarPosition := Y
    else
    if (Y > Pos + ClientHeight - 30) then
      VScrollBarPosition := (Y - ClientHeight div 2);
    Invalidate;
  end
end;

procedure ThtmlViewer.SelectAll;
begin
  with FSectionList do
    if (Count > 0) and not FNoSelect then
    begin
      SelB := 0;
      with TSectionBase(Items[Count - 1]) do
        SelE := StartCurs + Len;
      Invalidate;
    end;
end;

{----------------ThtmlViewer.InitLoad}

procedure ThtmlViewer.InitLoad;
begin
  if not Assigned(FSectionList.BitmapList) then
  begin
    FSectionList.BitmapList := TStringBitmapList.Create;
    FSectionList.BitmapList.Sorted := TRUE;
    FSectionList.BitmapList.SetCacheCount(FImageCacheCount);
    Include(FViewerState, vsLocalBitmapList);
  end;
  FSectionList.Clear;
  UpdateImageCache;
  FSectionList.SetFonts(FFontName, FPreFontName, FFontSize, FFontColor,
    FHotSpotColor, FVisitedColor, FOverColor, FBackground,
    htOverLinksActive in FOptions, not (htNoLinkUnderline in FOptions),
    FCharSet, FMarginHeight, FMarginWidth);
end;

{----------------ThtmlViewer.Clear}

procedure ThtmlViewer.Clear;
{Note: because of Frames do not clear history list here}
begin
  if vsProcessing in FViewerState then
    Exit;
  HTMLTimer.Enabled := FALSE;
  FSectionList.Clear;
  if vsLocalBitmapList in FViewerState then
    FSectionList.BitmapList.Clear;
  FSectionList.SetFonts(FFontName, FPreFontName, FFontSize, FFontColor,
    FHotSpotColor, FVisitedColor, FOverColor, FBackground,
    htOverLinksActive in FOptions, not (htNoLinkUnderline in FOptions),
    FCharSet, FMarginHeight, FMarginWidth);
  FBase := '';
  FBaseEx := '';
  FBaseTarget := '';
  FTitle := '';
  VScrollBar.Visible := FALSE;
  HScrollBar.Visible := FALSE;
  CaretPos := 0;
  Sel1 := -1;
  if Assigned(FOnSoundRequest) then
    FOnSoundRequest(Self, '', 0, TRUE);
  Invalidate;
end;

procedure ThtmlViewer.PaintWindow(DC: HDC);
begin
  PaintPanel.RePaint;
  BorderPanel.RePaint;
  VScrollbar.RePaint;
  HScrollbar.RePaint;
end;

procedure ThtmlViewer.CopyToClipboard;
const
  StartFrag = '<!--StartFragment-->';
  EndFrag = '<!--EndFragment-->';
  DocType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'#13#10;
var
  Leng: Integer;
  StSrc, EnSrc: Integer;
  HTML: AnsiString;
  format: UINT;

  procedure copyFormatToClipBoard(const source: Ansistring; format: UINT);
  // Put SOURCE on the clipboard, using FORMAT as the clipboard format
  // Based on http://www.lorriman.com/programming/cf_html.html
  var
    gMem: HGLOBAL;
    lp: pAnsichar;
  begin
    clipboard.Open;
    try
      //an extra "1" for the null terminator
      gMem := globalalloc(GMEM_DDESHARE + GMEM_MOVEABLE, length(source) + 1);
      lp := globallock(gMem);
      copymemory(lp, pAnsichar(source), length(source) + 1);
      globalunlock(gMem);
      setClipboarddata(format, gMem);
    finally
      clipboard.Close;
    end
  end;

  function GetHeader(const HTML: string): string;
  const
    Version = 'Version:1.0'#13#10;
    StartHTML = 'StartHTML:';
    EndHTML = 'EndHTML:';
    StartFragment = 'StartFragment:';
    EndFragment = 'EndFragment:';
    SourceURL = 'SourceURL:';
    NumberLengthAndCR = 10;

    // Let the compiler determine the description length.
    PreliminaryLength = Length(Version) + Length(StartHTML) +
      Length(EndHTML) + Length(StartFragment) +
      Length(EndFragment) + 4 * NumberLengthAndCR +
      2;  {2 for last CRLF}
  var
    URLString: string;
    StartHTMLIndex,
    EndHTMLIndex,
    StartFragmentIndex,
    EndFragmentIndex: Integer;
  begin
    if CurrentFile = '' then
      UrlString := SourceURL + 'unsaved:///ThtmlViewer.htm'
    else
    if Pos('://', CurrentFile) > 0 then
      URLString := SourceURL + CurrentFile    {already has protocol}
    else
      URLString := SourceURL + 'file://' + CurrentFile;
    StartHTMLIndex := PreliminaryLength + Length(URLString);
    EndHTMLIndex := StartHTMLIndex + Length(HTML);
    StartFragmentIndex := StartHTMLIndex + Pos(StartFrag, HTML) + Length(StartFrag) - 1;
    EndFragmentIndex := StartHTMLIndex + Pos(EndFrag, HTML) - 1;

    Result := Version +
      SysUtils.Format('%s%.8d', [StartHTML, StartHTMLIndex]) + #13#10 +
      SysUtils.Format('%s%.8d', [EndHTML, EndHTMLIndex]) + #13#10 +
      SysUtils.Format('%s%.8d', [StartFragment, StartFragmentIndex]) + #13#10 +
      SysUtils.Format('%s%.8d', [EndFragment, EndFragmentIndex]) + #13#10 +
      URLString + #13#10;
  end;

  function Truncate(const S: string): string;
  var
    I: Integer;
  begin
    I := Pos(EndFrag, S);
    Result := S;
    if I > 0 then
      Result := Copy(Result, 1, I + Length(EndFrag) - 1);
  end;

  procedure RemoveTag(const Tag: string);
  {remove all the tags that look like "<tag .....>" }
  var
    I: Integer;
    L: Ansistring;
    C: Ansichar;
  begin
    L := Lowercase(HTML);
    I := Pos(Tag, L);
    while (I > 0) do
    begin
      Delete(HTML, I, Length(Tag));
      repeat
        if I <= Length(HTML) then
          C := HTML[I]
        else
          C := #0;
        Delete(HTML, I, 1);
      until C in ['>', #0];
      L := Lowercase(HTML);
      I := Pos(Tag, L);
    end;
  end;

  procedure MessUp(const S: string);
  var
    I: Integer;
    L: string;
  begin
    L := Lowercase(HTML);
    I := Pos(S, L);
    while (I > 0) do
    begin
      Delete(HTML, I, 1);
      L := Lowercase(HTML);
      I := Pos(S, L);
    end;
  end;

  function ConvertToUTF8(const S: Ansistring): Ansistring;
  var
    Len, Len1: Integer;
    WS: WideString;
  begin
    if CodePage = CP_UTF8 then
    begin
      Result := S;
      Exit;
    end;
    Len := Length(S);
    SetString(WS, NIL, Len); // Yunqa.de: SetString() is faster than SetLength().
    Len := MultibyteToWideChar(CodePage, 0, PAnsiChar(S), Len, PWideChar(WS), Len);
    Len1 := 4 * Len;
    SetString(Result, NIL, Len1); // Yunqa.de: SetString() is faster than SetLength().
    Len1 := WideCharToMultibyte(CP_UTF8, 0, PWideChar(WS), Len, PAnsiChar(Result), Len1, NIL, NIL);
    SetLength(Result, Len1);
  end;

  procedure InsertDefaultFontInfo;
  var
    I: Integer;
    S, L: string;
    HeadFound: boolean;
  begin
    L := LowerCase(HTML);
    I := Pos('<head>', L);
    HeadFound := I > 0;
    if not HeadFound then
      I := Pos('<html>', L);
    if I <= 0 then
      I := 1;
    S := '<style> body {font-size: ' + IntToStr(DefFontSize) + 'pt; font-family: "' +
      DefFontName + '"; }</style>';
    if not HeadFound then
      S := '<head>' + S + '</head>';
    Insert(S, HTML, I);
  end;

  procedure BackupToContent;
  var
    C: AnsiChar;
    I: Integer;

    procedure GetC;  {reads characters backwards}
    begin
      if I - 1 > StSrc then
      begin
        Dec(I);
        C := HTML[I];
      end
      else
        C := #0;
    end;
  begin
    I := EnSrc;
    repeat
      repeat     {skip past white space}
        GetC;
      until C in [#0, '!'..#255];
      if C = '>' then
        repeat   {read thru a tag}
          repeat
            GetC;
          until C in [#0, '<'];
          GetC;
        until C <> '>';
    until C in [#0, '!'..#255]; {until found some content}
    if C = #0 then
      Dec(I);
    HTML := Copy(HTML, 1, I);  {truncate the tags}
  end;
begin
  Leng := FSectionList.GetSelLength;
  if Leng = 0 then
    Exit;
  FSectionList.CopyToClipboardA(Leng + 1);

  HTML := DocumentSource;
  StSrc := FindSourcePos(FSectionList.SelB) + 1;
  EnSrc := FindSourcePos(FSectionList.SelE);
  if EnSrc < 0 then {check to see if end selection is at end of document}
  begin
    EnSrc := Length(HTML);
    if HTML[EnSrc] = '>' then
    begin
      HTML := HTML + ' ';
      Inc(EnSrc);
    end;
  end
  else
    EnSrc := EnSrc + 1;
{Truncate beyond EnSrc}
  HTML := Copy(HTML, 1, EnSrc - 1);
{Also remove any tags on the end}
  BackupToContent;
{insert the StartFrag string}
  Insert(StartFrag, HTML, StSrc);
{Remove all Meta tags, in particular the ones that specify language, but others
 seem to cause problems also}
  RemoveTag('<meta');
{Remove <!doctype> in preparation to having one added}
  RemoveTag('<!doctype');
{page-break-... stylesheet properties cause a hang in Word -- mess them up}
  MessUp('page-break-');
{Add in default font information which wouldn't be in the HTML}
  InsertDefaultFontInfo;
{Convert character set to UTF-8}
  HTML := ConvertToUTF8(HTML);
{Add Doctype tag at start}
  HTML := DocType + HTML;
{Append the EndFrag string}
  HTML := HTML + EndFrag;
{Add the header to start}
  HTML := GetHeader(HTML) + HTML;

  format := RegisterClipboardFormat('HTML Format'); {not sure this is necessary}
  CopyFormatToClipBoard(HTML, format);
end;

function ThtmlViewer.GetSelTextBuf(Buffer: PWideChar; BufSize: Integer): Integer;
begin
  if BufSize <= 0 then
    Result := 0
  else
    Result := FSectionList.GetSelTextBuf(Buffer, BufSize);
end;

function ThtmlViewer.GetSelText: WideString;
var
  Len: Integer;
begin
  Len := FSectionList.GetSelLength;
  if Len > 0 then
  begin
    SetString(Result, NIL, Len);
    FSectionList.GetSelTextBuf(Pointer(Result), Len + 1);
  end
  else
    Result := '';
end;

function ThtmlViewer.GetSelLength: Integer;
begin
  with FSectionList do
    if FCaretPos = SelB then
      Result := SelE - SelB
    else
      Result := SelB - SelE;
end;

procedure ThtmlViewer.SetSelLength(Value: Integer);
begin
  with FSectionList do
  begin
    if Value >= 0 then
    begin
      SelB := FCaretPos;
      SelE := FCaretPos + Value;
    end
    else
    begin
      SelE := FCaretPos;
      SelB := FCaretPos + Value;
    end;
    Invalidate;
  end;
end;

procedure ThtmlViewer.SetSelStart(Value: Integer);
begin
  with FSectionList do
  begin
    FCaretPos := Value;
    SelB := Value;
    SelE := Value;
    Invalidate;
  end;
end;

procedure ThtmlViewer.SetNoSelect(Value: boolean);
begin
  if Value <> FNoSelect then
  begin
    FNoSelect := Value;
    if Value = TRUE then
    begin
      FSectionList.SelB := -1;
      FSectionList.SelE := -1;
      RePaint;
    end;
  end;
end;

procedure ThtmlViewer.UpdateImageCache;
begin
  FSectionList.BitmapList.BumpAndCheck;
end;

procedure ThtmlViewer.SetImageCacheCount(Value: Integer);
begin
  Value := Max(0, Value);
  Value := Min(20, Value);
  if Value <> FImageCacheCount then
  begin
    FImageCacheCount := Value;
    if Assigned(FSectionList.BitmapList) then
      FSectionList.BitmapList.SetCacheCount(FImageCacheCount);
  end;
end;

procedure ThtmlViewer.SetStringBitmapList(BitmapList: TStringBitmapList);
begin
  FSectionList.BitmapList := BitmapList;
  Exclude(FViewerState, vsLocalBitmapList);
end;

procedure ThtmlViewer.DrawBorder;
begin
  if (Focused and (FBorderStyle = htFocused)) or (FBorderStyle = htSingle) or (csDesigning in ComponentState) then
  begin
//LCL sets BorderStyle no matter if it changes or not, which ends up in an endless window recreation.
{$ifdef LCL}
    if BorderPanel.BorderStyle <> bsSingle then
{$endif}
      BorderPanel.BorderStyle := bsSingle;
  end
  else
  begin
{$ifdef LCL}
    if BorderPanel.BorderStyle <> bsNone then
{$endif}
    BorderPanel.BorderStyle := bsNone;
end;
end;

procedure ThtmlViewer.DoEnter;
begin
  inherited DoEnter;
  DrawBorder;
end;

procedure ThtmlViewer.DoExit;
begin
  inherited DoExit;
  DrawBorder;
end;

procedure ThtmlViewer.SetScrollBars(Value: TScrollStyle);
begin
  if (Value <> FScrollBars) then
  begin
    FScrollBars := Value;
    if not (csLoading in ComponentState) and HandleAllocated then
    begin
      SetProcessing(TRUE);
      try
        DoLogic;
      finally
        SetProcessing(FALSE);
      end;
      Invalidate;
    end;
  end;
end;

{----------------ThtmlViewer.Reload}

procedure ThtmlViewer.Reload;     {reload the last file}
var
  Pos: Integer;
begin
  if FCurrentFile <> '' then
  begin
    Pos := Position;
    if FCurrentFileType = HTMLType then
      LoadFromFile(FCurrentFile)
    else
    if FCurrentFileType = TextType then
      LoadTextFile(FCurrentFile)
    else
      LoadImageFile(FCurrentFile);
    Position := Pos;
  end;
end;

{----------------ThtmlViewer.GetOurPalette:}

function ThtmlViewer.GetOurPalette: HPalette;
begin
  if ColorBits = 8 then
    Result := CopyPalette(ThePalette)
  else
    Result := 0;
end;

{----------------ThtmlViewer.SetOurPalette}

procedure ThtmlViewer.SetOurPalette(Value: HPalette);
var
  NewPalette: HPalette;
begin
  if (Value <> 0) and (ColorBits = 8) then
  begin
    NewPalette := CopyPalette(Value);
    if NewPalette <> 0 then
    begin
      if ThePalette <> 0 then
        DeleteObject(ThePalette);
      ThePalette := NewPalette;
end;
  end;
end;

procedure ThtmlViewer.SetCaretPos(Value: Integer);
begin
  if Value >= 0 then
  begin
    FCaretPos := Value;
  end;
end;

function ThtmlViewer.FindSourcePos(DisplayPos: Integer; vvdfix: boolean = FALSE): Integer;
begin
  Result := FSectionList.FindSourcePos(DisplayPos);

// Added by vvd

  if vvdFix and FIsUtf16Source then
  begin
  // Utf8 -> Utf16
    if Result > Length(FDocumentSource) then
      Result := Length(FDocumentSource);
    Result := GetPos_Utf8ToUnicode(PChar(FDocumentSource) + 3, Result - 3);
  end;

// End of Added by vvd

end;

function ThtmlViewer.FindDisplayPos(SourcePos: Integer; Prev: boolean): Integer;
begin

// Added by vvd
  if FIsUtf16Source then
  begin
  // Utf16 -> Utf8
    if SourcePos > Length(FDocumentSourceUtf16) then
      SourcePos := Length(FDocumentSourceUtf16);
    SourcePos := 3 + GetPos_UnicodeToUtf8(PWideChar(FDocumentSourceUtf16), SourcePos);
  end;
//MessageBox (0, PChar (IntToStr (SourcePos)), '', 0);

// End of Added by vvd

  Result := FSectionList.FindDocPos(SourcePos, Prev);
end;

function ThtmlViewer.DisplayPosToXy(DisplayPos: Integer; var X, Y: Integer): boolean;
begin
  Result := FSectionList.CursorToXY(PaintPanel.Canvas, DisplayPos, X, Integer(Y));  {Integer() req'd for delphi 2}
end;

{----------------ThtmlViewer.SetProcessing}

procedure ThtmlViewer.SetProcessing(Value: boolean);
begin
  if (vsProcessing in FViewerState) <> Value then
  begin
    SetViewerStateBit(vsProcessing, Value);
    if Assigned(FOnProcessing) and not (csLoading in ComponentState) then
      FOnProcessing(Self, vsProcessing in FViewerState);
  end;
end;

procedure THTMLViewer.SetServerRoot(Value: string);
begin
  FServerRoot := ExcludeTrailingPathDelimiter(Trim(Value));
end;

procedure THTMLViewer.HandleMeta(Sender: TObject; const HttpEq, Name, Content: string);
var
  DelTime, I: Integer;
begin
  if Assigned(FOnMeta) then
    FOnMeta(Self, HttpEq, Name, Content);
  if Assigned(FOnMetaRefresh) then
    if CompareText(Lowercase(HttpEq), 'refresh') = 0 then
    begin
      I := Pos(';', Content);
      if I > 0 then
        DelTime := StrToIntDef(copy(Content, 1, I - 1), -1)
      else
        DelTime := StrToIntDef(Content, -1);
      if DelTime < 0 then
        Exit
      else
      if DelTime = 0 then
        DelTime := 1;
      I := Pos('url=', Lowercase(Content));
      if I > 0 then
        FRefreshURL := Copy(Content, I + 4, Length(Content) - I - 3)
      else
        FRefreshURL := '';
      FRefreshDelay := DelTime;
    end;
end;

procedure THTMLViewer.SetOptions(Value: ThtmlViewerOptions);
begin
  if Value <> FOptions then
  begin
    FOptions := Value;
    if Assigned(FSectionList) then
      with FSectionList do
      begin
        LinksActive := htOverLinksActive in FOptions;
        PrintTableBackground := (htPrintTableBackground in FOptions) or
          (htPrintBackground in FOptions);
        PrintBackground := htPrintBackground in FOptions;
        PrintMonoBlack := htPrintMonochromeBlack in FOptions;
        ShowDummyCaret := htShowDummyCaret in FOptions;
      end;
  end;
end;

procedure ThtmlViewer.Repaint;
var
  I: Integer;
begin
  for I := 0 to FormControlList.count - 1 do
    with TFormControlObj(FormControlList.Items[I]) do
      if Assigned(TheControl) then
        TheControl.Hide;
  BorderPanel.BorderStyle := bsNone;
  inherited Repaint;
end;

function THTMLViewer.GetDragDrop: TDragDropEvent;
begin
  Result := FOnDragDrop;
end;

procedure THTMLViewer.SetDragDrop(const Value: TDragDropEvent);
begin
  FOnDragDrop := Value;
  if Assigned(Value) then
    PaintPanel.OnDragDrop := HTMLDragDrop
  else
    PaintPanel.OnDragDrop := NIL;
end;

procedure THTMLViewer.HTMLDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if Assigned(FOnDragDrop) then
    FOnDragDrop(Self, Source, X, Y);
end;

function THTMLViewer.GetDragOver: TDragOverEvent;
begin
  Result := FOnDragOver;
end;

procedure THTMLViewer.SetDragOver(const Value: TDragOverEvent);
begin
  FOnDragOver := Value;
  if Assigned(Value) then
    PaintPanel.OnDragOver := HTMLDragOver
  else
    PaintPanel.OnDragOver := NIL;
end;

procedure THTMLViewer.HTMLDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Assigned(FOnDragOver) then
    FOnDragOver(Self, Source, X, Y, State, Accept);
end;

function THTMLViewer.GetFormData: TFreeList;
begin
  if Assigned(SectionList) then
    Result := SectionList.GetFormControlData
  else
    Result := NIL;
end;

procedure THTMLViewer.SetFormData(T: TFreeList);
begin
  if Assigned(SectionList) and Assigned(T) then
    with SectionList do
    begin
      ObjectClick := NIL;
      SetFormControlData(T);
      ObjectClick := OnObjectClick;
    end;
end;

procedure THTMLViewer.ReplaceImage(const NameID: string; NewImage: TStream);
var
  I: Integer;
  OldPos: Integer;
begin
  if FNameList.Find(NameID, I) then
    if FNameList.Objects[I] is TImageObj then
    begin
      TImageObj(FNameList.Objects[I]).ReplaceImage(NewImage);
      if not TImageObj(FNameList.Objects[I]).ImageKnown then
        if FSectionList.Count > 0 then
        begin
          FSectionList.GetBackgroundBitmap;    {load any background bitmap}
          OldPos := Position;
          DoLogic;
          Position := OldPos;
        end;
    end;
end;

function THTMLViewer.GetIDControl(const ID: string): TObject;
var
  I: Integer;
  Obj: TObject;
begin
  Result := NIL;
  with FSectionList.IDNameList do
    if Find(ID, I) then
    begin
      Obj := Objects[I];
      if (Obj is TFormControlObj) then
      begin
        if (Obj is THiddenFormControlObj) then
          Result := Obj
        else
          Result := TFormControlObj(Obj).TheControl;
      end
      else
      if (Obj is TImageObj) then
        Result := Obj;
    end;
end;

function THtmlViewer.GetIDDisplay(const ID: string): TPropDisplay;
var
  I: Integer;
  Obj: TObject;
begin
  Result := pdUnassigned;
  with FSectionList.IDNameList do
    if Find(ID, I) then
    begin
      Obj := Objects[I];
      if (Obj is TBlock) then
        Result := TBlock(Obj).Display;
    end;
end;

procedure THtmlViewer.SetIDDisplay(const ID: string; Value: TPropDisplay);
var
  I: Integer;
  Obj: TObject;
begin
  with FSectionList.IDNameList do
    if Find(ID, I) then
    begin
      Obj := Objects[I];
      if (Obj is TBlock) and (TBlock(Obj).Display <> Value) then
      begin
        FSectionList.HideControls;
        TBlock(Obj).Display := Value;
      end;
    end;
end;

procedure THTMLViewer.SetPrintScale(Value: double);
//BG, 29.08.2009: changed zoom factor limits from 0.25..4 to 0.125..8
//BG, 07.10.2009: constants for min/max zoom factor. 
const
  CMinPrintScale = 0.125;
  CMaxPrintScale = 8.0;
begin
  if Value > CMaxPrintScale then
    FPrintScale := CMaxPrintScale
  else
  if Value < CMinPrintScale then
    FPrintScale := CMinPrintScale
  else
    FPrintScale := Value;
end;

procedure THTMLViewer.Reformat;
var
  Pt: TPoint;
begin
  Layout;
  Update;
  GetCursorPos(Pt);
  SetCursorPos(Pt.X, Pt.Y); {trigger a mousemove to keep cursor correct}
end;

procedure THTMLViewer.htProgressInit;
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, psStarting, 0);
end;

procedure THTMLViewer.htProgress(Percent: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, psRunning, Percent);
end;

procedure THTMLViewer.htProgressEnd;
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, psEnding, 100);
end;

{----------------TPaintPanel.CreateIt}


{AlekID}
procedure TPaintPanel.CMHintShow(var Message: TMessage);
begin
inherited;
  with TCMHintShow(Message) do begin
    HintInfo.HintData := HintInfo;
    HintInfo.HintStr := GetShortHint(HintInfo.HintControl.Hint);
  end;
end;
{/AlekiD}


constructor TPaintPanel.CreateIt(AOwner: TComponent; Viewer: ThtmlViewer);
begin
  inherited Create(AOwner);
  FViewer := Viewer;
end;

{----------------TPaintPanel.Paint}

procedure TPaintPanel.Paint;
var
  MemDC: HDC;
  ABitmap: HBitmap;
  ARect: TRect;
  OldPal: HPalette;
begin
  if (vsDontDraw in FViewer.FViewerState) or (Canvas2 <> NIL) then
    Exit;
  FViewer.DrawBorder;
  OldPal := 0;
  Canvas.Font := Font;
  Canvas.Brush.Color := Color;
  ARect := Canvas.ClipRect;
  Canvas2 := TCanvas.Create;   {paint on a memory DC}
  try
    MemDC := CreateCompatibleDC(Canvas.Handle);
    ABitmap := 0;
    try
      with ARect do
      begin
        ABitmap := CreateCompatibleBitmap(Canvas.Handle, Right - Left, Bottom - Top);
        if (ABitmap = 0) and (Right - Left + Bottom - Top <> 0) then
          raise EOutOfResources.Create('Out of Resources');
        try
          SelectObject(MemDC, ABitmap);
          SetWindowOrgEx(memDC, Left, Top, NIL);
          Canvas2.Handle := MemDC;
          DoBackground(Canvas2);
          if Assigned(FOnPaint) then
            FOnPaint(Self);
          OldPal := SelectPalette(Canvas.Handle, ThePalette, FALSE);
          RealizePalette(Canvas.Handle);
          BitBlt(Canvas.Handle, Left, Top, Right - Left, Bottom - Top,
            MemDC, Left, Top, SrcCopy);
        finally
          if OldPal <> 0 then
            SelectPalette(MemDC, OldPal, FALSE);
          Canvas2.Handle := 0;
        end;
      end;
    finally
      DeleteDC(MemDC);
      DeleteObject(ABitmap);
    end;
  finally
    FreeAndNil(Canvas2);
  end;
end;

procedure TPaintPanel.DoBackground(ACanvas: TCanvas);
var
  ARect: TRect;
  Image: TGpObject;
  Mask, NewBitmap, NewMask: TBitmap;
  PRec: PtPositionRec;
  BW, BH, X, Y, X2, Y2, IW, IH, XOff, YOff: Integer;
  AniGif: TGifImage;
begin
  with FViewer do
  begin
    if FSectionList.Printing then
      Exit;    {no background}

    ARect := Canvas.ClipRect;
    Image := FSectionList.BackgroundBitmap;
    if FSectionList.ShowImages and Assigned(Image) then
    begin
      Mask := FSectionList.BackgroundMask;
      BW := GetImageWidth(Image);
      BH := GetImageHeight(Image);
      PRec := FSectionList.BackgroundPRec;
      SetViewerStateBit(vsBGFixed, PRec[1].Fixed);
      if vsBGFixed in FViewerState then
      begin  {fixed background}
        XOff := 0;
        YOff := 0;
        IW := Self.ClientRect.Right;
        IH := Self.ClientRect.Bottom;
      end
      else
      begin   {scrolling background}
        XOff := HScrollbar.Position;
        YOff := FSectionList.YOff;
        IW := HScrollbar.Max;
        IH := Max(MaxVertical, Self.ClientRect.Bottom);
      end;

    {Calculate where the tiled background images go}
      CalcBackgroundLocationAndTiling(PRec, ARect, XOff, YOff, IW, IH, BW, BH, X, Y, X2, Y2);

      if (BW = 1) or (BH = 1) then
      begin  {this is for people who try to tile 1 pixel images}
        NewBitmap := EnlargeImage(Image, X2 - X, Y2 - Y);// as TBitmap;
        try
          if Assigned(Mask) then
            NewMask := TBitmap(EnlargeImage(Mask, X2 - X, Y2 - Y))
          else
            NewMask := NIL;
          try
            DrawBackground(ACanvas, ARect, X, Y, X2, Y2, NewBitmap, NewMask, NIL, NewBitmap.Width, NewBitmap.Height, Self.Color);
          finally
            NewMask.Free;
          end;
        finally
          NewBitmap.Free;
        end;
      end
      else  {normal situation}
      begin
        AniGif := FSectionList.BackgroundAniGif;
        DrawBackground(ACanvas, ARect, X, Y, X2, Y2, Image, Mask, AniGif, BW, BH, Self.Color);
      end;
    end
    else
    begin  {no background image, show color only}
      Exclude(FViewerState, vsBGFixed);
      DrawBackground(ACanvas, ARect, 0, 0, 0, 0, NIL, NIL, NIL, 0, 0, Self.Color);
    end;
  end;
end;

procedure TPaintPanel.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;   {it's erased}
end;

{----------------TPaintPanel.WMLButtonDblClk}

procedure TPaintPanel.WMLButtonDblClk(var Message: TWMMouse);
begin
  if Message.Keys and MK_LButton <> 0 then
    ThtmlViewer(FViewer).HTMLMouseDblClk(Message);
end;

//{ T32ScrollBar }
//
//procedure T32ScrollBar.SetParams(APosition, APage, AMin, AMax: Integer);
//var
//  ScrollInfo: TScrollInfo;
//begin
//  if (APosition <> FPosition) or (APage <> FPage) or (AMin <> FMin)
//    or (AMax <> FMax) then
//    with ScrollInfo do
//    begin
//      cbSize := SizeOf(ScrollInfo);
//      fMask := SIF_ALL;
//      if htShowVScroll in (Owner as THtmlViewer).FOptions then
//        fMask := fMask or SIF_DISABLENOSCROLL;
//      nPos := APosition;
//      nPage := APage;
//      nMin := AMin;
//      nMax := AMax;
//      SetScrollInfo(Handle, SB_CTL, ScrollInfo, True);
//      FPosition := APosition;
//      FPage := APage;
//      FMin := AMin;
//      FMax := AMax;
//    end;
//end;
//
//procedure T32ScrollBar.SetPosition(Value: Integer);
//var
//  SavePos: Integer;
//begin
//  SavePos := FPosition;
//  SetParams(Value, FPage, FMin, FMax);
//  if FPosition <> SavePos then
//    Change;
//end;
//
//procedure T32ScrollBar.SetMin(Value: Integer);
//begin
//  SetParams(FPosition, FPage, Value, FMax);
//end;
//
//procedure T32ScrollBar.SetMax(Value: Integer);
//begin
//  SetParams(FPosition, FPage, FMin, Value);
//end;
//
//{$ifdef LCL}
//procedure T32ScrollBar.CNVScroll(var Message: TLMVScroll);
//{$else}
//procedure T32ScrollBar.CNVScroll(var Message: TWMVScroll);
//{$endif}
//var
//  SPos: Integer;
//  ScrollInfo: TScrollInfo;
//  OrigPos: Integer;
//  TheChange: Integer;
//begin
//  with THtmlViewer(Parent) do
//  begin
//    ScrollInfo.cbSize := SizeOf(ScrollInfo);
//    ScrollInfo.fMask := SIF_ALL;
//    GetScrollInfo(Self.Handle, SB_CTL, ScrollInfo);
//    if TScrollCode(Message.ScrollCode) = scTrack then
//    begin
//      OrigPos := ScrollInfo.nPos;
//      SPos := ScrollInfo.nTrackPos;
//    end
//    else
//    begin
//      SPos := ScrollInfo.nPos;
//      OrigPos := SPos;
//      case TScrollCode(Message.ScrollCode) of
//        scLineUp:
//          Dec(SPos, SmallChange);
//        scLineDown:
//          Inc(SPos, SmallChange);
//        scPageUp:
//          Dec(SPos, LargeChange);
//        scPageDown:
//          Inc(SPos, LargeChange);
//        scTop:
//          SPos := 0;
//        scBottom:
//          SPos := (FMaxVertical - PaintPanel.Height);
//      end;
//    end;
//    SPos := Math.Max(0, Math.Min(SPos, (FMaxVertical - PaintPanel.Height)));
//
//    Self.SetPosition(SPos);
//
//    FSectionList.SetYOffset(SPos);
//    if vsBGFixed in FViewerState then
//      PaintPanel.Invalidate
//    else
//    begin {scroll background}
//      TheChange := OrigPos - SPos;
//      ScrollWindow(PaintPanel.Handle, 0, TheChange, nil, nil);
//      PaintPanel.Update;
//    end;
//  end;
//end;

{ PositionObj }

destructor PositionObj.Destroy;
begin
  FormData.Free;
  inherited;
end;

end.
