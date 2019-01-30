unit InfoSource;

interface

uses Classes, ChapterData, Generics.Collections;

type

  TInfoSource = class
  private
    FDataPairs: TStrings;

    FFileName: String;
    FBibleName, FBibleShortName, FCopyright: String;
    FIsBible, FIsCompressed, FIsCommentary: Boolean;
    FChapterString, FChapterStringPs, FChapterZeroString: String;
    FDesiredUIFont, FDesiredFontName, FInstallFonts: String;
    FChapterSign, FVerseSign: String;
    FAlphabet, FHTMLFilter, FSoundDirectory: String;
    FUseRightAlignment, FStrongsPrefixed: Boolean;
    FDefaultEncoding: String;

    FModuleName, FModuleAuthor, FModuleVersion, FModuleCompiler, FModuleImage: String;
    FOldTestament, FNewTestament, FApocrypha, FChapterZero, FEnglishPsalms,
    FStrongNumbers, FNoForcedLineBreaks, FUseChapterHead :Boolean;
    FDesiredFontCharset, FBookQty: Integer;

    FChapterDatas: TList<TChapterData>;
    FCategories: String;

    procedure SetChapterDatas(aChapterDatas: TList<TChapterData>);

  private
    procedure ClearChapterDatas();

  public


    constructor Create();
    destructor Destroy; override;
    function Clone(): TInfoSource;

    property IsBible: Boolean read FIsBible write FIsBible;
    property BibleName: String read FBibleName write FBibleName;
    property BibleShortName: String read FBibleShortName write FBibleShortName;
    property Copyright: String read FCopyright write FCopyright;
    property ModuleName: String read FModuleName write FModuleName;
    property ModuleAuthor: String read FModuleAuthor write FModuleAuthor;
    property ModuleCompiler: String read FModuleCompiler write FModuleCompiler;
    property ModuleVersion: String read FModuleVersion write FModuleVersion;
    property ModuleImage: String read FModuleImage write FModuleImage;
    property UseRightAlignment: Boolean read FUseRightAlignment write FUseRightAlignment;
    property Alphabet: String read FAlphabet write FAlphabet;
    property DesiredFontName: String read FDesiredFontName write FDesiredFontName;
    property SoundDirectory: String read FSoundDirectory write FSoundDirectory;
    property DesiredUIFont: String read FDesiredUIFont write FDesiredUIFont;
    property ChapterSign: String read FChapterSign write FChapterSign;
    property ChapterString: String read FChapterString write FChapterString;
    property ChapterStringPs: String read FChapterStringPs write FChapterStringPs;
    property ChapterZeroString: String read FChapterZeroString write FChapterZeroString;
    property HTMLFilter: String read FHTMLFilter write FHTMLFilter;
    property VerseSign: String read FVerseSign write FVerseSign;
    property BookQty: Integer read FBookQty write FBookQty;
    property StrongsPrefixed: Boolean read FStrongsPrefixed write FStrongsPrefixed;
    property DesiredFontCharset: Integer read FDesiredFontCharset write FDesiredFontCharset;
    property InstallFonts: String read FInstallFonts write FInstallFonts;
    property Categories: String read FCategories write FCategories;
    property OldTestament: Boolean read FOldTestament write FOldTestament;
    property NewTestament: Boolean read FNewTestament write FNewTestament;
    property Apocrypha: Boolean read FApocrypha write FApocrypha;
    property ChapterZero: Boolean read FChapterZero write FChapterZero;
    property EnglishPsalms: Boolean read FEnglishPsalms write FEnglishPsalms;
    property StrongNumbers: Boolean read FStrongNumbers write FStrongNumbers;
    property NoForcedLineBreaks: Boolean read FNoForcedLineBreaks write FNoForcedLineBreaks;
    property UseChapterHead: Boolean read FUseChapterHead write FUseChapterHead;
    property ChapterDatas: TList<TChapterData> read FChapterDatas write SetChapterDatas;
    property IsCompressed: Boolean read FIsCompressed write FIsCompressed;
    property FileName: String read FFileName write FFileName;
    property IsCommentary: Boolean read FIsCommentary write FIsCommentary;
    property DefaultEncoding: String read FDefaultEncoding write FDefaultEncoding;

  end;

implementation

{ TInfoSource }

uses SysUtils;

procedure TInfoSource.ClearChapterDatas;
var
  i: Integer;
begin

  for i := 0 to FChapterDatas.Count - 1 do
  begin;
    FChapterDatas[i].Free;
  end;

end;

function TInfoSource.Clone: TInfoSource;
var
  InfoSource: TInfoSource;

begin
  InfoSource := TInfoSource.Create;

  Result := InfoSource;

  with InfoSource do begin
    IsBible := Self.FIsBible;
    BibleName := Self.FBibleName;
    BibleShortName := Self.FBibleShortName;
    Copyright := Self.FCopyright;
    ModuleName := Self.FModuleName;
    ModuleAuthor := Self.FModuleAuthor;
    ModuleCompiler := Self.FModuleCompiler;
    ModuleVersion := Self.FModuleVersion;
    ModuleImage := Self.FModuleImage;
    UseRightAlignment := Self.FUseRightAlignment;
    Alphabet := Self.FAlphabet;
    DesiredFontName := Self.FDesiredFontName;
    SoundDirectory := Self.FSoundDirectory;
    DesiredUIFont := Self.FDesiredUIFont;
    ChapterSign := Self.FChapterSign;
    ChapterString := Self.FChapterString;
    ChapterStringPs := Self.FChapterStringPs;
    ChapterZeroString := Self.FChapterZeroString;
    HTMLFilter := Self.FHTMLFilter;
    VerseSign := Self.FVerseSign;
    BookQty := Self.FBookQty;
    StrongsPrefixed := Self.FStrongsPrefixed;
    DesiredFontCharset := Self.FDesiredFontCharset;
    InstallFonts := Self.FInstallFonts;
    Categories := Self.FCategories;
    OldTestament := Self.FOldTestament;
    NewTestament := Self.FNewTestament;
    Apocrypha := Self.FApocrypha;
    ChapterZero := Self.FChapterZero;
    EnglishPsalms := Self.FEnglishPsalms;
    StrongNumbers := Self.FStrongNumbers;
    NoForcedLineBreaks := Self.FNoForcedLineBreaks;
    UseChapterHead := Self.FUseChapterHead;
    ChapterDatas := Self.FChapterDatas;
    IsCompressed := Self.FIsCompressed;
    FileName := Self.FFileName;
    IsCommentary := Self.FIsCommentary;
  end;

end;

constructor TInfoSource.Create;
begin
  inherited Create;

  FChapterDatas := TList<TChapterData>.Create();
end;

destructor TInfoSource.Destroy;
begin

  ClearChapterDatas();

  FreeAndNil(FChapterDatas);

  inherited;
end;


procedure TInfoSource.SetChapterDatas(aChapterDatas: TList<TChapterData>);
var
  i :Integer;
  ChapterData: TChapterData;
begin

  ClearChapterDatas();

  for I := 0 to aChapterDatas.Count - 1 do
  begin
    ChapterData := aChapterDatas[i].Clone();
    ChapterDatas.Add(ChapterData);
  end;
end;

end.
