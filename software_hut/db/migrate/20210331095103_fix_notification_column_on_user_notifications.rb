class FixNotificationColumnOnUserNotifications < ActiveRecord::Migration[6.0]
  def change
    rename_column :user_notifications, :notifcation_id, :notification_id
  end
end
