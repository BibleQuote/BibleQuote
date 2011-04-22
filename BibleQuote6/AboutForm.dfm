object frmAbout: TfrmAbout
  Left = 0
  Top = 0
  Cursor = crHandPoint
  BorderStyle = bsSingle
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 274
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = TntFormCreate
  OnShow = TntFormShow
  DesignSize = (
    416
    274)
  PixelsPerInch = 105
  TextHeight = 14
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 416
    Height = 76
    Align = alTop
    ExplicitWidth = 408
  end
  object lbBQName: TTntLabel
    Left = 79
    Top = 4
    Width = 329
    Height = 64
    Alignment = taRightJustify
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = #1062#1080#1090#1072#1090#1072' '#1080#1079' '#1041#1080#1073#1083#1080#1080' 6'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Layout = tlCenter
  end
  object Image1: TImage
    Left = 12
    Top = 5
    Width = 64
    Height = 64
    AutoSize = True
    Transparent = True
  end
  object memDevs: TTntMemo
    Left = 8
    Top = 82
    Width = 400
    Height = 138
    TabStop = False
    Lines.Strings = (
      #1042#1077#1088#1089#1080#1103' 6.0.1b9f2 (7.03.2011) ALPHA'
      #1053#1072#1076' '#1087#1088#1086#1075#1088#1072#1084#1084#1086#1081' '#1088#1072#1073#1086#1090#1072#1083#1080':'
      #1058#1080#1084#1086#1092#1077#1081' '#1061#1072
      #1042#1083#1072#1076#1080#1089#1083#1072#1074' '#1044#1086#1088#1086#1096
      #1040#1083#1077#1082#1089#1072#1085#1076#1088' '#1057#1085#1080#1075#1077#1088#1077#1074
      #1041#1083#1072#1075#1086#1076#1072#1088#1085#1086#1089#1090#1080':'
      #1054#1083#1077#1075#1091' '#1063#1091#1087#1077' ('#1075#1088#1072#1092#1080#1082#1072' '#1087#1072#1085#1077#1083#1080' '#1080#1089#1090#1088#1091#1084#1077#1085#1090#1086#1074')'
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      #1045#1089#1083#1080' '#1074#1099' '#1093#1086#1090#1080#1090#1077' '#1087#1086#1076#1076#1077#1088#1078#1072#1090#1100' '#1088#1072#1079#1088#1072#1073#1086#1090#1082#1091' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '
      #1084#1072#1090#1077#1088#1080#1072#1083#1100#1085#1086', '#1090#1086' '#1101#1090#1086' '#1084#1086#1078#1085#1086' '#1089#1076#1077#1083#1072#1090#1100' '#1089#1083#1077#1076#1091#1102#1097#1080#1084#1080' '#1089#1087#1086#1089#1086#1073#1072#1084#1080':'
      '1. WebMoney: R424918668350 Z232543872197'
      '2. Visa/MasterCard '#1085#1072' '#1072#1076#1088#1077#1089' mailtoAlek@gmail.com '
      '(https://load.payoneer.com/LoadToPage.aspx)'
      '3. '#1048#1083#1080' '#1087#1088#1086#1089#1090#1086' '#1086#1090#1086#1096#1083#1080#1090#1077' '#1082#1086#1076' '#1072#1082#1090#1080#1074#1072#1094#1080#1080' '#1045#1076#1080#1085#1086#1081' '#1082#1072#1088#1090#1099' '#1086#1087#1083#1072#1090#1099' '
      #1052#1077#1075#1072#1092#1086#1085' '#1085#1072' '#1072#1076#1088#1077#1089' mailtoAlek@gmail.com ')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btnOK: TTntButton
    Left = 333
    Top = 241
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 8
    Top = 220
    Width = 289
    Height = 25
    Cursor = crHandPoint
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Caption = #1054#1073#1089#1091#1076#1080#1090#1077' '#1088#1072#1073#1086#1090#1091' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1085#1072' '#1092#1086#1088#1091#1084#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 2
    OnClick = TntLabel1Click
  end
  object Panel2: TPanel
    Tag = 1
    Left = 8
    Top = 241
    Width = 241
    Height = 25
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Caption = #1040#1082#1090#1091#1072#1083#1100#1085#1072#1103' '#1074#1077#1088#1089#1080#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1079#1076#1077#1089#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 0
    OnClick = TntLabel1Click
    OnMouseEnter = Panel2MouseEnter
    OnMouseLeave = Panel2MouseLeave
  end
end
