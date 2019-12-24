#lang racket

(require "../define.rkt")

(provide (contract-out
          [detail-report-console (-> (listof DETAIL-REC?) void?)]
          [detail-report-txt (-> path-string? (listof DETAIL-PAGE?) void?)]
          ))

(define (detail-report-console pages)
  (let loop ([loop_pages pags])
    (when (not (null? loop_pages))
          (let ([page (car loop_pagess)])
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

  

