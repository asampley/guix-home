(define-module (my services)
	#:use-module (gnu services)
	#:use-module (gnu home services)
	#:use-module (gnu home services guix)
	#:use-module (gnu home services shells)
	#:use-module (guix channels)
	#:use-module (my util)
)

(define-public channels-non-guix-service
	(simple-service 'my-home-channels-non-guix-service
		home-channels-service-type
		(list
			(channel
				(name 'nonguix)
				(url "https://gitlab.com/nonguix/nonguix")
				;; Enable signature verification:
				(introduction
					(make-channel-introduction
						"897c1a470da759236cc11798f4e0a5f7d4d59fbc"
						(openpgp-fingerprint "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")
					)
				)
			)
		)
	)
)

(define-public my-nvim-service-type
	(service-type
		(name 'my-nvim)
		(description "My home nvim service")
		(extensions (list
			(service-extension home-environment-variables-service-type (lambda (config)
				'(
					("EDITOR" . "nvim")
					("VISUAL" . "nvim")
				)
			))
			(service-extension home-files-service-type (lambda (config)
				(home-file-leaves ".config/nvim" "config-nvim")
			))
			(service-extension home-bash-service-type (lambda (config)
				(home-bash-extension
					(aliases '(
						("vim" . "nvim")
					))
				)
			))
		))
		(default-value (list))
	)
)

(define-public my-shell-service-type
	(service-type
		(name 'my-shell)
		(description "My home shell service")
		(extensions (list
			(service-extension home-bash-service-type (lambda (config)
				(home-bash-extension
					(aliases '(
						("ls" . "ls --color=auto")
					))
					(bash-profile (list (home-file ".bash_profile" "bash_profile")))
					(bashrc (list (home-file ".bashrc" "bashrc")))
					(bash-logout (list (home-file ".bash_logout" "bash_logout")))
				)
			))
			(service-extension home-shell-profile-service-type (lambda (config)
				(list
					(home-file ".profile" "profile")
				)
			))
			(service-extension home-environment-variables-service-type (lambda (config)
				'(
					("PATH" . "$HOME/.local/bin${PATH:+:${PATH}}")
				)
			))
		))
		(default-value (list))
	)
)

(define-public config-service
	(simple-service 'my-home-config-files-service
		home-files-service-type
		(append
			;; regular links
			`(
				(".editorconfig" ,(home-file ".editorconfig" "editorconfig"))
			)
			;; leaf links allow files to be added, if they don't conflict
			(home-file-leaves ".config/autostart" "config-autostart")
		)
	)
)

(define-public base-services (list
	channels-non-guix-service
	(service my-nvim-service-type)
	(service my-shell-service-type)
	config-service
))

(define local-path (string-append (dirname (current-filename)) "/services.local.scm"))

(define-public local-services
	(if (file-exists? local-path) (load local-path) (list))
)
