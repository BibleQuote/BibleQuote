unit BookmarksFra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.UITypes, BibleQuoteUtils,
  TabData, Vcl.StdCtrls, Vcl.ExtCtrls, BroadcastList, StringProcs, BookFra,
  MainFrm, AppIni;

type
  TBookmarksFrame = class(TFrame, IBookmarksView)
    lbBookmarks: TListBox;
    pnlBookmarks: TPanel;
    lblBookmark: TLabel;
    procedure lbBookmarksClick(Sender: TObject);
    procedure lbBookmarksKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbBookmarksDblClick(Sender: TObject);
  private
    { Private declarations }
    mBookmarks: TBroadcastStringList;
    mWorkspace: IWorkspace;
    mMainView: TMainForm;

    procedure OnBookmarksChange(Sender: TObject);
    procedure RefreshBookmarks();
  public
    procedure Translate();
    procedure ApplyConfig(appConfig, oldConfig: TAppConfig);
    procedure EventFrameKeyDown(var Key: Char);
    constructor Create(AOwner: TComponent; AMainView: TMainForm; AWorkspace: IWorkspace; ABookmarks: TBroadcastStringList); reintroduce;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}
constructor TBookmarksFrame.Create(AOwner: TComponent; AMainView: TMainForm; AWorkspace: IWorkspace; ABookmarks: TBroadcastStringList);
begin
  inherited Create(AOwner);

  mMainView := AMainView;
  mWorkspace := AWorkspace;

  mBookmarks := ABookmarks;
  RefreshBookmarks();
  mBookmarks.AddOnChange(OnBookmarksChange);
end;

destructor TBookmarksFrame.Destroy;
begin

  inherited;
end;

procedure TBookmarksFrame.EventFrameKeyDown(var Key: Char);
begin

end;

procedure TBookmarksFrame.OnBookmarksChange(Sender: TObject);
begin
  RefreshBookmarks();
end;

procedure TBookmarksFrame.RefreshBookmarks();
var
  i: integer;
begin
  lbBookmarks.Items.BeginUpdate;
  lbBookmarks.Clear;
  for i := 0 to mBookmarks.Count - 1 do
    lbBookmarks.Items.Add(Comment(mBookmarks[i]));
  lbBookmarks.Items.EndUpdate;

  lblBookmark.Caption := '';
  if mBookmarks.Count > 0 then
    lblBookmark.Caption := Comment(mBookmarks[0]);
end;

procedure TBookmarksFrame.lbBookmarksClick(Sender: TObject);
begin
  lblBookmark.Caption := Comment(mBookmarks[lbBookmarks.ItemIndex]);
end;

procedure TBookmarksFrame.lbBookmarksDblClick(Sender: TObject);
var
  bookFrame: TBookFrame;
  bookmark: string;
  bookTabInfo: TBookTabInfo;
begin
  bookmark := mBookmarks[lbBookmarks.ItemIndex];

  bookFrame := mWorkspace.BookView as TBookFrame;
  bookTabInfo := bookFrame.BookTabInfo;
  if not Assigned(bookTabInfo) then
  begin
    bookTabInfo := mMainView.CreateNewBookTabInfo();
  end;

  if (bookTabInfo <> nil) then
  begin
    mMainView.OpenOrCreateBookTab(bookmark, bookTabInfo.SatelliteName, bookTabInfo.State);
  end;
end;

procedure TBookmarksFrame.lbBookmarksKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  prompt, title: string;
begin
  if lbBookmarks.Items.Count = 0 then
    Exit;

  if Key = VK_DELETE then
  begin
    prompt := Lang.SayDefault('DeleteBookmarkTextPrompt', 'Удалить закладку?');
    title := Lang.SayDefault('DeleteBookmarkTitle', 'Подтвердите удаление');
    if Application.MessageBox(PWideChar(prompt), PWideChar(title), MB_YESNO + MB_DEFBUTTON1) <> ID_YES then
      Exit;

    mBookmarks.Delete(lbBookmarks.ItemIndex);
  end;
end;

procedure TBookmarksFrame.Translate();
begin
  Lang.TranslateControl(self, 'DockTabsForm');
end;

procedure TBookmarksFrame.ApplyConfig(appConfig, oldConfig: TAppConfig);
begin
  if (appConfig.MainFormFontName <> Font.Name) then
    Font.Name := appConfig.MainFormFontName;

  if (appConfig.MainFormFontSize <> Font.Size) then
    Font.Size := appConfig.MainFormFontSize;
end;

end.
