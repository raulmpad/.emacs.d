; This should be on a custom rails.el file
(autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby process" t)
(autoload 'inf-ruby-setup-keybindings "inf-ruby" "" t)
(eval-after-load 'ruby-mode
  '(add-hook 'ruby-mode-hook 'inf-ruby-setup-keybindings))

;; Change cursor color according to mode; inspired by
;; http://www.emacswiki.org/emacs/ChangingCursorDynamically
;; (setq djcb-read-only-color       "gray")
;; valid values are t, nil, box, hollow, bar, (bar . WIDTH), hbar,
;; (hbar. HEIGHT); see the docs for set-cursor-type

;; (setq djcb-read-only-cursor-type 'hbar)
;; (setq djcb-overwrite-color       "red")
;; (setq djcb-overwrite-cursor-type 'box)
;; (setq djcb-normal-color          "yellow")
;; (setq djcb-normal-cursor-type    'bar)

;; (defun djcb-set-cursor-according-to-mode ()
;;   "change cursor color and type according to some minor modes."

;;   (cond
;;     (buffer-read-only
;;       (set-cursor-color djcb-read-only-color)
;;       (setq cursor-type djcb-read-only-cursor-type))
;;     (overwrite-mode
;;       (set-cursor-color djcb-overwrite-color)
;;       (setq cursor-type djcb-overwrite-cursor-type))
;;     (t 
;;       (set-cursor-color djcb-normal-color)
;;       (setq cursor-type djcb-normal-cursor-type))))

;; (add-hook 'post-command-hook 'djcb-set-cursor-according-to-mode)

(add-hook 'ruby-mode-hook (lambda () (ruby-block-mode t) (wrap-region-mode t) (linum-mode t)))

;; magit colors
;; change magit diff colors
(eval-after-load 'magit
  '(progn
     (set-face-foreground 'magit-diff-add "green3")
     (set-face-foreground 'magit-diff-del "red3")
     (when (not window-system)
       (set-face-background 'magit-item-highlight "black"))))

(load-theme 'misterioso)

;; (set-cursor-color "yellow")

(require 'evil)  
(evil-mode 1)

(require 'surround)
(global-surround-mode 1)

(setq evil-default-cursor (quote (t "yellow")))

(add-to-list 'load-path "~/.emacs.d/inits/")
(require 'helm-rails)

(require 'haml-mode)
(add-hook 'haml-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (define-key haml-mode-map "\C-m" 'newline-and-indent)))

(add-to-list 'auto-mode-alist '("\\.sass\\'" . sass-mode))
; add this line after the auto-complete mode has been loaded
(add-to-list 'ac-modes 'sass-mode)

;; TODO: Make it work
;; (defun quickrun_ruby ()
;;   "Quickrun ruby current buffer."
;;   (interactive)
;;   (ruby-mode t)
;;   (flet ((quickrun/command-key (arg) "ruby" ))
;;     (quickrun/common (point-min) (point-max))))

;; (define-key ruby-mode-map (kbd "C-c C-r") 'quickrun_ruby)

;; Thanks to "rtags `find . -name '*.rb'`"
(defun asok/find-tag-dwim ()
  (interactive)
  (let ((thing (thing-at-point 'symbol)))
    (condition-case nil
	(pop-to-buffer (find-tag-noselect thing))
      ('error (find-tag thing)))))
(evil-define-key 'normal global-map (kbd ", m") 'asok/find-tag-dwim)

;; Diferent alignments from: http://danconnor.com/post/5028ac91e8891a000000111f/align_and_columnize_key_value_data_in_emacs
(defun align-hash (beg end)
  (interactive "r")
  (align-regexp beg end "\\(\\s-*\\)\=\>\\(\\s-*\\)" 1 1 t))
(defun align-colons (beg end)
  (interactive "r")
  (align-regexp beg end ":\\(\\s-*\\)" 1 1 t))

(defun asok/bounds-of-ruby-word-at-point ()
  (save-excursion
    (skip-syntax-backward "w_")
    (if (looking-at "[:a-zA-Z0-9_]+")
	(cons (+ 1 (point)) (match-end 0)) ; bounds of integer
      nil)))

(put 'ruby-word 'bounds-of-thing-at-point 'asok/bounds-of-ruby-word-at-point)

(evil-define-motion asok/evil-search-ruby-word-forward (count)
  "Search forward for ruby word under point."
  :jump t
  :type exclusive
  (dotimes (var (or count 1))
    (setq isearch-forward t)
    (evil-search (thing-at-point 'ruby-word) t evil-regexp-search)))

(evil-define-key 'motion ruby-mode-map (kbd "*") 'asok/evil-search-ruby-word-forward)

(add-to-list 'load-path "~/.emacs.d/raul/emacs-calfw")
(require 'calfw)
