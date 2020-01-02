#lang racket

(require "define.rkt")
(require "report/report.rkt")

(provide (contract-out
          [detail (-> (or/c #f (listof (or/c 'raw 'console path-string?))) any/c procedure? any)]
          [detail-add-rec (-> (or/c DETAIL-TITLE? DETAIL-LINE? DETAIL-PREFIX-LINE?) void?)]
          [detail-h1 (-> string? void?)]
          [detail-h2 (-> string? void?)]
          [detail-h3 (-> string? void?)]
          [detail-line (->* (string?) (#:line_break_length natural? #:font_size (or/c 'normal 'big 'small)) void?)]
          [detail-prefix-line (->* (string? string?) (#:line_break_length natural? #:font_size (or/c 'normal 'big 'small)) void?)]
          [detail-page (->* (procedure?) (#:page_line_break_length natural? #:page_font_size (or/c 'normal 'big 'small)) any)]
          ))

(define (detail detail_types exception_value proc)
  (parameterize ([*detail*
                  (if detail_types
                      (DETAIL detail_types '())
                      #f)]
                 [*page_line_break_length* 60]
                 [*page_font_size* 'normal])
       (dynamic-wind
          (lambda () (void))
          (lambda ()
            (with-handlers ([exn:fail?
                             (lambda (e)
                               (detail-page
                                (lambda ()
                                  (detail-line (exn-message e))))
                               (when (*detail*) (detail-report (DETAIL-report (*detail*)) (DETAIL-pages (*detail*))))
                               exception_value)])
                           (proc)))
          (lambda ()
            (when (*detail*)
                  (detail-report (DETAIL-report (*detail*)) (DETAIL-pages (*detail*))))))))

(define (detail-add-rec rec)
  (when (and
         (DETAIL-PREFIX-LINE? rec)
         (> (string-length (DETAIL-PREFIX-LINE-prefix rec)) (DETAIL-PAGE-prefix_length (*current_page*))))
        (set-DETAIL-PAGE-prefix_length! (*current_page*) (string-length (DETAIL-PREFIX-LINE-prefix rec))))
  (set-DETAIL-PAGE-recs! (*current_page*) `(,@(DETAIL-PAGE-recs (*current_page*)) ,rec)))

(define (detail-h1 h1)
  (when (*detail*)
        (detail-add-rec (DETAIL-TITLE 'h1 h1))))

(define (detail-h2 h2)
  (when (*detail*)
        (detail-add-rec (DETAIL-TITLE 'h2 h2))))

(define (detail-h3 h3)
  (when (*detail*)
        (detail-add-rec (DETAIL-TITLE 'h3 h3))))

(define (detail-line
         val
         #:line_break_length [line_break_length (*page_line_break_length*)]
         #:font_size [font_size (*page_font_size*)])
  (when (*detail*)
    (detail-add-rec (DETAIL-LINE val line_break_length font_size))))

(define (detail-prefix-line prefix  val
         #:line_break_length [line_break_length (*page_line_break_length*)]
         #:font_size [font_size (*page_font_size*)])
  (when (*detail*)
    (detail-add-rec (DETAIL-PREFIX-LINE prefix (DETAIL-LINE val line_break_length font_size)))))

(define *current_page* (make-parameter #f))

(define (detail-page
         proc
         #:page_line_break_length [page_line_break_length (*page_line_break_length*)]
         #:page_font_size [page_font_size (*page_font_size*)])
  (if (*detail*)
      (parameterize
          ([*current_page* (DETAIL-PAGE 0 '())]
           [*page_line_break_length* page_line_break_length]
           [*page_font_size* page_font_size])
        (dynamic-wind
            (lambda () (void))
            (lambda () (proc))
            (lambda ()
              (set-DETAIL-pages! (*detail*) `(,@(DETAIL-pages (*detail*)) ,(*current_page*))))))
      (proc)))
