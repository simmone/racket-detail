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
          (let* ([page (car loop_pages)]
                 [prefix_length (DETAIL-PAGE-prefix_length page)])
            (let loop-rec ([recs (DETAIL-PAGE-recs page)])
              (when (not (null? recs))
                    (let ([rec (car recs)])
                      (cond
                       [(DETAIL-TITLE? rec)
                        (printf "~a\n\n" (DETAIL-TITLE-data rec))]
                       [(DETAIL-LINE? rec)
                        (let loop ([strs (zip-string (DETAIL-LINE-data rec) (*line_break_length*))])
                          (when (not (null? strs))
                            (printf "~a\n" (car strs))
                            (loop (cdr strs))))]
                       [(DETAIL-PREFIX-LINE? rec)
                        (printf (~a #:min-width prefix_length #:pad-string " " #:align 'right (DETAIL-PREFIX-LINE-prefix rec)))
                        (let loop ([strs (zip-string (DETAIL-PREFIX-LINE-data rec) (*line_break_length*))]
                                   [line_no 1])
                          (when (not (null? strs))
                            (if (= line_no 1)
                                (printf "~a\n" (car strs))
                                (printf "~a~a\n"
                                        (~a #:min-width prefix_length #:pad-string " ")
                                        (car strs)))
                            (loop (cdr strs) (add1 line_no))))]))
                      (loop-rec (cdr recs)))))
          (printf "----\n")
          (loop-page (cdr loop_pages)))))

(define (detail-report-txt txt_file recs)
  (with-output-to-file txt_file
    #:exists 'replace
    (lambda ()
      (detail-report-console recs))))

  

