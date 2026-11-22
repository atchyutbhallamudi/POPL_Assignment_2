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
