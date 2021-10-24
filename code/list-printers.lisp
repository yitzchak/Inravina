(in-package #:inravina)

(defmacro pprint-tail (client stream kind)
  `(loop do (pprint-exit-if-list-exhausted)
            (write-char #\Space ,stream)
            (pprint-newline ,client ,stream ,kind)
            (write (pprint-pop) :stream ,stream)))

(defmacro pprint-format-logical-block ((client stream object colon-p at-sign-p) &body body)
  (declare (ignore at-sign-p))
  `(pprint-logical-block (,client ,stream ,object :prefix (if ,colon-p "(" "")
                                                  :suffix (if ,colon-p ")" ""))
     ,@body))

(defmacro pprint-fill-form ((client stream object colon-p at-sign-p) &body body)
  `(pprint-format-logical-block (,client ,stream ,object ,colon-p ,at-sign-p)
     ,@body
    (pprint-exit-if-list-exhausted)
    (loop do (write (pprint-pop) :stream ,stream)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space ,stream)
             (pprint-newline ,client ,stream :fill))))

(defmacro pprint-linear-form ((client stream object colon-p at-sign-p) &body body)
  `(pprint-format-logical-block (,client ,stream ,object ,colon-p ,at-sign-p)
     ,@body
    (pprint-exit-if-list-exhausted)
    (loop do (write (pprint-pop) :stream ,stream)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space ,stream)
             (pprint-newline ,client ,stream :linear))))

(defmacro pprint-tabular-form ((client stream object colon-p at-sign-p tabsize) &body body)
  `(pprint-format-logical-block (,client ,stream ,object ,colon-p ,at-sign-p)
     ,@body
    (pprint-exit-if-list-exhausted)
    (loop do (write (pprint-pop) :stream ,stream)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space ,stream)
             (pprint-tab ,client ,stream :section-relative 0 ,tabsize)
             (pprint-newline ,client ,stream :fill))))

(defmacro pprint-fill-plist-form ((client stream object colon-p at-sign-p) &body body)
  `(pprint-format-logical-block (,client ,stream ,object ,colon-p ,at-sign-p)
     ,@body
    (pprint-exit-if-list-exhausted)
    (loop do (write (pprint-pop) :stream ,stream)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space ,stream)
             (write (pprint-pop) :stream ,stream)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space ,stream)
             (pprint-newline ,client ,stream :fill))))

(defmacro pprint-linear-plist-form ((client stream object colon-p at-sign-p) &body body)
  `(pprint-format-logical-block (,client ,stream ,object ,colon-p ,at-sign-p)
     ,@body
    (pprint-exit-if-list-exhausted)
    (loop do (write (pprint-pop) :stream ,stream)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space ,stream)
             (write (pprint-pop) :stream ,stream)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space ,stream)
             (pprint-newline ,client ,stream :linear))))

(defmacro pprint-tabular-plist-form ((client stream object colon-p at-sign-p tabsize) &body body)
  `(pprint-format-logical-block (,client ,stream ,object ,colon-p ,at-sign-p)
     ,@body
    (pprint-exit-if-list-exhausted)
    (loop do (write (pprint-pop) :stream ,stream)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space ,stream)
             (pprint-tab client stream :section-relative 0 ,tabsize)
             (write (pprint-pop) :stream ,stream)
             (pprint-exit-if-list-exhausted)
             (write-char #\Space ,stream)
             (pprint-tab client stream :section-relative 0 ,tabsize)
             (pprint-newline ,client ,stream :fill))))

(defmacro pprint-body-form ((client stream object colon-p at-sign-p) &body body)
  `(pprint-linear-form (,client ,stream ,object ,colon-p ,at-sign-p)
     ,@body
     (pprint-exit-if-list-exhausted)
     (pprint-indent ,client ,stream :block 1)
     (write-char #\Space ,stream)
     (pprint-newline ,client ,stream :linear)))

(defmacro pprint-tagbody-form ((client stream object colon-p at-sign-p) &body body)
  `(pprint-format-logical-block (,client ,stream ,object ,colon-p ,at-sign-p)
     ,@body
     (pprint-exit-if-list-exhausted)
     (loop for form-or-tag = (pprint-pop)
           do (pprint-indent ,client ,stream :block
                             (if (atom form-or-tag) 0 1))
              (write-char #\Space ,stream)
              (pprint-newline ,client ,stream :linear)
              (write form-or-tag :stream ,stream)
              (pprint-exit-if-list-exhausted))))

(defmacro pprint-function-call-form ((client stream object colon-p at-sign-p argument-count) &body body)
  `(pprint-fill-plist-form (,client ,stream ,object ,colon-p ,at-sign-p)
     ,@body
     (pprint-exit-if-list-exhausted)
     (loop for i below (or ,argument-count most-positive-fixnum)
           do (write (pprint-pop) :stream ,stream)
              (pprint-exit-if-list-exhausted)
              (write-char #\Space ,stream)
              (pprint-newline ,client ,stream :fill))))

(defmethod pprint-fill (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-fill-form (client stream object colon-p at-sign-p)))

(defmethod pprint-linear (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-linear-form (client stream object colon-p at-sign-p)))

(defmethod pprint-tabular (client stream object &optional colon-p at-sign-p tabsize)
  (declare (ignore at-sign-p))
  (unless tabsize
    (setq tabsize 16))
  (pprint-tabular-form (client stream object colon-p at-sign-p tabsize)))

(defmethod pprint-fill-plist (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-fill-plist-form (client stream object colon-p at-sign-p)))

(defmethod pprint-linear-plist (client stream object &optional colon-p at-sign-p)
  (declare (ignore at-sign-p))
  (pprint-linear-plist-form (client stream object colon-p at-sign-p)))

(defmethod pprint-tabular-plist (client stream object &optional colon-p at-sign-p tabsize)
  (declare (ignore at-sign-p))
  (unless tabsize
    (setq tabsize 16))
  (pprint-tabular-plist-form (client stream object colon-p at-sign-p tabsize)))
  
