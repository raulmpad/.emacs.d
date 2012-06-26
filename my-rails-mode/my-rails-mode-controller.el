(require 'my-rails-mode-helm-projectile)

(defcustom mrm/controller-keywords 
  '("logger" "polymorphic_path" "polymorphic_url" "mail" "render" "attachments" "default" "helper" "helper_attr" "helper_method"
    "filter" "layout" "url_for" "serialize" "exempt_from_layout" "filter_parameter_logging" "hide_action" "cache_sweeper" "protect_from_forgery" "caches_page" "cache_page" "caches_action" "expire_page" "expire_action" "rescue_from"
    "params" "request" "response" "session" "flash" "head" "redirect_to" "render_to_string" "respond_with" "before_filter" "append_before_filter" "prepend_before_filter" "after_filter" "append_after_filter" "prepend_after_filter" "around_filter" "append_around_filter" "prepend_around_filter" "skip_before_filter" "skip_after_filter" "skip_filter")
  "List of keywords to highlight for controllers"
  :group 'my-rails-mode
  :type '(repeat string))


(add-hook 'ruby-mode-hook '(lambda ()
                             (when (mrm/under-p "app/controllers/")
                               (mrm/highlight-keywords mrm/controller-keywords))))

(defun mrm/helm-c-projectile-controllers-files-list ()
  "Generates a list of files in the current project"
  (projectile-get-project-files
   (concat (mrm/root) "app/controllers/" )))

(defvar mrm/helm-c-source-projectile-controllers-files-list
  `((name . "Projectile files list")
    ;; Needed for filenames with capitals letters.
    (disable-shortcuts)
    (candidates . mrm/helm-c-projectile-controllers-files-list)
    (candidate-number-limit . 15)
    (volatile)
    (keymap . ,helm-generic-files-map)
    (help-message . helm-generic-file-help-message)
    (mode-line . helm-generic-file-mode-line-string)
    (match helm-c-match-on-basename)
    (type . file))
  "Helm source definition")

;;;###autoload
(defun mrm/helm-projectile-controllers ()
  "Search using helm for controllers"
  (interactive)
  (helm-other-buffer '(mrm/helm-c-source-projectile-controllers-files-list
                       mrm/helm-c-source-projectile-buffers-list)
                     (format "*My Rails Mode %s*" "controllers" )))

(provide 'my-rails-mode-controller)
