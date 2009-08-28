object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1062#1080#1090#1072#1090#1072' '#1080#1079' '#1041#1080#1073#1083#1080#1080
  ClientHeight = 732
  ClientWidth = 973
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial Unicode MS'
  Font.Style = []
  KeyPreview = True
  Menu = theMainMenu
  OldCreateOrder = True
  Position = poDesigned
  ShowHint = True
  OnClose = FormClose
  OnCloseQuery = TntFormCloseQuery
  OnCreate = FormCreate
  OnDeactivate = TntFormDeactivate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 108
  TextHeight = 15
  object Label4: TTntLabel
    Left = 332
    Top = 48
    Width = 33
    Height = 15
    Alignment = taRightJustify
    Caption = 'Ctrl+1'
  end
  object Splitter1: TTntSplitter
    Left = 298
    Top = 27
    Width = 2
    Height = 705
    MinSize = 100
    OnMoved = Splitter1Moved
    ExplicitTop = 23
    ExplicitHeight = 532
  end
  object MainPanel: TTntPanel
    Left = 430
    Top = 27
    Width = 543
    Height = 705
    Align = alRight
    Caption = 'MainPanel'
    TabOrder = 0
    object mBibleTabsEx: TDockTabSet
      Tag = -1
      Left = 1
      Top = 676
      Width = 541
      Height = 28
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      StartMargin = 0
      SoftTop = True
      Style = tsSoftTabs
      TabHeight = 18
      OnChange = mBibleTabsExChange
      OnDragDrop = BibleTabsDragDrop
      OnDragOver = BibleTabsDragOver
      OnMouseDown = mBibleTabsExMouseDown
      OnMouseMove = mBibleTabsExMouseMove
      OnMouseUp = mBibleTabsExMouseUp
      OnStartDrag = mBibleTabsExStartDrag
      DockSite = False
    end
    object mViewTabs: TAlekPageControl
      Left = 1
      Top = 1
      Width = 541
      Height = 675
      Margins.Top = 10
      ActivePage = mInitialViewPage
      Align = alClient
      PopupMenu = mViewTabsPopup
      TabOrder = 0
      OnChange = mViewTabsChange
      OnContextPopup = mInitialViewPageContextPopup
      OnMouseDown = mViewTabsMouseDown
      OnStartDrag = mViewTabsStartDrag
      OnDeleteTab = mViewTabsDeleteTab
      object mInitialViewPage: TTntTabSheet
        PopupMenu = mViewTabsPopup
        OnContextPopup = mInitialViewPageContextPopup
        object FirstBrowser: THTMLViewer
          Left = 0
          Top = -6
          Width = 533
          Height = 511
          OnHotSpotClick = FirstBrowserHotSpotClick
          OnImageRequest = FirstBrowserImageRequest
          TabOrder = 0
          PopupMenu = BrowserPopupMenu
          DefBackground = 14870763
          BorderStyle = htNone
          HistoryMaxCount = 0
          DefFontName = 'Times New Roman'
          DefPreFontName = 'Courier New'
          NoSelect = False
          CharSet = RUSSIAN_CHARSET
          PrintMarginLeft = 2.000000000000000000
          PrintMarginRight = 2.000000000000000000
          PrintMarginTop = 2.000000000000000000
          PrintMarginBottom = 2.000000000000000000
          PrintScale = 1.000000000000000000
          htOptions = []
          OnKeyDown = FirstBrowserKeyDown
          OnKeyUp = FirstBrowserKeyUp
          OnKeyPress = FirstBrowserKeyPress
          OnFileBrowse = FirstBrowserFileBrowse
          OnMouseDouble = FirstBrowserMouseDouble
        end
      end
    end
  end
  object PreviewBox: TTntScrollBox
    Left = 304
    Top = 206
    Width = 97
    Height = 180
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    BorderStyle = bsNone
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    Visible = False
    object ContainPanel: TTntPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 159
      BevelOuter = bvNone
      Color = clBtnShadow
      TabOrder = 0
      object PagePanel: TTntPanel
        Left = 10
        Top = 4
        Width = 70
        Height = 146
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        object PB1: TTntPaintBox
          Left = 0
          Top = 0
          Width = 70
          Height = 146
          Cursor = crArrow
          Align = alClient
          OnMouseDown = PB1MouseDown
          OnPaint = PB1Paint
          ExplicitLeft = -8
          ExplicitTop = 16
        end
      end
    end
  end
  object TRE: TTntRichEdit
    Left = 304
    Top = 69
    Width = 93
    Height = 131
    Lines.Strings = (
      'TRE')
    TabOrder = 2
    Visible = False
  end
  object MainPages: TTntPageControl
    Left = 0
    Top = 27
    Width = 298
    Height = 705
    ActivePage = MemoTab
    Align = alLeft
    Images = theImageList
    PopupMenu = RefPopupMenu
    TabOrder = 3
    OnChange = MainPagesChange
    object GoTab: TTntTabSheet
      ImageIndex = 5
      object Splitter2: TTntSplitter
        Left = 0
        Top = 250
        Width = 290
        Height = 3
        Cursor = crVSplit
        Align = alTop
        Beveled = True
        Color = clBtnFace
        ParentColor = False
        OnMoved = Splitter2Moved
        ExplicitTop = 243
      end
      object Panel2: TTntPanel
        Left = 0
        Top = 0
        Width = 290
        Height = 250
        Align = alTop
        BevelOuter = bvNone
        Constraints.MinHeight = 250
        TabOrder = 0
        object GroupBox1: TTntGroupBox
          Left = 1
          Top = -5
          Width = 288
          Height = 250
          TabOrder = 4
          object HelperButton: TTntButton
            Left = 212
            Top = 12
            Width = 19
            Height = 22
            Caption = '?'
            TabOrder = 0
            OnClick = HelperButtonClick
          end
        end
        object BooksCB: TTntComboBox
          Left = 5
          Top = 34
          Width = 278
          Height = 23
          Style = csDropDownList
          DropDownCount = 25
          ItemHeight = 0
          PopupMenu = EmptyPopupMenu
          TabOrder = 1
          OnChange = BooksCBChange
        end
        object BookLB: TTntListBox
          Left = 6
          Top = 62
          Width = 220
          Height = 177
          Style = lbOwnerDrawVariable
          ItemHeight = 14
          PopupMenu = EmptyPopupMenu
          TabOrder = 2
          OnClick = BookLBClick
        end
        object ChapterLB: TTntListBox
          Left = 232
          Top = 63
          Width = 53
          Height = 178
          ItemHeight = 15
          PopupMenu = EmptyPopupMenu
          TabOrder = 3
          OnClick = ChapterLBClick
        end
        object AddressOKButton: TTntButton
          Left = 232
          Top = 7
          Width = 51
          Height = 22
          Caption = 'OK'
          TabOrder = 5
          OnClick = AddressOKButtonClick
        end
        object GoEdit: TTntEdit
          Left = 6
          Top = 6
          Width = 203
          Height = 23
          PopupMenu = MemoPopupMenu
          TabOrder = 0
          OnChange = GoEditChange
          OnDblClick = GoEditDblClick
          OnKeyPress = GoEditKeyPress
        end
      end
      object HistoryBookmarkPages: TTntPageControl
        Left = 0
        Top = 253
        Width = 290
        Height = 422
        ActivePage = TntTabSheet1
        Align = alClient
        TabOrder = 1
        object HistoryTab: TTntTabSheet
          Caption = 'HistoryTab'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object HistoryLB: TTntListBox
            Left = 0
            Top = 0
            Width = 282
            Height = 392
            Style = lbOwnerDrawVariable
            Align = alClient
            ItemHeight = 14
            PopupMenu = HistoryPopupMenu
            TabOrder = 0
            OnClick = HistoryLBClick
            OnDblClick = HistoryLBDblClick
            OnKeyUp = HistoryLBKeyUp
          end
        end
        object BookmarksTab: TTntTabSheet
          Caption = 'BookmarksTab'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object BookmarksLB: TTntListBox
            Left = 0
            Top = 0
            Width = 282
            Height = 281
            Style = lbOwnerDrawVariable
            Align = alClient
            ItemHeight = 14
            PopupMenu = HistoryPopupMenu
            TabOrder = 0
            OnClick = BookmarksLBClick
            OnDblClick = BookmarksLBDblClick
            OnKeyUp = BookmarksLBKeyUp
          end
          object BookmarkPanel: TTntPanel
            Left = 0
            Top = 281
            Width = 282
            Height = 111
            Align = alBottom
            BevelOuter = bvNone
            BorderWidth = 10
            TabOrder = 1
            object BookmarkLabel: TTntLabel
              Left = 10
              Top = 10
              Width = 87
              Height = 15
              Align = alClient
              Caption = 'BookmarkLabel'
              WordWrap = True
            end
          end
        end
        object TntTabSheet1: TTntTabSheet
          Caption = #1041#1099#1089#1090#1088#1099#1081' '#1087#1086#1080#1089#1082
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object SearchInWindowLabel: TTntLabel
            Left = 0
            Top = 0
            Width = 104
            Height = 15
            Align = alTop
            Caption = #1053#1072#1081#1090#1080' '#1074' '#1101#1090#1086#1084' '#1086#1082#1085#1077
            Layout = tlCenter
          end
          object QuickSearchPanel: TTntPanel
            Left = 0
            Top = 15
            Width = 282
            Height = 106
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            DesignSize = (
              282
              106)
            object TntBitBtn1: TTntBitBtn
              Left = 4
              Top = 16
              Width = 28
              Height = 25
              Caption = '<'
              TabOrder = 0
              OnClick = SearchBackwardClick
              Style = bsNew
            end
            object SearchEdit: TTntEdit
              Left = 38
              Top = 17
              Width = 207
              Height = 23
              Hint = ' '
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              OnKeyUp = SearchEditKeyUp
            end
            object SearchForward: TTntBitBtn
              Left = 251
              Top = 16
              Width = 28
              Height = 25
              Anchors = [akTop, akRight]
              Caption = '>'
              TabOrder = 2
              OnClick = SearchForwardClick
              Style = bsNew
            end
          end
        end
      end
    end
    object SearchTab: TTntTabSheet
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SearchBrowser: THTMLViewer
        Left = 0
        Top = 179
        Width = 290
        Height = 496
        OnHotSpotClick = SearchBrowserHotSpotClick
        TabOrder = 0
        Align = alClient
        PopupMenu = RefPopupMenu
        BorderStyle = htSingle
        HistoryMaxCount = 0
        DefFontName = 'Times New Roman'
        DefPreFontName = 'Courier New'
        NoSelect = False
        CharSet = RUSSIAN_CHARSET
        PrintMarginLeft = 2.000000000000000000
        PrintMarginRight = 2.000000000000000000
        PrintMarginTop = 2.000000000000000000
        PrintMarginBottom = 2.000000000000000000
        PrintScale = 1.000000000000000000
        htOptions = []
        OnKeyDown = SearchBrowserKeyDown
        OnKeyUp = SearchBrowserKeyUp
      end
      object SearchBoxPanel: TTntPanel
        Left = 0
        Top = 0
        Width = 290
        Height = 179
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object SearchLabel: TTntLabel
          Left = 4
          Top = 158
          Width = 70
          Height = 15
          Caption = 'SearchLabel'
        end
        object SearchCB: TTntComboBox
          Left = 3
          Top = 3
          Width = 210
          Height = 23
          DropDownCount = 10
          ItemHeight = 0
          PopupMenu = MemoPopupMenu
          TabOrder = 0
        end
        object CBList: TTntComboBox
          Left = 24
          Top = 30
          Width = 189
          Height = 22
          Style = csOwnerDrawVariable
          DropDownCount = 15
          ItemHeight = 16
          TabOrder = 1
          Items.Strings = (
            #1042#1089#1077' '#1082#1085#1080#1075#1080
            #1053#1077' '#1074#1089#1077' '#1082#1085#1080#1075#1080)
        end
        object FindButton: TTntButton
          Left = 217
          Top = 29
          Width = 69
          Height = 22
          Caption = #1053#1072#1081#1090#1080
          TabOrder = 2
          OnClick = FindButtonClick
        end
        object CBAll: TTntCheckBox
          Left = 4
          Top = 56
          Width = 265
          Height = 17
          Caption = #1083#1102#1073#1086#1077' '#1080#1079' '#1089#1083#1086#1074
          TabOrder = 3
        end
        object CBPhrase: TTntCheckBox
          Left = 4
          Top = 76
          Width = 265
          Height = 17
          Caption = #1089#1086#1073#1083#1102#1076#1072#1090#1100' '#1087#1086#1088#1103#1076#1086#1082' '#1089#1083#1086#1074
          TabOrder = 4
        end
        object CBParts: TTntCheckBox
          Left = 4
          Top = 116
          Width = 265
          Height = 17
          Caption = #1080#1097#1077#1084' '#1089#1083#1086#1074#1072' '#1094#1077#1083#1080#1082#1086#1084
          TabOrder = 6
        end
        object CBCase: TTntCheckBox
          Left = 4
          Top = 136
          Width = 265
          Height = 17
          Caption = #1088#1072#1079#1083#1080#1095#1072#1090#1100' '#1088#1077#1075#1080#1089#1090#1088#1099
          TabOrder = 7
        end
        object CBExactPhrase: TTntCheckBox
          Left = 4
          Top = 96
          Width = 265
          Height = 17
          Caption = #1080#1097#1077#1084' '#1090#1086#1095#1085#1091#1102' '#1092#1088#1072#1079#1091
          TabOrder = 5
          OnClick = CBExactPhraseClick
        end
        object CBQty: TTntComboBox
          Left = 217
          Top = 2
          Width = 71
          Height = 23
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 8
          OnChange = CBQtyChange
          Items.Strings = (
            '50'
            '100'
            '200'
            '300'
            '*')
        end
        object SearchOptionsButton: TTntButton
          Left = 4
          Top = 31
          Width = 18
          Height = 22
          Caption = '<'
          TabOrder = 9
          OnClick = SearchOptionsButtonClick
        end
      end
    end
    object DicTab: TTntTabSheet
      ImageIndex = 17
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DicBrowser: THTMLViewer
        Left = 0
        Top = 232
        Width = 290
        Height = 443
        OnHotSpotClick = DicBrowserHotSpotClick
        TabOrder = 0
        Align = alClient
        PopupMenu = RefPopupMenu
        BorderStyle = htSingle
        HistoryMaxCount = 0
        DefFontName = 'Times New Roman'
        DefPreFontName = 'Courier New'
        NoSelect = False
        ScrollBars = ssVertical
        CharSet = RUSSIAN_CHARSET
        PrintMarginLeft = 2.000000000000000000
        PrintMarginRight = 2.000000000000000000
        PrintMarginTop = 2.000000000000000000
        PrintMarginBottom = 2.000000000000000000
        PrintScale = 1.000000000000000000
        htOptions = []
        OnMouseDouble = DicBrowserMouseDouble
      end
      object DicPanel: TTntPanel
        Left = 0
        Top = 0
        Width = 290
        Height = 178
        Align = alTop
        TabOrder = 1
        object DicLB: TTntListBox
          Left = 5
          Top = 57
          Width = 278
          Height = 116
          ItemHeight = 15
          PopupMenu = EmptyPopupMenu
          TabOrder = 0
          OnDblClick = DicLBDblClick
          OnKeyPress = DicLBKeyPress
        end
        object DicFilterCB: TTntComboBox
          Left = 5
          Top = 6
          Width = 279
          Height = 23
          Style = csDropDownList
          ItemHeight = 0
          PopupMenu = EmptyPopupMenu
          TabOrder = 1
          OnChange = DicFilterCBChange
        end
        object DicEdit: TTntComboBox
          Left = 5
          Top = 31
          Width = 279
          Height = 23
          ItemHeight = 0
          TabOrder = 2
          OnChange = DicEditChange
          OnKeyPress = DicEditKeyPress
          OnKeyUp = DicEditKeyUp
        end
      end
      object DicCBPanel: TTntPanel
        Left = 0
        Top = 178
        Width = 290
        Height = 54
        Align = alTop
        TabOrder = 2
        object DicFoundSeveral: TTntLabel
          Left = 8
          Top = 5
          Width = 184
          Height = 15
          Caption = #1085#1072#1081#1076#1077#1085#1086' '#1074' '#1085#1077#1089#1082#1086#1083#1100#1082#1080#1093' '#1089#1083#1086#1074#1072#1088#1103#1093':'
        end
        object DicCB: TTntComboBox
          Left = 5
          Top = 25
          Width = 279
          Height = 23
          Style = csDropDownList
          ItemHeight = 0
          PopupMenu = EmptyPopupMenu
          TabOrder = 0
          OnChange = DicCBChange
        end
      end
    end
    object StrongTab: TTntTabSheet
      ImageIndex = 18
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object StrongBrowser: THTMLViewer
        Left = 0
        Top = 206
        Width = 290
        Height = 469
        OnHotSpotClick = StrongBrowserHotSpotClick
        TabOrder = 0
        Align = alClient
        PopupMenu = RefPopupMenu
        BorderStyle = htSingle
        HistoryMaxCount = 0
        DefFontName = 'Times New Roman'
        DefPreFontName = 'Courier New'
        NoSelect = False
        ScrollBars = ssVertical
        CharSet = RUSSIAN_CHARSET
        PrintMarginLeft = 2.000000000000000000
        PrintMarginRight = 2.000000000000000000
        PrintMarginTop = 2.000000000000000000
        PrintMarginBottom = 2.000000000000000000
        PrintScale = 1.000000000000000000
        htOptions = [htNoLinkUnderline]
        OnMouseDouble = StrongBrowserMouseDouble
      end
      object StrongPanel: TTntPanel
        Left = 0
        Top = 0
        Width = 290
        Height = 181
        Align = alTop
        TabOrder = 1
        object StrongEdit: TTntEdit
          Left = 5
          Top = 5
          Width = 279
          Height = 23
          PopupMenu = MemoPopupMenu
          TabOrder = 0
          OnKeyPress = StrongEditKeyPress
        end
        object StrongLB: TTntListBox
          Left = 5
          Top = 32
          Width = 279
          Height = 143
          ItemHeight = 15
          PopupMenu = EmptyPopupMenu
          TabOrder = 1
          OnDblClick = StrongLBDblClick
        end
      end
      object FindStrongNumberPanel: TTntPanel
        Left = 0
        Top = 181
        Width = 290
        Height = 25
        Align = alTop
        Caption = #1053#1072#1081#1090#1080' '#1074' '#1041#1080#1073#1083#1080#1080
        TabOrder = 2
        OnClick = FindStrongNumberPanelClick
        OnMouseDown = FindStrongNumberPanelMouseDown
        OnMouseUp = FindStrongNumberPanelMouseUp
      end
    end
    object CommentsTab: TTntTabSheet
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object CommentsBrowser: THTMLViewer
        Left = 0
        Top = 30
        Width = 290
        Height = 645
        OnHotSpotClick = CommentsBrowserHotSpotClick
        TabOrder = 0
        Align = alClient
        PopupMenu = RefPopupMenu
        BorderStyle = htSingle
        HistoryMaxCount = 0
        DefFontName = 'Times New Roman'
        DefPreFontName = 'Courier New'
        NoSelect = False
        CharSet = RUSSIAN_CHARSET
        PrintMarginLeft = 2.000000000000000000
        PrintMarginRight = 2.000000000000000000
        PrintMarginTop = 2.000000000000000000
        PrintMarginBottom = 2.000000000000000000
        PrintScale = 1.000000000000000000
        htOptions = []
      end
      object Panel4: TTntPanel
        Left = 0
        Top = 0
        Width = 290
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object CommentsCB: TTntComboBox
          Left = 2
          Top = 3
          Width = 285
          Height = 23
          Style = csDropDownList
          DropDownCount = 25
          ItemHeight = 0
          PopupMenu = EmptyPopupMenu
          TabOrder = 0
          OnChange = CommentsCBChange
        end
      end
    end
    object XRefTab: TTntTabSheet
      ImageIndex = 19
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object XRefBrowser: THTMLViewer
        Left = 0
        Top = 0
        Width = 290
        Height = 675
        OnHotSpotClick = XRefBrowserHotSpotClick
        TabOrder = 0
        Align = alClient
        PopupMenu = RefPopupMenu
        BorderStyle = htSingle
        HistoryMaxCount = 0
        DefFontName = 'Times New Roman'
        DefPreFontName = 'Courier New'
        NoSelect = False
        CharSet = RUSSIAN_CHARSET
        PrintMarginLeft = 2.000000000000000000
        PrintMarginRight = 2.000000000000000000
        PrintMarginTop = 2.000000000000000000
        PrintMarginBottom = 2.000000000000000000
        PrintScale = 1.000000000000000000
        htOptions = []
      end
    end
    object MemoTab: TTntTabSheet
      ImageIndex = 2
      object TREMemo: TTntRichEdit
        Left = 0
        Top = 27
        Width = 290
        Height = 623
        Align = alClient
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        PopupMenu = MemoPopupMenu
        ScrollBars = ssVertical
        TabOrder = 0
        OnChange = TREMemoChange
      end
      object Panel3: TTntPanel
        Left = 0
        Top = 0
        Width = 290
        Height = 27
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object MemoLabel: TTntLabel
          Left = 5
          Top = 4
          Width = 12
          Height = 15
          Caption = '....'
        end
      end
      object TntToolBar1: TTntToolBar
        AlignWithMargins = True
        Left = 2
        Top = 652
        Width = 285
        Height = 23
        Margins.Left = 2
        Margins.Top = 2
        Margins.Bottom = 0
        Align = alBottom
        Images = theImageList
        TabOrder = 2
        object MemoOpen: TTntToolButton
          Left = 0
          Top = 0
          Caption = 'MemoOpen'
          ImageIndex = 9
          OnClick = MemoOpenClick
        end
        object MemoSave: TTntToolButton
          Left = 23
          Top = 0
          Caption = 'MemoSave'
          ImageIndex = 10
          OnClick = MemoSaveClick
        end
        object MemoPrint: TTntToolButton
          Left = 46
          Top = 0
          Caption = 'MemoPrint'
          ImageIndex = 11
          OnClick = MemoPrintClick
        end
        object Sep21: TTntToolButton
          Left = 69
          Top = 0
          Width = 6
          Style = tbsSeparator
        end
        object MemoFont: TTntToolButton
          Left = 75
          Top = 0
          Caption = 'MemoFont'
          ImageIndex = 20
          OnClick = MemoFontClick
        end
        object Sep22: TTntToolButton
          Left = 98
          Top = 0
          Width = 6
          Style = tbsSeparator
        end
        object MemoBold: TTntToolButton
          Left = 104
          Top = 0
          Caption = 'MemoBold'
          ImageIndex = 21
          OnClick = MemoBoldClick
        end
        object MemoItalic: TTntToolButton
          Left = 127
          Top = 0
          Caption = 'MemoItalic'
          ImageIndex = 22
          OnClick = MemoItalicClick
        end
        object MemoUnderline: TTntToolButton
          Left = 150
          Top = 0
          Caption = 'MemoUnderline'
          ImageIndex = 23
          OnClick = MemoUnderlineClick
        end
        object Sep23: TTntToolButton
          Left = 173
          Top = 0
          Width = 6
          Style = tbsSeparator
        end
        object MemoPainter: TTntToolButton
          Left = 179
          Top = 0
          Caption = 'MemoPainter'
          ImageIndex = 24
          OnClick = MemoPainterClick
        end
      end
    end
  end
  object ToolbarPanel: TAlekPanel
    Left = 0
    Top = 0
    Width = 973
    Height = 27
    Align = alTop
    AutoSize = True
    BevelEdges = [beBottom]
    ParentBackground = False
    TabOrder = 4
    GradientDirection = gdVertical
    GradientStartColor = clWindow
    GradientEndColor = clBtnFace
    object lbTitleLabel: TTntLabel
      Left = 568
      Top = 1
      Width = 337
      Height = 25
      Margins.Right = 7
      Align = alClient
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lbTitleLabel'
      Transparent = True
      Layout = tlCenter
      ExplicitTop = 2
      ExplicitWidth = 200
      ExplicitHeight = 24
    end
    object lbCopyRightNotice: TTntLabel
      AlignWithMargins = True
      Left = 908
      Top = 4
      Width = 57
      Height = 19
      Margins.Right = 7
      Align = alRight
      Alignment = taRightJustify
      Caption = 'CopyRight'
      Transparent = True
      Layout = tlCenter
      ExplicitHeight = 15
    end
    object MainToolbar: TTntToolBar
      Left = 1
      Top = 1
      Width = 408
      Height = 25
      Margins.Top = 2
      Margins.Bottom = 0
      Align = alLeft
      AutoSize = True
      ButtonWidth = 24
      DrawingStyle = dsGradient
      GradientEndColor = clBtnFace
      Images = theImageList
      List = True
      AllowTextButtons = True
      TabOrder = 0
      object ToggleButton: TTntToolButton
        Left = 0
        Top = 0
        Caption = 'Toggle'
        ImageIndex = 16
        OnClick = ToggleButtonClick
      end
      object Sep01: TTntToolButton
        Left = 24
        Top = 0
        Width = 6
        Style = tbsSeparator
      end
      object NewTabButton: TTntToolButton
        Left = 30
        Top = 0
        Caption = 'NewTabButton'
        ImageIndex = 30
        OnClick = miNewTabClick
      end
      object CloseTabButton: TTntToolButton
        Left = 54
        Top = 0
        Caption = 'CloseTabButton'
        ImageIndex = 31
        OnClick = miCloseTabClick
      end
      object Sep06: TTntToolButton
        Left = 78
        Top = 0
        Width = 6
        Style = tbsSeparator
      end
      object BackButton: TTntToolButton
        Left = 84
        Top = 0
        Caption = 'Back'
        ImageIndex = 4
        OnClick = BackButtonClick
      end
      object ForwardButton: TTntToolButton
        Left = 108
        Top = 0
        Caption = 'Forward'
        ImageIndex = 6
        OnClick = ForwardButtonClick
      end
      object Sep02: TTntToolButton
        Left = 132
        Top = 0
        Width = 6
        Style = tbsSeparator
      end
      object PrevChapterButton: TTntToolButton
        Left = 138
        Top = 0
        Caption = 'Minus'
        ImageIndex = 26
        OnClick = PrevChapterButtonClick
      end
      object NextChapterButton: TTntToolButton
        Left = 162
        Top = 0
        Caption = 'Plus'
        ImageIndex = 25
        OnClick = NextChapterButtonClick
      end
      object Sep03: TTntToolButton
        Left = 186
        Top = 0
        Width = 6
        Style = tbsSeparator
      end
      object CopyButton: TTntToolButton
        Left = 192
        Top = 0
        Caption = 'Copy'
        ImageIndex = 15
        OnClick = CopyButtonClick
      end
      object StrongNumbersButton: TTntToolButton
        Left = 216
        Top = 0
        Caption = 'Strong'
        ImageIndex = 18
        OnClick = miStrongClick
      end
      object MemosButton: TTntToolButton
        Left = 240
        Top = 0
        Caption = 'Memos'
        ImageIndex = 29
        OnClick = miMemosToggleClick
      end
      object Sep04: TTntToolButton
        Left = 264
        Top = 0
        Width = 6
        Style = tbsSeparator
      end
      object PreviewButton: TTntToolButton
        Left = 270
        Top = 0
        Caption = 'Preview'
        ImageIndex = 12
      end
      object PrintButton: TTntToolButton
        Left = 294
        Top = 0
        Caption = 'Print'
        ImageIndex = 11
      end
      object Sep05: TTntToolButton
        Left = 318
        Top = 0
        Width = 6
        Style = tbsSeparator
      end
      object SoundButton: TTntToolButton
        Left = 324
        Top = 0
        Caption = 'Sound'
        ImageIndex = 14
        OnClick = SoundButtonClick
      end
      object CopyrightButton: TTntToolButton
        Left = 348
        Top = 0
        Caption = 'Copyright'
        ImageIndex = 32
        OnClick = CopyrightButtonClick
      end
      object SatelliteButton: TTntToolButton
        Left = 372
        Top = 0
        Caption = 'Satellite'
        ImageIndex = 3
        OnClick = SatelliteButtonClick
      end
      object tbbMainPanelLastSeparator: TTntToolButton
        Left = 396
        Top = 0
        Width = 12
        Caption = 'tbbMainPanelLastSeparator'
        Style = tbsSeparator
        Visible = False
      end
    end
    object tbLinksToolBar: TTntToolBar
      Left = 409
      Top = 1
      Width = 159
      Height = 25
      Margins.Top = 2
      Margins.Bottom = 0
      Align = alLeft
      ButtonHeight = 23
      ButtonWidth = 24
      Caption = '44444'
      DrawingStyle = dsGradient
      List = True
      ShowCaptions = True
      TabOrder = 1
      Visible = False
      object LinksCB: TTntComboBox
        Left = 0
        Top = 0
        Width = 159
        Height = 23
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alLeft
        Style = csDropDownList
        ItemHeight = 15
        TabOrder = 0
        OnChange = LinksCBChange
      end
    end
  end
  object OpenDialog1: TTntOpenDialog
    Left = 633
    Top = 265
  end
  object SaveFileDialog: TTntSaveDialog
    InitialDir = 'c:\'
    Options = [ofOverwritePrompt, ofHideReadOnly]
    Left = 633
    Top = 321
  end
  object BrowserPopupMenu: TTntPopupMenu
    AutoHotkeys = maManual
    OnPopup = BrowserPopupMenuPopup
    Left = 403
    Top = 97
    object miSearchWord: TTntMenuItem
      Caption = 'miSearchWord'
      OnClick = miSearchWordClick
    end
    object miSearchWindow: TTntMenuItem
      Caption = 'miSearchWindow'
      OnClick = miSearchWindowClick
    end
    object miCompare: TTntMenuItem
      Caption = 'miCompare'
      OnClick = miCompareClick
    end
    object N3: TTntMenuItem
      Caption = '-'
    end
    object miCopySelection: TTntMenuItem
      Caption = 'miCopySelection'
      ShortCut = 16451
      OnClick = CopyButtonClick
    end
    object miCopyPassage: TTntMenuItem
      Caption = 'miCopyPassage'
      OnClick = miCopyPassageClick
    end
    object miCopyVerse: TTntMenuItem
      Caption = 'miCopyVerse'
      OnClick = miCopyVerseClick
    end
    object N2: TTntMenuItem
      Caption = '-'
    end
    object miAddBookmark: TTntMenuItem
      Caption = 'miAddBookmark'
      OnClick = miAddBookmarkClick
    end
    object miAddMemo: TTntMenuItem
      Caption = 'miAddMemo'
      OnClick = miAddMemoClick
    end
    object N4: TTntMenuItem
      Caption = '-'
    end
    object miMemosToggle: TTntMenuItem
      Caption = 'miMemosToggle'
      ShortCut = 16461
      OnClick = miMemosToggleClick
    end
  end
  object PrintDialog1: TPrintDialog
    FromPage = 1
    MinPage = 1
    MaxPage = 9999
    Options = [poPageNums]
    ToPage = 1
    Left = 496
    Top = 296
  end
  object ColorDialog1: TColorDialog
    Left = 555
    Top = 212
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 595
    Top = 348
  end
  object RefPopupMenu: TTntPopupMenu
    AutoHotkeys = maManual
    Left = 405
    Top = 269
    object miRefCopy: TTntMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnClick = miRefCopyClick
    end
    object miRefPrint: TTntMenuItem
      Caption = #1055#1077#1095#1072#1090#1072#1090#1100
      OnClick = miRefPrintClick
    end
  end
  object MemoPopupMenu: TTntPopupMenu
    AutoHotkeys = maManual
    Left = 405
    Top = 229
    object miMemoCopy: TTntMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      ShortCut = 16451
      OnClick = miMemoCopyClick
    end
    object miMemoCut: TTntMenuItem
      Caption = #1042#1099#1088#1077#1079#1072#1090#1100
      ShortCut = 16472
      OnClick = miMemoCutClick
    end
    object miMemoPaste: TTntMenuItem
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      ShortCut = 16470
      OnClick = miMemoPasteClick
    end
  end
  object HistoryPopupMenu: TTntPopupMenu
    Left = 404
    Top = 337
  end
  object EmptyPopupMenu: TTntPopupMenu
    Left = 412
    Top = 395
    object miDeteleBibleTab: TTntMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = miDeteleBibleTabClick
    end
  end
  object TrayIcon: TCoolTrayIcon
    CycleInterval = 0
    Icon.Data = {
      0000010001002020100000000000E80200001600000028000000200000004000
      0000010004000000000080020000000000000000000000000000000000000000
      000000008000008000000080800080000000800080008080000080808000C0C0
      C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      0000000000000700000000000000000000000000007755700000000000000000
      0000000075577557000000000000000000000077775777557000000000000000
      00007775788777755700000000000000000755778FF757775570000000000000
      0557778F88755777755700000000007777578888775555777755700000000775
      788888775555555777755700000075778FF87755555555557777557000005558
      F8755555555555555777755700005577775555BB555555555577775570005557
      55555BBBB55555555557777557005555555555BBBB5555555555777755707555
      5555555BBBB55555555557777555775555555555BBBB55555555557777550775
      555555555BBBB55555B55557777700775555555555BBBB55BBBB555577700007
      75555555555BBBBBBBBB555557700000775555555555BBBBBBB5555555700000
      077555555555BBBBB5555555555500000077555555BBBBBBBB55555555550000
      000775555BBBBB5BBBB55555555500000000775555BB5555BBBB555555570000
      00000775555555555BB555555770000000000077555555555555555770000000
      0000000775555555555557700000000000000000775555555557700000000000
      0000000007755555577000000000000000000000007755577000000000000000
      000000000007757000000000000000000000000000000000000000000000FFFF
      BFFFFFFC1FFFFFF00FFFFFC007FFFF0003FFFE0001FFF80000FFC000007F8000
      003F0000001F0000000F00000007000000030000000100000000000000008000
      0000C0000001E0000001F0000001F8000000FC000000FE000000FF000000FF80
      0001FFC00007FFE0001FFFF0007FFFF801FFFFFC07FFFFFE1FFFFFFFFFFF}
    IconIndex = 0
    OnClick = TrayIconClick
    Left = 336
    Top = 472
  end
  object SatelliteMenu: TTntPopupMenu
    AutoHotkeys = maManual
    Left = 405
    Top = 160
  end
  object theMainMenu: TTntMainMenu
    AutoHotkeys = maManual
    Images = theImageList
    Left = 408
    Top = 32
    object miFile: TTntMenuItem
      Caption = #1060#1072#1081#1083
      object miPrint: TTntMenuItem
        Caption = #1055#1077#1095#1072#1090#1100
        ImageIndex = 11
        ShortCut = 122
      end
      object miPrintPreview: TTntMenuItem
        Caption = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088
        ImageIndex = 12
        ShortCut = 16506
        OnClick = miPrintPreviewClick
      end
      object miSave: TTntMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082'...'
        ImageIndex = 10
        ShortCut = 123
        OnClick = SaveButtonClick
      end
      object miOpen: TTntMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100'...'
        ImageIndex = 9
        ShortCut = 16507
        OnClick = OpenButtonClick
      end
      object N11: TTntMenuItem
        Caption = '-'
      end
      object miOptions: TTntMenuItem
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
        ShortCut = 115
        OnClick = miOptionsClick
      end
      object miFonts: TTntMenuItem
        Caption = #1064#1088#1080#1092#1090
        object miFontConfig: TTntMenuItem
          Caption = #1064#1088#1080#1092#1090' '#1075#1083#1072#1074#1085#1086#1075#1086' '#1086#1082#1085#1072
          OnClick = miFontConfigClick
        end
        object miRefFontConfig: TTntMenuItem
          Caption = #1064#1088#1080#1092#1090' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
          OnClick = miRefFontConfigClick
        end
        object miDialogFontConfig: TTntMenuItem
          Caption = #1064#1088#1080#1092#1090' '#1076#1080#1072#1083#1086#1075#1086#1074#1099#1093' '#1086#1082#1086#1085
          OnClick = miDialogFontConfigClick
        end
      end
      object miColors: TTntMenuItem
        Caption = #1062#1074#1077#1090
        object miBGConfig: TTntMenuItem
          Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072' '#1086#1082#1086#1085
          OnClick = miBGConfigClick
        end
        object miHrefConfig: TTntMenuItem
          Caption = #1062#1074#1077#1090' '#1075#1080#1087#1077#1088#1089#1089#1099#1083#1086#1082
          OnClick = miHrefConfigClick
        end
        object miFoundTextConfig: TTntMenuItem
          Caption = #1062#1074#1077#1090' '#1085#1072#1081#1076#1077#1085#1085#1086#1075#1086' '#1090#1077#1082#1089#1090#1072' '#1080' '#1079#1072#1084#1077#1090#1086#1082
          OnClick = miFoundTextConfigClick
        end
      end
      object N1: TTntMenuItem
        Caption = '-'
      end
      object miNewTab: TTntMenuItem
        Caption = #1053#1086#1074#1086#1077' '#1086#1082#1085#1086
        ShortCut = 16468
        OnClick = miNewTabClick
      end
      object miCloseTab: TTntMenuItem
        Caption = #1047#1072#1082#1088#1099#1090#1100' '#1086#1082#1085#1086
        ShortCut = 16471
        OnClick = miCloseTabClick
      end
      object N15: TTntMenuItem
        Caption = '-'
      end
      object miExit: TTntMenuItem
        Caption = #1042#1099#1093#1086#1076
        ShortCut = 32883
        OnClick = miExitClick
      end
    end
    object miActions: TTntMenuItem
      Caption = #1054#1087#1077#1088#1072#1094#1080#1080
      object miToggle: TTntMenuItem
        Caption = #1042#1082#1083'/'#1074#1099#1082#1083#1102#1095#1080#1090#1100' '#1083#1077#1074#1091#1102' '#1087#1072#1085#1077#1083#1100
        ImageIndex = 16
        ShortCut = 16496
        OnClick = ToggleButtonClick
      end
      object miOpenPassage: TTntMenuItem
        Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1086#1090#1088#1099#1074#1086#1082
        ImageIndex = 5
        ShortCut = 113
        OnClick = GoButtonClick
      end
      object miQuickNav: TTntMenuItem
        Caption = #1041#1099#1089#1090#1088#1086#1077' '#1086#1090#1082#1088#1099#1090#1080#1077' '#1086#1090#1088#1099#1074#1082#1072
        ShortCut = 16497
        OnClick = miQuickNavClick
      end
      object miSearch: TTntMenuItem
        Caption = #1055#1086#1080#1089#1082'...'
        ImageIndex = 1
        ShortCut = 114
        OnClick = SearchButtonClick
      end
      object miQuickSearch: TTntMenuItem
        Caption = #1041#1099#1089#1090#1088#1086#1077' '#1086#1090#1082#1088#1099#1090#1080#1077' '#1087#1086#1080#1089#1082#1072
        ShortCut = 16498
        OnClick = miQuickSearchClick
      end
      object miDic: TTntMenuItem
        Caption = #1057#1083#1086#1074#1072#1088#1080
        ImageIndex = 17
        ShortCut = 115
        OnClick = miDicClick
      end
      object miStrong: TTntMenuItem
        Caption = #1053#1086#1084#1077#1088#1072' '#1057#1090#1088#1086#1085#1075#1072
        ImageIndex = 18
        ShortCut = 116
        OnClick = miStrongClick
      end
      object miComments: TTntMenuItem
        Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080
        ImageIndex = 0
        ShortCut = 117
        OnClick = miCommentsClick
      end
      object miXref: TTntMenuItem
        Caption = #1055#1072#1088#1072#1083#1083#1077#1083#1100#1085#1099#1077' '#1084#1077#1089#1090#1072
        ImageIndex = 19
        ShortCut = 118
        OnClick = miXrefClick
      end
      object miNotepad: TTntMenuItem
        Caption = #1047#1072#1084#1077#1090#1082#1080' '#1082' '#1089#1090#1080#1093#1072#1084
        ImageIndex = 2
        ShortCut = 119
        OnClick = miNotepadClick
      end
      object N19: TTntMenuItem
        Caption = '-'
      end
      object miCopy: TTntMenuItem
        Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1081' '#1090#1077#1082#1089#1090
        ImageIndex = 15
        ShortCut = 16500
        OnClick = CopyButtonClick
      end
      object miCopyOptions: TTntMenuItem
        Caption = #1054#1087#1094#1080#1080' '#1082#1086#1087#1080#1088#1086#1074#1072#1085#1080#1103
        ShortCut = 8308
        OnClick = miCopyOptionsClick
      end
      object N22: TTntMenuItem
        Caption = '-'
      end
      object miSound: TTntMenuItem
        Caption = #1055#1088#1086#1089#1083#1091#1096#1072#1090#1100' '#1079#1072#1087#1080#1089#1100' ('#1077#1089#1083#1080' '#1077#1089#1090#1100')'
        ImageIndex = 14
        ShortCut = 16505
        OnClick = SoundButtonClick
      end
    end
    object miFavorites: TTntMenuItem
      Tag = 3333
      Caption = #1051#1102#1073#1080#1084#1099#1077' '#1084#1086#1076#1091#1083#1080
      object miHotKey: TTntMenuItem
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1083#1102#1073#1080#1084#1099#1077' '#1084#1086#1076#1091#1083#1080'...'
        ShortCut = 120
        OnClick = miHotkeyClick
      end
      object s: TTntMenuItem
        Caption = '-'
      end
    end
    object miHelpMenu: TTntMenuItem
      Caption = #1055#1086#1084#1086#1097#1100
      object miHelp: TTntMenuItem
        Caption = #1050#1072#1082' '#1088#1072#1073#1086#1090#1072#1090#1100' '#1089' "'#1062#1080#1090#1072#1090#1086#1081'"'
        ShortCut = 112
        OnClick = miHelpClick
      end
      object miAbout: TTntMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = miAboutClick
      end
    end
    object miLanguage: TTntMenuItem
      Caption = 'Do you speak...'
    end
    object miWebSites: TTntMenuItem
      Caption = 'JesusChrist.ru'
      object miTechnoForum: TTntMenuItem
        Caption = #1054#1073#1089#1091#1078#1076#1077#1085#1080#1077' 6-'#1081' '#1074#1077#1088#1089#1080#1080' "'#1062#1080#1090#1072#1090#1099'"'
        OnClick = JCRU_HomeClick
      end
      object JCRU_Home: TTntMenuItem
        Caption = 'JesusChrist.ru'
        OnClick = JCRU_HomeClick
      end
      object JCRU_Software: TTntMenuItem
        Caption = 'JesusChrist.ru Software'
        OnClick = JCRU_HomeClick
      end
      object JCRU_Bible: TTntMenuItem
        Caption = 'JesusChrist.ru Bible'
        OnClick = JCRU_HomeClick
      end
      object N6: TTntMenuItem
        Caption = '-'
      end
      object JCRU_News: TTntMenuItem
        Caption = 'JesusChrist.ru News'
        OnClick = JCRU_HomeClick
      end
      object JCRU_Forum: TTntMenuItem
        Caption = 'JesusChrist.ru Forum'
        OnClick = JCRU_HomeClick
      end
      object JCRU_Chat: TTntMenuItem
        Caption = 'JesusChrist.ru Chat'
        OnClick = JCRU_HomeClick
      end
      object JCRU_Library: TTntMenuItem
        Caption = 'JesusChrist.ru Library'
        OnClick = JCRU_HomeClick
      end
      object JCRU_Docs: TTntMenuItem
        Caption = 'JesusChrist.ru Docs'
        OnClick = JCRU_HomeClick
      end
      object N8: TTntMenuItem
        Caption = '-'
      end
      object JCRU_Mail: TTntMenuItem
        Caption = 'JesusChrist.ru Mail'
        OnClick = JCRU_HomeClick
      end
    end
  end
  object theImageList: TImageList
    Left = 360
    Top = 432
    Bitmap = {
      494C010121002200040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000009000000001002000000000000090
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7F1EC00E2CEBB00DAC0A800D6B99E00DEC7B200F3EAE2000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DAC0A800BE8F6500D6B99E00DEC7B200E2CEBB00DAC0A800C2966E00D2B2
      9500FBF8F5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6B9
      9E00CAA48100F7F1EC0000000000FBF8F500EFE3D800F3EAE200FBF8F500D2B2
      9500CAA48100FBF8F50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EBDCCF00C296
      6E00FBF8F500F3EAE200CEAB8B00BE8F6500C2966E00BE8F6500C2966E000000
      0000CEAB8B00DAC0A80000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CAA48100E7D5
      C500FBF8F500C69D7800BE8F6500E7D5C50000000000EBDCCF00BE8F65000000
      0000F7F1EC00BE8F6500FBF8F500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BE8F65000000
      0000EBDCCF00BE8F6500CAA481000000000000000000F7F1EC00DEC7B2000000
      000000000000CAA48100EFE3D800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFE3D800C69D78000000
      0000DEC7B200BE8F6500DAC0A800000000000000000000000000000000000000
      000000000000D2B29500DEC7B200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FBF8F500BE8F65000000
      0000E7D5C500BE8F6500CEAB8B00000000000000000000000000000000000000
      000000000000CEAB8B00EBDCCF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C2966E00EFE3
      D800F7F1EC00C2966E00BE8F6500F3EAE20000000000EFE3D800BE8F65000000
      0000FBF8F500C2966E00F3EAE200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DAC0A800D2B2
      950000000000E7D5C500C2966E00C2966E00DAC0A800CAA48100BE8F65000000
      0000E2CEBB00CEAB8B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FBF8F500C69D
      7800D6B99E0000000000F7F1EC00E2CEBB00DEC7B200DEC7B200EBDCCF00E7D5
      C500C2966E00F3EAE20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F3EA
      E200CAA48100CEAB8B00EBDCCF000000000000000000F3EAE200D6B99E00C296
      6E00EBDCCF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FBF8F500E2CEBB00CAA48100BE8F6500BE8F6500CAA48100DAC0A800F7F1
      EC00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084B094002573
      4100196B37002573410084B09400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000095B0E300235C
      C2000543BC001F59C10086A6DD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000088B29700288C530064BA
      8D0095D2B20064BA8D00288C530081AE91000000000000000000000000000000
      000000000000000000000000000000000000000000008CABE1002866CA002177
      E6000579EA000164DD00074FBE0086A6DD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004DA3EA00469E
      E8003E9AE7003595E6001E8CE200208CE200218DE4001989E3001283E3000A81
      E100037DE0000079DF000000000000000000C6A18C00C38E6800C08B6600BE88
      6400BB856100B9835F00B47E5C00B27C5A00B17B5800206C3A0062BA8B0060BA
      87000000000060B9870067BC8F0020703D00C6A18C00C38E6800C08B6600BE88
      6400BB856100B9835F00B47E5C00B27C5A00B17B5800164BAE00639DF400187F
      FF000076F8000076EE000368E1001E59C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000055A7EB00B6E6
      F90095D1F1004BA7E8005AAFEB007DC2EE00BBEEFB00BAEEF900B7EDF900B3ED
      F900B2EDF900017DE2000000000000000000C8926C0000000000000000000000
      00000000000000000000000000000000000000000000317B4C009CD4B6000000
      0000000000000000000095D2B200196B3700C8926C0000000000000000000000
      000000000000000000000000000000000000000000000543BC00AECDFE000000
      00000000000000000000187FEF000543BC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005DABEB00B4E3
      F800329FE6003BABE900A8E9F8004EBAEB005AD6F30050D4F30048D2F20042D1
      F200B4EDF9000881E3000000000000000000CA946E000000000000000000FFFF
      FE00FFFFFD00FEFEFD00FEFEFC00FEFEFC00FEFEFC004A8B620090D3B10092D6
      B1000000000065BC8C0067BC8F0020703D00CA946E000000000000000000FFFF
      FE00FFFFFD00FEFEFD00FEFEFC00FEFEFC00FEFEFC00245DC2008DB5F6004D92
      FF001177FF002186FF00408AEB00245CC2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005DACEC0055AD
      EB0047AFEB00ACE9F900ADEAFA0056BBEB0062D9F4005AD6F30050D4F30049D2
      F300B7EDF9001185E4000000000000000000CC976F0000000000FFFFFC00FFFF
      FD00FEFEFC00FEFEFC00FEFEFB00FDFDFA00FDFDFA00A7C6B10061AB810095D4
      B400BAE6D0006ABB8F002D8F570081AE9100CC976F0000000000FFFFFC00FFFF
      FD00FEFEFC00FEFEFC00FEFEFB00FDFDFA00FDFDFA0095B0E1003D76D2008DB5
      F700B8D6FE0072A8F5002E6BCA0094AFE2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005EADEB0083C3
      F000D3F3FC00D1F3FC00B2EDFA005BBCED006CDAF40062D9F4005AD6F30051D4
      F300BAEEFB001A8AE5000000000000000000D19C730000000000FEFEFC00FEFE
      FC00FEFEFC00FDFDFB00FDFDFB00FDFDFA00FDFDF800FBFBF900ACC8B5006099
      75004F8E66004A8A61007179510000000000D19C730000000000FEFEFC00FEFE
      FC00FEFEFC00FDFDFB00FDFDFB00FDFDFA00FDFDF800FBFBF90093AEDF002A61
      C6000543BC00205AC1005F618600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000071B6EE009ED1
      F40078CAF00072C7F0006EC6F00060BEED0076DDF5006CDBF40064D9F4005BD6
      F300BEEFFB00238FE8000000000000000000D49E750000000000FEFEFC00FDFD
      FB00FDFDFC00FDFDFB00FDFDF900FCFCF800FBF9F700FBF9F500FBF8F400FBF7
      F200FBF5F20000000000B27C5A0000000000D49E750000000000FEFEFC00FDFD
      FB00FDFDFC00FDFDFB00FDFDF900FCFCF800FBF9F700FBF9F500FBF8F400FBF7
      F200FBF5F20000000000B27C5A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000079B9F000DBF6
      FC009CE7F80095E5F8008FE3F70086E1F7007EDFF50076DDF5006DDBF40064D9
      F400C0F0FB002C94E9000000000000000000D5A0760000000000FDFDFC00FDFD
      FB00FDFDFA00FCFCF900FCFBF700FBF9F500FBF8F400FBF7F300FBF5F200FAF3
      EF00F8F2EC0000000000B57E5C0000000000D5A0760000000000FDFDFC00FDFD
      FB00FDFDFA00FCFCF900FCFBF700FBF9F500FBF8F400FBF7F300FBF5F200FAF3
      EF00F8F2EC0000000000B57E5C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008CC5F400DDF7
      FD00A2E8F8009DE7F80095E5F8008FE3F70087E1F7007FDFF60077DDF5006DDB
      F400C4F0FB003798EA000000000000000000D8A2790000000000FDFDFA00FCFC
      FA00FCFBF900FBFAF600FBF8F500FBF7F400FBF6F100F8F4EE00F7F2EB00F7F0
      EA00F6ECE80000000000B7815E0000000000D8A2790000000000FDFDFA00FCFC
      FA00FCFBF900FBFAF600FBF8F500FBF7F400FBF6F100F8F4EE00F7F2EB00F7F0
      EA00F6ECE80000000000B7815E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000093C8F500E1F7
      FD00AAEAF900A3E8F9009DE7F80096E5F80090E3F70088E1F70080DFF60077DD
      F500C8F1FB00409EEB000000000000000000D9A3790000000000FCFBF900FCFB
      F800FBF9F700FBF7F400FAF7F200F9F5F000F7F3ED00F6EFEA00F5EBE700F3EA
      E400F2E7DE0000000000BA85600000000000D9A3790000000000FCFBF900FCFB
      F800FBF9F700FBF7F400FAF7F200F9F5F000F7F3ED00F6EFEA00F5EBE700F3EA
      E400F2E7DE0000000000BA856000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000097CCF600F9FD
      FF00F0FBFE00F0FBFE00F0FCFE00EEFBFD00EFFBFD00EFFBFD00F0FBFD00F0FB
      FD00F7FDFE004AA3ED000000000000000000DBA47A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BD87630000000000DBA47A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BD876300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B2DCFD00FAFE
      FF00FAFEFF00FAFEFF00FAFEFF00FAFEFF00FAFDFE00FAFDFF00FAFEFF00FAFE
      FF00FAFDFF0053A8EE000000000000000000DCA77B00DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00C08B660000000000DCA77B00DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00C08B6600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B6DFFE00A2D2
      FA009CD1F90097CDF80092CAF7008CC6F60085C2F5007EBFF40076BAF4006EB6
      F10065B2F0005DADF0000000000000000000DDAD8600E8B99200E8B99200E8B9
      9200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B9
      9200E8B99200E8B99200C191700000000000DDAD8600E8B99200E8B99200E8B9
      9200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B9
      9200E8B99200E8B99200C1917000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DBC3B600DEB49200DCA77B00DCA6
      7A00DAA47A00D8A27900D5A07600D49E7500D29D7300CF9A7200CE997000CB96
      6F00C9946C00C79E8000DBC3B60000000000DBC3B600DEB49200DCA77B00DCA6
      7A00DAA47A00D8A27900D5A07600D49E7500D29D7300CF9A7200CE997000CB96
      6F00C9946C00C79E8000DBC3B600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000C6A18C00C38E6800C08B6600BE88
      6400BB856100B9835F00B47E5C00B27C5A00B17B5800AE795700AD765600AB75
      5400A9735300A9715100C6A18C0000000000C6A18C00A9715100A9735300AB75
      5400AD765600AE795700B17B5800B27C5A00B47E5C00B9835F00BB856100BE88
      6400C08B6600C38E6800C6A18C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C8926C00DEFFE200DEFFE200DCFD
      E000CCF1D1009ECFA300347E3A00000000000000000000000000000000000000
      00000000000000000000A972510000000000A972510000000000000000000000
      000000000000000000000000000000000000347E3A009ECFA300CCF1D100DCFD
      E000DEFFE200DEFFE200C8926C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000CA946E00DEFFE200DFFFE300DCFD
      E000CDF3D200A2D3A7003B88420000000000699E6C00F9FBF700FEFEFA00FEFE
      FA00FCFCF90000000000AA73530000000000AA73530000000000FCFCF900FEFE
      FA00FEFEFA00F9FBF700699E6C00000000003B884200A2D3A700CDF3D200DCFD
      E000DFFFE300DEFFE200CA946E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0084848400FFFFFF0000FFFF00FFFFFF00000000000000
      000000000000000000000000000000000000CC976F00DEFFE300DFFFE300DCFD
      E000CFF4D300A5D7AA0058A15F00D4E6D6003D874400508E5400FDFDFA00FCFC
      F700FBFBF60000000000AC75540000000000AC75540000000000FBFBF600FCFC
      F700FDFDFA00508E54003D874400D4E6D60058A15F00A5D7AA00CFF4D300DCFD
      E000DFFFE300DEFFE300CC976F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0084848400FFFFFF00C6C6C6008484840000FFFF00FFFFFF000000
      000000000000000000000000000000000000D19C7300DEFFE300DFFFE300DCFD
      E000D0F5D400AADDB0006FB4760054A25C006CB3740058A15F0059955E00FBFA
      F600FBF8F40000000000B07A580000000000B07A580000000000FBF8F400FBFA
      F60059955E0058A15F006CB3740054A25C006FB47600AADDB000D0F5D400DCFD
      E000DFFFE300DEFFE300D19C7300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0084848400FFFFFF00C6C6C6008484840000FFFF00FFFFFF0000FFFF008484
      840000000000000000000000000000000000D49E7500DEFFE300DFFFE300DDFE
      E100D1F6D600ABDFB10077BC7F0092CF9A008ECC96008BCB92005AA261003E86
      4500FBF5F20000000000B27C5A0000000000B27C5A0000000000FBF5F2003E86
      45005AA261008BCB92008ECC960092CF9A0077BC7F00ABDFB100D1F6D600DDFE
      E100DFFFE300DEFFE300D49E7500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008484
      8400FFFFFF00C6C6C6008484840000FFFF00FFFFFF0000FFFF0084848400C6C6
      C600C6C6C600000000000000000000000000D5A07600DEFFE200DFFFE300DDFE
      E100D1F7D600AEE3B4007EC3860054AB5E006BB6740067B06F0064A56900FAF3
      EF00F8F2EC0000000000B57E5C0000000000B57E5C0000000000F8F2EC00FAF3
      EF0064A5690067B06F006BB6740054AB5E007EC38600AEE3B400D1F7D600DDFE
      E100DFFFE300DEFFE200D5A07600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00C6C6C6008484840000FFFF00FFFFFF0000FFFF0084848400C6C6C600C6C6
      C600C6C6C600000000000000000000000000D8A27900DEFFE300DFFFE300DDFE
      E100D3F8D700B2E7B8005FBB6A00000000005BAF640068B16F00F7F2EB00F7F0
      EA00F6ECE80000000000B7815E0000000000B7815E0000000000F6ECE800F7F0
      EA00F7F2EB0068B16F005BAF6400000000005FBB6A00B2E7B800D3F8D700DDFE
      E100DFFFE300DEFFE300D8A27900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF0084848400C6C6C600C6C6C600C6C6
      C60000000000000000000000000000000000D9A37900DEFFE300DFFFE300DEFE
      E200D2F8D700B2E8B90064C270000000000085C68B00F2EEE700F5EBE700F3EA
      E400F2E7DE0000000000BA85600000000000BA85600000000000F2E7DE00F3EA
      E400F5EBE700F2EEE70085C68B000000000064C27000B2E8B900D2F8D700DEFE
      E200DFFFE300DEFFE300D9A37900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0084848400C6C6C600C6C6C600C6C6C6008484
      840084000000000000000000000000000000DBA47A00DEFFE300DFFFE300DEFE
      E200D2F8D700B2E8B90068C77400000000000000000000000000000000000000
      00000000000000000000BD87630000000000BD87630000000000000000000000
      00000000000000000000000000000000000068C77400B2E8B900D2F8D700DEFE
      E200DFFFE300DEFFE300DBA47A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600C6C6C600C6C6C600000000008400
      000084000000840000000000000000000000DCA77B00DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00C08B660000000000C08B6600DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00DCA77B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000840000008400000000000000DDAD8600E8B99200E8B99200E8B9
      9200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B9
      9200E8B99200E8B99200C191700000000000C1917000E8B99200E8B99200E8B9
      9200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B9
      9200E8B99200E8B99200DDAD8600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000840000008400000000000000DBC3B600DEB49200DCA77B00DCA6
      7A00DAA47A00D8A27900D5A07600D49E7500D29D7300CF9A7200CE997000CB96
      6F00C9946C00C79E8000DBC3B60000000000DBC3B600C79E8000C9946C00CB96
      6F00CE997000CF9A7200D29D7300D49E7500D5A07600D8A27900DAA47A00DCA6
      7A00DCA77B00DEB49200DBC3B600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000095B0E300235C
      C2000543BC001F59C10086A6DD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008CABE1002866CA002177
      E6000579EA000164DD00074FBE0086A6DD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6A18C00C38E6800C08B6600BE88
      6400BB856100B9835F00B47E5C00B27C5A00B17B5800164BAE00639DF400187F
      FF000076F8000076EE000368E1001E59C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B6B6
      B60074747400626262005C5C5C00818181007E7E7E004E4E4E0077777700E0E0
      E000000000000000000000000000000000000000000000000000000000000000
      000099999900616161005C5C5C00565656006060600000000000000000000000
      000000000000000000000000000000000000C8926C0000000000000000000000
      000000000000000000000000000000000000000000000543BC00AECDFE000000
      00000000000000000000187FEF000543BC000000000000000000000000009090
      90007373730078787800CCCCCC0000000000000000009A9A9A004C4C4C004747
      4700919191000000000000000000000000000000000000000000000000000000
      00009E9E9E00404040005656560000000000000000009B9B9B00242424001E1E
      1E00E0E0E0000000000000000000000000000000000000000000000000000000
      000000000000CDCDCD0035353500282828000000000000000000000000000000
      000000000000000000000000000000000000CA946E000000000000000000FFFF
      FE00FFFFFD00FEFEFD00FEFEFC00FEFEFC00FEFEFC00245DC2008DB5F6004D92
      FF001177FF002186FF00408AEB00245CC200000000000000000000000000D5D5
      D5004F4F4F00A2A2A20000000000000000000000000000000000434343004C4C
      4C00000000000000000000000000000000000000000000000000000000000000
      0000A3A3A300464646006A6A6A000000000000000000000000001C1C1C002929
      2900888888000000000000000000000000000000000000000000000000000000
      000000000000000000005050500038383800BCBCBC0000000000000000000000
      000000000000000000000000000000000000CC976F0000000000FFFFFC00FFFF
      FD00FEFEFC00FEFEFC00FEFEFB00FDFDFA00FDFDFA0095B0E1003D76D2008DB5
      F700B8D6FE0072A8F5002E6BCA0094AFE200000000000000000000000000D7D7
      D70056565600A6A6A60000000000000000000000000000000000575757005151
      5100000000000000000000000000000000000000000000000000000000000000
      0000A7A7A7004D4D4D00717171000000000000000000F2F2F200262626002D2D
      2D00999999000000000000000000000000000000000000000000000000000000
      0000000000000000000094949400444444007E7E7E0000000000000000000000
      000000000000000000000000000000000000D19C730000000000FEFEFC00FEFE
      FC00FEFEFC00FDFDFB00FDFDFB00FDFDFA00FDFDF800FBFBF90093AEDF002A61
      C6000543BC00205AC1005F61860000000000000000000000000000000000D9D9
      D9005E5E5E00ABABAB00000000000000000000000000000000005E5E5E005757
      5700000000000000000000000000000000000000000000000000000000000000
      0000ACACAC005353530077777700000000000000000080808000383838004F4F
      4F00F1F1F1000000000000000000000000000000000000000000000000000000
      00000000000000000000DDDDDD00454545004747470000000000000000000000
      000000000000000000000000000000000000D49E750000000000FEFEFC00FDFD
      FB00FDFDFC00FDFDFB00FDFDF900FCFCF800FBF9F700FBF9F500FBF8F400FBF7
      F200FBF5F20000000000B27C5A0000000000000000000000000000000000DADA
      DA0064646400AFAFAF0000000000000000000000000000000000656565005E5E
      5E00000000000000000000000000000000000000000000000000000000000000
      0000B0B0B0005959590069696900A6A6A6006868680044444400686868000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006262620049494900C2C2C200000000000000
      000000000000000000000000000000000000D5A0760000000000FDFDFC00FDFD
      FB00FDFDFA00FCFCF900FCFBF700FBF9F500FBF8F400FBF7F300FBF5F200FAF3
      EF00F8F2EC0000000000B57E5C000000000000000000D4D4D40000000000DCDC
      DC006A6A6A00B2B2B20000000000BCBCBC00E9E9E900000000006C6C6C006565
      65000000000000000000B7B7B700000000000000000000000000000000000000
      0000B3B3B3005F5F5F008484840000000000F4F4F4005D5D5D00464646008383
      8300000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009E9E9E00525252008B8B8B00000000000000
      000000000000000000000000000000000000D8A2790000000000FDFDFA00FCFC
      FA00FCFBF900FBFAF600FBF8F500FBF7F400FBF6F100F8F4EE00F7F2EB00F7F0
      EA00F6ECE80000000000B7815E00000000000000000090909000E5E5E500DDDD
      DD0070707000B6B6B600000000006C6C6C009D9D9D0000000000737373006C6C
      6C0000000000949494008F8F8F00000000000000000000000000000000000000
      0000B6B6B600656565008A8A8A000000000000000000A7A7A7004E4E4E004141
      4100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E0E0E0005757570059595900000000000000
      000000000000000000000000000000000000D9A3790000000000FCFBF900FCFB
      F800FBF9F700FBF7F400FAF7F200F9F5F000F7F3ED00F6EFEA00F5EBE700F3EA
      E400F2E7DE0000000000BA85600000000000000000009999990099999900B2B2
      B20099999900A7A7A7009A9A9A006B6B6B0072727200A0A0A0007A7A7A007F7F
      7F00858585004B4B4B00BCBCBC00000000000000000000000000000000000000
      0000B9B9B900696969008F8F8F00000000000000000097979700545454006C6C
      6C00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007272720059595900BDBDBD000000
      000000000000000000000000000000000000DBA47A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BD876300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCCC
      CC00919191007474740079797900B5B5B500959595006A6A6A0097979700F4F4
      F400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B5B5B5006E6E6E0060606000636363007D7D
      7D0000000000000000000000000000000000DCA77B00DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00C08B6600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DDAD8600E8B99200E8B99200E8B9
      9200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B9
      9200E8B99200E8B99200C1917000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DBC3B600DEB49200DCA77B00DCA6
      7A00DAA47A00D8A27900D5A07600D49E7500D29D7300CF9A7200CE997000CB96
      6F00C9946C00C79E8000DBC3B600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C4C9D8008A97
      BE00A2AAC200C9C9C900C9C9C900C9C9C900C9C9C900C9C9C900C9C9C900C9C9
      C900C9C9C900C9C9C900C9C9C900DFDFDF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004942
      3C000000000059524C0000000000000000000000000000000000000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FCFCFC00EDEDED002C4BA500355D
      AF002142AB00DCDCDC00D8D8D800D4D4D400D2D2D200D1D1D100D3D3D300D1D1
      D100CBCBCB00CDCDCD00C7C7C700C9C9C9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006862
      5C00F0EFEF0068625C00F0EFEF0000000000000000008484840084848400CED6
      D600000000008400000000000000000000008400000084000000840000008400
      000084000000840000000000000000000000C6A18C00C38E6800C08B6600BE88
      6400BB856100B9835F00B47E5C00B27C5A00B17B5800AE795700AD765600AB75
      5400A9735300A9715100C6A18C0000000000F6F6F600CECECE00C4C6CA00C0C6
      CC002143AC00FDFDFD00FBFBFB00F8F8F800F4F4F400EDEDED00D5D5D500E9E9
      E900000000000000000000000000C9C9C9000000000000000000F3EDE9000000
      000000000000F3EDE900E6DCD300E6DCD300000000000000000086817D003A32
      2C0049423C003A322C003A322C0059524C000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      000000000000000000000000000000000000C8926C0000000000000000000000
      00000000000000000000DCA77B00000000000000000000000000000000000000
      00000000000000000000A972510000000000FCFCFC00E2E2E2006379B300618F
      BF002246AE00FAFAFA00FAFAFA00F6F6F600F3F3F300EEEEEE00F3F3F300CACA
      CA00E6E6E600FBFBFB00FCFCFC00C9C9C9000000000000000000A8836400DACA
      BD00BB9D8500C1A69000D4C1B200D4C1B200B5957A00D4C1B20000000000C2C0
      BE0095918D00C2C0BE0086817D00000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CA946E0000000000FF8E2B009595
      95008787870000000000DCA77B0000000000FEFEFC00FEFEFC00FEFEFA00FEFE
      FA00FCFCF90000000000AA73530000000000F6F6F600CECECE00C4C6CA00C0C6
      CC002249AE00FAFAFA00FAFAFA00F8F8F800F4F4F400F1F1F100FBFBFB00F2F2
      F200CACACA00E6E6E600FCFCFC00C9C9C9000000000000000000A27A5900A883
      6400ECE4DE00000000000000000000000000F9F6F400B5957A006C5C4F005952
      4C002B231B0059524C002B231B0059524C000000000084848400000000000000
      000000000000000000000000000000000000CED6D60000000000CED6D6000000
      000000000000000000000000000000000000CC976F0000000000000000000000
      00000000000000000000DCA77B0000000000FDFDFA00FDFDFA00FDFDFA00FCFC
      F700FBFBF60000000000AC75540000000000FCFCFC00E2E2E200647CB3006392
      C100234BAF00F9F9F900F9F9F900F9F9F900F6F6F600F3F3F300FAFAFA00FAFA
      FA00F2F2F200C9C9C900E8E8E800C9C9C9000000000000000000A27A5900DACA
      BD000000000000000000000000000000000000000000D4C1B200A27A5900F3ED
      E90059524C000000000059524C00000000000000000084848400000000000000
      0000000000008484840084848400CED6D6000000000084000000000000000000
      000084000000840000008400000084000000D19C730000000000FF9E3A009F9F
      9F009999990000000000DCA77B0000000000FDFDF800FBFBF900FBFAF700FBFA
      F600FBF8F40000000000B07A580000000000F6F6F600CECECE00C4C6CA00C0C6
      CD00234EB100FAFAFA00F9F9F900F8F8F800F7F7F700F6F6F600FAFAFA00FAFA
      FA00FAFAFA00F2F2F200D1D1D100C8C8C8000000000000000000AE8C6F000000
      00000000000000000000000000000000000000000000BB9D8500A27A5900E6DC
      D30077716D00E1E0DE0077716D00D2D0CE000000000084848400000000000000
      000000000000848484000000000000000000CED6D60000000000CED6D6000000
      000000000000000000000000000000000000D49E750000000000000000000000
      00000000000000000000DCA77B0000000000FBF9F700FBF9F500FBF8F400FBF7
      F200FBF5F20000000000B27C5A0000000000FCFCFC00E2E2E200657FB5006494
      C2002451B200FAFAFA00F8F8F800E09F7300DD9D7100DC9A6E00DA996B00D998
      6A00D4936A00EAEAEA00ECECEC00C9C9C9000000000000000000000000000000
      000000000000F9F6F400E0D3C800CDB8A600AE8C6F00A27A5900A27A5900F3ED
      E900000000000000000000000000000000000000000084848400000000000000
      000000000000CED6D60000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D5A0760000000000FFBF6800AFAF
      AF00AAAAAA0000000000DCA77B0000000000FBF8F400FBF7F300FBF5F200FAF3
      EF00F8F2EC0000000000B57E5C0000000000F6F6F600CECECE00C4C6CA00C0C7
      CD002552B200FBFBFB00FAFAFA00F8F8F800F8F8F800F8F8F800F7F7F700F3F3
      F300F2F2F200F0F0F000EFEFEF00CCCCCC00000000000000000000000000E6DC
      D300C1A69000A27A5900A27A5900A27A5900A27A5900A27A5900CDB8A6000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      000000000000000000000000000000000000D8A2790000000000000000000000
      00000000000000000000DCA77B0000000000FBF6F100F8F4EE00F7F2EB00F7F0
      EA00F6ECE80000000000B7815E0000000000FCFCFC00E2E2E2006682B5006596
      C3002555B400FAFAFA00FAFAFA00E0A27600E0A07600E0A07400DF9E7300DC9C
      7200DC9B6F00F2F2F200F6F6F600C9C9C9000000000000000000E6DCD300A27A
      5900A27A5900A27A5900A27A5900A27A5900C1A69000DACABD00000000000000
      000000000000000000000000000000000000000000008484840084848400CED6
      D600000000008400000000000000000000008400000084000000840000008400
      000084000000000000000000000000000000D9A3790000000000FFBF6800BDBD
      BD00B7B7B70000000000DCA77B0000000000F7F3ED00F6EFEA00F5EBE700F3EA
      E400F2E7DE0000000000BA85600000000000F6F6F600CECECE00C4C6CA00C0C7
      CD002656B500F9F9F900F9F9F900E1A37800EAC0A300EAC0A200EABFA100EABE
      A000DF9E7100F4F4F400F7F7F700C9C9C9000000000000000000C1A69000A27A
      5900A8836400CDB8A600E6DCD300000000000000000000000000DACABD000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      000000000000000000000000000000000000DBA47A0000000000000000000000
      00000000000000000000DCA77B00000000000000000000000000000000000000
      00000000000000000000BD87630000000000FCFCFC00E2E2E2006783B7006699
      C4002659B700F8F8F800F8F8F800E1A57A00E1A37800E1A37700E0A27600E0A0
      7600E0A07400F4F4F400FAFAFA00C9C9C9000000000000000000BB9D8500A27A
      5900ECE4DE0000000000000000000000000000000000DACABD00BB9D85000000
      00000000000000000000000000000000000000000000CED6D600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DCA77B00DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA77B00DCA7
      7B00DCA77B00DCA77B00C08B660000000000F6F6F600CECECE00C4C7CA00C0C7
      CD00265BB700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F5F5F500F5F5
      F500F5F5F500F3F3F300FAFAFA00C9C9C9000000000000000000D4C1B200A27A
      5900F9F6F400000000000000000000000000F9F6F400AE8C6F00BB9D85000000
      000000000000000000000000000000000000E7E7E70000000000CED6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DDAD8600E8B99200E8B99200E8B9
      9200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B99200E8B9
      9200E8B99200E8B99200C191700000000000FCFCFC00E2E2E2006787B900679A
      C500275EB800F7F7F700F7F7F700F7F7F700F7F7F700F5F5F500F4F4F400F4F4
      F400F4F4F400F2F2F200FBFBFB00C9C9C9000000000000000000F9F6F400B595
      7A00C7AF9B00F3EDE90000000000E6DCD300B5957A00B5957A00BB9D85000000
      0000000000000000000000000000000000006363630000FFFF00000000000000
      0000840000008400000084000000840000008400000000000000000000000000
      000000000000000000000000000000000000DBC3B600DEB49200DCA77B00DCA6
      7A00DAA47A00D8A27900D5A07600D49E7500D29D7300CF9A7200CE997000CB96
      6F00C9946C00C79E8000DBC3B60000000000F6F6F600CECECE00C4C7CA00C1C7
      CD00275FB800FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00C9C9C900000000000000000000000000F9F6
      F400D4C1B200BB9D8500BB9D8500C7AF9B00E6DCD300F9F6F400D4C1B2000000
      000000000000000000000000000000000000E7E7E70000000000CED6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F1F1F100648BC2004978
      BE002861BA00C9C9C900C9C9C900C9C9C900C9C9C900C9C9C900C9C9C900C9C9
      C900C9C9C900C9C9C900C9C9C900DFDFDF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E2C0AA00CC8D6600C071
      4000BC6B3600BC6B3600BC6B3600BC6A3600BC6A3600BB6A3500BB6A3500BB69
      3500B16D4300576F85007D91A200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D3957000CC835700C8764600CA7B4E00CB7B4E00CA7B
      4E00CA7B4E00CA7B4E00CA815500CD865C0000000000C57C4D00F8F2EB00F7EC
      DF00F6EBDE00F6EADE00F6EADC00F6EADC00FAF3EB00FAF3EB00FAF2EA00EDED
      EE006C98BE0072A3CE003A7AAC00000000000000000000000000000000000000
      0000F4ECE500D6BAA200B6845A00AC744500AB724300B27E5300D2B59C00F2EA
      E300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CB825600FCF3EC00FAF1E800FAF0E700FBF1E900FBF2
      EA00FBF2EA00FBF2EB00FDF4EE00CB83580000000000C2774000F5EBDF00FEE5
      D500FDE5D300FDE5D300FAE2D000F4D8C200F1D3BB00F3D2B800E2D0C200789E
      C10086B0D70083AFD6003F70990000000000000000000000000000000000E7D5
      C600BA895F00D7BBA300E9DACA00ECE0D100ECE0D100E8D8C800D3B59C00B07A
      4D00E2CFBE000000000000000000000000000000000000000000000000000000
      00000000000000000000C7C8C800707474000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CF825300EFF1E700FFE9D900FFEADB00FFE9D900FFE7
      D700FFE5D200FFE2CB00EFF2E800CE81560000000000C37C4200F7EDE300FEE5
      D500FDE5D300FAE0CC00E7C4A700E3C1A400E4C3A700E2BFA100CDA98E00A2A9
      B2008FBAE1005E90BD00A36C4B00000000000000000000000000EAD9CB00BE8C
      6200E7D5C400E5D2BF00C9A68500B88E6700B68A6500C5A18000E0CCBA00E3D0
      BE00AF764800E3D0C00000000000000000000000000000000000000000000000
      0000FDFDFD00ACAEAE0066696900606464000000000000000000000000000000
      000000000000A9A0F300E9E7FC00000000000000000000000000000000000000
      00000000000000000000CD855500FBF5EE00FFE9D900FFEADB00FFE9D900FFE7
      D700FFE5D200FFE2CB00FBF6EF00CC83560000000000C6804600F7F0E600FEE5
      D500FDE5D300EDCDB100F1D9C500F8E5D200F8E2CB00F8E1CB00F7DEC600DEB7
      99008F9EAF00DCE4EB00C1743C000000000000000000F7F1EC00C99D7900EAD8
      C900E3CDBA00C0946B00BA8C6200CFB09400CFB09400B7895F00B2876100DAC0
      AA00E4D1C000B6835900F4ECE60000000000DEDEDF00DDDDDD00DCDDDD00DBDC
      DC00767A7A00696D6D0072777700606464000000000000000000000000000000
      00009A90F0003D32ED005746E70000000000D69E7C00D3936E00CF875E00D08C
      6400D18C6400D08C6400CA845200FFF7F100FFE9D900FFEADB00FFE9D900FFE7
      D700FFE5D200FFE2CB00FFF7F100CB85560000000000C7844800F8F1E800FEE5
      D500FDE5D300F1D6BE00F8E7D600F4DCC400F3D8BD00F3D6BA00F6DDC500F5D8
      BC00C6AF9E00FDFAF700C37A41000000000000000000E6CFBC00E4CCB900EAD6
      C500C7997100BF906600BF906600F7F1EC00F6F0EA00B7895F00B7895F00B589
      6300E2CEBB00D9BDA600D9BEA70000000000717474006F7373006B6F6F00696D
      6D00696C6C00505151005F61610061656500000000000000000000000000B2AB
      F300DEDBFA003D2EE6003F35ED00A79EF200D1936D00FCF5EE00FBF3EB00FBF2
      EA00FCF3EC00FCF4ED00E4BA9100FFF7F000FFE7D500FDE7D600FDE6D400FCE4
      D000FBE3CB00FADCC200FEF3E800CC86570000000000C7864B00F8F2EB00FEE7
      D600FDE7D600F6DEC900F7E6D400F5DCC500F4DCC400F4DAC000F3D8BE00F5E0
      CC00DFB59200FBF7F200C78045000000000000000000D9B39500EFE1D300D9B5
      9500C7986C00C3956900C1936700BF906600BF906600BB8B6300B98A6300B88A
      6200CBA78600EADCCC00C2956F0000000000787B7B00999A9A00777878006E6F
      6F00505151003F3F3F005D5F5F00636767000000000000000000B9B3F300554D
      ED00A8A0F100ADA5F200453BED005342E600D5926900F1F3EA00FFECDE00FFED
      E000FFECDE00FFEADC00E4BB9100FFF7F200FEE7D500FEE7D500FDE5D100FAE0
      CA00F9DEC400F7D9BC00FDF2E700CC87580000000000C8884D00F9F3EC00FEE8
      D600FEE8D700F8E1CC00F7E8D900F5E0C900F5DEC700F4DCC400F5DDC400F5E0
      CD00E2BB9A00FAF2EA00C88448000000000000000000DAB39300F2E4D900D1A5
      7A00C5996B00C4976A00C4966900FAF6F200F3EAE100C2956D00BE8F6500BE8F
      6400C0956D00EFE3D500C19067000000000081838300999B9B00656565005F5F
      5F005353530049494900676969006669690000000000665CEB00D4D1F7005A50
      E9004F40E100000000004230E1003B29E100D3956A00FCF6F000FFECDE00FFED
      E000FFECDE00FFEADC00E4BB9200FEF7F100FCE5D200FCE4D100FBE2CC00F9DD
      C400F6D7BB00F3D1AF00FAEFE400CC87590000000000C88C4F00F9F4ED00FEE8
      D800FEE8D800F9DFC700F9EBDF00F7E6D600F6E0CB00F6E0CA00F8E7D700EFD6
      BE00EAC7A800FAF4ED00C8864B000000000000000000E1BB9D00F2E5DA00D1A6
      7E00CC9D7100C79A6C00C5986B00E2CCB600F8F3EE00F6EEE800D9BDA100C294
      6800C59B7100F0E2D600C79971000000000085878700A5A6A600878787008585
      85007D7D7D007272720084858500696D6D00000000007168EC00D7D4F7006159
      E900574AE100000000004A3AE1004332E100D1956A00FFF8F300FFECDE00FFED
      E000FFECDE00FFEADC00E4BB9200FEF6F000FCE2CD00FCE3CD00FADFC800F7D9
      BC00F5E9DD00FAF3EB00FBF8F300CA83540000000000C88C5000F9F4EF00FEE7
      D700FDE7D600FCE3CD00F9E1CB00FAEADB00F8EBDD00F8EADB00F4DDC800ECC9
      AA00F5D7B900FAF4EF00C8874C000000000000000000EACAB000F3E5D900DFBB
      9E00CFA07500CD9E7200F5EBE300E4CBB400E7D3BF00FBF8F600E5D3BF00C498
      6B00D6B49100EEE0D200D3AC8B0000000000888B8B00C2C3C300BCBCBC00BABA
      BA009E9E9E0083838300919191006E7172000000000000000000C6C2F3006B65
      EC00B4AFF100B7B2F2005A53ED006759E600D2966B00FFF8F200FFEADA00FDEA
      DB00FDE9DA00FCE7D600E4BB9300FEF5ED00FCDEC500FBE0C700F9DCC200F5D3
      B400FEF9F300FAE2C400ECC19300DCB4960000000000C88D5100F9F4F000FCE6
      D300FCE6D400FDE7D300FCE1CA00F9DCC200F6D9BE00F5D6B900F1D0B200F2D2
      B300F1D2B300F8F4F000C6864C000000000000000000F5E4D600F4E3D400EFDC
      CD00D5A87E00D0A07700FBF8F500FCF8F500FCF8F500FBF8F500D1A88100CFA4
      7B00EAD5C300EAD4C200E9D4C200000000008B8D8D00919292008F9191008F90
      9000A1A3A300A9A9A900A1A2A20075777800000000000000000000000000C6C2
      F300E5E3FA00635AE600615BED00B7B1F200D2976C00FFF8F400FEEADA00FEEA
      DA00FDE8D700FBE4D100E5BE9600FFFFFE00FDF3E900FDF3EA00FCF2E800FAEF
      E300FAF2E700EABB8800DDA98800FBF8F60000000000C88D5100F9F5F100FCE3
      CF00FBE4D000FCE4CF00FCE3CD00FAE1CA00F9DDC400F6D9BC00F4E9DF00F7F2
      EC00FBF7F300F5EFE900C38048000000000000000000FDF9F500F1D3BB00F6E9
      DD00ECD8C600D7AC8100DCBB9A00F6ECE300F5ECE200E4C8AE00D2A77B00E6CE
      BA00F1E2D500DFBB9C00FAF4F00000000000E5E5E500E5E5E500E5E5E500E5E5
      E500999B9B009B9D9D00ADAFAF007C7F7F000000000000000000000000000000
      0000BAB6F1006D69EC008379E70000000000D2976D00FEF8F300FCE8D800FCE7
      D700FCE6D300FAE1CC00EAC39D00E6BF9600E4BB9200E4BB9200D3A47200D2A1
      7200D3A57600E2BDA200FCFAF8000000000000000000C88D5200F9F5F100FCE3
      CD00FBE3CE00FBE3CD00FBE2CB00F9E0C800F8DCC200F5D6BA00FDFBF800FCE6
      CD00FAE5C900E2B68400D5A88400000000000000000000000000FBF1E900F3D4
      BB00F7EADF00EEDED000E3C1A700D8AE8900D7AC8600DDBB9C00EBD6C700F3E6
      D900E4C1A300F5E9DF0000000000000000000000000000000000000000000000
      0000FEFEFE00C2C3C300898B8B00818383000000000000000000000000000000
      000000000000C8C4F300F0EFFC0000000000D2976D00FEF7F200FCE6D300FCE7
      D300FBE3CF00F8DEC500F6ECE100FBF5EE00FCF9F500D4A47A00000000000000
      00000000000000000000000000000000000000000000CA925A00FAF6F200FAE0
      C700FBE1C900FBE2C900FBE0C800F9DFC500F8DBC100F4D6B800FFFBF800F6D8
      B400E1B07D00DC966900FDFBFA0000000000000000000000000000000000FCF2
      EA00F6DAC300F9E9DC00F6E8DD00F3E5DA00F3E5DA00F5E7DC00F5E4D600EDCD
      B400F8ECE3000000000000000000000000000000000000000000000000000000
      00000000000000000000D5D6D600909191000000000000000000000000000000
      000000000000000000000000000000000000D3986F00FEF6EF00FCE2CD00FCE4
      CE00FAE1CA00F6D9BE00FEFAF500FBE6CC00EEC9A100E1BEA300000000000000
      00000000000000000000000000000000000000000000D2A27400F8F3ED00F8F4
      EE00F8F4ED00F8F3ED00F8F3ED00F8F3ED00F8F2EC00F7F2EC00F2E6D700E2B2
      7D00DC986B00FDFBFA0000000000000000000000000000000000000000000000
      0000FEFAF700FCEDE100F8DEC900F6D9C100F5D7BF00F5D9C300F8E8DC00FDF8
      F500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D49B740000000000FDF5EC00FDF5
      ED00FCF4EB00FBF1E700FBF4EA00EDC49700E2B49700FCF9F700000000000000
      00000000000000000000000000000000000000000000E8CEB900D7AA7C00CC94
      5B00CA905500CA905500CA905500CA915500CB905500C98F5500CF9D6900DDB1
      9000FDFBFA000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DAA68400D69D7600D3976D00D299
      6E00D3996E00D2986F00D49A7000E6C5AD00FDFAF90000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000348CD900348BD900348C
      D900348CD900348CD900348CD900348CD900348CD900348CD900348CD900348B
      D900348CD90000000000FFFFFF00FFFFFF0000000000CD957000BD734200B768
      3500B5683500B4673400B2663400B0653300AE643300AC633200AA623200A961
      3200A8603100A7613200AB693C00BC866100000000000000000000000000C896
      6200CA986500CA976500CA976500CA976500CA976400C9976400C9976400CA98
      6500C89562000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003690DA00DCF0FA0098E1F60095E0
      F60092DFF6008EDEF50089DCF50085DAF40080D9F4007AD7F30074D5F30070D3
      F200C2EAF8003594DA00FFFFFF00FFFFFF00C37D4F00EBC6AD00EAC5AD00FEFB
      F800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFB
      F800FEFBF800C89A7C00C7987900AD6B4000A1A1A1007A7A7A0058585800C795
      6100F9F7F600F9F1EC00F9F1EB00F8F0E900F7EDE600F4EAE100F2E8DE00FAF8
      F600C7946100242424004B4B4B00969696000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003B97DB00EFFAFE0093E5F8008FE4
      F80089E3F80082E1F7007ADFF70071DEF60067DBF5005BD8F4004DD4F30040D1
      F200CAF2FB003594DA00FFFFFF00FFFFFF00BA6C3800EDCAB300E0A27A00FEFA
      F70062C0880062C0880062C0880062C0880062C0880062C0880062C0880062C0
      8800FDF9F600CA8D6500C99B7C00A76132006B6B6B00A7A7A700B5B5B5008181
      8100AFACAA00C5C0BD00C5C0BD00C5C0BD00C5C0BD00C5C0BD00C5C0BD00ADAA
      A8002C2C2C00B5B5B5009B9B9B00232323000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000003C9DDB00F2FAFD0094E6F80092E5
      F80090E5F8008BE3F80086E2F7007FE1F70077DEF6006CDCF6005ED9F4004FD5
      F300CCF2FB003594DA00FFFFFF00FFFFFF00BB6C3800EECCB600E1A27A00FEFA
      F700BFDCC200BFDCC200BFDCC200BFDCC200BFDCC200BFDCC200BFDCC200BFDC
      C200FDF9F600CD906800CC9E8100A861320070707000B5B5B500B5B5B5009595
      95008181810081818100797979006E6E6E006161610052525200434343004242
      42006E6E6E00B5B5B500B5B5B500252525000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000003BA3DB00F6FCFE0094E5F80093E5
      F80093E5F80091E5F80093DBE90093D7E30093D2DC0090CED7008CC8CF0086C1
      C600C9D8D6003594DA00CA815500CD865C00BB6B3800EFCEB800E1A27900FEFA
      F70062C0880062C0880062C0880062C0880062C0880062C0880062C0880062C0
      8800FDF9F600CF936A00CEA38400AA61320075757500BBBBBB00BBBBBB008D8D
      8D00D4D4D400B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900D3D3
      D30083838300BBBBBB00BBBBBB002A2A2A000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000003BA8DB00FEFFFF00F8FDFF00F6FD
      FF00F5FCFF00F3FCFE009AE4F4009AE6F7009BE6F6009DE5F5009EE5F5009FE5
      F400DAF3F8003594DA00FDF4EE00CB835800BA6A3600EFD0BB00E2A27A00FEFB
      F800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFB
      F800FEFBF800D3966D00D2A78A00AB6232007A7A7A00D7D7D700D7D7D7009797
      9700D8D8D800BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00D7D7
      D7008E8E8E00D7D7D700D7D7D7003F3F3F000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000039ADDB00E8F6FB0070BCE70055AA
      E2004DA5E00091C9EB00FAF3EF00FDFEFD00FFFDFC00FFFDFC00FEFDFC00FEFC
      FB00FEFEFD003594DA00EFF2E800CE815600BB6A3600F0D2BE00E2A37A00E2A3
      7A00E1A37A00E2A37B00E1A37B00E0A17800DE9F7700DD9F7600DC9D7400D99B
      7200D8997100D6997000D5AB8E00AD6333007E7E7E00F9F9F900F9F9F900ABAB
      AB00DFDFDF00CBCBCB00CBCBCB00CBCBCB00CBCBCB00CBCBCB00CBCBCB00DFDF
      DF00A3A3A300F9F9F900F9F9F900616161000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000040AEDC00F1FAFD0094DEF50093DC
      F40064BCE9003594DA003594DA003594DA003594DA003594DA003594DA003594
      DA003594DA003594DA00FBF6EF00CC835600BB6A3600F2D5C200E3A37A00E3A3
      7A00E2A37B00E2A37B00E2A47B00E1A27900E0A17800DEA07700DE9E7500DC9D
      7400DA9B7300D99B7300DAB09500AF64330084848400FCFCFC00FCFCFC00CBCB
      CB00F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2
      F200C6C6C600FCFCFC00FCFCFC00717171000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000041B4DC00F7FCFE008EE4F80091DE
      F5009FE0F500ACE1F600CA845200FFF7F100FFE9D900FFEADB00FFE9D900FFE7
      D700FFE5D200FFE2CB00FFF7F100CB855600BB6A3600F2D8C500E3A47B00E3A3
      7A00E3A47A00E2A47B00E2A37B00E1A37B00E1A27900DFA07700DE9F7600DD9E
      7400DB9C7200DC9D7400DDB59A00B165340097979700D2D2D200E8E8E8007D7D
      7D007D7D7D007D7D7D007D7D7D007D7D7D007D7D7D007D7D7D007D7D7D007D7D
      7D007D7D7D00E8E8E800C4C4C4006D6D6D000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000003CB5DB00FDFEFE00FEFFFF00FEFE
      FF00FDFEFF00FEFFFF00E4BA9100FFF7F000FFE7D500FDE7D600FDE6D400FCE4
      D000FBE3CB00FADCC200FEF3E800CC865700BB6B3600F4D9C700E6A67D00C88C
      6400C98D6500C98E6700CB926C00CB926D00CA906900C88C6500C88C6400C88C
      6400C88C6400DA9C7400E1BA9F00B3663400DDDDDD009A9A9A00CCCCCC00C78B
      4E00F9F4ED00FEE8D800FEE8D700FDE5D300FCE4D100FAE0C700F9DDC300FAF4
      ED00C7854A00C3C3C30074747400CDCDCD000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084848400000000000000000059C2E00061C3E20063C4E30063C4
      E30063C4E30062C4E300E4BB9100FFF7F200FEE7D500FEE7D500FDE5D100FAE0
      CA00F9DEC400F7D9BC00FDF2E700CC875800BB6C3700F4DCC900E7A77D00F9EC
      E100F9ECE100F9EDE300FCF4EE00FDFAF700FDF7F300FAEDE500F7E7DB00F7E5
      D900F6E5D800DEA07700E4BEA400B467340000000000CECECE0087878700C589
      4C00F9F4EF00FEE7D700FDE7D500FCE6D200FBE1CC00F8DCC200F6DABD00FAF4
      EF00C483480061616100BCBCBC0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E4BB9200FEF7F100FCE5D200FCE4D100FBE2CC00F9DD
      C400F6D7BB00F3D1AF00FAEFE400CC875900BD6E3A00F5DDCC00E7A87E00FAF0
      E800FAF0E800C98D6600FAF0E900FDF8F300FEFAF800FCF4EF00F9E9DF00F7E7
      DB00F7E5D900E0A27800E7C2A900B66835000000000000000000FBFBFB00C68C
      4F00F9F4F000FCE6D300FDE7D300FBE3CD00FAE0C800F5D6BB00F3D4B500F8F4
      F000C4854A00F9F9F90000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E4BB9200FEF6F000FCE2CD00FCE3CD00FADFC800F7D9
      BC00F5E9DD00FAF3EB00FBF8F300CA835400C0744200F6DFD000E8A87E00FCF6
      F100FCF6F100C88C6400FAF1E900FBF4EE00FDFAF700FDF9F600FAF0E800F8E8
      DD00F7E6DB00E1A37A00EFD5C300B76A3600000000000000000000000000C88D
      5100F9F5F100FCE3CF00FCE4CF00FAE1CA00F9DDC400F4E9DF00F7F2EC00F5EF
      E900C38048000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000000000008400000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E4BB9300FEF5ED00FCDEC500FBE0C700F9DCC200F5D3
      B400FEF9F300FAE2C400ECC19300DCB49600C6825500F6DFD100E9AA8000FEFA
      F600FDFAF600C88C6400FBF3EE00FBF1EA00FCF6F200FEFBF800FCF6F100F9EC
      E200F8E7DB00EED0BA00ECD0BD00BD744300000000000000000000000000C88D
      5200F9F5F100FCE3CD00FBE3CD00F9E0C800F8DCC200FDFBF800FCE6CD00E2B6
      8400D5A884000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000840000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E5BE9600FFFFFE00FDF3E900FDF3EA00FCF2E800FAEF
      E300FAF2E700EABB8800DDA98800FBF8F600D6A58500F6E0D100F7E0D100FEFB
      F800FEFBF700FDF9F600FCF5F000FAF0EA00FBF2ED00FDF9F600FDFAF700FBF1
      EB00F8E9DF00ECD1BE00CD926A00E2C5B100000000000000000000000000C588
      4D00F7F2EC00F8F4EE00F8F3ED00F8F3ED00F8F2EC00F2E6D700E2B27D00DB95
      6900FDFBFA000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000840000008400000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EAC39D00E6BF9600E4BB9200E4BB9200D3A47200D2A1
      7200D3A57600E2BDA200FCFAF800FFFFFF00E1BDA600D9AB8D00C9895E00C075
      4300BD6E3A00BB6C3700BB6B3600BB6A3600BB6A3600BC6C3900BD6E3B00BB6D
      3A00BF744400C98D6500E7CEBC00FFFFFF00000000000000000000000000E8CE
      B900D7AA7C00C88C5000C88C4F00CA915500CB905500C5894D00DDAF8D000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E2C0AA00CC8D6600C071
      4000BC6B3600BC6B3600BC6B3600BC6A3600BC6A3600BB6A3500BB6A3500BB69
      3500BD6E3B00CA8B6300E3C2AE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B1947600865E3400825A3100A4825F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C57C4D00F8F2EB00F7EC
      DF00F6EBDE00F6EADE00F6EADC00F6EADC00FAF3EB00FAF3EB00FAF2EA00FCF7
      F300FCF8F400FEFEFD00C37A4D00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CF816E00B43312000000
      000000000000000000000000000000000000A37642009E703D00986B38009365
      33008D602E00875A2900825424009368390090653600724516006D401100693C
      0D0065380A00613406005E3103005B2E01000000000000000000000000000000
      0000C04E1600D38C700000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C2774000F5EBDF00FDBF
      6800FCBD6700FBBE6500FCBE6400FCBE6400FCBD6200FBBD6300FBBC6100FCBE
      6000FCBC6200FDFBF800BC6B3700000000000000000000000000000000000000
      000000000000000000000000000000000000D0836B00C45F3100B73913000000
      000000000000000000000000000000000000AB7E4A00B38B5D00B38B5D00B38B
      5D00B38B5D00B38B5D00B38B5D007D512100794C1D00B38B5D00B38B5D00B38B
      5D00B38B5D00B38B5D00B38B5D00683C0E000000000000000000000000000000
      0000C4591800CC713B00D38A6C00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C37C4200F7EDE300FDC2
      6E00FFD8A000FFD79E00FFD69B00FFD79800FFD69600FFD69500FFD59400FFD4
      9300FBBE6500FBF7F400BD6C3700000000000000000000000000000000000000
      0000000000000000000000000000D58C6B00C96B3700DA956200B94014000000
      000000000000000000000000000000000000B0834F009E703D00986B38009365
      33008D602E00875A290082542400AB907400AA8F7300724516006D401100693C
      0D0065380A00613406005E3103006C3F12000000000000000000000000000000
      0000C9621A00DFA37500CF743C00D58C6B000000000000000000000000000000
      00000000000000000000000000000000000000000000C6804600F7F0E600F8B4
      5500F7B45600F7B55400F8B45300F8B25300F7B35200F7B35200F7B25100F7B2
      4F00F7B24F00FCF9F500C1743C00000000000000000000000000000000000000
      00000000000000000000D8936700D0773D00DD9F6E00DC9B6900BD4715000000
      000000000000000000000000000000000000B6885400A5774300F9F9F900F9F9
      F900F9F9F900F8F8F800F1F1F100E3E3E300F3F3F300F8F8F800F9F9F900F8F8
      F800E9E9E900F8F8F80062350700704416000000000000000000000000000000
      0000CD6E2300E1A87E00E0A67900D0773D00D38B650000000000000000000000
      00000000000000000000000000000000000000000000C7844800F8F1E800FEE5
      D500FDE5D300FDE5D300FCE5D300FCE5D300FCE4D100FCE2CE00FCE2CC00FBE0
      C900FBE1C800FDFAF700C37A4100000000000000000000000000000000000000
      0000FEFDFC00DD9D6D00D6854800E1A97C00DB986600DEA17100C05217000000
      000000000000000000000000000000000000BA8D5800AB7D4900F9F9F900F1F1
      F100EDEDED00E7E7E700D3D3D300A5A5A500D7D7D700F4F4F400EEEEEE00EAEA
      EA00DCDCDC00F8F8F80066390B0074481A000000000000000000000000000000
      0000D2773500E4AF8700DFA17200E1A97C00D07A3F00D58B6300FEFCFB000000
      00000000000000000000000000000000000000000000C7864B00F8F2EB00FEE7
      D600FDE7D600FDE7D600FDE7D600FDE6D500FDE5D300FCE4D100FCE2CD00FBE1
      CB00FBE1C900FBF7F200C7804500000000000000000000000000000000000000
      0000E2A67A00DC955F00E5B38B00E0A47700DC9A6700E1A67A00C65C19000000
      000000000000000000000000000000000000BE915C00B1834E00F9F9F900CCCC
      CC00C9C9C900C5C5C500D3D3D300A6A6A600D8D8D800F4F4F400CACACA00C6C6
      C600BABABA00F8F8F8006B3E10007A4D1E000000000000000000000000000000
      0000D6844300E7B59000E0A37400E0A47700E2AB8100D37F4300D78A5E000000
      00000000000000000000000000000000000000000000C8884D00F9F3EC00FEE8
      D600FEE8D700FDE7D600FDE7D600FDE7D500FDE5D300FBE4D000FBE3CC00FADF
      C700FADFC600FAF2EA00C8844800000000000000000000000000000000000000
      0000DD966400E09D6B00E8B89500E3AB8100DFA17200E3AD8300C9651B000000
      000000000000000000000000000000000000C2956000B7895300FAFAFA00F1F1
      F100EDEDED00E9E9E900D4D4D400A6A6A600D8D8D800F5F5F500EFEFEF00EBEB
      EB00DCDCDC00F8F8F800714415007F5323000000000000000000000000000000
      0000DB8E5300EABB9900E3AA8000E3AB8100E4B18A00D6884B00CC7434000000
      00000000000000000000000000000000000000000000C88C4F00F9F4ED00FEE8
      D800FEE8D800FEE8D700FEE7D600FDE5D300FCE4D100FBE1CC00FAE0C700F9DD
      C300F8DCC200FAF4ED00C8864B00000000000000000000000000000000000000
      000000000000E7B69000E0A07100E9BB9900E5AF8600E6B28D00CF722A000000
      000000000000000000000000000000000000C6986200BC8E5800FAFAFA00CCCC
      CC00CACACA00C5C5C500D4D4D400A7A7A700D8D8D800F5F5F500CBCBCB00C7C7
      C700BBBBBB00F8F8F800774A1A00845828000000000000000000000000000000
      0000E1976200ECC1A100E8B79200E9BB9900DD976100DFA47700000000000000
      00000000000000000000000000000000000000000000C88C5000F9F4EF00FEE7
      D700FDE7D600FDE7D500FDE6D400FCE6D200FBE1CC00FADFC700F8DCC200F6DA
      BD00F6D8BB00FAF4EF00C8874C00000000000000000000000000000000000000
      00000000000000000000E9BA9900E3A47500E9BB9900E8B99500D47C3A000000
      000000000000000000000000000000000000C6996300C1935C00FAFAFA00F2F2
      F200EFEFEF00EAEAEA00D5D5D500B5B5B500DFDFDF00F5F5F500F1F1F100ECEC
      EC00DEDEDE00F9F9F9007D5020008A5E2D000000000000000000000000000000
      0000E2A06E00EEC7A800EDC2A300E3A47500E6B38D0000000000000000000000
      00000000000000000000000000000000000000000000C88D5100F9F4F000FCE6
      D300FCE6D400FDE7D300FCE4D100FBE3CD00FAE0C800F8DCC200F5D6BB00F3D4
      B500F1D2B300F8F4F000C6864C00000000000000000000000000000000000000
      0000000000000000000000000000ECC4A600E5A67A00EABD9A00D9874A000000
      000000000000000000000000000000000000C6996300C5976000FAFAFA00CDCD
      CD00CACACA00C6C6C600F2F2F200DDD8D200EBE5DF00FCFCFC00CCCCCC00C9C9
      C900BDBDBD00F9F9F90084572600916333000000000000000000000000000000
      0000E6A77900EFC8AD00E8B08700ECC4A6000000000000000000000000000000
      00000000000000000000000000000000000000000000C88D5100F9F5F100FCE3
      CF00FBE4D000FCE4CF00FCE3CD00FAE1CA00F9DDC400F6D9BC00F4E9DF00F7F2
      EC00FBF7F300F5EFE900C3804800000000000000000000000000000000000000
      000000000000000000000000000000000000EEC9AD00E1976300DD9059000000
      000000000000000000000000000000000000C6996300C89A6300FAFAFA00FAFA
      FA00FAFAFA00F8F8F800D9C6B100B98F5F00B48B5C00D7C4AF00F9F9F900F9F9
      F900F9F9F900F9F9F9008B5D2C00976938000000000000000000000000000000
      0000EAAB8000E8A97D00F0CEB500000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C88D5200F9F5F100FCE3
      CD00FBE3CE00FBE3CD00FBE2CB00F9E0C800F8DCC200F5D6BA00FDFBF800FCE6
      CD00FAE5C900E2B68400D5A88400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFCAB100E29D6C000000
      000000000000000000000000000000000000F4EBE000C99B6400D3AE8200D0AC
      8000CEA97D00CBA67B00C6A07400F2EAE100F1E9E000BB956A00B8946A00B490
      6600AF8B6200AB875E0092643200EBE2D7000000000000000000000000000000
      0000E9AF8500F3D1BB0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CA925A00FAF6F200FAE0
      C700FBE1C900FBE2C900FBE0C800F9DFC500F8DBC100F4D6B800FFFBF800F6D8
      B400E1B07D00DC966900FDFBFA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F4EBE000F4EBE000F4EB
      E000F4EAE000F3EADF00F2E9DE000000000000000000F0E7DC00EFE6DB00EEE5
      DA00EDE4D900ECE2D800EAE1D700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D2A27400F8F3ED00F8F4
      EE00F8F4ED00F8F3ED00F8F3ED00F8F3ED00F8F2EC00F7F2EC00F2E6D700E2B2
      7D00DC986B00FDFBFA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E8CEB900D7AA7C00CC94
      5B00CA905500CA905500CA905500CA915500CB905500C98F5500CF9D6900DDB1
      9000FDFBFA000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000348CD900348BD900348C
      D900348CD900348CD900348CD900348CD900348CD900348CD900348CD900348B
      D900348CD90000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003690DA00DCF0FA0098E1F60095E0
      F60092DFF6008EDEF50089DCF50085DAF40080D9F4007AD7F30074D5F30070D3
      F200C2EAF8003594DA00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B3B3B300B3B3
      B300B3B3B300000000002B2B2B00242424001E1E1E0017171700121212000C0C
      0C0000000000000000000000000000000000000000003E39340039343000332F
      2B002C29250027242100201D1B00E7E7E700333130000B0A0900070706000404
      0300000000000000000000000000000000003B97DB00EFFAFE0093E5F8008FE4
      F80089E3F80082E1F7007ADFF70071DEF60067DBF5005BD8F4004DD4F30040D1
      F200CAF2FB003594DA00FFFFFF00FFFFFF00C49E8A00C0886200BC835F00A66C
      4F00A2694B009F6549009D624600A7725A00B97C5700B5765400B27251009A5E
      4300975B420097594000BA918000000000000000000000000000B3B3B300E4E4
      E400B3B3B3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000046413B00857A7000C3B8
      AE007C7268007F756B0036322D00F2F2F1004C4A470095897D00BAAEA2007C72
      68007F756B000101010000000000000000003C9DDB00F2FAFD0094E6F80092E5
      F80090E5F8008BE3F80086E2F7007FE1F70077DEF6006CDCF6005ED9F4004FD5
      F300CCF2FB003594DA00FFFFFF00FFFFFF00C8916B0000000000000000000000
      0000000000000000000000000000C1845E000000000000000000000000000000
      00000000000000000000975A4000000000000000000000000000B4B4B400E5E5
      E500B3B3B300000000003D3D3D00363636002F2F2F0028282800212121001B1B
      1B00141414000F0F0F009898980000000000000000004D47410083786F00CCC3
      BA00786F65007B71670034302D00FEFEFE002C2A270095897D00C2B8AD00786F
      65007C7268000605050000000000000000003BA3DB00F6FCFE0094E5F80093E5
      F80093E5F80091E5F80093DBE90093D7E30093D2DC0090CED7008CC8CF0086C1
      C600C9D8D6003594DA00CA815500CD865C00CB97710000000000000000000000
      0000000000000000000000000000C58963000000000000000000000000000000
      00000000000000000000995D4300000000000000000000000000B6B6B600E6E6
      E600B3B3B3000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000554E480083786F00CCC3
      BA007970660071685F00585550000000000049464500857A7000C2B8AD00786F
      65007B7167000D0C0B0000000000000000003BA8DB00FEFFFF00F8FDFF00F6FD
      FF00F5FCFF00F3FCFE009AE4F4009AE6F7009BE6F6009DE5F5009EE5F5009FE5
      F400DAF3F8003594DA00FDF4EE00CB835800CF9D750000000000000000000000
      0000000000000000000000000000C89067000000000000000000000000000000
      000000000000000000009D604500000000000000000000000000B8B8B800E8E8
      E800B5B5B500000000004F4F4F0048484800414141003A3A3A00323232002B2B
      2B000000000000000000000000000000000000000000817B76009F928600CCC3
      BA00C0B4AA00A6988B00807D79000000000074726F0090847900C2B8AD00C0B4
      AA00A89B8E0049474700000000000000000039ADDB00E8F6FB0070BCE70055AA
      E2004DA5E00091C9EB00FAF3EF00FDFEFD00FFFDFC00FFFDFC00FEFDFC00FEFC
      FB00FEFEFD003594DA00EFF2E800CE815600D5A47C0000000000000000000000
      0000000000000000000000000000CF986E000000000000000000000000000000
      00000000000000000000A4674A00000000000000000000000000BABABA00EBEB
      EB00B7B7B7000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FCFCFC0060595200423D38005851
      4A003D383300332F2B0039373400D3D3D3005F5E5C001A181600252220001917
      15000F0E0D0012121200FDFDFD000000000040AEDC00F1FAFD0094DEF50093DC
      F40064BCE9003594DA003594DA003594DA003594DA003594DA003594DA003594
      DA003594DA003594DA00FBF6EF00CC835600D9A9820000000000000000000000
      0000000000000000000000000000D39D73000000000000000000000000000000
      00000000000000000000A86B4E00000000000000000000000000BBBBBB00EDED
      ED00B9B9B900000000006060600059595900535353004C4C4C00454545003D3D
      3D00363636002F2F2F00A5A5A50000000000FDFDFD009D918500B1A396007F75
      6B007C726800776D64006C635B002E2A2600564F480080766C007C726800776D
      640070675E0001010100FAFAFA000000000041B4DC00F7FCFE008EE4F80091DE
      F5009FE0F500ACE1F600CA845200FFF7F100FFE9D900FFEADB00FFE9D900FFE7
      D700FFE5D200FFE2CB00FFF7F100CB855600DBAD860000000000000000000000
      0000000000000000000000000000D6A178000000000000000000000000000000
      00000000000000000000AD705200000000000000000000000000BCBCBC00EFEF
      EF00BBBBBB000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFDFD00B8ACA100BAAEA2008277
      6D0082776D00AA917B00BAA79400B8A69000B09781009F8D7D00836D5B007163
      570095897D0023232200FCFCFC00000000003CB5DB00FDFEFE00FEFFFF00FEFE
      FF00FDFEFF00FEFFFF00E4BA9100FFF7F000FFE7D500FDE7D600FDE6D400FCE4
      D000FBE3CB00FADCC200FEF3E800CC865700DEB18C0000000000000000000000
      0000000000000000000000000000DAA67E000000000000000000000000000000
      00000000000000000000B1775600000000000000000000000000BCBCBC00F0F0
      F000BBBBBB00000000006D6D6D0068686800636363005C5C5C00565656004F4F
      4F0000000000000000000000000000000000FDFCFC00DDDAD7009B8E82009D91
      8500867B7100564F4800504A440080766C006E665D00826C5800A6917D009484
      7400564F48008B8A8A00FEFEFE000000000059C2E00061C3E20063C4E30063C4
      E30063C4E30062C4E300E4BB9100FFF7F200FEE7D500FEE7D500FDE5D100FAE0
      CA00F9DEC400F7D9BC00FDF2E700CC875800E0B48F0000000000000000000000
      0000000000000000000000000000DCAA82000000000000000000000000000000
      00000000000000000000B67F5B00000000000000000000000000BCBCBC00F0F0
      F000BCBCBC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000746B6200A497
      8A0095897D009F9286003E393400000000004C4640007E746A00857A70003E39
      340085817E00F5F5F500FDFDFD0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E4BB9200FEF7F100FCE5D200FCE4D100FBE2CC00F9DD
      C400F6D7BB00F3D1AF00FAEFE400CC875900E2B6920000000000000000000000
      0000000000000000000000000000DFAD86000000000000000000000000000000
      00000000000000000000BB846100000000000000000000000000BCBCBC00BCBC
      BC00BCBCBC00000000007777770074747400707070006B6B6B00656565006060
      60005959590053535300B4B4B400000000000000000000000000000000000000
      00009B918700C3B8AE00655D5500000000007C726800A89B8E00A69B90000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E4BB9200FEF6F000FCE2CD00FCE3CD00FADFC800F7D9
      BC00F5E9DD00FAF3EB00FBF8F300CA835400E3B99500E3B99400E3B89300E2B7
      9100E2B69000E2B58E00E1B38C00E0B28A00E0B18900DFAF8700DFAE8500DEAC
      8200DDAB8000DDA97E00C08C6700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A79C9100BCB0A4009D91850000000000AEA093009D9185007B756E000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E4BB9300FEF5ED00FCDEC500FBE0C700F9DCC200F5D3
      B400FEF9F300FAE2C400ECC19300DCB49600E4BFA000EDC8A900EDC7A800EDC7
      A800ECC6A700ECC5A500ECC4A400E2B89700EBC3A100EBC19F00EAC09D00EABF
      9C00EABE9A00E9BD9800C3957400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E5BE9600FFFFFE00FDF3E900FDF3EA00FCF2E800FAEF
      E300FAF2E700EABB8800DDA98800FBF8F600E2CDBD00E5C5A900E3BA9500D8AF
      8800D6AB8600D4A98100D1B19500D0AD9500E3C0A300E1B48D00E1B28A00D1A2
      7C00CE9F7700CBA68900DDC6B800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EAC39D00E6BF9600E4BB9200E4BB9200D3A47200D2A1
      7200D3A57600E2BDA200FCFAF800FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000900000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000F81F000000000000
      F007000000000000E203000000000000C013000000000000C091000000000000
      D19900000000000091F900000000000091F9000000000000C091000000000000
      C813000000000000C403000000000000E187000000000000F00F000000000000
      FFFF000000000000FFFF000000000000FFFFFFFFFFC1FFC1FFFFFFFFFF80FF80
      FFFFC00300080000FFFFC0037F9C7F9CEF7FC00360086000E73FC00340004000
      E31FC00340014001E10FC00340054005E007C00340054005E10FC00340054005
      E31FC00340054005E73FC0037FFD7FFDEF7FC00300010001FFFFC00300010001
      FFFFFFFF00010001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF07FFFFFFFFFFFFFF
      F9FF00010001FFFFFC7F01FD7F01FFFFF83F01054101FDEFF01F00054001F9CF
      E00F00054001F18FC00700054001E10F800300054001C00F000301054101E10F
      E00701054101F18FF80301FD7F01F9CFFC0100010001FDEFFE2000010001FFFF
      FFF000010001FFFFFFF9FFFFFFFFFFFFFFFFFFFFFFFFFFC1FFFFFFFFFFFFFF80
      FFFFFFFFFFFF0000FFFFE00FF07F7F9CE187F187F8FF6000E3CFF1C7FC7F4000
      E3CFF187FC7F4001E3CFF187FC7F4005E3CFF01FFE3F4005A24DF10FFE3F4005
      8249F18FFE3F40058001F18FFF1F7FFDFFFFE00FFE0F0001FFFFFFFFFFFF0001
      FFFFFFFFFFFF0001FFFFFFFFFFFFFFFFFFFFC000FFEBF1FFFFFF0000FFE18103
      0001000ED8C0B1FF7DFD0000C021BFFF45050000C700BF1F7D050000CF85B810
      45050000DF80BB1F7D050000F80FBBFF45050000E01FB1FF7D050000C03F8107
      45050000C1DFB1FF7DFD0000C79FBFFF00010000C71F1FFF00010000C21F107F
      00010000E01F1FFFFFFF8000FFFFFFFF8001FFFFFFFFFC008001F00FFFFFFC00
      8001E007FCFFFC008001C003F0F9FC008001800100F100008001800100E00000
      8001800100C00000800180010084000080018001008400008001800100C00000
      8001800100E000008001800100F100018001C003F0F9003F8001E007FCFF003F
      8003F00FFFFF403F8007FFFFFFFF007FFFFF80048000E007FFFF000000000000
      8003000000000000800300000000000080030000000000008003000000000000
      8003000000000000800300000000000080030000000000008003000000000000
      8003000000008001C1FE00000000C003E3FE00000000E007FFF500000000E007
      FFF300000000E007FFF100000000E01FFFFFFFFFFFFF8001FFFFFC3FFFFF8001
      FF9F0000F3FF8001FF1F0000F1FF8001FE1F0000F0FF8001FC1F0000F07F8001
      F01F0000F01F8001F01F0000F01F8001F01F0000F01F8001F81F0000F03F8001
      FC1F0000F07F8001FE1F0000F0FF8001FF1F0000F1FF8001FF9F0000F3FF8001
      FFFF8181FFFF8003FFFFFFFFFFFF8007FFFFFFFF8004FFFFFFFFFFFF0000FFFF
      C40F800300000001C7FF800300007EFDC401800300007EFDC7FF810300007EFD
      C40F810300007EFDC7FF000100007EFDC401000100007EFDC7FF000100007EFD
      C40F000100007EFDC7FFC10100007EFDC401F11F00000001FFFFF11F00000001
      FFFFFFFF00000001FFFFFFFF0000FFFF00000000000000000000000000000000
      000000000000}
  end
  object mViewTabsPopup: TTntPopupMenu
    Images = theImageList
    Left = 400
    Top = 128
    object miCloseViewTab: TTntMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1082#1083#1072#1076#1082#1091
      ImageIndex = 31
      OnClick = miCloseTabClick
    end
    object miNewViewTab: TTntMenuItem
      Caption = #1053#1086#1074#1072#1103' '#1074#1082#1083#1072#1076#1082#1072
      ImageIndex = 30
      OnClick = miNewTabClick
    end
  end
end
