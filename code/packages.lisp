(defpackage #:inravina
  (:use #:common-lisp)
  (:documentation "A portable and extensible Common Lisp pretty printer.")
  (:shadow
    #:copy-pprint-dispatch
    #:pprint-dispatch
    #:pprint-exit-if-list-exhausted
    #:pprint-fill
    #:pprint-indent
    #:pprint-linear
    #:pprint-logical-block
    #:pprint-newline
    #:pprint-pop
    #:pprint-tab
    #:pprint-tabular
    #:*print-pprint-dispatch*
    #:set-pprint-dispatch)
  #+sicl (:local-nicknames (:trivial-gray-streams :cyclosis))
  (:export
    #:*client*
    #:client
    #:copy-pprint-dispatch
    #:do-pprint-logical-block
    #:make-pretty-stream
    #:*options*
    #:pprint-apply
    #:pprint-argument-list
    #:pprint-array
    #:pprint-bindings
    #:pprint-block
    #:pprint-case
    #:pprint-cond
    #:pprint-defclass
    #:pprint-defmethod-with-qualifier
    #:pprint-defun
    #:pprint-dispatch
    #:pprint-do
    #:pprint-dolist
    #:pprint-end-logical-block
    #:pprint-eval-when
    #:pprint-exit-if-list-exhausted
    #:pprint-extended-loop
    #:pprint-fill
    #:pprint-fill-plist
    #:pprint-flet
    #:pprint-function-call
    #:pprint-indent
    #:pprint-lambda
    #:pprint-lambda-list
    #:pprint-let
    #:pprint-linear
    #:pprint-linear-plist
    #:pprint-logical-block
    #:pprint-macro-char
    #:pprint-newline
    #:pprint-pop
    #:pprint-pop-p
    #:pprint-progn
    #:pprint-progv
    #:pprint-simple-loop
    #:pprint-start-logical-block
    #:pprint-tab
    #:pprint-tabular
    #:pprint-tabular-plist
    #:pprint-tagbody
    #:pprint-with
    #:pretty-stream-p
    #:pretty-stream
    #:*print-pprint-dispatch*
    #:set-pprint-dispatch))

