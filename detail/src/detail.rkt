#lang racket

(require "define.rkt")
(require "report/report.rkt")

(provide (contract-out
          [detail (-> (or/c #f (listof (or/c 'raw 'console path-string?))) procedure? any)]
          [detail-add-rec (-> DETAIL-REC? void?)]
          [detail-h1 (-> string? void?)]
          [detail-h2 (-> string? void?)]
          [detail-h3 (-> string? void?)]
          [detail-line (-> string? void?)]
          [detail-page (-> procedure? void?)]
          ))

(define (detail detail_types proc)
  (parameterize ([*detail*
                  (if detail_types
                      (DETAIL detail_types '())
                      #f)])
       (dynamic-wind
          (lambda () (void))
          (lambda () (proc))
          (lambda ()
            (when (*detail*)
                  (detail-report (DETAIL-report (*detail*)) (DETAIL-recs (*detail*))))))))

(define (detail-add-rec detail_rec)
  (set-DETAIL-recs! (*detail*) `(,@(DETAIL-recs (*detail*)) ,detail_rec)))

(define (detail-h1 h1)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'h1 h1))))

(define (detail-h2 h2)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'h2 h2))))

(define (detail-h3 h3)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'h3 h3))))

(define (detail-line text)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'line text))))

(define (detail-page proc)
  (when (*detail*)
    (dynamic-wind
        (lambda () (detail-add-rec (DETAIL-REC 'page-start "")))
        (lambda () (proc))
        (lambda () (detail-add-rec (DETAIL-REC 'page-end ""))))))
