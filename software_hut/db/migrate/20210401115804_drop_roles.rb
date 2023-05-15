class DropRoles < ActiveRecord::Migration[6.0]
  def change
    drop_table :roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
