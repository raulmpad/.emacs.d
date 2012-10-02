(defun mrm/rake-tmp-file ()
  (concat (mrm/root) "tmp/rake-output"))

(defun mrm/rake-tasks ()
  "Returns a content of tmp file with rake tasks."
  (if (file-exists-p (mrm/rake-tmp-file))
      (with-temp-buffer
        (insert-file-contents (mrm/rake-tmp-file))
        (buffer-string))
    (and (mrm/regenerate-rake) (mrm/rake-tasks))))

;; Shamelessly stolen from ruby-starter-kit.el:
;; https://github.com/technomancy/emacs-starter-kit/blob/v2/modules/starter-kit-ruby.el
(defun mrm/pcmpl-rake-tasks ()
  "Return a list of all the rake tasks defined in the current
projects."
  (delq nil (mapcar '(lambda(line)
                       (if (string-match "rake \\([^ ]+\\)" line) (match-string 1 line)))
                    (split-string (mrm/rake-tasks) "[\n]"))))

(defun mrm/regenerate-rake ()
  "Generates rakes tasks file in the tmp
within rails root directory."
  (interactive)
  (if (file-exists-p (mrm/rake-tmp-file)) (delete-file (mrm/rake-tmp-file)))
  (with-temp-file (mrm/rake-tmp-file) (insert (shell-command-to-string (mrm/bundle-or-zeus-command) "rake -T"))))


(defun mrm/rake (task)
  (interactive (list (completing-read "Rake (default: default): "
                                      (mrm/pcmpl-rake-tasks))))
  (let ((default-directory (mrm/root)))
        (async-shell-command (concat (mrm/bundle-or-zeus-command) "rake " (if (= 0 (length task)) "default" task)))))

(provide 'my-rails-mode-rake)
