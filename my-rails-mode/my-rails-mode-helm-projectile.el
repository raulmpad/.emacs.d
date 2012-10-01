(require 'helm-projectile)

(defmacro mrm/helm-projectile-c-source (function-name)
    `(list '(name . "Files")
         ;; Needed for filenames with capitals letters.
         '(disable-shortcuts)
         '(candidates . ,function-name)
         '(volatile)
         '(keymap . ,helm-generic-files-map)
         '(help-message . helm-generic-file-help-message)
         '(match  helm-c-match-on-basename)
         '(mode-line . helm-generic-file-mode-line-string)
         '(type . file)))

(defun mrm/helm-c-projectile-files-list (path)
  (projectile-get-project-files
   (concat (mrm/root) path)))

;; (defun mrm/helm-c-projectile-models-current-scope-files-list ()
;;   (cond
;;    ((mrm/under-p "controllers")
;;     ()
;;     )

;;    )
;;   )

(defun mrm/helm-c-projectile-models-files-list ()
  (mrm/helm-c-projectile-files-list "app/models/"))

(defun mrm/helm-c-projectile-controllers-files-list ()
  (mrm/helm-c-projectile-files-list "app/controllers/"))

(defun mrm/helm-c-projectile-views-files-list ()
  (mrm/helm-c-projectile-files-list "app/views/"))

(defun mrm/helm-c-projectile-specs-files-list ()
  (mrm/helm-c-projectile-files-list "spec/"))

(defvar mrm/helm-projectile-c-source-models-file-list
 (mrm/helm-projectile-c-source mrm/helm-c-projectile-models-files-list))
;; (defvar mrm/helm-projectile-c-source-models-current-scope-file-list
;;  (mrm/helm-projectile-c-source mrm/helm-c-projectile-models-current-scope-files-list))

(defvar mrm/helm-projectile-c-source-controllers-file-list
 (mrm/helm-projectile-c-source mrm/helm-c-projectile-controllers-files-list))

(defvar mrm/helm-projectile-c-source-views-file-list
 (mrm/helm-projectile-c-source mrm/helm-c-projectile-views-files-list))

(defvar mrm/helm-projectile-c-source-specs-file-list
 (mrm/helm-projectile-c-source mrm/helm-c-projectile-specs-files-list)) 

;;;###autoload
(defun mrm/helm-projectile-models ()
  "Search using helm for models"
  (interactive)
  (helm-other-buffer '(mrm/helm-projectile-c-source-models-file-list)
                     (format "*My Rails Mode %s*" "models" )))

;;;###autoload
(defun mrm/helm-projectile-views ()
  "Search using helm for views"
  (interactive)
  (helm-other-buffer '(mrm/helm-projectile-c-source-views-file-list)
                     (format "*My Rails Mode %s*" "views" )))

;;;###autoload
(defun mrm/helm-projectile-controllers ()
  "Search using helm for controllers"
  (interactive)
  (helm-other-buffer '(mrm/helm-projectile-c-source-controllers-file-list)
                     (format "*My Rails Mode %s*" "controllers" )))

;;;###autoload
(defun mrm/helm-projectile-specs ()
  "Search using helm for specs"
  (interactive)
  (helm-other-buffer '(mrm/helm-projectile-c-source-specs-file-list)
                     (format "*My Rails Mode %s*" "specs" )))

(provide 'my-rails-mode-helm-projectile)
