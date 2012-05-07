(require 'my-rails-mode-model)
(require 'my-rails-mode-controller)
(require 'my-rails-mode-migration)
;; (require 'my-rails-mode-views)

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

(defun my-rails-mode:find-class (word)
  (let ((curdir default-directory)
        (found nil)
        (model (concat (my-rails-mode:root) "app/models/" word ".rb"))
        (mailer (concat (my-rails-mode:root) "app/mailers/" word ".rb"))
        (controller (concat (my-rails-mode:root) "app/controllers/" word ".rb"))
        (lib (concat (my-rails-mode:root)  "lib/" word ".rb")))

    (cond ((file-exists-p model
           (find-file model)) 
          ((file-exists-p mailer)
           (find-file mailer))
          ((file-exists-p controller)
           (find-file controller))
          ((file-exists-p lib)
           (find-file lib)))
    )
  )

(defun my-rails-mode:jump ()
  (interactive)
  (let ((word (thing-at-point 'symbol))
        (case-fold-search nil))
    (if (string-match-p "^[A-Z].*" word)
        (my-rails-mode:find-class word)))

  )

(defun my-rails-mode:open-log ()
(interactive)
(find-file
 (concat (my-rails-mode:root)
         "log/"
         (ido-completing-read "Open log: " (directory-files (concat (my-rails-mode:root) "log/")))))
(compilation-mode 1)
(auto-revert-tail-mode 1))


(defun my-rails-mode:under-p (path)
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

(define-minor-mode my-rails-mode
  "My custom RubyOnRails minor mode"
  nil
  " myRoR"
  `(
    (,(kbd "C-c s") . my-rails-mode:grep-project)
    (,(kbd "<C-return>") . my-rails-mode:jump)
    )
  )

(provide 'my-rails-mode)

