# View helpers for the Academic model
# Author: William Lee

module StudentsHelper
  ATTRIBUTE_TO_HEADING = {
    registration_number: 'Registration Number',
    forename: 'Forename',
    surname: 'Surname',
    email: 'Email',
    programme_code: 'Programme Code',
    disability_advisor_name: 'Disability Advisor Name',
    disability_advisor_email: 'Disability Advisor Email',
    disability_types: 'Disability Types',
    disability_info: 'Disability Info',
    date_shared: 'Date Shared',
    access_evacuation_emergency_care: 'Access, Evacuation and Emergency Care',
    teaching_support: 'Teaching Support',
    communication_ongoing_contact: 'Communication/Ongoing Contact',
    exams_and_assessment: 'Exams and Assessments',
    extenuating_circumstances: 'Extenuating Circumstances Support',
    practical_course_elements: 'Practical Course Elements',
    additional_recommendations: 'Additional Recommendations',
  }.freeze

  ATTRIBUTE_TO_NAVIGATION = {
    registration_number: %i(registration_number),
    forename: %i(forename),
    surname: %i(surname),
    email: %i(email),
    programme_code: %i(programme_code),
    disability_advisor_name: %i(lsp advisor full_name),
    disability_advisor_email: %i(lsp advisor email),
    disability_types: %i(lsp disability_types),
    disability_info: %i(lsp disability_info),
    date_shared: %i(lsp date_shared),
    access_evacuation_emergency_care: %i(lsp access_evacuation_emergency_care),
    teaching_support: %i(lsp teaching),
    communication_ongoing_contact: %i(lsp communication_ongoing_contact),
    exams_and_assessment: %i(lsp exams_and_assessment),
    extenuating_circumstances: %i(lsp extenuating_circumstances),
    practical_course_elements: %i(lsp practical_course_elements),
    additional_recommendations: %i(lsp additional_recommendations),
  }.freeze

  def search_attributes
    students = [
      ["Name", "full_name"],
      ["Module", "module_changed"],
      ["Course", "course_taught"],
      ["Date changed", "date_changed"],
      ["Disability type", "disability_type"]
    ]
  end

  def search_module_ids
    search_params[:department_code].present? ? Department.find_by(code: search_params[:department_code]).modules : []
  end

  def attr_for(model_instance, attribute)
    navigation = ATTRIBUTE_TO_NAVIGATION[attribute]
    value = model_instance
    navigation.each do |attribute|
      value = value&.public_send(attribute)
    end

    value
  end

  def heading_for(attribute)
    ATTRIBUTE_TO_HEADING[attribute]
  end
end
