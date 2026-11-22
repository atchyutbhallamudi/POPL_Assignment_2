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
