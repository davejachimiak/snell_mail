class UsersController < ApplicationController
  before_filter :authenticate
  before_filter :authenticate_admin, :except => 'change_password'
  before_filter :user_is_params_id, :only => ['edit', 'update', 'change_password']

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
  end

  def update
    @user.update_attributes(params[:user])
    redirect_to users_path
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path
  end

private

  def user_is_params_id
    @user = User.find(params[:id])
  end
end
