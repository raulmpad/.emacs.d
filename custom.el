(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ack-and-a-half-arguments nil)
 '(ack-and-a-half-mode-extension-alist nil)
 '(ansi-color-names-vector ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(color-theme-directory (quote ("~/.emacs.d/themes/emacs-color-theme-solarized")))
 '(comint-process-echoes t)
 '(custom-enabled-themes nil)
 '(custom-safe-themes (quote ("fab5515afc0931312520b243796956ed65498af486c0da01cfd5dd196e9ebc4c" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(custom-theme-load-path (quote ("/Users/raul/.emacs.d/el-get/" "/Users/raul/.emacs.d/el-get/color-theme-solarized/" "/Users/raul/.emacs.d/themes/" "/Users/raul/.emacs.d/themes/tomorrow-theme" "/Users/raul/.emacs.d/themes/base16-emacs" custom-theme-directory t)))
 '(dabbrev-abbrev-skip-leading-regexp ":")
 '(dabbrev-case-distinction nil)
 '(dabbrev-case-fold-search nil)
 '(evil-complete-next-func (lambda (arg) (if (ac-menu) (ac-next) (ac-start))))
 '(evil-complete-previous-func (lambda (arg) (if (popup-hidden-p ac-menu) (ac-start) (ac-previous))))
 '(evil-default-cursor (quote (t "white")))
 '(evil-emacs-state-modes (quote (archive-mode bbdb-mode bookmark-bmenu-mode bookmark-edit-annotation-mode browse-kill-ring-mode bzr-annotate-mode calc-mode cfw:calendar-mode completion-list-mode debugger-mode delicious-search-mode desktop-menu-blist-mode desktop-menu-mode doc-view-mode dvc-bookmarks-mode dvc-diff-mode dvc-info-buffer-mode dvc-log-buffer-mode dvc-revlist-mode dvc-revlog-mode dvc-status-mode dvc-tips-mode ediff-mode efs-mode Electric-buffer-menu-mode emms-browser-mode emms-mark-mode emms-metaplaylist-mode emms-playlist-mode etags-select-mode fj-mode gc-issues-mode gdb-breakpoints-mode gdb-disassembly-mode gdb-frames-mode gdb-locals-mode gdb-memory-mode gdb-registers-mode gdb-threads-mode gist-list-mode gnus-article-mode gnus-browse-mode gnus-group-mode gnus-server-mode gnus-summary-mode google-maps-static-mode ibuffer-mode jde-javadoc-checker-report-mode magit-commit-mode magit-diff-mode magit-key-mode magit-log-mode magit-reflog-mode magit-show-branches-mode magit-stash-mode magit-status-mode magit-wazzup-mode mh-folder-mode monky-mode notmuch-hello-mode notmuch-search-mode notmuch-show-mode occur-mode org-agenda-mode package-menu-mode proced-mode rcirc-mode rebase-mode recentf-dialog-mode reftex-select-bib-mode reftex-toc-mode sldb-mode slime-inspector-mode slime-thread-control-mode slime-xref-mode sr-buttons-mode sr-mode sr-tree-mode sr-virtual-mode tar-mode tetris-mode tla-annotate-mode tla-archive-list-mode tla-bconfig-mode tla-bookmarks-mode tla-branch-list-mode tla-browse-mode tla-category-list-mode tla-changelog-mode tla-follow-symlinks-mode tla-inventory-file-mode tla-inventory-mode tla-lint-mode tla-logs-mode tla-revision-list-mode tla-revlog-mode tla-tree-lint-mode tla-version-list-mode twittering-mode urlview-mode vc-annotate-mode vc-dir-mode vc-git-log-view-mode vc-svn-log-view-mode vm-mode vm-summary-mode w3m-mode wab-compilation-mode xgit-annotate-mode xgit-changelog-mode xgit-diff-mode xgit-revlog-mode xhg-annotate-mode xhg-log-mode xhg-mode xhg-mq-mode xhg-mq-sub-mode xhg-status-extra-mode)))
 '(evil-flash-delay 5)
 '(evil-motion-state-modes (quote (apropos-mode Buffer-menu-mode calendar-mode command-history-mode compilation-mode dictionary-mode help-mode Info-mode speedbar-mode undo-tree-visualizer-mode view-mode magit-mode)))
 '(helm-buffer-max-length 50)
 '(idle-highlight-exceptions (quote ("end" "def" "class" "module" "require" "require_relative" "if" "unless")))
 '(projectile-enable-caching t)
 '(rails-rake-use-bundler-when-possible t)
 '(recentf-max-saved-items 40)
 '(rspec-spec-command "rspec")
 '(rspec-use-bundler-when-possible nil)
 '(rspec-use-opts-file-when-available t)
 '(rspec-use-rake-flag nil)
 '(rspec-use-rvm t)
 '(rspec-use-zeus-when-possible t)
 '(ruby-check-syntax (quote errors-and-warnings))
 '(ruby-extra-keywords (quote ("include" "extend" "require" "require_relative")))
 '(safe-local-variable-values (quote ((Coding . utf-8) (ruby-compilation-executable . "ruby") (ruby-compilation-executable . "ruby1.8") (ruby-compilation-executable . "ruby1.9") (ruby-compilation-executable . "rbx") (ruby-compilation-executable . "jruby"))))
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 50) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t) (left-fringe . 0))))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(erm-syn-errline ((t (:underline "Red"))))
 '(erm-syn-warnline ((t (:underline "Orange"))))
 '(helm-selection ((t (:underline t))))
 '(ruby-op-face ((t (:foreground "Magenta" :weight bold))))
 '(yas/field-highlight-face ((t (:inherit (quote highlight)))) t))


