% apply_operator(+Operator, +Left, +Right, -Result)
% Holds when Result is the integer result, with division defined only when exact.
apply_operator('+', Left, Right, Result) :-
    Result is Left + Right.
apply_operator('-', Left, Right, Result) :-
    Result is Left - Right.
apply_operator('*', Left, Right, Result) :-
    Result is Left * Right.
apply_operator('/', Left, Right, Result) :-
    Right =\= 0,
    0 =:= Left rem Right,
    Result is Left // Right.

% expression_tree(+Numbers, -Tree, -Value)
% A singleton denotes a leaf with its own value. A node combines trees
% over two nonempty contiguous parts with a valid integer operation.
expression_tree([Number], num(Number), Number).
expression_tree(Numbers, op(Operator, LeftTree, RightTree), Value) :-
    append(LeftNumbers, RightNumbers, Numbers),
    LeftNumbers = [_|_],
    RightNumbers = [_|_],
    expression_tree(LeftNumbers, LeftTree, LeftValue),
    expression_tree(RightNumbers, RightTree, RightValue),
    apply_operator(Operator, LeftValue, RightValue, Value).

% expression_text(+Tree, -Text, -Precedence)
% A leaf renders as a decimal number. A node combines its rendered children
% with parentheses where their precedence and position require them.
expression_text(num(Number), Text, 3) :-
    number_string(Number, Text).
expression_text(op(Operator, LeftTree, RightTree), Text, Precedence) :-
    member(Operator-Precedence, ['+'-1, '-'-1, '*'-2, '/'-2]),
    expression_text(LeftTree, LeftText, LeftPrecedence),
    expression_text(RightTree, RightText, RightPrecedence),
    ( LeftPrecedence < Precedence ->
        format(string(LeftOperand), '(~s)', [LeftText])
    ;   LeftOperand = LeftText
    ),
    ( RightPrecedence =< Precedence ->
        format(string(RightOperand), '(~s)', [RightText])
    ;   RightOperand = RightText
    ),
    format(string(Text), '~s~a~s', [LeftOperand, Operator, RightOperand]).
