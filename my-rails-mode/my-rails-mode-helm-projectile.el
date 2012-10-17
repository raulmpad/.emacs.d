(require 'helm-projectile)


(defmacro mrm/def-helm-c-source (name path)
  `(defvar ,(intern (format "mrm/helm-c-source-%S-files-list" name))
     '((name . ,(format "%S" name))
       ;; Needed for filenames with capitals letters.
       (disable-shortcuts)
       (candidates . ,(intern (format "mrm/%S-files-list" name)))
       (volatile)
       (keymap . ,helm-generic-files-map)
       (help-message . helm-generic-file-help-message)
       (match  helm-c-match-on-basename)
       (candidate-number-limit . 25)
       (mode-line . helm-generic-file-mode-line-string)
       (action . (lambda (candidate)
		   (find-file (concat (projectile-get-project-root) ,path candidate))))
       (type . file))))

(defmacro mrm/def-files-list (name path regexp)
  `(defun ,(intern (format "mrm/%S-files-list" name)) ()
     (let ((subdirpath (concat (expand-file-name (projectile-get-project-root)) ,path)))
       (remq nil (mapcar (lambda (c) (if (string-match ,regexp c) (substring c (length subdirpath))))
			 (projectile-get-project-files subdirpath))))
     ))

(defmacro mrm/def-helm-projectile (name)
;;;###autoload
  `(defun ,(intern (format "mrm/helm-projectile-%S" name)) ()
     ,(format "Search using helm for %S" name)
     (interactive)
     (helm-other-buffer (list ,(intern (format "mrm/helm-c-source-%S-files-list" name)))
			,(format "*My Rails Mode %s*" name ))))

(loop for args in 
      '((models  "app/models/" ".rb$")
	(views  "app/views/" ".rb$")
	(controllers  "app/controllers/" ".rb$")
	(helpers  "app/helpers/" ".rb$")
	(mailers  "app/mailers/" ".rb$")
	(specs  "spec/" "_spec.rb$")
	(javascripts  "public/javascripts/" ".js$")
	(stylesheets  "public/stylesheets/" ".css$"))
      do(progn
	  (eval `(mrm/def-helm-c-source ,(first args) ,(second args)))
	  (eval `(mrm/def-files-list ,(first args) ,(second args) ,(third args)))
	  (eval `(mrm/def-helm-projectile ,(first args)))))

;(mrm/def-helm-c-source various )
;(defun mrm/various-files-list ()
;  (let ((projectile-ignored-directories '("tmp"
;					   "public"
;					   "coverage"
;					   "vendor"
;					   "app"
;					   "spec")))
;    (mapcar (lambda (c)
;	      (car (last (split-string c "/"))))
;	    (projectile-get-project-files (projectile-get-project-root)))
;    ))

;;;###autoload
(defun mrm/helm-projectile-all () ;(&optional arg)
  (interactive)
  (helm-projectile)
  ;"Search using helm for models, views, controllers, helpers, specs, js and stylesheets files.
   ;If called with optional arg uses `helm-projectile' for show all files in the project."
  ;(interactive "P")
  ;(if (consp arg)
    ;(helm-other-buffer '(mrm/helm-c-source-models-files-list
			 ;mrm/helm-c-source-views-files-list
			 ;mrm/helm-c-source-controllers-files-list
			 ;mrm/helm-c-source-helpers-files-list
			 ;mrm/helm-c-source-mailers-files-list
			 ;mrm/helm-c-source-specs-files-list
			 ;mrm/helm-c-source-javascripts-files-list
			 ;mrm/helm-c-source-stylesheets-files-list
			 ;mrm/helm-c-source-various-files-list)
		       ;(format "*My Rails Mode %s*" "specs" ))
    ;(helm-projectile))
  )

(provide 'my-rails-mode-helm-projectile)
