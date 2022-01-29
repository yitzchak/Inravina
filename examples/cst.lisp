(asdf:load-system :inravina/ext.extrinsic)
(asdf:load-system :concrete-syntax-tree)

(defclass cst-client (inravina:client)
  ())

(defclass cst-stream (trivial-gray-streams:fundamental-character-output-stream)
  ((target :reader target
           :initarg :target)
   (line :accessor line
         :initform 1)
   (objects :reader objects
            :initform (make-hash-table :test #'eq))))

(defmethod trivial-gray-streams:stream-write-char ((stream cst-stream) char)
  (when (char= #\Newline char)
    (incf (line stream)))
  (write-char char (target stream)))

(defmethod trivial-gray-streams:stream-write-string ((stream cst-stream) string &optional start end)
  (incf (line stream) (count #\Newline string  :start start :end end))
  (write-string string (target stream) :start start :end end))

(defmethod trivial-gray-streams:stream-line-column ((stream cst-stream))
  (trivial-stream-column:line-column (target stream)))

(defmethod trivial-gray-streams:stream-advance-to-column ((stream cst-stream) column)
  (trivial-stream-column:advance-to-column column (target stream)))

(defmethod trivial-gray-streams:stream-terpri ((stream cst-stream))
  (incf (line stream))
  (terpri (target stream)))

(defmethod trivial-gray-streams:stream-finish-output ((stream cst-stream))
  (finish-output (target stream)))

(defmethod trivial-gray-streams:stream-force-output ((stream cst-stream))
  (force-output (target stream)))

(defmethod trivial-gray-streams:stream-clear-output ((stream cst-stream))
  (clear-output (target stream)))

(defmethod (setf trivial-stream-column:stream-style) (new-style (stream cst-stream))
  (setf (gethash new-style (objects stream))
        (list :line (line stream)
              :column (trivial-stream-column:line-column (target stream)))))

(defmethod incless:write-object :before ((client cst-client) object stream)
  (trivial-stream-column:set-style object stream))

(defun find-sources (cst source objects)
  (let ((lc (gethash (cst:raw cst) objects)))
    (when lc
      (setf (cst:source cst) (list* :source source lc)))
    (when (typep cst 'cst:cons-cst)
      (find-sources (cst:first cst) source objects)
      (find-sources (cst:rest cst) source objects))))

(defun cst-from-expression (expr)
  (let* ((cst (cst:cst-from-expression expr))
         (inravina:*client* (make-instance 'cst-client))
         (incless:*client* inravina:*client*)
         (stream (make-instance 'cst-stream :target (make-string-output-stream))))
    (incless/ext:pprint expr stream)
    (find-sources cst (get-output-stream-string (target stream)) (objects stream))
    cst))
  
