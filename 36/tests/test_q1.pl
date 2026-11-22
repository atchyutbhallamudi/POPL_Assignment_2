% Tests for P1 (code/36_q1.pl). Run from 36:
% swipl -q -s tests/test_q1.pl -g run_tests -t halt
% Expected values are worked out by hand, not computed by the code under test.
:- use_module(library(plunit)).
:- use_module(library(aggregate)).

:- begin_tests(q1).
:- consult('../code/36_q1.pl').

% clue_case(N, Expected, Sol)
% Sol is a full candidate on which clue N should hold (Expected = holds)
% or should not hold (Expected = fails).

% Clue 1: AI friend not in research and not Dana.
clue_case(1, holds, [p('Alex',design,python,'AI'), p('Ben',development,java,web),
                     p('Carla',research,'c++',embedded), p('Dana',testing,javascript,data)]).
clue_case(1, fails, [p('Alex',research,python,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',testing,javascript,data)]).
clue_case(1, fails, [p('Alex',research,python,web), p('Ben',development,java,embedded),
                     p('Carla',design,'c++',data), p('Dana',testing,javascript,'AI')]).

% Clue 2: Alex not in development and not c++.
clue_case(2, holds, [p('Alex',research,python,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',testing,javascript,data)]).
clue_case(2, fails, [p('Alex',development,python,'AI'), p('Ben',research,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',testing,javascript,data)]).
clue_case(2, fails, [p('Alex',research,'c++','AI'), p('Ben',development,java,web),
                     p('Carla',design,python,embedded), p('Dana',testing,javascript,data)]).

% Clue 3: testing friend likes python.
clue_case(3, holds, [p('Alex',research,javascript,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',testing,python,data)]).
clue_case(3, fails, [p('Alex',research,python,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',testing,javascript,data)]).

% Clue 4: Ben has web and is not in testing.
clue_case(4, holds, [p('Alex',research,python,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',testing,javascript,data)]).
clue_case(4, fails, [p('Alex',research,python,web), p('Ben',development,java,'AI'),
                     p('Carla',design,'c++',embedded), p('Dana',testing,javascript,data)]).
clue_case(4, fails, [p('Alex',research,python,'AI'), p('Ben',testing,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',development,javascript,data)]).

% Clue 5: java friend is in design.
clue_case(5, holds, [p('Alex',research,python,'AI'), p('Ben',design,java,web),
                     p('Carla',development,'c++',embedded), p('Dana',testing,javascript,data)]).
clue_case(5, fails, [p('Alex',research,python,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',testing,javascript,data)]).

% Clue 6: Carla not embedded and not in development.
clue_case(6, holds, [p('Alex',research,python,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',data), p('Dana',testing,javascript,embedded)]).
clue_case(6, fails, [p('Alex',research,python,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',testing,javascript,data)]).
clue_case(6, fails, [p('Alex',research,python,'AI'), p('Ben',design,java,web),
                     p('Carla',development,'c++',data), p('Dana',testing,javascript,embedded)]).

% Clue 7: Dana not java, and in research or testing.
clue_case(7, holds, [p('Alex',testing,python,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',research,javascript,data)]).
clue_case(7, holds, [p('Alex',research,python,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',testing,javascript,data)]).
clue_case(7, fails, [p('Alex',research,python,'AI'), p('Ben',development,javascript,web),
                     p('Carla',design,'c++',embedded), p('Dana',testing,java,data)]).
clue_case(7, fails, [p('Alex',research,python,'AI'), p('Ben',testing,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',development,javascript,data)]).

% Clue 8: data friend is in research and not javascript.
clue_case(8, holds, [p('Alex',testing,javascript,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',research,python,data)]).
clue_case(8, fails, [p('Alex',research,python,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',testing,javascript,data)]).
clue_case(8, fails, [p('Alex',testing,python,'AI'), p('Ben',development,java,web),
                     p('Carla',design,'c++',embedded), p('Dana',research,javascript,data)]).

% Clue 9: AI friend likes python. These are the three solutions of
% clues 1 to 8; only solution 2 should pass.
clue_case(9, holds, [p('Alex',design,java,embedded), p('Ben',development,javascript,web),
                     p('Carla',testing,python,'AI'), p('Dana',research,'c++',data)]).
clue_case(9, fails, [p('Alex',design,java,'AI'), p('Ben',development,javascript,web),
                     p('Carla',research,'c++',data), p('Dana',testing,python,embedded)]).
clue_case(9, fails, [p('Alex',testing,python,embedded), p('Ben',development,javascript,web),
                     p('Carla',design,java,'AI'), p('Dana',research,'c++',data)]).

% The four lines main/0 must print: the first solution of clues 1 to 8 in
% candidate order, checked by hand against the English clues.
expected_main_output(Expected) :-
    atomic_list_concat([ 'Alex = [design, java, AI]\n',
                         'Ben = [development, javascript, web]\n',
                         'Carla = [research, c++, data]\n',
                         'Dana = [testing, python, embedded]\n' ], Atom),
    atom_string(Atom, Expected).

% 24 orders of departments * 24 of languages * 24 of projects.
test(candidate_count) :-
    aggregate_all(count, candidate(_), N),
    assertion(N == 13824).

% Makes sure the test data itself is valid. candidate/1 and clue/2 may
% leave choice points (permutation/2, member/2), hence nondet.
test(clue_cases_are_candidates, [forall(clue_case(_, _, Sol)), nondet]) :-
    candidate(Sol).

test(clue_holds, [forall(clue_case(N, holds, Sol)), nondet]) :-
    clue(N, Sol).

test(clue_fails, [forall(clue_case(N, fails, Sol)), fail]) :-
    clue(N, Sol).

% An empty Active list checks no clue, so every candidate satisfies it,
% including ones that break some clue.
test(satisfies_empty, [forall(clue_case(_, _, Sol))]) :-
    satisfies([], Sol).

test(count_no_clues) :-
    count_solutions([], N),
    assertion(N == 13824).

test(count_clues_1_to_8) :-
    count_solutions([1,2,3,4,5,6,7,8], N),
    assertion(N == 3).

test(count_clues_1_to_9) :-
    count_solutions([1,2,3,4,5,6,7,8,9], N),
    assertion(N == 1).

test(main_prints_exact_lines) :-
    with_output_to(string(Out), main),
    expected_main_output(Expected),
    assertion(Out == Expected).

:- end_tests(q1).
