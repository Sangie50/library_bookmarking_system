class ChangePrimaryKeyOnModuleSessions < ActiveRecord::Migration[6.0]
  def up
    execute "ALTER TABLE module_sessions DROP CONSTRAINT module_sessions_pkey"
    execute "ALTER TABLE module_sessions ADD CONSTRAINT module_sessions_pkey PRIMARY KEY (code)"
    remove_column :module_sessions, :id
  end

  def down
    execute "ALTER TABLE module_sessions DROP CONSTRAINT academics_pkey"
    add_column :module_sessions, :id, :primary_key
  end
end
