(unless (file-exists-p "~/.emacs.d/el-get")
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (goto-char (point-max))
     (eval-print-last-sexp))))

(require 'package)
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)

(setq el-get-sources
      '(
        (:name flymake-haml
               :type elpa
               :post-init (progn (add-hook 'haml-mode-hook 'flymake-haml-load)))
        (:name thingatpt+
               :type emacswiki
               :load "thingatpt+.el"
               :feature "thingatpt")
        (:name ack-and-a-half
               :type github
               :pkgname "jhelwig/ack-and-a-half"
               :post-init (progn
                            (defalias 'ack 'ack-and-a-half)
                            (defalias 'ack-same 'ack-and-a-half-same)
                            (defalias 'ack-find-file 'ack-and-a-half-find-file)
                            (defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)))
        (:name haml-mode
               :type github
	       :pkgname "dgutov/haml-mode"
               :load "haml-mode.el"
               :feature haml-mode
               :post-init (progn
			    (require 'ruby-mode)
                            (add-hook 'haml-mode-hook 'flyspell-mode-off)
                            (add-hook 'haml-mode-hook 'delete-trailing-whitespace-on-file-write)))
        ;; (:name pry
        ;;        :type github
        ;;        :pkgname "jacott/emacs-pry"
        ;;        :post-init (progn (require 'pry)))
        (:name wgrep
               :type github
               :pkgname "mhayashi1120/Emacs-wgrep"
               :branch "BR-ack-support")
        (:name projectile
               :type github
               :pkgname "bbatsov/projectile" 
               :feature "projectile"
               :checkout "c5436c8260"
               )
	(:name magit
	       :website "https://github.com/magit/magit#readme"
	       :description "It's Magit! An Emacs mode for Git."
	       :type github
	       :pkgname "magit/magit"
	       :checkout "5ed79cb120"
	       :info "."
	       :autoloads ("50magit")
	       :build (("make" "all"))
	       :build/darwin `(,(concat "make EMACS=" el-get-emacs " all")))
	(:name ruby-mode
	       :type elpa)
	(:name Enhanced-Ruby-Mode
	       :description "Replacement for ruby-mode which uses ruby 1.9's Ripper to parse and indent"
	       :type github
	       :pkgname "jacott/Enhanced-Ruby-Mode"
	       :features ruby-mode
	       :post-init (progn (load-library "ruby-mode")))
        ))

(el-get 'sync (append '(helm
			color-theme-solarized
			auto-complete
			expand-region
			yasnippet
			idle-highlight-mode
			ace-jump-mode
			rainbow-delimiters
			evil
			evil-surround
			rhtml-mode
			zenburn
			bundler
			yaml-mode
			rspec-mode
			key-chord
			inf-ruby
			smex
			ido-ubiquitous
			rainbow-mode
			rvm
			rinari)
		      (mapcar 'el-get-source-name el-get-sources)))

(provide 'inits/packages)
