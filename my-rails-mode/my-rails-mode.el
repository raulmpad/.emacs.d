(require 'my-rails-mode-model)
(require 'my-rails-mode-controller)
(require 'my-rails-mode-migration)
;; (require 'my-rails-mode-views)
(require 'ack-and-a-half)

(defvar my-rails-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c s") 'mrm/ack-project)
    (define-key map (kbd "C-<return>") 'mrm/jump)
    (define-key map (kbd "C-c r") 'mrm/run-server)
    (define-key map (kbd "C-c b") 'mrm/bundle-open)
    (define-key map (kbd "s-t") 'mrm/helm-projectile-controllers)
    (define-key map (kbd "s-y") 'mrm/helm-projectile-models)
    (define-key map (kbd "s-u") 'mrm/helm-projectile-specs)
    map)
  "Keymap for `my-rails-mode`.")

(defun mrm/highlight-keywords (keywords)
  (setq ruby-extra-keywords (append ruby-extra-keywords keywords ))
  (ruby-local-enable-extra-keywords))

(defun mrm/root ()
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

(defun mrm/ack-project (pattern &optional regexp directory)
  (interactive (ack-and-a-half-interactive))
  (ack-and-a-half-run (mrm/root) regexp (concat "--type=ruby --type=html --type=js --type=css --type-add html=.haml --type-add css=.sass,.scss --ignore-dir=tmp --ignore-dir=coverage " pattern)))

(defun mrm/find-class (word)
  (let ((curdir default-directory)
        (model (concat (mrm/root) "app/models/" word ".rb"))
        (mailer (concat (mrm/root) "app/mailers/" word ".rb"))
        (lib (concat (mrm/root)  "lib/" word ".rb")))

    (cond ((file-exists-p model)
           (find-file model)) 
          ((file-exists-p mailer)
           (find-file mailer))
          ((file-exists-p lib)
           (find-file lib)))
    ))

(defun mrm/jump ()
  (interactive)
  (let ((word (thing-at-point 'symbol))
        (case-fold-search nil))
    
    (if (string-match-p "^[A-Z].*" word) 
        (mrm/find-class (downcase (replace-regexp-in-string "::" "/" word)))
      (if (string-match-p "['\"\\|/]" word) ; we've grabbed string from view
          (mrm/find-partial-or-template word)
        (mrm/find-class (downcase
                                   (replace-regexp-in-string "s$" ""
                                                             (replace-regexp-in-string ":" ""
                                                                                       (replace-regexp-in-string "::" "/" word))))))) ; we've grabbed something like :hedges (strip ':' and 's') TODO: pluralization is dumb here
    )
  )

(defun mrm/substring-of-regexp (regexp word)
  "Returns substring of word starting from beginning of matched regexp plus the passed length"
  (substring word (+ (string-match regexp word) 1) (match-end 1)))

;TODO DRY it up
(defun mrm/find-partial-or-template (word)
  (let ((word (replace-regexp-in-string "['\"]" "" word)) ; get rid of ' and "
        (path (concat (mrm/root) "app/views/"))
        (cur-format (mrm/substring-of-regexp ".\\(js\\|html\\|text\\|csv\\|pdf\\)." buffer-file-name))) ; extract current format
    (if (string-match-p "/" word)
        (cond 
         ((file-exists-p (concat path word)) ; user.html.erb
          (find-file (concat path word)))

         ((file-exists-p (concat path word "." cur-format ".erb")) ; user
          (find-file (concat path word "." cur-format ".erb")))

         ((file-exists-p (concat path word "." cur-format ".haml")) ; user
          (find-file (concat path word "." cur-format ".haml")))

         ((file-exists-p (concat path (mrm/insert-string "/.*$" word "_"))) ; _user.html.erb
          (find-file (concat path (mrm/insert-string "/.*$" word "_"))))

         ((file-exists-p (concat path (mrm/insert-string "/.*$" word "_") "." cur-format ".erb")) ; _user
          (find-file (concat path (mrm/insert-string "/.*$" word "_") "." cur-format ".erb")))

         ((file-exists-p (concat path (mrm/insert-string "/.*$" word "_") "." cur-format ".haml")) ; _user
          (find-file (concat path (mrm/insert-string "/.*$" word "_") "." cur-format ".haml")))
         ))
    (cond  ; anything inside of current directory
     ((file-exists-p (concat default-directory word)) ; user.html.erb
      (find-file (concat default-directory word)))

     ((file-exists-p (concat default-directory word "." cur-format ".erb")) ; user
      (find-file (concat default-directory word "." cur-format ".erb")))

     ((file-exists-p (concat default-directory word "." cur-format ".haml")) ; user
      (find-file (concat default-directory word "." cur-format ".haml")))

     ((file-exists-p (concat default-directory "_" word)) ; _user.html.erb
      (find-file (concat default-directory "_" word)))

     ((file-exists-p (concat default-directory "_" word "." cur-format ".erb")) ; _user
      (find-file (concat default-directory "_" word "." cur-format ".erb")))

     ((file-exists-p (concat default-directory "_" word "." cur-format ".haml")) ; _user
      (find-file (concat default-directory "_" word "." cur-format ".haml"))
      )

     )

    ))

(defun mrm/insert-string (regexp word string)
  "Inserts string after the catched regexp in the word"
  (let ((pos (+ (string-match "/.*$" word) 1)))
    (concat (substring word 0 pos) string (substring word pos))
    )

  )

(defun mrm/open-log ()
  (interactive)
  (find-file
   (concat (mrm/root)
           "log/"
           (ido-completing-read "Open log: " (directory-files (concat (mrm/root) "log/") nil "[^.|^..]"))))
  (auto-revert-tail-mode 1))

(defun mrm/run-server (&optional arg)
  "Run server with 'bundle exec rails server' command and outputs to
buffer named whatever `mrm/run-server-buffer-name' returns.
If the server is already running switch to the compilation buffer.
If the current buffer is the compilation buffer restart the server.
If invoked with prefix arg shutdown the server."
  (interactive "P")
  (if (consp arg) (kill-buffer (mrm/run-server-buffer-name))
    (if (string= (buffer-name) (mrm/run-server-buffer-name))
        (recompile)
      (if (get-buffer (mrm/run-server-buffer-name))
          (switch-to-buffer-other-window (mrm/run-server-buffer-name))
        (compilation-start "bundle exec rails server" t 'mrm/run-server-buffer-name)
        (save-window-excursion
          (switch-to-buffer (mrm/run-server-buffer-name))
          (my-rails-mode t))
        ))))

(defun mrm/run-server-buffer-name (&optional arg)
  (string ?* ?M ?y ?R ?o ?R ? ?S ?e ?r ?v ?e ?r ?*))


(defun mrm/under-p (dirname)
  "Returns t if `default-directory' is under pass dir name "
  (if (string-match (concat dirname "\\(\.*\\)?$") (expand-file-name default-directory))
      t
    nil
    )
  )

(defun mrm/bundle-open (gem)
  (interactive "sGem name: ")
  (let ((dir (mrm/trim-string (shell-command-to-string (concat "bundle show " gem))) ))
    (if (file-exists-p dir)
        (find-file dir))
  ))

(defun mrm/trim-string (string)
  "Remove white spaces in beginning and ending of STRING.
White space here is any of: space, tab, emacs newline (line feed, ASCII 10)."
(replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string))
)

(defun mrm/helm-c-projectile-specs-files-list ()
  "Generates a list of spec files in the current project"
  (projectile-get-project-files
   (concat (mrm/root) "spec/" )))

(defvar mrm/helm-c-source-projectile-specs-files-list
  `((name . "Specs files list")
    ;; Needed for filenames with capitals letters.
    (disable-shortcuts)
    (candidates . mrm/helm-c-projectile-specs-files-list)
    (candidate-number-limit . 15)
    (volatile)
    (keymap . ,helm-generic-files-map)
    (help-message . helm-generic-file-help-message)
    (mode-line . helm-generic-file-mode-line-string)
    (match helm-c-match-on-basename)
    (type . file))
  "Helm source definition")

;;;###autoload
(defun mrm/helm-projectile-specs ()
  "Search using helm for controllers"
  (interactive)
  (helm-other-buffer '(mrm/helm-c-source-projectile-specs-files-list
                       mrm/helm-c-source-projectile-buffers-list)
                     (format "*My Rails Mode %s*" "specs" )))

(defun set-my-rails-mode ()
  (when (mrm/root)
    (my-rails-mode t)))

(add-hook 'find-file-hook 'set-my-rails-mode)

(define-minor-mode my-rails-mode
  "My custom RubyOnRails minor mode"
  nil
  " myRoR"
  my-rails-mode-map
  )

(provide 'my-rails-mode)

