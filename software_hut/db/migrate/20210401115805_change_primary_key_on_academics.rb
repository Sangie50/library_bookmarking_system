class ChangePrimaryKeyOnAcademics < ActiveRecord::Migration[6.0]
  def up
    execute "ALTER TABLE academics DROP CONSTRAINT academics_pkey"
    execute "ALTER TABLE academics ADD CONSTRAINT academics_pkey PRIMARY KEY (username)"
    remove_column :academics, :id
  end

  def down
    execute "ALTER TABLE academics DROP CONSTRAINT academics_pkey"
    add_column :academics, :id, :primary_key
  end
end
