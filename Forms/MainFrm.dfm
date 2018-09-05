object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1062#1080#1090#1072#1090#1072' '#1080#1079' '#1041#1080#1073#1083#1080#1080
  ClientHeight = 355
  ClientWidth = 881
  Color = clBtnFace
  Constraints.MinHeight = 414
  Constraints.MinWidth = 581
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial Unicode MS'
  Font.Style = []
  KeyPreview = True
  Menu = mmGeneral
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object splMain: TSplitter
    Left = 290
    Top = 34
    Width = 8
    Height = 300
    AutoSnap = False
    MinSize = 100
    ExplicitTop = 24
    ExplicitHeight = 553
  end
  object pnlModules: TPanel
    Left = 298
    Top = 34
    Width = 583
    Height = 300
    Align = alClient
    DockSite = True
    TabOrder = 0
  end
  object sbxPreview: TScrollBox
    Left = 299
    Top = 219
    Width = 100
    Height = 180
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    BorderStyle = bsNone
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    Visible = False
    object pnlContainer: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 160
      BevelOuter = bvNone
      Color = clBtnShadow
      TabOrder = 0
      object pnlPage: TPanel
        Left = 11
        Top = 4
        Width = 68
        Height = 146
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        object pbPreview: TPaintBox
          Left = 0
          Top = 0
          Width = 68
          Height = 146
          Cursor = crArrow
          Align = alClient
          OnMouseDown = pbPreviewMouseDown
          OnPaint = pbPreviewPaint
        end
      end
    end
  end
  object pgcMain: TPageControl
    Left = 0
    Top = 34
    Width = 290
    Height = 300
    Hint = 'Memos'
    ActivePage = tbList
    Align = alLeft
    Images = ilImages
    TabOrder = 2
    TabWidth = 27
    OnChange = pgcMainChange
    OnMouseLeave = pgcMainMouseLeave
    OnMouseMove = pgcMainMouseMove
    object tbGo: TTabSheet
      Hint = 'Navigate'
      ImageIndex = 5
      object splGo: TSplitter
        Left = 0
        Top = 242
        Width = 282
        Height = 13
        Cursor = crVSplit
        Align = alTop
        Beveled = True
        Color = clBtnFace
        ParentColor = False
        ExplicitWidth = 283
      end
      object pnlGo: TPanel
        Left = 0
        Top = 0
        Width = 282
        Height = 242
        Align = alTop
        BevelOuter = bvNone
        Constraints.MinHeight = 150
        TabOrder = 0
        DesignSize = (
          282
          242)
        object vdtModules: TVirtualStringTree
          Left = 4
          Top = 0
          Width = 276
          Height = 236
          Anchors = [akLeft, akTop, akRight, akBottom]
          ButtonStyle = bsTriangle
          Header.AutoSizeIndex = 0
          Header.MainColumn = -1
          TabOrder = 0
          TreeOptions.AnimationOptions = [toAnimatedToggle]
          TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnAddToSelection = vdtModulesAddToSelection
          OnFreeNode = vdtModulesFreeNode
          OnGetText = vdtModulesGetText
          OnInitChildren = vdtModulesInitChildren
          OnInitNode = vdtModulesInitNode
          Columns = <>
        end
      end
      object pgcHistoryBookmarks: TPageControl
        Left = 0
        Top = 255
        Width = 282
        Height = 15
        ActivePage = tbBookmarks
        Align = alClient
        TabOrder = 1
        object tbHistory: TTabSheet
          Caption = 'tbHistory'
          object lbHistory: TListBox
            Left = 0
            Top = 0
            Width = 274
            Height = 5
            Style = lbOwnerDrawVariable
            Align = alClient
            ItemHeight = 14
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            OnClick = lbHistoryClick
            OnDblClick = lbHistoryDblClick
            OnKeyUp = lbHistoryKeyUp
          end
        end
        object tbBookmarks: TTabSheet
          Caption = 'tbBookmarks'
          ImageIndex = 1
          object lbBookmarks: TListBox
            Left = 0
            Top = 0
            Width = 274
            Height = 0
            Style = lbOwnerDrawVariable
            Align = alClient
            ItemHeight = 14
            TabOrder = 0
            OnClick = lbBookmarksClick
            OnDblClick = lbBookmarksDblClick
            OnKeyUp = lbBookmarksKeyUp
          end
          object pnlBookmarks: TPanel
            Left = 0
            Top = -105
            Width = 274
            Height = 110
            Align = alBottom
            BevelOuter = bvNone
            BorderWidth = 10
            TabOrder = 1
            object lblBookmark: TLabel
              Left = 10
              Top = 10
              Width = 254
              Height = 90
              Align = alClient
              Caption = 'lblBookmark'
              WordWrap = True
              ExplicitWidth = 59
              ExplicitHeight = 15
            end
          end
        end
      end
    end
    object tbSearch: TTabSheet
      Hint = 'Search'
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
      object bwrSearch: THTMLViewer
        Left = 0
        Top = 179
        Width = 282
        Height = 91
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
        OnKeyDown = bwrSearchKeyDown
        OnKeyUp = bwrSearchKeyUp
        OnHotSpotClick = bwrSearchHotSpotClick
        OnHotSpotCovered = bwrSearchHotSpotCovered
      end
      object pnlSearch: TPanel
        Left = 0
        Top = 0
        Width = 282
        Height = 179
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          282
          179)
        object lblSearch: TLabel
          Left = 4
          Top = 159
          Width = 45
          Height = 15
          Caption = 'lblSearch'
        end
        object cbSearch: TComboBox
          Left = 4
          Top = 3
          Width = 226
          Height = 23
          Hint = 'enter word or expression to search'
          AutoCloseUp = True
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 10
          TabOrder = 0
          OnKeyUp = cbSearchKeyUp
        end
        object cbList: TComboBox
          Left = 27
          Top = 28
          Width = 196
          Height = 23
          Hint = 'Search scope'
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 15
          TabOrder = 1
          OnDropDown = cbListDropDown
          Items.Strings = (
            #1042#1089#1077' '#1082#1085#1080#1075#1080
            #1053#1077' '#1074#1089#1077' '#1082#1085#1080#1075#1080)
        end
        object btnFind: TButton
          AlignWithMargins = True
          Left = 228
          Top = 28
          Width = 54
          Height = 22
          Anchors = [akTop, akRight]
          Caption = #1053#1072#1081#1090#1080
          Default = True
          TabOrder = 2
          OnClick = btnFindClick
        end
        object chkAll: TCheckBox
          Left = 4
          Top = 57
          Width = 279
          Height = 16
          Anchors = [akLeft, akTop, akRight]
          Caption = #1083#1102#1073#1086#1077' '#1080#1079' '#1089#1083#1086#1074
          TabOrder = 3
        end
        object chkPhrase: TCheckBox
          Left = 4
          Top = 76
          Width = 278
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = #1089#1086#1073#1083#1102#1076#1072#1090#1100' '#1087#1086#1088#1103#1076#1086#1082' '#1089#1083#1086#1074
          TabOrder = 4
        end
        object chkParts: TCheckBox
          Left = 4
          Top = 117
          Width = 278
          Height = 16
          Anchors = [akLeft, akTop, akRight]
          Caption = #1080#1097#1077#1084' '#1089#1083#1086#1074#1072' '#1094#1077#1083#1080#1082#1086#1084
          TabOrder = 6
        end
        object chkCase: TCheckBox
          Left = 4
          Top = 136
          Width = 278
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = #1088#1072#1079#1083#1080#1095#1072#1090#1100' '#1088#1077#1075#1080#1089#1090#1088#1099
          TabOrder = 7
        end
        object chkExactPhrase: TCheckBox
          Left = 4
          Top = 94
          Width = 278
          Height = 20
          Anchors = [akLeft, akTop, akRight]
          Caption = #1080#1097#1077#1084' '#1090#1086#1095#1085#1091#1102' '#1092#1088#1072#1079#1091
          TabOrder = 5
          OnClick = chkExactPhraseClick
        end
        object cbQty: TComboBox
          Left = 234
          Top = 2
          Width = 48
          Height = 23
          Hint = 'Number of result to display per view'
          Style = csDropDownList
          Anchors = [akTop, akRight]
          TabOrder = 8
          OnChange = cbQtyChange
          Items.Strings = (
            '50'
            '100'
            '200'
            '300'
            '*')
        end
        object btnSearchOptions: TButton
          Left = 4
          Top = 29
          Width = 20
          Height = 20
          Caption = '<'
          TabOrder = 9
          OnClick = btnSearchOptionsClick
        end
      end
    end
    object tbDic: TTabSheet
      Hint = 'Dictionaries'
      ImageIndex = 17
      object bwrDic: THTMLViewer
        Left = 0
        Top = 234
        Width = 282
        Height = 36
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
        Width = 282
        Height = 178
        Align = alTop
        Anchors = []
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          282
          178)
        object cbDicFilter: TComboBox
          Left = 4
          Top = 5
          Width = 275
          Height = 23
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
          Width = 275
          Height = 23
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
          Width = 275
          Height = 115
          Anchors = [akLeft, akTop, akRight]
          DefaultNodeHeight = 16
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
          OnClick = DicLBDblClick
          OnDblClick = DicLBDblClick
          OnGetText = vstDicListGetText
          OnKeyPress = DicLBKeyPress
          Columns = <>
        end
      end
      object pnlSelectDic: TPanel
        Left = 0
        Top = 178
        Width = 282
        Height = 56
        Align = alTop
        Anchors = []
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          282
          56)
        object lblDicFoundSeveral: TLabel
          Left = 9
          Top = 4
          Width = 166
          Height = 15
          Caption = #1085#1072#1081#1076#1077#1085#1086' '#1074' '#1085#1077#1089#1082#1086#1083#1100#1082#1080#1093' '#1089#1083#1086#1074#1072#1088#1103#1093':'
        end
        object cbDic: TComboBox
          Left = 3
          Top = 26
          Width = 276
          Height = 23
          Hint = 'Select dictionary to show entry from'
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          PopupMenu = pmEmpty
          TabOrder = 0
          OnChange = cbDicChange
        end
      end
    end
    object tbStrong: TTabSheet
      Hint = 'Strong'#39's Dictionary'
      ImageIndex = 18
      object bwrStrong: THTMLViewer
        AlignWithMargins = True
        Left = 3
        Top = 210
        Width = 276
        Height = 57
        TabOrder = 0
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
      object pnlStrong: TPanel
        Left = 0
        Top = 0
        Width = 282
        Height = 181
        Align = alTop
        Anchors = []
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          282
          181)
        object edtStrong: TEdit
          Left = 4
          Top = 4
          Width = 277
          Height = 23
          Hint = 'Strong number to show'
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnKeyPress = edtStrongKeyPress
        end
        object lbStrong: TListBox
          Left = 4
          Top = 32
          Width = 277
          Height = 144
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 15
          PopupMenu = pmEmpty
          TabOrder = 1
          OnDblClick = lbStrongDblClick
        end
      end
      object pnlFindStrongNumber: TPanel
        Left = 0
        Top = 181
        Width = 282
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
        TabOrder = 2
        OnClick = pnlFindStrongNumberClick
        OnMouseDown = pnlFindStrongNumberMouseDown
        OnMouseUp = pnlFindStrongNumberMouseUp
      end
    end
    object tbComments: TTabSheet
      Hint = 'Commentaries'
      object bwrComments: THTMLViewer
        Left = 0
        Top = 30
        Width = 282
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
        OnHotSpotClick = bwrCommentsHotSpotClick
      end
      object pnlComments: TPanel
        Left = 0
        Top = 0
        Width = 282
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          282
          30)
        object cbComments: TComboBox
          Left = 1
          Top = 3
          Width = 254
          Height = 23
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 25
          PopupMenu = pmEmpty
          TabOrder = 0
          OnChange = cbCommentsChange
          OnCloseUp = cbCommentsCloseUp
          OnDropDown = cbCommentsDropDown
        end
        object btnOnlyMeaningful: TrkGlassButton
          Left = 258
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
          Images = ilImages
          LightHeight = 27
          ParentFont = False
          TabOrder = 1
          TextAlign = taLeft
          OnClick = btnOnlyMeaningfulClick
        end
      end
    end
    object tbXRef: TTabSheet
      Hint = 'TSK'
      ImageIndex = 19
      object bwrXRef: THTMLViewer
        Left = 0
        Top = 0
        Width = 282
        Height = 270
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
    end
    object tbList: TTabSheet
      ImageIndex = 39
      object tlbTags: TToolBar
        Left = 0
        Top = 0
        Width = 282
        Height = 30
        ButtonHeight = 30
        ButtonWidth = 31
        GradientEndColor = 13684944
        Images = ilPictures24
        TabOrder = 0
        object tbtnAddNode: TToolButton
          Left = 0
          Top = 0
          Caption = 'tbtnAddNode'
          ImageIndex = 0
          OnClick = tbtnAddTagClick
        end
        object tbtnDelNode: TToolButton
          Left = 31
          Top = 0
          AutoSize = True
          Caption = 'tbtnDelNode'
          ImageIndex = 1
          OnClick = tbtnDelNodeClick
        end
      end
      object vdtTagsVerses: TVirtualDrawTree
        Left = 0
        Top = 53
        Width = 282
        Height = 217
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
        Header.FixedAreaConstraints.MinWidthPercent = 100
        Header.Height = 17
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
        OnCollapsed = vdtTagsVersesCollapsed
        OnCompareNodes = vdtTagsVersesCompareNodes
        OnCreateEditor = vdtTagsVersesCreateEditor
        OnDblClick = vdtTagsVersesDblClick
        OnDrawNode = vdtTagsVersesDrawNode
        OnEdited = vdtTagsVersesEdited
        OnEditing = vdtTagsVersesEditing
        OnGetNodeWidth = vdtTagsVersesGetNodeWidth
        OnIncrementalSearch = vdtTagsVersesIncrementalSearch
        OnMeasureItem = vdtTagsVersesMeasureItem
        OnMouseMove = vdtTagsVersesMouseMove
        OnResize = vdtTagsVersesResize
        OnShowScrollBar = vdtTagsVersesShowScrollBar
        OnStateChange = vdtTagsVersesStateChange
        Columns = <>
      end
      object cbTagsFilter: TComboBox
        Left = 0
        Top = 30
        Width = 282
        Height = 23
        Align = alTop
        BevelInner = bvSpace
        BevelOuter = bvSpace
        TabOrder = 2
        OnChange = cbTagsFilterChange
      end
    end
  end
  object tlbPanel: TGradientPanel
    Left = 0
    Top = 0
    Width = 881
    Height = 34
    Align = alTop
    BevelEdges = [beBottom]
    ParentBackground = False
    TabOrder = 3
    GradientDirection = gdVertical
    GradientStartColor = clWindow
    GradientEndColor = clBtnFace
    object lblTitle: TLabel
      AlignWithMargins = True
      Left = 578
      Top = 4
      Width = 38
      Height = 26
      Margins.Right = 7
      Align = alLeft
      Anchors = []
      Caption = 'lblTitle'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Unicode MS'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      Layout = tlCenter
      ExplicitLeft = 610
      ExplicitHeight = 15
    end
    object lblCopyRightNotice: TLabel
      AlignWithMargins = True
      Left = 626
      Top = 4
      Width = 247
      Height = 26
      Margins.Right = 7
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'CopyRight'
      Transparent = True
      Layout = tlCenter
      ExplicitLeft = 544
      ExplicitTop = 3
      ExplicitWidth = 164
      ExplicitHeight = 18
    end
    object tlbMain: TToolBar
      Left = 1
      Top = 1
      Width = 382
      Margins.Top = 2
      Margins.Bottom = 0
      Align = alLeft
      AutoSize = True
      ButtonHeight = 32
      ButtonWidth = 32
      DrawingStyle = dsGradient
      EdgeInner = esNone
      EdgeOuter = esNone
      GradientEndColor = clBtnFace
      Images = ilPictures24
      List = True
      TabOrder = 2
      object tbtnToggle: TToolButton
        Left = 0
        Top = 0
        Caption = 'Toggle'
        ImageIndex = 3
        OnClick = tbtnToggleClick
      end
      object tbtnSep01: TToolButton
        Left = 32
        Top = 0
        Width = 6
        Style = tbsSeparator
      end
      object tbtnNewForm: TToolButton
        Left = 38
        Top = 0
        Caption = 'New Form'
        ImageIndex = 14
        OnClick = tbtnNewFormClick
      end
      object tbtnNewTab: TToolButton
        Left = 70
        Top = 0
        Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1082#1083#1072#1076#1082#1091' '#1074#1080#1076#1072
        Caption = 'tbtnNewTab'
        ImageIndex = 10
        OnClick = miNewTabClick
      end
      object tbtnCloseTab: TToolButton
        Left = 102
        Top = 0
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1082#1083#1072#1076#1082#1091' '#1074#1080#1076#1072
        Caption = 'tbtnCloseTab'
        ImageIndex = 4
        OnClick = miCloseTabClick
      end
      object tbtnSep06: TToolButton
        Left = 134
        Top = 0
        Width = 6
        Style = tbsSeparator
      end
      object tbtnAddLibraryForm: TToolButton
        Left = 140
        Top = 0
        Caption = 'tbtnAddLibraryTab'
        ImageIndex = 7
        OnClick = tbtnAddLibraryTabClick
      end
      object tbtnNewMemoTab: TToolButton
        Left = 172
        Top = 0
        Caption = 'tbtnNewMemoTab'
        ImageIndex = 15
        OnClick = tbtnNewMemoTabClick
      end
      object tbtnSep04: TToolButton
        Left = 204
        Top = 0
        Width = 6
        Style = tbsSeparator
      end
      object tbtnPreview: TToolButton
        Left = 210
        Top = 0
        Caption = 'Preview'
        ImageIndex = 2
        OnClick = tbtnPreviewClick
      end
      object tbtnPrint: TToolButton
        Left = 242
        Top = 0
        Caption = 'Print'
        ImageIndex = 9
        OnClick = tbtnPrintClick
      end
      object tbtnSep05: TToolButton
        Left = 274
        Top = 0
        Width = 6
        Style = tbsSeparator
      end
      object tbtnSound: TToolButton
        Left = 280
        Top = 0
        Caption = 'Sound'
        ImageIndex = 6
        OnClick = tbtnSoundClick
      end
      object tbtnCopyright: TToolButton
        Left = 312
        Top = 0
        Caption = 'Copyright'
        ImageIndex = 8
        OnClick = tbtnCopyrightClick
      end
      object tbtnSatellite: TToolButton
        Left = 344
        Top = 0
        Caption = 'Satellite'
        ImageIndex = 5
        Style = tbsCheck
        OnClick = tbtnSatelliteClick
        OnMouseEnter = tbtnSatelliteMouseEnter
      end
      object tbtnLastSeparator: TToolButton
        Left = 376
        Top = 0
        Width = 6
        Caption = 'tbtnLastSeparator'
        Style = tbsSeparator
        Visible = False
      end
    end
    object tlbResolveLnks: TToolBar
      Left = 383
      Top = 1
      Width = 56
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alLeft
      ButtonHeight = 32
      ButtonWidth = 48
      DrawingStyle = dsGradient
      EdgeInner = esNone
      EdgeOuter = esNone
      GradientEndColor = clBtnFace
      Images = ilPictures24
      List = True
      TabOrder = 0
      ExplicitLeft = 415
      object tbtnResolveLinks: TToolButton
        AlignWithMargins = True
        Left = 0
        Top = 0
        AutoSize = True
        Caption = 'Recognize Bible Links'
        DropdownMenu = pmRecLinksOptions
        ImageIndex = 11
        Style = tbsDropDown
        OnClick = tbtnResolveLinksClick
      end
      object tbtnSpace1: TToolButton
        Left = 56
        Top = 0
        Caption = 'tbtnSpace1'
      end
      object tbtnSpace2: TToolButton
        Left = 104
        Top = 0
        Caption = 'tbtnSpace2'
      end
    end
    object tbLinksToolBar: TToolBar
      Left = 439
      Top = 1
      Width = 136
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
      ExplicitLeft = 471
      object cbLinks: TComboBox
        Left = 0
        Top = 0
        Width = 136
        Height = 23
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        Style = csDropDownList
        TabOrder = 0
        OnChange = cbLinksChange
      end
    end
  end
  object reClipboard: TRichEdit
    Left = 304
    Top = 89
    Width = 95
    Height = 129
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Unicode MS'
    Font.Style = []
    Lines.Strings = (
      'TRE')
    ParentFont = False
    TabOrder = 4
    Visible = False
    Zoom = 100
  end
  object pnlStatusBar: TPanel
    Left = 0
    Top = 334
    Width = 881
    Height = 21
    Align = alBottom
    TabOrder = 5
    object imgLoadProgress: TImage
      Tag = 1
      AlignWithMargins = True
      Left = 861
      Top = 1
      Width = 19
      Height = 19
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alRight
      Center = True
      Proportional = True
      Transparent = True
      Visible = False
      ExplicitLeft = 862
      ExplicitTop = 3
    end
  end
  object OpenDialog: TOpenDialog
    Left = 681
    Top = 321
  end
  object SaveFileDialog: TSaveDialog
    InitialDir = 'c:\'
    Options = [ofOverwritePrompt, ofHideReadOnly]
    Left = 721
    Top = 321
  end
  object PrintDialog: TPrintDialog
    FromPage = 1
    MinPage = 1
    MaxPage = 9999
    Options = [poPageNums]
    ToPage = 1
    Left = 552
    Top = 328
  end
  object ColorDialog: TColorDialog
    Left = 595
    Top = 324
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 643
    Top = 324
  end
  object pmRef: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = pmRefPopup
    Left = 550
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
    Left = 620
    Top = 163
    object miDeteleBibleTab: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = miDeteleBibleTabClick
    end
  end
  object trayIcon: TCoolTrayIcon
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
    OnClick = trayIconClick
    Left = 416
    Top = 328
  end
  object mmGeneral: TMainMenu
    AutoHotkeys = maManual
    Images = ilImages
    Left = 621
    Top = 118
    object miFile: TMenuItem
      Caption = #1060#1072#1081#1083
      object miPrint: TMenuItem
        Caption = #1055#1077#1095#1072#1090#1100
        ImageIndex = 11
        ShortCut = 122
        OnClick = tbtnPrintClick
      end
      object miPrintPreview: TMenuItem
        Caption = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088
        ImageIndex = 12
        ShortCut = 16506
        OnClick = miPrintPreviewClick
      end
      object miSave: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082'...'
        ImageIndex = 10
        ShortCut = 123
        OnClick = SaveButtonClick
      end
      object miOpen: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100'...'
        ImageIndex = 9
        ShortCut = 16507
        OnClick = OpenButtonClick
      end
      object miFileSep1: TMenuItem
        Caption = '-'
      end
      object miOptions: TMenuItem
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
        ShortCut = 16499
        OnClick = miOptionsClick
      end
      object miFileSep2: TMenuItem
        Caption = '-'
      end
      object miNewTab: TMenuItem
        Caption = #1053#1086#1074#1072#1103' '#1074#1082#1083#1072#1076#1082#1072
        ImageIndex = 30
        ShortCut = 16468
        OnClick = miNewTabClick
      end
      object miCloseTab: TMenuItem
        Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1082#1083#1072#1076#1082#1091
        ImageIndex = 31
        ShortCut = 16471
        OnClick = miCloseTabClick
      end
      object miFileSep3: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        ShortCut = 32883
        OnClick = miExitClick
      end
    end
    object miView: TMenuItem
      Caption = #1042#1080#1076
      object miColors: TMenuItem
        Caption = #1062#1074#1077#1090
        object miBGConfig: TMenuItem
          Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072' '#1086#1082#1086#1085
          OnClick = miBGConfigClick
        end
        object miHrefConfig: TMenuItem
          Caption = #1062#1074#1077#1090' '#1075#1080#1087#1077#1088#1089#1089#1099#1083#1086#1082
          OnClick = miHrefConfigClick
        end
        object miFoundTextConfig: TMenuItem
          Caption = #1062#1074#1077#1090' '#1085#1072#1081#1076#1077#1085#1085#1086#1075#1086' '#1090#1077#1082#1089#1090#1072' '#1080' '#1079#1072#1084#1077#1090#1086#1082
          OnClick = miFoundTextConfigClick
        end
        object miVerseHighlightBG: TMenuItem
          Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1093' '#1089#1090#1080#1093#1086#1074
          OnClick = miVerseHighlightBGClick
        end
      end
      object miFonts: TMenuItem
        Caption = #1064#1088#1080#1092#1090
        object miFontConfig: TMenuItem
          Caption = #1064#1088#1080#1092#1090' '#1075#1083#1072#1074#1085#1086#1075#1086' '#1086#1082#1085#1072
          OnClick = miFontConfigClick
        end
        object miRefFontConfig: TMenuItem
          Caption = #1064#1088#1080#1092#1090' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
          OnClick = miRefFontConfigClick
        end
        object miDialogFontConfig: TMenuItem
          Caption = #1064#1088#1080#1092#1090' '#1076#1080#1072#1083#1086#1075#1086#1074#1099#1093' '#1086#1082#1086#1085
          OnClick = miDialogFontConfigClick
        end
      end
      object miLanguage: TMenuItem
        Caption = #1071#1079#1099#1082' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1072
      end
    end
    object miActions: TMenuItem
      Caption = #1054#1087#1077#1088#1072#1094#1080#1080
      object miMyLibrary: TMenuItem
        Caption = 'My Librar&y'
        ImageIndex = 33
        ShortCut = 16460
        OnClick = tbtnAddLibraryTabClick
      end
      object miToggle: TMenuItem
        Caption = #1042#1082#1083'/'#1074#1099#1082#1083#1102#1095#1080#1090#1100' '#1083#1077#1074#1091#1102' '#1087#1072#1085#1077#1083#1100
        ImageIndex = 16
        ShortCut = 16496
        OnClick = tbtnToggleClick
      end
      object miOpenPassage: TMenuItem
        Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1086#1090#1088#1099#1074#1086#1082
        ImageIndex = 5
        ShortCut = 113
        OnClick = GoButtonClick
      end
      object miQuickNav: TMenuItem
        Caption = #1041#1099#1089#1090#1088#1086#1077' '#1086#1090#1082#1088#1099#1090#1080#1077' '#1086#1090#1088#1099#1074#1082#1072
        ShortCut = 16497
        OnClick = miQuickNavClick
      end
      object miSearch: TMenuItem
        Caption = #1055#1086#1080#1089#1082'...'
        ImageIndex = 1
        ShortCut = 114
        OnClick = SearchButtonClick
      end
      object miQuickSearch: TMenuItem
        Caption = #1041#1099#1089#1090#1088#1086#1077' '#1086#1090#1082#1088#1099#1090#1080#1077' '#1087#1086#1080#1089#1082#1072
        ShortCut = 16498
        OnClick = miQuickSearchClick
      end
      object miDic: TMenuItem
        Caption = #1057#1083#1086#1074#1072#1088#1080
        ImageIndex = 17
        ShortCut = 115
        OnClick = miDicClick
      end
      object miStrong: TMenuItem
        Caption = #1053#1086#1084#1077#1088#1072' '#1057#1090#1088#1086#1085#1075#1072
        ImageIndex = 18
        ShortCut = 116
        OnClick = miStrongClick
      end
      object miComments: TMenuItem
        Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080
        ImageIndex = 0
        ShortCut = 117
        OnClick = miCommentsClick
      end
      object miXref: TMenuItem
        Caption = #1055#1072#1088#1072#1083#1083#1077#1083#1100#1085#1099#1077' '#1084#1077#1089#1090#1072
        ImageIndex = 19
        ShortCut = 118
        OnClick = miXrefClick
      end
      object miNotepad: TMenuItem
        Caption = #1052#1080#1085#1080'-'#1088#1077#1076#1072#1082#1090#1086#1088
        ImageIndex = 2
        ShortCut = 119
        OnClick = miNotepadClick
      end
      object miChooseSatelliteBible: TMenuItem
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1090#1086#1088#1080#1095#1085#1099#1081' '#1074#1080#1076'...'
        ImageIndex = 3
        OnClick = miChooseSatelliteBibleClick
      end
      object miRecognizeBibleLinks: TMenuItem
        AutoCheck = True
        Caption = 'Recognize Bible Links'
        OnClick = miRecognizeBibleLinksClick
      end
      object miShowSignatures: TMenuItem
        Caption = 'Show signatures for every verse'
        OnClick = miShowSignaturesClick
      end
      object miActionsSep1: TMenuItem
        Caption = '-'
      end
      object miCopy: TMenuItem
        Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1081' '#1090#1077#1082#1089#1090
        ImageIndex = 15
        ShortCut = 16500
        OnClick = CopySelectionClick
      end
      object miCopyOptions: TMenuItem
        Caption = #1054#1087#1094#1080#1080' '#1082#1086#1087#1080#1088#1086#1074#1072#1085#1080#1103
        ShortCut = 8308
        OnClick = miCopyOptionsClick
      end
      object miActionsSep2: TMenuItem
        Caption = '-'
      end
      object miSound: TMenuItem
        Caption = #1055#1088#1086#1089#1083#1091#1096#1072#1090#1100' '#1079#1072#1087#1080#1089#1100' ('#1077#1089#1083#1080' '#1077#1089#1090#1100')'
        ImageIndex = 14
        ShortCut = 16505
        OnClick = tbtnSoundClick
      end
    end
    object miFavorites: TMenuItem
      Tag = 3333
      Caption = #1051#1102#1073#1080#1084#1099#1077' '#1084#1086#1076#1091#1083#1080
      object miHotKey: TMenuItem
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1083#1102#1073#1080#1084#1099#1077' '#1084#1086#1076#1091#1083#1080'...'
        ShortCut = 120
        OnClick = miHotkeyClick
      end
      object miFavoritesSep: TMenuItem
        Caption = '-'
      end
    end
    object miHelpMenu: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object miAbout: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = miAboutClick
      end
    end
  end
  object ilImages: TImageList
    Left = 464
    Top = 328
    Bitmap = {
      494C010133006800500410001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000D0000000010020000000000000D0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D3D3D32CD6D6D629DBDBDB24E3E3E31CD3D3D32CD6D6D629DBDBDB24E3E3
      E31CEAEAEA150000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AD9E937FAD9E937FAD9E937FAD9E
      937FAD9E937FD7CFC93E00000000000000000000000000000000D6CEC93FAD9E
      937FAD9E937FAD9E937FAD9E937FAE9E937EFDFDFD0200000000DFDFDF20D3D3
      D32CBDBAB84CCCA089C3CC9070F2C48462FFC68664FFC58563FFC98F70F0BF9B
      88B9BEBEBE41C6C6C639D3D3D32CDFDFDF200000000000000000000000000000
      000000000000D2CAC04AAB9D8793F0EFEE110000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B38361FFFFC296FFFFC296FFFFC2
      96FFFFC296FFB2A1957F00000000000000000000000000000000B2A1957FFFC2
      96FFFFC296FFFFC296FFFFC296FFB38361FF000000000000000000000000F3DF
      D54ECE9271F3D49370FFE09E79FFE3A17CFFE4A17CFFE3A07BFFDE9C78FFCF8E
      6CFFD39B7BE5F7EBE53000000000000000000000000000000000000000000000
      0000000000009D90857FE1B480FF967852E1CEC8C23F00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8A5977FB8A5977FB8A5977FB8A5
      977FB8A5977FDBD2CB3F00000000000000000000000000000000DBD2CB3FB8A5
      977FB8A5977FB8A5977FB8A5977FB8A5977F0000000000000000EED5C66ACE8F
      6CFEE19F7AFFE19E79FFDE9B77FFE09D79FFE29F7AFFE09D79FFDE9B76FFE19E
      7AFFDC9A76FFCE906EFAF6E7DE3D000000000000000000000000000000000000
      000000000000998D847FE7B78CFFDBA784FFAE845AFCA8978884FBFBFB040000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B8A5
      977FB9845FFFB89479BFB9845FFFDBD2CB3FB89479BF966847FFB89479BFB984
      5FFFDBD2CB3F00000000000000000000000000000000FAF3EF1ED29372F9E4A3
      7FFFE09D78FFE4A17DFFE8A580FFF2D0ADFFF4D8B5FFF2CFACFFE8A580FFE3A0
      7CFFDF9C78FFE0A07BFFD59B7AECFEFDFC050000000000000000000000000000
      000000000000978C847FDFAD85FFD7A37FFFCE9874FFBB8961FF96775BC8E6E1
      DE23000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DBD2CB3FDC9F
      76FFB89479BFB89479BFFFBB8EFFB8A5977FB9845FFFFFBB8EFFB9845FFFDC9F
      76FFB9845FFF00000000000000000000000000000000E5BBA4AAE1A27DFFE2A1
      7CFFE7A580FFE8A681FFE8A680FFEECDBBFFF3F3F3FFEDC7B2FFE8A580FFE8A5
      80FFE7A47FFFE2A07BFFDA9B79FFEBCAB887000000007F6245F1744B2AFF835A
      38FF866041FF886446FFD5A17BFFD09B77FFC9936FFFBE8863FFB27B55FF9468
      45F1C8B7AB5E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DBD2CB3FDC9F
      76FFDC9F76FFB9845FFFFFBB8EFFB8A5977FB9845FFFB9845FFF00000000B8A5
      977FFFBB8EFFB8A5977F000000000000000000000000DA9F7EF0E8AA86FFE7A6
      81FFE9A983FFE9A883FFE9A883FFF0D0BDFFF6F6F6FFEFC9B4FFE9A782FFE9A7
      81FFE9A681FFE5A47FFFE5A784FFE0AC8FD300000000653D1FFF8F5B38FFAE77
      52FFBE8863FFC6906CFFC9936FFFC7926DFFC28C67FFBA845EFFAE7852FF9D68
      44FF8A5936FFAA8870A6F5F3F10F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DBD2
      CB3FB89479BFB9845FFFFFBB8EFFB8A5977FB9845FFFB9845FFF00000000B8A5
      977FFFBB8EFFB8A5977F0000000000000000FCF7F316E0A37FFFE9AD89FFEBAC
      87FFEBAC86FFEBAB86FFEAAB86FFF2D3C0FFF9F9F9FFF1CCB7FFEAAA84FFEAA9
      84FFEAA984FFE9A983FFE9AC88FFDEA382F1000000006A4023FF926241FFAC7B
      57FFBB8A65FFC2906CFFC4926EFFC2906BFFBD8A65FFB57F5AFFA7724DFF9864
      40FF875532FF764524FF8B5C3BDFE8DCD4300000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009668
      47FFB9845FFFB9845FFFDC9F76FFDBD2CB3FB9845FFFFFBB8EFFB9845FFFDC9F
      76FFB89479BF000000000000000000000000FAEFE92BE5AA86FFECB38FFFECB0
      8AFFECAF8AFFECAF89FFECAE89FFF4D6C4FFFCFCFCFFF2CFBAFFEBAD88FFEBAC
      87FFEBAC87FFEBAC86FFECB08CFFE1A683FB000000007F5A3EFFAC896AFFBA95
      75FFC39E7DFFCAA381FFCCA583FFCCA483FFC9A280FFC49E7DFFBB9575FFAD85
      65FF996F50FF7E5031FF915C39DFEADDD5300000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DBD2
      CB3FB9845FFFB9845FFFDBD2CB3F00000000B9845FFFB9845FFFB8A5977FB8A5
      977F00000000000000000000000000000000FDF8F513E7AD8AFFF2BE9AFFEEB3
      8EFFEEB38EFFEEB38DFFEDB28DFFF6D9C6FFFFFFFFFFF5D2BDFFEDB08BFFECB0
      8BFFECB08AFFECAF8AFFF1BB98FFE6AC8CEF000000008A664AFFB59778FFBF9F
      80FFC6A585FFCBA989FFCDAB8AFFCDAB8AFFCBA989FFC7A686FFC2A182FFBB9C
      7DFFB38E6DFFC3987BA9F7F3F010000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B9845FFFB9845FFF000000000000
      00000000000000000000000000000000000000000000EBB597DBF5C3A0FFEFB7
      92FFEFB791FFEFB691FFEFB691FFE0A582FFDCA381FFE3A985FFEEB48FFFEEB4
      8EFFEEB38EFFEEB38EFFF3BF9DFFEDBFA4BF00000000A88A75F19B7556FF9A74
      55FF937053FF8B6B51FFD1B495FFD1B494FFD0B293FFCEB091FFCBAE8FFFBB8F
      6BF4DBBFAC630000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B89479BFB8A5977F000000000000
      00000000000000000000000000000000000000000000F4D4C185F2BE9BFFF5C3
      9EFFF1BA95FFF1BA94FFECB48FFFF6D4BDFFFEFAF7FFF5D2BAFFECB38DFFF0B8
      92FFEFB792FFF5C29DFFF0B995FFF7E3D6570000000000000000000000000000
      000000000000A895887FDAC2A4FFD9C0A1FFD8BFA0FFD2B596FFBF906ECEEEE4
      DD27000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFAF90DEEB594EFF9CB
      A9FFF3C09BFFF2BD97FFEBB48FFFFAE3D3FFFFFFFFFFF9E2D1FFEBB48EFFF1BB
      96FFF3BF99FFF7C8A6FFEFBEA0D1000000000000000000000000000000000000
      000000000000B29A8A7FE7D4B6FFE5D0B0FFCAA988FDC7A48B8EFBFAF9060000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FBEDE539F1B9
      97F9FBCFADFFF7C7A3FFF3C09AFFECB590FFEAB38DFFEAB38DFFF2BF99FFF7C7
      A3FFFBCDABFFF1BB99EDFDF5F11E000000000000000000000000000000000000
      000000000000C1A4907FEFDEC3FFBF9472E8DFCCBF4900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FCF3
      ED27F3C3A6CCF9C9A6FFFCD1AFFFFCD7B9FFFBD8BAFFFCD7B9FFFCD1AFFFF8C6
      A4FFF4CAB1B1FDF8F51500000000000000000000000000000000000000000000
      000000000000EFE8E332E5D2C590F4EFEB170000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFD03F8DFD069F3C7ADBEF3BD9AF8F4BF9CFFF3BE9DF1F4CAB0B4FAE7
      DC4E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F4CEA772E99F47F4E89944F2F9E4CE3F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F3D1
      A872E8A449F6EAA148FFF2C863FCE7A048F20000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F3D4AA72E8A9
      4EF6EAA149FFF3C56CFFFCEAA5FFEAAF56F40000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F3D7AC72E8AE54F6EAA2
      4CFFF4C871FFFCE9A4FFEBB861F5F4DBB5660000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005858
      5800585858005858580058585800000000000000000000000000000000005C5C
      5C005C5C5C005C5C5C0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FCF6EB1CE7B45AF6EAA24EFFF6CD
      78FFFCEAA6FFEABE66F5F4DFB766000000000000000000000000000000000000
      00000000000000000000D4D4D44CB2B3B38A000000000000000000000000FDFD
      FD02C2C5C477C3C5C56800000000000000000000000000000000C6C7C65ABDBF
      BF86FAFAFA05000000000000000000000000B9BBBA7FCFD1D056000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005E5E5E005E5E5E0000000000000000000000000000000000000000000000
      0000686868000000000000000000000000000000000000000000F8F8F70EC7C7
      BF729E9E91C4888878F2A1A194BFCACAC26CF5EBD440EAC167F6F7D17FFEFDEB
      A7FFEAC569F5F4E1B96600000000000000000000000000000000000000000000
      0000FAFAFA05BBC0BE8AD2DAD6F7C0C3C2A20000000000000000ECECEC1AB7BC
      B9B0DEE6E3FFC8CBC97000000000000000000000000000000000C5C7C761DFE7
      E4FFB6BBBBBCE5E5E5260000000000000000C4C8C793D4DAD7F9B9BCBB94F6F6
      F609000000000000000000000000000000000000000000000000000000000000
      0000666666006666660000000000000000000000000000000000000000000000
      00007676760000000000000000000000000000000000D3D3CD5B8C8C7CF2B7B7
      A8F8D8D8C9FDEAEADCFFD5D5C7FCB5B5A6F88B8B7CF2787878FFEBCD71F6EACA
      6CF5F3E4BA66000000000000000000000000000000000000000000000000E3E3
      E329B9BDBABFDCE4E0FFDEE5E2FFC0C4C4A700000000D0D2D050C0C6C2DCDEE6
      E2FFE0E7E4FFC5C8C87000000000000000000000000000000000C4C5C561DFE6
      E3FFDBE3E0FFC1C7C4E4CBCCCB5E00000000C4C8C796DDE5E2FFDAE2DEFFB7BB
      BAC7E0E1E1310000000000000000000000000000000000000000000000000000
      00006F6F6F006F6F6F0000000000000000000000000000000000828282000000
      000082828200000000008282820000000000F5F5F4148F8F80F2D8D8C9FCECEC
      DEFFECECDEFFECECDEFFECECDEFFECECDEFFD4D4C6FC8F8F7FF2F4EDD73EFCF9
      EF17000000000000000000000000000000000000000000000000C9CDCB62C6CD
      CAE6DCE5E1FFD9E2DEFFE4E9E7FFBFC1C1ADBDBEBD8DD0D8D4F8DBE3E0FFDBE2
      DFFFE7EBEAFFC5C5C57000000000000000000000000000000000C2C4C261E6EA
      E8FFDAE1DDFFD6DEDBFFCED8D3FCB9BCB99BC0C3C09DE5E9E7FFD8DFDBFFD7DF
      DCFFC4C9C7EBC4C7C66DFEFEFE01000000000000000000000000000000000000
      00007878780078787800000000000000000000000000000000008B8B8B008B8B
      8B008B8B8B008B8B8B008B8B8B0000000000C8C8C178BFBFB1F8EEEEE1FFEEEE
      E1FFEEEEE1FFEEEEE1FFEEEEE1FFEEEEE1FFEEEEE1FFBCBCAFF8CBCBC4720000
      0000000000000000000000000000000000000000000000000000BCBFBD80D1D6
      D5F3E3E9E7FFE9EDEBFFEBEEEDFFBDC1BFB3B9BCBC9BD8E0DCFBE5EAE7FFE9ED
      ECFFECEFEDFFC1C5C47000000000000000000000000000000000C2C2C261EAED
      ECFFECEFEDFFE6EAE8FFDCE2DFFEB7BABAAABCBEBEA2ECEFEEFFEBEEEDFFE4E9
      E7FFD3D8D6F8B7B9B98CFDFDFD02000000000000000080808000000000000000
      0000808080008080800000000000000000008080800000000000000000000000
      000000000000000000000000000000000000A0A093D8E6E6DBFEF0F0E5FFF0F0
      E5FFF0F0E5FFF0F0E5FFF0F0E5FFF0F0E5FFF0F0E5FFE4E4D9FDA3A395D30000
      000000000000000000000000000000000000000000000000000000000000D5D6
      D640BDC0BFD7E9ECEBFFF0F2F1FFC1C3C3B300000000CBCCCC5AC6CCCAE8EBEE
      EDFFF1F3F2FFC1C1C17000000000000000000000000000000000BFC2C061F0F2
      F1FFF1F3F2FFCFD2CFF0C2C5C36BFEFEFE01C1C2C29EF3F5F4FFEFF1F0FFC3C6
      C5E0CFCFCF4A000000000000000000000000000000008686860086868600CFCF
      CF008686860086868600CFCFCF00868686008686860000000000000000000000
      0000000000000000000000000000000000009A9A8CF2F2F2E8FFF2F2E8FFF2F2
      E8FFF2F2E8FFF2F2E8FFF2F2E8FFF2F2E8FFF2F2E8FFF0F0E6FF9B9B8EEC0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F1F2F110B1B3B3A4E2E5E3FDC1C4C2B70000000000000000E7E7E720B6B7
      B7BDEBEDECFFBDC0BE7000000000000000000000000000000000BFBFBF61EFF1
      F0FFB7BAB9CCDFDFDF2C0000000000000000C0C2C0A0ECEDEDFFB2B4B2AFEEEE
      EE150000000000000000000000000000000000000000CFCFCF008B8B8B008B8B
      8B008B8B8B008B8B8B008B8B8B008B8B8B00CFCFCF0000000000000000000000
      000000000000000000000000000000000000A7A79BD8EBEBE2FEF4F4ECFFF4F4
      ECFFF4F4ECFFF4F4ECFFF4F4ECFFF4F4ECFFF4F4ECFFE9E9E0FDA9A99DD30000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C3C4C45FA3A6A696000000000000000000000000FBFB
      FB04B6B7B77DB9BBBB6900000000000000000000000000000000C0C0C05AB1B3
      B28BF9F9F906000000000000000000000000ADAEAE89BBBDBB6BFEFEFE010000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CFCFC87ACCCCC2F9F6F6F0FFF6F6
      F0FFF6F6F0FFF6F6F0FFF6F6F0FFF6F6F0FFF6F6F0FFC8C8BEF8D2D2CC720000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FDFDFD020000000000000000000000000000
      000000000000FEFEFE0100000000000000000000000000000000FEFEFE010000
      000000000000000000000000000000000000FDFDFD0200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F6F6F517A6A699F2E6E6DFFCF8F8
      F3FFF8F8F3FFF8F8F3FFF8F8F3FFF8F8F3FFE3E3DCFCA5A598F2F9F9F90E0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEDED95BA9A99DF2D0D0
      C7F8ECECE6FDFAFAF5FFEBEBE5FDCDCDC4F8A8A89CF2E1E1DC53000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F8F8F714D5D5
      CF78B8B8AECAAAAA9EF2B9B9AFC7D8D8D26FFBFBFA0B00000000000000000000
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
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6946B00C6946B00C6946B00C6946B00C6946B00000000000000
      0000000000000000000000000000000000003194DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C67B4A00E5CF
      B700EBD6C000F1DDC900F8E5D300C67B4A00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0071310900C26E3900E1BFA600DEBDA700CD916F00B66031007A25
      0000210A00000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C694
      6B00D6BD9C00D3C5B100FFF4ED00FFF4ED00FFF4ED00D3C5B100D6BD9C00C694
      6B00000000000000000000000000000000003594DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C6734200E5CF
      B700EBD6C000F1DDC900F8E5D300C6734200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000BB622700D8AF9800CEADA500D6BAB300CFACA300CFA59700D299
      7A00C37143008F350A004F180000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6946B00D6BD
      9C00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00D6BD
      9C00C6946B000000000000000000000000003995DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C67B4200E5CF
      B700EBD6C000F1DDC900F8E5D300C67B4200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00B3591B00D9A58200D6B6AD00DCC5BF00ECDFDC00E5D2CE00E1C8C300CFA5
      9900CA9B8E00D7A58B00CD835700A14315000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6BD9C00FFF4
      ED00FFF4ED00F7E7DC00C6946B00C6946B00C6946B00E8CEBA00FFF4ED00FFF4
      ED00D6BD9C00000000000000000000000000399ADE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C6844200E5CF
      B700EBD6C000F1DDC900F8E5D300C6844200FFFFFF00FFFFFF00FFFFFF00B65E
      1C00DA9D6B00CFA59800E9D7D300E4D0CD00EDE1E100E3CDC800ECE0DF00EEE2
      E200E4CEC900D2AAA000D9AC9400AD4F1F000000000000000000000000000000
      00009F9F9F009F9F9F00000000000000000000000000000000009F9F9F009F9F
      9F000000000000000000000000000000000000000000C6946B00D3C5B100FFF4
      ED00F7E7DC00C6946B00F0DBCC00FFF4ED00FFF4ED00C6946B00F0DBCC00FFF4
      ED00D3C5B100C6946B00000000000000000039A0DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C6844A00E5CF
      B700EBD6C000F1DDC900F8E5D300C6844A00FFFFFF00FFFFFF00FFFFFF00CC79
      3500D9B19E00E5CDC700E4CFC900F0E6E600EDE1E100EFE3E300DFC4BE00EDE1
      E100ECDFDF00DBBCB500D89C7600872900000000000000000000000000000000
      00009F9F9F009F9F9F009F9F9F0000000000000000009F9F9F009F9F9F009F9F
      9F000000000000000000000000000000000000000000C6946B00FFF4ED00FFF4
      ED00E8CEBA00D6AF8F00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4
      ED00FFF4ED00C6946B00000000000000000039A6DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900C6844A00E5CF
      B700EBD6C000F1DDC900F8E5D300C6844A00FFFFFF00FFFFFF00AD612000DB9C
      6500D2AA9F00F7F0EF00E1C9C300F3EAEA00EFE4E400ECDFDF00E9D7D300E6D3
      D000EDE1E000D1A69700C5713E00401300000000000000000000000000000000
      0000000000009F9F9F009F9F9F009F9F9F009F9F9F009F9F9F009F9F9F000000
      00000000000000000000000000000000000000000000C6946B00FFF4ED00FFF4
      ED00E8CEBA00DFBFA600FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4
      ED00FFF4ED00C6946B00000000000000000039ABDE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900CE8C4A00E5CF
      B700EBD6C000F1DDC900F8E5D300CE8C4A00FFFFFF00FFFFFF00CA742700DCAE
      8E00E0C4BC00EAD8D400F1E6E400F5EEEE00F1E8E800EDE1E100F2E9E900DEC1
      BB00E3CDC800DAAA8C009D3D0C00000000000000000000000000000000000000
      000000000000000000009F9F9F009F9F9F009F9F9F009F9F9F00000000000000
      00000000000000000000000000000000000000000000C6946B00FFF4ED00FFF4
      ED00E8CEBA00D6AF8F00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4
      ED00FFF4ED00C6946B00000000000000000039ADDE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900CE8C4A00E5CF
      B700EBD6C000F1DDC900F8E5D300CE8C4A00FFFFFF0000000000DE9A5600D4AB
      9E00EFE0DD00E3CBC500FAF7F700F7F1F100F3EBEB00EFE5E500E9D7D400EADA
      D800D6B2A900D48F6000752C0600FFFFFF000000000000000000000000000000
      000000000000000000009F9F9F009F9F9F009F9F9F009F9F9F00000000000000
      00000000000000000000000000000000000000000000C6946B00D3C5B100FFF4
      ED00FFF4ED00C6946B00F0DBCC00FFF4ED00F7E7DC00C6946B00F7E7DC00FFF4
      ED00D3C5B100C6946B0000000000000000003AADDE0034B9E50034B9E50063C6
      E70096DFF70052AD5A0052AD5A0052AD5A006BB5730094D39A00CE8C5200CE94
      5200CE945200D6AD7B00EFCEBD00CE8C5200FFFFFF00CA7C2D00E1AE8000D5B1
      A700F5EDEB00EAD8D300FCFBFB00F9F4F400F5EEEE00F2EAEA00E3CCC600EFE3
      E200D4A79300BA632B0000000000FFFFFF000000000000000000000000000000
      0000000000009F9F9F009F9F9F009F9F9F009F9F9F009F9F9F009F9F9F000000
      0000000000000000000000000000000000000000000000000000D6BD9C00FFF4
      ED00FFF4ED00F7E7DC00C6946B00C6946B00C6946B00F0DBCC00FFF4ED00FFF4
      ED00D6BD9C0000000000000000000000000040ADDE0034B9E50034B9E50063C6
      E70096DFF70052AD5A0052AD5A0052AD5A006BB5730094D39A00CE8C5200CE94
      5200CE945200D6AD7B00EFCEBD00CE8C5200FFFFFF00DE944300DAB39E00E6CF
      C900D0B1A800E8D5D000FEFEFE00FBF8F800F7F2F200F4ECEB00E4CDC800E0C6
      C000DAA47F0098420E0000000000FFFFFF000000000000000000000000000000
      00009F9F9F009F9F9F009F9F9F0000000000000000009F9F9F009F9F9F009F9F
      9F00000000000000000000000000000000000000000000000000C6946B00D6BD
      9C00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00FFF4ED00D6BD
      9C00C6946B0000000000000000000000000042B1DE0034B9E50034B9E50063C6
      E70096DFF70052AD5A0052AD5A0052AD5A006BB5730094D39A00CE8C5200CE94
      5200CE945200D6AD7B00EFCEBD00CE8C5200C07D2F00E9B27400D3ACA000D6B8
      B0005B453F00CFA69B00F9F3F200FDFBFB00F9F5F500E7D2CD00F5EEED00D1A7
      9A00D48B530053250900FFFFFF00FFFFFF000000000000000000000000000000
      00009F9F9F009F9F9F00000000000000000000000000000000009F9F9F009F9F
      9F0000000000000000000000000000000000000000000000000000000000C694
      6B00D6BD9C00D3C5B100FFF4ED00FFF4ED00FFF4ED00D3C5B100D6BD9C00C694
      6B000000000000000000000000000000000040B5DE0034B9E50034B9E50063C6
      E70096DFF70052AD5A0052AD5A0052AD5A006BB5730094D39A00CE8C5200CE94
      5200CE945200D6AD7B00EFCEBD00CE8C5200DB8F3600DFB49200CB9E9200926F
      6600FFFFFF00C9998C00DCBDB500FEFEFE00FCFAFA00CEAEA500DCBFB700D79B
      7000B55F210000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6946B00C6946B00C6946B00C6946B00C6946B00000000000000
      0000000000000000000000000000000000003AB5DE0093D2FF00A9DBFF00BFE4
      FF00D6EEFF0052AD5A00B5E2BD00B5E2BD00CDEBD300E6F5E900CE945A00E5CF
      B700EBD6C000F1DDC900F8E5D300CE945A00E2963D00C6947800BE9084000000
      0000FFFFFF00FFFFFF00C7978A00EDDEDA00F2E6E30088675E00FFFFFF00C363
      1D00B25A1900FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000049BDE20093D2FF00A9DBFF00BFE4
      FF00D6EEFF0068C67300B5E2BD00B5E2BD00CDEBD300E6F5E900D6A57300E5CF
      B700EBD6C000F1DDC900F8E5D300D6A57300DE90370000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00D1A99F00D6B9B10000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005BC3E5005CC6E70063C6E70063C6
      E70063C6E700ACE2B2007BC6840052AD5A006BB5730063B56B00EFCEBD00D6AD
      7B00CE945200CE945200D6AD7B00EFCEBD00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C5968900C1938600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
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
      2800000040000000D00000000100010000000000800600000000000000000000
      000000000000000000000000FFFFFF00FFFFF007FFFF000003C04000F8FF0000
      03C0E003F87F000003C0C001F81F0000E0078000F80F0000C007800080070000
      C023800080010000E023000080000000E007000080000000E10F000080010000
      FF3F800080070000FF3F8000F80F0000FFFF8001F81F0000FFFFC001F87F0000
      FFFFE003F8FF0000FFFFF00FFFFF0000FFF0FFFFFFFFFFFFFFE0FFFFFFFFFFFF
      FFC0FFFFFFFFFFFFFF80FFFFFFFFE1E3FF01FCE3C73FF3F7C003F0C3C30FF3F7
      8007E083C107F3D5000FC003C001F3C1001FC003C001B37F001FE083C007807F
      001FF0C3C30F807F001FFCE3C71FFFFF001FFEFBDF7FFFFF001FFFFFFFFFFFFF
      803FFFFFFFFFFFFFC07FFFFFFFFFFFFFFFFF81FF81FF81FFFFFF00FF00FF00FF
      C7FF007F007F007F83FF183F183F183F99FF1C3F103F103F90FF0E3F003F003F
      C87F070700070007E43F838380038003C21FC1C1C001C001E10FE0E0E000E000
      F027FC60FC00FC00F867FC18FC18FC18FCE7FC18FC18FC18FE0FFE00FE00FE00
      FF1FFF00FF00FF00FFFFFF83FF83FF83FFFF8003FFFF8001F00F8001F81FBFFD
      F00F8000F007A005F00F8000E203A00580018000C013A00580018001C091A005
      80018003D199A0058001800391F9A0058001800391F9A00580018003C091A001
      80018003C813A00080018003C403A000F00F8003E187A000F00F8003F00FA000
      F00F8003FFFF8000FFFF8003FFFFC000FFFF00000000FFFFF83F00000000FFFF
      E00F00000000FFFFC00700000000FFFFC00700000000F3CF800300000000F18F
      800300000000F81F800300000000FC3F800300000000FC3F800300000000F81F
      C00700000000F18FC00700000000F3CFE00F00000000FFFFF83F00000000FFFF
      FFFF00000000FFFFFFFF00000000FFFFFFFFFFFFFFC1FFC1FFFFF801FF80FF80
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
  object appEvents: TApplicationEvents
    OnException = appEventsException
    Left = 691
    Top = 115
  end
  object ilPictures24: TImageList
    Height = 24
    Width = 24
    Left = 506
    Top = 329
    Bitmap = {
      494C01011000E8014C0218001800FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      00000000000036000000280000006000000078000000010020000000000000B4
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B9B8
      B3008581790066615700655F5500827F7600B9B7B20000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F0F0F000656E
      73002B39400023363F0028373E00545F6400E2E2E20000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D5D3
      D00077736A005651460055504500544E4300534E4300524C4100514B40004F4A
      3F004F493E004D473C004C473B004B453A004A44390049433700484236004641
      350046403400443E32006B665D00D3D1CE00000000000000000000000000B8AD
      A1006D563E007C6751007C6751007C6751007C6751007C6751007C6751007C67
      51007C6751007C6751007C6751007C6751007C6751007C6751007C6751007C67
      5100624A3000DED9D400000000000000000000000000EDECEB00827D76007672
      6A00AEADA900C6C6C500C5C5C400ABABA700706B63007C776F00EAE9E7000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C3C4C4001E2F3700418F
      B20059C9FC004FC7FF003EC0FE002994C6001F323B009CA1A300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007874
      6C00D0CFCC00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00CAC9C5006B665D00000000000000000000000000B8AD
      A100C3BAB000FAFDFF00F5FBFF00F5FBFF00F5FBFF00F5FBFF00F5FBFF00F5FB
      FF00F5FBFF00F5FBFF00F5FBFF00F5FBFF00F5FBFF00F5FBFF00F5FBFF00FCFE
      FF0097877600DED9D400000000000000000000000000837F780094928C00C4C3
      C20085827C0068645A0067625800827E7800C2C1BF0093908B0065605600E7E7
      E5000000000000000000000000000000000000000000746F6600000000000000
      000000000000000000000000000000000000F0F0F0002631360059BFED0060CD
      FF005ECAFB004696BB005CC3F3004CC6FF0034BAF900204455008F9396000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005A54
      4A00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00433D3100000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBF
      FD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD00D7EF
      FE0097877600DED9D4000000000000000000BBB9B4007A766E00C4C3C3006662
      5800928F8800D5D4D100D5D4D200908D86005F5B5100B3B3B00099979300655F
      5600E8E7E6000000000000000000000000000000000047413600000000000000
      0000000000000000000000000000000000006A707300468FB10060CDFF004587
      A5002D3A400071797C00354248003462770058C8FC0035BBFB00204455008F93
      9600000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D4D2CF007A766D005B564C005A54
      4A0059544900575248005751470055504500554F4400534E4300524D4200514B
      4000504B3F004F493E004E483D004C473B004C463B004A443900494438006F6A
      6100D4D2CF00FFFFFF00FFFFFF00433E3200000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBF
      FD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD00D7EF
      FE0097877600DED9D400000000000000000089857D00B1B0AD0087837D009491
      8A00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CCCAC7005E584F00B4B2B0009A97
      9200635F5400E7E7E50000000000000000000000000048423600000000000000
      0000000000000000000000000000000000002E393D005ECAFB005ECAFB002D3A
      4000FEFEFE00FFFFFF00FFFFFF008E9395002B4C5B0058C9FC0035BBFB002044
      55008F9396000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007C776F00D1D1CD00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CCCB
      C7006E696000FFFFFF00FFFFFF00443E3200000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD005EBFFD005EBFFD005EBDFA005A95B7005EBF
      FD005A95B7005EBFFD005A95B7005EBFFD005EBFFD005EBFFD005EBFFD00D7EF
      FE0097877600DED9D40000000000000000006E696000C9C9C8006B665D00D9D8
      D600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CCCAC7005D584F00B5B3
      B1009A989400635E5300E7E7E500000000000000000074706700000000000000
      0000000000000000000000000000000000002432380060CDFF00499CC2007179
      7C00FFFFFF00FFFFFF00FFFFFF00FFFFFF008A8F91003761740054C5FD0061BD
      F1003A647C00F3FAFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005E594F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0048423600FFFFFF00FFFFFF00453F3300000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD005EBFFD005EBFFD005EBEFB005B9CC2005EBF
      FD005B9CC2005EBFFD005B9CC2005EBFFD005EBFFD005EBFFD005EBFFD00D7EF
      FE0097877600DED9D40000000000000000006F6A6100C9C9C8006B675E00DAD9
      D700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CBC9C6005D58
      4F00B4B3B1009B989300635E5400EBEAE8000000000000000000746F67004640
      3400443E3200726D640000000000000000002B363B0060CCFE005DC7F700303C
      4200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DDE7EC003F91B8002160
      7F001E5A7E003F81A700E9F1F400000000000000000000000000000000000000
      0000000000000000000000000000000000005F5A5000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0049433700FFFFFF00FFFFFF00453F33000000000000000000F7F6F4008D7B
      68006D563E006F625200625D5200625D5200625D5200625D5200625D5200625D
      5200625D5200625D5200625D5200625D5200625D5200625D5200625D52007665
      5200624A2F006D593A0088785F00F0EEEB008B877F00B2B1AE0088857E009692
      8C00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D5D3D0006864
      5A00524D42005A554B00514C4200726E6400FBFBFB0000000000000000000000
      0000000000000000000000000000000000005B6367004A9CC20060CDFF003764
      780081868800FFFFFF00FFFFFF00FFFFFF00C2C2C200302E28005C533A007E6F
      45007C6A3A00524C300020292B00B7BCBF000000000000000000000000000000
      000000000000000000000000000000000000605B5000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0049433700FFFFFF00FFFFFF004640340000000000C1B8AD00735D4600BEB3
      A900FAF9F800FAF9F800FAF9F800FAF9F800FAF9F800FAF9F800FAF9F800FAF9
      F800FAF9F800FAF9F800FAF9F800FAF9F800FAF9F800FAF9F800FAF9F800FAF9
      F8008D8064008EA24400848D4000B0A69600BBB9B5007D797100C6C5C4006A66
      5C00CCCBC700FFFFFF00FFFFFF00FFFFFF00F0F0EF008A857E0067635A009996
      9100C3C2C100B1B0AD0094918C006E6A6200736E6400EAE9E700000000000000
      000000000000000000000000000000000000E5E5E500253339005DC7F7005FCB
      FC002D4D5C0084898B00FFFFFF00C0C0C00036342C00A79F7D00B5AC8800B5AC
      8800B6AC8700B19E6700A1894B003A3729009B9A980000000000000000000000
      000000000000000000000000000000000000605B5000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0049443800FFFFFF00FFFFFF0046413500E9E6E20077624B009A8B7A00F7F6
      F400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008F82670090A5450089984000A89D89000000000086817A009D9B9600BAB8
      B50069645B00CCCAC700FFFFFF00FFFFFF00E3E2E0005F5A5000A5A39F008C89
      8300625C530069645B007F7C7500C1C0C000928F8A00615C5200E7E7E5000000
      00000000000000000000000000000000000000000000A3A7A800294450005EC9
      FA005FCBFD002E4E5D00818587002D2C2800A39B7B00B4AB87007F7960003F3D
      35003F3D35007F796000B4A67A00AC935100413A29009B9A9700000000000000
      000000000000000000000000000000000000605B5100FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004A443900FFFFFF00FFFFFF004641350000000000FEFEFE00BFB5AB00755F
      4800978776009084760089827600898276008982760089827600898276008982
      7600898276008982760089827600898276008982760089827600898276009486
      76006B553A00716837006D5D3800D4CDC50000000000EAE9E700736E6500A2A0
      9B00B9B8B50068635A00CDCBC800FFFFFF00FFFFFF00CFCECA006D685E00A19E
      9700EBEAE800E0DFDE00A8A5A0005C564D00B1AFAD0095938E005F5B5000E7E7
      E500000000000000000000000000000000000000000000000000979B9D002A45
      51005EC9FA005FCBFD002E4F5E0043433A00B5AC8800696452006A6A6800ECEC
      EC00ECECEC007776740044463E00B4A67A00AC9351003F3928009B9A97000000
      000000000000000000000000000000000000615C5200FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004B453A00FFFFFF00FFFFFF0047413600000000000000000000000000B8AD
      A100B1A598009FC4DA005CAAD9005CAAD9005CAAD9005CAAD9005CAAD9005CAA
      D9005CAAD9005CAAD9005CAAD9005CAAD9005CAAD9005CAAD9005CAAD900C2D2
      DA008D7B6800C8C0B700F2F0EE00000000000000000000000000E8E8E600726E
      6400A1A09B00B9B7B50068635900CCCAC800FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CBC9C6005A544A00B1AFAC0094928D005F5A
      4F00E7E7E500000000000000000000000000000000000000000000000000979B
      9D002A4552005EC9FA005FCBFD00294A560062625100AFAB9C00FDFDFD00FFFF
      FF00FFFFFF00FFFFFF005C7D8A003E433C00B4A67A00AC9250003F3928009B9A
      970000000000000000000000000000000000625D5300FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004B453A00FFFFFF00FFFFFF0048423600000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBF
      FD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD00D7EF
      FE0097877600DED9D4000000000000000000000000000000000000000000E7E7
      E600716D6400A19F9A00B9B7B40066615800CCCAC700FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CBC9C60059534800B0AEAB009492
      8C005E594F00E7E7E50000000000000000000000000000000000000000000000
      0000989B9D002B4753005EC9FA005FCBFD002A4B580070726800FFFFFF00FFFF
      FF00FFFFFF00FDFDFD007DB6D00038728D0036413F00B4A67B00AC9250003E37
      26009A999600000000000000000000000000625D5300FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004C463B00FFFFFF00FFFFFF0048423600000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD00555B57005458510054585100545851005458
      5100545851005458510054585100545851005458510057727C005EBFFD00D7EF
      FE0097877600DED9D40000000000000000000000000000000000000000000000
      0000E7E7E500726D6400A19F9A00B8B6B40066615900ABA8A200E1E0DE00EAE9
      E700A09E97006B665C00D0CFCB00FFFFFF00FFFFFF00CBC9C60058524800B0AE
      AB0093918C005D594E00EAE9E700000000000000000000000000000000000000
      000000000000989B9D002B4754005ECAFB005FCBFD002B4B58006F747500ECEC
      EC00ECECEC00666C6E0038738F0060CDFF0021495B0045423700B4A67A00AC92
      50003E3726009A9996000000000000000000635E5400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004C473B00FFFFFF00FFFFFF0049433700000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBF
      FD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD00D7EF
      FE0097877600DED9D40000000000000000000000000000000000000000000000
      000000000000E7E7E500716D63009C9A9500C6C5C50087847E00706B62006661
      58008E8A8500A4A39F005B574C00E3E2E000FFFFFF00FFFFFF00CBC9C6005751
      4700B0AEAB008D8A840076716900000000000000000000000000000000000000
      00000000000000000000989B9D002C4854005ECAFB0060CCFE00458FB1002D43
      4C002D434D00458FB20060CCFE0057B9E600202E34008483820045423700B3A5
      7A00AC9250003C362500A5A5A30000000000635E5500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004C473B00FFFFFF00FFFFFF0049443800000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD00598CA900598BA700598BA700598BA700598B
      A700598BA7005A90AF005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD00D7EF
      FE0097877600DED9D40000000000000000000000000000000000000000000000
      00000000000000000000EBEAE8007D7970007A776F009C999400B5B4B200C5C4
      C3009B98940068635A0089847D00F0F0EF00FFFFFF00FFFFFF00FFFFFF00CBC9
      C60056524700BDBCBB0066615800B7B5B0000000000000000000000000000000
      0000000000000000000000000000999C9D00273F480058BDEB0060CDFF0060CD
      FF0060CDFF0060CDFF0058BDEB00263D4700C2C3C300FFFFFF00888886004542
      3700B4A67A00AA904E002F2B2300E5E5E500635E5500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004D473C00FFFFFF00FFFFFF004A443900000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD005989A4005987A0005987A0005987A0005987
      A0005987A000598CA9005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD00D7EF
      FE0097877600DED9D40000000000000000000000000000000000000000000000
      0000000000000000000000000000FBFBFB007D786F005F5A5000666259005B56
      4C006C685E00D4D2CF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008E8A830077736C00A5A4A0007C786F000000000000000000000000000000
      000000000000000000000000000000000000BEBEBD00232D2E0035657A004492
      B5004492B500386980002A363B00C2C3C300FFFFFF00FFFFFF00FFFFFF008584
      830059554500B2A16E0085723F00615F5A00645F5500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004E483D004C473B004C463B004A443900000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBF
      FD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD00D7EF
      FE0097877600DED9D40000000000000000000000000000000000000000008682
      7A0066615700645F5500847F7700FFFFFF00EAE9E7006E6A60009E9D9700B7B5
      B200635D5400CCCAC700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00D9D8D60057534800C1C1C000595348000000000000000000000000000000
      00000000000000000000000000000000000000000000F3F2F0008F8A75005C5D
      4E005C5D4E008E887300E7E7E400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF003A393500AFA78400AF995C0033312A0065605600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004F493E007E746B007B7067004B453A00000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD005457500054544A0054544A0054544A005454
      4A0054544A0054544A0054544A0054544A0054544A00566E77005EBFFD00D7EF
      FE0097877600DED9D40000000000000000000000000000000000000000000000
      0000000000000000000000000000827E760000000000E8E8E6006D695F009E9C
      9700B6B5B200625D5300CBC9C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00D9D8D60058534900C1C1C000595349000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FAFAF8006763
      5400B2A98600B5AC8800585547008E8D8C00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00777774008A836700B3A372002E2B220065605600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004F493E0080776E007E736A004C463B00000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBF
      FD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD00D7EF
      FE0097877600DED9D40000000000000000000000000000000000000000000000
      0000000000000000000000000000625D53000000000000000000E7E7E6006D68
      5F009D9C9700B6B4B200615C5200CCCAC700FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008E8A840079756D00A6A5A2007D7970000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009393
      9200423F3600B2A98600B3AA86004543380091918F00FFFFFF00FFFFFF00FEFE
      FE0037363100B2A98600B2A67E0036332D006661570065605600635E5500635E
      5400615C5200605B51005F5A50005E594F005D584D005C574C005A554B005A54
      4A00585348005752480056514600554F4400544E4300524D4200524C4100504B
      3F004F4A3F008279700072685F00706B6300000000000000000000000000B8AD
      A100C3BAB000AEDFFE005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBF
      FD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD005EBFFD00D7EF
      FE0097877600DED9D40000000000000000000000000000000000000000000000
      0000000000000000000000000000635E5400000000000000000000000000E7E7
      E5006C685E009D9B9600B6B4B100615C52008F8C8500D5D4D100D4D4D1008E8B
      84005A554A00BEBDBC0069645C00B7B5B0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000093939200423F3600B2A98600B3AA8600595647003F3E3A00777774003736
      320078735D00B5AC88007E775B006E6D690066615800B2ACA600AFA9A400ADA6
      A000AAA49E00A8A09B00A59E9700A29B9400A09892009D958E009A938C00978F
      8700958D8500918981008E867E008B827A0089807700857B7200827870007E74
      6B00504B3F004F493E00716C6400D3D1CE00000000000000000000000000B8AD
      A100C3BAB000CCEBFE009AD7FE009AD7FE009AD7FE009AD7FE009AD7FE009AD7
      FE009AD7FE009AD7FE009AD7FE009AD7FE009AD7FE009AD7FE009AD7FE00E6F5
      FF0097877600DED9D40000000000000000000000000000000000000000000000
      0000000000000000000000000000848078000000000000000000000000000000
      0000E7E7E5006B675D0097958F00C3C2C000817E7700635F5500625D53007E7A
      7400C0BFBD008A87810078746C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000093939200423F3600B1A88500B5AC8800ACA48200857E6400B2A9
      8600B5AC8800A89F7E002C292300F0F0F00067625900B4ADA8008A857D00AFA8
      A30087817900AAA29D00847E7500A49D9700A19A93009F9791009B948D009991
      8A00968F8600938B8300918980008D857C008A827900877E7500847B71008177
      6E00504B3F00000000000000000000000000000000000000000000000000B8AD
      A100C3BAB000E1DCD700DCD6D00000000000EFECE900CBC3BA00000000000000
      0000BDB3A8000000000000000000BBB0A5000000000000000000C6BDB300F7F6
      F40097877600DED9D40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EBEAE800807C7400746F6700ACABA700C4C4C300C4C4C300AAA9
      A5006D6860007A756E00ECEBEA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A1A09F00302E2A008A846800B4AB8700B5AC8800B2A9
      86007C765E002E2D2900C4C4C40000000000817D7600A39C9700B3ADA800B0AA
      A500ADA7A100ABA49F00A9A29C00A6A09900A39B9500A19993009E9790009B94
      8D0098908900968D8500928A820090877F008C837C0089807800867D7400766D
      6400746F6600000000000000000000000000000000000000000000000000BBB0
      A50068513800664E3400644C3200715B43006B553C005E452A00715B4300715B
      4300583E2200715B4300715B4300583E2200715B4300715B43005B422700735D
      460067503600E0DCD60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B9B7B30083807700645F5500635D5300817D
      7500B8B6B1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E2E2E2005F5E5B0033322E002F2E29003635
      32006E6D6A00F0F0F0000000000000000000D5D3D000817D750066615700645F
      5500635E5500625D5300615C5200605B50005F5A50005D584E005D584D005B56
      4C005A554B0059544900585348005751470056514600554F4400544E4300746F
      6700D4D2CF000000000000000000000000000000000000000000000000000000
      000000000000C3BAB000B3A79A0000000000E4DFDB0097877600000000000000
      000077614B0000000000000000007C68520000000000000000008C7B6700E9E6
      E200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000EDEDED00C3C2C00099979400716E6A004743
      3E0047433E00716E6A0099979400C3C2C000EDEDED0000000000000000000000
      0000000000000000000000000000000000000000000000000000E1E0DE007E7A
      72005A544A00585348005751470055504500544E4300524D4200514B4000504B
      3F004F493E004D473C004C463B004A443900494337004741360046403400453F
      3300706C6300E1E0DE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F1F0F00096938C006B665D004F493F006A65
      5B0094918A00F1F0F0000000000000000000000000000000000000000000BAB8
      B3008581790065605600645F5500817E7500B8B6B20000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FBFBFB009997940037332D0035312C0055514C007D7A7600A5A3
      A000A5A3A0007D7A760055514C0035312C0037332D0099979400FBFBFB000000
      0000000000000000000000000000000000000000000000000000918E8700928E
      8700EFEFEE00F0EFEE00F0EFEE00F0EFEE00F0EFEE00F0EFEE00E8E7E600E7E6
      E500E8E7E600E8E7E600E8E7E600EAE9E800EBEAE900ECEBEA00EBEAEA00ECEC
      EB00827F770087837C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D4D2CF005B574B0049795200489F630047AF6A00469E
      610044764D0055514500D3D1CE000000000000000000ECEBEA00827E77007772
      6B00AEADA900C6C6C500C5C5C400ABAAA6006F6A62007A766E00EAE9E7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D9D8D700595550003D3A3400AEADAA00F7F7F700FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00F7F7F700AEADAA003D3A340059555000D9D8
      D7000000000000000000000000000000000000000000000000008D888100B1AF
      AA00FFFFFF00FFFFFF00DEDDDB0077726A0075706700726D6400706B63006E6B
      6100827F7700F5F5F400F7F7F700F7F7F700F9F9F900FAFAFA00FBFBFB00FCFC
      FC00A6A39E00817C74000000000000000000D5D3D00079756D005A544A005954
      4900575248005751470055504500554F4400534E4300524C4100514B40004F4A
      3F004F493E004D473C004C493C004B9B630049B66F0049B66E0047B56D0046B5
      6D0045B46B0044975D0055514500F1F0F00000000000847F780095938D00C5C4
      C20085827B0065615700635F5500817E7600C1C0BE00928F8A00635F5400E7E7
      E500000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AAA9
      A60037332D0065625D00E5E5E400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E5E5E40065625D003733
      2D00AAA9A6000000000000000000000000000000000000000000CBC9C6006E6A
      6000FCFCFC00FFFFFF00FCFCFC00D1CFCC00C8C6C300C4C3C000C5C3C000C5C3
      C100D4D4D100F5F5F500F6F6F600F6F6F600F7F7F700F9F9F900FAFAFA00F8F8
      F80059544900CAC8C50000000000000000007B766E00D1D0CD00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF009B9891004C7C55004CB771004AB66F0049B66F00485E440046B5
      6D0046B46C0044B46B0043754C0094918A00BBB9B4007B776F00C5C4C3006763
      580092908800D5D4D100D5D4D200908D86005E594F00B3B2B00098969200635E
      5400E9E8E7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D9D8D7003733
      2D0094928F00FDFDFD00FFFFFF00FFFFFF00FFFFFF00FCFCFC00D9D9D800AFAD
      AB00908E8A00AAA9A600CDCCCB00F4F4F300FFFFFF00FFFFFF00FDFDFD009492
      8F0037332D00D9D8D7000000000000000000FAFAF900C1BFBB0094918A005E5A
      5000C5C3C000FFFFFF00FFFFFF00E5E4E300928F89008F8B84008E8B84008E8A
      84008D8983008D8982008C8981008F8C8500E6E5E400F7F7F700F9F9F900BCBA
      B600474236008A867F00BDBBB700FAFAF9005D584E00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00726D64004DA267004CB771004BB7700049B66F004943370047B5
      6D0046B56D0045B46B00439D5F0069645A008B877F00B2B1AE0088847E009591
      8B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CCCAC7005D584F00B3B2B0009996
      9100615C5200E8E8E60000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FBFBFB00595550006562
      5D00FDFDFD00FFFFFF00FFFFFF00FFFFFF00D1D1CF004D494400332F2900332F
      2900332F2900332F2900332F29003F3B3600B2B1AE00FFFFFF00FFFFFF00FDFD
      FD0065625D0059555000FBFBFB00000000009C999300696357006F685A006962
      56007E7A7100FFFFFF00F1F1F100E6E6E600AAA7A300A6A49F00A7A49E00A7A4
      9F00A6A39F00A6A39E00A5A39E00A9A7A200EFEFEE00F6F6F600F7F7F7006D69
      5F00514A3C00564E3D004A433600918E87005E594F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00575147004EB270004CB771004C6148004A443900494438004842
      3600465D430046B46C0044AE68004C463C00716C6200C9C9C9006C685F00DAD9
      D700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CBC9C6005C574E00B4B2
      B00099979200625D5200E7E7E500000000000000000000000000000000000000
      00000000000000000000000000000000000000000000999794003D3A3400E5E5
      E400FFFFFF00FFFFFF00FFFFFF00A5A3A00036322C00332F2900332F2900332F
      2900332F2900332F2900332F2900332F29003F3B3600F9F8F800FFFFFF00FFFF
      FF00E5E5E4003D3A3400999794000000000069655B00878072007D756300746D
      5D005D584E00A4A09B00ABA9A400ABA8A300ABA8A300AAA8A200AAA7A300AAA7
      A200A9A7A200A9A7A100A9A6A000A8A6A000A8A5A000A9A6A0009B9892004943
      37005B534100655B4700615744004D483C005F5A5000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00736E65004FA369004DB772004CB771004BB770004944380049B6
      6E0047B56D0046B56D00459E610069645A00726D6400CACAC9006D696000D9D8
      D600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CBC9C6005C56
      4D00B4B3B00099979200615C5200EAE9E7000000000000000000000000000000
      000000000000000000000000000000000000EDEDED0037332D00AEADAA00FFFF
      FF00FFFFFF00FFFFFF00D9D8D70035312C00332F2900332F290045413B008381
      7D00A1A09D007E7C78004E4B4600332F290054504B00FEFEFE00FFFFFF00FFFF
      FF00FFFFFF00AEADAA0037332D00EDEDED00635E55008B8475007E756400746C
      5D00696256006861540066605300655E5100645D4F00625B4E00625A4D006059
      4C005F584A005D5648005C5547005B534500595244005850420057504100564E
      40005F564500685E4900635A4600433E32005F5A5000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF009C9993004F7D57004EB872004CB771004CB771004A60460049B6
      6E0048B56E0046B56D0046774F0094918A008C898100B3B2AF008A8780009692
      8C00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D4D2CF006863
      5900514B4000585348004F4A3F00716C6200FBFBFB0000000000000000000000
      000000000000000000000000000000000000C3C2C00035312C00F7F7F700FFFF
      FF00FFFFFF00FEFEFE00615E5A00332F2900332F290059555000E9E9E800FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00E2E2E100FBFBFB00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F7F7F70035312C00C3C2C000645F55008C8576007E7564007D75
      63007C7361007A72600079715F00786F5D00776E5C00766D5A00746B5900746B
      5800736A570071685500706754006F6652006E6451006D634F006B624E006B61
      4D0069604C00665D490061584500443E3200605B5000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F2F1F100605C51004E9D65004DB772004CB771004BB7700049B6
      6F0049B66E004799600057534800F1F0F000BCBAB5007F7B7400C6C6C5006B67
      5E00CDCCC800FFFFFF00FFFFFF00FFFFFF00ECECEB008A857E0073706700A9A7
      A300C4C3C200B0AFAC0093908A006B675F00706B6200EAE9E700000000000000
      0000000000000000000000000000000000009997940055514C00FFFFFF00FFFF
      FF00FFFFFF00DBDAD900332F2900332F2900332F2900D4D3D200FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0055514C0099979400656056008D8576007E7664007D75
      63007C7462007B7361007A715F0079705E00776F5C00766D5B00756C5900746B
      5800736A57007269560071685400706653006E6551006D6450006C624E006B61
      4D0064644E006359470061574400453F3300605B5100FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00D6D4D2005F5C50004E7D56004CA167004BB16D004AA0
      65004979510048443700D3D1CE00000000000000000087837C009F9C9700BBB9
      B7006A655C00CCCAC700FFFFFF00FFFFFF008B867F00928F8A00C2C1C000807D
      75005E5A50005D574D007D797100C0BFBE00908D88005D594E00E7E7E5000000
      000000000000000000000000000000000000716E6A007D7A7600FFFFFF00FFFF
      FF00FFFFFF00B7B6B300332F2900332F290059565100FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007D7A7600716E6A00666157008D8677007F7665007E75
      64007C7462007C7361007A72600079715F00786F5D00776E5C00766D5A00746B
      5900736A5700736A570071685500706754006F6652006E6451006D634F006572
      580047AD7A004E8964006158450046403400605B5100FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00F2F1F1009B989100716C6300544E44006F6A
      610098958F0048423600000000000000000000000000EBEAE80075706700A3A2
      9D00BAB8B6006A655B00CCCAC700D5D3D0007A766E00C4C3C200625D5300A19E
      9900EAE9E700D6D5D300504A3F0057534700B0AEAB0093918B005D584D00E7E7
      E5000000000000000000000000000000000047433E00A5A3A000FFFFFF00FFFF
      FF00FFFFFF0093918E00332F2900332F290078757100FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A5A3A00047433E00666158008F887A007F7766007E76
      64007D7563007C7361007B7361007A715F0079705E00776F5C00766D5B00756C
      5900746B5800736A57007269560071685400706653006E6551006D645000686D
      55004EAC7B0056866300665C490046413500615C5200FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004943370000000000000000000000000000000000E8E8E6007470
      6600A2A19C00BAB8B50068635A00716C6300ACAAA70083807900A19E9800FFFF
      FF00FFFFFF00E9E8E7005F5A5100A4A29E00514D4100B0AEAB0093918B005B56
      4C00E7E7E50000000000000000000000000047433E00A5A3A000FFFFFF00FFFF
      FF00FFFFFF00908E8A00332F2900332F290076746F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A5A3A00047433E00817C740089847700908979008B84
      75008A837400898172008880710087807000867E6F00857D6E00847C6C00837B
      6B00827A6A0081796800807767007F7766007E7665007D7564007C7362007B72
      61007A71600078705F00635B4B006C685E00625D5300FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00494438000000000000000000000000000000000000000000E8E8
      E600736F6600A2A09B00B9B7B500635F5500ABAAA60069655C00E9E8E700FFFF
      FF00FFFFFF00A09D97007D797200A5A4A000635F540056514600AFADAA009290
      8A005C574C00E7E7E5000000000000000000716E6A007D7A7600FFFFFF00FFFF
      FF00FFFFFF00B1B0AE00332F2900332F290058555000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007D7A7600716E6A00CDCBC800746F67006A655B006964
      5900686358006661560065605500635E5300635E5200615C5100605B4F005E59
      4E005D584C005C564A005A55490059534700585247005751450055504300544E
      4200524D4000504A3E005C574E00CAC8C500635E5400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004A44390000000000000000000000000000000000000000000000
      0000E8E8E600726E6400A1A09B00B9B7B400676258005C574C00D6D5D400EAE9
      E700A29F99005E5A4F00C2C1C000716D6500D4D2CF00CAC8C500554F4500AFAD
      AA00918F89005B564B00EAE9E700000000009997940055514C00FFFFFF00FFFF
      FF00FFFFFF00D4D3D200332F2900332F2900332F2900D5D5D300FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0055514C009997940000000000FDFDFD00DEDDDB00817D
      7500635E5400A29F9900D7D7D500D7D6D400D7D6D400D6D6D400D6D5D300D6D5
      D300D5D4D300D5D4D200D5D4D200D4D3D200D4D3D100D4D3D10098948E004E48
      3D00746F6600DDDCDA00FDFDFD0000000000635E5400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004A44390000000000000000000000000000000000000000000000
      000000000000E7E7E600716D64009D9B9600C7C6C50088857E00726E66006864
      5A008D8A8400C6C6C5008F8C860087827A00FFFFFF00FFFFFF00CBC9C600544F
      4400AEACA9008B888200746F670000000000C3C2C00035312C00F7F7F700FFFF
      FF00FFFFFF00FCFCFC0057544F00332F2900332F29005D595500EEEEED00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FDFDFD00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F7F7F70035312C00C3C2C0000000000000000000000000008A85
      7E00635E5500B2AFAA00F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2
      F200F2F2F200F2F2F200F2F2F200F1F1F100F1F1F100F1F1F100A9A6A1004F49
      3E007D787000000000000000000000000000635E5500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004B453A0000000000000000000000000000000000000000000000
      00000000000000000000EBEAE8007E7A71007C7871009C9A9500B5B4B200C7C6
      C500AAA9A5007470680088837C00ECECEB00FFFFFF00FFFFFF00FFFFFF00CBC9
      C600544F4400BBBAB900625D5400B6B4AF00EDEDED0037332D00AEADAA00FFFF
      FF00FFFFFF00FFFFFF00D0CFCD0034302A00332F2900332F29004A4741008D8A
      8700AEADAA00908E8A0065625E003936300095938F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00AEADAA0037332D00EDEDED000000000000000000000000008985
      7E00645F5500B2B0AB00F4F4F400F4F4F400F4F4F400F4F4F400F4F4F400F4F4
      F400F4F4F400F3F3F300F3F3F300F3F3F300F3F3F300F3F3F300A9A7A2004F4A
      3F007D797100000000000000000000000000645F5500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004C463B0000000000000000000000000000000000000000000000
      0000000000000000000000000000FBFBFB007E797100605B5100676359005B56
      4C006C685E00D4D2CF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008D89820074706900A3A29F007A766D0000000000999794003D3A3400E5E5
      E400FFFFFF00FFFFFF00FFFFFF009997940034302A00332F2900332F2900332F
      2900332F2900332F2900332F2900332F290059555000FFFFFF00FFFFFF00FFFF
      FF00E5E5E4003D3A340099979400000000000000000000000000000000008985
      7E0065605600B3B1AC00F6F6F600F6F6F600F6F6F600F6F6F600F6F6F600F5F5
      F500F5F5F500F5F5F500F5F5F500F5F5F500F5F5F500F5F5F500AAA7A2004F4A
      3F007E79720000000000000000000000000065605600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004C473B0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EBEAE8006F6B62009F9D9800B7B5
      B200635D5400CBC9C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00D8D7D500544F4400BFBFBE00554F450000000000FBFBFB00595550006562
      5D00FDFDFD00FFFFFF00FFFFFF00FFFFFF00C6C5C30045423C00332F2900332F
      2900332F2900332F2900332F2900413D3700C3C2C000FFFFFF00FFFFFF00FDFD
      FD0065625D0059555000FBFBFB0000000000000000000000000000000000D4D2
      CF007B766E00B4B2AD00F8F8F800F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700F7F7F700F7F7F700F7F7F700E6E5E300B1AFAA00ACA9A400817E75006C68
      5E00D3D1CE0000000000000000000000000065605600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004C473B0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E8E8E6006E6A60009E9D
      9700B6B5B200615C5200CCCAC700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00D8D7D50055504600C0C0BF00575146000000000000000000D9D8D7003733
      2D0094928F00FDFDFD00FFFFFF00FFFFFF00FFFFFF00F6F6F600CECDCC00A6A4
      A20089868300A2A09E00C5C3C200F1F1F100FFFFFF00FFFFFF00FDFDFD009492
      8F0037332D00D9D8D70000000000000000000000000000000000000000000000
      000096948D00B5B3AE00F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9
      F900F9F9F900F9F9F900CAC9C600605A510088857E0075716900524D4200BBB8
      B400000000000000000000000000000000006661570065605600635E5500625D
      5300615C5200605B50005F5A50005D584E005C574C005B564C005A544A005954
      4900575248005751470055504500544E4300534E4300524C4100514B40004F4A
      3F004F493E004D473C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E8E8E6006D69
      5F009D9C9700B6B4B200615B5100CCCAC700FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008E8A830077736B00A5A4A0007B776E00000000000000000000000000AAA9
      A60037332D0065625D00E5E5E400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E5E5E40065625D003733
      2D00AAA9A6000000000000000000000000000000000000000000000000000000
      000097948D00B6B3AE00FBFBFB00FBFBFB00FBFBFB00FBFBFB00FBFBFB00FBFB
      FB00FBFBFB00FBFBFB0088847C00B0AEAA00CFCECC00615C5200AEABA5000000
      00000000000000000000000000000000000066615800B2ACA700AFA9A400ADA6
      A100ABA59F00A8A19B00A59E9900A39C9500A19A93009E968F009B938C009991
      8900958D8500928982008F877F008C837B0089807800867C7500847A71008076
      6E007C7269004E483D0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      E6006C685E009D9B9600B5B4B100605B52008F8C8400D5D4D100D5D4D1008C8A
      820058534800BDBCBB0067625900B7B5B0000000000000000000000000000000
      0000D9D8D700595550003D3A3400AEADAA00F7F7F700FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00F7F7F700AEADAA003D3A340059555000D9D8
      D700000000000000000000000000000000000000000000000000000000000000
      000098948E00B5B3AF00FDFDFD00FDFDFD00FDFDFD00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC0079746B00A6A49E00635E5400AEABA700000000000000
      00000000000000000000000000000000000067625900B4ADA8008B857E00AFA8
      A30086817900AAA39D00837D7600A49E9800A39B9400A09891009C958D009A93
      8B00978F8800948C8500918981008E867F008B837B00897F7700857C74008378
      6F0080756C004F493E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E7E7E5006B675D0097958F00C2C2C000817D7700635E5400605C52007D79
      7300BFBEBC0088857F0077726A00000000000000000000000000000000000000
      000000000000FBFBFB009997940037332D0035312C0055514C007D7A7600A5A3
      A000A5A3A0007D7A760055514C0035312C0037332D0099979400FBFBFB000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C1BFBC0086837B00E7E6E400F0EFEF00F0EFEE00F0EFEE00F0EFEE00F0EF
      EE00F0EFEE00EFEFEE007671690059544900ACAAA50000000000000000000000
      000000000000000000000000000000000000817D7600A39C9700B3ADA800B0AB
      A500AEA7A100ABA59F00A9A39C00A69F9900A49D9600A19B94009F9791009C95
      8D0099918A00978F8700938A8300908880008D847D008A827A00877D7600847A
      7200746B6200726D640000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EBEAE800807C7400736F6700ACABA700C4C4C300C3C3C200A9A8
      A4006B665E0078746C00ECEBEA00000000000000000000000000000000000000
      0000000000000000000000000000EDEDED00C3C2C00099979400716E6A004743
      3E0047433E00716E6A0099979400C3C2C000EDEDED0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FAFAF9009E9B95006C685E00645F5500635E5400615C5200605B51005F5A
      50005D584E005C574C005C574D00ADAAA4000000000000000000000000000000
      00000000000000000000000000000000000000000000817D750066615700645F
      5500635E5500625D5300615C5200605B50005E594F005D584E005C574C005B56
      4C005A544A0059544900575248005651460055504500544E4300534E4300524C
      4100746F6600D4D2CF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B9B7B30083807700635E5400625C5200817D
      7400B8B6B1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F1F0F00096938C006B665D004F493F006A65
      5B0094918A00F1F0F000000000000000000000000000827F77005B554B005853
      4800575248005651460055504500544E4300534E4300524C4100514B40004F4A
      3F004F493E004D473C004C473B004B453A004A44390049433700474136004641
      3500453F3300453F330077736A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E4E3E100817E7600585348009A979100FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D4D2CF005B554D00454990003F4CCC003D4DE8003D4A
      CB003F448C00554F4700D3D1CE000000000084817900ACA9A400EEEEEE00F0EF
      EE00F0EFEE00F0EFEE00F0EFEE00F0EFEE00F0EFEE00EFEFEE00EFEEED004F49
      3E00A09D9700EFEEED00EFEEED00EFEEED00EFEEED00EFEEED00EFEEED00EEED
      ED00EEEDEC00ECECEB00A09D970077736A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D3D1CE0057524600645B51006A605800534C4100CCCAC7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D5D3D00079756D005A544A005954
      4900575248005751470055504500554F4400534E4300524C4100514B40004F4A
      3F004F493E004D473C004C473E00434FC4003F50F1003E4FF1003C4EF0003C4D
      F0003A4CF0003C48C200554F4700F1F0F0005E584E00EFEFEE00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004F49
      3E00B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00ECECEB00443E32000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBAB600524D42006A6258006B625A006A615800635A50009C9992000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B766E00D1D0CD00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF009B989100484C91004152F100424FD600414DCB003D4FF0003E4A
      CA003D4BD500394BF0003F438C0094918A005D584E00F0EFEF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004F49
      3E00B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDEC00433E32000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A5A2
      9C00544E43006F665C006D645C006F655C0072685E00645C52009B9892000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000067625900BEBCB8000000000000000000BEBCB8005D58
      4E00000000000000000000000000000000005D584E00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00726D64004551CD004253F1004250D00048454800434A9B004642
      46003E4BCF003A4CF0003B47CA0069645A005E594F00F0F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006159
      4F00B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDEC00443E32000000000000000000000000000000
      00000000000000000000000000000000000000000000FBFAFA008C8882005953
      490070675E006F665E0072696000786D6400776C6200695F55009C9993000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000004D473C00615039009D9A94009D9A94005E4D35004741
      3600000000000000000000000000000000005E594F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00575147004453E9004253F1004152F100444B9B00494438004249
      9A003C4DF0003B4DF0003A4AE7004C463C005E594F00F0F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006159
      4F00B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDEC00443E32000000000000000000000000000000
      000000000000000000000000000000000000F2F1F0007B766E00615A50007269
      600071685F00756C6200796F6600786E6400776D6300696056009B9892000000
      00000000000000000000000000000000000000000000FBFBFB00BBB9B5007975
      6C005A554B0059544900585348005751470055504500554F4400534E4300524C
      4100504B3F004F4A3F004E483D00DC8A2B007C5D35007B5B3300DB8727004842
      360046413500453F3300443E32005B564C005F5A5000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00736E65004652CE004354F1004350D0004A464A00444A9B004844
      48003E4CCF003C4DF0003C49CB0069645A005F5A5000F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00675F
      5500B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDEC00453F330000000000DEDDDB00AEACA600ACA9
      A400ACA9A500ABA8A400ABA8A300ABA8A3006C675E0069615900746B63007369
      6100796F65007A706700796F6600796E6500786D64006A6057009C9993000000
      00000000000000000000000000000000000000000000BBB9B50076756E00B7BA
      BB00D1D6DB00D1D6DA00D0D6DA00D0D5DA00D0D5D900CFD5D900CFD4D900CFD4
      D900CED4D800CED4D8004F493E00E78F2B00E68F2A00E68E2900E58C27004842
      3600D7D9D700DBDDDB009D9C96008E8A83005F5A5000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF009C9993004A4F93004454F1004351DB004350D0004051F100404D
      D0003E4DDA003C4DF00041468D0094918A00605B5000F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00675F
      5500B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDEC0046403400ADAAA50066615700736C6300736C
      6300726B6100706960006F685E006E675E00736A6100766D6500756C64007B71
      68007C7269007B7168007A706600796E6500786E64006B6158009C9993000000
      00000000000000000000E7E6E400F9F9F900000000007C786F00AFB2B200D1D7
      DB00D1D6DB00A4A5A40095959100949491009393900092928F0091918E00A0A1
      A000CED4D800CED4D8004F4A3F00E78F2C00E68F2A00E28B2900E18A27004943
      3700D4D6D400D7D9D7007D7A7200C1BFBB00605B5000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F2F1F100605A53004652C5004354F1004152F1004052F1003F50
      F1003E4FF1003F4BC30057524A00F1F0F000605B5000F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00675F
      5500B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDED00464135006F6B62007F776F007D766E007C74
      6D007B736B007A726A0078706900776F6700776F6700786F66007E746B007E74
      6B007D7369007C7168007A706700796F6600786E64006B6158009D9A94000000
      0000BDBBB700ECECEB008B878000B0ADA80000000000605B5000C4C9CC00D2D7
      DB00D1D6DB00A5A6A50095959200949491009494900093938F0092928E00A1A2
      A100CFD4D900CED4D8004F4A3F00E7902D00E08B2A00DB872800DE8928004944
      3800D1D2D100DADCDA005E594F00E4E3E200605B5100FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00D6D4D2005F5A5200494E92004450CD004151E800424E
      CC0044498F0048423900D3D1CE0000000000605B5100F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00675F
      5500B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED0046413500635E55008178710080776F007F77
      6E007E756D007D746B007C736A007A7269007B71690080776E007F766D007E74
      6B007D736A007C7269007B7168007A706600796E65006B6258009D9A94000000
      00007C786F00B9B7B200A09D9700908D860000000000605B5100C4C9CC00D2D7
      DB00D1D7DB00D1D6DB00D1D6DA00D0D6DA00D0D5DA00D0D5DA00CFD5D900CFD4
      D900CFD4D900CED4D800504B3F00DE8B2D00D7862A00D9862800DB8728004A44
      3900D6D8D600E0E2E0004A453A0000000000605B5100FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00F2F1F1009B989100716C6300544E44006F6A
      610098958F00484236000000000000000000615C5200F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00675F
      5500B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED0047413600635E5500887F7600887F7700877E
      7600867D7400857C7300847A72008379700082786F0081776E0080766D007F75
      6C007E746B007D7369007C7168007A706700796F66006C6259009C9993000000
      000098958F009B989200BFBDB900726D64000000000064605500BDC1C500D1D6
      DB00D2D7DB00D1D6DB00D1D6DB00D1D6DA0076746D005752480056514600554F
      4400534E4300524D4200514B40004F4A3F004F493E004D473C004C463B004B45
      3A00494438004842360047413600D3D1CE00615C5200FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00494337000000000000000000625D5300F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007973
      6A00B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED0048423600645F55008A80780089807700887F
      7600877D7500867C7400847B7200837A71008279700081776F0080766D007F75
      6C007E746B007D736A007C7269007B7168007A7066006D635A009D9A94000000
      0000B6B4AF007D797100DEDDDB00544E430000000000807C74009A9B9900C7CC
      D000CFD4D900D1D7DB00D1D6DB00D1D6DA00D0D6DA00D0D5DA00D0D5DA00CFD5
      D900CFD4D900CFD4D900CED4D800CED4D800CED3D800CDD3D800CDD3D700CCD2
      D700CCD2D700CCD2D60079787200ADAAA500625D5300FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00494438000000000000000000625D5300F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007973
      6A00B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED0048423600656056008A81790089807700887F
      7700877E7600867D7400857C7300847A72008379700082786F0081776E007F76
      6D007E746B007E746B007D7369007C7168007A7067006D645A009D9A94000000
      0000B6B4AF007D797100DEDDDB00554F440000000000CFCDCA00625D53007E7B
      76009393900092928F0091918E0090908D008F8F8C008E8E8B008D8D8A008D8D
      8A008C8C89008B8B88008A8A8700898986008888850088888500878784008686
      830085858200848481006E6B640069645A00635E5400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004A4439000000000000000000635E5400F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007973
      6A00B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED0049433700666157008F877E008A807800887F
      7700877E7600877D7500867C7400847B7200837A71008279700081776F008076
      6D007F756C007E746B007D736A007C7269007B7168006E645B009D9B95000000
      0000999690009B989200C0BEBA00736E6500DFDEDB00746E660086837C00A3A1
      9B00A2A09A00A1A09A00A19F9900A09E98009F9D97009E9D96009E9C96009D9B
      95009C9A94009B9A93009A9992009A989200999791009896900098968F009795
      8F0096948E007A766F00625D5200B1AFAA00635E5400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004A4439000000000000000000635E5500F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007973
      6A00B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED004944380066615800A09892009D968F009C95
      8E009B948D009A938C009A928B0099918A00948C8400847A720082786F008177
      6E007F766D007E746B007D736A007D7369007C7168006E655C009D9A94000000
      00007D797100B9B7B200A19E9800918E8700908C8500A5A49F00E4E5E400E4E6
      E400E4E6E400E4E5E400E4E5E400E3E5E300E3E5E300E3E5E300E3E5E300E3E4
      E300E2E4E200E2E4E200E2E4E200E2E4E200E2E3E200E1E3E100E1E3E100E1E3
      E100E1E3E100918F8800B2AFAA0000000000635E5500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004B453A000000000000000000635E5500F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007973
      6A00B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED004A443900736E65009D958E00A29B9400A19A
      9300A09992009F9891009E9790009E9790009D968F0097908800857B72008177
      6F0080766D007F756C007E746B007D7369007C7269006F665C009D9A95000000
      0000C3C1BD00EEEDEC008C888100B1AEA9006A665C00D0D2CF00E5E6E500E4E6
      E400817E75005F5A50005E594F005D584D005B564C005A544A00595449005752
      48005651460055504500544E4300524D420075726900E1E3E100E1E3E100E1E3
      E100E1E3E100726E6600DAD9D60000000000645F5500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004C463B000000000000000000645F5500F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00807A
      7300B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED004A443900AEABA7006F6B6100857F7600857F
      7600847D7500837C7400827B7200807A71008C837C009C948D0099918A00867D
      740081776E007F766D007E746B007D736A007C72690070665D009E9B95000000
      00000000000000000000ECEBEA00FBFBFB0066615700D5D7D500E5E6E500E4E6
      E400E4E6E400E4E6E400E4E5E400E4E5E400E3E5E300E3E5E300E3E5E300E3E5
      E300E3E4E300E2E4E200E2E4E200E2E4E200E2E3E200E2E3E200E1E3E100E1E3
      E100E1E3E100544F4400000000000000000065605600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004C473B00000000000000000065605600F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00827C
      7500B1AEA900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED004B453A0000000000DFDEDC00B0ADA700AEAB
      A700ADAAA600ADABA600ADAAA500ADAAA500716D64007C746C009C948D009A92
      8B00887F770080766D007F756C007E746B007D73690070665D009E9B96000000
      00000000000000000000000000000000000066615800D5D6D500E5E6E500E5E6
      E500E4E6E400E4E6E400E4E6E400B2B1AC00A19F9900A09E98009F9D97009E9D
      96009E9C96009D9B95009C9A94009B9A93009A9992009A989200999791009896
      900097968F004F4A3E00E5E4E3000000000065605600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004C473B00000000000000000066615700AFACA700B7B4AF00B6B3
      AE00B5B3AE00B5B2AD00B4B2AC00B4B1AC00B3B0AB00B3B0AB00B2AFAA00837C
      7500B1AEA900B1AEA900B0ADA800B0ADA800AFACA700AFACA600AEABA600AEAB
      A500ADAAA400ADAAA400A2A09A004C463B000000000000000000000000000000
      000000000000000000000000000000000000F3F2F1007F7B7300726B61009A92
      8B009A928B008B827A007F766D007E746B007D736A0070675E009E9B96000000
      000000000000000000000000000000000000817C7400BEBEBB00E1E2E100E5E6
      E500E4E6E400E4E6E400E4E6E400B2B2AC00A19F9900A09E98009F9D97009E9D
      96009E9C96009D9B95009C9A94009C9A94009B9993009A9892009A9891009997
      900098968F00635F5500C1BFBB00000000006661570065605600635E5500625D
      5300615C5200605B50005F5A50005D584E005C574C005B564C005A544A005954
      4900575248005751470055504500544E4300534E4300524C4100514B40004F4A
      3F004F493E004D473C00000000000000000066615700837C7500837E7600827C
      7500807A73007F7971007D776E007C756D0079736A0078726900756F6700746E
      6400726B6200706A60006E675E006C655B006A635A0068615700675F5500645D
      5300625A500061594F005C554A004C463B000000000000000000000000000000
      00000000000000000000000000000000000000000000FBFAFA00928F88006862
      5900968F88009A938C008E867E007F756C007E746B0072695F009E9B95000000
      000000000000000000000000000000000000BCBBB600837F7700BEBEBB00D9DA
      D900DBDCDB00DBDCDB00DBDCDB00DBDBDB00DADBDA00DADBDA00DADBDA00D9DA
      D900D9DAD900D9DAD900D9D9D900D8D9D800D8D9D800D8D9D800D7D8D700D7D8
      D700D7D8D70097979000918D86000000000066615800B2ACA700AFA9A400ADA6
      A100ABA59F00A8A19B00A59E9900A39C9500A19A93009E968F009B938C009991
      8900958D8500928982008F877F008C837B0089807800867C7500847A71008076
      6E007C7269004E483D00000000000000000066615800ADA6A100ABA59E00AEA7
      A100A8A19B00A9A29C00A69F9A00A09A9300A39C9500A09992009E968F009A93
      8C0098908900968E8600938B830090887F008D847D008B817900887F7700847B
      7300827970007F756C00796F65004C473B000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A9A6
      A100625B5300928A82009A928B0092898200887F77007B736B009E9B96000000
      00000000000000000000000000000000000000000000BCBAB6007F7B73006560
      5600635E5500625D5300605B5100605B50005E594F005D584D005C574C005A55
      4B0059544900585348005751470055504500554F4400534E4300524C4100504B
      3F004F4A3F004E483D00615D53000000000067625900B4ADA8008B857E00AFA8
      A30086817900AAA39D00837D7600A49E9800A39B9400A09891009C958D009A93
      8B00978F8800948C8500918981008E867F008B837B00897F7700857C74008378
      6F0080756C004F493E00000000000000000068635900AEA8A3008F8A8300A9A4
      9E00958F88009D978F009A948E008F888200A49D9700A29B9400A09891009D95
      8E009A928B0098908900958D8400928A82008F877E008D847C008A807900887E
      7500847A710082776E007A7167004E483D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C2BFBB00605B50008B837B0099928B0098918A007F776E00A09D96000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000817D7600A39C9700B3ADA800B0AB
      A500AEA7A100ABA59F00A9A39C00A69F9900A49D9600A19B94009F9791009C95
      8D0099918A00978F8700938A8300908880008D847D008A827A00877D7600847A
      7200746B6200726D6400000000000000000089867E00928D8600ADA8A100ABA5
      9F00A9A39D00A8A19A00A49E9800A29C9600A09A93009E9791009C948D009A92
      8B00978F8700958C8500928982008F877F008C847C008A817A00877E7700857B
      730082786F007E756C00675F55007C7970000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7D5D3006560560081797100928A830067605700CECCC9000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000817D750066615700645F
      5500635E5500625D5300615C5200605B50005E594F005D584E005C574C005B56
      4C005A544A0059544900575248005651460055504500544E4300534E4300524C
      4100746F6600D4D2CF0000000000000000000000000089867E00666258006560
      5600635E5500635E5400615C5200605B50005F5A50005D584E005D584D005B56
      4C005A554B0059544900585348005751470056514600554F4400544E4300524D
      4200524C4100514B40007D797000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E8E7E5008A867F00666157009F9C9600FEFEFE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0EFED0083796C0083796C00F0EFED0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000827F77005B554B005853
      4800575248005651460055504500544E4300534E4300524C4100514B40004F4A
      3F004F493E004D473C004C473B004B453A004A44390049433700474136004641
      3500453F3300453F330077736A00000000000000000000000000000000000000
      000000000000FBFBFB00EFEFEF00E2E2E200D5D5D500C9C9C900BEBEBE00BCBC
      BC00B9B9B900BABABA00BFBFBF00C8C8C800D9D9D900E7E7E700F2F2F200FBFB
      FB00FEFEFE0000000000000000000000000000000000FCFCFC00F6F6F600EEEE
      EE00E7E7E700E5E5E500E6E6E600E6E6E600E7E7E700E9E9E900EBEBEB00EDED
      ED00EFEFEF00F1F1F100F3F3F300F5F5F500F7F7F700F9F9F900FBFBFB00FDFD
      FD00FEFEFE000000000000000000000000000000000000000000000000000000
      000000000000BBB6AF009183700091837000BBB6AF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084817900ACA9A400EEEEEE00F0EF
      EE00F0EFEE00F0EFEE00F0EFEE00B5B2AE007F7A7200EFEFEE00EFEEED00EFEE
      ED00EFEEED00EFEEED00EFEEED00EFEEED00EFEEED00EFEEED00EFEEED00EEED
      ED00EEEDEC00ECECEB00A09D970077736A00000000000000000000000000BFC2
      C100858A8800858A8800858A8800858A8800858A8800858A8800858A8800858A
      8800858A8800858A8800858A8800858A8800858A8800858A8800858A8800858A
      8800C5C7C60000000000000000000000000000000000FAFAFA00EDEDED00DDDD
      DD00B6B6B6009B9B9B009B9B9B009A9A9A00999999009999990099999900BABA
      BA00DFDFDF00E3E3E300E8E8E800ECECEC00F0F0F000F4F4F400F8F8F800FBFB
      FB00FDFDFD000000000000000000000000000000000000000000000000000000
      000000000000B2ADA500A08F7B00A08F7B00B0A89B00FBF6EC00665B4C00665B
      4C00665B4C00665B4C00665B4C00665B4C00665B4C00665B4C006F645600DBD8
      D500000000000000000000000000000000005E584E00EFEFEE00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00BFBDB900847F7800FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00ECECEB00443E3200000000000000000000000000858A
      8800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000858A8800000000000000000000000000000000000000000000000000CECE
      CE009F9F9F00DEDEDE00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD009999
      9900CBCBCB000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B2ADA500A08F7B00A08F7B00AEA49200F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900665B4C007267
      5800DBD8D5000000000000000000000000005D584E00F0EFEF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00BFBDB90084807900FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDEC00433E3200000000000000000000000000858A
      880000000000E8E8E800EBEBEB00EBEBEB00EDEDED00EEEEEE00F0F0F000F2F2
      F200F3F3F300F5F5F500F6F6F600F8F8F800F9F9F900F8F8F800F6F6F6000000
      0000858A88000000000000000000000000000000000000000000D2D2D200A5A5
      A500EFEFEF00DFDFDF00DFDFDF00BDBDBD00BEBEBE00BFBFBF00C1C1C100CFCF
      CF009B9B9B00CBCBCB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B2ADA500A08F7B00A08F7B00AEA49200F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900665B4C00BCA9
      920072675800DBD8D50000000000000000005E594F00F0F0EF00C4C3BE009795
      8E0099958F00E7E6E500FFFFFF00C0BEB90085807900FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDEC00443E3200000000000000000000000000858A
      880000000000E8E8E800EBEBEB00EBEBEB00C2C2C200C2C2C200C2C2C200C2C2
      C200C2C2C200C2C2C200C2C2C200F5F5F500F6F6F600F8F8F800F7F7F7000000
      0000858A880000000000000000000000000000000000D5D5D500ABABAB00EFEF
      EF00E1E1E100E1E1E100E1E1E100E1E1E100BFBFBF00C1C1C100C2C2C200C3C3
      C300D1D1D1009D9D9D00CCCCCC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B2ADA500A08F7B00A08F7B00AEA49200F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED9006D625300D4BF
      A500BCA9920072675800DBD8D500000000005E594F00F0F0EF00D9D7D500B2AF
      AB00B3B0AB00F4F3F200FFFFFF00C0BEBA0085807900FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDEC00443E3200000000000000000000000000858A
      880000000000E8E8E800EAEAEA00EBEBEB00EBEBEB00F0F0F000F0F0F000F0F0
      F000F0F0F000F1F1F100F2F2F200F4F4F400F5F5F500F8F8F800F6F6F6000000
      0000858A880000000000000000000000000000000000B1B1B100EFEFEF00E3E3
      E300E3E3E300E3E3E300E3E3E300E3E3E300E3E3E300C2C2C200C3C3C300C5C5
      C500C6C6C600D4D4D4009F9F9F00CDCDCD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B9B4AD009183700098897600B4AB9800F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900A29887009B8B
      7700D4BFA500BCA9920072675800DBD8D5005F5A5000F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0BEBA0085817A00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDEC00453F3300000000000000000000000000858A
      880000000000E8E8E800EAEAEA00EBEBEB00C2C2C200C2C2C200C2C2C200C2C2
      C200C2C2C200C2C2C200C2C2C200C2C2C200C2C2C200F3F3F300F5F5F5000000
      0000858A880000000000000000000000000000000000B7B7B700EFEFEF00E8E8
      E800E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500C5C5C500C6C6
      C600C7C7C700C9C9C900D7D7D700A1A1A100CFCFCF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000ECEBE9007A7062007A706000E5DCC800F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900E9E0CB00A49A
      89006D625300665B4C00665B4C006F645600605B5000F1F0EF00E3E2E000C2C0
      BC00C1C0BB00C1BFBB00F4F4F300C0BEBA0086817A00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDEC0046403400000000000000000000000000858A
      880000000000E7E7E700F6F6F600E9E9E900EAEAEA00EAEAEA00ECECEC00EEEE
      EE00EFEFEF00ECECEC00E7E7E700F2F2F200F2F2F200F6F6F600F4F4F4000000
      0000858A880000000000000000000000000000000000DDDDDD00BABABA00F0F0
      F000E9E9E900E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700C7C7
      C700C9C9C900CACACA00CCCCCC00D9D9D900A4A4A400D0D0D000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B2ADA500AEA49200F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C00605B5000F1F0EF00BAB8B4008A86
      7F0089857E0089847D00DAD8D700C0BFBA0086817A00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EEEDED0046413500000000000000000000000000858A
      880000000000ADAFAE00D4D4D400D4D4D400B8B8B800C1C1C100C2C2C200C0C0
      C000B7B7B700B0B0B000B0B0B000C2C2C200C2C2C200F3F3F300F3F3F3000000
      0000858A88000000000000000000000000000000000000000000DEDEDE00BDBD
      BD00F1F1F100EBEBEB00E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900CACACA00CCCCCC00CECECE00CFCFCF00DCDCDC00C37B6700E1BCB2000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B2ADA500AEA49200F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C00605B5100F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C1BFBA0086827B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED0046413500000000000000000000000000858A
      880000000000E6E6E600CDCDCD00794A3800794A3800CECCCB00DDDDDD00D0CE
      CD00794A3800794A3800D4D4D400F2F2F200F2F2F200F2F2F200F2F2F2000000
      0000858A8800000000000000000000000000000000000000000000000000DFDF
      DF00BFBFBF00F3F3F300EDEDED00EBEBEB00EBEBEB00EBEBEB00EBEBEB00EBEB
      EB00EBEBEB00CECECE00CFCFCF00D1D1D100DC877000EF9A8300C47D6900E1BD
      B30000000000000000000000000000000000000000000000000000000000F5F5
      F400B9B4AB00918976006D6251006D62520091877600B8AF9C00EAE1CC00F7EE
      D900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C00615C5200F1F0EF00FBFBFA00F0F0
      EF00F0F0EF00EFEFEF00FEFEFE00C1BFBA0087837C00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED0047413600000000000000000000000000858A
      880000000000E6E6E600C5C5C5007A4B3A008D634E00794A3800D0CECD00794A
      3800936A540078483600C9C9C900EEEEEE00F1F1F100F1F1F100F0F0F0000000
      0000858A88000000000000000000000000000000000000000000000000000000
      0000E0E0E000C2C2C200F4F4F400EFEFEF00EEEEEE00EEEEEE00EEEEEE00EEEE
      EE00EEEEEE00EEEEEE00D1D1D100DC877000DE897200DF8A7300F19C8500C67F
      6B00E2BEB4000000000000000000000000000000000000000000D9D6D200796F
      5C00A0975C00CCC46000E9E16600E9E16600CCC46000A0965F00756B5A00D5CC
      B800F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C00625D5300F1F0EF00A5A19C005E59
      4F005D584E005C574C00D0CECC00C1BFBB0087837C00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED0048423600000000000000000000000000858A
      880000000000E5E5E500BDBDBD00794A3800B18F75008D634E00794A38008D63
      4E00B5937900784836009E9E9E00C2C2C200C2C2C200EFEFEF00EFEFEF000000
      0000858A88000000000000000000000000000000000000000000000000000000
      000000000000E1E1E100C4C4C400F5F5F500F1F1F100F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F1AA9300DE897200DF8A7300E08B7400E28D7600F49F
      8800C8806D00E3BFB500000000000000000000000000D9D6D200776D5600D3CB
      6200F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900D3CB6200796E
      5A00CCC2AF00F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C00625D5300F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C1BFBB0088837C00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED0048423600000000000000000000000000858A
      880000000000E4E4E400C9C9C90079493800B2907600AB856800B28E7300AA82
      6500B593790078483600B9B9B900ECECEC00EDEDED00EFEFEF00EDEDED000000
      0000858A88000000000000000000000000000000000000000000000000000000
      00000000000000000000E3E3E300C7C7C700F6F6F600F4F4F400F3F3F300F3F3
      F300F3F3F300F1AA9300F2AB9400F3AD9600E08B7400E28D7600E38E7700E48F
      7800F6A18A00CA826E00E4C0B60000000000F5F5F400796F5C00D3CB6200F7F0
      6900F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900D3CB
      6200796E5D00F2E9D500F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C00635E5400F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C1BFBB0088847D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED0049433700000000000000000000000000858A
      880000000000ACAFAD00AEAEAE0078493700B2907600A47B5B00A47A5A00A47A
      5A00B59379007848360089898900B6B6B600B6B6B600EFEFEF00ECECEC000000
      0000858A88000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E4E4E400C9C9C900F8F8F800F6F6F600F5F5
      F500F1AA9300F2AB9400F3AD9600F3AE9700F4AF9800E38E7700E48F7800E590
      7900E6917A00F8A38C00CB84700000000000B9B4AB00A0975C00F7F06900F7F0
      6900F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900F7F0
      6900A0965F00B4AA9800F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C00635E5500F1F0EF00B3B0AB007D79
      71007D7870007B776F00D7D5D200C1C0BB0089847D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED0049443800000000000000000000000000858A
      880000000000E2E2E200A7A7A70078483600B3917600A47B5B00A47A5A00A47A
      5A00B593790078483600A8A8A800EAEAEA00EAEAEA00EAEAEA00EAEAEA000000
      0000858A88000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E500CBCBCB00F9F9F900F6AD
      9600F2AB9400F3AD9600F3AE9700F4AF9800F5B09900F4B19A00E5907900E691
      7A00E7927B00F2A39600CE8673000000000091897600CCC46000F7F06900F7F0
      6900F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900F7F0
      6900CCC460008E847300F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C00635E5500F1F0EF00EDEDEB00D3D1
      CE00D2D0CE00D2D0CE00F9F9F900C2C0BC0089847D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED004A443900000000000000000000000000858A
      880000000000E1E1E100A6A6A60075463400B18F75009F7758009F7657009E76
      5700AF8F75007445340083838300B6B6B600B6B6B600E7E7E700E8E9E900FBFE
      FE00848B89000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E6E6E600D7927F00FEC0
      AD00F7B19A00F3AE9700F4AF9800F5B09900F4B19A00F5B29B00F5B39C00E792
      7B00F5A39200D0897600E7C4BA000000000072675500E9E16600F7F06900F7F0
      6900F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900F7F0
      6900E9E166007C726000F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C00645F5500F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C2C0BC0089857E00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED004A443900000000000000000000000000858A
      880000000000E0E0E000A4A3A3006C403000A6887100936E5100936E5100936D
      5000A68770006B403000A6A6A600E7E7E700E7E7E700E4E7E700CDE7EA00C9F8
      FE00789FA100F9FEFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000ECC9BF00D993
      8000FEC2B000F9B39C00F5B09900F4B19A00F5B29B00F5B39C00F6B49D00FECB
      BA00D38D7A00E8C5BB0000000000000000007D735E00E9E16600F7F06900746A
      4F00D9D26300F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900F7F0
      6900E9E1660072675700F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C0065605600F1F0EF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C2C0BC008A857E00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEEED004B453A00000000000000000000000000858A
      880000000000DFDFDF00A3A1A100653E2E00A1836C008C684C008C684C008C68
      4D00A1836D00673D2E0084848400B7B7B700B3B8B900B4E9EF00A6EEF800AFF3
      FD0071CBD500D9FAFE00FEFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000ECC9
      BF00D9948100FDC5B500F9B69F00F5B29B00F5B39C00F6B49D00FCCABC00D690
      7D00EAC7BD0000000000000000000000000091887600CCC46000F7F06900998F
      56009D945700F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900F7F0
      6900CCC4600091877600F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C0066615700AFACA700B7B4AF00B6B3
      AE00B5B3AE00B5B2AD00B4B2AC009390890074706700B3B0AB00B2AFAA00B2AF
      AA00B1AEA900B1AEA900B0ADA800B0ADA800AFACA700AFACA600AEABA600AEAB
      A500ADAAA400ADAAA400A2A09A004C463B00000000000000000000000000858A
      880000000000DEDEDE00A19F9E006F433300AA8A720097705300987153009871
      5300AA8B72006F423200A4A4A400E5E5E500C0E6EA009FEFF800E9FAFD00F5FD
      FE00AAE8F000B9F6FE00F5FEFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000ECCAC000DA958200FDC7B800FAB8A100F6B49D00FCCABC00D8938000EBC8
      BF0000000000000000000000000000000000B7B2A900A0975C00F7F06900E8E1
      6600756B4F009D945700D9D26300F7F06900F7F06900F7F06900F7F06900F7F0
      6900A0965F00B8AF9C00F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C0066615700837C7500837E7600827C
      7500807A73007F7971007D776E007B746D007771690078726900756F6700746E
      6400726B6200706A60006E675E006C655B006A635A0068615700675F5500645D
      5300625A500061594F005C554A004C463B00000000000000000000000000858A
      88000000000000000000B4B3B20079493800BA9C8500AC876A00AC876A00AC87
      6A00BB9D850078483600B8B8B80000000000C9F8FE00A4F2FD00F3FDFE00FBFE
      FE00C6F1F600AFF5FE00F3FDFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EDCAC100DB958300FCC9BB00FCCABC00DA948100ECC9BF000000
      000000000000000000000000000000000000FAFAF9007A705D00D3CB6200F7F0
      6900E8E16600998F5600746A4F00F7F06900F7F06900F7F06900F7F06900D3CB
      6200756B5A00EAE1CC00F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F7EED900665B4C0066615800ADA6A100A6A09900AEA7
      A100A49D9700A8A19B00A69E99009B968F00A39C9500A09992009E968F009A93
      8C0098908900968E8600938B830090887F008D847D008B817900887F7700847B
      7300827970007F756C00796F65004C473B00000000000000000000000000C1C3
      C200858A8800858A880061615E00784A3700D5C2B400D5C1B300D5C1B300D5C2
      B400D5C2B400784836005F636200858A88007C999B006CCDD800A5EAF300C3F1
      F50096DEE700E5FCFF00FDFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EDCAC100DC978400DC968400EDCAC100000000000000
      00000000000000000000000000000000000000000000D1CECA00796E5700D3CB
      6200F7F06900F7F06900F7F06900F7F06900F7F06900F7F06900D3CB6200796E
      5A00D5CCB800F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F7EED900F0E7D2006D63540068635900AEA8A3007C786F00A49F
      9800857F7600928B83008F8A82007F797200A49D9700A29B9400A09891009D95
      8E009A928B0098908900958D8400928A82008F877E008D847C008A807900887E
      7500847A710082776E007A7167004E483D000000000000000000000000000000
      000000000000BBA39A0078483600784836007848360078483600784836007848
      360078483600855949000000000000000000FCFFFF00DFFBFE00BBF6FE00C8F8
      FE00EFFDFF00FEFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCD9D600766C
      5A00A0965D00CCC46000E9E16600E9E16600CCC46000A0966000796E5E00CCC2
      AF00F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EED900F7EE
      D900F7EED900F0E7D200A79D8B00A7A0960089867E00928D8600ADA8A100ABA5
      9F00A9A39D00A8A19A00A49E9800A29C9600A09A93009E9791009C948D009A92
      8B00978F8700958C8500928982008F877F008C847C008A817A00877E7700857B
      730082786F007E756C00675F55007C7970000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F1F0
      EF00BCB7B000938B7900726755007D735F0090877500B6AEA100F6F1E700FBF6
      EC00FBF6EC00665B4C00665B4C00665B4C00665B4C00665B4C00665B4C00665B
      4C00665B4C006D635400A7A09600000000000000000089867E00666258006560
      5600635E5500635E5400615C5200605B50005F5A50005D584E005D584D005B56
      4C005A554B0059544900585348005751470056514600554F4400544E4300524D
      4200524C4100514B40007D79700000000000424D3E000000000000003E000000
      2800000060000000780000000100010000000000A00500000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000E07FFFC07FFFE00000E00003801FFF80
      3FFFE00000E00003800FBF001FFFE00000E000030007BF000FFF000000E00003
      0003BF0007FF000000E000030001BF0003FF000000E000030000C30001FF0000
      00C0000000007F0000FF00000080000000003F00007F0000000FFFF080001F80
      003F00000080000080000FC0001F000000E00001C00007E0000F000000E00003
      E00003F00007000000E00003F00001F80003000000E00003F80001FC00010000
      00E00003FC0000FE0000000000E00003FE0000FF0000000000E00003E00000FF
      8000000000E00003FE8000FFC000000000E00003FEC000FFE000000000E00003
      FEE000FFF000000000E00003FEF001FFF800000007E136C3FFF801FFFC010000
      07E00003FFFE07FFFE03000007F936CFFE007FC00003FFFE03E07FFFF8001FC0
      0003FFFC01801FFFF0000FC00003000000800FFFE00007C000030000000007FF
      C000030000000000000003FF8000010000000000000001FF8000010000000000
      000000FF00000000000000000000007F00000000000000000000003F00000000
      000000000180001F00000000000000000380000F000000000000000003C00007
      000000000000000003E00003000000000000000003F000010000008000010000
      03F80001000000E00007000003FC0000000000E00007000003FE0000800001E0
      0007000003FF0000800001E00007000003FF8000C00003F0000F000003FFC000
      E00007F0001F000003FFE000F0000FF0003F000003FFF001F8001FF0007F0000
      03FFF801FE007FF000FF800003FFFE07FFFE03800001FFFC1FFFFFFFFFFC0100
      0000FFF81FFFFFFF000000000000FFF01FFFFFFF000000000000FFE01FFFFCCF
      000000000000FF801FFFFC0F000000000000FF001F8000000000000000008000
      1F80000000000000000000001C80000000000000000000001080000000000100
      0000000010800001000003000000000010800000000003000000000010800000
      0000030000000000108000000000030000000000100000000000030000000000
      1000000100000300000000001000000100000300000000001C00000300000300
      000080001F000001000003000000FF001F000001000003000000FF801F000001
      000003000000FFE01F800001000003000000FFF01FFFFFFF000003000000FFF8
      1FFFFFFF800003800001FFFC1FFFFFFFFFFFFFFFFFFFF87FFF800001F8000780
      0007F87FFF000000E00007800007F8000F000000EFFFF7E007FFF80007000000
      E80017C003FFF80003000000E800178001FFF80001000000E800178000FFF800
      00000000E8001780007FF80000000000E8001780003FFC0000000000E80017C0
      001FFC0000000000E80017E0000FE00000000000E80017F00007C00000000000
      E80017F80003800000000000E80017FC0001000000000000E80017FE00010000
      00000000E80017FF0001000000000000E80007FF8001000000000000E80003FF
      C003000000000000E80001FFE007000000000000E80001FFF00F000000000000
      EC0101FFF81F000000000000E00001FFFC3F800000000000F80303FFFFFFC000
      00000000FFFFFFFFFFFFE0000180000100000000000000000000000000000000
      000000000000}
  end
  object pmRecLinksOptions: TPopupMenu
    Images = ilPictures24
    OnChange = pmRecLinksOptionsChange
    Left = 584
    Top = 118
    object miStrictLogic: TMenuItem
      AutoCheck = True
      Caption = 'Use only strict logic'
      GroupIndex = 1
      ImageIndex = 11
      RadioItem = True
      OnClick = miChooseLogicClick
    end
    object miFuzzyLogic: TMenuItem
      AutoCheck = True
      Caption = 'Use Fuzzy Logic'
      Checked = True
      GroupIndex = 1
      ImageIndex = 13
      RadioItem = True
      OnClick = miChooseLogicClick
    end
  end
end
