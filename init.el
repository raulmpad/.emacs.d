(push "/usr/local/bin" exec-path)
(push "/opt/local/bin" exec-path)
(add-to-list 'load-path "~/.emacs.d")

(fset 'yes-or-no-p 'y-or-n-p)
(set-frame-font "Monospaced-15")
(setq ring-bell-function 'ignore)

(setq make-backup-files nil)
(setq auto-save-default nil)

;; Original idea from
;; http://www.opensubscriber.com/message/emacs-devel@gnu.org/10971693.html
(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (not (region-active-p))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key (kbd "M-;") 'comment-dwim-line)



(autoload 'vkill "vkill" nil t)
(autoload 'list-unix-processes "vkill" nil t)
(defun open-vkill-and-update ()
  (interactive)
  (vkill)
  (vkill-update-process-info))
(global-set-key (kbd "<f3>") 'open-vkill-and-update)

(add-hook 'vkill-after-send-signal-hook '(lambda ()
                                           (setq line (line-number-at-pos))
                                           (goto-char (point-min)) (forward-line line )
                                           (vkill-update-process-info)))

(setq temporary-file-directory "~/.emacs.d/tmp")

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


(setq font-lock-maximum-decoration t)


(defun delete-trailing-whitespace-on-file-write ()
    (add-hook 'local-write-file-hooks
              '(lambda()
                 (save-excursion
                   (delete-trailing-whitespace)))))

(defun erm-rspec-extra-keywords ()
  (setq ruby-extra-keywords (append '("describe" "pending" "context" "specify" "shared_examples_for" "it_should_behave_like" "before" "it" "after" "background" "feature" "scenario") ruby-extra-keywords))
  (ruby-local-enable-extra-keywords))

(defun my-rhtml-mode-hook ()
  (flyspell-mode-off)
  (turn-off-auto-fill)
                                        ;disable abbrev-mode
  (abbrev-mode -1))

(defadvice find-file-at-point (around goto-line compile activate)
  (let ((line (and (looking-at ".*:\\([0-9]+\\)")
                   (string-to-number (match-string 1)))))
    ad-do-it
    (and line (goto-line line))))

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)

(setq el-get-sources
      '(
        ;ruby-mode is needed for haml-mode to work
        (:name ruby-mode
               :load "ruby-mode.el")
        (:name enhanced-ruby-mode
               :type git
               :url "git://github.com/jacott/Enhanced-Ruby-Mode.git"
               :load "ruby-mode.el"
               :features ruby-mode
               :post-init (lambda ()
                            (setq enh-ruby-program "~/.rvm/rubies/ruby-1.9.3-p125/bin/ruby")
                            ;; (autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
                            (add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
                            (add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
                            ))
        ;; (:name ruby-electric
        ;;        :type git
        ;;        :url "git://github.com/qoobaa/ruby-electric.git")
        (:name rvm
               :type elpa
               :load "rvm.el"
               :post-init (lambda () (rvm-autodetect-ruby)))
        (:name haml-mode
               :type git
               :url "git://github.com/dgutov/haml-mode.git"
               :load "haml-mode.el"
               :feature haml-mode
               :post-init (lambda ()
                            (require 'ruby-mode)
                            (add-hook 'haml-mode-hook 'flyspell-mode-off)
                            (add-hook 'haml-mode-hook 'delete-trailing-whitespace-on-file-write)))
        (:name flymake-haml
               :type elpa
               :post-init (lambda () (add-hook 'haml-mode-hook 'flymake-haml-load)))
        ;; (:name flymake-ruby :type elpa
        ;;        :post-init (lambda () (add-hook 'ruby-mode-hook 'flymake-ruby-load)))
        (:name color-theme-sanityinc-solarized
               :type elpa)
        (:name helm
               :type elpa
               :post-init (lambda ()
                            (require 'helm-mode)
                            (global-set-key (kbd "s-r") 'helm-projectile)
                            (global-set-key (kbd "s-a") 'helm-mini)
                            (global-set-key (kbd "s-i") 'helm-imenu)
                            (global-set-key (kbd "s-x") 'helm-M-x)))
        (:name key-chord
               :type emacswiki
               :load "key-chord.el"
               :feature key-chord
               :post-init (lambda ()
                            (key-chord-mode 1)))
        (:name evil
               :type git
               :url "git://gitorious.org/evil/evil.git"
               :load "evil.el"
               :feature evil
               :post-init (lambda ()
                            (require 'my-evil-bindings)
                            (evil-mode 1)))
        (:name evil-surround
               :type git
               :url "git://github.com/timcharper/evil-surround.git"
               :load "surround.el"
               :feature surround
               :post-init (lambda ()
                            (global-surround-mode 1)))
        (:name rspec-mode
               :type git
               :url "git://github.com/asok/rspec-mode.git"
               :load "rspec-mode.el"
               :feature rspec-mode
               :post-init (lambda ()
                            (add-hook 'rspec-mode-hook 'erm-rspec-extra-keywords)
                            (define-key rspec-mode-verifible-keymap (kbd "s") 'rspec-verify-single)))
        (:name rhtml-mode
               :load "rhtml-mode.el"
               :feature rhtml-mode
               :post-init (lambda ()
                            (add-to-list 'auto-mode-alist '("\\.js\.erb$" . rhtml-mode))
                            (add-to-list 'auto-mode-alist '("\\.text\.erb$" . rhtml-mode))
                            (add-hook 'rhtml-mode-hook 'my-rhtml-mode-hook)))
        (:name yaml-mode
               :type git
               :url "git://github.com/yoshiki/yaml-mode.git"
               :post-init (lambda ()
                            (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))))
        (:name bundler
               :type git
               :branch "bundle-list-gems-without-nils"
               :url "git://github.com/asok/bundler.el.git"
               :feature bundler)
        (:name thingatpt+
               :type emacswiki
               :load "thingatpt+.el"
               :feature "thingatpt")
        (:name ack-and-a-half
               :type git
               :url "git://github.com/gleber/ack-and-a-half.git"
               :branch "autofill-word-at-point"
               :post-init (lambda ()
                            (autoload 'ack-and-a-half-same "ack-and-a-half" nil t)
                            (autoload 'ack-and-a-half "ack-and-a-half" nil t)
                            (autoload 'ack-and-a-half-find-file-same "ack-and-a-half" nil t)
                            (autoload 'ack-and-a-half-find-file "ack-and-a-half" nil t)
                            ;; Create shorter aliases
                            (defalias 'ack 'ack-and-a-half)
                            (defalias 'ack-same 'ack-and-a-half-same)
                            (defalias 'ack-find-file 'ack-and-a-half-find-file)
                            (defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)
                            ))
        (:name rainbow-delimiters
               :description "Color nested parentheses, brackets, and braces according to their depth."
               :type elpa
               :feature rainbow-delimiters
               :post-init (lambda () (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)))
        ;; (:name multi-web-mode
        ;;        :type elpa
        ;;        :url "git://github.com/fgallina/multi-web-mode.git"
        ;;        :feature multi-web-mode)
        (:name ace-jump
               :type git
               :url "git://github.com/winterTTr/ace-jump-mode.git"
               :feature ace-jump-mode)
        (:name projectile
               :type git
               :url "git://github.com/bbatsov/projectile.git"
               :post-init (lambda ()
                            (require 'projectile)
                            (add-hook 'ruby-mode-hook #'(lambda () (projectile-mode)))
                            (add-hook 'rhtml-mode-hook #'(lambda () (projectile-mode)))
                            (setq projectile-ignored-directories (append projectile-ignored-directories '("tmp" "public" "coverage" "log" "vendor" "db/migrate")))))
        (:name auto-complete
               :type elpa
               :post-init (lambda ()
                            (require 'auto-complete-config)
                            ;; (add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
                            (ac-config-default)
                            (setq rsense-home "/usr/local/Cellar/rsense/0.3/libexec")
                            (add-to-list 'load-path (concat rsense-home "/etc"))
                            (setq ac-auto-start nil)
                            (require 'rsense)
                            ))
        (:name pry
               :type git
               :url "git://github.com/jacott/emacs-pry"
               :post-init (lambda () (require 'pry))
               )
        (:name expand-region
               :type git
               :url "git://github.com/magnars/expand-region.el.git"
               :post-init (lambda ()
                            (global-set-key (kbd "S-,") 'er/expand-region)))
        (:name idle-highlight
               :type git
               :url "git://github.com/nonsequitur/idle-highlight-mode.git")
        (:name wgrep
               :type git
               :url "git://github.com/mhayashi1120/Emacs-wgrep.git"
               :branch "BR-ack-support")
        ))

(setq my-packages (append '(magit yasnippet inf-ruby)
                          (mapcar 'el-get-source-name el-get-sources)))
(el-get 'sync my-packages)

(global-set-key (kbd "M-e") 'rgrep)


(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(auto-fill-mode nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(erm-syn-errline ((t (:underline "Red"))))
 '(erm-syn-warnline ((t (:underline "Orange"))))
 '(helm-selection ((t (:underline t))))
 '(magit-item-highlight ((t nil)) t)
 '(yas/field-highlight-face ((t (:inherit (quote highlight))))))

(menu-bar-mode 1)

(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M [])
                                        ;(aset buffer-display-table ?\^[ []))
  )
(add-hook 'fundamental-mode-hook 'remove-dos-eol)

(load-theme 'wombat)

(require 'term)

(defun visit-shell ()
  "If the current buffer is:
     1) a running shell named *shell*, rename it.
     2) a non shell, go to an already running shell
        or start a new one while killing a defunt one"
  (interactive)
  (if (and (string= "shell-mode" major-mode) (string= "*shell*" (buffer-name)))
      (call-interactively 'rename-buffer)
    (shell)))

(global-set-key (kbd "<f2>") 'visit-shell)

(add-to-list 'load-path "~/.emacs.d/my-rails-mode/")
(require 'my-rails-mode)

                                        ;(add-hook 'magit-checkout-command-hook '(lambda () (projectile-invalidate-cache)))

(require 'yasnippet)
(yas/initialize)
(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)

(defun inf-ruby-keys () nil)

;; (defun multi-web-mode-html-erb ()
;;     (setq mweb-default-major-mode 'rhtml-mode)
;;     (setq mweb-tags '((ruby-mode "<%=" "%>")))
;;     (setq mweb-filename-extensions '("html.erb"))
;;     (multi-web-mode)
;;     )

;; (defun multi-web-mode-text-erb ()
;;     (setq mweb-default-major-mode 'text-mode)
;;     (setq mweb-tags '((ruby-mode "<%==\\|<%=\\|<%#\\|<%" "%>")))
;;     (setq mweb-filename-extensions '("text.erb"))
;;     (multi-web-mode))

;; (add-to-list 'auto-mode-alist '("\.html\.erb$" . multi-web-mode-html-erb))
;; (add-to-list 'auto-mode-alist '("\.text\.erb$" . multi-web-mode-text-erb))

(global-unset-key (kbd "s-t"))
(global-unset-key (kbd "s-y"))
(global-unset-key (kbd "s-u"))

(global-set-key (kbd "C-q") (lambda () (interactive) (switch-to-prev-buffer (previous-window))))
(global-set-key (kbd "C-w") (lambda () (interactive) (switch-to-next-buffer (previous-window))))

(electric-pair-mode)

(add-hook 'ruby-mode-hook 'delete-trailing-whitespace-on-file-write)

(set-variable 'shell-file-name "/bin/bash")

(global-set-key (kbd "s-,") 'er/expand-region)

(global-set-key (kbd "C-c SPC") 'helm-all-mark-rings)
;; todo this is not workin 
(require 'ruby-mode-expansions)

(require 'my-ext)

(defun my-idle-highlight-hook ()
  (if window-system
      (progn (idle-highlight-mode t) (hl-line-mode -1))))

(add-hook 'emacs-lisp-mode-hook 'my-idle-highlight-hook)
(add-hook 'js2-mode-hook 'my-idle-highlight-hook)
