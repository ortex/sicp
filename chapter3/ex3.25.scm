(define (make-table)
  (define (assoc key records)
    (cond ((null? records) false)
          ((equal? key (caar records)) (car records))
          (else (assoc key (cdr records)))))
  (define (make-subrecords keys value)
    (if (eq? (car keys) 'final-key)
        (cons (car keys) value)
        (list (car keys)
              (make-subrecords (cdr keys) value))))
  (let ((local-table (list '*table*)))
    (define (lookup keys table)
      (let ((record (assoc (car keys) (cdr table))))
        (if record
            (if (eq? (car keys) 'final-key)
                (cdr record)
                (lookup (cdr keys) record))
            false)))
    (define (insert! keys value table)
      (let ((record (assoc (car keys) (cdr table))))
        (if record
            (if (eq? (car keys) 'final-key)
                (set-cdr! record value)
                (insert! (cdr keys) value (cdr record)))
            (set-cdr! table
                      (cons (make-subrecords keys value)
                            (cdr table)))
            )))
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) (lambda (keys) (lookup (append keys '(final-key)) local-table)))
            ((eq? m 'insert-proc!) (lambda (keys value) (insert! (append keys '(final-key)) value local-table)))
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define table (make-table))

((table 'insert-proc!) '(a) 1)
((table 'lookup-proc) '(a))

((table 'insert-proc!) '(a b b c) 68)
((table 'lookup-proc) '(a b b c))