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
  end;

implementation

end.
