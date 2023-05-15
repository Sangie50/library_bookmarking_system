class AddProgrammeCodeToLsps < ActiveRecord::Migration[6.0]
  def change
    add_column :lsps, :programme_code, :text
  end
end
