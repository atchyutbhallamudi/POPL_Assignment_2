#lang racket/base
;; Tests for S2, code/36_q4.rkt, run the way the grader runs it.
;; The code file is copied to a temp file with (print-insert-result) added
;; at the end. Each case runs `racket <copy>`, feeds its input on stdin and
;; compares the whole result exactly: stdout must be the expected line plus
;; one newline, stderr must be empty and the exit code must be 0.
;; Run from 36:  raco test tests/test_q4.rkt
(require rackunit racket/port racket/runtime-path)

(define-runtime-path code-file "../code/36_q4.rkt")

(define racket-exe
  (or (find-executable-path "racket")
      (error 'test_q4 "racket is not on the PATH")))

;; (run-racket file input) -> (list stdout stderr exit-code)
;; Runs `racket file` with input on its stdin and collects everything it
;; prints. stdin is written and stderr is read in their own threads, so a
;; large input or output cannot block the run.
(define (run-racket file input)
  (define-values (proc out in err) (subprocess #f #f #f racket-exe file))
  (define writer
    (thread (lambda ()
              (write-string input in)
              (close-output-port in))))
  (define err-ch (make-channel))
  (thread (lambda () (channel-put err-ch (port->string err))))
  (define out-text (port->string out))
  (define err-text (channel-get err-ch))
  (thread-wait writer)
  (subprocess-wait proc)
  (close-input-port out)
  (close-input-port err)
  (list out-text err-text (subprocess-status proc)))

;; The grader-style copy: the code file unchanged, then the call.
;; (void ...) because write-string returns a count, which would be printed.
(define code-text (call-with-input-file code-file port->string))
(define run-file
  (build-path (find-system-path 'temp-dir)
              (format "test_q4_run_~a.rkt" (current-milliseconds))))
(void
 (call-with-output-file run-file #:exists 'truncate
   (lambda (port)
     (write-string code-text port)
     (write-string "(print-insert-result)\n" port))))

;; (check-io label input expected) runs the copy on input and expects the
;; one line expected (without its newline) and nothing else.
(define (check-io label input expected)
  (test-case label
    (check-equal? (run-racket run-file input)
                  (list (string-append expected "\n") "" 0))))

;; (repeat-text text k) -> text written k times in a row
(define (repeat-text text k)
  (with-output-to-string
    (lambda ()
      (let loop ([i 0])
        (when (< i k)
          (display text)
          (loop (+ i 1)))))))

;; "1 2 3 ... k"
(define (numbers-up-to k)
  (with-output-to-string
    (lambda ()
      (let loop ([i 1])
        (display i)
        (when (< i k)
          (display " ")
          (loop (+ i 1)))))))

;; ---------------------------------------------------------------------
;; The file itself
;; ---------------------------------------------------------------------

(test-case "first line is #lang racket/base"
  (check-true (and (>= (string-length code-text) 17)
                   (string=? (substring code-text 0 17) "#lang racket/base"))))

(test-case "file ends with a newline, so the grader's call starts on its own line"
  (check-true (char=? (string-ref code-text (- (string-length code-text) 1))
                      #\newline)))

(test-case "loading the file alone prints nothing"
  (check-equal? (run-racket code-file "") (list "" "" 0)))

;; ---------------------------------------------------------------------
;; The four examples from the PDF
;; ---------------------------------------------------------------------

(check-io "pdf example 1"
          "42 ((1 2) (3 4 5) (6) ()) 3"
          "((42 1 2) (3 4 5) (42 6) (42))")
(check-io "pdf example 2"
          "0 (((1) 2) (3) ((4 5 6) ())) 3"
          "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))")
(check-io "pdf example 3"
          "7 () 3"
          "(7)")
(check-io "pdf example 4"
          "7 () 0"
          "()")

;; ---------------------------------------------------------------------
;; n = 0: nothing is shorter than 0, so nothing changes
;; ---------------------------------------------------------------------

(check-io "n = 0, flat list" "a (1 2 3) 0" "(1 2 3)")
(check-io "n = 0, nested list with empty lists"
          "9 ((1) (()) ()) 0"
          "((1) (()) ())")

;; ---------------------------------------------------------------------
;; Empty lists and () inside lists
;; ---------------------------------------------------------------------

(check-io "top-level () with n = 1" "a () 1" "(a)")
(check-io "() elements, top level too long"
          "e (() () ()) 1"
          "((e) (e) (e))")
(check-io "(()) with n = 1: only the inner () is short"
          "x (()) 1"
          "((x))")
(check-io "(()) with n = 2: both lists are short"
          "x (()) 2"
          "(x (x))")
(check-io "() two levels down"
          "z (a (b c) (())) 2"
          "(a (b c) (z (z)))")

;; ---------------------------------------------------------------------
;; Symbols, the n boundary, and the top-level list
;; ---------------------------------------------------------------------

(check-io "symbol x and symbol elements"
          "s (p (q r) t) 3"
          "(p (s q r) t)")
(check-io "length equal to n gets no x" "a (1 2 3) 3" "(1 2 3)")
(check-io "length one less than n gets x" "a (1 2) 3" "(a 1 2)")
(check-io "every level gets x when n is large"
          "q (1 (2 (3))) 10"
          "(q 1 (q 2 (q 3)))")
(check-io "length is the original one: (2 3) stays, (1) gets x"
          "0 ((1) (2 3)) 2"
          "((0 1) (2 3))")

;; ---------------------------------------------------------------------
;; Input layout: read does not care about spaces or newlines
;; ---------------------------------------------------------------------

(check-io "one value per line" "a\n(1 2)\n3\n" "(a 1 2)")
(check-io "extra spaces, a tab and a list split over lines"
          "   z   (a   (b c)\n (()))\t 2  "
          "(a (b c) (z (z)))")

;; ---------------------------------------------------------------------
;; Nesting depth 100: (((...()...))) with 100 pairs of parentheses
;; ---------------------------------------------------------------------

(define deep-100 (string-append (repeat-text "(" 100) (repeat-text ")" 100)))

(check-io "depth 100, n = 2: every level gets x"
          (string-append "x " deep-100 " 2")
          (string-append (repeat-text "(x " 99) "(x)" (repeat-text ")" 99)))
(check-io "depth 100, n = 1: only the innermost () gets x"
          (string-append "x " deep-100 " 1")
          (string-append (repeat-text "(" 99) "(x)" (repeat-text ")" 99)))
(check-io "depth 100, n = 0: unchanged"
          (string-append "x " deep-100 " 0")
          deep-100)

;; ---------------------------------------------------------------------
;; Lists of 10,000 elements
;; ---------------------------------------------------------------------

(define nums-10000 (numbers-up-to 10000))

(check-io "10,000 numbers, n = 10001: x in front"
          (string-append "x (" nums-10000 ") 10001")
          (string-append "(x " nums-10000 ")"))
(check-io "10,000 numbers, n = 10000: unchanged"
          (string-append "x (" nums-10000 ") 10000")
          (string-append "(" nums-10000 ")"))
(check-io "10,000 empty lists, n = 1: each becomes (e)"
          (string-append "e (" (repeat-text "() " 10000) ") 1")
          (string-append "(" (repeat-text "(e) " 9999) "(e))"))

(delete-file run-file)
