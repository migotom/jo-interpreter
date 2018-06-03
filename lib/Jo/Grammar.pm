use v6;

grammar Jo::Grammar {
  token TOP                       { \s* <block> \s* }
  rule block                      { '{' <statement>+ '}' } 

  proto rule statement            {*}
  rule statement:sym<print>       { <sym> '(' <identifier> ')' ';' }
  rule statement:sym<if>          { <condition> }

  proto rule condition {*}
  rule condition:sym<if>          { <sym> <expression> \s* <block> <condition>? }
  rule condition:sym<elsif>       { <sym> <expression> \s* <block> <condition>? }
  rule condition:sym<else>        { <sym> <block> }

  rule expression                 { '(' <factor> [<logical-operator> <factor> ]? ')' }

  proto token term                {*}
  token term:sym<true>            { <sym> }
  token term:sym<false>           { <sym> }

  proto token factor              {*}
  token factor:sym<term>          { <term> }
  token factor:sym<expression>    { <expression> }

  proto token logical-operator    {*}
  token logical-operator:sym<and> { <sym> }
  token logical-operator:sym<or>  { <sym> }

  token identifier                { \w+ }
}
