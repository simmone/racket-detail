#lang racket

(require "src/detail.rkt")

(provide (contract-out
          [detail (->*
                   (procedure?)
                   (
                    #:formats? (or/c #f (listof (or/c 'raw 'console path-string?)))
                    #:exception_value? any/c
                    #:line_break_length? natural?
                    #:font_size? (or/c 'normal 'big 'small)
                    ) any)]
          [detail-page (->*
                        (procedure?)
                        (
                         #:line_break_length? natural?
                         #:font_size? (or/c 'normal 'big 'small)
                         ) any)]
          [detail-new-page (-> any)]
          [detail-div (->*
                        (procedure?)
                        (
                         #:line_break_length? natural?
                         #:font_size? (or/c 'normal 'big 'small)
                         ) any)]
          [detail-h1 (-> string? void?)]
          [detail-h2 (-> string? void?)]
          [detail-h3 (-> string? void?)]
          [detail-line (->*
                        (string?)
                        (
                         #:line_break_length? natural?
                         #:font_size? (or/c 'normal 'big 'small)
                         ) any)]
          [detail-lines (->*
                        ((listof string?))
                        (
                         #:line_break_length? natural?
                         #:font_size? (or/c 'normal 'big 'small)
                         ) any)]
          [detail-list (->*
                        (procedure?)
                        (
                         #:font_size? (or/c 'normal 'big 'small)
                         ) any)]
          [detail-row (-> procedure? any)]
          [detail-col (->* (string?) (#:width? natural?) any)]
          [detail-simple-list (->*
                        ((listof string?))
                        (
                         #:font_size? (or/c 'normal 'big 'small)
                         #:cols_count? natural?
                         #:col_width? natural?
                         ) any)]
          [detail-img (->
                       path-string?
                       natural?
                       any)]
          ))
