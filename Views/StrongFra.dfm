object StrongFrame: TStrongFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 340
  TabOrder = 0
  object pnlFindStrongNumber: TPanel
    Left = 0
    Top = 181
    Width = 320
    Height = 26
    Cursor = crHandPoint
    Align = alTop
    Anchors = []
    BevelEdges = []
    BevelOuter = bvNone
    Caption = '# search'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial Unicode MS'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = pnlFindStrongNumberClick
    OnMouseDown = pnlFindStrongNumberMouseDown
    OnMouseUp = pnlFindStrongNumberMouseUp
  end
  object pnlStrong: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 181
    Align = alTop
    Anchors = []
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      320
      181)
    object edtStrong: TEdit
      Left = 4
      Top = 4
      Width = 315
      Height = 21
      Hint = 'Strong number to show'
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnKeyPress = edtStrongKeyPress
    end
    object lbStrong: TListBox
      Left = 4
      Top = 32
      Width = 315
      Height = 144
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
      OnDblClick = lbStrongDblClick
    end
  end
  object bwrStrong: THTMLViewer
    AlignWithMargins = True
    Left = 3
    Top = 210
    Width = 314
    Height = 127
    TabOrder = 2
    Align = alClient
    PopupMenu = pmRef
    BorderStyle = htSingle
    CharSet = RUSSIAN_CHARSET
    DefFontName = 'Times New Roman'
    DefPreFontName = 'Courier New'
    HistoryMaxCount = 0
    HtOptions = [htNoLinkUnderline]
    NoSelect = False
    PrintMarginBottom = 2.000000000000000000
    PrintMarginLeft = 2.000000000000000000
    PrintMarginRight = 2.000000000000000000
    PrintMarginTop = 2.000000000000000000
    PrintScale = 1.000000000000000000
    ScrollBars = ssVertical
    OnHotSpotClick = bwrStrongHotSpotClick
    OnMouseDouble = bwrStrongMouseDouble
  end
  object pmRef: TPopupMenu
    AutoHotkeys = maManual
    Left = 292
    Top = 165
    object miRefCopy: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnClick = miRefCopyClick
    end
    object miRefPrint: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1072#1090#1100
      OnClick = miRefPrintClick
    end
  end
end
