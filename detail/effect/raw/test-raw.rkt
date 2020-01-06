#lang racket

(require "../../main.rkt")

(define (test-raw)
  (detail
   #:formats '(raw)
   #:line_break_length 1
   #:font_size 'small
   (lambda ()
     (detail-page
      #:line_break_length 2
      #:font_size 'big
      (lambda ()
        (detail-h1 "Hello World!")
        
        (detail-line "Yes, one by one, day by day.")

        (detail-list
         (lambda ()
           (detail-row
            (lambda ()
              (detail-add-col "123")
              (detail-add-col "12345")
              (detail-add-col "1234567")))

           (detail-row
            (lambda ()
              (detail-add-col "12345")
              (detail-add-col "123"))))))))))

(test-raw)
