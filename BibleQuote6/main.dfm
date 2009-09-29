object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1062#1080#1090#1072#1090#1072' '#1080#1079' '#1041#1080#1073#1083#1080#1080
  ClientHeight = 688
  ClientWidth = 964
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial Unicode MS'
  Font.Style = []
  KeyPreview = True
  Menu = theMainMenu
  OldCreateOrder = True
  Position = poDesigned
  ShowHint = True
  OnActivate = TntFormActivate
  OnClose = FormClose
  OnCloseQuery = TntFormCloseQuery
  OnCreate = FormCreate
  OnDeactivate = TntFormDeactivate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Label4: TTntLabel
    Left = 336
    Top = 48
    Width = 29
    Height = 15
    Alignment = taRightJustify
    Caption = 'Ctrl+1'
  end
  object Splitter1: TTntSplitter
    Left = 298
    Top = 27
    Width = 2
    Height = 661
    MinSize = 100
    OnMoved = Splitter1Moved
  end
  object MainPanel: TTntPanel
    Left = 421
    Top = 27
    Width = 543
    Height = 661
    Align = alRight
    Caption = 'MainPanel'
    TabOrder = 0
    object mBibleTabsEx: TDockTabSet
      Tag = -1
      Left = 1
      Top = 632
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
      DockSite = False
    end
    object mViewTabs: TAlekPageControl
      Left = 1
      Top = 1
      Width = 541
      Height = 631
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
          Left = 3
          Top = -94
          Width = 533
          Height = 511
          OnHotSpotClick = FirstBrowserHotSpotClick
          OnImageRequest = FirstBrowserImageRequest
          TabOrder = 0
          PopupMenu = BrowserPopupMenu
          DefBackground = 14870763
          BorderStyle = htSingle
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
          OnMouseWheel = FirstBrowserMouseWheel
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
          ExplicitWidth = 69
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
    Height = 661
    ActivePage = GoTab
    Align = alLeft
    Images = theImageList
    MultiLine = True
    PopupMenu = RefPopupMenu
    TabOrder = 3
    TabWidth = 36
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
        ExplicitWidth = 291
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
          ItemHeight = 15
          PopupMenu = EmptyPopupMenu
          TabOrder = 1
          OnChange = BooksCBChange
          OnCloseUp = BooksCBCloseUp
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
        Height = 378
        ActivePage = tbQuickSearch
        Align = alClient
        TabOrder = 1
        object HistoryTab: TTntTabSheet
          Caption = 'HistoryTab'
          object HistoryLB: TTntListBox
            Left = 0
            Top = 0
            Width = 282
            Height = 348
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
          object BookmarksLB: TTntListBox
            Left = 0
            Top = 0
            Width = 282
            Height = 237
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
            Top = 237
            Width = 282
            Height = 111
            Align = alBottom
            BevelOuter = bvNone
            BorderWidth = 10
            TabOrder = 1
            object BookmarkLabel: TTntLabel
              Left = 10
              Top = 10
              Width = 75
              Height = 15
              Align = alClient
              Caption = 'BookmarkLabel'
              WordWrap = True
            end
          end
        end
        object tbQuickSearch: TTntTabSheet
          Caption = #1041#1099#1089#1090#1088#1099#1081' '#1087#1086#1080#1089#1082
          object SearchInWindowLabel: TTntLabel
            Left = 0
            Top = 0
            Width = 282
            Height = 15
            Align = alTop
            Caption = #1053#1072#1081#1090#1080' '#1074' '#1101#1090#1086#1084' '#1086#1082#1085#1077
            Layout = tlCenter
            ExplicitWidth = 94
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
            object btnQuickSearchBack: TTntBitBtn
              Left = 4
              Top = 16
              Width = 26
              Height = 25
              TabOrder = 0
              OnClick = SearchBackwardClick
              Style = bsNew
            end
            object SearchEdit: TTntEdit
              Left = 37
              Top = 17
              Width = 207
              Height = 23
              Hint = ' '
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              OnKeyUp = SearchEditKeyUp
            end
            object btnQuickSearchFwd: TTntBitBtn
              Left = 250
              Top = 16
              Width = 26
              Height = 25
              Anchors = [akTop, akRight]
              TabOrder = 2
              OnClick = btnQuickSearchFwdClick
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
        Height = 452
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
          Width = 61
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
      object DicBrowser: THTMLViewer
        Left = 0
        Top = 232
        Width = 290
        Height = 399
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
          Width = 166
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
      object StrongBrowser: THTMLViewer
        Left = 0
        Top = 206
        Width = 290
        Height = 425
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
      object CommentsBrowser: THTMLViewer
        Left = 0
        Top = 30
        Width = 290
        Height = 601
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
          OnCloseUp = CommentsCBCloseUp
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
        Height = 631
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
        Top = 25
        Width = 290
        Height = 579
        Align = alClient
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
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
        Top = 604
        Width = 290
        Height = 27
        Align = alBottom
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
        Top = 2
        Width = 285
        Height = 23
        Margins.Left = 2
        Margins.Top = 2
        Margins.Bottom = 0
        GradientEndColor = 11517638
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
    Width = 964
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
      Width = 334
      Height = 25
      Margins.Right = 7
      Align = alClient
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lbTitleLabel'
      Transparent = True
      Layout = tlCenter
      ExplicitLeft = 533
      ExplicitWidth = 366
    end
    object lbCopyRightNotice: TTntLabel
      AlignWithMargins = True
      Left = 905
      Top = 4
      Width = 51
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
      EdgeInner = esNone
      EdgeOuter = esNone
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
        Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1082#1083#1072#1076#1082#1091' '#1074#1080#1076#1072
        Caption = 'NewTabButton'
        ImageIndex = 30
        OnClick = miNewTabClick
      end
      object CloseTabButton: TTntToolButton
        Left = 54
        Top = 0
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1082#1083#1072#1076#1082#1091' '#1074#1080#1076#1072
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
        Style = tbsCheck
        OnClick = miStrongClick
      end
      object MemosButton: TTntToolButton
        Left = 240
        Top = 0
        Caption = 'Memos'
        ImageIndex = 29
        Style = tbsCheck
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
        OnClick = PreviewButtonClick
      end
      object PrintButton: TTntToolButton
        Left = 294
        Top = 0
        Caption = 'Print'
        ImageIndex = 11
        OnClick = PrintButtonClick
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
      GradientEndColor = 11517638
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
    object miOpenNewView: TTntMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074' '#1085#1086#1074#1086#1081' '#1074#1082#1083#1072#1076#1082#1077
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
      0000010001001010000001000800680500001600000028000000100000002000
      0000010008000000000040010000000000000000000000010000000000000000
      0000FFFFFF00E09B6100C25F0800C6620900C4600900C3600900D78A4300D78C
      4600D88E4900DF975700E3A06400E1A36900E09C5A00E9AB6C00E1A87100E2AC
      7700E4AE7900E8B37F00E8B58200EAC49E00EBA25600F2B36D00EFB16E00F3B7
      7400EBB88300DFB07E00E0B28200F1D3B300F6C48B00E6B98500EBC29100E6C1
      9400EBCBA600E7C49800EED1AB00FEE8CC00FFECD200EDCC9E00F4DCB800F2DB
      B400F9E6C500F5E3BD00FAF0CF00FBF2D100FDF7D800FDF8D800FEFADC00FFFC
      DE00FFFFFF000000000000000000000000000000000000000000000000000000
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
      0000000004090904000000000000000000000004132525130400000000000000
      0000041324181D251304000000000000000413290E15151D2510060000000000
      0410210F1E130C0D19211B03000000040F142730303030281F30302203000410
      142B30302A272E3030302D21110407232830280B020B0223302B0D262507071C
      2330260A020A0C28302A0A1F250704111423302F2A2C303030302B2111040004
      111C1E293030302A1F303020030000000412270B0D0C0D0A0E231A0300000000
      0004122517151518240F05000000000000000412241616241204000000000000
      000000041225251204000000000000000000000004080704000000000000FC3F
      0000F81F0000F00F0000E0070000C00300008001000000000000000000000000
      00000000000080010000C0030000E0070000F00F0000F81F0000FC3F0000}
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
        OnClick = PrintButtonClick
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
        Caption = #1053#1086#1074#1072#1103' '#1074#1082#1083#1072#1076#1082#1072
        ImageIndex = 30
        ShortCut = 16468
        OnClick = miNewTabClick
      end
      object miCloseTab: TTntMenuItem
        Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1082#1083#1072#1076#1082#1091
        ImageIndex = 31
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
        Caption = #1052#1080#1085#1080'-'#1088#1077#1076#1072#1082#1090#1086#1088
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
      object miAbout: TTntMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = miAboutClick
      end
    end
    object miLanguage: TTntMenuItem
      Caption = 'Do you speak...'
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
      000000000000F7F7EF00E7CEBD00DEC6AD00D6BD9C00DEC6B500F7EFE7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DEC6AD00BD8C6300D6BD9C00DEC6B500E7CEBD00DEC6AD00C6946B00D6B5
      9400FFFFF7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6BD
      9C00CEA58400F7F7EF0000000000FFFFF700EFE7DE00F7EFE700FFFFF700D6B5
      9400CEA58400FFFFF70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFDECE00C694
      6B00FFFFF700F7EFE700CEAD8C00BD8C6300C6946B00BD8C6300C6946B000000
      0000CEAD8C00DEC6AD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CEA58400E7D6
      C600FFFFF700C69C7B00BD8C6300E7D6C60000000000EFDECE00BD8C63000000
      0000F7F7EF00BD8C6300FFFFF700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BD8C63000000
      0000EFDECE00BD8C6300CEA584000000000000000000F7F7EF00DEC6B5000000
      000000000000CEA58400EFE7DE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFE7DE00C69C7B000000
      0000DEC6B500BD8C6300DEC6AD00000000000000000000000000000000000000
      000000000000D6B59400DEC6B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFF700BD8C63000000
      0000E7D6C600BD8C6300CEAD8C00000000000000000000000000000000000000
      000000000000CEAD8C00EFDECE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6946B00EFE7
      DE00F7F7EF00C6946B00BD8C6300F7EFE70000000000EFE7DE00BD8C63000000
      0000FFFFF700C6946B00F7EFE700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DEC6AD00D6B5
      940000000000E7D6C600C6946B00C6946B00DEC6AD00CEA58400BD8C63000000
      0000E7CEBD00CEAD8C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFF700C69C
      7B00D6BD9C0000000000F7F7EF00E7CEBD00DEC6B500DEC6B500EFDECE00E7D6
      C600C6946B00F7EFE70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7EF
      E700CEA58400CEAD8C00EFDECE000000000000000000F7EFE700D6BD9C00C694
      6B00EFDECE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFF700E7CEBD00CEA58400BD8C6300BD8C6300CEA58400DEC6AD00F7F7
      EF00000000000000000000000000000000000000000000000000000000000000
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
      000000000000000000000000000000000000000000000000000084B594002173
      4200186B31002173420084B59400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094B5E700215A
      C6000042BD00185AC60084A5DE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7F7
      EF00D6D6BD00A59C6B00847B39007B7329007B7329007B732900BD7B2900D67B
      2900D67B2900D67B290000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008CB59400298C520063BD
      8C0094D6B50063BD8C00298C520084AD94000000000000000000000000000000
      000000000000000000000000000000000000000000008CADE7002963CE002173
      E700007BEF000063DE00004ABD0084A5DE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7EF00D6D6BD00948C
      5200847B4200CED6BD00EFF7F700EFF7F700EFF7F700EFF7F700DEA56300D67B
      2900D67B2900D67B29000000000000000000C6A58C00C68C6B00C68C6300BD8C
      6300BD846300BD845A00B57B5A00B57B5A00B57B5A00216B390063BD8C0063BD
      84000000000063BD840063BD8C0021733900C6A58C00C68C6B00C68C6300BD8C
      6300BD846300BD845A00B57B5A00B57B5A00B57B5A00104AAD00639CF700187B
      FF000073FF000073EF00006BE700185AC6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6D6BD00948C52008C7B4200D6C6
      9C00E7BD8C00E7EFE700E7F7F700E7F7F700E7F7F700E7F7F700E7CEB500D67B
      2900D67B2900D67B29000000000000000000CE946B0000000000000000000000
      00000000000000000000000000000000000000000000317B4A009CD6B5000000
      0000000000000000000094D6B500186B3100CE946B0000000000000000000000
      000000000000000000000000000000000000000000000042BD00ADCEFF000000
      00000000000000000000187BEF000042BD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009C844A00DEBD8C00E7AD7300DEAD
      6B00DEAD6B00DED6BD00DEF7F700DEF7EF00DEF7EF00DEF7F700E7F7F700DECE
      AD00DE9C5A00D67B29000000000000000000CE946B000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004A8C630094D6B50094D6
      B5000000000063BD8C0063BD8C0021733900CE946B000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00215AC6008CB5F7004A94
      FF001073FF002184FF00428CEF00215AC6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEAD6B00DEA56B00DE9C6300DEA5
      6300DEAD6B00DEC69C00DEEFEF00D6EFEF00D6EFEF00DEEFEF00DEF7F700E7F7
      F700EFF7F7007B7329000000000000000000CE946B0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A5C6B50063AD840094D6
      B500BDE7D6006BBD8C00298C520084AD9400CE946B0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0094B5E7003973D6008CB5
      F700BDD6FF0073ADF700296BCE0094ADE7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEAD6B00D69C6300D6945A00D69C
      6300DEAD6B00DEB58400D6EFEF00D6EFEF00D6EFEF00D6EFEF00DEF7EF00E7F7
      F700EFF7F7007B7329000000000000000000D69C730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00ADCEB500639C
      73004A8C63004A8C6300737B520000000000D69C730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0094ADDE002963
      C6000042BD00215AC6005A638400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEAD6B00D69C6300D69C5A00DE9C
      6300DEB58400EFE7D600EFE7DE00D6EFEF00D6EFEF00D6EFEF00DEF7F700E7F7
      F700EFF7F7007B7329000000000000000000D69C730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFF700FFF7
      F700FFF7F70000000000B57B5A0000000000D69C730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFF700FFF7
      F700FFF7F70000000000B57B5A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEAD6B00DEA56B00DEA56B00DEBD
      8C00F7E7CE00FFE7CE00FFE7CE00EFE7D600D6EFEF00DEEFEF00DEF7F700E7F7
      F700EFF7F7008C7B39000000000000000000D6A5730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFF700FFF7F700FFF7F700FFF7
      EF00FFF7EF0000000000B57B5A0000000000D6A5730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFF700FFF7F700FFF7F700FFF7
      EF00FFF7EF0000000000B57B5A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEAD6B00DEAD6B00E7C69400F7E7
      CE00FFE7CE00FFE7CE00FFE7CE00FFE7CE00DED6BD00DEB58400E7CEB500E7E7
      DE00C6C6AD00ADA57B000000000000000000DEA57B0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFF700FFFFF700FFF7F700FFF7F700FFF7EF00F7F7EF00F7F7
      EF00F7EFEF0000000000B5845A0000000000DEA57B0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFF700FFFFF700FFF7F700FFF7F700FFF7EF00F7F7EF00F7F7
      EF00F7EFEF0000000000B5845A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEAD6B00EFCEA500FFE7CE00FFE7
      CE00FFE7CE00FFE7CE00FFE7CE00E7DEC600E7AD7300E7A57300E7A57300E7BD
      940073631800DEDECE000000000000000000DEA57B0000000000FFFFFF00FFFF
      FF00FFFFF700FFF7F700FFF7F700FFF7F700F7F7EF00F7EFEF00F7EFE700F7EF
      E700F7E7DE0000000000BD84630000000000DEA57B0000000000FFFFFF00FFFF
      FF00FFFFF700FFF7F700FFF7F700FFF7F700F7F7EF00F7EFEF00F7EFE700F7EF
      E700F7E7DE0000000000BD846300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EFD6B500FFE7CE00FFE7CE00FFE7
      CE00FFE7CE00FFE7CE00EFE7CE00E7AD7300DEA56B00E7A57300E7AD7300AD9C
      6B00BDB59400FFFFF7000000000000000000DEA57B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BD84630000000000DEA57B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BD846300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFE7CE00FFE7CE00FFE7CE00FFE7
      CE00FFE7CE00F7E7CE00DEB57B00DEA56B00DEA56B00E7A56B00DEBD94008C84
      4A00EFEFE700000000000000000000000000DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00C68C630000000000DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00C68C6300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFE7CE00FFE7CE00FFE7CE00FFE7
      CE00FFE7CE00E7B58C00DEA56B00DEA56B00DEA56B00E7B584007B732900DED6
      C60000000000000000000000000000000000DEAD8400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400C694730000000000DEAD8400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400C6947300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFE7CE00FFE7CE00FFE7CE00FFE7
      CE00E7C6A500E7A57300E7A57300DEA56B00E7A57300BDA57B00B5AD8400F7F7
      F70000000000000000000000000000000000DEC6B500DEB59400DEA57B00DEA5
      7B00DEA57B00DEA57B00D6A57300D69C7300D69C7300CE9C7300CE9C7300CE94
      6B00CE946B00C69C8400DEC6B50000000000DEC6B500DEB59400DEA57B00DEA5
      7B00DEA57B00DEA57B00D6A57300D69C7300D69C7300CE9C7300CE9C7300CE94
      6B00CE946B00C69C8400DEC6B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFE7CE00FFE7CE00FFE7CE00EFD6
      B500E7A57300E7A57300E7A57300E7B58C00DEBD94008C7B4200EFEFDE000000
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
      000000000000000000000000000000000000C6A58C00C68C6B00C68C6300BD8C
      6300BD846300BD845A00B57B5A00B57B5A00B57B5A00AD7B5200AD735200AD73
      5200AD735200AD735200C6A58C0000000000C6A58C00AD735200AD735200AD73
      5200AD735200AD7B5200B57B5A00B57B5A00B57B5A00BD845A00BD846300BD8C
      6300C68C6300C68C6B00C6A58C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CE946B00DEFFE700DEFFE700DEFF
      E700CEF7D6009CCEA500317B3900000000000000000000000000000000000000
      00000000000000000000AD73520000000000AD73520000000000000000000000
      000000000000000000000000000000000000317B39009CCEA500CEF7D600DEFF
      E700DEFFE700DEFFE700CE946B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000CE946B00DEFFE700DEFFE700DEFF
      E700CEF7D600A5D6A500398C4200000000006B9C6B00FFFFF700FFFFFF00FFFF
      FF00FFFFFF0000000000AD73520000000000AD73520000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFF7006B9C6B0000000000398C4200A5D6A500CEF7D600DEFF
      E700DEFFE700DEFFE700CE946B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0084848400FFFFFF0000FFFF00FFFFFF00000000000000
      000000000000000000000000000000000000CE946B00DEFFE700DEFFE700DEFF
      E700CEF7D600A5D6AD005AA55A00D6E7D60039844200528C5200FFFFFF00FFFF
      F700FFFFF70000000000AD73520000000000AD73520000000000FFFFF700FFFF
      F700FFFFFF00528C520039844200D6E7D6005AA55A00A5D6AD00CEF7D600DEFF
      E700DEFFE700DEFFE700CE946B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0084848400FFFFFF00C6C6C6008484840000FFFF00FFFFFF000000
      000000000000000000000000000000000000D69C7300DEFFE700DEFFE700DEFF
      E700D6F7D600ADDEB5006BB5730052A55A006BB573005AA55A005A945A00FFFF
      F700FFFFF70000000000B57B5A0000000000B57B5A0000000000FFFFF700FFFF
      F7005A945A005AA55A006BB5730052A55A006BB57300ADDEB500D6F7D600DEFF
      E700DEFFE700DEFFE700D69C7300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0084848400FFFFFF00C6C6C6008484840000FFFF00FFFFFF0000FFFF008484
      840000000000000000000000000000000000D69C7300DEFFE700DEFFE700DEFF
      E700D6F7D600ADDEB50073BD7B0094CE9C008CCE94008CCE94005AA563003984
      4200FFF7F70000000000B57B5A0000000000B57B5A0000000000FFF7F7003984
      42005AA563008CCE94008CCE940094CE9C0073BD7B00ADDEB500D6F7D600DEFF
      E700DEFFE700DEFFE700D69C7300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008484
      8400FFFFFF00C6C6C6008484840000FFFF00FFFFFF0000FFFF0084848400C6C6
      C600C6C6C600000000000000000000000000D6A57300DEFFE700DEFFE700DEFF
      E700D6F7D600ADE7B5007BC6840052AD5A006BB5730063B56B0063A56B00FFF7
      EF00FFF7EF0000000000B57B5A0000000000B57B5A0000000000FFF7EF00FFF7
      EF0063A56B0063B56B006BB5730052AD5A007BC68400ADE7B500D6F7D600DEFF
      E700DEFFE700DEFFE700D6A57300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00C6C6C6008484840000FFFF00FFFFFF0000FFFF0084848400C6C6C600C6C6
      C600C6C6C600000000000000000000000000DEA57B00DEFFE700DEFFE700DEFF
      E700D6FFD600B5E7BD005ABD6B00000000005AAD63006BB56B00F7F7EF00F7F7
      EF00F7EFEF0000000000B5845A0000000000B5845A0000000000F7EFEF00F7F7
      EF00F7F7EF006BB56B005AAD6300000000005ABD6B00B5E7BD00D6FFD600DEFF
      E700DEFFE700DEFFE700DEA57B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF0084848400C6C6C600C6C6C600C6C6
      C60000000000000000000000000000000000DEA57B00DEFFE700DEFFE700DEFF
      E700D6FFD600B5EFBD0063C673000000000084C68C00F7EFE700F7EFE700F7EF
      E700F7E7DE0000000000BD84630000000000BD84630000000000F7E7DE00F7EF
      E700F7EFE700F7EFE70084C68C000000000063C67300B5EFBD00D6FFD600DEFF
      E700DEFFE700DEFFE700DEA57B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0084848400C6C6C600C6C6C600C6C6C6008484
      840084000000000000000000000000000000DEA57B00DEFFE700DEFFE700DEFF
      E700D6FFD600B5EFBD006BC67300000000000000000000000000000000000000
      00000000000000000000BD84630000000000BD84630000000000000000000000
      0000000000000000000000000000000000006BC67300B5EFBD00D6FFD600DEFF
      E700DEFFE700DEFFE700DEA57B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600C6C6C600C6C6C600000000008400
      000084000000840000000000000000000000DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00C68C630000000000C68C6300DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00DEA57B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000840000008400000000000000DEAD8400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400C694730000000000C6947300EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400DEAD8400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000840000008400000000000000DEC6B500DEB59400DEA57B00DEA5
      7B00DEA57B00DEA57B00D6A57300D69C7300D69C7300CE9C7300CE9C7300CE94
      6B00CE946B00C69C8400DEC6B50000000000DEC6B500C69C8400CE946B00CE94
      6B00CE9C7300CE9C7300D69C7300D69C7300D6A57300DEA57B00DEA57B00DEA5
      7B00DEA57B00DEB59400DEC6B500000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000292929002121210018181800101010001010100008080800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B5B5
      B50073737300636363005A5A5A00848484007B7B7B004A4A4A0073737300E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      00009C9C9C00636363005A5A5A00525252006363630000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009494
      9400737373007B7B7B00CECECE0000000000000000009C9C9C004A4A4A004242
      4200949494000000000000000000000000000000000000000000000000000000
      00009C9C9C00424242005252520000000000000000009C9C9C00212121001818
      1800E7E7E7000000000000000000000000000000000000000000000000000000
      000000000000CECECE0031313100292929000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E7E7E7007B7B7B005A5A5A005A5A5A007B7B7B00D6D6D6000000
      000000000000000000000000000000000000000000000000000000000000D6D6
      D6004A4A4A00A5A5A50000000000000000000000000000000000424242004A4A
      4A00000000000000000000000000000000000000000000000000000000000000
      0000A5A5A500424242006B6B6B00000000000000000000000000181818002929
      29008C8C8C000000000000000000000000000000000000000000000000000000
      000000000000000000005252520039393900BDBDBD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EFEFEF004A4A4A005A5A5A00E7E7E70000000000CECECE0042424200E7E7
      E70000000000000000000000000000000000000000000000000000000000D6D6
      D60052525200A5A5A50000000000000000000000000000000000525252005252
      5200000000000000000000000000000000000000000000000000000000000000
      0000A5A5A5004A4A4A00737373000000000000000000F7F7F700212121002929
      29009C9C9C000000000000000000000000000000000000000000000000000000
      0000000000000000000094949400424242007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009C9C9C004A4A4A00C6C6C600000000000000000000000000CECECE008484
      840000000000000000000000000000000000000000000000000000000000DEDE
      DE005A5A5A00ADADAD00000000000000000000000000000000005A5A5A005252
      5200000000000000000000000000000000000000000000000000000000000000
      0000ADADAD005252520073737300000000000000000084848400393939004A4A
      4A00F7F7F7000000000000000000000000000000000000000000000000000000
      00000000000000000000DEDEDE00424242004242420000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484005252520000000000000000000000000000000000000000005A5A
      5A0000000000000000000000000000000000000000000000000000000000DEDE
      DE0063636300ADADAD0000000000000000000000000000000000636363005A5A
      5A00000000000000000000000000000000000000000000000000000000000000
      0000B5B5B5005A5A5A006B6B6B00A5A5A5006B6B6B00424242006B6B6B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000636363004A4A4A00C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C8C8C005A5A5A0000000000000000000000000000000000000000006363
      63000000000000000000000000000000000000000000D6D6D60000000000DEDE
      DE006B6B6B00B5B5B50000000000BDBDBD00EFEFEF00000000006B6B6B006363
      63000000000000000000B5B5B500000000000000000000000000000000000000
      0000B5B5B5005A5A5A008484840000000000F7F7F7005A5A5A00424242008484
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009C9C9C00525252008C8C8C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C8C8C006363630000000000000000000000000000000000000000006B6B
      6B00000000000000000000000000000000000000000094949400E7E7E700DEDE
      DE0073737300B5B5B500000000006B6B6B009C9C9C0000000000737373006B6B
      6B0000000000949494008C8C8C00000000000000000000000000000000000000
      0000B5B5B500636363008C8C8C000000000000000000A5A5A5004A4A4A004242
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E7E7E700525252005A5A5A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000949494006B6B6B0000000000000000000000000000000000000000007373
      730000000000000000000000000000000000000000009C9C9C009C9C9C00B5B5
      B5009C9C9C00A5A5A5009C9C9C006B6B6B0073737300A5A5A5007B7B7B007B7B
      7B00848484004A4A4A00BDBDBD00000000000000000000000000000000000000
      0000BDBDBD006B6B6B008C8C8C00000000000000000094949400525252006B6B
      6B00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737373005A5A5A00BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000949494006B6B6B0000000000000000000000000000000000000000007373
      7300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CECE
      CE0094949400737373007B7B7B00B5B5B500949494006B6B6B0094949400F7F7
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B5B5B5006B6B6B0063636300636363007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      00009C9C9C007373730000000000000000000000000000000000F7F7F7007373
      7300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CECE
      CE008484840073737300B5B5B500000000000000000000000000949494005A5A
      5A00B5B5B5000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000C6CEDE008C94
      BD00A5ADC600CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00CECECE00CECECE00CECECE00DEDEDE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004A42
      3900000000005A524A0000000000000000000000000000000000000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00EFEFEF00294AA500315A
      AD002142AD00DEDEDE00DEDEDE00D6D6D600D6D6D600D6D6D600D6D6D600D6D6
      D600CECECE00CECECE00C6C6C600CECECE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006B63
      5A00F7EFEF006B635A00F7EFEF0000000000000000008484840084848400CED6
      D600000000008400000000000000000000008400000084000000840000008400
      000084000000840000000000000000000000C6A58C00C68C6B00C68C6300BD8C
      6300BD846300BD845A00B57B5A00B57B5A00B57B5A00AD7B5200AD735200AD73
      5200AD735200AD735200C6A58C0000000000F7F7F700CECECE00C6C6CE00C6C6
      CE002142AD00FFFFFF00FFFFFF00FFFFFF00F7F7F700EFEFEF00D6D6D600EFEF
      EF00000000000000000000000000CECECE000000000000000000F7EFEF000000
      000000000000F7EFEF00E7DED600E7DED600000000000000000084847B003931
      29004A42390039312900393129005A524A000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      000000000000000000000000000000000000CE946B0000000000000000000000
      00000000000000000000DEA57B00000000000000000000000000000000000000
      00000000000000000000AD73520000000000FFFFFF00E7E7E700637BB500638C
      BD002142AD00FFFFFF00FFFFFF00F7F7F700F7F7F700EFEFEF00F7F7F700CECE
      CE00E7E7E700FFFFFF00FFFFFF00CECECE000000000000000000AD846300DECE
      BD00BD9C8400C6A59400D6C6B500D6C6B500B5947B00D6C6B50000000000C6C6
      BD0094948C00C6C6BD0084847B00000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CE946B0000000000FF8C29009494
      94008484840000000000DEA57B0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000AD73520000000000F7F7F700CECECE00C6C6CE00C6C6
      CE00214AAD00FFFFFF00FFFFFF00FFFFFF00F7F7F700F7F7F700FFFFFF00F7F7
      F700CECECE00E7E7E700FFFFFF00CECECE000000000000000000A57B5A00AD84
      6300EFE7DE00000000000000000000000000FFF7F700B5947B006B5A4A005A52
      4A00292118005A524A00292118005A524A000000000084848400000000000000
      000000000000000000000000000000000000CED6D60000000000CED6D6000000
      000000000000000000000000000000000000CE946B0000000000000000000000
      00000000000000000000DEA57B0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      F700FFFFF70000000000AD73520000000000FFFFFF00E7E7E700637BB5006394
      C600214AAD00FFFFFF00FFFFFF00FFFFFF00F7F7F700F7F7F700FFFFFF00FFFF
      FF00F7F7F700CECECE00EFEFEF00CECECE000000000000000000A57B5A00DECE
      BD000000000000000000000000000000000000000000D6C6B500A57B5A00F7EF
      EF005A524A00000000005A524A00000000000000000084848400000000000000
      0000000000008484840084848400CED6D6000000000084000000000000000000
      000084000000840000008400000084000000D69C730000000000FF9C39009C9C
      9C009C9C9C0000000000DEA57B0000000000FFFFFF00FFFFFF00FFFFF700FFFF
      F700FFFFF70000000000B57B5A0000000000F7F7F700CECECE00C6C6CE00C6C6
      CE00214AB500FFFFFF00FFFFFF00FFFFFF00F7F7F700F7F7F700FFFFFF00FFFF
      FF00FFFFFF00F7F7F700D6D6D600CECECE000000000000000000AD8C6B000000
      00000000000000000000000000000000000000000000BD9C8400A57B5A00E7DE
      D60073736B00E7E7DE0073736B00D6D6CE000000000084848400000000000000
      000000000000848484000000000000000000CED6D60000000000CED6D6000000
      000000000000000000000000000000000000D69C730000000000000000000000
      00000000000000000000DEA57B0000000000FFFFF700FFFFF700FFFFF700FFF7
      F700FFF7F70000000000B57B5A0000000000FFFFFF00E7E7E700637BB5006394
      C6002152B500FFFFFF00FFFFFF00E79C7300DE9C7300DE9C6B00DE9C6B00DE9C
      6B00D6946B00EFEFEF00EFEFEF00CECECE000000000000000000000000000000
      000000000000FFF7F700E7D6CE00CEBDA500AD8C6B00A57B5A00A57B5A00F7EF
      EF00000000000000000000000000000000000000000084848400000000000000
      000000000000CED6D60000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6A5730000000000FFBD6B00ADAD
      AD00ADADAD0000000000DEA57B0000000000FFFFF700FFF7F700FFF7F700FFF7
      EF00FFF7EF0000000000B57B5A0000000000F7F7F700CECECE00C6C6CE00C6C6
      CE002152B500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7F700F7F7
      F700F7F7F700F7F7F700EFEFEF00CECECE00000000000000000000000000E7DE
      D600C6A59400A57B5A00A57B5A00A57B5A00A57B5A00A57B5A00CEBDA5000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      000000000000000000000000000000000000DEA57B0000000000000000000000
      00000000000000000000DEA57B0000000000FFF7F700FFF7EF00F7F7EF00F7F7
      EF00F7EFEF0000000000B5845A0000000000FFFFFF00E7E7E7006384B5006394
      C6002152B500FFFFFF00FFFFFF00E7A57300E7A57300E7A57300DE9C7300DE9C
      7300DE9C6B00F7F7F700F7F7F700CECECE000000000000000000E7DED600A57B
      5A00A57B5A00A57B5A00A57B5A00A57B5A00C6A59400DECEBD00000000000000
      000000000000000000000000000000000000000000008484840084848400CED6
      D600000000008400000000000000000000008400000084000000840000008400
      000084000000000000000000000000000000DEA57B0000000000FFBD6B00BDBD
      BD00B5B5B50000000000DEA57B0000000000F7F7EF00F7EFEF00F7EFE700F7EF
      E700F7E7DE0000000000BD84630000000000F7F7F700CECECE00C6C6CE00C6C6
      CE002152B500FFFFFF00FFFFFF00E7A57B00EFC6A500EFC6A500EFBDA500EFBD
      A500DE9C7300F7F7F700F7F7F700CECECE000000000000000000C6A59400A57B
      5A00AD846300CEBDA500E7DED600000000000000000000000000DECEBD000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      000000000000000000000000000000000000DEA57B0000000000000000000000
      00000000000000000000DEA57B00000000000000000000000000000000000000
      00000000000000000000BD84630000000000FFFFFF00E7E7E7006384B500639C
      C600215AB500FFFFFF00FFFFFF00E7A57B00E7A57B00E7A57300E7A57300E7A5
      7300E7A57300F7F7F700FFFFFF00CECECE000000000000000000BD9C8400A57B
      5A00EFE7DE0000000000000000000000000000000000DECEBD00BD9C84000000
      00000000000000000000000000000000000000000000CED6D600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00C68C630000000000F7F7F700CECECE00C6C6CE00C6C6
      CE00215AB500F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700F7F7F700F7F7F700FFFFFF00CECECE000000000000000000D6C6B500A57B
      5A00FFF7F700000000000000000000000000FFF7F700AD8C6B00BD9C84000000
      000000000000000000000000000000000000E7E7E70000000000CED6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEAD8400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400C694730000000000FFFFFF00E7E7E7006384BD00639C
      C600215ABD00F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700F7F7F700F7F7F700FFFFFF00CECECE000000000000000000FFF7F700B594
      7B00C6AD9C00F7EFEF0000000000E7DED600B5947B00B5947B00BD9C84000000
      0000000000000000000000000000000000006363630000FFFF00000000000000
      0000840000008400000084000000840000008400000000000000000000000000
      000000000000000000000000000000000000DEC6B500DEB59400DEA57B00DEA5
      7B00DEA57B00DEA57B00D6A57300D69C7300D69C7300CE9C7300CE9C7300CE94
      6B00CE946B00C69C8400DEC6B50000000000F7F7F700CECECE00C6C6CE00C6C6
      CE00215ABD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CECECE00000000000000000000000000FFF7
      F700D6C6B500BD9C8400BD9C8400C6AD9C00E7DED600FFF7F700D6C6B5000000
      000000000000000000000000000000000000E7E7E70000000000CED6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700638CC6004A7B
      BD002963BD00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00CECECE00CECECE00CECECE00DEDEDE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7C6AD00CE8C6300C673
      4200BD6B3100BD6B3100BD6B3100BD6B3100BD6B3100BD6B3100BD6B3100BD6B
      3100B56B4200526B84007B94A500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6947300CE845200CE734200CE7B4A00CE7B4A00CE7B
      4A00CE7B4A00CE7B4A00CE845200CE845A0000000000C67B4A00FFF7EF00F7EF
      DE00F7EFDE00F7EFDE00F7EFDE00F7EFDE00FFF7EF00FFF7EF00FFF7EF00EFEF
      EF006B9CBD0073A5CE00397BAD00000000000000000000000000000000000000
      0000F7EFE700D6BDA500B5845A00AD734200AD734200B57B5200D6B59C00F7EF
      E700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CE845200FFF7EF00FFF7EF00FFF7E700FFF7EF00FFF7
      EF00FFF7EF00FFF7EF00FFF7EF00CE845A0000000000C6734200F7EFDE00FFE7
      D600FFE7D600FFE7D600FFE7D600F7DEC600F7D6BD00F7D6BD00E7D6C6007B9C
      C60084B5D60084ADD60039739C0000000000000000000000000000000000E7D6
      C600BD8C5A00D6BDA500EFDECE00EFE7D600EFE7D600EFDECE00D6B59C00B57B
      4A00E7CEBD000000000000000000000000000000000000000000000000000000
      00000000000000000000C6CECE00737373000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CE845200EFF7E700FFEFDE00FFEFDE00FFEFDE00FFE7
      D600FFE7D600FFE7CE00EFF7EF00CE84520000000000C67B4200F7EFE700FFE7
      D600FFE7D600FFE7CE00E7C6A500E7C6A500E7C6A500E7BDA500CEAD8C00A5AD
      B5008CBDE7005A94BD00A56B4A00000000000000000000000000EFDECE00BD8C
      6300E7D6C600E7D6BD00CEA58400BD8C6300B58C6300C6A58400E7CEBD00E7D6
      BD00AD734A00E7D6C60000000000000000000000000000000000000000000000
      0000FFFFFF00ADADAD00636B6B00636363000000000000000000000000000000
      000000000000ADA5F700EFE7FF00000000000000000000000000000000000000
      00000000000000000000CE845200FFF7EF00FFEFDE00FFEFDE00FFEFDE00FFE7
      D600FFE7D600FFE7CE00FFF7EF00CE84520000000000C6844200F7F7E700FFE7
      D600FFE7D600EFCEB500F7DEC600FFE7D600FFE7CE00FFE7CE00F7DEC600DEB5
      9C008C9CAD00DEE7EF00C67339000000000000000000F7F7EF00CE9C7B00EFDE
      CE00E7CEBD00C6946B00BD8C6300CEB59400CEB59400B58C5A00B5846300DEC6
      AD00E7D6C600B5845A00F7EFE70000000000DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00737B7B006B6B6B0073737300636363000000000000000000000000000000
      00009C94F7003931EF005242E70000000000D69C7B00D6946B00CE845A00D68C
      6300D68C6300D68C6300CE845200FFF7F700FFEFDE00FFEFDE00FFEFDE00FFE7
      D600FFE7D600FFE7CE00FFF7F700CE84520000000000C6844A00FFF7EF00FFE7
      D600FFE7D600F7D6BD00FFE7D600F7DEC600F7DEBD00F7D6BD00F7DEC600F7DE
      BD00C6AD9C00FFFFF700C67B42000000000000000000E7CEBD00E7CEBD00EFD6
      C600C69C7300BD946300BD946300F7F7EF00F7F7EF00B58C5A00B58C5A00B58C
      6300E7CEBD00DEBDA500DEBDA50000000000737373006B7373006B6B6B006B6B
      6B006B6B6B00525252005A63630063636300000000000000000000000000B5AD
      F700DEDEFF003929E7003931EF00A59CF700D6946B00FFF7EF00FFF7EF00FFF7
      EF00FFF7EF00FFF7EF00E7BD9400FFF7F700FFE7D600FFE7D600FFE7D600FFE7
      D600FFE7CE00FFDEC600FFF7EF00CE84520000000000C6844A00FFF7EF00FFE7
      D600FFE7D600F7DECE00F7E7D600F7DEC600F7DEC600F7DEC600F7DEBD00F7E7
      CE00DEB59400FFF7F700C68442000000000000000000DEB59400EFE7D600DEB5
      9400C69C6B00C6946B00C6946300BD946300BD946300BD8C6300BD8C6300BD8C
      6300CEA58400EFDECE00C6946B00000000007B7B7B009C9C9C00737B7B006B6B
      6B0052525200393939005A5A5A00636363000000000000000000BDB5F700524A
      EF00ADA5F700ADA5F7004239EF005242E700D6946B00F7F7EF00FFEFDE00FFEF
      E700FFEFDE00FFEFDE00E7BD9400FFF7F700FFE7D600FFE7D600FFE7D600FFE7
      CE00FFDEC600F7DEBD00FFF7E700CE845A0000000000CE8C4A00FFF7EF00FFEF
      D600FFEFD600FFE7CE00F7EFDE00F7E7CE00F7DEC600F7DEC600F7DEC600F7E7
      CE00E7BD9C00FFF7EF00CE844A000000000000000000DEB59400F7E7DE00D6A5
      7B00C69C6B00C6946B00C6946B00FFF7F700F7EFE700C6946B00BD8C6300BD8C
      6300C6946B00EFE7D600C694630000000000848484009C9C9C00636363005A5A
      5A00525252004A4A4A00636B6B00636B6B0000000000635AEF00D6D6F7005A52
      EF004A42E700000000004231E7003929E700D6946B00FFF7F700FFEFDE00FFEF
      E700FFEFDE00FFEFDE00E7BD9400FFF7F700FFE7D600FFE7D600FFE7CE00FFDE
      C600F7D6BD00F7D6AD00FFEFE700CE845A0000000000CE8C4A00FFF7EF00FFEF
      DE00FFEFDE00FFDEC600FFEFDE00F7E7D600F7E7CE00F7E7CE00FFE7D600EFD6
      BD00EFC6AD00FFF7EF00CE844A000000000000000000E7BD9C00F7E7DE00D6A5
      7B00CE9C7300C69C6B00C69C6B00E7CEB500FFF7EF00F7EFEF00DEBDA500C694
      6B00C69C7300F7E7D600C69C73000000000084848400A5A5A500848484008484
      84007B7B7B0073737300848484006B6B6B0000000000736BEF00D6D6F700635A
      EF00524AE700000000004A39E7004231E700D6946B00FFFFF700FFEFDE00FFEF
      E700FFEFDE00FFEFDE00E7BD9400FFF7F700FFE7CE00FFE7CE00FFDECE00F7DE
      BD00F7EFDE00FFF7EF00FFFFF700CE84520000000000CE8C5200FFF7EF00FFE7
      D600FFE7D600FFE7CE00FFE7CE00FFEFDE00FFEFDE00FFEFDE00F7DECE00EFCE
      AD00F7D6BD00FFF7EF00CE844A000000000000000000EFCEB500F7E7DE00DEBD
      9C00CEA57300CE9C7300F7EFE700E7CEB500E7D6BD00FFFFF700E7D6BD00C69C
      6B00D6B59400EFE7D600D6AD8C00000000008C8C8C00C6C6C600BDBDBD00BDBD
      BD009C9C9C0084848400949494006B7373000000000000000000C6C6F7006B63
      EF00B5ADF700B5B5F7005A52EF00635AE700D6946B00FFFFF700FFEFDE00FFEF
      DE00FFEFDE00FFE7D600E7BD9400FFF7EF00FFDEC600FFE7C600FFDEC600F7D6
      B500FFFFF700FFE7C600EFC69400DEB5940000000000CE8C5200FFF7F700FFE7
      D600FFE7D600FFE7D600FFE7CE00FFDEC600F7DEBD00F7D6BD00F7D6B500F7D6
      B500F7D6B500FFF7F700C6844A000000000000000000F7E7D600F7E7D600EFDE
      CE00D6AD7B00D6A57300FFFFF700FFFFF700FFFFF700FFFFF700D6AD8400CEA5
      7B00EFD6C600EFD6C600EFD6C600000000008C8C8C00949494008C9494008C94
      9400A5A5A500ADADAD00A5A5A50073737B00000000000000000000000000C6C6
      F700E7E7FF00635AE700635AEF00B5B5F700D6946B00FFFFF700FFEFDE00FFEF
      DE00FFEFD600FFE7D600E7BD9400FFFFFF00FFF7EF00FFF7EF00FFF7EF00FFEF
      E700FFF7E700EFBD8C00DEAD8C00FFFFF70000000000CE8C5200FFF7F700FFE7
      CE00FFE7D600FFE7CE00FFE7CE00FFE7CE00FFDEC600F7DEBD00F7EFDE00F7F7
      EF00FFF7F700F7EFEF00C6844A000000000000000000FFFFF700F7D6BD00F7EF
      DE00EFDEC600D6AD8400DEBD9C00F7EFE700F7EFE700E7CEAD00D6A57B00E7CE
      BD00F7E7D600DEBD9C00FFF7F70000000000E7E7E700E7E7E700E7E7E700E7E7
      E7009C9C9C009C9C9C00ADADAD007B7B7B000000000000000000000000000000
      0000BDB5F7006B6BEF00847BE70000000000D6946B00FFFFF700FFEFDE00FFE7
      D600FFE7D600FFE7CE00EFC69C00E7BD9400E7BD9400E7BD9400D6A57300D6A5
      7300D6A57300E7BDA500FFFFFF000000000000000000CE8C5200FFF7F700FFE7
      CE00FFE7CE00FFE7CE00FFE7CE00FFE7CE00FFDEC600F7D6BD00FFFFFF00FFE7
      CE00FFE7CE00E7B58400D6AD8400000000000000000000000000FFF7EF00F7D6
      BD00F7EFDE00EFDED600E7C6A500DEAD8C00D6AD8400DEBD9C00EFD6C600F7E7
      DE00E7C6A500F7EFDE0000000000000000000000000000000000000000000000
      0000FFFFFF00C6C6C6008C8C8C00848484000000000000000000000000000000
      000000000000CEC6F700F7EFFF0000000000D6946B00FFF7F700FFE7D600FFE7
      D600FFE7CE00FFDEC600F7EFE700FFF7EF00FFFFF700D6A57B00000000000000
      00000000000000000000000000000000000000000000CE945A00FFF7F700FFE7
      C600FFE7CE00FFE7CE00FFE7CE00FFDEC600FFDEC600F7D6BD00FFFFFF00F7DE
      B500E7B57B00DE946B00FFFFFF0000000000000000000000000000000000FFF7
      EF00F7DEC600FFEFDE00F7EFDE00F7E7DE00F7E7DE00F7E7DE00F7E7D600EFCE
      B500FFEFE7000000000000000000000000000000000000000000000000000000
      00000000000000000000D6D6D600949494000000000000000000000000000000
      000000000000000000000000000000000000D69C6B00FFF7EF00FFE7CE00FFE7
      CE00FFE7CE00F7DEBD00FFFFF700FFE7CE00EFCEA500E7BDA500000000000000
      00000000000000000000000000000000000000000000D6A57300FFF7EF00FFF7
      EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00F7F7EF00F7E7D600E7B5
      7B00DE9C6B00FFFFFF0000000000000000000000000000000000000000000000
      0000FFFFF700FFEFE700FFDECE00F7DEC600F7D6BD00F7DEC600FFEFDE00FFFF
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D69C730000000000FFF7EF00FFF7
      EF00FFF7EF00FFF7E700FFF7EF00EFC69400E7B59400FFFFF700000000000000
      00000000000000000000000000000000000000000000EFCEBD00D6AD7B00CE94
      5A00CE945200CE945200CE945200CE945200CE945200CE8C5200CE9C6B00DEB5
      9400FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEA58400D69C7300D6946B00D69C
      6B00D69C6B00D69C6B00D69C7300E7C6AD00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000318CDE00318CDE00318C
      DE00318CDE00318CDE00318CDE00318CDE00318CDE00318CDE00318CDE00318C
      DE00318CDE0000000000FFFFFF00FFFFFF0000000000CE947300BD734200B56B
      3100B56B3100B5633100B5633100B5633100AD633100AD633100AD633100AD63
      3100AD633100A5633100AD6B3900BD846300000000000000000000000000CE94
      6300CE9C6300CE946300CE946300CE946300CE946300CE946300CE946300CE9C
      6300CE9463000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003194DE00DEF7FF009CE7F70094E7
      F70094DEF7008CDEF7008CDEF70084DEF70084DEF7007BD6F70073D6F70073D6
      F700C6EFFF003194DE00FFFFFF00FFFFFF00C67B4A00EFC6AD00EFC6AD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CE9C7B00C69C7B00AD6B4200A5A5A5007B7B7B005A5A5A00C694
      6300FFF7F700FFF7EF00FFF7EF00FFF7EF00F7EFE700F7EFE700F7EFDE00FFFF
      F700C6946300212121004A4A4A00949494000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003994DE00EFFFFF0094E7FF008CE7
      FF008CE7FF0084E7F7007BDEF70073DEF70063DEF7005ADEF7004AD6F70042D6
      F700CEF7FF003194DE00FFFFFF00FFFFFF00BD6B3900EFCEB500E7A57B00FFFF
      F70063C68C0063C68C0063C68C0063C68C0063C68C0063C68C0063C68C0063C6
      8C00FFFFF700CE8C6300CE9C7B00A56331006B6B6B00A5A5A500B5B5B5008484
      8400ADADAD00C6C6BD00C6C6BD00C6C6BD00C6C6BD00C6C6BD00C6C6BD00ADAD
      AD0029292900B5B5B5009C9C9C00212121000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      840000848400000000000000000000000000399CDE00F7FFFF0094E7FF0094E7
      FF0094E7FF008CE7FF0084E7F7007BE7F70073DEF7006BDEF7005ADEF7004AD6
      F700CEF7FF003194DE00FFFFFF00FFFFFF00BD6B3900EFCEB500E7A57B00FFFF
      F700BDDEC600BDDEC600BDDEC600BDDEC600BDDEC600BDDEC600BDDEC600BDDE
      C600FFFFF700CE946B00CE9C8400AD63310073737300B5B5B500B5B5B5009494
      940084848400848484007B7B7B006B6B6B006363630052525200424242004242
      42006B6B6B00B5B5B500B5B5B500212121000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000039A5DE00F7FFFF0094E7FF0094E7
      FF0094E7FF0094E7FF0094DEEF0094D6E70094D6DE0094CED6008CCECE0084C6
      C600CEDED6003194DE00CE845200CE845A00BD6B3900EFCEBD00E7A57B00FFFF
      F70063C68C0063C68C0063C68C0063C68C0063C68C0063C68C0063C68C0063C6
      8C00FFFFF700CE946B00CEA58400AD63310073737300BDBDBD00BDBDBD008C8C
      8C00D6D6D600BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00D6D6
      D60084848400BDBDBD00BDBDBD00292929000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000039ADDE00FFFFFF00FFFFFF00F7FF
      FF00F7FFFF00F7FFFF009CE7F7009CE7F7009CE7F7009CE7F7009CE7F7009CE7
      F700DEF7FF003194DE00FFF7EF00CE845A00BD6B3100EFD6BD00E7A57B00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00D6946B00D6A58C00AD6331007B7B7B00D6D6D600D6D6D6009494
      9400DEDEDE00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00D6D6
      D6008C8C8C00D6D6D600D6D6D600393939000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000039ADDE00EFF7FF0073BDE70052AD
      E7004AA5E70094CEEF00FFF7EF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF003194DE00EFF7EF00CE845200BD6B3100F7D6BD00E7A57B00E7A5
      7B00E7A57B00E7A57B00E7A57B00E7A57B00DE9C7300DE9C7300DE9C7300DE9C
      7300DE9C7300D69C7300D6AD8C00AD6331007B7B7B00FFFFFF00FFFFFF00ADAD
      AD00DEDEDE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00DEDE
      DE00A5A5A500FFFFFF00FFFFFF00636363000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000042ADDE00F7FFFF0094DEF70094DE
      F70063BDEF003194DE003194DE003194DE003194DE003194DE003194DE003194
      DE003194DE003194DE00FFF7EF00CE845200BD6B3100F7D6C600E7A57B00E7A5
      7B00E7A57B00E7A57B00E7A57B00E7A57B00E7A57B00DEA57300DE9C7300DE9C
      7300DE9C7300DE9C7300DEB59400AD63310084848400FFFFFF00FFFFFF00CECE
      CE00F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700C6C6C600FFFFFF00FFFFFF00737373000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000042B5DE00F7FFFF008CE7FF0094DE
      F7009CE7F700ADE7F700CE845200FFF7F700FFEFDE00FFEFDE00FFEFDE00FFE7
      D600FFE7D600FFE7CE00FFF7F700CE845200BD6B3100F7DEC600E7A57B00E7A5
      7B00E7A57B00E7A57B00E7A57B00E7A57B00E7A57B00DEA57300DE9C7300DE9C
      7300DE9C7300DE9C7300DEB59C00B563310094949400D6D6D600EFEFEF007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B00EFEFEF00C6C6C6006B6B6B000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000039B5DE00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFF7F700FFE7D600FFE7D600FFE7D600FFE7
      D600FFE7CE00FFDEC600FFF7EF00CE845200BD6B3100F7DEC600E7A57B00CE8C
      6300CE8C6300CE8C6300CE946B00CE946B00CE946B00CE8C6300CE8C6300CE8C
      6300CE8C6300DE9C7300E7BD9C00B5633100DEDEDE009C9C9C00CECECE00C68C
      4A00FFF7EF00FFEFDE00FFEFD600FFE7D600FFE7D600FFE7C600FFDEC600FFF7
      EF00C6844A00C6C6C60073737300CECECE000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000005AC6E70063C6E70063C6E70063C6
      E70063C6E70063C6E700E7BD9400FFF7F700FFE7D600FFE7D600FFE7D600FFE7
      CE00FFDEC600F7DEBD00FFF7E700CE845A00BD6B3100F7DECE00E7A57B00FFEF
      E700FFEFE700FFEFE700FFF7EF00FFFFF700FFF7F700FFEFE700F7E7DE00F7E7
      DE00F7E7DE00DEA57300E7BDA500B563310000000000CECECE0084848400C68C
      4A00FFF7EF00FFE7D600FFE7D600FFE7D600FFE7CE00FFDEC600F7DEBD00FFF7
      EF00C6844A0063636300BDBDBD0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFF7F700FFE7D600FFE7D600FFE7CE00FFDE
      C600F7D6BD00F7D6AD00FFEFE700CE845A00BD6B3900F7DECE00E7AD7B00FFF7
      EF00FFF7EF00CE8C6300FFF7EF00FFFFF700FFFFFF00FFF7EF00FFEFDE00F7E7
      DE00F7E7DE00E7A57B00E7C6AD00B56B31000000000000000000FFFFFF00C68C
      4A00FFF7F700FFE7D600FFE7D600FFE7CE00FFE7CE00F7D6BD00F7D6B500FFF7
      F700C6844A00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFF7F700FFE7CE00FFE7CE00FFDECE00F7DE
      BD00F7EFDE00FFF7EF00FFFFF700CE845200C6734200F7DED600EFAD7B00FFF7
      F700FFF7F700CE8C6300FFF7EF00FFF7EF00FFFFF700FFFFF700FFF7EF00FFEF
      DE00F7E7DE00E7A57B00EFD6C600B56B3100000000000000000000000000CE8C
      5200FFF7F700FFE7CE00FFE7CE00FFE7CE00FFDEC600F7EFDE00F7F7EF00F7EF
      EF00C6844A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000000000008400000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFF7EF00FFDEC600FFE7C600FFDEC600F7D6
      B500FFFFF700FFE7C600EFC69400DEB59400C6845200F7DED600EFAD8400FFFF
      F700FFFFF700CE8C6300FFF7EF00FFF7EF00FFF7F700FFFFFF00FFF7F700FFEF
      E700FFE7DE00EFD6BD00EFD6BD00BD734200000000000000000000000000CE8C
      5200FFF7F700FFE7CE00FFE7CE00FFE7CE00FFDEC600FFFFFF00FFE7CE00E7B5
      8400D6AD84000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000840000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFFFFF00FFF7EF00FFF7EF00FFF7EF00FFEF
      E700FFF7E700EFBD8C00DEAD8C00FFFFF700D6A58400F7E7D600F7E7D600FFFF
      FF00FFFFF700FFFFF700FFF7F700FFF7EF00FFF7EF00FFFFF700FFFFF700FFF7
      EF00FFEFDE00EFD6BD00CE946B00E7C6B500000000000000000000000000C68C
      4A00F7F7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00F7E7D600E7B57B00DE94
      6B00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000840000008400000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFC69C00E7BD9400E7BD9400E7BD9400D6A57300D6A5
      7300D6A57300E7BDA500FFFFFF00FFFFFF00E7BDA500DEAD8C00CE8C5A00C673
      4200BD6B3900BD6B3100BD6B3100BD6B3100BD6B3100BD6B3900BD6B3900BD6B
      3900BD734200CE8C6300E7CEBD00FFFFFF00000000000000000000000000EFCE
      BD00D6AD7B00CE8C5200CE8C4A00CE945200CE945200C68C4A00DEAD8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7C6AD00CE8C6300C673
      4200BD6B3100BD6B3100BD6B3100BD6B3100BD6B3100BD6B3100BD6B3100BD6B
      3100BD6B3900CE8C6300E7C6AD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B5947300845A3100845A3100A5845A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C67B4A00FFF7EF00F7EF
      DE00F7EFDE00F7EFDE00F7EFDE00F7EFDE00FFF7EF00FFF7EF00FFF7EF00FFF7
      F700FFFFF700FFFFFF00C67B4A00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CE846B00B53110000000
      000000000000000000000000000000000000A57342009C7339009C6B39009463
      31008C632900845A290084522100946B390094633100734210006B4210006B39
      080063390800633100005A3100005A2900000000000000000000000000000000
      0000C64A1000D68C730000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6734200F7EFDE00FFBD
      6B00FFBD6300FFBD6300FFBD6300FFBD6300FFBD6300FFBD6300FFBD6300FFBD
      6300FFBD6300FFFFFF00BD6B3100000000000000000000000000000000000000
      000000000000000000000000000000000000D6846B00C65A3100B53910000000
      000000000000000000000000000000000000AD7B4A00B58C5A00B58C5A00B58C
      5A00B58C5A00B58C5A00B58C5A007B5221007B4A1800B58C5A00B58C5A00B58C
      5A00B58C5A00B58C5A00B58C5A006B3908000000000000000000000000000000
      0000C65A1800CE733900D68C6B00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C67B4200F7EFE700FFC6
      6B00FFDEA500FFD69C00FFD69C00FFD69C00FFD69400FFD69400FFD69400FFD6
      9400FFBD6300FFF7F700BD6B3100000000000000000000000000000000000000
      0000000000000000000000000000D68C6B00CE6B3100DE946300BD4210000000
      000000000000000000000000000000000000B5844A009C7339009C6B39009463
      31008C632900845A290084522100AD947300AD8C7300734210006B4210006B39
      080063390800633100005A3100006B3910000000000000000000000000000000
      0000CE631800DEA57300CE733900D68C6B000000000000000000000000000000
      00000000000000000000000000000000000000000000C6844200F7F7E700FFB5
      5200F7B55200F7B55200FFB55200FFB55200F7B55200F7B55200F7B55200F7B5
      4A00F7B54A00FFFFF700C6733900000000000000000000000000000000000000
      00000000000000000000DE946300D6733900DE9C6B00DE9C6B00BD4210000000
      000000000000000000000000000000000000B58C5200A5734200FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00F7F7F700E7E7E700F7F7F700FFFFFF00FFFFFF00FFFF
      FF00EFEFEF00FFFFFF0063310000734210000000000000000000000000000000
      0000CE6B2100E7AD7B00E7A57B00D6733900D68C630000000000000000000000
      00000000000000000000000000000000000000000000C6844A00FFF7EF00FFE7
      D600FFE7D600FFE7D600FFE7D600FFE7D600FFE7D600FFE7CE00FFE7CE00FFE7
      CE00FFE7CE00FFFFF700C67B4200000000000000000000000000000000000000
      0000FFFFFF00DE9C6B00D6844A00E7AD7B00DE9C6300DEA57300C65210000000
      000000000000000000000000000000000000BD8C5A00AD7B4A00FFFFFF00F7F7
      F700EFEFEF00E7E7E700D6D6D600A5A5A500D6D6D600F7F7F700EFEFEF00EFEF
      EF00DEDEDE00FFFFFF0063390800734A18000000000000000000000000000000
      0000D6733100E7AD8400DEA57300E7AD7B00D67B3900D68C6300FFFFFF000000
      00000000000000000000000000000000000000000000C6844A00FFF7EF00FFE7
      D600FFE7D600FFE7D600FFE7D600FFE7D600FFE7D600FFE7D600FFE7CE00FFE7
      CE00FFE7CE00FFF7F700C6844200000000000000000000000000000000000000
      0000E7A57B00DE945A00E7B58C00E7A57300DE9C6300E7A57B00C65A18000000
      000000000000000000000000000000000000BD945A00B5844A00FFFFFF00CECE
      CE00CECECE00C6C6C600D6D6D600A5A5A500DEDEDE00F7F7F700CECECE00C6C6
      C600BDBDBD00FFFFFF006B3910007B4A18000000000000000000000000000000
      0000D6844200E7B59400E7A57300E7A57300E7AD8400D67B4200D68C5A000000
      00000000000000000000000000000000000000000000CE8C4A00FFF7EF00FFEF
      D600FFEFD600FFE7D600FFE7D600FFE7D600FFE7D600FFE7D600FFE7CE00FFDE
      C600FFDEC600FFF7EF00CE844A00000000000000000000000000000000000000
      0000DE946300E79C6B00EFBD9400E7AD8400DEA57300E7AD8400CE6318000000
      000000000000000000000000000000000000C6946300B58C5200FFFFFF00F7F7
      F700EFEFEF00EFEFEF00D6D6D600A5A5A500DEDEDE00F7F7F700EFEFEF00EFEF
      EF00DEDEDE00FFFFFF00734210007B5221000000000000000000000000000000
      0000DE8C5200EFBD9C00E7AD8400E7AD8400E7B58C00D68C4A00CE7331000000
      00000000000000000000000000000000000000000000CE8C4A00FFF7EF00FFEF
      DE00FFEFDE00FFEFD600FFE7D600FFE7D600FFE7D600FFE7CE00FFE7C600FFDE
      C600FFDEC600FFF7EF00CE844A00000000000000000000000000000000000000
      000000000000E7B59400E7A57300EFBD9C00E7AD8400E7B58C00CE7329000000
      000000000000000000000000000000000000C69C6300BD8C5A00FFFFFF00CECE
      CE00CECECE00C6C6C600D6D6D600A5A5A500DEDEDE00F7F7F700CECECE00C6C6
      C600BDBDBD00FFFFFF00734A1800845A29000000000000000000000000000000
      0000E7946300EFC6A500EFB59400EFBD9C00DE946300DEA57300000000000000
      00000000000000000000000000000000000000000000CE8C5200FFF7EF00FFE7
      D600FFE7D600FFE7D600FFE7D600FFE7D600FFE7CE00FFDEC600FFDEC600F7DE
      BD00F7DEBD00FFF7EF00CE844A00000000000000000000000000000000000000
      00000000000000000000EFBD9C00E7A57300EFBD9C00EFBD9400D67B39000000
      000000000000000000000000000000000000C69C6300C6945A00FFFFFF00F7F7
      F700EFEFEF00EFEFEF00D6D6D600B5B5B500DEDEDE00F7F7F700F7F7F700EFEF
      EF00DEDEDE00FFFFFF007B5221008C5A29000000000000000000000000000000
      0000E7A56B00EFC6AD00EFC6A500E7A57300E7B58C0000000000000000000000
      00000000000000000000000000000000000000000000CE8C5200FFF7F700FFE7
      D600FFE7D600FFE7D600FFE7D600FFE7CE00FFE7CE00FFDEC600F7D6BD00F7D6
      B500F7D6B500FFF7F700C6844A00000000000000000000000000000000000000
      0000000000000000000000000000EFC6A500E7A57B00EFBD9C00DE844A000000
      000000000000000000000000000000000000C69C6300C6946300FFFFFF00CECE
      CE00CECECE00C6C6C600F7F7F700DEDED600EFE7DE00FFFFFF00CECECE00CECE
      CE00BDBDBD00FFFFFF0084522100946331000000000000000000000000000000
      0000E7A57B00EFCEAD00EFB58400EFC6A5000000000000000000000000000000
      00000000000000000000000000000000000000000000CE8C5200FFF7F700FFE7
      CE00FFE7D600FFE7CE00FFE7CE00FFE7CE00FFDEC600F7DEBD00F7EFDE00F7F7
      EF00FFF7F700F7EFEF00C6844A00000000000000000000000000000000000000
      000000000000000000000000000000000000EFCEAD00E7946300DE945A000000
      000000000000000000000000000000000000C69C6300CE9C6300FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00DEC6B500BD8C5A00B58C5A00D6C6AD00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008C5A2900946B39000000000000000000000000000000
      0000EFAD8400EFAD7B00F7CEB500000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CE8C5200FFF7F700FFE7
      CE00FFE7CE00FFE7CE00FFE7CE00FFE7CE00FFDEC600F7D6BD00FFFFFF00FFE7
      CE00FFE7CE00E7B58400D6AD8400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFCEB500E79C6B000000
      000000000000000000000000000000000000F7EFE700CE9C6300D6AD8400D6AD
      8400CEAD7B00CEA57B00C6A57300F7EFE700F7EFE700BD946B00BD946B00B594
      6300AD8C6300AD845A0094633100EFE7D6000000000000000000000000000000
      0000EFAD8400F7D6BD0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CE945A00FFF7F700FFE7
      C600FFE7CE00FFE7CE00FFE7CE00FFDEC600FFDEC600F7D6BD00FFFFFF00F7DE
      B500E7B57B00DE946B00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7EFE700F7EFE700F7EF
      E700F7EFE700F7EFDE00F7EFDE000000000000000000F7E7DE00EFE7DE00EFE7
      DE00EFE7DE00EFE7DE00EFE7D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6A57300FFF7EF00FFF7
      EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00F7F7EF00F7E7D600E7B5
      7B00DE9C6B00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFCEBD00D6AD7B00CE94
      5A00CE945200CE945200CE945200CE945200CE945200CE8C5200CE9C6B00DEB5
      9400FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000318CDE00318CDE00318C
      DE00318CDE00318CDE00318CDE00318CDE00318CDE00318CDE00318CDE00318C
      DE00318CDE0000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003194DE00DEF7FF009CE7F70094E7
      F70094DEF7008CDEF7008CDEF70084DEF70084DEF7007BD6F70073D6F70073D6
      F700C6EFFF003194DE00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B5B5B500B5B5
      B500B5B5B5000000000029292900212121001818180010101000101010000808
      0800000000000000000000000000000000000000000039393100393131003129
      2900292921002121210021181800E7E7E7003131310008080800000000000000
      0000000000000000000000000000000000003994DE00EFFFFF0094E7FF008CE7
      FF008CE7FF0084E7F7007BDEF70073DEF70063DEF7005ADEF7004AD6F70042D6
      F700CEF7FF003194DE00FFFFFF00FFFFFF00C69C8C00C68C6300BD845A00A56B
      4A00A56B4A009C634A009C634200A5735A00BD7B5200B5735200B57352009C5A
      4200945A4200945A4200BD948400000000000000000000000000B5B5B500E7E7
      E700B5B5B5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000042423900847B7300C6BD
      AD007B736B007B736B0031312900F7F7F7004A4A4200948C7B00BDADA5007B73
      6B007B736B00000000000000000000000000399CDE00F7FFFF0094E7FF0094E7
      FF0094E7FF008CE7FF0084E7F7007BE7F70073DEF7006BDEF7005ADEF7004AD6
      F700CEF7FF003194DE00FFFFFF00FFFFFF00CE946B0000000000000000000000
      0000000000000000000000000000C6845A000000000000000000000000000000
      00000000000000000000945A4200000000000000000000000000B5B5B500E7E7
      E700B5B5B5000000000039393900313131002929290029292900212121001818
      180010101000080808009C9C9C0000000000000000004A424200847B6B00CEC6
      BD007B6B63007B73630031312900FFFFFF0029292100948C7B00C6BDAD007B6B
      63007B736B0000000000000000000000000039A5DE00F7FFFF0094E7FF0094E7
      FF0094E7FF0094E7FF0094DEEF0094D6E70094D6DE0094CED6008CCECE0084C6
      C600CEDED6003194DE00CE845200CE845A00CE94730000000000000000000000
      0000000000000000000000000000C68C63000000000000000000000000000000
      000000000000000000009C5A4200000000000000000000000000B5B5B500E7E7
      E700B5B5B5000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000524A4A00847B6B00CEC6
      BD007B736300736B5A005A525200000000004A424200847B7300C6BDAD007B6B
      63007B73630008080800000000000000000039ADDE00FFFFFF00FFFFFF00F7FF
      FF00F7FFFF00F7FFFF009CE7F7009CE7F7009CE7F7009CE7F7009CE7F7009CE7
      F700DEF7FF003194DE00FFF7EF00CE845A00CE9C730000000000000000000000
      0000000000000000000000000000CE9463000000000000000000000000000000
      000000000000000000009C634200000000000000000000000000BDBDBD00EFEF
      EF00B5B5B500000000004A4A4A004A4A4A004242420039393900313131002929
      29000000000000000000000000000000000000000000847B73009C948400CEC6
      BD00C6B5AD00A59C8C00847B7B000000000073736B0094847B00C6BDAD00C6B5
      AD00AD9C8C004A424200000000000000000039ADDE00EFF7FF0073BDE70052AD
      E7004AA5E70094CEEF00FFF7EF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF003194DE00EFF7EF00CE845200D6A57B0000000000000000000000
      0000000000000000000000000000CE9C6B000000000000000000000000000000
      00000000000000000000A5634A00000000000000000000000000BDBDBD00EFEF
      EF00B5B5B5000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00635A5200423939005A52
      4A00393931003129290039313100D6D6D6005A5A5A0018181000212121001810
      10000808080010101000FFFFFF000000000042ADDE00F7FFFF0094DEF70094DE
      F70063BDEF003194DE003194DE003194DE003194DE003194DE003194DE003194
      DE003194DE003194DE00FFF7EF00CE845200DEAD840000000000000000000000
      0000000000000000000000000000D69C73000000000000000000000000000000
      00000000000000000000AD6B4A00000000000000000000000000BDBDBD00EFEF
      EF00BDBDBD0000000000636363005A5A5A00525252004A4A4A00424242003939
      39003131310029292900A5A5A50000000000FFFFFF009C948400B5A594007B73
      6B007B736B00736B63006B635A0029292100524A4A0084736B007B736B00736B
      630073635A0000000000FFFFFF000000000042B5DE00F7FFFF008CE7FF0094DE
      F7009CE7F700ADE7F700CE845200FFF7F700FFEFDE00FFEFDE00FFEFDE00FFE7
      D600FFE7D600FFE7CE00FFF7F700CE845200DEAD840000000000000000000000
      0000000000000000000000000000D6A57B000000000000000000000000000000
      00000000000000000000AD735200000000000000000000000000BDBDBD00EFEF
      EF00BDBDBD000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00BDADA500BDADA5008473
      6B0084736B00AD947B00BDA59400BDA59400B59484009C8C7B00846B5A007363
      5200948C7B0021212100FFFFFF000000000039B5DE00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFF7F700FFE7D600FFE7D600FFE7D600FFE7
      D600FFE7CE00FFDEC600FFF7EF00CE845200DEB58C0000000000000000000000
      0000000000000000000000000000DEA57B000000000000000000000000000000
      00000000000000000000B5735200000000000000000000000000BDBDBD00F7F7
      F700BDBDBD00000000006B6B6B006B6B6B00636363005A5A5A00525252004A4A
      4A0000000000000000000000000000000000FFFFFF00DEDED6009C8C84009C94
      8400847B7300524A4A00524A420084736B006B635A00846B5A00A5947B009484
      7300524A4A008C8C8C00FFFFFF00000000005AC6E70063C6E70063C6E70063C6
      E70063C6E70063C6E700E7BD9400FFF7F700FFE7D600FFE7D600FFE7D600FFE7
      CE00FFDEC600F7DEBD00FFF7E700CE845A00E7B58C0000000000000000000000
      0000000000000000000000000000DEAD84000000000000000000000000000000
      00000000000000000000B57B5A00000000000000000000000000BDBDBD00F7F7
      F700BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000736B6300A594
      8C00948C7B009C94840039393100000000004A4242007B736B00847B73003939
      310084847B00F7F7F700FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFF7F700FFE7D600FFE7D600FFE7CE00FFDE
      C600F7D6BD00F7D6AD00FFEFE700CE845A00E7B5940000000000000000000000
      0000000000000000000000000000DEAD84000000000000000000000000000000
      00000000000000000000BD846300000000000000000000000000BDBDBD00BDBD
      BD00BDBDBD00000000007373730073737300737373006B6B6B00636363006363
      63005A5A5A0052525200B5B5B500000000000000000000000000000000000000
      00009C948400C6BDAD00635A5200000000007B736B00AD9C8C00A59C94000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFF7F700FFE7CE00FFE7CE00FFDECE00F7DE
      BD00F7EFDE00FFF7EF00FFFFF700CE845200E7BD9400E7BD9400E7BD9400E7B5
      9400E7B59400E7B58C00E7B58C00E7B58C00E7B58C00DEAD8400DEAD8400DEAD
      8400DEAD8400DEAD7B00C68C6300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A59C9400BDB5A5009C94840000000000ADA594009C9484007B736B000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFF7EF00FFDEC600FFE7C600FFDEC600F7D6
      B500FFFFF700FFE7C600EFC69400DEB59400E7BDA500EFCEAD00EFC6AD00EFC6
      AD00EFC6A500EFC6A500EFC6A500E7BD9400EFC6A500EFC69C00EFC69C00EFBD
      9C00EFBD9C00EFBD9C00C6947300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFFFFF00FFF7EF00FFF7EF00FFF7EF00FFEF
      E700FFF7E700EFBD8C00DEAD8C00FFFFF700E7CEBD00E7C6AD00E7BD9400DEAD
      8C00D6AD8400D6AD8400D6B59400D6AD9400E7C6A500E7B58C00E7B58C00D6A5
      7B00CE9C7300CEA58C00DEC6BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFC69C00E7BD9400E7BD9400E7BD9400D6A57300D6A5
      7300D6A57300E7BDA500FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000900000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000F81F000000000000
      F007000000000000E203000000000000C013000000000000C091000000000000
      D19900000000000091F900000000000091F9000000000000C091000000000000
      C813000000000000C403000000000000E187000000000000F00F000000000000
      FFFF000000000000FFFF000000000000FFFFFFFFFFC1FFC1FFFFE003FF80FF80
      FFFF800300080000FFFF00037F9C7F9CEF7F000360086000E73F000340004000
      E31F000340014001E10F000340054005E007000340054005E10F000340054005
      E31F000340054005E73F00037FFD7FFDEF7F000700010001FFFF000F00010001
      FFFF000F00010001FFFF001FFFFFFFFFFFFFFFFFFFFFFFFF07FFFFFFFFFFFFFF
      F9FF00010001FFFFFC7F01FD7F01FFFFF83F01054101FDEFF01F00054001F9CF
      E00F00054001F18FC00700054001E10F800300054001C00F000301054101E10F
      E00701054101F18FF80301FD7F01F9CFFC0100010001FDEFFE2000010001FFFF
      FFF000010001FFFFFFF9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF00FFFFFE00FF07FFFFFE187F187F8FFF81FE3CFF1C7FC7FF08F
      E3CFF187FC7FF1CFE3CFF187FC7FF3EFE3CFF01FFE3FF3EFA24DF10FFE3FF3EF
      8249F18FFE3FF3EF8001F18FFF1FF3EFFFFFE00FFE0FF3CFFFFFFFFFFFFFE1C7
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC000FFEBF1FFFFFF0000FFE18103
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
