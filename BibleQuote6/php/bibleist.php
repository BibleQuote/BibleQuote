<?

// heb = 1...8674 -- http://www.bibleist.ru/tmp/lexicon.php?strongid=1&lang=1&maxcount=10
// grk = 2...5944 -- http://www.bibleist.ru/tmp/lexicon.php?strongid=1&lang=2&maxcount=10

// <span class="lex_word_1">בּרא‎</span>
// <span class="lex_word_2">α, ἄλφα</span>

function get_word($num, $lang=1) {

	$matches = array();
	$s = file_get_contents("http://www.bibleist.ru/tmp/lexicon.php?strongid=$num&lang=$lang&maxcount=10");

//$s = "<span class=\"lex_strong\">1 &#x2014; </span> <span class=\"lex_word_1\">אָב‎</span>
//<p>отец, праотец, (родо)начальник, предок.</p>";

	$p1 = strpos($s, "<span class=\"lex_word_$lang\">");
	$s = substr($s, $p1 + strlen("<span class=\"lex_word_$lang\">"));
	$p2 = strpos($s, "</span>");
	$word = substr($s, 0, $p2);
	$p3 = strpos($s, "<input");
	$s =substr($s, 0, $p3);
	$text = substr($s, $p2 + strlen("</span>"));
	
	if(strlen($word))
		return "<h4>".sprintf("%05d",$num)."</h4>\r\n<b>$num, $word</b>\r\n".$text."\r\n\r\n";
	else
		return "";
}

//echo get_word(2);
//echo get_word(120);
//echo get_word(8674);

//echo get_word(4, 2);
//echo get_word(120, 2);

//for($i=1; $i<= 8674; $i++) echo get_word($i);
for($i=1; $i<= 5624; $i++) echo get_word($i, 2);
