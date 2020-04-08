#lang racket

(require "../main.rkt")

(define (test-lines)
  (detail
   #:formats? '(raw console "lines.pdf")
   (lambda ()
     (detail-page
      #:line_break_length? 10
      (lambda ()
        (detail-lines '("kskdfk" "123456789012345" "skdjfk" "ksdjkf")))))))

(test-lines)
