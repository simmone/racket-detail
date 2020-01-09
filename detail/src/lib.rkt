#lang racket

(provide (contract-out
          [zip-string (-> string? (and/c natural? (>/c 0)) (listof string?))]
          [display-double-list (->* (list? list?) (natural? natural?) string?)]
          [display-list (->* (list?) (natural? natural?) string?)]
          ))

(define (zip-string str line_count)
  (let loop ([chs (string->list str)]
             [str_list '()]
             [result_list '()]
             [count 0])
    (if (not (null? chs))
        (if (< count line_count)
            (loop (cdr chs) (cons (car chs) str_list) result_list (add1 count))
            (loop (cdr chs) (list (car chs)) (cons (list->string (reverse str_list)) result_list) 1))
        (reverse (cons (list->string (reverse str_list)) result_list)))))

(define (display-double-list input_list result_list [col_width 12] [line_count 10])
  (if (and
       (not (null? input_list))
       (= (length input_list) (length result_list)))
      (with-output-to-string
        (lambda ()
          (printf "@verbatim{\n")
          (let loop ([loop_list result_list]
                     [origin_list input_list]
                     [print_count 0]
                     [item_number 1]
                     [line_start? #t]
                     [origin? #t])
            (when (not (null? loop_list))
                  (if origin?
                      (begin
                        (when line_start?
                              (printf (~a #:min-width 6 #:align 'left #:right-pad-string " ")))

                        (if (or (= print_count (sub1 line_count)) (= (length origin_list) 1))
                            (begin
                              (printf (~a #:min-width col_width #:align 'left #:right-pad-string " " (format "[~a]" (car origin_list))))
                              (printf "\n")
                              (loop loop_list (cdr origin_list) 0 item_number #t #f))
                            (begin
                              (printf (~a #:min-width col_width #:align 'left #:right-pad-string " " (format "[~a]" (car origin_list))))
                              (loop loop_list (cdr origin_list) (add1 print_count) item_number #f #t))))
                      (begin
                        (when line_start?
                              (printf (~a #:min-width 6 #:align 'left #:right-pad-string " " (number->string item_number))))

                        (if (or (= print_count (sub1 line_count)) (= (length loop_list) 1))
                            (begin
                              (printf (~a #:min-width col_width #:align 'left #:right-pad-string " " (format "~a" (car loop_list))))
                              (printf "\n")
                              (loop (cdr loop_list) origin_list 0 (add1 item_number) #t #t))
                            (begin
                              (printf (~a #:min-width col_width #:align 'left #:right-pad-string " " (format "~a" (car loop_list))))
                              (loop (cdr loop_list) origin_list (add1 print_count) (add1 item_number) #f #f)))))))
          (printf "}")))
      ""))

(define (display-list input_list [col_width 12] [line_count 10])
  (with-output-to-string
    (lambda ()
      (printf "@verbatim{\n")
      (let loop ([loop_list input_list]
                 [print_count 0]
                 [item_number 1]
                 [line_start? #t]
                 [origin? #t])
        (when (not (null? loop_list))
              (when line_start?
                    (printf (~a #:min-width 6 #:align 'left #:right-pad-string " " (string-append "[" (number->string item_number) "]"))))

              (if (or (= print_count (sub1 line_count)) (= (length loop_list) 1))
                  (begin
                    (printf (~a #:min-width col_width #:align 'left #:right-pad-string " " (format "~a" (car loop_list))))
                    (printf "\n")
                    (loop (cdr loop_list) 0 (add1 item_number) #t #f))
                  (begin
                    (printf (~a #:min-width col_width #:align 'left #:right-pad-string " " (format "~a" (car loop_list))))
                    (loop (cdr loop_list) (add1 print_count) (add1 item_number) #f #t)))))
      (printf "}"))))

(define (rows->cols rows)
  (let ([cols_count (length rows)]
        [rows_count (if (null? tail_rows) 0 (apply max (map (lambda (items) (length items)) tail_rows)))])
    (let loop ([row_count 0]
               [cols '()])
      (if (< row_count rows_count)
          (loop
           (add1 row_count)
           (cons
            (let loop-col ([col_count 0]
                           [row '()])
              (if (< col_count cols_count)
                                    (let ([cols (list-ref tail_rows col_count)])
                                      (loop-col
                                       (add1 col_count)
                                       (cons (if
                                              (< row_count (length cols))
                                              (list-ref cols row_count)
                                              "")
                                             row)))
                                      (reverse row)))
