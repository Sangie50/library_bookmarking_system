# Controller for the Student model
# Authors: William Lee, Sophie Dillon

class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  helper_method :search_params

  authorize_resource

  # Permitted search parameters
  SEARCH_PARAMS = %i(forename surname department_code updated_at disability_type).freeze

  # Attributes to display in students table
  DEFAULT_ATTRIBUTES = %i(registration_number surname forename programme_code teaching_support).freeze
  ATTRIBUTES = %i(
    registration_number
    forename
    surname
    email
    programme_code
    disability_advisor_name
    disability_advisor_email
    disability_types
    disability_info
    date_shared
    access_evacuation_emergency_care
    teaching_support
    communication_ongoing_contact
    exams_and_assessment
    extenuating_circumstances
    practical_course_elements
    additional_recommendations
  ).freeze

  # GET /students
  def index
    # Full join is used on LSPs to make CanCanCan ability work
    @students = Student
    .joins('FULL JOIN lsps ON lsps.registration_number = students.registration_number')
    .accessible_by(current_ability)
    # Processes search parameter filters
    search_params.each do |key, value|
      next unless value.present?

      if value.instance_of? String
        value.strip!
        next if value.empty?
      end

      case key
      when 'updated_at'
        # Code for converting date to datetime
        @students = @students
          .where('lsps.updated_at >= ?', value.to_datetime)
          .where('lsps.updated_at < ?', value.to_datetime + 1)
          .references(:lsps)
      when 'module_ids'
        next if value.reject(&:empty?).empty?
        @students = @students.includes(:modules).where('course_modules.id': value)
      else
        # Database column name is qualified by table name in where
        if value.instance_of? String
          # Text searches are case-insensitive
          @students = @students.where("LOWER(students.#{key}) LIKE LOWER(?)", "%#{value}%")
        else
          @students = @students.where(students: { key => value })
        end
      end
    end
    @students = @students.paginate(page: params[:page])

    # Ensures attribute order is preserved
    @attributes = ATTRIBUTES.select { |v| columns.include? v }
  end

  # GET /students/1
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
    @student.build_lsp
    @student.build_supervisor

    return unless session[:lsp_data]

    @student.attributes = session[:lsp_data][:student]
    @student.build_lsp(session[:lsp_data][:lsp])
  end

  # GET /students/1/edit
  def edit
    @student.build_lsp unless @student.lsp&.persisted?
    @student.build_supervisor unless @student.supervisor&.persisted?
    @student.lsp.attributes = session[:lsp_data][:lsp] if session[:lsp_data]
  end

  # POST /students
  def create
    @student = Student.new(student_params)
    @student.build_lsp(lsp_params) unless lsp_params.empty?
    @student.build_supervisor(supervisor_params) unless supervisor_params.empty?

    if @student.save && @student.lsp.save && @student.supervisor.save
      session.delete(:lsp_data) if session[:lsp_data]
      redirect_to @student, notice: 'Student was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /students/1
  def update
    unless lsp_params.empty?
      if @student.lsp&.persisted?
        @student.lsp.attributes = lsp_params
      else
        @student.build_lsp(lsp_params)
      end
    end
    unless supervisor_params.empty?
      if @student.supervisor&.persisted?
        @student.supervisor.attributes = supervisor_params
      else
        @student.build_supervisor(supervisor_params)
      end
    end
    if @student.update(student_params) && (@student.supervisor.present? ? @student.supervisor.save : true) && (@student.lsp.present? ? @student.lsp.save : true)
      session.delete(:lsp_data) if session[:lsp_data]
      redirect_to @student, notice: 'Student was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /students/1
  def destroy
    @student.destroy
    redirect_to students_url, notice: 'Student was successfully deleted.'
  end

  # POST /students/upload
  def upload
    return redirect_to students_path, alert: 'No file selected' unless params.has_key? :students
    
    file = params.require(:students)[:file].tempfile
    importer = Imports::StudentImporter.new file
    begin
      importer.import
      flash[:notice] = 'All students successfully imported'
    rescue Imports::StudentImporter::StudentImportError => e
      flash[:alert] = e.message
    end

    redirect_to students_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def student_params
      params.require(:student).permit(
        :registration_number, :forename, :surname, 
        :username, :email, :tutor_username, :department_code,
        :partial_programme_code, :graduation_date
      )
    end

    def supervisor_params
      params.require(:supervisor).permit(:username, :role_code)
    end

    def lsp_params
      params.require(:lsp).permit(
        :registration_number, :disability_types, :disability_advisor_email,
        :access_evacuation_emergency_care, :teaching, :exams_and_assessment,
        :practical_course_elements, :disability_info,
        :communication_ongoing_contact, :extenuating_circumstances,
        :date_shared, :student_name, :programme_code, :additional_recommendations
      ).select { |_, v| v.present? }
    end

    def search_params
      return ActionController::Parameters.new unless params.has_key? :search
      allowed = params.require(:search).permit(*SEARCH_PARAMS, module_ids: [])
      if allowed.has_key? :updated_at
        allowed[:updated_at] = Date.strptime(allowed[:updated_at], '%Y-%m-%d')
      end
      allowed
    end

    def columns
      return DEFAULT_ATTRIBUTES unless params.has_key? :columns
      cols = params.require(:columns).permit(names: [])[:names]
      if cols.reject(&:empty?).empty?
        DEFAULT_ATTRIBUTES
      else
        cols.map(&:to_sym)
      end
    end
end
