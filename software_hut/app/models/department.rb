# == Schema Information
#
# Table name: departments
#
#  code       :string           primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Department < ApplicationRecord
  self.primary_key = :code

  default_scope { order(:code) }

  has_many :students, foreign_key: :department_code
  has_many :modules,
    class_name: 'CourseModule',
    foreign_key: :department_code
  has_many :dlos, foreign_key: :department_code
  has_many :academics, foreign_key: :department_code

  validates :code, length: { is: 3 }, format: { with: /\A[A-Z]+\z/, message: 'Uppercase letters only' }

  before_validation do
    code.upcase!
  end
end
