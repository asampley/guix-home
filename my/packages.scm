;; Only includes gnu packages.
;;
;; See my/more/packages.scm for other channel packages.
(define-module (my packages)
	#:use-module (gnu packages base)
	#:use-module (gnu packages crypto)
	#:use-module (gnu packages guile)
	#:use-module (gnu packages rust-apps)
	#:use-module (gnu packages vim)
	#:use-module (guix utils)
	#:use-module (my packages guile)
)

(define local-path (string-append (dirname (current-filename)) "/packages.local.scm"))

;; Below is the list of packages that will show up in your
;; Home profile, under ~/.guix-home/profile.

(define-public base-packages
	(list
		neovim
		ripgrep
		keychain
		glibc-locales
		guile-3.0
		guile-lsp-server
	)
)

(define-public local-packages
	(if (file-exists? local-path) (load local-path) (list))
)
