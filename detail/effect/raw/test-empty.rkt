#lang racket

(require "../../main.rkt")

(define (test-empty)
  (detail
   #:formats '(raw)
   #:line_break_length 1
   #:font_size 'small
   (lambda ()
     (detail-page
      #:line_break_length 2
      #:font_size 'big
      (lambda ()
        (detail-line
         #:line_break_length 3
         #:font_size 'normal
         (lambda () (void))))))))

(test-empty)
