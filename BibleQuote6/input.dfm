object InputForm: TInputForm
  Left = 255
  Top = 239
  ActiveControl = OKButton
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
  OnKeyPress = TntFormKeyPress
  OnShow = TntFormShow
  PixelsPerInch = 105
  TextHeight = 13
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 369
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object OKButton: TButton
    Left = 159
    Top = 147
    Width = 73
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = OKButtonClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 35
    Width = 369
    Height = 97
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
