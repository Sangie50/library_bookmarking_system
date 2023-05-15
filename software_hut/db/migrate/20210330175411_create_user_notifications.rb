class CreateUserNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :user_notifications do |t|
      t.string :username
      t.bigint :notifcation_id
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
