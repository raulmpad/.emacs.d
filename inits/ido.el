(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

(require 'ido-ubiquitous)
(ido-ubiquitous-mode)

(provide 'inits/ido)
