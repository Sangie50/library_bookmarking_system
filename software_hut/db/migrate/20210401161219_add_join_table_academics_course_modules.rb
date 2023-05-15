class AddJoinTableAcademicsCourseModules < ActiveRecord::Migration[6.0]
  def change
    create_table :academics_courses do |t|
      t.string :username
      t.string :module_code

      t.index [:username, :module_code]
      t.index [:module_code, :username]
    end
  end
end
