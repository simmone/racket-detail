#lang racket

(require racket/draw)

(require "../define.rkt")
(require "../lib.rkt")

(provide (contract-out
          [detail-report-pdf (-> path-string? (listof DETAIL-PAGE?) void?)]
          ))

(define PAGE_WIDTH 595)
(define PAGE_HEIGHT 842)
(define NORMAL_FONT_SIZE 14)
(define BIG_FONT_SIZE 18)
(define SMALL_FONT_SIZE 10)
(define H1_FONT_SIZE 36)
(define H2_FONT_SIZE 24)
(define H3_FONT_SIZE 20)

(define (detail-report-pdf pdf_file pages)
  (let ([dc #f])
    (dynamic-wind
        (lambda ()
          (set! dc 
                (new pdf-dc%
                     [interactive #f]
                     [use-paper-bbox #f]
                     [width PAGE_WIDTH]
                     [height PAGE_HEIGHT]
                     [as-eps #f]
                     [output pdf_file]))
          (send dc start-doc "")
          (send dc set-font (make-font #:size NORMAL_FONT_SIZE)))
        (lambda ()
          (let loop-page ([loop_pages pages])
            (when (not (null? loop_pages))
              (let* ([page (car loop_pages)]
                     [prefix_length (DETAIL-PAGE-prefix_length page)])

                (dynamic-wind
                    (lambda () (send dc start-page))
                    (lambda ()
                      (let loop-rec ([recs (DETAIL-PAGE-recs page)]
                                     [loop_line 0]
                                     [sum_line 0])
                        (when (not (null? recs))
                          (let ([rec (car recs)])
                            (cond
                             [(DETAIL-TITLE? rec)
                              (cond
                               [(eq? (DETAIL-TITLE-level rec) 'h1)
                                (send dc set-font (make-font #:size H1_FONT_SIZE))
                                (send dc draw-text (DETAIL-TITLE-data rec) 0 loop_line)
                                (send dc set-font (make-font #:size NORMAL_FONT_SIZE))
                                (loop-rec (cdr recs) (+ loop_line 80) (+ sum_line 4))]
                               [(eq? (DETAIL-TITLE-level rec) 'h2)
                                (send dc set-font (make-font #:size H2_FONT_SIZE))
                                (send dc draw-text (DETAIL-TITLE-data rec) 0 loop_line)
                                (send dc set-font (make-font #:size NORMAL_FONT_SIZE))
                                (loop-rec (cdr recs) (+ loop_line 60) (+ sum_line 3))]
                               [(eq? (DETAIL-TITLE-level rec) 'h3)
                                (send dc set-font (make-font #:size H3_FONT_SIZE))
                                (send dc draw-text (DETAIL-TITLE-data rec) 0 loop_line)
                                (send dc set-font (make-font #:size NORMAL_FONT_SIZE))
                                (loop-rec (cdr recs) (+ loop_line 50) (+ sum_line 2)])]
                             [(DETAIL-LINE? rec)
                              (loop-rec (cdr recs) (draw-lines dc 0 loop_line rec))]
                             [(DETAIL-PREFIX-LINE? rec)
                              (send dc draw-text (DETAIL-PREFIX-LINE-prefix rec) 0 loop_line rec)
                              (loop-rec (cdr recs) (draw-lines dc (* prefix_length 10) loop_line (DETAIL-PREFIX-LINE-line rec)))])))))
                    (lambda () (send dc end-page))))
              (loop-page (cdr loop_pages)))))
        (lambda ()
          (send dc end-doc)))))

(define (draw-lines dc start_x_pos start_y_pos rec)
  (cond
   [(eq? (DETAIL-LINE-font_size rec) 'big)
    (send dc set-font (make-font #:size BIG_FONT_SIZE))]
   [(eq? (DETAIL-LINE-font_size rec) 'small)
    (send dc set-font (make-font #:size SMALL_FONT_SIZE))]
   [else
    (send dc set-font (make-font #:size NORMAL_FONT_SIZE))])

  (let loop ([strs (zip-string (DETAIL-LINE-data rec) (DETAIL-LINE-line_break_length rec))]
             [y_pos start_y_pos])
    (if (not (null? strs))
        (begin
          (send dc draw-text (car strs) start_x_pos y_pos)
          (loop (cdr strs) (+ y_pos 32)))
        y_pos)))

(define (draw-line dc str x_pos y_pos line_count)
  (if (> (add1 line_count))
        (send dc end-page)
        (send dc start-page)
        (send dc draw-text str x_pos 0)
