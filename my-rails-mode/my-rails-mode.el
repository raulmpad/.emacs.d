(require 'my-rails-mode-model)
(require 'my-rails-mode-controller)

(defcustom my-rails-grep-extensions '("builder" "erb" "haml" "liquid" "mab" "rake" "rb" "rhtml" "rjs" "rxml" "yml" "feature" "js" "html" "rtex" "prawn")
  "List of file extensions which grep searches."
  :group 'my-rails-mode
  :type '(repeat string))

(defun my-rails-mode:highlight-keywords (keywords)
  (setq ruby-extra-keywords (append ruby-extra-keywords keywords ))
  (ruby-local-enable-extra-keywords))

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

(defun my-rails-mode:grep-project (regexp)
  "Find regexp in project."
  (interactive (progn (grep-compute-defaults)
                      (list (grep-read-regexp))))
  (rgrep regexp (mapconcat (lambda (ext) (format "*.%s" ext)) my-rails-grep-extensions " ") (my-rails-mode:root)))

(define-minor-mode my-rails-mode
  "My custom RubyOnRails minor mode"
  nil
  " myRoR"
  `(
    (,(kbd "C-c s") . my-rails-mode:grep-project)
    )
  )

(defun my-rails-mode:is-under (path)
"Returns t if it is under root + path "
(if (string-match (concat "^" (my-rails-mode:root) path) (expand-file-name default-directory))
                  t
                  nil
                 )
)

(defun set-my-rails-mode ()
  (when (my-rails-mode:root)
    (my-rails-mode t)))

(add-hook 'find-file-hook 'set-my-rails-mode)


;;; (defvar my-rails-mode-map
;;;   (let ((map (make-keymap)))
;;;     (define-key map (kbd "C-c s") 'my-rails-mode:grep-project)
;;;     map))

(provide 'my-rails-mode)

