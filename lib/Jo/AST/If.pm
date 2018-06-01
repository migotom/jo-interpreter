package Jo::AST::If;
use Moo;

extends 'Jo::AST::Node';

has condition => ( is => 'rw' );
has block => ( is => 'rw', default => sub { [] } );
has child_node => ( is => 'rw' );

1;

