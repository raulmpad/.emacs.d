(add-to-list 'load-path "~/.emacs.d/asok/rspec-mode")
(require 'rspec-mode)
(define-key rspec-mode-verifible-keymap (kbd "s") 'rspec-verify-single)

(defadvice find-file-at-point (around goto-line compile activate)
  (let ((line (and (looking-at ".*:\\([0-9]+\\)")
                   (string-to-number (match-string 1)))))
    ad-do-it
    (and line (goto-line line))))

;; never called
(defun asok-font-lock-keywording ()
  (add-hook 'rspec-mode-hook
            (lambda ()
              (font-lock-add-keywords nil
                                      '(("\\<\\(describe\\|pending\\|context\\|specify\\|shared_examples_for\\|it_should_behave_like\\|before\\|it\\|after\\)\\>" . font-lock-function-name-face)))))

  (font-lock-add-keywords 'ruby-mode '(("\\<\\(require_relative\\|require\\|include\\|extend\\)\\>" . font-lock-keyword-face))))

(defun erm-rspec-extra-keywords ()
  (setq ruby-extra-keywords (append '("describe" "pending" "context" "specify" "shared_examples_for" "it_should_behave_like" "before" "it" "after" "background" "feature" "scenario") ruby-extra-keywords))
  (ruby-local-enable-extra-keywords))
(add-hook 'rspec-mode-hook 'erm-rspec-extra-keywords)


(add-to-list 'load-path (expand-file-name "~/.emacs.d/asok/rhtml"))
(require 'rhtml-mode)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/asok/ruby-electric"))
(require 'ruby-electric)
(add-hook 'ruby-mode-hook 'ruby-electric-mode)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/asok/emacs-rails"))
(require 'rails)
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/asok/rinari"))
;; (require 'rinari)

;;; TODO nxhtml not working
;; ;;; nxml (HTML ERB template support)
;; (load "~/.emacs.d/asok/nxhtml/autostart.el")

;; (setq
;;  nxhtml-global-minor-mode t
;;  mumamo-chunk-coloring 'submode-colored
;;  nxhtml-skip-welcome t
;;  indent-region-mode t
;;  rng-nxml-auto-validate-flag nil
;;  nxml-degraded t)
;; (add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . eruby-nxhtml-mumamo))

(add-hook 'ruby-mode-hook
          (lambda()
            (add-hook 'local-write-file-hooks
                      '(lambda()
                         (save-excursion
                           (delete-trailing-whitespace))))))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/asok/enhanced-ruby-mode"))
(setq enh-ruby-program "~/.rvm/bin/ruby-1.9.3-p125") ; so that still works if ruby points to ruby1.8
(require 'ruby-mode)

(provide 'asok-rails-config)
