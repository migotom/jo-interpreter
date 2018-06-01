package Jo::AST::Block;
use Moo;

extends 'Jo::AST::Node';

has block => ( is => 'rw', default => sub { [] } );

1;

