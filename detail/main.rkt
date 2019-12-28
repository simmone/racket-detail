#lang racket

(require "src/define.rkt")
(require "src/detail.rkt")

(provide (contract-out
          [detail (-> (or/c #f (listof (or/c 'raw 'console path-string?))) any/c procedure? any)]
          [detail-add-rec (-> (or/c DETAIL-TITLE? DETAIL-LINE? DETAIL-PREFIX-LINE?) void?)]
          [detail-h1 (-> string? void?)]
          [detail-h2 (-> string? void?)]
          [detail-h3 (-> string? void?)]
          [detail-line (-> string? void?)]
          [detail-prefix-line (-> string? string? void?)]
          [detail-page (-> procedure? void?)]
          ))
