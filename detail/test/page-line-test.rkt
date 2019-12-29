#lang racket

(require rackunit)
(require rackunit/text-ui)

(require "../src/define.rkt")
(require "../src/detail.rkt")

(define test-detail
  (test-suite 
   "test-detail"
   
   (test-case
    "test-detail-page-line"

    (detail 
     '(console "detail.pdf")
     void
     (lambda ()
       (detail-page
        #:line_break_length 30
        (lambda ()
          (detail-prefix-line "long line: " (~a #:min-width 100 #:pad-string "a" ""))
          (detail-prefix-line "s line: " (~a #:min-width 100 #:pad-string "a" ""))
          )))))
   ))

(run-tests test-detail)
