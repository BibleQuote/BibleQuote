<?php

error_reporting(E_ALL);

if ($argc != 3) {
  exit("Usage: php make-idx.php dict.htm dict.idx\n");
}

$htm_file = $argv[1];
$idx_file = $argv[2];

$lines = file($htm_file);
$count = count($lines);
$fp = fopen($idx_file, "w");
$offset = 2; // first two bytes do not count (Unicode)

for($i=0; $i<$count; $i++) {
  $s = mb_convert_encoding($lines[$i], "windows-1251", "ucs-2be");
  if(substr($s,0,5)=="?<h4>") $s = substr($s,1); // fix first line like this;

  if(substr($s,0,4)=='<h4>') {
    $word = strip_tags(trim($s));
    fputs($fp, $word."\r\n".$offset."\r\n");
  }
  $offset += mb_strlen($lines[$i], 'latin1'); //strlen($lines[$i]);
}

fclose($fp);
