
(defcustom my-rails-mode:controller-keywords 
  '("logger" "polymorphic_path" "polymorphic_url" "mail" "render" "attachments" "default" "helper" "helper_attr" "helper_method"
    "filter" "layout" "url_for" "serialize" "exempt_from_layout" "filter_parameter_logging" "hide_action" "cache_sweeper" "protect_from_forgery" "caches_page" "cache_page" "caches_action" "expire_page" "expire_action" "rescue_from"
"params" "request" "response" "session" "flash" "head" "redirect_to" "render_to_string" "respond_with" "before_filter" "append_before_filter" "prepend_before_filter" "after_filter" "append_after_filter" "prepend_after_filter" "around_filter" "append_around_filter" "prepend_around_filter" "skip_before_filter" "skip_after_filter" "skip_filter")
"List of keywords to highlight for controllers"
:group 'my-rails-mode
:type '(repeat string))


(add-hook 'ruby-mode-hook '(lambda ()
                             (when (my-rails-mode:under-p "app/controllers")
                               (my-rails-mode:highlight-keywords my-rails-mode:controller-keywords))))



(provide 'my-rails-mode-controller)
