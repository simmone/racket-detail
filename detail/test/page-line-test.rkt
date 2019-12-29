#lang racket

(require rackunit)
(require rackunit/text-ui)

(require "../src/define.rkt")
(require "../src/detail.rkt")

(define test-detail
  (test-suite 
   "test-detail"
   
   (test-case
    "test-detail-page-line"

    (detail 
     '(console "detail.pdf")
     void
     (lambda ()
       (detail-page
        #:line_break_length 30
        (lambda ()
          (detail-line (~a #:min-width 100 #:pad-string "a" ""))
          (detail-line (~a #:min-width 100 #:pad-string "a" "") #:line_break_length 50)
          (detail-line (~a #:min-width 100 #:pad-string "a" "") #:line_break_length 40 #:font_size 'big)
          (detail-line (~a #:min-width 100 #:pad-string "a" "") #:line_break_length 60 #:font_size 'small)
          (detail-prefix-line "long line: " (~a #:min-width 100 #:pad-string "a" ""))
          (detail-prefix-line "big: " (~a #:min-width 100 #:pad-string "a" "") #:line_break_length 40 #:font_size 'big)
          (detail-prefix-line "normal: " (~a #:min-width 100 #:pad-string "a" "") #:line_break_length 50)
          (detail-prefix-line "small: " (~a #:min-width 100 #:pad-string "a" "") #:line_break_length 60 #:font_size 'small)
          )))))
   ))

(run-tests test-detail)
