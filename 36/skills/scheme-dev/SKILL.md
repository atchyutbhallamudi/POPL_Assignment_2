---
name: scheme-dev
description: "Racket 8.x (#lang racket/base) rules for the CS F301 Assignment 2 Scheme problems S1 (36_q3.rkt) and S2 (36_q4.rkt): allowed built-ins, naming and comment conventions, how to run and test in WSL, a self-review checklist and common AI mistakes in Scheme."
---

# scheme-dev

Use this for all Scheme work in this repo: `36/code/36_q3.rkt` (S1),
`36/code/36_q4.rkt` (S2) and their tests in `36/tests/`.

## 1. Language and version

- Racket 8.x (checked with Racket 8.18 [cs] on Ubuntu in WSL).
- Line 1 of every code file is exactly `#lang racket/base`. Not `#lang racket`,
  not `#lang scheme`, never missing.
- A code file contains only definitions and comments. Nothing is called at the
  top level and nothing is printed when the file is loaded, so
  `racket 36_q3.rkt` prints nothing. The grader appends its own calls (and its
  own example data) to the end of the file.
- No `provide`, `require`, `module+` or other module forms in code files.
- Work one unit at a time (one function, one test file or one review), as the
  assignment requires. Never write a whole problem in one go.

## 2. Allowed built-ins (from the assignment PDF)

Only these may appear in `code/36_q3.rkt` and `code/36_q4.rkt`:

| Group | Allowed |
|---|---|
| Defining and binding | `define`, `lambda`, `let`, `let*`, `letrec`, named `let` |
| Control | `if`, `cond` (with `else`), `and`, `or`, `not`, `begin` |
| Building and taking apart lists | `quote` (written `'`), `cons`, `car`, `cdr`, `list`, every composition of `car` and `cdr` up to four levels (`cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr`, and so on) |
| Tests | `null?`, `pair?`, `eq?`, `assq`, `assoc` |
| Arithmetic and comparison | `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max` |
| Output | `display`, `newline` |
| Input, **S2 only** | `read` |

The literals `#t`, `#f`, numbers and quoted data are fine. Anything else we
need, we write ourselves as a helper named `my-<name>` (for example
`my-reverse`, `my-length`, `my-map`).

Forbidden by name in the PDF: `set!` and its relatives, vectors, hash tables,
strings, loops (`do`, `for` and the whole `for/...` family), `length`,
`append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`.

Also forbidden because they are not on the list (AI tools reach for these a
lot): `when`, `unless`, `case`, `else` inside `if`, `equal?`, `eqv?`,
`number?`, `symbol?`, `list?`, `zero?`, `add1`, `sub1`, `/`, `quotient`,
`remainder`, `min`, `abs`, `apply`, `foldl`, `foldr`, `for-each`, `first`,
`rest`, `empty`, `empty?`, `null` (write `'()`), `true` and `false` (write
`#t` and `#f`), `printf`, `format`, `write`, `print`, `void`, `error`,
quasiquote (`` ` `` and `,`), `let-values`, `define-values`, `struct`,
`match`, and keyword or optional arguments.

## 3. Naming

- kebab-case for everything: `print-inorder`, `count-leaves`.
- Names the PDF gives are used exactly, with the PDF's argument order:
  `print-inorder`, `print-all-traversals`, `print-height-and-leaves` (S1);
  `print-insert-result`, `insert-if-short`, `my-length`, `my-map`,
  `make-inserter` (S2).
- Predicates end in `?` (for example `leaf?`).
- Our own versions of list functions start with `my-` and never reuse a
  racket/base name.
- An accumulator parameter is called `acc`. Other parameters use plain names
  such as `tree`, `lst`, `x`, `n`, and never the name of a built-in we call
  (no parameter called `list` or `max`).
- Never define top-level names the grader may define, such as `t1`, `t2`,
  `t3`. Example data lives only in the test file.
- If several functions take apart the same data shape, give it small named
  accessors built from `car`/`cadr`/`caddr`, so the code reads in the
  problem's own words.

## 4. Comments

- After the `#lang` line, a short header comment: which problem the file
  solves and what the input looks like.
- Before every function, a comment block in this shape (example only):

```racket
;; (sum-list lst) -> number
;; Adds up the numbers in lst.
;; Reading: the sum of () is 0; the sum of a non-empty list is its
;; first element plus the sum of the rest.
```

  1. Signature line: `;; (name arg ...) -> result` (for a printing function,
     say what it prints).
  2. One sentence on what it does.
  3. `Reading:` the recursive reading in plain English, base case first, then
     the recursive case.
  4. If it has an accumulator, say what `acc` holds and that the call is
     tail-recursive.
- Inline `;` comments only where a line is not obvious.
- Comments describe the code only, not how it was written.

## 5. Style

- Pass all state through function arguments. No mutation, no global variables.
- Prefer tail recursion where it is natural (named `let`, or a helper with an
  accumulator). Build result lists by `cons`-ing onto an accumulator, never by
  appending again and again (that is quadratic).
- `if` (always with both branches) for two cases, `cond` with `else` for more.
- Square brackets for `cond` clauses and `let` bindings, round parentheses
  everywhere else. Indent by two spaces.
- A printing function works out the value with pure helpers and then prints
  it once: `(display value)` and then `(newline)` as its last expression.
  That way it returns nothing, and the grader's top-level call echoes nothing
  extra.

## 6. Running and testing in WSL

One-time setup in the Ubuntu terminal:

```bash
sudo apt install racket
racket --version          # must say 8.x
```

The repo sits on the Windows drive. Quote the path, because it has spaces:

```bash
cd "/mnt/c/<path to repo>/36"
```

**a) Load check.** The file must load and print nothing:

```bash
racket code/36_q3.rkt; echo "exit=$?"     # expect only: exit=0
```

**b) Grader-style run.** Copy the file, append calls the way the grader does,
and run the copy. Never put these calls in the real file:

```bash
cp code/36_q3.rkt /tmp/q3_run.rkt
cat >> /tmp/q3_run.rkt <<'EOF'
(define t3 '(a (b () ()) (c () ())))
(print-all-traversals t3)
EOF
racket /tmp/q3_run.rkt
```

The output must match the PDF character for character. For S2, append
`(print-insert-result)` and give the input on stdin:
`echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket /tmp/q4_run.rkt`.

**c) Test file.** Run it with:

```bash
raco test tests/test_q3.rkt               # expect: N tests passed
```

`tests/test_qN.rkt` is its own `#lang racket/base` module. It tests the code
exactly the way the grader runs it. For each case it:

1. copies the code file, unchanged, to a fresh temp file;
2. adds the grader-style text at the end: the definitions (for example
   `(define t1 '(...))`) and then the calls (for S2, `(print-insert-result)`);
3. runs `racket <copy>` as a separate process (for S2, with the case's input
   on stdin);
4. compares the whole result exactly: stdout must be the expected lines, each
   ending in one newline, stderr must be empty and the exit code must be 0;
5. deletes the temp file, even if the run failed.

It also checks the file itself: line 1 is `#lang racket/base`, the file ends
with a newline, and running the code file on its own prints nothing. The S1
PDF examples define their trees under the PDF's own names (`t1`, `t2`,
`t3`), so if the code file defines one of those names itself, the clash
shows up as a failure.

The core of `tests/test_q3.rkt`:

```racket
#lang racket/base
(require rackunit racket/port racket/file racket/system racket/runtime-path)
(define-runtime-path code-file "../code/36_q3.rkt")
(define code-text (call-with-input-file code-file port->string))
(define racket-exe (find-executable-path "racket"))

;; (run-racket file) -> (list stdout stderr exit-code)
(define (run-racket file)
  (define out (open-output-string))
  (define err (open-output-string))
  (define code
    (parameterize ([current-input-port (open-input-string "")]
                   [current-output-port out]
                   [current-error-port err])
      (system*/exit-code racket-exe file)))
  (list (get-output-string out) (get-output-string err) code))

;; (run-with-calls calls) -> the code file plus calls in a temp copy, run
(define (run-with-calls calls)
  (define copy (make-temporary-file "test_q3_~a.rkt"))
  (dynamic-wind
   void
   (lambda ()
     (call-with-output-file copy #:exists 'truncate
       (lambda (port)
         (write-string code-text port)
         (write-string calls port)))
     (run-racket copy))
   (lambda () (delete-file copy))))

;; (check-equal? (run-with-calls "(print-inorder '())\n") (list "()\n" "" 0))
```

`tests/test_q4.rkt` works the same way and also writes each case's input to
the run's stdin.

Group choice: the PDF's built-in list applies to the solution files in
`code/`. Test files may use `rackunit`, `racket/port`, `racket/file`,
`racket/system` and `racket/runtime-path`, because running the code the way
the grader does needs them and tests are not part of the solution.

Tests cover every example in the PDF plus our own edge cases: empty input,
a single element, lopsided or deep input, and long input. If running
anything leaves a `compiled/` folder in the repo, delete it and never commit
it.

**d) Forbidden-name scan.** This is a quick extra check; it does not replace
reading the code:

```bash
grep -nE "\((append|reverse|length|map|filter|member|memq|list-ref|list-tail|set!|set-[a-z-]+!|vector[a-z-]*|hash[a-z-]*|string[a-z-]*|for[a-z*/-]*|do|when|unless|case|equal\?|eqv\?|apply|foldl|foldr|first|rest|empty\?|add1|sub1|/|quotient|min|abs|printf|format|write|print|void|error)[] )]" code/36_q3.rkt
```

Expect no output. A hit inside a comment can be ignored.

## 7. Self-review checklist (go through it before every answer)

1. I did only the one unit that was asked for. No extra functions, no
   "while I'm here" edits, and no changes to files that belong to someone else.
2. Line 1 is `#lang racket/base`, and the file ends with a newline (the
   grader appends its calls after the last line).
3. Every identifier is on the allowed list or defined in this file. I checked
   word by word, and the forbidden-name scan printed nothing.
4. Nothing runs on load: no top-level calls, no example data such as `t1`,
   no `provide`/`require`. `racket code/id_qN.rkt` printed nothing.
5. Every function has its comment block: signature, purpose and recursive
   reading (base case, then recursive case).
6. Empty input is handled first. No `car`, `cdr` or `cadr` is ever applied to
   `'()`.
7. Every `if` has both branches. Every `cond` that can fall through has an
   `else`.
8. Lists are built with `(cons item lst)`, never `(cons lst item)` (a `.` in
   the output means this bug), and there are no quadratic appends.
9. Output uses `display` (not `write`) and matches the PDF exactly. Each
   printed line ends with exactly one `newline`, and a printing function's
   last expression is `(newline)`.
10. State passes only through arguments, and recursion is tail recursion
    where that is natural.
11. I actually ran it: the load check, every PDF example and the edge cases.
    I show the real output, not the output I expect.
12. I report what changed, the commands I ran and their output.

## 8. Common mistakes AI makes in Scheme

- **Forbidden built-ins.** It uses `append`, `reverse`, `length`, `map`,
  `filter`, `apply`, `foldl`, `when`, `equal?`, `add1` or `printf` because
  they are normal Racket. Check every name against section 2.
- **Mixed dialects.** It writes `#lang racket` instead of `racket/base`, or
  uses `true`/`false`, `empty`, `first`/`rest` (all unbound in
  `racket/base`), `nil`, `1+` or `set-car!` (from other Schemes), or SRFI-1
  names such as `fold`, `iota`, `last` that do not exist here.
- **Bad `if`.** It writes a one-armed `(if c x)`, which is a syntax error in
  Racket, or puts `else` inside an `if`.
- **Quoting.** A bare `()` is a syntax error ("missing procedure
  expression"). Writing `'(1 '() '())` quotes twice and gives
  `(1 (quote ()) (quote ()))`.
- **`cons` order.** `(cons acc x)` instead of `(cons x acc)` gives dotted
  output such as `((1 2) . 3)`.
- **Traversals with `append`.** That is forbidden here and O(n^2). With an
  accumulator, handle the part that comes last in the output first, so that
  the first part ends up at the front.
- **Accumulator order.** The list comes out backwards, or it gets reversed
  twice.
- **Conventions.** The height of `()` is 0 (not -1) and a single node has
  height 1. `()` is not a leaf, and a leaf needs both subtrees empty.
- **Empty input.** It calls `car` or `cadr` on `'()` instead of checking for
  empty input first.
- **Output.** It uses `write` instead of `display`, misses or doubles a
  `newline`, returns the list after printing it (so the grader's top-level
  call echoes it), or prints a quote as in `'(1 2)`.
- **Test leftovers.** It leaves calls or example data such as
  `(define t1 ...)` in the code file. The calls print when the file loads,
  and a second `t1` clashes with the grader's own definition.
- **Shadowing.** A parameter called `list` or `max` breaks later calls to
  that built-in.
- **Large inputs.** S2's hidden tests use nesting depth 100 and lists of
  10,000 elements. Avoid quadratic helpers, and use tail recursion for long
  top-level lists.
- **Process.** It writes more than the one unit asked for, or says code was
  tested without running it.
