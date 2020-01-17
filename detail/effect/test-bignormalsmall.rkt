#lang racket

(require "../main.rkt")

(define (test-line-break)
  (detail
   #:formats '(raw console "bignormalsmall.pdf")
   (lambda ()
     (detail-page
      (lambda ()
        (let loop ([count 1])
          (when (<= count 20)
                (detail-line (number->string count) #:font_size 'big)
                (detail-line (number->string count) #:font_size 'normal)
                (detail-line (number->string count) #:font_size 'small)
                (loop (add1 count))))
        )))))

(test-line-break)
