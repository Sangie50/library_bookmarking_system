class DropTutorUsernameFromStudents < ActiveRecord::Migration[6.0]
  def change
    remove_column :students, :tutor_username, :string
  end
end
