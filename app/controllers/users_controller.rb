class UsersController < ApplicationController
  before_filter :authenticate
  before_filter :authenticate_admin, :except => 'change_password'
  before_filter :user_is_params_id, :only => ['edit', 'update', 'destroy']

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    if User.create(params[:user])
      redirect_to users_path
    end
  end

  def edit
  end

  def change_password
    @user = User.find(params[:user_id])
  end

  def update
    @user.update_attributes(params[:user])
    if request.full_path.include?('change_password') 
      redirect_to users_path, :notice => "#{@user.name} updated"
    else
      redirect_to new_notification_path, :notice => "new password saved!"
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

private

  def user_is_params_id
    @user = User.find(params[:id])
  end
end
