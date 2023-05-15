class CreateDdssStaffMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :ddss_staff_members, id: false, primary_key: :username do |t|
      t.string :username

      t.timestamps
    end
  end
end
