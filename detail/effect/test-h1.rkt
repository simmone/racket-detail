#lang racket

(require "../main.rkt")

(define (test-line-break)
  (detail
   #:formats '(raw console "h1.pdf")
   (lambda ()
     (detail-page
      (lambda ()
        (let loop ([count 1])
          (when (<= count 22)
                (detail-h1 (number->string count))
                (loop (add1 count))))
        )))))

(test-line-break)
