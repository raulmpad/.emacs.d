(add-hook 'after-init-hook '(lambda ()

(defun match-paren (arg)
  "Go to the matching paren if on a paren."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))))

(global-set-key (kbd "s-h") 'windmove-left)
(global-set-key (kbd "s-l") 'windmove-right)
(global-set-key (kbd "s-j") 'windmove-down)
(global-set-key (kbd "s-k") 'windmove-up)

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
))


(evil-define-key 'normal global-map
  (kbd ", s") 'rspec-verify-single
  (kbd ", v") 'rspec-verify
  (kbd ", t") 'rspec-toggle-spec-and-target
  (kbd ", f") 'ido-find-file
  (kbd ", d") 'ido-dired
  (kbd ", c") 'magit-status)
(evil-define-key 'emacs global-map
  (kbd ", f") 'ido-find-file
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

;TODO
(add-hook 'term-mode-hook (lambda ()
                            (local-unset-key "\M-k")
                            (local-unset-key "\M-j")))
(provide 'my-evil-bindings)

