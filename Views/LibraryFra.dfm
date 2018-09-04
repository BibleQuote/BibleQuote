object LibraryFrame: TLibraryFrame
  Left = 0
  Top = 0
  Width = 441
  Height = 357
  TabOrder = 0
  OnResize = FrameResize
  DesignSize = (
    441
    357)
  object edtFilter: TEdit
    Left = 3
    Top = 5
    Width = 222
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = edtFilterChange
  end
  object cmbBookType: TComboBox
    Left = 231
    Top = 5
    Width = 126
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    TabOrder = 1
    OnChange = cmbBookTypeChange
  end
  object btnClear: TButton
    Left = 363
    Top = 3
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Clear'
    TabOrder = 2
    OnClick = btnClearClick
  end
  object vdtBooks: TVirtualDrawTree
    Left = 3
    Top = 32
    Width = 435
    Height = 322
    Cursor = crHandPoint
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderWidth = 1
    Colors.BorderColor = clWindow
    Colors.DisabledColor = clWindow
    Colors.FocusedSelectionColor = 16706784
    Colors.HotColor = clBtnHighlight
    Colors.SelectionRectangleBlendColor = clCaptionText
    Colors.UnfocusedSelectionColor = 16511449
    Colors.UnfocusedSelectionBorderColor = 15106675
    Header.AutoSizeIndex = 0
    Header.MainColumn = -1
    HintAnimation = hatFade
    HintMode = hmHint
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking, toAutoDeleteMovedNodes, toAutoChangeScale, toDisableAutoscrollOnEdit]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toVariableNodeHeight, toEditOnClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toStaticBackground]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnCompareNodes = vdtBooksCompareNodes
    OnDblClick = vdtBooksDblClick
    OnDrawNode = vdtBooksDrawNode
    OnFreeNode = vdtBooksFreeNode
    OnMeasureItem = vdtBooksMeasureItem
    Columns = <>
  end
end
