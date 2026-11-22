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
