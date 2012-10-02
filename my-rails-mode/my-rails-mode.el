(require 'cl)
(require 'my-rails-mode-model)
(require 'my-rails-mode-controller)
(require 'my-rails-mode-migration)
(require 'my-rails-mode-view)
(require 'my-rails-mode-rake)
(require 'my-rails-mode-helm-projectile)
(require 'ack-and-a-half)


(defvar my-rails-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c s") 'mrm/ack-project)
    (define-key map (kbd "C-<return>") 'mrm/jump)
    (define-key map (kbd "C-c C-r") 'mrm/run-server)
    (define-key map (kbd "C-c r") 'mrm/rake)
    (define-key map (kbd "s-t") 'mrm/helm-projectile-controllers)
    (define-key map (kbd "s-y") 'mrm/helm-projectile-models)
    (define-key map (kbd "s-u") 'mrm/helm-projectile-views)
    (define-key map (kbd "s-o") 'mrm/helm-projectile-specs)
    map)
  "Keymap for `my-rails-mode`.")

(defun mrm/highlight-keywords (keywords)
  (setq ruby-extra-keywords (append ruby-extra-keywords keywords ))
  (ruby-local-enable-extra-keywords))

;Stolen from https://github.com/remvee/emacs-rails/blob/master/rails-project.el
(defun mrm/root ()
  "Return RAILS_ROOT if this file is a part of a Rails application,
else return nil"
  (let ((curdir default-directory)
        (max 6)
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

(defun mrm/ack-project (pattern &optional regexp directory)
  (interactive (ack-and-a-half-interactive))
  (ack-and-a-half-run (mrm/root) regexp (concat "--type=ruby --type=html --type=js --type=css --type-add html=.haml --type-add css=.sass,.scss --ignore-dir=tmp --ignore-dir=coverage " pattern)))

(defun mrm/find-class (word)
  (loop for file in (list (concat (mrm/root) "app/models/" word ".rb")
                          (concat (mrm/root) "app/mailers/" word ".rb")
                          (concat (mrm/root)  "lib/" word ".rb"))
        do (if (file-exists-p file) (find-file file))))

(defun mrm/jump ()
  (interactive)
  (let ((word (thing-at-point 'symbol))
        (case-fold-search nil))
    (cond ((mrm/under-p "app/views/")
           (mrm/find-partial-or-template word))
          ((string-match-p "^[A-Z].*" word)
           (mrm/find-class (downcase (replace-regexp-in-string "::" "/" word))))
          (t  (mrm/find-class (downcase
                               (replace-regexp-in-string "s$" ""
                                                         (replace-regexp-in-string ":" ""
                                        ; we've grabbed something like :hedges (strip ':' and 's') TODO: pluralization is dumb here
                                                                                   (replace-regexp-in-string "::" "/" word))))))
          )))

(defun mrm/substring-of-regexp (regexp word)
  "Returns substring of word starting from beginning of matched regexp till end"
  (substring word (+ (string-match regexp word) 1) (match-end 1)))


(defun mrm/insert-string (regexp word string)
  "Inserts string after the catched regexp in the word"
  (let ((pos (if (string-match-p "/" word)
                 (+ (string-match "/.*$" word) 1)
               0)))
    (concat (substring word 0 pos) string (substring word pos))))

(defun mrm/open-log ()
  (interactive)
  (find-file
   (concat (mrm/root)
           "log/"
           (ido-completing-read "Open log: " (directory-files (concat (mrm/root) "log/") nil "[^.|^..]"))))
  (auto-revert-tail-mode 1)
  (my-rails-mode t))

(defun mrm/run-server (&optional arg)
  "Run server with 'bundle exec rails server' command and outputs to
buffer named whatever `mrm/run-server-buffer-name' returns.
If the server is already running switch to the compilation buffer.
If the current buffer is the compilation buffer restart the server.
If invoked with prefix arg shutdown the server."
  (interactive "P")
  (if (consp arg) (progn
                    (kill-process (mrm/run-server-buffer-name)) (kill-buffer (mrm/run-server-buffer-name)))
    (if (string= (buffer-name) (mrm/run-server-buffer-name))
        (recompile)
      (if (get-buffer (mrm/run-server-buffer-name))
          (switch-to-buffer-other-window (mrm/run-server-buffer-name))
        (start-process "rails server" (mrm/run-server-buffer-name) "rails" "server")
        (save-window-excursion
          (switch-to-buffer (mrm/run-server-buffer-name))
          (my-rails-mode t))
        ))))

(defun mrm/run-server-buffer-name (&optional arg)
  "*MyRoRServer*")

(defun mrm/under-p (dirname)
  "Returns t if `default-directory' is under pass dir name "
  (if (string-match (concat dirname "\\(\.*\\)?$") (expand-file-name default-directory))
      t
    nil))

(defun mrm/trim-string (string)
  "Remove white spaces in beginning and ending of STRING.
White space here is any of: space, tab, emacs newline (line feed, ASCII 10)."
  (replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string)))

(defun mrm/zeus-or-bundler-command ()
  (if (file-exists-p (concat (mrm/root) ".zeus.sock"))
      "zeus "
    "bundle exec "))

(defmacro mrm/in-root (body-form)
  `(let ((default-directory (mrm/root)))
     ,body-form))

(define-minor-mode my-rails-mode
  "My custom RubyOnRails minor mode"
  :init-value nil
  :lighter " myRoR"
  :keymap my-rails-mode-map)

(define-globalized-minor-mode global-my-rails-mode my-rails-mode
  (lambda ()
    (when (mrm/root)
      (my-rails-mode t))))

(global-my-rails-mode t)

(provide 'my-rails-mode)

