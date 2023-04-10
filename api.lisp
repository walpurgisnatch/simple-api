(ql:quickload '(clack ningle jonathan))

(defvar *app* (make-instance 'ningle:<app>))

(defvar *server* nil)

(defparameter *items* '((:|id| 0 :|name| "item 1" :|description| "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ullamcorper sapien tellus, sit amet facilisis erat varius ac. Quisque commodo elit neque, vel rhoncus nulla pulvinar et. Aliquam erat volutpat. Ut convallis, felis a imperdiet blandit, diam arcu iaculis metus, ut condimentum sem elit vitae tellus. Nulla at interdum orci. Curabitur vehicula, risus eu volutpat porta, tortor urna imperdiet risus, at dapibus eros magna id elit. Integer placerat, velit dictum aliquam sodales, dui justo ullamcorper nulla, sed finibus justo dolor nec velit. Fusce consequat porttitor elit in congue. In id vehicula felis. Quisque sem ex, imperdiet nec scelerisque eu, feugiat quis nunc. " :|cost| 4100)
                  (:|id| 1 :|name| "item 2" :|description| "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ullamcorper sapien tellus, sit amet facilisis erat varius ac. Quisque commodo elit neque, vel rhoncus nulla pulvinar et. Aliquam erat volutpat. Ut convallis, felis a imperdiet blandit, diam arcu iaculis metus, ut condimentum sem elit vitae tellus. Nulla at interdum orci. Curabitur vehicula, risus eu volutpat porta, tortor urna imperdiet risus, at dapibus eros magna id elit. Integer placerat, velit dictum aliquam sodales, dui justo ullamcorper nulla, sed finibus justo dolor nec velit. Fusce consequat porttitor elit in congue. In id vehicula felis. Quisque sem ex, imperdiet nec scelerisque eu, feugiat quis nunc. " :|cost| 2020)
                  (:|id| 2 :|name| "another" :|description| "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ullamcorper sapien tellus, sit amet facilisis erat varius ac. Quisque commodo elit neque, vel rhoncus nulla pulvinar et. Aliquam erat volutpat. Ut convallis, felis a imperdiet blandit, diam arcu iaculis metus, ut condimentum sem elit vitae tellus. Nulla at interdum orci. Curabitur vehicula, risus eu volutpat porta, tortor urna imperdiet risus, at dapibus eros magna id elit. Integer placerat, velit dictum aliquam sodales, dui justo ullamcorper nulla, sed finibus justo dolor nec velit. Fusce consequat porttitor elit in congue. In id vehicula felis. Quisque sem ex, imperdiet nec scelerisque eu, feugiat quis nunc. " :|cost| 6000)
                  (:|id| 3 :|name| "here we go" :|description| " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ullamcorper sapien tellus, sit amet facilisis erat varius ac. Quisque commodo elit neque, vel rhoncus nulla pulvinar et. Aliquam erat volutpat. Ut convallis, felis a imperdiet blandit, diam arcu iaculis metus, ut condimentum sem elit vitae tellus. Nulla at interdum orci. Curabitur vehicula, risus eu volutpat porta, tortor urna imperdiet risus, at dapibus eros magna id elit. Integer placerat, velit dictum aliquam sodales, dui justo ullamcorper nulla, sed finibus justo dolor nec velit. Fusce consequat porttitor elit in congue. In id vehicula felis. Quisque sem ex, imperdiet nec scelerisque eu, feugiat quis nunc.

Cras sodales eros id aliquam convallis. Maecenas sagittis dui vel dolor auctor, in accumsan augue eleifend. Donec id bibendum risus. Ut et porta sem, nec ullamcorper massa. Maecenas vitae lectus eros. Quisque egestas quis eros vel commodo. Curabitur eu ultrices arcu, nec tempor nisi. Maecenas vitae turpis urna. Pellentesque eleifend interdum leo quis posuere.

Aenean at ullamcorper massa. Quisque et orci risus. Nulla ante erat, vestibulum sit amet ultrices consequat, gravida id erat. Pellentesque pharetra sapien eros, vitae pellentesque enim commodo nec. Vestibulum consequat condimentum interdum. In vel neque quis diam pulvinar dapibus. Maecenas vel velit accumsan, convallis elit nec, tempor lorem. Aliquam erat volutpat.

Ut vulputate libero in felis cursus, eu pellentesque dolor cursus. Sed pulvinar purus a ex fermentum sodales. Aenean dignissim, orci eu lobortis pulvinar, libero turpis dignissim massa, ut dapibus arcu mi vitae orci. Nullam mattis non purus sed malesuada. Sed ut sapien id neque dictum euismod. Maecenas luctus nisl at sem accumsan lobortis. Sed ut orci non elit scelerisque porta. Cras sit amet nibh lobortis, varius nunc ut, sodales mauris. Nullam id diam sit amet sapien facilisis porttitor. Etiam ac pellentesque ipsum. " :|cost| 1500)
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
      (progn (clack:stop *server*)
             (setf *server* nil))
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

