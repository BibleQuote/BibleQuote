object TagsVersesFrame: TTagsVersesFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object tlbTags: TToolBar
    Left = 0
    Top = 0
    Width = 320
    Height = 30
    ButtonHeight = 30
    ButtonWidth = 31
    GradientEndColor = 13684944
    Images = ilImages24
    TabOrder = 0
    object tbtnAddNode: TToolButton
      Left = 0
      Top = 0
      Caption = 'tbtnAddNode'
      ImageIndex = 0
      OnClick = tbtnAddTagNodeClick
    end
    object tbtnDelNode: TToolButton
      Left = 31
      Top = 0
      AutoSize = True
      Caption = 'tbtnDelNode'
      ImageIndex = 1
      OnClick = tbtnDelTagNodeClick
    end
  end
  object cbTagsFilter: TComboBox
    Left = 0
    Top = 30
    Width = 320
    Height = 21
    Align = alTop
    BevelInner = bvSpace
    BevelOuter = bvSpace
    TabOrder = 1
    OnChange = cbTagsFilterChange
  end
  object vdtTagsVerses: TVirtualDrawTree
    Left = 0
    Top = 51
    Width = 320
    Height = 189
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
    TabOrder = 2
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
  object ilImages24: TImageList
    Height = 24
    Width = 24
    Left = 292
    Top = 212
    Bitmap = {
      494C01010200E8015C0318001800FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000600000001800000001002000000000000024
      0000000000000000000000000000000000000000000000000000000000006D68
      5F00BBB9B4000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B8B6B1005B564C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006D68
      5F00BBB9B4000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B8B6B1005B564C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005752
      48006F5F490094908900FAFAF900000000000000000000000000000000000000
      000000000000FAFAF9008F8B84005C4A3000433E320000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005752
      48006F5F490094908900FAFAF900000000000000000000000000000000000000
      000000000000FAFAF9008F8B84005C4A3000433E320000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005853
      4800E5A65E008A6E4A00736F6500E8E8E6000000000000000000000000000000
      0000E7E7E5006D685E007A593000DC862300443E320000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005853
      4800E5A65E008A6E4A00736F6500E8E8E6000000000000000000000000000000
      0000E7E7E5006D685E007A593000DC862300443E320000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005954
      4900ECAB5F00EA9F4A00A5743B00615A4F00CAC8C5000000000000000000C9C7
      C4005A5247009F6B2F00E68C2500E68B2300453F330000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005954
      4900ECAB5F00EA9F4A00A5743B00615A4F00CAC8C5000000000000000000C9C7
      C4005A5247009F6B2F00E68C2500E68B2300453F330000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005A54
      4A00ECAB6000EBA04B00E8943500C483370062544100A3A09900A3A099005E50
      3C00C17D2D00E68D2800E68C2600E68B24004640340000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005A54
      4A00ECAB6000EBA04B00E8943500C483370062544100A3A09900A3A099005E50
      3C00C17D2D00E68D2800E68C2600E68B24004640340000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005A55
      4B00EDAC6100EBA04C00E8953600E8943400DA8C3400785E3C00775D3B00D989
      2F00E68F2A00E68E2900E68D2700E68C25004641350000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005A55
      4B00EDAC6100EBA04C00E8953600E8943400DA8C3400785E3C00775D3B00D989
      2F00E68F2A00E68E2900E68D2700E68C25004641350000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005B56
      4C00EDAC6200EBA14D00E8953700E8943500E7933300E7923100E7913000E790
      2E00E78F2B00D9872B00B7772C009F6B2E0047413600EFEEED00000000000000
      0000000000000000000000000000000000000000000000000000000000005B56
      4C00EDAC6200EBA14D00E8953700E8943500E7933300E7923100E7913000E790
      2E00E78F2B00D9872B00B7772C009F6B2E0047413600EFEEED00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005C57
      4C00EDAC6200EBA14E00E8963800E8953600E8943400E7933200E7923100E58F
      2E009E6E35004F4E3F004B674A0049785100486547004A4C3D00A6A39D00FDFD
      FD00000000000000000000000000000000000000000000000000000000005C57
      4C00EDAC6200EBA14E00E8963800E8953600E8943400E7933200E7923100E58F
      2E009E6E35004E4947004849710045498C0045466F0049454400A6A39D00FDFD
      FD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005D58
      4D00EDAD6300EBA14E00E8963800E8953700E8943500E7933300E79231008964
      39004F6A4E004DAD6D004CB771004AB66F0049B66E0047AA6800466245008986
      7E00000000000000000000000000000000000000000000000000000000005D58
      4D00EDAD6300EBA14E00E8963800E8953700E8943500E7933300E79231008964
      39004C4D73004453E1004152F1004051F1003E4FF1003D4DE00043446C008986
      7E00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005D58
      4E00EDAD6400EBA24F00E8963900E8963800E8953600E8943400B87D3800515F
      49004FB673004EB872004CB771004B9A630049B66F0048B56E0046B26C004554
      3D00C4C2BE000000000000000000000000000000000000000000000000005D58
      4E00EDAD6400EBA24F00E8963900E8963800E8953600E8943400B87D38004F4D
      60004556EC004454F1004253F1004052F1003F50F1003D4FF0003C4DEB004341
      5500C4C2BE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005E59
      4F00EDAD6400EBA25000E8973A00E8963800E8953700E894350080633F005297
      650050B974004FB873004DB772004C463B004AB66F0049B66E0047B56D004690
      5A007C7870000000000000000000000000000000000000000000000000005E59
      4F00EDAD6400EBA25000E8973A00E8963800E8953700E894350080633F004A54
      BB004657F1004455F1004354F1004152F1004051F1003E4FF1003C4EF0003E49
      B6007C7870000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005F5A
      5000EDAE6500EBA35100E8973B00E8963900E8963800E89536006355420052AF
      700051B975004F8F60004E8057004C473B004B7D5400498B5B0048B56E0046A9
      6700585247000000000000000000000000000000000000000000000000005F5A
      5000EDAE6500EBA35100E8973B00E8963900E8963800E8953600635542004958
      E0004757F1004951AE00494E9700484C9600464B9500434BAB003D4FF0003D4C
      DE00585247000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000605B
      5000EDAE6600EBA35200E8983C00E8973A00E8963800E89537006456430053AF
      710052B97500508F61004F8058004D473C004C7E55004A8B5B0049B66E0047A9
      670058524700000000000000000000000000000000000000000000000000605B
      5000EDAE6600EBA35200E8983C00E8973A00E8963800E8953700645643004A59
      E0004758F1004A52AE004A4F9700484D9700474C9600434CAC003E4FF1003D4D
      DE00585247000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000605B
      5100EDAF6700EBA45200E9983D00E8973B00E8963900E8963800816541005499
      670052BA760051B975004FB874004E483D004CB771004BB7700049B66F004892
      5C007D797100000000000000000000000000000000000000000000000000605B
      5100EDAF6700EBA45200E9983D00E8973B00E8963900E8963800816541004D57
      BC004859F1004757F1004556F1004454F1004253F1004052F1003F50F100404B
      B7007D7971000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000615C
      5200EDAF6700EBA45300E9993E00E8983C00E8973A00E8963800B97F3B005562
      4D0053B7760052B9750050B974004F9C66004DB772004CB771004AB36F004957
      4100C4C2BE00000000000000000000000000000000000000000000000000615C
      5200EDAF6700EBA45300E9993E00E8983C00E8973A00E8963800B97F3B005351
      63004959ED004758F1004657F1004455F1004354F1004152F1004051EC004745
      5800C4C2BE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000625D
      5300EDAF6800ECA45400E9993F00E9983D00E8973B00E8963900E89537008C69
      3F00546E530052B0710051B975004FB874004EB872004CAD6D004B674A008C89
      810000000000000000000000000000000000000000000000000000000000625D
      5300EDAF6800ECA45400E9993F00E9983D00E8973B00E8963900E89537008C69
      3F00515277004958E2004757F1004556F1004454F1004352E100484970008C89
      8100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000635E
      5400EDB06900ECA55500E99A4000E9993E00E8983C00E8973A00E8963800E694
      3600A1733C0056554600526D5100507D57004F6B4E0051534400A7A49E00FDFD
      FD0000000000000000000000000000000000000000000000000000000000635E
      5400EDB06900ECA55500E99A4000E9993E00E8983C00E8973A00E8963800E694
      3600A1733C00554F4E004F5076004B5090004C4D7400504C4B00A7A49E00FDFD
      FD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000635E
      5500EEB06900ECA55500E99A4000E9993F00E9983D00E8973B00E8963800E895
      3700E8943500DB8D3500BA7D3600A37237004F4A3F00EFEEED00000000000000
      000000000000000000000000000000000000000000000000000000000000635E
      5500EEB06900ECA55500E99A4000E9993F00E9983D00E8973B00E8963800E895
      3700E8943500DB8D3500BA7D3600A37237004F4A3F00EFEEED00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000645F
      5500EEB06A00ECA65600E99B4100E99A4000E9993E00E8983C00E8963900E896
      3800E8953600E8943400E7933200E7923100504B3F0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000645F
      5500EEB06A00ECA65600E99B4100E99A4000E9993E00E8983C00E8963900E896
      3800E8953600E8943400E7933200E7923100504B3F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006560
      5600EEB16B00ECA75800E99B4200E99A4000E9993F00E8983C00E8973A00E896
      3800E8953700E8943500E7933300E7923100514B400000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006560
      5600EEB16B00ECA75800E99B4200E99A4000E9993F00E8983C00E8973A00E896
      3800E8953700E8943500E7933300E7923100514B400000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006661
      5700EEB16B00EDAD6400E99C4300E99B4100E99A4000E9983D00E8973B00E896
      3900E8963800E8953600E8943400E7933200524C410000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006661
      5700EEB16B00EDAD6400E99C4300E99B4100E99A4000E9983D00E8973B00E896
      3900E8963800E8953600E8943400E7933200524C410000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006661
      5800EEB26C00EEB16B00EDAD6400ECA65600ECA45400EBA35200EBA25000EBA1
      4E00EBA14D00EBA04B00EA9F4A00EA9E4800524D420000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006661
      5800EEB26C00EEB16B00EDAD6400ECA65600ECA45400EBA35200EBA25000EBA1
      4E00EBA14D00EBA04B00EA9F4A00EA9E4800524D420000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000817D
      7600CD9E6600EEB16B00EEB06A00EDB06900EDAF6700EDAE6500EDAD6400EDAC
      6200EDAC6100ECAB5F00ECAA5E00C89355007470670000000000000000000000
      000000000000000000000000000000000000000000000000000000000000817D
      7600CD9E6600EEB16B00EEB06A00EDB06900EDAF6700EDAE6500EDAD6400EDAC
      6200EDAC6100ECAB5F00ECAA5E00C89355007470670000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D5D3
      D000817D750065605600635E5500625D5300605B50005E594F005D584D005B56
      4C005A544A00585348005751470076726900D4D2CF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D5D3
      D000817D750065605600635E5500625D5300605B50005E594F005D584D005B56
      4C005A544A00585348005751470076726900D4D2CF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000060000000180000000100010000000000200100000000000000000000
      000000000000000000000000FFFFFF00E7FE7FE7FE7F000000000000E1F87FE1
      F87F000000000000E0F07FE0F07F000000000000E0607FE0607F000000000000
      E0007FE0007F000000000000E0007FE0007F000000000000E0003FE0003F0000
      00000000E0000FE0000F000000000000E0000FE0000F000000000000E00007E0
      0007000000000000E00007E00007000000000000E00007E00007000000000000
      E00007E00007000000000000E00007E00007000000000000E00007E000070000
      00000000E0000FE0000F000000000000E0000FE0000F000000000000E0003FE0
      003F000000000000E0007FE0007F000000000000E0007FE0007F000000000000
      E0007FE0007F000000000000E0007FE0007F000000000000E0007FE0007F0000
      00000000E0007FE0007F00000000000000000000000000000000000000000000
      000000000000}
  end
end
