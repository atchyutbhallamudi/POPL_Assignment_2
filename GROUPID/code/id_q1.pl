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

% Clue 5: The friend whose favorite language is Java works in the design
% department.
clue(5, Sol) :-
    member(p(_, Dept, java, _), Sol),
    Dept == design.

% Clue 6: Carla's project preference is not embedded, and her department is
% not development.
clue(6, Sol) :-
    member(p('Carla', Dept, _, Project), Sol),
    Project \== embedded,
    Dept \== development.

% Clue 7: Dana's favorite language is not Java, and she works in research or
% testing.
% Dept has one value, so at most one branch of the "or" can succeed.
clue(7, Sol) :-
    member(p('Dana', Dept, Lang, _), Sol),
    Lang \== java,
    ( Dept == research ; Dept == testing ).

% Clue 8: The friend who prefers data projects works in research and does
% not use JavaScript.
clue(8, Sol) :-
    member(p(_, Dept, Lang, data), Sol),
    Dept == research,
    Lang \== javascript.

% satisfies(+Active, +Sol)
% True when every clue number in the list Active holds in Sol, a fully
% filled-in candidate. Clues not in Active are ignored, not negated.
% forall/2 succeeds when no member N of Active makes clue(N, Sol) fail, so
% an empty Active list is satisfied by every Sol. Succeeds at most once and
% binds nothing.
satisfies(Active, Sol) :-
    forall(member(N, Active), clue(N, Sol)).

% main/0
% Prints one solution that satisfies clues 1 to 8 as four lines, in the
% order Alex, Ben, Carla, Dana, such as "Alex = [research, python, AI]".
% Nothing is hard-coded: candidate/1 generates assignments and satisfies/2
% keeps one that passes every clue. once/1 stops after the first such
% candidate, so exactly one solution is printed. ~w writes atoms without
% quotes, so 'c++' and 'AI' print as c++ and AI.
main :-
    once(( candidate(Sol),
           satisfies([1,2,3,4,5,6,7,8], Sol) )),
    forall(member(p(Name, Dept, Lang, Project), Sol),
           format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Project])).
