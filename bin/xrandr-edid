#!/bin/bash
# http://stackoverflow.com/a/18245494/239657
xrandr --verbose | perl -ne '
if (/^(\w+) connected /) {
  $output = $1;
}
if ((/EDID(_DATA)?:/.../:/) && !/:/) {
  s/^\s+//;
  chomp;
  $hex .= $_;
} elsif ($hex) {
  print $output;
  # Use "|strings" if you dont have read-edid package installed
  # and just want to see (or grep) the human-readable parts.
  open FH, "|parse-edid";
  print FH pack("H*", $hex);
  $hex = "";
}'
