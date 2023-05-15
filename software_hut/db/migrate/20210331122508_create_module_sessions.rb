class CreateModuleSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :module_sessions do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
