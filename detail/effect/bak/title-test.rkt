#lang racket

(require rackunit)
(require rackunit/text-ui)

(require "../src/define.rkt")
(require "../src/detail.rkt")

(define test-detail
  (test-suite 
   "test-poem"
   
   (test-case
    "test-detail-title"

    (detail 
;     '(console "detail.pdf")
     #f
     void
     (lambda ()
       (detail-page
        (lambda ()
          (detail-h1 "The Tyger ")
          (detail-h2 "        BY WILLIAM BLAKE")
          (detail-h3 "Tyger Tyger, burning bright, ")
          (detail-h3 "In the forests of the night; ")
          (detail-h3 "What immortal hand or eye, ")
          (detail-h3 "Could frame thy fearful symmetry?")
          (detail-h3 "")
          (detail-h3 "In what distant deeps or skies. ")
          (detail-h3 "Burnt the fire of thine eyes?")
          (detail-h3 "On what wings dare he aspire?")
          (detail-h3 "What the hand, dare seize the fire?")
          (detail-h3 "")
          (detail-h3 "And what shoulder, & what art,")
          (detail-h3 "Could twist the sinews of thy heart?")
          (detail-h3 "And when thy heart began to beat,")
          (detail-h3 "What dread hand? & what dread feet?")
          (detail-h3 "")
          (detail-h3 "What the hammer? what the chain, ")
          (detail-h3 "In what furnace was thy brain?")
          (detail-h3 "What the anvil? what dread grasp, ")))
          
       (detail-page
        (lambda ()
          (detail-h3 "Dare its deadly terrors clasp! ")
          (detail-h3 "")
          (detail-h3 "When the stars threw down their spears ")
          (detail-h3 "And water'd heaven with their tears: ")
          (detail-h3 "Did he smile his work to see?")
          (detail-h3 "Did he who made the Lamb make thee?")
          (detail-h3 "")
          (detail-h3 "Tyger Tyger burning bright, ")
          (detail-h3 "In the forests of the night: ")
          (detail-h3 "What immortal hand or eye,")
          (detail-h3 "Dare frame thy fearful symmetry?")
          (detail-h3 "")
       )))))
   ))

(run-tests test-detail)
