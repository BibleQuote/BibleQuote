unit AppPaths;

interface

uses IOUtils, JclSysInfo, SystemInfo, StringProcs, SysUtils, Windows,
     BibleQuoteConfig, Vcl.Forms;

const
  C_LibraryDirectory = 'Library';
  C_BiblesSubDirectory = 'Bibles';
  C_CommentariesSubDirectory = 'Commentaries';
  C_DictionariesSubDirectory = 'Dictionaries';
  C_BooksSubDirectory = 'Books';
  C_TSKSubDirectory = 'System\TSK';
  C_StrongSubDirectory = 'System\Strong';

type
  TAppDirectories = class
  public
    class function UserSettings: string; static;
    class function Root: string; static;
    class function Localization: string; static;
  end;

  TLibraryDirectories = class
    class function Root: string; static;
    class function Strong: string; static;
    class function TSK: string; static;
    class function Bibles: string; static;
    class function Books: string; static;
    class function Dictionaries: string; static;
    class function Commentaries: string; static;
  end;

implementation

class function TAppDirectories.UserSettings: string;
begin
  Result := TPath.Combine(GetAppdataFolder, 'BibleQuote');
  if ForceDirectories(Result) then
    Exit;

  MessageBox(0, 'Cannot Found BibleQute data folder', 'BibleQute Error', MB_OK or MB_ICONERROR);
  Result := '';
end;

class function TAppDirectories.Root: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

class function TAppDirectories.Localization: string;
begin
  Result := TPath.Combine(Root, 'Localization');
end;

class function TLibraryDirectories.Root: string;
begin
  Result := TPath.Combine(TAppDirectories.Root, C_LibraryDirectory);
end;

class function TLibraryDirectories.Strong: string;
begin
  Result := TPath.Combine(Root, C_StrongSubDirectory);
end;

class function TLibraryDirectories.TSK: string;
begin
  Result := TPath.Combine(Root, C_TSKSubDirectory);
end;

class function TLibraryDirectories.Bibles: string;
begin
  Result := TPath.Combine(Root, C_BiblesSubDirectory);
end;

class function TLibraryDirectories.Books: string;
begin
  Result := TPath.Combine(Root, C_BooksSubDirectory);
end;

class function TLibraryDirectories.Dictionaries: string;
begin
  Result := TPath.Combine(Root, C_DictionariesSubDirectory);
end;

class function TLibraryDirectories.Commentaries: string;
begin
  Result := TPath.Combine(Root, C_CommentariesSubDirectory);
end;

end.
