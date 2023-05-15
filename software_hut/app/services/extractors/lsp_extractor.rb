# A class dedicated for reading and extracting LSP pdfs

require "open-uri"
require "pdf-reader"

class Extractors::LspExtractor

  class LspExtractionError < StandardError; end

  # Main headers from the PDFs
  HEADER_FIELDS = {
    registration_number: 'Registration number',
    student_name: 'Student name',
    programme_code: 'Programme code',
    disability_types: 'Disability type(s)',
    disability_advisor_email: 'Disability adviser email address',
    date_shared: 'Date LSP shared with department',
  }.freeze

  BODY_FIELDS = {
    access_evacuation_emergency_care: [
      ['Seizure Advice', 'Evacuation'],
      ['Evacuation', 'Timetabling'],
      ['Physical environment', 'Accessibility of materials'],
    ],
    teaching: [
      ['Accessibility of materials', 'Attendance'],
      ['Attendance', 'Teaching'],
      ['Teaching', 'Teaching-seminars/tutorials'],
      ['Teaching-seminars/tutorials', 'Working with peers'],
      ['Working with peers', 'Speaking in class'],
      ['Speaking in class', 'Presentations'],
      ['Timetabling', 'Communication/ongoing contact'],
    ],
    exams_and_assessment: [
      ['Coursework: support with production', 'Feedback'],
      ['Feedback', 'Viva'],
      ['Viva', 'Examinations'],
      ['Examinations', 'Extenuating Circumstances'],
      ['Presentations', 'Practical course elements'],
    ],
    practical_course_elements: [
      ['Practical course elements', 'Placements'],
      ['Placements', 'Field trips'],
      ['Field trips', 'Year abroad'],
      ['Year abroad', 'Coursework: support with production'],
    ],
    disability_info: [
      ['Disability information', 'Support required'],
    ],
    communication_ongoing_contact: [
      ['Communication/ongoing contact', 'Physical environment'],
    ],
    extenuating_circumstances: [
      ['Extenuating Circumstances', 'Please contact me if you have any queries'],
    ],
  }

  LSP_FIELDS = %i(disability_types
                  disability_advisor_email access_evacuation_emergency_care teaching
                  exams_and_assessment practical_course_elements disability_info
                  communication_ongoing_contact extenuating_circumstances date_shared
                  additional_recommendations)

  STUDENT_FIELDS = %i(registration_number forename surname department_code partial_programme_code)

  # Initialise the file 
  def initialize(file)
    @path = file.path
  end

  def extract
    begin
      reader = PDF::Reader.new(@path)
    rescue PDF::Reader::MalformedPDFError
      raise LspExtractionError.new "PDF is not valid"
    end

    @file_text = reader.pages.map(&:text).join('')

    # Extract basic LSP info from first page ("header" fields)
    fields = Hash[
      HEADER_FIELDS.map do |k, v|
        [k, extract_one_line_field(v)]
      end
    ]

    # Checks that all header fields are present
    header_fields_not_present = HEADER_FIELDS.map { |k, v| v.present? ? HEADER_FIELDS[k] : nil }.compact
    raise LspExtractionError.new(
      "Missing required info in PDF #{header_fields_not_present.join(', ')}"
    ) if header_fields_not_present.empty?

    # Extracts support recommendations and disability information
    fields.merge!(Hash[
      BODY_FIELDS.map do |k, v|
        [k, v.map { |h1, h2|
          extract_multi_line_field(h1, h2)
        }.join('')]
      end
    ])
    fields[:date_shared] = Date.strptime(fields[:date_shared], '%d/%m/%y')

    # Checks if the lsp already exists for that student
    # TODO: Implement additional recommendations extraction
    fields[:additional_recommendations] = ""

    # TODO: Work out forename/surname extraction
    fields[:forename] = fields.delete(:student_name)
    fields[:surname] = ""

    fields[:department_code] = fields[:programme_code][0...3]
    fields[:partial_programme_code] = fields[:programme_code][3..]
    fields.delete(:programme_code)

    {
      student: fields.slice(*STUDENT_FIELDS),
      lsp: fields.slice(*LSP_FIELDS)
    }
  end

  private
    def extract_one_line_field(field)
      @file_text.match(/(?<=#{Regexp.escape(field)}:)(.*)/).to_s.gsub("\u200B", '').strip
    end

    def extract_multi_line_field(heading, next_heading)
      @file_text.match(/(#{heading})(.*)(?=#{next_heading})/m).to_s.strip
    end
end
