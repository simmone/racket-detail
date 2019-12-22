#lang racket

(require "../define.rkt")

(provide (contract-out
          [detail-report-raw (-> (listof DETAIL-REC?) void?)]
          ))

(define (detail-report-raw recs)
  (let loop ([loop_recs recs])
    (when (not (null? loop_recs))
          (printf "[~a]~a\n" (DETAIL-REC-type (car loop_recs)) (DETAIL-REC-data (car loop_recs)))
          (loop (cdr loop_recs)))))

  

