# == Schema Information
#
# Table name: users
#
#  admin              :boolean          default(FALSE)
#  current_sign_in_at :datetime
#  current_sign_in_ip :inet
#  dn                 :string
#  email              :string           default(""), not null
#  givenname          :string
#  last_sign_in_at    :datetime
#  last_sign_in_ip    :inet
#  mail               :string
#  ou                 :string
#  sign_in_count      :integer          default(0), not null
#  sn                 :string
#  uid                :string
#  username           :string           default(""), not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email)
#
class User < ApplicationRecord
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include EpiCas::DeviseHelper
  self.primary_key = :username

  has_one :academic_profile,
    class_name: 'Academic',
    foreign_key: :username
  has_one :dlo_profile,
    class_name: 'Dlo',
    foreign_key: :username
  has_one :ddss_staff_member_profile,
    class_name: 'DdssStaffMember',
    foreign_key: :email,
    primary_key: :email
  # Only unread notifications
  has_many :user_notifications, -> { where read: false }
  has_many :notifications, through: :user_notifications

  validates :username, :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be valid' }

  before_validation do
    get_info_from_ldap if username.present? || email.present?
  end

  # Usernames and email addresses are lowercased
  before_save do
    username&.downcase!
    email&.downcase!
  end

  # Attribute aliases
  %w(forename first_name).each { |name| alias_attribute name, :givenname }
  %w(surname last_name).each { |name| alias_attribute name, :sn }

  # Returns full name of the user
  def full_name
    "#{givenname} #{sn}"
  end

  # If the user is an academic
  def academic?
    !academic_profile.nil?
  end

  # If the user is a DLO
  def dlo?
    !dlo_profile.nil?
  end

  # If the user is a DDSS staff member
  def ddss?
    !ddss_staff_member_profile.nil?
  end

  # Makes this user a DLO of the specified department
  def make_dlo(department)
    create_dlo_profile username: username, department: department_from_code(department)
  end

  # Makes this user an admin
  def make_admin
    update!(admin: true)
  end

  # Makes this user a DDSS staff member
  def make_ddss
    create_ddss_staff_member_profile email: email
  end

  # Makes this user an academic of the specified department
  def make_academic(department)
    create_academic_profile username: username, department: department_from_code(department)
  end

  # Returns the department of this user
  def department
    if academic?
      klazz = Academic
    elsif dlo?
      klazz = Dlo
    else
      return nil
    end

    klazz.where(username: self.username).first&.department
  end

  # Returns a human-readable list of roles for this user
  def roles
    roles = {
      "Academic": academic?,
      "DLO": dlo?,
      "DDSS": ddss?,
      "Admin": admin?,
    }
    roles.filter { |_, v| v }.keys.map(&:to_s)
  end

  private
    # Returns the department by code or name
    # If a department instance is passed in, returns that department instance
    def department_from_code(department)
      if department.instance_of? String
        query = Department.where(code: department).or(Department.where(name: department))
        temp = query.first
        if temp.nil?
          raise TypeError.new "Department with code or name #{department}"
        end

        department = temp
      end

      department
    end
end
