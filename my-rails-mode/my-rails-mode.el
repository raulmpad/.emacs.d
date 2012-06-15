(require 'my-rails-mode-model)
(require 'my-rails-mode-controller)
(require 'my-rails-mode-migration)
;; (require 'my-rails-mode-views)
(require 'ack-and-a-half)

(defvar my-rails-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c s") 'my-rails-mode:ack-project)
    (define-key map (kbd "C-<return>") 'my-rails-mode:jump)
    (define-key map (kbd "C-c r") 'my-rails-mode:run-server)
    map)
  "Keymap for `my-rails-mode`.")

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

(defun my-rails-mode:ack-project (pattern &optional regexp directory)
  (interactive (ack-and-a-half-interactive))
  (ack-and-a-half-run (my-rails-mode:root) regexp (concat "--type=ruby --type=html --type=js --type=css --type-add html=.haml --type-add css=.sass,.scss --ignore-dir=tmp --ignore-dir=coverage " pattern)))

(defun my-rails-mode:find-class (word)
  (let ((curdir default-directory)
        (model (concat (my-rails-mode:root) "app/models/" word ".rb"))
        (mailer (concat (my-rails-mode:root) "app/mailers/" word ".rb"))
        (lib (concat (my-rails-mode:root)  "lib/" word ".rb")))

    (cond ((file-exists-p model)
           (find-file model)) 
          ((file-exists-p mailer)
           (find-file mailer))
          ((file-exists-p lib)
           (find-file lib)))
    ))

(defun my-rails-mode:jump ()
  (interactive)
  (let ((word (thing-at-point 'symbol))
        (case-fold-search nil))
    
    (if (string-match-p "^[A-Z].*" word) 
        (my-rails-mode:find-class (downcase (replace-regexp-in-string "::" "/" word)))
      (if (string-match-p "['\"\\|/]" word) ; we've grabbed string from view
          (my-rails-mode:find-partial-or-template word)
        (my-rails-mode:find-class (downcase
                                   (replace-regexp-in-string "s$" ""
                                                             (replace-regexp-in-string ":" ""
                                                                                       (replace-regexp-in-string "::" "/" word))))))) ; we've grabbed something like :hedges (strip ':' and 's') TODO: pluralization is dumb here
    )
  )

(defun my-rails-mode:substring-of-regexp (regexp word)
  "Returns substring of word starting from beginning of matched regexp plus the passed length"
  (substring word (+ (string-match regexp word) 1) (match-end 1)))

;TODO DRY it up
(defun my-rails-mode:find-partial-or-template (word)
  (let ((word (replace-regexp-in-string "['\"]" "" word)) ; get rid of ' and "
        (path (concat (my-rails-mode:root) "app/views/"))
        (cur-format (my-rails-mode:substring-of-regexp ".\\(js\\|html\\|text\\|csv\\|pdf\\)." buffer-file-name))) ; extract current format
    (if (string-match-p "/" word)
        (cond 
         ((file-exists-p (concat path word)) ; user.html.erb
          (find-file (concat path word)))

         ((file-exists-p (concat path word "." cur-format ".erb")) ; user
          (find-file (concat path word "." cur-format ".erb")))

         ((file-exists-p (concat path word "." cur-format ".haml")) ; user
          (find-file (concat path word "." cur-format ".haml")))

         ((file-exists-p (concat path (my-rails-mode:insert-string "/.*$" word "_"))) ; _user.html.erb
          (find-file (concat path (my-rails-mode:insert-string "/.*$" word "_"))))

         ((file-exists-p (concat path (my-rails-mode:insert-string "/.*$" word "_") "." cur-format ".erb")) ; _user
          (find-file (concat path (my-rails-mode:insert-string "/.*$" word "_") "." cur-format ".erb")))

         ((file-exists-p (concat path (my-rails-mode:insert-string "/.*$" word "_") "." cur-format ".haml")) ; _user
          (find-file (concat path (my-rails-mode:insert-string "/.*$" word "_") "." cur-format ".haml")))
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

(defun my-rails-mode:insert-string (regexp word string)
  (let ((pos (+ (string-match "/.*$" word) 1)))
    (concat (substring word 0 pos) string (substring word pos))
    )

  )

(defun my-rails-mode:open-log ()
  (interactive)
  (find-file
   (concat (my-rails-mode:root)
           "log/"
           (ido-completing-read "Open log: " (directory-files (concat (my-rails-mode:root) "log/") nil "[^.|^..]"))))
  (auto-revert-tail-mode 1))

(defun my-rails-mode:run-server (&optional arg)
  "Run server with 'bundle exec rails server' command and outputs to
buffer named whatever `my-rails-mode:run-server-buffer-name' returns.
If the server is already running switch to the compilation buffer.
If the current buffer is the compilation buffer restart the server.
If invoked with prefix arg shutdown the server."
  (interactive "P")
  (if (consp arg) (kill-buffer (my-rails-mode:run-server-buffer-name))
    (if (string= (buffer-name) (my-rails-mode:run-server-buffer-name))
        (recompile)
      (if (get-buffer (my-rails-mode:run-server-buffer-name))
          (switch-to-buffer-other-window (my-rails-mode:run-server-buffer-name))
        (compilation-start "bundle exec rails server" t 'my-rails-mode:run-server-buffer-name)
        (save-window-excursion
          (switch-to-buffer (my-rails-mode:run-server-buffer-name))
          (my-rails-mode t))
        ))))

(defun my-rails-mode:run-server-buffer-name (&optional arg)
  (string ?* ?M ?y ?R ?o ?R ? ?S ?e ?r ?v ?e ?r ?*))


(defun my-rails-mode:under-p (dirname)
  "Returns t if `default-directory' is under pass dir name "
  (if (string-match (concat dirname "\\(\.*\\)?$") (expand-file-name default-directory))
      t
    nil
    )
  )

(defun set-my-rails-mode ()
  (when (my-rails-mode:root)
    (my-rails-mode t)))

(add-hook 'find-file-hook 'set-my-rails-mode)

(define-minor-mode my-rails-mode
  "My custom RubyOnRails minor mode"
  nil
  " myRoR"
  my-rails-mode-map
  )

(provide 'my-rails-mode)

