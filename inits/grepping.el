(global-set-key (kbd "M-e") 'rgrep)

(defun ack-in-directory (pattern &optional regexp directory)
  "Run ack inside a directory"
  (interactive (ack-and-a-half-interactive))
  (ack-and-a-half-run (read-directory-name "directory to look in") regexp pattern))
(global-set-key (kbd "C-c e") 'ack-in-directory)

(provide 'inits/grepping)
