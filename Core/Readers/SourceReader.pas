unit SourceReader;

interface

uses System.Classes, InfoSource, Bible, SourceReaderIntf, Sets;

type
  TSourceReader = class abstract(TInterfacedObject, ISourceReader)
  protected
    FBible: TBible;
  public
    constructor Create(Bible: TBible);

    function GetBibleChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean; virtual; abstract;
    function GetCommentaryChapter(aBook, aChapter: Integer; aLines: TStrings): Boolean; virtual; abstract;
    function CountVerses(aBook, aChapter: Integer): Integer; virtual; abstract;
    function GetBookVerses(aBook: Integer): TStrings; virtual; abstract;
    function GetSpecialSearchSections(): TStrings; virtual; abstract;
    function ParseLisks(Query: String; var FormattedQuery: String): TIntSet; virtual; abstract;
    function GetSectionBooks(SectionIndex: Integer): TIntSet; virtual; abstract;

    function GetInfoSource(): TInfoSource;
  end;

implementation

constructor TSourceReader.Create(Bible: TBible);
begin
  inherited Create();

  FBible := Bible;
end;

function TSourceReader.GetInfoSource;
begin
  Result := FBible.Info;
end;

end.
