#lang racket

(require rackunit)
(require rackunit/text-ui)

(require "../src/define.rkt")
(require "../src/detail.rkt")

(define test-detail
  (test-suite 
   "test-detail"
   
   (test-case
    "test-detail-page-auto-split"

    (detail 
;     '(console "detail.pdf")
     #f
     void
     (lambda ()
       (detail-page
        (lambda ()
          (let loop ([i 0])
            (when (< i 100)
                  (detail-line (number->string i))
                  (loop (add1 i))))

          (let loop ([i 0])
            (when (< i 50)
                  (detail-prefix-line (format "~a: " i) (~a #:min-width 100 #:pad-string "a" "") #:line_break_length 60 #:font_size 'small)
                  (loop (add1 i)))))))))
   ))

(run-tests test-detail)
