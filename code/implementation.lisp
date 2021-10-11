(in-package #:inravina)

(defmacro pprint-logical-block ((stream-symbol object &key
                                 (prefix nil prefix-p)
                                 (per-line-prefix nil per-line-prefix-p)
                                 (suffix ""))
                                &body body)
  (when (and prefix-p per-line-prefix-p)
    (error 'program-error))
  (check-type stream-symbol symbol)
  (let ((tag-name (make-symbol "L"))
        (object-var (make-symbol "T"))
        (stream-var (cond
                      ((null stream-symbol)
                        '*standard-output*)
                      ((eq t stream-symbol)
                        '*terminal-io*)
                      (t
                        stream-symbol))))
    `(let ((,stream-var (make-pretty-stream *client* ,stream-symbol))
           (,object-var ,object))
       (declare (ignorable ,stream-var ,object-var))
       (unwind-protect
           (block ,tag-name
             (pprint-start-logical-block *client* ,stream-var
                                         ,(if (or prefix-p per-line-prefix-p)
                                            prefix
                                            "")
                                         ,per-line-prefix)
             (macrolet ((pprint-exit-if-list-exhausted ()
                          '(unless ,object-var
                             (return-from ,tag-name)))
                        (pprint-pop ()
                          '(pop ,object-var)))
               ,@body))
         (pprint-end-logical-block *client* ,stream-var ,suffix)))))

(defmacro pprint-exit-if-list-exhausted ()
  "Tests whether or not the list passed to the lexically current logical block has
   been exhausted. If this list has been reduced to nil, pprint-exit-if-list-exhausted
   terminates the execution of the lexically current logical block except for the
   printing of the suffix. Otherwise pprint-exit-if-list-exhausted returns nil."
  (error "PPRINT-EXIT-IF-LIST-EXHAUSTED must be lexically inside PPRINT-LOGICAL-BLOCK."))

(defmacro pprint-pop ()
  "Pops one element from the list being printed in the lexically current logical
   block, obeying *print-length* and *print-circle*."
  (error "PPRINT-POP must be lexically inside PPRINT-LOGICAL-BLOCK."))

(defmethod pprint-fill (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (let ((*client* client))
    (pprint-logical-block (stream object :prefix (if colon-p "(" "")
                                         :suffix (if colon-p ")" ""))
      (pprint-exit-if-list-exhausted)
      (loop (write (pprint-pop) :stream stream)
            (pprint-exit-if-list-exhausted)
            (write-char #\space stream)
            (pprint-newline client :fill stream)))))

(defmethod pprint-linear (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (let ((*client* client))
    (pprint-logical-block (stream object :prefix (if colon-p "(" "")
                                         :suffix (if colon-p ")" ""))
      (pprint-exit-if-list-exhausted)
      (loop (write (pprint-pop) :stream stream)
            (pprint-exit-if-list-exhausted)
            (write-char #\Space stream)
            (pprint-newline client :linear stream)))))

(defmethod pprint-tabular (client stream object &optional colon-p at-sign-p tabsize)
  (declare (ignore at-sign-p))
  (unless tabsize
    (setq tabsize 16))
  (let ((*client* client))
    (pprint-logical-block (stream object :prefix (if colon-p "(" "")
                                         :suffix (if colon-p ")" ""))
      (pprint-exit-if-list-exhausted)
      (loop (write (pprint-pop) :stream stream)
            (pprint-exit-if-list-exhausted)
            (write-char #\space stream)
            (pprint-tab client :section-relative 0 tabsize stream)
            (pprint-newline client :fill stream)))))

(defmethod text-width (client stream text &optional start end)
  (- (or end (length text))
     (or start 0)))

(defmethod break-position (client stream text)
  (1+ (or (position-if (lambda (ch)
                     (char/= ch #\Space))
                   text :from-end t)
      -1)))

(defmethod normalize-text (client stream text)
  text)

(defmethod arrange-text (client stream (text (eql nil)))
  (values nil 0 0))

(defmethod right-margin (client stream)
  (or *print-right-margin* 100))

(defmethod miser-p (client stream)
  (and *print-miser-width*
       (<= (- (right-margin client stream)
              (column client stream))
           *print-miser-width*)))

(defmethod pprint-split (client stream text &optional start end)
  (prog (pos)
   next
    (setf pos (position #\newline text :start (or start 0) :end end))
    (when pos
      (pprint-text client stream text start pos)
      (pprint-newline client :literal-mandatory stream)
      (setf start (1+ pos))
      (go next))
    (pprint-text client stream text start end)))



