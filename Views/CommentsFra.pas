unit CommentsFra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TabData, BibleQuoteUtils,
  HTMLEmbedInterfaces, Htmlview, Vcl.Menus, MainFrm, StringProcs,
  Bible, BibleQuoteConfig, LinksParserIntf, PlainUtils, Engine,
  System.ImageList, Vcl.ImgList, AppIni,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, JclNotify, NotifyMessages;

type
  TCommentsFrame = class(TFrame, ICommentsView, IJclListener)
    pnlComments: TPanel;
    cbCommentSource: TComboBox;
    bwrComments: THTMLViewer;
    sbtnMeaningfulOnly: TSpeedButton;
    procedure sbtnMeaningfulOnlyClick(Sender: TObject);
    procedure cbCommentSourceChange(Sender: TObject);
    procedure cbCommentSourceCloseUp(Sender: TObject);
    procedure cbCommentSourceDropDown(Sender: TObject);
    procedure bwrCommentsHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
  private
    FMainView: TMainForm;
    FWorkspace: IWorkspace;
    FBqEngine: TBibleQuoteEngine;
    FNotifier: IJclNotifier;
    FSourceBook: TBible;
    FLastCommentaryBook: String;

    procedure ShowComments();
    function FilterCommentSources(): integer;
    procedure DisplayAllSources;
    procedure Notification(Msg: IJclNotificationMessage); stdcall;
  public
    procedure Translate();
    procedure ApplyConfig(AppConfig: TAppConfig);
    procedure SetSourceBook(SourceBook: TBible);
    property SourceBook: TBible read FSourceBook write SetSourceBook;
    procedure EventFrameKeyDown(var Key: Char);

    constructor Create(Owner: TComponent; MainView: TMainForm; Workspace: IWorkspace); reintroduce;
  end;

implementation

{$R *.dfm}
uses BookFra;

constructor TCommentsFrame.Create(Owner: TComponent; MainView: TMainForm; Workspace: IWorkspace);
begin
  inherited Create(Owner);

  FMainView  := MainView;
  FWorkspace := Workspace;
  FBqEngine  := MainView.BqEngine;
  FNotifier  := MainView.mNotifier;

  FNotifier.Add(self);

  ApplyConfig(AppConfig);
end;

procedure TCommentsFrame.Translate();
begin
  Lang.TranslateControl(Self, 'MainForm');
  Lang.TranslateControl(Self, 'DockTabsForm');
end;

procedure TCommentsFrame.ApplyConfig(AppConfig: TAppConfig);
begin
  with bwrComments do
  begin
    DefFontName  := AppConfig.RefFontName;
    DefFontSize  := AppConfig.RefFontSize;
    DefFontColor := AppConfig.RefFontColor;

    DefBackGround   := AppConfig.BackgroundColor;
    DefHotSpotColor := AppConfig.HotSpotColor;
  end;

  if (appConfig.MainFormFontName <> Font.Name) then
    Font.Name := appConfig.MainFormFontName;

  if (appConfig.MainFormFontSize <> Font.Size) then
    Font.Size := appConfig.MainFormFontSize;
end;

procedure TCommentsFrame.sbtnMeaningfulOnlyClick(Sender: TObject);
begin
  FilterCommentSources();
end;

procedure TCommentsFrame.bwrCommentsHotSpotClick(Sender: TObject; const SRC: string; var Handled: Boolean);
var
  Command, PrefBible, ConcreteCmd: string;
  AutoCmd: Boolean;
  Status: integer;
  BookView: TBookFrame;
begin
  if not Assigned(FSourceBook) then
    Exit;

  Handled := true;
  Command := SRC;
  AutoCmd := Pos(C__bqAutoBible, Command) <> 0;

  BookView := TBookFrame(FWorkspace.BookView);
  if AutoCmd then
  begin
    if FSourceBook.isBible then
      PrefBible := FSourceBook.ShortPath
    else
      PrefBible := '';

    Status := BookView.PreProcessAutoCommand(FSourceBook, Command, PrefBible, ConcreteCmd);
    if Status <= -2 then
      Exit;

    Command := ConcreteCmd;
  end;

  FMainView.OpenOrCreateBookTab(Command, '', FMainView.DefaultBookTabState);
end;

procedure TCommentsFrame.cbCommentSourceChange(Sender: TObject);
begin
  ShowComments();
end;

procedure TCommentsFrame.cbCommentSourceCloseUp(Sender: TObject);
begin
  try
    MainForm.FocusControl(bwrComments);
  except
  end;
end;

procedure TCommentsFrame.cbCommentSourceDropDown(Sender: TObject);
begin
  FilterCommentSources();
end;

procedure TCommentsFrame.ShowComments();
var
  B, C, V: Integer;
  IntBook, IntChapter, IntVerse: Integer;
  VerseIdx, CommentaryIdx, VerseCount: integer;
  Lines: string;
  IsComm, IsSuccess: Boolean;
  S, Aname: string;
  CommentaryModule: TModuleEntry;
  CommentaryBook: TBible;

  function FailedToLoadComment(const Key: string; const DefReason: string): string;
  begin
    Result :=
      Lang.SayDefault('commentsLoadFail', 'Failed to display commentary')
      + '<br>'
      + Lang.SayDefault(Key, DefReason);
  end;

label lblSetOutput;
begin
  if not Assigned(FSourceBook) then
    Exit;

  if not FSourceBook.isBible then
    Exit;

  Lines := '';
  if Length(Trim(cbCommentSource.Text)) = 0 then
  begin
    if cbCommentSource.Items.Count > 0 then
    begin
      CommentaryIdx := cbCommentSource.Items.IndexOf(FLastCommentaryBook);
      if CommentaryIdx >= 0 then
        cbCommentSource.ItemIndex := CommentaryIdx
      else
        cbCommentSource.ItemIndex := 0;
    end
    else
      Exit;
  end;

  CommentaryIdx := FMainView.mModules.IndexOf(cbCommentSource.Text);
  if CommentaryIdx < 0 then
  begin
    raise Exception.CreateFmt
      ('Cannot locate module for comments, module name: %s', [cbCommentSource.Text])
  end;

  CommentaryModule := FMainView.mModules[CommentaryIdx];
  CommentaryBook := TBible.Create(FMainView);
  CommentaryBook.SetInfoSource(CommentaryModule.getIniPath());

  FSourceBook.ReferenceToInternal(FSourceBook.CurBook, FSourceBook.CurChapter, 1, IntBook, IntChapter, IntVerse);
  IsSuccess := CommentaryBook.InternalToReference(IntBook, IntChapter, IntVerse, B, C, V);
  if not IsSuccess then
  begin
    Lines := FailedToLoadComment('commentsCantFind', 'Cannot find matching comment');
    goto lblSetOutput;
  end;

  IsComm := CommentaryModule.modType = modtypeComment;

  CommentaryBook.RecognizeBibleLinks := true;
  CommentaryBook.FuzzyResolve := true;

  // if it's a commentary or it has chapter zero (introduction to book)
  // and it's chapter 1, show chapter 0, too :-)
  if CommentaryBook.Trait[bqmtZeroChapter] and (C = 2) then
  begin
    IsSuccess := false;
    try
      IsSuccess := CommentaryBook.OpenChapter(B, 1, true);
    except
      on E: TBQPasswordException do
      begin
        FMainView.PasswordPolicy.InvalidatePassword(E.mArchive);
        MessageBoxW(self.Handle, PWideChar(Pointer(E.mMessage)), nil, MB_ICONERROR or MB_OK);
      end
    end;

    if IsSuccess then
    begin
      VerseCount := CommentaryBook.verseCount - 1;
      for VerseIdx := 0 to VerseCount do
      begin
        S := CommentaryBook.Verses[VerseIdx];

        if not IsComm then
        begin
          StrDeleteFirstNumber(S);
          if CommentaryBook.Trait[bqmtStrongs] then
            S := DeleteStrongNumbers(S);

          AddLine(
            Lines, Format('<a name=%d>%d <font face="%s">%s</font><br>',
            [VerseIdx + 1, VerseIdx + 1, CommentaryBook.FontName, S])
          );

        end // if not commentary
        else
        begin // if it's commentary
          Aname := StrGetFirstNumber(S);
          AddLine(Lines, Format('<a name=%s><font face="%s">%s</font><br>', [Aname, CommentaryBook.FontName, S]));
        end;
      end;
    end;

    AddLine(Lines, '<hr>');
  end;

  IsSuccess := false;
  try
    IsSuccess := CommentaryBook.OpenChapter(B, C, true);
  except
    on E: TBQPasswordException do
    begin
      FMainView.PasswordPolicy.InvalidatePassword(E.mArchive);
      MessageBoxW(self.Handle, PWideChar(Pointer(E.mMessage)), nil, MB_ICONERROR or MB_OK);
    end
  end;

  if not IsSuccess then
  begin
    Lines := FailedToLoadComment('commentsOpenChapterFail', 'Failed to open chapter');
    goto lblSetOutput;
  end;

  VerseCount := CommentaryBook.verseCount() - 1;
  for VerseIdx := 0 to VerseCount do
  begin
    S := CommentaryBook.Verses[VerseIdx];
    if not IsComm then
    begin
      StrDeleteFirstNumber(S);
      if CommentaryBook.Trait[bqmtStrongs] then
        S := DeleteStrongNumbers(S);

      AddLine(Lines, Format('<a name=%d>%d <font face="%s">%s</font><br>',
        [VerseIdx + 1, VerseIdx + 1, CommentaryBook.FontName, S]));

    end
    else
    begin
      Aname := StrGetFirstNumber(S);
      AddLine(Lines, Format('<a name=%s><font face="%s">%s</font><br>', [Aname, CommentaryBook.fontName, S]));
    end;
  end;

  AddLine(Lines, RepeatString('<br>', 24));

  bwrComments.Base := CommentaryBook.Path;
  FLastCommentaryBook := CommentaryBook.Name;

lblSetOutput:
  bwrComments.LoadFromString(Lines);
end;

function TCommentsFrame.FilterCommentSources(): integer;
var
  BibleLink: TBibleLinkEx;
  InternalBibleLink: TBibleLink;
  Address, doFilter: Boolean;
  LinkStatus, AddIndex, SelIndex: integer;
  CommentaryModule: TModuleEntry;
  RefBook: TBible;
  LastCommentary: string;
begin
  Result := -1;
  doFilter := sbtnMeaningfulOnly.Down;

  if (FSourceBook = nil) then
    Exit;

  Address := true;

  BibleLink.Build(FSourceBook.CurBook, FSourceBook.CurChapter, 0, 0);
  LinkStatus := FSourceBook.ReferenceToInternal(BibleLink, InternalBibleLink);
  if LinkStatus = -2 then
    Address := false;

  CommentaryModule := FMainView.mModules.ModTypedAsFirst(modtypeComment);
  LastCommentary := cbCommentSource.Text;

  cbCommentSource.Items.BeginUpdate;
  cbCommentSource.Items.Clear();
  try
    SelIndex := -1;
    while Assigned(CommentaryModule) do
    begin
      try
        RefBook := TBible.Create(FMainView);
        RefBook.SetInfoSource(CommentaryModule.getIniPath());

        LinkStatus := RefBook.LinkValidnessStatus(RefBook.InfoSource.FileName, InternalBibleLink, true, false);
        if (LinkStatus > -2) or (not Address) or (not doFilter) then
        begin
          AddIndex := cbCommentSource.Items.Add(CommentaryModule.FullName);

          if OmegaCompareTxt(CommentaryModule.FullName, LastCommentary, -1, true) = 0 then
            SelIndex := AddIndex;
        end;
        CommentaryModule := FMainView.mModules.ModTypedAsNext(modtypeComment);
      except
      end;
    end; // while
  finally
    cbCommentSource.Items.EndUpdate();
  end;

  if SelIndex >= 0 then
    cbCommentSource.ItemIndex := SelIndex;
end;

procedure TCommentsFrame.DisplayAllSources;
var
  ModuleEntry: TModuleEntry;
begin
  cbCommentSource.Items.BeginUpdate;
  try
    cbCommentSource.Items.Clear;
    ModuleEntry := FMainView.mModules.ModTypedAsFirst(modtypeComment);

    while Assigned(ModuleEntry) do
    begin
      cbCommentSource.Items.Add(ModuleEntry.FullName);
      ModuleEntry := FMainView.mModules.ModTypedAsNext(modtypeComment);
    end;
  finally
    cbCommentSource.Items.EndUpdate;
  end;

  if (cbCommentSource.Items.Count > 0) then
    cbCommentSource.ItemIndex := 0;
end;

procedure TCommentsFrame.EventFrameKeyDown(var Key: Char);
begin

end;

procedure TCommentsFrame.Notification(Msg: IJclNotificationMessage);
var
  MsgModulesLoaded: IModulesLoadedMessage;
begin
  if Supports(Msg, IModulesLoadedMessage, MsgModulesLoaded) then
  begin
    if (cbCommentSource.Items.Count = 0) then
      DisplayAllSources;
  end;
end;

procedure TCommentsFrame.SetSourceBook(SourceBook: TBible);
begin
  FSourceBook := SourceBook;
  ShowComments();
end;

end.
