class CreateDepartments < ActiveRecord::Migration[6.0]
  def change
    create_table :departments, id: false, primary_key: :code do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
