package Jo::AST::Node;
use Moo;

has token => ( is => 'rw' );

sub full_name {
  my ($self) = shift;
  return ref($self);
}

sub name {
  my ($self) = shift;
  my ($name) = ref($self) =~ /Jo::AST::(.*)/;
  return lc $name;
}
1;
