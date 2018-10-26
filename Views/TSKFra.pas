unit TSKFra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TabData, BibleQuoteUtils,
  HTMLEmbedInterfaces, Htmlview, Vcl.Menus, MainFrm, StringProcs,
  MultiLanguage, Bible, IOUtils, BibleQuoteConfig, LinksParser, Clipbrd;

type
  TTSKFrame = class(TFrame, ITSKView)
    bwrXRef: THTMLViewer;
    pmRef: TPopupMenu;
    miRefCopy: TMenuItem;
    miOpenNewView: TMenuItem;
    miRefPrint: TMenuItem;
    procedure bwrXRefHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
    procedure miRefCopyClick(Sender: TObject);
    procedure miOpenNewViewClick(Sender: TObject);
    procedure miRefPrintClick(Sender: TObject);
    procedure pmRefPopup(Sender: TObject);
  private
    mMainView: TMainForm;
    mTabsView: ITabsView;

    mXRefVerseCmd: string;
  public
    constructor Create(AOwner: TComponent; AMainView: TMainForm; ATabsView: ITabsView); reintroduce;
    procedure Translate();
    procedure ShowXref(bookTabInfo: TBookTabInfo; goverse: integer = 0);
  end;

implementation

{$R *.dfm}
constructor TTSKFrame.Create(AOwner: TComponent; AMainView: TMainForm; ATabsView: ITabsView);
begin
  inherited Create(AOwner);

  mMainView := AMainView;
  mTabsView := ATabsView;


  with bwrXRef do
  begin
    DefFontName := MainCfgIni.SayDefault('RefFontName', 'Microsoft Sans Serif');
    DefFontSize := StrToInt(MainCfgIni.SayDefault('RefFontSize', '12'));
    DefFontColor := Hex2Color(MainCfgIni.SayDefault('RefFontColor', Color2Hex(clWindowText)));

    DefBackGround := Hex2Color(MainCfgIni.SayDefault('DefBackground', Color2Hex(clWindow))); // '#EBE8E2'
    DefHotSpotColor := Hex2Color(MainCfgIni.SayDefault('DefHotSpotColor', Color2Hex(clHotLight))); // '#0000FF'

    // this browser doesn't have underlines...
    htOptions := htOptions + [htNoLinkUnderline];
  end;
end;

procedure TTSKFrame.bwrXRefHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
begin
  if IsDown(VK_MENU) then
    mMainView.NewBookTab(SRC, '------', mMainView.DefaultBookTabState, '', true)
  else
    mMainView.OpenOrCreateBookTab(SRC, '------', mMainView.DefaultBookTabState);

  Handled := true;
end;

procedure TTSKFrame.miOpenNewViewClick(Sender: TObject);
var
  command: string;
begin
  command := Trim(mXRefVerseCmd);
  if Length(command) <= 0 then
    Exit;

  mMainView.NewBookTab(command, '------', mMainView.DefaultBookTabState, '', true);
end;

procedure TTSKFrame.miRefCopyClick(Sender: TObject);
var
  trCount: integer;
begin
  trCount := 7;
  repeat
    try
      if not(mMainView.CopyOptionsCopyFontParamsChecked xor IsDown(VK_SHIFT)) then
        Clipboard.AsText := (pmRef.PopupComponent as THTMLViewer).SelText
      else
        (pmRef.PopupComponent as THTMLViewer).CopyToClipboard();
      trCount := 0;
    except
      Dec(trCount);
      sleep(100);
    end;
  until trCount <= 0;
end;

procedure TTSKFrame.miRefPrintClick(Sender: TObject);
begin
  with mMainView.PrintDialog do
    if Execute then
      (pmRef.PopupComponent as THTMLViewer).Print(MinPage, MaxPage)
end;

procedure TTSKFrame.pmRefPopup(Sender: TObject);
begin
  miOpenNewView.Visible := true;
  mXRefVerseCmd := Get_AHREF_VerseCommand(
    bwrXRef.DocumentSource,
    bwrXRef.SectionList.FindSourcePos(bwrXRef.RightMouseClickPos));
end;

procedure TTSKFrame.ShowXref(bookTabInfo: TBookTabInfo; goverse: integer = 0);
var
  ti: TMultiLanguage;
  tf: TSearchRec;
  s, snew, passageSig: string;
  verse, tmpverse, book, chapter, fromverse, toverse,
  i, j: integer;
  RefLines: string;
  RefText: string;
  Links: TStrings;
  slink: string;
  diff: integer;
  path: string;
  mainBible, secBible: TBible;
begin
  if not Assigned(bookTabInfo) then
    Exit;

  mainBible := bookTabInfo.Bible;
  secBible := bookTabInfo.SecondBible;

  if mMainView.mModules.IndexOf(mainBible.Name) = -1 then
    Exit;

  if goverse = 0 then
    goverse := 1;

  RefLines := '';
  Links := TStringList.Create;

  secBible.inifile := mainBible.inifile;

  mainBible.ReferenceToEnglish(mainBible.CurBook, mainBible.CurChapter, goverse, book, chapter, verse);
  s := IntToStr(book);

  if Length(s) = 1 then
    s := '0' + s;

  path := TPath.Combine(LibraryDirectory, C_TSKSubDirectory);
  path := TPath.Combine(path, s + '_*.ini');

  if FindFirst(path, faAnyFile, tf) <> 0 then
    Exit;

  ti := TMultiLanguage.Create(nil);

  path := TPath.Combine(LibraryDirectory, C_TSKSubDirectory);
  ti.inifile := TPath.Combine(path, tf.Name);

  secBible.OpenChapter(mainBible.CurBook, mainBible.CurChapter);

  tmpverse := goverse;

  if tmpverse > secBible.verseCount() then
    tmpverse := secBible.verseCount();
  s := secBible[tmpverse - 1];
  StrDeleteFirstNumber(s);
  s := DeleteStrongNumbers(s);

  RefText := Format
    ('<a name=%d><a href="go %s %d %d %d"><font face=%s>%s%d:%d</font></a><br><font face="%s">%s</font><p>',
    [tmpverse, mainBible.ShortPath, mainBible.CurBook, mainBible.CurChapter,
    tmpverse, mMainView.mBrowserDefaultFontName, mainBible.ShortNames[mainBible.CurBook],
    mainBible.CurChapter, tmpverse, mainBible.fontName, s]);

  slink := ti.ReadString(IntToStr(chapter), IntToStr(verse), '');
  if slink = '' then
    AddLine(RefLines, RefText + '<b>.............</b>')
  else
  begin
    StrToLinks(slink, Links);

    // get xrefs
    for i := 0 to Links.Count - 1 do
    begin
      if not secBible.OpenTSKReference(Links[i], book, chapter, fromverse, toverse) then
        continue;

      diff := toverse - fromverse;
      secBible.ENG2RUS(book, chapter, fromverse, book, chapter, fromverse);

      if not secBible.InternalToReference(book, chapter, fromverse, book, chapter, fromverse) then
        continue; // if this module doesn't have the link...

      toverse := fromverse + diff;

      if fromverse = 0 then
        fromverse := 1;
      if toverse < fromverse then
        toverse := fromverse; // if one verse

      try
        secBible.OpenChapter(book, chapter);
      except
        continue;
      end;

      if fromverse > secBible.verseCount() then
        continue;
      if toverse > secBible.verseCount then
        toverse := secBible.verseCount;

      s := '';
      for j := fromverse to toverse do
      begin
        snew := secBible.Verses[j - 1];
        s := s + ' ' + StrDeleteFirstNumber(snew);
        snew := DeleteStrongNumbers(snew);
        s := s + ' ' + snew;
      end;
      s := Trim(s);

      StrDeleteFirstNumber(s);
      passageSig := Format('<font face="%s">%s</font>',
        [mMainView.mBrowserDefaultFontName, secBible.ShortPassageSignature(book, chapter, fromverse, toverse)]);
      if toverse = fromverse then
        RefText := RefText +
          Format
          ('<a href="go %s %d %d %d %d">%s</a> <font face="%s">%s</font><br>',
          [mainBible.ShortPath, book, chapter, fromverse, 0, passageSig, mainBible.fontName, s])
      else
        RefText := RefText +
          Format
          ('<a href="go %s %d %d %d %d">%s</a> <font face="%s">%s</font><br>',
          [mainBible.ShortPath, book, chapter, fromverse, toverse, passageSig, mainBible.fontName, s]);
    end;

    AddLine(RefLines, RefText);
  end;

  AddLine(RefLines, '</font><br><br>');

  bwrXRef.DefFontName := mTabsView.Browser.DefFontName;
  bwrXRef.LoadFromString(RefLines);

  Links.Free;
end;

procedure TTSKFrame.Translate();
begin
  Lang.TranslateControl(self, 'MainForm');
  Lang.TranslateControl(self, 'DockTabsForm');
end;

end.
