#lang racket

(require "../define.rkt")

(provide (contract-out
          [detail-report-console (-> (listof DETAIL-PAGE?) void?)]
          [detail-report-txt (-> path-string? (listof DETAIL-PAGE?) void?)]
          ))

(define (detail-report-console pages)
  (let loop-page ([loop_pages pages])
    (when (not (null? loop_pages))
          (printf "----\n")
          (let* ([page (car loop_pages)]
                 [prefix_length (DETAIL-PAGE-prefix_length page)])
            (let loop-rec ([recs (DETAIL-PAGE-recs page)])
              (when (not (null? recs))
                    (let ([rec (car recs)])
                      (cond
                       [(DETAIL-TITLE? rec)
                        (printf "~a\n\n" (DETAIL-TITLE-data rec))]
                       [(DETAIL-LINE? rec)
                        (printf "~a\n" (DETAIL-LINE-data rec))]
                       [(DETAIL-PREFIX-LINE? rec)
                        (printf "~a~a\n"
                                (~a #:min-width prefix_length #:pad-string " " #:align 'right (DETAIL-PREFIX-LINE-prefix rec))
                                (DETAIL-PREFIX-LINE-data rec))]))
                      (loop-rec (cdr recs)))))
          (printf "----\n")
          (loop-page (cdr loop_pages)))))

(define (detail-report-txt txt_file recs)
  (with-output-to-file txt_file
    #:exists 'replace
    (lambda ()
      (detail-report-console recs))))

  

