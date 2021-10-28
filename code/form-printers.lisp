(in-package #:inravina)

(defmethod pprint-bindings (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-format-logical-block (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (loop do (pprint-linear client stream (pprint-pop) t nil)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space stream)
             (pprint-newline client stream :linear))))

(defmethod pprint-block (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-body-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :fill)
    (write (pprint-pop) :stream stream)))

(defmethod pprint-defun (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-body-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-indent client stream :current 0)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :fill)
    (let ((arg (pprint-pop)))
      (when (and at-sign-p
                 arg
                 (symbolp arg))
        (write arg :stream stream)
        (pprint-exit-if-list-exhausted)
        (write-char #\Space stream)
        (pprint-newline client stream :fill)
        (setf arg (pprint-pop)))
      (pprint-lambda-list client stream arg t nil))))

(defmethod pprint-do (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-tagbody-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-indent client stream :current 0)
    (pprint-newline client stream :miser)
    (pprint-bindings client stream (pprint-pop) t nil)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :fill)
    (pprint-linear client stream (pprint-pop) t nil)))

(defmethod pprint-dolist (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-tagbody-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-fill client stream (pprint-pop) t nil)))

(defmethod pprint-eval-when (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-body-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-fill client stream (pprint-pop) t nil)))

(defmethod pprint-let (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-body-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-indent client stream :current 0)
    (pprint-newline client stream :miser)
    (pprint-bindings client stream (pprint-pop) t nil)))

(defmethod pprint-progn (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-body-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)))

(defmethod pprint-progv (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-body-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :linear)
    (pprint-linear client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-newline client stream :linear)
    (pprint-linear client stream (pprint-pop) t nil)))

(defmethod pprint-tagbody (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-tagbody-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)))

(defmethod pprint-function-call (client stream object &optional colon-p at-sign-p argument-count)
  (declare (ignore at-sign-p))
  (pprint-function-call-form (client stream object colon-p at-sign-p argument-count)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (write-char #\Space stream)
    (pprint-indent client stream :current 0)
    (pprint-newline client stream :fill)))

(defmethod pprint-argument-list (client stream object &optional colon-p at-sign-p argument-count)
  (declare (ignore at-sign-p))
  (pprint-function-call-form (client stream object colon-p at-sign-p argument-count)))

(defmethod pprint-with-hash-table-iterator (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-body-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-argument-list client stream (pprint-pop) t nil nil)))

(defmethod pprint-with-compilation-unit (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-body-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-argument-list client stream (pprint-pop) t nil 0)))

(defmethod pprint-pprint-logical-block (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-body-form (client stream object colon-p at-sign-p)
    (pprint-exit-if-list-exhausted)
    (write (pprint-pop) :stream stream)
    (pprint-exit-if-list-exhausted)
    (pprint-indent client stream :block 3)
    (write-char #\Space stream)
    (pprint-newline client stream :miser)
    (pprint-argument-list client stream (pprint-pop) t nil 2)))

(defmethod pprint-lambda-list (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-format-logical-block (client stream object colon-p at-sign-p)
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
                 (pprint-lambda-list client stream arg colon-p at-sign-p))
                ((:optional :key)
                 (pprint-format-logical-block (client stream arg colon-p at-sign-p)
                   (pprint-exit-if-list-exhausted)
                   (if (eq state :key)
                       (pprint-format-logical-block (client stream (pprint-pop) t nil)
                         (pprint-exit-if-list-exhausted)
                         (write (pprint-pop) :stream stream)
                         (pprint-exit-if-list-exhausted)
                         (write-char #\Space stream)
                         (pprint-newline client stream :fill)
                         (pprint-lambda-list stream (pprint-pop) t nil)
                         (loop (pprint-exit-if-list-exhausted)
                               (write-char #\Space stream)
                               (pprint-newline client stream :fill)
                               (write (pprint-pop) :stream stream)))
                       (pprint-lambda-list client stream (pprint-pop) t nil))
                   (loop (pprint-exit-if-list-exhausted)
                         (write-char #\Space stream)
                         (pprint-newline client stream :linear)
                         (write (pprint-pop) :stream stream))))))
            (setf first nil)))))

