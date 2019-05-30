unit LibraryFra;

interface

uses
  Vcl.Tabs, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, VirtualTrees, Contnrs, StdCtrls, ExtCtrls, Math,
  Vcl.DockTabSet, Vcl.ComCtrls, Vcl.ToolWin, System.ImageList, MainFrm,
  Vcl.ImgList, TabData, Vcl.Menus, System.UITypes, BibleQuoteUtils, PlainUtils,
  ImageUtils, AppIni, Generics.Collections, Vcl.VirtualImageList,
  Vcl.BaseImageCollection, Vcl.ImageCollection, NotifyMessages, JclNotify,
  UITools;

const

  UNDEFAINED_IMAGEINDEX = -2;
  NATIVE_COVER_DEFAULT_IMAGE = 'NATIVE_COVER_DEFAULT_IMAGE';
  MYBIBLE_COVER_DEFAULT_IMAGE = 'MYBIBLE_COVER_DEFAULT_IMAGE';
  SMALL_COVER_COEF = 3;
  MIN_AUTHOR_COLUMN_WIDTH = 141;
  MIN_VERSION_COLUMN_WIDTH = 80;


type
  TBooksType = (
    btAllBooks,
    btBibles,
    btCommentaries,
    btOtherBooks,
    btAllDictionaries);

  TSelectModuleEvent = procedure(Sender: TObject; modEntry: TModuleEntry) of object;

  TLibraryFrame = class(TFrame, ILibraryView, IJclListener)
    edtFilter: TEdit;
    cmbBookType: TComboBox;
    btnClear: TButton;
    pmViewStyle: TPopupMenu;
    miTileViewStyle: TMenuItem;
    miDetailsViewStyle: TMenuItem;
    imgViewStyle: TImageList;
    btnViewStyle: TButton;
    pcViews: TPageControl;
    tsCoverDetailView: TTabSheet;
    tsListView: TTabSheet;
    vdtBooks: TVirtualDrawTree;
    miCoverViewStyle: TMenuItem;
    lvBooks: TListView;
    imgCoverCollection: TImageCollection;
    vimgCover: TVirtualImageList;
    lblModuleCount: TLabel;
    miListViewStyle: TMenuItem;

    procedure btnClearClick(Sender: TObject);
    procedure cmbBookTypeChange(Sender: TObject);
    procedure edtFilterChange(Sender: TObject);
    procedure vdtBooksDblClick(Sender: TObject);
    procedure vdtBooksDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
    procedure vdtBooksFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vdtBooksMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure FrameResize(Sender: TObject);
    procedure vdtBooksCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure lvBooksDataHint(Sender: TObject; StartIndex, EndIndex: Integer);
    procedure lvBooksData(Sender: TObject; Item: TListItem);
    procedure lvBooksDblClick(Sender: TObject);
    procedure miSomeViewStyleClick(Sender: TObject);
    procedure lvBooksResize(Sender: TObject);
    procedure edtFilterEnter(Sender: TObject);
    procedure lvBooksInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
  private
    mUILock: Boolean;
    mMainView: TMainForm;
    mWorkspace: IWorkspace;

    FFilteredModTypes: TList<TPair<TModuleEntry, Integer>>;

    FFontBookName, FFontCopyright, FFontModuleVersion, FFontModType: TFont;

    FCoverDefaults: TDictionary<String, TPicture>;

    FOnSelectModuleEvent: TSelectModuleEvent;

    procedure DrawTextNode(const PaintInfo: TVTPaintInfo; aRect: TRect;
                           var aTop: Integer; aFont: TFont; aText: String);
    procedure OnModulesAssign(Sender: TObject);
    procedure UpdateModuleTypes();
    procedure UpdateCoverDetailView();

    function AddDefaultCoverImage(aResource: String): Integer;
    function AddCoverImage(aName: String; aPicture: TPicture): Integer; overload;
    function AddImageToCoverCollection(aName: String; aImage: TWICImage): Integer;
    function GetWICImage(aPicture: TPicture): TWICImage;
    procedure SetCoverImageSize(aWidth, aHeight: Integer);
    procedure SetModuleCountLable();
    function IsSuitableCategory(aModType: TModuleType): Boolean;
    function GetDefaultCoverKey(aModEntry: TModuleEntry): String;
    procedure TileView(aListView: TListView);
    procedure TileViewInfo(aListView: TListView; aIndex: Integer);
    procedure FillTileViewItems();
    procedure FillListViewItems();
    procedure LoadBookThumbnails(aStartIndex: Integer; aEndIndex: Integer);
    procedure AdjustDetailsViewColumnsWidth();
    function GetToolTipForIcon(Item: TListItem): String;
    function AddAtNewLine(aDestination, aValue: String; aTitle: String = ''): String;
    procedure PrepareListForBigImages();
    procedure PrepareListForSmallImages();
    procedure TurnOnVirtualDataForList();
    procedure TurnOffVirtualDataForList();

    procedure InitFonts();
    function CreateFont(aSize: Integer = 10; aColor: Integer = clBlack;
                        aStyle: TFontStyles = []; aName: String = ''): TFont;
    procedure InitCoverDefault();
    function LoadDefaultCoverImage(aResource:String): TPicture;
    function GetModuleTypeText(modType: TModuleType): string;
    function GetCoverWidth(): Integer;
    function GetSmallCoverWidth(): Integer;
    function GetCoverHeight(): Integer;
    function GetSmallCoverHeight(): Integer;
    procedure HidePageControlTabs(aPageControl: TPageControl);
    procedure ListViewSetMinWidthColunms();
    procedure Notification(Msg: IJclNotificationMessage); stdcall;
    procedure SelectNodeByIndex(Index: Integer);
  public
    constructor Create(AOwner: TComponent; mainView: TMainForm; workspace: IWorkspace); reintroduce;

    procedure UpdateBookList();
    procedure UpdateBookViews();
    procedure Translate();
    procedure ApplyConfig(appConfig: TAppConfig);
    procedure EventFrameKeyDown(var Key: Char);
    procedure SelectViewMode(viewMode: TLibraryViewMode);
    function GetViewMode(): TLibraryViewMode;
    function GetSelectedIndex(): Integer;
    procedure SelectItem(Index: Integer);

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

uses SelectEntityType, CommCtrl;

constructor TLibraryFrame.Create(AOwner: TComponent; mainView: TMainForm; workspace: IWorkspace);
var
  viewMode: TLibraryViewMode;
begin
  inherited Create(AOwner);
  mMainView := mainView;
  mWorkspace := workspace;
  mMainView.GetNotifier.Add(self);

  FCoverDefaults := TDictionary<String, TPicture>.Create;

  InitFonts();
  Translate();
  InitCoverDefault();

  FFilteredModTypes := TList<TPair<TModuleEntry, Integer>>.Create;

  HidePageControlTabs(pcViews);

  ListViewSetMinWidthColunms();

  SelectViewMode(AppConfig.LastLibraryViewMode);
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
  if Assigned(FCoverDefaults) then
    FCoverDefaults.Free;

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
begin

  FCoverDefaults.Add(NATIVE_COVER_DEFAULT_IMAGE, LoadDefaultCoverImage(NATIVE_COVER_DEFAULT_IMAGE));
  FCoverDefaults.Add(MYBIBLE_COVER_DEFAULT_IMAGE, LoadDefaultCoverImage(MYBIBLE_COVER_DEFAULT_IMAGE));

end;

function TLibraryFrame.AddAtNewLine(aDestination, aValue: String; aTitle: String): String;
begin

  Result := aDestination;

  if not aValue.IsEmpty then
  begin
    if not aDestination.IsEmpty then aDestination := aDestination + sLineBreak;

    if not aTitle.IsEmpty then
      aDestination := aDestination + Format('%s: %s', [aTitle, aValue])
    else
      aDestination := aDestination + aValue;

    Result := aDestination;
  end;
  
end;

function TLibraryFrame.AddCoverImage(aName: String; aPicture: TPicture): Integer;
var
  ImageIndex: Integer;
  Image: TWICImage;
begin
  Result := vimgCover.GetIndexByName(aName);

  if Result > -1 then exit;

  Image := GetWICImage(aPicture);
  ImageIndex := AddImageToCoverCollection(aName, Image);

  vimgCover.Add(aName, ImageIndex);
  Result := vimgCover.GetIndexByName(aName);

end;


function TLibraryFrame.AddDefaultCoverImage(aResource: String): Integer;
begin
  Result := AddCoverImage(aResource, FCoverDefaults[aResource]);
end;

function TLibraryFrame.AddImageToCoverCollection(aName: String;
  aImage: TWICImage): Integer;
var
  ImageItem: TImageCollectionItem;
begin
  ImageItem := imgCoverCollection.Images.Add;
  ImageItem.Name := aName;
  ImageItem.SourceImages.Add.Image := aImage;

  Result := imgCoverCollection.GetIndexByName(aName);
end;

procedure TLibraryFrame.AdjustDetailsViewColumnsWidth();
var
  ListWidth: Integer;
  ColumnVersionWidth, ColumnAuthorWidth, ColumnDescriptionWidth: Integer;
begin

  ListWidth := lvBooks.ClientRect.Width;
  ColumnVersionWidth := MIN_VERSION_COLUMN_WIDTH;
  ColumnAuthorWidth := Max(MIN_AUTHOR_COLUMN_WIDTH, Trunc(ListWidth * 0.3));
  ColumnDescriptionWidth := ListWidth - ColumnVersionWidth - ColumnAuthorWidth;

  lvBooks.Columns.BeginUpdate;
  lvBooks.Columns[0].Width := ColumnDescriptionWidth;
  lvBooks.Columns[1].Width := ColumnAuthorWidth;
  lvBooks.Columns[2].Width := ColumnVersionWidth;
  lvBooks.Columns.EndUpdate;
end;

procedure TLibraryFrame.ApplyConfig(appConfig: TAppConfig);
begin
  if (appConfig.MainFormFontName <> Font.Name) then
    Font.Name := appConfig.MainFormFontName;

  if (appConfig.MainFormFontSize <> Font.Size) then
    Font.Size := appConfig.MainFormFontSize;
end;

function TLibraryFrame.GetCoverWidth(): Integer;
begin
  Result := Round(COVER_WIDTH * Screen.PixelsPerInch / 96.0);
end;

function TLibraryFrame.GetDefaultCoverKey(aModEntry: TModuleEntry): String;
begin
  Result := NATIVE_COVER_DEFAULT_IMAGE;

  if (aModEntry.ModType in [modtypeBible, modtypeDictionary, modtypeComment] ) and
     (TSelectEntityType.IsMyBibleFileEntry(aModEntry.ShortPath))
  then
    Result := MYBIBLE_COVER_DEFAULT_IMAGE;

end;

function TLibraryFrame.GetCoverHeight(): Integer;
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

function TLibraryFrame.IsSuitableCategory(aModType: TModuleType): Boolean;
var
  BooksType: TBooksType;
  FilteredModType: TModuleType;
begin

  Result := True;

  BooksType := TBooksType(cmbBookType.Items.Objects[cmbBookType.ItemIndex]);

  if booksType = btAllBooks then exit;


  FilteredModType := modtypeBible;
  case booksType of
    btBibles: FilteredModType := modtypeBible;
    btCommentaries: FilteredModType := modtypeComment;
    btOtherBooks: FilteredModType := modtypeBook;
    btAllDictionaries: FilteredModType := modtypeDictionary;
  end;

  // add only books of selected type
  if (aModType <> FilteredModType) then
    Result := false;

end;

procedure TLibraryFrame.ListViewSetMinWidthColunms;
begin
  lvBooks.Columns[1].MinWidth := MIN_AUTHOR_COLUMN_WIDTH;
  lvBooks.Columns[2].MinWidth := MIN_VERSION_COLUMN_WIDTH;
end;

procedure TLibraryFrame.LoadBookThumbnails(aStartIndex, aEndIndex: Integer);
var
  i: Integer;
  ModEntry : TModuleEntry;
  CoverPicture : TPicture;
  ImageIndex: Integer;
  Item: TPair<TModuleEntry, Integer>;

begin
  for i := aStartIndex to aEndIndex do
  begin

    if FFilteredModTypes[i].Value <> UNDEFAINED_IMAGEINDEX then continue;

    Item := FFilteredModTypes[i];
    ModEntry := Item.Key;

    CoverPicture := ModEntry.GetCoverImage(GetCoverWidth, GetCoverHeight);

    if Assigned(CoverPicture) then
      ImageIndex := AddCoverImage(ModEntry.ShortPath, CoverPicture)
    else
      ImageIndex := AddDefaultCoverImage(GetDefaultCoverKey(ModEntry));

    Item.Value := ImageIndex;
    FFilteredModTypes[i] := Item;

  end;
end;

function TLibraryFrame.LoadDefaultCoverImage(aResource: String): TPicture;
var origCoverImage: TPicture;
begin
  origCoverImage := nil;
  try
    origCoverImage := LoadResourceImage(aResource);
    Result := StretchImage(origCoverImage, GetCoverWidth, GetCoverHeight);
  finally
    if Assigned(origCoverImage) then
      origCoverImage.Free;
  end;


end;

procedure TLibraryFrame.lvBooksData(Sender: TObject; Item: TListItem);
var
  ImageIndex: Integer;
  ModEntry: TModuleEntry;
begin

  if Item.Index >= FFilteredModTypes.Count then exit;

  ImageIndex := FFilteredModTypes[Item.Index].Value;

  if ImageIndex >= 0 then
    Item.ImageIndex := ImageIndex;

  if ListView_GetView(lvBooks.Handle) <> LV_VIEW_DETAILS then exit;

  ModEntry := FFilteredModTypes[Item.Index].Key;

  Item.Caption := ModEntry.FullName;
  Item.SubItems.Add(ModEntry.Author);
  Item.SubItems.Add(ModEntry.ModuleVersion);
end;

procedure TLibraryFrame.lvBooksDataHint(Sender: TObject; StartIndex,
  EndIndex: Integer);
begin

  if (StartIndex >= FFilteredModTypes.Count) or (EndIndex >= FFilteredModTypes.Count) then exit;

  LoadBookThumbnails(StartIndex, EndIndex);

end;

procedure TLibraryFrame.lvBooksDblClick(Sender: TObject);
var
  SelectedItem : TListItem;
  ListView: TListView;
  ModEntry: TModuleEntry;
begin

  ListView := Sender as TListView;

  SelectedItem := ListView.Selected;

  if SelectedItem = nil then exit;

  ModEntry := FFilteredModTypes[SelectedItem.Index].Key;

  if Assigned(FOnSelectModuleEvent) then
    FOnSelectModuleEvent(self, modEntry);

end;

procedure TLibraryFrame.lvBooksInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: string);
begin

  if ListView_GetView(lvBooks.Handle) = LV_VIEW_ICON then
  begin
    InfoTip := GetToolTipForIcon(Item);
  end
  else
    InfoTip := '';

end;

procedure TLibraryFrame.lvBooksResize(Sender: TObject);
begin
  if ListView_GetView(lvBooks.Handle) = LV_VIEW_DETAILS then
    AdjustDetailsViewColumnsWidth();
end;

procedure TLibraryFrame.miSomeViewStyleClick(Sender: TObject);
begin

  btnViewStyle.ImageIndex := (Sender as TMenuItem).ImageIndex;

  UpdateBookViews();

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

  UpdateCoverDetailView();
end;


procedure TLibraryFrame.TurnOffVirtualDataForList;
begin
  lvBooks.OwnerData := False;
  lvBooks.Clear;
end;

procedure TLibraryFrame.TurnOnVirtualDataForList;
begin
  lvBooks.Clear;
  lvBooks.OwnerData := True;
  lvBooks.Items.Count := FFilteredModTypes.Count;
  lvBooks.Repaint;
end;

procedure TLibraryFrame.SetCoverImageSize(aWidth, aHeight: Integer);
begin
  vimgCover.Width := aWidth;
  vimgCover.Height := aHeight;
end;

procedure TLibraryFrame.SetModuleCountLable;
begin
  lblModuleCount.Caption := IntToStr(FFilteredModTypes.Count);
end;

procedure TLibraryFrame.OnModulesAssign(Sender: TObject);
begin
  UpdateBookList();
end;

procedure TLibraryFrame.PrepareListForSmallImages;
begin
  lvBooks.LargeImages := nil;
  SetCoverImageSize(GetSmallCoverWidth, GetSmallCoverHeight);
  lvBooks.SmallImages := vimgCover;
end;

procedure TLibraryFrame.PrepareListForBigImages();
begin
  lvBooks.SmallImages := nil;
  SetCoverImageSize(GetCoverWidth, GetCoverHeight);
  lvBooks.LargeImages := vimgCover;
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


procedure TLibraryFrame.edtFilterEnter(Sender: TObject);
var
  Edit: TEdit;
begin
  Edit := Sender as TEdit;
  PostMessage(Edit.Handle, EM_SETSEL, 0, Length(Edit.Text));
end;

procedure TLibraryFrame.EventFrameKeyDown(var Key: Char);
begin

  if not edtFilter.Focused then begin

    edtFilter.SetFocus;
    PostMessage(edtFilter.Handle, WM_CHAR, dword(Key), 0);
    PostMessage(edtFilter.Handle, WM_KEYUP, VK_RIGHT, 0);

    Key := #0;
  end;

end;

procedure TLibraryFrame.FillListViewItems();
var
  i: Integer;
begin
    // Tile view
    vdtBooks.Clear;
    vdtBooks.BeginUpdate;

    try

      for i := 0 to FFilteredModTypes.Count - 1 do
      begin
        vdtBooks.InsertNode(nil, amAddChildLast, FFilteredModTypes[i].Key);
      end;

    finally
      vdtBooks.EndUpdate;

    end;
end;

procedure TLibraryFrame.FillTileViewItems;
var
  i: Integer;
  Item: TListItem;
  ModEntry : TModuleEntry;
  ImageIndex: Integer;

begin
  lvBooks.Items.Clear;
  lvBooks.Items.BeginUpdate;

  try

    for i := 0 to FFilteredModTypes.Count -1 do
    begin
      Item := lvBooks.Items.Add;

      ImageIndex := FFilteredModTypes[Item.Index].Value;

      if ImageIndex >= 0 then
        Item.ImageIndex := ImageIndex;

      ModEntry := FFilteredModTypes[Item.Index].Key;

      Item.Caption := ModEntry.FullName;
      Item.SubItems.Add(ModEntry.Author);
      Item.SubItems.Add(ModEntry.ModuleVersion);

    end;

  finally
    lvBooks.Items.EndUpdate;

  end;

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
  modules: TCachedModules;
begin
  if mUILock then
    Exit;

  mUILock := true;

  try
    filterText := Trim(edtFilter.Text);

    FFilteredModTypes.Clear();

    allMatch := false;
    if length(filterText) > 0 then
    begin
      allMatch := filterText[1] <> '.';
      if not allMatch then
        filterText := Copy(filterText, 2, $FFF);
    end;

    filterTokens := TStringList.Create();
    StrToTokens(filterText, ' ', filterTokens);

    modules := mMainView.mModules;
    count := modules.Count - 1;
    for i := 0 to count do
    begin
      modEntry := TModuleEntry(modules.Items[i]);

      if not IsSuitableCategory(modEntry.modType) then continue;

      if length(filterText) > 0 then
      begin
        matchType := modEntry.Match(filterTokens, modEntry.mMatchInfo, allMatch);
        if (matchType = []) or ((modEntry.ModType in [modtypeBible, modtypeComment]) and (matchType = [mmtBookName])) then
          Continue;
      end;

      FFilteredModTypes.Add(TPair<TModuleEntry, Integer>.Create(modEntry, UNDEFAINED_IMAGEINDEX));

    end;

    SetModuleCountLable();
    UpdateBookViews();

  finally
    mUILock := false;
  end;
end;

procedure TLibraryFrame.TileView(aListView: TListView);
var
  tvi: TLVTILEVIEWINFO;
  i: integer;
begin
  ListView_SetView(aListView.Handle, LV_VIEW_TILE);

  for i := 0 to aListView.Items.Count - 1 do begin
    TileViewInfo(alistView, i);
  end;

  tvi.cbSize := Sizeof(tvi);
  tvi.dwMask := LVTVIM_COLUMNS;
  // Requesting space to draw the caption + 3 subitems
  tvi.cLines := aListView.Columns.Count;
  ListView_SetTileViewInfo(aListView.Handle, tvi);
end;


procedure TLibraryFrame.TileViewInfo(aListView: TListView; aIndex: Integer);
var
  ti: TLVTILEINFO;
  Order: array of Integer;
begin
    FillChar(ti, SizeOf(ti), 0);
    ti.cbSize := SizeOf(ti);
    // First item
    ti.iItem := aIndex;
    // Specifying the order for three columns
    ti.cColumns := 6;
    // Array initialization
    SetLength(order, ti.cColumns);
    // The order is 2nd, 3rd and 4th columns
    order[0] := 1;
    order[1] := 2;
    order[2] := 3;
    order[3] := 4;
    ti.puColumns := PUINT(order);
    ListView_SetTileInfo(aListView.Handle, ti);

end;

function TLibraryFrame.GetSelectedIndex(): Integer;
var
  SelectedNode: PVirtualNode;
begin
  if (GetViewMode() = lvmList) then
  begin
    Result := -1;
    SelectedNode := vdtBooks.GetFirstSelected;
    if Assigned(SelectedNode) then
      Result := SelectedNode.Index;
  end
  else
    Result := lvBooks.ItemIndex;
end;

procedure TLibraryFrame.SelectItem(Index: Integer);
begin
  if (GetViewMode() = lvmList) then
    SelectNodeByIndex(Index)
  else
  begin
    if (Index < lvBooks.Items.Count) then
      lvBooks.ItemIndex := Index;
  end;
end;

procedure TLibraryFrame.SelectNodeByIndex(Index: Integer);
var
  Node : PVirtualNode;
begin

  Node := vdtBooks.GetFirst();
  while (Node <> nil)  and (Node.Index <> Index) do begin
    Node := vdtBooks.GetNext(Node);
  end;

  if Assigned(Node) then
    vdtBooks.Selected[Node] := True;
end;

procedure TLibraryFrame.SelectViewMode(viewMode: TLibraryViewMode);
var
  menuItem: TMenuItem;
begin
  case viewMode of
    lvmCover: menuItem := miCoverViewStyle;
    lvmTile:  menuItem := miTileViewStyle;
    lvmList:  menuItem := miListViewStyle;
  else
    menuItem := miDetailsViewStyle;
  end;

  menuItem.Checked := True;
  miSomeViewStyleClick(menuItem);

  AppConfig.LastLibraryViewMode := viewMode;
end;

function TLibraryFrame.GetViewMode(): TLibraryViewMode;
begin
  if (miCoverViewStyle.Checked) then
    Result := lvmCover
  else if (miTileViewStyle.Checked) then
    Result := lvmTile
  else if (miListViewStyle.Checked) then
    Result := lvmList
  else
    Result := lvmDetail;
end;

procedure TLibraryFrame.UpdateBookViews();
begin
    // Cover view
    if miCoverViewStyle.Checked or miDetailsViewStyle.Checked then
    begin
      TurnOnVirtualDataForList();

      if miCoverViewStyle.Checked then
      begin
        PrepareListForBigImages();
        lvBooks.ViewStyle := vsIcon;
        pcViews.ActivePage := tsCoverDetailView;
      end
      else begin
        PrepareListForSmallImages();
        lvBooks.ViewStyle := vsReport;
        pcViews.ActivePage := tsCoverDetailView;
        AdjustDetailsViewColumnsWidth();
      end;



    end
    else if miTileViewStyle.Checked then
    begin
      PrepareListForBigImages();

      // Tile view
      TurnOffVirtualDataForList();

      LoadBookThumbnails(0, FFilteredModTypes.Count - 1);
      FillTileViewItems();

      TileView(lvBooks);

      lvBooks.Repaint;
      lvBooks.Refresh;

      pcViews.ActivePage := tsCoverDetailView;
    end
    else if miListViewStyle.Checked then
    begin
      FillListViewItems();

      pcViews.ActivePage := tsListView;
    end;

end;

procedure TLibraryFrame.UpdateCoverDetailView;
begin
  lvBooks.Columns[0].Caption := Lang.Say('StrModuleName');
  lvBooks.Columns[1].Caption := Lang.Say('StrModuleAuthor');
  lvBooks.Columns[2].Caption := Lang.Say('StrModuleVersion');

  miTileViewStyle.Caption := Lang.Say('StrLibraryTileView');
  miCoverViewStyle.Caption := Lang.Say('StrLibraryCoverView');
  miDetailsViewStyle.Caption := Lang.Say('StrLibraryDetailsView');
  miListViewStyle.Caption := Lang.Say('StrLibraryListView');

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

  ModEntry := Sender.GetNodeData<TModuleEntry>(PaintInfo.Node);
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
      PaintInfo.Canvas.Draw(Rect.Left, PicTop, FCoverDefaults[GetDefaultCoverKey(ModEntry)].Graphic);

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

function TLibraryFrame.GetSmallCoverHeight: Integer;
begin
  Result := Trunc(GetCoverHeight / SMALL_COVER_COEF);
end;

function TLibraryFrame.GetSmallCoverWidth: integer;
begin
  Result := Trunc(GetCoverWidth / SMALL_COVER_COEF);
end;

function TLibraryFrame.GetToolTipForIcon(Item: TListItem): String;
var
  ModEntry: TModuleEntry;
begin

  Result := '';

  if Item.Index >= FFilteredModTypes.Count then exit;

  ModEntry := FFilteredModTypes[Item.Index].Key;

  Result := AddAtNewLine(Result, ModEntry.FullName);
  Result := AddAtNewLine(Result, ModEntry.Author, Lang.Say('StrModuleAuthor'));
  Result := AddAtNewLine(Result, ModEntry.ModuleVersion, Lang.Say('StrModuleVersion'));

end;

function TLibraryFrame.GetWICImage(aPicture: TPicture): TWICImage;
var
  Image: TWICImage;
  MemoryStream: TMemoryStream;
begin
  Image := TWICImage.Create;
  Result := Image;
  MemoryStream := TMemoryStream.Create;
  try

    aPicture.SaveToStream(MemoryStream);
    MemoryStream.Position := 0;

    Image.LoadFromStream(MemoryStream);

  finally
    MemoryStream.Free;
  end;


end;

procedure TLibraryFrame.HidePageControlTabs(aPageControl: TPageControl);
var
  i: Integer;
begin
  for i := 0 to aPageControl.PageCount -1 do
    aPageControl.Pages[i].TabVisible := False;



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

procedure TLibraryFrame.Notification(Msg: IJclNotificationMessage);
var
  MsgModulesLoaded: IModulesLoadedMessage;
begin
  if Supports(Msg, IModulesLoadedMessage, MsgModulesLoaded) then
    UpdateBookList;
end;

end.
