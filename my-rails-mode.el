(defun my-rails-mode:root ()
  "Return RAILS_ROOT if this file is a part of a Rails application,
else return nil"
  (let ((curdir default-directory)
        (max 10)
        (found nil))
    (while (and (not found) (> max 0))
      (progn
        (if (file-exists-p (concat curdir "config/environment.rb"))
            (progn
              (setq found t))
          (progn
            (setq curdir (concat curdir "../"))
            (setq max (- max 1))))))
    (if found (expand-file-name curdir))))

(defcustom my-rails-grep-extensions '("builder" "erb" "haml" "liquid" "mab" "rake" "rb" "rhtml" "rjs" "rxml" "yml" "feature" "js" "html" "rtex" "prawn")
  "List of file extensions which grep searches."
  :group 'my-rails-mode
  :type '(repeat string))

(defun my-rails-mode:grep-project (regexp)
  "Find regexp in project."
  (interactive (progn (grep-compute-defaults)
                      (list (grep-read-regexp))))
  (rgrep regexp (mapconcat (lambda (ext) (format "*.%s" ext)) my-rails-grep-extensions " ") (my-rails-mode:root)))


(global-set-key (kbd "C-c s") 'my-rails-mode:grep-project)
(provide 'my-rails-mode)
