package Jo;
use Moo;

our $VERSION = '0.1';


use Jo::Interpreter;

# Main live interpreter loop
#
sub input_loop {
  my ($self) = shift;

  my $program;
  while(my $line = <>) {
    # exit interpreter and execute
    last if $line =~ /^(die|quit|execute)$/ix;
    $program .= $line;
  }

  # evaluate program
  eval {
    my $interpreter = Jo::Interpreter->new;
    $interpreter->interpret($program);
    1;
  } or do {
    my $error = $@;
    print STDERR "Error: $error\n";
  };

  return;
}

1;
