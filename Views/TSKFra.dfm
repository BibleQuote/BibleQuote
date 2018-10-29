object TSKFrame: TTSKFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object bwrXRef: THTMLViewer
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    TabOrder = 0
    Align = alClient
    PopupMenu = pmRef
    BorderStyle = htSingle
    CharSet = RUSSIAN_CHARSET
    DefFontName = 'Times New Roman'
    DefPreFontName = 'Courier New'
    HistoryMaxCount = 0
    HtOptions = []
    NoSelect = False
    PrintMarginBottom = 2.000000000000000000
    PrintMarginLeft = 2.000000000000000000
    PrintMarginRight = 2.000000000000000000
    PrintMarginTop = 2.000000000000000000
    PrintScale = 1.000000000000000000
    OnHotSpotClick = bwrXRefHotSpotClick
  end
  object pmRef: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = pmRefPopup
    Left = 292
    Top = 165
    object miRefCopy: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnClick = miRefCopyClick
    end
    object miOpenNewView: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074' '#1085#1086#1074#1086#1081' '#1074#1082#1083#1072#1076#1082#1077
      OnClick = miOpenNewViewClick
    end
    object miRefPrint: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1072#1090#1100
      OnClick = miRefPrintClick
    end
  end
end
