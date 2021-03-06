// JCL_DEBUG_EXPERT_GENERATEJDBG ON
// JCL_DEBUG_EXPERT_INSERTJDBG ON
program BibleQuote;

{$R *.dres}

uses
  Forms,
  Classes,
  WideStrings,
  SysUtils,
  MainFrm in 'Forms\MainFrm.pas' {MainForm},
  InputFrm in 'Forms\InputFrm.pas' {InputForm},
  ConfigFrm in 'Forms\ConfigFrm.pas' {ConfigForm},
  ExceptionFrm in 'Forms\ExceptionFrm.pas' {ExceptionForm},
  AboutFrm in 'Forms\AboutFrm.pas' {AboutForm},
  PasswordDlg in 'Forms\PasswordDlg.pas' {PasswordBox},
  Containers in 'Collections\Containers.pas',
  Bible in 'Core\Bible.pas',
  BibleLinkParser in 'Core\BibleLinkParser.pas',
  BibleQuoteConfig in 'Core\BibleQuoteConfig.pas',
  BibleQuoteUtils in 'Core\BibleQuoteUtils.pas',
  CommandProcessor in 'Core\CommandProcessor.pas',
  AppInfo in 'Utils\AppInfo.pas',
  SystemInfo in 'Utils\SystemInfo.pas',
  GfxRenderers in 'UI\GfxRenderers.pas',
  HintTools in 'UI\HintTools.pas',
  HTMLViewerSite in 'UI\HTMLViewerSite.pas',
  WinUIServices in 'UI\WinUIServices.pas',
  ICommandProcessor in 'Core\ICommandProcessor.pas',
  VDTEditLink in 'UI\VDTEditLink.pas',
  NativeDict in 'Core\Dict\NativeDict.pas',
  ZipUtils in 'Utils\ZipUtils.pas',
  LinksParser in 'Core\LinksParser.pas',
  LinksParserIntf in 'Core\LinksParserIntf.pas',
  Favorites in 'Core\Favorites.pas',
  PlainUtils in 'Utils\PlainUtils.pas',
  StringProcs in 'Utils\StringProcs.pas',
  IOProcs in 'IO\IOProcs.pas',
  TagsDb in 'Data\TagsDb.pas' {TagsDbEngine: TDataModule},
  MultiLanguage in 'Core\MultiLanguage.pas',
  TabData in 'Core\TabData.pas',
  CRC32 in 'Utils\CRC32.pas',
  DockTabsFrm in 'Forms\DockTabsFrm.pas' {DockTabsForm},
  ThinCaptionedDockTree in 'UI\ThinCaptionedDockTree.pas',
  LayoutConfig in 'IO\LayoutConfig.pas',
  BookFra in 'Views\BookFra.pas' {BookFrame: TFrame},
  MemoFra in 'Views\MemoFra.pas' {MemoFrame: TFrame},
  ManageFonts in 'Core\ManageFonts.pas',
  LibraryFra in 'Views\LibraryFra.pas' {LibraryFrame: TFrame},
  ImageUtils in 'Utils\ImageUtils.pas',
  UITools in 'UI\UITools.pas',
  PopupFrm in 'Forms\PopupFrm.pas' {PopupForm},
  BookmarksFra in 'Views\BookmarksFra.pas' {BookmarksFrame: TFrame},
  BroadcastList in 'Collections\BroadcastList.pas',
  SearchFra in 'Views\SearchFra.pas' {SearchFrame: TFrame},
  TSKFra in 'Views\TSKFra.pas' {TSKFrame: TFrame},
  TagsVersesFra in 'Views\TagsVersesFra.pas' {TagsVersesFrame: TFrame},
  DictionaryFra in 'Views\DictionaryFra.pas' {DictionaryFrame: TFrame},
  CommentsFra in 'Views\CommentsFra.pas' {CommentsFrame: TFrame},
  NotifyMessages in 'Core\NotifyMessages.pas',
  StrongFra in 'Views\StrongFra.pas' {StrongFrame: TFrame},
  AppPaths in 'IO\AppPaths.pas',
  AppIni in 'IO\AppIni.pas',
  StrongsConcordance in 'Core\StrongsConcordance.pas',
  DictInterface in 'Core\Dict\DictInterface.pas',
  BaseDict in 'Core\Dict\BaseDict.pas',
  DictLoaderInterface in 'Core\Dict\DictLoaderInterface.pas',
  NativeDictLoader in 'Core\Dict\NativeDictLoader.pas',
  MyBibleDict in 'Core\Dict\MyBibleDict.pas',
  MyBibleDictLoader in 'Core\Dict\MyBibleDictLoader.pas',
  DictLoaderFabric in 'Core\Dict\DictLoaderFabric.pas',
  ChapterData in 'Core\ChapterData.pas',
  SelectEntityType in 'Utils\SelectEntityType.pas',
  MyBibleUtils in 'Utils\MyBibleUtils.pas',
  GoCommand in 'Core\Commands\GoCommand.pas',
  FileCommand in 'Core\Commands\FileCommand.pas',
  CommandInterface in 'Core\Commands\CommandInterface.pas',
  CommandFactory in 'Core\Commands\CommandFactory.pas',
  CommandBase in 'Core\Commands\CommandBase.pas',
  CommandFactoryInterface in 'Core\Commands\CommandFactoryInterface.pas',
  FileNameCommand in 'Core\Commands\FileNameCommand.pas',
  DownloadModulesFrm in 'Forms\DownloadModulesFrm.pas' {DownloadModulesForm},
  ThirdPartModulesProcs in 'IO\ThirdPartModulesProcs.pas',
  JsonProcs in 'Utils\JsonProcs.pas',
  DataScanning in 'IO\DataScanning.pas',
  Types.Extensions in 'Utils\Types.Extensions.pas',
  HTMLParser in 'HTML\HTMLParser.pas',
  DOMCore in 'HTML\DOMCore.pas',
  Entities in 'HTML\Entities.pas',
  Formatter in 'HTML\Formatter.pas',
  HtmlReader in 'HTML\HtmlReader.pas',
  HtmlTags in 'HTML\HtmlTags.pas',
  ScriptureProvider in 'Core\ScriptureProvider.pas',
  AppStates in 'Core\AppStates.pas',
  DataServices in 'Core\DataServices.pas',
  Jobs in 'Core\Jobs.pas',
  InfoSource in 'Core\InfoSource\InfoSource.pas',
  InfoSourceLoaderFabric in 'Core\InfoSource\InfoSourceLoaderFabric.pas',
  InfoSourceLoaderInterface in 'Core\InfoSource\InfoSourceLoaderInterface.pas',
  MyBibleInfoSourceLoader in 'Core\InfoSource\MyBibleInfoSourceLoader.pas',
  NativeInfoSourceLoader in 'Core\InfoSource\NativeInfoSourceLoader.pas',
  SourceReader in 'Core\Readers\SourceReader.pas',
  MyBibleSourceReader in 'Core\Readers\MyBibleSourceReader.pas',
  NativeSourceReader in 'Core\Readers\NativeSourceReader.pas',
  SourceReaderIntf in 'Core\Readers\SourceReaderIntf.pas',
  Sets in 'Utils\Sets.pas',
  PreviewFrm in 'Forms\PreviewFrm.pas' {PreviewForm},
  PrintStatusFrm in 'Forms\PrintStatusFrm.pas' {PrnStatusForm},
  Gopage in 'Forms\Gopage.pas' {GoPageForm},
  PreviewUtils in 'Utils\PreviewUtils.pas';

{$R *.res}

var
  fn: string;
  param: string;

begin
  try
    if ParamStartedWith('/debug', param) then
    begin
      fn := ExtractFilePath(Application.Exename) + 'dbg.log';
      G_DebugEx := 1;
    end
    else
    begin
      fn := 'nul';
      G_DebugEx := 0;
    end;
    Assign(Output, fn);
    Rewrite(Output);
    writeln(NowDateTimeString(), 'BibleQuote dbg log started');
    Flush(Output);
    if ParamStartedWith('/memcheck', param) then
    begin
      ReportMemoryLeaksOnShutdown := true;
    end
    else
      ReportMemoryLeaksOnShutdown := false;
  except
  end;

  Application.Initialize;
  if not Assigned(TagsDbEngine) then
    TagsDbEngine := TTagsDbEngine.Create(Application);

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TPasswordBox, PasswordBox);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.CreateForm(TPrnStatusForm, PrnStatusForm);
  Application.CreateForm(TGoPageForm, GoPageForm);
  Application.Run;
  try
    Close(Output);
  except
  end;

end.
