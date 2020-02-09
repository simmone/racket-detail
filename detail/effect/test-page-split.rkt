#lang racket

(require "../main.rkt")

(define (test-line-break)
  (detail
   #:formats? '(raw console "page.pdf")
   (lambda ()
     (detail-page
      (lambda ()
        (detail-line "1234567890123456789012345678901234567890123456789012345678901234567890" #:line_break_length? 1)

        (detail-list
         (lambda ()
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))))

        (detail-list
         #:font_size? 'big
         (lambda ()
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))))

        (detail-list
         #:font_size? 'small
         (lambda ()
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))
           (detail-row (lambda () (detail-col "12345") (detail-col "123456789012345678901" #:width? 1)))))

           )))))

(test-line-break)
