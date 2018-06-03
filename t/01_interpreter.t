use v6;

use Test;
use lib 'lib';

use Jo::Grammar;
use Jo::Actions;

# capture STDOUT
#
my class IO::Bag {
  has @.out-contents;
  method out { @.out-contents.join: '' }
}

my class IO::Capture::Single is IO::Handle {
  has IO::Bag $.bag is required;

  method print-nl { self.print($.nl-out); }
  method print (*@what) {
    $.bag.out-contents.push: @what.join: '';
    True;
  }
}

# STDOUT checking test helper
#
sub stdout-is(&code, $expected) {
  my $bag = IO::Bag.new;
  my $out = IO::Capture::Single.new: :$bag;

  my $saved-out = $PROCESS::OUT;

  $PROCESS::OUT = $out;
  &code();
  $PROCESS::OUT = $saved-out;

  return is $bag.out, $expected;
}

# Jo parser
#
sub jo($program) {
  my $parse = Jo::Grammar.parse($program, actions => Jo::Actions.new);
  $parse.made[0].run;
}


# Required program logic tests

stdout-is { jo('{ print(ala); }')}, 'ala';
stdout-is { jo('{print(ala); print(kot);}')}, 'alakot';
stdout-is { jo('{if (true) { print(ala); } }')}, 'ala';
stdout-is { jo('{if (false) { print(tomasz); } elsif ((true and false) or true) {print(ala); } elsif (false) { print(jan); } else { print(piotr); } }')}, 'ala';
stdout-is { jo('{if (true) { print(ala); if (true) { print(ala); if (true) { print(ala); } } } }') }, 'alaalaala';

done-testing;


