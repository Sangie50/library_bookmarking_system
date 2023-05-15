class ChangeCodeColumnTypeOnModuleSessions < ActiveRecord::Migration[6.0]
  def change
    remove_column :module_sessions, :code, :integer
    add_column :module_sessions, :code, :string
  end
end
