# == Schema Information
#
# Table name: students
#
#  department_code        :string
#  email                  :string
#  forename               :string
#  graduation_date        :date
#  partial_programme_code :string
#  registration_number    :integer          primary key
#  surname                :string
#  title                  :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Student < ApplicationRecord
  RetentionPeriod = 365  # in days

  self.primary_key = :registration_number

  has_one :lsp,
    foreign_key: :registration_number,
    dependent: :destroy
  has_one :supervisor
  belongs_to :department, foreign_key: :department_code
  has_and_belongs_to_many :modules,
    class_name: 'CourseModule',
    association_foreign_key: :module_id

  validates *%i(registration_number forename department
                partial_programme_code), presence: true
  validates :registration_number, uniqueness: true
  validates :username, uniqueness: true, if: -> { username.present? }
  validates :email, uniqueness: true, if: -> { email.present? }

  before_save do
    email&.downcase!
    username&.downcase!
  end

  def programme_code
    "#{department_code}#{partial_programme_code}"
  end

  def full_name
    "#{forename} #{surname}"
  end

  # Deletes expired students records
  # This is when the student has graduated for at least the retention period
  def self.delete_expired!
    destroy_by('graduation_date <= ?', Date.today - RetentionPeriod)
  end
end
