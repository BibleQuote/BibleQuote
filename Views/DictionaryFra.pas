unit DictionaryFra;

interface

uses
  Winapi.Windows, Vcl.Forms, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Dialogs, TabData, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ToolWin, System.ImageList, Vcl.ImgList,
  Vcl.Menus, System.UITypes, BibleQuoteUtils, MainFrm, Htmlview, VirtualTrees,
  HTMLEmbedInterfaces, Dict, Bible, ExceptionFrm, BibleQuoteConfig,
  StringProcs, BibleLinkParser, Clipbrd, Engine, JclNotify, NotifyMessages;

type
  TDictionaryFrame = class(TFrame, IDictionaryView, IJclListener)
    bwrDic: THTMLViewer;
    pnlDic: TPanel;
    cbDicFilter: TComboBox;
    edtDic: TComboBox;
    vstDicList: TVirtualStringTree;
    pnlSelectDic: TPanel;
    lblDicFoundSeveral: TLabel;
    cbDic: TComboBox;
    pmRef: TPopupMenu;
    miRefCopy: TMenuItem;
    miOpenNewView: TMenuItem;
    miRefPrint: TMenuItem;
    procedure bwrDicHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure bwrDicHotSpotCovered(Sender: TObject; const SRC: string);
    procedure bwrDicMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pmRefPopup(Sender: TObject);
    procedure cbDicFilterChange(Sender: TObject);
    procedure edtDicChange(Sender: TObject);
    procedure edtDicKeyPress(Sender: TObject; var Key: Char);
    procedure edtDicKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstDicListAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstDicListClick(Sender: TObject);
    procedure vstDicListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstDicListKeyPress(Sender: TObject; var Key: Char);
    procedure cbDicChange(Sender: TObject);
    procedure miRefCopyClick(Sender: TObject);
    procedure miOpenNewViewClick(Sender: TObject);
    procedure miRefPrintClick(Sender: TObject);
  private
    mTabsView: ITabsView;
    mMainView: TMainForm;
    mXRefVerseCmd: string;
    mBqEngine: TBibleQuoteEngine;

    function DicScrollNode(nd: PVirtualNode): Boolean;
    function DicSelectedItemIndex(out pn: PVirtualNode): integer; overload;
    function DicSelectedItemIndex: integer; overload;
    function DictionaryStartup(maxAdd: integer = maxInt): Boolean;
    procedure UpdateDictionariesCombo;
    procedure Notification(msg: IJclNotificationMessage); reintroduce; stdcall;
    procedure DisplayDictionaries;

    // finds the closest match for a word in merged
    // dictionary word list
    function LocateDicItem: integer;
  public
    constructor Create(AOwner: TComponent; AMainView: TMainForm; ATabsView: ITabsView); reintroduce;

    procedure Translate();
    procedure DisplayDictionary(const s: string);
  end;

implementation

uses BookFra;

{$R *.dfm}
procedure TDictionaryFrame.bwrDicHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  concreteCmd: string;
  status: integer;
  modIx: integer;
  modPath: string;
  bookTabInfo: TBookTabInfo;
  modEntry: TModuleEntry;
begin
  modIx := mMainView.mModules.FindByName(mMainView.DefaultBibleName);
  if (modIx < 0) then
  begin
    modEntry := mMainView.mModules.ModTypedAsFirst(modtypeBible);
    if Assigned(modEntry) then
      modIx := mMainView.mModules.FindByName(modEntry.mFullName);
  end;

  if (modIx >= 0) then
  begin
    modPath := mMainView.mModules[modIx].mShortPath;
    bookTabInfo := mMainView.CreateNewBookTabInfo();

    if (Pos(C__bqAutoBible, SRC) <> 0) then
    begin
      status := (TBookFrame(mTabsView.BookView)).PreProcessAutoCommand(bookTabInfo, SRC, modPath, concreteCmd);
      if status <= -2 then
        Exit;
    end;

    mMainView.OpenOrCreateBookTab(ConcreteCmd, '', mMainView.DefaultBookTabState);
  end;

  Handled := true;
end;

procedure TDictionaryFrame.bwrDicHotSpotCovered(Sender: TObject; const SRC: string);
begin
  // TODO: decide what source to use for hints
  // show hints from this source
  //GetBookView(self).BrowserHotSpotCovered(Sender as THTMLViewer, SRC);
end;

procedure TDictionaryFrame.bwrDicMouseDouble(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DisplayDictionary(Trim(bwrDic.SelText));
end;

procedure TDictionaryFrame.cbDicChange(Sender: TObject);
var
  i: integer;
  res, tt: string;
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
  blResolveLinks := true;
  blFuzzy := true;
    // TODO: resolve links depending on current book view
//  bookTabInfo := GetBookView(self).BookTabInfo;
//  if Assigned(bookTabInfo) then
//  begin
//    blResolveLinks := bookTabInfo[vtisResolveLinks];
//    blFuzzy := bookTabInfo[vtisFuzzyResolveLinks];
//  end;
  if blResolveLinks then
    tt := ResolveLinks(res, blFuzzy)
  else
    tt := res;

  bwrDic.LoadFromString(tt);
end;

procedure TDictionaryFrame.cbDicFilterChange(Sender: TObject);
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

constructor TDictionaryFrame.Create(AOwner: TComponent; AMainView: TMainForm; ATabsView: ITabsView);
begin
  inherited Create(AOwner);

  mMainView := AMainView;
  mTabsView := ATabsView;
  mBqEngine := mMainView.BqEngine;

  vstDicList.DefaultNodeHeight := mMainView.Canvas.TextHeight('X');
  mMainView.GetNotifier.Add(self);

  with bwrDic do
  begin
    DefFontName := MainCfgIni.SayDefault('RefFontName', 'Microsoft Sans Serif');
    DefFontSize := StrToInt(MainCfgIni.SayDefault('RefFontSize', '12'));
    DefFontColor := Hex2Color(MainCfgIni.SayDefault('RefFontColor', Color2Hex(clWindowText)));

    DefBackGround := Hex2Color(MainCfgIni.SayDefault('DefBackground', Color2Hex(clWindow))); // '#EBE8E2'
    DefHotSpotColor := Hex2Color(MainCfgIni.SayDefault('DefHotSpotColor', Color2Hex(clHotLight))); // '#0000FF'
  end;
end;

procedure TDictionaryFrame.edtDicChange(Sender: TObject);
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

procedure TDictionaryFrame.edtDicKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    DisplayDictionary(edtDic.Text);
  end;
end;

procedure TDictionaryFrame.edtDicKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
//
end;

procedure TDictionaryFrame.pmRefPopup(Sender: TObject);
begin
  miOpenNewView.Visible := true;
  mXRefVerseCmd := Get_AHREF_VerseCommand(
    bwrDic.DocumentSource,
    bwrDic.SectionList.FindSourcePos(bwrDic.RightMouseClickPos));
end;

procedure TDictionaryFrame.Translate();
begin
  UpdateDictionariesCombo();
  Lang.TranslateControl(self, 'MainForm');
  Lang.TranslateControl(self, 'DockTabsForm');
end;

procedure TDictionaryFrame.vstDicListAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
//
end;

procedure TDictionaryFrame.vstDicListClick(Sender: TObject);
var
  ix: integer;
begin
  ix := DicSelectedItemIndex();
  if ix >= 0 then
    DisplayDictionary(mBqEngine.DictionaryTokens[ix]);
end;

procedure TDictionaryFrame.vstDicListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
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

procedure TDictionaryFrame.vstDicListKeyPress(Sender: TObject; var Key: Char);
var
  ix: integer;
begin
  ix := DicSelectedItemIndex();
  if (Key = #13) and (ix >= 0) then
    DisplayDictionary(mBqEngine.DictionaryTokens[ix]);
end;

function TDictionaryFrame.DicScrollNode(nd: PVirtualNode): Boolean;
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

function TDictionaryFrame.DicSelectedItemIndex: integer;
var
  pn: PVirtualNode;
begin
  Result := DicSelectedItemIndex(pn);
end;

function TDictionaryFrame.DicSelectedItemIndex(out pn: PVirtualNode): integer;
begin
  Result := -1;
  pn := nil;
  pn := vstDicList.GetFirstSelected();
  if not Assigned(pn) then
    Exit;
  Result := integer(vstDicList.GetNodeData(pn)^);
end;

procedure TDictionaryFrame.DisplayDictionary(const s: string);
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

function TDictionaryFrame.DictionaryStartup(maxAdd: integer = maxInt): Boolean;
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

function TDictionaryFrame.LocateDicItem: integer;
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

procedure TDictionaryFrame.miOpenNewViewClick(Sender: TObject);
var
  command: string;
begin
  command := Trim(mXRefVerseCmd);
  if Length(command) <= 0 then
    Exit;

  mMainView.NewBookTab(command, '------', mMainView.DefaultBookTabState, '', true);
end;

procedure TDictionaryFrame.miRefCopyClick(Sender: TObject);
var
  trCount: integer;
begin
  trCount := 7;
  repeat
    try
      if not(mMainView.CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then
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

procedure TDictionaryFrame.miRefPrintClick(Sender: TObject);
begin
  with mMainView.PrintDialog do
    if Execute then
      (pmRef.PopupComponent as THTMLViewer).Print(MinPage, MaxPage)
end;

procedure TDictionaryFrame.UpdateDictionariesCombo;
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

procedure TDictionaryFrame.Notification(msg: IJclNotificationMessage);
var
  msgDictionariesLoaded: IDictionariesLoadedMessage;
begin
  if Supports(msg, IDictionariesLoadedMessage, msgDictionariesLoaded) then
  begin
    DisplayDictionaries();
  end;
end;

procedure TDictionaryFrame.DisplayDictionaries();
begin
  UpdateDictionariesCombo();
  DictionaryStartup();
end;

end.
