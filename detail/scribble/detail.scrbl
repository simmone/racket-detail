#lang scribble/manual

@title{Detail: a log tool}

integrated into the code to generate detail report when needed(report or debug).

@author+email["Chen Xiao" "chenxiao770117@gmail.com"]

I need a log tool integarated into the code to show the whole process of computing when needed.

So I can see the whole process and debug the code easily.

And these log statements in the code can't slow down the computing when the log closed.

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

2. detail elements has two kinds: container and element, all element should be placed in some container.

3. detail can generate multiple report at the same time.

4. some properties can be set in detail or the children elements, like: detail-page, detail-line...
   properted is inheritated from parent element.


