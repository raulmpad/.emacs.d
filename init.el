(setq ring-bell-function nil)
(setq visible-bell nil)
(push "/usr/local/bin" exec-path)
(push "/opt/local/bin" exec-path)
(add-to-list 'load-path "~/.emacs.d")

(fset 'yes-or-no-p 'y-or-n-p)
(set-frame-font "Monospaced-15")
(setq ring-bell-function 'ignore)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq temporary-file-directory "~/.emacs.d/tmp")

(set-variable 'shell-file-name "/bin/bash")
(winner-mode 1)
(scroll-bar-mode -1)
(show-paren-mode t)
(auto-fill-mode nil)
(menu-bar-mode 1)
(blink-cursor-mode -1)

(setq font-lock-maximum-decoration t)
(electric-pair-mode)

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

(defun delete-trailing-whitespace-on-file-write ()
    (add-hook 'local-write-file-hooks
              '(lambda()
                 (save-excursion
                   (delete-trailing-whitespace)))))


(defadvice find-file-at-point (around goto-line compile activate)
  (let ((line (and (looking-at ".*:\\([0-9]+\\)")
                   (string-to-number (match-string 1)))))
    ad-do-it
    (and line (goto-line line))))


(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M [])
					;(aset buffer-display-table ?\^[ []))
  )
(add-hook 'fundamental-mode-hook 'remove-dos-eol)

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

(require 'inits/elisp-extensions)

(require 'inits/packages)

(require 'inits/idle-highlight)
(require 'inits/auto-complete)
(require 'inits/helm)
(require 'inits/projectile)
(require 'inits/ruby)
(require 'inits/evil-and-bindings)
(require 'inits/ido)
(require 'inits/grepping)

;expand-region
;; todo this is not workin 
(global-set-key (kbd "s-,") 'er/expand-region)

;rainbow-delimiters
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-to-list 'auto-mode-alist '("\\.css$" . rainbow-mode))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(load-theme 'solarized-dark)
;; (setq evil-default-cursor (quote (t "black")))

