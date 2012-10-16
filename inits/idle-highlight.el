(defun my-idle-highlight-hook ()
  (if window-system
      (progn (idle-highlight-mode t) (hl-line-mode -1))))

(add-hook 'emacs-lisp-mode-hook 'my-idle-highlight-hook)
(add-hook 'js2-mode-hook 'my-idle-highlight-hook)

(provide 'inits/idle-highlight)

