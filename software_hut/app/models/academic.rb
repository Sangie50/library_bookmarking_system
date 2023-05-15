# == Schema Information
#
# Table name: academics
#
#  department_code :string
#  username        :string           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Academic < RoleProfile
  self.primary_key = :username

  belongs_to :user, foreign_key: :username
  belongs_to :department, foreign_key: :department_code
  has_and_belongs_to_many :modules,
    join_table: :academics_courses,
    class_name: 'CourseModule',
    association_foreign_key: :module_id,
    foreign_key: :username,
    before_add: :check_module_department
  has_many :tutees,
    class_name: 'Student',
    foreign_key: :tutor_username

  validates :department, :user, presence: true
  validates :user, uniqueness: true

  private
    # Before add hook for modules to check module department
    def check_module_department(added_module)
      raise Exception.new(
        "Department for #{added_module.full_code} is not equal to academic department (#{department.code})"
      ) if added_module.department != department
    end
end
