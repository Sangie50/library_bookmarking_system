# Controller for the CourseModule model
# Authors: William Lee, Sophie Dillon

class CourseModulesController < ApplicationController
  before_action :set_course_module, only: [:show, :edit, :update, :destroy]

  authorize_resource

  # GET /course_modules
  def index
    @course_modules = CourseModule
      .accessible_by(current_ability)
      .paginate(page: params[:page])
  end

  # GET /course_modules/1
  def show
  end

  # GET /course_modules/new
  def new
    @course_module = CourseModule.new
  end

  # GET /course_modules/1/edit
  def edit
  end

  # POST /course_modules
  def create
    @course_module = CourseModule.new(course_module_params)

    department_codes = Department.accessible_by(current_ability).map { |d| d.code }
    unless department_codes.include? course_module_params[:department_code]
      flash[:alert] = "You aren't permitted to add modules to this department"
      return render :new
    end

    if @course_module.save
      redirect_to @course_module, notice: 'Module was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /course_modules/1
  def update
    if @course_module.update(course_module_params)
      redirect_to @course_module, notice: 'Module was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /course_modules/1
  def destroy
    @course_module.destroy
    redirect_to course_modules_url, notice: 'Module was successfully deleted.'
  end

  # POST /modules/upload
  def upload
    file = params[:course_modules]&.require(:file)
    return flash[:alert] = 'No file selected' unless file

    importer = Imports::CourseModuleImporter.new file, current_user
    flash[:alert] = importer.import
    redirect_to course_modules_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_module
      @course_module = CourseModule.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def course_module_params
      params.require(:course_module).permit(:code, :name, :department_code, :session_code, academic_ids: [])
    end
end
