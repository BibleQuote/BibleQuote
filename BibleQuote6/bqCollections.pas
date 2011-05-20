unit bqCollections;

interface

uses
  SysUtils, Classes, ASGSQLite3;

type
  TDataModule1 = class(TDataModule)
    dbCollections: TASQLite3DB;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

end.
