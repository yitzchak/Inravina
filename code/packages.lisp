(defpackage #:inravina
  (:use #:common-lisp)
  (:documentation "A portable and extensible Common Lisp pretty printer.")
  (:shadow
    "COPY-PPRINT-DISPATCH"
    "PPRINT-DISPATCH"
    "PPRINT-EXIT-IF-LIST-EXHAUSTED"
    "PPRINT-FILL"
    "PPRINT-INDENT"
    "PPRINT-LINEAR"
    "PPRINT-LOGICAL-BLOCK"
    "PPRINT-NEWLINE"
    "PPRINT-POP"
    "PPRINT-TAB"
    "PPRINT-TABULAR"
    ;"*PRINT-PPRINT-DISPATCH*"
    "SET-PPRINT-DISPATCH")
  (:export
    #:client
    #:*client*
    #:copy-pprint-dispatch
    #:*options*
    #:pprint-argument-list
    #:pprint-bindings
    #:pprint-block
    #:pprint-defun
    #:pprint-defmethod-with-qualifier
    #:pprint-dispatch
    #:pprint-do
    #:pprint-dolist
    #:pprint-eval-when
    #:pprint-extended-loop
    #:pprint-exit-if-list-exhausted
    #:pprint-fill
    #:pprint-fill-plist
    #:pprint-function-call
    #:pprint-indent
    #:pprint-lambda-list
    #:pprint-let
    #:pprint-linear
    #:pprint-linear-plist
    #:pprint-logical-block
    #:pprint-newline
    #:pprint-pop
    #:pprint-pprint-logical-block
    #:pprint-progn
    #:pprint-progv
    #:pprint-simple-loop
    #:pprint-tab
    #:pprint-tabular
    #:pprint-tabular-plist
    #:pprint-tagbody
    #:pprint-with-compilation-unit
    #:pprint-with-hash-table-iterator
    ;#:*print-pprint-dispatch*
    #:set-pprint-dispatch))

