# P1 Report

## N for clues 1 to 8

`count_solutions([1,2,3,4,5,6,7,8], N)` gives **N = 3**.

So clues 1 to 8 do not contradict each other (there is at least one
solution), but they are not enough to fix a single answer: three different
assignments satisfy all eight clues. The puzzle as given has no unique
solution, which is why it needs a ninth clue.

## The three solutions

Each cell is department, language, project.

| # | Alex | Ben | Carla | Dana |
|---|------|-----|-------|------|
| 1 | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| 2 | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| 3 | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

## Why solutions 1 and 3 cannot be told apart without names

Solutions 1 and 3 use exactly the same four combinations:

- design, java, AI
- development, javascript, web
- research, c++, data
- testing, python, embedded

Only the owners change. Ben keeps his, and Alex, Carla and Dana pass theirs
around: Alex's combination in solution 1 belongs to Carla in solution 3,
Carla's to Dana, and Dana's to Alex.

A clue that does not use names can only talk about these combinations (for
example "the friend who likes Java works in design"). Since both solutions
have the same combinations, such a clue is either true in both or false in
both. So no name-free clue can keep one of them and drop the other. The
only solution a name-free clue can keep on its own is solution 2.

## Clue 9

> The friend who prefers the AI project likes Python.

| Solution | AI friend | Their language | Clue 9 |
|----------|-----------|----------------|--------|
| 1 | Alex | java | false |
| 2 | Carla | python | true |
| 3 | Carla | java | false |

Clue 9 is true only in solution 2, so
`count_solutions([1,2,3,4,5,6,7,8,9], N)` gives **N = 1**, and the one
remaining answer is solution 2.
