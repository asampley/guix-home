(use-modules
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
		guile-lsp-server
	)
	(if (search-path (list ".") "packages.local.scm") (load "packages.local.scm") (list))
)
