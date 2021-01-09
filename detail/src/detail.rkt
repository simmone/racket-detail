#lang racket

(require "define.rkt")
(require "lib.rkt")
(require "report/report.rkt")

(provide (contract-out
          [detail (->*
                   (procedure?)
                   (
                    #:formats? (or/c #f (listof (or/c 'raw 'console path-string?)))
                    #:exception_value? any/c
                    #:line_break_length? natural?
                    #:font_size? (or/c 'normal 'big 'small)
                    ) any)]
          [detail-page (->*
                        (procedure?)
                        (
                         #:line_break_length? natural?
                         #:font_size? (or/c 'normal 'big 'small)
                         ) any)]
          [detail-new-page (-> any)]
          [detail-div (->*
                        (procedure?)
                        (
                         #:line_break_length? natural?
                         #:font_size? (or/c 'normal 'big 'small)
                         ) any)]
          [detail-h1 (-> string? void?)]
          [detail-h2 (-> string? void?)]
          [detail-h3 (-> string? void?)]
          [detail-line (->*
                        (string?)
                        (
                         #:line_break_length? natural?
                         #:font_size? (or/c 'normal 'big 'small)
                         ) any)]
          [detail-lines (->*
                        ((listof string?))
                        (
                         #:line_break_length? natural?
                         #:font_size? (or/c 'normal 'big 'small)
                         ) any)]
          [detail-list (->*
                        (procedure?)
                        (
                         #:font_size? (or/c 'normal 'big 'small)
                         ) any)]
          [detail-row (-> procedure? any)]
          [detail-col (->* (string?) (#:width? natural?) any)]
          [detail-simple-list (->*
                        ((listof string?))
                        (
                         #:font_size? (or/c 'normal 'big 'small)
                         #:cols_count? natural?
                         #:col_width? natural?
                         ) any)]
          [detail-img (->
                       path-string?
                       natural?
                       any)]
          ))

(define (detail
         #:formats? [formats #f]
         #:exception_value? [exception_value #f]
         #:line_break_length? [line_break_length 60]
         #:font_size? [font_size 'normal]
         proc)
  (parameterize ([*detail*
                  (if formats
                      (DETAIL formats '())
                      #f)]
                 [*line_break_length* line_break_length]
                 [*font_size* font_size])
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
         #:line_break_length? [line_break_length (*line_break_length*)]
         #:font_size? [font_size (*font_size*)])
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

(define (detail-new-page)
  (detail-add-rec (DETAIL-NEW-PAGE)))

(define (detail-div
         proc
         #:line_break_length? [line_break_length (*line_break_length*)]
         #:font_size? [font_size (*font_size*)])
  (if (*detail*)
      (parameterize
          ([*line_break_length* line_break_length]
           [*font_size* font_size])
        (proc))
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
         #:line_break_length? [line_break_length (*line_break_length*)]
         #:font_size? [font_size (*font_size*)])
  (when (*detail*)
        (detail-add-rec (DETAIL-LINE line line_break_length font_size))))

(define (detail-lines
         lines
         #:line_break_length? [line_break_length (*line_break_length*)]
         #:font_size? [font_size (*font_size*)])
  (when (*detail*)
        (map
         (lambda (line)
           (detail-line line #:line_break_length? line_break_length #:font_size? font_size))
         lines)))

(define *current_list* (make-parameter #f))

(define (detail-list
         proc
         #:font_size? [font_size (*font_size*)])
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
  (if (*detail*)
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
                ,@(map (lambda (rec) (DETAIL-ROW rec '())) (rows->cols (DETAIL-ROW-tail_rows (*current_row*)) #:fill "")))))))
      (proc)))

(define (detail-col val #:width? [width? 100])
  (when (*detail*)
        (let* ([split_vals (zip-string val width?)]
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

(define (detail-simple-list
         str_list
         #:font_size? [font_size? (*font_size*)]
         #:cols_count? [cols_count? 4]
         #:col_width? [col_width? 64])
  (when (*detail*)
        (detail-list
         #:font_size? font_size?
         (lambda ()
           (let loop-row ([row_count 1]
                          [row_list str_list])
            (when (not (null? row_list))
                  (loop-row
                   (add1 row_count)
                   (detail-row
                    (lambda ()
                      (detail-col (format "[~a]" row_count))
                      (let loop-col ([col_list row_list]
                                     [count 0])
                        (if (not (null? col_list))
                            (if (< count cols_count?)
                                (begin
                                  (detail-col (car col_list) #:width? col_width?)
                                  (loop-col (cdr col_list) (add1 count)))
                                col_list)
                            col_list)))))))))))

(define (detail-img img y)
  (when (*detail*)
        (detail-add-rec (DETAIL-IMG img y))))
