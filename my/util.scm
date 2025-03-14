(define-module (my util)
	#:use-module (ice-9 ftw)
	#:use-module (guix gexp)
	#:use-module (guix utils)
)

(define (debug x)
	(display x)
	(newline)
	x
)

(define file-base (string-append (dirname (current-source-directory)) "/files"))

(define-public (home-file-leaves rel-dir name)
	(let* (
		(abs-dir (string-append file-base "/" rel-dir))
		(store (local-file abs-dir name #:recursive? #t))
		(enter? (lambda (path stat result) (not (member (basename path) '(".git")))))
		;;(enter? (lambda (path stat result) #f))
		(leaf (lambda (path stat result)
			(if (not (enter? path stat result)) ;; skip directories turned leaf because we didn't enter them
				result
				(let* (
					(out-path (substring path (+ 1 (string-length file-base))))
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

(define-public (home-file path store-name)
	;; set #:recursive? to true for both directories and to keep executable permissions
	(local-file (string-append file-base "/" path) store-name #:recursive? #t)
)
