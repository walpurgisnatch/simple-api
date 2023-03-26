(ql:quickload '(clack ningle jonathan))

(defvar *app* (make-instance 'ningle:<app>))

(defvar *server* nil)

(defmacro defroute (path &body body)
  `(setf (ningle:route *app* ,path)
         #'(lambda (params)
             (declare (ignore params))
             (setf (lack.response:response-headers ningle:*response*)
                   (append (lack.response:response-headers ningle:*response*)
                           (list :content-type "application/json")))
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

(defroute "/items"
  (jonathan:to-json '((:name "heh" :description "meh" :cost 4000)
                      (:name "kek" :description "wpek" :cost 2000)
                      (:name "another" :description "123" :cost 6000))))

(defroute "/comments"
  (jonathan:to-json '((:name "first" :body "lol")
                      (:name "second" :body "kek")
                      (:name "third" :body "nice"))))

