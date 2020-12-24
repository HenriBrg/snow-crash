#!/usr/bin/php
<?php

function y($m) {
    $m = preg_replace("/\./", " x ", $m);
    $m = preg_replace("/@/", " y", $m);
    return $m;
}

function x($y, $z) {
    // $a = file_get_contents($y);
    $a = $y;
    $a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a); # Match ce pattern précis (sans les quotes) : '[x ]' donc faudrait un truc du style [x rm -rf /]
    $a = preg_replace("/\[/", "(", $a); # --> Useless
    $a = preg_replace("/\]/", ")", $a); # --> Useless
    return $a;
}

$r = x($argv[1], $argv[2]);
print $r;

# https://www.guru99.com/php-regular-expressions.html#4

# \	Used to escape meta characters

?>
