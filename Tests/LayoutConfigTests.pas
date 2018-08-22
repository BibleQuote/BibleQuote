unit LayoutConfigTests;

interface
uses
  DUnitX.TestFramework, Classes, LayoutConfig, SysUtils, RegularExpressions,
  Rest.Json, IOUtils;

type

  [TestFixture]
  TestLayoutConfig = class(TObject)
  public
    [Setup]
    procedure Setup;

    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure LoadLayoutConfigTest_ShouldReturnLayoutConfig();

    [Test]
    procedure SaveLayoutConfigTest_ShouldNotThrow();

    function GetFilePath(filename: string): string;
  end;

  implementation

procedure TestLayoutConfig.Setup;
begin
end;

procedure TestLayoutConfig.TearDownFixture;
begin
  DeleteFile(GetFilePath('layout_config_temp.json'));
end;

procedure TestLayoutConfig.LoadLayoutConfigTest_ShouldReturnLayoutConfig();
var
  path: string;
  layoutConfig: TLayoutConfig;
begin

  path := GetFilePath('layout_config.json');
  layoutConfig := TLayoutConfig.Load(path);

  Assert.IsNotNull(layoutConfig);
  Assert.AreEqual(2, layoutConfig.TabsViewList.Count);
  Assert.AreEqual(2, layoutConfig.TabsViewList[0].TabSettingsList.Count);
  Assert.AreEqual(2, layoutConfig.TabsViewList[1].TabSettingsList.Count);

  Assert.AreEqual('Test location 1', layoutConfig.TabsViewList[0].TabSettingsList[0].Location);
  Assert.AreEqual('Title 1', layoutConfig.TabsViewList[0].TabSettingsList[0].Title);
  Assert.AreEqual('Test location 3', layoutConfig.TabsViewList[1].TabSettingsList[0].Location);
  Assert.AreEqual('Title 3', layoutConfig.TabsViewList[1].TabSettingsList[0].Title);
end;

procedure TestLayoutConfig.SaveLayoutConfigTest_ShouldNotThrow();
var
  path: string;
  layoutConfig: TLayoutConfig;
  tabsSettings: TTabsViewSettings;
  tabSettings: TTabSettings;
begin
  path := GetFilePath('layout_config_temp.json');
  layoutConfig := TLayoutConfig.Create;

  tabsSettings := TTabsViewSettings.Create;

  tabSettings := TTabSettings.Create;
  tabSettings.Location := 'Test location 1';
  tabSettings.Title := 'Title 1';

  tabsSettings.TabSettingsList.Add(tabSettings);

  tabSettings := TTabSettings.Create;
  tabSettings.Location := 'Test location 2';
  tabSettings.Title := 'Title 2';

  tabsSettings.TabSettingsList.Add(tabSettings);
  layoutConfig.TabsViewList.Add(tabsSettings);

  tabsSettings := TTabsViewSettings.Create;

  tabSettings := TTabSettings.Create;
  tabSettings.Location := 'Test location 3';
  tabSettings.Title := 'Title 3';

  tabsSettings.TabSettingsList.Add(tabSettings);

  tabSettings := TTabSettings.Create;
  tabSettings.Location := 'Test location 4';
  tabSettings.Title := 'Title 4';

  tabsSettings.TabSettingsList.Add(tabSettings);
  layoutConfig.TabsViewList.Add(tabsSettings);

  Assert.WillNotRaise(procedure begin layoutConfig.Save(path); end);
end;

function TestLayoutConfig.GetFilePath(filename: string): string;
begin
  Result := ExtractFileDir(ParamStr(0)) + '\..\TestFiles\' + filename;
end;

initialization

TDUnitX.RegisterTestFixture(TestLayoutConfig);

end.
