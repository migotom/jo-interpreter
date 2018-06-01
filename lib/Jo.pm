package Jo;
use Moo;

our $VERSION = '0.1';


use Jo::Interpreter;

# Main live interpreter loop
#
sub input_loop {
  my ($self) = shift;

  my $program;
  while(my $line = <STDIN>) {
    # exit interpreter and execute
    last if $line =~ /^(die|quit|execute)$/i;
    $program .= $line;
  }

  # evaluate program
  eval {
    my $interpreter = Jo::Interpreter->new;
    $interpreter->interpret($program);
  };

  # handle errors
  if ($@) {
    my $error = $@;
    print STDERR "Error: $error\n";
  }
}

1;
