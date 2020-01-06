#lang racket

(require "define.rkt")
(require "report/report.rkt")

(provide (contract-out
          [detail (->*
                   (procedure?)
                   (
                    #:formats (or/c #f (listof (or/c 'raw 'console path-string?)))
                    #:exception_value any/c
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
                         #:line_break_length natural?
                         #:font_size (or/c 'normal 'big 'small)
                         ) void?)]
          [detail-list-add-col (-> string? void?)]
          [detail-page (->*
                        (procedure?)
                        (
                         #:line_break_length natural?
                         #:font_size (or/c 'normal 'big 'small)
                         ) any)]
          ))

(define (detail
         #:formats [formats #f]
         #:exception_value [exception_value #f]
         #:line_break_length [line_break_length 60]
         #:font_size [font_size 'normal]
         proc)
  (parameterize ([*detail*
                  (if formats
                      (DETAIL formats '())
                      #f)]
                 [*line_break_length* 60]
                 [*font_size* 'normal])
       (dynamic-wind
          (lambda () (void))
          (lambda ()
            (with-handlers ([exn:fail?
                             (lambda (e)
                               (detail-page
                                (lambda ()
                                  (detail-line (exn-message e))))
                               (when (*detail*) (detail-report (*detail*)))
                               exception_value)])
            (proc)))
          (lambda ()
            (when (*detail*)
                  (detail-report (*detail*)))))))

(define *current_page* (make-parameter #f))

(define (detail-page
         proc
         #:line_break_length [line_break_length (*line_break_length*)]
         #:font_size [font_size (*font_size*)])
  (if (*detail*)
      (parameterize
          ([*current_page* (DETAIL-PAGE '() '())]
           [*line_break_length* line_break_length]
           [*font_size* font_size])
        (dynamic-wind
            (lambda () (void))
            (lambda () (proc))
            (lambda ()
              (set-DETAIL-pages! (*detail*) `(,@(DETAIL-pages (*detail*)) ,(*current_page*))))))
      (proc)))

(define *current_line* (make-parameter #f))

(define (detail-list
         proc
         #:line_break_length [line_break_length (*line_break_length*)]
         #:font_size [font_size (*font_size*)])
  (when (*detail*)
      (parameterize
          ([*current_line* (DETAIL-LINE '() line_break_length font_size)])
        (dynamic-wind
            (lambda () (void))
            (lambda () (proc))
            (lambda ()
              (detail-add-rec (*current_line*)))))))

(define (detail-line-add-item val)
  (when (*detail*)
     (set-DETAIL-LINE-items! (*current_line*) `(,@(DETAIL-LINE-items (*current_line*)) ,val))
    (let* ([items (DETAIL-LINE-items (*current_line*))]
           [items_length (DETAIL-PAGE-items_length (*current_page*))]
           [val_length (string-length val)]
           [val_pos (sub1 (length items))])
      (if (< (length items_length) (length items))
          (set-DETAIL-PAGE-items_length!
           (*current_page*)
           `(,@(DETAIL-PAGE-items_length (*current_page*)) ,val_length))
          (when (> (string-length val) (list-ref items_length val_pos))
            (set-DETAIL-PAGE-items_length!
             (*current_page*)
             (list-set items_length val_pos val_length)))))))

(define (detail-line
         line
         #:line_break_length [line_break_length (*line_break_length*)]
         #:font_size [font_size (*font_size*)])
  (when (*detail*)
        (detail-add-rec (DETAIL-LINE line line_break_length font_size))))

(define (detail-h1 h1)
  (when (*detail*)
        (detail-add-rec (DETAIL-TITLE 'h1 h1))))

(define (detail-h2 h2)
  (when (*detail*)
        (detail-add-rec (DETAIL-TITLE 'h2 h2))))

(define (detail-h3 h3)
  (when (*detail*)
        (detail-add-rec (DETAIL-TITLE 'h3 h3))))

(define (detail-add-rec rec)
  (set-DETAIL-PAGE-recs! (*current_page*) `(,@(DETAIL-PAGE-recs (*current_page*)) ,rec)))
