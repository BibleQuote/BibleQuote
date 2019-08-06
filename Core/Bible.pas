unit bible;

// {$LONGSTRINGS ON}

interface

uses
  Windows, Messages, SysUtils, Classes, IOUtils, Types,
  Graphics, Controls, Forms, Dialogs, IOProcs, Sets, Math,
  StringProcs, BibleQuoteUtils, LinksParserIntf, WinUIServices, AppPaths,
  InfoSource, StrUtils, Generics.Collections, ManageFonts, SourceReaderIntf;

const
  RusToEngTable: array [1 .. 27] of integer = (1, 2, 3, 4, 5, 20, 21, 22, 23,
    24, 25, 26, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 27);

  EngToRusTable: array [1 .. 27] of integer = (1, 2, 3, 4, 5, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 6, 7, 8, 9, 10, 11, 12, 27);

  NativeToMyBibleMap: array[1..66] of Integer = (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110,
  120, 130, 140, 150, 160, 190, 220, 230, 240, 250, 260, 290, 300, 310, 330, 340, 350, 360, 370, 380, 390,
  400, 410, 420, 430, 440, 450, 460, 470, 480, 490, 500, 510, 660, 670, 680, 690, 700, 710, 720, 520, 530,
  540, 550, 560, 570, 580, 590, 600, 610, 620, 630, 640, 650, 730);

const

  TSKShortNames: array [1 .. 66] of string = // used to translate TSK references
    ('Ge. Ge Gen. Gen Gn. Gn Genesis',
    'Ex. Ex Exo. Exo Exod. Exod Exodus',
    'Lev. Lev Le. Le Lv. Lv Levit. Levit Leviticus',
    'Nu. Nu Num. Num Nm. Nm Numb. Numb Numbers',
    'De. De Deut. Deut Deu. Deu Dt. Dt  Deuteron. Deuteron Deuteronomy',
    'Jos. Jos Josh. Josh Joshua',
    'Jdg. Jdg Judg. Judg Judge. Judge Judges',
    'Ru. Ru Ruth Rth. Rth Rt. Rt',
    '1Sa. 1Sa 1S. 1S 1Sam. 1Sam 1Sm. 1Sm 1Sml. 1Sml 1Samuel',
    '2Sa. 2Sa 2S. 2S 2Sam. 2Sam 2Sm. 2Sm 2Sml. 2Sml 2Samuel',
    '1Ki. 1Ki 1K. 1K 1Kn. 1Kn 1Kg. 1Kg 1King. 1King 1Kng. 1Kng 1Kings',
    '2Ki. 2Ki 2K. 2K 2Kn. 2Kn 2Kg. 2Kg 2King. 2King 2Kng. 2Kng 2Kings',
    '1Chr. 1Chr 1Ch. 1Ch 1Chron. 1Chron',
    '2Chr. 2Chr 2Ch. 2Ch 2Chron. 2Chron',
    'Ezr. Ezr Ezra',
    'Ne. Ne Neh. Neh Nehem. Nehem Nehemiah',
    'Esth. Esth Est. Est Esther Es Es.',
    'Job. Job Jb. Jb',
    'Ps. Ps Psa. Psa Psal. Psal Psalm Psalms',
    'Pr. Pr Prov. Prov Pro. Pro Proverb Proverbs',
    'Ec. Ec Eccl. Eccl Ecc. Ecc Ecclesia. Ecclesia',
    'Song. Song Songs SS. SS Sol. Sol',
    'Isa. Isa Is. Is Isaiah',
    'Je. Je Jer. Jer Jerem. Jerem Jeremiah',
    'La. La Lam. Lam Lament. Lament Lamentation Lamentations',
    'Ez. Ez Eze. Eze Ezek. Ezek Ezekiel',
    'Da. Da Dan. Dan Daniel',
    'Hos. Hos Ho. Ho Hosea',
    'Joel. Joel Joe. Joe', 'Am. Am Amos Amo. Amo',
    'Ob. Ob Obad. Obad. Obadiah Oba. Oba',
    'Jon. Jon Jnh. Jnh. Jona. Jona Jonah',
    'Mi. Mi Mic. Mic Micah',
    'Na. Na Nah. Nah Nahum',
    'Hab. Hab Habak. Habak Habakkuk',
    'Zeph. Zeph  Zep. Zep Zephaniah',
    'Hag. Hag Haggai',
    'Ze. Ze Zec. Zec Zech. Zech Zechariah',
    'Mal. Mal Malachi',
    'Mt. Mt Ma. Ma Matt. Matt Mat. Mat Matthew',
    'Mk. Mk Mar. Mar Mr. Mr Mrk. Mrk Mark',
    'Lk. Lk Lu. Lu Luk. Luk Luke',
    'Jn. Jn Jno. Jno Joh. Joh John',
    'Ac. Ac Act. Act Acts',
    'Ro. Ro Rom. Rom Romans',
    '1Co. 1Co 1Cor. 1Cor 1Corinth. 1Corinth 1Corinthians',
    '2Co. 2Co 2Cor. 2Cor 2Corinth. 2Corinth 2Corinthians',
    'Ga. Ga Gal. Gal Galat. Galat Galatians',
    'Eph. Eph Ep. Ep Ephes. Ephes Ephesians',
    'Php. Php Ph. Ph Phil. Phil Phi. Phi. Philip. Philip Philippians',
    'Col. Col Colos. Colos Colossians',
    '1Th. 1Th 1Thes. 1Thes 1Thess. 1Thess 1Thessalonians',
    '2Th. 2Th 2Thes. 2Thes 2Thess. 2Thess 2Thessalonians',
    '1Ti. 1Ti 1Tim. 1Tim 1Timothy',
    '2Ti. 2Ti 2Tim. 2Tim 2Timothy',
    'Tit. Tit Ti. Ti Titus',
    'Phm. Phm Phile. Phile Phlm. Phlm Philemon',
    'He. He Heb. Heb Hebr. Hebr Hebrews',
    'Jas. Jas Ja. Ja Jam. Jam Jms. Jms James',
    '1Pe. 1Pe 1Pet. 1Pet 1Peter',
    '2Pe. 2Pe 2Pet. 2Pet 2Peter',
    '1Jn. 1Jn 1Jo. 1Jo 1Joh. 1Joh 1Jno. 1Jno 1John',
    '2Jn. 2Jn 2Jo. 2Jo 2Joh. 2Joh 2Jno. 2Jno 2John',
    '3Jn. 3Jn 3Jo. 3Jo 3Joh. 3Joh 3Jno. 3Jno 3John',
    'Jud. Jud Jude Jd. Jd',
    'Rev. Rev Re. Re Rv. Rv Revelation');

  RussianShortNames: array [1 .. 66] of string =
  // used to translate dictionary references
    ('Быт. Быт Бт. Бт Бытие Ge. Ge Gen. Gen Gn. Gn Genesis',
    'Исх. Исх Исход Ex. Ex Exo. Exo Exod. Exod Exodus',
    'Лев. Лев Лв. Лв Левит Lev. Lev Le. Le Lv. Lv Levit. Levit Leviticus',
    'Чис. Чис Чс. Чс Числ. Числ Числа Nu. Nu Num. Num Nm. Nm Numb. Numb Numbers',
    'Втор. Втор Вт. Вт Втрзк. Втрзк Второзаконие De. De Deut. Deut Deu. Deu Dt. Dt  Deuteron. Deuteron Deuteronomy',
    'Иис.Нав. Иис.Нав Нав. Нав Иисус Навин Jos. Jos Josh. Josh Joshua',
    'Суд. Суд Сд. Сд Судьи Jdg. Jdg Judg. Judg Judge. Judge Judges',
    'Руф. Руф Рф. Рф Руфь Ru. Ru Ruth Rth. Rth Rt. Rt',
    '1Цар. 1Цар 1Цр. 1Цр 1Ц 1Царств. 1Царств 1Sa. 1Sa 1S. 1S 1Sam. 1Sam 1Sm. 1Sm 1Sml. 1Sml 1Samuel',
    '2Цар. 2Цар 2Цр. 2Цр 2Ц 2Царств. 2Царств 2Sa. 2Sa 2S. 2S 2Sam. 2Sam 2Sm. 2Sm 2Sml. 2Sml 2Samuel',
    '3Цар. 3Цар 3Цр. 3Цр 3Ц 3Царств. 3Царств 1Ki. 1Ki 1K. 1K 1Kn. 1Kn 1Kg. 1Kg 1King. 1King 1Kng. 1Kng 1Kings',
    '4Цар. 4Цар 4Цр. 4Цр 4Ц 4Царств. 4Царств 2Ki. 2Ki 2K. 2K 2Kn. 2Kn 2Kg. 2Kg 2King. 2King 2Kng. 2Kng 2Kings',
    '1Пар. 1Пар 1Пр. 1Пр 1Chr. 1Chr 1Ch. 1Ch 1Chron. 1Chron',
    '2Пар. 2Пар 2Пр. 2Пр 2Chr. 2Chr 2Ch. 2Ch 2Chron. 2Chron',
    'Ездр. Ездр Езд. Езд Ез. Ез Ездра Ezr. Ezr Ezra',
    'Неем. Неем. Нм. Нм Неемия Ne. Ne Neh. Neh Nehem. Nehem Nehemiah',
    'Есф. Есф Ес. Ес Есфирь Esth. Esth Est. Est Esther',
    'Иов. Иов Ив. Ив Job. Job Jb. Jb',
    'Пс. Пс Псалт. Псалт Псал. Псал Псл. Псл Псалом Псалтирь Псалмы Ps. Ps Psa. Psa Psal. Psal Psalm Psalms',
    'Прит. Прит Притч. Притч Пр. Пр Притчи Притча Pr. Pr Prov. Prov Pro. Pro Proverb Proverbs',
    'Еккл. Еккл Ек. Ек Екк. Екк Екклесиаст Ec. Ec Eccl. Eccl Ecc. Ecc Ecclesia. Ecclesia',
    'Песн. Песн Пес. Пес Псн. Псн Песн.Песней Песни Song. Song Songs SS. SS Sol. Sol',
    'Ис. Ис Иса. Иса Исаия Исайя Isa. Isa Is. Is Isaiah',
    'Иер. Иер Иерем. Иерем Иеремия Je. Je Jer. Jer Jerem. Jerem Jeremiah',
    'Плач. Плач Плч. Плч Пл. Пл Пл.Иер. Пл.Иер Плач Иеремии La. La Lam. Lam Lament. Lament Lamentation Lamentations',
    'Иез. Иез Из. Иезек. Иезек Иезекииль Ez. Ez Eze. Eze Ezek. Ezek Ezekiel',
    'Дан. Дан Дн. Дн Днл. Днл Даниил Da. Da Dan. Dan Daniel',
    'Ос. Ос Осия Hos. Hos Ho. Ho Hosea',
    'Иоил. Иоил Ил. Ил Иоиль Joel. Joel Joe. Joe',
    'Ам. Ам Амс. Амс Амос Am. Am Amos Amo. Amo',
    'Авд. Авд Авдий Ob. Ob Obad. Obad. Obadiah Oba. Oba',
    'Ион. Ион. Иона Jon. Jon Jnh. Jnh. Jona. Jona Jonah',
    'Мих. Мих Мх. Мх Михей Mi. Mi Mic. Mic Micah',
    'Наум. Наум Na. Na Nah. Nah Nahum',
    'Авв. Авв Аввак. Аввак Аввакум Hab. Hab Habak. Habak Habakkuk',
    'Соф. Соф Софон. Софон Софония Zeph. Zeph  Zep. Zep Zephaniah',
    'Агг. Агг Аггей Hag. Hag Haggai',
    'Зах. Зах Зхр. Зхр Захар. Захар Захария Ze. Ze Zec. Zec Zech. Zech Zechariah',
    'Мал. Мал Малах. Малах Млх. Млх Малахия Mal. Mal Malachi',
    'Матф. Матф Мтф. Мтф Мф. Мф Мт. Мт Матфея Матфей Мат Мат. Mt. Mt Ma. Ma Matt. Matt Mat. Mat Matthew',
    'Мар. Мар Марк. Марк Мрк. Мрк Мр. Мр Марка Мк Мк. Mk. Mk Mar. Mar Mr. Mr Mrk. Mrk Mark',
    'Лук. Лук Лк. Лк Лукa Луки Lk. Lk Lu. Lu Luk. Luk Luke',
    'Иоан. Иоан Ин. Ин Иоанн Иоанна Jn. Jn Jno. Jno Joh. Joh John',
    'Деян. Деян Дея. Дея Д.А. Деяния Ac. Ac Act. Act Acts',
    'Иак. Иак Ик. Ик Иаков Иакова Jas. Jas Ja. Ja Jam. Jam Jms. Jms James',
    '1Пет. 1Пет 1Пт. 1Пт 1Птр. 1Птр 1Петр. 1Петр 1Петра 1Pe. 1Pe 1Pet. 1Pet 1Peter',
    '2Пет. 2Пет 2Пт. 2Пт 2Птр. 2Птр 2Петр. 2Петр 2Петра 2Pe. 2Pe 2Pet. 2Pet 2Peter',
    '1Иоан. 1Иоан 1Ин. 1Ин 1Иоанн 1Иоанна 1Jn. 1Jn 1Jo. 1Jo 1Joh. 1Joh 1Jno. 1Jno 1John',
    '2Иоан. 2Иоан 2Ин. 2Ин 2Иоанн 2Иоанна 2Jn. 2Jn 2Jo. 2Jo 2Joh. 2Joh 2Jno. 2Jno 2John',
    '3Иоан. 3Иоан 3Ин. 3Ин 3Иоанн 3Иоанна 3Jn. 3Jn 3Jo. 3Jo 3Joh. 3Joh 3Jno. 3Jno 3John',
    'Иуд. Иуд Ид. Ид Иуда Иуды Jud. Jud Jude Jd. Jd',
    'Рим. Рим Римл. Римл Римлянам Ro. Ro Rom. Rom Romans',
    '1Кор. 1Кор 1Коринф. 1Коринф 1Коринфянам 1Коринфянам 1Co. 1Co 1Cor. 1Cor 1Corinth. 1Corinth 1Corinthians',
    '2Кор. 2Кор 2Коринф. 2Коринф 2Коринфянам 2Коринфянам 2Co. 2Co 2Cor. 2Cor 2Corinth. 2Corinth 2Corinthians',
    'Гал. Гал Галат. Галат Галатам Ga. Ga Gal. Gal Galat. Galat Galatians',
    'Еф. Еф Ефес. Ефес Ефесянам Eph. Eph Ep. Ep Ephes. Ephes Ephesians',
    'Фил. Фил Флп. Флп Филип. Филип Филиппийцам Php. Php Ph. Ph Phil. Phil Phi. Phi. Philip. Philip Philippians',
    'Кол. Кол Колос. Колос Колоссянам Col. Col Colos. Colos Colossians',
    '1Фесс. 1Фесс 1Фес. 1Фес 1Фессалоникийцам 1Сол. 1Сол 1Солунянам 1Th. 1Th 1Thes. 1Thes 1Thess. 1Thess 1Thessalonians',
    '2Фесс. 2Фесс 2Фес. 2Фес 2Фессалоникийцам 2Сол. 2Сол 2Солунянам 2Th. 2Th 2Thes. 2Thes 2Thess. 2Thess 2Thessalonians',
    '1Тим. 1Тим  1Тимоф. 1Тимоф 1Тимофею 1Ti. 1Ti 1Tim. 1Tim 1Timothy',
    '2Тим. 2Тим 2Тимоф. 2Тимоф 2Тимофею 2Ti. 2Ti 2Tim. 2Tim 2Timothy',
    'Тит. Тит Титу Tit. Tit Ti. Ti Titus',
    'Флм. Флм Филимон. Филимон Филимону Phm. Phm Phile. Phile Phlm. Phlm Philemon',
    'Евр. Евр Евреям He. He Heb. Heb Hebr. Hebr Hebrews',
    'Откр. Откр Отк. Отк Откровен. Откровен Апок. Апок Откровение Апокалипсис Rev. Rev Re. Re Rv. Rv Revelation');

const
  C_TotalPsalms = 150;

type
  TSearchOption = (soWordParts, soContainAll, soFreeOrder, soIgnoreCase, soExactPhrase, soSkipSearch);
  TSearchOptions = set of TSearchOption;

  // book_number + chapter number list
  TChapterNumber = TPair<Integer, TIntegerDynArray>;
  TChapterNumbers = TList<TChapterNumber>;

type
  IBookSearchCallback = interface;
  TBible = class;

  TBibleSearchEvent = procedure(
    Sender: TObject;
    NumVersesFound, book, chapter, verse: integer;
    s: string;
    removeStrongs: boolean) of object;

  TBiblePasswordRequired = procedure(
    aSender: TBible;
    out outPassword: string) of object;

  TModuleLocation = record
    bookIx, ChapterIx, VerseStartIx, VerseEndIx: integer;
  end;

  TbqModuleStateEntries = (bqmsFontsInstallPending);
  TbqModuleState = set of TbqModuleStateEntries;
  TbqModuleType = (bqmBible, bqmCommentary, bqmBook);
  TbqModuleTrait = (
    bqmtOldCovenant,
    bqmtNewCovenant,
    bqmtApocrypha,
    bqmtEnglishPsalms,
    bqmtStrongs,
    bqmtIncludeChapterHead,
    bqmtZeroChapter,
    bqmtNoForcedLineBreaks);

  TbqModuleTraits = set of TbqModuleTrait;

  TBible = class
  private
    { Private declarations }
    FInfoSource: TInfoSource;
    FPath: string;
    FShortPath: string;

    // Default 8-bit encoding for all book files of TBible.
    FDesiredFontCharset: integer;

    FAlphabet: string; // ALL letters that can be parts of text in the module

    FHTML: string; // allowed HTML codes
    FFiltered: boolean;

    FLines: TStrings; // these are verses when you open a chapter

    FBook, FChapter, FVerseQty: integer;
    FRememberPlace: boolean;

    FVersesFound: integer; // run-time counter of words found during search
    FStopSearching: boolean;

    FOnChangeModule: TNotifyEvent;

    FOnPasswordRequired: TBiblePasswordRequired;

    AlphabetArray: array [0 .. 2047] of Cardinal;
    FModuleState: TbqModuleState;
    FTraits: TbqModuleTraits;
    FCategories: TStringList;
    FChapterHead: string;
    procedure ClearAlphabetBits();
    procedure SetAlphabetBit(aCode: integer; aValue: boolean);
    function GetAlphabetBit(aCode: integer): boolean;

  protected
    FRecognizeBibleLinks: boolean;
    FFuzzyResolveLinks: boolean;
    FShortNamesVars: TStringList;
    FModuleType: TbqModuleType;

    FChapterQtys: TList<Integer>;
    FChapterNumbers: TChapterNumbers;
    FFullNames: TList<String>;
    // variants for shortening the title of the book
    FShortNames: TList<String>;
    FPathNames: TList<String>;

    procedure InitializeFields();
    procedure InitializeTraits(aInfoSource: TInfoSource);
    procedure InitializeChapterData(aInfoSource: TInfoSource);
    procedure InitializeAlphabet(aInfoSource: TInfoSource);
    procedure InitializePaths(aInfoSource: TInfoSource);

    function SearchOK(Source: string; Words: TStrings; SearchOptions: TSearchOptions): Boolean;
    procedure SearchBook(Words: TStrings; SearchOptions: TSearchOptions; Book: Integer; RemoveStrongs: Boolean; Callback: IBookSearchCallback);

    function toInternal(
      const bl: TBibleLink;
      out obl: TBibleLink;
      englishbible: boolean = False;
      EnglishPsalms: boolean = False): boolean;

    function GetShortNameVars(bookIx: integer): string;
    procedure SetShortNameVars(bookIx: integer; const Name: string);
    procedure InstallFonts();
    function GetVerse(i: Cardinal): string;
    function GetTraitState(trait: TbqModuleTrait): boolean;
    procedure setTraitState(trait: TbqModuleTrait; state: boolean);
    function GetIsMyBybleModule(): Boolean;
    function IsNativeEmptyParagraph(aBookLine: String): Boolean;
    function IsNativeCaption(aBookLine: String): Boolean;
    function GetClearVerses(aLines: TStrings): TStringList;
    function GetFirstWord(aRow: String): String;

  public
    function GetChapterQtys(aBookNumber: Integer): Integer;
    function GetChapterQtysSafe(aBookNumber: Integer): Integer;
    function GetShortNames(aBookNumber: Integer): String;
    function GetFullNames(aBookNumber: Integer): String;
    function GetTSKShortNames(aNativeBookNumber: Integer): String;

    function GetStucture(): string;
    function GetDefaultEncoding(): TEncoding;
    function GetModuleName(): string;
    function GetAuthor(): string;
    function GetAllVerses(): string;
    function GetIsBible(): Boolean;
    function GetSearchSections(): TStrings;
    function GetSourceReader(): ISourceReader;

    function GetBookNumberIndex(aBookNumber: Integer): Integer;
    function GetChapterNumberIndex(aBookNumber, aChapterNumber: Integer): Integer;

    function GetBookNumberAt(aIndex: Integer): Integer;
    function GetChapterNumberAt(aParentIndex, aIndex: Integer): Integer;
    function IsValidChapterNumber(aBookNumber, aChapterNumber: Integer): Boolean;
    function IsValidBookNumber(aBookNumber: Integer): Boolean;
    function NativeToMyBibleBookNumber(aNativeBookNumber: Integer; WithNumberCorrection: Boolean = False): Integer;
    function MyBibleToNativeBookNumber(aMyBibleBookNumber: Integer): Integer;
    function CorrectNewTestamentBookNumber(aNativeBookNumber: Integer): Integer;

    function GetFirstBookNumber(): Integer;
    function GetFirstChapterNumber(): Integer;  overload;
    function GetFirstChapterNumber(Book: Integer): Integer; overload;
    function GetLastBookNumber(): Integer;
    function GetLastChapterNumber(): Integer;

    function GetNextBookNumber(): Integer;
    function GetPrevBookNumber(): Integer;
    procedure GetNextChapterNumber(BookNumber, ChapterNumber: Integer; var NextBookNumber: Integer; var NextChapterNumber: Integer);
    procedure GetPrevChapterNumber(BookNumber, ChapterNumber: Integer; var PrevBookNumber: Integer; var PrevChapterNumber: Integer);

    function SetInfoSource(aFileEntryPath: String): Boolean; overload;
    function SetInfoSource(aInfoSource: TInfoSource): Boolean; overload;

    function LinkValidnessStatus(
      path: string;
      bl: TBibleLink;
      internalAddr: boolean = true;
      checkverse: boolean = true): integer;

    function SyncToBible(const refBible: TBible; const bl: TBibleLink; out outBibleLink): integer;
    property IsMyBibleModule: Boolean read GetIsMyBybleModule;
    property Path: string read FPath;
    property PathNames: TList<String> read FPathNames;
    property ShortPath: string read FShortPath;
    property Name: string read GetModuleName;
    property Categories: TStringList read FCategories;

    // new attributes
    property Info: TInfoSource read FInfoSource;
    property Author: string read GetAuthor;

    property ShortNamesVars[ix: integer]: string read GetShortNameVars;

    property IsBible: boolean read GetIsBible;
    property ModuleType: TbqModuleType read FModuleType;

    property DefaultEncoding: TEncoding read GetDefaultEncoding;
    property DesiredCharset: integer read FDesiredFontCharset;

    property Alphabet: string read FAlphabet;

    property CurBook: integer read FBook;
    property CurChapter: integer read FChapter;
    property VerseQty: integer read FVerseQty write FVerseQty;
    property ChapterHead: string read FChapterHead write FChapterHead;

    property RememberPlace: boolean read FRememberPlace write FRememberPlace;

    property Verses[i: Cardinal]: string read GetVerse; default;

    function GetVerseByNumber(aVerseNumber: Integer): String;

    constructor Create(); reintroduce;
    destructor Destroy; override;

    function OpenCopyright(): Boolean;
    function OpenChapter(book, chapter: integer;
      forceResolveLinks: boolean = False): boolean;
    function GetShortNameVarByBookNumber(aBookNumber: Integer): String;

    function OpenReference(s: string; var book, chapter, fromverse, toverse: integer): boolean;
    function OpenTSKReference(s: string; var book, chapter, fromverse, toverse: integer): boolean;
    function OpenRussianReference(s: string; var book, chapter, fromverse, toverse: integer): boolean;

    procedure Search(SearchText: string; SearchOptions: TSearchOptions; Bookset: TIntSet; RemoveStrongs: boolean; Callback: IBookSearchCallback);
    procedure StopSearching;

    procedure ClearBuffers;

    function ReferenceToInternal(
      book, chapter, verse: integer;
      var ibook, ichapter, iverse: integer;
      checkShortNames: boolean = true): boolean; overload;

    function ReferenceToInternal(
      const moduleRelatedRef: TBibleLink;
      out independent: TBibleLink): integer; overload;

    function InternalToReference(
      ibook, ichapter, iverse: integer;
      var book, chapter, verse: integer;
      checkShortNames: boolean = true) : boolean; overload;

    function InternalToReference(inputLnk: TBibleLink; out outLink: TBibleLink): integer; overload;
    function ShortPassageSignature(book, chapter, fromverse, toverse: integer): string;
    function FullPassageSignature(book, chapter, fromverse, toverse: integer): string;

    function CountVerses(book, chapter: integer): integer;

    function isEnglish: boolean;

    procedure ENG2RUS(book, chapter, verse: integer; var rbook, rchapter, rverse: integer);
    procedure RUS2ENG(book, chapter, verse: integer; var ebook, echapter, everse: integer);

    function ReferenceToEnglish(
      book, chapter, verse: integer;
      var ebook, echapter, everse: integer;
      checkShortNames: boolean = true): boolean;

    function EnglishToReference(
      ebook, echapter, everse: integer;
      var book, chapter, verse: integer): boolean;

    procedure _InternalSetContext(book, chapter: integer);
    procedure SetHTMLFilterX(value: string; forceUserFilter: boolean);
    function VerseCount(): integer;
    property Traits: TbqModuleTraits read FTraits;
    property Trait[index: TbqModuleTrait]: boolean read GetTraitState;

  published
    property Filtered: boolean read FFiltered write FFiltered;
    property VersesFound: integer read FVersesFound;

    property OnChangeModule: TNotifyEvent read FOnChangeModule write FOnChangeModule;
    property OnPasswordRequired: TBiblePasswordRequired read FOnPasswordRequired write FOnPasswordRequired;
    property RecognizeBibleLinks: boolean read FRecognizeBibleLinks write FRecognizeBibleLinks;
    property FuzzyResolve: boolean read FFuzzyResolveLinks write FFuzzyResolveLinks;

  end;

  IBookSearchCallback = interface
    procedure OnVerseFound(bible: TBible; NumVersesFound, book, chapter, verse: integer; s: string; removeStrongs: boolean);
    procedure OnSearchComplete(bible: TBible);
  end;

implementation

uses PlainUtils, bibleLinkParser, ExceptionFrm, SelectEntityType,
     InfoSourceLoaderFabric, InfoSourceLoaderInterface, FireDAC.Comp.Client,
     MyBibleUtils, ChapterData, System.Masks, RegularExpressions,
     SourceReader, MyBibleSourceReader, NativeSourceReader;

constructor TBible.Create();
begin
  FLines := TStringList.Create;
  FCategories := TStringList.Create();
  FShortNamesVars := TStringList.Create();
  FChapterNumbers := TChapterNumbers.Create;

  FChapterQtys := TList<Integer>.Create;
  FFullNames := TList<String>.Create;
  FShortNames := TList<String>.Create;
  FPathNames := TList<String>.Create;

  FInfoSource := TInfoSource.Create;
end;

destructor TBible.Destroy;
begin
  FLines.Free;
  FCategories.Free();
  FShortNamesVars.Free();

  FreeAndNil(FChapterNumbers);
  FreeAndNil(FInfoSource);

  FreeAndNil(FChapterQtys);
  FreeAndNil(FFullNames);
  FreeAndNil(FShortNames);
  FreeAndNil(FPathNames);

  inherited Destroy;
end;

function TBible.ReferenceToInternal(const moduleRelatedRef: TBibleLink; out independent: TBibleLink): integer;
begin
  moduleRelatedRef.AssignTo(independent);

  Result := ord(ReferenceToInternal(
    moduleRelatedRef.book,
    moduleRelatedRef.chapter,
    moduleRelatedRef.vstart,
    independent.book,
    independent.chapter,
    independent.vstart)) - 1;

  if Result < 0 then
  begin
    Result := -2;
    exit;
  end;

  Inc(Result, ord(ReferenceToInternal(
    moduleRelatedRef.book,
    moduleRelatedRef.chapter,
    moduleRelatedRef.vend,
    independent.book,
    independent.chapter,
    independent.vend)) - 1);
end;

function TBible.GetBookNumberIndex(aBookNumber: Integer): Integer;
var
  i: Integer;
begin

  Result := -1;

  if FChapterNumbers.Count = 0 then exit;

  for I := 0 to FChapterNumbers.Count - 1 do
    if FChapterNumbers[i].Key = aBookNumber then
    begin
      Result := i;
      exit;
    end;

end;

procedure TBible.ClearAlphabetBits();
var
  i: integer;
begin
  for i := 0 to 2047 do
    AlphabetArray[i] := 0;
end;

procedure TBible.SetAlphabetBit(aCode: integer; aValue: boolean);
var
  dIndex: integer;
  dMask: Cardinal;
begin
  dIndex := aCode div 32;
  if (dIndex > 2047) or (dIndex < 0) then
    exit;

  dMask := 1 shl (aCode mod 32);

  if aValue then
    AlphabetArray[dIndex] := AlphabetArray[dIndex] or dMask
  else
    AlphabetArray[dIndex] := AlphabetArray[dIndex] and not dMask;

end;

function TBible.GetAlphabetBit(aCode: integer): boolean;
var
  dIndex: integer;
  dMask: Cardinal;
begin
  Result := False;

  dIndex := aCode div 32;
  if (dIndex > 2047) or (dIndex < 0) then
    exit;

  dMask := 1 shl (aCode mod 32);

  Result := (AlphabetArray[dIndex] and dMask) <> 0;

end;
{$J+}

var
  bookNames: TStringList = nil;
{$J-}

function TBible.GetShortNameVarByBookNumber(aBookNumber: Integer): String;
var
  NewTestamentOnly: Boolean;
  index: Integer;
begin

  NewTestamentOnly := not trait[bqmtOldCovenant] and trait[bqmtNewCovenant];

  if IsMyBibleModule and NewTestamentOnly then
  begin
    index := aBookNumber - 39;
    
  end
  else
    index := aBookNumber;

  Result := ShortNamesVars[index];

end;

function TBible.GetShortNameVars(bookIx: integer): string;
begin

  dec(bookIx);
  if (bookIx < 0) or (bookIx >= FShortNamesVars.Count) then
    raise ERangeError.CreateFmt
      ('Invalid request of shortNames property, invalid index=%d not in [1 - %d]',
      [bookIx + 1, 0, FShortNamesVars.Count]);

  Result := FShortNamesVars[bookIx];

end;

function TBible.GetModuleName: string;
begin
  if (FInfoSource.ModuleName <> '') then
    Result := FInfoSource.ModuleName
  else
    Result := FInfoSource.BibleName;
end;

function TBible.GetShortNames(aBookNumber: Integer): String;
var
  BookIndex: Integer;
begin
  Result := '';

  BookIndex := GetBookNumberIndex(aBookNumber);

  if BookIndex > -1 then
    Result := FShortNames[BookIndex + 1]
  else
    Result := FShortNames[aBookNumber];

end;

function TBible.GetAuthor: string;
begin
  if (FInfoSource.ModuleAuthor <> '') then
    Result := FInfoSource.ModuleAuthor
  else
    Result := FInfoSource.Copyright;
end;

function TBible.GetBookNumberAt(aIndex: Integer): Integer;
begin
  Result := FChapterNumbers[aIndex].Key
end;

function TBible.GetChapterNumberAt(aParentIndex, aIndex: Integer): Integer;
begin
  Result := FChapterNumbers[aParentIndex].Value[aIndex]
end;

function TBible.GetChapterNumberIndex(aBookNumber,
  aChapterNumber: Integer): Integer;
var
  BookIndex : Integer;
  ChapterList: TIntegerDynArray;
  i: integer;
begin

  Result:= -1;

  BookIndex:= GetBookNumberIndex(aBookNumber);
  if BookIndex = -1 then exit;

  ChapterList := FChapterNumbers[BookIndex].Value;

  for i := 0 to High(ChapterList) do
    if ChapterList[i] = aChapterNumber then
    begin
      Result := i;
      exit;
    end;

end;

function TBible.GetChapterQtys(aBookNumber: Integer): Integer;
var
  BookIndex: Integer;
begin
  BookIndex := GetBookNumberIndex(aBookNumber);

  if (BookIndex > -1) then
    Result := Length(FChapterNumbers[BookIndex].Value)
  else
    Result := FChapterQtys[aBookNumber];

end;

function TBible.GetChapterQtysSafe(aBookNumber: Integer): Integer;
var
  BookIndex: Integer;
begin
  BookIndex := GetBookNumberIndex(aBookNumber);
  Result := 0;
  if (BookIndex > -1) then
  begin
    if (BookIndex < FChapterNumbers.Count) then
      Result := Length(FChapterNumbers[BookIndex].Value)
  end
  else
  begin
    if (aBookNumber < FChapterQtys.Count) then
      Result := FChapterQtys[aBookNumber];
  end;

end;

function TBible.GetStucture: string;
var
  bookIx, bookCnt: integer;
  s: string;

begin
  bookCnt := Info.BookQty;
  if not assigned(bookNames) then
    bookNames := TStringList.Create()
  else
    bookNames.Clear();
  if IsBible and not(bqmtOldCovenant in FTraits) then
  begin
    for bookIx := 1 to 66 do
      bookNames.Add('0');
  end;

  for bookIx := 1 to bookCnt do
  begin
    if not IsBible then
    begin
      s := GetFullNames(bookIx);
      bookNames.Add(s);
    end
    else
      bookNames.Add(inttoStr(ord(Copy(GetFullNames(bookIx), 1, 5) <> '-----')));
  end;
  Result := StringReplace(bookNames.Text, #$D#$A, '|', [rfReplaceAll]);
end;

function TBible.GetDefaultEncoding(): TEncoding;
begin
  if Assigned(Info.DefaultEncoding) then
    Result := Info.DefaultEncoding
  else
    Result := TEncoding.GetEncoding(1251);
end;

function TBible.GetFirstBookNumber: Integer;
begin
  Result := GetBookNumberAt(0);
end;

function TBible.GetLastBookNumber(): Integer;
begin
  Result := GetBookNumberAt(FChapterNumbers.Count - 1);
end;

function TBible.GetLastChapterNumber(): Integer;
var
  BookIndex: Integer;
  TotalChapters: Integer;
begin
  BookIndex := GetBookNumberIndex(CurBook);
  TotalChapters := Length(FChapterNumbers[BookIndex].Value);
  Result := GetChapterNumberAt(BookIndex, TotalChapters - 1);
end;

function TBible.GetFirstChapterNumber: Integer;
begin
  Result := GetFirstChapterNumber(CurBook);
end;

function TBible.GetFirstChapterNumber(Book: Integer): Integer;
var
  BookIndex: Integer;
begin
  BookIndex := GetBookNumberIndex(Book);
  if Length(FChapterNumbers[BookIndex].Value) > 0 then
    Result := FChapterNumbers[BookIndex].Value[0]
  else
    raise Exception.Create('Unknown default chapter');
end;

function TBible.GetNextBookNumber(): Integer;
var
  BookIndex: Integer;
begin
  Result := -1;

  BookIndex := GetBookNumberIndex(CurBook);
  if (BookIndex >= 0) then
  begin
    BookIndex := BookIndex + 1;
    if (BookIndex >= FChapterNumbers.Count) then
      // we're behind the last book, go the first book
      Result := GetFirstBookNumber()
    else
      Result := GetBookNumberAt(BookIndex);
  end;

end;

function TBible.GetPrevBookNumber(): Integer;
var
  BookIndex: Integer;
begin
  Result := -1;

  BookIndex := GetBookNumberIndex(CurBook);
  if (BookIndex >= 0) then
  begin
    BookIndex := BookIndex - 1;
    if (BookIndex < 0) then
      // we're before the first book, go to the last book
      Result := GetLastBookNumber()
    else if (BookIndex < FChapterNumbers.Count) then
      Result := GetBookNumberAt(BookIndex);
  end;

end;

procedure TBible.GetNextChapterNumber(BookNumber, ChapterNumber: Integer; var NextBookNumber: Integer; var NextChapterNumber: Integer);
var
  BookIndex: Integer;
  ChapterIndex: Integer;
begin
  BookIndex := GetBookNumberIndex(BookNumber);
  ChapterIndex := GetChapterNumberIndex(BookNumber, ChapterNumber);
  ChapterIndex := ChapterIndex + 1; // next chapter
  if (ChapterIndex >= Length(FChapterNumbers[BookIndex].Value)) then
  begin
    // we're behind the last chapter of the book, go next book
    BookIndex := BookIndex + 1;
    if BookIndex >= FChapterNumbers.Count then
    begin
      // we're behind the last chapter of the last book, go to the beggining of the first book
      NextBookNumber := GetBookNumberAt(0);
      NextChapterNumber := FChapterNumbers[0].Value[0];
      Exit;
    end;

    NextBookNumber := GetBookNumberAt(BookIndex);
    NextChapterNumber := FChapterNumbers[BookIndex].Value[0];
    Exit;
  end;

  NextBookNumber := BookNumber;
  NextChapterNumber := GetChapterNumberAt(BookIndex, ChapterIndex);
end;

procedure TBible.GetPrevChapterNumber(BookNumber, ChapterNumber: Integer; var PrevBookNumber: Integer; var PrevChapterNumber: Integer);
var
  BookIndex: Integer;
  ChapterIndex: Integer;
  TotalChapters: Integer;
begin
  BookIndex := GetBookNumberIndex(BookNumber);
  ChapterIndex := GetChapterNumberIndex(BookNumber, ChapterNumber);
  ChapterIndex := ChapterIndex - 1; // previous chapter
  if (ChapterIndex < 0) then
  begin
    // we're before the first chapter of the book, go previous book
    BookIndex := BookIndex - 1;
    if BookIndex < 0 then
    begin
      // we're before the first chapter of the first book, go to the end of the last book
      PrevBookNumber := GetLastBookNumber();
      BookIndex := GetBookNumberIndex(PrevBookNumber);
      TotalChapters := Length(FChapterNumbers[BookIndex].Value);
      PrevChapterNumber := GetChapterNumberAt(BookIndex, TotalChapters - 1);
      Exit;
    end;

    PrevBookNumber := GetBookNumberAt(BookIndex);
    TotalChapters := Length(FChapterNumbers[BookIndex].Value);
    PrevChapterNumber := FChapterNumbers[BookIndex].Value[TotalChapters - 1];
    Exit;
  end;

  PrevBookNumber := BookNumber;
  PrevChapterNumber := GetChapterNumberAt(BookIndex, ChapterIndex);
end;

function TBible.GetFirstWord(aRow: String): String;
var
  i: Integer;
begin

  Result:= '';

  i:= pos(' ', aRow);
  if i > 0 then
    Result:= LeftStr(aRow, i-1);

end;

function TBible.GetFullNames(aBookNumber: Integer): String;
var
  BookIndex: Integer;
begin
  Result := '';

  BookIndex := GetBookNumberIndex(aBookNumber);

  if BookIndex > -1 then
    Result := FFullNames[BookIndex + 1]
  else
  begin
    if (aBookNumber <= 0) then
      Exit;
    Result := FFullNames[aBookNumber];
  end;
end;

function TBible.GetTraitState(trait: TbqModuleTrait): boolean;
begin
  Result := trait in FTraits;
end;

function TBible.GetTSKShortNames(aNativeBookNumber: Integer): String;
begin
  Result := TSKShortNames[aNativeBookNumber];
end;

function TBible.GetVerse(i: Cardinal): string;
begin
  if (i >= FLines.Count) then
  begin
    g_ExceptionContext.Add(Format('i=%d', [i]));
    raise ERangeError.Create('Invalid verse Number');
  end;
  Result := FLines[i];
end;

function TBible.GetAllVerses(): string;
var
  I: Integer;
  sb: TStringBuilder;
begin
  Result := '';
  sb := TStringBuilder.Create();
  for I := 0 to FLines.Count - 1 do
  begin
    sb.AppendLine(FLines[I]);
  end;
  Result := sb.ToString;
end;

function TBible.GetIsBible(): Boolean;
begin
  Result := Info.IsBible;
end;

function TBible.IsNativeEmptyParagraph(aBookLine: String): Boolean;
begin
  Result := ((Trim(aBookLine) = '<p></p>') or (Trim(aBookLine).IsEmpty));
end;

function TBible.IsNativeCaption(aBookLine: String): Boolean;
begin
  aBookLine := aBookLine.Replace('<p>', '');
  Result := MatchesMask(aBookLine, '<i>*</i>');
end;

function TBible.GetClearVerses(aLines: TStrings): TStringList;
var
  i: Integer;
  CurVerseNumber: Integer;
  FirstWord: String;
  iFirstWord, iCode: Integer;
begin
  Result := TStringList.Create;
  CurVerseNumber := 1;

  for I := 0 to aLines.Count-1 do
  begin
    FirstWord := GetFirstWord( aLines[i]);
    val(FirstWord, iFirstWord, iCode);
    if (iCode = 0) and (iFirstWord = CurVerseNumber) then
    begin
      Result.Add(aLines[i]);
      CurVerseNumber := CurVerseNumber + 1;
    end;
  end;

end;

function TBible.GetVerseByNumber(aVerseNumber: Integer): String;
var
  ClearVerses: TStringList;
begin

  Result := '';

  if IsMyBibleModule then
    Result := Verses[aVerseNumber - 1]
  else
  begin

    ClearVerses:= GetClearVerses(FLines);
    try

      if aVerseNumber < ClearVerses.Count then
        Result := ClearVerses[aVerseNumber-1];

    finally
      ClearVerses.Free;
    end;
  end;
end;

procedure TBible.SetHTMLFilterX(value: string; forceUserFilter: boolean);
begin
  if forceUserFilter then
    FHTML := value
  else
    FHTML := DefaultHTMLFilter + value;
end;

function TBible.SetInfoSource(aInfoSource: TInfoSource): Boolean;
begin

  Result := False;

  if not Assigned(aInfoSource) then exit;

  if Assigned(FInfoSource) then
    FInfoSource.Free;

  FInfoSource := aInfoSource.Clone();
  FInfoSource.InfoSourceType := aInfoSource.InfoSourceType;

  InitializeFields();
  InitializeTraits(aInfoSource);
  InitializeChapterData(aInfoSource);
  InitializeAlphabet(aInfoSource);
  InitializePaths(aInfoSource);

  Result := True;

end;

function TBible.SetInfoSource(aFileEntryPath: String): Boolean;
var
  InfoSourceType: TInfoSourceTypes;
  InfoSourceLoader: IInfoSourceLoader;
  InfoSource: TInfoSource;
begin

  Result := False;

  InfoSourceType := TSelectEntityType.SelectInfoSourceType(aFileEntryPath);

  if InfoSourceType = isNone then exit;

  InfoSourceLoader := TInfoSourceLoaderFabric.CreateInfoSourceLoader(InfoSourceType);

  if not Assigned(InfoSourceLoader) then
  begin
    raise Exception.Create('Missing info source loader');
  end;

  InfoSource := TInfoSource.Create;
  try
    InfoSource.InfoSourceType := InfoSourceType;
    InfoSourceLoader.LoadInfoSource(aFileEntryPath, InfoSource);

    if not Assigned(InfoSource) then exit;

    SetInfoSource(InfoSource);
  finally
    InfoSource.Free;
  end;

  Result := True;
end;

procedure TBible.SetShortNameVars(bookIx: integer; const Name: string);
var
  i, countDiff: integer;
begin
  dec(bookIx);
  countDiff := bookIx - FShortNamesVars.Count - 1;
  if (bookIx < 0) or (countDiff > 255) then
    raise ERangeError.CreateFmt
      ('invalid attempt to set ShortNames property, index =%d', [bookIx + 1]);

  for i := 0 to countDiff do
    FShortNamesVars.Add(''); // fill not used
  if countDiff = -1 then
    FShortNamesVars.Add(name)
  else
    FShortNamesVars[bookIx] := name;

end;

procedure TBible.setTraitState(trait: TbqModuleTrait; state: boolean);
begin
  if state then
    Include(FTraits, trait)
  else
    Exclude(FTraits, trait);
end;

function TBible.OpenCopyright(): Boolean;
var
  CopyrightPath: String;
  CopyrightLines: TStrings;
begin
  Result := False;

  CopyrightPath := TPath.Combine(Self.ShortPath, 'copyright.htm');
  CopyrightPath := ResolveFullPath(CopyrightPath);

  if (CopyrightPath <> '') then
    begin
      try
        CopyrightLines := ReadHtml(CopyrightPath, DefaultEncoding);

        FLines.Clear;
        FLines.AddStrings(CopyrightLines);
        _InternalSetContext(-1, 1);
        Result := True;
      Except
        // do nothing
      end;
    end;
end;

function TBible.OpenChapter(
  book, chapter: integer;
  forceResolveLinks: boolean = False): boolean;
var
  recLnks: boolean;
  SourceReader: ISourceReader;
begin
  Result := False;

  FLines.Clear;
  if bqmsFontsInstallPending in FModuleState then
    InstallFonts();

  FChapterHead := '';
  if ( not (IsValidBookNumber(book) and IsValidChapterNumber(book, chapter))) then exit;
  SourceReader := GetSourceReader();

  if Info.IsCommentary then
  begin
    if not SourceReader.GetCommentaryChapter(book, chapter, FLines) then exit;
  end
  else begin
    if not SourceReader.GetBibleChapter(book, chapter, FLines) then exit;
  end;

  FBook := book;
  FChapter := chapter;

  if FFiltered and (FLines.Count <> 0) then
    FLines.Text := ParseHTML(FLines.Text, FHTML);
  recLnks := (not IsBible) or (Info.IsCommentary);
  if forceResolveLinks or (recLnks and FRecognizeBibleLinks) then
  begin
    FLines.Text := ResolveLinks(FLines.Text, FFuzzyResolveLinks);
  end;

  if FFiltered and trait[bqmtIncludeChapterHead] then
    FChapterHead := ParseHTML(FChapterHead, FHTML);
  FVerseQty := FLines.Count;

  if FLines.Count = 0 then
    raise Exception.CreateFmt(
      'TBible.OpenChapter: Passage not found.' + #13#10
      + #13#10 + 'IniFile = %s' + #13#10 + 'Book=%d Chapter=%d',
      [''{FIniFile}, book, chapter]);

  Result := true;
end;

function TBible.SearchOK(Source: string; Words: TStrings; SearchOptions: TSearchOptions): Boolean;
var
  I, Lastpos, Curpos: Integer;
  Res, StopKeyword, Sr: boolean;
  Src, Wrd: string;
  StringSearchOptions: TStringSearchOptions;
begin
  Res := True;
  Src := Source;

  StringSearchOptions := [soDown];

  if not (soIgnoreCase in SearchOptions) then
    Include(StringSearchOptions, soMatchCase);

  if not (soWordParts in SearchOptions) then
  begin
    Include(StringSearchOptions, soWholeWord);

    // cleanup text for search
    for I := 1 to Length(Src) do
      if not GetAlphabetBit(Integer(Src[i])) then
        Src[i] := ' ';

    if IsBible then
    begin
      Src := Trim(Src);
      StrDeleteFirstNumber(Src);
    end;
  end;

  if not (soContainAll in SearchOptions) then
  begin
    Res := False;

    for i := 0 to Words.Count - 1 do
    begin
      Wrd := Words[i];
      StopKeyword := ((Wrd[1] = '-') or ((Length(Wrd) > 1) and (Wrd[1] = ' ') and (Wrd[2] = '-')) { second } );

      if StopKeyword then
        if (soSkipSearch in SearchOptions) then
          Continue // just skip as nothing
        else
        begin
          if Wrd[1] = '-' then
            Wrd := Copy(Wrd, 2, 1024)
          else
            Wrd := Copy(Wrd, 3, 1024);
          Words.Objects[i] := TObject(-1);
        end;

      Sr := (FindPosition(Src, Wrd, 0, StringSearchOptions) > 0);
      if StopKeyword and Sr then
      begin
        Res := False;
        Break;
      end;

      Res := Res or Sr;
    end;

    Result := Res;
    Exit;
  end;

  I := 0;
  Lastpos := 0;

  repeat
    Wrd := Words[i];
    StopKeyword := ((Wrd[1] = '-') or ((Length(Wrd) > 1) and (Wrd[1] = ' ') and (Wrd[2] = '-')) { second } );
    if StopKeyword then
    begin

      if (soSkipSearch in SearchOptions) then
      begin
        Inc(i);
        Continue;
      end
      else
      begin
        if Wrd[1] = '-' then
          Wrd := Copy(Wrd, 2, 1024)
        else
          Wrd := Copy(Wrd, 3, 1024);
      end;
    end;

    Curpos := FindPosition(Src, Wrd, 0, StringSearchOptions);
    Sr := (Curpos > 0) xor StopKeyword;

    Res := Res and Sr;
    if not Res then
      Break;

    if not StopKeyword and not (soFreeOrder in SearchOptions) then
    begin
      if Curpos < Lastpos then
      begin
        Res := False;
        Break;
      end
      else
        Lastpos := curpos;
    end;

    Words.Objects[i] := TObject(Curpos);
    Inc(i);

  until (not Res) or (i = Words.Count);

  Result := Res;
end;

function compareKeyWords(List: TStringList; Index1, Index2: integer): integer;
begin
  Result := integer(List.objects[Index1]) - integer(List.objects[Index2]);
end;

procedure TBible.SearchBook(Words: TStrings; SearchOptions: TSearchOptions; Book: Integer; RemoveStrongs: Boolean; Callback: IBookSearchCallback);
var
  I, Chapter, Verse: Integer;
  TempWords: TStringList; // lines buffer from the book
  S, SNew: string;
  NewParams: TSearchOptions;
  Verses: TStrings; // just a buffer
  SourceReader: ISourceReader;
  VerseMeta: TVerseMeta;
begin
  TempWords := TStringList.Create;

  {
    first, we're search in the book as a whole string,
    so parameters like exact phrase or word order should be omitted

    they will be used later on a verse basis
  }

  if (soExactPhrase in SearchOptions) and trait[bqmtStrongs] then
  begin
    NewParams := SearchOptions - [soExactPhrase] + [soWordParts];
    // we're filter results for exact phrases later...
    // in books with Strong's numbers we first search for non-exact phrase
    S := Trim(Words[0]);
    while S <> '' do
    begin
      SNew := DeleteFirstWord(S);
      TempWords.Add(SNew);
    end;
  end
  else
  begin
    if not (soFreeOrder in SearchOptions) then
      NewParams := SearchOptions + [soFreeOrder]
    else
      NewParams := SearchOptions;

    TempWords.AddStrings(Words);
  end;

  SourceReader := GetSourceReader();
  Verses := SourceReader.GetBookVerses(book);

  // if the whole book doesn't have matches, just skip it
  if not SearchOK(Verses.Text, TempWords, NewParams + [soSkipSearch]) then
    Exit;

  if not (soFreeOrder in SearchOptions) then
    NewParams := NewParams - [soFreeOrder];

  // reformat finished
  for I := 0 to Verses.Count - 1 do
  begin
    if FStopSearching then
      break;

    VerseMeta := TVerseMeta(Verses.Objects[I]);
    Chapter := VerseMeta.ChapterNumber;
    Verse := VerseMeta.VerseNumber;

    if SearchOK(Verses[I], TempWords, NewParams) and (Chapter > 0) then
    begin
      if ((soExactPhrase in SearchOptions) and Trait[bqmtStrongs]) then
        if (not SearchOK(DeleteStrongNumbers(Verses[I]), Words, SearchOptions)) then
          Continue; // filter for exact phrases

      Inc(FVersesFound);
      if Assigned(Callback) then
        Callback.OnVerseFound(Self, FVersesFound, Book, Chapter, Verse, Verses[I], RemoveStrongs);
    end;
  end;

  TempWords.Free;
end;

procedure TBible.Search(SearchText: string; SearchOptions: TSearchOptions; Bookset: TIntSet; RemoveStrongs: boolean; Callback: IBookSearchCallback);
var
  words: TStrings;
  w: String;
  I: Integer;
  BookNumber: Integer;
begin
  words := TStringList.Create;
  w := SearchText;

  FLines.Clear;

  FVersesFound := 0;
  FStopSearching := False;

  if not (soExactPhrase in SearchOptions) then
    while w <> '' do
      words.Add(DeleteFirstWord(w))
  else
    words.Add(Trim(SearchText));

  if words.Count > 0 then
  begin
    for I := 0 to Info.BookQty - 1 do
    begin
      BookNumber := GetBookNumberAt(I);
      if Bookset.Contains(BookNumber) then
      begin
        if FStopSearching then
          break;

        if Assigned(Callback) then
          Callback.OnVerseFound(Self, FVersesFound, BookNumber, 0, 0, '', RemoveStrongs);
        // just to know that there is a searching -- fire an event
        try
          SearchBook(words, SearchOptions, BookNumber, RemoveStrongs, Callback);
        except
          on e: Exception do
          begin
            g_ExceptionContext.Add(Format('TBible.Search: s=%s | i(cbook)=%d', [SearchText, BookNumber]));
            BqShowException(e);
          end;
        end;
      end;
    end;
  end;

  words.Free;

  if Assigned(Callback) then
    Callback.OnSearchComplete(Self);

end;

procedure TBible.StopSearching;
begin
  FStopSearching := true;
end;

function TBible.SyncToBible(const refBible: TBible; const bl: TBibleLink; out outBibleLink): integer;
var
  independentLink: TBibleLink;
  rslt: integer;
begin
  Result := -1;
  // check if both modules are bibles
  if not(refBible.isBible and isBible) then
    exit; // if not then fail

  // get indendent address
  rslt := refBible.ReferenceToInternal(bl, independentLink);
  if rslt <= -2 then
    exit;

end;

function TBible.toInternal(
  const bl: TBibleLink;
  out obl: TBibleLink;
  englishbible: boolean = False;
  EnglishPsalms: boolean = False): boolean;
begin
  Result := true;
  obl.book := bl.book;
  obl.chapter := bl.chapter;
  obl.vstart := bl.vstart;

  // in English Bible ROMANS follows ACTS instead of JAMES
  if englishbible or (EnglishPsalms and (bl.book = 19)) then
    ENG2RUS(bl.book, bl.chapter, bl.vstart, obl.book, obl.chapter, obl.vstart)
  else
  begin
    obl.book := bl.book;
    obl.chapter := bl.chapter;
    obl.vstart := bl.vstart;
  end;
end;

function TBible.VerseCount: integer;
begin
  Result := FLines.Count;
end;

function TBible.GetSearchSections(): TStrings;
var
  I, BookNumber: Integer;
  Items: TStrings;
  SourceReader: ISourceReader;
begin
  Items := TStringList.Create;
  SourceReader := GetSourceReader();
  Items.AddStrings(SourceReader.GetSpecialSearchSections);

  for I := 0 to Info.BookQty - 1 do
  begin
    BookNumber := GetBookNumberAt(I);
    Items.AddObject(GetFullNames(BookNumber), TObject(BookNumber));
  end;

  Result := Items;
end;

function TBible.GetSourceReader(): ISourceReader;
begin
  if FInfoSource.InfoSourceType = isMyBible then
    Result := TMyBibleSourceReader.Create(Self)
  else
    Result := TNativeSourceReader.Create(Self);
end;

procedure TBible._InternalSetContext(book, chapter: integer);
begin
  FBook := book;
  FChapter := chapter;
end;

function TBible.OpenRussianReference(s: string; var book, chapter, fromverse, toverse: integer): boolean;
var
  Name: string;
  ibook, ichapter, ifromverse, itoverse: integer;
begin
  Result := False;
  book := 1;
  chapter := 1;
  fromverse := 0;
  toverse := 0;

  if not SplitValue(s, name, ichapter, ifromverse, itoverse) then
    exit;

  name := ' ' + LowerCase(name) + ' ';

  for ibook := 1 to 66 do
    if Pos(string(name), string(' ' + LowerCase(RussianShortNames[ibook]) + ' ')) <> 0 then
    begin
      book := ibook;
      chapter := ichapter;
      fromverse := ifromverse;
      toverse := itoverse;

      Result := true;
      exit;
    end;
end;

function TBible.OpenTSKReference(s: string; var book, chapter, fromverse, toverse: integer): boolean;
var
  Name: string;
  BookIndex, ichapter, ifromverse, itoverse: integer;
begin
  Result := False;
  book := 1;
  chapter := 1;
  fromverse := 0;
  toverse := 0;

  if not SplitValue(s, name, ichapter, ifromverse, itoverse) then
    exit;

  name := ' ' + name + ' ';

  for BookIndex := 0 to 65 do
    if ContainsText(' ' + GetTSKShortNames(BookIndex + 1) + ' ', name) then
    begin
      if (IsMyBibleModule) then
      begin
        book := NativeToMyBibleBookNumber(BookIndex + 1);
        book := MyBibleToNativeBookNumber(book);
      end
      else
        book := GetBookNumberAt(BookIndex);

      chapter := ichapter;
      fromverse := ifromverse;
      toverse := itoverse;

      Result := true;
      exit;
    end;
end;

function TBible.OpenReference(s: string; var book, chapter, fromverse, toverse: integer): boolean;
var
  Name: string;
  BookIndex, ichapter, ifromverse, itoverse: integer;
begin
  Result := False;
  book := 1;
  chapter := 1;
  fromverse := 0;
  toverse := 0;

  if not SplitValue(s, name, ichapter, ifromverse, itoverse) then
    exit;

  name := ' ' + name + ' ';

  for BookIndex := 0 to Info.BookQty - 1 do
    if ContainsText(' ' + ShortNamesVars[BookIndex + 1] + ' ', name) then
    begin
      book := GetBookNumberAt(BookIndex);
      chapter := ichapter;
      fromverse := ifromverse;
      toverse := itoverse;

      Result := true;
      exit;
    end;
end;

procedure TBible.ClearBuffers;
begin
  FLines.Clear;
end;

function TBible.isEnglish: boolean;
begin
  if (IsMyBibleModule) then
    Result := False
  else
    Result := ((not trait[bqmtOldCovenant] and trait[bqmtNewCovenant]) and (GetChapterQtysSafe(6) = 16)) or (GetChapterQtysSafe(45) = 16);
end;

function TBible.GetIsMyBybleModule: Boolean;
begin
  Result := Info.InfoSourceType = isMyBible;
end;

function TBible.IsValidBookNumber(aBookNumber: Integer): Boolean;
begin
  if FChapterNumbers.Count = 0 then
    Result:= (aBookNumber > 0) and (aBookNumber <= Info.BookQty)
  else
    Result := GetBookNumberIndex(aBookNumber) <> -1;
end;

function TBible.IsValidChapterNumber(aBookNumber, aChapterNumber: Integer): Boolean;
begin
  if FChapterNumbers.Count = 0 then
    Result:= (aBookNumber > 0) and (aBookNumber <= Info.BookQty)
  else
    Result := GetChapterNumberIndex(aBookNumber, aChapterNumber) <> -1;
end;

function TBible.LinkValidnessStatus(
  path: string;
  bl: TBibleLink;
  internalAddr: boolean = true;
  checkverse: boolean = true): integer;
var
  effectiveLnk: TBibleLink;
  openchapter_res: boolean;
begin
  Result := 0;
  try
    if FPath <> path then
      SetInfoSource(path);
    if internalAddr then
    begin
      Result := InternalToReference(bl, effectiveLnk);
      if Result < -1 then
      begin
        exit;
      end;
    end
    else
      bl.AssignTo(effectiveLnk);
    if checkverse then
    begin
      openchapter_res := OpenChapter(effectiveLnk.book, effectiveLnk.chapter);

      if (effectiveLnk.vstart > VerseQty) or (effectiveLnk.vstart < 0) then
      begin
        Result := -2;
        exit;
      end;
      if effectiveLnk.vend > effectiveLnk.vstart then
        dec(Result, ord(effectiveLnk.vend > VerseQty));
    end
    else
      openchapter_res := effectiveLnk.chapter <= GetChapterQtys(effectiveLnk.book) - ord(trait[bqmtZeroChapter]);

    if not openchapter_res then
    begin
      Result := -2;
      exit;
    end;

  except
    Result := -2;
    g_ExceptionContext.Add('TBible.LinkValidnessStatus.path=' + path);
    g_ExceptionContext.Add('TBible.LinkValidnessStatus.bl=' + bl.ToCommand(''));
  end;

end;

function TBible.MyBibleToNativeBookNumber(aMyBibleBookNumber: Integer): Integer;
var
  i: Integer;
begin

  Result := 1;

  for I := Low(NativeToMyBibleMap) to High(NativeToMyBibleMap) do
    if NativeToMyBibleMap[i] = aMyBibleBookNumber then
    begin
      Result := i;
      exit;
    end;

end;

function TBible.NativeToMyBibleBookNumber(aNativeBookNumber: Integer; WithNumberCorrection: Boolean): Integer;
begin

  if WithNumberCorrection then
    aNativeBookNumber := CorrectNewTestamentBookNumber(aNativeBookNumber);

  Result := NativeToMyBibleMap[aNativeBookNumber];

end;

function TBible.ShortPassageSignature(book, chapter, fromverse,
  toverse: integer): string;
var
  offset: integer;
  ShortName: String;
begin
  if trait[bqmtZeroChapter] then
    offset := 1
  else
    offset := 0;

  ShortName := GetShortNames(book);

  if (fromverse <= 1) and (toverse = 0) then
    Result := Format('%s%d', [ShortName, chapter - offset])
  else if (fromverse > 1) and (toverse = 0) then
    Result := Format('%s%d:%d', [ShortName, chapter - offset, fromverse])
  else if toverse = fromverse then
    Result := Format('%s%d:%d', [ShortName, chapter - offset, fromverse])
  else if toverse = fromverse + 1 then
    Result := Format('%s%d:%d,%d', [ShortName, chapter - offset, fromverse, toverse])
  else
    Result := Format('%s%d:%d-%d', [ShortName, chapter - offset, fromverse, toverse]);
end;

function TBible.FullPassageSignature(book, chapter, fromverse, toverse: integer): string;
var
  offset: integer;
  FullName: String;
begin
  if trait[bqmtZeroChapter] then
    offset := 1
  else
    offset := 0;

  FullName := GetFullNames(book);

  if (fromverse <= 1) and (toverse = 0) then
    Result := Format('%s %d', [FullName, chapter - offset])
  else if (fromverse > 1) and (toverse = 0) then
    Result := Format('%s %d:%d', [FullName, chapter - offset, fromverse])
  else if toverse = fromverse then
    Result := Format('%s %d:%d', [FullName, chapter - offset, fromverse])
  else if toverse = fromverse + 1 then
    Result := Format('%s %d:%d,%d', [FullName, chapter - offset, fromverse, toverse])
  else
    Result := Format('%s %d:%d-%d', [FullName, chapter - offset, fromverse, toverse]);
end;

function TBible.CorrectNewTestamentBookNumber(
  aNativeBookNumber: Integer): Integer;
var
  NewTestamentOnly: Boolean;
begin
  NewTestamentOnly := not trait[bqmtOldCovenant] and trait[bqmtNewCovenant];

  if (NewTestamentOnly and IsMyBibleModule) then
    aNativeBookNumber := aNativeBookNumber + 39;

  Result := aNativeBookNumber;

end;

function TBible.CountVerses(book, chapter: integer): integer;
var
  slines: TStrings;
  i, Count: integer;
begin
  if chapter < 1 then
  begin
    Result := CountVerses(book, 1);
    exit;
  end
  else if chapter > FChapterQtys[book] then
  begin
    Result := CountVerses(book, FChapterQtys[book]);
    exit;
  end;

  slines := nil;
  try
    slines := ReadHtml(FPath + FPathNames[book], DefaultEncoding);

    i := 0;
    Count := 0;
    repeat
      if Pos(Info.ChapterSign, slines[i]) > 0 then
        Inc(Count);
      if Count = chapter then
        break;
      Inc(i);
    until i = slines.Count;

    if i = slines.Count then
    begin
      Result := 0;
      exit;
    end;

    Count := 0;
    repeat
      if Pos(Info.VerseSign, slines[i]) > 0 then
        Inc(Count);
      Inc(i);
    until (i = slines.Count) or (Pos(Info.ChapterSign, slines[i]) > 0);

  finally
    slines.Free;

  end;

  Result := Count;
end;

procedure TBible.ENG2RUS(book, chapter, verse: integer; var rbook, rchapter, rverse: integer);
begin
  rbook := book;
  rchapter := chapter;
  rverse := verse;

  if rbook > 39 then
    rbook := EngToRusTable[book - 39] + 39; // convert NT books

  // CHAPTER SHIFT

  case book of
    // JOB=40:1-40:5#-1;41:1-41:8#-1
    18:
      if ((chapter = 40) and (verse in [1 .. 5])) or
        ((chapter = 41) and (verse in [1 .. 8])) then
        rchapter := rchapter - 1;
    // PSA=10:1-147:11#-1
    19:
      begin
        if (chapter in [10 .. 146]) or ((chapter = 147) and (verse in [1 .. 11]))
        then
          rchapter := rchapter - 1;

        if (chapter = 115) then
          rchapter := rchapter - 1; // 115:1-18 = RUS 113:9-26
        // if(chapter = 116) and (verse>=10) then rchapter := rchapter-1; // 116:10-.. = RUS 114
      end;
    // ECC=5:1#-1
    21:
      if (chapter = 5) and (verse = 1) then
        rchapter := rchapter - 1;
    // SNG=6:13#+1
    22:
      if (chapter = 6) and (verse = 13) then
        rchapter := rchapter + 1;
    // DAN=4:1-4:3#-1
    27:
      if (chapter = 4) and (verse in [1 .. 3]) then
        rchapter := rchapter - 1;
    // JON=1:17#1
    32:
      if (chapter = 1) and (verse = 17) then
        rchapter := rchapter + 1;
    // ROM=16:25-16:27#-2
    45:
      if (chapter = 16) and (verse in [25 .. 27]) then
        rchapter := rchapter - 2;
  end;

  // VERSE SHIFT

  // JOB40=1-5#30;6-24#-5
  if (book = 18) and (chapter = 40) and (verse in [1 .. 5]) then
    rverse := rverse + 30;
  if (book = 18) and (chapter = 40) and (verse in [6 .. 24]) then
    rverse := rverse - 5;

  // JOB41=1-8#19;9-34#-8
  if (book = 18) and (chapter = 41) and (verse in [1 .. 8]) then
    rverse := rverse + 19;
  if (book = 18) and (chapter = 41) and (verse in [9 .. 34]) then
    rverse := rverse - 8;

  if (book = 19) then
  begin
    {
      PSA3=2+#1       PSA4=2+#1       PSA5=2+#1       PSA6=2+#1       PSA7=2+#1
      PSA8=2+#1       PSA9=2+#1       PSA18=2+#1      PSA19=2+#1      PSA20=2+#1
      PSA21=2+#1      PSA22=2+#1      PSA30=2+#1      PSA31=2+#1      PSA34=2+#1
      PSA36=2+#1      PSA38=2+#1      PSA39=2+#1      PSA40=2+#1      PSA41=2+#1
      PSA42=2+#1      PSA44=2+#1      PSA45=2+#1      PSA46=2+#1      PSA47=2+#1
      PSA48=2+#1      PSA49=2+#1      PSA53=2+#1      PSA55=2+#1      PSA56=2+#1
      PSA57=2+#1      PSA58=2+#1      PSA61=2+#1      PSA62=2+#1      PSA63=2+#1
      PSA64=2+#1      PSA65=2+#1      PSA67=2+#1      PSA68=2+#1      PSA69=2+#1
      PSA70=2+#1      PSA75=2+#1      PSA76=2+#1      PSA77=2+#1      PSA80=2+#1
      PSA81=2+#1      PSA83=2+#1      PSA84=2+#1      PSA85=2+#1      PSA88=2+#1
      PSA89=2+#1      PSA92=2+#1      PSA102=2+#1     PSA108=2+#1
    }
    if (chapter in [3 .. 9, 12, 13, 18 .. 22, 30, 31, 34, 36, 38 .. 42,
      44 .. 49, 53, 55 .. 58, 59, 61 .. 65, 67 .. 70, 75 .. 77, 80, 81,
      83 .. 85, 88, 89, 90, 92, 102, 108, 140]) and (verse >= 2) then
      rverse := rverse + 1;
    // PSA10=1+#21
    if (chapter = 10) then
      rverse := rverse + 21;
    // PSA51=2#1;3+#2
    // PSA52=2#1;3+#2
    // PSA54=2#1;3+#2
    // PSA60=2#1;3+#2
    if (chapter in [51, 52, 54, 60]) and (verse = 2) then
      rverse := rverse + 1;
    if (chapter in [51, 52, 54, 60]) and (verse >= 3) then
      rverse := rverse + 2;

    if chapter = 115 then
      rverse := rverse + 8;
    if (chapter = 116) and (verse >= 10) then
      rverse := rverse - 9;
    if (chapter = 147) and (verse >= 12) then
      rverse := rverse - 11;
  end;

  // ECC5=1#16;2-20#-1
  if (book = 21) and (chapter = 5) then
    if verse = 1 then
      rverse := rverse + 16
    else if verse in [2 .. 20] then
      rverse := rverse - 1;

  // SNG1=2-16#-1
  if (book = 22) and (chapter = 1) and (verse in [2 .. 16]) then
    rverse := rverse - 1;

  // SNG6=13#-12
  if (book = 22) and (chapter = 6) and (verse = 13) then
    rverse := rverse - 12;

  // SNG7=1-13#1
  if (book = 22) and (chapter = 7) and (verse in [1 .. 13]) then
    rverse := rverse + 1;

  // DAN3=24-30#67
  if (book = 27) and (chapter = 3) and (verse in [24 .. 30]) then
    rverse := rverse + 67;

  // DAN4=1-3#97;4-37#-3
  if (book = 27) and (chapter = 4) then
    if (verse in [1 .. 3]) then
      rverse := rverse + 97
    else if (verse in [4 .. 37]) then
      rverse := rverse - 3;

  // JON2=1-10#1
  if (book = 32) and (chapter = 2) and (verse in [1 .. 10]) then
    rverse := rverse + 1;

  // PRO13=14-25#1
  if (book = 20) and (chapter = 13) and (verse in [14 .. 25]) then
    rverse := rverse + 1;

  // PRO18=8-24#1
  if (book = 20) and (chapter = 18) and (verse in [8 .. 24]) then
    rverse := rverse + 1;

  // ROM16=25-27#-1
  if (book = 45) and (chapter = 16) and (verse in [25 .. 27]) then
    rverse := rverse - 1;

  // 2CO13=13#-1
  if (book = 47) and (chapter = 13) and (verse = 13) then
    rverse := rverse - 1;
end;

procedure TBible.RUS2ENG(book, chapter, verse: integer; var ebook, echapter, everse: integer);
begin
  ebook := book;
  echapter := chapter;
  everse := verse;

  if ebook > 39 then
    ebook := RusToEngTable[book - 39] + 39; // convert NT books

  // rules are ENG 2 RUS, from old KJV2RST method...

  // CHAPTER SHIFT

  case book of
    // JOB=40:1-40:5#-1;41:1-41:8#-1
    18:
      if ((chapter = 39) and (verse in [31 .. 35])) or
        ((chapter = 40) and (verse in [20 .. 27])) then
        echapter := echapter + 1;
    // PSA=10:1-147:11#-1
    19:
      begin
        if (chapter in [10 .. 145]) or ((chapter = 146) and (verse in [1 .. 11])
          ) or ((chapter = 9) and (verse in [22 .. 39])) then
          echapter := echapter + 1;

        if ((chapter = 113) and (verse in [9 .. 26])) or (chapter = 114) then
          echapter := echapter + 1; // +2, RUS 113:9-26 = 115:1-18
      end;
    // ECC=5:1#-1
    21:
      if (chapter = 4) and (verse = 17) then
        echapter := echapter + 1;
    // SNG=6:13#-1
    22:
      if (chapter = 7) and (verse = 1) then
        echapter := echapter - 1;
    // DAN=4:1-4:3#-1
    27:
      if (chapter = 3) and (verse in [98 .. 100]) then
        echapter := echapter - 1;
    // JON=1:17#1
    32:
      if (chapter = 2) and (verse = 1) then
        echapter := echapter - 1;
    // ROM=16:25-16:27#-2
    52:
      if (chapter = 14) and (verse in [24 .. 26]) then
        echapter := echapter + 2;
  end;

  // VERSE SHIFT

  // JOB40=1-5#30;6-24#-5
  if (book = 18) and (chapter = 39) and (verse in [31 .. 35]) then
    everse := everse - 30;
  if (book = 18) and (chapter = 40) and (verse in [1 .. 19]) then
    everse := everse + 5;

  // JOB41=1-8#19;9-34#-8
  if (book = 18) and (chapter = 40) and (verse in [20 .. 27]) then
    everse := everse - 19;
  if (book = 18) and (chapter = 41) and (verse in [1 .. 26]) then
    everse := everse + 8;

  if (book = 19) then
  begin
    {
      PSA3=2+#1       PSA4=2+#1       PSA5=2+#1       PSA6=2+#1       PSA7=2+#1
      PSA8=2+#1       PSA9=2+#1       PSA18=2+#1      PSA19=2+#1      PSA20=2+#1
      PSA21=2+#1      PSA22=2+#1      PSA30=2+#1      PSA31=2+#1      PSA34=2+#1
      PSA36=2+#1      PSA38=2+#1      PSA39=2+#1      PSA40=2+#1      PSA41=2+#1
      PSA42=2+#1      PSA44=2+#1      PSA45=2+#1      PSA46=2+#1      PSA47=2+#1
      PSA48=2+#1      PSA49=2+#1      PSA53=2+#1      PSA55=2+#1      PSA56=2+#1
      PSA57=2+#1      PSA58=2+#1      PSA61=2+#1      PSA62=2+#1      PSA63=2+#1
      PSA64=2+#1      PSA65=2+#1      PSA67=2+#1      PSA68=2+#1      PSA69=2+#1
      PSA70=2+#1      PSA75=2+#1      PSA76=2+#1      PSA77=2+#1      PSA80=2+#1
      PSA81=2+#1      PSA83=2+#1      PSA84=2+#1      PSA85=2+#1      PSA88=2+#1
      PSA89=2+#1      PSA92=2+#1      PSA102=2+#1     PSA108=2+#1
    }
    if (chapter in [3 .. 9, 11, 12, 17, 18 .. 22, 29, 30, 33, 35, 37 .. 41,
      43 .. 48, 52, 54 .. 58, 60 .. 64, 66 .. 69, 74 .. 76, 79, 80, 82 .. 84,
      87, 88, 89, 91, 101, 107, 139]) and (verse >= 2) then
      everse := everse - 1;
    // PSA10=1+#21
    if (chapter = 9) and (verse >= 22) then
      everse := everse - 20;
    // PSA51=2#1;3+#2
    // PSA52=2#1;3+#2
    // PSA54=2#1;3+#2
    // PSA60=2#1;3+#2
    if (chapter in [50, 51, 53, 59]) and (verse <= 2) then
      everse := 1;
    if (chapter in [50, 51, 53, 59]) and (verse >= 3) then
      everse := everse - 2;

    if (chapter = 113) and (verse >= 9) then
      everse := everse - 8;
    if (chapter = 115) then
      everse := everse + 9;
  end;

  // ECC5=1#16;2-20#-1
  if (book = 21) and (chapter = 4) then
    if verse = 17 then
      everse := everse - 16
    else if (chapter = 5) and (verse in [1 .. 19]) then
      everse := everse + 1;

  // SNG1=2-16#-1
  if (book = 22) and (chapter = 1) and (verse in [1 .. 15]) then
    everse := everse + 1;

  // SNG6=13#-12
  if (book = 22) and (chapter = 7) and (verse = 1) then
    everse := everse + 12;

  // SNG7=1-13#1
  if (book = 22) and (chapter = 7) and (verse in [2 .. 14]) then
    everse := everse - 1;

  // DAN3=24-30#67
  if (book = 27) and (chapter = 3) and (verse in [91 .. 97]) then
    everse := everse - 67;

  // DAN4=1-3#97;4-37#-3
  if (book = 27) and (chapter = 3) and (verse in [98 .. 100]) then
    everse := everse - 97;
  if (book = 27) and (chapter = 4) and (verse in [1 .. 34]) then
    everse := everse + 3;

  // JON2=1-10#1
  if (book = 32) and (chapter = 2) and (verse = 1) then
    everse := everse + 16;
  if (book = 32) and (chapter = 2) and (verse in [2 .. 11]) then
    everse := everse - 1;

  // PRO13=14-25#1
  if (book = 20) and (chapter = 13) and (verse in [15 .. 26]) then
    everse := everse - 1;

  // PRO18=8-24#1
  if (book = 20) and (chapter = 18) and (verse in [9 .. 25]) then
    everse := everse - 1;

  // ROM16=25-27#-1
  if (book = 52) and (chapter = 14) and (verse in [24 .. 26]) then
    everse := everse + 1;

  // 2CO13=13#-1
  if (book = 54) and (chapter = 13) and (verse = 13) then
    everse := everse + 1;
end;

{
  procedures to convert a Russian Bible reference (which is stored in xref.dat)
  to equivalent in current module
}
function BookShortNamesToRussianBible(const ShortNames: string; out book: integer): integer;
var
  maxMatchValue, maxMatchIx, currentMatchValue, i: integer;
begin
  maxMatchValue := -1;
  maxMatchIx := -1;
  for i := 1 to 66 do
  begin
    currentMatchValue := CompareTokenStrings(RussianShortNames[i], ShortNames, ' ');
    if currentMatchValue > maxMatchValue then
    begin
      maxMatchValue := currentMatchValue;
      maxMatchIx := i;
    end;
  end;
  Result := maxMatchValue;
  book := maxMatchIx;
end;

function TBible.ReferenceToInternal(
  book, chapter, verse: integer;
  var ibook, ichapter, iverse: integer;
  checkShortNames: boolean = true): boolean;
var
  newTestamentOnly, englishbible, convertToRus: boolean;
  offset, checkNamesResult, savebook: integer;
begin
  if IsMyBibleModule then
    book := MyBibleToNativeBookNumber(book);

  Result := true;

  offset := IfThen(trait[bqmtZeroChapter], 1, 0);
  ibook := book;
  ichapter := chapter - offset;
  iverse := verse;

  if (not IsBible) or (book > 66) then
  begin
    ibook := 1;
    ichapter := 1;
    iverse := 1;
    Result := False;
    exit;
  end;

  if IsMyBibleModule then
    newTestamentOnly := False
  else
    newTestamentOnly := not trait[bqmtOldCovenant] and trait[bqmtNewCovenant];

  if newTestamentOnly then
    Inc(book, 39);

  englishbible := isEnglish();

  savebook := book;

  if checkShortNames and not IsMyBibleModule then
  begin
    checkNamesResult := BookShortNamesToRussianBible(ShortNamesVars[savebook], ibook);
    if checkNamesResult > 30 then
    begin
      book := ibook;
      if englishbible then
      begin
        RUS2ENG(book, 1, 1, ibook, ichapter, iverse);
        book := ibook;
      end;
    end;
  end;
  // in English Bible ROMANS follows ACTS instead of JAMES

  convertToRus := englishbible or (not newTestamentOnly and (trait[bqmtEnglishPsalms] and (book = 19)));
  if convertToRus then
    ENG2RUS(book, chapter - offset, verse, ibook, ichapter, iverse)
  else
  begin
    ibook := book;
    ichapter := chapter - offset;
    iverse := verse;
  end;

end;

procedure TBible.InitializeFields();
begin

  FModuleState := [];
  FModuleType := bqmBook;

  FBook := 1;
  FChapter := 1;

  FFiltered := true;
  FHTML := DefaultHTMLFilter + Info.HTMLFilter;

  FStopSearching := False;

  FRememberPlace := true;

  if not Info.InstallFonts.IsEmpty then
    Include(FModuleState, bqmsFontsInstallPending);

  FCategories.Clear();
  StrToTokens(Info.Categories, '|', FCategories);
end;

procedure TBible.InitializePaths(aInfoSource: TInfoSource);
begin
    if aInfoSource.InfoSourceType = isNative then
    begin
      FPath := ExtractFilePath(aInfoSource.FileName);
      FShortPath := ExtractRelativePath(TAppDirectories.Root, FPath);
      FShortPath := ExcludeTrailingPathDelimiter(FShortPath);
    end
    else begin
      FPath := aInfoSource.FileName;
      FShortPath := TPath.Combine(
                      ExtractRelativePath(TAppDirectories.Root, ExtractFilePath(FPath)),
                      ExtractFileName(FPath));
    end;

    if IsBible then
    begin
      if aInfoSource.IsCommentary then
        FModuleType := bqmCommentary
      else
        FModuleType := bqmBible;

      if trait[bqmtOldCovenant] then
        FCategories.Add(Lang.SayDefault('catOT', 'Old Covenant'));

      if trait[bqmtNewCovenant] then
        FCategories.Add(Lang.SayDefault('catNT', 'New Covenant'));

      if trait[bqmtApocrypha] then
        FCategories.Add(Lang.SayDefault('catApocrypha', 'Apocrypha'));
    end
    else
    begin // not bible
      Exclude(FTraits, bqmtOldCovenant);
      Exclude(FTraits, bqmtNewCovenant);
      Exclude(FTraits, bqmtApocrypha);
    end;
    if Assigned(FOnChangeModule) then
      FOnChangeModule(Self);
end;

procedure TBible.InitializeAlphabet(aInfoSource: TInfoSource);
var
  i: Integer;
begin
  FAlphabet := aInfoSource.Alphabet + '0123456789';

  ClearAlphabetBits;

  for i := 1 to length(FAlphabet) do
    SetAlphabetBit(integer(FAlphabet[i]), true);

end;

procedure TBible.InitializeChapterData(aInfoSource: TInfoSource);
var
  Count: Integer;
  i, index: Integer;
  ShortName: String;
  ChapterList: TIntegerDynArray;
  ChapterData: TChapterData;
  ChapterNumber: TChapterNumber;
begin

  FChapterNumbers.Clear;
  Count := aInfoSource.ChapterDatas.Count;

  FPathNames.Count := Count + 1;
  FFullNames.Count := Count + 1;
  FShortNames.Count := Count + 1;
  FChapterQtys.Count := Count + 1;

  for i := 0 to aInfoSource.ChapterDatas.Count - 1 do
  begin
    index := i + 1;
    ChapterData := aInfoSource.ChapterDatas[i];

    FPathNames[index] := ChapterData.PathName;
    FFullNames[index] := ChapterData.FullName;

    ShortName := ChapterData.ShortName;
    SetShortNameVars(index, ShortName);
    FShortNames[index] := FirstWord(ShortNamesVars[index]);

    FChapterQtys[index] := Length(ChapterData.ChapterNumbers);

    if (ChapterData.BookNumber > 0) then
    begin
      if Length(ChapterData.ChapterNumbers) = 0 then
        raise Exception.Create('Empty chapter list for book '+IntToStr(ChapterData.BookNumber));

      ChapterList := Copy(ChapterData.ChapterNumbers, 0, Length(ChapterData.ChapterNumbers));

      ChapterNumber := TChapterNumber.Create(ChapterData.BookNumber, ChapterList);
      FChapterNumbers.Add(ChapterNumber);
    end;
  end;
end;

procedure TBible.InitializeTraits(aInfoSource: TInfoSource);
begin
  FTraits := [bqmtOldCovenant, bqmtNewCovenant];

  setTraitState(bqmtOldCovenant, aInfoSource.OldTestament);
  setTraitState(bqmtNewCovenant, aInfoSource.NewTestament);
  setTraitState(bqmtApocrypha, aInfoSource.Apocrypha);
  setTraitState(bqmtZeroChapter, aInfoSource.ChapterZero);
  setTraitState(bqmtEnglishPsalms, aInfoSource.EnglishPsalms);
  setTraitState(bqmtStrongs, aInfoSource.StrongNumbers);
  setTraitState(bqmtNoForcedLineBreaks, aInfoSource.NoForcedLineBreaks);
  setTraitState(bqmtIncludeChapterHead, aInfoSource.UseChapterHead);

end;

procedure TBible.InstallFonts;
var
  pc: PChar;
  saveChar: Char;
  l: integer;
  token: String;

begin
  pc := Pointer(Info.InstallFonts);
  if (pc = nil) then
    exit;

  pc := GetTokenFromString(pc, ',', l);
  if pc <> nil then
    repeat
      saveChar := (pc + l)^;
      (pc + l)^ := #0;
      token := pc;
      (pc + l)^ := saveChar;
      FontManager.InstallFont(FPath + Trim(token));

      Inc(pc, l);

      pc := GetTokenFromString(pc, ',', l);
    until (pc = nil);

end;

function TBible.InternalToReference(inputLnk: TBibleLink; out outLink: TBibleLink): integer;
begin
  inputLnk.AssignTo(outLink);
  outLink.tokenEndOffset := outLink.tokenEndOffset;
  Result := ord(InternalToReference(inputLnk.book, inputLnk.chapter,
    inputLnk.vstart, outLink.book, outLink.chapter, outLink.vstart)) - 1;
  if Result < 0 then
  begin
    Result := -2;
    exit;
  end;
  Inc(Result,
    ord(InternalToReference(inputLnk.book, inputLnk.chapter, inputLnk.vend, outLink.book, outLink.chapter, outLink.vend)) - 1);
end;

function RussianBibleBookToModuleBook(bookIx: integer; bibleModule: TBible; out book: integer): integer;
var
  maxMatchValue, maxMatchIx, currentMatchValue, i, modBookCount: integer;
begin
  maxMatchValue := -1;
  maxMatchIx := -1;
  modBookCount := bibleModule.Info.BookQty;
  for i := 1 to modBookCount do
  begin
    currentMatchValue := CompareTokenStrings(RussianShortNames[bookIx], bibleModule.ShortNamesVars[i], ' ');
    if currentMatchValue > maxMatchValue then
    begin
      maxMatchValue := currentMatchValue;
      maxMatchIx := i;
    end;
  end;
  Result := maxMatchValue;
  book := maxMatchIx;
end;

function TBible.InternalToReference(
  ibook, ichapter, iverse: integer;
  var book, chapter, verse: integer;
  checkShortNames: boolean = true): boolean;
var
  newCovenantOnly, oldCovenantOnly: boolean;
  checkNamesResult, savebook: integer;

  procedure ResetLink();
  begin
    book := IfThen(IsMyBibleModule, 10, 1);
    chapter := 1;
    verse := 1;
  end;
begin
  Result := true;

  book := ibook;
  savebook := ibook;
  chapter := ichapter;
  verse := iverse;

  if ichapter > C_TotalPsalms then
    chapter := 1;

  if (not IsBible) then
  begin
    ResetLink();
    Result := False;
    Exit;
  end;

  if (ibook > 66) then
  begin
    Result := True;
    Exit;
  end;

  newCovenantOnly := not trait[bqmtOldCovenant] and trait[bqmtNewCovenant];

  // in English Bible ROMANS (16 chaps) follows ACTS instead of JAMES (5 chaps)

  if not newCovenantOnly then // если не НЗ
  begin
    oldCovenantOnly := not trait[bqmtNewCovenant] and trait[bqmtOldCovenant];

    if oldCovenantOnly and (book >= 40) then
    begin
      ResetLink();
      Result := False;
      Exit;
    end;

    if isEnglish or (trait[bqmtEnglishPsalms] and (book = 19)) then
      RUS2ENG(ibook, ichapter, iverse, book, chapter, verse)
    else
    begin
      book := ibook;
      chapter := ichapter;
      verse := iverse;
    end;
  end
  else
  begin // если только нз
    if isEnglish then
    begin
      RUS2ENG(ibook, ichapter, iverse, book, chapter, verse);
      if book > 39 then
        book := book - 39
      else
      begin
        ResetLink();
        Result := False;
        Exit;
      end;
    end
    else
    begin // не английская библия
      if ibook > 39 then
      begin
        book := ibook - 39;
        chapter := ichapter;
        verse := iverse;
      end
      else
      begin
        ResetLink();
        Result := False;
        exit;
      end;
    end;

  end;
  if trait[bqmtZeroChapter] then
    chapter := chapter + 1;
  if checkShortNames and not IsMyBibleModule then
  begin
    checkNamesResult := RussianBibleBookToModuleBook(savebook, Self, ibook);
    if checkNamesResult > 30 then
      book := ibook;
  end;

  if (chapter = 0) and (not trait[bqmtZeroChapter]) then
    chapter := 1;

  if IsMyBibleModule then
    book := NativeToMyBibleBookNumber(book, True);
end;

function TBible.ReferenceToEnglish(
  book, chapter, verse: integer;
  var ebook, echapter, everse: integer;
  checkShortNames: boolean = true): boolean;
var
  newTestamentOnly: boolean;
  offset, savebook, checkNamesResult: integer;
  ShortName: String;

begin
  Result := true;

  offset := 0;
  if trait[bqmtZeroChapter] then
    offset := 1;

  ebook := book;
  echapter := chapter - offset;
  everse := verse;

  if (not IsBible) or (book > 66) then
  begin
    ebook := 1;
    echapter := 1;
    everse := 1;
    Result := False;
    exit;
  end;

  newTestamentOnly := not trait[bqmtOldCovenant] and trait[bqmtNewCovenant];
  // in English Bible ROMANS follows ACTS instead of JAMES
  savebook := book;
  if checkShortNames and not IsMyBibleModule then
  begin

    ShortName := GetShortNameVarByBookNumber( savebook );

    checkNamesResult := BookShortNamesToRussianBible(ShortName, ebook);
    if checkNamesResult > 30 then
    begin
      book := ebook;
      if isEnglish then
      begin
        RUS2ENG(book, 1, 1, ebook, echapter, everse);
        book := ebook;
      end;
    end;
  end;
  if not newTestamentOnly then
  begin
    if isEnglish then
    begin
      ebook := book;
      echapter := chapter - offset;
      everse := verse;
    end
    else
    begin
      RUS2ENG(book, chapter - offset, verse, ebook, echapter, everse)
    end;
  end
  else
  begin
    if isEnglish then
    begin
      ebook := book;
      echapter := chapter - offset;
      everse := verse;
    end
    else
    begin
      RUS2ENG(book, chapter - offset, verse, ebook, echapter, everse)
    end;
  end;
end;

function TBible.EnglishToReference(
  ebook, echapter, everse: integer;
  var book, chapter, verse: integer): boolean;
var
  newtestament: boolean;
begin
  Result := true;

  book := ebook;
  chapter := echapter;
  verse := everse;

  if (not IsBible) or (ebook > 66) then
  begin
    book := 1;
    chapter := 1;
    verse := 1;
    Result := False;
    exit;
  end;

  newtestament := not trait[bqmtOldCovenant] and trait[bqmtNewCovenant];

  // in English Bible ROMANS (16 chaps) follows ACTS instead of JAMES (5 chaps)

  if not newtestament then
  begin
    if isEnglish then
    begin
      book := ebook;
      chapter := echapter;
      verse := everse;
    end
    else
    begin
      ENG2RUS(ebook, echapter, everse, book, chapter, verse)
    end;
  end
  else
  begin
    if isEnglish then
    begin
      book := ebook - 39;
      chapter := echapter;
      verse := everse;
    end
    else
    begin
      ENG2RUS(ebook, echapter, everse, book, chapter, verse);
      book := book - 39;
    end;
  end;

  if trait[bqmtZeroChapter] then
    chapter := chapter + 1;
end;

{

  Psalms: array[1..150] of integer =
  (6, 12, 9, 9, 13, 11, 18, 10, 39, 8,
  9, 6, 8, 6, 12, 16, 51, 15, 10, 14,
  32, 7, 11, 23, 13, 15, 10, 12, 13,
  25, 12, 22, 23, 29, 13, 41, 23, 14, 18, 14, 12, 5, 27, 18, 12, 10, 15, 21,
  24, 21, 11, 7, 9, 24, 14, 12, 12, 18, 14, 9, 13, 12, 11, 14, 21, 8, 36, 37, 6,
  24, 20, 29, 24, 11, 13, 21, 73, 14, 20, 17, 9, 19, 13, 14, 18, 7, 19, 53, 17,
  16, 16, 5, 23, 11, 13, 12, 10, 9, 6, 9, 29, 23, 35, 45, 49, 43, 14, 32, 8,
  11, 11, 10, 26, 9, 10, 2, 29, 176, 8, 9, 10, 5, 9, 6, 7, 6, 7, 9, 9, 4, 19,
  4, 4, 22, 26, 9, 9, 25, 14, 11, 8, 13, 16, 22, 10, 11, 9, 14, 9, 6);

}

initialization

finalization

try
  bookNames.Free();
except
end;

end.
