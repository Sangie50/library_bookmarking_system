# == Schema Information
#
# Table name: user_notifications
#
#  id              :bigint           not null, primary key
#  read            :boolean          default(FALSE), not null
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notification_id :bigint
#
# Indexes
#
#  index_user_notifications_on_notification_id_and_username  (notification_id,username) UNIQUE
#  index_user_notifications_on_username_and_notification_id  (username,notification_id) UNIQUE
#
class UserNotification < ApplicationRecord
  belongs_to :notification
  belongs_to :user, foreign_key: :username

  validates :username, :notification_id, :read, presence: true
end
