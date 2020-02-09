#lang racket

(require "../main.rkt")

(define (test-line-break)
  (detail
   #:formats? '(raw console "h3.pdf")
   (lambda ()
     (detail-page
      (lambda ()
        (let loop ([count 1])
          (when (<= count 40)
                (detail-h3 (number->string count))
                (loop (add1 count))))
        )))))

(test-line-break)
