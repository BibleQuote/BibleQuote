unit ConfigFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, IOUtils, Forms,
  FileCtrl, ExtCtrls, Buttons, StdCtrls, ComCtrls, Vcl.Dialogs,
  AppIni, PlainUtils, Favorites, BibleQuoteUtils, AppPaths, StringProcs;

type
  TConfigForm = class(TForm)
    pgcOptions: TPageControl;
    tsCopyOptions: TTabSheet;
    chkCopyVerseNumbers: TCheckBox;
    chkCopyFontParams: TCheckBox;
    chkAddReference: TCheckBox;
    rgAddReference: TRadioGroup;
    chkAddModuleName: TCheckBox;
    chkAddLineBreaks: TCheckBox;
    tsOtherOptions: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    lblSelectSecondPath: TLabel;
    edtSelectPath: TEdit;
    btnSelectPath: TButton;
    btnDeletePath: TButton;
    chkMinimizeToTray: TCheckBox;
    rgHotKeyChoice: TRadioGroup;
    tsFavouriteEx: TTabSheet;
    lblAvailableModules: TLabel;
    lblFavourites: TLabel;
    lbFavourites: TListBox;
    bbtnUp: TBitBtn;
    bbtnDown: TBitBtn;
    cbAvailableModules: TComboBox;
    bbtnDelete: TBitBtn;
    btnAddHotModule: TBitBtn;
    chkFullContextOnRestrictedLinks: TCheckBox;
    chkHighlightVerseHits: TCheckBox;
    lblDefaultBible: TLabel;
    cbDefaultBible: TComboBox;
    lblDefaultStrongBible: TLabel;
    cbDefaultStrongBible: TComboBox;
    tsInterface: TTabSheet;
    grpColors: TGroupBox;
    lblBackgroundColor: TLabel;
    lblHyperlinksColor: TLabel;
    lblSearchTextColor: TLabel;
    lblVerseHighlightColor: TLabel;
    clrBackground: TColorBox;
    clrHyperlinks: TColorBox;
    clrSearchText: TColorBox;
    clrVerseHighlight: TColorBox;
    grpFonts: TGroupBox;
    lblPrimaryFont: TLabel;
    lblDialogsFont: TLabel;
    lblSecondaryFont: TLabel;
    btnPrimaryFont: TButton;
    edtPrimaryFont: TEdit;
    btnDialogsFont: TButton;
    edtDialogsFont: TEdit;
    btnSecondaryFont: TButton;
    edtSecondaryFont: TEdit;
    FontDialog: TFontDialog;
    ColorDialog: TColorDialog;
    cbLanguage: TComboBox;
    grpLocalization: TGroupBox;
    lblLanguage: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSelectPathClick(Sender: TObject);
    procedure btnDeletePathClick(Sender: TObject);
    procedure favouritesBitBtnClick(Sender: TObject);
    procedure btnAddHotModuleClick(Sender: TObject);
    procedure btnDialogsFontClick(Sender: TObject);
    procedure btnSecondaryFontClick(Sender: TObject);
    procedure btnPrimaryFontClick(Sender: TObject);
  private
    FPrimaryFont: TFont;
    FSecondaryFont: TFont;
    FDialogsFont: TFont;
    
    procedure DisplayPrimaryFont;
    procedure DisplaySecondaryFont;
    procedure DisplayDialogsFont;
    procedure FillLanguages();
  public
    property PrimaryFont: TFont read FPrimaryFont;
    property SecondaryFont: TFont read FSecondaryFont;
    property DialogsFont: TFont read FDialogsFont;

    procedure LoadConfiguration(modules: TCachedModules; favorites: TFavoriteModules);
  end;

var
  ConfigForm: TConfigForm;

implementation

{$R *.DFM}

procedure TConfigForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(27) then
    ModalResult := mrCancel;
end;

procedure TConfigForm.favouritesBitBtnClick(Sender: TObject);
var
  itemIx, newItemIx, itemCount: integer;
  op: integer;
begin
  itemIx := lbFavourites.ItemIndex;
  itemCount := lbFavourites.Count - 1;
  if (itemIx < 0) or (itemIx > itemCount) then
    exit;
  op := (Sender as TBitBtn).Tag;
  if op = 0 then
  begin
    lbFavourites.Items.Delete(itemIx);
    Dec(itemCount);
    if (itemCount >= 0) then
    begin
      if (itemIx > itemCount) then
        itemIx := itemCount;
      lbFavourites.ItemIndex := itemIx;
    end;
    exit
  end;
  newItemIx := itemIx + op;
  if (newItemIx < 0) or (newItemIx > itemCount) then
    exit;
  lbFavourites.Items.Move(itemIx, newItemIx);
  lbFavourites.ItemIndex := newItemIx;
end;

procedure TConfigForm.btnAddHotModuleClick(Sender: TObject);
var
  ix, cnt: integer;
begin
  cnt := cbAvailableModules.Items.Count;
  ix := cbAvailableModules.ItemIndex;
  if (ix < 0) or (ix >= cnt) then
    exit;
  ix := lbFavourites.Items.Add(cbAvailableModules.Items[ix]);
  lbFavourites.ItemIndex := ix;
end;

procedure TConfigForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TConfigForm.btnSelectPathClick(Sender: TObject);
var
  s: string;
begin
  if SelectDirectory(lblSelectSecondPath.Caption, edtSelectPath.Text, s) then
  begin
    if s[Length(s)] <> '\' then
      s := s + '\';

    edtSelectPath.Text := s;
  end;
end;

procedure TConfigForm.btnDeletePathClick(Sender: TObject);
begin
  edtSelectPath.Text := '';
end;

procedure TConfigForm.btnDialogsFontClick(Sender: TObject);
begin
  if not Assigned(FDialogsFont) then
    Exit;

  FontDialog.Options := [];
  FontDialog.Font.Name := FDialogsFont.Name;
  FontDialog.Font.Size := FDialogsFont.Size;

  if (FontDialog.Execute()) then
  begin
    FDialogsFont.Name := FontDialog.Font.Name;
    FDialogsFont.Size := FontDialog.Font.Size;

    DisplayDialogsFont;
  end;
end;

procedure TConfigForm.btnPrimaryFontClick(Sender: TObject);
begin
  if not Assigned(FPrimaryFont) then
    Exit;

  FontDialog.Options := [fdEffects];
  FontDialog.Font.Name := FPrimaryFont.Name;
  FontDialog.Font.Color := FPrimaryFont.Color;
  FontDialog.Font.Size := FPrimaryFont.Size;

  if (FontDialog.Execute()) then
  begin
    FPrimaryFont.Name := FontDialog.Font.Name;
    FPrimaryFont.Color := FontDialog.Font.Color;
    FPrimaryFont.Size := FontDialog.Font.Size;

    DisplayPrimaryFont;
  end;
end;

procedure TConfigForm.btnSecondaryFontClick(Sender: TObject);
begin
  if not Assigned(FSecondaryFont) then
    Exit;

  FontDialog.Options := [fdEffects];
  FontDialog.Font.Name := FSecondaryFont.Name;
  FontDialog.Font.Color := FSecondaryFont.Color;
  FontDialog.Font.Size := FSecondaryFont.Size;

  if (FontDialog.Execute()) then
  begin
    FSecondaryFont.Name := FontDialog.Font.Name;
    FSecondaryFont.Color := FontDialog.Font.Color;
    FSecondaryFont.Size := FontDialog.Font.Size;

    DisplaySecondaryFont;
  end;
end;

procedure TConfigForm.DisplayDialogsFont;
begin
  edtDialogsFont.Text := FDialogsFont.Name + ', ' + IntToStr(FDialogsFont.Size);
end;

procedure TConfigForm.DisplaySecondaryFont;
begin
  edtSecondaryFont.Font.Color := FSecondaryFont.Color;
  edtSecondaryFont.Text := FSecondaryFont.Name + ', ' + IntToStr(FSecondaryFont.Size);
end;

procedure TConfigForm.DisplayPrimaryFont;
begin
  edtPrimaryFont.Font.Color := FPrimaryFont.Color;
  edtPrimaryFont.Text := FPrimaryFont.Name + ', ' + IntToStr(FPrimaryFont.Size);
end;

procedure TConfigForm.LoadConfiguration(modules: TCachedModules; favorites: TFavoriteModules);
var
  allBibles: TStringList;
  strongBibles: TSTringList;
  i: integer;
  moduleCount: integer;
begin
  FillLanguages();

  edtSelectPath.Text := AppConfig.SecondPath;
  chkMinimizeToTray.Checked := AppConfig.MinimizeToTray;
  chkFullContextOnRestrictedLinks.Checked := AppConfig.FullContextLinks;
  chkHighlightVerseHits.Checked := AppConfig.HighlightVerseHits;
  rgHotKeyChoice.ItemIndex := AppConfig.HotKeyChoice;
  moduleCount := modules.Count - 1;

  // fill the list of available modules for favorites
  cbAvailableModules.Clear;
  allBibles := TStringList.Create;
  try
    allBibles.Sorted := true;

    allBibles.BeginUpdate;
    try
      for i := 0 to moduleCount do
      begin
        allBibles.Add(modules[i].mFullName);
      end;
    finally
      allBibles.EndUpdate;
    end;

    cbAvailableModules.Items.BeginUpdate;
    try
      cbAvailableModules.Items.Clear;
      for i := 0 to allBibles.Count - 1 do
      begin
        cbAvailableModules.Items.Add(allBibles[i]);
      end;
    finally
      cbAvailableModules.Items.EndUpdate;
    end;
  finally
    allBibles.Free;
  end;

  if moduleCount >= 0 then
    cbAvailableModules.ItemIndex := 0;

  // fill the list of available modules for default bible
  cbDefaultBible.Clear;
  allBibles := TStringList.Create;
  strongBibles := TStringList.Create;
  try
    allBibles.Sorted := true;
    strongBibles.Sorted := true;

    allBibles.BeginUpdate;
    strongBibles.BeginUpdate;
    try
      for i := 0 to moduleCount do
      begin
        if (modules[i].modType = modtypeBible) then
        begin
          allBibles.Add(modules[i].mFullName);

          if (modules[i].mHasStrong) then
            strongBibles.Add(modules[i].mFullName);
        end;
      end;
    finally
      allBibles.EndUpdate;
      strongBibles.EndUpdate;
    end;
    cbDefaultBible.Items.BeginUpdate;

    try
      cbDefaultBible.Items.Clear;
      cbDefaultBible.Items.Add('');
      for i := 0 to allBibles.Count - 1 do
      begin
        cbDefaultBible.Items.Add(allBibles[i]);
      end;
    finally
      cbDefaultBible.Items.EndUpdate;
    end;

    if (AppConfig.DefaultBible = '') then
    begin
      cbDefaultBible.ItemIndex := 0;
    end
    else
    begin
      for i := 0 to cbDefaultBible.Items.Count - 1 do
      begin
        if (OmegaCompareTxt(AppConfig.DefaultBible, cbDefaultBible.Items[i], -1, false) = 0) then
        begin
          cbDefaultBible.ItemIndex := i;
          break;
        end;
      end;
    end;

    cbDefaultStrongBible.Items.BeginUpdate;
    try
      cbDefaultStrongBible.Items.Clear;
      cbDefaultStrongBible.Items.Add('');
      for i := 0 to strongBibles.Count - 1 do
      begin
        cbDefaultStrongBible.Items.Add(strongBibles[i]);
      end;
    finally
      cbDefaultStrongBible.Items.EndUpdate;
    end;

    if (AppConfig.DefaultStrongBible = '') then
    begin
      cbDefaultStrongBible.ItemIndex := 0;
    end
    else
    begin
      for i := 0 to cbDefaultStrongBible.Items.Count - 1 do
      begin
        if (OmegaCompareTxt(AppConfig.DefaultStrongBible, cbDefaultStrongBible.Items[i], -1, false) = 0) then
        begin
          cbDefaultStrongBible.ItemIndex := i;
          break;
        end;
      end;
    end;

  finally
    allBibles.Free;
    strongBibles.Free;
  end;

  moduleCount := favorites.mModuleEntries.Count - 1;
  lbFavourites.Clear;
  lbFavourites.Items.BeginUpdate;
  for i := 0 to moduleCount do
  begin
    lbFavourites.Items.Add(favorites.mModuleEntries[i].mFullName);
  end;
  lbFavourites.Items.EndUpdate;

  FPrimaryFont := TFont.Create();
  FPrimaryFont.Name := AppConfig.DefFontName;
  FPrimaryFont.Color := AppConfig.DefFontColor;
  FPrimaryFont.Size := AppConfig.DefFontSize;

  FSecondaryFont := TFont.Create();
  FSecondaryFont.Name := AppConfig.RefFontName;
  FSecondaryFont.Color := AppConfig.RefFontColor;
  FSecondaryFont.Size := AppConfig.RefFontSize;

  FDialogsFont := TFont.Create();
  FDialogsFont.Name := AppConfig.MainFormFontName;
  FDialogsFont.Size := AppConfig.MainFormFontSize;

  DisplayPrimaryFont;
  DisplaySecondaryFont;
  DisplayDialogsFont;

  clrBackground.Selected := AppConfig.BackgroundColor;
  clrHyperlinks.Selected := AppConfig.HotSpotColor;
  clrVerseHighlight.Selected := AppConfig.VerseHighlightColor;
  clrSearchText.Selected := AppConfig.SelTextColor;
end;

procedure TConfigForm.FillLanguages();
var
  locDirectory: string;
  langPattern: string;
  lang: string;
  sRec: TSearchRec;
  i, idx: integer;
begin
  locDirectory := TAppDirectories.Localization;
  langPattern := TPath.Combine(locDirectory, '*.lng');

  cbLanguage.Clear;    
  i := 0;
  idx := -1;
  if FindFirst(langPattern, faAnyFile, sRec) = 0 then
  begin
    repeat
      lang := UpperCaseFirstLetter(Copy(sRec.Name, 1, Length(sRec.Name) - 4));
      cbLanguage.AddItem(lang, TObject(lang));
      if (LowerCase(sRec.Name) = LowerCase(AppConfig.LocalizationFile)) then
        idx := i;
      inc(i);
    until FindNext(sRec) <> 0;
    FindClose(sRec);
  end;      

  if (idx >= 0) then  
    cbLanguage.ItemIndex := idx;
end;

end.
