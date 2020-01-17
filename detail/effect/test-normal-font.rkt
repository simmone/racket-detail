#lang racket

(require "../main.rkt")

(define (test-line-break)
  (detail
   #:formats '(raw console "normalfont.pdf")
   (lambda ()
     (detail-page
      (lambda ()
        (let loop ([count 1])
          (when (<= count 60)
                (detail-line (number->string count) #:font_size 'normal)
                (loop (add1 count))))
        )))))

(test-line-break)
