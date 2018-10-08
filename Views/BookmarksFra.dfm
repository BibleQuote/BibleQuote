object BookmarksFrame: TBookmarksFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object lbBookmarks: TListBox
    Left = 0
    Top = 0
    Width = 320
    Height = 130
    Style = lbOwnerDrawVariable
    Align = alClient
    ItemHeight = 14
    TabOrder = 0
    OnClick = lbBookmarksClick
    OnDblClick = lbBookmarksDblClick
    OnKeyUp = lbBookmarksKeyUp
    ExplicitWidth = 282
    ExplicitHeight = 207
  end
  object pnlBookmarks: TPanel
    Left = 0
    Top = 130
    Width = 320
    Height = 110
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 1
    ExplicitWidth = 282
    object lblBookmark: TLabel
      Left = 10
      Top = 10
      Width = 300
      Height = 90
      Align = alClient
      Caption = 'lblBookmark'
      WordWrap = True
      ExplicitWidth = 56
      ExplicitHeight = 13
    end
  end
end
