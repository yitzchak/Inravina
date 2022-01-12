(in-package #:inravina/ext)

(defmacro without-package-locks (&body body)
  `(progn ,@body))
