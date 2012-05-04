
(defcustom my-rails-mode:controller-keywords 
'("logger" "url_for" "polymorphic_path" "polymorphic_url" "mail" "render" "attachments" "default" "helper" "helper_attr" "helper_method")
"List of keywords to highlight for controllers"
:group 'my-rails-mode
:type '(repeat string))


(add-hook 'ruby-mode-hook '(lambda ()
                             (when (my-rails-mode:is-under "app/controllers")
                               (my-rails-mode:highlight-keywords my-rails-mode:controller-keywords))))



(provide 'my-rails-mode-controller)
