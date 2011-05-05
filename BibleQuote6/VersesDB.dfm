object VerseListEngine: TVerseListEngine
  OldCreateOrder = False
  Height = 446
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
    object cdVersesLoCID: TIntegerField
      FieldName = 'LoCID'
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
  end
  object DbTags: TASQLite3DB
    TimeOut = 0
    CharacterEncoding = 'UTF8'
    Database = 'h:\BibleQuote 5 Bibliologia Edition\TagsDb.bqd'
    DefaultExt = '.bqd'
    Version = '3.6.23.1'
    DriverDLL = 'BQsqlite3.dll'
    Connected = True
    MustExist = True
    ExecuteInlineSQL = False
    Left = 312
    Top = 8
  end
  object cdLocations: TASQLite3Query
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
      'SELECT * FROM VLocations')
    Left = 72
    Top = 72
    object cdLocationsLOCID: TIntegerField
      FieldName = 'LOCID'
    end
    object cdLocationsLocStringID: TStringField
      FieldName = 'LocStringID'
      Size = 255
    end
  end
  object ASQLite3Query1: TASQLite3Query
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
      'CREATE TABLE [TagNames] ('
      '  [TAGID] INTEGER NOT NULL PRIMARY KEY, '
      '  [TagName] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT);'
      ''
      
        'CREATE UNIQUE INDEX [un] ON [TagNames] ([TagName] COLLATE BINARY' +
        ');'
      ''
      'CREATE TABLE [TTRelations] ('
      
        '  [ORG_TAGID] INTEGER NOT NULL CONSTRAINT [ORGTIX_FK] REFERENCES' +
        ' [TagNames]([TAGID]) ON DELETE RESTRICT ON UPDATE RESTRICT, '
      
        '  [REL_TAGID] INTEGER NOT NULL CONSTRAINT [REL_TIX_FK] REFERENCE' +
        'S [TagNames]([TAGID]) ON DELETE RESTRICT ON UPDATE RESTRICT, '
      '  [TTRELATIONID] INTEGER NOT NULL, '
      '  UNIQUE([ORG_TAGID], [REL_TAGID]) ON CONFLICT ABORT);'
      ''
      'CREATE INDEX [ORGTIX] ON [TTRelations] ([ORG_TAGID]);'
      ''
      'CREATE INDEX [RELTAGIX] ON [TTRelations] ([REL_TAGID]);'
      ''
      'CREATE TABLE [Verses] ('
      '  [ID] INTEGER NOT NULL PRIMARY KEY, '
      
        '  [LoCID] INTEGER NOT NULL CONSTRAINT [LOCID_FK] REFERENCES [VLo' +
        'cations]([LOCID]) ON DELETE RESTRICT ON UPDATE RESTRICT, '
      '  [BookIx] INTEGER NOT NULL, '
      '  [ChapterIx] INTEGER NOT NULL, '
      '  [VerseStart] INTEGER NOT NULL, '
      '  [VerseEnd] INTEGER NOT NULL, '
      
        '  UNIQUE([LoCID], [BookIx], [ChapterIx], [VerseStart], [VerseEnd' +
        ']) ON CONFLICT ABORT);'
      ''
      'CREATE TABLE [VLocations] ('
      '  [LOCID] INTEGER NOT NULL PRIMARY KEY, '
      '  [LocStringID] VARCHAR NOT NULL UNIQUE ON CONFLICT ABORT);'
      ''
      'CREATE TABLE [VTRelations] ('
      
        '  [TAGID] INTEGER NOT NULL CONSTRAINT [TagID_FK] REFERENCES [Tag' +
        'Names]([TAGID]) ON DELETE RESTRICT ON UPDATE RESTRICT, '
      
        '  [VERSEID] INTEGER NOT NULL CONSTRAINT [VerseId_FK] REFERENCES ' +
        '[Verses]([ID]) ON DELETE RESTRICT ON UPDATE RESTRICT, '
      '  [RELATIONID] INTEGER, '
      '  UNIQUE([TAGID], [VERSEID]) ON CONFLICT ABORT);'
      ''
      'CREATE INDEX [TAGIX] ON [VTRelations] ([TAGID]);'
      ''
      'CREATE INDEX [VERSEIX] ON [VTRelations] ([VERSEID]);'
      ''
      'CREATE TRIGGER [TTRELATIONS_CHECK_NO_CIRCULAR_REF]'
      'BEFORE INSERT'
      'ON [TTRelations]'
      'WHEN (NEW.ORG_TAGID=NEW.REL_TAGID)'
      'BEGIN'
      
        'SELECT RAISE( ABORT,"TTRELATIONS INSERT: TTRELATION: ORG_IX must' +
        ' not be equal to REL_IX"); '
      'END;'
      ''
      'CREATE TRIGGER [TTRELATIONS_CHECK_NO_CIRCULAR_REF_UPD]'
      'BEFORE UPDATE'
      'ON [TTRelations]'
      'WHEN (New.ORG_TAGID=New.REL_TAGID)'
      'BEGIN'
      
        'Select Raise(ABORT, "TTRELATIONS UPDATE: REL_TAGID AND ORG_TAGID' +
        ' must not be equal");'
      'END;'
      ''
      'CREATE TRIGGER [TTRELATIONS_CHECK_NO_DUPS]'
      'BEFORE INSERT'
      'ON [TTRelations]'
      
        'WHEN (SELECT TTRELATIONID FROM TTRELATIONS WHERE (ORG_TAGID=New.' +
        'REL_TAGID) AND (REL_TAGID=New.ORG_TAGID) IS NOT NULL)'
      'BEGIN'
      
        'SELECT RAISe(ABORT,"TTRELATIONS: indirect dup detected:aborted")' +
        ';'
      'END;'
      ''
      'CREATE TRIGGER [TTRELATIONS_CHECK_NO_DUPS_UPD]'
      'BEFORE UPDATE'
      'ON [TTRelations]'
      
        'WHEN (SELECT TTRELATIONID FROM TTRelations WHERE (ORG_TAGID=new.' +
        'REL_TAGID) OR (REL_TAGID=new.ORG_TAGID) is NOT NULL)'
      'BEGIN'
      
        'SELECT RAISE(ABORT, "TTRELATIONS UPDATE: indirect dup detected:a' +
        'borted");'
      'END;')
    Left = 160
    Top = 160
    object IntegerField1: TIntegerField
      FieldName = 'TagId'
    end
    object StringField1: TStringField
      FieldName = 'TagName'
      Size = 255
    end
  end
  object cdTTRelations: TASQLite3Query
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
      'select * from ttrelations')
    Left = 312
    Top = 232
    object cdTTRelationsORG_TAGID: TIntegerField
      FieldName = 'ORG_TAGID'
    end
    object cdTTRelationsREL_TAGID: TIntegerField
      FieldName = 'REL_TAGID'
    end
    object cdTTRelationsTTRELATIONID: TIntegerField
      FieldName = 'TTRELATIONID'
    end
  end
  object ASQLite3Pragma1: TASQLite3Pragma
    TempCacheSize = 0
    DefaultCacheSize = 0
    Left = 344
    Top = 144
  end
end
