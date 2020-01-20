#lang racket

(require "../main.rkt")

(define (test-line-break)
  (detail
   #:formats '(raw console "h2.pdf")
   (lambda ()
     (detail-page
      (lambda ()
        (let loop ([row 1])
          (when (<= row 40)
                (detail-h2 (number->string row))
                (loop (add1 row))))
        )))))

(test-line-break)
