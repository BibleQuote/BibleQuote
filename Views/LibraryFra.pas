unit LibraryFra;

interface

uses
  Vcl.Tabs, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, VirtualTrees, Contnrs, StdCtrls, ExtCtrls,
  DockTabSet, Vcl.ComCtrls, Vcl.ToolWin, System.ImageList, MainFrm,
  Vcl.ImgList, TabData, Vcl.Menus, System.UITypes, BibleQuoteUtils, PlainUtils;

type
  TLibraryFrame = class(TFrame, ILibraryView)
    edtFilter: TEdit;
    cmbBookType: TComboBox;
    btnClear: TButton;
    vdtBooks: TVirtualDrawTree;
    procedure btnClearClick(Sender: TObject);
    procedure cmbBookTypeChange(Sender: TObject);
    procedure edtFilterChange(Sender: TObject);
    procedure vdtBooksDblClick(Sender: TObject);
    procedure vdtBooksDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure vdtBooksFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vdtBooksMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure FrameResize(Sender: TObject);
    procedure vdtBooksCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
  private
    mUILock: Boolean;
    mModules: TCachedModules;

    mMainView: TMainForm;
    mTabsView: ITabsView;

    procedure UpdateBookList();
    procedure OnModulesAssign(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; mainView: TMainForm; tabsView: ITabsView); reintroduce;
    procedure SetModules(modules: TCachedModules);
  end;

var
  G_OtherCats: string = 'Другие категории';

implementation

{$R *.dfm}

constructor TLibraryFrame.Create(AOwner: TComponent; mainView: TMainForm; tabsView: ITabsView);
begin
  inherited Create(AOwner);
  mModules := TCachedModules.Create();

  mMainView := mainView;
  mTabsView := tabsView;
end;

procedure TLibraryFrame.SetModules(modules: TCachedModules);
begin
  mModules := modules;
  mModules.OnAssignEvent := OnModulesAssign;
  UpdateBookList();
end;

procedure TLibraryFrame.OnModulesAssign(Sender: TObject);
begin
  UpdateBookList();
end;

procedure TLibraryFrame.btnClearClick(Sender: TObject);
begin
  edtFilter.Clear;
end;

procedure TLibraryFrame.cmbBookTypeChange(Sender: TObject);
begin
  UpdateBookList();
end;

procedure TLibraryFrame.edtFilterChange(Sender: TObject);
begin
  UpdateBookList();
end;

procedure TLibraryFrame.FrameResize(Sender: TObject);
begin
  vdtBooks.ReinitChildren(nil, true);
end;

procedure TLibraryFrame.UpdateBookList;
var
  filterText: string;
  allMatch: Boolean;
  i, count: integer;
  modEntry: TModuleEntry;
  filterTokens: TStringList;
  matchType: TModMatchTypes;
begin
  if mUILock then
    Exit;

  mUILock := true;

  try
    filterText := Trim(edtFilter.Text);
    vdtBooks.Clear();
    vdtBooks.BeginUpdate();

    if length(filterText) > 0 then
    begin
      allMatch := filterText[1] <> '.';
      if not allMatch then
        filterText := Copy(filterText, 2, $FFF);
    end;

    filterTokens := TStringList.Create();
    StrToTokens(filterText, ' ', filterTokens);

    count := mModules.Count - 1;
    for i := 0 to count do
    begin
      modEntry := TModuleEntry(mModules.Items[i]);
      if length(filterText) > 0 then
      begin
        matchType := modEntry.Match(filterTokens, modEntry.mMatchInfo, allMatch);
        if (matchType = []) or ((modEntry.modType in [modtypeBible, modtypeComment]) and (matchType = [mmtBookName])) then
          Continue;
      end;

      vdtBooks.InsertNode(nil, amAddChildLast, modEntry);
    end;
  finally
    mUILock := false;
    vdtBooks.EndUpdate;
  end;
end;

procedure TLibraryFrame.vdtBooksCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  mod1, mod2: TModuleEntry;
  tr: Integer;
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
      if mod1.mFullName = G_OtherCats then
      begin
        Result := 1;
        exit;
      end;
      if mod2.mFullName = G_OtherCats then
      begin
        Result := -1;
        exit;
      end;
    end;
  tr := OmegaCompareTxt(mod1.mFullName, mod2.mFullName);
done:
  Result := tr;
end;

procedure TLibraryFrame.vdtBooksDblClick(Sender: TObject);
var
  vdt: TVirtualDrawTree;
  nodeTop: integer;
  point: TPoint;
  pnode: PVirtualNode;
  modEntry: TModuleEntry;
begin
  if not(Sender is TVirtualDrawTree) then
  begin
    Exit;
  end;

  vdt := TVirtualDrawTree(Sender);
  point := vdt.ScreenToClient(Mouse.CursorPos);
  pnode := vdt.GetNodeAt(point.X, point.Y, true, nodeTop);

  if not Assigned(pnode) or (pnode = vdt.RootNode) then
  begin
    Exit;
  end;

  modEntry := TModuleEntry((vdt.GetNodeData(pnode))^);
  mMainView.GoModuleName(modEntry.mFullName, true);
end;

procedure TLibraryFrame.vdtBooksDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
var
  modEntry: TModuleEntry;
  name: string;
  //height: integer;
  rect: TRect;
begin
  if PaintInfo.Node = nil then
    Exit;

  modEntry := TModuleEntry((Sender.GetNodeData(PaintInfo.Node))^);
  if Assigned(modEntry) then
  begin
    name := modEntry.mFullName;
    rect := PaintInfo.ContentRect;
    Windows.DrawText(PaintInfo.Canvas.Handle, PChar(Pointer(name)), -1, rect, DT_WORDBREAK);
  end;
end;

procedure TLibraryFrame.vdtBooksFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  try
    PPointer(Sender.GetNodeData(Node))^ := nil;
  except
    // do nothing
  end;
end;

procedure TLibraryFrame.vdtBooksMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
  NodeHeight := 30;
end;

end.
