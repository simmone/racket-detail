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
          (send dc set-font (make-font #:size 8))
          (send dc start-doc "")
          (send dc start-page)

          (let loop ([loop_recs recs]
                     [loop_line 0])
            (when (not (null? loop_recs))
              (send dc draw-text (DETAIL-REC-data (car loop_recs)) loop_line 0)
              (loop (cdr loop_recs) (+ loop_line 10))))
          )
        (lambda ()
          (send dc end-page)
          (send dc end-doc)))))

  

