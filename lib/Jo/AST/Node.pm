use v6;

class Jo::AST::Node {
  method run {
    die "Not implemented";
  }
}

class Jo::AST::Node::Block is Jo::AST::Node {
  has @.block;

  method run {
    @.block>>.run;
  }
} 

class Jo::AST::Node::Print is Jo::AST::Node {
  has $.value;

  method run {
    print $.value;
  }
}

class Jo::AST::Node::If is Jo::AST::Node {
  has $.expression;
  has $.condition;
  has @.block;

  method run {
    if $.expression {
      # if
      if $.expression.run == True {
        @.block>>.run;
      } elsif ($.condition) {
        # elsif
        $.condition.run;
      }
    } else {
      # else
      @.block>>.run;
    }
  }
}

class Jo::AST::Node::Bool is Jo::AST::Node {
  has $.value;

  method run {
    return $.value;
  }
}

class Jo::AST::Node::LogicalOperator is Jo::AST::Node {
  has $.lhs;
  has $.rhs;
  has $.operator;

  method run {
    given $.operator {
      when 'and' { return Jo::AST::Node::Bool.new(value => ($.lhs.run and $.rhs.run)).run }
      when 'or'  { return Jo::AST::Node::Bool.new(value => ($.lhs.run or $.rhs.run)).run }
      default    { die; }        
    }
  }
}
