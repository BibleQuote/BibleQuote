unit AppStates;

interface

uses
  Classes, SysUtils, BroadcastList, IOUtils, AppPaths, ExceptionFrm;

type
  TAppState = class
  private
    FMemosOn: Boolean;

    FMemos: TStringList;
    FBookmarks: TBroadcastStringList;

    procedure LoadMemos;
    procedure LoadBookmarks;
    procedure SaveMemos;
    procedure SaveBookmarks;
  public
    constructor Create();
    destructor Destroy; override;

    property MemosOn: Boolean read FMemosOn write FMemosOn;
    property Memos: TStringList read FMemos write FMemos;
    property Bookmarks: TBroadcastStringList read FBookmarks write FBookmarks;

    procedure Load();
    procedure Save();
  end;

var
  AppState: TAppState;

implementation

constructor TAppState.Create();
begin
  inherited Create();

  FMemosOn := False;

  FMemos := TStringList.Create;
  FMemos.Sorted := true;

  FBookmarks := TBroadcastStringList.Create;
end;

destructor TAppState.Destroy;
begin
  FreeAndNil(FMemos);
  FreeAndNil(FBookmarks);

  inherited;
end;

procedure TAppState.Load();
begin
  LoadBookmarks();
  LoadMemos();
end;

procedure TAppState.Save();
begin
  SaveBookmarks();
  SaveMemos();
end;

procedure TAppState.SaveBookmarks();
var
  fname: String;
begin
  try
    fname := TPath.Combine(TAppDirectories.UserSettings, 'bibleqt_bookmarks.ini');
    if (not FileExists(fname)) or (FileGetAttr(fname) and faReadOnly <> faReadOnly) then
      Bookmarks.SaveToFile(fname, TEncoding.UTF8);
  except
    on E: Exception do
      BqShowException(E)
  end;
end;

procedure TAppState.SaveMemos();
var
  fname: String;
begin
  try
    fname := TPath.Combine(TAppDirectories.UserSettings, 'UserMemos.mls');
    if (not FileExists(fname)) or (FileGetAttr(fname) and faReadOnly <> faReadOnly) then
      Memos.SaveToFile(fname, TEncoding.UTF8);
  except
    on E: Exception do
      BqShowException(E)
  end;
end;

procedure TAppState.LoadBookmarks;
var
  fname: String;
begin
  try
    fname := TPath.Combine(TAppDirectories.UserSettings, 'bibleqt_bookmarks.ini');
    if FileExists(fname) then
      Bookmarks.LoadFromFile(fname);
  except
    on E: Exception do
      BqShowException(E)
  end;
end;

procedure TAppState.LoadMemos;
var
  oldPath, newpath: string;
  sl: TStringList;
  i, C: integer;
  s: string;
begin
  try
    newpath := TPath.Combine(TAppDirectories.UserSettings, 'UserMemos.mls');
    if FileExists(newpath) then
    begin
      Memos.LoadFromFile(newpath);
      Exit;
    end;
    oldPath := TPath.Combine(TAppDirectories.UserSettings, 'bibleqt_memos.ini');
    if not FileExists(oldPath) then
      Exit;
    sl := nil;
    try
      sl := TStringList.Create();
      sl.LoadFromFile(oldPath);
      C := sl.Count - 1;
      Memos.Clear();
      for i := 0 to C do
      begin
        s := sl[i];
        if Length(s) > 2 then
          Memos.Add(s);
      end; // for
    except
      on E: Exception do
        BqShowException(E)
    end;
    sl.Free();
  except
    on E: Exception do
      BqShowException(E)
  end;
end;

initialization
begin
  AppState := TAppState.Create;
end;

finalization
begin
  FreeAndNil(AppState);
end;

end.
