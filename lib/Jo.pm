use v6;

unit module Jo;

our $VERSION = '0.1';


use Jo::Grammar;
use Jo::Actions;

# Main live interpreter loop
#
sub jo-repl is export {
  my $program;
  for $*IN.lines {
    # exit interpreter and execute
    last if $_ ~~ /^(die|quit|execute)$/;
    $program ~= $_;
  }

  try {
    my $parse = Jo::Grammar.parse($program, actions => Jo::Actions.new);
    $parse.made[0].run;
  } // say "Execution error!";

  return;
}
