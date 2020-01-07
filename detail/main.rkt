#lang racket

(require "src/detail.rkt")

(provide (contract-out
          [detail (->*
                   (procedure?)
                   (
                    #:formats (or/c #f (listof (or/c 'raw 'console path-string?)))
                    #:exception_value any/c
                    #:line_break_length natural?
                    #:font_size (or/c 'normal 'big 'small)
                    ) any)]
          [detail-page (->*
                        (procedure?)
                        (
                         #:line_break_length natural?
                         #:font_size (or/c 'normal 'big 'small)
                         ) any)]
          [detail-h1 (-> string? void?)]
          [detail-h2 (-> string? void?)]
          [detail-h3 (-> string? void?)]
          [detail-line (->*
                        (string?)
                        (
                         #:line_break_length natural?
                         #:font_size (or/c 'normal 'big 'small)
                         ) void?)]
          [detail-list (->*
                        (procedure?)
                        (
                         #:font_size (or/c 'normal 'big 'small)
                         ) void?)]
          [detail-row (-> procedure? void?)]
          [detail-col (->* (string?) (#:width natural?) void?)]
          ))
