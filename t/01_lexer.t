#!perl -T

use strict;
use warnings;

use Test::More;
use Test::Exception;

use Data::Dumper;

BEGIN {
	use_ok('Jo::Lexer');
}

sub lex {
	my ($input) = shift;
	my $lexer = Jo::Lexer->new( input => $input );

	$lexer->analyze;

	return $lexer->tokens->[0]->show;
}

sub lex_stream {
	my ($input) = shift;
	my $lexer = Jo::Lexer->new( input => $input );

        $lexer->analyze;
	my $output;
	foreach my $token (@{$lexer->tokens}) {
		$output .= $token->show.';';
	}
	return $output;
}

# basic tokens

is(lex('('),'LEFT_BRACKET');
is(lex(')'),'RIGHT_BRACKET');
is(lex('{'),'LEFT_CURLY_BRACKET');
is(lex('}'),'RIGHT_CURLY_BRACKET');
is(lex(';'),'SEMICOLON');
throws_ok {lex('&') } qr/Unexpected character at: '\&'/;

# identifiers

is  (lex('ala'),'IDENTIFIER (ala)');
is  (lex('true'),'IDENTIFIER (true)');
is  (lex('false'),'IDENTIFIER (false)');
is  (lex('abc123'),'IDENTIFIER (abc123)');
throws_ok {lex('abc$') } qr/Unexpected character at: '\$'/;

# stream

is(lex_stream('{ print(ala); }'), 'LEFT_CURLY_BRACKET;IDENTIFIER (print);LEFT_BRACKET;IDENTIFIER (ala);RIGHT_BRACKET;SEMICOLON;RIGHT_CURLY_BRACKET;');
throws_ok { lex_stream('{ print($ala); }') } qr/Unexpected character at: '\$ala/;

done_testing();


