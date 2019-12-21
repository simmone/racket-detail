#lang racket

(require "src/define.rkt")
(require "src/detail.rkt")

(provide (contract-out
          [detail (-> (or/c #f (listof (or/c 'console path-string?))) procedure? any)]
          [detail-add-rec (-> DETAIL-REC? void?)]
          [detail-title (-> string? void?)]
          [detail-text (-> string? void?)]
          [detail-section-start (-> void?)]
          [detail-section-end (-> void?)]
          ))
