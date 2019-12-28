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
                     [output pdf_file]))
          (send dc start-doc "")
          (send dc set-font (make-font #:size 14)))
        (lambda ()
          (let loop-page ([loop_pages pages])
            (when (not (null? loop_pages))
                  (let* ([page (car loop_pages)]
                         [prefix_length (DETAIL-PAGE-prefix_length page)])

                    (dynamic-wind
                        (lambda () (send dc start-page))
                        (lambda ()
                          (let loop-rec ([recs (DETAIL-PAGE-recs page)]
                                         [loop_line 0])
                            (when (not (null? recs))
                                  (let ([rec (car recs)])
                                    (cond
                                     [(DETAIL-TITLE? rec)
                                      (cond
                                       [(eq? (DETAIL-TITLE-level rec) 'h1)
                                        (send dc set-font (make-font #:size 36))
                                        (send dc draw-text (DETAIL-TITLE-data rec) 0 loop_line)
                                        (send dc set-font (make-font #:size 14))
                                        (loop-rec (cdr recs) (+ loop_line 80))]
                                       [(eq? (DETAIL-TITLE-level rec) 'h2)
                                        (send dc set-font (make-font #:size 24))
                                        (send dc draw-text (DETAIL-TITLE-data rec) 0 loop_line)
                                        (send dc set-font (make-font #:size 14))
                                        (loop-rec (cdr recs) (+ loop_line 60))]
                                       [(eq? (DETAIL-TITLE-level rec) 'h3)
                                        (send dc set-font (make-font #:size 20))
                                        (send dc draw-text (DETAIL-TITLE-data rec) 0 loop_line)
                                        (send dc set-font (make-font #:size 14))
                                        (loop-rec (cdr recs) (+ loop_line 50))])]
                                     [(DETAIL-LINE? rec)
                                      (send dc draw-text (DETAIL-LINE-data rec) 0 loop_line)
                                      (loop-rec (cdr recs) (+ loop_line 32))]
                                     [(DETAIL-PREFIX-LINE? rec)
                                      (send dc draw-text
                                            (DETAIL-PREFIX-LINE-prefix rec)
                                            0 loop_line)
                                      (send dc draw-text (DETAIL-PREFIX-LINE-data rec) (* prefix_length 10) loop_line)
                                      (loop-rec (cdr recs) (+ loop_line 32))])))))
                        (lambda () (send dc end-page))))
                    (loop-page (cdr loop_pages)))))
        (lambda ()
          (send dc end-doc)))))
