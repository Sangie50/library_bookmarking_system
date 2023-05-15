# frozen_string_literal: true

REG_NUM_BASE = 210000000

# Default module sessions
MODULE_SESSIONS = {
  'ACAD YR': 'Academic Year',
  'SPR SEM': 'Spring Semester',
  'AUT SEM': 'Autumn Semester',
}

# Default departments
DEPARTMENTS = {
  'ACS': 'Automatic Control and Systems Engineering',
  'COM': 'Computer Science',
  'CIV': 'Civil and Structural Engineering',
  'CBE': 'Chemical and Biological Engineering',
  'EEE': 'Electronic and Electrical Engineering',
  'MAT': 'Materials Science and Engineering',
  'MEC': 'Mechanical Engineering',
  'IPE': 'Interdisciplinary Programmes',
  'MGT': 'Management School',
}

# Default supervisor roles
SUPERVISOR_ROLES = {
  'TUTOR': 'Personal Tutor',
  'DISSUP': 'Dissertation Supervisor',
  'PGTUT': 'Postgraduate Tutor',
}

# Users for development and demo
DEVELOPERS = %w(aca19wwl acb19sd acb19cm aca17cao acb19sb aca19clh)
CLIENTS = %w(g.sapsford@sheffield.ac.uk
             m.lubelski@sheffield.ac.uk
             ruaridh.watson@sheffield.ac.uk
             t.dolmansley@sheffield.ac.uk)

# Students for development and demo
STUDENTS = [
  {
    forename: 'William',
    surname: 'Lee',
    email: 'wwflee1@sheffield.ac.uk',
    username: 'aca19wwl'
  },
  {
    forename: 'Sophie',
    surname: 'Dillon',
    email: 'sdillon1@sheffield.ac.uk',
    username: 'acb19sd',
  },
  {
    forename: 'Connor',
    surname: 'Mitchell',
    email: 'cmitchell9@sheffield.ac.uk',
    username: 'acb19cm',
  },
  {
    forename: 'Caroline',
    surname: 'Osborne',
    email: 'caosborne1@sheffield.ac.uk',
    username: 'aca17cao',
  },
  {
    forename: 'Sangramithra',
    surname: 'Bala Amuthan',
    email: 'sbalaamuthan1@sheffield.ac.uk',
    username: 'acb19sb',
  },
  {
    forename: 'Chelsea',
    surname: 'Huang',
    email: 'clhuang@sheffield.ac.uk',
    username: 'aca19clh',
  },
]

# Modules for demo
MODULES = [
  {
    code: 1001,
    name: 'Introduction to Software Engineering'
  },
  {
    code: 1002,
    name: 'Foundations of Computer Science'
  },
  {
    code: 1003,
    name: 'Java Programming'
  },
  {
    code: 1005,
    name: 'Machines and Intelligence'
  },
  {
    code: 1006,
    name: 'Devices and Networks'
  },
  {
    code: 2004,
    name: 'Data Driven Computing'
  },
  {
    code: 2008,
    name: 'Systems Design and Security'
  },
  {
    code: 2009,
    name: 'Robotics'
  },
  {
    code: 2107,
    name: 'Logic in Computer Science'
  },
  {
    code: 2108,
    name: 'Functional Programming'
  }
]

# Academics for demo
ACADEMICS = %w(
  k.bogdanov
  p.watton
  mark.stevenson
  s.north
  m.villa-uriol
  y.gotoh
  e.j.norling
  a.j.simons
)

MODULE_SESSIONS.each do |code, name|
  puts "Adding module session #{code}: #{name}"
  ModuleSession.where(code: code).first_or_create!(name: name)
end

DEPARTMENTS.each do |code, name|
  puts "Adding department #{code}: #{name}"
  Department.where(code: code).first_or_create!(name: name)
end

SUPERVISOR_ROLES.each do |code, name|
  puts "Adding supervisor role #{code}: #{name}"
  SupervisorRole.where(code: code).first_or_create!(name: name)
end

if Rails.env.demo? || Rails.env.development? || Rails.env.test?
  ACADEMICS.each do |email|
    puts "Adding academic with email #{email}"
    User.where(email: "#{email}@sheffield.ac.uk").first_or_create!.make_academic 'COM'
  end
end

# User seeds for test and demonstration environments
if Rails.env.demo? || Rails.env.development?
  DEVELOPERS.each do |username|
    puts "Adding developer with username #{username} as admin"
    user = User.where(username: username).first_or_initialize
    user.admin = true
    user.save!
  end

  STUDENTS.each_with_index do |student_info, i|
    puts "Adding student #{student_info[:forename]} #{student_info[:surname]}"
    student = Student.where(
      registration_number: REG_NUM_BASE + i,
    ).first_or_create!(
      **student_info,
      department_code: 'COM',
      partial_programme_code: 'U104',
      graduation_date: Date.today,
    )
    student.supervisor = Supervisor.where(student: student)
      .first_or_create(
        academic: User.where(email: 'k.bogdanov@sheffield.ac.uk').first.academic_profile,
        role_code: 'TUTOR'
      )
  end

  MODULES.each do |module_info|
    puts "Adding module #{module_info[:code]}: #{module_info[:name]}"
    CourseModule.where(**module_info).first_or_create!(department_code: 'COM', session: ModuleSession.all.sample)
  end

  Student.all.each do |student|
    puts "Assigning random modules to student #{student.full_name}"
    student.modules = CourseModule.all.sample(Random.rand(1..CourseModule.count))
  end
end

if Rails.env.demo?
  CLIENTS.each do |email|
    puts "Adding client with email #{email}"
    User.where(email: email).first_or_create!(admin: true)
  end
end
