
(defcustom mrm/model-keywords 
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
                             (when (mrm/under-p "app/models/")
                               (mrm/highlight-keywords mrm/model-keywords))))

(defun mrm/helm-c-projectile-models-files-list ()
  "Generates a list of files in the current project"
  (projectile-get-project-files
   (concat (mrm/root) "app/models/" )))

(defvar mrm/helm-c-source-projectile-models-files-list
  `((name . "Projectile files list")
    ;; Needed for filenames with capitals letters.
    (disable-shortcuts)
    (candidates . mrm/helm-c-projectile-models-files-list)
    (candidate-number-limit . 15)
    (volatile)
    (keymap . ,helm-generic-files-map)
    (help-message . helm-generic-file-help-message)
    (mode-line . helm-generic-file-mode-line-string)
    (match helm-c-match-on-basename)
    (type . file))
  "Helm source definition")

;;;###autoload
(defun mrm/helm-projectile-models ()
  "Search using helm for models"
  (interactive)
  (helm-other-buffer '(mrm/helm-c-source-projectile-models-files-list
                       mrm/helm-c-source-projectile-buffers-list)
                     (format "*My Rails Mode %s*" "models" )))

(provide 'my-rails-mode-model)
