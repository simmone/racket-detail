#lang racket

(provide (contract-out
          [*detail* parameter?]
          [struct
           DETAIL
           (
            (report (or/c #f (listof (or/c 'console path-string?))))
            (recs (listof DETAIL-REC?))
            )]
          [struct
           DETAIL-REC
           (
            (type (or/c
                   'title
                   'text
                   'section-start
                   'section-end
                   ))
            (data (or/c string?))
            )]
          ))

(define *detail* (make-parameter #f))

(struct
 DETAIL-REC
 (
  [type #:mutable]
  [data #:mutable]
  ))

(struct
 DETAIL
 (
  [report #:mutable]
  [recs #:mutable]
  ))

