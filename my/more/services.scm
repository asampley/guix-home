(define-module (my more services))

(define local-path (string-append (dirname (current-filename)) "/services.local.scm"))

(define-public more-services (list))

(define-public more-local-services
	(if (file-exists? local-path) (load local-path) (list))
)
