unit ViewConfigTests;

interface
uses
  DUnitX.TestFramework, Classes, ViewConfig, SysUtils, RegularExpressions,
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
  Assert.AreEqual(2, viewConfig.ModuleViews[0].TabSettingsList.Count);
  Assert.AreEqual(2, viewConfig.ModuleViews[1].TabSettingsList.Count);

  Assert.AreEqual('Test location 1', viewconfig.ModuleViews[0].TabSettingsList[0].Location);
  Assert.AreEqual('Title 1', viewconfig.ModuleViews[0].TabSettingsList[0].Title);
  Assert.AreEqual('Test location 3', viewconfig.ModuleViews[1].TabSettingsList[0].Location);
  Assert.AreEqual('Title 3', viewconfig.ModuleViews[1].TabSettingsList[0].Title);
end;

procedure TestViewConfig.SaveViewConfigTest_ShouldNotThrow();
var
  path: string;
  viewConfig: TViewConfig;
  moduleSettings: TModuleViewSettings;
  tabSettings: TTabSettings;
begin
  path := GetFilePath('viewconfig_temp.json');
  viewConfig := TViewConfig.Create;

  moduleSettings := TModuleViewSettings.Create;

  tabSettings := TTabSettings.Create;
  tabSettings.Location := 'Test location 1';
  tabSettings.Title := 'Title 1';

  moduleSettings.TabSettingsList.Add(tabSettings);

  tabSettings := TTabSettings.Create;
  tabSettings.Location := 'Test location 2';
  tabSettings.Title := 'Title 2';

  moduleSettings.TabSettingsList.Add(tabSettings);
  viewConfig.ModuleViews.Add(moduleSettings);

   moduleSettings := TModuleViewSettings.Create;

  tabSettings := TTabSettings.Create;
  tabSettings.Location := 'Test location 3';
  tabSettings.Title := 'Title 3';

  moduleSettings.TabSettingsList.Add(tabSettings);

  tabSettings := TTabSettings.Create;
  tabSettings.Location := 'Test location 4';
  tabSettings.Title := 'Title 4';

  moduleSettings.TabSettingsList.Add(tabSettings);
  viewConfig.ModuleViews.Add(moduleSettings);

  Assert.WillNotRaise(procedure begin viewConfig.Save(path); end);
end;

function TestViewConfig.GetFilePath(filename: string): string;
begin
  Result := ExtractFileDir(ParamStr(0)) + '\..\TestFiles\' + filename;
end;

initialization

TDUnitX.RegisterTestFixture(TestViewConfig);

end.
