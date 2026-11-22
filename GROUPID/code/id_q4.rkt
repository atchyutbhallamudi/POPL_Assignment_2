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
