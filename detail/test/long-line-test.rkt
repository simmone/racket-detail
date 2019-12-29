#lang racket

(require rackunit)
(require rackunit/text-ui)

(require "../src/define.rkt")
(require "../src/detail.rkt")

(define test-detail
  (test-suite 
   "test-detail"
   
   (test-case
    "test-detail-line"

    (detail 
     '(console "detail.pdf")
     void
     (lambda ()
       (detail-page
        (lambda ()
          (detail-line (~a #:min-width 100 #:pad-string "a" ""))
          (detail-line (~a #:min-width 100 #:pad-string "a" ""))
          (detail-prefix-line "long line: " (~a #:min-width 100 #:pad-string "a" "") #:line_break_length 50)
          (detail-prefix-line "s line: " (~a #:min-width 100 #:pad-string "a" "") #:line_break_length 30)
          )))))
   ))

(run-tests test-detail)
