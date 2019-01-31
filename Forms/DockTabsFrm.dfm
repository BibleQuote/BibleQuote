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
    PopupMenu = pmTabs
    TabOrder = 1
  end
  object pmTabs: TPopupMenu
    Images = vImgIcons
    OnPopup = mViewTabsOnPopup
    Left = 512
    Top = 120
    object miSeparator: TMenuItem
      Caption = '-'
    end
    object miCloseTab: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1082#1083#1072#1076#1082#1091
      OnClick = miCloseTabClick
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
        Name = 'strongTab'
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
        Name = 'memoTab'
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
        Name = 'libraryTab'
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
        Name = 'bookmarksTab'
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
        Name = 'searchTab'
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
        Name = 'tskTab'
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
        Name = 'themedBookmarksTab'
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
        Name = 'dictionaryTab'
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
      end
      item
        Name = 'commentsTab'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              610000000473424954080808087C08648800000009704859730000006F000000
              6F01F1A2DC430000001974455874536F667477617265007777772E696E6B7363
              6170652E6F72679BEE3C1A000001DF49444154388D8D923D68535114C77FF7B6
              49DECB6B6D7C790D35F563A88B283888601471111C8A83B855A408D94551348B
              08ADA50EE2282E3A284E222EE220883814B5E2E0A0B88883432C6D87E625BC60
              EE3D0EC9CB97B1F52CF77039E777CFFF7FAE1211FAE3F4CC6C418B1C741CAF68
              C5500D2BF7A3C6EFCFAF9F3F7DDF5FAB62C0D9F3C5E9A1212E5863467393BB4F
              8EF981CE64C711115657CAACFD2ADB9F3FBEBF34221BD6D8876F5E3C7B05301C
              93F64EED797CF3DAD5CC46A5C2F5B945B66DF7595B2963C562AD50AB56F4BDBB
              B7A747BD114AF30BA7806C0F60726222E3BA0EAEEB3057BAC297AFDF0088279C
              9A39432E08D05AB32B9FF7E3BE36A0DB899DF91D8C677D6AB51A4A29B4D60068
              AD514AD1ED5B07D067662A9542294514453DCD5A6B5457E93F0100C96412A514
              F57ABDD3AC14A20600E2585D5FE7C1A32748CB3C11A1610CA66128CE9E231704
              9B4B48BB2E470E1F4204902640108CB178E974CB83CE83FA2F09222D4705A19D
              A295229148B4646C22A116452C7D58C68A455A12E2FCC0FE7D8C78DED65B109A
              5308C2F1A3054E1C2BF43C2283B7D03C03DFA774E962FF607DD121E841975B45
              F7B46D4058AD9AFF058461B511E76D09CB1F3FDDB9716BF1B2E3B8C3DDC6D9F6
              7F689E611836DE2EBD5B88FBFE005342F114AE839E450000000049454E44AE42
              6082}
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
        CollectionName = 'strongTab'
        Disabled = False
        Name = 'strongTab'
      end
      item
        CollectionIndex = 1
        CollectionName = 'memoTab'
        Disabled = False
        Name = 'memoTab'
      end
      item
        CollectionIndex = 2
        CollectionName = 'libraryTab'
        Disabled = False
        Name = 'libraryTab'
      end
      item
        CollectionIndex = 3
        CollectionName = 'bookmarksTab'
        Disabled = False
        Name = 'bookmarksTab'
      end
      item
        CollectionIndex = 4
        CollectionName = 'searchTab'
        Disabled = False
        Name = 'searchTab'
      end
      item
        CollectionIndex = 5
        CollectionName = 'tskTab'
        Disabled = False
        Name = 'tskTab'
      end
      item
        CollectionIndex = 6
        CollectionName = 'themedBookmarksTab'
        Disabled = False
        Name = 'themedBookmarksTab'
      end
      item
        CollectionIndex = 7
        CollectionName = 'dictionaryTab'
        Disabled = False
        Name = 'dictionaryTab'
      end
      item
        CollectionIndex = 8
        CollectionName = 'commentsTab'
        Disabled = False
        Name = 'commentsTab'
      end>
    ImageCollection = imgIcons
    Left = 56
    Top = 206
  end
end
