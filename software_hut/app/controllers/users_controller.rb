# Controller for the User model
# Authors: Connor Mitchell, Caroline Osborne, William Lee

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users/1
  def show
  end

  def index
    @users = User.all.paginate(page: params[:page])
  end

  # GET /users/1/edit
  def edit
  end

  def new
    @users = User.new
  end
    
  def create
    @users = User.new(user_params)
    #, :sign_in_count => 0, :created_at => DateTime.now, :updated_at => DateTime.now
    if @users.save
    redirect_to users_path, notice: 'User was created.'
    else
    render :new
    end
  end


  # PATCH/PUT /users/1
  def update
  end

  # DELETE /users/1
  def destroy
    @user.destroy

    # Destroys user profiles
    if @user.academic?
      @user.academic_profile.destroy
    elsif @user.dlo?
      @user.dlo_profile.destroy
    elsif @user.ddss?
      @user.ddss_staff_member_profile.destroy
    end
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  # POST /users/upload_users
  def upload_users
    file = params[:upload_users][:file].tempfile
    importer = Imports::UserImporter.new(file)
    if importer.import_users
      flash.now[:alert] = 'Success'
      redirect_to users_path
    else
      flash.now[:alert] = 'Error'
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:username, :email)
    end
end