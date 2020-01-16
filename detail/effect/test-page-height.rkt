#lang racket

(require "../main.rkt")

(define (test-line-break)
  (detail
   #:formats '(raw console "height.pdf")
   (lambda ()
     (detail-page
      (lambda ()
        (let loop ([count 0])
          (when (< count 40)
                (detail-h1 (number->string count))
                (loop (add1 count))))
        )))))

(test-line-break)
