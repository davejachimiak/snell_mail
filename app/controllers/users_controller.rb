class UsersController < ApplicationController
  before_filter :authenticate
  before_filter :authenticate_admin, :except => ['change_password','update']
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
    session[:redirect_back] = "/change_password?user_id=#{@user.id}"
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to users_path, :notice => "#{@user.name} updated"
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
