unit IOProcsTests;

interface

uses
  DUnitX.TestFramework, Classes, IOProcs, SysUtils, RegularExpressions;

type

  [TestFixture]
  TestReadFiles = class(TObject)
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    [TestCase('ru-1251', 'ru01-windows-1251-w-metatag.htm,Книга 1')]
    [TestCase('en-1252', 'en01-windows-1252-w-metatag.htm,Book 1')]
    [TestCase('gk-1253', 'gk01-windows-1253-w-metatag.htm,Βιβλίο 1')]
    [TestCase('ru-utf-16', 'ru01-utf-16-w-metatag.htm,Книга 1')]
    [TestCase('en-utf-16', 'en01-utf-16-w-metatag.htm,Book 1')]
    [TestCase('gk-utf-16', 'gk01-utf-16-w-metatag.htm,Βιβλίο 1')]
    [TestCase('ru-utf-8', 'ru01-utf-8-w-metatag.htm,Книга 1')]
    [TestCase('en-utf-8', 'en01-utf-8-w-metatag.htm,Book 1')]
    [TestCase('gk-utf-8', 'gk01-utf-8-w-metatag.htm,Βιβλίο 1')]
    [TestCase('ru-1251-wo', 'ru01-windows-1251-wo-metatag.htm,Книга 1')]
    [TestCase('en-1252-wo', 'en01-windows-1252-wo-metatag.htm,Book 1')]
    [TestCase('ru-utf-16-wo', 'ru01-utf-16-wo-metatag.htm,Книга 1')]
    [TestCase('en-utf-16-wo', 'en01-utf-16-wo-metatag.htm,Book 1')]
    [TestCase('gk-utf-16-wo', 'gk01-utf-16-wo-metatag.htm,Βιβλίο 1')]
    [TestCase('ru-utf-8-bom-wo', 'ru01-utf-8-bom-wo-metatag.htm,Книга 1')]
    [TestCase('en-utf-8-bom-wo', 'en01-utf-8-bom-wo-metatag.htm,Book 1')]
    [TestCase('gk-utf-8-bom-wo', 'gk01-utf-8-bom-wo-metatag.htm,Βιβλίο 1')]
    procedure ReadHtml_ShouldReturnHtmlWithValidCharacters_ForSupportedEncodings(const filename: string; const title: string);

    [TestCase('enc-1251-ru', 'ru01-windows-1251-w-metatag.htm')]
    [TestCase('enc-1252-en', 'en01-windows-1252-w-metatag.htm')]
    [TestCase('enc-1253-gk', 'gk01-windows-1253-w-metatag.htm')]
    [TestCase('enc-utf-16-ru', 'ru01-utf-16-w-metatag.htm')]
    [TestCase('enc-utf-16-en', 'en01-utf-16-w-metatag.htm')]
    [TestCase('enc-utf-16-gk', 'gk01-utf-16-w-metatag.htm')]
    [TestCase('enc-utf-8-ru', 'ru01-utf-8-w-metatag.htm')]
    [TestCase('enc-utf-8-en', 'en01-utf-8-w-metatag.htm')]
    [TestCase('enc-utf-8-gk', 'gk01-utf-8-w-metatag.htm')]
    procedure FindEncodingMetatag_ShouldReturnNonEmptyEncoding(const filename: string);

    [TestCase('enc-nil-1251-ru', 'ru01-windows-1251-wo-metatag.htm')]
    [TestCase('enc-nil-1252-en', 'en01-windows-1252-wo-metatag.htm')]
    [TestCase('enc-nil-utf-16-ru', 'ru01-utf-16-wo-metatag.htm')]
    [TestCase('enc-nil-utf-16-en', 'en01-utf-16-wo-metatag.htm')]
    [TestCase('enc-nil-utf-16-gk', 'gk01-utf-16-wo-metatag.htm')]
    [TestCase('enc-nil-utf-8-bom-ru', 'ru01-utf-8-bom-wo-metatag.htm')]
    [TestCase('enc-nil-utf-8-bom-en', 'en01-utf-8-bom-wo-metatag.htm')]
    [TestCase('enc-nil-utf-8-bom-gk', 'gk01-utf-8-bom-wo-metatag.htm')]
    procedure FindEncodingMetatag_ShouldReturnEmptyEncoding(const filename: string);

    [Test]
    procedure WriteEncodingMetatagToHtml_ShouldReplaceEncodingMetatag_WhenMetatagExists();

    [TestCase('write-enc-html-head',  '<html><head></head><body></body></html>')]
    [TestCase('write-enc-html-body',  '<html><body></body></html>')]
    [TestCase('write-enc-html',       '<html></html>')]
    [TestCase('write-enc-html-empty', '')]
    procedure WriteEncodingMetatagToHtml_ShouldAddEncodingMetatag_WhenMetatagNotExists(const html: string);

    function GetFilePath(filename: string): string;
  end;

implementation

procedure TestReadFiles.Setup;
begin
end;

procedure TestReadFiles.TearDown;
begin
end;

procedure TestReadFiles.ReadHtml_ShouldReturnHtmlWithValidCharacters_ForSupportedEncodings(const filename: string; const title: string);
var
  path: string;
  lines: TStrings;
  regexpr: TRegEx;
  match: TMatch;
begin
  path := GetFilePath(filename);
  lines := ReadHtml(path, TEncoding.GetEncoding(1251));

  regexpr := TRegEx.Create('<title>(.+?)<\/title>', [roIgnoreCase]);
  match := regexpr.match(lines[3]);

  Assert.AreEqual(true, match.Success);
  Assert.AreEqual(title, match.Groups[1].Value);
end;

procedure TestReadFiles.FindEncodingMetatag_ShouldReturnNonEmptyEncoding(const filename: string);
var
  path: string;
  content: string;
  startPos, endPos: Integer;
  encoding: TEncoding;
begin
   path := GetFilePath(filename);
   ReadHtmlTo(path, content, nil);

   encoding := FindEncodingMetatag(content, startPos, endPos);
   Assert.IsNotNull(encoding);
end;

procedure TestReadFiles.FindEncodingMetatag_ShouldReturnEmptyEncoding(const filename: string);
var
  path: string;
  content: string;
  startPos, endPos: Integer;
  encoding: TEncoding;
begin
   path := GetFilePath(filename);
   ReadHtmlTo(path, content, TEncoding.GetEncoding(1251));

   encoding := FindEncodingMetatag(content, startPos, endPos);
   Assert.IsNull(encoding);
end;

procedure TestReadFiles.WriteEncodingMetatagToHtml_ShouldReplaceEncodingMetatag_WhenMetatagExists();
var
  html: string;
  oldPos: Integer;
  newPos: Integer;
begin
  html := '<html><head><meta http-equiv="content-type" content="text/html; charset=windows-1251"></head><body></body></html>';
  oldPos := Pos('windows-1251', html);

  WriteEncodingMetatagToHtml(html);
  newPos := Pos('utf-8', html);

  Assert.IsTrue(newPos > 0);
  Assert.AreEqual(oldPos, newPos);
end;

procedure TestReadFiles.WriteEncodingMetatagToHtml_ShouldAddEncodingMetatag_WhenMetatagNotExists(const html: string);
var
  htmlCopy: string;
  encPos: Integer;
begin
  htmlCopy := html;

  WriteEncodingMetatagToHtml(htmlCopy);
  encPos := Pos('content="text/html; charset=utf-8"', htmlCopy);

  Assert.IsTrue(encPos > 0);
end;


function TestReadFiles.GetFilePath(filename: string): string;
begin
  Result := ExtractFileDir(ParamStr(0)) + '\..\TestFiles\' + filename;
end;

initialization

TDUnitX.RegisterTestFixture(TestReadFiles);

end.
