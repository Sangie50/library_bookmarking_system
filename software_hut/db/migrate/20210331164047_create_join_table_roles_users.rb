class CreateJoinTableRolesUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :roles_users do |t|
      t.string :username
      t.string :role_name

      t.index [:username, :role_name]
      t.index [:role_name, :username]
    end
  end
end
