object DictionaryFrame: TDictionaryFrame
  Left = 0
  Top = 0
  Width = 356
  Height = 354
  TabOrder = 0
  object bwrDic: THTMLViewer
    Left = 0
    Top = 234
    Width = 356
    Height = 120
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
    ScrollBars = ssVertical
    OnHotSpotClick = bwrDicHotSpotClick
    OnHotSpotCovered = bwrDicHotSpotCovered
    OnMouseDouble = bwrDicMouseDouble
  end
  object pnlDic: TPanel
    Left = 0
    Top = 0
    Width = 356
    Height = 178
    Align = alTop
    Anchors = []
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      356
      178)
    object cbDicFilter: TComboBox
      Left = 4
      Top = 5
      Width = 349
      Height = 21
      Hint = 'Select dictionary to search within'
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      PopupMenu = pmEmpty
      TabOrder = 0
      OnChange = cbDicFilterChange
    end
    object edtDic: TComboBox
      Left = 4
      Top = 31
      Width = 349
      Height = 21
      Hint = 'ent word to search here'
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnChange = edtDicChange
      OnKeyPress = edtDicKeyPress
      OnKeyUp = edtDicKeyUp
    end
    object vstDicList: TVirtualStringTree
      Left = 4
      Top = 60
      Width = 349
      Height = 115
      Anchors = [akLeft, akTop, akRight]
      DefaultNodeHeight = 17
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Height = 17
      Header.MainColumn = -1
      Indent = 1
      Margin = 0
      NodeDataSize = 4
      ScrollBarOptions.ScrollBars = ssVertical
      TabOrder = 2
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toUseBlendedSelection, toUseExplorerTheme]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnAddToSelection = vstDicListAddToSelection
      OnClick = vstDicListClick
      OnDblClick = vstDicListClick
      OnGetText = vstDicListGetText
      OnKeyPress = vstDicListKeyPress
      Columns = <>
    end
  end
  object pnlSelectDic: TPanel
    Left = 0
    Top = 178
    Width = 356
    Height = 56
    Align = alTop
    Anchors = []
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      356
      56)
    object lblDicFoundSeveral: TLabel
      Left = 9
      Top = 4
      Width = 168
      Height = 13
      Caption = #1085#1072#1081#1076#1077#1085#1086' '#1074' '#1085#1077#1089#1082#1086#1083#1100#1082#1080#1093' '#1089#1083#1086#1074#1072#1088#1103#1093':'
    end
    object cbDic: TComboBox
      Left = 3
      Top = 26
      Width = 350
      Height = 21
      Hint = 'Select dictionary to show entry from'
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      PopupMenu = pmEmpty
      TabOrder = 0
      OnChange = cbDicChange
    end
  end
  object pmRef: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = pmRefPopup
    Left = 328
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
  object pmEmpty: TPopupMenu
    Left = 328
    Top = 163
    object miDeteleBibleTab: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
  end
end
