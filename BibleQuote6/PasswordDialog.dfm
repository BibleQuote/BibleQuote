object frmPassBox: TfrmPassBox
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  ClientHeight = 172
  ClientWidth = 447
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
    Width = 431
    Height = 42
    AutoSize = False
    Caption = 'lblPasswordNeeded'
    WordWrap = True
  end
  object lblEnterPassword: TTntLabel
    Left = 8
    Top = 56
    Width = 56
    Height = 13
    Caption = 'lbPassWord'
  end
  object btnOk: TTntButton
    Left = 40
    Top = 139
    Width = 105
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object edPwd: TTntEdit
    Left = 8
    Top = 75
    Width = 425
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnKeyUp = edPwdKeyUp
  end
  object btnCancel: TTntButton
    Left = 295
    Top = 139
    Width = 105
    Height = 25
    Cancel = True
    Caption = 'btnCancel'
    ModalResult = 2
    TabOrder = 3
  end
  object cbxSavePwd: TTntCheckBox
    Left = 8
    Top = 102
    Width = 401
    Height = 19
    Caption = 'cbxSavePwd'
    TabOrder = 1
  end
end
