require 'csv'

# A class dedicated for importing students 
class Imports::StudentImporter

  class StudentImportError < StandardError; end
  class CourseModuleNotFound < StudentImportError
    def initialize(code)
      super("Module with code #{code} not found")
    end
  end

  # CSV headers
  HEADERS = [
    'Registration number',
    'Surname',
    'Forename',
    'Title',
    'Email address',
    'Supervisor role type code',
    'Supervisor email',
    'Programme code',
    'Unit code',
  ].freeze

  # Other headers for module code only lines
  # (for adding modules to the current student)
  OTHER_HEADERS = (HEADERS - ['Registration number', 'Unit code']).freeze

  def initialize(file)
    @path = file.path
  end

  def import
    begin
      csv = CSV.read(@path, headers: true, skip_blanks: true)
    rescue CSV.const_get('MalformedCSVError')
      raise StudentImportError.new 'CSV is not valid: not a valid CSV file'
    end
    csv_valid = (HEADERS - csv.headers.compact).empty?
    raise StudentImportError.new 'CSV is not valid: missing headings' unless csv_valid

    # Changes to students are rolled back on error
    Student.transaction do
      add_students_from_csv(csv)
    end
  end

  private

  def add_students_from_csv(csv)
    # Enumerator for CSV rows
    rows = csv.each
    # Holds the current student
    student = nil
    while true
      # Peek at the next line
      begin
        row = rows.next
      rescue StopIteration => e
        break
      end

      if row['Registration number'].present?
        student = add_student(row)
      elsif student.nil?
        # Should only happen if the first line doesn't contain student details
        raise StudentImportError.new 'Expected student on line 1'
      end

      begin
        until rows.peek['Registration number'].present?
          row = rows.next
          add_module_to_student(student, row)
        end
      rescue StopIteration => e
        break
      end
    end
  end

  def add_module_to_student(student, row)
    # Raises error if module code is empty
    raise StudentImportError.new(
      "Empty module for student with registration number #{student.registration_number}"
    ) unless row['Unit code'].present?
    # Other columns not be filled in
    other_columns_empty = OTHER_HEADERS.select { |header| row[header].present? }.empty?
    unless other_columns_empty
      raise StudentImportError.new "Registration number was not found by "
    end

    # Find module
    course_module = CourseModule.where(
      department_code: row['Unit code'][0...3], code: row['Unit code'][3..]
    ).first

    # Module not found
    raise CourseModuleNotFound.new(row['Unit code']) if course_module.nil?
    # Add the module to the student
    student.modules << course_module
  end

  def add_student(row)
    # Find or initialize new student from info
    student = Student.find_or_create_by(registration_number: row['Registration number'])
    # If student exists
    if student.persisted?
      # Clear existing modules
      student.modules.clear
    end

    student.surname = row['Surname']
    student.forename = row['Forename']
    student.title = row['Title']
    student.email = row['Email address']
    student.supervisor&.destroy
    student.build_supervisor(
      academic: User.where(email: row['Supervisor email'].downcase).first.academic_profile,
      role_code: row['Supervisor role type code']
    ).save!
    student.department_code = row['Programme code'][0...3]
    student.partial_programme_code = row['Programme code'][3..]
    student.save!
    student
  end
end