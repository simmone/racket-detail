#lang racket

(require racket/draw)

(require "../define.rkt")

(provide (contract-out
          [detail-report-pdf (-> path-string? (listof DETAIL-REC?) void?)]
          ))

(define (detail-report-pdf pdf_file recs)
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

          (let loop ([loop_recs recs]
                     [loop_line 0])
            (when (not (null? loop_recs))
              (cond
               [(eq? (DETAIL-REC-type (car loop_recs)) 'title)
                (send dc set-font (make-font #:size 28))
                (send dc draw-text (DETAIL-REC-data (car loop_recs)) 0 loop_line)
                (send dc set-font (make-font #:size 14))]
               [(eq? (DETAIL-REC-type (car loop_recs)) 'line)
                (send dc draw-text (DETAIL-REC-data (car loop_recs)) 0 loop_line)]
               [(eq? (DETAIL-REC-type (car loop_recs)) 'page-start)
                (send dc start-page)
                (send dc set-font (make-font #:size 14))]
               [(eq? (DETAIL-REC-type (car loop_recs)) 'page-end)
                (send dc flush)
                (send dc end-page)])
              (loop (cdr loop_recs) (+ loop_line 28))))
          )
        (lambda ()
          (send dc end-doc)))))
