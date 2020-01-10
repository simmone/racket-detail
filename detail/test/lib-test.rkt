#lang racket

(require rackunit rackunit/text-ui)

(require "../src/lib.rkt")

(define test-detail
  (test-suite 
   "test-lib"
   
   (test-case
    "test-zip-string"
    
    (check-equal? (zip-string "1234" 1) '("1" "2" "3" "4"))

    (check-equal? (zip-string "1234" 2) '("12" "34"))

    (check-equal? (zip-string "1234" 3) '("123" "4"))

    (check-equal? (zip-string "1234" 4) '("1234"))

    (check-equal? (zip-string "1234" 5) '("1234"))

    (check-equal? (zip-string "" 32) '(""))
    )
   
   (test-case
    "test-rows->cols"

    (let ([rows '((1 2 3) (4 5 6) (7 8 9))])
      (check-equal?
       (rows->cols rows)
       '((1 4 7) (2 5 8) (3 6 9))))

    (let ([rows '((1 2) (4 5 6) (7 8 9))])
      (check-equal?
       (rows->cols rows)
       '((1 4 7) (2 5 8) (#f 6 9))))

    (let ([rows '((1) (4) (7 8 9))])
      (check-equal?
       (rows->cols rows #:fill 0)
       '((1 4 7) (0 0 8) (0 0 9))))

    )

   ))

(run-tests test-detail)
