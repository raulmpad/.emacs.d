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


(mrm/def-files-list models "app/models/")
(mrm/def-files-list views "app/views/")
(mrm/def-files-list controllers "app/controllers/")
(mrm/def-files-list helpers "app/helpers/")
(mrm/def-files-list specs "spec/")
(mrm/def-files-list javascripts "public/javascripts/")
(mrm/def-files-list stylesheets "public/stylesheets/")

(mrm/def-helm-c-source models)
(mrm/def-helm-c-source views)
(mrm/def-helm-c-source controllers)
(mrm/def-helm-c-source helpers)
(mrm/def-helm-c-source specs)
(mrm/def-helm-c-source javascripts)
(mrm/def-helm-c-source stylesheets)

;;;###autoload
(defun mrm/helm-projectile-models ()
  "Search using helm for models"
  (interactive)
  (helm-other-buffer '(mrm/helm-c-source-models-files-list)
                     (format "*My Rails Mode %s*" "models" )))

;;;###autoload
(defun mrm/helm-projectile-views ()
  "Search using helm for views"
  (interactive)
  (helm-other-buffer '(mrm/helm-c-source-views-files-list)
                     (format "*My Rails Mode %s*" "views" )))

;;;###autoload
(defun mrm/helm-projectile-controllers ()
  "Search using helm for controllers"
  (interactive)
  (helm-other-buffer '(mrm/helm-c-source-controllers-files-list)
                     (format "*My Rails Mode %s*" "controllers" )))

;;;###autoload
(defun mrm/helm-projectile-specs ()
  "Search using helm for specs"
  (interactive)
  (helm-other-buffer '(mrm/helm-c-source-specs-files-list)
                     (format "*My Rails Mode %s*" "specs" )))

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
