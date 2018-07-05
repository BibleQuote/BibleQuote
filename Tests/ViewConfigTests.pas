unit ViewConfigTests;

interface
uses
  DUnitX.TestFramework, Classes, ViewConfig, XmlSerial, SysUtils, RegularExpressions,
  Rest.Json, IOUtils;

type

  [TestFixture]
  TestViewConfig = class(TObject)
  public
    [Setup]
    procedure Setup;

    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure LoadViewConfigTest_ShouldReturnViewConfig();

    [Test]
    procedure SaveViewConfigTest_ShouldNotThrow();

    function GetFilePath(filename: string): string;
  end;

  implementation

procedure TestViewConfig.Setup;
begin
end;

procedure TestViewConfig.TearDownFixture;
begin
  DeleteFile(GetFilePath('viewconfig_temp.json'));
end;

procedure TestViewConfig.LoadViewConfigTest_ShouldReturnViewConfig();
var
  path: string;
  viewConfig: TViewConfig;
begin

  path := GetFilePath('viewconfig.json');
  viewConfig := TViewConfig.Load(path);

  Assert.IsNotNull(viewConfig);
  Assert.AreEqual(2, viewConfig.ModuleViews.Count);
  Assert.AreEqual('Test location 1', viewconfig.ModuleViews[0].Location);
  Assert.AreEqual('Test location 2', viewconfig.ModuleViews[1].Location);
end;

procedure TestViewConfig.SaveViewConfigTest_ShouldNotThrow();
var
  path: string;
  viewConfig: TViewConfig;
  m1, m2: TModuleViewSettings;
begin
  path := GetFilePath('viewconfig_temp.json');
  viewConfig := TViewConfig.Create;

  m1 := TModuleViewSettings.Create;
  m1.Location := 'Test location 1';

  m2 := TModuleViewSettings.Create;
  m2.Location := 'Test location 2';

  viewConfig.ModuleViews.Add(m1);
  viewConfig.ModuleViews.Add(m2);

  Assert.WillNotRaise(procedure begin viewConfig.Save(path); end);
end;

function TestViewConfig.GetFilePath(filename: string): string;
begin
  Result := ExtractFileDir(ParamStr(0)) + '\..\TestFiles\' + filename;
end;

initialization

TDUnitX.RegisterTestFixture(TestViewConfig);

end.
