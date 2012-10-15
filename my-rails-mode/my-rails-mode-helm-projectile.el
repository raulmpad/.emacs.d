(require 'helm-projectile)

(defmacro mrm/def-helm-c-source (name)
  `(defvar ,(intern (format "mrm/helm-c-source-%S-files-list" name))
     (list '(name . ,(format "%S" name))
	   ;; Needed for filenames with capitals letters.
	   '(disable-shortcuts)
	   '(candidates . ,(intern (format "mrm/%S-files-list" name)))
	   '(volatile)
	   '(keymap . ,helm-generic-files-map)
	   '(help-message . helm-generic-file-help-message)
	   '(match  helm-c-match-on-basename)
	   '(mode-line . helm-generic-file-mode-line-string)
	   '(type . file))))

(defmacro mrm/def-files-list (name path)
  `(defun ,(intern (format "mrm/%S-files-list" name)) ()
     (projectile-get-project-files (concat (projectile-get-project-root) ,path))))

(defmacro mrm/def-helm-projectile (name)
;;;###autoload
  `(defun ,(intern (format "mrm/helm-projectile-%S" name)) ()
     ,(format "Search using helm for %S" name)
     (interactive)
     (helm-other-buffer (list ,(intern (format "mrm/helm-c-source-%S-files-list" name)))
			,(format "*My Rails Mode %s*" name ))))

(loop for pair in 
      '((models  "app/models/")
	(views  "app/views/")
	(controllers  "app/controllers/")
	(helpers  "app/helpers/")
	(specs  "specs/")
	(javascripts  "public/javascripts/")
	(stylesheets  "public/stylesheets/"))
      do(progn
	  (eval `(mrm/def-helm-c-source ,(first pair)))
	  (eval `(mrm/def-files-list ,(first pair) ,(second pair)))
	  (eval `(mrm/def-helm-projectile ,(first pair)))))

;;;###autoload
(defun mrm/helm-projectile-all (&optional arg)
  "Search using helm for models, views, controllers, helpers, specs, js and stylesheets files.
   If called with optional arg uses `helm-projectile' for show all files in the project."
  (interactive "P")
  (if (consp arg)
      (helm-projectile)
    (helm-other-buffer '(mrm/helm-c-source-models-files-list
			 mrm/helm-c-source-views-files-list
			 mrm/helm-c-source-controllers-files-list
			 mrm/helm-c-source-helpers-files-list
			 mrm/helm-c-source-specs-files-list
			 mrm/helm-c-source-javascripts-files-list
			 mrm/helm-c-source-stylesheets-files-list)
		       (format "*My Rails Mode %s*" "specs" ))))

(provide 'my-rails-mode-helm-projectile)
