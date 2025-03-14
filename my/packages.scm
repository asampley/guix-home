;; Only includes gnu packages.
;;
;; See my/more/packages.scm for other channel packages.
(define-module (my packages)
	#:use-module (gnu packages base)
	#:use-module (gnu packages crypto)
	#:use-module (gnu packages gnuzilla)
	#:use-module (gnu packages guile)
	#:use-module (gnu packages rust-apps)
	#:use-module (gnu packages tor-browsers)
	#:use-module (gnu packages vim)
	#:use-module (gnu packages wm)
	#:use-module (gnu packages xdisorg)
	#:use-module (gnu packages xorg)
	#:use-module (guix utils)
	#:use-module (my packages guile)
)

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
		xterm
	)
)

(define-public desktop-packages
	(list
		awesome
		dex
		icecat
		torbrowser
	)
)

(define-public local-packages
	(let ((local-path (string-append (current-source-directory) "my/packages.local.scm")))
		(if (file-exists? local-path) (load local-path) (list))
	)
)
