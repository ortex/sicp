(load "chapter3/streams.scm")

(define (expand num den radix)
  (cons-stream
    (quotient (* num radix) den)
    (expand (remainder (* num radix) den) den radix)))

(show-first-n (expand 1 7 10) 100)

(show-first-n (expand 3 8 10) 10)
