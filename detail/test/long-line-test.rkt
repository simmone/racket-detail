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
          (detail-line (~a #:min-width 100 #:pad-string "a" "")))))))
   ))

(run-tests test-detail)
