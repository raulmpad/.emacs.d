(push "/usr/local/bin" exec-path)
(push "/opt/local/bin" exec-path)

(fset 'yes-or-no-p 'y-or-n-p)
(set-frame-font "Menlo-14")
(setq ring-bell-function 'ignore)

(setq make-backup-files nil)
(setq auto-save-default nil)

(add-to-list 'load-path "~/.emacs.d/asok/evil")
(require 'evil)
(evil-mode 1)

(add-to-list 'load-path "~/.emacs.d/asok/evil-surround")
(require 'surround)
(global-surround-mode 1)

(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)
(remove-hook 'prog-mode-hook 'esk-turn-on-idle-highlight-mode)
(remove-hook 'prog-mode-hook 'esk-local-comment-auto-fill)

(add-to-list 'load-path "~/.emacs.d/asok/rspec-mode")
(require 'rspec-mode)
(define-key rspec-mode-verifible-keymap (kbd "s") 'rspec-verify-single)

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
;; use shell instead of ansi-term
;(global-set-key (kbd "<f2>") '(lambda () (interactive) (term "/bin/bash")))
(global-set-key (kbd "<f2>") 'visit-ansi-term)
(setq term-default-bg-color nil)
(setq term-default-fg-color "#708183")


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

(call-process "/bin/sh" nil t nil "-c" "~/.emacs.d/asok/umount-ram.sh ~/.emacs.d/tmp")

(call-process "/bin/sh" nil t nil "-c" "~/.emacs.d/asok/mount-ram.sh ~/.emacs.d/tmp 30")
(setq temporary-file-directory "~/.emacs.d/tmp")

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


(global-set-key (kbd "s-x") 'smex)
(global-set-key (kbd "s-g") 'abort-recursive-edit)

(setq font-lock-maximum-decoration t)

(global-set-key "\M-j" 'previous-buffer)
(global-set-key "\M-k" 'next-buffer)

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/asok/enhanced-ruby-mode"))
;; (setq enh-ruby-program "~/.rvm/bin/ruby-1.9.2-p0") ; so that still works if ruby points to ruby1.8
;; (require 'ruby-mode)
   (autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
   (add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
   (add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(require 'package)
(add-to-list 'package-archives
                          '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(starter-kit-ruby starter-kit-js starter-kit-lisp anything anything-match-plugin
                                       anything-config rvm flymake-ruby color-theme flymake-haml
                                       yasnippet-bundle yari solarized-theme zenburn-theme
                                       color-theme-sanityinc-solarized mo-git-blame ruby-end)
  "A list of packages to ensure are installed at launch.")

  (dolist (p my-packages)
    (when (not (package-installed-p p))
        (package-install p)))

(require 'anything-match-plugin)
(require 'anything-config)
(defun my-anything ()
  (interactive)
  (anything-other-buffer
   '(anything-c-source-buffers
     anything-c-source-recentf)
   " *my-anything*"))
(global-set-key (kbd "s-a") 'my-anything)
(require 'anything-of-rails)
(global-set-key (kbd "s-r") 'anything-of-rails)
(global-set-key (kbd "s-i") '(lambda () (interactive) (anything-other-buffer '(anything-c-source-imenu) "*my-imenu*")))

(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)

(global-set-key (kbd "M-e") 'rgrep)

(require 'rvm)
(rvm-autodetect-ruby)

(require 'asok-rails-config)

(require 'color-theme)
(load-file "~/.emacs.d/asok/railscasts/color-theme-railscasts.el")
;(color-theme-railscasts)

(require 'evil-bindings)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-process-echoes t)
 '(custom-safe-themes (quote ("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "69349beba557a65bb06f89b28b8fd2890c742f07" "d14db41612953d22506af16ef7a23c4d112150e5" "1440d751f5ef51f9245f8910113daee99848e2c0" "485737acc3bedc0318a567f1c0f5e7ed2dfde3fb" "4711e8fe63ef13accc884c59469067d2f497e79c" default)))
 '(evil-complete-previous-func (lambda (arg) (let ((dabbrev-search-these-buffers-only (buffer-list)) dabbrev-case-distinction) (dabbrev-expand arg))))
 '(evil-default-cursor (quote (t "white")))
 '(evil-flash-delay 5)
 '(evil-motion-state-modes (quote (apropos-mode Buffer-menu-mode calendar-mode command-history-mode compilation-mode dictionary-mode help-mode Info-mode speedbar-mode undo-tree-visualizer-mode view-mode magit-mode)))
 '(rails-rake-use-bundler-when-possible t)
 '(recentf-max-saved-items 40)
 '(rspec-spec-command "rspec")
 '(rspec-use-rake-flag nil)
 '(rspec-use-rvm t)
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 50) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t) (left-fringe . 0))))
 '(tool-bar-mode nil))

(require 'haml-mode)
(require 'flymake-haml) (add-hook 'haml-mode-hook 'flymake-haml-load)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(require 'yasnippet-bundle)

(yas/global-mode 1)

(auto-fill-mode nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-item-highlight ((t nil))))

(add-to-list 'load-path "~/.emacs.d/asok/anything-show-completion")
(require 'anything-show-completion)


(autoload 'mo-git-blame-file "mo-git-blame" nil t)
(autoload 'mo-git-blame-current "mo-git-blame" nil t)
(global-set-key [?\C-c ?g ?b] 'mo-git-blame-current)
(global-set-key [?\C-c ?. ?s] 'magit-status)

(require 'ruby-end)
(require 'evil-bindings)

(add-hook 'rhtml-mode-hook '(lambda ()
                              (flymake-mode-off)
                              (turn-off-auto-fill)))

(menu-bar-mode 1)
