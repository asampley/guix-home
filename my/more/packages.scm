;; Includes non-gnu packages.
(define-module (my more packages)
	#:use-module (guix utils)
)

;; Below is the list of packages that will show up in your
;; Home profile, under ~/.guix-home/profile.

(define-public more-packages (list))

(define-public more-local-packages
	(let ((local-path (string-append (current-source-directory) "/my/more/packages.local.scm")))
		(if (file-exists? local-path) (load local-path) (list))
	)
)
