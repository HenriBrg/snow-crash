#!/usr/bin/env perl
# localhost:4646
print "Content-type: text/html\n\n";

sub t {
  $nn = $_[1]; # var 2 : y
  $xx = $_[0]; # var 1 : x
  $xx =~ tr/a-z/A-Z/;  # remplace par maj
  $xx =~ s/\s.*//;     # Retire tout à droite d'un espace
  print("Arg = ${xx}");
  @output = `egrep "^$xx" /tmp/x 2>&1`;
  print join(", ", @output);

  foreach $line (@output) {
      ($f, $s) = split(/:/, $line);
      if($s =~ $nn) {
          return 1;
      }
  }
  return 0;
}

sub n {
  if($_[0] == 1) {
      print("..");
  } else {
      print(".");
  }    
}

# n(t(param("x"), param("y")));
n(t($ARGV[0], $ARGV[1]));

