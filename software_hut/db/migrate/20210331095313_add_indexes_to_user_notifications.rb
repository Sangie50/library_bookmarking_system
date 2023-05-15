class AddIndexesToUserNotifications < ActiveRecord::Migration[6.0]
  def change
    add_index :user_notifications, [:username, :notification_id], unique: true
    add_index :user_notifications, [:notification_id, :username], unique: true
  end
end
