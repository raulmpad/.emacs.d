(require 'package)
(add-to-list 'package-archives
                          '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(starter-kit-ruby starter-kit-js starter-kit-lisp anything anything-match-plugin anything-config rvm flymake-ruby color-theme flymake-haml yaml-mode yasnippet yari solarized-theme zenburn-theme)
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
     anything-c-source-recentf
     anything-c-source-imenu)
   " *my-anything*"))
(global-set-key (kbd "s-a") 'my-anything)
(require 'anything-of-rails)
(global-set-key (kbd "s-r") 'anything-of-rails)


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
 '(custom-safe-themes (quote ("1440d751f5ef51f9245f8910113daee99848e2c0" "485737acc3bedc0318a567f1c0f5e7ed2dfde3fb" "4711e8fe63ef13accc884c59469067d2f497e79c" default)))
 '(evil-complete-next-func (lambda (arg) (let ((dabbrev-search-these-buffers-only (buffer-list)) dabbrev-case-distinction) (condition-case nil (if (eq last-command this-command) (dabbrev-expand nil) (dabbrev-expand (- (abs (or arg 1))))) (error (dabbrev-expand nil) j)))))
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

(require 'yasnippet) ;; not yasnippet-bundle
(yas/global-mode 1)

(auto-fill-mode nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-item-highlight ((t nil)) t))

(add-to-list 'load-path "~/.emacs.d/asok/anything-show-completion")
(require 'anything-show-completion)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/asok/enhanced-ruby-mode"))
(setq enh-ruby-program "~/.rvm/bin/ruby-1.9.2-p0") ; so that still works if ruby points to ruby1.8
(require 'ruby-mode)
