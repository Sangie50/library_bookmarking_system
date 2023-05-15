require 'csv'

# A class dedicated to importing course modules with various academics 
class Imports::CourseModuleImporter
  HEADERS = [
    "module code",
    "module name",
    "semester type",
    "academic 1",
    "academic 2",
    "academic 3",
  ].freeze

  # Initialises an instance of this class with the path to the file
  # and the current user 
  def initialize(file, user)
    @path = file.path
    @user = user
  end

  # Read the CSV which is passed in with error checking
  def import
    csv = CSV.read(@path, headers: true, skip_blanks: true)
    csv_valid = (HEADERS - csv.headers.map(&:downcase).compact).empty?

    return "CSV is invalid" unless csv_valid

    invalid_emails = Set.new
    unpermitted_department = false
    num_success = csv.map do |course_module|
      new_module = CourseModule.new

      module_code = next_csv_value(course_module)
      new_module.department_code, new_module.code = module_code[0...3], module_code[3..]

      unless permitted_department_codes.include? new_module.department_code
        unpermitted_department = true
        next false
      end
      new_module.name = next_csv_value(course_module)
      new_module.session = ModuleSession.where(code: next_csv_value(course_module)).first

      # Get the user from email for an academic
      (0..3).map do
        email = next_csv_value(course_module)
        next unless email && !email.empty?

        begin
          user = User.where(email: email).first_or_create!
        rescue ActiveRecord::RecordInvalid
          invalid_emails << email
        else
          user.academic_profile = Academic.where(username: user.username).first_or_create!(department_code: new_module.department_code)
          new_module.academics << user.academic_profile
        end
      end

      new_module.save
      true
    end.count{ |x| x }

    message = "Successfully added #{num_success}/#{csv.length} modules. "
    message += "Some module(s) couldn't be added because you weren't permitted." if unpermitted_department
    message += "No user for emails: #{invalid_emails.to_a.join(', ')}." unless invalid_emails.empty?
    message
  end

  private
    # Go to the next CSV row
    def next_csv_value(row)
      row.delete(0)&.last
    end
    
    # Check if the department code is valid
    # Go over each department and get all of their codes if admin
    # Otherwise get the department code if DLO 
    def permitted_department_codes
      return Department.all.map(&:code) if @user.admin?
      return [@user.dlo_profile.department.code] if @user.dlo?
      []
    end
end