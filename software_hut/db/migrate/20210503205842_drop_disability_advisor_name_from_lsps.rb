class DropDisabilityAdvisorNameFromLsps < ActiveRecord::Migration[6.0]
  def change
    remove_column :lsps, :disability_advisor_name, :text
  end
end
