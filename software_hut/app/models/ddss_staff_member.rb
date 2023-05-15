# == Schema Information
#
# Table name: ddss_staff_members
#
#  email      :string           primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DdssStaffMember < RoleProfile
  self.primary_key = :email

  belongs_to :user, foreign_key: :email, primary_key: :email
  has_many :advised_lsps,
    class_name: 'Lsp',
    foreign_key: :email,
    primary_key: :advisor_email

  validates :user, presence: true
end
