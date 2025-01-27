(use-modules
	(gnu packages base)
	(gnu packages rust-apps)
	(gnu packages vim)
	(guile-lsp-server)
)

;; Below is the list of packages that will show up in your
;; Home profile, under ~/.guix-home/profile.

(append
	(list
		neovim
		ripgrep
		glibc-locales
		guile-lsp-server
	)
	(if (%search-load-path "packages.local.scm") (load-from-path "packages.local.scm") (list))
)
