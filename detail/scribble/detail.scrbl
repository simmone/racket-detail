#lang scribble/manual

@(require (for-label detail))

@title{Detail: a log tool}

integrated into the code to generate detail report when needed(report or debug).

@author+email["Chen Xiao" "chenxiao770117@gmail.com"]

I need a log tool integarated into the code to show the whole process of computing when needed.

So I can see the whole process and debug the code easily.

And these log statements in the code can't slow down the computing when the log closed.

@table-of-contents[]

@defmodule[detail]

@section[#:tag "install"]{Install}

raco pkg install detail

@section{Basic Example}

@codeblock{
  (detail
   #:formats? '(raw console "basic.pdf")
;; #:formats? #f to disable log
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

2. detail elements has two kinds: container and element, all element should be placed in some container.

3. detail can generate multiple report at the same time.

4. some properties can be set in parent or the children elements, like: detail-page, detail-line...
   properted is inheritated from parent element.

@section{Tradeoff}

The apparent's tradeoff of detail is the "noise", you'll think its so verbose.

For the purpose of record the detail process, the real code should be included into the body of detail.

This maybe affect some readability of the code.

The pro is you can treat detail code as the docs to understand the real code.

The con is you maybe think this will make your clean code to some mess。

@section{It's Transparent}

All the detail's code is transparent.

It means it include all your real code into its lambda body, though, any detail container's return value is the real code's return value.

you put your code into the detail's body anywhere, it doesn's affect the function's running results.

you put the detail's output on, it'll slow down the running process, but the result is the same as you put the detail output off.

@section{Auto Page Split}

When use pdf as output format, you can write all things in one page: detail-line, detail-simple-list....

It start new page automatically.

If want to start a new page manually, use (start-new-page) in detail-page scope.

@section{Hierarchy}

detail is the parent element of detail-page and detail-div.

detail-page and detail-div is other elements's parent.

detail-list's children element is detail-row, detail-row is the parent of detail-col.

@codeblock{
(detail
  (lambda ()
  ...
  (detail-page
    (lambda ()
    ...
    (detail-line...)

    ...
    (detail-new-page)

    ...
    (detail-h1...)
    ...
    (detail-list
      (lambda ()
      ...
      (detail-row
        (lambda ()
        ...
        (detail-col...)
        ...))
      ...))
    ...
    (detail-simple-list...)
    ...
    ))
      
  (detail-div
    (lambda ()
      ...))))
}


@section{Top Container: detail}

@defproc[(detail
              [proc procedure?]
              [#:formats? formats? (or/c #f (listof (or/c 'raw 'console path-string?)))]
              [#:exception_value? exception_value? any/c]
              [#:line_break_length? line_break_length? natural?]
              [#:font_size? font_size? (or/c 'normal 'big 'small)]
              )
            any]{
  detail is the top container, all detail statement should be placed into proc.

  formats?: reports list

  formats? has below options:

  #f: don't run any detail statements, shutoff the log.

  raw: detail raw information, used for debug.

  console: output to console, format same as txt.

  path-string?: support *.txt or *.pdf

  exception_value?: when exception happens, return this value.

  line_break_length?: global env, how long a line before auto returned.

  font_size?: global env.
}

@section{Second Container: detail-page/detail-div}

@defproc[(detail-page
              [proc procedure?]
              [#:line_break_length? line_break_length? natural?]
              [#:font_size? font_size? (or/c 'normal 'big 'small)]
              )
            any]{
  detail-page means when all it's children detail statement done, it should start a new page.

  detail-div same as detail-page, but not start a new page, just like html's div, block container.

  detail-page and detail-div is second level container, but all detail statements should be placed into its proc.
}

@section{detail-h1/2/3}

@defproc[(detail-h1/2/3
              [head string?]
              )
            void?]{
 output a header with different font size: detail-h1 detail-h2 detail-h3
}

@section{detail-line}

@defproc[(detail-line
              [line string?]
              [#:line_break_length? line_break_length? natural?]
              [#:font_size? font_size? (or/c 'normal 'big 'small)]
              )
            any]{
  line_break_length? and font_size? inherited from parent.
}

@section{detail-list/row/col}

@defproc[(detail-list
              [proc procedure?]
              [#:font_size? font_size? (or/c 'normal 'big 'small)]
              )
            any]{
  detail-list is a container.

  it contains detail-rows, detail-row contains detail-cols.
}

@defproc[(detail-row
              [proc procedure?]
              )
            any]{
  detail-row is a container.

  it contains detail-cols.
}

@defproc[(detail-col
              [col string?]
              [width? natural?]
              )
            any]{
  detail-col add a col value with optional width?

  it included in detail-rows.
}

@section{Example}

@codeblock{
#lang racket

(require "../main.rkt")

(detail
 #:formats? '("tiger.pdf")
 (lambda()
   (detail-page
    (lambda ()
      (detail-h1 "The Tiger")

      (detail-h2 "By William Blake")

      (detail-h3 "1757-1827")))

   (detail-page
    (lambda ()
      (detail-line "TIGER, tiger, burning bright ")
      (detail-line "In the forests of the night, ")
      (detail-line "What immortal hand or eye ")
      (detail-line "Could frame thy fearful symmetry? ")
      (detail-line "")
      (detail-line "In what distant deeps or skies ")
      (detail-line "Burnt the fire of thine eyes? ")
      (detail-line "On what wings dare he aspire? ")
      (detail-line "What the hand dare seize the fire? ")
      (detail-line "")
      (detail-line "And what shoulder and what art ")
      (detail-line "Could twist the sinews of thy heart? ")
      (detail-line "And when thy heart began to beat, ")
      (detail-line "What dread hand and what dread feet? ")
      (detail-line "")
      (detail-line "What the hammer? what the chain? ")
      (detail-line "In what furnace was thy brain? ")
      (detail-line "What the anvil? What dread grasp ")
      (detail-line "Dare its deadly terrors clasp? ")
      (detail-line "")
      (detail-line "When the stars threw down their spears, ")
      (detail-line "And water'd heaven with their tears, ")
      (detail-line "Did He smile His work to see? ")
      (detail-line "Did He who made the lamb make thee? ")
      (detail-line "")
      (detail-line "Tiger, tiger, burning bright ")
      (detail-line "In the forests of the night, ")
      (detail-line "What immortal hand or eye ")
      (detail-line "Dare frame thy fearful symmetry? ")))))
}

above code will output a pdf file: tiger.pdf

the two pages of pdf file's screen shot:

@image{example/tiger1.png}

@image{example/tiger2.png}