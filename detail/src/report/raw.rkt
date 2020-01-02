#lang racket

(require "../define.rkt")

(provide (contract-out
          [detail-report-raw (-> (listof DETAIL-PAGE?) void?)]
          ))

(define (detail-report-raw pages)
  (let loop-page ([loop_pages pages])
    (when (not (null? loop_pages))
          (let* ([page (car loop_pages)]
                 [prefix_length (DETAIL-PAGE-prefix_length page)])
            (printf "PAGE-START\n")
            (let loop-rec ([recs (DETAIL-PAGE-recs page)])
              (when (not (null? recs))
                    (let ([rec (car recs)])
                      (cond
                       [(DETAIL-TITLE? rec)
                        (printf "DETAIL-TITLE:[~a][~a]\n" (DETAIL-TITLE-level rec) (DETAIL-TITLE-data rec))]
                       [(DETAIL-LINE? rec)
                        (printf "DETAIL-LINE:[~a]\n" (DETAIL-LINE-data rec))]
                       [(DETAIL-PREFIX-LINE? rec)
                        (printf "DETAIL-PREFIX-LINE:[~a][~a][~a]\n"
                                prefix_length
                                (DETAIL-PREFIX-LINE-prefix rec)
                                (DETAIL-LINE-data (DETAIL-PREFIX-LINE-line rec)))]
                       ))
                    (loop-rec (cdr recs))))
            (printf "PAGE-END\n"))
          (loop-page (cdr loop_pages)))))

  

