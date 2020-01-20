#lang racket

(require "../main.rkt")

(define (test-line-break)
  (detail
   #:formats '(raw console "h1.pdf")
   (lambda ()
     (detail-page
      (lambda ()
        (let loop-row ([row 1])
          (when (<= row 22)
                (detail-h1 (number->string row))
                (loop-row (add1 row))))
        )))))

(test-line-break)
