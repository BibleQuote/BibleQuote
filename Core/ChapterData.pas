unit ChapterData;

interface

uses System.Types;

type

  TChapterData = class(TObject)
  private
    FPathName: String;
    FFullName: String;
    FShortName: String;
    FBookNumber: Integer;
  public
    ChapterNumbers: TArray<Integer>;

  public
    property PathName: String read FPathName write FPathName;
    property FullName: String read FFullName write FFullName;
    property ShortName: String read FShortName write FShortName;
    property BookNumber: Integer read FBookNumber write FBookNumber;

    function Clone(): TChapterData;
  end;

  TVerseMeta = class(TObject)
  private
    FChapterNumber, FVerseNumber: Integer;
  public
    property ChapterNumber: Integer read FChapterNumber write FChapterNumber;
    property VerseNumber: Integer read FVerseNumber write FVerseNumber;
  end;

implementation

{ TChapterData }

function TChapterData.Clone: TChapterData;
var
  ChapterData: TChapterData;
begin
  ChapterData := TChapterData.Create;

  ChapterData.PathName := Self.FPathName;
  ChapterData.FullName := Self.FFullName;
  ChapterData.ShortName := Self.FShortName;
  ChapterData.BookNumber := Self.FBookNumber;
  ChapterData.ChapterNumbers := Self.ChapterNumbers;

  Result := ChapterData;
end;

end.
