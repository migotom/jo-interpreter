#!perl -T

use strict;
use warnings;

use Test::More;
use Test::Exception;

use Data::Dumper;

use Jo::Token;
use Jo::Lexer;

BEGIN {
	use_ok('Jo::Parser');
}

sub init_tokens {
	my ($input) = shift;
        my $lexer = Jo::Lexer->new( input => $input );

        $lexer->analyze;
	return $lexer->tokens;
}

sub parse {
	my ($input) = shift;
	my $parser = Jo::Parser->new( tokens => init_tokens($input) );
	return $parser->parse;
}

my ($tokens,$parser);
# consume token

$tokens = init_tokens('{ print(ala); }');
$parser = Jo::Parser->new( tokens => $tokens);
lives_ok(sub { $parser->consume($Jo::Token::Types{LEFT_CURLY_BRACKET}); });
lives_ok(sub { $parser->consume($Jo::Token::Types{IDENTIFIER}); });
lives_ok(sub { $parser->consume($Jo::Token::Types{LEFT_BRACKET}); });
lives_ok(sub { $parser->consume($Jo::Token::Types{IDENTIFIER}); });
lives_ok(sub { $parser->consume($Jo::Token::Types{RIGHT_BRACKET}); });
lives_ok(sub { $parser->consume($Jo::Token::Types{SEMICOLON}); });
dies_ok(sub { $parser->consume($Jo::Token::Types{IDENTIFIER}); }, 'waiting for RIGHT_CURLY_BRACKET');

# consume block and statement

$tokens = init_tokens('{ print(ala); }');
$parser = Jo::Parser->new( tokens => $tokens);

lives_ok(sub { $parser->consume($Jo::Token::Types{LEFT_CURLY_BRACKET})});
my @block = $parser->block;
is($block[0]->full_name,'Jo::AST::Print');

# full parse

is(parse('{ }')->full_name,'Jo::AST::Block');


done_testing();


