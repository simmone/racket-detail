#lang racket

(provide (contract-out
          [*detail* parameter?]
          [struct
           DETAIL
           (
            (report (or/c #f (listof (or/c 'raw 'console path-string?))))
            (recs (listof DETAIL-PAGE?))
            )]
          [struct
           DETAIL-PAGE
           (
            (prefix_length string?)
            (recs (listof DETAIL-REC?))
            )]
          [struct
           DETAIL-REC
           (
            (type (or/c
                   'h1
                   'h2
                   'h3
                   'line
                   'page-start
                   'page-end
                   ))
            (prefix string?)
            (data string?)
            )]
          ))

(define *detail* (make-parameter #f))

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
 DETAIL-REC
 (
  [type #:mutable]
  [prefix #:mutable]
  [data #:mutable]
  ))

