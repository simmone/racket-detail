#lang racket

(require "../define.rkt")

(provide (contract-out
          [detail-report-raw (-> (listof DETAIL-PAGE?) void?)]
          ))

(define (detail-report-raw pages)
  (let loop-page ([loop_pages pages])
    (when (not (null? loop_pages))
          (let* ([page (car loop_pages)])
            (printf "PAGE-START\n")
            (let loop-rec ([recs (DETAIL-PAGE-recs page)])
              (when (not (null? recs))
                    (let ([rec (car recs)])
                      (cond
                       [(DETAIL-TITLE? rec)
                        (printf "DETAIL-TITLE:[~a][~a]\n" (DETAIL-TITLE-level rec) (DETAIL-TITLE-data rec))]
                       [(DETAIL-LINE? rec)
                        (let loop-item ([items (DETAIL-LINE-items rec)]
                                        [items_length (DETAIL-PAGE-items_length page)]
                                        [index 1])
                          (when (not (null? items))
                            (printf "[~a][~a][~a] "
                                    (~a #:min-width 5 index)
                                    (~a #:min-width 5 (car items_length))
                                    (~a #:min-width (car items_length) (car items)))
                            (loop-item (cdr items) (cdr items_length) (add1 index))))
                        (printf "\n")]
                       ))
                    (loop-rec (cdr recs))))
            (printf "PAGE-END\n"))
          (loop-page (cdr loop_pages)))))
