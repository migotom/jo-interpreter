package Jo::Lexer;
use Moo;

use Jo::Token;

has input => ( is => 'rwp', default => '' );
has tokens => ( is => 'rwp', default => sub { [] } );

sub analyze {
  my ($self) = shift;


  my ($stream) = $self->input;
  $stream =~ s/\s+/ /g;

  $self->{line} = 0;
  while ($stream && $stream ne '') {
    if ($stream =~ s/\n//) {
      # skip newline
      $self->{line}++;
      next;
    };

    if ($stream =~ s/^([a-zA-Z0-9]+) ?//) {
      push @{$self->tokens}, Jo::Token->new(position => $self->position($stream), type => $Jo::Token::Types{IDENTIFIER}, attribute => $1);
      next;
    };
    if ($stream =~ s/^\( ?//) {
      push @{$self->tokens}, Jo::Token->new(position => $self->position($stream), type => $Jo::Token::Types{LEFT_BRACKET});
      next;
    }
    if ($stream =~ s/^\) ?//) {
      push @{$self->tokens}, Jo::Token->new(position => $self->position($stream), type => $Jo::Token::Types{RIGHT_BRACKET});
      next;
    }
    if ($stream =~ s/^\{ ?//) {
      push @{$self->tokens}, Jo::Token->new(position => $self->position($stream), type => $Jo::Token::Types{LEFT_CURLY_BRACKET});
      next;
    }
    if ($stream =~ s/^\} ?//) {
      push @{$self->tokens}, Jo::Token->new(position => $self->position($stream), type => $Jo::Token::Types{RIGHT_CURLY_BRACKET});
      next;
    }
    if ($stream =~ s/^; ?//) {
      push @{$self->tokens}, Jo::Token->new(position => $self->position($stream), type => $Jo::Token::Types{SEMICOLON});
      next;
    }

    die "Unexpected character at: '$stream'\n";
  }
}

sub position {
  my ($self, $stream) = @_;
  return { line => $self->{line}, fragment => substr($stream,0,30) };
}

1;
