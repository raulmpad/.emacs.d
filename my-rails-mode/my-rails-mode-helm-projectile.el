(require 'projectile)
(require 'helm-config)
(require 'helm-locate)
(require 'helm-buffers)

(defvar mrm/helm-c-source-projectile-buffers-list
  `((name . "Projectile buffers list")
    ;; Needed for filenames with capitals letters.
    (candidates . projectile-get-project-buffer-names)
    (volatile)
    (keymap . ,helm-c-buffer-map)
    (mode-line . helm-buffer-mode-line-string)
    (match helm-c-buffer-match-major-mode)
    (type . buffer)
    (persistent-help
     . "Show this buffer / C-u \\[helm-execute-persistent-action]: Kill this buffer"))
  "Helm source definition")

(provide 'my-rails-mode-helm-projectile)
