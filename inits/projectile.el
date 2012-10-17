(require 'projectile)
(add-hook 'ruby-mode-hook #'(lambda () (projectile-mode)))
(add-hook 'rhtml-mode-hook #'(lambda () (projectile-mode)))
(setq projectile-ignored-directories (append projectile-ignored-directories '("tmp" "public" "coverage" "log" "vendor" "db/migrate")))

;; (add-hook 'magit-checkout-command-hook '(lambda () (projectile-invalidate-cache)))

(provide 'inits/projectile)
