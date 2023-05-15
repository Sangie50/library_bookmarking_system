class AddStudentNameToLsps < ActiveRecord::Migration[6.0]
  def change
    add_column :lsps, :student_name, :string
  end
end
