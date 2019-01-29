unit ChapterData;

interface

type

  TChapterData = class
  private
    FPathName: String;
    FFullName: String;
    FShortName: String;
    FChapterQty: Integer;

  public
    property PathName: String read FPathName write FPathName;
    property FullName: String read FFullName write FFullName;
    property ShortName: String read FShortName write FShortName;
    property ChapterQty: Integer read FChapterQty write FChapterQty;

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

  Result := ChapterData;
end;

end.
