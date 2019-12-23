#lang racket

(require "../define.rkt")

(provide (contract-out
          [detail-report-console (-> (listof DETAIL-REC?) void?)]
          [detail-report-txt (-> path-string? (listof DETAIL-REC?) void?)]
          ))

(define (detail-report-console recs)
  (let loop ([loop_recs recs])
    (when (not (null? loop_recs))
          (let ([rec (car loop_recs)])
            (cond
             [(eq? (DETAIL-REC-type rec) 'line)
              (printf "~a: ~a\n" (DETAIL-REC-prefix rec) (DETAIL-REC-data rec))]
             [else
              (printf "~a\n" (DETAIL-REC-data (car loop_recs)))]))
          (loop (cdr loop_recs)))))

(define (detail-report-txt txt_file recs)
  (with-output-to-file txt_file
    #:exists 'replace
    (lambda ()
      (detail-report-console recs))))

  

