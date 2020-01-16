#lang racket

(require "../main.rkt")

(define (test-line-break)
  (detail
   #:formats '(raw console "h1h2h3.pdf")
   (lambda ()
     (detail-page
      (lambda ()
        (let loop ([count 1])
          (when (<= count 20)
                (detail-h1 (number->string count))
                (detail-h2 (number->string count))
                (detail-h3 (number->string count))
                (loop (add1 count))))
        )))))

(test-line-break)
