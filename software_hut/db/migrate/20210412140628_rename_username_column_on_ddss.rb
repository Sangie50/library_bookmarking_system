class RenameUsernameColumnOnDdss < ActiveRecord::Migration[6.0]
  def change
    rename_column :ddss_staff_members, :username, :email
  end
end
