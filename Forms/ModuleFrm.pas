unit ModuleFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Tabs, Vcl.DockTabSet, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ToolWin, HTMLEmbedInterfaces, Htmlview,
  bqClosableTabControl, System.ImageList, Vcl.ImgList, Vcl.Menus, TabData, HintTools,
  CommandProcessor, BibleQuoteUtils, ShellAPI, System.StrUtils,
  LinksParserIntf, SevenZipHelper, HTMLUn2, ExceptionFrm, InputFrm,
  ShlObj, contnrs, Clipbrd, Bible, Math, StringProcs, ModuleViewIntf, MainFrm;

const
  bsText = 0;
  bsFile = 1;
  bsBookmark = 2;
  bsMemo = 3;
  bsHistory = 4;
  bsSearch = 5;

type
  TModuleForm = class(TForm, IModuleView)
    ilImages: TImageList;
    ilPictures24: TImageList;
    pnlMain: TPanel;
    pgcViewTabs: TClosableTabControl;
    pnlMainView: TPanel;
    bwrHtml: THTMLViewer;
    pnlViewPageToolbar: TPanel;
    tlbViewPage: TToolBar;
    tbtnBack: TToolButton;
    tbtnForward: TToolButton;
    tbtnSep02: TToolButton;
    tbtnPrevChapter: TToolButton;
    tbtnNextChapter: TToolButton;
    tbtnSep03: TToolButton;
    tbtnCopy: TToolButton;
    tbtnStrongNumbers: TToolButton;
    tbtnMemos: TToolButton;
    tbtnSep07: TToolButton;
    tbtnQuickSearch: TToolButton;
    tbtnSep09: TToolButton;
    tedtReference: TEdit;
    tbtnReference: TToolButton;
    tbtnReferenceInfo: TToolButton;
    tlbQuickSearch: TToolBar;
    tbtnQuickSearchPrev: TToolButton;
    tedtQuickSearch: TEdit;
    tbtnQuickSearchNext: TToolButton;
    tbtnSep08: TToolButton;
    tbtnMatchCase: TToolButton;
    tbtnMatchWholeWord: TToolButton;
    pnlPaint: TPanel;
    imgLoadProgress: TImage;
    dtsBible: TDockTabSet;
    mViewTabsPopup: TPopupMenu;
    miNewViewTab: TMenuItem;
    miCloseViewTab: TMenuItem;
    miCloseAllOtherTabs: TMenuItem;
    pmBrowser: TPopupMenu;
    miSearchWord: TMenuItem;
    miSearchWindow: TMenuItem;
    miCompare: TMenuItem;
    N3: TMenuItem;
    miCopySelection: TMenuItem;
    miCopyPassage: TMenuItem;
    miCopyVerse: TMenuItem;
    N2: TMenuItem;
    miAddBookmark: TMenuItem;
    miAddBookmarkTagged: TMenuItem;
    miAddMemo: TMenuItem;
    N4: TMenuItem;
    miMemosToggle: TMenuItem;
    pmMemo: TPopupMenu;
    miMemoCopy: TMenuItem;
    miMemoCut: TMenuItem;
    miMemoPaste: TMenuItem;
    procedure pgcViewTabsChange(Sender: TObject);
    procedure pgcViewTabsChanging(Sender: TObject; var AllowChange: Boolean);
    procedure pgcViewTabsContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure pgcViewTabsDeleteTab(sender: TClosableTabControl; index: Integer);
    procedure pgcViewTabsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure pgcViewTabsDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure pgcViewTabsGetImageIndex(Sender: TObject; TabIndex: Integer; var ImageIndex: Integer);
    procedure pgcViewTabsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pgcViewTabsStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure pgcViewTabsTabDoubleClick(sender: TClosableTabControl; index: Integer);
    procedure miNewViewTabClick(Sender: TObject);
    procedure miCloseViewTabClick(Sender: TObject);
    procedure miCloseAllOtherTabsClick(Sender: TObject);
    procedure dtsBibleChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure dtsBibleClick(Sender: TObject);
    procedure bwrHtmlHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure bwrHtmlHotSpotCovered(Sender: TObject; const SRC: string);
    procedure bwrHtmlImageRequest(Sender: TObject; const SRC: string; var Stream: TMemoryStream);
    procedure bwrHtmlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bwrHtmlKeyPress(Sender: TObject; var Key: Char);
    procedure bwrHtmlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bwrHtmlMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bwrHtmlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bwrHtmlMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure miSearchWordClick(Sender: TObject);
    procedure miSearchWindowClick(Sender: TObject);
    procedure miCompareClick(Sender: TObject);
    procedure miCopySelectionClick(Sender: TObject);
    procedure miCopyPassageClick(Sender: TObject);
    procedure miCopyVerseClick(Sender: TObject);
    procedure miAddBookmarkClick(Sender: TObject);
    procedure miAddBookmarkTaggedClick(Sender: TObject);
    procedure miAddMemoClick(Sender: TObject);
    procedure miMemosToggleClick(Sender: TObject);
    procedure tbtnQuickSearchNextClick(Sender: TObject);
    procedure tbtnQuickSearchPrevClick(Sender: TObject);
    procedure tedtQuickSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tbtnBackClick(Sender: TObject);
    procedure tbtnCopyClick(Sender: TObject);
    procedure tbtnForwardClick(Sender: TObject);
    procedure tbtnMemosClick(Sender: TObject);
    procedure tbtnNextChapterClick(Sender: TObject);
    procedure tbtnPrevChapterClick(Sender: TObject);
    procedure tbtnQuickSearchClick(Sender: TObject);
    procedure tbtnReferenceClick(Sender: TObject);
    procedure tbtnReferenceInfoClick(Sender: TObject);
    procedure tbtnStrongNumbersClick(Sender: TObject);
    procedure tedtReferenceChange(Sender: TObject);
    procedure tedtReferenceDblClick(Sender: TObject);
    procedure tedtReferenceEnter(Sender: TObject);
    procedure tedtReferenceKeyPress(Sender: TObject; var Key: Char);
    procedure miMemoCopyClick(Sender: TObject);
    procedure miMemoCutClick(Sender: TObject);
    procedure miMemoPasteClick(Sender: TObject);

    procedure dtsBibleDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dtsBibleDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure dtsBibleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure dtsBibleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure dtsBibleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure FormCreate(Sender: TObject);
    procedure pmBrowserPopup(Sender: TObject);
    function GetActiveTabInfo(): TViewTabInfo;
  private
    { Private declarations }
    mMainView: TMainForm;
  public
    { Public declarations }

    constructor Create(AOwner: TComponent; mainView: TMainForm); reintroduce;

    procedure BrowserHotSpotCovered(viewer: THTMLViewer; src: string);
    procedure CloseCurrentTab();
    procedure CopyBrowserSelectionToClipboard();
    procedure SetMemosVisible(showMemos: Boolean);
    procedure UpdateViewTabs();
    procedure ToggleQuickSearchPanel(const enable: Boolean);
    procedure ToggleStrongNumbers();

    // getters
    function GetBrowser: THTMLViewer;
    function GetViewTabs: TClosableTabControl;
    function GetBibleTabs: TDockTabSet;

    // properties
    property ViewTabs: TClosableTabControl read GetViewTabs;
    property Browser: THTMLViewer read GetBrowser;
    property BibleTabs: TDockTabSet read GetBibleTabs;
  end;

implementation

{$R *.dfm}

function TModuleForm.GetViewTabs(): TClosableTabControl;
begin
  Result := pgcViewTabs;
end;

function TModuleForm.GetBrowser(): THTMLViewer;
begin
  Result := bwrHtml;
end;

function TModuleForm.GetBibleTabs(): TDockTabSet;
begin
  Result := dtsBible;
end;

constructor TModuleForm.Create(AOwner: TComponent; mainView: TMainForm);
begin
  inherited Create(AOwner);
  mMainView := mainView;
end;

procedure TModuleForm.bwrHtmlHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  first: integer;
  scode, unicodeSRC: string;
  cb: THTMLViewer;
  lr: Boolean;
  ws: string;
  iscontrolDown: Boolean;
  tabInfo: TViewTabInfo;
  viewTabState: TViewTabInfoState;
  Key: Char;
begin
  unicodeSRC := SRC;
  iscontrolDown := IsDown(VK_CONTROL);
  if GetCommandType(SRC) = bqctGoCommand then
  // verse hyperlink
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
          mMainView.LoadBibleToXref(unicodeSRC, ws);
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
        viewTabState := mMainView.DefaultViewTabState;
      end
      else
        viewTabState := tabInfo.State;

      mMainView.NewViewTab(unicodeSRC, '', bwrHtml.Base, viewTabState, '', true);

    end
    else
    begin

      mMainView.ProcessCommand(unicodeSRC, hlDefault);
    end;
    Handled := true;
  end

  else if Pos('http://', unicodeSRC) = 1 then { // WWW }
  begin
    if (Application.MessageBox(
      PChar(Format(Lang.Say('GoingOnline'), [unicodeSRC])),
      'WWW',
      MB_OKCancel Or MB_DEFBUTTON1) = ID_OK) then
    begin
      ShellExecute(Application.Handle, nil, PChar(unicodeSRC), nil, nil, SW_NORMAL);
    end;

    Handled := true;
  end
  else if Pos('mailto:', unicodeSRC) = 1 then
  begin
    ShellExecute(Application.Handle, nil, PChar(unicodeSRC), nil, nil, SW_NORMAL);
    Handled := true;
  end
  else if Pos('verse ', unicodeSRC) = 1 then
  begin
    mMainView.tbXRef.tag := StrToInt(Copy(unicodeSRC, 7, Length(unicodeSRC) - 6));
    mMainView.tbComments.tag := mMainView.tbXRef.tag;

    with mMainView.MainBook do
      mMainView.HistoryAdd(Format('go %s %d %d %d %d $$$%s %s', [ShortPath, CurBook,
        CurChapter, mMainView.tbXRef.tag, 0,
        // history comment
        ShortName, FullPassageSignature(CurBook, CurChapter, mMainView.tbXRef.tag, 0)]));

    if iscontrolDown or (mMainView.pgcMain.Visible and (mMainView.pgcMain.ActivePage = mMainView.tbComments))
    then
      mMainView.ShowComments
    else
    begin
      try
        mMainView.ShowXref;
      finally
        mMainView.ShowComments;
      end;
    end;

    if not mMainView.pgcMain.Visible then
      mMainView.tbtnToggle.Click;
    if ((mMainView.pgcMain.ActivePage <> mMainView.tbXRef) or iscontrolDown) and
      (mMainView.pgcMain.ActivePage <> mMainView.tbComments) then
      if iscontrolDown then
        mMainView.pgcMain.ActivePage := mMainView.tbComments
      else
        mMainView.pgcMain.ActivePage := mMainView.tbXRef;
  end
  else if Pos('s', unicodeSRC) = 1 then
  begin
    scode := Copy(unicodeSRC, 2, Length(unicodeSRC) - 1);

    mMainView.edtStrong.Text := scode;
    Key := #13;
    mMainView.edtStrongKeyPress(Sender, Key);
  end
  else
  begin
    cb := Sender as THTMLViewer;
    if Pos('BQNote', cb.LinkAttributes.Text) > 0 then
    begin
      Handled := true;
      mMainView.bwrXRef.CharSet := mMainView.MainBook.desiredCharset;
      try
        if EndsStr('??', cb.Base) then
        begin
          unicodeSRC := ReplaceStr(cb.HtmlExpandFilename(SRC), '??\', '??');
        end
        else
          unicodeSRC := cb.HtmlExpandFilename(SRC);

        lr := mMainView.LoadAnchor(mMainView.bwrComments, unicodeSRC, cb.CurrentFile, unicodeSRC);
        if lr then
        begin
          if not mMainView.pgcMain.Visible then
            mMainView.tbtnToggle.Click;
          mMainView.pgcMain.ActivePage := mMainView.tbComments;
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
  // in all other cases, the link is processed according to HTML rules :-)
end;

procedure TModuleForm.BrowserHotSpotCovered(viewer: THTMLViewer; src: string);
var
  unicodeSRC, ConcreteCmd: string;
  wstr, ws2, fontName, replaceModPath: string;
  bl: TBibleLink;
  ti: TViewTabInfo;
  modIx, status: integer;
begin
  if (SRC = '') or (viewer.LinkAttributes.Count < 3) then
  begin
    viewer.Hint := '';
    bwrHtml.Hint := '';
    Application.CancelHint();
    Exit
  end;
  if Pos(viewer.LinkAttributes[2], 'CLASS=bqResolvedLink') <= 0 then
    Exit;

  unicodeSRC := SRC;
  wstr := PeekToken(Pointer(unicodeSRC), ' ');
  if SysUtils.CompareText(wstr, 'go') <> 0 then
    Exit;

  if Length(wstr) <= 0 then
    Exit;
  ti := GetActiveTabInfo();

  if (viewer <> bwrHtml) and (ti.Bible.isBible) then
    replaceModPath := ti.Bible.ShortPath
  else
  begin
    modIx := mMainView.mModules.FindByName(ti.SatelliteName);
    if modIx >= 0 then
    begin
      replaceModPath := mMainView.mModules[modIx].mShortPath;
    end;
  end;
  status := mMainView.PreProcessAutoCommand(unicodeSRC, replaceModPath, ConcreteCmd);
  if status > -2 then
    status := mMainView.GetModuleText(ConcreteCmd, fontName, bl, ws2, wstr,
      [gmtBulletDelimited, gmtLookupRefBibles, gmtEffectiveAddress]);

  if status < 0 then
    wstr := ConcreteCmd + #13#10'--не найдено--'
  else
  begin
    wstr := wstr + ' (' + mMainView.mRefenceBible.ShortName + ')'#13#10;
    if ws2 <> '' then
      wstr := wstr + ws2
    else
      wstr := wstr + '--не найдено--';
  end;

  viewer.Hint := '';
  viewer.Hint := wstr;
  HintWindowClass := HintTools.TbqHintWindow;
  Application.CancelHint();
  HintWindowClass := HintTools.TbqHintWindow;
end;

procedure TModuleForm.bwrHtmlHotSpotCovered(Sender: TObject; const SRC: string);
begin
  BrowserHotSpotCovered(Sender as THTMLViewer, SRC);
end;

procedure TModuleForm.bwrHtmlImageRequest(Sender: TObject; const SRC: string; var Stream: TMemoryStream);
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
    archive := vti.Bible.inifile;
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

procedure TModuleForm.bwrHtmlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  mMainView.BrowserPosition := bwrHtml.Position;

  if (Shift = [ssCtrl]) then
  begin
    if (Key = VK_INSERT) then
    begin
      Key := 0;
      CopyBrowserSelectionToClipboard();
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
end;

procedure TModuleForm.bwrHtmlKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = '+' then
  begin
    Key := #0;
    mMainView.FontChanged(1);
  end
  else if Key = '-' then
  begin
    Key := #0;
    mMainView.FontChanged(-1);
  end;
end;

procedure TModuleForm.bwrHtmlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  oxt, oct: integer;
begin
  if GetActiveTabInfo().LocationType = vtlFile then
    Exit;

  if (Key = VK_NEXT) and (bwrHtml.Position = mMainView.BrowserPosition) then
  begin
    mMainView.GoNextChapter;
    Exit;
  end;
  if (Key = VK_PRIOR) and (bwrHtml.Position = mMainView.BrowserPosition) then
  begin
    mMainView.GoPrevChapter;
    if (mMainView.MainBook.CurBook <> 1) or (mMainView.MainBook.CurChapter <> 1) then
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
    mMainView.miRecognizeBibleLinks.Click();
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
    oxt := mMainView.tbXRef.tag;
    oct := mMainView.tbComments.tag;
    mMainView.tbXRef.tag := Get_ANAME_VerseNumber(bwrHtml.DocumentSource, mMainView.CurFromVerse, bwrHtml.FindSourcePos(bwrHtml.CaretPos, true));
    mMainView.tbComments.tag := mMainView.tbXRef.tag;
    if (mMainView.pgcMain.ActivePage = mMainView.tbXRef) and (oxt <> mMainView.tbXRef.tag) then
    begin
      mMainView.ShowXref;
      Exit

    end;

    if (mMainView.pgcMain.ActivePage = mMainView.tbComments) and (oct <> mMainView.tbComments.tag) then
    begin
      mMainView.ShowComments;
      Exit
    end;
  end;
end;

procedure TModuleForm.bwrHtmlMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  num, code: integer;
begin
  if not mMainView.mDictionariesFullyInitialized then
  begin
    mMainView.LoadDictionaries(true);
  end;

  Val(Trim(bwrHtml.SelText), num, code);
  if code = 0 then
  begin
    mMainView.DisplayStrongs(num, (mMainView.MainBook.CurBook < 40) and
      (mMainView.MainBook.Trait[bqmtOldCovenant]));
  end
  else
  begin
    mMainView.DisplayDictionary(Trim(bwrHtml.SelText));
  end;

  if not mMainView.pgcMain.Visible then
    mMainView.tbtnToggle.Click;
end;

procedure TModuleForm.bwrHtmlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TModuleForm.bwrHtmlMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
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
        (bwrHtml.VScrollBarPosition >= mMainView.msbPosition) then
      begin
        if mMainView.mScrollAcc > 2 then
        begin
          lastWheelTime := tm;
          mMainView.GoNextChapter();
          Handled := true;

        end
        else
          inc(mMainView.mScrollAcc);
      end
      else
        mMainView.mScrollAcc := 0;
    end
    else if WheelDelta > 0 then
    begin
      if (bwrHtml.VScrollBarPosition <= 0) and
        (bwrHtml.VScrollBarPosition <= mMainView.msbPosition) then
      begin
        if mMainView.mScrollAcc > 2 then
        begin
          lastWheelTime := tm;
          mMainView.GoPrevChapter();
          bwrHtml.PositionTo('endofchapterNMFHJAHSTDGF123');
          Handled := true;
        end
        else
          inc(mMainView.mScrollAcc);

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

  mMainView.FontChanged(delta);
end;

procedure TModuleForm.dtsBibleChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
var
  me: TModuleEntry;
begin
  if mMainView.mInterfaceLock then
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
      mMainView.GoModuleName(me.mFullName);
    end;
  except
    on E: Exception do
      BqShowException(E);
  end;

  mMainView.tbLinksToolBar.Visible := false;
end;

procedure TModuleForm.dtsBibleClick(Sender: TObject);
var
  pt: TPoint;
  it, modIx: integer;
  me: TModuleEntry;
  ti: TViewTabInfo;
  s: string;
begin
  if mMainView.mInterfaceLock then
    Exit;
  pt := dtsBible.ScreenToClient(Mouse.CursorPos);
  it := dtsBible.ItemAtPos(pt);
  if (it < 0) or (it >= dtsBible.Tabs.Count) then
    Exit;
  if (it = dtsBible.Tabs.Count - 1) then
  begin
    if IsDown(VK_SHIFT) then
    begin
      mMainView.SelectSatelliteBibleByName('');
      Exit;
    end;
    modIx := mMainView.mModules.FindByFolder(GetActiveTabInfo().Bible.ShortPath);
    if modIx >= 0 then
    begin
      me := TModuleEntry(mMainView.mModules.Items[modIx]);
      if mMainView.mFavorites.AddModule(me) then
        mMainView.AdjustBibleTabs();
    end;
    Exit;
  end;

  me := dtsBible.Tabs.Objects[it] as TModuleEntry;
  if IsDown(VK_SHIFT) then
  begin
    mMainView.SelectSatelliteBibleByName(me.mFullName);
    Exit;
  end;
  if IsDown(VK_MENU) then
  begin
    ti := GetActiveTabInfo();
    s := ti.Location;
    StrReplace(s, mMainView.MainBook.ShortPath, me.mShortPath, false);
    mMainView.NewViewTab(s, ti.SatelliteName, '', ti.State, '', true);
    Exit;
  end;
end;

procedure TModuleForm.dtsBibleDragDrop(Sender, Source: TObject; X, Y: Integer);
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
      ViewTabInfo := TObject((TObject((Source as TClosableTabControl).tag) as TTabSheet).tag) as TViewTabInfo;
      if TabIndex = dtsBible.Tabs.Count - 1 then
      begin
        // drop on *** - last tab, adding new tab
        modIx := mMainView.mModules.FindByFolder(ViewTabInfo.Bible.ShortPath);
        if modIx >= 0 then
        begin
          me := TModuleEntry(mMainView.mModules.Items[modIx]);
          mMainView.mFavorites.AddModule(me);
          mMainView.AdjustBibleTabs(mMainView.MainBook.ShortName);
        end;
        Exit;
      end;
      // replace
      modIx := mMainView.mModules.FindByFolder(ViewTabInfo.Bible.ShortPath);
      if modIx < 0 then
        Exit;

      me := TModuleEntry(mMainView.mModules.Items[modIx]);
      if not Assigned(me) then
        Exit;

      mMainView.mFavorites.ReplaceModule(TModuleEntry(dtsBible.Tabs.Objects[TabIndex]), me);
      mMainView.AdjustBibleTabs(mMainView.MainBook.ShortName);
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

    mMainView.mFavorites.MoveItem(me, TabIndex);

    mMainView.AdjustBibleTabs(mMainView.MainBook.ShortName);
    mMainView.SetFavouritesShortcuts();
  end;
end;

procedure TModuleForm.dtsBibleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TModuleForm.dtsBibleDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
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

procedure TModuleForm.dtsBibleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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
    mMainView.hint_expanded := 0;
  end
  else if mMainView.hint_expanded >= 1 then
    Exit; // same tab hint already expanded

  if (it < 0) or (it = dtsBible.Tabs.Count - 1) then
  begin
    dtsBible.Hint := '';
    Exit
  end;

  me := dtsBible.Tabs.Objects[it] as TModuleEntry;
  ws := me.mFullName;

  if mMainView.hint_expanded = 0 then
    mMainView.hint_expanded := 1;
  dtsBible.Hint := ws;
  Application.CancelHint();
end;

procedure TModuleForm.dtsBibleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  itemIx: integer;
begin
  mMainView.miDeteleBibleTab.tag := 0;
  if Button <> mbRight then
    Exit;
  pt.X := X;
  pt.Y := Y;
  itemIx := dtsBible.ItemAtPos(pt);
  if ((itemIx < 0) or (itemIx >= dtsBible.Tabs.Count - 1)) or (dtsBible.Tabs.Count <= 2) then
    Exit;

  mMainView.miDeteleBibleTab.tag := itemIx;
  pt := dtsBible.ClientToScreen(pt);
  mMainView.pmEmpty.Popup(pt.X, pt.Y);
end;

procedure TModuleForm.FormCreate(Sender: TObject);
begin
//
end;

procedure TModuleForm.miAddBookmarkClick(Sender: TObject);
begin
  mMainView.AddBookmark(miAddBookmark.Caption);
end;

procedure TModuleForm.miAddBookmarkTaggedClick(Sender: TObject);
begin
   mMainView.AddBookmarkTagged();
end;

procedure TModuleForm.miAddMemoClick(Sender: TObject);
begin
  if (mMainView.AddMemo(miAddMemo.Caption)) then
  begin
    if not mMainView.MemosOn then
      miMemosToggle.Click
    else
    begin
      miMemosToggle.Click; // off
      miMemosToggle.Click; // on - to show new memos...
    end;
  end;
end;

procedure TModuleForm.miCloseAllOtherTabsClick(Sender: TObject);
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

procedure TModuleForm.CloseCurrentTab();
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

procedure TModuleForm.miCloseViewTabClick(Sender: TObject);
begin
  CloseCurrentTab;
end;

procedure TModuleForm.miCompareClick(Sender: TObject);
begin
  mMainView.CompareTranslations();
end;

procedure TModuleForm.miCopyPassageClick(Sender: TObject);
begin
  mMainView.CopyPassageToClipboard();
end;

procedure TModuleForm.CopyBrowserSelectionToClipboard();
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
        if not(mMainView.CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then
        begin
          if bwrHtml.tag <= bsText then
          begin
            s := Clipboard.AsText;

            // carriage returns are replaced by space
            StrReplace(s, '  ', ' ', true);

            // double spaces are replaced by single space
            Clipboard.AsText := s;
          end
          else
            Clipboard.AsText := mMainView.CopyPassage(mMainView.CurFromVerse, mMainView.CurToVerse);
        end
      end;
      trCount := 0;
    except
      Dec(trCount);
      sleep(100);
    end;
  until trCount <= 0;
end;

procedure TModuleForm.miCopySelectionClick(Sender: TObject);
begin
  CopyBrowserSelectionToClipboard();
end;

procedure TModuleForm.miCopyVerseClick(Sender: TObject);
begin
  mMainView.CopyVerse;
end;

procedure TModuleForm.miMemoCopyClick(Sender: TObject);
begin
  if pmMemo.PopupComponent = mMainView.reMemo then
    mMainView.reMemo.CopyToClipboard
  else if pmMemo.PopupComponent is TEdit then
    (pmMemo.PopupComponent as TEdit).CopyToClipboard
  else if pmMemo.PopupComponent is TComboBox then
    Clipboard.AsText := (pmMemo.PopupComponent as TComboBox).Text;
end;

procedure TModuleForm.miMemoCutClick(Sender: TObject);
begin
  if pmMemo.PopupComponent = mMainView.reMemo then
    mMainView.reMemo.CutToClipboard
  else if pmMemo.PopupComponent is TEdit then
    (pmMemo.PopupComponent as TEdit).CutToClipboard
  else if pmMemo.PopupComponent is TComboBox then
  begin
    Clipboard.AsText := (pmMemo.PopupComponent as TComboBox).Text;
    (pmMemo.PopupComponent as TComboBox).Text := '';
  end;
end;

procedure TModuleForm.miMemoPasteClick(Sender: TObject);
begin
  if pmMemo.PopupComponent = mMainView.reMemo then
    mMainView.reMemo.PasteFromClipboard
  else if pmMemo.PopupComponent is TEdit then
    (pmMemo.PopupComponent as TEdit).PasteFromClipboard;
end;

procedure TModuleForm.SetMemosVisible(showMemos: Boolean);
var
  ti: TViewTabInfo;
begin
  miMemosToggle.Checked := showMemos;
  tbtnMemos.Down := showMemos;

  mMainView.MemosOn := showMemos;
  ti := GetActiveTabInfo();
  ti[vtisShowNotes] := showMemos;

  mMainView.ProcessCommand(ti.Location, TbqHLVerseOption(ord(ti[vtisHighLightVerses])));
end;

procedure TModuleForm.miMemosToggleClick(Sender: TObject);
begin
  SetMemosVisible(miMemosToggle.Checked);
end;

procedure TModuleForm.miNewViewTabClick(Sender: TObject);
var
  activeTabInfo: TViewTabInfo;
begin
  activeTabInfo := GetActiveTabInfo();
  if (activeTabInfo <> nil) then
  begin
    mMainView.NewViewTab(activeTabInfo.Location, activeTabInfo.SatelliteName, '', activeTabInfo.State, '', true);
  end;
end;

procedure TModuleForm.miSearchWindowClick(Sender: TObject);
begin
  mMainView.pgcMain.ActivePageIndex := 0; // to the first tab
  mMainView.pgcHistoryBookmarks.ActivePageIndex := 2;

  // to quick search tab
  Winapi.Windows.SetFocus(tedtQuickSearch.Handle);

  if bwrHtml.SelLength <> 0 then
  begin
    tedtQuickSearch.Text := Trim(bwrHtml.SelText);
    mMainView.SearchForward();
  end;
end;

procedure TModuleForm.miSearchWordClick(Sender: TObject);
begin
  if bwrHtml.SelLength = 0 then
    Exit;

  mMainView.IsSearching := false;
  mMainView.cbSearch.Text := Trim(bwrHtml.SelText);
  mMainView.miSearch.Click;
  mMainView.btnFindClick(Sender);
end;

procedure TModuleForm.UpdateViewTabs();
var
  tabInfo: TViewTabInfo;
begin
  try
    tabInfo := GetActiveTabInfo();
    try
      bwrHtml.NoScollJump := true;
      mMainView.UpdateUI();

      if (tabInfo.IsCompareTranslation) then
      begin
        bwrHtml.LoadFromString(tabInfo.CompareTranslationText);
      end
      else
      begin
        mMainView.ProcessCommand(tabInfo.Location, TbqHLVerseOption(ord(tabInfo[vtisHighLightVerses])));
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

procedure TModuleForm.pgcViewTabsChange(Sender: TObject);
begin
  UpdateViewTabs();
end;

procedure TModuleForm.pgcViewTabsChanging(Sender: TObject; var AllowChange: Boolean);
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

procedure TModuleForm.pgcViewTabsContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  pgcViewTabs.tag := pgcViewTabs.IndexOfTabAt(MousePos.X, MousePos.Y);
end;

procedure TModuleForm.pgcViewTabsDeleteTab(sender: TClosableTabControl; index: Integer);
begin
  pgcViewTabs.tag := index;
  CloseCurrentTab();
end;

procedure TModuleForm.pgcViewTabsDragDrop(Sender, Source: TObject; X, Y: Integer);
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

procedure TModuleForm.pgcViewTabsDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Source <> pgcViewTabs then
    Exit;
  Accept := true;
end;

procedure TModuleForm.pgcViewTabsGetImageIndex(Sender: TObject; TabIndex: Integer; var ImageIndex: Integer);
begin
  // disable tab icons
  ImageIndex := -1;
end;

procedure TModuleForm.pgcViewTabsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    pgcViewTabs.BeginDrag(false, 10);
end;

procedure TModuleForm.pgcViewTabsStartDrag(Sender: TObject; var DragObject: TDragObject);
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

procedure TModuleForm.pgcViewTabsTabDoubleClick(sender: TClosableTabControl; index: Integer);
var
  ti: TViewTabInfo;
begin
  ti := pgcViewTabs.Tabs.Objects[index] as TViewTabInfo;
  if not Assigned(ti) then
    Exit;
  mMainView.NewViewTab(ti.Location, ti.SatelliteName, '', ti.State, '', true)
end;

procedure TModuleForm.pmBrowserPopup(Sender: TObject);
var
  s, scap: string;
  i: integer;
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

  mMainView.CurVerseNumber := Get_ANAME_VerseNumber(
    bwrHtml.DocumentSource, mMainView.CurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.RightMouseClickPos, true));

  mMainView.CurSelStart := Get_ANAME_VerseNumber(
    bwrHtml.DocumentSource, mMainView.CurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.SelStart, true));

  mMainView.CurSelEnd := Get_ANAME_VerseNumber(
    bwrHtml.DocumentSource, mMainView.CurFromVerse,
    bwrHtml.FindSourcePos(bwrHtml.SelStart + bwrHtml.SelLength, true));

  if mMainView.CurSelStart > mMainView.CurSelEnd then
  begin
    i := mMainView.CurSelStart;
    mMainView.CurSelStart := mMainView.CurSelEnd;
    mMainView.CurSelEnd := i;
  end;

  miCopyPassage.Visible := (mMainView.CurSelStart < mMainView.CurSelEnd);

  if mMainView.CurVerseNumber = 0 then
  begin
    miCompare.Visible := false;
    miCopyVerse.Visible := false;
  end
  else
    with mMainView.MainBook do
    begin
      if miCopyPassage.Visible then
        miCopyPassage.Caption := Format('%s  "%s"',
          [FirstWord(miCopyVerse.Caption), FullPassageSignature(CurBook, CurChapter, mMainView.CurSelStart, mMainView.CurSelEnd)]);

      miCopyVerse.Caption := Format('%s  "%s"',
        [FirstWord(miCopyVerse.Caption), FullPassageSignature(CurBook, CurChapter, mMainView.CurVerseNumber, mMainView.CurVerseNumber)]);

      scap := miAddBookmark.Caption;
      s := DeleteFirstWord(scap);
      s := s + ' ' + FirstWord(scap);

      miAddBookmark.Caption := Format('%s  "%s"',
        [s, FullPassageSignature(CurBook, CurChapter, mMainView.CurVerseNumber, mMainView.CurVerseNumber)]);

      scap := miAddMemo.Caption;
      s := DeleteFirstWord(scap);
      s := s + ' ' + FirstWord(scap);

      miAddMemo.Caption := Format(
        '%s  "%s"',
        [s, FullPassageSignature(CurBook, CurChapter, mMainView.CurVerseNumber, mMainView.CurVerseNumber)]);
    end;
end;

procedure TModuleForm.tbtnBackClick(Sender: TObject);
begin
  mMainView.HistoryOn := false;
  if mMainView.lbHistory.ItemIndex < mMainView.lbHistory.Items.Count - 1 then
  begin
    mMainView.lbHistory.ItemIndex := mMainView.lbHistory.ItemIndex + 1;
    mMainView.ProcessCommand(mMainView.History[mMainView.lbHistory.ItemIndex], hlDefault);
  end;
  mMainView.HistoryOn := true;

  Winapi.Windows.SetFocus(bwrHtml.Handle);
end;

procedure TModuleForm.tbtnCopyClick(Sender: TObject);
begin
  CopyBrowserSelectionToClipboard();
end;

procedure TModuleForm.tbtnForwardClick(Sender: TObject);
begin
  mMainView.HistoryOn := false;
  if mMainView.lbHistory.ItemIndex > 0 then
  begin
    mMainView.lbHistory.ItemIndex := mMainView.lbHistory.ItemIndex - 1;
    mMainView.ProcessCommand(mMainView.History[mMainView.lbHistory.ItemIndex], hlDefault);
  end;
  mMainView.HistoryOn := true;

  Winapi.Windows.SetFocus(bwrHtml.Handle);
end;

procedure TModuleForm.tbtnMemosClick(Sender: TObject);
begin
  SetMemosVisible(tbtnMemos.Down);
end;

procedure TModuleForm.tbtnNextChapterClick(Sender: TObject);
begin
  mMainView.GoNextChapter;
end;

procedure TModuleForm.tbtnPrevChapterClick(Sender: TObject);
begin
    mMainView.GoPrevChapter;
end;

procedure TModuleForm.ToggleQuickSearchPanel(const enable: Boolean);
begin
  tbtnQuickSearch.Down := enable;
  tlbQuickSearch.Visible := enable;
  tlbQuickSearch.Height := IfThen(enable, tlbViewPage.Height, 0);

  if (enable) then
    Winapi.Windows.SetFocus(tedtQuickSearch.Handle);

end;

procedure TModuleForm.tbtnQuickSearchClick(Sender: TObject);
begin
  ToggleQuickSearchPanel(tbtnQuickSearch.Down);
end;

procedure TModuleForm.tbtnQuickSearchNextClick(Sender: TObject);
begin
  mMainView.SearchForward();
end;

procedure TModuleForm.tbtnQuickSearchPrevClick(Sender: TObject);
begin
  mMainView.SearchBackward();
end;

procedure TModuleForm.tbtnReferenceClick(Sender: TObject);
begin
  mMainView.GoReference();
end;

procedure TModuleForm.tbtnReferenceInfoClick(Sender: TObject);
begin
  mMainView.ShowReferenceInfo();
end;

procedure TModuleForm.ToggleStrongNumbers();
var
  vti: TViewTabInfo;
  savePosition: integer;
begin
  mMainView.miStrong.Checked := not mMainView.miStrong.Checked;
  mMainView.StrongNumbersOn := mMainView.miStrong.Checked;
  tbtnStrongNumbers.Down := mMainView.StrongNumbersOn;
  vti := GetActiveTabInfo();
  vti[vtisShowStrongs] := mMainView.StrongNumbersOn;

  if not mMainView.MainBook.Trait[bqmtStrongs] then
  begin
    tbtnStrongNumbers.Enabled := false;
    Exit;
  end;
  savePosition := bwrHtml.Position;
  mMainView.ProcessCommand(vti.Location, TbqHLVerseOption(ord(vti[vtisHighLightVerses])));
  bwrHtml.Position := savePosition;
end;

procedure TModuleForm.tbtnStrongNumbersClick(Sender: TObject);
begin
  ToggleStrongNumbers();
end;

procedure TModuleForm.tedtQuickSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    mMainView.SearchForward();
  end;
end;

procedure TModuleForm.tedtReferenceChange(Sender: TObject);
begin
  mMainView.AddressFromMenus := false;
end;

procedure TModuleForm.tedtReferenceDblClick(Sender: TObject);
begin
  mMainView.GoReference();
end;

procedure TModuleForm.tedtReferenceEnter(Sender: TObject);
begin
  PostMessageW(tedtReference.Handle, EM_SETSEL, 0, -1);
end;

procedure TModuleForm.tedtReferenceKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    mMainView.GoReference();
  end;
end;

function TModuleForm.GetActiveTabInfo(): TViewTabInfo;
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

end.
