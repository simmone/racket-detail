#lang racket

(provide (contract-out
          [*detail* parameter?]
          [*line_break_length* parameter?]
          [*font_size* parameter?]
          [struct
           DETAIL
           (
            (formats (or/c #f (listof (or/c 'raw 'console path-string?))))
            (pages (listof DETAIL-PAGE?))
            )]
          [struct
           DETAIL-PAGE
           (
            (recs (listof (or/c DETAIL-TITLE? DETAIL-LINE? DETAIL-LIST?)))
            )]
          [struct DETAIL-TITLE
                  (
                   (level (or/c 'h1 'h2 'h3))
                   (data string?)
                   )]
          [struct DETAIL-LINE
                  (
                   (line string?)
                   (line_break_length natural?)
                   (font_size (or/c 'normal 'big 'small))
                   )]
          [struct DETAIL-LIST
                  (
                   (rows (listof DETAIL-ROW?))
                   (cols_width (listof natural?))
                   (font_size (or/c 'normal 'big 'small))
                   )]
          [struct DETAIL-ROW
                  (
                   (cols (listof string?))
                   (tail_cols (listof (listof string?)))
                   )]
          ))

(define *detail* (make-parameter #f))
(define *line_break_length* (make-parameter #f))
(define *font_size* (make-parameter #f))

(struct
 DETAIL
 (
  [formats #:mutable]
  [pages #:mutable]
  ))

(struct
 DETAIL-PAGE
 (
  [recs #:mutable]
  ))

(struct
 DETAIL-TITLE
 (
  [level #:mutable]
  [data #:mutable]
  ))

(struct
 DETAIL-LINE
 (
  [line #:mutable]
  [line_break_length #:mutable]
  [font_size #:mutable]
  ))

(struct
 DETAIL-LIST
 (
  [rows #:mutable]
  [cols_width #:mutable]
  [font_size #:mutable]
  ))

(struct
 DETAIL-ROW
 (
  [cols #:mutable]
  [tail_cols #:mutable]
  ))
