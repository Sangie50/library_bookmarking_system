# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.academic?
      can [:read, :get_modules], Department, code: user.academic_profile.department.code
      can :read, CourseModule, academics: { username: user.username }
      can [:search, :read], Student, modules: { academics: { username: user.username } }
      # Academics should not be able to view students that do not have LSPs
      cannot [:search, :read], Student, lsp: nil
    end

    if user.dlo?
      can :manage, CourseModule, department: user.dlo_profile.department
      can :manage, Academic, department: user.dlo_profile.department
      can [:read, :get_modules, :get_tutors], Department, code: user.dlo_profile.department.code
      can [:read, :search], Student, department: user.dlo_profile.department
    end

    if user.ddss?
      can :manage, [Student, Department, Academic] 
      can :read, CourseModule 
    end

    return unless user.admin?
    can :manage, :all
  end
end
