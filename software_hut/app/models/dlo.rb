# == Schema Information
#
# Table name: dlos
#
#  department_code :string
#  username        :string           primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Dlo < RoleProfile
  self.primary_key = :username

  belongs_to :user, foreign_key: :username
  belongs_to :department, foreign_key: :department_code

  validates :user, :department, presence: true
  validates :user, uniqueness: true
end
