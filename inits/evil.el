(evil-mode 1)
(global-surround-mode 1)

(key-chord-mode 1)


(defun match-paren (arg)
  "Go to the matching paren if on a paren."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))))


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
  (kbd "C-f") 'evil-scroll-page-down
  (kbd "C-b") 'evil-scroll-page-up)
  ;; "K" 'magit-discard-item
(evil-add-hjkl-bindings magit-status-mode-map 'emacs
  (kbd "C-f") 'evil-scroll-page-down
  (kbd "C-b") 'evil-scroll-page-up
  (kbd "K") 'magit-discard-item
  (kbd "h") 'magit-toggle-diff-refine-hunk
  (kbd "l") 'magit-key-mode-popup-logging)
  ;; "K" 'magit-discard-item
  ;; "l" 'magit-key-mode-popup-logging
  ;; "h" 'magit-toggle-diff-refine-hunk)

(evil-define-key 'motion magit-status-mode-map
  (kbd "<tab>") 'magit-toggle-section
  (kbd "<enter>") 'magit-visit-item
  (kbd ", o") 'magit-checkout
  (kbd ", c") 'magit-status)

(add-hook 'compilation-mode-hook '(lambda ()
                                    (local-unset-key "g")
                                    (local-unset-key "h")
                                    (evil-define-key 'motion compilation-mode-map "r" 'recompile)
                                    (evil-define-key 'motion compilation-mode-map "h" 'evil-backward-char)))

(evil-define-key 'insert ruby-mode-map
  (kbd "<enter>") 'ruby-reindent-then-newline-and-indent)

(evil-define-key 'normal global-map (kbd "SPC") 'ace-jump-mode)

(evil-define-key 'normal dired-mode-map (kbd ", k") 'dired-up-directory)

(defun dired-rspec-verify-single ()
  (interactive)
  (rspec-compile (mapconcat 'identity (dired-get-marked-files) " ") (rspec-core-options)))

(defun dired-rspec-verify ()
  (interactive)
  (rspec-run-single-file (dired-current-directory) (rspec-core-options)))

(evil-define-key 'normal dired-mode-map (kbd ", v") 'dired-rspec-verify)
(evil-define-key 'normal dired-mode-map (kbd ", s") 'dired-rspec-verify-single)

(defun my-move-key (keymap-from keymap-to key)
  "Moves key binding from one keymap to another, deleting from the old location. "
  (define-key keymap-to key (lookup-key keymap-from key))
  (define-key keymap-from key nil))
(my-move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
(my-move-key evil-motion-state-map evil-normal-state-map " ")


;; (evil-define-key 'insert ac-mode-map (kbd "C-n") 'ac-next
;;   (kbd "C-p") 'ac-previous)

(evil-define-key 'motion help-mode-map (kbd "<left>") 'help-go-back)
(evil-define-key 'motion help-mode-map (kbd "<right>") 'help-go-forward)

(defun google-query ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
        (buffer-substring (region-beginning) (region-end))
      (read-string "Google: " (thing-at-point 'symbol))))))

(evil-define-key 'normal global-map (kbd ", g") 'google-query)
(evil-define-key 'motion global-map (kbd ", g") 'google-query)
(evil-define-key 'visual global-map (kbd ", g") 'google-query)
(setq evil-want-fine-undo t)

(provide 'inits/evil)
