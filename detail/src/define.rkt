#lang racket

(provide (contract-out
          [*detail* parameter?]
          [struct
           DETAIL
           (
            (report (or/c #f (listof (or/c 'raw 'console path-string?))))
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

(define ** (make-parameter #f))

(struct
 DETAIL-REC
 (
  [type #:mutable]
  [prefix #:mutable]
  [data #:mutable]
  ))

(struct
 DETAIL
 (
  [report #:mutable]
  [recs #:mutable]
  ))

