(define-module (my more services))

(define local-path "my/more/services.local.scm")

(define-public more-services (list))

(define-public more-local-services
	(if (%search-load-path local-path) (load-from-path local-path) (list))
)
