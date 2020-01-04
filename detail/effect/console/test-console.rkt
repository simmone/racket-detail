#lang racket

(require "../../main.rkt")

(define (test-console)
  (detail
   #:formats '(console)
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
         (lambda ()
           (detail-h1 "Hello World!")
           (detail-line
            (lambda ()
              (detail-line-add-item "123")
              (detail-line-add-item "12345")
              (detail-line-add-item "")))

           (detail-line
            (lambda ()
              (detail-line-add-item "1")
              (detail-line-add-item "123456")
              (detail-line-add-item "12345678")))

           )))))))

(test-console)
