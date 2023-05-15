# == Schema Information
#
# Table name: course_modules
#
#  id              :bigint           not null, primary key
#  code            :integer
#  department_code :string
#  name            :string
#  session_code    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class CourseModule < ApplicationRecord
  belongs_to :department, foreign_key: :department_code
  belongs_to :session,
    class_name: 'ModuleSession',
    foreign_key: :session_code
  has_and_belongs_to_many :academics,
    join_table: :academics_courses,
    association_foreign_key: :username,
    foreign_key: :module_id,
    before_add: :check_academic_department
  has_and_belongs_to_many :students,
    association_foreign_key: :student_id,
    foreign_key: :module_id

  validates :code, uniqueness: { scope: :department }
  validates :name, uniqueness: true
  validates :code, :name, presence: true
  validates :session, :department, presence: { message: 'must exist' }

  def full_code
    "#{department_code}#{code}"
  end

  def label
    "#{full_code} - #{name}"
  end

  private
    # Before add hook to check academic department
    def check_academic_department(added_academic)
      raise Exception.new(
        "Department for #{added_academic.full_name} (#{added_academic.department.code}) is not equal to department for #{full_code}"
      ) if added_academic.department != department
    end
end
