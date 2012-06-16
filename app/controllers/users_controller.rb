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
    old_password = params[:user][:old_password]
    if old_password 
      if Digest::SHA2.digest("#{old_password}#{current_user.salt}") == current_user.encrypted_password
        if params[:user][:password_confirmation] == params[:user][:password]
          if @user.update_attributes(params[:user])
            if !admin?
              redirect_to new_notification_path, :notice => 'new password saved!'
            elsif current_user.id == @user.id && admin? && @user.password?
              redirect_to users_path, :notice => 'new password saved!'
            end
          else
            redirect_to session[:redirect_back], :notice => "your new password needs to be over 6 characters"
          end
        else
          redirect_to session[:redirect_back], :notice => "your new password and confirmation didn't match"
        end
      else
        redirect_to session[:redirect_back], :notice => "your old password didn't match your existing one"
      end
    elsif @user.update_attributes(params[:user])
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
