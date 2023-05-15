# == Schema Information
#
# Table name: module_sessions
#
#  code       :string           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ModuleSession < ApplicationRecord
  self.primary_key = :code

  validates :code, :name, presence: true, format: { with: /\A[A-Z ]+\z/, message: "only allows uppercase letters or spaces" }
  
  before_validation do
    code.upcase!
  end
end
