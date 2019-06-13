unit TagsVersesFra;

interface

uses
  Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ToolWin, ExtCtrls, TagsDb, PlainUtils,
  InputFrm, TabData, MainFrm, BibleQuoteUtils, LinksParserIntf, VDTEditLink,
  GfxRenderers, BookFra, Engine, Generics.Collections, System.Contnrs,
  ShlObj, EngineInterfaces, ExceptionFrm, JclNotify, System.Types,
  System.UITypes, System.ImageList, Vcl.ImgList, BibleQuoteConfig,
  NotifyMessages, AppIni;

type
  TTagsVersesFrame = class(TFrame, ITagsVersesView, IJclListener, IVDTInfo)
    tlbTags: TToolBar;
    tbtnAddNode: TToolButton;
    tbtnDelNode: TToolButton;
    cbTagsFilter: TComboBox;
    vdtTagsVerses: TVirtualDrawTree;
    ilImages24: TImageList;
    procedure cbTagsFilterChange(Sender: TObject);
    procedure tbtnAddTagNodeClick(Sender: TObject);
    procedure tbtnDelTagNodeClick(Sender: TObject);
    procedure vdtTagsVersesCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vdtTagsVersesCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vdtTagsVersesCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vdtTagsVersesDblClick(Sender: TObject);
    procedure vdtTagsVersesDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
    procedure vdtTagsVersesEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure vdtTagsVersesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vdtTagsVersesGetNodeWidth(Sender: TBaseVirtualTree; HintCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; var NodeWidth: Integer);
    procedure vdtTagsVersesIncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode; const SearchText: string; var Result: Integer);
    procedure vdtTagsVersesMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure vdtTagsVersesMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure vdtTagsVersesResize(Sender: TObject);
    procedure vdtTagsVersesShowScrollBar(Sender: TBaseVirtualTree; Bar: Integer; Show: Boolean);
    procedure vdtTagsVersesStateChange(Sender: TBaseVirtualTree; Enter, Leave: TVirtualTreeStates);
  private
    mFilterTagsTimer: TTimer;
    mWorkspace: IWorkspace;
    mMainView: TMainForm;
    mTaggedBookmarksLoaded: Boolean;
    mBqEngine: TBibleQuoteEngine;
    mscrollbarX: integer;

    mBookTabInfo: TBookTabInfo;
    mTagsVersesList: TbqVerseTagsList;
    mTagsVersesCached: Boolean;

    procedure FilterTags(const FilterText: string);
    procedure TagFilterTimerProc(Sender: TObject);
    function GetTagFilterTimer: TTimer;
    function LoadTaggedBookMarks(): Boolean;
    function PaintTokens(canv: TCanvas; rct: TRect; tkns: TObjectList; calc: Boolean): integer;
    procedure ReCalculateTagTree;
  public
    constructor Create(AOwner: TComponent; AMainView: TMainForm; AWorkspace: IWorkspace); reintroduce;
    destructor Destroy; override;
    procedure Translate();
    procedure ApplyConfig(appConfig, oldConfig: TAppConfig);
    procedure EventFrameKeyDown(var Key: Char);

    procedure TagAdded(tagId: int64; const txt: string; Show: Boolean);
    procedure TagRenamed(tagId: int64; const newTxt: string);
    procedure TagDeleted(id: int64; const txt: string);
    procedure VerseAdded(verseId, tagId: int64; const cmd: string; Show: Boolean);
    procedure VerseDeleted(verseId, tagId: int64);
    procedure Notification(msg: IJclNotificationMessage); reintroduce; stdcall;

    procedure GetTextInfo(tree: TVirtualDrawTree; Node: PVirtualNode; Column: TColumnIndex; const AFont: TFont; var R: TRect; var Text: string);
    procedure SetNodeText(tree: TVirtualDrawTree; Node: PVirtualNode; Column: TColumnIndex; const Text: string);

    function CacheTagNames: HRESULT;

    property TagsVersesList: TbqVerseTagsList read mTagsVersesList;
  end;

implementation

{$R *.dfm}
constructor TTagsVersesFrame.Create(AOwner: TComponent; AMainView: TMainForm; AWorkspace: IWorkspace);
begin
  inherited Create(AOwner);

  mMainView := AMainView;
  mWorkspace := AWorkspace;

  mTagsVersesCached := false;
  mBqEngine := mMainView.BqEngine;

  mBookTabInfo := mMainView.CreateNewBookTabInfo();

  TagsDbEngine.GetNotifier.Add(self);
  LoadTaggedBookMarks();
end;

destructor TTagsVersesFrame.Destroy;
begin
  FreeAndNil(mTagsVersesList);

  FreeAndNil(mBookTabInfo);

  inherited;
end;

procedure TTagsVersesFrame.EventFrameKeyDown(var Key: Char);
begin

end;

function TTagsVersesFrame.GetTagFilterTimer: TTimer;
begin
  if not Assigned(mFilterTagsTimer) then
  begin
    mFilterTagsTimer := TTimer.Create(self);
    mFilterTagsTimer.OnTimer := TagFilterTimerProc;
    mFilterTagsTimer.Interval := 1000;
  end;
  Result := mFilterTagsTimer;
end;

procedure TTagsVersesFrame.TagFilterTimerProc(Sender: TObject);
begin
  GetTagFilterTimer().Enabled := false;
  FilterTags(cbTagsFilter.Text);
end;

procedure TTagsVersesFrame.FilterTags(const FilterText: string);
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

procedure TTagsVersesFrame.cbTagsFilterChange(Sender: TObject);
var
  timer: TTimer;
begin
  timer := GetTagFilterTimer();
  timer.Enabled := true;
end;

procedure TTagsVersesFrame.tbtnAddTagNodeClick(Sender: TObject);
var
  dummyTag: int64;
  inputForm: TInputForm;
begin
  inputForm := TInputForm.CreateText('Тег');

  if inputForm.ShowModal <> mrOk then
    Exit;
  if not mTaggedBookmarksLoaded then
    LoadTaggedBookMarks();
  TagsDb.TagsDbEngine.AddTag(inputForm.GetValue, dummyTag);
end;

procedure TTagsVersesFrame.tbtnDelTagNodeClick(Sender: TObject);
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
    TagsDb.TagsDbEngine.DeleteTag(vnd.getText(), vnd.SelfId);
    del_ix := mTagsVersesList.IndexOf(vnd);
    if del_ix >= 0 then
    begin
      mTagsVersesList.Delete(del_ix);
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
    TagsDb.TagsDbEngine.DeleteVerseFromTag(vnd.SelfId, vndParent.getText(), false);
  end;

end;

procedure TTagsVersesFrame.vdtTagsVersesCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
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

procedure TTagsVersesFrame.vdtTagsVersesCompareNodes(
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

procedure TTagsVersesFrame.vdtTagsVersesCreateEditor(
  Sender: TBaseVirtualTree;
  Node: PVirtualNode;
  Column: TColumnIndex;
  out EditLink: IVTEditLink);
begin
  EditLink := TbqVDTEditLink.Create(self);
end;

procedure TTagsVersesFrame.vdtTagsVersesDblClick(Sender: TObject);
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
    (mBookTabInfo, pt.X - vdt.Margin - levelIndent, pt.Y - nodeTop, vdt.Canvas, nd, rct);

  if R <> tvcPlainTxt then
    Exit;

  ble := nd.getBibleLinkEx();

  mMainView.OpenOrCreateBookTab(ble.ToCommand(), '', mMainView.DefaultBookTabState);
end;

procedure TTagsVersesFrame.vdtTagsVersesEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
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

procedure TTagsVersesFrame.vdtTagsVersesEditing(
  Sender: TBaseVirtualTree;
  Node: PVirtualNode;
  Column: TColumnIndex;
  var Allowed: Boolean);
begin
  Allowed := Sender.NodeParent[Node] = nil;
end;

procedure TTagsVersesFrame.vdtTagsVersesGetNodeWidth(
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
  if Assigned(nd) then
  begin
    HintCanvas.Font := Sender.Font;
    str := Format('%s (%d)', [nd.getText(), vdtTagsVerses.ChildCount[Node]]);
    rct := Rect(0, 0, Sender.ClientWidth - mscrollbarX - vdtTagsVerses.TextMargin * 2 - 5, 40);
    NodeWidth := rct.Right;
  end;
end;

procedure TTagsVersesFrame.vdtTagsVersesIncrementalSearch(
  Sender: TBaseVirtualTree;
  Node: PVirtualNode;
  const SearchText: string;
  var Result: integer);
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

procedure TTagsVersesFrame.vdtTagsVersesMeasureItem(
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
      NodeHeight := TbqTagsRenderer.RenderVerseNode(mBookTabInfo, TargetCanvas, nd, true, rct) + 4;
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

procedure TTagsVersesFrame.vdtTagsVersesDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
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
    TbqTagsRenderer.RenderVerseNode(mBookTabInfo, PaintInfo.Canvas, nd, false, rct);
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
        TagsDb.TagsDbEngine.InitNodeChildren(nd, mTagsVersesList);
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
      TagsDb.TagsDbEngine.InitNodeChildren(nd, mTagsVersesList);
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

procedure TTagsVersesFrame.vdtTagsVersesMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
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
    (mBookTabInfo, X - vdt.Margin - levelIndent, Y - nodeTop, vdt.Canvas, nd, rct);
  case R of
    tvcLink:
      vdt.Cursor := crHandPoint;

  else
    vdt.Cursor := crDefault;
  end;

end;

procedure TTagsVersesFrame.vdtTagsVersesResize(Sender: TObject);
begin
  ReCalculateTagTree();
end;

procedure TTagsVersesFrame.vdtTagsVersesShowScrollBar(Sender: TBaseVirtualTree; Bar: integer; Show: Boolean);
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

procedure TTagsVersesFrame.vdtTagsVersesStateChange(Sender: TBaseVirtualTree; Enter, Leave: TVirtualTreeStates);
begin
  //
end;

procedure TTagsVersesFrame.Translate();
begin
  Lang.TranslateControl(self, 'DockTabsForm');
end;

procedure TTagsVersesFrame.ApplyConfig(appConfig, oldConfig: TAppConfig);
begin
  if (appConfig.MainFormFontName <> Font.Name) then
    Font.Name := appConfig.MainFormFontName;

  if (appConfig.MainFormFontSize <> Font.Size) then
    Font.Size := appConfig.MainFormFontSize;

  if (appConfig.DefFontName <> vdtTagsVerses.Font.Name) or
     (appConfig.DefFontSize <> vdtTagsVerses.Font.Size) then
  begin
    vdtTagsVerses.Font.Name := appConfig.DefFontName;
    vdtTagsVerses.Font.Size := appConfig.DefFontSize;
  end;

  TbqTagsRenderer.SetVerseFont(appConfig.DefFontName, appConfig.DefFontSize);
  TbqTagsRenderer.InvalidateRenderers;
  vdtTagsVerses.Invalidate;
end;

function TTagsVersesFrame.LoadTaggedBookMarks(): Boolean;
var
  i, j, pc, C: integer;
  nd, tn: TVersesNodeData;
  failed: boolean;

  procedure Fail();
  begin
    Self.Enabled := false;
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
      mBqEngine.InitVerseListEngine(true);

    if not TagsDbEngine.fdTagsConnection.Connected then
    begin
      Fail();
      Exit;
    end;
    if CacheTagNames() <> S_OK then
    begin
      Fail();
      Exit
    end;

    vdtTagsVerses.BeginUpdate();
    try
      vdtTagsVerses.Clear();
      C := mTagsVersesList.Count;
      i := 0;
      while (i < C) and (TVersesNodeData(mTagsVersesList[i]).nodeType = bqvntTag) do
      begin
        nd := TVersesNodeData(mTagsVersesList[i]);
        PVirtualNode(nd.Parents) := vdtTagsVerses.InsertNode(nil, amAddChildLast, nd);
        inc(i);
      end;

      while (i < C) do
      begin
        nd := TVersesNodeData(mTagsVersesList[i]);
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

function TTagsVersesFrame.PaintTokens(canv: TCanvas; rct: TRect; tkns: TObjectList; calc: Boolean): integer;
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

procedure TTagsVersesFrame.ReCalculateTagTree;
begin
  if (not Assigned(TagsDbEngine)) or (not Assigned(TagsDbEngine.fdTagsConnection))
  then
    Exit;
  if (not TagsDbEngine.fdTagsConnection.Connected) then
    Exit;

  GfxRenderers.TbqTagsRenderer.InvalidateRenderers();
  vdtTagsVerses.Invalidate();
  vdtTagsVerses.ReinitNode(vdtTagsVerses.RootNode, true);
end;

procedure TTagsVersesFrame.Notification(msg: IJclNotificationMessage);
var
  msgVerseAdded: IVerseAddedMessage;
  msgVerseDeleted: IVerseDeletedMessage;
  msgTagAdded: ITagAddedMessage;
  msgTagDeleted: ITagDeletedMessage;
  msgTagRenamed: ITagRenamedMessage;
  msgDefaultBibleChanged: IDefaultBibleChangedMessage;
begin
  if Supports(msg, IVerseAddedMessage, msgVerseAdded) then
  begin
    VerseAdded(msgVerseAdded.GetVerseId, msgVerseAdded.GetTagId, msgVerseAdded.GetCommand, msgVerseAdded.DoShow);
  end;

  if Supports(msg, IVerseDeletedMessage, msgVerseDeleted) then
  begin
    VerseDeleted(msgVerseDeleted.GetVerseId, msgVerseDeleted.GetTagId);
  end;

  if Supports(msg, ITagAddedMessage, msgTagAdded) then
  begin
    TagAdded(msgTagAdded.GetTagId, msgTagAdded.GetText, msgTagAdded.DoShow);
  end;

  if Supports(msg, ITagDeletedMessage, msgTagDeleted) then
  begin
    TagDeleted(msgTagDeleted.GetTagId, msgTagDeleted.GetText);
  end;

  if Supports(msg, ITagRenamedMessage, msgTagRenamed) then
  begin
    TagRenamed(msgTagRenamed.GetTagId, msgTagRenamed.GetNewText);
  end;

  if Supports(msg, IDefaultBibleChangedMessage, msgDefaultBibleChanged) then
  begin
    LoadTaggedBookMarks();
  end;

end;

procedure TTagsVersesFrame.TagAdded(tagId: int64; const txt: string; Show: Boolean);
var
  vnd: TVersesNodeData;
  pvn: PVirtualNode;
begin
  vnd := TVersesNodeData.Create(tagId, txt, bqvntTag);
  mTagsVersesList.Add(vnd);
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

procedure TTagsVersesFrame.TagDeleted(id: int64; const txt: string);
var
  vnd: TVersesNodeData;
  pvn: PVirtualNode;
begin
  vnd := mTagsVersesList.FindTagItem(txt);

  if (not Assigned(vnd)) or (not Assigned(vnd.Parents)) then
  begin
    MessageBeep(MB_ICONERROR);
    Exit;
  end;
  pvn := PVirtualNode(vnd.Parents);
  vdtTagsVerses.DeleteNode(pvn);
end;

procedure TTagsVersesFrame.TagRenamed(tagId: int64; const newTxt: string);
var
  vnd: TVersesNodeData;
  pvn: PVirtualNode;
  ix: integer;
begin
  ix := TVersesNodeData.FindNodeById(mTagsVersesList, tagId, bqvntTag, vnd);
  if ix < 0 then
    Exit;
  vnd.cachedTxt := newTxt;
  pvn := PVirtualNode(vnd.Parents);
  vdtTagsVerses.InvalidateNode(pvn);
end;


procedure TTagsVersesFrame.VerseAdded(verseId, tagId: int64; const cmd: string; Show: Boolean);
var
  ix: integer;
  vnd, vnd_verse: TVersesNodeData;
  pvnTag, pvnVerse: PVirtualNode;

begin
  ix := TVersesNodeData.FindNodeById(mTagsVersesList, tagId, bqvntTag, vnd);
  if ix < 0 then
    Exit;
  pvnTag := PVirtualNode(vnd.Parents);
  if not Assigned(pvnTag) then
    Exit;
  if TVersesNodeData.FindNodeById(mTagsVersesList, verseId, bqvntVerse, vnd_verse) < 0 then
  begin
    vnd_verse := TVersesNodeData.Create(verseId, '', bqvntVerse);
    vnd_verse.Parents.Add(vnd);
    mTagsVersesList.Add(vnd_verse);
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

procedure TTagsVersesFrame.VerseDeleted(verseId, tagId: int64);
var
  ix, tagIx: integer;
  vnd, tag_vnd, vnd2: TVersesNodeData;
  pvnVerse: PVirtualNode;
  fndNode: Boolean;
begin
  ix := TVersesNodeData.FindNodeById(mTagsVersesList, verseId, bqvntVerse, vnd);

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
      mTagsVersesList.Remove(vnd);
    end;
  end;

end;

function TTagsVersesFrame.CacheTagNames: HRESULT;
begin
  Result := S_OK;
  if mTagsVersesCached = true then
  begin
    Result := S_OK;
    exit;
  end;
  if not Assigned(mTagsVersesList) then
    mTagsVersesList := TbqVerseTagsList.Create(true);

  TagsDbEngine.SeedNodes(mTagsVersesList);
  mTagsVersesCached := true;
end;

procedure TTagsVersesFrame.GetTextInfo(
  tree: TVirtualDrawTree;
  Node: PVirtualNode;
  Column: TColumnIndex;
  const AFont: TFont;
  var R: TRect;
  var Text: string);
var
  vnd: TVersesNodeData;
begin
  vnd := TVersesNodeData(tree.GetNodeData(Node)^);
  if vnd = nil then
    Exit;

  R := tree.GetDisplayRect(Node, Column, false);
  InflateRect(R, 0, -4);
  Text := vnd.getText();
end;

procedure TTagsVersesFrame.SetNodeText(tree: TVirtualDrawTree; Node: PVirtualNode; Column: TColumnIndex; const Text: string);
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

end.
