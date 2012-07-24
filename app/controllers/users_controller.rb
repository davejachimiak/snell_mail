class UsersController < ApplicationController
  before_filter :authenticate
  before_filter :authenticate_admin, except: [:password, :update]
  before_filter :set_user, except: [:index, :new, :create, :password]

  def password
    @user = current_user
    session[:redirect_back] = request.referer
  end

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path,
        flash: { "alert_success" => "#{@user.name} created" }
    else
      @error = true
      render 'new'
    end
  end

  def update
    if changing_password?
      change_password
    elsif @user.update_attributes(params[:user])
      redirect_to users_path, notice: "#{@user.name} updated"
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  def show
    notifications = @user.notifications
    if notifications.empty?
      @notifications = []
    else
      @notifications = notifications.order('id DESC').page(params[:page]).
                         per_page(15)
    end
  end

  def edit
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def changing_password?
      @old_password = params[:user][:old_password]
    end

    def change_password
      params[:user].delete(:old_password)
      if authenticates_and_updates?
        success
      elsif @user.authenticate(@old_password)
        password_confirmation_mismatch
      else
        old_password_mismatch
      end
    end

    def authenticates_and_updates?
      @user.authenticate(@old_password) &&
      @user.update_attributes(params[:user])
    end

    def success
      flash[:notice] = 'new password saved!'
      redirect_to session[:redirect_back]
    end

    def password_confirmation_mismatch
      flash[:notice] = "Password confirmation doesn't match"
      redirect_to request.referer
    end

    def old_password_mismatch
      flash[:notice] = "Old password didn't match existing one"
      redirect_to request.referer
    end
end
