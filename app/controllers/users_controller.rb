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
                         per_page(RECORDS_PER_PAGE)
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
      if old_password_authenticates?
        if new_password_confirmed?
          success
        else
          password_confirmation_mismatch
        end
      else
        old_password_mismatch
      end
    end

    def old_password_authenticates?
      @user.authenticate(@old_password)
    end

    def new_password_confirmed?
      @user.update_attributes(params[:user])
    end

    def success
      redirect_from_password_change_success
      session[:redirect_back] = nil
    end

    def password_confirmation_mismatch
      flash[:notice] = "Password confirmation doesn't match"
      redirect_to request.referer
    end

    def old_password_mismatch
      flash[:notice] = "Old password didn't match existing one"
      redirect_to request.referer
    end

    def redirect_from_password_change_success
      flash[:notice] = 'new password saved!'
      redirect_to session[:redirect_back]
    end
end
