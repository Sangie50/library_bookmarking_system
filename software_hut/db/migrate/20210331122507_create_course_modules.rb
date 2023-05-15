class CreateCourseModules < ActiveRecord::Migration[6.0]
  def change
    create_table :course_modules do |t|
      t.integer :code
      t.string :name
      t.string :department_code
      t.string :session_code

      t.timestamps
    end
  end
end
