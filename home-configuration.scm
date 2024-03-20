;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.
(use-modules
	(ice-9 ftw)
	(gnu home)
	(gnu packages)
	(gnu services)
	(guix gexp)
	(guix utils)
	(gnu home services)
	(gnu home services shells)
	(gnu home services shepherd)
	(gnu packages suckless)
	(gnu packages xdisorg)
)

(define (debug x)
	(display x)
	(newline)
	x
)

(define (file-leaves rel-dir name)
	(let* (
		(abs-dir (string-append (current-source-directory) "/" rel-dir))
		(store (local-file abs-dir name #:recursive? #t))
		(enter? (lambda (path stat result) (not (member (basename path) '(".git")))))
		(leaf (lambda (path stat result)
			(let* (
				(out-path (substring path (+ 1 (string-length (current-source-directory)))))
				(store-path (substring out-path (+ 1 (string-length rel-dir))))
			) (cons
				(list out-path (file-append store "/" store-path))
				result
			))
		))
		(down (lambda (path stat result) result))
		(up (lambda (path stat result) result))
		(skip (lambda (path stat result) (raise-exception (list path stat result))))
		(error (lambda (path stat errno result) (raise-exception (list path stat errno result))))
	) (file-system-fold enter? leaf down up skip error '() abs-dir))
)

(home-environment
	;; Below is the list of packages that will show up in your
	;; Home profile, under ~/.guix-home/profile.
	(packages (specifications->packages '(
		"neovim"
		"ripgrep"
	)))

	;; Below is the list of Home services.  To search for available
	;; services, run 'guix home search KEYWORD' in a terminal.
	(services
		(list
			(service home-bash-service-type
				(home-bash-configuration
					(aliases '(
						("ls" . "ls --color=auto")
						("vim" . "nvim")
					))
					(bashrc (list (local-file ".bashrc" "bashrc")))
					(bash-logout (list (local-file ".bash_logout" "bash_logout")))
				)
			)
			(simple-service 'env-vars-service
				home-environment-variables-service-type
				'(
					("EDITOR" . "nvim")
					("VISUAL" . "nvim")
				)
			)
			(simple-service 'config-files-service
				home-files-service-type
				(append
					;; regular links
					`(
						(".config/nvim" ,(local-file ".config/nvim" "config-nvim" #:recursive? #t))
					)
					;; leaf links for autostart
					(file-leaves ".config/autostart" "config-autostart")
				)
			)
		)
	)
)
