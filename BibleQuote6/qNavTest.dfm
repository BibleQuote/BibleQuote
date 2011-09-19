object frmQNav: TfrmQNav
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'frmQNav'
  ClientHeight = 454
  ClientWidth = 952
  Color = clBtnFace
  Constraints.MaxHeight = 933
  Constraints.MaxWidth = 1243
  Constraints.MinHeight = 364
  Constraints.MinWidth = 729
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = TntFormCreate
  OnDestroy = TntFormDestroy
  OnKeyPress = FormKeyPress
  OnKeyUp = TntFormKeyUp
  OnMouseWheel = TntFormMouseWheel
  OnResize = TntFormResize
  OnShow = FormShow
  DesignSize = (
    952
    454)
  PixelsPerInch = 120
  TextHeight = 17
  object lbBQName: TTntLabel
    Left = 2
    Top = 11
    Width = 71
    Height = 27
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1055#1077#1088#1077#1081#1090#1080
    Transparent = True
    Layout = tlCenter
  end
  object mTagTabsEx: TDockTabSet
    Tag = -1
    Left = -1
    Top = 53
    Width = 955
    Height = 31
    Anchors = [akLeft, akTop, akRight]
    DitherBackground = False
    EndMargin = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = True
    StartMargin = 0
    SelectedColor = 10081785
    SoftTop = True
    Style = tsSoftTabs
    TabHeight = 18
    TabPosition = tpTop
    OnChange = mTagTabsExChange
    DockSite = False
  end
  object vstBookList: TVirtualDrawTree
    Left = 9
    Top = 90
    Width = 932
    Height = 352
    Cursor = crHandPoint
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderWidth = 1
    Colors.BorderColor = clWindow
    Colors.DisabledColor = clWindow
    Colors.FocusedSelectionColor = 14281467
    Colors.FocusedSelectionBorderColor = 694509
    Colors.HotColor = clBtnHighlight
    Colors.SelectionRectangleBlendColor = clCaptionText
    Colors.UnfocusedSelectionColor = 16511449
    Colors.UnfocusedSelectionBorderColor = 15106675
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
    NodeDataSize = 4
    ParentShowHint = False
    SelectionCurveRadius = 7
    ShowHint = True
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking, toAutoDeleteMovedNodes, toAutoChangeScale, toDisableAutoscrollOnEdit]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toVariableNodeHeight, toEditOnClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toStaticBackground]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnClick = vstBookListClick
    OnCompareNodes = vstBookListCompareNodes
    OnDblClick = vstBookListDblClick
    OnDrawHint = vstBookListDrawHint
    OnDrawNode = vstBookListDrawNode
    OnFreeNode = vstBookListFreeNode
    OnGetHintSize = vstBookListGetHintSize
    OnKeyUp = vstBookListKeyUp
    OnMeasureItem = vstBookListMeasureItem
    OnMouseDown = vstBookListMouseDown
    OnMouseMove = vstBookListMouseMove
    OnMouseUp = vstBookListMouseUp
    Columns = <>
  end
  object edFilter: TTntEdit
    Left = 87
    Top = 11
    Width = 666
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvNone
    TabOrder = 0
    OnChange = edFilterChange
    OnKeyUp = edFilterKeyUp
  end
  object btnOK: TButton
    Left = 855
    Top = 10
    Width = 87
    Height = 30
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 2
    OnClick = vstBookListDblClick
  end
  object btnCollapse: TButton
    Left = 806
    Top = 47
    Width = 136
    Height = 31
    Anchors = [akTop, akRight]
    Caption = #1057#1074#1077#1088#1085#1091#1090#1100' '#1074#1089#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Visible = False
    OnClick = btnCollapseClick
  end
  object btnClear: TButton
    Left = 760
    Top = 10
    Width = 88
    Height = 30
    Anchors = [akTop, akRight]
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    TabStop = False
    OnClick = btnClearClick
  end
  object stCount: TTntStaticText
    Left = 736
    Top = 50
    Width = 65
    Height = 28
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    AutoSize = False
    BevelKind = bkFlat
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
end
