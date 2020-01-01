#lang racket

(require "src/define.rkt")
(require "src/detail.rkt")

(provide (contract-out
          [detail (-> (or/c #f (listof (or/c 'raw 'console path-string?))) any/c procedure? any)]
          [detail-add-rec (-> (or/c DETAIL-TITLE? DETAIL-LINE? DETAIL-PREFIX-LINE?) void?)]
          [detail-h1 (-> string? void?)]
          [detail-h2 (-> string? void?)]
          [detail-h3 (-> string? void?)]
          [detail-line (->* (string?) (#:line_break_length natural? #:font_size (or/c 'normal 'big 'small)) void?)]
          [detail-prefix-line (->* (string? string?) (#:line_break_length natural? #:font_size (or/c 'normal 'big 'small)) void?)]
          [detail-page (->* (procedure?) (#:line_break_length natural? #:font_size (or/c 'normal 'big 'small)) any)]
          ))
