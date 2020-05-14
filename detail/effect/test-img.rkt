#lang racket

(require "../main.rkt")

(define (test-img)
  (detail
   #:formats? '(raw console "img.pdf")
   (lambda ()
     (detail-page
      (lambda ()
        (let loop-row ([row 1])
          (when (<= row 22)
                (detail-h1 (number->string row))
                (detail-img "logo.jpg" 0 0)
                (loop-row (add1 row))))
        )))))

(test-img)
