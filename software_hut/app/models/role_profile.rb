# Base class for user role profiles

class RoleProfile < ApplicationRecord
  self.abstract_class = true

  # Delegates missing attributes to the associated user
  # e.g. academic_profile.full_name is a shortcut for academic_profile.user.full_name
  def method_missing(m, *args, &block)
    self.user&.send(m, *args, &block)
  end
end