(ql:quickload '(clack ningle jonathan))

(defvar *app* (make-instance 'ningle:<app>))

(defvar *server* nil)

(defvar *items* '((:|id| 0 :|name| "heh" :|description| "meh" :|cost| 4100)
                  (:|id| 1 :|name| "kek" :|description| "wpek" :|cost| 2020)
                  (:|id| 2 :|name| "another" :|description| "123" :|cost| 6000)
                  (:|id| 3 :|name| "vamp" :|description| "hello" :|cost| 1500)
                  (:|id| 4 :|name| "sudo" :|description| "ls cd ls" :|cost| 3400)))

(defmacro defroute (path &body body)
  `(setf (ningle:route *app* ,path)
         #'(lambda (params)
             (declare (ignore params))
             (setf (lack.response:response-headers ningle:*response*)
                   (append (lack.response:response-headers ningle:*response*)
                           (list :content-type "application/json")
                           (list :access-control-allow-origin "*")))
             ,@body)))

(defun start ()
  (if *server*
      (format t "Already")
      (setf *server* (clack:clackup *app*))))

(defun stop ()
  (if *server*
      (clack:stop *server*)
      (format t "Not running")))

(setf (ningle:route *app* "/") "Fine")

(defroute "/api/items"
  (jonathan:to-json *items*))

(defroute "/api/item/:id"
  (jonathan:to-json (elt *items* (parse-integer (cdr (assoc :id params))))))

(defroute "/api/comments"
  (jonathan:to-json '((:|name| "first" :|body| "lol")
                      (:|name| "second" :|body| "kek")
                      (:|name| "third" :|body| "nice"))))

