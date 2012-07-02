(add-hook 'ruby-mode-hook 'mrm/end-mode)
end  
(defvar mrm/end-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "<return>") 'mrm/end-potential-indent-or-end)
    map)
  "Keymap for `my-rails-mode/end-mode`.")

(defun mrm/end-or-indent (arg)
  (interactive "P")
  (let (current-line)
    (setq current-line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
    (when (string-match-p "if[ ]+.*$" current-line )
        (ruby-indent-line))
    (self-insert-command arg)
  ))

(define-minor-mode mrm/end-mode
  "Electric mode inputing end and indending end"
  nil
  " mrmE"
  mrm/end-mode-map
  )

(provide 'my-rails-mode-end)
