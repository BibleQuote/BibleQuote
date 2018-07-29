unit TabData;

interface

uses System.Classes, SysUtils, Controls, Bible, Htmlview;

type
  TViewTabLocType = (vtlUnspecified, vtlModule, vtlFile);

  TViewTabInfoStateEntries = (
    vtisShowStrongs,
    vtisShowNotes,
    vtisHighLightVerses,
    vtisResolveLinks,
    vtisFuzzyResolveLinks,
    vtisPendingReload);

  TViewTabInfoState = set of TViewTabInfoStateEntries;

  TViewTabBrowserState = class
  private
    mSelStart: integer;
    mSelLenght: integer;
    mHScrollPos: integer;
    mVScrollPos: integer;
  public
    property SelStart: integer read mSelStart write mSelStart;
    property SelLenght: integer read mSelLenght write mSelLenght;
    property HScrollPos: integer read mHScrollPos write mHScrollPos;
    property VScrollPos: integer read mVScrollPos write mVScrollPos;

    constructor Create();
  end;

  TViewTabInfo = class
  private
    mLocation, mTitleLocation: string;
    mTitleFont: string;
    mCopyrightNotice: string;
    mTitle: string;
    mBible, mSecondBible: TBible;
    mReferenceBible: TBible;

    mSatelliteName: string;
    mFirstVisiblePara, mLastVisiblePara: integer;

    mState: TViewTabInfoState;
    mLocationType: TViewTabLocType;
    mBrowserState: TViewTabBrowserState;

    mIsCompareTranslation: Boolean;
    mCompareTranslationText: string;

    function GetStateEntryStatus(stateEntry: TViewTabInfoStateEntries): Boolean; inline;
    procedure SetStateEntry(stateEntry: TViewTabInfoStateEntries; value: Boolean);
  public
    property State: TViewTabInfoState read mState write mState;

    property Location: string read mLocation write mLocation;
    property TitleLocation: string read mTitleLocation write mTitleLocation;
    property TitleFont: string read mTitleFont write mTitleFont;
    property CopyrightNotice: string read mCopyrightNotice write mCopyrightNotice;
    property Title: string read mTitle write mTitle;
    property SatelliteName: string read mSatelliteName write mSatelliteName;

    property FirstVisiblePara: integer read mFirstVisiblePara write mFirstVisiblePara;
    property LastVisiblePara: integer read mLastVisiblePara  write mLastVisiblePara;

    property Bible: TBible read mBible;
    property SecondBible: TBible read mSecondBible write mSecondBible;
    property ReferenceBible: TBible read mReferenceBible write mReferenceBible;

    property LocationType: TViewTabLocType read mLocationType write mLocationType;
    property BrowserState: TViewTabBrowserState read mBrowserState;
    property IsCompareTranslation: Boolean read mIsCompareTranslation write mIsCompareTranslation;
    property CompareTranslationText: string read mCompareTranslationText write mCompareTranslationText;

    property StateEntryStatus[i: TViewTabInfoStateEntries]: Boolean
      read GetStateEntryStatus write SetStateEntry; default;

    procedure SaveBrowserState(const aHtmlViewer: THTMLViewer);
    procedure RestoreBrowserState(const aHtmlViewer: THTMLViewer);

    constructor Create(
      const bible: TBible;
      const location: string;
      const satelliteBibleName: string;
      const title: string;
      const state: TViewTabInfoState);

    procedure Init(
      const bible: TBible;
      const location: string;
      const satelliteBibleName: string;
      const title: string;
      const state: TViewTabInfoState);

    destructor Destroy; override;
  end;

  TViewTabDragObject = class(TDragObjectEx)
  protected
    mViewTabInfo: TViewTabInfo;
  public
    constructor Create(aViewTabInfo: TViewTabInfo);
    property ViewTabInfo: TViewTabInfo read mViewTabInfo;
  end;

implementation

constructor TViewTabBrowserState.Create;
begin
  SelStart := -1;
  SelLenght := -1;
  HScrollPos := -1;
  VScrollPos := -1;
end;

{ TViewTabInfo }

constructor TViewTabInfo.Create(
  const bible: TBible;
  const location: string;
  const satelliteBibleName: string;
  const title: string;
  const state: TViewTabInfoState);
begin
  Init(bible, location, satelliteBibleName, title, state);
end;

destructor TViewTabInfo.Destroy;
begin
  if (mBible <> nil) then
    FreeAndNil(mBible);

  inherited Destroy;
end;

procedure TViewTabInfo.SaveBrowserState(const aHtmlViewer: THTMLViewer);
begin
  mBrowserState.SelStart := aHtmlViewer.SelStart;
  mBrowserState.SelLenght := aHtmlViewer.SelLength;
  mBrowserState.HScrollPos := aHtmlViewer.HScrollBarPosition;
  mBrowserState.VScrollPos := aHtmlViewer.VScrollBarPosition;
end;

procedure TViewTabInfo.RestoreBrowserState(const aHtmlViewer: THTMLViewer);
begin
  if mBrowserState = nil then
    Exit;

  if (mBrowserState.SelStart >= 0) then
  begin
    aHtmlViewer.SelStart := mBrowserState.SelStart;
    aHtmlViewer.SelLength := mBrowserState.SelLenght;
  end;

  if (mBrowserState.HScrollPos >= 0) then
     aHtmlViewer.HScrollBarPosition := mBrowserState.HScrollPos;

  if (mBrowserState.VScrollPos >= 0) then
     aHtmlViewer.VScrollBarPosition := mBrowserState.VScrollPos;
end;

function TViewTabInfo.GetStateEntryStatus(stateEntry: TViewTabInfoStateEntries): Boolean;
begin
  Result := stateEntry in mState;
end;

procedure TViewTabInfo.Init(
  const bible: TBible;
  const location: string;
  const satelliteBibleName: string;
  const title: string;
  const state: TViewTabInfoState);
begin
  mBrowserState := TViewTabBrowserState.Create;
  mBible := bible;
  mLocation := location;
  mSatelliteName := satelliteBibleName;
  mState := state;
  mLocationType := vtlUnspecified;
  mLastVisiblePara := -1;
  mTitle := title;
  mIsCompareTranslation := false;
  mCompareTranslationText := '';
end;

procedure TViewTabInfo.SetStateEntry(stateEntry: TViewTabInfoStateEntries; value: Boolean);
begin
  if value then
    Include(mState, stateEntry)
  else
    Exclude(mState, stateEntry);
end;

{ TViewTabDragObject }

constructor TViewTabDragObject.Create(aViewTabInfo: TViewTabInfo);
begin
  inherited Create();
  mViewTabInfo := aViewTabInfo;
end;

end.

