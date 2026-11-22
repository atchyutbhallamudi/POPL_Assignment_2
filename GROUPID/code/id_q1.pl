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
