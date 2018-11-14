unit NotifyMessages;

interface

uses JclNotify;

type

  IVerseAddedMessage = interface
    ['{24C95F1D-4B9A-4C59-B91C-9EC895AB385A}']
    function GetVerseId: int64;
    function GetTagId: int64;
    function GetCommand: string;
    function DoShow: boolean;
  end;

  IVerseDeletedMessage = interface
    ['{0CD95A05-7CEE-4E0A-AE0B-388DD2E8F42A}']
    function GetVerseId: int64;
    function GetTagId: int64;
  end;

  ITagAddedMessage = interface
    ['{6CDEDE4F-2A97-43FF-9A7B-4238455F7262}']
    function GetTagId: int64;
    function GetText: string;
    function DoShow: boolean;
  end;

  ITagDeletedMessage = interface
    ['{5B755E86-DBF4-4CB6-85DE-D898A6842359}']
    function GetTagId: int64;
    function GetText: string;
  end;

  ITagRenamedMessage = interface
    ['{B7FDB2F5-2C2D-41A4-882D-E522773EEABF}']
    function GetTagId: int64;
    function GetNewText: string;
  end;

  IDictionariesLoadedMessage = interface
    ['{B7FDB2F5-2C2D-41A4-882D-E522773EEABF}']
  end;

  IDefaultBibleChangedMessage = interface
    ['{4C399C9E-875F-4DFB-B3F4-AF7532AA41C3}']
    function GetBibleName: string;
  end;

  TVerseAddedMessage = class (TJclBaseNotificationMessage, IVerseAddedMessage)
  private
    FVerseId: int64;
    FTagId: int64;
    FCommand: string;
    FShow: boolean;
  public
    constructor Create(verseId, tagId: int64; command: string; show: boolean);

    function GetVerseId: int64;
    function GetTagId: int64;
    function GetCommand: string;
    function DoShow: boolean;
  end;

  TVerseDeletedMessage = class (TJclBaseNotificationMessage, IVerseDeletedMessage)
  private
    FVerseId: int64;
    FTagId: int64;
  public
    constructor Create(verseId, tagId: int64);

    function GetVerseId: int64;
    function GetTagId: int64;
  end;

  TTagAddedMessage = class (TJclBaseNotificationMessage, ITagAddedMessage)
  private
    FTagId: int64;
    FText: string;
    FShow: boolean;
  public
    constructor Create(tagId: int64; text: string; show: boolean);

    function GetTagId: int64;
    function GetText: string;
    function DoShow: boolean;
  end;

  TTagDeletedMessage = class (TJclBaseNotificationMessage, ITagDeletedMessage)
  private
    FTagId: int64;
    FText: string;
  public
    constructor Create(tagId: int64; text: string);

    function GetTagId: int64;
    function GetText: string;
  end;

  TTagRenamedMessage = class (TJclBaseNotificationMessage, ITagRenamedMessage)
  private
    FTagId: int64;
    FNewText: string;
  public
    constructor Create(tagId: int64; newText: string);

    function GetTagId: int64;
    function GetNewText: string;
  end;

  TDictionariesLoadedMessage = class(TJclBaseNotificationMessage, IDictionariesLoadedMessage)

  end;

  TDefaultBibleChangedMessage = class(TJclBaseNotificationMessage, IDefaultBibleChangedMessage)
  private
    FBibleName: string;
  public
    constructor Create(bibleName: string);
    function GetBibleName: string;
  end;

implementation

{ TVerseAddedMessage }

constructor TVerseAddedMessage.Create(verseId, tagId: int64; command: string; show: boolean);
begin
  FVerseId := verseId;
  FTagId := tagId;
  FCommand := command;
  FShow := show;
end;

function TVerseAddedMessage.GetVerseId: int64;
begin
  Result := FVerseId;
end;

function TVerseAddedMessage.GetTagId: int64;
begin
  Result := FTagId;
end;

function TVerseAddedMessage.GetCommand: string;
begin
  Result := FCommand;
end;

function TVerseAddedMessage.DoShow: boolean;
begin
  Result := FShow;
end;

{ TVerseAddedMessage }

constructor TVerseDeletedMessage.Create(verseId, tagId: int64);
begin
  FVerseId := verseId;
  FTagId := tagId;
end;

function TVerseDeletedMessage.GetVerseId: int64;
begin
  Result := FVerseId;
end;

function TVerseDeletedMessage.GetTagId: int64;
begin
  Result := FTagId;
end;

{ TTagAddedMessage }

constructor TTagAddedMessage.Create(tagId: int64; text: string; show: boolean);
begin
  FTagId := tagId;
  FText := text;
  FShow := show;
end;

function TTagAddedMessage.GetTagId: int64;
begin
  Result := FTagId;
end;

function TTagAddedMessage.GetText: string;
begin
  Result := FText;
end;

function TTagAddedMessage.DoShow: boolean;
begin
  Result := FShow;
end;

{ TTagDeletedMessage }

constructor TTagDeletedMessage.Create(tagId: int64; text: string);
begin
  FTagId := tagId;
  FText := text;
end;

function TTagDeletedMessage.GetTagId: int64;
begin
  Result := FTagId;
end;

function TTagDeletedMessage.GetText: string;
begin
  Result := FText;
end;

{ TTagRenamedMessage }

constructor TTagRenamedMessage.Create(tagId: int64; newText: string);
begin
  FTagId := tagId;
  FNewText := newText;
end;

function TTagRenamedMessage.GetTagId: int64;
begin
  Result := FTagId;
end;

function TTagRenamedMessage.GetNewText: string;
begin
  Result := FNewText;
end;

{ TDefaultBibleChangedMessage }

constructor TDefaultBibleChangedMessage.Create(bibleName: string);
begin
  FBibleName := bibleName;
end;

function TDefaultBibleChangedMessage.GetBibleName: string;
begin
  Result := FBibleName;
end;
end.
