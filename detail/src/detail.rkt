#lang racket

(require "define.rkt")
(require "report/report.rkt")

(provide (contract-out
          [detail (-> (or/c #f (listof (or/c 'raw 'console path-string?))) procedure? any)]
          [detail-add-rec (-> (or/c DETAIL-TITLE? DETAIL-LINE? DETAIL-PREFIX-LINE?) void?)]
          [detail-h1 (-> string? void?)]
          [detail-h2 (-> string? void?)]
          [detail-h3 (-> string? void?)]
          [detail-line (-> string? void?)]
          [detail-prefix-line (-> string? string? void?)]
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
  (when (and
         (DETAIL-PREFIX-LINE? detail_rec)
         (> (string-length (DETAIL-PREFIX-LINE-prefix detail_rec)) (DETAIL-PAGE-prefix_length (*current_page*))))
        (set-DETAIL-PAGE-prefix_length! (*current_page*) (string-length (DETAIL-PREFIX-LINE-prefix detail_rec))))
  (set-DETAIL-PAGE-recs! (*current_page*) `(,@(DETAIL-PAGE-recs (*current_page*)) ,detail_rec)))

(define (detail-h1 h1)
  (when (*detail*)
        (detail-add-rec (DETAIL-TITLE 'h1 h1))))

(define (detail-h2 h2)
  (when (*detail*)
        (detail-add-rec (DETAIL-TITLE 'h2 h2))))

(define (detail-h3 h3)
  (when (*detail*)
        (detail-add-rec (DETAIL-TITLE 'h3 h3))))

(define (detail-prefix-line prefix val)
  (when (*detail*)
        (detail-add-rec (DETAIL-PREFIX-LINE prefix val))))

(define (detail-line val)
  (when (*detail*)
        (detail-add-rec (DETAIL-LINE val))))

(define *current_page* (make-parameter #f))

(define (detail-page proc)
  (when (*detail*)
        (parameterize
         ([*current_page* (DETAIL-PAGE 0 '())])
         (dynamic-wind
             (lambda () (void))
             (lambda () (proc))
             (lambda ()
               (set-DETAIL-pages! (*detail*) `(,@(DETAIL-pages (*detail*)) ,(*current_page*))))))))
