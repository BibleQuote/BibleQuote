<?php

error_reporting(E_ALL);

$lines = file("greek.htm");
$count = count($lines);

$fp = fopen("greek.idx", "w");

//fputs($fp, mb_convert_encoding("Еврейский лексикон Стронга (с) Bob Jones University\r\n", "ucs-2be", "windows-1251"));
fputs($fp, "Греческий лексикон Стронга (с) Bob Jones University\r\n");

$offset = 2; // first two bytes do not count (Unicode)

for($i=0;$i<$count;$i++)
{
	$s = mb_convert_encoding($lines[$i], "windows-1251", "ucs-2be");
	if(substr($s,0,5)=="?<h4>") $s = substr($s,1); // fix first line like this;

	if(substr($s,0,4)=='<h4>')
	{
		$word = strip_tags(trim($s));
		fputs($fp, $word."\r\n".$offset."\r\n");
		//fputs($fp, mb_convert_encoding($word."\r\n".$offset."\r\n", "ucs-2be", "windows-1251"));
	}
	$offset += mb_strlen($lines[$i], 'latin1'); //strlen($lines[$i]);

}

fclose($fp);

