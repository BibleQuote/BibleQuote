unit qNavTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, Contnrs, StdCtrls, TntStdCtrls, ExtCtrls, TntForms,
  WideStrings,
  BibleQuoteUtils, DockTabSet, Tabs;

type
  TBQUseDisposition = (udMyLibrary, udParabibles);
  TLibLinkType = (lltTag, lltBook);
  TfrmQNav = class(TTntForm)
    vstBookList: TVirtualDrawTree;
    edFilter: TTntEdit;
    lbBQName: TTntLabel;
    btnOK: TButton;
    mTagTabsEx: TDockTabSet;
    btnCollapse: TButton;
    btnClear: TButton;
    stCount: TTntStaticText;
    procedure vstBookListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure vstBookListCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure edFilterChange(Sender: TObject);
    procedure edFilterKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstBookListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure vstBookListDblClick(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure vstBookListDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure vstBookListMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure TntFormResize(Sender: TObject);
    procedure vstBookListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure vstBookListClick(Sender: TObject);
    procedure mTagTabsExChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);

    procedure vstBookListFocusChanging(Sender: TBaseVirtualTree; OldNode,
      NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure vstBookListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vstBookListDrawHint(Sender: TBaseVirtualTree; HintCanvas: TCanvas;
      Node: PVirtualNode; R: TRect; Column: TColumnIndex);
    procedure vstBookListGetHintSize(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
    procedure TntFormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TntFormDestroy(Sender: TObject);
    procedure btnCollapseClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure vstBookListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstBookListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }

    mods: TObjectList;
    mStrTokens, mFilterStrTokens, mTagTokens: TWideStringList;
    mAllMatch:boolean;
    mAllowExp, mFiltered: boolean;
    mCatNodes: TCachedModules;
    mFilterStr: WideString;
    mCounter: Integer;
    mfntReg, mfntBook, mfntTag, mfntTagCap: TFont;

    procedure SelAction(const modName: Widestring = ''; bookName: integer = 0);
    function LinkFromPoint(pt: TPoint; out me: TModuleEntry;
      out linkType: TLibLinkType): integer;
    function PaintTokens(canv: TCanvas; rct: TRect;
      tkns: TWideStrings; calc: boolean; var rects: PRectArray): integer;
    function PaintBookTokens(canv: TCanvas; rct: TRect;
      var tkns: TMatchInfoArray; calc: boolean): integer;
    procedure SetTagTabs();
  public
    mCellText: WideString;
    mBookIx: integer;
    mUseDisposition: TBQUseDisposition;
    mUILock:boolean;
    mSavedWidth, mSavedHeight:integer;
    procedure UpdateList(ml: TObjectList; ti: integer = -1; selName: WideString
      =
      '');
    procedure PrepareFonts();
    { Public declarations }
  end;

var
  frmQNav: TfrmQNav;
  G_OtherCats: WideString = 'Другие категории';
implementation
uses bqExceptionTracker, Types, BibleQuoteConfig,bqPlainUtils;
{$R *.dfm}

function EmptyModuleEntry(): TModuleEntry;

{$J+}
const
  S_EmptyModuleEntry: TModuleEntry = nil;
{$J-}
begin
  if not assigned(S_EmptyModuleEntry) then begin
    S_EmptyModuleEntry := TModuleEntry.Create(modtypeBible, '------', '',
      '<none>', '', '', '');
  end;
  result := S_EmptyModuleEntry;
end;

procedure TfrmQNav.btnClearClick(Sender: TObject);
begin
  edFilter.Text := '';
end;

procedure TfrmQNav.btnCollapseClick(Sender: TObject);
var
  pn: PVirtualNode;
begin
  pn := vstBookList.GetFirstVisible(vstBookList.RootNode);
  if mUseDisposition=udMyLibrary then begin
  while (assigned(pn)) and ((vstBookList.RootNode <> pn)) do begin
    vstBookList.Expanded[pn] := false; pn := vstBookList.GetNextVisible(pn);
  end;
  exit
  end
  else if mUseDisposition=udParabibles then begin
    if not assigned(pn) then exit;
    vstBookList.Selected[pn]:=true;
    btnOK.Click();
  end;
end;

procedure TfrmQNav.edFilterChange(Sender: TObject);
begin
  UpdateList(mods);
end;

procedure TfrmQNav.edFilterKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  pvn: PVirtualNode;
begin
  if key = VK_DOWN then begin FocusControl(vstBookList);
    pvn := vstBookList.GetFirst();
    if not assigned(pvn) then exit;
    vstBookList.FocusedNode := pvn;
  end;
end;

procedure TfrmQNav.FormKeyPress(Sender: TObject; var Key: Char);

begin
  try
    if (key = #27) and (ActiveControl <> vstBookList) then
    begin ModalResult := mrCancel; close; end
    else if key = #13 then begin
      SelAction();
    end;
  except end;
end;

procedure TfrmQNav.FormShow(Sender: TObject);
begin
  PrepareFonts();
  edFilter.SelectAll();
  btnCollapse.Visible:=(mTagTabsEx.TabIndex=4) or (mUseDisposition=udParabibles);
  FocusControl(edFilter);
end;

function TfrmQNav.LinkFromPoint(pt: TPoint; out me: TModuleEntry;
  out linkType: TLibLinkType): integer;
var
  node: PVirtualNode;
  nVOrg, i, c: integer;
begin
  result := -1;
  node := vstBookList.GetNodeAt(pt.x, pt.y, true, nVOrg);
  if node = nil then exit;
  try
    me := TModuleEntry((vstBookList.GetNodeData(node))^);
    pt.Y := pt.Y - nVOrg;
    if integer(me) < 65536 then exit;
    c := me.mCatsCnt - 1;

    if c >= 0 then begin
      i := -1;
      repeat
        inc(i);
      until (i > c) or (PtInRect(me.mRects^[i], pt));
      if i <= c then begin result := i; linkType := lltTag; exit end;
    end;

    c := length(me.mMatchInfo) - 1;
    if c >= 0 then begin
      i := -1;
      repeat
        inc(i);
      until (i > c) or (PtInRect(me.mMatchInfo[i].rct, pt));
      if i <= c then begin result :=  i; linkType := lltBook; end;
    end;

  except end;
end;

procedure TfrmQNav.mTagTabsExChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  if mods = nil then exit;
  if NewTab = 4 then begin

  end;
  btnCollapse.Visible := NewTab = 4;
  UpdateList(mods, NewTab);
end;

function TfrmQNav.PaintBookTokens(canv: TCanvas; rct: TRect; var tkns:
  TMatchInfoArray;
  calc: boolean): integer;

var
  i, c, fw, fh, fi, fwidth: integer;
  ws: WideString;
  sz: TSize;

  procedure AlignRects(f, l: integer);
  var
    sw, i, space: integer;
  begin
    if f = l then exit;
    sw := 0;
    for i := f to l do Inc(sw, tkns[i].rct.Right - tkns[i].rct.Left);
    space := (fwidth - sw) div (l - f);
    sw := 0;
    for i := f + 1 to l do begin
      sw := tkns[i - 1].rct.Right - tkns[i - 1].rct.Left + space + sw;
      OffsetRect(tkns[i].rct, sw - tkns[i].rct.left, 0);
    end;

  end;

begin
  c := length(tkns) - 1;
//  if c > 9 then c := 9;
  if calc then begin

    tkns[0].rct.Left := rct.Left;
    tkns[0].rct.Right := rct.Right;
    tkns[0].rct.Top := rct.Top;
    tkns[0].rct.Bottom := rct.Bottom;
    sz := canv.TextExtent('X');
    fw := sz.cx;
    fh := canv.Font.Height div 3;
    fwidth := rct.Right - rct.Left;
    if fh < 0 then fh := -fh;

  end;
  fi := 0;
  for i := 0 to c do begin
    ws := tkns[i].name;
    if calc then begin
      Windows.DrawTextW(canv.Handle,
        PWideChar(Pointer(ws)), -1, tkns[i].rct, DT_TOP or DT_CALCRECT or
        DT_SINGLELINE);
      if (tkns[i].rct.Right > rct.Right) and (tkns[i].rct.Left > rct.Left) then
        begin
        AlignRects(fi, i - 1);
        fi := i;
        tkns[i].rct.Left := rct.Left;
        tkns[i].rct.Top := tkns[i].rct.Bottom + fh;
        Windows.DrawTextW(canv.Handle,
          PWideChar(Pointer(ws)), -1, tkns[i].rct, DT_TOP or DT_CALCRECT or
          DT_SINGLELINE);
      end;

      if i < c then begin
        tkns[i + 1].rct.Left := tkns[i].rct.RIGHT + fw * 4;
        tkns[i + 1].rct.Top := tkns[i].rct.Top;
        tkns[i + 1].rct.Bottom := rct.Bottom;
        tkns[i + 1].rct.Right := rct.Right;
      end;

    end
    else begin
      Windows.DrawTextW(canv.Handle,
        PWideChar(Pointer(ws)), -1, tkns[i].rct, DT_TOP or DT_SINGLELINE);
    end;

  end;
  result := tkns[c].rct.Bottom;

end;

function TfrmQNav.PaintTokens(canv: TCanvas; rct: TRect; tkns: TWideStrings;
  calc: boolean;
  var rects: PRectArray): integer;
var
  i, c, fw, fh: integer;
  ws: WideString;
  sz: TSize;
begin
  c := tkns.Count - 1;
  if c > 9 then c := 9;
  if calc then begin

    rects^[0].Left := rct.Left;
    rects^[0].Right := rct.Right;
    rects^[0].Top := rct.Top;
    rects^[0].Bottom := rct.Bottom;
    sz := canv.TextExtent('X');
    fw := sz.cx;
    fh := canv.Font.Height;
    if fh < 0 then fh := -fh;

  end;

  for i := 0 to c do begin
    ws := tkns[i];
    if calc then begin
      Windows.DrawTextW(canv.Handle,
        PWideChar(Pointer(ws)), -1, rects^[i], DT_TOP or DT_CALCRECT or
        DT_SINGLELINE);
      if (rects^[i].Right > rct.Right) and (rects^[i].Left > rct.Left) then begin
        rects^[i].Left := rct.Left;
        rects^[i].Top := rects^[i].Bottom + fh;
        Windows.DrawTextW(canv.Handle,
          PWideChar(Pointer(ws)), -1, rects^[i], DT_TOP or DT_CALCRECT or
          DT_SINGLELINE);
      end;

      if i < c then begin
        rects^[i + 1].Left := rects^[i].RIGHT + fw * 4;
        rects^[i + 1].Top := rects^[i].Top;
        rects^[i + 1].Bottom := rct.Bottom;
        rects^[i + 1].Right := rct.Right;
      end;

    end
    else begin
      Windows.DrawTextW(canv.Handle,
        PWideChar(Pointer(ws)), -1, rects^[i], DT_TOP or DT_SINGLELINE);
    end;

  end;
  result := rects[c].Bottom;

end;

procedure TfrmQNav.PrepareFonts;
var
  rh: integer;
begin
  rh := vstBookList.Font.Height;

//if rh<0 t;
  if not assigned(mfntReg) then mfntReg := TFont.Create();
  if not assigned(mfntBook) then mfntBook := TFont.Create();
  if not assigned(mfntTag) then mfntTag := TFont.Create();
  if not assigned(mfntTagCap) then mfntTagCap := TFont.Create();
  mfntReg.Height := rh; mfntBook.Height := rh * 4 div 5;
  mfntTag.Height := rh * 4 div 5; mfntTagCap.Height := rh;
  mfntTag.Style := [fsUnderline]; // mfntBook.Style:=[fsBold];
  mfntReg.Color := clWindowText; mfntTagCap.Color := clWindowText;
  mfntTag.Color := $B07B00; mfntBook.Color := $005EBB;
end;

procedure TfrmQNav.SelAction(const modName: Widestring = '';
  bookName: integer = 0);
var
  pvn: PVirtualNode;
var
  pNodeData: TModuleEntry;
var
  CellText: WideString;
begin

  pvn := vstBookList.GetFirstSelected();
  if length(modName) <= 0 then begin
    if assigned(pvn) then begin
      pNodeData := TModuleEntry((vstBookList.GetNodeData(pvn))^);
      if integer(pNodeData) > 65536 then begin
        if pNodeData.modType = modtypeTag then exit;
        mCellText := pNodeData.wsFullName;
        ModalResult := mrOk;
      end //modentry valid
    end//selected node found
  end// modName not spec
  else begin
    mCellText := modName;
    ModalResult := mrOk;
  end;
  if ModalResult<>0 then
  if bookName > 0 then mBookIx := bookName
  else begin
    if (assigned(pvn)) then begin
      pNodeData := TModuleEntry((vstBookList.GetNodeData(pvn))^);
      if integer(pNodeData) > 65536 then begin
        if (pNodeData.modType = modtypeBookHighlighted)
          and (length(pNodeData.mMatchInfo) > 0) then begin
          mBookIx := pNodeData.mMatchInfo[0].ix; exit
        end; //if modtype is book hl
      end; //if modentry valid object
    end; //if selected node detected
    mBookIx := 0;
  end; //else- when modname is not specif


end;

procedure TfrmQNav.SetTagTabs;
var
  s: WideString;
  c, i: integer;
begin
  if mUseDisposition = udMyLibrary then begin

    s := Lang.SayDefault('LibTabsAll', 'All');
    if mTagTabsEx.WideTabs.Count < 1 then
      mTagTabsEx.WideTabs.Add(s)
    else if mTagTabsEx.WideTabs[0] <> s then mTagTabsEx.WideTabs[0] := s;

    s := Lang.SayDefault('LibTabsScriptures', 'Scriptures');
    if mTagTabsEx.WideTabs.Count < 2 then
      mTagTabsEx.WideTabs.Add(s)
    else if mTagTabsEx.WideTabs[1] <> s then mTagTabsEx.WideTabs[1] := s;

    s := Lang.SayDefault('LibTabsBooks', 'Books');
    if mTagTabsEx.WideTabs.Count < 3 then
      mTagTabsEx.WideTabs.Add(s)
    else if mTagTabsEx.WideTabs[2] <> s then mTagTabsEx.WideTabs[2] := s;

    s := Lang.SayDefault('LibTabsComments', 'Commentaries');
    if mTagTabsEx.WideTabs.Count < 4 then
      mTagTabsEx.WideTabs.Add(s)
    else if mTagTabsEx.WideTabs[3] <> s then mTagTabsEx.WideTabs[3] := s;

    s := Lang.SayDefault('LibTabsTags', 'Tags');
    if mTagTabsEx.WideTabs.Count < 5 then
      mTagTabsEx.WideTabs.Add(s)
    else if mTagTabsEx.WideTabs[4] <> s then mTagTabsEx.WideTabs[4] := s;

  end
  else if mUseDisposition = udParabibles then begin
    btnCollapse.Visible := true;
    c := mTagTabsEx.WideTabs.Count - 1;
    s := Lang.SayDefault('LibTabsScriptures', 'Scriptures');
    if c >= 0 then begin
      for i := 1 to c do mTagTabsEx.WideTabs.Delete(0)
    end;
    if c < 0 then mTagTabsEx.WideTabs.Add(s)
    else if mTagTabsEx.WideTabs[0] <> s then mTagTabsEx.WideTabs[0] := s;
    mTagTabsEx.TabIndex := 0;
  end;
end;

procedure TfrmQNav.TntFormCreate(Sender: TObject);
var v:integer;
begin
  try
    PrepareFonts();
    mCatNodes := TCachedModules.Create(true);
    SetTagTabs();

    mTagTabsEx.TabIndex := 0;
    Lang.TranslateForm(self);
    mStrTokens := TWideStringList.Create();
    mTagTokens := TWideStringList.Create();
    mFilterStrTokens := TWideStringList.Create();
    self.Font.Assign((self.Owner as TForm).Font);
    self.Font.Height := self.Font.Height * 5 div 4;
    v:=  MainCfgIni.GetIntDefault(C_frmMyLibHeight,10000);
    if v>Screen.Height then v:=Screen.Height*2 div 3;
    Height:=v;
    v:=MainCfgIni.GetIntDefault(C_frmMyLibWidth,10000);
    if v>Screen.Width then v:=Screen.Width div 3;
    Width:=v;
    Position:=poMainFormCenter;
  except on e: Exception do BqShowException(e, '');

  end;
end;

procedure TfrmQNav.TntFormDestroy(Sender: TObject);
begin
try
 mfntReg.Free(); mfntBook.Free(); mfntTag.Free; mfntTagCap.Free();
 mStrTokens.Free();mTagTokens.Free();mFilterStrTokens.Free();
 FreeAndNil(mCatNodes);
except end;
end;

procedure TfrmQNav.TntFormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  dlt, ti: integer;

begin

  if (key = VK_TAB) and (ssCtrl in Shift) then begin
    dlt := 1;
    Dec(dlt, ord(ssShift in Shift) * 2);
    ti := mTagTabsEx.TabIndex;
    inc(ti, dlt);
    if (ti >= mTagTabsEx.WideTabs.Count) then ti := 0
    else if (ti < 0) then ti := mTagTabsEx.WideTabs.Count - 1;
    mTagTabsEx.TabIndex := ti;
  end;

end;

procedure TfrmQNav.TntFormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if self.ActiveControl <> vstBookList then self.FocusControl(vstBookList);
//Handled:=true;
end;

procedure TfrmQNav.TntFormResize(Sender: TObject);
begin
  vstBookList.ReinitChildren(nil, true);
end;

procedure TfrmQNav.UpdateList(ml: TObjectList; ti: integer = -1; selName:
  WideString = '');
var
  cnt, i, mIx: integer;
  name: WideString;
  me, catMe: TModuleEntry;
  mt: TModMatchTypes;
  allMatch, doAdd, selFlag, foundCat: boolean;
  ss, tagstr: WideString;
  ci: INTEGER;
  rt, sel, tempVN: PVirtualNode;
  j, tg: integer;

begin
if mUILock then exit;
mUILock:=true;
 try

  ss := Trim(edFilter.Text);
  mFilterStr := ss;
  mFiltered := length(ss) > 0;
//  edFilter.Text:=ss;

  if ti < 0 then ti := mTagTabsEx.TabIndex;
  SetTagTabs();
  if mUseDisposition = udParabibles then begin
    ti := 1;
  end;
  mods := ml;
  sel := nil;
  selFlag := false;
  if length(selname) <= 0 then begin
    rt := frmQNav.vstBookList.GetFirstSelected();
    if assigned(rt) then begin
      me := TModuleEntry(vstBookList.GetNodeData(rt)^);
      if Assigned(me) then begin
        selName := me.wsFullName;
      end;
    end;
  end;

  qNavTest.frmQNav.vstBookList.Clear();
  mCatNodes.Clear();
  mCounter := 0;
  cnt := ml.Count - 1;
  frmQNav.vstBookList.BeginUpdate();
  try
    mStrTokens.Clear();
    if length(ss) > 0 then begin

      allMatch := ss[1] <> '.';
      mAllMatch:=allMatch;
      if not allMatch then ss := Copy(ss, 2, $FFF);
    end;

    if mUseDisposition = udParabibles then begin
      vstBookList.AddChild(nil, Pointer(EmptyModuleEntry()));
    end;

    StrToTokens(ss, ' ', mFilterStrTokens);
    for i := 0 to cnt do begin
      me := TModuleEntry(ml.Items[i]);
      if length(ss) > 0 then begin

        mt := me.Match(mFilterStrTokens, me.mMatchInfo, allMatch);
        if (mt = []) or ((me.modType in [modtypeBible, modtypeComment])
          and (mt = [mmtBookName])) then Continue;

//  if Pos(WideLowerCase(edFilter.Text), WideLowerCase(TModuleEntry(ml.Items[i]).wsFullName))<=0 then continue;
      end;

      case ti of
        0, 4: doAdd := true;
        1: doAdd := me.modType = modtypeBible;
        2: doAdd := me.modType = modtypeBook;
        3: doAdd := me.modType = modtypeComment;
      end;
      selFlag := (me.wsFullName = selName) and doAdd;
      if (doadd) and (mmtBookName in mt) then begin
        catme := me;
        me := TModuleEntry.Create(me);
        catme.mMatchInfo := nil;
        me.modType := modtypeBookHighlighted;

      end;
      if ti = 4 then begin
        StrToTokens(me.modCats, '|', mTagTokens);
        tg := mTagTokens.Count;
        j := 0;
        Inc(mCounter);
        foundCat := false;
        repeat
          tagstr := mTagTokens[j];
          if (mFiltered) then begin
            if (not (mmtCat in mt)) then begin
              tg := 1; tagstr := G_OtherCats;
            end
            else //mmtCat hit

              if (not StrMathTokens(tagstr, mFilterStrTokens, allMatch)) then
            begin
                // not found cat
              inc(j);
              if (j >= tg) and (not foundCat) then begin
                tagstr := G_OtherCats;
              end
              else continue;
            end else {cat found} foundCat := true;

          end; //filtered

//          end;

          ci := mCatNodes.IndexOf(tagstr);
          if ci < 0 then begin
            catMe := TModuleEntry.Create(modtypeTag, tagstr, '', '', '', '',
             '');

            rt := vstBookList.AddChild(nil, Pointer(catMe));
            if tagstr = selName then sel := rt;
            Include(rt^.States, vsDisabled);
            catMe.mNode := rt;
            mCatNodes.Add(catMe);
          end
          else rt := PVirtualNode(TModuleEntry(mCatNodes[ci]).mNode);

          tempVN := frmQNav.vstBookList.AddChild(rt, me);
          if selFlag then begin selFlag := false; sel := tempVN; end;
          if length(ss) > 0 then
            vstBookList.Expanded[rt] := true;
          inc(j);
        until j >= tg;

      end
      else if doadd then begin
        Inc(mCounter);
        tempVN := frmQNav.vstBookList.AddChild(nil, me);
      end;

      if selFlag then sel := tempVN;
    end;
    frmQNav.vstBookList.Sort(nil, 0, sdAscending, false);
  finally
    stCount.Caption := IntToStr(mCounter);
    frmQNav.vstBookList.EndUpdate();
  end;

  if (not assigned(sel)) and (vstBookList.RootNodeCount > 0) then
    sel := vstBookList.GetFirst();
  if assigned(sel) then begin
    vstBookList.Selected[sel] := true;

  end;

 finally
   mUILock:=false;
   frmQNav.vstBookList.EndUpdate;
 end;

//repeat
selFlag:= vstBookList.ScrollIntoView(sel, true);
//until selFlag;

end;

procedure TfrmQNav.vstBookListClick(Sender: TObject);
var
  me: TModuleEntry;
  pt: TPoint;
  i: integer;
  lt: TLibLinkType;
var
  pn, cn: PVirtualNode;
begin

  pt := vstBookList.ScreenToClient(Mouse.CursorPos);
  pn := vstBookList.GetNodeAt(pt.x, pt.y);
  if not assigned(pn) then exit;
  me := TModuleEntry(vstBookList.GetNodeData(pn)^);
  if not assigned(me) then exit;
  if me.modType = modtypeTag then begin
    vstBookList.Expanded[pn] := not vstBookList.Expanded[pn];
    if vstBookList.Expanded[pn] then begin
      cn := vstBookList.GetFirstChild(pn);
      if assigned(cn) then vstBookList.FocusedNode := cn
    end
    else vstBookList.FocusedNode := nil;
    exit;
  end;

  i := LinkFromPoint(pt, me, lt);
  if i < 0 then exit;
  if lt = lltBook then begin
    SelAction(me.wsFullName, me.mMatchInfo[i].ix);

  end
  else begin
  StrToTokens(me.modCats, '|', mStrTokens);
  edFilter.Text := mStrTokens[i];
  end;
//node:=vstBookList.GetNodeAt(pt.x,pt.y, true, nVOrg);
//if node=nil then exit;
//try
//me:=TModuleEntry((vstBookList.GetNodeData(node))^);
//if not assigned(me) then exit;
//c:=me.mCatsCnt-1;
//if c<0 then exit;
//pt.Y:=pt.Y - nVOrg;
//
//for I := 0 to c do begin
//  if PtInRect(me.mRects^[i],pt) then begin
//     StrToTokens(me.modCats, '|', mStrTokens);
//     edFilter.Text:='.'+ mStrTokens[i];
//  end;
//
//end;//fr
//

end;

procedure TfrmQNav.vstBookListCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  mod1, mod2: TModuleEntry;
  tr: integer;
const
  synodalny: string = 'Синод';
  russky: string = 'Русск';
label
  done;
begin
  mod1 := TModuleEntry(Sender.getNodeData(node1)^);
  mod2 := TModuleEntry(Sender.getNodeData(node2)^);

  if not (Assigned(mod1) and Assigned(mod2)) then begin
    result := 0;
  end;

  tr := ord(mod1.modType) - ord(mod2.modType);
  if tr = 0 then
    if mod1.modType = modtypeTag then begin
      if mod1.wsFullName = G_OtherCats then begin result := 1; exit; end;
      if mod2.wsFullName = G_OtherCats then begin result := -1; exit; end;
    end;
  tr := OmegaCompareTxt(mod1.wsFullName, mod2.wsFullName);
      // AnsiCompareText(mod1.name, mod2.name);
  done:
  result := tr;

end;

procedure TfrmQNav.vstBookListGetHintSize(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
var
  me: TModuleEntry;
begin
  if node = nil then exit;
//if column<0 then exit;
  me := TModuleEntry((Sender.GetNodeData(Node))^);
  if (not Assigned(me)) or (me.modType = modtypeTag) then exit;
  vstBookList.Canvas.Font.Assign(self.Font);
  vstBookList.Canvas.Font.Height := self.Font.Height * 4 div 5;

  r.Right := 640;
  r.Bottom := 480;
  DrawTextW(vstBookList.Canvas.Handle, PWideChar(Pointer(me.wsShortPath)),
    length(me.wsShortPath), r, DT_CALCRECT, true);
  InflateRect(r, 6, 6);
end;

procedure TfrmQNav.vstBookListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  pNodeData: TModuleEntry;
begin
  if node = nil then exit;
  pNodeData := TModuleEntry((Sender.GetNodeData(Node))^);
  if integer(pNodeData) > 65536 then try
    CellText := pNodeData.wsFullName;
  except end;
end;

procedure TfrmQNav.vstBookListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);

begin
  try
    if Key = VK_ESCAPE then FocusControl(edFilter)
  except end;
end;

procedure TfrmQNav.vstBookListMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
var
  me: TModuleEntry;
  rct: TRect;
  h, dlt, vmarg, rght: integer;
  ws: WideString;
begin
  if (node = nil) or (csDestroying in Self.ComponentState) then exit;

  try
    TargetCanvas.Font := mfntReg;
    dlt := mfntReg.Height;
    if dlt < 0 then dlt := -dlt;
    dlt := dlt div 4;
    if dlt = 0 then dlt := 2;

    me := TModuleEntry((Sender.GetNodeData(Node))^);
    ws := me.wsFullName;

    rct.Left := 0; rct.Top := 0; rct.Bottom := 200;

    rght := vstBookList.Width - GetSystemMetrics(SM_CXVSCROLL) -
      vstBookList.TextMargin * 2 - 6;
    rct.Right := rght;
    h := Windows.DrawTextW(TargetCanvas.Handle,
      PWideChar(Pointer(ws)), -1, rct, DT_CALCRECT or DT_WORDBREAK);
    NodeHeight := h;
    rct.Top := h;
    vmarg := dlt + dlt;
    rct.Right := rght;
    if me.modType = modtypeBookHighlighted then begin
      Inc(rct.Top, dlt);
      dlt := TargetCanvas.Font.Height * 4 div 5;
      TargetCanvas.Font := mfntBook;
    end;
    Inc(rct.Left, 4);
    if ((me.modType = modtypeBookHighlighted) or (bqisExpanded in me.mStyle )) and (length(me.mMatchInfo) > 0) then
      begin
      rct.Left := vstBookList.TextMargin;
      rct.Right := vstBookList.Width - GetSystemMetrics(SM_CXVSCROLL) -
        vstBookList.TextMargin - 2;
      dlt := mfntTag.Height;
      TargetCanvas.Font := mfntBook;
      if dlt < 0 then dlt := -dlt;
      rct.Top := rct.Top + (dlt div 4);
      rct.Bottom := rct.Top + 300;
      rct.Top := PaintBookTokens(TargetCanvas, rct, me.mMatchInfo, true);
    end;

    if (length(me.modCats) <= 0) then begin
      if me.modType = modtypeTag then inc(vmarg, 5);
      Inc(NodeHeight, vmarg); exit; end;

    mStrTokens.Clear();
    StrToTokens(me.modCats, '|', mStrTokens);
    ws := TokensToStr(mStrTokens, ' ', false);

    if not assigned(me.mRects) then begin
      GetMem(me.mRects, mStrTokens.Count * sizeof(TRect));
      me.mCatsCnt := mStrTokens.Count;
    end;

    rct.Right := vstBookList.Width - GetSystemMetrics(SM_CXVSCROLL) -
      vstBookList.TextMargin - 2;
    dlt := mfntTag.Height;

    TargetCanvas.Font := mfntTag;

    if dlt < 0 then dlt := -dlt;
    rct.Top := rct.Top + (dlt div 4);
    rct.Bottom := rct.Top + 300;
    NodeHeight := PaintTokens(TargetCanvas, rct, mStrTokens, true, me.mRects) +
      (vmarg);
//h:=Windows.DrawTextW(TargetCanvas.Handle,
// PWideChar(Pointer(ws)), -1,rct,DT_CALCRECT or DT_WORDBREAK);

    ///
  except {on e:Exception do BqShowException(e);}
  end;

end;

procedure TfrmQNav.vstBookListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  me: TModuleEntry;
  pt: TPoint;
  i: integer;
var
  pn: PVirtualNode;

begin
  pn := vstBookList.GetNodeAt(x, y);
  if not assigned(pn) then exit;
  me := TModuleEntry(vstBookList.GetNodeData(pn)^);
  if not assigned(me) then exit;
  if me.modType = modtypeTag then begin
    mAllowExp := not vstBookList.Expanded[pn];
  end;

end;

procedure TfrmQNav.vstBookListMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i: integer;
  me: TModuleEntry;
  pt: TPoint;
  pn: PVirtualNode;
  lt: TLibLinkType;
begin
//
  pn := vstBookList.GetNodeAt(x, y);
  if not assigned(pn) then exit;
  me := TModuleEntry(vstBookList.GetNodeData(pn)^);
  if not assigned(me) then exit;
  if me.modType = modtypeTag then begin
    vstBookList.Cursor := crHandPoint;
    exit;
  end;

  pt.X := x; pt.y := Y;
  i := LinkFromPoint(pt, me, lt);
  if i < 0 then begin vstBookList.Cursor := crDefault;
  end
  else begin vstBookList.Cursor := crHandPoint;
  end;
end;

procedure TfrmQNav.vstBookListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var pvn:PVirtualNode;
    me:TModuleEntry;
    i:integer;
    wbk:WideString;
    bk:AnsiString;
begin
if Button<>mbRight then  Exit;
pvn:= vstBookList.GetNodeAt(x,y);
if not Assigned(pvn) then Exit;
me:=TObject(vstBookList.GetNodeData(pvn)^) as TModuleEntry;
if (me.modType in [modtypeBook,modtypeBookHighlighted] ) then begin
if not (bqisExpanded in me.mStyle) then begin
Include(me.mStyle, bqisExpanded);
SetLength(me.mMatchInfo,255);
i:=0;
repeat
bk:=StrGetTokenByIx(me.modBookNames,i+1);
if length(bk)<=0 then break;
me.mMatchInfo[i].ix:=i+1; me.mMatchInfo[i].name:=C_BulletChar+#32+UTF8Decode(bk);
inc(i)
until i>=255;
SetLength(me.mMatchInfo, i);

end

else begin
Exclude(me.mStyle, bqisExpanded);
SetLength(me.mMatchInfo, 0);
if me.modType=modtypeBookHighlighted then begin
me.Match(mFilterStrTokens, me.mMatchInfo,mAllMatch);
end;
end;
vstBookList.ReinitNode(pvn, false);
end
end;

procedure TfrmQNav.vstBookListDblClick(Sender: TObject);
var
  pt: TPoint;
  pn: PVirtualNode;
  me: TModuleEntry;
begin
//pt:=vstBookList.ScreenToClient(Mouse.CursorPos);

  SelAction();
end;

procedure TfrmQNav.vstBookListDrawHint(Sender: TBaseVirtualTree;
  HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
var
  me: TModuleEntry;
begin
  if node = nil then exit;
  me := TModuleEntry((Sender.GetNodeData(Node))^);
  if not Assigned(me) then exit;
  HintCanvas.Font.Assign(self.Font);
  HintCanvas.Font.Height := HintCanvas.Font.Height * 4 div 5;
  HintCanvas.Brush.Color := clWindow;
  HintCanvas.RoundRect(r.Left, r.Top, r.Right, r.Bottom, 2, 2);
  InflateRect(r, -6, -6);
  Windows.DrawTextW(HintCanvas.Handle, PWideChar(Pointer(me.wsShortPath)),
    length(me.wsShortPath), r, 0);
end;

procedure TfrmQNav.vstBookListDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);

var
  me: TModuleEntry;
  rct: TRect;
  h, dlt, flgs: integer;
  ws: WideString;
  cl1, cl2: TColor;
begin

  if PaintInfo.Node = nil then exit;
  me := TModuleEntry((Sender.GetNodeData(PaintInfo.Node))^);
  rct := PaintInfo.ContentRect;
  PaintInfo.Canvas.Font := mfntReg;
  dlt := mfntReg.Height;
  if dlt < 0 then dlt := -dlt;

  dlt := dlt div 4;
  if dlt = 0 then dlt := 1;
  if me.modType = modtypeTag then begin
    flgs := DT_WORDBREAK or DT_VCENTER;
    InflateRect(rct, -2, -2);
    if Sender.FocusedNode = PaintInfo.Node then
      cl1 := vstBookList.Colors.FocusedSelectionColor
    else begin
      if me.wsFullName = G_NoCategoryStr then cl1 := $00D1D9ED
      else cl1 := $acd5ff;

    end;
    PaintInfo.Canvas.Pen.Color:=$90c0e0;
    PaintInfo.Canvas.Brush.Color := cl1;
    PaintInfo.Canvas.RoundRect(rct.Left, rct.Top, rct.Right, rct.Bottom, 4,
      10);
    Inc(rct.Left, 12);
    Dec(rct.Right, 2);
  end else flgs := DT_WORDBREAK;

  ws := me.wsFullName;

  Inc(rct.Top, dlt);
  PaintInfo.Canvas.Font := mfntTagCap;
  if (not (me.modType = modtypeTag)) and (vsSelected in PaintInfo.Node^.States)
    then begin
    if vstBookList.Focused then
      PaintInfo.Canvas.Brush.Color := vstBookList.Colors.FocusedSelectionColor;
  end;
  h := Windows.DrawTextW(PaintInfo.Canvas.Handle,
    PWideChar(Pointer(ws)), -1, rct, flgs);

  rct.Top := h;

//   if me.modType=modtypeBookHighlighted then begin
//     Inc(rct.Top,dlt);
//     dlt := PaintInfo.Canvas.Font.Height;
//     PaintInfo.Canvas.Font:=mfntBook;
//     //h := Windows.DrawTextW(PaintInfo.Canvas.Handle,
////      PWideChar(me.mMatchInfo[0].name ), -1, rct,  DT_WORDBREAK);
//     Inc(rct.Top,h);
//    end;
  if ((me.modType = modtypeBookHighlighted) or (bqisExpanded in me.mStyle)) and (length(me.mMatchInfo) > 0) then
    begin
    PaintInfo.Canvas.Font := mfntBook;
    PaintBookTokens(PaintInfo.Canvas, rct, me.mMatchInfo, false);
  end;

  if (length(me.modCats) <= 0) then exit;
//Inc(rct.Top,h+dlt);
  mStrTokens.Clear();
  StrToTokens(me.modCats, '|', mStrTokens);

  ws := TokensToStr(mStrTokens, ' ', false);
  PaintInfo.Canvas.Font := mfntTag;
  PaintTokens(PaintInfo.Canvas, rct, mStrTokens, false, me.mRects);
//h:=Windows.DrawTextW(PaintInfo.Canvas.Handle,
// PWideChar(Pointer(ws)), -1,rct,DT_WORDBREAK);

end;

procedure TfrmQNav.vstBookListFocusChanging(Sender: TBaseVirtualTree; OldNode,
  NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
var
  me: TModuleEntry;
  n: PVirtualNode;
begin
  if NewNode = nil then exit;
  me := TModuleEntry((Sender.GetNodeData(NewNode))^);
  if not assigned(me) then exit;
  if me.modType <> modtypeTag then exit;
  Allowed := false;
  n := sender.GetFirstChild(NewNode);
  if not assigned(n) then exit;
  sender.FocusedNode := n;
  sender.Selected[n] := true;
end;

procedure TfrmQNav.vstBookListFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  me: TModuleEntry;

begin
try
  me := TModuleEntry((Sender.GetNodeData(Node))^);
  PPointer(Sender.GetNodeData(Node))^ := nil;
//  if assigned(me) and (me.modType = modtypeBookHighlighted) then me.Free();
except on e:Exception do begin
// BqShowException(e);
end;
end;
end;

end.


