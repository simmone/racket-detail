#lang scribble/manual

@(require (for-label detail))

@title{Detail: a log tool. integrated into the code to generate detail report when needed.}

@author+email["Chen Xiao" "chenxiao770117@gmail.com"]

detail is useful when 1. need a complete report of software process. 2. debug when something goes wrong.

@table-of-contents[]

@section[#:tag "install"]{Install}

raco pkg install detail

@section{Basic Example}

@codeblock{
  (detail
   #:formats? '(raw console "basic.pdf")
   #:line_break_length? 1
   #:font_size? 'small
   (lambda ()
     (detail-page
      #:line_break_length? 100
      #:font_size? 'big
      (lambda ()
        (detail-h1 "Hello World!")
        
        (detail-line "Yes, one by one, day by day.")

        (detail-list
         (lambda ()
           (detail-row
            (lambda ()
              (detail-col "123")
              (detail-col "12345")
              (detail-col "1234567")))

           (detail-row
            (lambda ()
              (detail-col "12345")
              (detail-col "123")))))))))
}

1. include your normal code into the detail's body lambda.
2. detail elements has parent and children elements, each element should be placed in the container.
3. detail can generate multiple report at the same time.
4. some properties can be set in detail or the children elements, like: detail-page, detail-line...
   properted is inheritated from parent detail element.

@section{Usage}

@defmodule[simple-qr]

@subsection{Function}

@defproc[(qr-write
              [data (string?)]
              [output_file_path (path-string?)]
              [#:mode mode string? "B"]
              [#:error_level error_level string? "H"]
              [#:module_width module_width natural? 5]
              [#:color color (cons/c string? string?) '("black" . "white")]
              [#:express? express? boolean? #f]
              [#:express_path express_path path-string? "imgfile + '.write.express'"]
              [#:output_type output_type (or/c 'png 'svg)]
              )
            void?]{
  output qr code image to file.
  
  color's form is '(front_color . background_color).
  
  use color "transparent" to set transparent(background).

  if output_type is png, can use @racket[color-database<%>], 
  but hex color is all available in all formats, recommended.
}

@defproc[(qr-read
                [image_file_path (path-string?)]
                [#:express? express? boolean? #f]
                [#:express_path express_path path-string? "imgfile + '.read.express'"]
                )
              string?]{
  read qr code image's content, if failed, return "".
}

@subsection{Example}

@codeblock{
#lang racket

(require simple-qr)

;; block's default width is 5

(qr-write "https://github.com/simmone" "normal.png")

(qr-write "https://github.com/simmone" "normal_color.png" #:color '("#ffbb33" . "#0d47a1"))

(qr-write "https://github.com/simmone" "normal_trans.png" #:color '("#9933CC" . "transparent"))
 
(qr-write "https://github.com/simmone" "small.png" #:module_width 2)

(qr-write "https://github.com/simmone" "large.png" #:module_width 10)

(printf "~a\n~a\n~a\n"
        (qr-read "normal.png")
        (qr-read "small.png")
        (qr-read "large.png"))

(printf "~a\n" (qr-read "damaged.png"))

(qr-write "https://github.com/simmone" "normal.svg" #:output_type 'svg)

(qr-write "https://github.com/simmone" "normal_color.svg" #:color '("#ffbb33" . "#0d47a1") #:output_type 'svg)

(qr-write "https://github.com/simmone" "normal_trans.svg" #:color '("#9933CC" . "transparent") #:output_type 'svg)
}

@subsection{Png}

@codeblock{
(qr-write "https://github.com/simmone" "normal.png")
}
@image{example/normal.png}

@codeblock{
(qr-write "https://github.com/simmone" "normal_color.png" #:color '("#ffbb33" . "#0d47a1"))
}
@image{example/normal_color.png}

@codeblock{
(qr-write "https://github.com/simmone" "normal_trans.png" #:color '("#9933CC" . "transparent"))
}
@image{example/normal_trans.png}

@codeblock{
(qr-write "https://github.com/simmone" "small.png" #:module_width 2)
}
@image{example/small.png}

@codeblock{
(qr-write "https://github.com/simmone" "large.png" #:module_width 10)
}
@image{example/large.png}

@subsection{SVG}

@codeblock{
(qr-write "https://github.com/simmone" "normal.svg"  #:output_type 'svg)
}
@image{example/normal.svg}

@codeblock{
(qr-write "https://github.com/simmone" "normal_color.svg" #:color '("#ffbb33" . "#0d47a1") #:output_type 'svg)
}
@image{example/normal_color.svg}

@codeblock{
(qr-write "https://github.com/simmone" "normal_trans.svg" #:color '("#9933CC" . "transparent") #:output_type 'svg)
}
@image{example/normal_trans.svg}

@subsection{Read and Correct}

@codeblock{
(printf "~a\n" (qr-read "damaged.png"))
}
@image{example/damaged.png}

https://github.com/simmone

@section{Express}

If you want to see the each step of read or write a qr code, can set #:express? to true.

Default will create folder .read.express for qr-read or .write.express for qr-write.

You can use #:express_path to specify another folder name.

Warning: express will generate a set of scribble files, it's very slow, debug usage only.

Then into the express folder, @verbatim{scribble --htmls report.scrbl} to generate a detail report.