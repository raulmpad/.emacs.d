
(defcustom my-rails-model-mode:keywords 
 '("default_scope" "named_scope" "scope" "serialize"
 "belongs_to" "has_one" "has_many" "has_and_belongs_to_many" "composed_of" "accepts_nested_attributes_for"
"before_create" "before_destroy" "before_save" "before_update" "before_validation" "before_validation_on_create" "before_validation_on_update"
"after_create" "after_destroy" "after_save" "after_update" "after_validation" "after_validation_on_create" "after_validation_on_update"
"around_create" "around_destroy" "around_save" "around_update"
"after_commit" "after_find" "after_initialize" "after_rollback" "after_touch"
"attr_accessible" "attr_protected" "attr_readonly"
"validate" "validates" "validate_on_create" "validate_on_update" "validates_acceptance_of" "validates_associated" "validates_confirmation_of" "validates_each" "validates_exclusion_of" "validates_format_of" "validates_inclusion_of" "validates_length_of" "validates_numericality_of" "validates_presence_of" "validates_size_of" "validates_uniqueness_of" "validates_with")
"List of keywords to highlight"
:group 'my-rails-model-mode
:type '(repeat string))

(defun my-rails-model-mode:highlight-keywords ()
  (setq ruby-extra-keywords (append ruby-extra-keywords my-rails-model-mode:keywords ))
  (ruby-local-enable-extra-keywords))

(add-hook 'ruby-mode-hook '(lambda ()
                             (when (my-rails-mode:is-under "app/models")
                               (my-rails-model-mode:highlight-keywords))))

;;;###autoload
(define-minor-mode my-rails-model-mode
  "My minor mode for RubyOnRails models."
  :lighter " Model")



(provide 'my-rails-model-mode)
