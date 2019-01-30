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

    FFontBookName, FFontCopyright, FFontModuleVersion, FFontModType: TFont;

    FCoverDefault: TPicture;

    FOnSelectModuleEvent: TSelectModuleEvent;

    procedure DrawTextNode(const PaintInfo: TVTPaintInfo; aRect: TRect;
                           var aTop: Integer; aFont: TFont; aText: String);
    procedure UpdateBookList();
    procedure OnModulesAssign(Sender: TObject);
    procedure UpdateModuleTypes();

    procedure InitFonts();
    function CreateFont(aSize: Integer = 10; aColor: Integer = clBlack;
                        aStyle: TFontStyles = []; aName: String = ''): TFont;
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
  TEXT_OFFSET:  integer = 10;

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

function TLibraryFrame.CreateFont(aSize: Integer; aColor: Integer;
  aStyle: TFontStyles; aName: String): TFont;
var
  Font: TFont;
begin
  Font := TFont.Create();
  Result := Font;

  with Font do
  begin
    if not aName.IsEmpty then
    begin
      Name := aName;
    end;

    Color := aColor;
    Style := aStyle;
    Size := aSize;
  end;

end;

destructor TLibraryFrame.Destroy();
begin
  if Assigned(FCoverDefault) then
    FCoverDefault.Free;
    
  inherited;  
end;

procedure TLibraryFrame.DrawTextNode(const PaintInfo: TVTPaintInfo; aRect: TRect;
  var aTop: Integer; aFont: TFont; aText: String);
var
  DrawRect: TRect;
  Height: Integer;
begin
    DrawRect := TRect.Create(aRect);
    DrawRect.Top := aTop;
    PaintInfo.Canvas.Font := aFont;
    Height := Windows.DrawText(PaintInfo.Canvas.Handle, PChar(Pointer(aText)), -1, DrawRect, DT_WORDBREAK);
    aTop := aTop + Height + TEXT_OFFSET;

end;

procedure TLibraryFrame.InitCoverDefault();
var origCoverImage: TPicture;
begin
  origCoverImage := nil;
  try
    origCoverImage := LoadImage('CoverDefault');  
    FCoverDefault := StretchImage(origCoverImage, GetCoverWidth, GetCoverHeight);
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
  FFontBookName := CreateFont(10, clBlack, [fsBold], 'Segoe UI');
  FFontCopyright := CreateFont(9);
  FFontModuleVersion := CreateFont(9);
  FFontModType := CreateFont(9, clGray);
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
        if (matchType = []) or ((modEntry.ModType in [modtypeBible, modtypeComment]) and (matchType = [mmtBookName])) then
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

  Result := OmegaCompareTxt(mod1.FullName, mod2.FullName);
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
  ModEntry: TModuleEntry;
  Top: integer;
  Rect: TRect;
  PicTop: integer;
  CoverPicture: TPicture;
begin
  if PaintInfo.Node = nil then
    Exit;

  modEntry := Sender.GetNodeData<TModuleEntry>(PaintInfo.Node);
  if Assigned(modEntry) then
  begin
    Rect := TRect.Create(PaintInfo.CellRect);
    InflateRect(Rect, -COVER_OFFSET, -COVER_OFFSET);

    if (Rect.Height > GetCoverHeight) then
      PicTop := Rect.Top + (Rect.Height - GetCoverHeight) div 2
    else
      PicTop := Rect.Top;

    CoverPicture := ModEntry.GetCoverImage(GetCoverWidth, GetCoverHeight);
    if Assigned(coverPicture) then
      PaintInfo.Canvas.Draw(Rect.Left, PicTop, CoverPicture.Graphic)
    else
      PaintInfo.Canvas.Draw(Rect.Left, PicTop, FCoverDefault.Graphic);

    Rect.Left := GetCoverWidth + 2 * COVER_OFFSET;

    Top := Rect.Top;
    DrawTextNode(PaintInfo, Rect, Top, FFontBookName, ModEntry.FullName);
    DrawTextNode(PaintInfo, Rect, Top, FFontCopyright, ModEntry.Author);
    DrawTextNode(PaintInfo, Rect, Top, FFontModuleVersion, ModEntry.ModuleVersion);
    DrawTextNode(PaintInfo, Rect, Top, FFontModType, GetModuleTypeText(ModEntry.ModType));

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

    TargetCanvas.Font := FFontBookName;
    rect := TRect.Create(measureRect);
    height := Windows.DrawText(TargetCanvas.Handle, PChar(Pointer(modEntry.FullName)), -1, rect, DT_WORDBREAK or DT_CALCRECT);
    textHeight := textHeight + height + TEXT_OFFSET;

    TargetCanvas.Font := FFontCopyright;
    rect := TRect.Create(measureRect);
    height := Windows.DrawText(TargetCanvas.Handle, PChar(Pointer(modEntry.ShortName)), -1, rect, DT_WORDBREAK or DT_CALCRECT);
    textHeight := textHeight + height + TEXT_OFFSET;

    TargetCanvas.Font := FFontModType;
    rect := TRect.Create(measureRect);
    height := Windows.DrawText(TargetCanvas.Handle, PChar(Pointer(modEntry.ModCats)), -1, rect, DT_WORDBREAK or DT_CALCRECT);
    textHeight := textHeight + height;

    NodeHeight := Max(coverHeight, textHeight);
  end;
end;

end.
