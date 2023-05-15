class CreateDlos < ActiveRecord::Migration[6.0]
  def change
    create_table :dlos, id: false, primary_key: :username do |t|
      t.string :username
      t.string :department_code

      t.timestamps
    end
  end
end
