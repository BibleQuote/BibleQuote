object TagsDbEngine: TTagsDbEngine
  OldCreateOrder = False
  Height = 304
  Width = 231
  object fdSQLiteDriver: TFDPhysSQLiteDriverLink
    Left = 40
    Top = 24
  end
  object fdTagsConnection: TFDConnection
    Params.Strings = (
      'Database=.\TagsDb.bqd'
      'DriverID=SQLite'
      'OpenMode=CreateUTF16'
      'StringFormat=Unicode')
    ResourceOptions.AssignedValues = [rvMacroExpand]
    ResourceOptions.MacroExpand = False
    LoginPrompt = False
    Left = 40
    Top = 80
  end
  object tlbVRelations: TFDQuery
    Connection = fdTagsConnection
    SQL.Strings = (
      'Select * from VTRelations ORDER BY (VERSEID)')
    Left = 152
    Top = 136
    object tlbVRelationsTAGID: TIntegerField
      FieldName = 'TAGID'
      Origin = 'TAGID'
      Required = True
    end
    object tlbVRelationsVERSEID: TIntegerField
      FieldName = 'VERSEID'
      Origin = 'VERSEID'
      Required = True
    end
    object tlbVRelationsRELATIONID: TIntegerField
      FieldName = 'RELATIONID'
      Origin = 'RELATIONID'
    end
  end
  object tlbVerses: TFDQuery
    Connection = fdTagsConnection
    SQL.Strings = (
      'Select * from Verses')
    Left = 152
    Top = 192
    object tlbVersesID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object tlbVersesLoCID: TIntegerField
      FieldName = 'LoCID'
      Origin = 'LoCID'
      Required = True
    end
    object tlbVersesBookIx: TIntegerField
      FieldName = 'BookIx'
      Origin = 'BookIx'
      Required = True
    end
    object tlbVersesChapterIx: TIntegerField
      FieldName = 'ChapterIx'
      Origin = 'ChapterIx'
      Required = True
    end
    object tlbVersesVerseStart: TIntegerField
      FieldName = 'VerseStart'
      Origin = 'VerseStart'
      Required = True
    end
    object tlbVersesVerseEnd: TIntegerField
      FieldName = 'VerseEnd'
      Origin = 'VerseEnd'
      Required = True
    end
  end
  object tlbVLocations: TFDQuery
    Connection = fdTagsConnection
    SQL.Strings = (
      'SELECT * FROM VLocations')
    Left = 152
    Top = 248
    object tlbVLocationsLOCID: TIntegerField
      FieldName = 'LOCID'
      Origin = 'LOCID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object tlbVLocationsLocStringID: TWideStringField
      FieldName = 'LocStringID'
      Origin = 'LocStringID'
      Required = True
      Size = 32767
    end
  end
  object tlbTRelations: TFDQuery
    Connection = fdTagsConnection
    SQL.Strings = (
      'select * from ttrelations')
    Left = 152
    Top = 24
    object tlbTRelationsORG_TAGID: TIntegerField
      FieldName = 'ORG_TAGID'
      Origin = 'ORG_TAGID'
      Required = True
    end
    object tlbTRelationsREL_TAGID: TIntegerField
      FieldName = 'REL_TAGID'
      Origin = 'REL_TAGID'
      Required = True
    end
    object tlbTRelationsTTRELATIONID: TIntegerField
      FieldName = 'TTRELATIONID'
      Origin = 'TTRELATIONID'
      Required = True
    end
  end
  object tlbTagNames: TFDQuery
    Connection = fdTagsConnection
    SQL.Strings = (
      'Select * from  TagNames')
    Left = 152
    Top = 80
    object tlbTagNamesTAGID: TIntegerField
      FieldName = 'TAGID'
      Origin = 'TAGID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object tlbTagNamesTagName: TWideStringField
      FieldName = 'TagName'
      Origin = 'TagName'
      Required = True
      Size = 32767
    end
  end
end
