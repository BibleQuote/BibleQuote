unit BookFra;

interface

uses
  Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ToolWin,
  HTMLEmbedInterfaces, Htmlview, Vcl.Tabs, Vcl.DockTabSet, Vcl.ExtCtrls,
  Vcl.Menus, System.ImageList, Vcl.ImgList, MainFrm, TabData, HintTools,
  WinApi.ShellApi, StrUtils, BibleQuoteUtils, CommandProcessor, LinksParserIntf,
  SevenZipHelper, StringProcs, HTMLUn2, ExceptionFrm, ChromeTabs, Clipbrd,
  Bible, ModuleViewIntf, Math, IOUtils;

type
  TBookFrame = class(TFrame, IBookView)
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
    dtsBible: TDockTabSet;
    ilImages: TImageList;
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
    procedure miMemoCopyClick(Sender: TObject);
    procedure miMemoCutClick(Sender: TObject);
    procedure miMemoPasteClick(Sender: TObject);
    procedure bwrHtmlHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure bwrHtmlHotSpotCovered(Sender: TObject; const SRC: string);
    procedure bwrHtmlImageRequest(Sender: TObject; const SRC: string; var Stream: TMemoryStream);
    procedure bwrHtmlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bwrHtmlKeyPress(Sender: TObject; var Key: Char);
    procedure bwrHtmlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bwrHtmlMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bwrHtmlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bwrHtmlMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure dtsBibleChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure dtsBibleClick(Sender: TObject);
    procedure dtsBibleDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dtsBibleDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure dtsBibleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure dtsBibleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure dtsBibleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
    procedure pmBrowserPopup(Sender: TObject);

    procedure CopyBrowserSelectionToClipboard();
    procedure ToggleStrongNumbers();
    procedure BrowserHotSpotCovered(viewer: THTMLViewer; src: string);
    procedure FormMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
    procedure ToggleQuickSearchPanel(const enable: Boolean);
  private
    { Private declarations }
    mMainView: TMainForm;
    mModuleView: IModuleView;

    mBrowserSearchPosition: Longint;

    procedure SetMemosVisible(showMemos: Boolean);

    procedure SearchForward();
    procedure SearchBackward();

    function GetMainBook: TBible;

    property MainBook: TBible read GetMainBook;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; mainView: TMainForm; moduleView: IModuleView); reintroduce;

    procedure AdjustBibleTabs(moduleName: string = '');
    procedure LoadSecondBookByName(const name: string);
  end;

implementation

{$R *.dfm}
uses ModuleFrm;

function TBookFrame.GetMainBook(): TBible;
begin
  Result := mModuleView.GetActiveTabInfo.Bible;
end;

procedure TBookFrame.bwrHtmlHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
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
  tabInfo := mModuleView.GetActiveTabInfo();

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

    if Assigned(tabInfo) then
    begin
    with tabInfo.Bible do
      mMainView.HistoryAdd(Format('go %s %d %d %d %d $$$%s %s', [ShortPath, CurBook,
        CurChapter, mMainView.tbXRef.tag, 0,
        // history comment
        ShortName, FullPassageSignature(CurBook, CurChapter, mMainView.tbXRef.tag, 0)]));
    end;

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
      mMainView.bwrXRef.CharSet := tabInfo.Bible.desiredCharset;
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

procedure TBookFrame.BrowserHotSpotCovered(viewer: THTMLViewer; src: string);
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
  ti := mModuleView.GetActiveTabInfo();

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
    wstr := wstr + ' (' + ti.ReferenceBible.ShortName + ')'#13#10;
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

procedure TBookFrame.bwrHtmlHotSpotCovered(Sender: TObject; const SRC: string);
begin
  BrowserHotSpotCovered(Sender as THTMLViewer, SRC);
end;

procedure TBookFrame.bwrHtmlImageRequest(Sender: TObject; const SRC: string; var Stream: TMemoryStream);
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
    vti := mModuleView.GetActiveTabInfo();

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

procedure TBookFrame.bwrHtmlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TBookFrame.bwrHtmlKeyPress(Sender: TObject; var Key: Char);
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

procedure TBookFrame.bwrHtmlKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  oxt, oct: integer;
  tabInfo: TViewTabInfo;
begin
  tabInfo := mModuleView.GetActiveTabInfo();
  if tabInfo.LocationType = vtlFile then
    Exit;

  if (Key = VK_NEXT) and (bwrHtml.Position = mMainView.BrowserPosition) then
  begin
    mMainView.GoNextChapter;
    Exit;
  end;
  if (Key = VK_PRIOR) and (bwrHtml.Position = mMainView.BrowserPosition) then
  begin
    mMainView.GoPrevChapter;
    if (tabInfo.Bible.CurBook <> 1) or (tabInfo.Bible.CurChapter <> 1) then
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

procedure TBookFrame.bwrHtmlMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  num, code: integer;
  tabInfo: TViewTabInfo;
begin
  tabInfo := mModuleView.GetActiveTabInfo();

  if not mMainView.mDictionariesFullyInitialized then
  begin
    mMainView.LoadDictionaries(true);
  end;

  Val(Trim(bwrHtml.SelText), num, code);
  if code = 0 then
  begin
    mMainView.DisplayStrongs(num, (tabInfo.Bible.CurBook < 40) and (tabInfo.Bible.Trait[bqmtOldCovenant]));
  end
  else
  begin
    mMainView.DisplayDictionary(Trim(bwrHtml.SelText));
  end;

  if not mMainView.pgcMain.Visible then
    mMainView.tbtnToggle.Click;
end;

procedure TBookFrame.bwrHtmlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TBookFrame.bwrHtmlMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
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

constructor TBookFrame.Create(AOwner: TComponent; mainView: TMainForm; moduleView: IModuleView);
begin
  inherited Create(AOwner);
  mMainView := mainView;
  mModuleView := moduleView;
end;

procedure TBookFrame.dtsBibleChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
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

procedure TBookFrame.dtsBibleClick(Sender: TObject);
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
    modIx := mMainView.mModules.FindByFolder(mModuleView.GetActiveTabInfo().Bible.ShortPath);
    if modIx >= 0 then
    begin
      me := TModuleEntry(mMainView.mModules.Items[modIx]);
      if mMainView.mFavorites.AddModule(me) then
        AdjustBibleTabs();
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
    ti := mModuleView.GetActiveTabInfo();
    s := ti.Location;
    StrReplace(s, ti.Bible.ShortPath, me.mShortPath, false);
    mMainView.NewViewTab(s, ti.SatelliteName, '', ti.State, '', true);
    Exit;
  end;
end;

procedure TBookFrame.dtsBibleDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  TabIndex, sourceTabIx, modIx: integer;
  viewTabInfo: TViewTabInfo;
  dragDropPoint: TPoint;
  me: TModuleEntry;
  moduleTabIndex: integer;
begin
  dragDropPoint.X := X;
  dragDropPoint.Y := Y;
  TabIndex := dtsBible.ItemAtPos(dragDropPoint);
  if (TabIndex < 0) or (TabIndex >= dtsBible.Tabs.Count) then
    Exit;

  if Source is TChromeTabs then
  begin
    try
      moduleTabIndex := (Source as TChromeTabs).tag;
      if (moduleTabIndex < 0) then
        Exit;

      viewTabInfo := TViewTabInfo((Source as TChromeTabs).Tabs[moduleTabIndex]);
      if not Assigned(viewTabInfo) then
        Exit;

      if TabIndex = dtsBible.Tabs.Count - 1 then
      begin
        // drop on *** - last tab, adding new tab
        modIx := mMainView.mModules.FindByFolder(viewTabInfo.Bible.ShortPath);
        if modIx >= 0 then
        begin
          me := TModuleEntry(mMainView.mModules.Items[modIx]);
          mMainView.mFavorites.AddModule(me);
          AdjustBibleTabs(viewTabInfo.Bible.ShortName);
        end;
        Exit;
      end;
      // replace
      modIx := mMainView.mModules.FindByFolder(viewTabInfo.Bible.ShortPath);
      if modIx < 0 then
        Exit;

      me := TModuleEntry(mMainView.mModules.Items[modIx]);
      if not Assigned(me) then
        Exit;

      mMainView.mFavorites.ReplaceModule(TModuleEntry(dtsBible.Tabs.Objects[TabIndex]), me);
      AdjustBibleTabs(viewTabInfo.Bible.ShortName);
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
    viewTabInfo := mModuleView.GetActiveTabInfo;

    mMainView.mFavorites.MoveItem(me, TabIndex);

    AdjustBibleTabs(viewTabInfo.Bible.ShortName);
    mMainView.SetFavouritesShortcuts();
  end;
end;

procedure TBookFrame.dtsBibleDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
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

procedure TBookFrame.dtsBibleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TBookFrame.dtsBibleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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

procedure TBookFrame.dtsBibleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TBookFrame.FormMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
var moduleForm: TModuleForm;
begin
  moduleForm := mModuleView as TModuleForm;
  moduleForm.MakeActive;
end;

procedure TBookFrame.miAddBookmarkClick(Sender: TObject);
begin
  mMainView.AddBookmark(miAddBookmark.Caption);
end;

procedure TBookFrame.miAddBookmarkTaggedClick(Sender: TObject);
begin
  mMainView.AddBookmarkTagged();
end;

procedure TBookFrame.miAddMemoClick(Sender: TObject);
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

procedure TBookFrame.miCompareClick(Sender: TObject);
begin
  mMainView.CompareTranslations();
end;

procedure TBookFrame.miCopyPassageClick(Sender: TObject);
begin
  mMainView.CopyPassageToClipboard();
end;

procedure TBookFrame.CopyBrowserSelectionToClipboard();
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

procedure TBookFrame.miCopySelectionClick(Sender: TObject);
begin
  CopyBrowserSelectionToClipboard();
end;

procedure TBookFrame.miCopyVerseClick(Sender: TObject);
begin
  mMainView.CopyVerse;
end;

procedure TBookFrame.miMemoCopyClick(Sender: TObject);
begin
  if pmMemo.PopupComponent = mMainView.reMemo then
    mMainView.reMemo.CopyToClipboard
  else if pmMemo.PopupComponent is TEdit then
    (pmMemo.PopupComponent as TEdit).CopyToClipboard
  else if pmMemo.PopupComponent is TComboBox then
    Clipboard.AsText := (pmMemo.PopupComponent as TComboBox).Text;
end;

procedure TBookFrame.miMemoCutClick(Sender: TObject);
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

procedure TBookFrame.miMemoPasteClick(Sender: TObject);
begin
  if pmMemo.PopupComponent = mMainView.reMemo then
    mMainView.reMemo.PasteFromClipboard
  else if pmMemo.PopupComponent is TEdit then
    (pmMemo.PopupComponent as TEdit).PasteFromClipboard;
end;

procedure TBookFrame.SetMemosVisible(showMemos: Boolean);
var
  ti: TViewTabInfo;
begin
  miMemosToggle.Checked := showMemos;
  tbtnMemos.Down := showMemos;

  mMainView.MemosOn := showMemos;
  ti := mModuleView.GetActiveTabInfo();
  ti[vtisShowNotes] := showMemos;

  mMainView.ProcessCommand(ti.Location, TbqHLVerseOption(ord(ti[vtisHighLightVerses])));
end;

procedure TBookFrame.miMemosToggleClick(Sender: TObject);
begin
  SetMemosVisible(miMemosToggle.Checked);
end;

procedure TBookFrame.miSearchWindowClick(Sender: TObject);
begin
  mMainView.pgcMain.ActivePageIndex := 0; // to the first tab
  mMainView.pgcHistoryBookmarks.ActivePageIndex := 2;

  // to quick search tab
  Winapi.Windows.SetFocus(tedtQuickSearch.Handle);

  if bwrHtml.SelLength <> 0 then
  begin
    tedtQuickSearch.Text := Trim(bwrHtml.SelText);
    SearchForward();
  end;
end;

procedure TBookFrame.miSearchWordClick(Sender: TObject);
begin
  if bwrHtml.SelLength = 0 then
    Exit;

  mMainView.IsSearching := false;
  mMainView.cbSearch.Text := Trim(bwrHtml.SelText);
  mMainView.miSearch.Click;
  mMainView.btnFindClick(Sender);
end;

procedure TBookFrame.pmBrowserPopup(Sender: TObject);
var
  s, scap: string;
  i: integer;
  tabInfo: TViewTabInfo;
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
    tabInfo := mModuleView.GetActiveTabInfo;

    with tabInfo.Bible do
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

procedure TBookFrame.tbtnBackClick(Sender: TObject);
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

procedure TBookFrame.tbtnCopyClick(Sender: TObject);
begin
  CopyBrowserSelectionToClipboard();
end;

procedure TBookFrame.tbtnForwardClick(Sender: TObject);
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

procedure TBookFrame.tbtnMemosClick(Sender: TObject);
begin
  SetMemosVisible(tbtnMemos.Down);
end;

procedure TBookFrame.tbtnNextChapterClick(Sender: TObject);
begin
  mMainView.GoNextChapter;
end;

procedure TBookFrame.tbtnPrevChapterClick(Sender: TObject);
begin
  mMainView.GoPrevChapter;
end;

procedure TBookFrame.ToggleQuickSearchPanel(const enable: Boolean);
begin
  tbtnQuickSearch.Down := enable;
  tlbQuickSearch.Visible := enable;
  tlbQuickSearch.Height := IfThen(enable, tlbViewPage.Height, 0);

  if (enable) then
    Winapi.Windows.SetFocus(tedtQuickSearch.Handle);
end;

procedure TBookFrame.tbtnQuickSearchClick(Sender: TObject);
begin
  ToggleQuickSearchPanel(tbtnQuickSearch.Down);
end;

procedure TBookFrame.tbtnQuickSearchNextClick(Sender: TObject);
begin
  SearchForward();
end;

procedure TBookFrame.tbtnQuickSearchPrevClick(Sender: TObject);
begin
  SearchBackward();
end;

procedure TBookFrame.tbtnReferenceClick(Sender: TObject);
begin
  mMainView.GoReference();
end;

procedure TBookFrame.tbtnReferenceInfoClick(Sender: TObject);
begin
  mMainView.ShowReferenceInfo();
end;

procedure TBookFrame.ToggleStrongNumbers();
var
  vti: TViewTabInfo;
  savePosition: integer;
begin
  mMainView.miStrong.Checked := not mMainView.miStrong.Checked;
  mMainView.StrongNumbersOn := mMainView.miStrong.Checked;
  tbtnStrongNumbers.Down := mMainView.StrongNumbersOn;
  vti := mModuleView.GetActiveTabInfo();
  vti[vtisShowStrongs] := mMainView.StrongNumbersOn;

  if not vti.Bible.Trait[bqmtStrongs] then
  begin
    tbtnStrongNumbers.Enabled := false;
    Exit;
  end;
  savePosition := bwrHtml.Position;
  mMainView.ProcessCommand(vti.Location, TbqHLVerseOption(ord(vti[vtisHighLightVerses])));
  bwrHtml.Position := savePosition;
end;

procedure TBookFrame.tbtnStrongNumbersClick(Sender: TObject);
begin
  ToggleStrongNumbers();
end;

procedure TBookFrame.tedtQuickSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    SearchForward();
  end;
end;

procedure TBookFrame.tedtReferenceChange(Sender: TObject);
begin
  mMainView.AddressFromMenus := false;
end;

procedure TBookFrame.tedtReferenceDblClick(Sender: TObject);
begin
  mMainView.GoReference();
end;

procedure TBookFrame.tedtReferenceEnter(Sender: TObject);
begin
  PostMessageW(tedtReference.Handle, EM_SETSEL, 0, -1);
end;

procedure TBookFrame.tedtReferenceKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    mMainView.GoReference();
  end;
end;

procedure TBookFrame.SearchForward();
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

  if mBrowserSearchPosition = 0 then
  begin
    mBrowserSearchPosition := Pos('</title>', string(bwrHtml.DocumentSource));
    if mBrowserSearchPosition > 0 then
      inc(mBrowserSearchPosition, Length('</title>'));
  end;

  i := FindPosition(bwrHtml.DocumentSource, searchText, mBrowserSearchPosition + 1, searchOptions);
  if i > 0 then
  begin
    mBrowserSearchPosition := i;
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
    mBrowserSearchPosition := 0;
end;

procedure TBookFrame.SearchBackward();
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

  i := FindPosition(bwrHtml.DocumentSource, searchText, mBrowserSearchPosition - 1, searchOptions);
  if i > 0 then
  begin
    mBrowserSearchPosition := i;
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
      mBrowserSearchPosition := bwrHtml.DocumentSource.Length - 1
    else
      mBrowserSearchPosition := 0;
  end;
end;

procedure TBookFrame.AdjustBibleTabs(moduleName: string = '');
var
  i, tabCount, tabIx, offset: integer;
  ws: string;
begin

  if Length(moduleName) = 0 then
    moduleName := MainBook.ShortName;

  offset := ord(mMainView.mBibleTabsInCtrlKeyDownState) shl 1;
  tabCount := dtsBible.Tabs.Count - 1;
  tabIx := -1;

  for i := 0 to tabCount do
  begin
    ws := dtsBible.Tabs.Strings[i];
    if CompareString(LOCALE_SYSTEM_DEFAULT, 0, PChar(Pointer(moduleName)), -1, PChar(Pointer(ws)) + offset,-1) = CSTR_EQUAL then
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

procedure TBookFrame.LoadSecondBookByName(const name: string);
var
  ix: integer;
  ini: string;
  tabInfo: TViewTabInfo;
begin
  tabInfo := mModuleView.GetActiveTabInfo;
  if (Assigned(mMainView.mModules)) then
  begin
    ix := mMainView.mModules.FindByName(name);
    if ix >= 0 then
    begin
      ini := MainFileExists(TPath.Combine(mMainView.mModules[ix].mShortPath, 'bibleqt.ini'));
      if (ini <> tabInfo.SecondBible.inifile) then
        tabInfo.SecondBible.inifile := ini;
    end;
  end;
end;

end.
