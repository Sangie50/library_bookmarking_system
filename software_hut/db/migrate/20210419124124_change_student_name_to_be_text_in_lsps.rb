class ChangeStudentNameToBeTextInLsps < ActiveRecord::Migration[6.0]
  def change
    change_column :lsps, :student_name, :text
  end
end
