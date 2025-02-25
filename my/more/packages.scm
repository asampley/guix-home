;; Includes non-gnu packages.
(define-module (my more packages))

;; Below is the list of packages that will show up in your
;; Home profile, under ~/.guix-home/profile.

(define-public more-packages (list))

(define local-path (string-append (dirname (current-filename)) "/packages.local.scm"))

(define-public more-local-packages
	(if (file-exists? local-path) (load local-path) (list))
)
