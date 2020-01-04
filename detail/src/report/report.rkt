#lang racket

(require "../define.rkt")
(require "raw.rkt")
;; (require "console-txt.rkt")
;; (require "pdf.rkt")

(provide (contract-out
          [detail-report (-> DETAIL? void?)]
          ))

(define (detail-report detail)
  (let loop ([loop_formats (DETAIL-formats detail)])
    (when (not (null? loop_formats))
      (let ([pages (DETAIL-pages detail)])
        (cond
         [(eq? (car loop_formats) 'raw)
          (detail-report-raw pages)]
;       [(eq? (car loop_formats) 'console)
;        (detail-report-console recs)]
;       [(regexp-match #rx"\\.txt$" (car loop_formats))
;        (detail-report-txt (car loop_formats) recs)]
;       [(regexp-match #rx"\\.pdf$" (car loop_formats))
;        (detail-report-pdf (car loop_formats) recs)]
         [else
          (detail-report-raw pages)])
      (loop (cdr loop_formats))))))
  

