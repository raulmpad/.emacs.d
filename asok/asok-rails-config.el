(defadvice find-file-at-point (around goto-line compile activate)
  (let ((line (and (looking-at ".*:\\([0-9]+\\)")
                   (string-to-number (match-string 1)))))
    ad-do-it
    (and line (goto-line line))))

(add-hook 'rspec-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(describe\\|pending\\|context\\|specify\\|shared_example_group_for\\|it_should_behave_like\\|before\\|it\\|after\\)\\>" . font-lock-function-name-face)))))

(font-lock-add-keywords 'ruby-mode '(("\\<\\(require_relative\\|require\\|include\\|extend\\)\\>" . font-lock-keyword-face)))


(add-to-list 'load-path (expand-file-name "~/.emacs.d/asok/rhtml"))
(require 'rhtml-mode)

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/asok/ruby-electric"))
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/asok/emacs-rails"))
;; (require 'rails)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/asok/rinari"))
(require 'rinari)

(provide 'asok-rails-config)
