#lang racket/base
;; S2: Conditionally insert into a nested list.
;; Input: an atom x, a (possibly nested) list lst whose elements are atoms
;; or lists, and an integer n >= 0.

;; (my-length lst) -> number
;; Counts the top-level elements of lst; a sublist counts as one element.
;; Reading: the length of () is 0; the length of a non-empty list is 1 plus
;; the length of its rest.
;; acc holds how many elements have been counted so far, and the loop call
;; is tail-recursive, so long lists use constant stack.
(define (my-length lst)
  (let loop ([items lst] [acc 0])
    (if (null? items)
        acc
        (loop (cdr items) (+ acc 1)))))

;; (my-map f lst) -> list
;; Applies the one-argument function f to each top-level element of lst and
;; returns the results as a new list, in the same order.
;; Reading: mapping f over () gives (); mapping f over a non-empty list
;; gives (f first-element) in front of the map of the rest.
;; Done in two tail-recursive passes so long lists use constant stack:
;; in the first loop acc holds the results so far, newest first; the second
;; loop moves them one by one from acc onto out, which puts them back in
;; the original order.
(define (my-map f lst)
  (let loop ([items lst] [acc '()])
    (if (null? items)
        (let flip ([left acc] [out '()])
          (if (null? left)
              out
              (flip (cdr left) (cons (car left) out))))
        (loop (cdr items) (cons (f (car items)) acc)))))

;; (insert-if-short x lst n) -> list
;; Puts x at the front of every list whose length is less than n, at every
;; level of nesting, lst itself included. A length is always that of the
;; original list, counted before x is put in.
;; Reading: an atom element is left as it is. A list (() included) is
;; handled by first applying the same rule to each of its elements with
;; my-map, then putting x in front if its original my-length is less than
;; n. So () has nothing to process and becomes (x) exactly when 0 < n.
;; The recursion goes only as deep as the nesting; long lists are walked by
;; my-map and my-length, which are both tail-recursive.
(define (insert-if-short x lst n)
  (let ([new-items (my-map (lambda (item)
                             (if (or (null? item) (pair? item)) ; a sublist
                                 (insert-if-short x item n)
                                 item))
                           lst)])
    (if (< (my-length lst) n)
        (cons x new-items)
        new-items)))

;; (print-insert-result) -> prints one line
;; Reads x, then lst, then n from standard input and prints
;; (insert-if-short x lst n) followed by a newline, with no prompt.
;; Reading: not recursive; let* makes the three reads happen in this order,
;; and the result is printed once at the end.
(define (print-insert-result)
  (let* ([x (read)]
         [lst (read)]
         [n (read)])
    (display (insert-if-short x lst n))
    (newline)))
