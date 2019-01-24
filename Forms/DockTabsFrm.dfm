object DockTabsForm: TDockTabsForm
  Left = 0
  Top = 0
  ClientHeight = 396
  ClientWidth = 659
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnMouseActivate = FormMouseActivate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 30
    Width = 659
    Height = 366
    Align = alClient
    TabOrder = 0
  end
  object ctViewTabs: TChromeTabs
    Left = 0
    Top = 0
    Width = 659
    Height = 30
    OnActiveTabChanging = ctViewTabsActiveTabChanging
    OnActiveTabChanged = ctViewTabsActiveTabChanged
    OnButtonAddClick = ctViewTabsButtonAddClick
    OnButtonCloseTabClick = ctViewTabsButtonCloseTabClick
    OnTabDragDrop = ctViewTabsTabDragDrop
    OnTabDragDropped = ctViewTabsTabDragDropped
    ActiveTabIndex = -1
    Images = vImgIcons
    Options.Display.CloseButton.Offsets.Vertical = 6
    Options.Display.CloseButton.Offsets.Horizontal = 2
    Options.Display.CloseButton.Height = 14
    Options.Display.CloseButton.Width = 14
    Options.Display.CloseButton.AutoHide = True
    Options.Display.CloseButton.Visibility = bvAll
    Options.Display.CloseButton.AutoHideWidth = 20
    Options.Display.CloseButton.CrossRadialOffset = 4
    Options.Display.AddButton.Offsets.Vertical = 10
    Options.Display.AddButton.Offsets.Horizontal = 2
    Options.Display.AddButton.Height = 14
    Options.Display.AddButton.Width = 31
    Options.Display.AddButton.ShowPlusSign = False
    Options.Display.AddButton.Visibility = avRightFloating
    Options.Display.AddButton.HorizontalOffsetFloating = -3
    Options.Display.ScrollButtonLeft.Offsets.Vertical = 10
    Options.Display.ScrollButtonLeft.Offsets.Horizontal = 1
    Options.Display.ScrollButtonLeft.Height = 15
    Options.Display.ScrollButtonLeft.Width = 15
    Options.Display.ScrollButtonRight.Offsets.Vertical = 10
    Options.Display.ScrollButtonRight.Offsets.Horizontal = 1
    Options.Display.ScrollButtonRight.Height = 15
    Options.Display.ScrollButtonRight.Width = 15
    Options.Display.TabModifiedGlow.Style = msRightToLeft
    Options.Display.TabModifiedGlow.VerticalOffset = -6
    Options.Display.TabModifiedGlow.Height = 30
    Options.Display.TabModifiedGlow.Width = 100
    Options.Display.TabModifiedGlow.AnimationPeriodMS = 4000
    Options.Display.TabModifiedGlow.EaseType = ttEaseInOutQuad
    Options.Display.TabModifiedGlow.AnimationUpdateMS = 50
    Options.Display.Tabs.SeeThroughTabs = False
    Options.Display.Tabs.TabOverlap = 15
    Options.Display.Tabs.ContentOffsetLeft = 18
    Options.Display.Tabs.ContentOffsetRight = 16
    Options.Display.Tabs.OffsetLeft = 0
    Options.Display.Tabs.OffsetTop = 4
    Options.Display.Tabs.OffsetRight = 0
    Options.Display.Tabs.OffsetBottom = 0
    Options.Display.Tabs.MinWidth = 25
    Options.Display.Tabs.MaxWidth = 200
    Options.Display.Tabs.TabWidthFromContent = False
    Options.Display.Tabs.PinnedWidth = 39
    Options.Display.Tabs.ImageOffsetLeft = 13
    Options.Display.Tabs.TextTrimType = tttFade
    Options.Display.Tabs.Orientation = toTop
    Options.Display.Tabs.BaseLineTabRegionOnly = False
    Options.Display.Tabs.WordWrap = False
    Options.Display.Tabs.TextAlignmentHorizontal = taLeftJustify
    Options.Display.Tabs.TextAlignmentVertical = taVerticalCenter
    Options.Display.Tabs.ShowImages = True
    Options.Display.Tabs.ShowPinnedTabText = False
    Options.Display.TabContainer.TransparentBackground = True
    Options.Display.TabContainer.OverlayButtons = True
    Options.Display.TabContainer.PaddingLeft = 0
    Options.Display.TabContainer.PaddingRight = 0
    Options.Display.TabMouseGlow.Offsets.Vertical = 0
    Options.Display.TabMouseGlow.Offsets.Horizontal = 0
    Options.Display.TabMouseGlow.Height = 200
    Options.Display.TabMouseGlow.Width = 200
    Options.Display.TabMouseGlow.Visible = True
    Options.Display.TabSpinners.Upload.ReverseDirection = True
    Options.Display.TabSpinners.Upload.RenderedAnimationStep = 2
    Options.Display.TabSpinners.Upload.Position.Offsets.Vertical = 0
    Options.Display.TabSpinners.Upload.Position.Offsets.Horizontal = 0
    Options.Display.TabSpinners.Upload.Position.Height = 16
    Options.Display.TabSpinners.Upload.Position.Width = 16
    Options.Display.TabSpinners.Upload.SweepAngle = 135
    Options.Display.TabSpinners.Download.ReverseDirection = False
    Options.Display.TabSpinners.Download.RenderedAnimationStep = 5
    Options.Display.TabSpinners.Download.Position.Offsets.Vertical = 0
    Options.Display.TabSpinners.Download.Position.Offsets.Horizontal = 0
    Options.Display.TabSpinners.Download.Position.Height = 16
    Options.Display.TabSpinners.Download.Position.Width = 16
    Options.Display.TabSpinners.Download.SweepAngle = 135
    Options.Display.TabSpinners.AnimationUpdateMS = 50
    Options.Display.TabSpinners.HideImagesWhenSpinnerVisible = True
    Options.DragDrop.DragType = dtBetweenContainers
    Options.DragDrop.DragOutsideImageAlpha = 220
    Options.DragDrop.DragOutsideDistancePixels = 30
    Options.DragDrop.DragStartPixels = 2
    Options.DragDrop.DragControlImageResizeFactor = 0.500000000000000000
    Options.DragDrop.DragCursor = crDefault
    Options.DragDrop.DragDisplay = ddTab
    Options.DragDrop.DragFormBorderWidth = 2
    Options.DragDrop.DragFormBorderColor = 8421504
    Options.DragDrop.ContrainDraggedTabWithinContainer = True
    Options.Animation.DefaultMovementAnimationTimeMS = 100
    Options.Animation.DefaultStyleAnimationTimeMS = 300
    Options.Animation.AnimationTimerInterval = 15
    Options.Animation.MinimumTabAnimationWidth = 40
    Options.Animation.DefaultMovementEaseType = ttLinearTween
    Options.Animation.DefaultStyleEaseType = ttLinearTween
    Options.Animation.MovementAnimations.TabAdd.UseDefaultEaseType = True
    Options.Animation.MovementAnimations.TabAdd.UseDefaultAnimationTime = True
    Options.Animation.MovementAnimations.TabAdd.EaseType = ttEaseOutExpo
    Options.Animation.MovementAnimations.TabAdd.AnimationTimeMS = 500
    Options.Animation.MovementAnimations.TabDelete.UseDefaultEaseType = True
    Options.Animation.MovementAnimations.TabDelete.UseDefaultAnimationTime = True
    Options.Animation.MovementAnimations.TabDelete.EaseType = ttEaseOutExpo
    Options.Animation.MovementAnimations.TabDelete.AnimationTimeMS = 500
    Options.Animation.MovementAnimations.TabMove.UseDefaultEaseType = False
    Options.Animation.MovementAnimations.TabMove.UseDefaultAnimationTime = False
    Options.Animation.MovementAnimations.TabMove.EaseType = ttEaseOutExpo
    Options.Animation.MovementAnimations.TabMove.AnimationTimeMS = 500
    Options.Behaviour.BackgroundDblClickMaximiseRestoreForm = True
    Options.Behaviour.BackgroundDragMovesForm = True
    Options.Behaviour.TabSmartDeleteResizing = True
    Options.Behaviour.TabSmartDeleteResizeCancelDelay = 700
    Options.Behaviour.UseBuiltInPopupMenu = False
    Options.Behaviour.TabRightClickSelect = False
    Options.Behaviour.ActivateNewTab = True
    Options.Behaviour.DebugMode = False
    Options.Behaviour.IgnoreDoubleClicksWhileAnimatingMovement = True
    Options.Scrolling.Enabled = True
    Options.Scrolling.ScrollButtons = csbNone
    Options.Scrolling.ScrollStep = 20
    Options.Scrolling.ScrollRepeatDelay = 20
    Options.Scrolling.AutoHideButtons = True
    Options.Scrolling.DragScroll = True
    Options.Scrolling.DragScrollOffset = 50
    Options.Scrolling.MouseWheelScroll = True
    Tabs = <>
    LookAndFeel.TabsContainer.StartColor = 14586466
    LookAndFeel.TabsContainer.StopColor = 13201730
    LookAndFeel.TabsContainer.StartAlpha = 255
    LookAndFeel.TabsContainer.StopAlpha = 255
    LookAndFeel.TabsContainer.OutlineColor = 14520930
    LookAndFeel.TabsContainer.OutlineAlpha = 0
    LookAndFeel.Tabs.BaseLine.Color = 11110509
    LookAndFeel.Tabs.BaseLine.Thickness = 1.000000000000000000
    LookAndFeel.Tabs.BaseLine.Alpha = 255
    LookAndFeel.Tabs.Modified.CentreColor = clWhite
    LookAndFeel.Tabs.Modified.OutsideColor = clWhite
    LookAndFeel.Tabs.Modified.CentreAlpha = 130
    LookAndFeel.Tabs.Modified.OutsideAlpha = 0
    LookAndFeel.Tabs.DefaultFont.Name = 'Segoe UI'
    LookAndFeel.Tabs.DefaultFont.Color = clBlack
    LookAndFeel.Tabs.DefaultFont.Size = 9
    LookAndFeel.Tabs.DefaultFont.Alpha = 255
    LookAndFeel.Tabs.DefaultFont.TextRenderingMode = TextRenderingHintClearTypeGridFit
    LookAndFeel.Tabs.MouseGlow.CentreColor = clWhite
    LookAndFeel.Tabs.MouseGlow.OutsideColor = clWhite
    LookAndFeel.Tabs.MouseGlow.CentreAlpha = 120
    LookAndFeel.Tabs.MouseGlow.OutsideAlpha = 0
    LookAndFeel.Tabs.Spinners.Upload.Color = 12759975
    LookAndFeel.Tabs.Spinners.Upload.Thickness = 2.500000000000000000
    LookAndFeel.Tabs.Spinners.Upload.Alpha = 255
    LookAndFeel.Tabs.Spinners.Download.Color = 14388040
    LookAndFeel.Tabs.Spinners.Download.Thickness = 2.500000000000000000
    LookAndFeel.Tabs.Spinners.Download.Alpha = 255
    LookAndFeel.Tabs.Active.Font.Name = 'Segoe UI'
    LookAndFeel.Tabs.Active.Font.Color = clOlive
    LookAndFeel.Tabs.Active.Font.Size = 9
    LookAndFeel.Tabs.Active.Font.Alpha = 100
    LookAndFeel.Tabs.Active.Font.TextRenderingMode = TextRenderingHintClearTypeGridFit
    LookAndFeel.Tabs.Active.Font.UseDefaultFont = True
    LookAndFeel.Tabs.Active.Style.StartColor = clWhite
    LookAndFeel.Tabs.Active.Style.StopColor = 16316920
    LookAndFeel.Tabs.Active.Style.StartAlpha = 255
    LookAndFeel.Tabs.Active.Style.StopAlpha = 255
    LookAndFeel.Tabs.Active.Style.OutlineColor = 10189918
    LookAndFeel.Tabs.Active.Style.OutlineSize = 1.000000000000000000
    LookAndFeel.Tabs.Active.Style.OutlineAlpha = 255
    LookAndFeel.Tabs.NotActive.Font.Name = 'Segoe UI'
    LookAndFeel.Tabs.NotActive.Font.Color = 4603477
    LookAndFeel.Tabs.NotActive.Font.Size = 9
    LookAndFeel.Tabs.NotActive.Font.Alpha = 215
    LookAndFeel.Tabs.NotActive.Font.TextRenderingMode = TextRenderingHintClearTypeGridFit
    LookAndFeel.Tabs.NotActive.Font.UseDefaultFont = False
    LookAndFeel.Tabs.NotActive.Style.StartColor = 15194573
    LookAndFeel.Tabs.NotActive.Style.StopColor = 15194573
    LookAndFeel.Tabs.NotActive.Style.StartAlpha = 210
    LookAndFeel.Tabs.NotActive.Style.StopAlpha = 210
    LookAndFeel.Tabs.NotActive.Style.OutlineColor = 13546390
    LookAndFeel.Tabs.NotActive.Style.OutlineSize = 1.000000000000000000
    LookAndFeel.Tabs.NotActive.Style.OutlineAlpha = 215
    LookAndFeel.Tabs.Hot.Font.Name = 'Segoe UI'
    LookAndFeel.Tabs.Hot.Font.Color = 4210752
    LookAndFeel.Tabs.Hot.Font.Size = 9
    LookAndFeel.Tabs.Hot.Font.Alpha = 215
    LookAndFeel.Tabs.Hot.Font.TextRenderingMode = TextRenderingHintClearTypeGridFit
    LookAndFeel.Tabs.Hot.Font.UseDefaultFont = False
    LookAndFeel.Tabs.Hot.Style.StartColor = 15721176
    LookAndFeel.Tabs.Hot.Style.StopColor = 15589847
    LookAndFeel.Tabs.Hot.Style.StartAlpha = 255
    LookAndFeel.Tabs.Hot.Style.StopAlpha = 255
    LookAndFeel.Tabs.Hot.Style.OutlineColor = 12423799
    LookAndFeel.Tabs.Hot.Style.OutlineSize = 1.000000000000000000
    LookAndFeel.Tabs.Hot.Style.OutlineAlpha = 235
    LookAndFeel.CloseButton.Cross.Normal.Color = 6643031
    LookAndFeel.CloseButton.Cross.Normal.Thickness = 1.500000000000000000
    LookAndFeel.CloseButton.Cross.Normal.Alpha = 255
    LookAndFeel.CloseButton.Cross.Down.Color = 15461369
    LookAndFeel.CloseButton.Cross.Down.Thickness = 2.000000000000000000
    LookAndFeel.CloseButton.Cross.Down.Alpha = 220
    LookAndFeel.CloseButton.Cross.Hot.Color = clWhite
    LookAndFeel.CloseButton.Cross.Hot.Thickness = 2.000000000000000000
    LookAndFeel.CloseButton.Cross.Hot.Alpha = 220
    LookAndFeel.CloseButton.Circle.Normal.StartColor = clGradientActiveCaption
    LookAndFeel.CloseButton.Circle.Normal.StopColor = clNone
    LookAndFeel.CloseButton.Circle.Normal.StartAlpha = 0
    LookAndFeel.CloseButton.Circle.Normal.StopAlpha = 0
    LookAndFeel.CloseButton.Circle.Normal.OutlineColor = clGray
    LookAndFeel.CloseButton.Circle.Normal.OutlineSize = 1.000000000000000000
    LookAndFeel.CloseButton.Circle.Normal.OutlineAlpha = 0
    LookAndFeel.CloseButton.Circle.Down.StartColor = 3487169
    LookAndFeel.CloseButton.Circle.Down.StopColor = 3487169
    LookAndFeel.CloseButton.Circle.Down.StartAlpha = 255
    LookAndFeel.CloseButton.Circle.Down.StopAlpha = 255
    LookAndFeel.CloseButton.Circle.Down.OutlineColor = clGray
    LookAndFeel.CloseButton.Circle.Down.OutlineSize = 1.000000000000000000
    LookAndFeel.CloseButton.Circle.Down.OutlineAlpha = 255
    LookAndFeel.CloseButton.Circle.Hot.StartColor = 9408475
    LookAndFeel.CloseButton.Circle.Hot.StopColor = 9803748
    LookAndFeel.CloseButton.Circle.Hot.StartAlpha = 255
    LookAndFeel.CloseButton.Circle.Hot.StopAlpha = 255
    LookAndFeel.CloseButton.Circle.Hot.OutlineColor = 6054595
    LookAndFeel.CloseButton.Circle.Hot.OutlineSize = 1.000000000000000000
    LookAndFeel.CloseButton.Circle.Hot.OutlineAlpha = 255
    LookAndFeel.AddButton.Button.Normal.StartColor = 14340292
    LookAndFeel.AddButton.Button.Normal.StopColor = 14340035
    LookAndFeel.AddButton.Button.Normal.StartAlpha = 255
    LookAndFeel.AddButton.Button.Normal.StopAlpha = 255
    LookAndFeel.AddButton.Button.Normal.OutlineColor = 13088421
    LookAndFeel.AddButton.Button.Normal.OutlineSize = 1.000000000000000000
    LookAndFeel.AddButton.Button.Normal.OutlineAlpha = 255
    LookAndFeel.AddButton.Button.Down.StartColor = 13417645
    LookAndFeel.AddButton.Button.Down.StopColor = 13417644
    LookAndFeel.AddButton.Button.Down.StartAlpha = 255
    LookAndFeel.AddButton.Button.Down.StopAlpha = 255
    LookAndFeel.AddButton.Button.Down.OutlineColor = 10852748
    LookAndFeel.AddButton.Button.Down.OutlineSize = 1.000000000000000000
    LookAndFeel.AddButton.Button.Down.OutlineAlpha = 255
    LookAndFeel.AddButton.Button.Hot.StartColor = 15524314
    LookAndFeel.AddButton.Button.Hot.StopColor = 15524314
    LookAndFeel.AddButton.Button.Hot.StartAlpha = 255
    LookAndFeel.AddButton.Button.Hot.StopAlpha = 255
    LookAndFeel.AddButton.Button.Hot.OutlineColor = 14927787
    LookAndFeel.AddButton.Button.Hot.OutlineSize = 1.000000000000000000
    LookAndFeel.AddButton.Button.Hot.OutlineAlpha = 255
    LookAndFeel.AddButton.PlusSign.Normal.StartColor = clWhite
    LookAndFeel.AddButton.PlusSign.Normal.StopColor = clWhite
    LookAndFeel.AddButton.PlusSign.Normal.StartAlpha = 255
    LookAndFeel.AddButton.PlusSign.Normal.StopAlpha = 255
    LookAndFeel.AddButton.PlusSign.Normal.OutlineColor = clGray
    LookAndFeel.AddButton.PlusSign.Normal.OutlineSize = 1.000000000000000000
    LookAndFeel.AddButton.PlusSign.Normal.OutlineAlpha = 255
    LookAndFeel.AddButton.PlusSign.Down.StartColor = clWhite
    LookAndFeel.AddButton.PlusSign.Down.StopColor = clWhite
    LookAndFeel.AddButton.PlusSign.Down.StartAlpha = 255
    LookAndFeel.AddButton.PlusSign.Down.StopAlpha = 255
    LookAndFeel.AddButton.PlusSign.Down.OutlineColor = clGray
    LookAndFeel.AddButton.PlusSign.Down.OutlineSize = 1.000000000000000000
    LookAndFeel.AddButton.PlusSign.Down.OutlineAlpha = 255
    LookAndFeel.AddButton.PlusSign.Hot.StartColor = clWhite
    LookAndFeel.AddButton.PlusSign.Hot.StopColor = clWhite
    LookAndFeel.AddButton.PlusSign.Hot.StartAlpha = 255
    LookAndFeel.AddButton.PlusSign.Hot.StopAlpha = 255
    LookAndFeel.AddButton.PlusSign.Hot.OutlineColor = clGray
    LookAndFeel.AddButton.PlusSign.Hot.OutlineSize = 1.000000000000000000
    LookAndFeel.AddButton.PlusSign.Hot.OutlineAlpha = 255
    LookAndFeel.ScrollButtons.Button.Normal.StartColor = 14735310
    LookAndFeel.ScrollButtons.Button.Normal.StopColor = 14274499
    LookAndFeel.ScrollButtons.Button.Normal.StartAlpha = 255
    LookAndFeel.ScrollButtons.Button.Normal.StopAlpha = 255
    LookAndFeel.ScrollButtons.Button.Normal.OutlineColor = 11507842
    LookAndFeel.ScrollButtons.Button.Normal.OutlineSize = 1.000000000000000000
    LookAndFeel.ScrollButtons.Button.Normal.OutlineAlpha = 255
    LookAndFeel.ScrollButtons.Button.Down.StartColor = 13417645
    LookAndFeel.ScrollButtons.Button.Down.StopColor = 13417644
    LookAndFeel.ScrollButtons.Button.Down.StartAlpha = 255
    LookAndFeel.ScrollButtons.Button.Down.StopAlpha = 255
    LookAndFeel.ScrollButtons.Button.Down.OutlineColor = 10852748
    LookAndFeel.ScrollButtons.Button.Down.OutlineSize = 1.000000000000000000
    LookAndFeel.ScrollButtons.Button.Down.OutlineAlpha = 255
    LookAndFeel.ScrollButtons.Button.Hot.StartColor = 15524314
    LookAndFeel.ScrollButtons.Button.Hot.StopColor = 15524313
    LookAndFeel.ScrollButtons.Button.Hot.StartAlpha = 255
    LookAndFeel.ScrollButtons.Button.Hot.StopAlpha = 255
    LookAndFeel.ScrollButtons.Button.Hot.OutlineColor = 14927788
    LookAndFeel.ScrollButtons.Button.Hot.OutlineSize = 1.000000000000000000
    LookAndFeel.ScrollButtons.Button.Hot.OutlineAlpha = 255
    LookAndFeel.ScrollButtons.Button.Disabled.StartColor = 14340036
    LookAndFeel.ScrollButtons.Button.Disabled.StopColor = 14274499
    LookAndFeel.ScrollButtons.Button.Disabled.StartAlpha = 150
    LookAndFeel.ScrollButtons.Button.Disabled.StopAlpha = 150
    LookAndFeel.ScrollButtons.Button.Disabled.OutlineColor = 11113341
    LookAndFeel.ScrollButtons.Button.Disabled.OutlineSize = 1.000000000000000000
    LookAndFeel.ScrollButtons.Button.Disabled.OutlineAlpha = 100
    LookAndFeel.ScrollButtons.Arrow.Normal.StartColor = clWhite
    LookAndFeel.ScrollButtons.Arrow.Normal.StopColor = clWhite
    LookAndFeel.ScrollButtons.Arrow.Normal.StartAlpha = 255
    LookAndFeel.ScrollButtons.Arrow.Normal.StopAlpha = 255
    LookAndFeel.ScrollButtons.Arrow.Normal.OutlineColor = clGray
    LookAndFeel.ScrollButtons.Arrow.Normal.OutlineSize = 1.000000000000000000
    LookAndFeel.ScrollButtons.Arrow.Normal.OutlineAlpha = 200
    LookAndFeel.ScrollButtons.Arrow.Down.StartColor = clWhite
    LookAndFeel.ScrollButtons.Arrow.Down.StopColor = clWhite
    LookAndFeel.ScrollButtons.Arrow.Down.StartAlpha = 255
    LookAndFeel.ScrollButtons.Arrow.Down.StopAlpha = 255
    LookAndFeel.ScrollButtons.Arrow.Down.OutlineColor = clGray
    LookAndFeel.ScrollButtons.Arrow.Down.OutlineSize = 1.000000000000000000
    LookAndFeel.ScrollButtons.Arrow.Down.OutlineAlpha = 200
    LookAndFeel.ScrollButtons.Arrow.Hot.StartColor = clWhite
    LookAndFeel.ScrollButtons.Arrow.Hot.StopColor = clWhite
    LookAndFeel.ScrollButtons.Arrow.Hot.StartAlpha = 255
    LookAndFeel.ScrollButtons.Arrow.Hot.StopAlpha = 255
    LookAndFeel.ScrollButtons.Arrow.Hot.OutlineColor = clGray
    LookAndFeel.ScrollButtons.Arrow.Hot.OutlineSize = 1.000000000000000000
    LookAndFeel.ScrollButtons.Arrow.Hot.OutlineAlpha = 200
    LookAndFeel.ScrollButtons.Arrow.Disabled.StartColor = clSilver
    LookAndFeel.ScrollButtons.Arrow.Disabled.StopColor = clSilver
    LookAndFeel.ScrollButtons.Arrow.Disabled.StartAlpha = 150
    LookAndFeel.ScrollButtons.Arrow.Disabled.StopAlpha = 150
    LookAndFeel.ScrollButtons.Arrow.Disabled.OutlineColor = clGray
    LookAndFeel.ScrollButtons.Arrow.Disabled.OutlineSize = 1.000000000000000000
    LookAndFeel.ScrollButtons.Arrow.Disabled.OutlineAlpha = 200
    Align = alTop
    PopupMenu = mViewTabsPopup
    TabOrder = 1
  end
  object mViewTabsPopup: TPopupMenu
    Images = vImgIcons
    OnPopup = mViewTabsOnPopup
    Left = 512
    Top = 120
    object miSeparator: TMenuItem
      Caption = '-'
    end
    object miCloseViewTab: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1082#1083#1072#1076#1082#1091
      ImageIndex = 8
      OnClick = miCloseViewTabClick
    end
    object miCloseAllOtherTabs: TMenuItem
      Caption = 'C&lose all other tabs'
      OnClick = miCloseAllOtherTabsClick
    end
    object miCloseAllTabs: TMenuItem
      Caption = 'Close all tabs'
      OnClick = miCloseAllTabsClick
    end
  end
  object imgIcons: TImageCollection
    Images = <
      item
        Name = 'Item1'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000000FA4944415478DABDD12177C3201405E01B07AE75B191C8D6CD4EEE77
              54E627546E6E73995B2471894BDC2A53D7BA5422C18103C75EB333BB85F69C81
              7AE27E70CFCB2222EE39D9BF00C3C9C5E11450EDF22C19E8AEE131C0D3956591
              0634A38B930A287286EE68D1EF1380FAD3C58B0910140E34CB83C6F8229601EF
              BD89CA610E1B17C01881044C6F9BBF815DA522631CA2607014B6C1634D733568
              E87A01B097F4BAF5D8161C9A7EE1BC47CE39EA5E41370FCB2A941F2A2AEABF11
              6B18C2569C2AB406B65B08FC54B96E602BD83CCB46C11E1ED3D658BE5EE23823
              2BB4DD0DC08C3C1332392865618F4FE9C037728EB2D5B0E71B81DFCEDDC0172F
              5C9EF1CAD9D6370000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item2'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000001024944415478DAADD0A177C2301006F02F2E738DA3B273C5114765E7
              3A375C91CC812B12B9B9CE21B1C8FD0B93AB2BB2B2B2B8D411775C8B5C47CBD8
              99E4DECBF7BB7B1104C23D25FE1D78FFAC69EA4B846329FE0C9CF80C3C8948F7
              233F80CDFE489A37282AC053401C38E22660C540C8D32DDFF3D2C27580E47924
              0603AF5B06B48431809440561838BC493AF7C420609696144D148EB56DFB06F9
              62A4AA2CF28F89E8059EDE0A7A61A0AC2FBD6A80DC60C45BECD77E3FA0938266
              8182B1279EFED086C71CDE253EBF463FF0B83C501CBA687EB10DF375D731F957
              C05D1C681E3AF8CE6B6857627B25DC0DC419791C1C12EE045494D18237480784
              3B815BEB6EE00CD8C576F1855966C90000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item3'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000001724944415478DA85D2A17383301406F00F17C4EE8AA312C9DC26919D
              DCDDC4EA864422999B656E73ADDB24FB1326272B8B2B6EC8E282232E7BAF8530
              56CA720797CBBDFCF2F8889566DF5A360A4A01103083A7C1A583FBC0B53031AC
              E46DA793BB39EC8B9959ECAC2CAF01A910DF9E47AC988034F451D6FD22771478
              02450514FB23F270338E58F16AA75FA21EE0D35503788E8210821E20FD284087
              4C00B10F3EE890438B6C49548D32856525CDFCDA754C4703A0DBCCAFAF5D8578
              E1A2EE0D1374B6A1E25A22597AD609D0153210062E65400B363D0D47A1B0F005
              F2EAD821A41C76D0D61DC6E7B642C440073340AD790EE0B4D984CF791FE25E8D
              037FC36DA80B5E0AE602C9BA05D2C8A3F6C42430406876C9C0AB01FC93DF936D
              4E81DF883F0722069EE82271D2925EB6E8EF3207962557874F1BFC8516F1E9E2
              860C68E8D12BBA4C73FD4E803C0378B3B68329609D7814DAEC0C501350FEDF41
              B7418CD4C4531D3CAE0A5D522E74E12046760BFB88FE00AB94F2064E73427C00
              00000049454E44AE426082}
          end>
      end
      item
        Name = 'Item4'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              610000017A4944415478DA63FCCFF09F8112C0083360FAD2CBFF5FBEFD0E9750
              92E163880BD2605CBBE3CE7F432D510625397E469C06344C3A0536252E401DAE
              70D1BA1BFFEF3DF9C4802E8E61C0C275D7C10A75D58418823D545014ED3AFCE8
              FFB1F32FF01B306DE925B0D3C585391932A375311481BCE66E2B47D80010C066
              08C130D879F821D899C8C0CA5082C1CD560EAB06AC81881C60C800DDEF1EEE1E
              FF6B6A6A186C6C6D18616C78349E38FFE2FF8EC38F300C814527D836A072A07A
              1436237A42BAF7E8E3FF451B6EA2888162C8509589C1CDCD8DE1CEDD3B8CF7EE
              DEFB0F6383A3116603B62804819D6BBB194E1C5C83E1BACCCC4C482C8042D9C2
              5002C310500C5CBEF50ECCE6FA7E80414E4E8E21223282312B33EBBF9D9D1D98
              0D36E0CBB7DF0CA5A946380D0085C3B299050CE8010862A3A4030F608281B904
              392C5E5D5FC0307DFA74DC5E80259EEED9E7FE7FFDFE0723069003EDC8E123FF
              5B5A5A1876ECDCC1084F0784C08AE52BFE1F3A748861DAF4698CC86C901C0035
              0BE9B33CC96CF20000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item5'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              610000027B4944415478DA7DD3DD4B53711807F0EFB1E636E7D1B67C9B6EB84D
              9420E9A6DD0459DDE585EE0FB022197A9337D54D322AA2F0A2BA8C18158237BD
              1891285D046945B4D16846245D04CE54864AB9F3B2EDECCCBD3DFDCEA920DBF4
              C081F33BE73C1FCEEF79BE872310763A1459A44C3A85F5F812A4CD0D1095606B
              B4239FCF212D25D89AC0FD0FF48C7DA6B1A3223AEA15A4952C0C5C1639558685
              B7A0AEC503738307AB9129F00DEDA8B139CB81AE4B610A9FCEC26A3322290BC8
              2812D4B40083A91E7C8B1BBCBD0BDF4393A8DDEF86D9DAB61D181E77D0D73505
              CFFB5EA0A9C9C0804D28AC585504EC35D5816F76E9C072F829035C30EDFB0738
              7BAF9DAEFBAE6170C28FC7BDEF752021ACA3B8A5229DFAB13B7026E8A0802F80
              D0B711E48A3CC2B11C88CBA3903522D8F310A21CC71E135F1938790B74FBD40D
              4496AFA0C43EE6A07D101C2BB6186D181ABF83D9FE1924E41554196B2B03BD0C
              B8D07F11426102A92D8115035C15D06D1FC0C8FD4798EB9F66C0EACE40341AA5
              D1575E9CEBF3236F9EC29745117311A0C0FAD2EBF6E27CF72824796DE72D683D
              988FCE5360D60B7F9F0F77A767F0E4D86BB4763523236D404E6EB0496CFE6EA2
              36C6160D982C9F82865C7DEBC54FE504268F8FC0D9E9448A8D31A388C8B2311A
              CC2C07CD7F72C0009EE5601BF017197856CDF6BD004767078B320B12CB413A29
              608BAA515DDB88FAD603585F7803535D038C165B79120F5D0E51D035854C91D3
              A7C2695D8576128A2CFB5463D7D75C3601AEA8960343C177F471AD84227B8988
              D3EF6906AB459EAA30D1F91225F6EC66DC8B45D55A0EC41663244952C5BFF3C1
              27151FE205BDE2489B01C3874DE5C06EC7526C894451D4AFAD562B3C1D1EEE17
              C7E03D19351916CE0000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item6'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              610000027F4944415478DA8D935B4854511486FF7DE6A2E3CCF1CC991C9C39A3
              A833D64441941A8682141504815D08CC3721A2D4679FB48812A997EAA12B864E
              48177B1932ED02819A681A8350264691374C332ABB385A33CEACF6395A3196D9
              82CD662DF6FAF65E6BFD9BB5B7DC20A2286C7627C2E110A63F7D000FC0AEA421
              29D905B328C12CD918963036FAA49E121D6E9892DC18EDF1434C4A43822D1511
              5D22483061FAE35BC40B210C4C8650D99E888EAAF5313036FCB89E44470644E7
              2A0C7536C2B2220326D98504AB0B71929381C2844810EF5F3C455E831E2F4FE5
              C70286544072BA0618EEBAC501E988B7AA0045DD192273049AD60085FE5D58AB
              58507B608CFD07C0C5778545BF0749D011DE3DEF43D1BD3CF84AEA70B4E918AE
              1E1A61FF0498E514AD84E2731241F8029D60409E271E46DD57E47BCFA3A6A906
              0DA5636C4980454E855172B0AC2A46F587CB100C7DE6D331A07FC20781DF9D9B
              7E0215D78E6059C0864A4617CBF7A37FF226F8B4390410E36CB0E94B70E6CEE9
              E54BA8F6EF247FEF5D18F5C0D65C605DA60CC3EC1E5C68AEC3C9ED8105803A46
              870A68FCA3893FBBFDA6B3838A5B0B50BEBB1075CD4DA8D91640764E3663233D
              3EFE82051D7080C875A0024C9232AF8328D741F41BD7C84314B59D85DDFC08C7
              37CF276B531868BB44468B1D92B21A137DAD308932543FD59B03C4C9F32FA019
              1AEF6EC196DB5E5CDF17FE95AC011E5CAEA088DA9904A7EA0233E31010E50D8B
              F015D50E09820E668380B291BD7856BD48896BAADAB95805F856DED70225AF76
              C0C0D444FA7D882F1D236C54045C292D8805040201AAED9D45F7D89C16D894A2
              C7C12CD35F7F9ED56A8527D3130BE042C7E0EB419A9A9AD202B22CC3ED712FF9
              7D17DB0F0AB7070AB2502EB30000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item7'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000001A54944415478DA95932173C24010855FDCC511D7C8C8D4816B642438
              70E52780A30E6470D41589A40E1CB846820397C893C1E55CCEA57B7705129896
              E99B49E66E36FBDDDBDD9C55A2C431A3D78FB25C203ECAF3166E0360ACC03A5E
              E36B3AB27023EB16A094F2130EDCAC250A30D8F424B099C4B8D7B61E0294E2C3
              095C1415273696F1070661884127B41E02D4D9AB430621CE7B1BFE5381ED7E8D
              CD6454076C1351BA4EE39E0181E54E424A5306BD20F31D7C6ACCD985060C57BC
              0C3C4707EE7C1427AC8EDA9096F704449F334CBA6D0DB90054D0776D049E82B0
              1A24CF39F6D4D426C57D1738724E4DCE10F5BB1540E584F0D9BD401895E1B24C
              AF1833BD50EB305A604763BD0064AE06063D308FF2BB2D47231C9D6CC434C100
              5A931992F7E806402E6CFA86398C4E050681AC378400EC37802A411A0BDA6A93
              5CF47C5CBB7753420DD0891665F8122213364C21540225075E35DD246FD382FE
              0FD5488964EA1B80526F362F0595F1DA6943140EFA2DA0511F06E214785BE597
              7D0D709601098CFB6D72E0D562C3758E5D22FF0628CD37719966EA42710879BD
              0F60A1BA158F01FFD13767C3E2F141B546FE0000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item8'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000001684944415478DAA5932F7C824014C77FAFB1266D462236D666640D9B
              8B4469D8B686111A36691859D3266D44D6B46993880D1AB4DB897F98EEA31FDD
              DE7D3E77F7EEDE7DEFDDEF3E8F1818FE63348BD72CC980343FDD287943517B55
              BF1BD0144A28AD47686D89C89EAC59A321DE7D73B25AC1ED3F1359C1FA4F6FD8
              A41BF8EF7B80AD4B742FC0B023E60FD41F80BD9A65FDE45A8BB25E2AF8446A0A
              74117072BE3C91F0E8344481743B64C140237A0B96CCD5E513C0591267200E78
              00E91607385B80CF01C66FC03590700FE060E1628A681E22CFD3CACF321913C7
              2532477336EA2B5701E1D7071669044556208932C2E514F122822AE9A8015BBB
              0031861D7435AD9A6B2D93869F46153709A333C005EB584FCCD44D7EB8778C0B
              971E1B7836C80D6296A4077D0A1C4BA0A8E54BF23E5EBB6A1563BDF8E4F00C84
              4306B754A3371BB26835465B69436E2A58A50BAE41BCD3E0D672F6660E9B4663
              64650191FF6357EDC1EC58F40D16B3CBCEC1C2C4A60000000049454E44AE4260
              82}
          end>
      end
      item
        Name = 'Item9'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000001674944415478DAA5D3217482401807F0FFD7CE060DE2AD6DCDB52D12
              5DD348B569DB1A46D6B069D348744D22519B6BA379916BD8A0DD0EE760B8A74F
              B7E33DE038BEDFDD7DF73E5250F84FA3E56AAB4406A4BBE640A12FE4756F7FFF
              7AC06605DA77163A8F9CC85F6C95619857CF2C9204C1F081C80BB77FDA834C25
              662F07C077395D0BF4FD58CD46CE0FE090CDA2DE729D8BA2FE94EB176E333A09
              34E28B460AAB8E613272FD4885A30ED173F8A102F7B6011C2DE208D2400BE47A
              1A782D819906FABF817310BB06A88EED6D0A194D918B042D8B236E3DC09B8744
              83C9464D86EDB3401998C521B8D303E36D144984248E603B03D440D94E206BF7
              066D77002662BD9415609AD8318E64238E80132D764839C102B8EF56FFED3C5B
              6DD61214842B25D2EFFCE4A84A20AFD3D77B77D1E9EAE58BA51E9728CBA6AC0B
              9159A04BAA512EC62A8DE6B08D028C09645207EB49B9EB5F06EC91E55489708C
              5C0A7D0A16ACA7A1063CFA04325BCD9D0FFF130F0000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item10'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000000444944415478DA63FCCFF09F8112C0380C0D58307F01582021318191
              18719C06202BC62686D70BC81A9001BA66BC61806E0836CDB43380222F501C88
              144723A9601818000066424FF1A91A35C30000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item11'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000002114944415478DA9592D14B536118C69F3373EE1CD7A66B82DA6A1C4E
              36DD6A06D5C5E86617B61C4114ACDA850545DE7413D17F11DD7967370B041723
              B2CBA1E61A0503E10CE7DA866213255AAEAD29E79B533BFB3A27E8629C4ED6EF
              FAFD7E3CEFF7BC0C05854AA3B1470B6B6B286E6EA2B6B3836EAB1582D3894141
              407BFB11063A30AA60E55391BE5F5C84DBE582D3E180D562416D7B1BC58D0D14
              5657E1F7F914D9C93F4A1852AFD3A9991904FC7ED86D36CDC0D7721973C924EE
              8542307618351226954ED37D5986D7EDD64B0931938185E370DE7B562B783E3D
              4DAF8C8C8063595D814408E61309DCBF7D4B2B78363949C7C261FC8D66B38968
              2C86C7E30FB4828948848E0602E09488BA092409730B0B7878674C2B78974AD1
              DAEE2ECE0D0FEBFF8128A247A9F5D2C50B5A81B21F55D6403018448FDDAE795C
              2A95109F9D45F8EE387ACD267475B4B5487EDD81B89CA5AFE3719CF178C0F33C
              8E29759695FA8AEBEBC8E572F851A960EFE6131CC814D7FA595C76989916818A
              7A894AA5C8E4F3F8B2B505475F1FBC4343B0F11E4CE4087ABB8E62B0DF88E44A
              05D71D1C02CE4EA645A0C7B7BA4C1FBD2D43AAB6C1ED31C37BC28844B68A1B3C
              8751BE933954A0F22A2FD1689EA0211930705A3928DE84F9F4778404F6F004BF
              8965253AF591E0A06180708A856F80C59B0FD57F17A8BC5C92E88B65022A1B70
              DC65C2E702F93F814A542434B24420EF533CBDDA8D9F2454DBE2F79AB1F10000
              000049454E44AE426082}
          end>
      end
      item
        Name = 'Item12'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000001704944415478DAD5924B4B027114C5CF7FD4111BDB18A5B828C91E20
              2E2A50C3F15151ADF203147DD3EC616845693E4A0D05A74C4BA522A455E3CCCD
              6621A4E1A61675EFEE72F8DDD76104C24F82FD6D80AAA8C4E938D65F27958871
              8C0D0524E271AA566FB1BDB3DB0374E40E45A37BD0EB7558DFD8FC1ED06EB7E9
              38768485A5454892846020A4091B8F0DCA64D2F0783DC85DE5B0BAB236082816
              0AD46C35E076BBC1F346E4B259048221964A2649850CE7F42C0C061EE9CB0C42
              E1D057C0C1E13ED9ACE3B08C59BA23F2E018A77552E40E1C335310464661D0E9
              C1385DB7511EA2D80748A6CE89A0C06A9B80A228301905946ECAE8282AACF631
              9805015D01049319E552057ED13FB842EDBE46C5520173F34E6D82AA54851808
              B36C2E4BEDB757381C935ABD7657876FD9FFFD11E57799E22731D8EC563C355F
              100C8635E1F3D333A5321770B9E6F1506FC1EBF10D7F63FE3A4F9254C15624D2
              7BE3A72F4ECF1260DDF48B81E1805F71E2FF007C00DCEDB3F158110FED000000
              0049454E44AE426082}
          end>
      end
      item
        Name = 'Item13'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000001734944415478DACD924B4B42511485D731F5A2F45007428A2F482B2D
              BC9A50F9188462FD5A9BE720DF57E78A85595437074948693EAFEEAE0E0C5268
              D020CF78AD6FEFF3B11981F097C75607401322A660EC6760329E90624DC17E05
              A45369FA68BFE33C7E0135A79E172E1309DAD8DA44F42C8A6503E680D4758A7C
              7E1EA552112EE71EEC0EFB2C9CCEA4E9D07380BC5040381886DEA067CB37C8C8
              00DE07260FA93FDCA3D36E23741A462E9785FFC80F499250A994A1D5AC83F7F1
              6C0190CD64C9EDD993D75460341AA2D7EFA276538352A99A164044188E0668B5
              5A787E14118BC53175F30DC865C9E5DAC167AF238B93D01FF6D1109BE0380EBB
              2E273ADD36989C6DBEBEC9C28193E3E0CCC91C50C8E7C9EA30632C9745B1014E
              A545201060C5629ECC966D48E331EE6EEB326C1F569B6DF10B45A14016BB09D5
              72156EB71726B369169A0274061DC4A71784821168B49AE5120541A041BF8750
              2802955A350F25935764341AE1F5F24B6F61854EF9DF005F50AAB2F14494154E
              0000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item14'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000000C34944415478DA63FCCFF09F8112C0386A00C4800BE72FFCDFB3670F
              56052E2E2E0C0686068C780D686F6B073BC3D3D39361FBF6ED0CE8ECCAAA4AFC
              06343634FEAF6FA8072B02B14134321FC6262A0C2A2B2AC102ED1DED289A7ABA
              7B3002ABA4B48411C38082FC02B0C0848913500C686E6AFE5F5B57CB884E6318
              909E960E1698396B265667979795FFEFECEA84CB6118101F170F1658B8682156
              03323332FF4F9F311DBB0191119128A62D5FB11CC590D89858B8FCE2258B19B1
              BA805430F0060000ADE26CF125392BA90000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item15'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              610000011C4944415478DA63FCCFF09F8112C038020CA89AB2F3BF9C20034346
              B43B23590624B4EC022B5850E346D8803397EEFC9FB2E91E989DE3A7C460A2A7
              C20833C04211A20EDD25280678644CFF2F21A30C668B4B2B33841AFF670019A8
              6FEEC670F1E42EB018F3D73B0C6D390843305CB0EED05D86671F18C19A385FED
              6438711FA216E485194B77FEFF2EE60E1687B9046E0048F3EAB310C52F9FDE25
              DF009013414054DD1D6E00B21740862307288A17403680344809FC077B031490
              202F9DBB728FC14847092E060A5CB801D397EEC08847135D65144530179EB97C
              17331A139B37FF37B5F74111FC7F7F334356BC2F8A01D3166EFECFA8E88BA2EE
              F4C12D0C8C93E7ADC5708199A116106BA01870EADCF5FFA72E5C47B79FF2BC00
              004126A65E75C4B8F70000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item16'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000002AB4944415478DA5593CD6F4C6114C69FFBFD3D33D5B4512121A42DAA
              DD894E1742FA07D8B193585AF90F246C6D2512840D2B2BD2050D121636089DD1
              9486B6414B693B339DFB31F7EB3873AF4E67DEE42E6ECEF3FECE39CF7B8E4020
              749F3425AAAC84F8FA2BC2860788A2008108FDB680B1032A0E0F2942B75EE806
              6C6E27F4F4830FA82A0C5D82A9B2A0AD20015E08B86E0C478E313D6EC0D445A1
              07B0BA11D3E3B71E06074D78410CBF15C3735B48D2348BDBB6CE9714E8AA8CCD
              4D0F17CA360A9698F1118629DD9EAD6360D042C30D112784C06F617AA288B1FD
              0AE6BE87783ED780AEA99064118E2123F4025C3C5BCA01AFAA2E7D594F212912
              7C3FCE6A8AC208E3074D948775BC5EF05159F1A12832B81F5896CA09229C39A6
              E52DDC9AF94B46C144A319E60DFDB7A5BE5507A53164558369593DB1A2AD4043
              08C10D12BA39B38E529F85269BD4D170A6C9110393C3065E543CBCFF1664911D
              488101CDBA0BE1F756487767FFC0303444491EDC114D8DEA38C52DE480569BD9
              49A0CA027C8F01DB7E4C371EFD80691A4849EC2A935066C0E4B0C68000EF1880
              0E80C07621F4DDDC83ABF71649B70A88628228891D6179546380CA801657B0EB
              4FCABEB4019612E58007B3ABF4792DCE064696151E1E21134F8DA8DC828297D5
              9001519E9DFB88E3086914E0F4445F0EA86D4774FDFE029CD21EB442A6CB32BF
              B78C13C74DE8BAC84F9BA23AEF218E22BE1C738C13442EAE5D3ABA3B896F3E6D
              D1C367CB2894FA33B3D224E13D1021F0473C8DED89942529CB1E780D5C393F8A
              434386D0B30BF34B4DBAF3641124F02E583624BEC0D39E959DF0C566A38EA223
              E3F2B923D837A0E7BB902409B171C2F2D232359B4DFC5C5BC7C7D522D66AE0C1
              0AB22ADA00C794B1D7F670F230715B3A1CC7E1FDB07BB7B17DAA952AB5332B8A
              92096BB51ABAFF354DE39D19E8ACF43F3255635036E0C7830000000049454E44
              AE426082}
          end>
      end
      item
        Name = 'Item17'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              610000021C4944415478DAA5935F48537114C7BFBFFDBD9BBA39AC64B274CA90
              30DDB2268DC148C124114B52828C5E2216245410F53C8982B2A01E8292E8A917
              9F7A887A2F82A0A768108AF5306950DAF2EEEE6EBBBBFF4EBFEE9E62118E0EFC
              9E7EE77CBEDFDF39E7C70884FF09F637C0D76F226D6C56D0BFD78F5D8116D634
              E0C1B337742819C5F3571F309D0863341E664D0196965FD0607204AA6E62752D
              0FBB66E0D2A9385C2E07DB11E0F6C3150A0D1D8461F25B22542A2A56D70BB83C
              17435F28C01A00D7EFAC506EAB64259B7A0DA6A6607C72C242138798A6C98F81
              CF39116307C2981D8BB03F0053E9258A0EEF872078E174B9E17038C16C362B81
              78B161E8D0350D9A56832829F079DB71ED4C1CFE3681598023F3191A8C0DA1A5
              D507C1E381C3E986ED37805B30B8B2A16B50AA5588A284ADCD1FC8E5F2105A3B
              F064F174DD41647481BAFBF6614FB00B3EBF1F6E571D60707555D5502E2B2895
              2494A422A4E23624711B9D9DBBF13873B60E08A7D214EC1E4057A80781403B3C
              8200BBDD0E93EA80AAA2409665AB502A16908C85B1B830055F9BB7FE84897319
              CA7F2F5BEA1E971D4E870D23A969E8BC58516A90CB65482519626103E91371CC
              4D1E66FF1CE3CDBB8F88F51E835A51B8FD2A0A5C55FDB98E1B1767D0DB136C1C
              6303E0DE320903C7A188323E7DC922DAA1E2EAF959DEDC1D2ED2ADFB4F498B8C
              E3E3DB97B83293402A31DCDC2ABF7E9FA577D9355C38799437D5DFFC676A267E
              011B30FF2739DDB0160000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item18'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              610000018A4944415478DA63FCCFF09F0104AEDCBCFFFFE0C98B0CDFBF7D6790
              101362B872EB3E83838511C3FA5D871902DD6CE1F4DAED0719A2FC5C182C8CB5
              193839D818196106B44F5BF2DF504B95E1D7AF3F0CFC7CDC0C4F9EBF66D05091
              673877E51683918E1A9C3E7DF106C39BF71F18E2833D1864A5C4100674CF5CF1
              BF24548FE1FFC38D0CF80023BB30C3E2EBF20C8E9686580C085060F87F6D3A5E
              0318B82419963C71C46DC0ED835319365DF88D55AF282F1343AC931C7E03DE9E
              9EC670F3E53F148D9A124C0C025C8CC4B98062036EEE9FCAB0E61C762F48F031
              3224B9CAE33780AC40BC79F7D1FFCE19CB1994A5F81818BEBFC46F00131BC385
              27BF18FEF1B33214870532301E3D7BF97FEFEC550CCB26D632B0B3B332321001
              A62CDFF87F2BFB5306999BBF19C02EB870EDCEFF59CB3631284BF233FC27E802
              5686B38FBE33FCE26561C8F2F362C01906375FFC03C63B233846FEFC6560B055
              65262E16284A89A561060CFF1F6DC16F00BB10C3E2ABD29806344E58F09F9B93
              83983064B874F32E436B492AD800002B92E630CE7B53450000000049454E44AE
              426082}
          end>
      end
      item
        Name = 'Item19'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000001CF4944415478DA63FCCFF09F8112C04815034AAA1BFE3F7EFA8CE1EF
              DFBF0CFFFEFD83E0FFFF19FE81F8601AC4878AFF03F2FFFD05D387766C64642C
              A969FC9F9B96C0C0C2C2C20073CDD69D7B19FE833402358184401A410044FF87
              D2C74E9E6658B5700E23634462DAFFDED67AB0027C0680E4FE036D8589AFDFB2
              83E1E0B60D8C8C316959FF3B1BAAC10A724AAAC10A205E813A15CC071A00D434
              7F5A3FDCEFADDD1319664EEA65646CED99F03F3E3204181A6027A0B804442107
              32C8701858BE66034379611E233810436293FF2BCBC930488A8B409C0872F2FF
              FF708C8B7FF3C153482CCC9A3DFBBFB9A12E03373717C256741AE204080B4A9F
              BFF11062C0D99347FFF3F3F1A1284076725A7923C33B873E86DFBF7F03BDCAC4
              B02EF0370317171783BC9C3C238A01A7CE5F6678FBFE0338E0409A85F8F9182C
              8CF418D2CA1A18DEB9CD60F8FDFD0B03031333C34ACFCF0C9C5C9C0C1CEC5C10
              17E49796FFF77575649097918204E17F7808829D9F56DAC8F016680038510163
              6783EF2770BA59B17633C4806D3BF7FCDFBE671FC3DDFB0FE0D10832041C9DA0
              14088CC6774E7D0C1C17E7337CD14960E0DB950D3648525C8CB8BC109594F13F
              3E2A9CC1DDC59171E79EFDFF41347533132500003DC05A69676DE8C500000000
              49454E44AE426082}
          end>
      end
      item
        Name = 'Item20'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000002154944415478DAA5D2EF6B52611407F0AF2E10E64C485DEF0A59F507
              44B45134A8DE0749BD5941A35AF9ABCD953AA7F72ACE5FE9ACB91F3A2DC6C662
              32F6B7143618448D08CAE66CC25ECCEBC017F7F478B789B731103A179EE7C2E1
              F970CE791E0581D088E5FC1A95CA6514BE15D1A133A2BE5781512B427F460722
              115FBE6E2211F2A3DBA057A025144740626A8EDC0E3B1EFA73A8184D10B70AE0
              6F6A71E35AAF94B7BBC6D1A154C2EB74E06CB741710C98997F4FC3E6213CE0B3
              D83A67C2A9F267F0B7B4E83F049C5C0003F7EF6269650D3ED768136902D39977
              34627986012E8BD2791394DB05046E37803E29BFB4B28AF58D0D54851AF6AA02
              5617737220C5000703EE99DDD0693528EEEE63ECD11DF45FEF6BF62B08029B07
              61723683A0D72D07A6D2391AB53EC7E6F71FB8D863C4EFD236345D6A9CD6685A
              67867ABD8E483285A0EF04A09DF0471398F817783B97A59736331659AF3B951D
              882249E58AEC0A493CD80D3A3D2C4F06191067C0981C78333B4FAFEC96B62AE0
              237184B8FF00B8F06B84798F1C48CE64C8F9C28A850F79FC612DD0092DD8861E
              3320C680713930399D21D7B0B5AD0A7CA11822FE63409A01367C2AACB3C77270
              DFD2C7D25D9D9DB87AE5720B106580570E245269728FD8F05102AAD2C1C6D280
              D46A357A5B00EF4404D1804F0E0463490A789C6DB5E0F07048C5C3726061394F
              3F7F15A152A964833B7A0F74F85FABD570E9420F2C4F0725E02FD7272D00AEFF
              159B0000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item21'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              610000024E4944415478DA95D25F4853511C07F0EFDDDCDF66C94C1DB8920AD4
              898D2271D943CD8A22D61F6D923D046110BD642C49AC19BE1463B0598D0AA9F5
              6794582FEE29CA2212512A02455B427F169290E1DD9D238BB6B5B9D3DDBDDBDD
              863EE4B9702EF79CF3FBFCCEEF9C4B1110A4DBD8B88F0C0E8F80F9F9070B9408
              12C4A0D514E348C3411416AA292CD1A82410094789FB412F7E2DC8A037EC8062
              850A62711E086B33F40C4606FA6132D661CFEE7A6A49E0FAAD7B44555A89B51B
              7450B2C160B3A7F7954412890406BC1E1CAE3760CB667D0E428D8EBF272FDEFA
              506BDC07A56A2517901DCCBDD9271E8BA1FF8E038EAE0EC8153201A1BA6FF490
              8ABAFD501795002211179D0D10A44E89ED26DE0DA3A62C1F5B6B6B3240A7ED0A
              D9656E61EBCECFCD9EEA38203548FFF88E79FF1BB41C3B9A01AC7617D9DB7402
              12B92227BB88E2857802021C098731F6D483F36DAD19A0CBEE243BCDA7204D02
              A9CC52315020A7B88FB94802D1383F3EFDF51324213F9ACD8732C06DCF43B2BA
              DC00CD9AF542769504504AF835BF6304F3517E66E899178DDBF5A8AEAACC004C
              3048EC37EFA2E1B885BD3DFEFAC4ECF42A19BF2014E1CB980BCC62F4791F2E75
              B6E75E63F2905EBE1A22AF27A7603435439C274D9FBB507B88A1F1D8ED84F5F4
              496CACD62D06D2BF71AFF709CA376D8346BB0EAA0235E899694C7D9EC4DFE037
              341D30E17EDF2374585A51525C442D02C09D72944CF83EE0E3173F682688326D
              29AA741542CD748021B66E172EB49D11901CE07FDA2C1D2036E73558CF593864
              D9401AB9ECB88A8BED6797BF836CC4D5E3C63F25F0023D6EB0A19B0000000049
              454E44AE426082}
          end>
      end
      item
        Name = 'Item22'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000001134944415478DAB593B16A83501486FF0B3AA438BAA4630ABE41B338
              35901A7014DF40107C01D3D9CD45372709E2D88CA9555C9AA55905D766A84BF3
              026EE26975AB149220FDA6732FF77EDC73EE398C40B886EDF3967CDF87200810
              4511EC12C1FE6D4F5996A16D5B2449822E9EDE4ED94A59D15941F55991A66908
              82001CC7C1755D98A6094992A0EBFAF917A4AF29154581F5D39A75EBE3C7913C
              CF435DD75055F57AC110B6D96C288E63F03CDF6F344D03DBB6B17C5CB28B04B2
              2C539EE798DC4CFA03A7AF13198681DDCBEE4FC1E1FD408EE3F405FDB90BA628
              0AA559FACB3EBF9F9365597D5C9625AAAAEAF3ED88A2086118627637638B8705
              8D178C4E617411477FE3BF37D2E856EE18354C4386E3FC0D0526FBBF1AB2CB80
              0000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item23'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000002244944415478DA7DD2CF6BD3601807F06F1A70ED98ADE050A70775AB
              55C1C3C09BE28FA1389D070FFE82AA205E85E161EC202A82C8145B2A133CE974
              3FF07F10E6AA1B8AAE1EE6B6A0CC8B4297D2E1C0A924A969F2F8BC6FDAB86CEB
              0221A179DFCFF37D9EB70A81202ED3B4E8E6FD5ECCB9EBE0B8C4B70B979F2E3F
              C5BB6DFD8191D7D0BC6D2B1EF5DC42241256C43EA50A8CBE7D4F031326EAB6B4
              C2B009B6C3087F725CC02542499F46E1DB8C44D3C93D683BB83F088CBC19A317
              9F552C3424F0C3E0EA72F37F442D7C4469610E65FE2D75BA19C78E1C0E02AF5E
              0B2004BD2E01AB4C7293582C21BE43BA008A124D9F69590E8804431A03E1044C
              9BFCEA0210902A805F9C80E5CCD9F8CA09863405B3E19DB004405E0AA7D24A35
              819841E65C0D6090019D01E3AF1BA8EECA19E460F10C1C561F32D07EB46D490B
              0C3C9F56FC16BCCD5E7557CE2087D2CFA24CD67B7EC7CA09FAA7205B302A80F7
              7FF0DA5019D86B66B1A1713DAE5C4C22DEB27D09901DA567539519F0292CAE2E
              90903E8E07C7A37EE5EA1548D037490CECF24FC16F8363ABB33906D6FABD2F03
              863941DF247CA0BCA8BA078C23DD11AB9D40004F3F0179062CCB428336288F6C
              7EF72538CA1A9E010327A2AB27783241D0439B10D30670B7F302882B77A5FB91
              8F5F86323F83CCC9D8EAC0E3EC77447F7F454FF75534356D940B0B852275DE4E
              E18BBD19A9646B6D60ECDD077A393C82EB5DD7505F1F092C320C936EDCB98753
              1DED3874605FE0DB3FA8F89E000EBAC7810000000049454E44AE426082}
          end>
      end
      item
        Name = 'Item24'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              610000023E4944415478DA6D93BD4F536114C69FAB03462D0B71C35830222E6A
              134C4811103F82A889939B81AA80303BA09082FE052AE8A27169B451101C9CD0
              106C29C4AA4B2B88066C507071316AA2B4F7FDF0BCA71FE6BD7A9337B91FE7FC
              CEF33C39D7D1D03057243AAAC767D228737F426DAE80520AF2C75704037BA0B5
              C2743205B9A9021BE0E24C4B1DBA42671DD3E71401A77BC3FAD3D6006A720B80
              3F08A934DCE538268607F9FB89EE7EA8CA3AD06B382B094CDD1FB601277BAEEA
              35DF5EECCACE033B825CE82EC7F06464C80248E540ADCC21F6E0BA0D68BB38A4
              BF1401FE06B2A0213EC6D1D7718A2C00D7EE8C4157D64351ADCCCC221EF5008E
              770FB2829AEC421E405DEED20B6E3019889C0BB5BD9EAB45268199E80D1BD0DA
              1526C03E02CCC3A96AE00CC4AF6F107A2343D46F0AB7AC9CADC94C0C89A82783
              D6CEB05E65C05BA0EA202B3036A41010EE3A37168FA070671FDEB401C72E0CE8
              B5F2FD7980BF00300D062205DC5C8EEB241C48B2F60FE0E8F9015260006938D5
              8DDC6820C68A095148496ADCFCFDD234E61E792C1C39D7AF5749C1EE92057820
              46092D172D98FB610A2F473D8096D015B21020409A008DB68502289F0B01DE3F
              27C0880D38D471991404506B00D54DA5E9A5304BCFB4608BCF901CFB0FE0B3CF
              284851064DD674965F00F17E10E0D5E35B36A0B9BD8F0125059EE926BC2224B7
              388937E3B76DC0E1F64B3AE33B80DAF514B0B3F9AF05654F6765EF9E223971D7
              06DC8B447564F235FDCEDFA1B76CE3B4F997A6A3598562085416A1B6207A3B43
              0CF803439CCF001F21088F0000000049454E44AE426082}
          end>
      end>
    Left = 64
    Top = 110
  end
  object vImgIcons: TVirtualImageList
    AutoFill = True
    DisabledGrayscale = False
    DisabledSuffix = '_Disabled'
    Images = <
      item
        CollectionIndex = 0
        CollectionName = 'Item1'
        Disabled = False
        Name = 'Item1'
      end
      item
        CollectionIndex = 1
        CollectionName = 'Item2'
        Disabled = False
        Name = 'Item2'
      end
      item
        CollectionIndex = 2
        CollectionName = 'Item3'
        Disabled = False
        Name = 'Item3'
      end
      item
        CollectionIndex = 3
        CollectionName = 'Item4'
        Disabled = False
        Name = 'Item4'
      end
      item
        CollectionIndex = 4
        CollectionName = 'Item5'
        Disabled = False
        Name = 'Item5'
      end
      item
        CollectionIndex = 5
        CollectionName = 'Item6'
        Disabled = False
        Name = 'Item6'
      end
      item
        CollectionIndex = 6
        CollectionName = 'Item7'
        Disabled = False
        Name = 'Item7'
      end
      item
        CollectionIndex = 7
        CollectionName = 'Item8'
        Disabled = False
        Name = 'Item8'
      end
      item
        CollectionIndex = 8
        CollectionName = 'Item9'
        Disabled = False
        Name = 'Item9'
      end
      item
        CollectionIndex = 9
        CollectionName = 'Item10'
        Disabled = False
        Name = 'Item10'
      end
      item
        CollectionIndex = 10
        CollectionName = 'Item11'
        Disabled = False
        Name = 'Item11'
      end
      item
        CollectionIndex = 11
        CollectionName = 'Item12'
        Disabled = False
        Name = 'Item12'
      end
      item
        CollectionIndex = 12
        CollectionName = 'Item13'
        Disabled = False
        Name = 'Item13'
      end
      item
        CollectionIndex = 13
        CollectionName = 'Item14'
        Disabled = False
        Name = 'Item14'
      end
      item
        CollectionIndex = 14
        CollectionName = 'Item15'
        Disabled = False
        Name = 'Item15'
      end
      item
        CollectionIndex = 15
        CollectionName = 'Item16'
        Disabled = False
        Name = 'Item16'
      end
      item
        CollectionIndex = 16
        CollectionName = 'Item17'
        Disabled = False
        Name = 'Item17'
      end
      item
        CollectionIndex = 17
        CollectionName = 'Item18'
        Disabled = False
        Name = 'Item18'
      end
      item
        CollectionIndex = 18
        CollectionName = 'Item19'
        Disabled = False
        Name = 'Item19'
      end
      item
        CollectionIndex = 19
        CollectionName = 'Item20'
        Disabled = False
        Name = 'Item20'
      end
      item
        CollectionIndex = 20
        CollectionName = 'Item21'
        Disabled = False
        Name = 'Item21'
      end
      item
        CollectionIndex = 21
        CollectionName = 'Item22'
        Disabled = False
        Name = 'Item22'
      end
      item
        CollectionIndex = 22
        CollectionName = 'Item23'
        Disabled = False
        Name = 'Item23'
      end
      item
        CollectionIndex = 23
        CollectionName = 'Item24'
        Disabled = False
        Name = 'Item24'
      end>
    ImageCollection = imgIcons
    Left = 56
    Top = 206
  end
end
