package Jo::AST::Boolean;
use Moo;

use experimental 'switch';

extends 'Jo::AST::Node';

has value => ( is => 'rw' );

sub eval {
  my ($self) = shift;
  given(lc $self->value ) {
    return 1 when ('true');
    return 0 when ('false');

    default {
      die("Jo::AST::Boolean incorrect value");
    }
  }
}

1;

