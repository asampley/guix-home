;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.
(add-to-load-path (dirname (current-filename)))


(use-modules
	(ice-9 ftw)
	(gnu home)
	(gnu packages)
	(gnu services)
	(guix channels)
	(guix gexp)
	(guix utils)
	(gnu home services)
	(gnu home services guix)
	(gnu home services shells)
	(gnu home services shepherd)
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
		;;(enter? (lambda (path stat result) #f))
		(leaf (lambda (path stat result)
			(if (not (enter? path stat result)) ;; skip directories turned leaf because we didn't enter them
				result
				(let* (
					(out-path (substring path (+ 1 (string-length (current-source-directory)))))
					(store-path (substring out-path (+ 1 (string-length rel-dir))))
				) (cons
					(list out-path (file-append store "/" store-path))
					result
				))
			)
		))
		(down (lambda (path stat result) result))
		(up (lambda (path stat result) result))
		(skip (lambda (path stat result) (display (format #f "skipping ~:s~%" path))))
		(error (lambda (path stat errno result)
			(if (= errno 2)
				(display (format #f "warning: path does not exist path:~:s, stat:~:s, errno:~:s~%" path stat errno))
				(raise-exception (format #f "error: couldn't read path:~:s, stat:~:s, errno:~:s~%" path stat errno))
			)
			result
		))
	) (file-system-fold enter? leaf down up skip error '() abs-dir))
)

(home-environment
	;; Below is the list of packages that will show up in your
	;; Home profile, under ~/.guix-home/profile.
	(packages (load "packages.scm"))

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
					(bash-profile (list (local-file ".bash_profile" "bash_profile")))
					(bashrc (list (local-file ".bashrc" "bashrc")))
					(bash-logout (list (local-file ".bash_logout" "bash_logout")))
				)
			)
			(simple-service 'env-vars-service
				home-environment-variables-service-type
				'(
					("EDITOR" . "nvim")
					("VISUAL" . "nvim")
					("PATH" . "$HOME/.local/bin${PATH:+:${PATH}}")
				)
			)
			(simple-service 'config-files-service
				home-files-service-type
				(append
					;; regular links
					`(
						(".editorconfig" ,(local-file ".editorconfig" "editorconfig"))
					)
					;; leaf links allow files to be added, if they don't conflict
					(file-leaves ".config/nvim" "config-nvim")
					(file-leaves ".config/autostart" "config-autostart")
				)
			)
		)
	)
)
