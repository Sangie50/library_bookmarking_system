class AddJoinTableCourseModulesStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :course_modules_students do |t|
      t.integer :student_id
      t.string :module_code

      t.index [:student_id, :module_code]
      t.index [:module_code, :student_id]
    end
  end
end
