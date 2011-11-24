object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1062#1080#1090#1072#1090#1072' '#1080#1079' '#1041#1080#1073#1083#1080#1080
  ClientHeight = 731
  ClientWidth = 905
  Color = clBtnFace
  Constraints.MinHeight = 524
  Constraints.MinWidth = 736
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial Unicode MS'
  Font.Style = []
  KeyPreview = True
  Menu = theMainMenu
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnActivate = TntFormActivate
  OnClose = FormClose
  OnCloseQuery = TntFormCloseQuery
  OnCreate = FormCreate
  OnDblClick = TntFormDblClick
  OnDeactivate = TntFormDeactivate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnMouseWheel = TntFormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 19
  object Label4: TTntLabel
    Left = 423
    Top = 61
    Width = 38
    Height = 19
    Alignment = taRightJustify
    Caption = 'Ctrl+1'
  end
  object Splitter1: TTntSplitter
    Left = 367
    Top = 31
    Width = 11
    Height = 700
    AutoSnap = False
    MinSize = 100
    OnMoved = Splitter1Moved
    ExplicitHeight = 652
  end
  object TTntToolButton
    Left = 0
    Top = 0
    EmbedDropDownStyle = False
  end
  object TTntToolButton
    Left = 0
    Top = 0
    EmbedDropDownStyle = False
  end
  object MainPanel: TTntPanel
    Left = 378
    Top = 31
    Width = 527
    Height = 700
    Align = alClient
    Caption = 'MainPanel'
    TabOrder = 0
    object mViewTabs: TAlekPageControl
      AlignWithMargins = True
      Left = 4
      Top = 1
      Width = 522
      Height = 672
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      ActivePage = mInitialViewPage
      Align = alClient
      PopupMenu = mViewTabsPopup
      RaggedRight = True
      TabOrder = 0
      OnChange = mViewTabsChange
      OnChanging = mViewTabsChanging
      OnContextPopup = mInitialViewPageContextPopup
      OnDragDrop = mViewTabsDragDrop
      OnDragOver = mViewTabsDragOver
      OnMouseDown = mViewTabsMouseDown
      OnStartDrag = mViewTabsStartDrag
      HideTabsHints = False
      OnDeleteTab = mViewTabsDeleteTab
      OnDblClick = mViewTabsDblClick
      object mInitialViewPage: TTntTabSheet
        PopupMenu = mViewTabsPopup
        OnContextPopup = mInitialViewPageContextPopup
        object FirstBrowser: THTMLViewer
          Left = 145
          Top = 13
          Width = 455
          Height = 315
          OnHotSpotCovered = FirstBrowserHotSpotCovered
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
          OnMouseUp = FirstBrowserMouseUp
          OnMouseWheel = FirstBrowserMouseWheel
          OnKeyDown = FirstBrowserKeyDown
          OnKeyUp = FirstBrowserKeyUp
          OnKeyPress = FirstBrowserKeyPress
          OnMouseDouble = FirstBrowserMouseDouble
        end
      end
    end
    object btmPaint: TPanel
      Left = 1
      Top = 673
      Width = 525
      Height = 26
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object imgLoadProgress: TTntImage
        Tag = 1
        AlignWithMargins = True
        Left = 500
        Top = 0
        Width = 25
        Height = 26
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alRight
        Center = True
        Proportional = True
        Transparent = True
        Visible = False
        OnClick = imgLoadProgressClick
        ExplicitLeft = 502
      end
      object mBibleTabsEx: TDockTabSet
        Tag = -1
        Left = 0
        Top = 0
        Width = 500
        Height = 26
        Cursor = crHandPoint
        Hint = 'rtet'
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Tahoma'
        Font.Style = []
        StartMargin = 0
        SoftTop = True
        Style = tsSoftTabs
        TabHeight = 18
        OnClick = mBibleTabsExClick
        OnChange = mBibleTabsExChange
        OnDragDrop = BibleTabsDragDrop
        OnDragOver = BibleTabsDragOver
        OnMouseDown = mBibleTabsExMouseDown
        OnMouseMove = mBibleTabsExMouseMove
        OnMouseUp = mBibleTabsExMouseUp
        DockSite = False
      end
    end
  end
  object PreviewBox: TTntScrollBox
    Left = 379
    Top = 278
    Width = 127
    Height = 228
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
      Width = 118
      Height = 203
      BevelOuter = bvNone
      Color = clBtnShadow
      TabOrder = 0
      object PagePanel: TTntPanel
        Left = 14
        Top = 5
        Width = 86
        Height = 185
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        object PB1: TTntPaintBox
          Left = 0
          Top = 0
          Width = 86
          Height = 185
          Cursor = crArrow
          Align = alClient
          OnMouseDown = PB1MouseDown
          OnPaint = PB1Paint
          ExplicitWidth = 87
        end
      end
    end
  end
  object MainPages: TTntPageControl
    Left = 0
    Top = 31
    Width = 367
    Height = 700
    Hint = 'Strong'#39's Dictionary'
    ActivePage = StrongTab
    Align = alLeft
    Images = theImageList
    TabOrder = 2
    TabWidth = 27
    OnChange = MainPagesChange
    OnMouseLeave = MainPagesMouseLeave
    HideTabsHints = False
    object GoTab: TTntTabSheet
      ImageIndex = 5
      TabHint = 'Navigate'
      object Splitter2: TTntSplitter
        Left = 0
        Top = 306
        Width = 359
        Height = 17
        Cursor = crVSplit
        Align = alTop
        Beveled = True
        Color = clBtnFace
        ParentColor = False
        OnMoved = Splitter2Moved
        ExplicitWidth = 357
      end
      object Panel2: TTntPanel
        Left = 0
        Top = 0
        Width = 359
        Height = 306
        Align = alTop
        BevelOuter = bvNone
        Constraints.MinHeight = 190
        TabOrder = 0
        DesignSize = (
          359
          306)
        object cbModules: TTntComboBox
          Left = 5
          Top = 43
          Width = 351
          Height = 27
          Hint = 'Select module to view'
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 25
          ItemHeight = 19
          TabOrder = 1
          OnChange = cbModulesChange
          OnCloseUp = cbModulesCloseUp
          OnKeyPress = cbModulesKeyPress
        end
        object BookLB: TTntListBox
          Left = 5
          Top = 77
          Width = 278
          Height = 220
          Hint = 'Select book to view'
          Style = lbOwnerDrawVariable
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 14
          TabOrder = 2
          OnClick = BookLBClick
          OnMouseMove = BookLBMouseMove
        end
        object ChapterLB: TTntListBox
          Left = 297
          Top = 78
          Width = 58
          Height = 220
          Hint = 'Select chapter to view'
          Anchors = [akTop, akRight, akBottom]
          ItemHeight = 19
          PopupMenu = EmptyPopupMenu
          TabOrder = 3
          OnClick = ChapterLBClick
        end
        object AddressOKButton: TTntButton
          Left = 292
          Top = 5
          Width = 63
          Height = 28
          Hint = 'Go to link'
          Anchors = [akTop, akRight]
          Caption = 'OK'
          TabOrder = 5
          OnClick = AddressOKButtonClick
        end
        object GoEdit: TTntEdit
          Left = 5
          Top = 4
          Width = 254
          Height = 27
          Hint = 'Enter or paste verse link like Mk 10:30'
          Anchors = [akLeft, akTop, akRight]
          PopupMenu = MemoPopupMenu
          TabOrder = 0
          OnChange = GoEditChange
          OnDblClick = GoEditDblClick
          OnEnter = GoEditEnter
          OnKeyPress = GoEditKeyPress
        end
        object btbtnHelperButton: TTntBitBtn
          Left = 262
          Top = 5
          Width = 27
          Height = 28
          Hint = 'Module info and book signature hints'
          Anchors = [akTop, akRight]
          TabOrder = 4
          OnClick = btbtnHelperButtonClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000000000D8A674
            D1A16BCE975CCE9454CE9452CE9452CE9452CE9452CE9452CE9352CE8F52CE90
            58CF9967D8A674000000D09D67D39E64CE9452CE9452CE9452CE9452CE9452CE
            9452CE9452CE9452CE9452CE9452CE9452CE9452D39E64D09D67CF995FCE9452
            CE9453CE9453CE9453CE9453CE9453CE9453CE9453CE9453CE9453CE9453CE94
            53CE9453CE9452CF995FCE9558CE9554CF9657CF9657CF9657E9CFB2FFFFFFFF
            FFFFFFFFFFFFFFFFCF9657CF9657CF9657CF9657CE9554CE9558CE9453D1995C
            D1995CD1995CD1995CD1995CE2C09BFFFFFFFFFFFFD1995CD1995CD1995CD199
            5CD1995CD1995CCE9453CE9452D39E64D39E64D39E64D39E64D39E64E4C3A0FF
            FFFFFFFFFFD39E64D39E64D39E64D39E64D39E64D39E64CE9452CE9452D6A26C
            D6A26CD6A26CD6A26CD6A26CE5C6A5FFFFFFFFFFFFD6A26CD6A26CD6A26CD6A2
            6CD6A26CD6A26CCE9452CE9452D8A674D8A674D8A674D8A674D8A674E7C8A9FF
            FFFFFFFFFFD8A674D8A674D8A674D8A674D8A674D8A674CE9452CE9452DBAA7C
            DBAA7CDBAA7CDBAA7CDBAA7CEED8C3FFFFFFFFFFFFDBAA7CDBAA7CDBAA7CDBAA
            7CDBAA7CDBAA7CCE9452CE9352DDAF84DDAF84DDAF84DDAF84F5E8DCFFFFFFFF
            FFFFFFFFFFDDAF84DDAF84DDAF84DDAF84DDAF84DDAF84CE9352CE9152E0B38C
            E0B38CE0B38CE0B38CE0B38CE0B38CE0B38CE0B38CE0B38CE0B38CE0B38CE0B3
            8CE0B38CE0B38CCE9152CE8F55E2B894E2B894E2B894E2B894E2B894F6EAE0FF
            FFFFF6EAE0E2B894E2B894E2B894E2B894E2B894E2B894CE8F55CE9764E5BC9C
            E5BC9CE5BC9CE5BC9CE5BC9CF7ECE3FFFFFFF3E0D1E5BC9CE5BC9CE5BC9CE5BC
            9CE5BC9CE5BC9CCE9764D4A57BE7C0A4E7C0A4E7C0A4E7C0A4E7C0A4E7C0A4E7
            C0A4E7C0A4E7C0A4E7C0A4E7C0A4E7C0A4E7C0A4E7C0A4D4A57BDEB594D6AD7B
            EECDBBEECCBAEDCBB9EDCBB7EDCAB6ECC9B5ECC9B4EBC8B2EBC7B1EBC7B0EAC6
            AFEAC5ADD6AD7BDEB594000000D6AD7BD6AD7BD09C65CE9456CE9452CE9452CE
            9452CE9452CE9452CE9352CE8D52CE9560D3A479DEB594000000}
        end
      end
      object HistoryBookmarkPages: TTntPageControl
        Left = 0
        Top = 323
        Width = 359
        Height = 343
        ActivePage = BookmarksTab
        Align = alClient
        TabOrder = 1
        HideTabsHints = False
        object HistoryTab: TTntTabSheet
          Caption = 'HistoryTab'
          object HistoryLB: TTntListBox
            Left = 0
            Top = 0
            Width = 351
            Height = 309
            Style = lbOwnerDrawVariable
            Align = alClient
            ItemHeight = 14
            ParentShowHint = False
            PopupMenu = HistoryPopupMenu
            ShowHint = False
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
            Width = 351
            Height = 170
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
            Top = 170
            Width = 351
            Height = 139
            Align = alBottom
            BevelOuter = bvNone
            BorderWidth = 10
            TabOrder = 1
            object BookmarkLabel: TTntLabel
              Left = 10
              Top = 10
              Width = 331
              Height = 119
              Align = alClient
              Caption = 'BookmarkLabel'
              WordWrap = True
              ExplicitWidth = 98
              ExplicitHeight = 19
            end
          end
        end
        object tbQuickSearch: TTntTabSheet
          Caption = #1041#1099#1089#1090#1088#1099#1081' '#1087#1086#1080#1089#1082
          object SearchInWindowLabel: TTntLabel
            Left = 0
            Top = 0
            Width = 351
            Height = 19
            Align = alTop
            Caption = #1053#1072#1081#1090#1080' '#1074' '#1101#1090#1086#1084' '#1086#1082#1085#1077
            Layout = tlCenter
            ExplicitWidth = 120
          end
          object QuickSearchPanel: TTntPanel
            Left = 0
            Top = 19
            Width = 351
            Height = 134
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            DesignSize = (
              351
              134)
            object btnQuickSearchBack: TTntBitBtn
              Left = 5
              Top = 20
              Width = 33
              Height = 33
              TabOrder = 0
              OnClick = SearchBackwardClick
              Style = bsNew
            end
            object SearchEdit: TTntEdit
              Left = 50
              Top = 21
              Width = 252
              Height = 27
              Hint = ' '
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              OnKeyUp = SearchEditKeyUp
            end
            object btnQuickSearchFwd: TTntBitBtn
              Left = 312
              Top = 20
              Width = 36
              Height = 33
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
      ParentShowHint = False
      ShowHint = True
      TabHint = 'Search'
      object SearchBrowser: THTMLViewer
        Left = 0
        Top = 227
        Width = 359
        Height = 439
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
        Width = 359
        Height = 227
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          359
          227)
        object SearchLabel: TTntLabel
          Left = 5
          Top = 202
          Width = 80
          Height = 19
          Caption = 'SearchLabel'
        end
        object SearchCB: TTntComboBox
          Left = 5
          Top = 4
          Width = 286
          Height = 27
          Hint = 'enter word or expression to search'
          AutoCloseUp = True
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 10
          ItemHeight = 19
          TabOrder = 0
          OnKeyUp = SearchCBKeyUp
        end
        object CBList: TTntComboBox
          Left = 34
          Top = 36
          Width = 249
          Height = 27
          Hint = 'Search scope'
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 15
          ItemHeight = 19
          TabOrder = 1
          OnDropDown = CBListDropDown
          Items.Strings = (
            #1042#1089#1077' '#1082#1085#1080#1075#1080
            #1053#1077' '#1074#1089#1077' '#1082#1085#1080#1075#1080)
        end
        object FindButton: TTntButton
          AlignWithMargins = True
          Left = 289
          Top = 36
          Width = 68
          Height = 27
          Anchors = [akTop, akRight]
          Caption = #1053#1072#1081#1090#1080
          Default = True
          TabOrder = 2
          OnClick = FindButtonClick
        end
        object CBAll: TTntCheckBox
          Left = 5
          Top = 72
          Width = 354
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Caption = #1083#1102#1073#1086#1077' '#1080#1079' '#1089#1083#1086#1074
          TabOrder = 3
        end
        object CBPhrase: TTntCheckBox
          Left = 5
          Top = 96
          Width = 352
          Height = 22
          Anchors = [akLeft, akTop, akRight]
          Caption = #1089#1086#1073#1083#1102#1076#1072#1090#1100' '#1087#1086#1088#1103#1076#1086#1082' '#1089#1083#1086#1074
          TabOrder = 4
        end
        object CBParts: TTntCheckBox
          Left = 5
          Top = 148
          Width = 352
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Caption = #1080#1097#1077#1084' '#1089#1083#1086#1074#1072' '#1094#1077#1083#1080#1082#1086#1084
          TabOrder = 6
        end
        object CBCase: TTntCheckBox
          Left = 5
          Top = 172
          Width = 352
          Height = 22
          Anchors = [akLeft, akTop, akRight]
          Caption = #1088#1072#1079#1083#1080#1095#1072#1090#1100' '#1088#1077#1075#1080#1089#1090#1088#1099
          TabOrder = 7
        end
        object CBExactPhrase: TTntCheckBox
          Left = 5
          Top = 119
          Width = 352
          Height = 26
          Anchors = [akLeft, akTop, akRight]
          Caption = #1080#1097#1077#1084' '#1090#1086#1095#1085#1091#1102' '#1092#1088#1072#1079#1091
          TabOrder = 5
          OnClick = CBExactPhraseClick
        end
        object CBQty: TTntComboBox
          Left = 297
          Top = 2
          Width = 60
          Height = 27
          Hint = 'Number of result to display per view'
          Style = csDropDownList
          Anchors = [akTop, akRight]
          ItemHeight = 19
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
          Left = 5
          Top = 37
          Width = 26
          Height = 25
          Caption = '<'
          TabOrder = 9
          OnClick = SearchOptionsButtonClick
        end
      end
    end
    object DicTab: TTntTabSheet
      ImageIndex = 17
      TabHint = 'Dictionaries'
      object DicBrowser: THTMLViewer
        Left = 0
        Top = 297
        Width = 359
        Height = 369
        OnHotSpotCovered = FirstBrowserHotSpotCovered
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
        Width = 359
        Height = 226
        Align = alTop
        Anchors = []
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          359
          226)
        object DicFilterCB: TTntComboBox
          Left = 5
          Top = 6
          Width = 352
          Height = 27
          Hint = 'Select dictionary to search within'
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 19
          PopupMenu = EmptyPopupMenu
          TabOrder = 0
          OnChange = DicFilterCBChange
        end
        object DicEdit: TTntComboBox
          Left = 5
          Top = 39
          Width = 352
          Height = 27
          Hint = 'ent word to search here'
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 19
          TabOrder = 1
          OnChange = DicEditChange
          OnKeyPress = DicEditKeyPress
          OnKeyUp = DicEditKeyUp
        end
        object vstDicList: TVirtualStringTree
          Left = 5
          Top = 76
          Width = 352
          Height = 146
          Anchors = [akLeft, akTop, akRight]
          DefaultNodeHeight = 16
          Header.AutoSizeIndex = 0
          Header.DefaultHeight = 17
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -12
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Header.MainColumn = -1
          Indent = 1
          Margin = 0
          NodeDataSize = 4
          ScrollBarOptions.ScrollBars = ssVertical
          TabOrder = 2
          TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toUseBlendedSelection, toUseExplorerTheme]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnAddToSelection = vstDicListAddToSelection
          OnClick = DicLBDblClick
          OnDblClick = DicLBDblClick
          OnGetText = vstDicListGetText
          OnKeyPress = DicLBKeyPress
          Columns = <>
        end
      end
      object DicCBPanel: TTntPanel
        Left = 0
        Top = 226
        Width = 359
        Height = 71
        Align = alTop
        Anchors = []
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          359
          71)
        object DicFoundSeveral: TTntLabel
          Left = 12
          Top = 5
          Width = 213
          Height = 19
          Caption = #1085#1072#1081#1076#1077#1085#1086' '#1074' '#1085#1077#1089#1082#1086#1083#1100#1082#1080#1093' '#1089#1083#1086#1074#1072#1088#1103#1093':'
        end
        object DicCB: TTntComboBox
          Left = 4
          Top = 33
          Width = 351
          Height = 27
          Hint = 'Select dictionary to show entry from'
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 19
          PopupMenu = EmptyPopupMenu
          TabOrder = 0
          OnChange = DicCBChange
        end
      end
    end
    object StrongTab: TTntTabSheet
      ImageIndex = 18
      TabHint = 'Strong'#39's Dictionary'
      object StrongBrowser: THTMLViewer
        AlignWithMargins = True
        Left = 3
        Top = 265
        Width = 353
        Height = 398
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
        Width = 359
        Height = 229
        Align = alTop
        Anchors = []
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          359
          229)
        object StrongEdit: TTntEdit
          Left = 5
          Top = 5
          Width = 352
          Height = 27
          Hint = 'Strong number to show'
          Anchors = [akLeft, akTop, akRight]
          PopupMenu = MemoPopupMenu
          TabOrder = 0
          OnKeyPress = StrongEditKeyPress
        end
        object StrongLB: TTntListBox
          Left = 5
          Top = 40
          Width = 352
          Height = 183
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 19
          PopupMenu = EmptyPopupMenu
          TabOrder = 1
          OnDblClick = StrongLBDblClick
        end
      end
      object FindStrongNumberPanel: TTntPanel
        Left = 0
        Top = 229
        Width = 359
        Height = 33
        Cursor = crHandPoint
        Align = alTop
        Anchors = []
        BevelEdges = []
        BevelOuter = bvNone
        Caption = '# search'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial Unicode MS'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 2
        OnClick = FindStrongNumberPanelClick
        OnMouseDown = FindStrongNumberPanelMouseDown
        OnMouseUp = FindStrongNumberPanelMouseUp
      end
    end
    object CommentsTab: TTntTabSheet
      TabHint = 'Commentaries'
      object CommentsBrowser: THTMLViewer
        Left = 0
        Top = 38
        Width = 359
        Height = 628
        OnHotSpotCovered = FirstBrowserHotSpotCovered
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
        Width = 359
        Height = 38
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          359
          38)
        object CommentsCB: TTntComboBox
          Left = 1
          Top = 4
          Width = 326
          Height = 27
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 25
          ItemHeight = 19
          PopupMenu = EmptyPopupMenu
          TabOrder = 0
          OnChange = CommentsCBChange
          OnCloseUp = CommentsCBCloseUp
          OnDropDown = CommentsCBDropDown
        end
        object btnOnlyMeaningful: TrkGlassButton
          Left = 331
          Top = 5
          Width = 27
          Height = 26
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
          ImageIdx = 40
          Images = theImageList
          LightHeight = 27
          TabOrder = 1
          TextAlign = taLeft
          OnClick = btnOnlyMeaningfulClick
        end
      end
    end
    object MemoTab: TTntTabSheet
      ImageIndex = 2
      TabHint = 'Memos'
      object TREMemo: TTntRichEdit
        Left = 0
        Top = 25
        Width = 359
        Height = 604
        Align = alClient
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -25
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
        Top = 629
        Width = 359
        Height = 37
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object MemoLabel: TTntLabel
          Left = 5
          Top = 5
          Width = 16
          Height = 19
          Caption = '....'
        end
      end
      object TntToolBar1: TTntToolBar
        AlignWithMargins = True
        Left = 2
        Top = 2
        Width = 354
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
          EmbedDropDownStyle = False
        end
        object MemoSave: TTntToolButton
          Left = 23
          Top = 0
          Caption = 'MemoSave'
          ImageIndex = 10
          OnClick = MemoSaveClick
          EmbedDropDownStyle = False
        end
        object MemoPrint: TTntToolButton
          Left = 46
          Top = 0
          Caption = 'MemoPrint'
          ImageIndex = 11
          OnClick = MemoPrintClick
          EmbedDropDownStyle = False
        end
        object Sep21: TTntToolButton
          Left = 69
          Top = 0
          Width = 6
          Style = tbsSeparator
          EmbedDropDownStyle = False
        end
        object MemoFont: TTntToolButton
          Left = 75
          Top = 0
          Caption = 'MemoFont'
          ImageIndex = 20
          OnClick = MemoFontClick
          EmbedDropDownStyle = False
        end
        object Sep22: TTntToolButton
          Left = 98
          Top = 0
          Width = 6
          Style = tbsSeparator
          EmbedDropDownStyle = False
        end
        object MemoBold: TTntToolButton
          Left = 104
          Top = 0
          Caption = 'MemoBold'
          ImageIndex = 21
          OnClick = MemoBoldClick
          EmbedDropDownStyle = False
        end
        object MemoItalic: TTntToolButton
          Left = 127
          Top = 0
          Caption = 'MemoItalic'
          ImageIndex = 22
          OnClick = MemoItalicClick
          EmbedDropDownStyle = False
        end
        object MemoUnderline: TTntToolButton
          Left = 150
          Top = 0
          Caption = 'MemoUnderline'
          ImageIndex = 23
          OnClick = MemoUnderlineClick
          EmbedDropDownStyle = False
        end
        object Sep23: TTntToolButton
          Left = 173
          Top = 0
          Width = 6
          Style = tbsSeparator
          EmbedDropDownStyle = False
        end
        object MemoPainter: TTntToolButton
          Left = 179
          Top = 0
          Caption = 'MemoPainter'
          ImageIndex = 24
          OnClick = MemoPainterClick
          EmbedDropDownStyle = False
        end
      end
    end
    object XRefTab: TTntTabSheet
      ImageIndex = 19
      TabHint = 'TSK'
      object XRefBrowser: THTMLViewer
        Left = 0
        Top = 0
        Width = 359
        Height = 666
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
    object tbList: TTntTabSheet
      ImageIndex = 39
      object TntToolBar2: TTntToolBar
        Left = 0
        Top = 0
        Width = 359
        Height = 30
        ButtonHeight = 30
        ButtonWidth = 31
        GradientEndColor = 13684944
        Images = il24
        TabOrder = 0
        object tbtnAddNode: TTntToolButton
          Left = 0
          Top = 0
          Caption = 'tbtnAddNode'
          ImageIndex = 0
          OnClick = tbtnAddTagClick
          EmbedDropDownStyle = False
        end
        object tbtnDelNode: TTntToolButton
          Left = 31
          Top = 0
          AutoSize = True
          Caption = 'tbtnDelNode'
          ImageIndex = 1
          OnClick = tbtnDelNodeClick
          EmbedDropDownStyle = False
        end
      end
      object vdtTags_Verses: TVirtualDrawTree
        Left = 0
        Top = 57
        Width = 359
        Height = 609
        Cursor = crArrow
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderWidth = 1
        Color = clWhite
        Colors.BorderColor = clWindow
        Colors.DisabledColor = clWindow
        Colors.FocusedSelectionColor = 14675956
        Colors.FocusedSelectionBorderColor = 4628174
        Colors.HotColor = clBtnHighlight
        Colors.SelectionRectangleBlendColor = clCaptionText
        Colors.UnfocusedSelectionColor = 14675956
        Colors.UnfocusedSelectionBorderColor = 8634078
        Header.AutoSizeIndex = -1
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.FixedAreaConstraints.MinWidthPercent = 100
        Header.MainColumn = -1
        Header.Options = [hoColumnResize, hoDrag]
        HintAnimation = hatFade
        HintMode = hmHint
        IncrementalSearch = isAll
        Indent = 2
        NodeDataSize = 4
        ParentShowHint = False
        SelectionCurveRadius = 7
        ShowHint = True
        TabOrder = 1
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking, toDisableAutoscrollOnEdit]
        TreeOptions.MiscOptions = [toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toVariableNodeHeight, toEditOnClick]
        TreeOptions.PaintOptions = [toHideFocusRect, toThemeAware]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnCollapsed = vdtTags_VersesCollapsed
        OnCompareNodes = vdtTags_VersesCompareNodes
        OnCreateEditor = vdtTags_VersesCreateEditor
        OnDblClick = vdtTags_VersesDblClick
        OnDrawNode = vdtTags_VersesDrawNode
        OnEdited = vdtTags_VersesEdited
        OnEditing = vdtTags_VersesEditing
        OnGetNodeWidth = vdtTags_VersesGetNodeWidth
        OnIncrementalSearch = vdtTags_VersesIncrementalSearch
        OnMeasureItem = vdtTags_VersesMeasureItem
        OnMouseMove = vdtTags_VersesMouseMove
        OnResize = vdtTags_VersesResize
        OnShowScrollbar = vdtTags_VersesShowScrollbar
        OnStateChange = vdtTags_VersesStateChange
        Columns = <>
      end
      object cbbTagsFilter: TTntComboBox
        Left = 0
        Top = 30
        Width = 359
        Height = 27
        Align = alTop
        BevelInner = bvSpace
        BevelOuter = bvSpace
        ItemHeight = 19
        TabOrder = 2
        OnChange = cbbTagsFilterChange
      end
    end
  end
  object ToolbarPanel: TAlekPanel
    Left = 0
    Top = 0
    Width = 905
    Height = 31
    Align = alTop
    BevelEdges = [beBottom]
    ParentBackground = False
    TabOrder = 3
    GradientDirection = gdVertical
    GradientStartColor = clWindow
    GradientEndColor = clBtnFace
    object lbTitleLabel: TTntLabel
      AlignWithMargins = True
      Left = 606
      Top = 4
      Width = 73
      Height = 23
      Margins.Right = 7
      Align = alLeft
      Anchors = []
      Caption = 'lbTitleLabel'
      Transparent = True
      Layout = tlCenter
      ExplicitHeight = 19
    end
    object lbCopyRightNotice: TTntLabel
      AlignWithMargins = True
      Left = 689
      Top = 4
      Width = 208
      Height = 23
      Margins.Right = 7
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'CopyRight'
      Transparent = True
      Layout = tlCenter
      ExplicitLeft = 849
      ExplicitTop = 5
      ExplicitWidth = 48
      ExplicitHeight = 20
    end
    object MainToolbar: TTntToolBar
      Left = 1
      Top = 1
      Width = 416
      Height = 29
      Margins.Top = 2
      Margins.Bottom = 0
      Align = alLeft
      AutoSize = True
      ButtonHeight = 23
      DrawingStyle = dsGradient
      EdgeInner = esNone
      EdgeOuter = esNone
      GradientEndColor = clBtnFace
      Images = theImageList
      List = True
      TabOrder = 2
      object ToggleButton: TTntToolButton
        Left = 0
        Top = 0
        Caption = 'Toggle'
        ImageIndex = 16
        OnClick = ToggleButtonClick
        EmbedDropDownStyle = False
      end
      object Sep01: TTntToolButton
        Left = 23
        Top = 0
        Width = 6
        Style = tbsSeparator
        EmbedDropDownStyle = False
      end
      object NewTabButton: TTntToolButton
        Left = 29
        Top = 0
        Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1082#1083#1072#1076#1082#1091' '#1074#1080#1076#1072
        Caption = 'NewTabButton'
        ImageIndex = 30
        OnClick = miNewTabClick
        EmbedDropDownStyle = False
      end
      object CloseTabButton: TTntToolButton
        Left = 52
        Top = 0
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1082#1083#1072#1076#1082#1091' '#1074#1080#1076#1072
        Caption = 'CloseTabButton'
        ImageIndex = 31
        OnClick = miCloseTabClick
        EmbedDropDownStyle = False
      end
      object Sep06: TTntToolButton
        Left = 75
        Top = 0
        Width = 6
        Style = tbsSeparator
        EmbedDropDownStyle = False
      end
      object BackButton: TTntToolButton
        Left = 81
        Top = 0
        Caption = 'Back'
        ImageIndex = 4
        OnClick = BackButtonClick
        EmbedDropDownStyle = False
      end
      object ForwardButton: TTntToolButton
        Left = 104
        Top = 0
        Caption = 'Forward'
        ImageIndex = 6
        OnClick = ForwardButtonClick
        EmbedDropDownStyle = False
      end
      object Sep02: TTntToolButton
        Left = 127
        Top = 0
        Width = 6
        Style = tbsSeparator
        EmbedDropDownStyle = False
      end
      object PrevChapterButton: TTntToolButton
        Left = 133
        Top = 0
        Caption = 'Minus'
        ImageIndex = 25
        OnClick = PrevChapterButtonClick
        EmbedDropDownStyle = False
      end
      object NextChapterButton: TTntToolButton
        Left = 156
        Top = 0
        Caption = 'Plus'
        ImageIndex = 26
        OnClick = NextChapterButtonClick
        EmbedDropDownStyle = False
      end
      object Sep03: TTntToolButton
        Left = 179
        Top = 0
        Width = 6
        Style = tbsSeparator
        EmbedDropDownStyle = False
      end
      object CopyButton: TTntToolButton
        Left = 185
        Top = 0
        Caption = 'Copy'
        ImageIndex = 15
        OnClick = CopySelectionClick
        EmbedDropDownStyle = False
      end
      object StrongNumbersButton: TTntToolButton
        Left = 208
        Top = 0
        Caption = 'Strong'
        ImageIndex = 18
        Style = tbsCheck
        OnClick = miStrongClick
        EmbedDropDownStyle = False
      end
      object MemosButton: TTntToolButton
        Left = 231
        Top = 0
        Caption = 'Memos'
        ImageIndex = 29
        Style = tbsCheck
        OnClick = miMemosToggleClick
        EmbedDropDownStyle = False
      end
      object tbtnLib: TTntToolButton
        Left = 254
        Top = 0
        Hint = 'Browse Library'
        Caption = 'btnQNav'
        ImageIndex = 33
        OnClick = tbtnLibClick
        EmbedDropDownStyle = False
      end
      object Sep04: TTntToolButton
        Left = 277
        Top = 0
        Width = 6
        Style = tbsSeparator
        EmbedDropDownStyle = False
      end
      object PreviewButton: TTntToolButton
        Left = 283
        Top = 0
        Caption = 'Preview'
        ImageIndex = 12
        OnClick = PreviewButtonClick
        EmbedDropDownStyle = False
      end
      object PrintButton: TTntToolButton
        Left = 306
        Top = 0
        Caption = 'Print'
        ImageIndex = 11
        OnClick = PrintButtonClick
        EmbedDropDownStyle = False
      end
      object Sep05: TTntToolButton
        Left = 329
        Top = 0
        Width = 6
        Style = tbsSeparator
        EmbedDropDownStyle = False
      end
      object SoundButton: TTntToolButton
        Left = 335
        Top = 0
        Caption = 'Sound'
        ImageIndex = 14
        OnClick = SoundButtonClick
        EmbedDropDownStyle = False
      end
      object CopyrightButton: TTntToolButton
        Left = 358
        Top = 0
        Caption = 'Copyright'
        ImageIndex = 32
        OnClick = CopyrightButtonClick
        EmbedDropDownStyle = False
      end
      object SatelliteButton: TTntToolButton
        Left = 381
        Top = 0
        Caption = 'Satellite'
        ImageIndex = 3
        Style = tbsCheck
        OnClick = SatelliteButtonClick
        OnMouseEnter = SatelliteButtonMouseEnter
        EmbedDropDownStyle = False
      end
      object tbbMainPanelLastSeparator: TTntToolButton
        Left = 404
        Top = 0
        Width = 12
        Caption = 'tbbMainPanelLastSeparator'
        Style = tbsSeparator
        Visible = False
        EmbedDropDownStyle = False
      end
    end
    object tlbResolveLnks: TTntToolBar
      Left = 417
      Top = 1
      Width = 50
      Height = 29
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alLeft
      ButtonHeight = 23
      ButtonWidth = 40
      DrawingStyle = dsGradient
      EdgeInner = esNone
      EdgeOuter = esNone
      GradientEndColor = clBtnFace
      Images = theImageList
      List = True
      TabOrder = 0
      object tbtnResolveLinks: TTntToolButton
        AlignWithMargins = True
        Left = 0
        Top = 0
        AutoSize = True
        Caption = 'Recognize Bible Links'
        DropdownMenu = popupRecLinksOptions
        ImageIndex = 42
        Style = tbsDropDown
        OnClick = tbtnResolveLinksClick
        EmbedDropDownStyle = False
      end
      object TntToolButton1: TTntToolButton
        Left = 44
        Top = 0
        Caption = 'TntToolButton1'
        EmbedDropDownStyle = False
      end
      object TntToolButton2: TTntToolButton
        Left = 84
        Top = 0
        Caption = 'TntToolButton2'
        EmbedDropDownStyle = False
      end
    end
    object tbLinksToolBar: TTntToolBar
      Left = 467
      Top = 1
      Width = 136
      Height = 29
      Margins.Top = 2
      Margins.Bottom = 0
      Align = alLeft
      AutoSize = True
      ButtonHeight = 24
      ButtonWidth = 13
      Caption = '44444'
      DrawingStyle = dsGradient
      GradientEndColor = clBtnFace
      List = True
      ShowCaptions = True
      TabOrder = 1
      Visible = False
      object LinksCB: TTntComboBox
        Left = 0
        Top = 0
        Width = 136
        Height = 27
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        Style = csDropDownList
        ItemHeight = 19
        TabOrder = 0
        OnChange = LinksCBChange
      end
    end
  end
  object TRE: TTntRichEdit
    Left = 385
    Top = 89
    Width = 121
    Height = 163
    Lines.Strings = (
      'TRE')
    TabOrder = 4
    Visible = False
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
    Left = 494
    Top = 119
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
      OnClick = CopySelectionClick
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
    object miAddBookmarkTagged: TTntMenuItem
      Caption = 'Add Themed Bookmark'
      OnClick = miAddBookmarkTaggedClick
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
    OnPopup = RefPopupMenuPopup
    Left = 406
    Top = 269
    object miRefCopy: TTntMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnClick = miRefCopyClick
    end
    object miOpenNewView: TTntMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074' '#1085#1086#1074#1086#1081' '#1074#1082#1083#1072#1076#1082#1077
      OnClick = miOpenNewViewClick
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
  object theMainMenu: TTntMainMenu
    AutoHotkeys = maManual
    Images = theImageList
    Left = 405
    Top = 86
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
        ShortCut = 16499
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
        object miVerseHighlightBG: TTntMenuItem
          Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1093' '#1089#1090#1080#1093#1086#1074
          OnClick = miVerseHighlightBGClick
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
      object miMyLibrary: TTntMenuItem
        Caption = 'My Librar&y'
        ImageIndex = 33
        ShortCut = 16460
        OnClick = tbtnLibClick
      end
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
      object miChooseSatelliteBible: TTntMenuItem
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1090#1086#1088#1080#1095#1085#1099#1081' '#1074#1080#1076'...'
        ImageIndex = 3
        OnClick = miChooseSatelliteBibleClick
      end
      object miRecognizeBibleLinks: TTntMenuItem
        AutoCheck = True
        Caption = 'Recognize Bible Links'
        OnClick = miRecognizeBibleLinksClick
      end
      object N19: TTntMenuItem
        Caption = '-'
      end
      object miCopy: TTntMenuItem
        Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1081' '#1090#1077#1082#1089#1090
        ImageIndex = 15
        ShortCut = 16500
        OnClick = CopySelectionClick
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
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object miHelp: TTntMenuItem
        Caption = #1050#1072#1082' '#1088#1072#1073#1086#1090#1072#1090#1100' '#1089' "'#1062#1080#1090#1072#1090#1086#1081'"'
        ShortCut = 112
        OnClick = miHelpClick
      end
      object miWebSites: TTntMenuItem
        Caption = 'JesusChrist.ru'
        object JCRU_Home: TTntMenuItem
          Caption = 'JesusChrist.ru'
          OnClick = JCRU_HomeClick
        end
        object miTechnoForum: TTntMenuItem
          Caption = #1054#1073#1089#1091#1078#1076#1077#1085#1080#1077' 6-'#1081' '#1074#1077#1088#1089#1080#1080' "'#1062#1080#1090#1072#1090#1099'"'
          OnClick = JCRU_HomeClick
        end
      end
      object miDownloadLatest: TTntMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1086#1089#1083#1077#1076#1085#1102#1102' '#1074#1077#1088#1089#1080#1102
        OnClick = JCRU_HomeClick
      end
      object miAbout: TTntMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = miAboutClick
      end
    end
    object miLanguage: TTntMenuItem
      Caption = '&UI Language'
    end
  end
  object theImageList: TImageList
    Left = 360
    Top = 432
    Bitmap = {
      494C01012C002D00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000C0000000010020000000000000C0
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFDFFC0C0C0FF7373
      73FF7F7F7FFFD2D2D2FFFEFEFEFF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFDFFE6CAA1FFCB88
      2CFFCE913EFFEDD9BBFFFEFFFEFF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FBFBFAFF94B1B8FF2785
      B7FF3889B3FFB0C3C2FFFCFEFDFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFDFF979797FF535353FF6565
      65FF616161FF525252FFB9B9B9FFFEFEFEFF0000000000000000000000000000
      000000000000000000000000000000000000FEFEFDFFD9A861FFC26900FFD484
      01FFD07F00FFC16800FFE3C593FFFEFFFFFF0000000000000000000000000000
      000000000000000000000000000000000000FBFBFBFF599AB7FF0084C2FF007F
      D4FF007DD1FF0084C2FF88ADB9FFFDFEFEFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000505050005050
      5000505050000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8B8B8FF555555FF8E8E8EFFF3F3
      F3FFEBEBEBFF767676FF555555FFBEBEBEFFFEFEFEFF00000000000000000000
      000000000000000000000000000000000000E6C690FFC56C00FFDFA644FFFAF6
      ECFFF8F0DDFFD7921DFFC56D00FFE7CB99FFFEFEFFFF00000000000000000000
      00000000000000000000000000000000000085ABBAFF0083C4FF3F92C7FFE5E6
      E2FFD6DDD5FF1A85CEFF0083C4FF8FB1BAFFFDFCFEFF00000000000000000000
      00000000000000000000000000000000000000000000727272006D6D6D006D6D
      6D006A6A6A005050500000000000000000000000000000000000000000000000
      000000000000000000000000000000000000656565FF6D6D6DFFFAFAFAFF0000
      000000000000F7F7F7FF808080FF585858FFC3C3C3FFFEFEFEFF000000000000
      000000000000000000000000000000000000CB810CFFD28815FFFDFBF8FF0000
      000000000000FCF9F3FFDD9B29FFC87100FFEBCF9FFFFEFFFFFF000000000000
      0000000000000000000000000000000000000979BFFF1583CCFFF5F6F4FF0000
      000000000000EFF0EDFF268ACCFF0081C7FF97B6C0FFFDFFFFFF000000000000
      0000000000000000000000000000000000000000000078787800555555000000
      0000000000006D6D6D0050505000000000000000000000000000000000000000
      0000000000000000000000000000000000006C6C6CFF6F6F6FFFFBFBFBFF0000
      00000000000000000000E5E5E5FF838383FF636363FFF8F8F8FF000000000000
      000000000000000000000000000000000000D38B0BFFD08B16FFFDFCF8FF0000
      0000FEFEFEFFF8F2E5FFF6EBD3FFE0A02AFFD18200FFFCF9F3FF000000000000
      000000000000000000000000000000000000097AC7FF167FC9FFF5F6F2FF0000
      0000FDFDFDFFE0E7E7FFCCD7D4FF298AD0FF007DD1FFEFEFECFF000000000000
      00000000000000000000000000000000000000000000818181005A5A5A000000
      0000727272005555550072727200555555000000000000000000000000000000
      000000000000000000000000000000000000BDBDBDFF636363FF909090FFFDFD
      FDFF000000000000000000000000DEDEDEFF848484FFEEEEEEFF000000000000
      000000000000000000000000000000000000EDCE8CFFD38200FFDCA848FFFEFE
      FCFFF7EEDAFFBF6800FFD49C4EFFF4E7C6FFDEA228FFFAF2E1FF000000000000
      00000000000000000000000000000000000085AEC3FF007FD4FF4490C4FFFAFB
      F9FFD5E0E1FF0080BFFF4894BAFFC0CFD1FF2685CFFFDBE0D7FF000000000000
      0000000000000000000000000000000000000000000000000000858585006161
      610000000000777777005A5A5A00777777005A5A5A0000000000000000000000
      000000000000000000000000000000000000FDFDFDFFA3A3A3FF676767FF9C9C
      9CFFE4E4E4FF000000000000000000000000E2E2E2FFEAEAEAFFDBDBDBFFF1F1
      F1FFFEFEFEFF000000000000000000000000FEFDFCFFE8BE58FFD78700FFDFB3
      57FFF6EBD1FFDC961BFFCB7600FFD8A144FFF5E9CBFFF9F0DAFFF5E6BFFFFAF5
      E7FFFEFFFFFF000000000000000000000000F9FAF9FF5497CDFF007DD6FF5194
      C0FFCBD8D8FF1488DBFF0081CCFF3F8FC3FFC5D4D8FFD5DDDBFFB8C9CAFFE3E7
      E1FFFDFEFEFF0000000000000000000000000000000000000000000000008A8A
      8A0065656500000000007E7E7E00616161008181810065656500000000000000
      00000000000000000000000000000000000000000000FDFDFDFFAAAAAAFF6B6B
      6BFF9A9A9AFFDBDBDBFF000000000000000000000000D9D9D9FF7D7D7DFF6B6B
      6BFFC3C3C3FFFEFEFEFF000000000000000000000000FEFDFBFFECC460FFDA8E
      00FFE3B250FFF5E5BDFFE1A51BFFD38600FFDEA83FFFF4E4BCFFE1A311FFD98E
      00FFEED396FFFEFFFFFF000000000000000000000000F9FAF8FF5C99CBFF007B
      D9FF4C97CAFFB8CDD6FF147EE0FF007BD4FF2C8FDBFFB6CCD7FF127CDDFF007B
      D9FF8FB3C5FFFDFEFEFF00000000000000000000000000000000A3A3A3007575
      7500969696006D6D6D00000000008D8D8D006A6A6A008D8D8D006D6D6D000000
      0000000000000000000000000000000000000000000000000000FDFDFDFFB4B4
      B4FF777777FF9F9F9FFFDFDFDFFF000000000000000000000000DDDDDDFF8B8B
      8BFF6D6D6DFFC7C7C7FFFEFEFEFF000000000000000000000000FEFEFCFFEFCC
      70FFE2A100FFEBBC4CFFF6E9C3FFE9B127FFDC9300FFE4B43FFFF6E8C1FFE7AF
      23FFDB9100FFF1D699FFFEFFFFFF000000000000000000000000FAFBF9FF6CA0
      C9FF0071E3FF4B99DBFFBFD1D6FF2685DFFF0079DBFF2B87E3FFBDD1DAFF2180
      DBFF0079DBFF93B5C6FFFDFEFEFF00000000000000000000000000000000ACAC
      AC007E7E7E00A3A3A30077777700000000009898980075757500989898007575
      750000000000000000000000000000000000000000000000000000000000FEFE
      FEFFECECECFFD8D8D8FFECECECFFDFDFDFFF000000000000000000000000F0F0
      F0FF919191FF727272FFC7C7C7FFFEFEFEFF000000000000000000000000FEFE
      FEFFFBF2DDFFF6E5B7FFFAF1DBFFF7E9C2FFEFC248FFE8A609FFEDC459FFFAF5
      E1FFEAB52CFFDE9800FFF2D897FFFEFEFEFF000000000000000000000000FDFD
      FDFFD8DDD4FFAEBDB4FFD7DFDEFFBED1DBFF4696E7FF097CE8FF599EDEFFDEE4
      E1FF2A85DCFF0076DEFF92B5C6FFFCFCFCFF0000000000000000000000000000
      0000B3B3B3008A8A8A00ACACAC0081818100A3A3A3007E7E7E00000000009F9F
      9F007E7E7E000000000000000000000000000000000000000000000000000000
      00000000000000000000D9D9D9FF9C9C9CFFE9E9E9FF0000000000000000FEFE
      FEFFF7F7F7FF959595FF757575FFE2E2E2FF0000000000000000000000000000
      00000000000000000000F4E5B7FFEABB44FFFBF0D6FFF7DD97FFF4CD67FFFEFE
      FDFFFDFAF0FFEBB833FFE19E00FFF9EBC9FF0000000000000000000000000000
      00000000000000000000B0C4C8FF428FD7FFD3DED9FF94BBD6FF66A7DCFFFBFB
      FAFFEEF0EBFF3389E1FF0074E0FFC5D3D4FF0000000000000000000000000000
      000000000000BABABA0091919100B3B3B300ACACAC000000000000000000A5A5
      A500818181000000000000000000000000000000000000000000000000000000
      00000000000000000000EBEBEBFF7D7D7DFFA7A7A7FFF0F0F0FFFAFAFAFF0000
      000000000000EEEEEEFF7A7A7AFFB5B5B5FF0000000000000000000000000000
      00000000000000000000FAF1D9FFE8A705FFEDC357FFFBF5E3FFFDFCF5FF0000
      000000000000FAF3DFFFE6A501FFF0CE71FF0000000000000000000000000000
      00000000000000000000D6DEDCFF0576E8FF5599D2FFE0E9EBFFF3F4F1FF0000
      000000000000DBE2DFFF0073E6FF6DA3CCFF0000000000000000000000000000
      00000000000000000000BFBFBF009A9A9A00000000000000000000000000ACAC
      AC00858585000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFEFFC1C1C1FF898989FFABABABFFFDFDFDFF0000
      000000000000E9E9E9FF818181FFC2C2C2FF0000000000000000000000000000
      00000000000000000000FEFEFEFFF5D588FFECB118FFEFC75DFFFEFEFCFF0000
      000000000000F9F1D4FFEAAC09FFF5D68AFF0000000000000000000000000000
      00000000000000000000FCFCFCFF86B9E0FF1882EDFF5C9FDBFFFAFBFAFF0000
      000000000000CFDADAFF097AEBFF87B6D5FF0000000000000000000000000000
      0000000000000000000000000000C1C1C1009F9F9F009A9A9A00B6B6B6009191
      9100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FEFEFEFFC3C3C3FF949494FFADADADFFF6F6
      F6FFEAEAEAFF959595FF9B9B9BFFEEEEEEFF0000000000000000000000000000
      0000000000000000000000000000FEFEFDFFF7D88AFFF1B92BFFF3CA5FFFFDF8
      EFFFFBF1D6FFF0B92FFFF2BD3BFFFAF4DFFF0000000000000000000000000000
      0000000000000000000000000000FBFBFAFF87B6DBFF2C8FF2FF5EA4E4FFECEE
      EBFFD3DDDCFF3090EFFF3A96F2FFDBE2E0FF0000000000000000000000000000
      000000000000000000000000000000000000C4C4C400C1C1C1009F9F9F000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FAFAFAFFBFBFBFFFA0A0A0FF9E9E
      9EFF9B9B9BFFA7A7A7FFDDDDDDFFFEFEFEFF0000000000000000000000000000
      000000000000000000000000000000000000FEFCF6FFF8D581FFF4C33FFFF2C0
      3DFFF3BE38FFF5C64FFFFBE9B9FFFEFEFEFF0000000000000000000000000000
      000000000000000000000000000000000000F4F3EDFF7FB2D8FF4097F5FF3D97
      F2FF3895F2FF4EA2F5FFB7CFDBFFFCFCFCFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F9F9F9FFDADADAFFC3C3
      C3FFC4C4C4FFE6E6E6FF00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFBF4FFFBE7B4FFF8D9
      86FFF7DA8AFFFBF0CBFF00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F2F2EBFFB3CFDEFF84BC
      EDFF89BCEDFFC8D3CCFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E6C3AA00CD896000C676
      4600BF6D36004D4D4D004D4D4D004D4D4D004D4D4D00BD6B31004D4D4D004D4D
      4D004D4D4D004D4D4D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B4B4B400818181008181
      8100818181008181810081818100818181008181810081818100818181008181
      81008181810081818100B9B9B900000000000000000000000000000000000000
      0000EFF7E700C6EFAD008CDE5A006BD621006BD621008CDE5A00C6EFAD00EFF7
      E7000000000000000000000000000000000000000000C87F4F00FEF6ED00F8F0
      E1004D4D4D00FFFFFF00FFFFFF00FFFFFF00FFFFFF004D4D4D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D4D4D00000000000000000000000000000000000000
      000000000000F7F1EC00E2CEBB00DAC0A800D6B99E00DEC7B200F3EAE2000000
      0000000000000000000000000000000000000000000081818100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000081818100000000000000000000000000000000000000
      0000C6EFAD0052D6080052D6080052D6080052D6080052D6080052D60800C6EF
      AD000000000000000000000000000000000000000000C7774700F7EDDC004D4D
      4D00FFFFFF004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D
      4D004D4D4D004D4D4D00FFFFFF004D4D4D000000000000000000000000000000
      0000DAC0A800BE8F6500D6B99E00DEC7B200E2CEBB00DAC0A800C2966E00D2B2
      9500FBF8F500000000000000000000000000000000008181810000000000EDED
      ED00EDEDED00EEEEEE00EFEFEF00EFEFEF00F0F0F000F0F0F000F1F1F100F2F2
      F200F2F2F2000000000081818100000000000000000000000000000000000000
      00008CDE5A0052D60800D6FFCE00D6FFCE00D6FFCE00D6FFCE0052D608008CDE
      52000000000000000000000000000000000000000000C77F4700F7EDE4004D4D
      4D00FFFFFF004D4D4D00FCE0CC004D4D4D00FFFFFF00FFFFFF00FFFFFF004D4D
      4D00FEF5F0004D4D4D00FFFFFF004D4D4D00000000000000000000000000D6B9
      9E00CAA48100F7F1EC0000000000FBF8F500EFE3D800F3EAE200FBF8F500D2B2
      9500CAA48100FBF8F5000000000000000000000000008181810000000000DDDD
      DD00C4C4C400C7C7C700C7C7C700C8C8C800C8C8C800C6C6C600DFDFDF00F1F1
      F100F2F2F20000000000818181000000000000000000EFF7E700C6EFAD008CDE
      5A0052D6080052D60800D6FFCE00D6FFCE00D6FFCE00D6FFCE005AD6180052D6
      08008CDE5A00C6EFAD00EFF7E7000000000000000000C7884700F7F4E4004D4D
      4D00FFFFFF004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D
      4D004D4D4D004D4D4D00FFFFFF004D4D4D000000000000000000EBDCCF00C296
      6E00FBF8F500F3EAE200CEAB8B00BE8F6500C2966E00BE8F6500C2966E000000
      0000CEAB8B00DAC0A8000000000000000000000000008181810000000000C9C9
      C90078483600B39D9500EDEDED00EFEFEF00B7A39B0078483600CECECE00F1F1
      F100F1F1F10000000000818181000000000000000000C6EFAD0052D6080052D6
      080052D6080052D60800D6FFCE00D6FFCE00D6FFCE00D6FFCE005AD6180052D6
      080052D6080052D60800C6EFAD000000000000000000C8884F00FEF4EB00FCE1
      CD004D4D4D00FFFFFF00FFFFFF00FFFFFF00FFFFFF004D4D4D00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004D4D4D00000000000000000000000000CAA48100E7D5
      C500FBF8F500C69D7800BE8F6500E7D5C50000000000EBDCCF00BE8F65000000
      0000F7F1EC00BE8F6500FBF8F50000000000000000008181810000000000C1C1
      C100784836007848360086625400886658007848360078483600A4A4A400C8C8
      C800F0F0F000000000008181810000000000000000008CDE5A0052D60800D6FF
      CE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FF
      CE00D6FFCE0052D608008CDE5A000000000000000000C8884F00FEF4EB00A56E
      6700A56E67004D4D4D004D4D4D004D4D4D004D4D4D00CAA194004D4D4D004D4D
      4D004D4D4D004D4D4D0000000000000000000000000000000000BE8F65000000
      0000EBDCCF00BE8F6500CAA481000000000000000000F7F1EC00DEC7B2000000
      000000000000CAA48100EFE3D80000000000000000008181810000000000BABA
      BA0078483600B39076007848360078483600B391770079493700BCBCBC00EFEF
      EF00F0F0F000000000008181810000000000000000006BD6210052D60800D6FF
      CE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FF
      CE00D6FFCE0052D608006BD621000000000000000000CF8F4F00FEF4EB00FBDF
      CB00FBDFCA00FADEC900FADDC800FADDC700FADCC600F9DBC500F9DBC400F9DA
      C300FEF3E900CE884F00000000000000000000000000EFE3D800C69D78000000
      0000DEC7B200BE8F6500DAC0A800000000000000000000000000000000000000
      000000000000D2B29500DEC7B20000000000000000008181810000000000B0B0
      B00078483600B3917700B08C7000AF8A6E00B492780079493700ADB2B100EEEE
      EE00F0F0F000000000008181810000000000000000006BD6210052D60800D6FF
      CE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FF
      CE00D6FFCE0052D608006BD621000000000000000000CF8F4F00FEF4EA00A56E
      6700A56E6700AD786F00B3827900BB8C8200C3968B00CAA19400CAA09400CAA0
      9400FEF3E900CF885000000000000000000000000000FBF8F500BE8F65000000
      0000E7D5C500BE8F6500CEAB8B00000000000000000000000000000000000000
      000000000000CEAB8B00EBDCCF0000000000000000008181810000000000AAAA
      AA0078483600B3917700A47A5A00A47A5A00B492780079493700AAA9A900EEEE
      EE00F0F0F000000000008181810000000000000000008CDE5A0052D60800D6FF
      CE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FFCE00D6FF
      CE00D6FFCE0052D608008CDE5A000000000000000000CF8F5700FEF4EA00FADE
      C900FADDC800FADCC700F9DCC600F9DBC500F9DAC400F9DAC300F8D9C200F8D9
      C100FEF3E900CE88500000000000000000000000000000000000C2966E00EFE3
      D800F7F1EC00C2966E00BE8F6500F3EAE20000000000EFE3D800BE8F65000000
      0000FBF8F500C2966E00F3EAE20000000000000000008181810000000000AAAA
      AA0075463400B08F75009F7657009E765700AF8F7500754635008E8D8D00C7C7
      C700EFEFF000FBFEFE00808282000000000000000000C6EFAD0052D6080052D6
      080052D6080052D60800D6FFCE00D6FFCE00D6FFCE00D6FFCE0052D6080052D6
      080052D6080052D60800C6EFAD000000000000000000CF8F5700FEF4F100A56E
      6700A56E6700AD786F00B3827900BB8C8200C3968B00CAA19400CAA09400CAA0
      9400FEF3E900CE88500000000000000000000000000000000000DAC0A800D2B2
      950000000000E7D5C500C2966E00C2966E00DAC0A800CAA48100BE8F65000000
      0000E2CEBB00CEAB8B000000000000000000000000008181810000000000A9A9
      A9006C413000A6877000936E5100936D5000A68770006C413100A9A9A800EAED
      EE00D5EEF100C9F8FE0075989C00F9FEFF0000000000EFF7E700C6EFAD008CDE
      5A0052D6080052D60800D6FFCE00D6FFCE00D6FFCE00D6FFCE0052D6080052D6
      08008CDE5A00C6EFAD00EFF7E7000000000000000000CF8F5700FEF4F100FADC
      C600F9DCC500F9DBC400F9DAC300F8DAC200F8D9C200F8D8C100F8D8C000F7D7
      BF00FEF3EC00CC88500000000000000000000000000000000000FBF8F500C69D
      7800D6B99E0000000000F7F1EC00E2CEBB00DEC7B200DEC7B200EBDCCF00E7D5
      C500C2966E00F3EAE2000000000000000000000000008181810000000000A9A9
      A900663E2F00A0836C008C684C008C684D00A1836D00673F30008B8F8F00A1D5
      DC00A8F0FA00AFF3FD0070C8D300D9FAFE000000000000000000000000000000
      00008CDE5A0052D60800D6FFCE00D6FFCE00D6FFCE00D6FFCE0052D608008CDE
      5A000000000000000000000000000000000000000000CF8F5700FEF3F100A56E
      6700A56E6700AD786F00B3827900BB8C8200C3968B00CAA19400CAA09400CAA0
      9400FEF3EE00CA8850000000000000000000000000000000000000000000F3EA
      E200CAA48100CEAB8B00EBDCCF000000000000000000F3EAE200D6B99E00C296
      6E00EBDCCF00000000000000000000000000000000008181810000000000ACAC
      AC006E433200A98A72009871530098715300AA8B72007045340092B7BC00A0F0
      F900EAFAFD00F5FDFE00A9E7EF00B9F6FE000000000000000000000000000000
      0000C6EFAD0052D6080052D6080052D6080052D6080052D6080052D60800C6EF
      AD000000000000000000000000000000000000000000CF975F00FEF3F100F9DB
      C400F9DAC300F8D9C200F8D9C100F8D8C000F7D7BF00F7D7BE00F7D6BD00F7D6
      BD00FAEFEC00C888500000000000000000000000000000000000000000000000
      0000FBF8F500E2CEBB00CAA48100BE8F6500BE8F6500CAA48100DAC0A800F7F1
      EC0000000000000000000000000000000000000000008181810000000000BABA
      BA0078483600BA9B8500AC876A00AC876A00BB9D85007A4A380096C4CA00A4F2
      FD00F3FDFE00FBFEFE00C6F1F500AFF5FE000000000000000000000000000000
      0000EFF7E700C6EFAD008CDE5A006BD621006BD621008CDE5A00C6EFAD00EFF7
      E7000000000000000000000000000000000000000000D7A77700FFF7EF00FFF7
      EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7
      EF00FFF7EF00C788500000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BABABA00818181005E5D
      5C0078483600D4C1B300D4C1B300D4C2B300D4C1B300784836005A7375006BCA
      D600A4EAF300C3F0F5009EE5EE00E5FCFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EECCBA00CF9A6200CF9A
      6200CF9A6200CE945200CE945200CE945200CE945200CE935200CE935200CE93
      5D00CE935D00DDB4920000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C3AEA6007949
      37007949380079493800794938007A4A38007A4A3800875C4B00FAFCFD00DFFB
      FE00BBF6FE00C8F8FE00EFFDFF00FEFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000087B6DD0066A7DD003594DE0066A7
      DD0087B6DD0079C6820052AD5A0052AD5A006BB5730063B56B00E7C6AD00CE8C
      6300C6734200BD6B3100CE8C6300E7C6AD00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008C360800933707008A30040067220200000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000F7F7FF00A5A5E7004A4A
      C6004A4AC6004A4AC6004A4AC6004A4AC6004A4AC6004A4AC6004A4AC6004A4A
      C6004A4AC600A5A5E700F7F7FF00000000000000000000000000000000000000
      000000000000C6946B00C6946B00C6946B00C6946B00C6946B00000000000000
      0000000000000000000000000000000000003194DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C67B4A00E5CF
      B700EBD6C000F1DDC900F8E5D300C67B4A00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0071310900C26E3900E1BFA600DEBDA700CD916F00B66031007A25
      0000210A00000000000000000000FFFFFF00F7F7FF008484D6004A4ACE005252
      E7005252E7005252E7005252E7005252E7005252E7005252E7005252E7005252
      E7005252E7004A4ACE008484D600F7F7FF00000000000000000000000000C694
      6B00D6BD9C00D3C5B100FFF4ED00FFF4ED00FFF4ED00D3C5B100D6BD9C00C694
      6B00000000000000000000000000000000003594DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C6734200E5CF
      B700EBD6C000F1DDC900F8E5D300C6734200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000BB622700D8AF9800CEADA500D6BAB300CFACA300CFA59700D299
      7A00C37143008F350A004F18000000000000A5A5E7004A4ACE005A5AFF005A5A
      FF005A5AFF005A5AFF005A5AFF005A5AFF005A5AFF005A5AFF005A5AFF005A5A
      FF005A5AFF005A5AFF004A4ACE00A5A5E7000000000000000000C6946B00D6BD
      9C00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00D6BD
      9C00C6946B000000000000000000000000003995DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C67B4200E5CF
      B700EBD6C000F1DDC900F8E5D300C67B4200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00B3591B00D9A58200D6B6AD00DCC5BF00ECDFDC00E5D2CE00E1C8C300CFA5
      9900CA9B8E00D7A58B00CD835700A14315004A4AC6005252E7005A5AFF005A5A
      FF00B5B5FF005A5AFF005A5AFF005A5AFF005A5AFF005A5AFF005A5AFF00A5A5
      FF005A5AFF005A5AFF005252E7004A4AC6000000000000000000D6BD9C00FFF4
      ED00FFF4ED00F7E7DC00C6946B00C6946B00C6946B00E8CEBA00FFF4ED00FFF4
      ED00D6BD9C00000000000000000000000000399ADE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C6844200E5CF
      B700EBD6C000F1DDC900F8E5D300C6844200FFFFFF00FFFFFF00FFFFFF00B65E
      1C00DA9D6B00CFA59800E9D7D300E4D0CD00EDE1E100E3CDC800ECE0DF00EEE2
      E200E4CEC900D2AAA000D9AC9400AD4F1F004A4AC6005252E7005A5AFF009494
      FF000000000000000000B5B5FF005A5AFF005A5AFF00A5A5FF00000000000000
      0000A5A5FF005A5AFF005252E7004A4AC60000000000C6946B00D3C5B100FFF4
      ED00F7E7DC00C6946B00F0DBCC00FFF4ED00FFF4ED00C6946B00F0DBCC00FFF4
      ED00D3C5B100C6946B00000000000000000039A0DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C6844A00E5CF
      B700EBD6C000F1DDC900F8E5D300C6844A00FFFFFF00FFFFFF00FFFFFF00CC79
      3500D9B19E00E5CDC700E4CFC900F0E6E600EDE1E100EFE3E300DFC4BE00EDE1
      E100ECDFDF00DBBCB500D89C7600872900004A4AC6005252E7005A5AFF005A5A
      FF00000000000000000000000000B5B5FF00A5A5FF0000000000000000000000
      00005A5AFF005A5AFF005252E7004A4AC60000000000C6946B00FFF4ED00FFF4
      ED00E8CEBA00D6AF8F00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4
      ED00FFF4ED00C6946B00000000000000000039A6DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C6844A00E5CF
      B700EBD6C000F1DDC900F8E5D300C6844A00FFFFFF00FFFFFF00AD612000DB9C
      6500D2AA9F00F7F0EF00E1C9C300F3EAEA00EFE4E400ECDFDF00E9D7D300E6D3
      D000EDE1E000D1A69700C5713E00401300004A4AC6005252E7005A5AFF005A5A
      FF009494FF00000000000000000000000000000000000000000000000000A5A5
      FF005A5AFF005A5AFF005252E7004A4AC60000000000C6946B00FFF4ED00FFF4
      ED00E8CEBA00DFBFA600FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4
      ED00FFF4ED00C6946B00000000000000000039ABDE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900CE8C4A00E5CF
      B700EBD6C000F1DDC900F8E5D300CE8C4A00FFFFFF00FFFFFF00CA742700DCAE
      8E00E0C4BC00EAD8D400F1E6E400F5EEEE00F1E8E800EDE1E100F2E9E900DEC1
      BB00E3CDC800DAAA8C009D3D0C00000000004A4AC6005252E7005A5AFF005A5A
      FF005A5AFF009494FF0000000000000000000000000000000000A5A5FF005A5A
      FF005A5AFF005A5AFF005252E7004A4AC60000000000C6946B00FFF4ED00FFF4
      ED00E8CEBA00D6AF8F00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4
      ED00FFF4ED00C6946B00000000000000000039ADDE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900CE8C4A00E5CF
      B700EBD6C000F1DDC900F8E5D300CE8C4A00FFFFFF0000000000DE9A5600D4AB
      9E00EFE0DD00E3CBC500FAF7F700F7F1F100F3EBEB00EFE5E500E9D7D400EADA
      D800D6B2A900D48F6000752C0600FFFFFF004A4AC6005252E7005A5AFF005A5A
      FF005A5AFF00A5A5FF0000000000000000000000000000000000B5B5FF005A5A
      FF005A5AFF005A5AFF005252E7004A4AC60000000000C6946B00D3C5B100FFF4
      ED00FFF4ED00C6946B00F0DBCC00FFF4ED00F7E7DC00C6946B00F7E7DC00FFF4
      ED00D3C5B100C6946B0000000000000000003AADDE0034B9E50034B9E50063C6
      E70096DFF70052AD5A0052AD5A0052AD5A006BB5730094D39A00CE8C5200CE94
      5200CE945200D6AD7B00EFCEBD00CE8C5200FFFFFF00CA7C2D00E1AE8000D5B1
      A700F5EDEB00EAD8D300FCFBFB00F9F4F400F5EEEE00F2EAEA00E3CCC600EFE3
      E200D4A79300BA632B0000000000FFFFFF004A4AC6005252E7005A5AFF005A5A
      FF00A5A5FF00000000000000000000000000000000000000000000000000B5B5
      FF005A5AFF005A5AFF005252E7004A4AC6000000000000000000D6BD9C00FFF4
      ED00FFF4ED00F7E7DC00C6946B00C6946B00C6946B00F0DBCC00FFF4ED00FFF4
      ED00D6BD9C0000000000000000000000000040ADDE0034B9E50034B9E50063C6
      E70096DFF70052AD5A0052AD5A0052AD5A006BB5730094D39A00CE8C5200CE94
      5200CE945200D6AD7B00EFCEBD00CE8C5200FFFFFF00DE944300DAB39E00E6CF
      C900D0B1A800E8D5D000FEFEFE00FBF8F800F7F2F200F4ECEB00E4CDC800E0C6
      C000DAA47F0098420E0000000000FFFFFF004A4AC6005252E7005A5AFF005A5A
      FF00000000000000000000000000A5A5FF009494FF0000000000000000000000
      00005A5AFF005A5AFF005252E7004A4AC6000000000000000000C6946B00D6BD
      9C00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00D6BD
      9C00C6946B0000000000000000000000000042B1DE0034B9E50034B9E50063C6
      E70096DFF70052AD5A0052AD5A0052AD5A006BB5730094D39A00CE8C5200CE94
      5200CE945200D6AD7B00EFCEBD00CE8C5200C07D2F00E9B27400D3ACA000D6B8
      B0005B453F00CFA69B00F9F3F200FDFBFB00F9F5F500E7D2CD00F5EEED00D1A7
      9A00D48B530053250900FFFFFF00FFFFFF004A4AC6005252E7005A5AFF00A5A5
      FF000000000000000000A5A5FF005A5AFF005A5AFF009494FF00000000000000
      0000B5B5FF005A5AFF005252E7004A4AC600000000000000000000000000C694
      6B00D6BD9C00D3C5B100FFF4ED00FFF4ED00FFF4ED00D3C5B100D6BD9C00C694
      6B000000000000000000000000000000000040B5DE0034B9E50034B9E50063C6
      E70096DFF70052AD5A0052AD5A0052AD5A006BB5730094D39A00CE8C5200CE94
      5200CE945200D6AD7B00EFCEBD00CE8C5200DB8F3600DFB49200CB9E9200926F
      6600FFFFFF00C9998C00DCBDB500FEFEFE00FCFAFA00CEAEA500DCBFB700D79B
      7000B55F210000000000FFFFFF00FFFFFF004A4AC6005252E7005A5AFF005A5A
      FF00A5A5FF005A5AFF005A5AFF005A5AFF005A5AFF005A5AFF005A5AFF009494
      FF005A5AFF005A5AFF005252E7004A4AC6000000000000000000000000000000
      000000000000C6946B00C6946B00C6946B00C6946B00C6946B00000000000000
      0000000000000000000000000000000000003AB5DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900CE945A00E5CF
      B700EBD6C000F1DDC900F8E5D300CE945A00E2963D00C6947800BE9084000000
      0000FFFFFF00FFFFFF00C7978A00EDDEDA00F2E6E30088675E00FFFFFF00C363
      1D00B25A1900FFFFFF00FFFFFF00FFFFFF00ADADE7004A4ACE005A5AFF005A5A
      FF005A5AFF005A5AFF005A5AFF005A5AFF005A5AFF005A5AFF005A5AFF005A5A
      FF005A5AFF005A5AFF004A4ACE00A5A5E7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000049BDE20093D2FF00A9DBFF00BFE4
      FF00D6EEFF0068C67300B5E2BD00B5E2BD00CDEBD300E6F5E900D6A57300E5CF
      B700EBD6C000F1DDC900F8E5D300D6A57300DE90370000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00D1A99F00D6B9B10000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7FF008484D6004A4ACE005252
      E7005252E7005252E7005252E7005252E7005252E7005252E7005252E7005252
      E7005252E7004A4ACE008484D600F7F7FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005BC3E5005CC6E70063C6E70063C6
      E70063C6E700ACE2B2007BC6840052AD5A006BB5730063B56B00EFCEBD00D6AD
      7B00CE945200CE945200D6AD7B00EFCEBD00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C5968900C1938600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000F7F7FF00ADADE7004A4A
      C6004A4AC6004A4AC6004A4AC6004A4AC6004A4AC6004A4AC6004A4AC6004A4A
      C6004A4AC600ADADE700F7F7FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084B594002173
      4200186B31002173420084B59400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094B5E700215A
      C6000042BD00185AC60084A5DE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDB59400A59C6B00847B39007B7329007B7329007B732900BD7B
      2900D67B2900D67B2900D67B2900000000000000000000000000000000000000
      000000000000000000000000000000000000000000008CB59400298C520063BD
      8C0094D6B50063BD8C00298C520084AD94000000000000000000000000000000
      000000000000000000000000000000000000000000008CADE7002963CE002173
      E700007BEF000063DE00004ABD0084A5DE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000948C5200847B4200CED6BD00EFF7F700EFF7F700EFF7F700EFF7F700DEA5
      6300D67B2900D67B2900D67B290000000000C6A58C00C68C6B00C68C6300BD8C
      6300BD846300BD845A00B57B5A00B57B5A00B57B5A00216B390063BD8C0063BD
      84000000000063BD840063BD8C0021733900C6A58C00C68C6B00C68C6300BD8C
      6300BD846300BD845A00B57B5A00B57B5A00B57B5A00104AAD00639CF700187B
      FF000073FF000073EF00006BE700185AC6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000948C52008C7B
      4200D6C69C00E7BD8C00E7EFE700E7F7F700E7F7F700E7F7F700E7F7F700E7CE
      B500D67B2900D67B2900D67B290000000000CE946B0000000000000000000000
      00000000000000000000000000000000000000000000317B4A009CD6B5000000
      0000000000000000000094D6B500186B3100CE946B0000000000000000000000
      000000000000000000000000000000000000000000000042BD00ADCEFF000000
      00000000000000000000187BEF000042BD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009C844A00DEBD8C00E7AD
      7300DEAD6B00DEAD6B00DED6BD00DEF7F700DEF7EF00DEF7EF00DEF7F700E7F7
      F700DECEAD00DE9C5A00D67B290000000000CE946B000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004A8C630094D6B50094D6
      B5000000000063BD8C0063BD8C0021733900CE946B000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00215AC6008CB5F7004A94
      FF001073FF002184FF00428CEF00215AC6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEAD6B00DEA56B00DE9C
      6300DEA56300DEAD6B00DEC69C00DEEFEF00D6EFEF00D6EFEF00DEEFEF00DEF7
      F700E7F7F700EFF7F7007B73290000000000CE946B0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A5C6B50063AD840094D6
      B500BDE7D6006BBD8C00298C520084AD9400CE946B0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0094B5E7003973D6008CB5
      F700BDD6FF0073ADF700296BCE0094ADE7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEAD6B00D69C6300D694
      5A00D69C6300DEAD6B00DEB58400D6EFEF00D6EFEF00D6EFEF00D6EFEF00DEF7
      EF00E7F7F700EFF7F7007B73290000000000D69C730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00ADCEB500639C
      73004A8C63004A8C6300737B520000000000D69C730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0094ADDE002963
      C6000042BD00215AC6005A638400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEAD6B00D69C6300D69C
      5A00DE9C6300DEB58400EFE7D600EFE7DE00D6EFEF00D6EFEF00D6EFEF00DEF7
      F700E7F7F700EFF7F7007B73290000000000D69C730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFF700FFF7
      F700FFF7F70000000000B57B5A0000000000D69C730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFF700FFF7
      F700FFF7F70000000000B57B5A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEAD6B00DEA56B00DEA5
      6B00DEBD8C00F7E7CE00FFE7CE00FFE7CE00EFE7D600D6EFEF00DEEFEF00DEF7
      F700E7F7F700EFF7F7008C7B390000000000D6A5730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFF700FFF7F700FFF7F700FFF7
      EF00FFF7EF0000000000B57B5A0000000000D6A5730000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFF700FFF7F700FFF7F700FFF7
      EF00FFF7EF0000000000B57B5A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEAD6B00DEAD6B00E7C6
      9400F7E7CE00FFE7CE00FFE7CE00FFE7CE00FFE7CE00DED6BD00DEB58400E7CE
      B500E7E7DE00C6C6AD00ADA57B0000000000DEA57B0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFF700FFFFF700FFF7F700FFF7F700FFF7EF00F7F7EF00F7F7
      EF00F7EFEF0000000000B5845A0000000000DEA57B0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFF700FFFFF700FFF7F700FFF7F700FFF7EF00F7F7EF00F7F7
      EF00F7EFEF0000000000B5845A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEAD6B00EFCEA500FFE7
      CE00FFE7CE00FFE7CE00FFE7CE00FFE7CE00E7DEC600E7AD7300E7A57300E7A5
      7300E7BD940073631800BDB5940000000000DEA57B0000000000FFFFFF00FFFF
      FF00FFFFF700FFF7F700FFF7F700FFF7F700F7F7EF00F7EFEF00F7EFE700F7EF
      E700F7E7DE0000000000BD84630000000000DEA57B0000000000FFFFFF00FFFF
      FF00FFFFF700FFF7F700FFF7F700FFF7F700F7F7EF00F7EFEF00F7EFE700F7EF
      E700F7E7DE0000000000BD846300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFD6B500FFE7CE00FFE7
      CE00FFE7CE00FFE7CE00FFE7CE00EFE7CE00E7AD7300DEA56B00E7A57300E7AD
      7300AD9C6B00BDB594000000000000000000DEA57B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BD84630000000000DEA57B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BD846300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFE7CE00FFE7CE00FFE7
      CE00FFE7CE00FFE7CE00F7E7CE00DEB57B00DEA56B00DEA56B00E7A56B00DEBD
      94008C844A00000000000000000000000000DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00C68C630000000000DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00C68C6300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFE7CE00FFE7CE00FFE7
      CE00FFE7CE00FFE7CE00E7B58C00DEA56B00DEA56B00DEA56B00E7B584007B73
      2900BDB59400000000000000000000000000DEAD8400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400C694730000000000DEAD8400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400C6947300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFE7CE00FFE7CE00FFE7
      CE00FFE7CE00E7C6A500E7A57300E7A57300DEA56B00E7A57300BDA57B00B5AD
      840000000000000000000000000000000000DEC6B500DEB59400DEA57B00DEA5
      7B00DEA57B00DEA57B00D6A57300D69C7300D69C7300CE9C7300CE9C7300CE94
      6B00CE946B00C69C8400DEC6B50000000000DEC6B500DEB59400DEA57B00DEA5
      7B00DEA57B00DEA57B00D6A57300D69C7300D69C7300CE9C7300CE9C7300CE94
      6B00CE946B00C69C8400DEC6B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFE7CE00FFE7CE00FFE7
      CE00EFD6B500E7A57300E7A57300E7A57300E7B58C00DEBD94008C7B42000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DDDD
      DD00CCCCCC00CCCCCC00DDDDDD000000000000000000DDDDDD00CCCCCC00CCCC
      CC00DDDDDD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DCDCDC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00C39A
      6700BF7E2F00BF7E2E00C4996700CCCCCC00CCCCCC00C39A6700BF7E2F00BF7E
      2F00C39A6700CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00DCDC
      DC00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C1976300BF7D2E00C07D2B00C17C2A00C17C2A00C17D2B00C17C2A00C37B
      25007BA0C5007CA0C300B0844C00C17B2800C17C2A00C37B25007BA0C5007BA0
      C500C37B2500C17C2A00C07C2A00C07C2A00C07C2A00C07C2B00BF7D2E00C197
      6300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C47C2D00739CC4007499BA007498B8007599B9007699B9007599B9007498
      B6008DA2B5008EA2B5007B9AB6007297B7007599B9007498B6008DA2B6008EA2
      B6007498B6007298B8006F96B7006D94B6006D94B6007096B800729BC300C47C
      2D00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCCC
      CC00D2782600A5C5E300C8EAFF00B6DBF400A4CFEA0092C1DE0098C0D700ADCC
      DD00D5E6EC0094B9D300A8C7DB00BAD2E20098C0D700ADCCDD00D5E6EC0094B9
      D300A5C6DC00BAD2E200EEF9FF000000000000000000F5FFFF00AAC7E500D178
      2600CCCCCC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0084848400FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000CCCCCC00008C
      4A0040813500ABC0DE00C8E5FB00B4D6EE00A3CBE40091C0DC00A0C9E100C1E0
      EE00E7F9FB0090BFDA00B1D2E700CCE2EF00A0C9E100C1E0EE00E7F9FB0090BF
      DA00B1D2E700CCE2EF00E6F1F80000000000FAFEFF00F2FCFF00AEC1DE003E81
      3500008C4A00CCCCCC0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0084848400FFFFFF00C6C6C6008484840000FFFF00FFFFFF000000
      00000000000000000000000000000000000000000000CCCCCC00008846004ED4
      A80000853D00BEC3E500D5E9FF00BDD9F500A5CBE60091BFDB009FC7DF00C0DF
      EC00E6F7F9008FBDD900AFD0E500CAE0ED009FC7DF00C0DFEC00E6F7F9008FBD
      D900AFD0E500CAE0ED00E5F0F700000000000000000000000000C2C5E4000084
      3D004ED4A80000884600CCCCCC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0084848400FFFFFF00C6C6C6008484840000FFFF00FFFFFF0000FFFF008484
      840000000000000000000000000000000000CCCCCC000087440062D3AE0011DC
      A90000B87B00008138000081340034A27C00ACCEEC0092BFDC009FC7DF00BFDE
      EC00E5F7F9008FBDD900AFD0E500CAE0ED009FC7DF00BFDEEC00E5F7F9008FBD
      D900AFD0E500CAE0ED00E6F1F800000000004AAF8300007D32000081380000B8
      7B0011DCA90062D3AE0000874400CCCCCC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008484
      8400FFFFFF00C6C6C6008484840000FFFF00FFFFFF0000FFFF0084848400C6C6
      C600C6C6C600000000000000000000000000008A480072D7B90012D3A70000CC
      9A0000CD9B0000CF9C005AE8C80000823300B1CFF00093C0DD009FC7DF00BFDE
      EC00E5F7F9008FBDD900AFD0E500CAE0ED009FC7DF00BFDEEC00E5F7F9008FBD
      D900AFD0E500CAE0ED00E7F1F90000000000007B300058E6C70000CF9C0000CD
      9B0000CC9A0012D3A70072D7B900008A48000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00C6C6C6008484840000FFFF00FFFFFF0000FFFF0084848400C6C6C600C6C6
      C600C6C6C600000000000000000000000000008A470083E5D20000C59B0000C4
      990060DDC4005BDEC5006DE5D00000823400B2CFF00093C0DD009FC7DF00BFDE
      EC00E5F7F9008FBDD900AFD0E500CAE0ED009FC7DF00BFDEEC00E5F7F9008FBD
      D900AFD0E500CAE0ED00E7F1F90000000000007C31006AE4D0005BDEC50060DD
      C40000C4990000C59B0083E5D200008A47000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF0084848400C6C6C600C6C6C600C6C6
      C60000000000000000000000000000000000000000001B975C0095E5D60000BE
      9B000DBB950007985B0002995A0009915600AECEED0092BFDC009FC7DF00BFDE
      EC00E5F7F9008FBDD900AFD0E500CAE0ED009FC7DF00BFDEEC00E5F7F9008FBD
      D900AFD0E500CAE0ED00E6F1F800000000000E9458000096580005985B000DBB
      950000BE9B0095E5D6001B975C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0084848400C6C6C600C6C6C600C6C6C6008484
      84008400000000000000000000000000000000000000000000001E995E009EE7
      E00000874000C4CFE700C9E5FD00B0D3EA00A7CCE70091BFDB009FC7DF00BFDE
      EC00E5F7F9008FBDD900AFD0E500CAE0ED009FC7DF00BFDEEC00E5F7F9008FBD
      D900AFD0E500CAE0ED00E5F0F70000000000F4F9FD00F3FCFF00C6D0E9000087
      40009EE7E0001E995E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600C6C6C600C6C6C600000000008400
      0000840000008400000000000000000000000000000000000000000000001B9D
      640010833900C4CFE700C9E5FD00B5D6EF00A3CAE40091BFDB009FC7DF00BFDE
      EC00E5F7F9008FBDD900AFD0E500CAE0ED009FC7DF00BFDEEC00E5F7F9008FBD
      D900AFD0E500CAE0ED00E4F0F70000000000FBFDFF00EFFCFF00C0D4EB000F83
      39001B9D64000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      0000C5772500BDD3EB00C4E5FC00B2D6EE00A2CBE40090BFDB009FC7E000C0DF
      ED00E6F8FA008FBDD900B0D0E500CBE1EE009FC7E000C0DFED00E6F8FA008FBD
      D900B0D0E500CBE1EE00E6F1F80000000000FAFFFF00EFFCFF00C0D4EB00C477
      2500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000000000000000000000000000000000000000
      0000CF853C00BEC1C100B3D0E400ABC5D800A3C6DD0094BDD7009FCAE200C1E2
      F000E3F6F90092BFDB00B1D3E800CEE5F2009FCAE200C1E2F000E3F6F90092BF
      DB00B1D3E800CEE5F200DCE8EF00E5EAEE00CDD8E200C7DAEA00C1C3C100CF84
      3C00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000EEF1F400E1E5EA00BFC9D100A7B5C100A5B4
      C000BEC9D200B8C4CD00A5B4C100A4B3C000A7B5C100A5B4C000BEC9D200B8C4
      CD00A5B4C100A4B3C000C3CDD500DEE4E900EDF1F40000000000000000000000
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
      00000000000000000000000000000000000000000000000000004A4239000000
      00005A524A000000000000000000000000000000000000000000000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFEFEF00294AA500315A
      AD002142AD00DEDEDE00DEDEDE00D6D6D600D6D6D600D6D6D600D6D6D600D6D6
      D600CECECE00CECECE00C6C6C600CECECE000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006B635A000000
      00006B635A00000000000000000000000000000000008484840084848400CED6
      D600000000008400000000000000000000008400000084000000840000008400
      000084000000840000000000000000000000C6A58C00C68C6B00C68C6300BD8C
      6300BD846300BD845A00B57B5A00B57B5A00B57B5A00AD7B5200AD735200AD73
      5200AD735200AD735200C6A58C000000000000000000CECECE00C6C6CE00C6C6
      CE002142AD00FFFFFF00FFFFFF00FFFFFF00F7F7F700EFEFEF00D6D6D600EFEF
      EF00B1998300B1998300B1998300CECECE0000000000A57B5A00000000000000
      0000A57B5A00A57B5A00A57B5A00A57B5A000000000084847B00393129004A42
      390039312900393129005A524A00000000000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      000000000000000000000000000000000000CE946B0000000000000000000000
      00000000000000000000DEA57B00000000000000000000000000000000000000
      00000000000000000000AD7352000000000000000000E7E7E700637BB500638C
      BD002142AD00FFFFFF00FFFFFF00F7F7F700F7F7F700EFEFEF00F7F7F700CECE
      CE00E7E7E700FFFFFF00FFFFFF00CECECE0000000000A57B5A00A57B5A00A57B
      5A00000000000000000000000000A57B5A00A57B5A0000000000000000009494
      8C000000000084847B0000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CE946B0000000000FF8C29009494
      94008484840000000000DEA57B0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000AD7352000000000000000000CECECE00C6C6CE00C6C6
      CE00214AAD00FFFFFF00FFFFFF00FFFFFF00F7F7F700F7F7F700FFFFFF00F7F7
      F700CECECE00E7E7E700FFFFFF00CECECE0000000000A57B5A00A57B5A000000
      000000000000000000000000000000000000A57B5A006B5A4A005A524A002921
      18005A524A00292118005A524A00000000000000000084848400000000000000
      000000000000000000000000000000000000CED6D60000000000CED6D6000000
      000000000000000000000000000000000000CE946B0000000000000000000000
      00000000000000000000DEA57B0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      F700FFFFF70000000000AD7352000000000000000000E7E7E700637BB5006394
      C600214AAD00FFFFFF00FFFFFF00FFFFFF00F7F7F700F7F7F700FFFFFF00FFFF
      FF00F7F7F700CECECE00EFEFEF00CECECE0000000000A57B5A00000000000000
      000000000000000000000000000000000000A57B5A00A57B5A00000000005A52
      4A00000000005A524A0000000000000000000000000084848400000000000000
      0000000000008484840084848400CED6D6000000000084000000000000000000
      000084000000840000008400000084000000D69C730000000000FF9C39009C9C
      9C009C9C9C0000000000DEA57B0000000000FFFFFF00FFFFFF00FFFFF700FFFF
      F700FFFFF70000000000B57B5A000000000000000000CECECE00C6C6CE00C6C6
      CE00214AB500FFFFFF00FFFFFF00FFFFFF00F7F7F700F7F7F700FFFFFF00FFFF
      FF00FFFFFF00F7F7F700D6D6D600CECECE0000000000A57B5A00000000000000
      0000000000000000000000000000A57B5A00A57B5A00A57B5A00000000007373
      6B000000000073736B0000000000000000000000000084848400000000000000
      000000000000848484000000000000000000CED6D60000000000CED6D6000000
      000000000000000000000000000000000000D69C730000000000000000000000
      00000000000000000000DEA57B0000000000FFFFF700FFFFF700FFFFF700FFF7
      F700FFF7F70000000000B57B5A000000000000000000E7E7E700637BB5006394
      C6002152B500FFFFFF00FFFFFF00E79C7300DE9C7300DE9C6B00DE9C6B00DE9C
      6B00D6946B00EFEFEF00EFEFEF00CECECE000000000000000000000000000000
      00000000000000000000A57B5A00A57B5A00A57B5A0000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      000000000000CED6D60000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6A5730000000000FFBD6B00ADAD
      AD00ADADAD0000000000DEA57B0000000000FFFFF700FFF7F700FFF7F700FFF7
      EF00FFF7EF0000000000B57B5A000000000000000000CECECE00C6C6CE00C6C6
      CE002152B500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7F700F7F7
      F700F7F7F700F7F7F700EFEFEF00CECECE000000000000000000000000000000
      0000A57B5A00A57B5A00A57B5A00A57B5A000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      000000000000000000000000000000000000DEA57B0000000000000000000000
      00000000000000000000DEA57B0000000000FFF7F700FFF7EF00F7F7EF00F7F7
      EF00F7EFEF0000000000B5845A000000000000000000E7E7E7006384B5006394
      C6002152B500FFFFFF00FFFFFF00E7A57300E7A57300E7A57300DE9C7300DE9C
      7300DE9C6B00F7F7F700F7F7F700CECECE000000000000000000A57B5A00A57B
      5A00A57B5A00A57B5A0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840084848400CED6
      D600000000008400000000000000000000008400000084000000840000008400
      000084000000000000000000000000000000DEA57B0000000000FFBD6B00BDBD
      BD00B5B5B50000000000DEA57B0000000000F7F7EF00F7EFEF00F7EFE700F7EF
      E700F7E7DE0000000000BD8463000000000000000000CECECE00C6C6CE00C6C6
      CE002152B500FFFFFF00FFFFFF00E7A57B00EFC6A500EFC6A500EFBDA500EFBD
      A500DE9C7300F7F7F700F7F7F700CECECE0000000000A57B5A00A57B5A00A57B
      5A0000000000000000000000000000000000A57B5A0000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      000000000000000000000000000000000000DEA57B0000000000000000000000
      00000000000000000000DEA57B00000000000000000000000000000000000000
      00000000000000000000BD8463000000000000000000E7E7E7006384B500639C
      C600215AB500FFFFFF00FFFFFF00E7A57B00E7A57B00E7A57300E7A57300E7A5
      7300E7A57300F7F7F700FFFFFF00CECECE0000000000A57B5A00A57B5A000000
      000000000000000000000000000000000000A57B5A0000000000000000000000
      00000000000000000000000000000000000000000000CED6D600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA57B00DEA5
      7B00DEA57B00DEA57B00C68C63000000000000000000CECECE00C6C6CE00C6C6
      CE00215AB500F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700F7F7F700F7F7F700FFFFFF00CECECE0000000000A57B5A00A57B5A000000
      0000000000000000000000000000A57B5A00A57B5A0000000000000000000000
      000000000000000000000000000000000000E7E7E70000000000CED6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEAD8400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD9400EFBD
      9400EFBD9400EFBD9400C69473000000000000000000E7E7E7006384BD00639C
      C600215ABD00F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700F7F7F700F7F7F700FFFFFF00CECECE000000000000000000A57B5A00A57B
      5A000000000000000000A57B5A00A57B5A00A57B5A0000000000000000000000
      0000000000000000000000000000000000006363630000FFFF00000000000000
      0000840000008400000084000000840000008400000000000000000000000000
      000000000000000000000000000000000000DEC6B500DEB59400DEA57B00DEA5
      7B00DEA57B00DEA57B00D6A57300D69C7300D69C7300CE9C7300CE9C7300CE94
      6B00CE946B00C69C8400DEC6B5000000000000000000CECECE00C6C6CE00C6C6
      CE00215ABD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CECECE00000000000000000000000000A57B
      5A00A57B5A00A57B5A000000000000000000A57B5A0000000000000000000000
      000000000000000000000000000000000000E7E7E70000000000CED6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000638CC6004A7B
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
      000000000000ADADAD00636B6B00636363000000000000000000000000000000
      000000000000ADA5F70000000000000000000000000000000000000000000000
      00000000000000000000CE845200FFF7EF00FFEFDE00FFEFDE00FFEFDE00FFE7
      D600FFE7D600FFE7CE00FFF7EF00CE84520000000000C6844200F7F7E700FFE7
      D600FFE7D600EFCEB500F7DEC600FFE7D600FFE7CE00FFE7CE00F7DEC600DEB5
      9C008C9CAD00DEE7EF00C67339000000000000000000F7F7EF00CE9C7B00EFDE
      CE00E7CEBD00C6946B00BD8C6300CEB59400CEB59400B58C5A00B5846300DEC6
      AD00E7D6C600B5845A00F7EFE700000000000000000000000000000000000000
      0000737B7B006B6B6B0073737300636363000000000000000000000000000000
      00009C94F7003931EF005242E70000000000D69C7B00D6946B00CE845A00D68C
      6300D68C6300D68C6300CE845200FFF7F700FFEFDE00FFEFDE00FFEFDE00FFE7
      D600FFE7D600FFE7CE00FFF7F700CE84520000000000C6844A00FFF7EF00FFE7
      D600FFE7D600F7D6BD00FFE7D600F7DEC600F7DEBD00F7D6BD00F7DEC600F7DE
      BD00C6AD9C00FFFFF700C67B42000000000000000000E7CEBD00E7CEBD00EFD6
      C600C69C7300BD946300BD946300F7F7EF00F7F7EF00B58C5A00B58C5A00B58C
      6300E7CEBD00DEBDA500DEBDA50000000000737373006B7373006B6B6B006B6B
      6B006B6B6B00525252005A63630063636300000000000000000000000000B5AD
      F700000000003929E7003931EF00A59CF700D6946B00FFF7EF00FFF7EF00FFF7
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
      F70000000000635AE700635AEF00B5B5F700D6946B00FFFFF700FFEFDE00FFEF
      DE00FFEFD600FFE7D600E7BD9400FFFFFF00FFF7EF00FFF7EF00FFF7EF00FFEF
      E700FFF7E700EFBD8C00DEAD8C000000000000000000CE8C5200FFF7F700FFE7
      CE00FFE7D600FFE7CE00FFE7CE00FFE7CE00FFDEC600F7DEBD00F7EFDE00F7F7
      EF00FFF7F700F7EFEF00C6844A000000000000000000FFFFF700F7D6BD00F7EF
      DE00EFDEC600D6AD8400DEBD9C00F7EFE700F7EFE700E7CEAD00D6A57B00E7CE
      BD00F7E7D600DEBD9C00FFF7F700000000000000000000000000000000000000
      00009C9C9C009C9C9C00ADADAD007B7B7B000000000000000000000000000000
      0000BDB5F7006B6BEF00847BE70000000000D6946B00FFFFF700FFEFDE00FFE7
      D600FFE7D600FFE7CE00EFC69C00E7BD9400E7BD9400E7BD9400D6A57300D6A5
      7300D6A57300E7BDA500000000000000000000000000CE8C5200FFF7F700FFE7
      CE00FFE7CE00FFE7CE00FFE7CE00FFE7CE00FFDEC600F7D6BD00FFFFFF00FFE7
      CE00FFE7CE00E7B58400D6AD8400000000000000000000000000FFF7EF00F7D6
      BD00F7EFDE00EFDED600E7C6A500DEAD8C00D6AD8400DEBD9C00EFD6C600F7E7
      DE00E7C6A500F7EFDE0000000000000000000000000000000000000000000000
      000000000000C6C6C6008C8C8C00848484000000000000000000000000000000
      000000000000CEC6F7000000000000000000D6946B00FFF7F700FFE7D600FFE7
      D600FFE7CE00FFDEC600F7EFE700FFF7EF00FFFFF700D6A57B00000000000000
      00000000000000000000000000000000000000000000CE945A00FFF7F700FFE7
      C600FFE7CE00FFE7CE00FFE7CE00FFDEC600FFDEC600F7D6BD00FFFFFF00F7DE
      B500E7B57B00DE946B000000000000000000000000000000000000000000FFF7
      EF00F7DEC600FFEFDE00F7EFDE00F7E7DE00F7E7DE00F7E7DE00F7E7D600EFCE
      B500FFEFE7000000000000000000000000000000000000000000000000000000
      00000000000000000000D6D6D600949494000000000000000000000000000000
      000000000000000000000000000000000000D69C6B00FFF7EF00FFE7CE00FFE7
      CE00FFE7CE00F7DEBD00FFFFF700FFE7CE00EFCEA500E7BDA500000000000000
      00000000000000000000000000000000000000000000D6A57300FFF7EF00FFF7
      EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00F7F7EF00F7E7D600E7B5
      7B00DE9C6B000000000000000000000000000000000000000000000000000000
      0000FFFFF700FFEFE700FFDECE00F7DEC600F7D6BD00F7DEC600FFEFDE00FFFF
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D69C7300EFEAE600FFF7EF00FFF7
      EF00FFF7EF00FFF7E700FFF7EF00EFC69400E7B5940000000000000000000000
      00000000000000000000000000000000000000000000EFCEBD00D6AD7B00CE94
      5A00CE945200CE945200CE945200CE945200CE945200CE8C5200CE9C6B00DEB5
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEA58400D69C7300D6946B00D69C
      6B00D69C6B00D69C6B00D69C7300E7C6AD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000318CDE00318CDE00318C
      DE00318CDE00318CDE00318CDE00318CDE00318CDE00318CDE00318CDE00318C
      DE00318CDE0000000000000000000000000000000000CE947300BD734200B56B
      3100B56B3100B5633100B5633100B5633100AD633100AD633100AD633100AD63
      3100AD633100A5633100AD6B3900BD846300000000000000000000000000CE94
      6300CE9C6300CE946300CE946300CE946300CE946300CE946300CE946300CE9C
      6300CE9463000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003194DE00DEF7FF009CE7F70094E7
      F70094DEF7008CDEF7008CDEF70084DEF70084DEF7007BD6F70073D6F70073D6
      F700C6EFFF003194DE000000000000000000C67B4A00EFC6AD00EFC6AD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CE9C7B00C69C7B00AD6B4200A5A5A5007B7B7B005A5A5A00C694
      6300FFF7F700FFF7EF00FFF7EF00FFF7EF00F7EFE700F7EFE700F7EFDE00FFFF
      F700C6946300212121004A4A4A00949494000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003994DE00EFFFFF0094E7FF008CE7
      FF008CE7FF0084E7F7007BDEF70073DEF70063DEF7005ADEF7004AD6F70042D6
      F700CEF7FF003194DE000000000000000000BD6B3900EFCEB500E7A57B00FFFF
      F70063C68C0063C68C0063C68C0063C68C0063C68C0063C68C0063C68C0063C6
      8C00FFFFF700CE8C6300CE9C7B00A56331006B6B6B00A5A5A500B5B5B5008484
      8400ADADAD00C6C6BD00C6C6BD00C6C6BD00C6C6BD00C6C6BD00C6C6BD00ADAD
      AD0029292900B5B5B5009C9C9C00212121000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      840000848400000000000000000000000000399CDE00F7FFFF0094E7FF0094E7
      FF0094E7FF008CE7FF0084E7F7007BE7F70073DEF7006BDEF7005ADEF7004AD6
      F700CEF7FF003194DE000000000000000000BD6B3900EFCEB500E7A57B00FFFF
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
      0000000000000000000000000000840000000000000000000000000000000000
      00000000000000000000E7BD9400FFF7F700FFE7D600FFE7D600FFE7CE00FFDE
      C600F7D6BD00F7D6AD00FFEFE700CE845A00BD6B3900F7DECE00E7AD7B00FFF7
      EF00FFF7EF00CE8C6300FFF7EF00FFFFF700FFFFFF00FFF7EF00FFEFDE00F7E7
      DE00F7E7DE00E7A57B00E7C6AD00B56B3100000000000000000000000000C68C
      4A00FFF7F700FFE7D600FFE7D600FFE7CE00FFE7CE00F7D6BD00F7D6B500FFF7
      F700C6844A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000000000000000000000000
      00000000000000000000E7BD9400FFF7F700FFE7CE00FFE7CE00FFDECE00F7DE
      BD00F7EFDE00FFF7EF00FFFFF700CE845200C6734200F7DED600EFAD7B00FFF7
      F700FFF7F700CE8C6300FFF7EF00FFF7EF00FFFFF700FFFFF700FFF7EF00FFEF
      DE00F7E7DE00E7A57B00EFD6C600B56B3100000000000000000000000000CE8C
      5200FFF7F700FFE7CE00FFE7CE00FFE7CE00FFDEC600F7EFDE00F7F7EF00F7EF
      EF00C6844A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000000000000084000000000000000000000000000000000000000000
      00000000000000000000E7BD9400FFF7EF00FFDEC600FFE7C600FFDEC600F7D6
      B500FFFFF700FFE7C600EFC69400DEB59400C6845200F7DED600EFAD8400FFFF
      F700FFFFF700CE8C6300FFF7EF00FFF7EF00FFF7F700FFFFFF00FFF7F700FFEF
      E700FFE7DE00EFD6BD00EFD6BD00BD734200000000000000000000000000CE8C
      5200FFF7F700FFE7CE00FFE7CE00FFE7CE00FFDEC600FFFFFF00FFE7CE00E7B5
      8400D6AD84000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000000000000000000000000000000000000000000000000
      00000000000000000000E7BD9400FFFFFF00FFF7EF00FFF7EF00FFF7EF00FFEF
      E700FFF7E700EFBD8C00DEAD8C0000000000D6A58400F7E7D600F7E7D600FFFF
      FF00FFFFF700FFFFF700FFF7F700FFF7EF00FFF7EF00FFFFF700FFFFF700FFF7
      EF00FFEFDE00EFD6BD00CE946B00E7C6B500000000000000000000000000C68C
      4A00F7F7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00F7E7D600E7B57B00DE94
      6B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      00000000000000000000EFC69C00E7BD9400E7BD9400E7BD9400D6A57300D6A5
      7300D6A57300E7BDA5000000000000000000E7BDA500DEAD8C00CE8C5A00C673
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
      000000000000DE9C6B00D6844A00E7AD7B00DE9C6300DEA57300C65210000000
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
      DE00318CDE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003194DE00DEF7FF009CE7F70094E7
      F70094DEF7008CDEF7008CDEF70084DEF70084DEF7007BD6F70073D6F70073D6
      F700C6EFFF003194DE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B5B5B500B5B5
      B500B5B5B5000000000029292900212121001818180010101000101010000808
      0800000000000000000000000000000000000000000039393100393131003129
      2900292921002121210021181800000000003131310008080800000000000000
      0000000000000000000000000000000000003994DE00EFFFFF0094E7FF008CE7
      FF008CE7FF0084E7F7007BDEF70073DEF70063DEF7005ADEF7004AD6F70042D6
      F700CEF7FF003194DE000000000000000000C69C8C00C68C6300BD845A00A56B
      4A00A56B4A009C634A009C634200A5735A00BD7B5200B5735200B57352009C5A
      4200945A4200945A4200BD948400000000000000000000000000B5B5B500E7E7
      E700B5B5B5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000042423900847B7300C6BD
      AD007B736B007B736B0031312900000000004A4A4200948C7B00BDADA5007B73
      6B007B736B00000000000000000000000000399CDE00F7FFFF0094E7FF0094E7
      FF0094E7FF008CE7FF0084E7F7007BE7F70073DEF7006BDEF7005ADEF7004AD6
      F700CEF7FF003194DE000000000000000000CE946B0000000000000000000000
      0000000000000000000000000000C6845A000000000000000000000000000000
      00000000000000000000945A4200000000000000000000000000B5B5B500E7E7
      E700B5B5B5000000000039393900313131002929290029292900212121001818
      180010101000080808009C9C9C0000000000000000004A424200847B6B00CEC6
      BD007B6B63007B736300313129000000000029292100948C7B00C6BDAD007B6B
      63007B736B0022222200000000000000000039A5DE00F7FFFF0094E7FF0094E7
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
      00000000000000000000000000000000000000000000635A5200423939005A52
      4A00393931003129290039313100D6D6D6005A5A5A0018181000212121001810
      10000808080010101000000000000000000042ADDE00F7FFFF0094DEF70094DE
      F70063BDEF003194DE003194DE003194DE003194DE003194DE003194DE003194
      DE003194DE003194DE00FFF7EF00CE845200DEAD840000000000000000000000
      0000000000000000000000000000D69C73000000000000000000000000000000
      00000000000000000000AD6B4A00000000000000000000000000BDBDBD00EFEF
      EF00BDBDBD0000000000636363005A5A5A00525252004A4A4A00424242003939
      39003131310029292900A5A5A50000000000000000009C948400B5A594007B73
      6B007B736B00736B63006B635A0029292100524A4A0084736B007B736B00736B
      630073635A003B3B3B00000000000000000042B5DE00F7FFFF008CE7FF0094DE
      F7009CE7F700ADE7F700CE845200FFF7F700FFEFDE00FFEFDE00FFEFDE00FFE7
      D600FFE7D600FFE7CE00FFF7F700CE845200DEAD840000000000000000000000
      0000000000000000000000000000D6A57B000000000000000000000000000000
      00000000000000000000AD735200000000000000000000000000BDBDBD00EFEF
      EF00BDBDBD000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BDADA500BDADA5008473
      6B0084736B00AD947B00BDA59400BDA59400B59484009C8C7B00846B5A007363
      5200948C7B003A3A3A00000000000000000039B5DE00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFF7F700FFE7D600FFE7D600FFE7D600FFE7
      D600FFE7CE00FFDEC600FFF7EF00CE845200DEB58C0000000000000000000000
      0000000000000000000000000000DEA57B000000000000000000000000000000
      00000000000000000000B5735200000000000000000000000000BDBDBD00F7F7
      F700BDBDBD00000000006B6B6B006B6B6B00636363005A5A5A00525252004A4A
      4A000000000000000000000000000000000000000000DEDED6009C8C84009C94
      8400847B7300524A4A00524A420084736B006B635A00846B5A00A5947B009484
      7300524A4A008B8B8B0000000000000000005AC6E70063C6E70063C6E70063C6
      E70063C6E70063C6E700E7BD9400FFF7F700FFE7D600FFE7D600FFE7D600FFE7
      CE00FFDEC600F7DEBD00FFF7E700CE845A00E7B58C0000000000000000000000
      0000000000000000000000000000DEAD84000000000000000000000000000000
      00000000000000000000B57B5A00000000000000000000000000BDBDBD00F7F7
      F700BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000736B6300A594
      8C00948C7B009C94840039393100000000004A4242007B736B00847B73003939
      310084847B000000000000000000000000000000000000000000000000000000
      00000000000000000000E7BD9400FFF7F700FFE7D600FFE7D600FFE7CE00FFDE
      C600F7D6BD00F7D6AD00FFEFE700CE845A00E7B5940000000000000000000000
      0000000000000000000000000000DEAD84000000000000000000000000000000
      00000000000000000000BD846300000000000000000000000000BDBDBD00BDBD
      BD00BDBDBD00000000007373730073737300737373006B6B6B00636363006363
      63005A5A5A0052525200B5B5B500000000000000000000000000000000000000
      00009C948400C6BDAD00635A5200000000007B736B00AD9C8C00A59C94000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E7BD9400FFF7F700FFE7CE00FFE7CE00FFDECE00F7DE
      BD00F7EFDE00FFF7EF00FFFFF700CE845200E7BD9400E7BD9400E7BD9400E7B5
      9400E7B59400E7B58C00E7B58C00E7B58C00E7B58C00DEAD8400DEAD8400DEAD
      8400DEAD8400DEAD7B00C68C6300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A59C9400BDB5A5009C94840000000000ADA594009C9484007B736B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E7BD9400FFF7EF00FFDEC600FFE7C600FFDEC600F7D6
      B500FFFFF700FFE7C600EFC69400DEB59400E7BDA500EFCEAD00EFC6AD00EFC6
      AD00EFC6A500EFC6A500EFC6A500E7BD9400EFC6A500EFC69C00EFC69C00EFBD
      9C00EFBD9C00EFBD9C00C6947300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E7BD9400FFFFFF00FFF7EF00FFF7EF00FFF7EF00FFEF
      E700FFF7E700EFBD8C00DEAD8C0000000000E7CEBD00E7C6AD00E7BD9400DEAD
      8C00D6AD8400D6AD8400D6B59400D6AD9400E7C6A500E7B58C00E7B58C00D6A5
      7B00CE9C7300CEA58C00DEC6BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EFC69C00E7BD9400E7BD9400E7BD9400D6A57300D6A5
      7300D6A57300E7BDA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000C00000000100010000000000000600000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF81FF81FF81FFFFFF00FF00FF00FF
      C7FF007F007F007F83FF183F183F183F99FF1C3F103F103F90FF0E3F003F003F
      C87F070700070007E43F838380038003C21FC1C1C001C001E10FE0E0E000E000
      F027FC60FC00FC00F867FC18FC18FC18FCE7FC18FC18FC18FE0FFE00FE00FE00
      FF1FFF00FF00FF00FFFFFF83FF83FF83FFFF8003FFFF8001F00F8001F81FBFFD
      F00F8000F007A005F00F8000E203A00580018000C013A00580018001C091A005
      80018003D199A0058001800391F9A0058001800391F9A00580018003C091A001
      80018003C813A00080018003C403A000F00F8003E187A000F00F8003F00FA000
      F00F8003FFFF8000FFFF8003FFFFC000FFFF000000008001F83F000000000000
      E00F000000000000C007000000000000C007000000000C308003000000000E70
      80030000000007E080030000000003C080030000000003C080030000000007E0
      C007000000000E70C007000000000C30E00F000000000000F83F000000000000
      FFFF000000000000FFFF000000008001FFFFFFFFFFC1FFC1FFFFF801FF80FF80
      FFFFF00100080000FFFFC0017F9C7F9CEF7F800160086000E73F800140004000
      E31F800140014001E10F800140054005E007800140054005E10F800140054005
      E31F800140054005E73F80037FFD7FFDEF7F800700010001FFFF800700010001
      FFFF800F00010001FFFF801FFFFFFFFFFFFFFFE187FFFFFF07FFF000000FFFFF
      F9FFF000000FFFFFFC7FF000000FFFFFF83FE0000187FDEFF01FC0000103F9CF
      E00F800001C1F18FC00700000100E10F800300000100C00F000300000100E10F
      E00780000101F18FF803C0000103F9CFFC01E0000107FDEFFE20F000010FFFFF
      FFF0F000000FFFFFFFF9FE00007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF00FFFFFE00FF07FFFFFE187F187F8FFF81FE3CFF1C7FC7FF08F
      E3CFF187FC7FF1CFE3CFF187FC7FF3EFE3CFF01FFE3FF3EFA24DF10FFE3FF3EF
      8249F18FFE3FF3EF8001F18FFF1FF3EFFFFFE00FFE0FF3CFFFFFFFFFFFFFE1C7
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC000FFD7F1FFFFFF8000FFD78103
      00018000B081B1FF7DFD80008E6BBFFF450580009F01BF1F7D058000BF2BB810
      45058000BE2BBB1F7D058000FC7FBBFF45058000F0FFB1FF7D058000C3FF8107
      450580008F7FB1FF7DFD80009F7FBFFF000180009E7F1FFF00018000CC7F107F
      00018000E37F1FFFFFFFC000FFFFFFFF8001FFFFFFFFFC008001F00FFFFFFC00
      8001E007FCFFFC008001C003F8FBFC0080018001F0F100008001800100E80000
      8001800100C00000800180010084000080018001008400008001800100C00000
      8001800100E8000180018001F0F100038001C003F8FB003F8003E007FCFF003F
      8007F00FFFFF007F800FFFFFFFFF00FFFFFF80078000E007FFFF000300000000
      8003000300000000800300030000000080030000000000008003000000000000
      8003000000000000800300000000000080030000000000008003000000000000
      8003000000008001C1FEFC000000E007E3FEFC000000E007FFF5FC000000E007
      FFF3FC010000E00FFFF1FC030000E01FFFFFFFFFFFFF8001FFFFFC3FFFFF8001
      FF9F0000F3FF8001FF1F0000F1FF8001FE1F0000F0FF8001FC1F0000F07F8001
      F81F0000F01F8001F01F0000F01F8001F01F0000F01F8001F81F0000F03F8001
      FC1F0000F07F8001FE1F0000F0FF8001FF1F0000F1FF8001FF9F0000F3FF8001
      FFFF8181FFFF8003FFFFFFFFFFFF8007FFFFFFFF8007FFFFFFFFFFFF0003FFFF
      C40F810300030001C7FF810300037EFDC401810300007EFDC7FF810300007EFD
      C40F810300007EFDC7FF800300007EFDC401800300007EFDC7FF800300007EFD
      C40F800300007EFDC7FFC107FC007EFDC401F11FFC000001FFFFF11FFC000001
      FFFFFFFFFC010001FFFFFFFFFC03FFFF00000000000000000000000000000000
      000000000000}
  end
  object mViewTabsPopup: TTntPopupMenu
    Images = theImageList
    Left = 472
    Top = 56
    object miNewViewTab: TTntMenuItem
      Caption = #1053#1086#1074#1072#1103' '#1074#1082#1083#1072#1076#1082#1072
      ImageIndex = 30
      OnClick = miNewTabClick
    end
    object miCloseViewTab: TTntMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1082#1083#1072#1076#1082#1091
      ImageIndex = 31
      OnClick = miCloseTabClick
    end
    object miCloseAllOtherTabs: TTntMenuItem
      Caption = 'C&lose all other tabs'
      OnClick = miCloseAllOtherTabsClick
    end
  end
  object BQAppEvents: TApplicationEvents
    OnException = BQAppEventsException
    Left = 371
    Top = 99
  end
  object tmrCommonTimer: TTimer
    OnTimer = tmrCommonTimerTimer
    Left = 328
    Top = 416
  end
  object il24: TImageList
    Height = 24
    Width = 24
    Left = 378
    Top = 401
    Bitmap = {
      494C010102000300040018001800FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000600000001800000001002000000000000024
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
      000000000000FBFBFB00EFEFEF00E2E2E200D5D5D500C9C9C900BEBEBE00BCBC
      BC00B9B9B900BABABA00BFBFBF00C8C8C800D9D9D900E7E7E700F2F2F200FBFB
      FB00FEFEFE0000000000000000000000000000000000FCFCFC00F6F6F600EEEE
      EE00E7E7E700E5E5E500E6E6E600E6E6E600E7E7E700E9E9E900EBEBEB00EDED
      ED00EFEFEF00F1F1F100F3F3F300F5F5F500F7F7F700F9F9F900FBFBFB00FDFD
      FD00FEFEFE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BFC2
      C100858A8800858A8800858A8800858A8800858A8800858A8800858A8800858A
      8800858A8800858A8800858A8800858A8800858A8800858A8800858A8800858A
      8800C5C7C60000000000000000000000000000000000FAFAFA00EDEDED00DDDD
      DD00B6B6B6009B9B9B009B9B9B009A9A9A00999999009999990099999900BABA
      BA00DFDFDF00E3E3E300E8E8E800ECECEC00F0F0F000F4F4F400F8F8F800FBFB
      FB00FDFDFD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      8800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000858A8800000000000000000000000000000000000000000000000000CECE
      CE009F9F9F00DEDEDE00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD009999
      9900CBCBCB000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E8E8E800EBEBEB00EBEBEB00EDEDED00EEEEEE00F0F0F000F2F2
      F200F3F3F300F5F5F500F6F6F600F8F8F800F9F9F900F8F8F800F6F6F6000000
      0000858A88000000000000000000000000000000000000000000D2D2D200A5A5
      A500EFEFEF00DFDFDF00DFDFDF00BDBDBD00BEBEBE00BFBFBF00C1C1C100CFCF
      CF009B9B9B00CBCBCB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E8E8E800EBEBEB00EBEBEB00C2C2C200C2C2C200C2C2C200C2C2
      C200C2C2C200C2C2C200C2C2C200F5F5F500F6F6F600F8F8F800F7F7F7000000
      0000858A880000000000000000000000000000000000D5D5D500ABABAB00EFEF
      EF00E1E1E100E1E1E100E1E1E100E1E1E100BFBFBF00C1C1C100C2C2C200C3C3
      C300D1D1D1009D9D9D00CCCCCC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E8E8E800EAEAEA00EBEBEB00EBEBEB00F0F0F000F0F0F000F0F0
      F000F0F0F000F1F1F100F2F2F200F4F4F400F5F5F500F8F8F800F6F6F6000000
      0000858A880000000000000000000000000000000000B1B1B100EFEFEF00E3E3
      E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300C2C2C200C3C3C300C5C5
      C500C6C6C600D4D4D4009F9F9F00CDCDCD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E8E8E800EAEAEA00EBEBEB00C2C2C200C2C2C200C2C2C200C2C2
      C200C2C2C200C2C2C200C2C2C200C2C2C200C2C2C200F3F3F300F5F5F5000000
      0000858A880000000000000000000000000000000000B7B7B700EFEFEF00E8E8
      E800E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500C5C5C500C6C6
      C600C7C7C700C9C9C900D7D7D700A1A1A100CFCFCF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E7E7E700F6F6F600E9E9E900EAEAEA00EAEAEA00ECECEC00EEEE
      EE00EFEFEF00ECECEC00E7E7E700F2F2F200F2F2F200F6F6F600F4F4F4000000
      0000858A880000000000000000000000000000000000DDDDDD00BABABA00F0F0
      F000E9E9E900E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700C7C7
      C700C9C9C900CACACA00CCCCCC00D9D9D900A4A4A400D0D0D000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000ADAFAE00D4D4D400D4D4D400B8B8B800C1C1C100C2C2C200C0C0
      C000B7B7B700B0B0B000B0B0B000C2C2C200C2C2C200F3F3F300F3F3F3000000
      0000858A88000000000000000000000000000000000000000000DEDEDE00BDBD
      BD00F1F1F100EBEBEB00E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900CACACA00CCCCCC00CECECE00CFCFCF00DCDCDC00C37B6700E1BCB2000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E6E6E600CDCDCD00794A3800794A3800CECCCB00DDDDDD00D0CE
      CD00794A3800794A3800D4D4D400F2F2F200F2F2F200F2F2F200F2F2F2000000
      0000858A8800000000000000000000000000000000000000000000000000DFDF
      DF00BFBFBF00F3F3F300EDEDED00EBEBEB00EBEBEB00EBEBEB00EBEBEB00EBEB
      EB00EBEBEB00CECECE00CFCFCF00D1D1D100DC877000EF9A8300C47D6900E1BD
      B300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E6E6E600C5C5C5007A4B3A008D634E00794A3800D0CECD00794A
      3800936A540078483600C9C9C900EEEEEE00F1F1F100F1F1F100F0F0F0000000
      0000858A88000000000000000000000000000000000000000000000000000000
      0000E0E0E000C2C2C200F4F4F400EFEFEF00EEEEEE00EEEEEE00EEEEEE00EEEE
      EE00EEEEEE00EEEEEE00D1D1D100DC877000DE897200DF8A7300F19C8500C67F
      6B00E2BEB4000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E5E5E500BDBDBD00794A3800B18F75008D634E00794A38008D63
      4E00B5937900784836009E9E9E00C2C2C200C2C2C200EFEFEF00EFEFEF000000
      0000858A88000000000000000000000000000000000000000000000000000000
      000000000000E1E1E100C4C4C400F5F5F500F1F1F100F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F1AA9300DE897200DF8A7300E08B7400E28D7600F49F
      8800C8806D00E3BFB50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E4E4E400C9C9C90079493800B2907600AB856800B28E7300AA82
      6500B593790078483600B9B9B900ECECEC00EDEDED00EFEFEF00EDEDED000000
      0000858A88000000000000000000000000000000000000000000000000000000
      00000000000000000000E3E3E300C7C7C700F6F6F600F4F4F400F3F3F300F3F3
      F300F3F3F300F1AA9300F2AB9400F3AD9600E08B7400E28D7600E38E7700E48F
      7800F6A18A00CA826E00E4C0B600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000ACAFAD00AEAEAE0078493700B2907600A47B5B00A47A5A00A47A
      5A00B59379007848360089898900B6B6B600B6B6B600EFEFEF00ECECEC000000
      0000858A88000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E4E4E400C9C9C900F8F8F800F6F6F600F5F5
      F500F1AA9300F2AB9400F3AD9600F3AE9700F4AF9800E38E7700E48F7800E590
      7900E6917A00F8A38C00CB847000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E2E2E200A7A7A70078483600B3917600A47B5B00A47A5A00A47A
      5A00B593790078483600A8A8A800EAEAEA00EAEAEA00EAEAEA00EAEAEA000000
      0000858A88000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E500CBCBCB00F9F9F900F6AD
      9600F2AB9400F3AD9600F3AE9700F4AF9800F5B09900F4B19A00E5907900E691
      7A00E7927B00F2A39600CE867300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E1E1E100A6A6A60075463400B18F75009F7758009F7657009E76
      5700AF8F75007445340083838300B6B6B600B6B6B600E7E7E700E8E9E900FBFE
      FE00848B89000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E6E6E600D7927F00FEC0
      AD00F7B19A00F3AE9700F4AF9800F5B09900F4B19A00F5B29B00F5B39C00E792
      7B00F5A39200D0897600E7C4BA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000E0E0E000A4A3A3006C403000A6887100936E5100936E5100936D
      5000A68770006B403000A6A6A600E7E7E700E7E7E700E4E7E700CDE7EA00C9F8
      FE00789FA100F9FEFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000ECC9BF00D993
      8000FEC2B000F9B39C00F5B09900F4B19A00F5B29B00F5B39C00F6B49D00FECB
      BA00D38D7A00E8C5BB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000DFDFDF00A3A1A100653E2E00A1836C008C684C008C684C008C68
      4D00A1836D00673D2E0084848400B7B7B700B3B8B900B4E9EF00A6EEF800AFF3
      FD0071CBD500D9FAFE00FEFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000ECC9
      BF00D9948100FDC5B500F9B69F00F5B29B00F5B39C00F6B49D00FCCABC00D690
      7D00EAC7BD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      880000000000DEDEDE00A19F9E006F433300AA8A720097705300987153009871
      5300AA8B72006F423200A4A4A400E5E5E500C0E6EA009FEFF800E9FAFD00F5FD
      FE00AAE8F000B9F6FE00F5FEFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000ECCAC000DA958200FDC7B800FAB8A100F6B49D00FCCABC00D8938000EBC8
      BF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000858A
      88000000000000000000B4B3B20079493800BA9C8500AC876A00AC876A00AC87
      6A00BB9D850078483600B8B8B80000000000C9F8FE00A4F2FD00F3FDFE00FBFE
      FE00C6F1F600AFF5FE00F3FDFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EDCAC100DB958300FCC9BB00FCCABC00DA948100ECC9BF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C1C3
      C200858A8800858A880061615E00784A3700D5C2B400D5C1B300D5C1B300D5C2
      B400D5C2B400784836005F636200858A88007C999B006CCDD800A5EAF300C3F1
      F50096DEE700E5FCFF00FDFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EDCAC100DC978400DC968400EDCAC100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BBA39A0078483600784836007848360078483600784836007848
      360078483600855949000000000000000000FCFFFF00DFFBFE00BBF6FE00C8F8
      FE00EFFDFF00FEFFFF0000000000000000000000000000000000000000000000
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
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000060000000180000000100010000000000200100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF000000000000F8000780
      0007000000000000E00007800007000000000000EFFFF7E007FF000000000000
      E80017C003FF000000000000E800178001FF000000000000E800178000FF0000
      00000000E8001780007F000000000000E8001780003F000000000000E80017C0
      001F000000000000E80017E0000F000000000000E80017F00007000000000000
      E80017F80003000000000000E80017FC0001000000000000E80017FE00010000
      00000000E80017FF0001000000000000E80007FF8001000000000000E80003FF
      C003000000000000E80001FFE007000000000000E80001FFF00F000000000000
      EC0101FFF81F000000000000E00001FFFC3F000000000000F80303FFFFFF0000
      00000000FFFFFFFFFFFF00000000000000000000000000000000000000000000
      000000000000}
  end
  object popupRecLinksOptions: TTntPopupMenu
    Images = theImageList
    OnChange = popupRecLinksOptionsChange
    Left = 440
    Top = 86
    object miStrictLogic: TTntMenuItem
      AutoCheck = True
      Caption = 'Use only strict logic'
      GroupIndex = 1
      ImageIndex = 42
      RadioItem = True
      OnClick = miChooseLogicClick
    end
    object miFuzzyLogic: TTntMenuItem
      AutoCheck = True
      Caption = 'Use Fuzzy Logic'
      Checked = True
      GroupIndex = 1
      ImageIndex = 43
      RadioItem = True
      OnClick = miChooseLogicClick
    end
  end
end
