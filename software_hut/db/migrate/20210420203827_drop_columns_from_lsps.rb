class DropColumnsFromLsps < ActiveRecord::Migration[6.0]
  def change
    remove_column :lsps, :programme_code, :text
    remove_column :lsps, :student_name, :text
  end
end
