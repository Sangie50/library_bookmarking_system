class ChangeModuleIdTypeOnAcademicsModules < ActiveRecord::Migration[6.0]
  def change
    remove_column :academics_courses, :module_id, :string
    add_column :academics_courses, :module_id, :bigint
  end
end
