use v6;

use Jo::AST::Node;

class Jo::Actions {
  method TOP($/) {
    make $<block>.made;
  }

  method block($/) {
    make Jo::AST::Node::Block.new(block => $<statement>>>.made);
  }

  # statements

  method statement:sym<if>($/) {
    make $<condition>.made;
  }
  method statement:sym<print>($/) {
    make Jo::AST::Node::Print.new(value => $<identifier>);
  }

  # conditions

  method condition:sym<if>($/) {
    make Jo::AST::Node::If.new(expression => $<expression>.made, block => $<block>.made, condition => $<condition>.made);
  }

  method condition:sym<elsif>($/) {
    make Jo::AST::Node::If.new(expression => $<expression>.made, block => $<block>.made, condition => $<condition>.made);
  }

  method condition:sym<else>($/) {
    make Jo::AST::Node::If.new(block => $<block>.made);
  }

  # expression

  method expression($/) {
    make ($<logical-operator> ?? Jo::AST::Node::LogicalOperator.new(lhs => $<factor>[0].made, rhs => $<factor>[1].made, operator => $<logical-operator>) !! $<factor>[0].made);
  }

  # term

  method term:sym<true>($/) {
    make Jo::AST::Node::Bool.new(value => True);
  }

  method term:sym<false>($/) {
    make Jo::AST::Node::Bool.new(value => False);;
  }

  # factor

  method factor:sym<term>($/) {
    make $<term>.made;
  }

  method factor:sym<expression>($/) {
    make $<expression>.made;
  }

}
