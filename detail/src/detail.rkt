#lang racket

(require "define.rkt")
(require "lib.rkt")
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
          [detail-page (->*
                        (procedure?)
                        (
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
                         #:font_size (or/c 'normal 'big 'small)
                         ) any)]
          [detail-row (-> procedure? void?)]
          [detail-col (->* (string?) (#:width natural?) void?)]
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
          ([*current_page* (DETAIL-PAGE '())]
           [*line_break_length* line_break_length]
           [*font_size* font_size])
        (dynamic-wind
            (lambda () (void))
            (lambda () (proc))
            (lambda ()
              (set-DETAIL-pages! (*detail*) `(,@(DETAIL-pages (*detail*)) ,(*current_page*))))))
      (proc)))

(define (detail-add-rec rec)
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
         line
         #:line_break_length [line_break_length (*line_break_length*)]
         #:font_size [font_size (*font_size*)])
  (when (*detail*)
        (detail-add-rec (DETAIL-LINE line line_break_length font_size))))

(define *current_list* (make-parameter #f))

(define (detail-list
         proc
         #:font_size [font_size (*font_size*)])
  (if (*detail*)
      (parameterize
          ([*current_list* (DETAIL-LIST '() '() font_size)])
        (dynamic-wind
            (lambda () (void))
            (lambda () (proc))
            (lambda ()
              (detail-add-rec (*current_list*)))))
      (proc)))

(define *current_row* (make-parameter #f))

(define (detail-row proc)
  (when (*detail*)
      (parameterize
          ([*current_row* (DETAIL-ROW '() '())])
        (dynamic-wind
            (lambda () (void))
            (lambda () (proc))
            (lambda ()
              (set-DETAIL-LIST-rows! 
               (*current_list*)
               `(,@(DETAIL-LIST-rows (*current_list*))
                 ,(*current_row*)
                 ,@(map (lambda (rec) (DETAIL-ROW rec '())) (rows->cols (DETAIL-ROW-tail_rows (*current_row*)) #:fill "")))))))))

(define (detail-col val #:width [width 30])
  (when (*detail*)
        (let* ([split_vals (zip-string val width)]
               [head_val (car split_vals)]
               [head_val_width (string-length head_val)]
               [tail_vals (cdr split_vals)])

          (set-DETAIL-ROW-cols! (*current_row*) `(,@(DETAIL-ROW-cols (*current_row*)) ,head_val))
          
          (set-DETAIL-ROW-tail_rows! (*current_row*) `(,@(DETAIL-ROW-tail_rows (*current_row*)) ,tail_vals))
          
          (let* ([cols (DETAIL-ROW-cols (*current_row*))]
                 [cols_width (DETAIL-LIST-cols_width (*current_list*))]
                 [val_pos (sub1 (length cols))])
            (if (< (length cols_width) (length cols))
                (set-DETAIL-LIST-cols_width!
                 (*current_list*)
                 `(,@(DETAIL-LIST-cols_width (*current_list*)) ,head_val_width))
              (when (> head_val_width (list-ref cols_width val_pos))
                    (set-DETAIL-LIST-cols_width!
                     (*current_list*)
                     (list-set cols_width val_pos head_val_width))))))))
