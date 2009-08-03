object CopyrightForm: TCopyrightForm
  Left = 192
  Top = 122
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'CopyrightForm'
  ClientHeight = 362
  ClientWidth = 587
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyPress = TntFormKeyPress
  OnShow = TntFormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Browser: THTMLViewer
    Left = 0
    Top = 0
    Width = 587
    Height = 362
    OnHotSpotClick = BrowserHotSpotClick
    TabOrder = 0
    Align = alClient
    BorderStyle = htFocused
    HistoryMaxCount = 0
    DefFontName = 'Times New Roman'
    DefPreFontName = 'Courier New'
    NoSelect = False
    CharSet = DEFAULT_CHARSET
    PrintMarginLeft = 2.000000000000000000
    PrintMarginRight = 2.000000000000000000
    PrintMarginTop = 2.000000000000000000
    PrintMarginBottom = 2.000000000000000000
    PrintScale = 1.000000000000000000
    htOptions = []
    ExplicitWidth = 585
    ExplicitHeight = 361
  end
end
