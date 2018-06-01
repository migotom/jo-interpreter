package Jo::AST::Boolean;
use Moo;

use Carp qw/croak/;
use experimental 'switch';

extends 'Jo::AST::Node';

has value => ( is => 'rw' );

sub evaluate {
  my ($self) = shift;
  given(lc $self->value ) {
    return 1 when ('true');
    return 0 when ('false');

    default {
      croak("Jo::AST::Boolean incorrect value");
    }
  }
}

1;

