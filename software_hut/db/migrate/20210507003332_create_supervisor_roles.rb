class CreateSupervisorRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :supervisor_roles, id: false, primary_key: :code do |t|
      t.string :code
      t.string :name
    end
  end
end
