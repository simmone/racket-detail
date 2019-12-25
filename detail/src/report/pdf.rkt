#lang racket

(require racket/draw)

(require "../define.rkt")

(provide (contract-out
          [detail-report-pdf (-> path-string? (listof DETAIL-PAGE?) void?)]
          ))

(define (detail-report-pdf pdf_file pages)
  (let ([dc #f])
    (dynamic-wind
        (lambda ()
          (set! dc 
                (new pdf-dc%
                     [interactive #f]
                     [use-paper-bbox #f]
                     [width 595]
                     [height 842]
                     [as-eps #f]
                     [output pdf_file])))
        (lambda ()
          (send dc start-doc "")

          (let loop-page ([loop_pages pages])
            (when (not (null? loop_pages))
                  (let* ([page (car loop_pages)]
                         [prefix_length (DETAIL-PAGE-prefix_length page)])

                    (send dc start-page)
                    (send dc set-font (make-font #:size 14))

                    (let loop-rec ([recs (DETAIL-PAGE-recs page)]
                                   [loop_line 0])
                      (when (not (null? recs))
                            (let* ([rec (car recs)]
                                   [type (DETAIL-REC-type rec)]
                                   [prefix (DETAIL-REC-prefix rec)]
                                   [data (DETAIL-REC-data rec)])
                              (cond
                               [(eq? type 'h1)
                                (send dc set-font (make-font #:size 36))
                                (send dc draw-text data 0 loop_line)
                                (send dc set-font (make-font #:size 14))
                                (loop-rec (cdr recs) (+ loop_line 80))]
                               [(eq? type 'h2)
                                (send dc set-font (make-font #:size 24))
                                (send dc draw-text data 0 loop_line)
                                (send dc set-font (make-font #:size 14))
                                (loop-rec (cdr recs) (+ loop_line 60))]
                               [(eq? type 'h3)
                                (send dc set-font (make-font #:size 20))
                                (send dc draw-text data 0 loop_line)
                                (send dc set-font (make-font #:size 14))
                                (loop-rec (cdr recs) (+ loop_line 50))]
                               [(eq? type 'line)
                                (if (string=? data "")
                                    (send dc draw-text data 0 "\n")
                                    (send dc draw-text data 0
                                          (format "~a: ~a\n" (~a #:min-width prefix_length #:pad-string " " #:align 'right prefix) data)))
                                (loop-rec (cdr recs) (+ loop_line 32))]))))
                    (send dc end-page)
                    (loop-page (cdr loop_pages))))))
        (lambda ()
          (send dc end-doc)))))
