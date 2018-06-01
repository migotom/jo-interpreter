package Jo::Token;
use Moo;

our %Types = map { $_ => $_ } qw/IDENTIFIER LEFT_BRACKET RIGHT_BRACKET LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET SEMICOLON/;

has type => ( is => 'rwp' );
has attribute => (is => 'rwp' ); 
has position => (is => 'rwp' );

sub show {
  my ($self) = shift;
  return $self->type.($self->attribute ? " (${\$self->attribute})" : '');
}
1;
