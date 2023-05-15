# == Schema Information
#
# Table name: supervisor_roles
#
#  code :string           primary key
#  name :string
#
class SupervisorRole < ApplicationRecord
  self.primary_key = :code

  validates :code, :name, format: { with: /\A(\w| )+\z/, message: 'can contain letters and spaces only' }
end
