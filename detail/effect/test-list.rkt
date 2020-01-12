#lang racket

(require "../main.rkt")

(define (test-line-break)
  (detail
   #:formats '(raw console "list.pdf")
   #:line_break_length 1
   #:font_size 'small
   (lambda ()
     (detail-page
      #:line_break_length 10
      #:font_size 'big
      (lambda ()
        (detail-h1 "Hello World!")

        (detail-line "1234567890")
        
        (detail-line "Yes, one by one, day by day.")

        (detail-list
         (lambda ()
           (detail-row
            (lambda ()
              (detail-col "123")
              (detail-col "12345")
              (detail-col "12345678901" #:width 3)
              (detail-col "123456789012345678901" #:width 10)
              ))

           (detail-row
            (lambda ()
              (detail-col "12345")
              (detail-col "123")))))

        (detail-h1 "Hello World!")

        (detail-line "1234567890")
        
        (detail-line "Yes, one by one, day by day.")

        (detail-list
         (lambda ()
           (detail-row
            (lambda ()
              (detail-col "123")
              (detail-col "12345")
              (detail-col "12345678901" #:width 3)
              (detail-col "123456789012345678901" #:width 10)
              ))

           (detail-row
            (lambda ()
              (detail-col "12345")
              (detail-col "123")))))
        
        )))))

(test-line-break)