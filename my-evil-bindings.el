
(defun match-paren (arg)
  "Go to the matching paren if on a paren."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))))

(global-set-key (kbd "s-h") 'windmove-left)
(global-set-key (kbd "s-l") 'windmove-right)
(global-set-key (kbd "s-j") 'windmove-down)
(global-set-key (kbd "s-k") 'windmove-up)
(global-set-key (kbd "s-d") 'previous-buffer)
(global-set-key (kbd "s-f") 'next-buffer)


;; the greates keymapping EVER
(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "jk" 'evil-esc)
	 
(defun go-to-end-and-insert ()
  (interactive)
  (evil-goto-line nil)
  (evil-append-line nil))

(defun comint-goto-end-and-insert ()
  (interactive)
  (if (not (comint-after-pmark-p))
      (progn (comint-goto-process-mark)
       (evil-append-line nil))
    (evil-insert 1)))
;TODO
(defun comint-resend-last-input ()
  (interactive)
  (other-window 1)
  (comint-goto-end-and-insert)
  (comint-previous-input 1)
  (comint-send-input))

(evil-define-key 'normal term-raw-map "i" 'go-to-end-and-insert)
(evil-define-key 'normal comint-mode-map "i" 'comint-goto-end-and-insert)

(evil-define-key 'insert shell-mode-map (kbd "<up>") 'comint-previous-input)
(evil-define-key 'insert shell-mode-map (kbd "<down>") 'comint-next-input)
(evil-define-key 'insert ielm-map (kbd "<down>") 'comint-next-input)
(evil-define-key 'insert ielm-map (kbd "<up>") 'comint-previous-input)

(evil-define-key 'normal global-map
  (kbd ", s") 'rspec-verify-single
  (kbd ", v") 'rspec-verify
  (kbd ", t") 'rspec-toggle-spec-and-target
  (kbd ", k") 'helm-show-kill-ring
  (kbd ", f") 'ido-find-file
  (kbd ", d") 'ido-dired
  (kbd ", o") 'magit-checkout
  (kbd ", c") 'magit-status)
(evil-define-key 'emacs global-map
  (kbd ", f") 'ido-find-file
  (kbd ", o") 'magit-checkout
  (kbd ", d") 'ido-dired)
(evil-define-key 'motion global-map
  (kbd ", f") 'ido-find-file
  (kbd ", d") 'ido-dired)

(evil-add-hjkl-bindings magit-branch-manager-mode-map 'emacs
  "K" 'magit-discard-item
  "L" 'magit-key-mode-popup-logging)
(evil-add-hjkl-bindings magit-status-mode-map 'emacs
  "K" 'magit-discard-item
  "l" 'magit-key-mode-popup-logging
  "h" 'magit-toggle-diff-refine-hunk)

(add-hook 'compilation-mode-hook '(lambda ()
                                    (local-unset-key "g")
                                    (local-unset-key "h")
                                    (evil-define-key 'motion compilation-mode-map "r" 'recompile)
                                    (evil-define-key 'motion compilation-mode-map "h" 'evil-backward-char)))

(evil-define-key 'insert ruby-mode-map
  (kbd "<enter>") 'ruby-reindent-then-newline-and-indent)

(evil-define-key 'normal global-map (kbd "SPC") 'ace-jump-mode)

(evil-define-key 'normal rspec-mode-map (kbd ",v") '(lambda () (rspec-compile default-directory)))

;; (defun my/paste-shell ()
;;   (interactive)
;;   (term-send-raw-string (current-kill 0)))

;; (evil-define-key 'normal term-raw-escape-map "p" 'my/paste-shell)

(provide 'my-evil-bindings)

