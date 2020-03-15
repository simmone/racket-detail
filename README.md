# racket-detail
embbed into your code to give a full detail report when needed.

## basic usage
```
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

        ;; your code
        
        (detail-line "Yes, one by one, day by day.")))))
```

1. use **detail** to include your code.
   you can have multiple reports at the same time.
   you can set global env or set them on each detail statement.

2. output formats:
   **#f**: shutdown the detail mode, don't report anything.
   or
   list of below formats:
     **raw**: used to show the raw elements, for debug usage.
     **console**: plain txt format, output to console.
     files: ***.txt**: plain txt format, ***.pdf**: pdf format

3. statements:
   **detail-page**: container, tell the reports when its content ends, should start new page.
   **detail-h1/2/3**: header
   **detail-line**: output a line, use line_break_length? to control the line width.
   **detail-list**: container, use **detail-row** and **detail-col** to construct a list report.
   **detail-simple-list**: report a two dimension list directly.

## detail usage in the raco docs.