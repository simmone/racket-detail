#lang racket

(require rackunit)
(require rackunit/text-ui)

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
    )))

(run-tests test-detail)
