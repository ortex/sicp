(define (install-complex-package)
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))

  (define (add-complex z1 z2)
    (make-from-real-imag (add (real-part z1) (real-part z2))
                         (add (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (sub (real-part z1) (real-part z2))
                         (sub (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (mul (magnitude z1) (magnitude z2))
                       (add (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (div (magnitude z1) (magnitude z2))
                       (sub (angle z1) (angle z2))))
  (define (equal-complex? z1 z2)
    (and (equ? (real-part z1) (real-part z2))
         (equ? (imag-part z1) (imag-part z2))))

  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
    (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
    (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
    (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
    (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'equ? '(complex complex)
    (lambda (z1 z2) (tag (equal-complex? z1 z2))))
  (put '=zero? 'complex
    (lambda (z) (and (= (real-part z) 0) (= (imag-part z) 0))))
  (put 'make-from-real-imag 'complex
    (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
    (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))

(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

;; polar and rectangular complex
(define (install-rectangular-package)
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (magnitude z)
    (g-sqrt
           (sum
                (square (real-part z))
                (square (imag-part z)))))
  (define (angle z)
    (arctan (imag-part z) (real-part z)))
  (define (make-from-real-imag x y) (cons x y))
  (define (make-from-mag-ang r a)
    (cons (mul r (cosine a))
          (mul r (sine a))))

  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
    (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
    (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (install-polar-package)
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (mul (magnitude z) (cosine (angle z))))
  (define (imag-part z)
    (mul (magnitude z) (sine (angle z))))
  (define (make-from-real-imag x y)
    (cons (g-sqrt (sum (square x) (square y)))
          (arctan y x)))

  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
    (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
    (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(put 'cos '(scheme-number) (lambda (x) (attach-tag 'scheme-number (cos x))))
(put 'sin '(scheme-number) (lambda (x) (attach-tag 'scheme-number (sin x))))
(put 'sqrt '(scheme-number) (lambda (x) (attach-tag 'scheme-number (sqrt x))))
(put 'square '(scheme-number) (lambda (x) (attach-tag 'scheme-number (* x x))))
(put 'atan '(scheme-number scheme-number) (attach-tag 'scheme-number (lambda (x y) (atan x y))))

(put 'cos '(rational) (lambda (x) (attach-tag 'rational (cos (/ (numer x) (denom x))))))
(put 'sin '(rational) (lambda (x) (attach-tag 'rational (sin (/ (numer x) (denom x))))))
(put 'sqrt '(rational) (lambda (x) (attach-tag 'rational (mul (sqrt (numer x) (denom x))))))
(put 'square '(rational) (lambda (x) (attach-tag 'rational (mul x x))))
(put 'atan '(rational rational) (lambda (x) (attach-tag 'rational (atan (/ (numer x) (denom x))))))

(define (cosine x) (apply-generic 'cos x))
(define (sine x) (apply-generic 'sin x))
(define (g-sqrt x) (apply-generic 'sqrt x))
(define (square x) (apply-generic 'square x))
(define (arctan x y) (apply-generic 'atan x y))
