(in-package #:inravina/ext)

(let (#+sbcl (sb-ext:*muffled-warnings* 'warning))
#+sbcl (eval-when (:compile-toplevel :load-toplevel :execute)
         (sb-ext:add-implementation-package "INRAVINA/EXT" "COMMON-LISP"))

(fmakunbound 'pprint-dispatch)

(defun pprint-dispatch (object &optional table)
  (declare (ignore object table))
  (values nil nil))

(fmakunbound 'copy-pprint-dispatch)
(fmakunbound 'set-pprint-dispatch)

(declaim (ftype (function (&optional (or null inravina::dispatch-table))
                          inravina::dispatch-table)
                copy-pprint-dispatch)
         (ftype (function (t &optional (or null inravina::dispatch-table))
                          (values (or function symbol) boolean))
                pprint-dispatch)
         (ftype (function (t (or function symbol) &optional real inravina::dispatch-table)
                          null)
                set-pprint-dispatch)
         (type inravina::dispatch-table *print-pprint-dispatch*)))

