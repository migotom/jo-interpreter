#!perl -T

use strict;
use warnings;

use Test::More;
use Test::Exception;
use Test::Output;

use Data::Dumper;

use Jo::Token;
use Jo::Lexer;
use Jo::Parser;

BEGIN {
	use_ok('Jo::Interpreter');
}

sub jo {
	my ($input) = shift;
	my $interpreter = Jo::Interpreter->new;
 	return $interpreter->interpret($input);

}

# full parse

stdout_is { jo('{ print(ala); }')}  'ala';
stdout_is { jo('{print(ala); print(kot);}')} 'alakot';
stdout_is { jo('{if (true) { print(ala); } }')} 'ala';
stdout_is { jo('{if (false) { print(tomasz); } elsif ((true and false) or true) {print(ala); } elsif (false) { print(jan); } else { print(piotr); } }')} 'ala';
stdout_is { jo('{if (true) { print(ala); if (true) { print(ala); if (true) { print(ala); } } } }') } 'alaalaala';

throws_ok { jo('{if (false) { print(ala); } else { print}') } qr/Unexpected token type RIGHT_CURLY_BRACKET, expecting LEFT_BRACKET/;

done_testing();


