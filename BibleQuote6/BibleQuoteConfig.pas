unit BibleQuoteConfig;

interface


const
      C_bqVersion='6.0.20110908';
      C_bqDate='08.09.2011';

      C_CompressedModulesSubPath='compressed\modules';
      C_CommentariesSubPath='compressed\commentaries';
      C_DictionariesSubPath='compressed\dictionaries';
      C_ModuleIniName='bibleqt.ini';
      C_PasswordPolicyFileName= 'bq.pol';
      C_CachedModsFileName='cached.lst';
      C_HotModulessFileName='hotmodules.lst';
      C_CategoriesFile='cats.cfg';
      C_BQTechnoForumAddr='http://jesuschrist.ru/forum/B_biblequote.php';
      C_BQQuickLoad='http://jesuschrist.ru/forum/B_biblequote.php';
      C_NumOfModulesToScan= 5;
      C_BulletChar=#9679;

const
  C_crlf: packed array[0..2] of WideChar = (#13, #10,#0);
  C_plus: WideChar = '+';
  C_minus: WideChar = '-';
  C_frmMyLibWidth:WideString='frmMyLibWidth';
  C_frmMyLibHeight:WideString='frmMyLibHeight';
  C_opt_FullContextLinks='FullContextLinks';
  C_opt_HighlightVerseHits='HighlightVerseHits';
  C__bqAutoBible:WideString='_bqAutoBible';
  C__Utf8BOM=#$EF#$BB#$BF;
const
    C_TagRenameError:WideString= 'Cannot rename tag, another on with same name already exists';
    C_bqError:WideString='Error';
implementation

end.
