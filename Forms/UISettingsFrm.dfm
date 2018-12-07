object UISettingsForm: TUISettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Interface settings'
  ClientHeight = 289
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    362
    289)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 27
    Top = 360
    Width = 84
    Height = 13
    Caption = 'Main window text'
  end
  object btnCancel: TButton
    Left = 279
    Top = 256
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 198
    Top = 256
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object grpColors: TGroupBox
    Left = 8
    Top = 8
    Width = 345
    Height = 129
    Caption = 'Colors'
    TabOrder = 2
    object lblBackgroundColor: TLabel
      Left = 71
      Top = 16
      Width = 60
      Height = 13
      Caption = 'Background:'
    end
    object lblHyperlinksColor: TLabel
      Left = 78
      Top = 44
      Width = 53
      Height = 13
      Caption = 'Hyperlinks:'
    end
    object lblSearchTextColor: TLabel
      Left = 19
      Top = 72
      Width = 112
      Height = 13
      Caption = 'Search text and memo:'
    end
    object lblVerseHightlightColor: TLabel
      Left = 57
      Top = 100
      Width = 74
      Height = 13
      Caption = 'Verse highlight:'
    end
    object clrBackground: TColorBox
      Left = 137
      Top = 13
      Width = 112
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      TabOrder = 0
    end
    object clrHyperlinks: TColorBox
      Left = 137
      Top = 41
      Width = 112
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      TabOrder = 1
    end
    object clrSearchText: TColorBox
      Left = 137
      Top = 69
      Width = 112
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      TabOrder = 2
    end
    object clrVerseHighlight: TColorBox
      Left = 137
      Top = 97
      Width = 112
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      TabOrder = 3
    end
  end
  object grpFonts: TGroupBox
    Left = 8
    Top = 143
    Width = 345
    Height = 106
    Caption = 'Fonts'
    TabOrder = 3
    object lblPrimaryFont: TLabel
      Left = 41
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Primary font:'
    end
    object lglDialogsFont: TLabel
      Left = 14
      Top = 79
      Width = 90
      Height = 13
      Caption = 'Forms and dialogs:'
    end
    object lblSecondaryFont: TLabel
      Left = 26
      Top = 51
      Width = 78
      Height = 13
      Caption = 'Secondary font:'
    end
    object btnPrimaryFont: TButton
      Left = 304
      Top = 21
      Width = 30
      Height = 21
      Caption = '...'
      TabOrder = 0
      OnClick = btnPrimaryFontClick
    end
    object edtPrimaryFont: TEdit
      Left = 110
      Top = 21
      Width = 188
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object btnDialogsFont: TButton
      Left = 304
      Top = 75
      Width = 30
      Height = 21
      Caption = '...'
      TabOrder = 2
      OnClick = btnDialogsFontClick
    end
    object edtDialogsFont: TEdit
      Left = 110
      Top = 75
      Width = 188
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
    object btnSecondaryFont: TButton
      Left = 304
      Top = 48
      Width = 30
      Height = 21
      Caption = '...'
      TabOrder = 4
      OnClick = btnSecondaryFontClick
    end
    object edtSecondaryFont: TEdit
      Left = 110
      Top = 48
      Width = 188
      Height = 21
      ReadOnly = True
      TabOrder = 5
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdNoStyleSel]
    Left = 51
    Top = 252
  end
  object ColorDialog: TColorDialog
    Left = 11
    Top = 252
  end
end
