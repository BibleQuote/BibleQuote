unit UISettingsFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  BibleQuoteUtils, StringProcs, AppIni;

type
  TUISettingsForm = class(TForm)
    clrBackground: TColorBox;
    clrHyperlinks: TColorBox;
    clrSearchText: TColorBox;
    clrVerseHighlight: TColorBox;
    btnCancel: TButton;
    btnOk: TButton;
    lblBackgroundColor: TLabel;
    lblSearchTextColor: TLabel;
    lblHyperlinksColor: TLabel;
    lblVerseHightlightColor: TLabel;
    FontDialog: TFontDialog;
    ColorDialog: TColorDialog;
    grpColors: TGroupBox;
    grpFonts: TGroupBox;
    lblPrimaryFont: TLabel;
    btnPrimaryFont: TButton;
    edtPrimaryFont: TEdit;
    btnDialogsFont: TButton;
    edtDialogsFont: TEdit;
    lglDialogsFont: TLabel;
    btnSecondaryFont: TButton;
    edtSecondaryFont: TEdit;
    lblSecondaryFont: TLabel;
    Label1: TLabel;
    procedure btnPrimaryFontClick(Sender: TObject);
    procedure btnSecondaryFontClick(Sender: TObject);
    procedure btnDialogsFontClick(Sender: TObject);

  private
    FPrimaryFont: TFont;
    FSecondaryFont: TFont;
    FDialogsFont: TFont;
    procedure DisplayPrimaryFont;
    procedure DisplaySecondaryFont;
    procedure DisplayDialogsFont;

  public
    procedure LoadConfiguration();
    procedure UpdateConfiguration();
  end;

var
  UISettingsForm: TUISettingsForm;

implementation

{$R *.dfm}

procedure TUISettingsForm.btnDialogsFontClick(Sender: TObject);
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

procedure TUISettingsForm.btnPrimaryFontClick(Sender: TObject);
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

procedure TUISettingsForm.btnSecondaryFontClick(Sender: TObject);
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

procedure TUISettingsForm.LoadConfiguration;
begin
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

procedure TUISettingsForm.UpdateConfiguration;
begin
  if Assigned(FPrimaryFont) then
  begin
    AppConfig.DefFontName := FPrimaryFont.Name;
    AppConfig.DefFontColor := FPrimaryFont.Color;
    AppConfig.DefFontSize := FPrimaryFont.Size;
  end;

  if Assigned(FSecondaryFont) then
  begin
    AppConfig.RefFontName := FSecondaryFont.Name;
    AppConfig.RefFontColor := FSecondaryFont.Color;
    AppConfig.RefFontSize := FSecondaryFont.Size;
  end;

  if Assigned(FDialogsFont) then
  begin
    AppConfig.MainFormFontName := FDialogsFont.Name;
    AppConfig.MainFormFontSize := FDialogsFont.Size;
  end;

  AppConfig.BackgroundColor := clrBackground.Selected;
  AppConfig.HotSpotColor := clrHyperlinks.Selected;
  AppConfig.VerseHighlightColor := clrVerseHighlight.Selected;
  AppConfig.SelTextColor := clrSearchText.Selected;
end;

procedure TUISettingsForm.DisplayDialogsFont;
begin
  edtDialogsFont.Text := FDialogsFont.Name + ', ' + IntToStr(FDialogsFont.Size);
end;

procedure TUISettingsForm.DisplaySecondaryFont;
begin
  edtSecondaryFont.Font.Color := FSecondaryFont.Color;
  edtSecondaryFont.Text := FSecondaryFont.Name + ', ' + IntToStr(FSecondaryFont.Size);
end;

procedure TUISettingsForm.DisplayPrimaryFont;
begin
  edtPrimaryFont.Font.Color := FPrimaryFont.Color;
  edtPrimaryFont.Text := FPrimaryFont.Name + ', ' + IntToStr(FPrimaryFont.Size);
end;

end.
