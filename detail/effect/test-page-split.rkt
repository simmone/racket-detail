#lang racket

(require "../main.rkt")

(define (test-line-break)
  (detail
   #:formats '(raw console "page.pdf")
   (lambda ()
     (detail-page
      (lambda ()
        (detail-list
         (lambda ()
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width 1)))
           )))))))

(test-line-break)
