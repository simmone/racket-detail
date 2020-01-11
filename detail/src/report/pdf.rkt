#lang racket

(require racket/draw)

(require "../define.rkt")
(require "../lib.rkt")

(provide (contract-out
          [detail-report-pdf (-> path-string? (listof DETAIL-PAGE?) void?)]
          ))

(define PAGE_WIDTH 595)
(define PAGE_HEIGHT 842)
(define PAGE_LENGTH 1000)
(define NORMAL_FONT_SIZE 14)
(define BIG_FONT_SIZE 18)
(define SMALL_FONT_SIZE 10)
(define H1_FONT_SIZE 36)
(define H1_HEIGHT 40)
(define H2_FONT_SIZE 24)
(define H2_HEIGHT 30)
(define H3_FONT_SIZE 20)
(define H3_HEIGHT 10)
(define LINE_HEIGHT 30)

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
              (let* ([page (car loop_pages)])
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
                                (send dc set-font (make-font #:size H1_FONT_SIZE))
                                (loop-rec (cdr recs) (+ H1_HEIGHT (draw-str dc (DETAIL-TITLE-data rec) 0 loop_line)))]
                               [(eq? (DETAIL-TITLE-level rec) 'h2)
                                (send dc set-font (make-font #:size H2_FONT_SIZE))
                                (loop-rec (cdr recs) (+ H2_HEIGHT (draw-str dc (DETAIL-TITLE-data rec) 0 loop_line)))]
                               [(eq? (DETAIL-TITLE-level rec) 'h3)
                                (send dc set-font (make-font #:size H3_FONT_SIZE))
                                (loop-rec (cdr recs) (+ H3_HEIGHT (draw-str dc (DETAIL-TITLE-data rec) 0 loop_line)))])]
                             [(DETAIL-LINE? rec)
                              (send dc set-font (make-font #:size NORMAL_FONT_SIZE))
                              (loop-rec
                               (cdr recs)
                               (draw-lines
                                dc
                                0
                                loop_line
                                (zip-string (DETAIL-LINE-line rec) (DETAIL-LINE-line_break_length rec))
                                (DETAIL-LINE-font_size rec)))]
                             [(DETAIL-LIST? rec)
                              (send dc set-font (make-font #:size NORMAL_FONT_SIZE))
                              (loop-rec
                               (cdr recs)
                               (draw-rows dc 0 loop_line (DETAIL-LIST-cols_width rec) (DETAIL-LIST-rows rec) (DETAIL-LIST-font_size rec)))])))))
                    (lambda () (send dc end-page))))
              (loop-page (cdr loop_pages)))))
        (lambda ()
          (send dc end-doc)))))

(define (draw-lines dc start_x_pos start_y_pos lines font_size)
  (cond
   [(eq? font_size 'big)
    (send dc set-font (make-font #:size BIG_FONT_SIZE))]
   [(eq? font_size 'small)
    (send dc set-font (make-font #:size SMALL_FONT_SIZE))]
   [else
    (send dc set-font (make-font #:size NORMAL_FONT_SIZE))])

  (let loop ([loop_lines lines]
             [y_pos start_y_pos])
    (if (not (null? loop_lines))
        (loop (cdr loop_lines) (+ y_pos (draw-str dc (car loop_lines) start_x_pos y_pos)))
        y_pos)))

(define (draw-rows dc start_x_pos start_y_pos cols_width rows font_size)
  (cond
   [(eq? font_size 'big)
    (send dc set-font (make-font #:size BIG_FONT_SIZE))]
   [(eq? font_size 'small)
    (send dc set-font (make-font #:size SMALL_FONT_SIZE))]
   [else
    (send dc set-font (make-font #:size NORMAL_FONT_SIZE))])
  
  (let loop-row ([loop_rows rows]
                 [y_pos start_y_pos])
    (printf "y: ~a\n" y_pos)
    (if (not (null? loop_rows))
        (loop-row
         (cdr loop_rows)
         (let loop-col ([loop_cols (DETAIL-ROW-cols (car loop_rows))]
                        [loop_widths cols_width]
                        [x_pos start_x_pos]
                        [next_y_pos y_pos])
           (printf "x: ~a next_y_pos: ~a\n" x_pos next_y_pos)
           (if (not (null? loop_cols))
               (loop-col (cdr loop_cols) (cdr loop_widths) (+ x_pos (* (car loop_widths) 20))
                         (draw-str dc (car loop_cols) x_pos y_pos))
               next_y_pos)))
        y_pos)))

(define (draw-str dc str x_pos y_pos)
  (if (> y_pos PAGE_LENGTH)
      (begin
        (send dc end-page)
        (send dc start-page)
        (send dc draw-text str x_pos 0)
        LINE_HEIGHT)
      (begin
        (send dc draw-text str x_pos y_pos)
        (+ y_pos LINE_HEIGHT))))
