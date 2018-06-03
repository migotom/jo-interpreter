use v6;

use Test;
use lib 'lib';

use Jo::Grammar;

sub parse($input) {
  my $parsed = 0;
  try { Jo::Grammar.parse($input) and $parsed = 1 };
  return $parsed;
}

sub parse-ok($input) {
  ok parse($input), "Testing valid program '$input'";
}

sub parse-not($input) {
  not parse($input), "Testing invalid program '$input'";
}

# Grammar parsing test
#
my @valid =
  '{ print(ala); }',
  '{ print(ala); print(kota); }',
  '{ if(true) { print(ala); } }',
  '{ if(false) { print(ala); } else {print(kota);} }',
  '{ if(false or (false and true)) { print(ala); } else {print(kota);} }',

;

my @invalid = 
  '{}',
  'print(ala);',
  '{ print(ala) }',
  '{ printx(ala); }',
  '{ if(ala) { print(kota); } }'
;

for @valid -> $test {
  parse-ok $test;
}  

for @invalid -> $test {
  parse-not $test;
}

done-testing;


