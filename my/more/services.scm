(define-module (my more services)
	#:use-module (guix utils)
)

(define-public more-services (list))

(define-public more-local-services
	(let ((local-path (string-append (current-source-directory) "/my/more/services.local.scm")))
		(if (file-exists? local-path) (load local-path) (list))
	)
)
