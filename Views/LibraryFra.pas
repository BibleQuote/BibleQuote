unit LibraryFra;

interface

uses
  Vcl.Tabs, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, VirtualTrees, Contnrs, StdCtrls, ExtCtrls, Math,
  Vcl.DockTabSet, Vcl.ComCtrls, Vcl.ToolWin, System.ImageList, MainFrm,
  Vcl.ImgList, TabData, Vcl.Menus, System.UITypes, BibleQuoteUtils, PlainUtils,
  ImageUtils, AppIni;

type
  TBooksType = (
    btAllBooks,
    btBibles,
    btCommentaries,
    btOtherBooks,
    btAllDictionaries);

  TSelectModuleEvent = procedure(Sender: TObject; modEntry: TModuleEntry) of object;

  TLibraryFrame = class(TFrame, ILibraryView)
    edtFilter: TEdit;
    cmbBookType: TComboBox;
    btnClear: TButton;
    vdtBooks: TVirtualDrawTree;

    procedure btnClearClick(Sender: TObject);
    procedure cmbBookTypeChange(Sender: TObject);
    procedure edtFilterChange(Sender: TObject);
    procedure vdtBooksDblClick(Sender: TObject);
    procedure vdtBooksDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
    procedure vdtBooksFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vdtBooksMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure FrameResize(Sender: TObject);
    procedure vdtBooksCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
  private
    mUILock: Boolean;
    mModules: TCachedModules;

    mFontBookName, mFontCopyright, mFontModType: TFont;

    mCoverDefault: TPicture;

    FOnSelectModuleEvent: TSelectModuleEvent;

    procedure UpdateBookList();
    procedure OnModulesAssign(Sender: TObject);
    procedure UpdateModuleTypes();

    procedure InitFonts();
    procedure InitCoverDefault();
    function GetModuleTypeText(modType: TModuleType): string;
    function GetCoverWidth(): integer;
    function GetCoverHeight(): integer;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    procedure SetModules(modules: TCachedModules);

    procedure Translate();
    procedure ApplyConfig(appConfig: TAppConfig);
    destructor Destroy; override;

    property OnSelectModule: TSelectModuleEvent read FOnSelectModuleEvent write FOnSelectModuleEvent;
  end;

var
  G_OtherCats: string = 'Другие категории';

  COVER_WIDTH:  integer = 60;
  COVER_HEIGHT: integer = 90;
  COVER_OFFSET: integer = 10;
  TEXT_OFFSET:  integer = 12;

implementation

{$R *.dfm}

constructor TLibraryFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  mModules := TCachedModules.Create();

  InitFonts();
  Translate();
  InitCoverDefault();  
end;

destructor TLibraryFrame.Destroy();
begin
  if Assigned(mCoverDefault) then
    mCoverDefault.Free;
    
  inherited;  
end;

procedure TLibraryFrame.InitCoverDefault();
var origCoverImage: TPicture;
begin
  origCoverImage := nil;
  try
    origCoverImage := LoadImage('CoverDefault');  
    mCoverDefault := StretchImage(origCoverImage, GetCoverWidth, GetCoverHeight);
  finally
    if Assigned(origCoverImage) then
      origCoverImage.Free;
  end;
end;

procedure TLibraryFrame.ApplyConfig(appConfig: TAppConfig);
begin
  if (appConfig.MainFormFontName <> Font.Name) then
    Font.Name := appConfig.MainFormFontName;

  if (appConfig.MainFormFontSize <> Font.Size) then
    Font.Size := appConfig.MainFormFontSize;
end;

function TLibraryFrame.GetCoverWidth(): integer;
begin
  Result := Round(COVER_WIDTH * Screen.PixelsPerInch / 96.0);
end;

function TLibraryFrame.GetCoverHeight(): integer;
begin
  Result := Round(COVER_HEIGHT * Screen.PixelsPerInch / 96.0);
end;

procedure TLibraryFrame.InitFonts;
begin
  mFontBookName := TFont.Create();
  mFontBookName.Name := 'Segoe UI';
  mFontBookName.Color := clBlack;
  mFontBookName.Style := [fsBold];
  mFontBookName.Size := 10;

  mFontCopyright := TFont.Create();
  mFontCopyright.Color := clBlack;
  mFontCopyright.Style := [];
  mFontCopyright.Size := 9;

  mFontModType := TFont.Create();
  mFontModType.Color := clGray;
  mFontModType.Style := [];
  mFontModType.Size := 9;
end;

procedure TLibraryFrame.UpdateModuleTypes;
var index: integer;
begin
  index := cmbBookType.ItemIndex;
  cmbBookType.Clear;

  cmbBookType.AddItem(Lang.Say('StrAllBooks'), TObject(btAllBooks));
  cmbBookType.AddItem(Lang.Say('StrBibleTranslations'), TObject(btBibles));
  cmbBookType.AddItem(Lang.Say('StrBooks'), TObject(btOtherBooks));
  cmbBookType.AddItem(Lang.Say('StrCommentaries'), TObject(btCommentaries));
  cmbBookType.AddItem(Lang.Say('StrAllDictionaries'), TObject(btAllDictionaries));

  cmbBookType.ItemIndex := Max(index, 0);
end;

procedure TLibraryFrame.Translate();
begin
  Lang.TranslateControl(self, 'DockTabsForm');

  UpdateModuleTypes();
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
  booksType: TBooksType;
  modType: TModuleType;
  addBook: boolean;
begin
  if mUILock then
    Exit;

  mUILock := true;

  try
    filterText := Trim(edtFilter.Text);
    vdtBooks.Clear();
    vdtBooks.BeginUpdate();

    allMatch := false;
    if length(filterText) > 0 then
    begin
      allMatch := filterText[1] <> '.';
      if not allMatch then
        filterText := Copy(filterText, 2, $FFF);
    end;

    filterTokens := TStringList.Create();
    StrToTokens(filterText, ' ', filterTokens);

    booksType := TBooksType(cmbBookType.Items.Objects[cmbBookType.ItemIndex]);

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

      addBook := true;
      if (booksType <> btAllBooks) then
      begin
        modType := modtypeBible;
        case booksType of
          btBibles: modType := modtypeBible;
          btCommentaries: modType := modtypeComment;
          btOtherBooks: modType := modtypeBook;
          btAllDictionaries: modType := modtypeDictionary;
        end;

        // add only books of selected type
        if (modEntry.modType <> modType) then
          addBook := false;
      end;

      if (addBook) then
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
begin
  mod1 := Sender.GetNodeData<TModuleEntry>(Node1);
  mod2 := Sender.GetNodeData<TModuleEntry>(Node2);

  if not(assigned(mod1) and assigned(mod2)) then
  begin
    Result := 0;
    Exit;
  end;

  Result := OmegaCompareTxt(mod1.mFullName, mod2.mFullName);
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

  modEntry := vdt.GetNodeData<TModuleEntry>(pnode);
  if Assigned(FOnSelectModuleEvent) then
    FOnSelectModuleEvent(self, modEntry);
end;

procedure TLibraryFrame.vdtBooksDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
var
  modEntry: TModuleEntry;
  height, top: integer;
  rect, drawRect: TRect;
  picTop: integer;
  coverPicture: TPicture;
begin
  if PaintInfo.Node = nil then
    Exit;

  modEntry := Sender.GetNodeData<TModuleEntry>(PaintInfo.Node);
  if Assigned(modEntry) then
  begin
    rect := TRect.Create(PaintInfo.CellRect);
    InflateRect(rect, -COVER_OFFSET, -COVER_OFFSET);

    if (rect.Height > GetCoverHeight) then
      picTop := rect.Top + (rect.Height - GetCoverHeight) div 2
    else
      picTop := rect.Top;

    coverPicture := modEntry.GetCoverImage(GetCoverWidth, GetCoverHeight);
    if Assigned(coverPicture) then
      PaintInfo.Canvas.Draw(rect.Left, picTop, coverPicture.Graphic)
    else
      PaintInfo.Canvas.Draw(rect.Left, picTop, mCoverDefault.Graphic);
    
    rect.Left := GetCoverWidth + 2 * COVER_OFFSET;

    drawRect := TRect.Create(rect);
    PaintInfo.Canvas.Font := mFontBookName;
    height := Windows.DrawText(PaintInfo.Canvas.Handle, PChar(Pointer(modEntry.mFullName)), -1, drawRect, DT_WORDBREAK);
    top := rect.Top + height + TEXT_OFFSET;

    drawRect := TRect.Create(rect);
    drawRect.Top := top;
    PaintInfo.Canvas.Font := mFontCopyright;
    height := Windows.DrawText(PaintInfo.Canvas.Handle, PChar(Pointer(modEntry.mAuthor)), -1, drawRect, DT_WORDBREAK);
    top := top + height + TEXT_OFFSET;

    drawRect := TRect.Create(rect);
    drawRect.Top := top;
    PaintInfo.Canvas.Font := mFontModType;
    Windows.DrawText(PaintInfo.Canvas.Handle, PChar(Pointer(GetModuleTypeText(modEntry.modType))), -1, drawRect, DT_WORDBREAK);
  end;
end;

function TLibraryFrame.GetModuleTypeText(modType: TModuleType): string;
var text: string;
begin
  case modType of
    modtypeBook: text := Lang.Say('StrBooks');
    modtypeComment: text := Lang.Say('StrCommentaries');
    modtypeDictionary: text := Lang.Say('StrAllDictionaries');
  else
    text := Lang.Say('StrBibleTranslations');
  end;
  Result := text;
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
var
  modEntry: TModuleEntry;
  coverHeight, textHeight, height: integer;
  rect, measureRect: TRect;
  right: integer;
begin
  if (Node = nil) or (csDestroying in self.ComponentState) then
    Exit;

  coverHeight := GetCoverHeight + 2 * COVER_OFFSET;
  NodeHeight := 0;

  modEntry := vdtBooks.GetNodeData<TModuleEntry>(Node);
  if Assigned(modEntry) then
  begin
    right := vdtBooks.ClientWidth - COVER_OFFSET;
    measureRect := TRect.Create(COVER_OFFSET + GetCoverWidth + 12, 0, right, 0);

    textHeight := 2 * COVER_OFFSET;

    TargetCanvas.Font := mFontBookName;
    rect := TRect.Create(measureRect);
    height := Windows.DrawText(TargetCanvas.Handle, PChar(Pointer(modEntry.mFullName)), -1, rect, DT_WORDBREAK or DT_CALCRECT);
    textHeight := textHeight + height + TEXT_OFFSET;

    TargetCanvas.Font := mFontCopyright;
    rect := TRect.Create(measureRect);
    height := Windows.DrawText(TargetCanvas.Handle, PChar(Pointer(modEntry.mShortName)), -1, rect, DT_WORDBREAK or DT_CALCRECT);
    textHeight := textHeight + height + TEXT_OFFSET;

    TargetCanvas.Font := mFontModType;
    rect := TRect.Create(measureRect);
    height := Windows.DrawText(TargetCanvas.Handle, PChar(Pointer(modEntry.modCats)), -1, rect, DT_WORDBREAK or DT_CALCRECT);
    textHeight := textHeight + height;

    NodeHeight := Max(coverHeight, textHeight);
  end;
end;

end.
