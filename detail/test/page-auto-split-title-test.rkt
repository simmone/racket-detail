#lang racket

(require rackunit)
(require rackunit/text-ui)

(require "../src/define.rkt")
(require "../src/detail.rkt")

(define test-detail
  (test-suite 
   "test-detail"
   
   (test-case
    "test-detail-page-auto-split-title"

    (detail 
     '(console "detail.pdf")
     void
     (lambda ()
       (detail-page
        (lambda ()
          (let loop ([i 0])
            (when (< i 100)
                  (detail-h1 (number->string i))
                  (detail-h2 (number->string i))
                  (detail-h3 (number->string i))
                  (loop (add1 i)))))))))
   ))

(run-tests test-detail)
