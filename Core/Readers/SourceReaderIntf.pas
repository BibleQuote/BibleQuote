unit SourceReaderIntf;

interface

uses System.Classes, InfoSource, Sets;

type
  ISourceReader = interface
    ['{FAB70214-80F3-4404-8D36-E6F4E46A1BC8}']
    function GetBibleChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean;
    function GetCommentaryChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean;

    function CountVerses(aBook, aChapter: Integer): Integer;

    function GetBookVerses(aBook: Integer): TStrings;
    function GetSpecialSearchSections(): TStrings;
    function ParseLisks(Query: String; var FormattedQuery: String): TIntSet;
    function GetSectionBooks(SectionIndex: Integer): TIntSet;
  end;

implementation

end.
