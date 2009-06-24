object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 377
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = TntMainMenu1
  OldCreateOrder = False
  OnShow = TntFormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TntSplitter1: TTntSplitter
    Left = 257
    Top = 0
    Width = 2
    Height = 377
    ExplicitLeft = 289
    ExplicitHeight = 600
  end
  object TntPageControl1: TTntPageControl
    Left = 0
    Top = 0
    Width = 257
    Height = 377
    ActivePage = TntTabSheet1
    Align = alLeft
    TabOrder = 0
    object TntTabSheet1: TTntTabSheet
      Caption = 'TntTabSheet1'
    end
    object TntTabSheet2: TTntTabSheet
      Caption = 'TntTabSheet2'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 281
      ExplicitHeight = 534
    end
  end
  object TntPanel1: TTntPanel
    Left = 259
    Top = 0
    Width = 284
    Height = 377
    Align = alClient
    Caption = 'TntPanel1'
    TabOrder = 1
    object TntPanel2: TTntPanel
      Left = 1
      Top = 350
      Width = 282
      Height = 26
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alBottom
      Caption = 'TntPanel2'
      TabOrder = 0
      object TabsFavorite: TTntPageControl
        Left = 1
        Top = 1
        Width = 280
        Height = 24
        ActivePage = TabFavorite1
        Align = alClient
        Style = tsFlatButtons
        TabOrder = 0
        object TabFavorite1: TTntTabSheet
          Caption = 'Module1'
        end
        object TabFavorite2: TTntTabSheet
          Caption = 'Module2'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 240
          ExplicitHeight = 0
        end
        object TabFavorite3: TTntTabSheet
          Caption = 'Module3'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 240
          ExplicitHeight = 0
        end
        object TabFavorite4: TTntTabSheet
          Caption = 'Module4'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 240
          ExplicitHeight = 0
        end
        object TabFavorite5: TTntTabSheet
          Caption = 'Module5'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 240
          ExplicitHeight = 0
        end
        object TabFavorite6: TTntTabSheet
          Caption = 'Module6'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 240
          ExplicitHeight = 0
        end
        object TabFavorite7: TTntTabSheet
          Caption = 'Module7'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 240
          ExplicitHeight = 0
        end
        object TabFavorite8: TTntTabSheet
          Caption = 'Module8'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 240
          ExplicitHeight = 0
        end
        object TabFavorite9: TTntTabSheet
          Caption = 'Module9'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 240
          ExplicitHeight = 0
        end
        object TabFavorite0: TTntTabSheet
          Caption = 'Module0'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 240
          ExplicitHeight = 0
        end
      end
    end
    object TntPageControl2: TTntPageControl
      Left = 1
      Top = 1
      Width = 282
      Height = 349
      ActivePage = TntTabSheet3
      Align = alClient
      TabOrder = 1
      object TntTabSheet3: TTntTabSheet
        Caption = 'TntTabSheet3'
        object HTMLViewer1: THTMLViewer
          Left = 0
          Top = 0
          Width = 274
          Height = 321
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
        end
      end
    end
  end
  object TntMainMenu1: TTntMainMenu
    Left = 408
    Top = 168
    object File1: TTntMenuItem
      Caption = 'File'
      object Open1: TTntMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object COPY1: TTntMenuItem
        Caption = 'COPY'
        OnClick = COPY1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 344
    Top = 488
  end
end
