(defun inf-ruby-keys () nil)

;;(setq enh-ruby-program "/usr/local/rvm/rubies/ruby-1.9.3-p194/bin/ruby")
;; (autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(rvm-autodetect-ruby)

(add-hook 'ruby-mode-hook 'delete-trailing-whitespace-on-file-write)

(require 'ruby-mode-expansions)

;rails
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(add-to-list 'auto-mode-alist '("\\.js\.erb$" . rhtml-mode))
(add-to-list 'auto-mode-alist '("\\.text\.erb$" . rhtml-mode))

(global-unset-key (kbd "s-t"))
(global-unset-key (kbd "s-y"))
(global-unset-key (kbd "s-u"))
(add-to-list 'load-path "~/.emacs.d/my-rails-mode/")
(require 'my-rails-mode)

(defun my-rhtml-mode-hook ()
  (flyspell-mode-off)
  (turn-off-auto-fill)
  (abbrev-mode -1))
(add-hook 'rhtml-mode-hook 'my-rhtml-mode-hook)

;rspec
(defadvice rspec-verify-all (after rename-compilation-buffer ())
  "Rename compilation buffer to *compilation all*"
  (save-excursion
    (switch-to-buffer rspec-compilation-buffer-name)
    (rename-buffer "*compilation all*" t)))
(ad-activate 'rspec-verify-all)

(defun erm-rspec-extra-keywords ()
  (setq ruby-extra-keywords (append '("describe" "pending" "context" "specify" "shared_examples_for" "it_should_behave_like" "before" "it" "after" "background" "feature" "scenario") ruby-extra-keywords))
  (ruby-local-enable-extra-keywords))

(add-hook 'rspec-mode-hook 'erm-rspec-extra-keywords)
(define-key rspec-mode-verifible-keymap (kbd "s") 'rspec-verify-single)

(provide 'inits/ruby)
