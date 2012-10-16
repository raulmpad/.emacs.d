(require 'popup)
(require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)
;; (setq rsense-home "/usr/local/Cellar/rsense/0.3/libexec")
;; (add-to-list 'load-path (concat rsense-home "/etc"))
(setq ac-auto-start 3)

(provide 'inits/auto-complete)
