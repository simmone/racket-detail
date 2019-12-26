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
     '(raw)
     (lambda ()
       (detail-page
        (lambda ()
          (let loop-text ([count 1])
            (when (<= count 32)
              (detail-prefix-line (number->string (random 100000)) (number->string count))
              (loop-text (add1 count))))))

       (detail-page
        (lambda ()
          (let loop-text ([count 1])
            (when (<= count 32)
              (detail-prefix-line (number->string (random 100000)) (number->string count))
              (loop-text (add1 count))))))
       )))
   ))

(run-tests test-detail)
