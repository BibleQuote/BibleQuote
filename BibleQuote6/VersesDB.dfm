object VerseListEngine: TVerseListEngine
  OldCreateOrder = False
  Height = 140
  Width = 415
  object cdTagNames: TASQLite3Query
    AutoCommit = False
    SQLiteDateFormat = True
    Connection = DbTags
    MaxResults = 0
    StartResult = 0
    TypeLess = False
    SQLCursor = True
    ReadOnly = False
    UniDirectional = False
    RawSQL = True
    SQL.Strings = (
      'Select * from  TagNames')
    Left = 72
    Top = 8
    object cdTagNamesTagId: TIntegerField
      FieldName = 'TagId'
    end
    object cdTagNamesTagName: TStringField
      FieldName = 'TagName'
      Size = 255
    end
  end
  object cdVerses: TASQLite3Query
    AutoCommit = False
    SQLiteDateFormat = True
    Connection = DbTags
    MaxResults = 0
    StartResult = 0
    TypeLess = False
    SQLCursor = True
    ReadOnly = False
    UniDirectional = False
    RawSQL = False
    SQL.Strings = (
      'Select * from Verses')
    Left = 168
    Top = 8
    object cdVersesID: TIntegerField
      FieldName = 'ID'
    end
    object cdVersesBookIx: TIntegerField
      FieldName = 'BookIx'
    end
    object cdVersesChapterIx: TIntegerField
      FieldName = 'ChapterIx'
    end
    object cdVersesVerseStart: TIntegerField
      FieldName = 'VerseStart'
    end
    object cdVersesVerseEnd: TIntegerField
      FieldName = 'VerseEnd'
    end
  end
  object cdRelations: TASQLite3Query
    AutoCommit = False
    SQLiteDateFormat = True
    Connection = DbTags
    MaxResults = 0
    StartResult = 0
    TypeLess = False
    SQLCursor = True
    ReadOnly = False
    UniDirectional = False
    RawSQL = False
    SQL.Strings = (
      'Select * from VTRelations ORDER BY (VERSEID)')
    UpdateSQL = updSQL
    Left = 232
    Top = 8
    object cdRelationsTAGID: TIntegerField
      FieldName = 'TAGID'
    end
    object cdRelationsVERSEID: TIntegerField
      FieldName = 'VERSEID'
    end
    object RelationsRELATIONID: TIntegerField
      FieldName = 'RELATIONID'
    end
    object RelationsTagName: TStringField
      FieldKind = fkLookup
      FieldName = 'TagName'
      LookupDataSet = cdTagNames
      LookupKeyFields = 'TagId'
      LookupResultField = 'TagName'
      KeyFields = 'TAGID'
      Lookup = True
    end
    object cdRelationsVersBookIx: TIntegerField
      FieldKind = fkLookup
      FieldName = 'VersBookIx'
      LookupDataSet = cdVerses
      LookupKeyFields = 'ID'
      LookupResultField = 'BookIx'
      KeyFields = 'VERSEID'
      Lookup = True
    end
    object cdRelationsVerseChapter: TIntegerField
      FieldKind = fkLookup
      FieldName = 'VerseChapter'
      LookupDataSet = cdVerses
      LookupKeyFields = 'ID'
      LookupResultField = 'ChapterIx'
      KeyFields = 'VERSEID'
      Lookup = True
    end
    object cdRelationsVerseStart: TIntegerField
      FieldKind = fkLookup
      FieldName = 'VerseStart'
      LookupDataSet = cdVerses
      LookupKeyFields = 'ID'
      LookupResultField = 'VerseStart'
      KeyFields = 'VERSEID'
      Lookup = True
    end
    object cdRelationsVerseEnd: TIntegerField
      FieldKind = fkLookup
      FieldName = 'VerseEnd'
      LookupDataSet = cdVerses
      LookupKeyFields = 'ID'
      LookupResultField = 'VerseEnd'
      KeyFields = 'VERSEID'
      Lookup = True
    end
  end
  object DbTags: TASQLite3DB
    TimeOut = 0
    CharacterEncoding = 'UTF8'
    Database = 'h:\BibleQuote 5 Bibliologia Edition\TagsDb.bqd'
    DefaultExt = '.bqd'
    Version = '3.6.23.1'
    DriverDLL = 'BQsqlite3.dll'
    Connected = True
    MustExist = False
    ExecuteInlineSQL = False
    Left = 312
    Top = 8
  end
  object updSQL: TASQLite3UpdateSQL
    DeleteSQL.Strings = (
      'DELETE * FROM [VTRELATIONS] WHERE [TAGID=:Tag]')
    Left = 256
    Top = 96
  end
end
