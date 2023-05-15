class ChangeCourseModuleStudentsTable < ActiveRecord::Migration[6.0]
  def change
    remove_index :course_modules_students, [:module_code, :student_id]
    remove_index :course_modules_students, [:student_id, :module_code]
    remove_column :course_modules_students, :module_code, :integer
    add_column :course_modules_students, :module_id, :integer
    add_index :course_modules_students, [:module_id, :student_id]
    add_index :course_modules_students, [:student_id, :module_id]
  end
end
