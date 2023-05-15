# == Schema Information
#
# Table name: supervisors
#
#  id         :bigint           not null, primary key
#  role_code  :string
#  username   :string
#  student_id :integer
#
class Supervisor < ApplicationRecord
  belongs_to :academic,
    foreign_key: :username
  belongs_to :student
  belongs_to :role,
    class_name: 'SupervisorRole',
    foreign_key: :role_code

  validates :student, uniqueness: true
  validates :academic, :student, :role, presence: true
end
