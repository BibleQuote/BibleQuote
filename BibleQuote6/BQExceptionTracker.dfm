object bqExceptionForm: TbqExceptionForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1054#1073#1085#1072#1088#1091#1078#1077#1085#1072' '#1086#1096#1080#1073#1082#1072'!'
  ClientHeight = 337
  ClientWidth = 573
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 105
  TextHeight = 14
  object lblLog: TTntLabel
    Left = 9
    Top = 9
    Width = 133
    Height = 14
    Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1080#1089#1082#1083#1102#1095#1077#1085#1080#1103':'
  end
  object ErrMemo: TTntMemo
    Left = 8
    Top = 29
    Width = 554
    Height = 265
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object btnOK: TTntButton
    Left = 481
    Top = 300
    Width = 81
    Height = 27
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnHalt: TTntButton
    Left = 5
    Top = 300
    Width = 131
    Height = 27
    Caption = #1040#1074#1072#1088#1080#1081#1085#1099#1081' '#1086#1089#1090#1072#1085#1086#1074
    TabOrder = 2
    OnClick = btnHaltClick
  end
end
