
(defcustom my-rails-mode:model-keywords 
 '("default_scope" "named_scope" "scope" "serialize"
 "belongs_to" "has_one" "has_many" "has_and_belongs_to_many" "composed_of" "accepts_nested_attributes_for"
"before_create" "before_destroy" "before_save" "before_update" "before_validation" "before_validation_on_create" "before_validation_on_update"
"after_create" "after_destroy" "after_save" "after_update" "after_validation" "after_validation_on_create" "after_validation_on_update"
"around_create" "around_destroy" "around_save" "around_update"
"after_commit" "after_find" "after_initialize" "after_rollback" "after_touch"
"attr_accessible" "attr_protected" "attr_readonly"
"validate" "validates" "validate_on_create" "validate_on_update" "validates_acceptance_of" "validates_associated" "validates_confirmation_of" "validates_each" "validates_exclusion_of" "validates_format_of" "validates_inclusion_of" "validates_length_of" "validates_numericality_of" "validates_presence_of" "validates_size_of" "validates_uniqueness_of" "validates_with")
"List of keywords to highlight for models"
:group 'my-rails-mode
:type '(repeat string))

(add-hook 'ruby-mode-hook '(lambda ()
                             (when (my-rails-mode:under-p "app/models")
                               (my-rails-mode:highlight-keywords my-rails-mode:model-keywords))))

(provide 'my-rails-mode-model)
