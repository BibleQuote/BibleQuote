object CommentsFrame: TCommentsFrame
  Left = 0
  Top = 0
  Width = 413
  Height = 386
  TabOrder = 0
  object pnlComments: TPanel
    Left = 0
    Top = 0
    Width = 413
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      413
      30)
    object cbComments: TComboBox
      Left = 1
      Top = 3
      Width = 385
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 25
      TabOrder = 0
      OnChange = cbCommentsChange
      OnCloseUp = cbCommentsCloseUp
      OnDropDown = cbCommentsDropDown
    end
    object btnOnlyMeaningful: TrkGlassButton
      Left = 389
      Top = 4
      Width = 22
      Height = 20
      AltFocus = True
      AltRender = False
      Anchors = [akTop, akRight]
      Color = clWhite
      ColorDown = 15182972
      ColorFocused = clActiveBorder
      ColorFrame = clBlack
      ColorShadow = 15648678
      Down = True
      DropDownAlignment = paLeft
      Flat = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      GlossyLevel = 36
      GlyphPos = gpLeft
      ImageIndex = 40
      LightHeight = 27
      ParentFont = False
      TabOrder = 1
      TextAlign = taLeft
      OnClick = btnOnlyMeaningfulClick
    end
  end
  object bwrComments: THTMLViewer
    Left = 0
    Top = 30
    Width = 413
    Height = 356
    TabOrder = 1
    Align = alClient
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
    OnHotSpotClick = bwrCommentsHotSpotClick
  end
end
