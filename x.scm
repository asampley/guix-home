;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.
(add-to-load-path (dirname (current-filename)))

(use-modules
	(gnu home)
	(my packages)
	(my services)
	(my more packages)
	(my more services)
)

(home-environment
	;; Below is the list of packages that will show up in your
	;; Home profile, under ~/.guix-home/profile.
	(packages (append
		base-packages
		desktop-packages
		local-packages
		more-packages
		more-local-packages
	))

	;; Below is the list of Home services.  To search for available
	;; services, run 'guix home search KEYWORD' in a terminal.
	(services (append
		base-services
		desktop-services
		local-services
		more-services
		more-local-services
	))
)
