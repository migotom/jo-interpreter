package Jo::Parser;
use Moo;

use Data::Dumper;
use experimental 'switch';

use Jo::Token;
use Jo::AST::Node;
use Jo::AST::Block;
use Jo::AST::Print;
use Jo::AST::If;
use Jo::AST::Boolean;
use Jo::AST::LogicalOperator;

has tokens => ( is => 'rwp' );

sub parse {
  my ($self) = shift;

  return $self->run;
}

# consume one token and verify that consumed token is same as expected
#
sub consume {
  my ($self, $expectedTokenType) = @_;

  unless ($self->tokens && $self->tokens->[0]) {
    die("Missing token, expecting $expectedTokenType, line: ".$self->tokens->[0]->position->{line}.", >>".$self->tokens->[0]->position->{fragment}."<<");
  }

  if ($self->tokens->[0]->type eq $expectedTokenType) {
    $self->{lastToken} = shift @{$self->tokens};
    $self->{currentToken} = $self->tokens->[0];
  } else {
    die("Unexpected token type ".$self->tokens->[0]->type.", expecting $expectedTokenType, line: ".$self->tokens->[0]->position->{line}.", >>".$self->tokens->[0]->position->{fragment}."<<");
  }
}

# parse begening of program
# required block of code sorrounded by { }
#
sub run {
  my ($self) = shift;

  # main loop
  $self->consume($Jo::Token::Types{LEFT_CURLY_BRACKET});

  my $main_loop_node = Jo::AST::Block->new(token => $self->{currentToken});
  push @{$main_loop_node->block}, $self->block;
  return $main_loop_node;
}

# create array of statements inside block of code
#
sub block {
  my ($self) = shift;

  my @block_nodes;
  while($self->{currentToken}->type ne $Jo::Token::Types{RIGHT_CURLY_BRACKET}) {
    push @block_nodes, $self->statement;
  }
  $self->consume($Jo::Token::Types{RIGHT_CURLY_BRACKET});
  return @block_nodes;
}

# analyse type of statement
#
sub statement {
  my ($self) = shift;
  $self->consume($Jo::Token::Types{IDENTIFIER});

  given($self->{lastToken}->attribute) {
    return $self->st_print when (lc 'print');
    return $self->st_if when (lc 'if');
    default {
      die "Unexpected statement ".$self->{lastToken}->attribute.", line: ".$self->{lastToken}->position->{line}.", >>".$self->{lastToken}->position->{fragment}."<<";
    }
  }
}

sub st_print {
  my ($self) = shift;

  $self->consume($Jo::Token::Types{LEFT_BRACKET});
  $self->consume($Jo::Token::Types{IDENTIFIER});

  my $node = Jo::AST::Print->new( token => $self->{currentToken}, value => $self->{lastToken}->attribute);

  $self->consume($Jo::Token::Types{RIGHT_BRACKET});

  $self->consume($Jo::Token::Types{SEMICOLON});
  return $node;
}

# if statement, analyse condition expressions, block of code for valid expression and additional else/elsif statements
#
sub st_if {
  my ($self) = shift;

  my ($condition, $block, $child_node);

  # check condition
  $self->consume($Jo::Token::Types{LEFT_BRACKET});
  $condition = $self->condition;

  my $token = $self->{currentToken};
  # if true block
  $self->consume($Jo::Token::Types{LEFT_CURLY_BRACKET}); 
  $block = Jo::AST::Block->new(token => $self->{currentToken});
  push @{$block->block}, $self->block;

  # else/if blocks
  if ($self->{currentToken}->type eq $Jo::Token::Types{IDENTIFIER}) {
    $self->consume($Jo::Token::Types{IDENTIFIER});

    # looking for elsif/else statements
    if($self->{lastToken}->attribute eq lc 'elsif') {
      $child_node = $self->st_if;
    } elsif ($self->{lastToken}->attribute eq lc 'else') {
      $self->consume($Jo::Token::Types{LEFT_CURLY_BRACKET});
      $child_node = Jo::AST::Block->new(token => $self->{currentToken});
      push @{$child_node->block}, $self->block;
    }
  }

  return Jo::AST::If->new( token => $token, condition => $condition, block => $block, child_node => $child_node);
}

# check single factor: expression or boolean value
#
sub factor {
  my ($self) = shift;
  if ($self->{currentToken}->type eq $Jo::Token::Types{LEFT_BRACKET}) {
    # expression
    $self->consume($Jo::Token::Types{LEFT_BRACKET});
    return $self->expression;
  } elsif ($self->{currentToken}->type eq $Jo::Token::Types{IDENTIFIER} && lc($self->{currentToken}->attribute) ~~ ['true','false']) {
    $self->consume($Jo::Token::Types{IDENTIFIER});
    # boolean value
    return Jo::AST::Boolean->new( token => $self->{currentToken}, value => lc($self->{lastToken}->attribute))
  } else {
    die("Jo::Parser->factor syntax error , line: ".$self->{currentToken}->position->{line}.", >>".$self->{currentToken}->position->{fragment}."<<");
  }
}

sub condition {
  my ($self) = shift;
  return $self->expression;
}

sub expression {
  my ($self) = shift;
  my $node = $self->factor;

  if ($self->{currentToken}->type eq $Jo::Token::Types{IDENTIFIER} && lc($self->{currentToken}->attribute) ~~ ['and','or']) {
    my $op = lc $self->{currentToken}->attribute;
    $self->consume($Jo::Token::Types{IDENTIFIER});
    $node = Jo::AST::LogicalOperator->new(token => $self->{currentToken}, lhs => $node, rhs => $self->factor, operator => $op);
  }

  $self->consume($Jo::Token::Types{RIGHT_BRACKET});
  return $node;
}

1;
