;; Only includes gnu packages.
;;
;; See my/more/packages.scm for other channel packages.
(define-module (my packages)
	#:use-module (gnu packages base)
	#:use-module (gnu packages crypto)
	#:use-module (gnu packages guile)
	#:use-module (gnu packages rust-apps)
	#:use-module (gnu packages vim)
	#:use-module (guile-lsp-server)
	#:use-module (guix utils)
)

;; Below is the list of packages that will show up in your
;; Home profile, under ~/.guix-home/profile.

(define local-path "my/packages.local.scm")

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
	(if (%search-load-path local-path) (load-from-path local-path) (list))
)
