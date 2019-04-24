unit ChapterData;

interface

uses System.Types;

type

  TChapterData = class(TObject)
  private
    FPathName: String;
    FFullName: String;
    FShortName: String;
    FChapterQty: Integer;
    FBookNumber: Integer;
  public
    ChapterNumbers: TIntegerDynArray;

  public
    property PathName: String read FPathName write FPathName;
    property FullName: String read FFullName write FFullName;
    property ShortName: String read FShortName write FShortName;
    property ChapterQty: Integer read FChapterQty write FChapterQty;
    property BookNumber: Integer read FBookNumber write FBookNumber;

    function Clone(): TChapterData;
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
  ChapterData.ChapterQty := Self.FChapterQty;
  ChapterData.BookNumber := Self.FBookNumber;
  ChapterData.ChapterNumbers := Self.ChapterNumbers;

  Result := ChapterData;
end;

end.
