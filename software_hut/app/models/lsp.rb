# == Schema Information
#
# Table name: lsps
#
#  access_evacuation_emergency_care :text
#  additional_recommendations       :text
#  communication_ongoing_contact    :text
#  date_shared                      :date
#  disability_advisor_email         :string
#  disability_info                  :text
#  disability_types                 :text
#  exams_and_assessment             :text
#  extenuating_circumstances        :text
#  practical_course_elements        :text
#  registration_number              :integer          primary key
#  teaching                         :text
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
class Lsp < ApplicationRecord
  self.primary_key = :registration_number

  belongs_to :student,
    foreign_key: :registration_number
  belongs_to :advisor,
    class_name: "DdssStaffMember",
    foreign_key: :disability_advisor_email

  validates *%i(student disability_types advisor date_shared),
    presence: true
  validates :registration_number, uniqueness: true

  before_validation do
    User.where(email: disability_advisor_email).first_or_create!.make_ddss
  end
end
