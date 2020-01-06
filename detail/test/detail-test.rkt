#lang racket

(require rackunit rackunit/text-ui)

(require "../src/define.rkt")
(require "../src/detail.rkt")

(define test-detail
  (test-suite 
   "test-detail"
   
   (test-case
    "test-detail-hierachy"
    
    (detail
     #:line_break_length 1
     #:font_size 'small
     (lambda ()
       (check-equal? (*line_break_length*) 1)
       (check-equal? (*font_size*) 'small)
       
       (detail-page
        #:line_break_length 2
        #:font_size 'big
        (lambda ()
          (check-equal? (*line_break_length*) 2)
          (check-equal? (*font_size*) 'big)
          
          (detail-line
           #:line_break_length 3
           #:font_size 'normal
           (lambda ()
             (check-equal? (*line_break_length*) 3)
             (check-equal? (*font_size*) 'normal)))

          (detail-list
           #:line_break_length 4
           #:font_size 'small
           (lambda ()
             (check-equal? (*line_break_length*) 4)
             (check-equal? (*font_size*) 'small)
             
             (detail-line
              (lambda ()
                (check-equal? (*line_break_length*) 4)
                (check-equal? (*font_size*) 'small)))))

          (check-equal? (*line_break_length*) 2)
          (check-equal? (*font_size*) 'big)
          ))

       (check-equal? (*line_break_length*) 1)
       (check-equal? (*font_size*) 'small)
       ))
    )
   ))

(run-tests test-detail)
