# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  link       :string
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Notification < ApplicationRecord
  has_many :user_notifications
  has_many :users, through: :user_notifications

  validates :message, :link, presence: true
end
