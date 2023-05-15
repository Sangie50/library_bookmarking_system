class RenameSupervisorUsernameOnSupervisors < ActiveRecord::Migration[6.0]
  def change
    rename_column :supervisors, :supervisor_username, :username
  end
end
