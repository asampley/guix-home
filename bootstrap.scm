;; This "home-environment" file is meant to bootstrap loading the main one.
;; It will only include packages from mainline guix, allowing a pull to
;; update other channels.
(add-to-load-path (dirname (current-filename)))

(use-modules
	(gnu home)
	((my packages) #:prefix my:)
	((my services) #:prefix my:)
)

(home-environment
	;; Below is the list of packages that will show up in your
	;; Home profile, under ~/.guix-home/profile.
	(packages (append
		my:base-packages
		my:local-packages
	))

	;; Below is the list of Home services.  To search for available
	;; services, run 'guix home search KEYWORD' in a terminal.
	(services (append
		my:base-services
		my:local-services
	))
)
