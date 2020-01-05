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
                 [items_length (DETAIL-PAGE-items_length page)])
            (let loop-rec ([recs (DETAIL-PAGE-recs page)])
              (when (not (null? recs))
                    (let ([rec (car recs)])
                      (cond
                       [(DETAIL-TITLE? rec)
                        (printf "~a\n\n" (DETAIL-TITLE-data rec))]
                       [(DETAIL-LINE? rec)
                        (let* ([items (DETAIL-LINE-items rec)]
                               [items_length (DETAIL-PAGE-items_length page)]
                               [line_break_length (DETAIL-LINE-line_break_length rec)]
                               [prefix_length
                                (if (<= (length items_length) 1)
                                    0
                                    (foldr + 0 (cdr (reverse items_length))))])
                          (let loop-item ([loop_items items]
                                          [loop_items_length items_length]
                                          [index 1])
                            (when (not (null? loop_items))
                              (if (= (length loop_items) 1)
                                  (if (> line_break_length prefix_length)
                                      (let ([strs (zip-string (car loop_items) (- line_break_length prefix_length))])
                                        (printf "~a\n" (~a #:min-width (car loop_items_length) (car strs)))
                                        (let loop-split ([loop_strs (cdr strs)])
                                          (when (not (null? loop_strs))
                                            (printf "~a\n" (~a #:min-width prefix_length #:pad-string " " #:align 'right (car loop_strs)))
                                            (loop-split (cdr loop_strs)))))
                                      (printf "~a\n" (~a #:min-width (car loop_items_length) (car loop_items))))
                                  (printf "~a " (~a #:min-width (car loop_items_length) (car loop_items))))
                              (loop-item (cdr loop_items) (cdr loop_items_length) (add1 index)))))]))
                    (loop-rec (cdr recs)))))
          (printf "----\n")
          (loop-page (cdr loop_pages)))))

(define (detail-report-txt txt_file recs)
  (with-output-to-file txt_file
    #:exists 'replace
    (lambda ()
      (detail-report-console recs))))
