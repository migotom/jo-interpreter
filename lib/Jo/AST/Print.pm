package Jo::AST::Print;
use Moo;

extends 'Jo::AST::Node';

has value => ( is => 'rw', default => '' );

1;

