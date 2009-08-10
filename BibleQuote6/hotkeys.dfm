object HotKeyForm: THotKeyForm
  Left = 140
  Top = 109
  BorderStyle = bsDialog
  Caption = 'Ctrl+1 Ctrl+2 ...'
  ClientHeight = 304
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label10: TTntLabel
    Left = 7
    Top = 237
    Width = 27
    Height = 13
    Caption = 'Ctrl+0'
  end
  object Label11: TTntLabel
    Left = 7
    Top = 213
    Width = 27
    Height = 13
    Caption = 'Ctrl+9'
  end
  object Label8: TTntLabel
    Left = 7
    Top = 187
    Width = 27
    Height = 13
    Caption = 'Ctrl+8'
  end
  object Label9: TTntLabel
    Left = 7
    Top = 162
    Width = 27
    Height = 13
    Caption = 'Ctrl+7'
  end
  object Label6: TTntLabel
    Left = 7
    Top = 137
    Width = 27
    Height = 13
    Caption = 'Ctrl+6'
  end
  object Label7: TTntLabel
    Left = 7
    Top = 113
    Width = 27
    Height = 13
    Caption = 'Ctrl+5'
  end
  object Label3: TTntLabel
    Left = 7
    Top = 88
    Width = 27
    Height = 13
    Caption = 'Ctrl+4'
  end
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
  object HotKeyOKButton: TTntButton
    Left = 158
    Top = 268
    Width = 82
    Height = 24
    Caption = 'OK'
    TabOrder = 10
    OnClick = HotKeyOKButtonClick
  end
  object HotKeyCancelButton: TTntButton
    Left = 248
    Top = 268
    Width = 82
    Height = 24
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 11
    OnClick = HotKeyCancelButtonClick
  end
end
