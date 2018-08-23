unit BibleQuoteConfig;

interface

const
  C_LibraryDirectory = 'Library';
  C_CompressedLibraryDirectory = 'Library\Compressed';
  C_BiblesSubDirectory = 'Bibles';
  C_CommentariesSubDirectory = 'Commentaries';
  C_DictionariesSubDirectory = 'Dictionaries';
  C_BooksSubDirectory = 'Books';
  C_TSKSubDirectory = 'System\TSK';
  C_StrongsSubDirectory = 'System\Strongs';

  C_ModuleIniName = 'bibleqt.ini';
  C_PasswordPolicyFileName = 'bq.pol';
  C_CachedModsFileName = 'cached.lst';
  C_HotModulessFileName = 'hotmodules.lst';
  C_CategoriesFile = 'cats.cfg';
  C_BQTechnoForumAddr = 'http://jesuschrist.ru/forum/B_biblequote.php';
  C_BQQuickLoad = 'http://code.google.com/p/biblequote/downloads/';
  C_NumOfModulesToScan = 5;
  C_BulletChar = #9679;

const
  C_crlf: packed array [0 .. 2] of Char = (#13, #10, #0);
  C_plus: Char = '+';
  C_minus: Char = '-';
  C_frmMyLibWidth: string = 'frmMyLibWidth';
  C_frmMyLibHeight: string = 'frmMyLibHeight';
  C_opt_FullContextLinks = 'FullContextLinks';
  C_opt_HighlightVerseHits = 'HighlightVerseHits';
  C__bqAutoBible: string = '_bqAutoBible';

const
  C_TagRenameError: string =
    'Cannot rename tag, another on with same name already exists';

  C_bqError: string = 'Error';

  c_BibleBooks: string=
    'bqBibleBook1=���.|���|��.|��|�����|Ge.|Ge|Gen.|Gen|Gn.|Gn|Genesis' +#13#10+
    'bqChaptersCount1=50' +#13#10+
    'bqBibleBook2=���.|���|�����|Ex.|Ex|Exo.|Exo|Exod.|Exod|Exodus' +#13#10+
    'bqChaptersCount2=40' +#13#10+
    'bqBibleBook3=���.|���|��.|��|�����|Lev.|Lev|Le.|Le|Lv.|Lv|Levit.|Levit|Leviticus' +#13#10+
    'bqChaptersCount3=27' +#13#10+
    'bqBibleBook4=���.|���|��.|��|����.|����|�����|Nu.|Nu|Num.|Num|Nm.|Nm|Numb.|Numb|Numbers' +#13#10+
    'bqChaptersCount4=36' +#13#10+
    'bqBibleBook5=����.|����|��.|��|�����.|�����|������������|De.|De|Deut.|Deut|Deu.|Deu|Dt.|Dt||Deuteron.|Deuteron|Deuteronomy' +#13#10+
    'bqChaptersCount5=34' +#13#10+
    'bqBibleBook6=���.���.|���.���|���.|���|�����|�����|Jos.|Jos|Josh.|Josh|Joshua' +#13#10+
    'bqChaptersCount6=24' +#13#10+
    'bqBibleBook7=���.|���|��.|��|�����|Jdg.|Jdg|Judg.|Judg|Judge.|Judge|Judges' +#13#10+
    'bqChaptersCount7=21' +#13#10+
    'bqBibleBook8=���.|���|��.|��|����|Ru.|Ru|Ruth|Rth.|Rth|Rt.|Rt' +#13#10+
    'bqChaptersCount8=4' +#13#10+
    'bqBibleBook9=1���.|1���|1��.|1��|1�|1������.|1������|1Sa.|1Sa|1S.|1S|1Sam.|1Sam|1Sm.|1Sm|1Sml.|1Sml|1Samuel' +#13#10+
    'bqChaptersCount9=31' +#13#10+
    'bqBibleBook10=2���.|2���|2��.|2��|2�|2������.|2������|2Sa.|2Sa|2S.|2S|2Sam.|2Sam|2Sm.|2Sm|2Sml.|2Sml|2Samuel' +#13#10+
    'bqChaptersCount10=24' +#13#10+
    'bqBibleBook11=3���.|3���|3��.|3��|3�|3������.|3������|1Ki.|1Ki|1K.|1K|1Kn.|1Kn|1Kg.|1Kg|1King.|1King|1Kng.|1Kng|1Kings' +#13#10+
    'bqChaptersCount11=22' +#13#10+
    'bqBibleBook12=4���.|4���|4��.|4��|4�|4������.|4������|2Ki.|2Ki|2K.|2K|2Kn.|2Kn|2Kg.|2Kg|2King.|2King|2Kng.|2Kng|2Kings' +#13#10+
    'bqChaptersCount12=25' +#13#10+
    'bqBibleBook13=1���.|1���|1��.|1��|1Chr.|1Chr|1Ch.|1Ch|1Chron.|1Chron' +#13#10+
    'bqChaptersCount13=26' +#13#10+
    'bqBibleBook14=2���.|2���|2��.|2��|2Chr.|2Chr|2Ch.|2Ch|2Chron.|2Chron' +#13#10+
    'bqChaptersCount14=36' +#13#10+
    'bqBibleBook15=����.|����|���.|���|��.|��|�����|Ezr.|Ezr|Ezra' +#13#10+
    'bqChaptersCount15=10' +#13#10+
    'bqBibleBook16=����.|����.|��.|��|������|Ne.|Ne|Neh.|Neh|Nehem.|Nehem|Nehemiah' +#13#10+
    'bqChaptersCount16=13' +#13#10+
    'bqBibleBook17=���.|���|��.|��|������|Esth.|Esth|Est.|Est|Esther' +#13#10+
    'bqChaptersCount17=10' +#13#10+
    'bqBibleBook18=���.|���|��.|��|Job.|Job|Jb.|Jb' +#13#10+
    'bqChaptersCount18=42' +#13#10+
    'bqBibleBook19=��.|��|�����.|�����|����.|����|���.|���|������|��������|������|Ps.|Ps|Psa.|Psa|Psal.|Psal|Psalm|Psalms' +#13#10+
    'bqChaptersCount19=150' +#13#10+
    'bqBibleBook20=����.|����|�����.|�����|��.|��|������|������|Pr.|Pr|Prov.|Prov|Pro.|Pro|Proverb|Proverbs' +#13#10+
    'bqChaptersCount20=31' +#13#10+
    'bqBibleBook21=����.|����|��.|��|���.|���|����������|Ec.|Ec|Eccl.|Eccl|Ecc.|Ecc|Ecclesia.|Ecclesia' +#13#10+
    'bqChaptersCount21=12' +#13#10+
    'bqBibleBook22=����.|����|���.|���|���.|���|����.������|�����|Song.|Song|Songs|SS.|SS|Sol.|Sol' +#13#10+
    'bqChaptersCount22=8' +#13#10+
    'bqBibleBook23=��.|��|���.|���|�����|�����|Isa.|Isa|Is.|Is|Isaiah' +#13#10+
    'bqChaptersCount23=66' +#13#10+
    'bqBibleBook24=���.|���|�����.|�����|�������|Je.|Je|Jer.|Jer|Jerem.|Jerem|Jeremiah' +#13#10+
    'bqChaptersCount24=52' +#13#10+
    'bqBibleBook25=����.|����|���.|���|��.|��|��.���.|��.���|����|�������|La.|La|Lam.|Lam|Lament.|Lament|Lamentation|Lamentations' +#13#10+
    'bqChaptersCount25=5' +#13#10+
    'bqBibleBook26=���.|���|��.|��|�����.|�����|���������|Ez.|Ez|Eze.|Eze|Ezek.|Ezek|Ezekiel' +#13#10+
    'bqChaptersCount26=48' +#13#10+
    'bqBibleBook27=���.|���|��.|��|���.|���|������|Da.|Da|Dan.|Dan|Daniel' +#13#10+
    'bqChaptersCount27=14' +#13#10+
    'bqBibleBook28=��.|��|����|Hos.|Hos|Ho.|Ho|Hosea' +#13#10+
    'bqChaptersCount28=14' +#13#10+
    'bqBibleBook29=����.|����|��.|��|�����|Joel.|Joel|Joe.|Joe' +#13#10+
    'bqChaptersCount29=3' +#13#10+
    'bqBibleBook30=��.|��|���.|���|����|Am.|Am|Amos|Amo.|Amo' +#13#10+
    'bqChaptersCount30=9' +#13#10+
    'bqBibleBook31=���.|���|�����|Ob.|Ob|Obad.|Obad.|Obadiah|Oba.|Oba' +#13#10+
    'bqChaptersCount31=1' +#13#10+
    'bqBibleBook32=���.|���.|����|Jon.|Jon|Jnh.|Jnh.|Jona.|Jona|Jonah' +#13#10+
    'bqChaptersCount32=4' +#13#10+
    'bqBibleBook33=���.|���|��.|��|�����|Mi.|Mi|Mic.|Mic|Micah' +#13#10+
    'bqChaptersCount33=7' +#13#10+
    'bqBibleBook34=����.|����|Na.|Na|Nah.|Nah|Nahum' +#13#10+
    'bqChaptersCount34=3' +#13#10+
    'bqBibleBook35=���.|���|�����.|�����|�������|Hab.|Hab|Habak.|Habak|Habakkuk' +#13#10+
    'bqChaptersCount35=3' +#13#10+
    'bqBibleBook36=���.|���|�����.|�����|�������|Zeph.|Zeph||Zep.|Zep|Zephaniah' +#13#10+
    'bqChaptersCount36=3' +#13#10+
    'bqBibleBook37=���.|���|�����|Hag.|Hag|Haggai' +#13#10+
    'bqChaptersCount37=2' +#13#10+
    'bqBibleBook38=���.|���|���.|���|�����.|�����|�������|Ze.|Ze|Zec.|Zec|Zech.|Zech|Zechariah' +#13#10+
    'bqChaptersCount38=14' +#13#10+
    'bqBibleBook39=���.|���|�����.|�����|���.|���|�������|Mal.|Mal|Malachi' +#13#10+
    'bqChaptersCount39=4' +#13#10+
    'bqBibleBook40=����.|����|���.|���|��.|��|��.|��|������|������|���|���.|Mt.|Mt|Ma.|Ma|Matt.|Matt|Mat.|Mat|Matthew' +#13#10+
    'bqChaptersCount40=28' +#13#10+
    'bqBibleBook41=���.|���|����.|����|���.|���|��.|��|�����|��|��.|Mk.|Mk|Mar.|Mar|Mr.|Mr|Mrk.|Mrk|Mark' +#13#10+
    'bqChaptersCount41=16' +#13#10+
    'bqBibleBook42=���.|���|��.|��|���a|����|Lk.|Lk|Lu.|Lu|Luk.|Luk|Luke' +#13#10+
    'bqChaptersCount42=24' +#13#10+
    'bqBibleBook43=����.|����|��.|��|�����|������|Jn.|Jn|Jno.|Jno|Joh.|Joh|John' +#13#10+
    'bqChaptersCount43=21' +#13#10+
    'bqBibleBook44=����.|����|���.|���|�.�.|������|Ac.|Ac|Act.|Act|Acts' +#13#10+
    'bqChaptersCount44=28' +#13#10+
    'bqBibleBook45=���.|���|��.|��|�����|������|Jas.|Jas|Ja.|Ja|Jam.|Jam|Jms.|Jms|James' +#13#10+
    'bqChaptersCount45=5' +#13#10+
    'bqBibleBook46=1���.|1���|1��.|1��|1���.|1���|1����.|1����|1�����|1Pe.|1Pe|1Pet.|1Pet|1Peter' +#13#10+
    'bqChaptersCount46=5' +#13#10+
    'bqBibleBook47=2���.|2���|2��.|2��|2���.|2���|2����.|2����|2�����|2Pe.|2Pe|2Pet.|2Pet|2Peter' +#13#10+
    'bqChaptersCount47=3' +#13#10+
    'bqBibleBook48=1����.|1����|1��.|1��|1�����|1������|1Jn.|1Jn|1Jo.|1Jo|1Joh.|1Joh|1Jno.|1Jno|1John' +#13#10+
    'bqChaptersCount48=5' +#13#10+
    'bqBibleBook49=2����.|2����|2��.|2��|2�����|2������|2Jn.|2Jn|2Jo.|2Jo|2Joh.|2Joh|2Jno.|2Jno|2John' +#13#10+
    'bqChaptersCount49=1' +#13#10+
    'bqBibleBook50=3����.|3����|3��.|3��|3�����|3������|3Jn.|3Jn|3Jo.|3Jo|3Joh.|3Joh|3Jno.|3Jno|3John' +#13#10+
    'bqChaptersCount50=1' +#13#10+
    'bqBibleBook51=���.|���|��.|��|����|����|Jud.|Jud|Jude|Jd.|Jd' +#13#10+
    'bqChaptersCount51=1' +#13#10+
    'bqBibleBook52=���.|���|����.|����|��������|Ro.|Ro|Rom.|Rom|Romans' +#13#10+
    'bqChaptersCount52=16' +#13#10+
    'bqBibleBook53=1���.|1���|1������.|1������|1����������|1����������|1Co.|1Co|1Cor.|1Cor|1Corinth.|1Corinth|1Corinthians' +#13#10+
    'bqChaptersCount53=16' +#13#10+
    'bqBibleBook54=2���.|2���|2������.|2������|2����������|2����������|2Co.|2Co|2Cor.|2Cor|2Corinth.|2Corinth|2Corinthians' +#13#10+
    'bqChaptersCount54=13' +#13#10+
    'bqBibleBook55=���.|���|�����.|�����|�������|Ga.|Ga|Gal.|Gal|Galat.|Galat|Galatians' +#13#10+
    'bqChaptersCount55=6' +#13#10+
    'bqBibleBook56=��.|��|����.|����|��������|Eph.|Eph|Ep.|Ep|Ephes.|Ephes|Ephesians' +#13#10+
    'bqChaptersCount56=6' +#13#10+
    'bqBibleBook57=���.|���|���.|���|�����.|�����|�����������|Php.|Php|Ph.|Ph|Phil.|Phil|Phi.|Phi.|Philip.|Philip|Philippians' +#13#10+
    'bqChaptersCount57=4' +#13#10+
    'bqBibleBook58=���.|���|�����.|�����|����������|Col.|Col|Colos.|Colos|Colossians' +#13#10+
    'bqChaptersCount58=4' +#13#10+
    'bqBibleBook59=1����.|1����|1���.|1���|1���������������|1���.|1���|1���������|1Th.|1Th|1Thes.|1Thes|1Thess.|1Thess|1Thessalonians' +#13#10+
    'bqChaptersCount59=5' +#13#10+
    'bqBibleBook60=2����.|2����|2���.|2���|2���������������|2���.|2���|2���������|2Th.|2Th|2Thes.|2Thes|2Thess.|2Thess|2Thessalonians' +#13#10+
    'bqChaptersCount60=3' +#13#10+
    'bqBibleBook61=1���.|1���||1�����.|1�����|1�������|1Ti.|1Ti|1Tim.|1Tim|1Timothy' +#13#10+
    'bqChaptersCount61=6' +#13#10+
    'bqBibleBook62=2���.|2���|2�����.|2�����|2�������|2Ti.|2Ti|2Tim.|2Tim|2Timothy' +#13#10+
    'bqChaptersCount62=4' +#13#10+
    'bqBibleBook63=���.|���|����|Tit.|Tit|Ti.|Ti|Titus' +#13#10+
    'bqChaptersCount63=3' +#13#10+
    'bqBibleBook64=���.|���|�������.|�������|��������|Phm.|Phm|Phile.|Phile|Phlm.|Phlm|Philemon' +#13#10+
    'bqChaptersCount64=1' +#13#10+
    'bqBibleBook65=���.|���|������|He.|He|Heb.|Heb|Hebr.|Hebr|Hebrews' +#13#10+
    'bqChaptersCount65=13' +#13#10+
    'bqBibleBook66=����.|����|���.|���|��������.|��������|����.|����|����������|�����������|Rev.|Rev|Re.|Re|Rv.|Rv|Revelation' +#13#10+
    'bqChaptersCount66=22' +#13#10;

implementation

end.
