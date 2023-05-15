# Controller for the CourseModule model
# Authors: William Lee, Sophie Dillon

class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy, :get_modules, :get_academics]

  authorize_resource

  # GET /departments
  def index
    @departments = Department.all.paginate(page: params[:page])
  end

  # GET /departments/1
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  def create
    @department = Department.new(department_params)

    if @department.save
      redirect_to @department, notice: 'Department was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /departments/1
  def update
    if @department.update(department_params)
      redirect_to @department, notice: 'Department was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /departments/1
  def destroy
    @department.destroy
    redirect_to departments_url, notice: 'Department was successfully deleted.'
  end

  # GET /departments/COM/modules
  def get_modules
    modules = @department.nil? ? CourseModule.none : @department.modules.accessible_by(current_ability)
    json = Hash[
      modules.map do |m|
        [m.id, m.label]
      end
    ]

    render json: json, layout: false
  end

  # GET /departments/COM/academics
  def get_academics
    # Generates a JSON object mapping username (PK) to academic full name
    academics = @department.nil? ? Academic.none : @department.academics.accessible_by(current_ability)
    json = Hash[
      academics.map do |a|
        [a.username, a.full_name]
      end
    ]

    render json: json, layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def department_params
      params.require(:department).permit(:code, :name)
    end
end
