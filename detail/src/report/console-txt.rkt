#lang racket

(require "../define.rkt")
(require "../lib.rkt")

(provide (contract-out
          [detail-report-console (-> (listof DETAIL-PAGE?) void?)]
          [detail-report-txt (-> path-string? (listof DETAIL-PAGE?) void?)]
          ))

(define (detail-report-console pages)
  (let loop-page ([loop_pages pages])
    (when (not (null? loop_pages))
          (printf "----\n")
          (let* ([page (car loop_pages)])
            (let loop-rec ([recs (DETAIL-PAGE-recs page)])
              (when (not (null? recs))
                    (let ([rec (car recs)])
                      (cond
                       [(DETAIL-TITLE? rec)
                        (printf "~a\n\n" (DETAIL-TITLE-data rec))]
                       [(DETAIL-LINE? rec)
                        (let* ([line (DETAIL-LINE-line rec)]
                               [line_break_length (DETAIL-LINE-line_break_length rec)])
                          (let ([strs (zip-string line line_break_length)])
                            (let loop-split ([loop_strs strs])
                              (when (not (null? loop_strs))
                                (printf "~a\n" (car loop_strs))
                                (loop-split (cdr loop_strs))))))]
                       [(DETAIL-LIST? rec)
                        (let* ([cols_width (DETAIL-LIST-cols_width rec)])
                          (let loop-row ([rows (DETAIL-LIST-rows rec)])
                            (when (not (null? rows))
                              (let* ([row (car rows)]
                                     [cols (DETAIL-ROW-cols row)])
                                (let loop-cols ([loop_cols cols]
                                                [loop_cols_width cols_width])
                                  (if (not (null? loop_cols))
                                      (begin
                                        (printf "~a " (~a #:min-width (car loop_cols_width) (car loop_cols)))
                                        (loop-cols (cdr loop_cols) (cdr loop_cols_width)))
                                      (printf "\n"))))
                              (loop-row (cdr rows)))))]))
                    (loop-rec (cdr recs))))
          (printf "----\n")
          (loop-page (cdr loop_pages))))))

(define (detail-report-txt txt_file recs)
  (with-output-to-file txt_file
    #:exists 'replace
    (lambda ()
      (detail-report-console recs))))
