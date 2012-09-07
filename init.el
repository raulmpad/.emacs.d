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



(defun expand-region-init ()
  (global-set-key (kbd "s-,") 'er/expand-region)
  (require 'ruby-mode-expansions))

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

(call-process "/bin/sh" nil t nil "-c" "~/.emacs.d/umount-ram.sh ~/.emacs.d/tmp")

(call-process "/bin/sh" nil t nil "-c" "~/.emacs.d/mount-ram.sh ~/.emacs.d/tmp 30")
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
        (:name starter-kit
               :type elpa
               :load "starter-kit.el"
               :post-init (lambda ()
                            (remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)
                            (remove-hook 'prog-mode-hook 'esk-turn-on-idle-highlight-mode)
                            (remove-hook 'prog-mode-hook 'esk-local-comment-auto-fill)))
        (:name starter-kit-ruby
               :type elpa)
        (:name starter-kit-js
               :type elpa)
        (:name starter-kit-lisp
               :type elpa)
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
               :branch "handle-rvm-gemsets-paths-with-at-char"
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
                            (add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
                            (ac-config-default)
                            (setq rsense-home "/usr/local/Cellar/rsense/0.3/libexec")
                            (add-to-list 'load-path (concat rsense-home "/etc"))
                            (setq ac-auto-start t)
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
        ))

(setq my-packages (append '(magit yasnippet inf-ruby)
                          (mapcar 'el-get-source-name el-get-sources)))
(el-get 'sync my-packages)
(global-set-key (kbd "M-e") 'rgrep)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ack-and-a-half-arguments nil)
 '(ack-and-a-half-mode-extension-alist nil)
 '(comint-process-echoes t)
 '(custom-safe-themes (quote ("4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "69349beba557a65bb06f89b28b8fd2890c742f07" "d14db41612953d22506af16ef7a23c4d112150e5" "1440d751f5ef51f9245f8910113daee99848e2c0" "485737acc3bedc0318a567f1c0f5e7ed2dfde3fb" "4711e8fe63ef13accc884c59469067d2f497e79c" default)))
 '(evil-complete-previous-func (lambda (arg) (let ((dabbrev-search-these-buffers-only (buffer-list)) dabbrev-case-distinction) (dabbrev-expand arg))))
 '(evil-default-cursor (quote (t "white")))
 '(evil-flash-delay 5)
 '(evil-motion-state-modes (quote (apropos-mode Buffer-menu-mode calendar-mode command-history-mode compilation-mode dictionary-mode help-mode Info-mode speedbar-mode undo-tree-visualizer-mode view-mode magit-mode)))
 '(projectile-enable-caching t)
 '(rails-rake-use-bundler-when-possible t)
 '(recentf-max-saved-items 40)
 '(rspec-spec-command "rspec")
 '(rspec-use-rake-flag nil)
 '(rspec-use-rvm t)
 '(ruby-check-syntax (quote errors-and-warnings))
 '(ruby-extra-keywords (quote ("include" "extend" "require" "require_relative")))
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 50) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t) (left-fringe . 0))))
 '(tool-bar-mode nil))


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
(defun visit-ansi-term ()
  "If the current buffer is:
     1) a running ansi-term named *ansi-term*, rename it.
     2) a stopped ansi-term, kill it and create a new one.
     3) a non ansi-term, go to an already running ansi-term
        or start a new one while killing a defunt one"
  (interactive)
  (let ((is-term (string= "term-mode" major-mode))
        (is-running (term-check-proc (buffer-name)))
        (term-cmd "/bin/bash")
        (anon-term (get-buffer "*ansi-term*")))
    (if is-term
        (if is-running
            (if (string= "*ansi-term*" (buffer-name))
                (call-interactively 'rename-buffer)
              (if anon-term
                  (switch-to-buffer "*ansi-term*")
                (ansi-term term-cmd)))
          (kill-buffer (buffer-name))
          (ansi-term term-cmd))
      (if anon-term
          (if (term-check-proc "*ansi-term*")
              (switch-to-buffer "*ansi-term*")
            (kill-buffer "*ansi-term*")
            (ansi-term term-cmd))
        (ansi-term term-cmd))))
  (evil-mode nil))
(global-set-key (kbd "<f2>") 'visit-ansi-term)

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
;; todo this is not workin 
(require 'ruby-mode-expansions)

(require 'my-ext)
