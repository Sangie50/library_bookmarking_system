class RenameUsernameColumnOnLsp < ActiveRecord::Migration[6.0]
  def change
    rename_column :lsps, :advisor_username, :advisor_email
  end
end
