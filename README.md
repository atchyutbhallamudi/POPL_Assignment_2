# POPL Assignment 2 - Group 36

CS F301 Principles of Programming Languages, Assignment 2: two Prolog problems and two Scheme problems.

## Layout

```
36/
  code/      36_q1.pl  36_q2.pl  36_q3.rkt  36_q4.rkt
  tests/     test_q1.pl  test_q2.pl  test_q3.rkt  test_q4.rkt
  skills/    prolog-dev/SKILL.md  scheme-dev/SKILL.md
  prompts/   P1.md  P2.md  S1.md  S2.md
  P1_REPORT.md
```

## Running

Needs SWI-Prolog 9.x and Racket 8.x. From `36/code`:

```
swipl -q -f 36_q1.pl -g main -t halt
swipl -q -f 36_q2.pl -g "all_equations([4,2,5,3], Es), print(Es), nl" -t halt
```

The Racket files hold only definitions, so `racket 36_q3.rkt` prints nothing by itself. Add the calls at the end of the file, and for S2 add `(print-insert-result)` and give the input on stdin.

Tests, from `36`:

```
swipl -q -g run_tests -t halt tests/test_q1.pl
swipl -q -g run_tests -t halt tests/test_q2.pl
raco test tests/test_q3.rkt
raco test tests/test_q4.rkt
```

## Contributors

| Problem | File | Contributor |
|---|---|---|
| P1 Department puzzle | `36_q1.pl` | Atchyut |
| P2 Arithmetic equation | `36_q2.pl` | Kush |
| S1 Tree traversals | `36_q3.rkt` | Shreyash |
| S2 Insert into nested list | `36_q4.rkt` | Archit |

Kush wrote the prolog-dev skill and Shreyash wrote the scheme-dev skill. The prompts each of us used are in `36/prompts`.
