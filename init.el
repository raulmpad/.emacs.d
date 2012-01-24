(require 'package)
(add-to-list 'package-archives
                          '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(starter-kit-ruby starter-kit-js starter-kit-lisp anything anything-match-plugin anything-config rvm flymake-ruby color-theme flymake-haml yaml-mode)
  "A list of packages to ensure are installed at launch.")

  (dolist (p my-packages)
    (when (not (package-installed-p p))
        (package-install p)))

(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)

(require 'anything-match-plugin)
(require 'anything-config)
(defun my-anything ()
  (interactive)
  (anything-other-buffer
   '(anything-c-source-buffers
     anything-c-source-rails-project-files
     anything-c-source-recentf
     anything-c-source-imenu)
   " *my-anything*"))
(global-set-key (kbd "s-a") 'my-anything)
(require 'anything-of-rails)
(global-set-key (kbd "s-r") 'anything-of-rails)


(global-set-key (kbd "M-e") 'rgrep)

(require 'rvm)
(rvm-autodetect-ruby)

(require 'asok-rails-config)

(require 'color-theme)
(load-file "~/.emacs.d/asok/railscasts/color-theme-railscasts.el")
(color-theme-railscasts)

(require 'evil-bindings)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-default-cursor (quote (t "white")))
 '(evil-flash-delay 5)
 '(evil-motion-state-modes (quote (apropos-mode Buffer-menu-mode calendar-mode command-history-mode compilation-mode dictionary-mode help-mode Info-mode speedbar-mode undo-tree-visualizer-mode view-mode magit-mode)))
 '(recentf-max-saved-items 40)
 '(rspec-spec-command "rspec")
 '(rspec-use-rake-flag nil)
 '(rspec-use-rvm t)
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 200) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t) (left-fringe . 0))))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-item-highlight ((t (:inherit default)))))

(require 'haml-mode)
(require 'flymake-haml) (add-hook 'haml-mode-hook 'flymake-haml-load)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
