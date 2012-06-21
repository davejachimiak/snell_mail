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
    else
      redirect_to request.referer, :notify => 'Something went wrong. Try again'
    end
  end

  #def edit
  #end

  def change_password
    #if params[:user_id] == current_user.id
      @user = User.find(params[:user_id])
      session[:redirect_back] = request.referer
    #else
    #  redirect_to request.referer, :notify => 'idiot'
    #end
  end

  def update
    if changing_password?
      change_password
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

  def changing_password?
    @old_password = params[:user][:old_password]
  end

  def change_password
    if @user.authenticate(@old_password)
      if @user.update_attributes(params[:user])
        redirect_to session[:redirect_back], :notify => 'new password saved!'
      else
        redirect_to "/change_password?user_id=#{@user.id}", :notify => "password confirmation " +
                                                                         "doesn't match"
      end
    else
      redirect_to "/change_password?user_id=#{@user.id}"
    end
  end
end
