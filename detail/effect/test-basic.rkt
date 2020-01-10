#lang racket

(require "../main.rkt")

(define (test-basic)
  (detail
   #:formats '(raw console "basic.pdf")
   #:line_break_length 1
   #:font_size 'small
   (lambda ()
     (detail-page
      #:line_break_length 100
      #:font_size 'big
      (lambda ()
        (detail-h1 "Hello World!")
        
        (detail-line "Yes, one by one, day by day.")

        (detail-list
         (lambda ()
           (detail-row
            (lambda ()
              (detail-col "123")
              (detail-col "12345")
              (detail-col "1234567")))

           (detail-row
            (lambda ()
              (detail-col "12345")
              (detail-col "123"))))))))))

(test-basic)
