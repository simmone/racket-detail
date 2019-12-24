#lang racket

(require "define.rkt")
(require "report/report.rkt")

(provide (contract-out
          [detail (-> (or/c #f (listof (or/c 'raw 'console path-string?))) procedure? any)]
          [detail-add-rec (-> DETAIL-REC? void?)]
          [detail-h1 (-> string? void?)]
          [detail-h2 (-> string? void?)]
          [detail-h3 (-> string? void?)]
          [detail-line (-> string? string? void?)]
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
                  (detail-report (DETAIL-report (*detail*)) (DETAIL-pages (*detail*))))))))

(define (detail-add-rec detail_rec)
  (set-DETAIL-PAGE-recs! (*current_page*) `(,@(DETAIL-PAGE-recs (*current_page*)) ,detail_rec)))

(define (detail-h1 h1)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'h1 "" h1))))

(define (detail-h2 h2)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'h2 "" h2))))

(define (detail-h3 h3)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'h3 "" h3))))

(define (detail-line prefix val)
  (when (*detail*)
        (detail-add-rec (DETAIL-REC 'line prefix val))))

(define *current_page* (make-parameter #f))

(define (detail-page proc)
  (when (*detail*)
        (parameterize
         ([*current_page* (DETAIL-PAGE 0 '())])
         (dynamic-wind
             (lambda () (detail-add-rec (DETAIL-REC 'page-start "" "")))
             (lambda () (proc))
             (lambda ()
               (detail-add-rec (DETAIL-REC 'page-end "" ""))
               (set-DETAIL-pages! (*detail*) `(,@(DETAIL-pages (*detail*)) ,(*current_page*))))))))
