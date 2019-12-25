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
                    (let* ([rec (car recs)]
                           [type (DETAIL-REC-type rec)]
                           [prefix (DETAIL-REC-prefix rec)]
                           [data (DETAIL-REC-data rec)])
                      (cond
                       [(eq? type 'line)
                        (if (string=? data "")
                            (printf "\n")
                            (printf "~a: ~a\n" (~a #:min-width prefix_length #:pad-string " " #:align 'right prefix) data))]
                       [else
                            (printf "~a\n" data)]))
                      (loop-rec (cdr recs)))))
          (loop-page (cdr loop_pages)))))

(define (detail-report-txt txt_file recs)
  (with-output-to-file txt_file
    #:exists 'replace
    (lambda ()
      (detail-report-console recs))))

  

