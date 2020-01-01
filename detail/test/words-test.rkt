#lang racket

(require rackunit)
(require rackunit/text-ui)

(require "../src/define.rkt")
(require "../src/detail.rkt")

(define test-detail
  (test-suite 
   "test-detail"
   
   (test-case
    "test-detail-words"

    (detail 
     '(console "detail.pdf")
     #f
     void
     (lambda ()
       (detail-page
        (lambda ()
          (let loop-text ([count 1])
            (when (<= count 32)
              (detail-words (string-append (number->string (random 100000)) " "))
              (loop-text (add1 count))))
          (detail-line ""))
       )))
   ))

(run-tests test-detail)
