:- use_module(library(plunit)).
:- ensure_loaded('../code/id_q2.pl').

:- begin_tests(p2).

% Each case gives the expected sorted equation strings and their count.
equation_case([4,2,5,3],
              ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
               "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"], 7).
equation_case([2,4,8], ["2*4=8"], 1).
equation_case([2,3,4], [], 0).
equation_case([], [], 0).
equation_case([5], [], 0).

test(generate_valid, [forall(equation_case(Numbers, [First|Rest], _))]) :-
    once(generate_equation(Numbers, Equation)),
    memberchk(Equation, [First|Rest]).

test(generate_impossible, [forall(equation_case(Numbers, [], _)), fail]) :-
    generate_equation(Numbers, _).

test(all_equations, [forall(equation_case(Numbers, Expected, _)),
                     true(Equations == Expected)]) :-
    all_equations(Numbers, Equations).

test(count_equations, [forall(equation_case(Numbers, _, Expected)),
                       true(Count == Expected)]) :-
    count_equations(Numbers, Count).

test(exact_division_of_negative_operand, [true(Value == -2)]) :-
    apply_operator('/', -8, 4, Value).

test(inexact_division, [fail]) :-
    expression_tree([7,4], op('/', _, _), _).

test(zero_divisor, [fail]) :-
    expression_tree([8,0], op('/', _, _), _).

test(right_child_with_equal_precedence, [true(Texts == ["1+(2+3)"])]) :-
    Tree = op('+', num(1), op('+', num(2), num(3))),
    findall(Text, expression_text(Tree, Text, _), Texts).

:- end_tests(p2).
