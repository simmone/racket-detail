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
                        (printf "DETAIL-LINE:[~a][~a][~a]\n"
                                (DETAIL-LINE-line rec)
                                (DETAIL-LINE-line_break_length rec)
                                (DETAIL-LINE-font_size rec))]
                       [(DETAIL-LIST? rec)
                        (printf "DETAIL-LIST:[~a]\n" (DETAIL-LIST-font_size rec))
                        (let loop-row ([rows (DETAIL-LIST-rows rec)]
                                       [row_index 1])
                          (when (not (null? rows))
                                (printf "[~a] " (~a #:min-width 3 row_index))

                                (let loop-col ([cols (DETAIL-ROW-cols (car rows))]
                                               [cols_width (DETAIL-LIST-cols_width rec)]
                                               [col_index 1])
                                  (when (not (null? cols))
                                        (printf "[~a][~a][~a] "
                                                (~a #:min-width 3 col_index)
                                                (~a #:min-width 3 (car cols_width))
                                                (~a #:min-width (car cols_width) (car cols)))
                                        (loop-col (cdr cols) (cdr cols_width) (add1 col_index))))
                                (printf "\n")
                                (loop-row (cdr rows) (add1 row_index))))]
                       ))
                    (loop-rec (cdr recs))))
            (printf "PAGE-END\n"))
          (loop-page (cdr loop_pages)))))
