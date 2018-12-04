unit CommentsFra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TabData, BibleQuoteUtils,
  HTMLEmbedInterfaces, Htmlview, Vcl.Menus, MainFrm, StringProcs,
  MultiLanguage, Bible, IOUtils, BibleQuoteConfig, LinksParser, Clipbrd,
  AppPaths, rkGlassButton, Vcl.StdCtrls, Vcl.ExtCtrls, LinksParserIntf,
  PlainUtils, Engine, System.ImageList, Vcl.ImgList;

(*
  This frame type is not used for now, but may in the future be used to
  display commentaries
*)
type
  TCommentsFrame = class(TFrame)
    pnlComments: TPanel;
    cbComments: TComboBox;
    btnOnlyMeaningful: TrkGlassButton;
    bwrComments: THTMLViewer;
    ilImages: TImageList;
    procedure btnOnlyMeaningfulClick(Sender: TObject);
    procedure cbCommentsChange(Sender: TObject);
    procedure cbCommentsCloseUp(Sender: TObject);
    procedure cbCommentsDropDown(Sender: TObject);
    procedure bwrCommentsHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
  private
    mMainView: TMainForm;
    mTabsView: ITabsView;
    mBqEngine: TBibleQuoteEngine;

    G_XRefVerseCmd: string;

    procedure ShowComments;
    function FilterCommentariesCombo: integer;
    procedure UpdateAllBooks;
  public
    constructor Create(AOwner: TComponent; AMainView: TMainForm; ATabsView: ITabsView); reintroduce;
  end;

implementation

{$R *.dfm}
uses BookFra;

constructor TCommentsFrame.Create(AOwner: TComponent; AMainView: TMainForm; ATabsView: ITabsView);
begin
  inherited Create(AOwner);

  mMainView := AMainView;
  mTabsView := ATabsView;
  mBqEngine := mMainView.BqEngine;

  with bwrComments do
  begin
    DefFontName := MainCfgIni.SayDefault('RefFontName', 'Microsoft Sans Serif');
    DefFontSize := StrToInt(MainCfgIni.SayDefault('RefFontSize', '12'));
    DefFontColor := Hex2Color(MainCfgIni.SayDefault('RefFontColor', Color2Hex(clWindowText)));

    DefBackGround := Hex2Color(MainCfgIni.SayDefault('DefBackground', Color2Hex(clWindow))); // '#EBE8E2'
    DefHotSpotColor := Hex2Color(MainCfgIni.SayDefault('DefHotSpotColor', Color2Hex(clHotLight))); // '#0000FF'
  end;
end;

procedure TCommentsFrame.btnOnlyMeaningfulClick(Sender: TObject);
var
  btn: TrkGlassButton;
begin
  btn := Sender as TrkGlassButton;
  btn.Down := not btn.Down;
  FilterCommentariesCombo();
end;

procedure TCommentsFrame.bwrCommentsHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  cmd, prefBible, ConcreteCmd: string;
  autoCmd: Boolean;
  bible: TBible;
  bookView: TBookFrame;
  status: integer;
begin
  // TODO: get book view
  //bookView := GetBookView(self);

  Handled := true;
  cmd := SRC;
  autoCmd := Pos(C__bqAutoBible, cmd) <> 0;
  if autoCmd then
  begin
    bible := bookView.BookTabInfo.Bible;
    if bible.isBible then
      prefBible := bible.ShortPath
    else
      prefBible := '';
    status := bookView.PreProcessAutoCommand(bookView.BookTabInfo, cmd, prefBible, ConcreteCmd);
    if status <= -2 then
      Exit;
  end;
  if not IsDown(VK_CONTROL) then
  begin
    if autoCmd then
      G_XRefVerseCmd := ConcreteCmd
    else
      G_XRefVerseCmd := SRC;
    // TODO: Open new book view
    //miOpenNewViewClick(Sender);
  end
  else
  begin
    if autoCmd then
      bookView.ProcessCommand(bookView.BookTabInfo, ConcreteCmd, hlDefault)
    else
    begin
      bookView.tedtReference.Text := cmd;

      // TODO: go bible reference
      //GoReference();
    end;
  end;
end;

procedure TCommentsFrame.cbCommentsChange(Sender: TObject);
begin
  ShowComments;
  bwrComments.PositionTo(IntToStr(Self.tag));
end;

procedure TCommentsFrame.cbCommentsCloseUp(Sender: TObject);
begin
  try
    MainForm.FocusControl(bwrComments);
  except
  end;
end;

procedure TCommentsFrame.cbCommentsDropDown(Sender: TObject);
begin
  FilterCommentariesCombo();
end;

procedure TCommentsFrame.ShowComments;
var
  B, C, V, ib, ic, iv, verseIx, commentaryIx, verseCount: integer;
  Lines: string;
  iscomm, resolveLinks, blFailed: Boolean;
  s, aname: string;
  commentaryModule: TModuleEntry;
  bookTabInfo: TBookTabInfo;
  bookView: TBookFrame;

  function FailedToLoadComment(const reason: string): string;
  begin
    Result := Lang.SayDefault('comFailedLoad', 'Failed to display commentary') + '<br>' + Lang.Say(reason);
  end;

label lblSetOutput;
begin
  // TODO: get book view
  //bookView := GetBookView(self);
  bookTabInfo := bookView.BookTabInfo;

  if not Assigned(bookTabInfo) then
    Exit;

  if not bookTabInfo.Bible.isBible then
    Exit;

  if Self.tag = 0 then
    Self.tag := 1;

  Lines := '';
  if Length(Trim(cbComments.Text)) = 0 then
  begin
    if cbComments.Items.Count > 0 then
    begin
      commentaryIx := cbComments.Items.IndexOf(mBqEngine.mLastUsedComment);
      if commentaryIx >= 0 then
        cbComments.ItemIndex := commentaryIx
      else
        cbComments.ItemIndex := 0;
    end
    else
      Exit;
  end;

  commentaryIx := mMainView.mModules.IndexOf(cbComments.Text);
  if commentaryIx < 0 then
  begin
    raise Exception.CreateFmt
      ('Cannot locate module for comments, module name: %s', [cbComments.Text])
  end;
  commentaryModule := mMainView.mModules[commentaryIx];
  bookTabInfo.SecondBible.inifile := commentaryModule.getIniPath();

  bookTabInfo.Bible.ReferenceToInternal(bookTabInfo.Bible.CurBook, bookTabInfo.Bible.CurChapter, 1, ib, ic, iv);
  blFailed := not bookTabInfo.SecondBible.InternalToReference(ib, ic, iv, B, C, V);
  if blFailed then
  begin
    Lines := FailedToLoadComment('Cannot find matching comment');
    goto lblSetOutput;
  end;

  iscomm := commentaryModule.modType = modtypeComment;

  // if it's a commentary or it has chapter zero (introduction to book)
  // and it's chapter 1, show chapter 0, too :-)
  resolveLinks := false;
  if Assigned(bookTabInfo) then
  begin
    resolveLinks := bookTabInfo[vtisResolveLinks];
    if resolveLinks then
      bookTabInfo.SecondBible.FuzzyResolve := bookTabInfo[vtisFuzzyResolveLinks];
  end;

  if bookTabInfo.SecondBible.Trait[bqmtZeroChapter] and (C = 2) then
  begin
    blFailed := true;
    try
      blFailed := not bookTabInfo.SecondBible.OpenChapter(B, 1, resolveLinks);
    except
      on E: TBQPasswordException do
      begin
        mMainView.PasswordPolicy.InvalidatePassword(E.mArchive);
        MessageBoxW(self.Handle, PWideChar(Pointer(E.mMessage)), nil, MB_ICONERROR or MB_OK);
      end
    end;
    if not blFailed then
    begin

      verseCount := bookTabInfo.SecondBible.verseCount - 1;
      for verseIx := 0 to verseCount do
      begin
        s := bookTabInfo.SecondBible.Verses[verseIx];

        if not iscomm then
        begin
          StrDeleteFirstNumber(s);
          if bookTabInfo.SecondBible.Trait[bqmtStrongs] then
            s := DeleteStrongNumbers(s);

          AddLine(
            Lines, Format('<a name=%d>%d <font face="%s">%s</font><br>',
            [verseIx + 1, verseIx + 1, bookTabInfo.SecondBible.fontName, s])
          );

        end // if not commentary
        else
        begin // if it's commentary
          aname := StrGetFirstNumber(s);
          AddLine(Lines, Format('<a name=%s><font face="%s">%s</font><br>', [aname, bookTabInfo.SecondBible.fontName, s]));
        end;
      end;
    end;

    AddLine(Lines, '<hr>');
  end;
  blFailed := true;
  try
    blFailed := not bookTabInfo.SecondBible.OpenChapter(B, C, resolveLinks);
  except
    on E: TBQPasswordException do
    begin
      mMainView.PasswordPolicy.InvalidatePassword(E.mArchive);
      MessageBoxW(self.Handle, PWideChar(Pointer(E.mMessage)), nil, MB_ICONERROR or MB_OK);
    end
  end;
  if blFailed then
  begin
    Lines := FailedToLoadComment('Failed to open chapter');
    goto lblSetOutput;
  end;

  verseCount := bookTabInfo.SecondBible.verseCount() - 1;
  for verseIx := 0 to verseCount do
  begin
    s := bookTabInfo.SecondBible.Verses[verseIx];
    if not iscomm then
    begin
      StrDeleteFirstNumber(s);
      if bookTabInfo.SecondBible.Trait[bqmtStrongs] then
        s := DeleteStrongNumbers(s);

      AddLine(Lines, Format('<a name=%d>%d <font face="%s">%s</font><br>',
        [verseIx + 1, verseIx + 1, bookTabInfo.SecondBible.fontName, s]));

    end
    else
    begin
      aname := StrGetFirstNumber(s);
      AddLine(Lines, Format('<a name=%s><font face="%s">%s</font><br>', [aname, bookTabInfo.SecondBible.fontName, s]));
    end;
  end;
  AddLine(Lines,
    '<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>');

  bwrComments.Base := bookTabInfo.SecondBible.path;
  mBqEngine.mLastUsedComment := bookTabInfo.SecondBible.Name;

lblSetOutput:
  bwrComments.LoadFromString(Lines);

  for verseIx := 1 to Self.tag do
    bwrComments.PositionTo(IntToStr(verseIx)); // ??

end;

function TCommentsFrame.FilterCommentariesCombo: integer;
var
  vti: TBookTabInfo;
  bl: TBibleLinkEx;
  ibl: TBibleLink;
  getAddress, doFilter: Boolean;
  linkValidStatus, addIndex, selIndex: integer;
  commentaryModule: TModuleEntry;
  lastCmt: WideString;
begin
  Result := -1;
  doFilter := btnOnlyMeaningful.Down;

  // TODO: get book tab info
  //vti := GetBookView(self).BookTabInfo;
  if (vti = nil) then
    Exit;
  getAddress := bl.FromBqStringLocation(vti.Location);
  if getAddress then
  begin
    linkValidStatus := vti.Bible.ReferenceToInternal(bl, ibl);
    if linkValidStatus = -2 then
      getAddress := false;
  end;

  commentaryModule := mMainView.mModules.ModTypedAsFirst(modtypeComment);
  lastCmt := cbComments.Text;

  cbComments.Items.BeginUpdate;
  cbComments.Items.Clear();
  try
    selIndex := -1;
    while Assigned(commentaryModule) do
    begin
      try
        vti.SecondBible.inifile := commentaryModule.getIniPath();
        linkValidStatus := vti.SecondBible.LinkValidnessStatus(vti.SecondBible.inifile, ibl, true, false);
        if (linkValidStatus > -2) or (not getAddress) or (not doFilter) then
        begin
          addIndex := cbComments.Items.Add(commentaryModule.mFullName);
          if OmegaCompareTxt(commentaryModule.mFullName, lastCmt, -1, true) = 0
          then
            selIndex := addIndex;

        end;
        commentaryModule := mMainView.mModules.ModTypedAsNext(modtypeComment);
      except
      end;
    end; // while
  finally
    cbComments.Items.EndUpdate();
  end;
  if selIndex >= 0 then
    cbComments.ItemIndex := selIndex;
end;

procedure TCommentsFrame.UpdateAllBooks;
var
  moduleEntry: TModuleEntry;
begin
  cbComments.Items.BeginUpdate;
  try
    cbComments.Items.Clear;
    moduleEntry := mMainView.mModules.ModTypedAsFirst(modtypeComment);
    while Assigned(moduleEntry) do
    begin
      cbComments.Items.Add(moduleEntry.mFullName);
      moduleEntry := mMainView.mModules.ModTypedAsNext(modtypeComment);
    end;

  finally
    cbComments.Items.EndUpdate;
  end;

  cbComments.ItemIndex := 0;
end;

end.
