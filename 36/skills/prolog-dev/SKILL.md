---
name: prolog-dev
description: Develop, test, and review SWI-Prolog 9.x predicates for CS F301 Assignment 2, with puzzle checks for P1 and arithmetic equation checks for P2.
---

# Prolog development

Use SWI-Prolog 9.x. Work on one requested predicate, test file, or review at a time. Preserve the assignment's public predicate names and arities.

## Naming and declarative comments

- Use descriptive lowercase snake_case predicate names and meaningful capitalized variable names. Use `_` for an argument that is intentionally ignored.
- For a public predicate or a helper with a non-obvious contract, add a short `%` comment describing intended argument modes and the conditions under which it succeeds. For example, “`count_equations(+Numbers, -Count)` holds when Count is the number of distinct valid equations over Numbers.”
- For recursion, describe what the base case means and how the relation on smaller inputs establishes the recursive case. Explain invariants or deliberate determinism where they matter.

## Load and test

From the repository root, check the runtime and load the P2 source. A successful load should be silent and free of errors or warnings.

```sh
swipl --version
swipl -q -f 36/code/36_q2.pl -t halt
```

For each code unit, run a focused goal through the same source entry point. When the named predicate exists, for example, run:

```powershell
swipl -q -f 36/code/36_q2.pl -g "generate_equation([2,4,8], E), atom_string('2*4=8', Expected), string(E), E == Expected" -t halt
```

Use a success goal that checks the expected value or shape. For a predicate expected to fail, use a ground input and negate the call in the test goal so the test succeeds only when the call fails. Read diagnostics as well as the exit status, and report the focused check's result.

## P2 self-review checklist

- Each equation has exactly one equals sign. Both sides are nonempty, use every input number once in order, and have equal integer values. The only arithmetic operators are binary `+`, `-`, `*`, and `/`. Input numbers are non-negative integers and intermediate values may be negative.
- For every division node, evaluate both operands, reject a zero divisor before testing the remainder, and require a zero remainder before producing an integer quotient. Include exact, inexact, zero-divisor, and negative-intermediate cases in relevant checks.
- Render structure using the canonical precedence and associativity rules. Multiplication and division bind tighter than addition and subtraction. Operators associate to the left. Parenthesize a left child only at lower precedence, and a right child at the same or lower precedence. Never parenthesize a number. Check pairs such as `8/4*2` and `8/(4*2)`, and `1+2+3` and `1+(2+3)`.
- Return a space-free SWI-Prolog string with decimal numbers. Use `string/1` in output checks. Evaluate the expression structure directly without parsing rendered text.
- Check that `generate_equation/2` can return a valid string and fails finitely for impossible, empty, and singleton inputs. Check that `all_equations/2` returns all distinct strings in `sort/2` order, including `[]` when none exist, and that `count_equations/2` agrees with the list length.
- Keep the source definition-only, with no initialization directive, calls to `halt/0`, or printing. The permitted libraries are `lists`, `apply`, `yall`, and `aggregate`. Avoid `assert`, `retract`, and global variables.

## Common generated-code mistakes

- Confusing unification (`=`), evaluation (`is`), and arithmetic equality (`=:=`). Bind arithmetic operands before evaluating or comparing them.
- Using `/` for an integer quotient or assuming integer division establishes exactness. Test divisibility explicitly after the nonzero guard.
- Splitting lists at empty sides or recurring without consuming input. Verify that recursive expression splits produce strictly smaller nonempty inputs.
- Placing a cut or `once/1` in shared enumeration logic and losing valid equations. Check alternatives on backtracking when implementing collection.
- Relying on default term printing or returning atoms or character codes. Check the required parentheses and verify the string type independently of the rendered characters.

## P1 run and test commands

From the repository root, run the puzzle, count solutions for clues 1 through 8, and run the PlUnit suite.

```powershell
swipl -q -f 36/code/36_q1.pl -g main -t halt
swipl -q -f 36/code/36_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), writeln(N)" -t halt
swipl -q -s 36/tests/test_q1.pl -g run_tests -t halt
```

To verify the repair, add 9 to the active clue list and check that the count is 1.

## P1 self-review checklist

- Give each numbered clue one separate `clue/2` clause that succeeds exactly when the clue holds on a fully filled-in solution.
- Put the English clue text in a `% CLUE 9:` comment on the line immediately above the `clue(9, Solution)` clause. Refer to friends only through attribute values.
- Keep the solver free of `assert`, `retract`, and global variables.
