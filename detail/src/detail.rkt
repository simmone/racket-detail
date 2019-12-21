#lang racket

(require "define.rkt")
(require "report/report.rkt")

(provide (contract-out
          [detail (-> (or/c #f (listof (or/c 'console path-string?))) procedure? any)]
          [detail-add-rec (-> DETAIL-REC? void?)]
          [detail-title (-> string? void?)]
          [detail-text (-> string? void?)]
          [detail-section-start (-> void?)]
          [detail-section-end (-> void?)]
          ))

(define (detail detail_types proc)
  (parameterize ([*detail*
                  (if detail_types
                      (DETAIL detail_types '())
                      #f)])
       (dynamic-wind
          (lambda () (void))
          (lambda ()
            (proc))
          (lambda ()
            (when (*detail*)
                  (detail-report (DETAIL-report (*detail*)) (DETAIL-recs (*detail*))))))))

(define (detail-add-rec detail_rec)
  (set-DETAIL-recs! (*detail*) `(,@(DETAIL-recs (*detail*)) ,detail_rec)))

(define (detail-title title)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'title title))))

(define (detail-text text)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'text text))))

(define (detail-section-start)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'section-start ""))))

(define (detail-section-end)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'section-end ""))))
