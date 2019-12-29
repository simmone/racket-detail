#lang racket

(provide (contract-out
          [*detail* parameter?]
          [*line_break_length* parameter?]
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
                   (data string?)
                   )]
          [struct DETAIL-PREFIX-LINE
                  (
                   (prefix string?)
                   (data string?)
                   )]
          ))

(define *detail* (make-parameter #f))
(define *line_break_length* (make-parameter #f))

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
  ))

(struct
 DETAIL-PREFIX-LINE
 (
  [prefix #:mutable]
  [data #:mutable]
  ))
