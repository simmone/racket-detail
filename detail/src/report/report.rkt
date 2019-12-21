#lang racket

(require "../define.rkt")
(require "console-txt.rkt")
(require "pdf.rkt")

(provide (contract-out
          [detail-report (-> (listof (or/c 'console path-string?)) (listof DETAIL-REC?) void?)]
          ))

(define (detail-report types recs)
  (let loop ([loop_types types])
    (when (not (null? loop_types))
      (cond
       [(eq? (car loop_types) 'console)
        (detail-report-console recs)]
       [(regexp-match #rx"\\.txt$" (car loop_types))
        (detail-report-txt (car loop_types) recs)]
       [(regexp-match #rx"\\.pdf$" (car loop_types))
        (detail-report-pdf (car loop_types) recs)]
       [else
        (detail-report-console recs)])
      (loop (cdr loop_types)))))
  

