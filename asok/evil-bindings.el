(add-hook 'after-init-hook '(lambda ()

(defun match-paren (arg)
  "Go to the matching paren if on a paren."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))))

(require 'surround)
(global-surround-mode 1)

(global-set-key (kbd "s-h") 'windmove-left)
(global-set-key (kbd "s-l") 'windmove-right)
(global-set-key (kbd "s-j") 'windmove-down)
(global-set-key (kbd "s-k") 'windmove-up)

(require 'key-chord)
(key-chord-mode 1)
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
(global-set-key "\M-r" 'comint-resend-last-input)

(defun comint-native-completion ()
  (interactive)
  (setq current-command (buffer-substring-no-properties (process-mark (get-buffer-process (current-buffer))) (point-max)))
  ;(setq current-command (current-line-string))
  (comint-simple-send (get-buffer-process (current-buffer)) (concat current-command "\t"))
  )

(evil-define-key 'insert shell-mode-map (kbd "<up>") 'comint-previous-input)
(evil-define-key 'insert shell-mode-map (kbd "<down>") 'comint-next-input)
;; (evil-define-key 'insert shell-mode-map (kbd "<tab>") 'comint-native-completion)
))


(evil-define-key 'normal global-map
  (kbd ", s") 'rspec-verify-single
  (kbd ", v") 'rspec-verify
  (kbd ", t") 'rspec-toggle-spec-and-target
  (kbd ", f") 'ido-find-file
  (kbd ", c") 'magit-status)

(provide 'evil-bindings)

