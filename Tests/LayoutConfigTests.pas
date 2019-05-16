unit LayoutConfigTests;

interface
uses
  DUnitX.TestFramework, Classes, LayoutConfig, SysUtils, RegularExpressions,
  Rest.Json, IOUtils, System.JSON, Generics.Collections;

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

    [Test]
    procedure TestSearchTabSettingsSerialization();

    [Test]
    procedure TestBookTabSettingsSerialization();

   [Test]
    procedure TestTSKTabSettingsSerialization();

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
  Assert.AreEqual(2, layoutConfig.WorkspaceSettingsList.Count);
  Assert.AreEqual(2, layoutConfig.WorkspaceSettingsList[0].BookTabs.Count);
  Assert.AreEqual(1, layoutConfig.WorkspaceSettingsList[1].BookTabs.Count);

  Assert.AreEqual('Test location 1', layoutConfig.WorkspaceSettingsList[0].BookTabs[0].Location);
  Assert.AreEqual('Title 1', layoutConfig.WorkspaceSettingsList[0].BookTabs[0].Title);
  Assert.AreEqual('Test location 3', layoutConfig.WorkspaceSettingsList[1].BookTabs[0].Location);
  Assert.AreEqual('Title 3', layoutConfig.WorkspaceSettingsList[1].BookTabs[0].Title);
end;

procedure TestLayoutConfig.SaveLayoutConfigTest_ShouldNotThrow();
var
  path: string;
  layoutConfig: TLayoutConfig;
  workspaceSettings: TWorkspaceSettings;
  tabSettings: TBookTabSettings;
begin
  path := GetFilePath('layout_config_temp.json');
  layoutConfig := TLayoutConfig.Create;

  workspaceSettings := TWorkspaceSettings.Create;

  tabSettings := TBookTabSettings.Create;
  tabSettings.Location := 'Test location 1';
  tabSettings.Title := 'Title 1';

  workspaceSettings.AddTabSettings(tabSettings);

  tabSettings := TBookTabSettings.Create;
  tabSettings.Location := 'Test location 2';
  tabSettings.Title := 'Title 2';

  workspaceSettings.AddTabSettings(tabSettings);
  layoutConfig.WorkspaceSettingsList.Add(workspaceSettings);

  workspaceSettings := TWorkspaceSettings.Create;

  tabSettings := TBookTabSettings.Create;
  tabSettings.Location := 'Test location 3';
  tabSettings.Title := 'Title 3';

  workspaceSettings.AddTabSettings(tabSettings);

  tabSettings := TBookTabSettings.Create;
  tabSettings.Location := 'Test location 4';
  tabSettings.Title := 'Title 4';

  workspaceSettings.AddTabSettings(tabSettings);
  layoutConfig.WorkspaceSettingsList.Add(workspaceSettings);

  Assert.WillNotRaise(procedure begin layoutConfig.Save(path); end);
end;

function TestLayoutConfig.GetFilePath(filename: string): string;
begin
  Result := ExtractFileDir(ParamStr(0)) + '\..\TestFiles\' + filename;
end;

procedure TestLayoutConfig.TestSearchTabSettingsSerialization();
var
  json: TJSONValue;
  jsonStr: string;
  tabSettings: TSearchTabSettings;
begin
  json := TJSONObject.ParseJSONValue('{"SearchText": "search text", "AnyWord": "true", "Phrase" : "true", "ExactPhrase" : "true", "Parts" : "true", "MatchCase" : "true", "BookPath" : "path"}');
  tabSettings := TSearchTabSettings.Create();
  tabSettings.FromJson(TJSONObject(json));

  Assert.AreEqual('search text', tabSettings.SearchText);
  Assert.IsTrue(tabSettings.AnyWord);
  Assert.IsTrue(tabSettings.Phrase);
  Assert.IsTrue(tabSettings.ExactPhrase);
  Assert.IsTrue(tabSettings.Parts);
  Assert.IsTrue(tabSettings.MatchCase);
  Assert.AreEqual('path', tabSettings.BookPath);

  jsonStr := json.ToJSON;
  Assert.IsTrue(jsonStr.Length > 0);
end;

procedure TestLayoutConfig.TestBookTabSettingsSerialization();
var
  json: TJSONValue;
  jsonStr: string;
  tabSettings: TBookTabSettings;
begin
  json := TJSONObject.ParseJSONValue('{"Location": "location", "SecondBible": "second bible", "OptionsState": "100", "Title": "title", "History": "history", "HistoryIndex": "100"}');
  tabSettings := TBookTabSettings.Create();
  tabSettings.FromJson(TJSONObject(json));

  Assert.AreEqual('location', tabSettings.Location);
  Assert.AreEqual('second bible', tabSettings.SecondBible);
  Assert.AreEqual(Uint64(100), tabSettings.OptionsState);
  Assert.AreEqual('title', tabSettings.Title);
  Assert.AreEqual('history', tabSettings.History);
  Assert.AreEqual(100, tabSettings.HistoryIndex);

  jsonStr := json.ToJSON;
  Assert.IsTrue(jsonStr.Length > 0);
end;

procedure TestLayoutConfig.TestTSKTabSettingsSerialization();
var
  json: TJSONValue;
  jsonStr: string;
  tabSettings: TTSKTabSettings;
begin
  json := TJSONObject.ParseJSONValue('{"Location": "location", "Book": "1", "Chapter": "2", "Verse": "3"}');
  tabSettings := TTSKTabSettings.Create();
  tabSettings.FromJson(TJSONObject(json));

  Assert.AreEqual('location', tabSettings.Location);
  Assert.AreEqual(1, tabSettings.Book);
  Assert.AreEqual(2, tabSettings.Chapter);
  Assert.AreEqual(3, tabSettings.Verse);

  jsonStr := json.ToJSON;
  Assert.IsTrue(jsonStr.Length > 0);
end;

initialization

TDUnitX.RegisterTestFixture(TestLayoutConfig);

end.
