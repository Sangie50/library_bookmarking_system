class ChangeColumnsOnAcademicsCourses < ActiveRecord::Migration[6.0]
  def change
    remove_index :academics_courses, [:module_code, :username]
    remove_index :academics_courses, [:username, :module_code]
    rename_column :academics_courses, :module_code, :module_id
    add_index :academics_courses, [:module_id, :username]
    add_index :academics_courses, [:username, :module_id]
  end
end
