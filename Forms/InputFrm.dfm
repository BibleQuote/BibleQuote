object InputForm: TInputForm
  Left = 255
  Top = 239
  ActiveControl = btnOK
  BorderStyle = bsDialog
  Caption = 'InputForm'
  ClientHeight = 180
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 105
  TextHeight = 13
  object edtValue: TEdit
    Left = 8
    Top = 8
    Width = 369
    Height = 21
    TabOrder = 0
    Text = 'edtValue'
  end
  object btnOK: TButton
    Left = 159
    Top = 147
    Width = 73
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object memValue: TMemo
    Left = 8
    Top = 35
    Width = 369
    Height = 97
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
