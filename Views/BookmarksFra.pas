unit BookmarksFra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.UITypes, BibleQuoteUtils,
  TabData, Vcl.StdCtrls, Vcl.ExtCtrls, BroadcastList, StringProcs, BookFra,
  MainFrm;

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
    mTabsView: ITabsView;
    mMainView: TMainForm;

    procedure OnBookmarksChange(Sender: TObject);
    procedure RefreshBookmarks();
  public
    procedure Translate();
    constructor Create(AOwner: TComponent; AMainView: TMainForm; ATabsView: ITabsView; ABookmarks: TBroadcastStringList); reintroduce;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}
constructor TBookmarksFrame.Create(AOwner: TComponent; AMainView: TMainForm; ATabsView: ITabsView; ABookmarks: TBroadcastStringList);
begin
  inherited Create(AOwner);

  mMainView := AMainView;
  mTabsView := ATabsView;

  mBookmarks := ABookmarks;
  RefreshBookmarks();
  mBookmarks.AddOnChange(OnBookmarksChange);
end;

destructor TBookmarksFrame.Destroy;
begin
  mBookmarks.RemoveOnChange(OnBookmarksChange);

  inherited;
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

  bookFrame := mTabsView.BookView as TBookFrame;
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

end.
