object frmPassBox: TfrmPassBox
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  ClientHeight = 148
  ClientWidth = 412
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblPasswordNeeded: TTntLabel
    Left = 8
    Top = 8
    Width = 93
    Height = 13
    Caption = 'lblPasswordNeeded'
  end
  object lblEnterPassword: TTntLabel
    Left = 8
    Top = 40
    Width = 56
    Height = 13
    Caption = 'lbPassWord'
  end
  object btnOk: TTntButton
    Left = 8
    Top = 115
    Width = 105
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object TntEdit1: TTntEdit
    Left = 8
    Top = 59
    Width = 396
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
  object btnAcqirePassword: TTntButton
    Left = 263
    Top = 115
    Width = 105
    Height = 25
    Caption = 'btnAcqirePassword'
    ModalResult = 6
    TabOrder = 2
  end
  object btnCancel: TTntButton
    Left = 135
    Top = 115
    Width = 105
    Height = 25
    Cancel = True
    Caption = 'btnCancel'
    ModalResult = 2
    TabOrder = 3
  end
end
