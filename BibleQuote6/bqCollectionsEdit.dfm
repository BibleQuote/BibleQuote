object bqCollectionsEditor: TbqCollectionsEditor
  Left = 0
  Top = 0
  Caption = 'bqCollectionsEditor'
  ClientHeight = 381
  ClientWidth = 776
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  DesignSize = (
    776
    381)
  PixelsPerInch = 105
  TextHeight = 14
  object vdtCollectionBookList: TVirtualDrawTree
    Left = 5
    Top = 56
    Width = 708
    Height = 313
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
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking, toAutoDeleteMovedNodes, toAutoChangeScale, toDisableAutoscrollOnEdit]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toVariableNodeHeight, toEditOnClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toStaticBackground]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    Columns = <>
  end
end
