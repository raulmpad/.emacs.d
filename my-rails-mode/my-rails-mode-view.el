(defcustom mrm/view-keywords 
  '("action_name" "atom_feed" "audio_path" "audio_tag" "auto_discovery_link_tag"
    "button_tag" "button_to" "button_to_function"
    "cache" "capture" "cdata_section" "check_box" "check_box_tag" "collection_select" "concat" "content_for" "content_tag" "content_tag_for" "controller" "controller_name" "controller_path" "convert_to_model" "cookies" "csrf_meta_tag" "csrf_meta_tags" "current_cycle" "cycle"
    "date_select" "datetime_select" "debug" "distance_of_time_in_words" "distance_of_time_in_words_to_now" "div_for" "dom_class" "dom_id"
    "email_field" "email_field_tag" "escape_javascript" "escape_once" "excerpt"
    "favicon_link_tag" "field_set_tag" "fields_for" "file_field" "file_field_tag" "flash" "form_for" "form_tag"
    "grouped_collection_select" "grouped_options_for_select"
    "headers" "hidden_field" "hidden_field_tag" "highlight"
    "image_alt" "image_path" "image_submit_tag" "image_tag"
    "j" "javascript_cdata_section" "javascript_include_tag" "javascript_path" "javascript_tag"
    "l" "label" "label_tag" "link_to" "link_to_function" "link_to_if" "link_to_unless" "link_to_unless_current" "localize" "logger"
    "mail_to"
    "number_field" "number_field_tag" "number_to_currency" "number_to_human" "number_to_human_size" "number_to_percentage" "number_to_phone" "number_with_delimiter" "number_with_precision"
    "option_groups_from_collection_for_select" "options_for_select" "options_from_collection_for_select" ""
    "params" "password_field" "password_field_tag" "path_to_audio" "path_to_image" "path_to_javascript" "path_to_stylesheet" "path_to_video" "phone_field" "phone_field_tag" "pluralize" "provide"
    "radio_button" "radio_button_tag" "range_field" "range_field_tag" "raw" "render" "request" "request_forgery_protection_token" "reset_cycle" "response"
    "safe_concat" "safe_join" "sanitize" "sanitize_css" "search_field" "search_field_tag" "select" "select_date" "select_datetime" "select_day" "select_hour" "select_minute" "select_month" "select_second" "select_tag" "select_time" "select_year" "session" "simple_format" "strip_links" "strip_tags" "stylesheet_link_tag" "stylesheet_path" "submit_tag"
    "t" "tag" "telephone_field" "telephone_field_tag" "text_area" "text_area_tag" "text_field" "text_field_tag" "time_ago_in_words" "time_select" "time_tag" "time_zone_options_for_select" "time_zone_select" "translate" "truncate"
    "url_field" "url_field_tag" "url_for" "url_options"
    "video_path" "video_tag"
    "word_wrap"
    )
  "List of keywords to highlight for views"
  :group 'my-rails-mode
  :type '(repeat string))


;; (add-hook 'rhtml-mode-hook '(lambda ()
;;                               (when (mrm/under-p "app/views/")
;;                                 (font-lock-add-keywords nil
;;                                                         ;; '((regexp-opt mrm/view-keywords 'words) . font-lock-keyword-face)
;;                                                         ;; '(((regexp mrm/view-keywords 'words) . font-lock-keyword-face))
;;                                                         '(
;;                                                           ("link_")
;;                                                           )
;;                                                         ))))
                                        ;TODO make it more efficient

(defun mrm/find-partial-or-template (word)
  (let ((word (replace-regexp-in-string "['\"]" "" (replace-regexp-in-string "^/" "" word)))
        (path (concat (mrm/root) "app/views/"))
        (cur-format (mrm/substring-of-regexp "\.\\(js\\|html\\|text\\|csv\\|pdf\\)\." buffer-file-name)))
    (loop for file in  (list (concat path word) ; users/user.html.erb -> user.html.erb
                             (concat path word "." cur-format ".erb") ; users/user -> .../user.html.erb
                             (concat path word "." cur-format ".haml") ; users/user -> .../user.html.haml
                             (concat default-directory "_" word) ; user.html.erb -> .../_user.html.erb
                             (concat default-directory "_" word "." cur-format ".erb") ; user -> ./_user.html.erb
                             (concat default-directory "_" word "." cur-format ".haml") ; user -> ./_user.html.haml
                             (concat default-directory word "." cur-format ".erb") ; user -> ./user.html.erb
                             (concat default-directory word "." cur-format ".haml") ; user -> ./user.html.erb
                             (concat path (mrm/insert-string "/.*$" word "_")) ; users/_user.html.erb
                             (concat path (mrm/insert-string "/.*$" word "_") "." cur-format ".erb") ; users/user -> users/_user.html.erb
                             (concat path (mrm/insert-string "/.*$" word "_") "." cur-format ".haml") ; users/user -> users/_user.html.haml
                             (concat path (mrm/insert-string "/.*$" word "_") ".erb") ; users/user.html -> users/_user.html.erb
                             (concat path (mrm/insert-string "/.*$" word "_") ".haml")) ; users/user.html -> users/_user.html.haml
          do (if (file-exists-p file) (return (find-file file))))))

(provide 'my-rails-mode-view)
