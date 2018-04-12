unit MyLibraryFrm;

interface

uses
  Vcl.Tabs, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms,
  Dialogs, VirtualTrees, Contnrs, StdCtrls, ExtCtrls,
  BibleQuoteUtils, DockTabSet;

type
  TBQUseDisposition = (udMyLibrary, udParabibles);
  TLibLinkType = (lltTag, lltBook);

  TMyLibraryForm = class(TForm)
    vdtBookList: TVirtualDrawTree;
    edtFilter: TEdit;
    lblNavigate: TLabel;
    btnOK: TButton;
    dtsTags: TDockTabSet;
    btnCollapse: TButton;
    btnClear: TButton;
    stxCount: TStaticText;
    procedure vdtBookListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure vdtBookListCompareNodes(Sender: TBaseVirtualTree;
      Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure edtFilterChange(Sender: TObject);
    procedure edtFilterKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure vdtBookListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure vdtBookListDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure vdtBookListDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure vdtBookListMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure FormResize(Sender: TObject);
    procedure vdtBookListMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure vdtBookListClick(Sender: TObject);
    procedure dtsTagsChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);

    procedure vdtBookListFocusChanging(Sender: TBaseVirtualTree;
      OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure vdtBookListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vdtBookListDrawHint(Sender: TBaseVirtualTree; HintCanvas: TCanvas;
      Node: PVirtualNode; R: TRect; Column: TColumnIndex);
    procedure vdtBookListGetHintSize(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure btnCollapseClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure vdtBookListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vdtBookListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }

    mods: TObjectList;
    mStrTokens, mFilterStrTokens, mTagTokens: TStringList;
    mAllMatch: Boolean;
    mAllowExp, mFiltered: Boolean;
    mCatNodes: TCachedModules;
    mFilterStr: string;
    mCounter: Integer;
    mfntReg, mfntBook, mfntTag, mfntTagCap: TFont;

    procedure SelAction(const modName: WideString = ''; bookName: Integer = 0);
    function LinkFromPoint(pt: TPoint; out me: TModuleEntry;
      out linkType: TLibLinkType): Integer;
    function PaintTokens(canv: TCanvas; rct: TRect; tkns: TStrings;
      calc: Boolean; var rects: PRectArray): Integer;
    function PaintBookTokens(canv: TCanvas; rct: TRect;
      var tkns: TMatchInfoArray; calc: Boolean): Integer;
    procedure SetTagTabs();
  public
    mCellText: WideString;
    mBookIx: Integer;
    mUseDisposition: TBQUseDisposition;
    mUILock: Boolean;
    mSavedWidth, mSavedHeight: Integer;
    procedure UpdateList(ml: TObjectList; ti: Integer = -1;
      selName: WideString = '');
    procedure PrepareFonts();
    { Public declarations }
  end;

var
  MyLibraryForm: TMyLibraryForm;
  G_OtherCats: WideString = 'Другие категории';

implementation

uses ExceptionFrm, Types, BibleQuoteConfig, PlainUtils;
{$R *.dfm}

function EmptyModuleEntry(): TModuleEntry;

{$J+}
const
  S_EmptyModuleEntry: TModuleEntry = nil;
{$J-}
begin
  if not assigned(S_EmptyModuleEntry) then
  begin
    S_EmptyModuleEntry := TModuleEntry.Create(modtypeBible, '------', '',
      '<none>', '', '', '');
  end;
  Result := S_EmptyModuleEntry;
end;

procedure TMyLibraryForm.btnClearClick(Sender: TObject);
begin
  edtFilter.Text := '';
end;

procedure TMyLibraryForm.btnCollapseClick(Sender: TObject);
var
  pn: PVirtualNode;
begin
  pn := vdtBookList.GetFirstVisible(vdtBookList.RootNode);
  if mUseDisposition = udMyLibrary then
  begin
    while (assigned(pn)) and ((vdtBookList.RootNode <> pn)) do
    begin
      vdtBookList.Expanded[pn] := false;
      pn := vdtBookList.GetNextVisible(pn);
    end;
    exit
  end
  else if mUseDisposition = udParabibles then
  begin
    if not assigned(pn) then
      exit;
    vdtBookList.Selected[pn] := true;
    btnOK.Click();
  end;
end;

procedure TMyLibraryForm.btnOKClick(Sender: TObject);
begin
  SelAction();
end;

procedure TMyLibraryForm.edtFilterChange(Sender: TObject);
begin
  UpdateList(mods);
end;

procedure TMyLibraryForm.edtFilterKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  pvn: PVirtualNode;
begin
  if Key = VK_DOWN then
  begin
    FocusControl(vdtBookList);
    pvn := vdtBookList.GetFirst();
    if not assigned(pvn) then
      exit;
    vdtBookList.FocusedNode := pvn;
  end;
end;

procedure TMyLibraryForm.FormKeyPress(Sender: TObject; var Key: Char);

begin
  try
    if (Key = #27) and (ActiveControl <> vdtBookList) then
    begin
      ModalResult := mrCancel;
      close;
    end
    else if Key = #13 then
    begin
      SelAction();
    end;
  except
  end;
end;

procedure TMyLibraryForm.FormShow(Sender: TObject);
begin
  PrepareFonts();
  edtFilter.SelectAll();
  btnCollapse.Visible := (dtsTags.TabIndex = 4) or
    (mUseDisposition = udParabibles);
  FocusControl(edtFilter);
end;

function TMyLibraryForm.LinkFromPoint(pt: TPoint; out me: TModuleEntry;
  out linkType: TLibLinkType): Integer;
var
  Node: PVirtualNode;
  nVOrg, i, c: Integer;
begin
  Result := -1;
  Node := vdtBookList.GetNodeAt(pt.X, pt.Y, true, nVOrg);
  if Node = nil then
    exit;
  try
    me := TModuleEntry((vdtBookList.GetNodeData(Node))^);
    pt.Y := pt.Y - nVOrg;
    if Integer(me) < 65536 then
      exit;
    c := me.mCatsCnt - 1;

    if c >= 0 then
    begin
      i := -1;
      repeat
        inc(i);
      until (i > c) or (PtInRect(me.mRects^[i], pt));
      if i <= c then
      begin
        Result := i;
        linkType := lltTag;
        exit
      end;
    end;

    c := length(me.mMatchInfo) - 1;
    if c >= 0 then
    begin
      i := -1;
      repeat
        inc(i);
      until (i > c) or (PtInRect(me.mMatchInfo[i].rct, pt));
      if i <= c then
      begin
        Result := i;
        linkType := lltBook;
      end;
    end;

  except
  end;
end;

procedure TMyLibraryForm.dtsTagsChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  if mods = nil then
    exit;
  if NewTab = 4 then
  begin

  end;
  btnCollapse.Visible := NewTab = 4;
  UpdateList(mods, NewTab);
end;

function TMyLibraryForm.PaintBookTokens(canv: TCanvas; rct: TRect;
  var tkns: TMatchInfoArray; calc: Boolean): Integer;

var
  i, c, fw, fh, fi, fwidth: Integer;
  ws: WideString;
  sz: TSize;

  procedure AlignRects(f, l: Integer);
  var
    sw, i, space: Integer;
  begin
    if f = l then
      exit;
    sw := 0;
    for i := f to l do
      inc(sw, tkns[i].rct.Right - tkns[i].rct.Left);
    space := (fwidth - sw) div (l - f);
    sw := 0;
    for i := f + 1 to l do
    begin
      sw := tkns[i - 1].rct.Right - tkns[i - 1].rct.Left + space + sw;
      OffsetRect(tkns[i].rct, sw - tkns[i].rct.Left, 0);
    end;

  end;

begin
  c := length(tkns) - 1;
  // if c > 9 then c := 9;
  if calc then
  begin

    tkns[0].rct.Left := rct.Left;
    tkns[0].rct.Right := rct.Right;
    tkns[0].rct.Top := rct.Top;
    tkns[0].rct.Bottom := rct.Bottom;
    sz := canv.TextExtent('X');
    fw := sz.cx;
    fh := canv.Font.Height div 3;
    fwidth := rct.Right - rct.Left;
    if fh < 0 then
      fh := -fh;

    fi := 0;

    for i := 0 to c do
    begin
      ws := tkns[i].name;

      Windows.DrawTextW(canv.Handle, PWideChar(Pointer(ws)), -1, tkns[i].rct, DT_TOP or DT_CALCRECT or DT_SINGLELINE);

      if (tkns[i].rct.Right > rct.Right) and (tkns[i].rct.Left > rct.Left) then
      begin
        AlignRects(fi, i - 1);
        fi := i;
        tkns[i].rct.Left := rct.Left;
        tkns[i].rct.Top := tkns[i].rct.Bottom + fh;
        Windows.DrawTextW(canv.Handle, PWideChar(Pointer(ws)), -1, tkns[i].rct,
          DT_TOP or DT_CALCRECT or DT_SINGLELINE);
      end;

      if i < c then
      begin
        tkns[i + 1].rct.Left := tkns[i].rct.Right + fw * 4;
        tkns[i + 1].rct.Top := tkns[i].rct.Top;
        tkns[i + 1].rct.Bottom := rct.Bottom;
        tkns[i + 1].rct.Right := rct.Right;
      end;

    end;

  end
  else
  begin
    for i := 0 to c do
    begin
      ws := tkns[i].name;

      Windows.DrawTextW(canv.Handle, PWideChar(Pointer(ws)), -1, tkns[i].rct,
        DT_TOP or DT_SINGLELINE);
    end;
  end;

  Result := tkns[c].rct.Bottom;

end;

function TMyLibraryForm.PaintTokens(canv: TCanvas; rct: TRect; tkns: TStrings;
  calc: Boolean; var rects: PRectArray): Integer;
var
  i, c, fw, fh: Integer;
  ws: WideString;
  sz: TSize;
begin
  c := tkns.Count - 1;

  if c > 9 then
    c := 9;

  if calc then
  begin

    rects^[0].Left := rct.Left;
    rects^[0].Right := rct.Right;
    rects^[0].Top := rct.Top;
    rects^[0].Bottom := rct.Bottom;
    sz := canv.TextExtent('X');
    fw := sz.cx;
    fh := canv.Font.Height;
    if fh < 0 then
      fh := -fh;

    for i := 0 to c do
    begin
      ws := tkns[i];

      Windows.DrawTextW(canv.Handle, PWideChar(Pointer(ws)), -1, rects^[i], DT_TOP or DT_CALCRECT or DT_SINGLELINE);

      if (rects^[i].Right > rct.Right) and (rects^[i].Left > rct.Left) then
      begin
        rects^[i].Left := rct.Left;
        rects^[i].Top := rects^[i].Bottom + fh;
        Windows.DrawTextW(canv.Handle, PWideChar(Pointer(ws)), -1, rects^[i], DT_TOP or DT_CALCRECT or DT_SINGLELINE);
      end;

      if i < c then
      begin
        rects^[i + 1].Left := rects^[i].Right + fw * 4;
        rects^[i + 1].Top := rects^[i].Top;
        rects^[i + 1].Bottom := rct.Bottom;
        rects^[i + 1].Right := rct.Right;
      end;

    end;

  end
  else
  begin

    for i := 0 to c do
    begin
      ws := tkns[i];
      Windows.DrawTextW(canv.Handle, PWideChar(Pointer(ws)), -1, rects^[i], DT_TOP or DT_SINGLELINE);
    end;

  end;

  Result := rects[c].Bottom;
end;

procedure TMyLibraryForm.PrepareFonts;
var
  rh: Integer;
begin
  rh := vdtBookList.Font.Height;

  // if rh<0 t;
  if not assigned(mfntReg) then
    mfntReg := TFont.Create();
  if not assigned(mfntBook) then
    mfntBook := TFont.Create();
  if not assigned(mfntTag) then
    mfntTag := TFont.Create();
  if not assigned(mfntTagCap) then
    mfntTagCap := TFont.Create();
  mfntReg.Height := rh;
  mfntBook.Height := rh * 4 div 5;
  mfntTag.Height := rh * 4 div 5;
  mfntTagCap.Height := rh;
  mfntTag.Style := [fsUnderline]; // mfntBook.Style:=[fsBold];
  mfntReg.Color := clWindowText;
  mfntTagCap.Color := clWindowText;
  mfntTag.Color := $B07B00;
  mfntBook.Color := $005EBB;
end;

procedure TMyLibraryForm.SelAction(const modName: WideString = '';
  bookName: Integer = 0);
var
  pvn: PVirtualNode;
var
  pNodeData: TModuleEntry;
begin

  pvn := vdtBookList.GetFirstSelected();
  if length(modName) <= 0 then
  begin
    if assigned(pvn) then
    begin
      pNodeData := TModuleEntry((vdtBookList.GetNodeData(pvn))^);
      if Integer(pNodeData) > 65536 then
      begin
        if pNodeData.modType = modtypeTag then
          exit;
        mCellText := pNodeData.wsFullName;
        ModalResult := mrOk;
      end // modentry valid
    end // selected node found
  end // modName not spec
  else
  begin
    mCellText := modName;
    ModalResult := mrOk;
  end;
  if ModalResult <> 0 then
    if bookName > 0 then
      mBookIx := bookName
    else
    begin
      if (assigned(pvn)) then
      begin
        pNodeData := TModuleEntry((vdtBookList.GetNodeData(pvn))^);
        if Integer(pNodeData) > 65536 then
        begin
          if (pNodeData.modType = modtypeBookHighlighted) and
            (length(pNodeData.mMatchInfo) > 0) then
          begin
            mBookIx := pNodeData.mMatchInfo[0].ix;
            exit
          end; // if modtype is book hl
        end; // if modentry valid object
      end; // if selected node detected
      mBookIx := 0;
    end; // else- when modname is not specif

end;

procedure TMyLibraryForm.SetTagTabs;
var
  s: WideString;
  c, i: Integer;
begin
  if mUseDisposition = udMyLibrary then
  begin

    s := Lang.SayDefault('LibTabsAll', 'All');
    if dtsTags.Tabs.Count < 1 then
      dtsTags.Tabs.Add(s)
    else if dtsTags.Tabs[0] <> s then
      dtsTags.Tabs[0] := s;

    s := Lang.SayDefault('LibTabsScriptures', 'Scriptures');
    if dtsTags.Tabs.Count < 2 then
      dtsTags.Tabs.Add(s)
    else if dtsTags.Tabs[1] <> s then
      dtsTags.Tabs[1] := s;

    s := Lang.SayDefault('LibTabsBooks', 'Books');
    if dtsTags.Tabs.Count < 3 then
      dtsTags.Tabs.Add(s)
    else if dtsTags.Tabs[2] <> s then
      dtsTags.Tabs[2] := s;

    s := Lang.SayDefault('LibTabsComments', 'Commentaries');
    if dtsTags.Tabs.Count < 4 then
      dtsTags.Tabs.Add(s)
    else if dtsTags.Tabs[3] <> s then
      dtsTags.Tabs[3] := s;

    s := Lang.SayDefault('LibTabsTags', 'Tags');
    if dtsTags.Tabs.Count < 5 then
      dtsTags.Tabs.Add(s)
    else if dtsTags.Tabs[4] <> s then
      dtsTags.Tabs[4] := s;

  end
  else if mUseDisposition = udParabibles then
  begin
    btnCollapse.Visible := true;
    c := dtsTags.Tabs.Count - 1;
    s := Lang.SayDefault('LibTabsScriptures', 'Scriptures');
    if c >= 0 then
    begin
      for i := 1 to c do
        dtsTags.Tabs.Delete(0)
    end;
    if c < 0 then
      dtsTags.Tabs.Add(s)
    else if dtsTags.Tabs[0] <> s then
      dtsTags.Tabs[0] := s;
    dtsTags.TabIndex := 0;
  end;
end;

procedure TMyLibraryForm.FormCreate(Sender: TObject);
var
  v: Integer;
begin
  try
    PrepareFonts();
    mCatNodes := TCachedModules.Create(true);
    SetTagTabs();

    dtsTags.TabIndex := 0;
    Lang.TranslateForm(self);
    mStrTokens := TStringList.Create();
    mTagTokens := TStringList.Create();
    mFilterStrTokens := TStringList.Create();
    self.Font.Assign((self.Owner as TForm).Font);
    self.Font.Height := self.Font.Height * 5 div 4;
    v := MainCfgIni.GetIntDefault(C_frmMyLibHeight, 10000);
    if v > Screen.Height then
      v := Screen.Height * 2 div 3;
    Height := v;
    v := MainCfgIni.GetIntDefault(C_frmMyLibWidth, 10000);
    if v > Screen.Width then
      v := Screen.Width div 3;
    Width := v;
    Position := poMainFormCenter;
  except
    on e: Exception do
      BqShowException(e, '');

  end;
end;

procedure TMyLibraryForm.FormDestroy(Sender: TObject);
begin
  try
    mfntReg.Free();
    mfntBook.Free();
    mfntTag.Free;
    mfntTagCap.Free();
    mStrTokens.Free();
    mTagTokens.Free();
    mFilterStrTokens.Free();
    FreeAndNil(mCatNodes);
  except
  end;
end;

procedure TMyLibraryForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  dlt, ti: Integer;

begin

  if (Key = VK_TAB) and (ssCtrl in Shift) then
  begin
    dlt := 1;
    Dec(dlt, ord(ssShift in Shift) * 2);
    ti := dtsTags.TabIndex;
    inc(ti, dlt);
    if (ti >= dtsTags.Tabs.Count) then
      ti := 0
    else if (ti < 0) then
      ti := dtsTags.Tabs.Count - 1;
    dtsTags.TabIndex := ti;
  end;

end;

procedure TMyLibraryForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if self.ActiveControl <> vdtBookList then
    self.FocusControl(vdtBookList);
  // Handled:=true;
end;

procedure TMyLibraryForm.FormResize(Sender: TObject);
begin
  vdtBookList.ReinitChildren(nil, true);
end;

procedure TMyLibraryForm.UpdateList(ml: TObjectList; ti: Integer = -1;
  selName: WideString = '');
var
  cnt, i: Integer;
  me, catMe: TModuleEntry;
  mt: TModMatchTypes;
  allMatch, doAdd, selFlag, foundCat: Boolean;
  ss, tagstr: string;
  ci: Integer;
  rt, sel, tempVN: PVirtualNode;
  j, tg: Integer;

begin
  if mUILock then
    exit;
  mUILock := true;
  try

    ss := Trim(edtFilter.Text);
    mFilterStr := ss;
    mFiltered := length(ss) > 0;
    // edtFilter.Text:=ss;

    if ti < 0 then
      ti := dtsTags.TabIndex;
    SetTagTabs();
    if mUseDisposition = udParabibles then
    begin
      ti := 1;
    end;
    mods := ml;
    sel := nil;
    if length(selName) <= 0 then
    begin
      rt := vdtBookList.GetFirstSelected();
      if assigned(rt) then
      begin
        me := TModuleEntry(vdtBookList.GetNodeData(rt)^);
        if assigned(me) then
        begin
          selName := me.wsFullName;
        end;
      end;
    end;

    vdtBookList.Clear();
    mCatNodes.Clear();
    mCounter := 0;
    cnt := ml.Count - 1;
    vdtBookList.BeginUpdate();
    try
      mStrTokens.Clear();
      if length(ss) > 0 then
      begin

        allMatch := ss[1] <> '.';
        mAllMatch := allMatch;
        if not allMatch then
          ss := Copy(ss, 2, $FFF);
      end;

      if mUseDisposition = udParabibles then
      begin
        vdtBookList.AddChild(nil, Pointer(EmptyModuleEntry()));
      end;

      StrToTokens(ss, ' ', mFilterStrTokens);
      for i := 0 to cnt do
      begin
        me := TModuleEntry(ml.Items[i]);
        if length(ss) > 0 then
        begin

          mt := me.Match(mFilterStrTokens, me.mMatchInfo, allMatch);
          if (mt = []) or ((me.modType in [modtypeBible, modtypeComment]) and
            (mt = [mmtBookName])) then
            Continue;

          // if Pos(WideLowerCase(edtFilter.Text), WideLowerCase(TModuleEntry(ml.Items[i]).wsFullName))<=0 then continue;
        end;

        case ti of
          0, 4:
            doAdd := true;
          1:
            doAdd := me.modType = modtypeBible;
          2:
            doAdd := me.modType = modtypeBook;
          3:
            doAdd := me.modType = modtypeComment;
        end;
        selFlag := (me.wsFullName = selName) and doAdd;
        if (doAdd) and (mmtBookName in mt) then
        begin
          catMe := me;
          me := TModuleEntry.Create(me);
          catMe.mMatchInfo := nil;
          me.modType := modtypeBookHighlighted;

        end;
        if ti = 4 then
        begin
          StrToTokens(me.modCats, '|', mTagTokens);
          tg := mTagTokens.Count;
          j := 0;
          inc(mCounter);
          foundCat := false;
          repeat
            tagstr := mTagTokens[j];
            if (mFiltered) then
            begin
              if (not(mmtCat in mt)) then
              begin
                tg := 1;
                tagstr := G_OtherCats;
              end
              else // mmtCat hit

                if (not StrMathTokens(tagstr, mFilterStrTokens, allMatch)) then
                begin
                  // not found cat
                  inc(j);
                  if (j >= tg) and (not foundCat) then
                  begin
                    tagstr := G_OtherCats;
                  end
                  else
                    Continue;
                end
                else { cat found }
                  foundCat := true;

            end; // filtered

            // end;

            ci := mCatNodes.IndexOf(tagstr);
            if ci < 0 then
            begin
              catMe := TModuleEntry.Create(modtypeTag, tagstr, '', '', '', '', '');

              rt := vdtBookList.AddChild(nil, Pointer(catMe));
              if tagstr = selName then
                sel := rt;
              Include(rt^.States, vsDisabled);
              catMe.mNode := rt;
              mCatNodes.Add(catMe);
            end
            else
              rt := PVirtualNode(TModuleEntry(mCatNodes[ci]).mNode);

            tempVN := vdtBookList.AddChild(rt, me);
            if selFlag then
            begin
              selFlag := false;
              sel := tempVN;
            end;
            if length(ss) > 0 then
              vdtBookList.Expanded[rt] := true;
            inc(j);
          until j >= tg;

        end
        else if doAdd then
        begin
          inc(mCounter);
          tempVN := vdtBookList.AddChild(nil, me);
        end;

        if selFlag then
          sel := tempVN;
      end;
      vdtBookList.Sort(nil, 0, sdAscending, false);
    finally
      stxCount.Caption := IntToStr(mCounter);
      vdtBookList.EndUpdate();
    end;

    if (not assigned(sel)) and (vdtBookList.RootNodeCount > 0) then
      sel := vdtBookList.GetFirst();
    if assigned(sel) then
    begin
      vdtBookList.Selected[sel] := true;

    end;

  finally
    mUILock := false;
    vdtBookList.EndUpdate;
  end;

  vdtBookList.ScrollIntoView(sel, true);

end;

procedure TMyLibraryForm.vdtBookListClick(Sender: TObject);
var
  me: TModuleEntry;
  pt: TPoint;
  i: Integer;
  lt: TLibLinkType;
var
  pn, cn: PVirtualNode;
begin

  pt := vdtBookList.ScreenToClient(Mouse.CursorPos);
  pn := vdtBookList.GetNodeAt(pt.X, pt.Y);
  if not assigned(pn) then
    exit;
  me := TModuleEntry(vdtBookList.GetNodeData(pn)^);
  if not assigned(me) then
    exit;
  if me.modType = modtypeTag then
  begin
    vdtBookList.Expanded[pn] := not vdtBookList.Expanded[pn];
    if vdtBookList.Expanded[pn] then
    begin
      cn := vdtBookList.GetFirstChild(pn);
      if assigned(cn) then
        vdtBookList.FocusedNode := cn
    end
    else
      vdtBookList.FocusedNode := nil;
    exit;
  end;

  i := LinkFromPoint(pt, me, lt);
  if i < 0 then
    exit;
  if lt = lltBook then
  begin
    SelAction(me.wsFullName, me.mMatchInfo[i].ix);

  end
  else
  begin
    StrToTokens(me.modCats, '|', mStrTokens);
    edtFilter.Text := mStrTokens[i];
  end;
  // node:=vdtBookList.GetNodeAt(pt.x,pt.y, true, nVOrg);
  // if node=nil then exit;
  // try
  // me:=TModuleEntry((vdtBookList.GetNodeData(node))^);
  // if not assigned(me) then exit;
  // c:=me.mCatsCnt-1;
  // if c<0 then exit;
  // pt.Y:=pt.Y - nVOrg;
  //
  // for I := 0 to c do begin
  // if PtInRect(me.mRects^[i],pt) then begin
  // StrToTokens(me.modCats, '|', mStrTokens);
  // edtFilter.Text:='.'+ mStrTokens[i];
  // end;
  //
  // end;//fr
  //

end;

procedure TMyLibraryForm.vdtBookListCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  mod1, mod2: TModuleEntry;
  tr: Integer;
const
  synodalny: string = 'Ñèíîä';
  russky: string = 'Ðóññê';
label
  done;
begin
  mod1 := TModuleEntry(Sender.GetNodeData(Node1)^);
  mod2 := TModuleEntry(Sender.GetNodeData(Node2)^);

  if not(assigned(mod1) and assigned(mod2)) then
  begin
    Result := 0;
  end;

  tr := ord(mod1.modType) - ord(mod2.modType);
  if tr = 0 then
    if mod1.modType = modtypeTag then
    begin
      if mod1.wsFullName = G_OtherCats then
      begin
        Result := 1;
        exit;
      end;
      if mod2.wsFullName = G_OtherCats then
      begin
        Result := -1;
        exit;
      end;
    end;
  tr := OmegaCompareTxt(mod1.wsFullName, mod2.wsFullName);
  // AnsiCompareText(mod1.name, mod2.name);
done:
  Result := tr;

end;

procedure TMyLibraryForm.vdtBookListGetHintSize(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
var
  me: TModuleEntry;
begin
  if Node = nil then
    exit;
  // if column<0 then exit;
  me := TModuleEntry((Sender.GetNodeData(Node))^);
  if (not assigned(me)) or (me.modType = modtypeTag) then
    exit;
  vdtBookList.Canvas.Font.Assign(self.Font);
  vdtBookList.Canvas.Font.Height := self.Font.Height * 4 div 5;

  R.Right := 640;
  R.Bottom := 480;
  DrawTextW(vdtBookList.Canvas.Handle, PWideChar(Pointer(me.wsShortPath)),
    length(me.wsShortPath), R, DT_CALCRECT);
  InflateRect(R, 6, 6);
end;

procedure TMyLibraryForm.vdtBookListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  pNodeData: TModuleEntry;
begin
  if Node = nil then
    exit;
  pNodeData := TModuleEntry((Sender.GetNodeData(Node))^);
  if Integer(pNodeData) > 65536 then
    try
      CellText := pNodeData.wsFullName;
    except
    end;
end;

procedure TMyLibraryForm.vdtBookListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);

begin
  try
    if Key = VK_ESCAPE then
      FocusControl(edtFilter)
  except
  end;
end;

procedure TMyLibraryForm.vdtBookListMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
var
  me: TModuleEntry;
  rct: TRect;
  h, dlt, vmarg, rght: Integer;
  ws: WideString;
  p: Pointer;
begin
  if (Node = nil) or (csDestroying in self.ComponentState) then
    exit;

  try
    TargetCanvas.Font := mfntReg;
    dlt := mfntReg.Height;
    if dlt < 0 then
      dlt := -dlt;
    dlt := dlt div 4;
    if dlt = 0 then
      dlt := 2;

    p := Sender.GetNodeData(Node);
    me := TModuleEntry((p)^);
    ws := me.wsFullName;

    rct.Left := 0;
    rct.Top := 0;
    rct.Bottom := 200;

    rght := vdtBookList.Width - GetSystemMetrics(SM_CXVSCROLL) -
      vdtBookList.TextMargin * 2 - 6;
    rct.Right := rght;
    h := Windows.DrawTextW(TargetCanvas.Handle, PWideChar(Pointer(ws)), -1, rct,
      DT_CALCRECT or DT_WORDBREAK);
    NodeHeight := h;
    rct.Top := h;
    vmarg := dlt + dlt;
    rct.Right := rght;
    if me.modType = modtypeBookHighlighted then
    begin
      inc(rct.Top, dlt);
      TargetCanvas.Font := mfntBook;
    end;
    inc(rct.Left, 4);
    if ((me.modType = modtypeBookHighlighted) or (bqisExpanded in me.mStyle))
      and (length(me.mMatchInfo) > 0) then
    begin
      rct.Left := vdtBookList.TextMargin;
      rct.Right := vdtBookList.Width - GetSystemMetrics(SM_CXVSCROLL) -
        vdtBookList.TextMargin - 2;
      dlt := mfntTag.Height;
      TargetCanvas.Font := mfntBook;
      if dlt < 0 then
        dlt := -dlt;
      rct.Top := rct.Top + (dlt div 4);
      rct.Bottom := rct.Top + 300;
      rct.Top := PaintBookTokens(TargetCanvas, rct, me.mMatchInfo, true);
    end;

    if (length(me.modCats) <= 0) then
    begin
      if me.modType = modtypeTag then
        inc(vmarg, 5);
      inc(NodeHeight, vmarg);
      exit;
    end;

    mStrTokens.Clear();
    StrToTokens(me.modCats, '|', mStrTokens);
    ws := TokensToStr(mStrTokens, ' ', false);

    if not assigned(me.mRects) then
    begin
      GetMem(me.mRects, mStrTokens.Count * sizeof(TRect));
      me.mCatsCnt := mStrTokens.Count;
    end;

    rct.Right := vdtBookList.Width - GetSystemMetrics(SM_CXVSCROLL) -
      vdtBookList.TextMargin - 2;
    dlt := mfntTag.Height;

    TargetCanvas.Font := mfntTag;

    if dlt < 0 then
      dlt := -dlt;
    rct.Top := rct.Top + (dlt div 4);
    rct.Bottom := rct.Top + 300;
    NodeHeight := PaintTokens(TargetCanvas, rct, mStrTokens, true, me.mRects)
      + (vmarg);
    // h:=Windows.DrawTextW(TargetCanvas.Handle,
    // PWideChar(Pointer(ws)), -1,rct,DT_CALCRECT or DT_WORDBREAK);

    ///
  except { on e:Exception do BqShowException(e); }
  end;

end;

procedure TMyLibraryForm.vdtBookListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  me: TModuleEntry;
var
  pn: PVirtualNode;

begin
  pn := vdtBookList.GetNodeAt(X, Y);
  if not assigned(pn) then
    exit;
  me := TModuleEntry(vdtBookList.GetNodeData(pn)^);
  if not assigned(me) then
    exit;
  if me.modType = modtypeTag then
  begin
    mAllowExp := not vdtBookList.Expanded[pn];
  end;

end;

procedure TMyLibraryForm.vdtBookListMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  me: TModuleEntry;
  pt: TPoint;
  pn: PVirtualNode;
  lt: TLibLinkType;
begin
  //
  pn := vdtBookList.GetNodeAt(X, Y);
  if not assigned(pn) then
    exit;
  me := TModuleEntry(vdtBookList.GetNodeData(pn)^);
  if not assigned(me) then
    exit;
  if me.modType = modtypeTag then
  begin
    vdtBookList.Cursor := crHandPoint;
    exit;
  end;

  pt.X := X;
  pt.Y := Y;
  i := LinkFromPoint(pt, me, lt);
  if i < 0 then
  begin
    vdtBookList.Cursor := crDefault;
  end
  else
  begin
    vdtBookList.Cursor := crHandPoint;
  end;
end;

procedure TMyLibraryForm.vdtBookListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pvn: PVirtualNode;
  me: TModuleEntry;
  i: Integer;
  bk: string;
begin
  if Button <> mbRight then
    exit;
  pvn := vdtBookList.GetNodeAt(X, Y);
  if not assigned(pvn) then
    exit;
  me := TObject(vdtBookList.GetNodeData(pvn)^) as TModuleEntry;
  if (me.modType in [modtypeBook, modtypeBookHighlighted]) then
  begin
    if not(bqisExpanded in me.mStyle) then
    begin
      Include(me.mStyle, bqisExpanded);
      SetLength(me.mMatchInfo, 255);
      i := 0;
      repeat
        bk := StrGetTokenByIx(me.modBookNames, i + 1);
        if length(bk) <= 0 then
          break;
        me.mMatchInfo[i].ix := i + 1;
        me.mMatchInfo[i].name := C_BulletChar + #32 + bk;
        inc(i)
      until i >= 255;
      SetLength(me.mMatchInfo, i);

    end

    else
    begin
      Exclude(me.mStyle, bqisExpanded);
      SetLength(me.mMatchInfo, 0);
      if me.modType = modtypeBookHighlighted then
      begin
        me.Match(mFilterStrTokens, me.mMatchInfo, mAllMatch);
      end;
    end;
    vdtBookList.ReinitNode(pvn, false);
  end
end;

procedure TMyLibraryForm.vdtBookListDblClick(Sender: TObject);
begin
  SelAction();
end;

procedure TMyLibraryForm.vdtBookListDrawHint(Sender: TBaseVirtualTree;
  HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
var
  me: TModuleEntry;
begin
  if Node = nil then
    exit;
  me := TModuleEntry((Sender.GetNodeData(Node))^);
  if not assigned(me) then
    exit;
  HintCanvas.Font.Assign(self.Font);
  HintCanvas.Font.Height := HintCanvas.Font.Height * 4 div 5;
  HintCanvas.Brush.Color := clWindow;
  HintCanvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, 2, 2);
  InflateRect(R, -6, -6);
  Windows.DrawTextW(HintCanvas.Handle, PWideChar(Pointer(me.wsShortPath)),
    length(me.wsShortPath), R, 0);
end;

procedure TMyLibraryForm.vdtBookListDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);

var
  me: TModuleEntry;
  rct: TRect;
  h, dlt, flgs: Integer;
  ws: string;
  cl1: TColor;
begin

  if PaintInfo.Node = nil then
    exit;
  me := TModuleEntry((Sender.GetNodeData(PaintInfo.Node))^);
  rct := PaintInfo.ContentRect;
  PaintInfo.Canvas.Font := mfntReg;
  dlt := mfntReg.Height;
  if dlt < 0 then
    dlt := -dlt;

  dlt := dlt div 4;
  if dlt = 0 then
    dlt := 1;
  if me.modType = modtypeTag then
  begin
    flgs := DT_WORDBREAK or DT_VCENTER;
    InflateRect(rct, -2, -2);
    if Sender.FocusedNode = PaintInfo.Node then
      cl1 := vdtBookList.Colors.FocusedSelectionColor
    else
    begin
      if me.wsFullName = G_NoCategoryStr then
        cl1 := $00D1D9ED
      else
        cl1 := $ACD5FF;

    end;
    PaintInfo.Canvas.Pen.Color := $90C0E0;
    PaintInfo.Canvas.Brush.Color := cl1;
    PaintInfo.Canvas.RoundRect(rct.Left, rct.Top, rct.Right, rct.Bottom, 4, 10);
    inc(rct.Left, 12);
    Dec(rct.Right, 2);
  end
  else
    flgs := DT_WORDBREAK;

  ws := me.wsFullName;

  inc(rct.Top, dlt);
  PaintInfo.Canvas.Font := mfntTagCap;
  if (not(me.modType = modtypeTag)) and (vsSelected in PaintInfo.Node^.States)
  then
  begin
    if vdtBookList.Focused then
      PaintInfo.Canvas.Brush.Color := vdtBookList.Colors.FocusedSelectionColor;
  end;
  h := Windows.DrawTextW(PaintInfo.Canvas.Handle, PWideChar(Pointer(ws)), -1,
    rct, flgs);

  rct.Top := h;

  // if me.modType=modtypeBookHighlighted then begin
  // Inc(rct.Top,dlt);
  // dlt := PaintInfo.Canvas.Font.Height;
  // PaintInfo.Canvas.Font:=mfntBook;
  // //h := Windows.DrawTextW(PaintInfo.Canvas.Handle,
  /// /      PWideChar(me.mMatchInfo[0].name ), -1, rct,  DT_WORDBREAK);
  // Inc(rct.Top,h);
  // end;
  if ((me.modType = modtypeBookHighlighted) or (bqisExpanded in me.mStyle)) and
    (length(me.mMatchInfo) > 0) then
  begin
    PaintInfo.Canvas.Font := mfntBook;
    PaintBookTokens(PaintInfo.Canvas, rct, me.mMatchInfo, false);
  end;

  if (length(me.modCats) <= 0) then
    exit;
  // Inc(rct.Top,h+dlt);
  mStrTokens.Clear();
  StrToTokens(me.modCats, '|', mStrTokens);

  ws := TokensToStr(mStrTokens, ' ', false);
  PaintInfo.Canvas.Font := mfntTag;
  PaintTokens(PaintInfo.Canvas, rct, mStrTokens, false, me.mRects);
  // h:=Windows.DrawTextW(PaintInfo.Canvas.Handle,
  // PWideChar(Pointer(ws)), -1,rct,DT_WORDBREAK);

end;

procedure TMyLibraryForm.vdtBookListFocusChanging(Sender: TBaseVirtualTree;
  OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
var
  me: TModuleEntry;
  n: PVirtualNode;
begin
  if NewNode = nil then
    exit;
  me := TModuleEntry((Sender.GetNodeData(NewNode))^);
  if not assigned(me) then
    exit;
  if me.modType <> modtypeTag then
    exit;
  Allowed := false;
  n := Sender.GetFirstChild(NewNode);
  if not assigned(n) then
    exit;
  Sender.FocusedNode := n;
  Sender.Selected[n] := true;
end;

procedure TMyLibraryForm.vdtBookListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  try
    PPointer(Sender.GetNodeData(Node))^ := nil;
  except
    // do nothing
  end;
end;

end.
