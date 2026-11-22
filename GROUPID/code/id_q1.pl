:- use_module(library(lists)).

% candidate(-Sol)
% Sol is a list of four p(Name, Dept, Lang, Project) terms for Alex, Ben,
% Carla and Dana, in that order, where each department, each language and
% each project is given to exactly one friend. No clue is checked here.
% Each permutation/2 call picks one ordering of a value list, so no value
% repeats. Nondeterministic: on backtracking it gives all 24 * 24 * 24 =
% 13824 assignments, each exactly once.
candidate([p('Alex',  D1, L1, P1),
           p('Ben',   D2, L2, P2),
           p('Carla', D3, L3, P3),
           p('Dana',  D4, L4, P4)]) :-
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript], [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data], [P1, P2, P3, P4]).

% clue(+N, +Sol)
% Succeeds exactly when clue number N holds in Sol, where Sol is a fully
% filled-in candidate (every value bound). Each clue uses member/2 to find
% the one friend it talks about, then checks that friend's other values.
% Since every value is used exactly once, member/2 can match only one
% friend. == and \== compare without binding anything, so a clue only
% checks Sol and never fills it in.

% Clue 1: The friend who prefers the AI project does not work in research
% and is not Dana.
clue(1, Sol) :-
    member(p(Name, Dept, _, 'AI'), Sol),
    Dept \== research,
    Name \== 'Dana'.

% Clue 2: Alex does not work in development and does not prefer C++.
clue(2, Sol) :-
    member(p('Alex', Dept, Lang, _), Sol),
    Dept \== development,
    Lang \== 'c++'.

% Clue 3: The friend working in the testing department likes Python.
clue(3, Sol) :-
    member(p(_, testing, Lang, _), Sol),
    Lang == python.

% Clue 4: Ben prefers web projects and does not work in testing.
clue(4, Sol) :-
    member(p('Ben', Dept, _, Project), Sol),
    Project == web,
    Dept \== testing.
