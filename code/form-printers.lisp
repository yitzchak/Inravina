(in-package #:inravina)

(defmacro pprint-body-form ((client stream object) &body body)
  `(pprint-list (,client ,stream ,object :paren t :newline :linear)
     ,@body
     (pprint-exit-if-list-exhausted)
     (pprint-indent ,client ,stream :block 1)
     (write-char #\Space ,stream)
     (pprint-newline ,client ,stream :linear)))

(defmacro pprint-tagbody-form ((client stream object) &body body)
  `(pprint-format-logical-block (,client ,stream ,object :paren t)
     ,@body
     (pprint-exit-if-list-exhausted)
     (loop for form-or-tag = (pprint-pop)
           do (pprint-indent ,client ,stream :block
                             (if (atom form-or-tag) 0 1))
              (write-char #\Space ,stream)
              (pprint-newline ,client ,stream :linear)
              (incless:write-object ,client form-or-tag ,stream)
              (pprint-exit-if-list-exhausted))))

(defmacro pprint-function-call-form ((client stream object argument-count) &body body)
  `(pprint-plist (,client ,stream ,object :paren t :newline :fill)
     ,@body
     (pprint-exit-if-list-exhausted)
     (loop for i below (or ,argument-count most-positive-fixnum)
           do (incless:write-object ,client (pprint-pop) ,stream)
              (pprint-exit-if-list-exhausted)
              (write-char #\Space ,stream)
              (pprint-newline ,client ,stream :fill))))

(defmethod pprint-bindings (client stream object)
  (pprint-format-logical-block (client stream object :paren t)
    (pprint-exit-if-list-exhausted)
    (loop do (pprint-linear client stream (pprint-pop) t nil)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space stream)
             (pprint-newline client stream :linear))))

(defmethod pprint-block (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :fill)
    (incless:write-object client (pprint-pop) stream)))

(defmethod pprint-defun (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-indent client stream :current 0)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :fill)
    (pprint-lambda-list client stream (pprint-pop))))

(defmethod pprint-defmethod-with-qualifier (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-indent client stream :current 0)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :fill)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :fill)
    (pprint-lambda-list client stream (pprint-pop))))

(defmethod pprint-do (client stream object)
  (pprint-tagbody-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-indent client stream :current 0)
    (pprint-newline client stream :miser)
    (pprint-bindings client stream (pprint-pop))
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :linear)
    (pprint-linear client stream (pprint-pop) t nil)))

(defmethod pprint-dolist (client stream object)
  (pprint-tagbody-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-fill client stream (pprint-pop) t nil)))

(defmethod pprint-eval-when (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-fill client stream (pprint-pop) t nil)))

(defmethod pprint-let (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-indent client stream :current 0)
    (pprint-newline client stream :miser)
    (pprint-bindings client stream (pprint-pop))))

(defmethod pprint-progn (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)))

(defmethod pprint-progv (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :linear)
    (pprint-linear client stream object t nil)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :linear)
    (pprint-linear client stream (pprint-pop) t nil)))

(defmethod pprint-tagbody (client stream object)
  (pprint-tagbody-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)))

(defmethod pprint-function-call (client stream object &optional argument-count)
  (pprint-function-call-form (client stream object argument-count)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-indent client stream :current 0)
    #+(or)(pprint-newline client stream :fill)))

(defmethod pprint-argument-list (client stream object &optional argument-count)
  (pprint-function-call-form (client stream object argument-count)))

(defmethod pprint-with-hash-table-iterator (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-argument-list client stream (pprint-pop))))

(defmethod pprint-with-compilation-unit (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-argument-list client stream (pprint-pop) 0)))

(defmethod pprint-pprint-logical-block (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-argument-list client stream (pprint-pop) 2)))

(defmethod pprint-lambda-list (client stream object)
  (pprint-format-logical-block (client stream object :paren t)
    (let ((state :required)
          (first t)
          (group nil))
      (loop (pprint-exit-if-list-exhausted)
            (unless first
              (write-char #\Space stream))
            (when group
              (pprint-indent client stream :current 0)
              (setf group nil))
            (let ((arg (pprint-pop)))
              (unless first
                (case arg
                  (&optional
                   (setf state :optional
                         group t)
                   (pprint-indent client stream :block 0)
                   (pprint-newline client stream :linear))
                  ((&rest &body)
                   (setf state :required
                         group t)
                   (pprint-indent client stream :block 0)
                   (pprint-newline client stream :linear))
                  (&key
                   (setf state :key
                         group t)
                   (pprint-indent client stream :block 0)
                   (pprint-newline client stream :linear))
                  (&aux
                   (setf state :optional
                         group t)
                   (pprint-indent client stream :block 0)
                   (pprint-newline client stream :linear))
                  (otherwise
                   (pprint-newline client stream :fill))))
              (ecase state
                (:required
                 (pprint-lambda-list client stream arg))
                ((:optional :key)
                 (pprint-format-logical-block (client stream arg :paren t)
                   (pprint-exit-if-list-exhausted)
                   (if (eq state :key)
                       (pprint-format-logical-block (client stream (pprint-pop) :paren t)
                         (pprint-exit-if-list-exhausted)
                         (incless:write-object client (pprint-pop) stream)
                         (pprint-exit-if-list-exhausted)
                         (write-char #\Space stream)
                         (pprint-newline client stream :fill)
                         (pprint-lambda-list stream (pprint-pop))
                         (loop (pprint-exit-if-list-exhausted)
                               (write-char #\Space stream)
                               (pprint-newline client stream :fill)
                               (incless:write-object client (pprint-pop) stream)))
                       (pprint-lambda-list client stream (pprint-pop)))
                   (loop (pprint-exit-if-list-exhausted)
                         (write-char #\Space stream)
                         (pprint-newline client stream :linear)
                         (incless:write-object client (pprint-pop) stream))))))
            (setf first nil)))))

(defun loop-top-level-clause-p (item)
  (and (symbolp item)
       (member item (getf *options* :loop-top-level-clauses) :test #'string=)))

(defun loop-conditional-clause-p (item)
  (and (symbolp item)
       (member item (getf *options* :loop-conditional-clauses) :test #'string=)))

(defun loop-compound-clause-p (item)
  (and (symbolp item)
       (member item (getf *options* :loop-compound-clauses) :test #'string=)))

(defun loop-selectable-clause-p (item)
  (and (symbolp item)
       (member item (getf *options* :loop-selectable-clauses) :test #'string=)))

(defun loop-newline-p (item parent)
  (and (or (loop-top-level-clause-p item)
           (loop-selectable-clause-p item)
           (and (symbolp parent)
                (and (loop-compound-clause-p parent)
                     (listp item)))
           (and (symbolp item)
                (string= item :and)))
       (not (and (symbolp parent)
                 (string= parent :else)
                 (symbolp item)
                 (member item '(:if :when :unless) :test #'string=)))))

(defun loop-start-clause-p (item parent)
  (and (or (loop-top-level-clause-p item)
           (loop-selectable-clause-p item))
       (not (and (symbolp parent)
                 (string= parent :else)
                 (symbolp item)
                 (member item '(:if :when :unless) :test #'string=)))))

(defun loop-end-clause-p (item parent)
  (or (and (loop-selectable-clause-p parent)
           (symbolp item)
           (string= item :and))
      #+(or)(and (symbolp item)
           (string= item :end))))

(defun loop-end-all-clauses-p (item parent)
  (or (loop-top-level-clause-p item)
      (and (not (loop-conditional-clause-p parent))
           (loop-selectable-clause-p item))))

(defun loop-block-indent-p (item)
  (and (symbolp item)
       (member item (getf *options* :loop-block-indent-clauses)
               :test #'string=)))

(defun loop-current-indent-p (item)
  (and (symbolp item)
       (member item (getf *options* :loop-current-indent-clauses)
               :test #'string=)))

(defun allow-break-p (item parent)
  (or (not (symbolp item))
      (not (member item '(:and :do :doing :finally :initially)
                   :test #'string=))
      (and (string= item :and)
           (member parent '(:as :for :with)))))

(defmethod pprint-extended-loop (client stream object)
  (pprint-format-logical-block (client stream object :paren t)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-indent client stream :current 0)
    (let (allow-break-p clauses)
      (flet ((do-newline ()
               (if allow-break-p
                   (pprint-newline client stream :mandatory)
                   (setf allow-break-p t)))
             (end-all-clauses ()
               (loop while clauses
                     do (pop clauses)
                        (pprint-end-logical-block client stream ""))))
        (unwind-protect
            (loop for item = (pprint-pop)
                  for parent = (car clauses)
                  when (loop-end-clause-p item parent)
                    do (pop clauses)
                       (pprint-end-logical-block client stream "")
                  when (loop-end-all-clauses-p item parent)
                    do (end-all-clauses)
                  when (loop-newline-p item parent)
                    do (do-newline)
                  when (loop-start-clause-p item parent)
                    do (pprint-start-logical-block client stream "" nil)
                       (push item clauses)
                  do (incless:write-object client item stream)
                     (pprint-exit-if-list-exhausted)
                     (write-char #\Space stream)
                  when (loop-block-indent-p item)
                    do (pprint-indent client stream :block 2)
                  when (loop-current-indent-p item)
                    do (pprint-indent client stream :current 0)
                  do (setf allow-break-p (allow-break-p item parent)))
          (end-all-clauses))))))

(defmethod pprint-simple-loop (client stream object)
  (pprint-list (client stream object :paren t :newline :mandatory)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-indent client stream :current 0)))

(defmethod pprint-array (client stream (object vector))
  (pprint-logical-block (client stream nil :prefix "#(" :suffix ")")
    (dotimes (pos (length object))
      (unless (zerop pos)
        (write-char #\Space stream)
        (pprint-newline client stream :fill))
      (pprint-pop)
      (incless:write-object client (aref object pos) stream))))

(defmethod pprint-array (client stream object)
  (let ((stream (make-pretty-stream client stream)))
    (labels ((pprint-subarray (index dimensions)
               (pprint-logical-block (client stream nil :prefix (if (= (length dimensions)
                                                                       (array-rank object))
                                                                    (format nil "#~DA(" (array-rank object))
                                                                    "(")
                                                        :suffix ")")
                 (loop with dimension = (car dimensions)
                       with remaining-dimensions = (cdr dimensions)
                       for pos below dimension
                       for new-index = (+ pos (* index dimension))
                       unless (zerop pos)
                         do (write-char #\Space stream)
                            (pprint-newline client stream :fill)
                       do (pprint-pop)
                       if remaining-dimensions
                         do (pprint-subarray new-index remaining-dimensions)
                       else
                         do (incless:write-object client (row-major-aref object new-index) stream)))))
      (pprint-subarray 0 (array-dimensions object)))))

(defmethod pprint-lambda (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :fill)
    (pprint-lambda-list client stream (pprint-pop))))

(defmethod pprint-quote (client stream object)
  (write-char #\' stream)
  (incless:write-object client (second object) stream))

(defmethod pprint-function-quote (client stream object)
  (write-string "#'" stream)
  (incless:write-object client (second object) stream))

(defmethod pprint-cond (client stream object)
  (pprint-format-logical-block (client stream object :paren t)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-indent client stream :current 0)
    (loop do (pprint-linear client stream (pprint-pop) t nil)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space stream)
             (pprint-newline client stream :mandatory))))

(defmethod pprint-flet (client stream object)
  (pprint-body-form (client stream object)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-format-logical-block (client stream (pprint-pop) :paren t)
      (pprint-exit-if-list-exhausted)
      (pprint-lambda client stream (pprint-pop))
      (pprint-exit-if-list-exhausted)
      (write-char #\Space stream)
      (pprint-newline client stream :linear))))

(defmethod pprint-if (client stream object)
  (pprint-list (client stream object :paren t :newline :linear)
    (pprint-exit-if-list-exhausted)
    (incless:write-object client (pprint-pop) stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-indent client stream :current 0)))

