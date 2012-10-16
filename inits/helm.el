(require 'helm-mode)
(global-set-key (kbd "s-a") 'helm-mini)
(global-set-key (kbd "s-i") 'helm-imenu)
(global-set-key (kbd "s-x") 'helm-M-x)
(global-set-key (kbd "S-,") 'er/expand-region)
(global-set-key (kbd "C-c SPC") 'helm-all-mark-rings)

(provide 'inits/helm)
