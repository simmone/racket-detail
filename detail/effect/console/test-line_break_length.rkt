#lang racket

(require "../../main.rkt")

(define (test-console)
  (detail
   #:formats '(raw console)
   (lambda ()
     (detail-page
      (lambda ()
        (detail-h1 "Hello World!")

        (detail-line
         #:line_break_length 8
         (lambda ()
           (detail-line-add-item "123")
           (detail-line-add-item "12345")
           (detail-line-add-item "")))

        (detail-line
         #:line_break_length 8
         (lambda ()
           (detail-line-add-item "123456789012345678901")))

        (detail-line
         #:line_break_length 22
         (lambda ()
           (detail-line-add-item "1234567890")
           (detail-line-add-item "1234567890")
           (detail-line-add-item "1234567890"))))))))

(test-console)
