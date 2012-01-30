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
  (cond ((not (comint-after-pmark-p))
         (comint-goto-process-mark)
         (evil-append-line nil))))
;TODO
(defun comint-resend-last-input ()
  (interactive)
  (comint-goto-end-and-insert)
  (comint-previous-input)
  (comint-send-input))

(evil-define-key 'normal term-raw-map "i" 'go-to-end-and-insert)

(evil-define-key 'normal comint-mode-map "i" 'comint-goto-end-and-insert)
(evil-define-key 'normal comint-mode-map "\M-l" 'comint-resend-last-input)


(evil-define-key 'insert shell-mode-map (kbd "<up>") 'comint-previous-input)
(evil-define-key 'insert shell-mode-map (kbd "<down>") 'comint-next-input)

))


(provide 'evil-bindings)

