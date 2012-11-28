;; Zooming
(defun my-zoom (n)
"Increase or decrease font size based upon argument"
(set-face-attribute 'default (selected-frame) :height
(+ (face-attribute 'default :height) (* (if (> n 0) 1 -1) 10))))
(global-set-key (kbd "C-+")      '(lambda nil (interactive) (my-zoom 1)))
(global-set-key [C-kp-add]       '(lambda nil (interactive) (my-zoom 1)))
(global-set-key (kbd "C-_")      '(lambda nil (interactive) (my-zoom -1)))
(global-set-key [C-kp-subtract]  '(lambda nil (interactive) (my-zoom -1)))
(message "All done!")

;; Switching windows easily
(global-set-key [s-left] 'windmove-left) 
(global-set-key [s-right] 'windmove-right) 
(global-set-key [s-up] 'windmove-up) 
(global-set-key [s-down] 'windmove-down)
;;(global-set-key [s-r] 'query-replace)

;; init magit-status
(global-set-key (kbd "C-c C-g") 'magit-status)

;; rgrep power !
(global-set-key (kbd "s-g") 'rgrep)

;; Goto line
(global-set-key (kbd "s-l") 'goto-line)

;; jump !!
(global-set-key (kbd "s-j") 'ace-jump-mode)

;; easily remove buffer
(global-set-key (kbd "s-k") (kbd "C-x k RET"))

;; Cut
(global-set-key (kbd "s-x") (kbd "C-w"))

(defun insert-antidash ()
  "Insert a Euro currency symbol in utf-8."
  (interactive)
  (ucs-insert #x5c))
(global-set-key (kbd "M-º") 'insert-antidash)

(defun insert-pipe ()
  "Insert a Euro currency symbol in utf-8."
  (interactive)
  (ucs-insert #x7c))
(global-set-key (kbd "M-1") 'insert-pipe)

(defun insert-at ()
  "Insert an at symbol in utf-8."
  (interactive)
  (ucs-insert #x40))
(global-set-key (kbd "M-2") 'insert-at)

(defun insert-pound ()
  "Insert an at symbol in utf-8."
  (interactive)
  (ucs-insert #x23))
(global-set-key (kbd "M-3") 'insert-pound)

(defun insert-euro ()
  "Insert a Euro currency symbol in utf-8."
  (interactive)
  (ucs-insert #x20ac))
(global-set-key (kbd "M-e") 'insert-euro)

(defun insert-right_curly ()
  "Insert a Euro currency symbol in utf-8."
  (interactive)
  (ucs-insert #x7d))
(global-set-key (kbd "M-ç") 'insert-right_curly)

(defun insert-left_square ()
  "Insert a Euro currency symbol in utf-8."
  (interactive)
  (ucs-insert #x5b))
(global-set-key (kbd "M-`") 'insert-left_square)

(defun insert-right_square ()
  "Insert a Euro currency symbol in utf-8."
  (interactive)
  (ucs-insert #x5d))
(global-set-key (kbd "M-+") 'insert-right_square)


(defun current-buffer-name ()
  "Retrieve current buffer name"
  (interactive)
  (concat default-directory (buffer-name)))
(global-set-key (kbd "C-n") 'current-buffer-name)
(evil-define-key 'normal global-map (kbd ", n") 'current-buffer-name)

(evil-define-key 'normal global-map (kbd ", c") 'quickrun)
(evil-define-key 'normal global-map (kbd ", w") 'make-frame-command)
(evil-define-key 'normal global-map (kbd ", g") 'magit-status)
(evil-define-key 'normal global-map (kbd ", r") 'rspec-verify)
(evil-define-key 'normal global-map (kbd ", t") 'rspec-verify-single)
(evil-define-key 'normal global-map (kbd ", s") 'mrm/ack-project)
(evil-define-key 'normal global-map (kbd ", o") 'helm-occur)

