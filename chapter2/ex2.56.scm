(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
          (if (same-variable? exp var) 1 0))
        ((sum? exp)
          (make-sum (deriv (addend exp) var)
                    (deriv (augend exp) var)))
        ((product? exp)
          (make-sum
            (make-product (multiplier exp)
                          (deriv (multiplicand exp) var))
            (make-product (multiplicand exp)
                          (deriv (multiplier exp) var))))
        ((exponentiation? exp)
          (make-product
            (exponent exp)
            (make-product
             (make-exponent (base exp) (- (exponent exp) 1))
             (deriv (base exp) var))))
        (else
          (error "Unknown type of expression -- DERIV" exp))))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))
(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))
(define (multiplicand p) (caddr p))


; 2.56
(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (base e) (cadr e))
(define (exponent e) (caddr e))

(define (make-exponent b e)
  (cond ((=number? e 0) 1)
        ((=number? e 1) b)
        ((and (number? b) (number? e)) (expt b e))
        (else (list '** b e))))

(deriv '(** x 3) 'x) ; (* 3 (** x 2))

; 2.57

(define (not-number? x) (not (number? x)))

(define (make-sum-args items)
  (if (null? (cdr items))
      (car items)
      (cons '+ items)))

(define (make-sum . items)
  (let ((vars (filter not-number? items))
        (const (accumulate + 0 (filter number? items))))
    (cond ((null? vars) const)
          ((= 0 const) (make-sum-args vars))
          (else (make-sum-args (cons const vars))))))

(define (addend s) (cadr s))
(define (augend s) (make-sum-args (cddr s)))
