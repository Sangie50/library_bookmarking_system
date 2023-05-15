# Controller for the Academic model
# Author: William Lee

class AcademicsController < ApplicationController
  before_action :set_academic, only: [:show, :edit, :update, :destroy]

  authorize_resource

  # GET /academics
  def index
    @academics = Academic
      .accessible_by(current_ability)
      .paginate(page: params[:page])
  end

  # GET /academics/1
  def show
  end

  # GET /academics/new
  def new
    @academic = Academic.new
  end

  # GET /academics/1/edit
  def edit
  end

  # POST /academics
  def create
    @user = User.new(user_params)
    @academic = @user.build_academic_profile(academic_params)

    if @user.save && @user.academic_profile.save
      redirect_to @academic, notice: 'Academic was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /academics/1
  def update
    username = @user.username
    @user.username = ""
    if @user.update(user_edit_params)
        @academic.username = @user.username
        if @academic.update(academic_edit_params)
          return redirect_to @academic, notice: 'Academic was successfully updated.'
        end
    end

    @user.username = username
    @academic.username = username
    render :edit
  end

  # DELETE /academics/1
  def destroy
    @academic.destroy
    redirect_to academics_url, notice: 'Academic was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_academic
      @academic = Academic.find(params[:id])
      @user = @academic.user
    end

    # Only allow a trusted parameter "white list" through.
    def permitted_params
      params.require(:academic).permit(:username, :email, :forename, :surname, :department_code, module_ids: [])
    end

    def permitted_edit_params
      permitted_params.permit(:email, :department_code, module_ids: [])
    end

    def academic_params
      permitted_params.slice(:username, :department_code, :module_ids)
    end

    def academic_edit_params
      permitted_edit_params.slice(:department_code, :module_ids)
    end

    def user_params
      permitted_params.slice(:username, :surname, :forename, :email)
    end

    def user_edit_params
      permitted_edit_params.slice(:email)
    end
end
