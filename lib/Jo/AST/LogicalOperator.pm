package Jo::AST::LogicalOperator;
use Moo;

extends 'Jo::AST::Node';

has lhs => ( is => 'rw' );
has rhs => ( is => 'rw' );
has operator => ( is => 'rw' );

1;

