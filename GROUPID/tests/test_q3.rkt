#lang racket/base
;; Tests for S1, code/id_q3.rkt, run the way the grader runs it.
;; For each case the code file is copied unchanged to a temp file, the
;; grader-style text (tree definitions and calls) is added at the end, and
;; `racket <copy>` is run. The whole result is compared exactly: stdout must
;; be the expected lines, each ending in one newline, stderr must be empty
;; and the exit code must be 0.
;; Run from GROUPID:  raco test tests/test_q3.rkt
(require rackunit racket/port racket/file racket/system racket/runtime-path)

(define-runtime-path code-file "../code/id_q3.rkt")

(define racket-exe
  (or (find-executable-path "racket")
      (error 'test_q3 "racket is not on the PATH")))

(define code-text (call-with-input-file code-file port->string))

;; (run-racket file) -> (list stdout stderr exit-code)
;; Runs `racket file` with an empty stdin and collects what it prints.
(define (run-racket file)
  (define out (open-output-string))
  (define err (open-output-string))
  (define code
    (parameterize ([current-input-port (open-input-string "")]
                   [current-output-port out]
                   [current-error-port err])
      (system*/exit-code racket-exe file)))
  (list (get-output-string out) (get-output-string err) code))

;; (run-with-calls calls) -> (list stdout stderr exit-code)
;; Writes the code file followed by calls to a fresh temp file, runs it,
;; and deletes the temp file again even if the run fails.
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

;; (lines s ...) -> the strings s, each followed by a newline
(define (lines . strs)
  (apply string-append (map (lambda (s) (string-append s "\n")) strs)))

;; (check-run label calls expected) appends calls to the copy and expects
;; exactly expected on stdout, nothing on stderr and exit code 0.
(define (check-run label calls expected)
  (test-case label
    (check-equal? (run-with-calls calls) (list expected "" 0))))

;; (check-tree label tree-text in pre post hl) defines the tree as t, calls
;; all three functions on it and expects their five lines: the inorder line
;; from print-inorder, the three lines from print-all-traversals and the
;; line from print-height-and-leaves.
(define (check-tree label tree-text in pre post hl)
  (check-run label
             (string-append "(define t '" tree-text ")\n"
                            "(print-inorder t)\n"
                            "(print-all-traversals t)\n"
                            "(print-height-and-leaves t)\n")
             (lines in in pre post hl)))

;; (shown v) -> exactly what (display v) prints
(define (shown v)
  (with-output-to-string (lambda () (display v))))

;; ---------------------------------------------------------------------
;; The file itself
;; ---------------------------------------------------------------------

(test-case "first line is #lang racket/base"
  (check-true (and (>= (string-length code-text) 17)
                   (string=? (substring code-text 0 17) "#lang racket/base"))))

(test-case "file ends with a newline, so the grader's calls start on their own line"
  (check-true (char=? (string-ref code-text (- (string-length code-text) 1))
                      #\newline)))

(test-case "loading the file alone prints nothing"
  (check-equal? (run-racket code-file) (list "" "" 0)))

;; ---------------------------------------------------------------------
;; Every S1 example from the PDF, with the PDF's names t1, t2, t3
;; (this also checks that the file does not define those names itself)
;; ---------------------------------------------------------------------

(define pdf-trees
  (string-append
   "(define t1 '(4 (2 (1 () ()) (3 () ()))\n"
   "              (6 (5 () ()) (7 () ()))))\n"
   "(define t2 '(1 () (2 () (3 () ()))))\n"
   "(define t3 '(a (b () ()) (c () ())))\n"))

(define (pdf-call call)
  (string-append pdf-trees call "\n"))

(check-run "pdf: (print-inorder t1)"
           (pdf-call "(print-inorder t1)")
           (lines "(1 2 3 4 5 6 7)"))
(check-run "pdf: (print-all-traversals t1)"
           (pdf-call "(print-all-traversals t1)")
           (lines "(1 2 3 4 5 6 7)" "(4 2 1 3 6 5 7)" "(1 3 2 5 7 6 4)"))
(check-run "pdf: (print-height-and-leaves t1)"
           (pdf-call "(print-height-and-leaves t1)")
           (lines "(3 4)"))
(check-run "pdf: (print-all-traversals t2)"
           (pdf-call "(print-all-traversals t2)")
           (lines "(1 2 3)" "(1 2 3)" "(3 2 1)"))
(check-run "pdf: (print-height-and-leaves t2)"
           (pdf-call "(print-height-and-leaves t2)")
           (lines "(3 1)"))
(check-run "pdf: (print-all-traversals t3)"
           (pdf-call "(print-all-traversals t3)")
           (lines "(b a c)" "(a b c)" "(b c a)"))
(check-run "pdf: (print-height-and-leaves t3)"
           (pdf-call "(print-height-and-leaves t3)")
           (lines "(2 2)"))
(check-run "pdf: (print-inorder '())"
           (pdf-call "(print-inorder '())")
           (lines "()"))
(check-run "pdf: (print-all-traversals '())"
           (pdf-call "(print-all-traversals '())")
           (lines "()" "()" "()"))
(check-run "pdf: (print-height-and-leaves '())"
           (pdf-call "(print-height-and-leaves '())")
           (lines "(0 0)"))

(check-run "pdf: all the calls above in one file, one after another"
           (string-append pdf-trees
                          "(print-inorder t1)\n"
                          "(print-all-traversals t1)\n"
                          "(print-height-and-leaves t1)\n"
                          "(print-all-traversals t2)\n"
                          "(print-height-and-leaves t2)\n"
                          "(print-all-traversals t3)\n"
                          "(print-height-and-leaves t3)\n"
                          "(print-inorder '())\n"
                          "(print-all-traversals '())\n"
                          "(print-height-and-leaves '())\n")
           (lines "(1 2 3 4 5 6 7)"
                  "(1 2 3 4 5 6 7)" "(4 2 1 3 6 5 7)" "(1 3 2 5 7 6 4)"
                  "(3 4)"
                  "(1 2 3)" "(1 2 3)" "(3 2 1)"
                  "(3 1)"
                  "(b a c)" "(a b c)" "(b c a)"
                  "(2 2)"
                  "()"
                  "()" "()" "()"
                  "(0 0)"))

;; ---------------------------------------------------------------------
;; Small edge cases (each runs all three functions on one tree)
;;           label  tree  inorder  preorder  postorder  (height leaves)
;; ---------------------------------------------------------------------

(check-tree "single node"
            "(5 () ())"
            "(5)" "(5)" "(5)" "(1 1)")
(check-tree "single node holding a symbol"
            "(z () ())"
            "(z)" "(z)" "(z)" "(1 1)")
(check-tree "root with only a left child: the root is not a leaf"
            "(1 (2 () ()) ())"
            "(2 1)" "(1 2)" "(2 1)" "(2 1)")
(check-tree "root with only a right child: the root is not a leaf"
            "(1 () (2 () ()))"
            "(1 2)" "(1 2)" "(2 1)" "(2 1)")
(check-tree "one-child root above a left subtree with two leaves"
            "(1 (2 (3 () ()) (4 () ())) ())"
            "(3 2 4 1)" "(1 2 3 4)" "(3 4 2 1)" "(3 2)")
(check-tree "one-child root above a right subtree with two leaves"
            "(1 () (2 (3 () ()) (4 () ())))"
            "(1 3 2 4)" "(1 2 3 4)" "(3 4 2 1)" "(3 2)")
(check-tree "every node has one child, zigzagging left and right"
            "(1 (2 () (3 (4 () ()) ())) ())"
            "(2 4 3 1)" "(1 2 3 4)" "(4 3 2 1)" "(4 1)")
(check-tree "left-only chain"
            "(3 (2 (1 () ()) ()) ())"
            "(1 2 3)" "(3 2 1)" "(1 2 3)" "(3 1)")
(check-tree "lopsided tree with leaves at different depths"
            "(8 (3 (1 () ()) (6 (4 () ()) (7 () ()))) (10 () (14 (13 () ()) ())))"
            "(1 3 4 6 7 8 10 13 14)"
            "(8 3 1 6 4 7 10 14 13)"
            "(1 4 7 6 3 13 14 10 8)"
            "(4 4)")
(check-tree "numbers and symbols mixed"
            "(m (3 (a () ()) ()) (7 (b () ()) (x () ())))"
            "(a 3 m b 7 x)" "(m 3 a 7 b x)" "(a 3 b x 7 m)" "(3 3)")
(check-tree "zero and a negative number next to a symbol"
            "(0 (-5 () ()) (q () ()))"
            "(-5 0 q)" "(0 -5 q)" "(-5 q 0)" "(2 2)")
(check-tree "the same value in every node"
            "(1 (1 () ()) (1 () ()))"
            "(1 1 1)" "(1 1 1)" "(1 1 1)" "(2 2)")

(check-run "calling twice prints the same lines twice (no state kept)"
           (pdf-call (string-append "(print-inorder t1)\n"
                                    "(print-height-and-leaves t1)\n"
                                    "(print-inorder t1)\n"
                                    "(print-height-and-leaves t1)"))
           (lines "(1 2 3 4 5 6 7)" "(3 4)" "(1 2 3 4 5 6 7)" "(3 4)"))

;; ---------------------------------------------------------------------
;; Big trees. They are built here, written out as literal text the way a
;; grader would write them, and the expected lines are worked out
;; separately (by formula, or by the plain append-based definitions below,
;; which share no code with the solution).
;; ---------------------------------------------------------------------

;; (count-up a b) -> (a a+1 ... b)
(define (count-up a b)
  (if (> a b) '() (cons a (count-up (+ a 1) b))))

;; (1 () (2 () ( ... (n () ()) ... )))
(define (right-chain a n)
  (if (> a n) '() (list a '() (right-chain (+ a 1) n))))

;; (n (n-1 ( ... (1 () ()) ... ) ()) ())
(define (left-chain n)
  (if (= n 0) '() (list n (left-chain (- n 1)) '())))

;; complete tree holding lo..hi, numbered so that inorder is lo..hi
(define (complete lo hi)
  (if (> lo hi)
      '()
      (let ([mid (quotient (+ lo hi) 2)])
        (list mid (complete lo (- mid 1)) (complete (+ mid 1) hi)))))

(define (ref-preorder t)
  (if (null? t)
      '()
      (cons (car t) (append (ref-preorder (cadr t)) (ref-preorder (caddr t))))))

(define (ref-postorder t)
  (if (null? t)
      '()
      (append (ref-postorder (cadr t)) (ref-postorder (caddr t)) (list (car t)))))

(define big-n 10000)
(define one-to-n (count-up 1 big-n))

(check-tree "right chain of 10,000 nodes (height 10,000, one leaf)"
            (format "~s" (right-chain 1 big-n))
            (shown one-to-n)
            (shown one-to-n)
            (shown (reverse one-to-n))
            (shown (list big-n 1)))

(check-tree "left chain of 10,000 nodes (height 10,000, one leaf)"
            (format "~s" (left-chain big-n))
            (shown one-to-n)
            (shown (reverse one-to-n))
            (shown one-to-n)
            (shown (list big-n 1)))

(define full-tree (complete 1 32767))

(check-tree "complete tree of 32,767 nodes (height 15, 16,384 leaves)"
            (format "~s" full-tree)
            (shown (count-up 1 32767))
            (shown (ref-preorder full-tree))
            (shown (ref-postorder full-tree))
            (shown (list 15 16384)))
