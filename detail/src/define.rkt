#lang racket

(provide (contract-out
          [*detail* parameter?]
          [*page_line_break_length* parameter?]
          [*page_font_size* parameter?]
          [struct
           DETAIL
           (
            (report (or/c #f (listof (or/c 'raw 'console path-string?))))
            (pages (listof DETAIL-PAGE?))
            )]
          [struct
           DETAIL-PAGE
           (
            (prefix_length natural?)
            (recs (listof (or/c DETAIL-TITLE? DETAIL-LINE? DETAIL-PREFIX-LINE?)))
            )]
          [struct DETAIL-TITLE
                  (
                   (level (or/c 'h1 'h2 'h3))
                   (data string?)
                   )]
          [struct DETAIL-LINE
                  (
                   (item DETAIL-ITEM?)
                   (line_break_length natural?)
                   (font_size (or/c 'normal 'big 'small))
                   )]
          [struct DETAIL-ITEM
                  (
                   (data string?)
                   )]
          ))

(define *detail* (make-parameter #f))
(define *page_line_break_length* (make-parameter #f))
(define *page_font_size* (make-parameter #f))

(struct
 DETAIL
 (
  [report #:mutable]
  [pages #:mutable]
  ))

(struct
 DETAIL-PAGE
 (
  [prefix_length #:mutable]
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
  [data #:mutable]
  [line_break_length #:mutable]
  [font_size #:mutable]
  ))

(struct
 DETAIL-PREFIX-LINE
 (
  [prefix #:mutable]
  [line #:mutable]
  ))
