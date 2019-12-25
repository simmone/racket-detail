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
            (printf "prefix_length: ~a\n" prefix_length)
            (let loop-rec ([recs (DETAIL-PAGE-recs page)])
              (when (not (null? recs))
                    (let* ([rec (car recs)]
                           [type (DETAIL-REC-type rec)]
                           [prefix (DETAIL-REC-prefix rec)]
                           [data (DETAIL-REC-data rec)])
                      (printf "[~a][~a][~a]\n" type prefix data))
                    (loop-rec (cdr recs)))))
          (loop-page (cdr loop_pages)))))

  

