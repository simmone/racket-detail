#lang racket

(require "../main.rkt")

(define (test-wdith)
  (detail
   #:formats '(raw console "width.pdf")
   #:line_break_length 1
   #:font_size 'small
   (lambda ()
     (detail-page
      #:line_break_length 10
      #:font_size 'big
      (lambda ()
        (detail-list
         (lambda ()
           (detail-row
            (lambda ()
              (detail-col "12345678901")
              (detail-col "12345678901")
              (detail-col "12345678901")
              ))))))

     (detail-page
      #:line_break_length 10
      #:font_size 'normal
      (lambda ()
        (detail-list
         (lambda ()
           (detail-row
            (lambda ()
              (detail-col "12345678901")
              (detail-col "12345678901")
              (detail-col "12345678901")
              ))))))

     (detail-page
      #:line_break_length 10
      #:font_size 'small
      (lambda ()
        (detail-list
         (lambda ()
           (detail-row
            (lambda ()
              (detail-col "12345678901")
              (detail-col "12345678901")
              (detail-col "12345678901")
              ))))))
     )))

(test-wdith)
