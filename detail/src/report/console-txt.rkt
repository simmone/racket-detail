#lang racket

(require "../define.rkt")

(provide (contract-out
          [detail-report-console (-> (listof DETAIL-PAGE?) void?)]
          [detail-report-txt (-> path-string? (listof DETAIL-PAGE?) void?)]
          ))

(define (detail-report-console pages)
  (let loop-page ([loop_pages pages])
    (when (not (null? loop_pages))
          (let* ([page (car loop_pages)]
                 [prefix_length (DETAIL-PAGE-prefix_length page)])
            (let loop-rec ([recs (DETAIL-PAGE-recs page)])
              (when (not (null? recs))
                    (let ([rec (car recs)])
                      (cond
                       [(eq? (DETAIL-REC-type rec) 'line)
                        (printf "~a: ~a\n" (~a #:min-width 5 #:pad-string " " #:align 'right (DETAIL-REC-prefix rec)) (DETAIL-REC-data rec))]
                       [else
                        (printf "~a: ~a\n" (~a #:min-width 5 #:pad-string " " #:align 'right (DETAIL-REC-prefix rec)) (DETAIL-REC-data rec))])
                      (loop-rec (cdr recs))))))
          (loop-page (cdr loop_pages)))))

(define (detail-report-txt txt_file recs)
  (with-output-to-file txt_file
    #:exists 'replace
    (lambda ()
      (detail-report-console recs))))

  

