﻿unit BibleQuoteConfig;

interface

const
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
  C__bqAutoBible: string = '_bqAutoBible';

const
  C_TagRenameError: string =
    'Cannot rename tag, another on with same name already exists';

  C_StrongBibleNotDefined: string =
    'To perform a search, select the module with Strong''s lexicons in the settings.';

  C_bqError: string = 'Error';

  c_BibleBooks: string =
    'bqBibleBook1=Быт.|Быт|Бт.|Бт|Бытие|Ge.|Ge|Gen.|Gen|Gn.|Gn|Genesis' +#13#10+
    'bqChaptersCount1=50' +#13#10+
    'bqBibleBook2=Исх.|Исх|Исход|Ex.|Ex|Exo.|Exo|Exod.|Exod|Exodus' +#13#10+
    'bqChaptersCount2=40' +#13#10+
    'bqBibleBook3=Лев.|Лев|Лв.|Лв|Левит|Lev.|Lev|Le.|Le|Lv.|Lv|Levit.|Levit|Leviticus' +#13#10+
    'bqChaptersCount3=27' +#13#10+
    'bqBibleBook4=Чис.|Чис|Чс.|Чс|Числ.|Числ|Числа|Nu.|Nu|Num.|Num|Nm.|Nm|Numb.|Numb|Numbers' +#13#10+
    'bqChaptersCount4=36' +#13#10+
    'bqBibleBook5=Втор.|Втор|Вт.|Вт|Втрзк.|Втрзк|Второзаконие|De.|De|Deut.|Deut|Deu.|Deu|Dt.|Dt||Deuteron.|Deuteron|Deuteronomy' +#13#10+
    'bqChaptersCount5=34' +#13#10+
    'bqBibleBook6=Иис.Нав.|Иис.Нав|Нав.|Нав|Иисус|Навин|Jos.|Jos|Josh.|Josh|Joshua' +#13#10+
    'bqChaptersCount6=24' +#13#10+
    'bqBibleBook7=Суд.|Суд|Сд.|Сд|Судьи|Jdg.|Jdg|Judg.|Judg|Judge.|Judge|Judges' +#13#10+
    'bqChaptersCount7=21' +#13#10+
    'bqBibleBook8=Руф.|Руф|Рф.|Рф|Руфь|Ru.|Ru|Ruth|Rth.|Rth|Rt.|Rt' +#13#10+
    'bqChaptersCount8=4' +#13#10+
    'bqBibleBook9=1Цар.|1Цар|1Цр.|1Цр|1Ц|1Царств.|1Царств|1Sa.|1Sa|1S.|1S|1Sam.|1Sam|1Sm.|1Sm|1Sml.|1Sml|1Samuel' +#13#10+
    'bqChaptersCount9=31' +#13#10+
    'bqBibleBook10=2Цар.|2Цар|2Цр.|2Цр|2Ц|2Царств.|2Царств|2Sa.|2Sa|2S.|2S|2Sam.|2Sam|2Sm.|2Sm|2Sml.|2Sml|2Samuel' +#13#10+
    'bqChaptersCount10=24' +#13#10+
    'bqBibleBook11=3Цар.|3Цар|3Цр.|3Цр|3Ц|3Царств.|3Царств|1Ki.|1Ki|1K.|1K|1Kn.|1Kn|1Kg.|1Kg|1King.|1King|1Kng.|1Kng|1Kings' +#13#10+
    'bqChaptersCount11=22' +#13#10+
    'bqBibleBook12=4Цар.|4Цар|4Цр.|4Цр|4Ц|4Царств.|4Царств|2Ki.|2Ki|2K.|2K|2Kn.|2Kn|2Kg.|2Kg|2King.|2King|2Kng.|2Kng|2Kings' +#13#10+
    'bqChaptersCount12=25' +#13#10+
    'bqBibleBook13=1Пар.|1Пар|1Пр.|1Пр|1Chr.|1Chr|1Ch.|1Ch|1Chron.|1Chron' +#13#10+
    'bqChaptersCount13=26' +#13#10+
    'bqBibleBook14=2Пар.|2Пар|2Пр.|2Пр|2Chr.|2Chr|2Ch.|2Ch|2Chron.|2Chron' +#13#10+
    'bqChaptersCount14=36' +#13#10+
    'bqBibleBook15=Ездр.|Ездр|Езд.|Езд|Ез.|Ез|Ездра|Ezr.|Ezr|Ezra' +#13#10+
    'bqChaptersCount15=10' +#13#10+
    'bqBibleBook16=Неем.|Неем.|Нм.|Нм|Неемия|Ne.|Ne|Neh.|Neh|Nehem.|Nehem|Nehemiah' +#13#10+
    'bqChaptersCount16=13' +#13#10+
    'bqBibleBook17=Есф.|Есф|Ес.|Ес|Есфирь|Esth.|Esth|Est.|Est|Esther' +#13#10+
    'bqChaptersCount17=10' +#13#10+
    'bqBibleBook18=Иов.|Иов|Ив.|Ив|Job.|Job|Jb.|Jb' +#13#10+
    'bqChaptersCount18=42' +#13#10+
    'bqBibleBook19=Пс.|Пс|Псалт.|Псалт|Псал.|Псал|Псл.|Псл|Псалом|Псалтирь|Псалмы|Ps.|Ps|Psa.|Psa|Psal.|Psal|Psalm|Psalms' +#13#10+
    'bqChaptersCount19=150' +#13#10+
    'bqBibleBook20=Прит.|Прит|Притч.|Притч|Пр.|Пр|Притчи|Притча|Pr.|Pr|Prov.|Prov|Pro.|Pro|Proverb|Proverbs' +#13#10+
    'bqChaptersCount20=31' +#13#10+
    'bqBibleBook21=Еккл.|Еккл|Ек.|Ек|Екк.|Екк|Екклесиаст|Ec.|Ec|Eccl.|Eccl|Ecc.|Ecc|Ecclesia.|Ecclesia' +#13#10+
    'bqChaptersCount21=12' +#13#10+
    'bqBibleBook22=Песн.|Песн|Пес.|Пес|Псн.|Псн|Песн.Песней|Песни|Song.|Song|Songs|SS.|SS|Sol.|Sol' +#13#10+
    'bqChaptersCount22=8' +#13#10+
    'bqBibleBook23=Ис.|Ис|Иса.|Иса|Исаия|Исайя|Isa.|Isa|Is.|Is|Isaiah' +#13#10+
    'bqChaptersCount23=66' +#13#10+
    'bqBibleBook24=Иер.|Иер|Иерем.|Иерем|Иеремия|Je.|Je|Jer.|Jer|Jerem.|Jerem|Jeremiah' +#13#10+
    'bqChaptersCount24=52' +#13#10+
    'bqBibleBook25=Плач.|Плач|Плч.|Плч|Пл.|Пл|Пл.Иер.|Пл.Иер|Плач|Иеремии|La.|La|Lam.|Lam|Lament.|Lament|Lamentation|Lamentations' +#13#10+
    'bqChaptersCount25=5' +#13#10+
    'bqBibleBook26=Иез.|Иез|Из.|Из|Иезек.|Иезек|Иезекииль|Ez.|Ez|Eze.|Eze|Ezek.|Ezek|Ezekiel' +#13#10+
    'bqChaptersCount26=48' +#13#10+
    'bqBibleBook27=Дан.|Дан|Дн.|Дн|Днл.|Днл|Даниил|Da.|Da|Dan.|Dan|Daniel' +#13#10+
    'bqChaptersCount27=14' +#13#10+
    'bqBibleBook28=Ос.|Ос|Осия|Hos.|Hos|Ho.|Ho|Hosea' +#13#10+
    'bqChaptersCount28=14' +#13#10+
    'bqBibleBook29=Иоил.|Иоил|Ил.|Ил|Иоиль|Joel.|Joel|Joe.|Joe' +#13#10+
    'bqChaptersCount29=3' +#13#10+
    'bqBibleBook30=Ам.|Ам|Амс.|Амс|Амос|Am.|Am|Amos|Amo.|Amo' +#13#10+
    'bqChaptersCount30=9' +#13#10+
    'bqBibleBook31=Авд.|Авд|Авдий|Ob.|Ob|Obad.|Obad.|Obadiah|Oba.|Oba' +#13#10+
    'bqChaptersCount31=1' +#13#10+
    'bqBibleBook32=Ион.|Ион.|Иона|Jon.|Jon|Jnh.|Jnh.|Jona.|Jona|Jonah' +#13#10+
    'bqChaptersCount32=4' +#13#10+
    'bqBibleBook33=Мих.|Мих|Мх.|Мх|Михей|Mi.|Mi|Mic.|Mic|Micah' +#13#10+
    'bqChaptersCount33=7' +#13#10+
    'bqBibleBook34=Наум.|Наум|Na.|Na|Nah.|Nah|Nahum' +#13#10+
    'bqChaptersCount34=3' +#13#10+
    'bqBibleBook35=Авв.|Авв|Аввак.|Аввак|Аввакум|Hab.|Hab|Habak.|Habak|Habakkuk' +#13#10+
    'bqChaptersCount35=3' +#13#10+
    'bqBibleBook36=Соф.|Соф|Софон.|Софон|Софония|Zeph.|Zeph||Zep.|Zep|Zephaniah' +#13#10+
    'bqChaptersCount36=3' +#13#10+
    'bqBibleBook37=Агг.|Агг|Аггей|Hag.|Hag|Haggai' +#13#10+
    'bqChaptersCount37=2' +#13#10+
    'bqBibleBook38=Зах.|Зах|Зхр.|Зхр|Захар.|Захар|Захария|Ze.|Ze|Zec.|Zec|Zech.|Zech|Zechariah' +#13#10+
    'bqChaptersCount38=14' +#13#10+
    'bqBibleBook39=Мал.|Мал|Малах.|Малах|Млх.|Млх|Малахия|Mal.|Mal|Malachi' +#13#10+
    'bqChaptersCount39=4' +#13#10+
    'bqBibleBook40=Матф.|Матф|Мтф.|Мтф|Мф.|Мф|Мт.|Мт|Матфея|Матфей|Мат|Мат.|Mt.|Mt|Ma.|Ma|Matt.|Matt|Mat.|Mat|Matthew' +#13#10+
    'bqChaptersCount40=28' +#13#10+
    'bqBibleBook41=Мар.|Мар|Марк.|Марк|Мрк.|Мрк|Мр.|Мр|Марка|Мк|Мк.|Mk.|Mk|Mar.|Mar|Mr.|Mr|Mrk.|Mrk|Mark' +#13#10+
    'bqChaptersCount41=16' +#13#10+
    'bqBibleBook42=Лук.|Лук|Лк.|Лк|Лукa|Луки|Lk.|Lk|Lu.|Lu|Luk.|Luk|Luke' +#13#10+
    'bqChaptersCount42=24' +#13#10+
    'bqBibleBook43=Иоан.|Иоан|Ин.|Ин|Иоанн|Иоанна|Jn.|Jn|Jno.|Jno|Joh.|Joh|John' +#13#10+
    'bqChaptersCount43=21' +#13#10+
    'bqBibleBook44=Деян.|Деян|Дея.|Дея|Д.А.|Деяния|Ac.|Ac|Act.|Act|Acts' +#13#10+
    'bqChaptersCount44=28' +#13#10+
    'bqBibleBook45=Иак.|Иак|Ик.|Ик|Иаков|Иакова|Jas.|Jas|Ja.|Ja|Jam.|Jam|Jms.|Jms|James' +#13#10+
    'bqChaptersCount45=5' +#13#10+
    'bqBibleBook46=1Пет.|1Пет|1Пт.|1Пт|1Птр.|1Птр|1Петр.|1Петр|1Петра|1Pe.|1Pe|1Pet.|1Pet|1Peter' +#13#10+
    'bqChaptersCount46=5' +#13#10+
    'bqBibleBook47=2Пет.|2Пет|2Пт.|2Пт|2Птр.|2Птр|2Петр.|2Петр|2Петра|2Pe.|2Pe|2Pet.|2Pet|2Peter' +#13#10+
    'bqChaptersCount47=3' +#13#10+
    'bqBibleBook48=1Иоан.|1Иоан|1Ин.|1Ин|1Иоанн|1Иоанна|1Jn.|1Jn|1Jo.|1Jo|1Joh.|1Joh|1Jno.|1Jno|1John' +#13#10+
    'bqChaptersCount48=5' +#13#10+
    'bqBibleBook49=2Иоан.|2Иоан|2Ин.|2Ин|2Иоанн|2Иоанна|2Jn.|2Jn|2Jo.|2Jo|2Joh.|2Joh|2Jno.|2Jno|2John' +#13#10+
    'bqChaptersCount49=1' +#13#10+
    'bqBibleBook50=3Иоан.|3Иоан|3Ин.|3Ин|3Иоанн|3Иоанна|3Jn.|3Jn|3Jo.|3Jo|3Joh.|3Joh|3Jno.|3Jno|3John' +#13#10+
    'bqChaptersCount50=1' +#13#10+
    'bqBibleBook51=Иуд.|Иуд|Ид.|Ид|Иуда|Иуды|Jud.|Jud|Jude|Jd.|Jd' +#13#10+
    'bqChaptersCount51=1' +#13#10+
    'bqBibleBook52=Рим.|Рим|Римл.|Римл|Римлянам|Ro.|Ro|Rom.|Rom|Romans' +#13#10+
    'bqChaptersCount52=16' +#13#10+
    'bqBibleBook53=1Кор.|1Кор|1Коринф.|1Коринф|1Коринфянам|1Коринфянам|1Co.|1Co|1Cor.|1Cor|1Corinth.|1Corinth|1Corinthians' +#13#10+
    'bqChaptersCount53=16' +#13#10+
    'bqBibleBook54=2Кор.|2Кор|2Коринф.|2Коринф|2Коринфянам|2Коринфянам|2Co.|2Co|2Cor.|2Cor|2Corinth.|2Corinth|2Corinthians' +#13#10+
    'bqChaptersCount54=13' +#13#10+
    'bqBibleBook55=Гал.|Гал|Галат.|Галат|Галатам|Ga.|Ga|Gal.|Gal|Galat.|Galat|Galatians' +#13#10+
    'bqChaptersCount55=6' +#13#10+
    'bqBibleBook56=Еф.|Еф|Ефес.|Ефес|Ефесянам|Eph.|Eph|Ep.|Ep|Ephes.|Ephes|Ephesians' +#13#10+
    'bqChaptersCount56=6' +#13#10+
    'bqBibleBook57=Фил.|Фил|Флп.|Флп|Филип.|Филип|Филиппийцам|Php.|Php|Ph.|Ph|Phil.|Phil|Phi.|Phi.|Philip.|Philip|Philippians' +#13#10+
    'bqChaptersCount57=4' +#13#10+
    'bqBibleBook58=Кол.|Кол|Колос.|Колос|Колоссянам|Col.|Col|Colos.|Colos|Colossians' +#13#10+
    'bqChaptersCount58=4' +#13#10+
    'bqBibleBook59=1Фесс.|1Фесс|1Фес.|1Фес|1Фессалоникийцам|1Сол.|1Сол|1Солунянам|1Th.|1Th|1Thes.|1Thes|1Thess.|1Thess|1Thessalonians' +#13#10+
    'bqChaptersCount59=5' +#13#10+
    'bqBibleBook60=2Фесс.|2Фесс|2Фес.|2Фес|2Фессалоникийцам|2Сол.|2Сол|2Солунянам|2Th.|2Th|2Thes.|2Thes|2Thess.|2Thess|2Thessalonians' +#13#10+
    'bqChaptersCount60=3' +#13#10+
    'bqBibleBook61=1Тим.|1Тим||1Тимоф.|1Тимоф|1Тимофею|1Ti.|1Ti|1Tim.|1Tim|1Timothy' +#13#10+
    'bqChaptersCount61=6' +#13#10+
    'bqBibleBook62=2Тим.|2Тим|2Тимоф.|2Тимоф|2Тимофею|2Ti.|2Ti|2Tim.|2Tim|2Timothy' +#13#10+
    'bqChaptersCount62=4' +#13#10+
    'bqBibleBook63=Тит.|Тит|Титу|Tit.|Tit|Ti.|Ti|Titus' +#13#10+
    'bqChaptersCount63=3' +#13#10+
    'bqBibleBook64=Флм.|Флм|Филимон.|Филимон|Филимону|Phm.|Phm|Phile.|Phile|Phlm.|Phlm|Philemon' +#13#10+
    'bqChaptersCount64=1' +#13#10+
    'bqBibleBook65=Евр.|Евр|Евреям|He.|He|Heb.|Heb|Hebr.|Hebr|Hebrews' +#13#10+
    'bqChaptersCount65=13' +#13#10+
    'bqBibleBook66=Откр.|Откр|Отк.|Отк|Откровен.|Откровен|Апок.|Апок|Откровение|Апокалипсис|Rev.|Rev|Re.|Re|Rv.|Rv|Revelation' +#13#10+
    'bqChaptersCount66=22' +#13#10;

implementation

end.
