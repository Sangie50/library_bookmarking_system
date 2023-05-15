class CreateSupervisors < ActiveRecord::Migration[6.0]
  def change
    create_table :supervisors do |t|
      t.string :supervisor_username
      t.integer :student_id
      t.string :role_code
    end
  end
end
