unit BibleQuoteConfig;

interface
const C_CompressedModulesSubPath='compressed\modules';
      C_CommentariesSubPath='compressed\commentaries';
      C_DictionariesSubPath='compressed\dictionaries';
      C_ModuleIniName='bibleqt.ini';
      C_PasswordPolicyFileName= 'bq.pol';
      C_CachedModsFileName='cached.lst';
      C_HotModulessFileName='hotmodules.lst';
      C_CategoriesFile='cats.cfg';
      C_BQTechnoForumAddr='http://jesuschrist.ru/forum/686798.php';
      C_NumOfModulesToScan= 5;
const
  C_crlf: packed array[0..2] of WideChar = (#13, #10,#0);
  C_plus: WideChar = '+';
  C_minus: WideChar = '-';
      
implementation

end.
