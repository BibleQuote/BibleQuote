object frmQNav: TfrmQNav
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'frmQNav'
  ClientHeight = 378
  ClientWidth = 784
  Color = clBtnFace
  Constraints.MaxHeight = 768
  Constraints.MaxWidth = 1024
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
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
    784
    378)
  PixelsPerInch = 105
  TextHeight = 14
  object Shape2: TShape
    Left = -8
    Top = 68
    Width = 795
    Height = 293
    Anchors = [akLeft, akTop, akRight, akBottom]
    Brush.Color = 10081785
    Pen.Width = 0
  end
  object Shape1: TShape
    Left = -12
    Top = 312
    Width = 824
    Height = 265
    Anchors = [akLeft, akRight, akBottom]
    Brush.Color = 15648678
    DragCursor = crHandPoint
    Pen.Width = 0
  end
  object lbBQName: TTntLabel
    Left = 2
    Top = 9
    Width = 58
    Height = 22
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1055#1077#1088#1077#1081#1090#1080
    Transparent = True
    Layout = tlCenter
  end
  object mTagTabsEx: TDockTabSet
    Tag = -1
    Left = -1
    Top = 44
    Width = 787
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    DitherBackground = False
    EndMargin = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
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
    Left = 7
    Top = 74
    Width = 768
    Height = 291
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
    Left = 72
    Top = 9
    Width = 548
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvNone
    TabOrder = 0
    OnChange = edFilterChange
    OnKeyUp = edFilterKeyUp
  end
  object btnOK: TButton
    Left = 704
    Top = 8
    Width = 72
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 2
    OnClick = vstBookListDblClick
  end
  object btnCollapse: TButton
    Left = 664
    Top = 39
    Width = 112
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1057#1074#1077#1088#1085#1091#1090#1100' '#1074#1089#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Visible = False
    OnClick = btnCollapseClick
  end
  object btnClear: TButton
    Left = 626
    Top = 8
    Width = 72
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    TabStop = False
    OnClick = btnClearClick
  end
  object stCount: TTntStaticText
    Left = 606
    Top = 41
    Width = 54
    Height = 23
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    AutoSize = False
    BevelKind = bkFlat
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
end
