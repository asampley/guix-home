;; Includes non-gnu packages.
(define-module (my more packages))

;; Below is the list of packages that will show up in your
;; Home profile, under ~/.guix-home/profile.

(define-public more-packages (list))

(define-public more-local-packages
	(if (%search-load-path "my/more/packages.local.scm") (load-from-path "my/more/packages.local.scm") (list))
)
