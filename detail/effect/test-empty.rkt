#lang racket

(require "../main.rkt")

(define (test-empty)
  (detail
   #:formats '(raw console "empty.pdf")
   #:line_break_length 1
   #:font_size 'small
   (lambda ()
     (detail-page
      #:line_break_length 2
      #:font_size 'big
      (lambda ()
        (detail-list
         #:font_size 'small
         (lambda ()
           (detail-row
            (lambda ()
              (void))))))))))

(test-empty)
