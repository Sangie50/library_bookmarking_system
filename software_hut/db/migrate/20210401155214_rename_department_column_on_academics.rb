class RenameDepartmentColumnOnAcademics < ActiveRecord::Migration[6.0]
  def change
    rename_column :academics, :department, :department_code
  end
end
