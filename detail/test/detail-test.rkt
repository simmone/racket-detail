#lang racket

(require rackunit)
(require rackunit/text-ui)

(require "../src/define.rkt")
(require "../src/detail.rkt")

(define test-detail
  (test-suite 
   "test-detail"
   
   (test-case
    "test-add-rec"

    (detail 
     '(console "test.pdf")
     (lambda ()
       (detail-title "Hello World!")
       
       (let ([recs (DETAIL-recs (*detail*))])
         (check-equal? (length recs) 1))
      )))

   ))

(run-tests test-detail)
