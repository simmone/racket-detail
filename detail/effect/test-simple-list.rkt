#lang racket

(require "../main.rkt")

(define (test-wdith)
  (detail
   #:formats '(raw console "simple-list.pdf")
   #:font_size 'small
   (lambda ()
     (detail-page
      #:font_size 'big
      (lambda ()
        (detail-simple-list '(
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           ))

        (detail-simple-list '(
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           )
           #:cols_count 2)

        (detail-simple-list '(
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           "1" "2" "3" "4"
           )
           #:font_size 'small                            
           #:cols_count 7)

        )))))

(test-wdith)
