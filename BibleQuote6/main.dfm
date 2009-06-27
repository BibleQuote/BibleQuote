object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1062#1080#1090#1072#1090#1072' '#1080#1079' '#1041#1080#1073#1083#1080#1080
  ClientHeight = 651
  ClientWidth = 998
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
  OnClose = FormClose
  OnCloseQuery = TntFormCloseQuery
  OnCreate = FormCreate
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
    Top = 30
    Width = 2
    Height = 621
    MinSize = 100
    OnMoved = Splitter1Moved
    ExplicitTop = 23
    ExplicitHeight = 532
  end
  object MainPanel: TTntPanel
    Left = 455
    Top = 30
    Width = 543
    Height = 621
    Align = alRight
    Caption = 'MainPanel'
    TabOrder = 0
    object BibleTabs: TTntTabControl
      Left = 1
      Top = 594
      Width = 541
      Height = 26
      Align = alBottom
      Style = tsFlatButtons
      TabOrder = 0
      Tabs.Strings = (
        'Ctrl-1'
        'Ctrl-2'
        'Ctrl-3'
        'Ctrl-4'
        'Ctrl-5'
        'Ctrl-6'
        'Ctrl-7'
        'Ctrl-8'
        'Ctrl-9'
        'Ctrl-0'
        '***')
      TabIndex = 0
      OnChange = BibleTabsChange
      OnDragDrop = BibleTabsDragDrop
      OnDragOver = BibleTabsDragOver
    end
    object mViewTabs: TAlekPageControl
      Left = 1
      Top = 1
      Width = 541
      Height = 593
      Margins.Top = 10
      ActivePage = mInitialViewPage
      Align = alClient
      OwnerDraw = True
      PopupMenu = mViewTabsPopup
      TabOrder = 1
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
          Top = 0
          Width = 533
          Height = 563
          OnHotSpotClick = FirstBrowserHotSpotClick
          TabOrder = 0
          Align = alClient
          PopupMenu = BrowserPopupMenu
          DefBackground = 14410470
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
    Top = 30
    Width = 298
    Height = 621
    ActivePage = SearchTab
    Align = alLeft
    Images = theImageList
    PopupMenu = RefPopupMenu
    TabOrder = 3
    OnChange = MainPagesChange
    object GoTab: TTntTabSheet
      ImageIndex = 5
      object Splitter2: TTntSplitter
        Left = 0
        Top = 243
        Width = 290
        Height = 3
        Cursor = crVSplit
        Align = alTop
        Beveled = True
        Color = clBtnFace
        ParentColor = False
        OnMoved = Splitter2Moved
      end
      object Panel2: TTntPanel
        Left = 0
        Top = 0
        Width = 290
        Height = 243
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object GroupBox1: TTntGroupBox
          Left = 1
          Top = -5
          Width = 288
          Height = 245
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
          Left = 6
          Top = 33
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
          Top = 59
          Width = 220
          Height = 175
          Style = lbOwnerDrawVariable
          ItemHeight = 14
          PopupMenu = EmptyPopupMenu
          TabOrder = 2
          OnClick = BookLBClick
        end
        object ChapterLB: TTntListBox
          Left = 230
          Top = 59
          Width = 53
          Height = 175
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
          Top = 7
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
        Top = 246
        Width = 290
        Height = 345
        ActivePage = BookmarksTab
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
            Height = 315
            Style = lbOwnerDrawVariable
            Align = alClient
            Color = clBtnFace
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
            Height = 204
            Style = lbOwnerDrawVariable
            Align = alClient
            Color = clBtnFace
            ItemHeight = 14
            PopupMenu = HistoryPopupMenu
            TabOrder = 0
            OnClick = BookmarksLBClick
            OnDblClick = BookmarksLBDblClick
            OnKeyUp = BookmarksLBKeyUp
          end
          object BookmarkPanel: TTntPanel
            Left = 0
            Top = 204
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
        object TntTabSheet1: TTntTabSheet
          Caption = #1041#1099#1089#1090#1088#1099#1081' '#1087#1086#1080#1089#1082
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object SearchInWindowLabel: TTntLabel
            Left = 0
            Top = 0
            Width = 94
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
              Left = 5
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
      object SearchBrowser: THTMLViewer
        Left = 0
        Top = 179
        Width = 290
        Height = 412
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
          ItemHeight = 15
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
          ItemHeight = 15
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
        Height = 359
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object StrongBrowser: THTMLViewer
        Left = 0
        Top = 206
        Width = 290
        Height = 385
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
        Height = 561
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
        Height = 591
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TREMemo: TTntRichEdit
        Left = 0
        Top = 27
        Width = 290
        Height = 539
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
        Top = 568
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
  object ToolbarPanel: TTntPanel
    Left = 0
    Top = 0
    Width = 998
    Height = 30
    Align = alTop
    AutoSize = True
    BevelEdges = [beBottom]
    TabOrder = 4
    object MainToolbar: TTntToolBar
      AlignWithMargins = True
      Left = 4
      Top = 3
      Width = 408
      Height = 26
      Margins.Top = 2
      Margins.Bottom = 0
      Align = alLeft
      AutoSize = True
      ButtonWidth = 24
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
        ImageIndex = 0
        OnClick = CopyrightButtonClick
      end
      object SatelliteButton: TTntToolButton
        Left = 372
        Top = 0
        Caption = 'Satellite'
        ImageIndex = 3
        OnClick = SatelliteButtonClick
      end
      object TntToolButton3: TTntToolButton
        Left = 396
        Top = 0
        Width = 12
        Caption = 'TntToolButton3'
        Style = tbsSeparator
      end
    end
    object TitleLabel: TTntPanel
      AlignWithMargins = True
      Left = 580
      Top = 4
      Width = 410
      Height = 25
      Margins.Left = 0
      Margins.Right = 7
      Margins.Bottom = 0
      Align = alClient
      Alignment = taRightJustify
      BevelEdges = [beBottom]
      BevelOuter = bvNone
      Caption = 'CopyRight'
      TabOrder = 1
    end
    object LinksCB: TTntComboBox
      AlignWithMargins = True
      Left = 418
      Top = 3
      Width = 159
      Height = 23
      Margins.Top = 2
      Align = alLeft
      BevelInner = bvNone
      BevelKind = bkSoft
      BevelOuter = bvNone
      Style = csDropDownList
      ItemHeight = 15
      TabOrder = 2
      Visible = False
      OnChange = LinksCBChange
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
    Left = 404
    Top = 195
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
      Caption = #1051#1102#1073#1080#1084#1099#1077' '#1084#1086#1076#1091#1083#1080
      object miHotKey: TTntMenuItem
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1083#1102#1073#1080#1084#1099#1077' '#1084#1086#1076#1091#1083#1080'...'
        ShortCut = 120
        OnClick = miHotkeyClick
      end
      object s: TTntMenuItem
        Caption = '-'
      end
      object miHot1: TTntMenuItem
        Caption = 'miHot1'
        ShortCut = 16433
      end
      object miHot2: TTntMenuItem
        Caption = 'miHot2'
        ShortCut = 16434
      end
      object miHot3: TTntMenuItem
        Caption = 'miHot3'
        ShortCut = 16435
      end
      object miHot4: TTntMenuItem
        Caption = 'miHot4'
        ShortCut = 16436
      end
      object miHot5: TTntMenuItem
        Caption = 'miHot5'
        ShortCut = 16437
      end
      object miHot6: TTntMenuItem
        Caption = 'miHot6'
        ShortCut = 16438
      end
      object miHot7: TTntMenuItem
        Caption = 'miHot7'
        ShortCut = 16439
      end
      object miHot8: TTntMenuItem
        Caption = 'miHot8'
        ShortCut = 16440
      end
      object miHot9: TTntMenuItem
        Caption = 'miHot9'
        ShortCut = 16441
      end
      object miHot0: TTntMenuItem
        Caption = 'miHot0'
        ShortCut = 16432
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
      494C010120002200040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7FFF700FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0031B5210031B5210031B52100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF008473FF007B73FF00FFFFFF00FFFFFF00FFFFFF00948CFF00948C
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00F7FFF70031B521004AFF6B0031B52100F7FFF700FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF008C84FF002918FF002918FF00847BFF00FFFFFF00948CFF002918FF002918
      FF00948CFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00F7FFF700F7FFF70031B521004AFF6B0031B52100F7FFF700F7FF
      F700FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00948CFF002918FF002918FF002918FF005A4AFF002918FF002918FF002918
      FF009494FF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF0031B5210031B5210031B5210031B521004AFF6B0031B5210031B5210031B5
      210031B52100FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00948CFF002918FF002918FF002918FF002918FF002918FF009494
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000F7FF
      F70031B521004AFF6B004AFF6B004AFF6B004AFF6B004AFF6B004AFF6B004AFF
      6B0031B52100F7FFF7000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00635AFF002918FF002918FF002918FF006B5AFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0084000000840000008400000084000000840000008400000084000000FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF0031B5210031B5210031B5210031B521004AFF6B0031B5210031B5210031B5
      210031B52100FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF009C94FF002918FF002918FF002918FF002918FF002918FF00A59C
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00F7FFF700F7FFF70031B521004AFF6B0031B52100F7FFF700F7FF
      F700FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF009C94FF002918FF002918FF002918FF00635AFF002918FF002918FF002918
      FF00ADA5FF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0084000000840000008400000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00F7FFF70031B521004AFF6B0031B52100F7FFF700FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF008C7BFF002918FF002918FF009C94FF00FFFFFF00948CFF002918FF002918
      FF00ADA5FF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0031B5210031B5210031B52100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF008C7BFF00A59CFF00FFFFFF00FFFFFF00FFFFFF009494FF00ADA5
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00840000008400000084000000FFFFFF00FFFFFF0000000000FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7FFF700FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0084848400FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0084848400FFFFFF00C6C6C6008484840000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840000000000000000000000000084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0084848400FFFFFF00C6C6C6008484840000FFFF00FFFFFF0000FFFF008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008484
      8400FFFFFF00C6C6C6008484840000FFFF00FFFFFF0000FFFF0084848400C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00C6C6C6008484840000FFFF00FFFFFF0000FFFF0084848400C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF0084848400C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0084848400C6C6C600C6C6C600C6C6C6008484
      8400840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600C6C6C600C6C6C600000000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000000000000000000000000000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008400
      0000000000000000000000000000000000000000000084848400840000008400
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000000000000000000000000000000000000084848400840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400840000000000000000000000000000000000000084000000840000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008400000000000000000000008400000084000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000000000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084000000840000008400000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400840000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C60000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000E7E7E70084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840084848400CED6
      D600000000008400000000000000000000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000C6C6C6007B7B
      7B00C6C6C600C6C6C600C6C6C60000000000FFFFFF00FFFFFF00D6D6D600D6D6
      D600D6D6D60000000000FFFFFF0000000000E7E7E70084848400FFFFFF008400
      0000840000008400000084000000840000008400000084000000840000008400
      00008400000084000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000008484000000000000000000000000000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C6000000
      000000000000C6C6C600C6C6C60000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000E7E7E70084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000008484000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C6000000
      000000FFFF0000000000C6C6C60000000000FFFFFF00FFFFFF00848484008484
      840084848400D6D6D600FFFFFF0000000000E7E7E70084848400FFFFFF008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000008484000000000000000000000000000000000084848400000000000000
      000000000000000000000000000000000000CED6D60000000000CED6D6000000
      0000000000000000000000000000000000006363630000000000000000000000
      000000FFFF0000FFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000E7E7E70084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000084840000848400008484000084
      8400008484000084840000848400008484000000000084848400000000000000
      0000000000008484840084848400CED6D6000000000084000000000000000000
      0000840000008400000084000000840000008484840000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFFFF00848484008484
      840084848400ADADAD00FFFFFF0000000000E7E7E70084848400FFFFFF008400
      0000840000008400000084000000840000008400000084000000840000008400
      00008400000084000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000000000000084840000000000000000000000000084848400000000000000
      000000000000848484000000000000000000CED6D60000000000CED6D6000000
      00000000000000000000000000000000000084848400FFFFFF0000FFFF00FFFF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000E7E7E70084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000000000000084840000000000000000000000000084848400000000000000
      000000000000CED6D60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000FFFF00FFFFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFFFF00848484008484
      840084848400D6D6D600FFFFFF0000000000E7E7E70084848400FFFFFF000000
      FF00FFFFFF00FFFFFF00FFFFFF000000FF00FFFFFF0084000000840000008400
      0000840000008400000084000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000084840000848400008484000084
      8400008484000084840000848400008484000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      840000FFFF0000FFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000E7E7E70084848400FFFFFF000000
      FF000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      000000000000008484000000000000000000000000008484840084848400CED6
      D600000000008400000000000000000000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000C6C6C6008484
      840000FFFF0000000000C6C6C60000000000FFFFFF00FFFFFF00848484008484
      840084848400ADADAD00FFFFFF0000000000E7E7E70084848400FFFFFF00FFFF
      FF000000FF00FFFFFF00FFFFFF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      8400000000000000000000848400000000000000000084848400000000000000
      0000CED6D60000000000CED6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C6008484
      840000000000C6C6C600C6C6C60000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000E7E7E70084848400FFFFFF00FFFF
      FF00FFFFFF000000FF00FFFFFF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      84000000000000000000008484000000000000000000CED6D600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C6008484
      8400C6C6C600C6C6C600C6C6C60000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000E7E7E70084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      840000000000000000000084840000000000E7E7E70000000000CED6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E7E7E70084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006363630000FFFF00000000000000
      0000840000008400000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000000000E7E7E70084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E7E7E70000000000CED6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EFEFEF0063636300636363006363
      6300636363006363630063636300636363006363630063636300636363006363
      630063636300636363006363630063636300EFEFEF00B5B5B500B5B5B500B5B5
      B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
      B500B5B5B500B5B5B500B5B5B500B5B5B5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008484000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000848400000000000000000000000000848484000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      00008400000084000000840000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008484008484840084848400FFFFFF00FFFFFF00848484000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00840000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000084848400C6C6C600C6C6C6008484
      8400000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084840000FFFF000000000000000000FFFFFF00FFFFFF00848484000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF00840000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000084848400C6C6C600C6C6C600FFFF00008484
      8400848484000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      840000FFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00840000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C6C6C600C6C6C600C6C6C600C6C6C6008484
      8400C6C6C6000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000084840000000000000000000000
      00000000000000000000000000000000000000000000008484008484840000FF
      FF00FFFFFF0000FFFF000000000000000000FFFFFF00FFFFFF00848484000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF00840000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C6C6C600FFFF0000C6C6C600C6C6C6008484
      8400C6C6C6000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000084840000000000000000000000
      0000000000000000000000000000000000000084840000FFFF0000000000FFFF
      FF0000FFFF00FFFFFF00000000008484840000000000FFFFFF00848484000000
      00008484840084848400848484008484840000000000FFFFFF00000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00840000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000084848400FFFF0000FFFF0000C6C6C6008484
      8400848484000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000848400000000000000
      0000000000000000000000000000000000000084840000FFFF000000000000FF
      FF00FFFFFF0000FFFF00000000000000000000000000FFFFFF00848484000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000FFFFFF000000000000000000FFFFFF008400
      00008400000084000000840000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000084848400C6C6C600C6C6C6008484
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00008484000000
      00000000000000000000000000000000000000848400FFFFFF0000000000FFFF
      FF0000FFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00848484000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008400
      0000FFFFFF0084000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000084840000000000000000000000000000FFFF0000FFFF000084
      84000000000000000000000000000000000000000000008484000084840000FF
      FF00FFFFFF0000FFFF000000000000000000FFFFFF00FFFFFF00848484000000
      00008484840000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008400
      00008400000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF00008484000000000000000000000000000000000000FFFF000084
      8400000000000000000000000000000000000000000000000000000000000084
      840000FFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00848484000000
      00000000000084848400000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000084000000840000008400000084000000840000008400
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000848400000000000000000000FFFF0000FFFF000084
      8400000000000000000000000000000000000000000000000000000000000000
      00000084840000FFFF00848484008484840000000000FFFFFF00848484000000
      00000000000000000000848484000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000FFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000848400848484000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600000000000084840000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C6000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000FFFF00000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000C6C6C600C6C6
      C6000000000000848400000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C60000FFFF0000FFFF0000FFFF00C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000000000000FFFFFF0000FFFF000000
      0000008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000848400000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600848484008484840084848400C6C6C600C6C6
      C60000000000C6C6C60000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      00000084840000848400000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C60000000000C6C6C600000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000084840000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000C6C6C60000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C60000000000008484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C60000000000C6C6C600000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000084840000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000084840000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000000000000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000084000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      000084000000840000008484840084000000FFFFFF0084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000084000000840000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000008400000084000000000000000000
      0000000000000000000000000000000000008400000084000000848484008484
      840084848400848484008484840084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000084000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000008400000084000000848484008484
      840084848400848484008484840084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000084000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000008400000084000000848484008484
      840084848400848484008484840084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000084000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000008400000084000000848484008484
      840084848400848484008484840084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000084000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000008400000084000000848484008484
      840084848400848484008484840084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000084000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000008400000084000000000000000000
      0000000000000000000000000000000000008400000084000000848484008484
      840084848400848484008484840084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000084000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000000000000000
      0000000000000000000000000000000000008400000084000000848484008484
      840084848400848484008484840084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000084000000000000000000000000000000000000000000
      0000000000000000000084000000840000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000000000000000
      0000000000000000000000000000000000008400000084000000848484008484
      84008484840084848400840000000000000084000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000084000000000000000000000000000000000000000000
      0000000000000000000084000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000000000000000000000000000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      00008400000084000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000FFFF00000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      840000000000FFFFFF00FFFFFF00000000000000000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      0000008484000084840000848400008484000084840000848400008484000084
      84000084840000000000FFFFFF00000000000000000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000008484000084840000848400008484000084
      8400008484000084840000848400000000000000000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000C6C6C60000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084000000000000000000000000000000FFFFFF0000000000C6C6
      C60000000000FFFFFF0000000000C6C6C60000000000C6C6C600000000000000
      0000000000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084000000000000000000000000000000FFFFFF00FFFFFF000000
      0000C6C6C60000000000C6C6C60000000000C6C6C60000000000C6C6C600C6C6
      C600C6C6C600000000008400000084000000000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF000000000000000000FFFFFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000000000000000000000000000000000000000000000000
      000000000000C6C6C60000000000C6C6C60000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C60084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000000000000000000000000000000000000000000000000
      00000000000000000000C6C6C60000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C60084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000084000000840000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000084000000FFFFFF008400
      000084000000840000008400000084000000FFFFFF0084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000900000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFC001C001
      FFFFC007C001C001FFFFC007C001C001EF7FC007C001C001E73FC007C001C001
      E31FC007C001C001E10FC007C001C001E007C007C001C001E10FC007C001C001
      E31FC007C001C001E73FC007C001C001EF7FC00FC003C003FFFFC01FC007C007
      FFFFC03FC00FC00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF07FFFFFFFFFFFFFF
      F9FFFE3FFFFFFFFFFC7FFC3FFFFFFFFFF83FFC3FFFFFFDEFF01FFC3FFFFFF9CF
      E00FE007F003F18FC007C007E003E10F8003C007E003C00F0003C00FE007E10F
      E007FC3FFFFFF18FF803FC3FFFFFF9CFFC01FC3FFFFFFDEFFE20FC7FFFFFFFFF
      FFF0FFFFFFFFFFFFFFF9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF8703FFFFFFFFE00FCF87E01FE07FFFFFE78FF18FF8FFF83F
      E78FF18FF8FFF11FF01FF18FFC7FF39FF31FF01FFC7FF39FF93FF18FFE3FF39F
      F83FF18FFE3FF39FFC7FF18FFF1FF39FFC7FE01FFE0FF39FFEFFFFFFFFFFE10F
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80008000FFFFF1FF80000000FFFF8103
      80040000A1B7B1FF800000009CB7BFFF80000000BCB7BF1F00000000B800B810
      00000000F1DBBB1F00000000E3DBBBFF00000000C700B1FF000000008EDB8107
      800000009EEDB1FF800000009CEDBFFF80000000C2ED1FFF80000000FFFF107F
      80000000FFFF1FFF00000000FFFFFFFFFFFFFFFFFE7FFFFF000CFE7FFC3FFFFF
      0008FC3FF8DDFC010001FC3FF01BFC010003FE7FE117FC010003FC3F811F0001
      0003FC3F001F00010003FC3F201000010003FC1F211F00010007F20F201F0003
      000FE10781170007000FE187E11B000F000FE007F09D00FF001FF00FF8FF01FF
      003FF81FFC3F03FF007FFFFFFE7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFC001C007
      8003001F800180038003000F8001000180030007800100018003000380010001
      800300018001000080030000800100008003001F800180008003001F8001C000
      8003001F8001E001C1FE8FF18001E007E3FEFFF98001F007FFF5FF758001F003
      FFF3FF8F8001F803FFF1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FF9FF83FF9FFC007FF1F0001F8FFC007FE1F0001F87FC007FC1F0001F83FC007
      F81F0001F81FC007F01F0001F80FC007F01F0001F80FC007F81F0001F81FC007
      FC1F0001F83FC007FE1F0001F87FC007FF1F0101F8FFC00FFF9F8383F9FFC01F
      FFFFFFFFFFFFC03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFF
      000F07C1001F8003000F07C100008003000F07C100008003000F010100008003
      000F000100008003000F020100008003000F0201000080030004800300008003
      0000C107000080030000C10788008003F800E38FF8008003FC00E38FF8018003
      FE04E38FF8038003FFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object mViewTabsPopup: TTntPopupMenu
    Left = 400
    Top = 128
    object miCloseViewTab: TTntMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1082#1083#1072#1076#1082#1091
      OnClick = miCloseTabClick
    end
    object miNewViewTab: TTntMenuItem
      Caption = #1053#1086#1074#1072#1103' '#1074#1082#1083#1072#1076#1082#1072
      OnClick = miNewTabClick
    end
  end
end
