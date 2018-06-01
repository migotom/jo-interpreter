package Jo::Interpreter;
use Moo;

use experimental 'switch';
use Carp qw/croak/;

use Jo::AST::Node;
use Jo::Lexer;
use Jo::Parser;

has lexer => ( is => 'rwp' );
has parser => ( is => 'rwp' );
has ast => ( is => 'rwp' );

my %driver = (
  block           => \&on_block,
  print           => \&on_print,
  if              => \&on_if,
  else            => \&on_else,
  boolean         => \&on_boolean,
  logicaloperator => \&on_logicaloperator,
);

# drive/visit AST node
#
sub drive {
  my ($node) = shift;
  return $driver{$node->name}->($node) if ($node);
  return;
}

# handle Jo::AST::Block
#
sub on_block {
  my ($node) = shift;
  my $value;
  foreach my $child (@{$node->block}) {
    $value = drive($child);
  }
  return $value;
}

# handle Jo::AST::Print
#
sub on_print {
  my ($node) = shift;
  return print($node->value);
}

# handle Jo::AST:If condition statement
#
sub on_if {
  my ($node) = shift;

  # evaluate conditions
  my $condition = drive($node->condition);

  if ($condition) {
    # true
    return drive($node->block);
  } else {
    # false
    return drive($node->child_node);
  }
}

# handle Jo::AST::Boolean value
#
sub on_boolean {
  my ($node) = shift;
  return $node->evaluate;
}

# handle Jo::AST::LogicalOperator 
#
sub on_logicaloperator {
  my ($node) = shift;
  my $lhs = drive($node->lhs);
  my $rhs = drive($node->rhs);

  given(lc $node->operator) {
    return ($lhs && $rhs) when ('and');
    return ($lhs || $rhs) when ('or');
    default {
      croak "Jo::Interpreter-on_logicaloperator incorrect logical operator";
    }
  }
  return;
}

# Main interpreter subrutine
# Analyse input text by Lexer, parse provided tokens into AST tree and run driver/visitor into root of tree
#
sub interpret {
  my ($self, $input) = @_;

  $self->_set_lexer(  Jo::Lexer->new( input => $input ) );
  $self->lexer->analyze;

  $self->_set_parser( Jo::Parser->new( tokens => $self->lexer->tokens ) );

  return drive( $self->parser->parse() );
}

1;
