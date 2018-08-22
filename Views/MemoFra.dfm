object MemoFrame: TMemoFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  DoubleBuffered = True
  ParentDoubleBuffered = False
  TabOrder = 0
  object tlbMemo: TToolBar
    AlignWithMargins = True
    Left = 2
    Top = 2
    Width = 315
    Height = 23
    Margins.Left = 2
    Margins.Top = 2
    Margins.Bottom = 0
    GradientEndColor = 11517638
    Images = ilImages
    TabOrder = 0
    object tbtnMemoOpen: TToolButton
      Left = 0
      Top = 0
      Caption = 'tbtnMemoOpen'
      ImageIndex = 0
      OnClick = tbtnMemoOpenClick
    end
    object tbtnMemoSave: TToolButton
      Left = 23
      Top = 0
      Caption = 'tbtnMemoSave'
      ImageIndex = 1
      OnClick = tbtnMemoSaveClick
    end
    object tbtnMemoPrint: TToolButton
      Left = 46
      Top = 0
      Caption = 'tbtnMemoPrint'
      ImageIndex = 2
      OnClick = tbtnMemoPrintClick
    end
    object tbtnSep1: TToolButton
      Left = 69
      Top = 0
      Width = 6
      Style = tbsSeparator
    end
    object tbtnMemoFont: TToolButton
      Left = 75
      Top = 0
      Caption = 'tbtnMemoFont'
      ImageIndex = 3
      OnClick = tbtnMemoFontClick
    end
    object tbtnSep2: TToolButton
      Left = 98
      Top = 0
      Width = 6
      Style = tbsSeparator
    end
    object tbtnMemoBold: TToolButton
      Left = 104
      Top = 0
      Caption = 'tbtnMemoBold'
      ImageIndex = 4
      OnClick = tbtnMemoBoldClick
    end
    object tbtnMemoItalic: TToolButton
      Left = 127
      Top = 0
      Caption = 'tbtnMemoItalic'
      ImageIndex = 5
      OnClick = tbtnMemoItalicClick
    end
    object tbtnMemoUnderline: TToolButton
      Left = 150
      Top = 0
      Caption = 'tbtnMemoUnderline'
      ImageIndex = 6
      OnClick = tbtnMemoUnderlineClick
    end
    object tbtnSep3: TToolButton
      Left = 173
      Top = 0
      Width = 6
      Style = tbsSeparator
    end
    object tbtnMemoPainter: TToolButton
      Left = 179
      Top = 0
      Caption = 'tbtnMemoPainter'
      ImageIndex = 7
      OnClick = tbtnMemoPainterClick
    end
  end
  object pnlMemo: TPanel
    Left = 0
    Top = 211
    Width = 320
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblMemo: TLabel
      Left = 4
      Top = 4
      Width = 16
      Height = 13
      Caption = '....'
    end
  end
  object reMemo: TRichEdit
    Left = 0
    Top = 25
    Width = 320
    Height = 186
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    PopupMenu = pmMemo
    ScrollBars = ssVertical
    TabOrder = 2
    Zoom = 100
    OnChange = reMemoChange
  end
  object ilImages: TImageList
    Left = 292
    Top = 212
    Bitmap = {
      494C010108006800300410001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      0000292929002121210018181800101010001010100008080800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B5B5
      B50073737300636363005A5A5A00848484007B7B7B004A4A4A0073737300E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      00009C9C9C00636363005A5A5A00525252006363630000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009C9C9C00424242005252520000000000000000009C9C9C00212121001818
      1800E7E7E7000000000000000000000000000000000000000000000000000000
      000000000000CECECE0031313100292929000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E7E7E7007B7B7B005A5A5A005A5A5A007B7B7B00D6D6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A5A5A500424242006B6B6B00000000000000000000000000181818002929
      29008C8C8C000000000000000000000000000000000000000000000000000000
      000000000000000000005252520039393900BDBDBD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EFEFEF004A4A4A005A5A5A00E7E7E70000000000CECECE0042424200E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0084848400FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A5A5A5004A4A4A00737373000000000000000000F7F7F700212121002929
      29009C9C9C000000000000000000000000000000000000000000000000000000
      0000000000000000000094949400424242007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009C9C9C004A4A4A00C6C6C600000000000000000000000000CECECE008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0084848400FFFFFF00C6C6C6008484840000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000ADADAD005252520073737300000000000000000084848400393939004A4A
      4A00F7F7F7000000000000000000000000000000000000000000000000000000
      00000000000000000000DEDEDE00424242004242420000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484005252520000000000000000000000000000000000000000005A5A
      5A0000000000000000000000000000000000000000000000000000000000FFFF
      FF0084848400FFFFFF00C6C6C6008484840000FFFF00FFFFFF0000FFFF008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000B5B5B5005A5A5A006B6B6B00A5A5A5006B6B6B00424242006B6B6B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000636363004A4A4A00C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C8C8C005A5A5A0000000000000000000000000000000000000000006363
      6300000000000000000000000000000000000000000000000000FFFFFF008484
      8400FFFFFF00C6C6C6008484840000FFFF00FFFFFF0000FFFF0084848400C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      0000B5B5B5005A5A5A008484840000000000F7F7F7005A5A5A00424242008484
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009C9C9C00525252008C8C8C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C8C8C006363630000000000000000000000000000000000000000006B6B
      6B0000000000000000000000000000000000000000000000000000000000FFFF
      FF00C6C6C6008484840000FFFF00FFFFFF0000FFFF0084848400C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      0000B5B5B500636363008C8C8C000000000000000000A5A5A5004A4A4A004242
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E7E7E700525252005A5A5A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000949494006B6B6B0000000000000000000000000000000000000000007373
      7300000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF0084848400C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD006B6B6B008C8C8C00000000000000000094949400525252006B6B
      6B00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737373005A5A5A00BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000949494006B6B6B0000000000000000000000000000000000000000007373
      7300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0084848400C6C6C600C6C6C600C6C6C6008484
      840084000000000000000000000000000000000000000000000000000000CECE
      CE0094949400737373007B7B7B00B5B5B500949494006B6B6B0094949400F7F7
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B5B5B5006B6B6B0063636300636363007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      00009C9C9C007373730000000000000000000000000000000000F7F7F7007373
      7300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600C6C6C600C6C6C600000000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CECE
      CE008484840073737300B5B5B500000000000000000000000000949494005A5A
      5A00B5B5B5000000000000000000000000000000000000000000000000000000
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
      AD0029292900B5B5B5009C9C9C00212121000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000399CDE00F7FFFF0094E7FF0094E7
      FF0094E7FF008CE7FF0084E7F7007BE7F70073DEF7006BDEF7005ADEF7004AD6
      F700CEF7FF003194DE000000000000000000BD6B3900EFCEB500E7A57B00FFFF
      F700BDDEC600BDDEC600BDDEC600BDDEC600BDDEC600BDDEC600BDDEC600BDDE
      C600FFFFF700CE946B00CE9C8400AD63310073737300B5B5B500B5B5B5009494
      940084848400848484007B7B7B006B6B6B006363630052525200424242004242
      42006B6B6B00B5B5B500B5B5B500212121000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000039A5DE00F7FFFF0094E7FF0094E7
      FF0094E7FF0094E7FF0094DEEF0094D6E70094D6DE0094CED6008CCECE0084C6
      C600CEDED6003194DE00CE845200CE845A00BD6B3900EFCEBD00E7A57B00FFFF
      F70063C68C0063C68C0063C68C0063C68C0063C68C0063C68C0063C68C0063C6
      8C00FFFFF700CE946B00CEA58400AD63310073737300BDBDBD00BDBDBD008C8C
      8C00D6D6D600BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00D6D6
      D60084848400BDBDBD00BDBDBD00292929000000000000000000000000009494
      9400737373007B7B7B00CECECE0000000000000000009C9C9C004A4A4A004242
      42009494940000000000000000000000000039ADDE00FFFFFF00FFFFFF00F7FF
      FF00F7FFFF00F7FFFF009CE7F7009CE7F7009CE7F7009CE7F7009CE7F7009CE7
      F700DEF7FF003194DE00FFF7EF00CE845A00BD6B3100EFD6BD00E7A57B00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00D6946B00D6A58C00AD6331007B7B7B00D6D6D600D6D6D6009494
      9400DEDEDE00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00D6D6
      D6008C8C8C00D6D6D600D6D6D60039393900000000000000000000000000D6D6
      D6004A4A4A00A5A5A50000000000000000000000000000000000424242004A4A
      4A000000000000000000000000000000000039ADDE00EFF7FF0073BDE70052AD
      E7004AA5E70094CEEF00FFF7EF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF003194DE00EFF7EF00CE845200BD6B3100F7D6BD00E7A57B00E7A5
      7B00E7A57B00E7A57B00E7A57B00E7A57B00DE9C7300DE9C7300DE9C7300DE9C
      7300DE9C7300D69C7300D6AD8C00AD6331007B7B7B00FFFFFF00FFFFFF00ADAD
      AD00DEDEDE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00DEDE
      DE00A5A5A500FFFFFF00FFFFFF0063636300000000000000000000000000D6D6
      D60052525200A5A5A50000000000000000000000000000000000525252005252
      52000000000000000000000000000000000042ADDE00F7FFFF0094DEF70094DE
      F70063BDEF003194DE003194DE003194DE003194DE003194DE003194DE003194
      DE003194DE003194DE00FFF7EF00CE845200BD6B3100F7D6C600E7A57B00E7A5
      7B00E7A57B00E7A57B00E7A57B00E7A57B00E7A57B00DEA57300DE9C7300DE9C
      7300DE9C7300DE9C7300DEB59400AD63310084848400FFFFFF00FFFFFF00CECE
      CE00F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700C6C6C600FFFFFF00FFFFFF0073737300000000000000000000000000DEDE
      DE005A5A5A00ADADAD00000000000000000000000000000000005A5A5A005252
      52000000000000000000000000000000000042B5DE00F7FFFF008CE7FF0094DE
      F7009CE7F700ADE7F700CE845200FFF7F700FFEFDE00FFEFDE00FFEFDE00FFE7
      D600FFE7D600FFE7CE00FFF7F700CE845200BD6B3100F7DEC600E7A57B00E7A5
      7B00E7A57B00E7A57B00E7A57B00E7A57B00E7A57B00DEA57300DE9C7300DE9C
      7300DE9C7300DE9C7300DEB59C00B563310094949400D6D6D600EFEFEF007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B00EFEFEF00C6C6C6006B6B6B00000000000000000000000000DEDE
      DE0063636300ADADAD0000000000000000000000000000000000636363005A5A
      5A000000000000000000000000000000000039B5DE00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7BD9400FFF7F700FFE7D600FFE7D600FFE7D600FFE7
      D600FFE7CE00FFDEC600FFF7EF00CE845200BD6B3100F7DEC600E7A57B00CE8C
      6300CE8C6300CE8C6300CE946B00CE946B00CE946B00CE8C6300CE8C6300CE8C
      6300CE8C6300DE9C7300E7BD9C00B5633100DEDEDE009C9C9C00CECECE00C68C
      4A00FFF7EF00FFEFDE00FFEFD600FFE7D600FFE7D600FFE7C600FFDEC600FFF7
      EF00C6844A00C6C6C60073737300CECECE0000000000D6D6D60000000000DEDE
      DE006B6B6B00B5B5B50000000000BDBDBD00EFEFEF00000000006B6B6B006363
      63000000000000000000B5B5B500000000005AC6E70063C6E70063C6E70063C6
      E70063C6E70063C6E700E7BD9400FFF7F700FFE7D600FFE7D600FFE7D600FFE7
      CE00FFDEC600F7DEBD00FFF7E700CE845A00BD6B3100F7DECE00E7A57B00FFEF
      E700FFEFE700FFEFE700FFF7EF00FFFFF700FFF7F700FFEFE700F7E7DE00F7E7
      DE00F7E7DE00DEA57300E7BDA500B563310000000000CECECE0084848400C68C
      4A00FFF7EF00FFE7D600FFE7D600FFE7D600FFE7CE00FFDEC600F7DEBD00FFF7
      EF00C6844A0063636300BDBDBD00000000000000000094949400E7E7E700DEDE
      DE0073737300B5B5B500000000006B6B6B009C9C9C0000000000737373006B6B
      6B0000000000949494008C8C8C00000000000000000000000000000000000000
      00000000000000000000E7BD9400FFF7F700FFE7D600FFE7D600FFE7CE00FFDE
      C600F7D6BD00F7D6AD00FFEFE700CE845A00BD6B3900F7DECE00E7AD7B00FFF7
      EF00FFF7EF00CE8C6300FFF7EF00FFFFF700FFFFFF00FFF7EF00FFEFDE00F7E7
      DE00F7E7DE00E7A57B00E7C6AD00B56B3100000000000000000000000000C68C
      4A00FFF7F700FFE7D600FFE7D600FFE7CE00FFE7CE00F7D6BD00F7D6B500FFF7
      F700C6844A00000000000000000000000000000000009C9C9C009C9C9C00B5B5
      B5009C9C9C00A5A5A5009C9C9C006B6B6B0073737300A5A5A5007B7B7B007B7B
      7B00848484004A4A4A00BDBDBD00000000000000000000000000000000000000
      00000000000000000000E7BD9400FFF7F700FFE7CE00FFE7CE00FFDECE00F7DE
      BD00F7EFDE00FFF7EF00FFFFF700CE845200C6734200F7DED600EFAD7B00FFF7
      F700FFF7F700CE8C6300FFF7EF00FFF7EF00FFFFF700FFFFF700FFF7EF00FFEF
      DE00F7E7DE00E7A57B00EFD6C600B56B3100000000000000000000000000CE8C
      5200FFF7F700FFE7CE00FFE7CE00FFE7CE00FFDEC600F7EFDE00F7F7EF00F7EF
      EF00C6844A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E7BD9400FFF7EF00FFDEC600FFE7C600FFDEC600F7D6
      B500FFFFF700FFE7C600EFC69400DEB59400C6845200F7DED600EFAD8400FFFF
      F700FFFFF700CE8C6300FFF7EF00FFF7EF00FFF7F700FFFFFF00FFF7F700FFEF
      E700FFE7DE00EFD6BD00EFD6BD00BD734200000000000000000000000000CE8C
      5200FFF7F700FFE7CE00FFE7CE00FFE7CE00FFDEC600FFFFFF00FFE7CE00E7B5
      8400D6AD84000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E7BD9400FFFFFF00FFF7EF00FFF7EF00FFF7EF00FFEF
      E700FFF7E700EFBD8C00DEAD8C0000000000D6A58400F7E7D600F7E7D600FFFF
      FF00FFFFF700FFFFF700FFF7F700FFF7EF00FFF7EF00FFFFF700FFFFF700FFF7
      EF00FFEFDE00EFD6BD00CE946B00E7C6B500000000000000000000000000C68C
      4A00F7F7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00F7E7D600E7B57B00DE94
      6B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EFC69C00E7BD9400E7BD9400E7BD9400D6A57300D6A5
      7300D6A57300E7BDA5000000000000000000E7BDA500DEAD8C00CE8C5A00C673
      4200BD6B3900BD6B3100BD6B3100BD6B3100BD6B3100BD6B3900BD6B3900BD6B
      3900BD734200CE8C6300E7CEBD00FFFFFF00000000000000000000000000EFCE
      BD00D6AD7B00CE8C5200CE8C4A00CE945200CE945200C68C4A00DEAD8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF07FF
      FFFFFFFFF00FF9FFE00FF07FFFFFFC7FF187F8FFF81FF83FF1C7FC7FF08FF01F
      F187FC7FF1CFE00FF187FC7FF3EFC007F01FFE3FF3EF8003F10FFE3FF3EF0003
      F18FFE3FF3EFE007F18FFF1FF3EFF803E00FFE0FF3CFFC01FFFFFFFFE1C7FE20
      FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF980078000E007FFFF000300000000FFFF
      000300000000FFFF000300000000FFFF000000000000E187000000000000E3CF
      000000000000E3CF000000000000E3CF000000000000E3CF000000000000A24D
      0000000080018249FC000000E0078001FC000000E007FFFFFC000000E007FFFF
      FC010000E00FFFFFFC030000E01FFFFF00000000000000000000000000000000
      000000000000}
  end
  object OpenDialog: TOpenDialog
    Left = 292
    Top = 212
  end
  object SaveFileDialog: TSaveDialog
    InitialDir = 'c:\'
    Options = [ofOverwritePrompt, ofHideReadOnly]
    Left = 292
    Top = 212
  end
  object ColorDialog: TColorDialog
    Left = 292
    Top = 212
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 292
    Top = 212
  end
  object PrintDialog: TPrintDialog
    FromPage = 1
    MinPage = 1
    MaxPage = 9999
    Options = [poPageNums]
    ToPage = 1
    Left = 292
    Top = 212
  end
  object pmMemo: TPopupMenu
    AutoHotkeys = maManual
    Left = 45
    Top = 93
    object miMemoCopy: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      ShortCut = 16451
      OnClick = miMemoCopyClick
    end
    object miMemoCut: TMenuItem
      Caption = #1042#1099#1088#1077#1079#1072#1090#1100
      ShortCut = 16472
      OnClick = miMemoCutClick
    end
    object miMemoPaste: TMenuItem
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      ShortCut = 16470
      OnClick = miMemoPasteClick
    end
  end
end
