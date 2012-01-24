(push "/usr/local/bin" exec-path)
(push "/opt/local/bin" exec-path)

(fset 'yes-or-no-p 'y-or-n-p)
(set-frame-font "Menlo-14")
(setq ring-bell-function 'ignore)

(setq make-backup-files nil)
(setq auto-save-default nil)

(add-to-list 'load-path "~/.emacs.d/asok/evil")
(require 'evil)
(evil-mode 1)

(add-to-list 'load-path "~/.emacs.d/asok/evil-surround")
(require 'surround)
(global-surround-mode 1)

(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)

(add-to-list 'load-path "~/.emacs.d/asok/rspec-mode")
(require 'rspec-mode)
(define-key rspec-mode-verifible-keymap (kbd "s") 'rspec-verify-single)

;; Original idea from
;; http://www.opensubscriber.com/message/emacs-devel@gnu.org/10971693.html
(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (not (region-active-p))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key (kbd "M-;") 'comment-dwim-line)

(require 'term)
(defun visit-ansi-term ()
  "If the current buffer is:
     1) a running ansi-term named *ansi-term*, rename it.
     2) a stopped ansi-term, kill it and create a new one.
     3) a non ansi-term, go to an already running ansi-term
        or start a new one while killing a defunt one"
  (interactive)
  (let ((is-term (string= "term-mode" major-mode))
        (is-running (term-check-proc (buffer-name)))
        (term-cmd "/bin/bash")
        (anon-term (get-buffer "*ansi-term*")))
    (if is-term
        (if is-running
            (if (string= "*ansi-term*" (buffer-name))
                (call-interactively 'rename-buffer)
              (if anon-term
                  (switch-to-buffer "*ansi-term*")
                (ansi-term term-cmd)))
          (kill-buffer (buffer-name))
          (ansi-term term-cmd))
      (if anon-term
          (if (term-check-proc "*ansi-term*")
              (switch-to-buffer "*ansi-term*")
            (kill-buffer "*ansi-term*")
            (ansi-term term-cmd))
        (ansi-term term-cmd))))
  (evil-mode nil))
;; use shell instead of ansi-term
(global-set-key (kbd "<f2>") 'shell)

(autoload 'vkill "vkill" nil t)
(autoload 'list-unix-processes "vkill" nil t)
(defun open-vkill-and-update ()
  (interactive)
  (vkill)
  (vkill-update-process-info))
(global-set-key (kbd "<f3>") 'open-vkill-and-update)

(add-hook 'vkill-after-send-signal-hook '(lambda ()
                                           (setq line (line-number-at-pos))
                                           (goto-char (point-min)) (forward-line line )
                                           (vkill-update-process-info)))

(call-process "/bin/sh" nil t nil "-c" "~/.emacs.d/asok/umount-ram.sh ~/.emacs.d/tmp")

(call-process "/bin/sh" nil t nil "-c" "~/.emacs.d/asok/mount-ram.sh ~/.emacs.d/tmp 30")
(setq temporary-file-directory "~/.emacs.d/tmp")

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(menu-bar-mode 1)

(global-set-key (kbd "s-x") 'smex)
(global-set-key (kbd "s-g") 'abort-recursive-edit)
