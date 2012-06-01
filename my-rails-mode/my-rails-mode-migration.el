
(defcustom my-rails-mode:migration-keywords 
'("create_table" "change_table" "drop_table" "rename_table" "add_column" "rename_column" "change_column" "change_column_default" "remove_column" "add_index" "remove_index" "rename_index" "execute")
"List of keywords to highlight for migrations"
:group 'my-rails-mode
:type '(repeat string))


(add-hook 'ruby-mode-hook '(lambda ()
                             (when (my-rails-mode:under-p "db/migrate/")
                               (my-rails-mode:highlight-keywords my-rails-mode:migration-keywords))))



(provide 'my-rails-mode-migration)
