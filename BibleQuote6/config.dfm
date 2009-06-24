object ConfigForm: TConfigForm
  Left = 203
  Top = 144
  BorderStyle = bsDialog
  Caption = 'ConfigForm'
  ClientHeight = 343
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ShowHint = True
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TTntPageControl
    Left = 0
    Top = 0
    Width = 475
    Height = 305
    ActivePage = FavoritesTabSheet
    Align = alTop
    TabOrder = 0
    object CopyOptionsTabSheet: TTntTabSheet
      Caption = 'CopyOptionsTabSheet'
      object CopyVerseNumbers: TTntCheckBox
        Left = 13
        Top = 15
        Width = 343
        Height = 17
        Caption = 'CopyVerseNumbers'
        TabOrder = 0
      end
      object CopyFontParams: TTntCheckBox
        Left = 13
        Top = 38
        Width = 351
        Height = 17
        Caption = 'CopyFontParams'
        TabOrder = 1
      end
      object AddReference: TTntCheckBox
        Left = 13
        Top = 62
        Width = 343
        Height = 17
        Caption = 'AddReference'
        TabOrder = 2
      end
      object AddReferenceRadio: TTntRadioGroup
        Left = 12
        Top = 84
        Width = 348
        Height = 91
        Items.Strings = (
          'Short reference at the beginning of each verse'
          'Short reference at the end of passage'
          'Full reference at the end of passage')
        TabOrder = 3
      end
      object AddModuleName: TTntCheckBox
        Left = 13
        Top = 184
        Width = 343
        Height = 17
        Caption = 'AddModuleName'
        TabOrder = 4
      end
      object AddLineBreaks: TTntCheckBox
        Left = 13
        Top = 208
        Width = 343
        Height = 17
        Caption = 'AddLineBreaks'
        TabOrder = 5
      end
    end
    object FavoritesTabSheet: TTntTabSheet
      Caption = 'FavoritesTabSheet'
      ImageIndex = 1
      object Label1: TTntLabel
        Left = 7
        Top = 13
        Width = 27
        Height = 13
        Caption = 'Ctrl+1'
      end
      object Label2: TTntLabel
        Left = 7
        Top = 38
        Width = 27
        Height = 13
        Caption = 'Ctrl+2'
      end
      object Label5: TTntLabel
        Left = 7
        Top = 63
        Width = 27
        Height = 13
        Caption = 'Ctrl+3'
      end
      object Label3: TTntLabel
        Left = 7
        Top = 88
        Width = 27
        Height = 13
        Caption = 'Ctrl+4'
      end
      object Label7: TTntLabel
        Left = 7
        Top = 113
        Width = 27
        Height = 13
        Caption = 'Ctrl+5'
      end
      object Label6: TTntLabel
        Left = 7
        Top = 137
        Width = 27
        Height = 13
        Caption = 'Ctrl+6'
      end
      object Label9: TTntLabel
        Left = 7
        Top = 162
        Width = 27
        Height = 13
        Caption = 'Ctrl+7'
      end
      object Label8: TTntLabel
        Left = 7
        Top = 187
        Width = 27
        Height = 13
        Caption = 'Ctrl+8'
      end
      object Label11: TTntLabel
        Left = 7
        Top = 213
        Width = 27
        Height = 13
        Caption = 'Ctrl+9'
      end
      object Label10: TTntLabel
        Left = 7
        Top = 237
        Width = 27
        Height = 13
        Caption = 'Ctrl+0'
      end
      object HotCB1: TTntComboBox
        Left = 52
        Top = 8
        Width = 407
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        TabOrder = 0
      end
      object HotCB2: TTntComboBox
        Left = 52
        Top = 33
        Width = 407
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        TabOrder = 1
      end
      object HotCB3: TTntComboBox
        Left = 52
        Top = 58
        Width = 407
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        TabOrder = 2
      end
      object HotCB4: TTntComboBox
        Left = 52
        Top = 83
        Width = 407
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        TabOrder = 3
      end
      object HotCB5: TTntComboBox
        Left = 52
        Top = 108
        Width = 407
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        TabOrder = 4
      end
      object HotCB6: TTntComboBox
        Left = 52
        Top = 133
        Width = 407
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        TabOrder = 5
      end
      object HotCB7: TTntComboBox
        Left = 52
        Top = 158
        Width = 407
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        TabOrder = 6
      end
      object HotCB8: TTntComboBox
        Left = 52
        Top = 183
        Width = 407
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        TabOrder = 7
      end
      object HotCB9: TTntComboBox
        Left = 52
        Top = 208
        Width = 407
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        TabOrder = 8
      end
      object HotCB0: TTntComboBox
        Left = 52
        Top = 234
        Width = 407
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        TabOrder = 9
      end
    end
    object OtherOptionsTabSheet: TTntTabSheet
      Caption = 'OtherOptionsTabSheet'
      ImageIndex = 2
      object SelectSecondPathLabel: TTntLabel
        Left = 8
        Top = 8
        Width = 115
        Height = 13
        Caption = 'SelectSecondPathLabel'
      end
      object SelectPathEdit: TTntEdit
        Left = 8
        Top = 32
        Width = 313
        Height = 21
        Enabled = False
        TabOrder = 0
      end
      object SelectPathButton: TTntButton
        Left = 322
        Top = 32
        Width = 25
        Height = 21
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = SelectPathButtonClick
      end
      object DeleteButton: TTntButton
        Left = 346
        Top = 32
        Width = 25
        Height = 21
        Caption = 'x'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = DeleteButtonClick
      end
      object MinimizeToTray: TTntCheckBox
        Left = 8
        Top = 70
        Width = 449
        Height = 17
        Caption = 'MinimizeToTray'
        TabOrder = 3
      end
      object HotKeyChoice: TTntRadioGroup
        Left = 26
        Top = 96
        Width = 255
        Height = 83
        Caption = 'HotKeyChoice'
        ItemIndex = 0
        Items.Strings = (
          'Win + B'
          'Ctrl + Alt + B')
        TabOrder = 4
      end
    end
  end
  object OKButton: TTntButton
    Left = 250
    Top = 312
    Width = 105
    Height = 25
    Caption = 'OKButton'
    TabOrder = 1
    OnClick = OKButtonClick
  end
  object CancelButton: TTntButton
    Left = 362
    Top = 312
    Width = 105
    Height = 25
    Caption = 'CancelButton'
    TabOrder = 2
    OnClick = CancelButtonClick
  end
end
