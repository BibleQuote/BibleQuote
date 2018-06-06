object AboutForm: TAboutForm
  Left = 0
  Top = 0
  Cursor = crArrow
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 333
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    505
    333)
  PixelsPerInch = 120
  TextHeight = 17
  object shpHeader: TShape
    Left = 0
    Top = 0
    Width = 505
    Height = 86
    Align = alTop
  end
  object lblTitle: TLabel
    Left = 8
    Top = 8
    Width = 297
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'BibleQuote'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Layout = tlCenter
  end
  object memDevs: TMemo
    Left = 9
    Top = 97
    Width = 485
    Height = 168
    TabStop = False
    Lines.Strings = (
      ''
      #1041#1083#1072#1075#1086#1076#1072#1088#1085#1086#1089#1090#1080':'
      '- '#1040#1083#1077#1082#1089#1072#1085#1076#1088' '#1057#1085#1080#1075#1077#1088#1077#1074
      '- Samuel A. Kim'
      '- '#1058#1080#1084#1086#1092#1077#1081' '#1061#1072)
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 206
    Top = 285
    Width = 91
    Height = 30
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
end
