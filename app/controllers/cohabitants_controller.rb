class CohabitantsController < ApplicationController
  before_filter :authenticate, :authenticate_admin
  before_filter :set_cohabitant, except: [:index, :new, :create]

  def index
    @cohabitants = Cohabitant.all
  end

  def new
    @cohabitant = Cohabitant.new
  end

  def create
    @cohabitant = Cohabitant.new(params[:cohabitant])
    if @cohabitant.save
      redirect_to cohabitants_path, notice: 'New cohabitant successfully created.'
    else
      render 'new'
    end
  end

  def update
    if @cohabitant.update_attributes(params[:cohabitant])
      redirect_to cohabitants_path,
        notice: "#{@cohabitant.department} updated."
    else
      render 'edit'
    end
  end

  def toggle_activated
    cohabitant_state_info = @cohabitant.toggle_activated!
    redirect_to cohabitants_path,
      flash: { "alert-#{cohabitant_state_info[:flash]}" =>
      "#{@cohabitant.department} #{cohabitant_state_info[:adj]}." }
  end

  def destroy
    @cohabitant.destroy
    redirect_to cohabitants_path
  end

  def show
    @notifications = @cohabitant.notifications.order('id DESC').
      page(params[:page]).per_page(15)
  end

  def edit
  end

  private

    def set_cohabitant
      @cohabitant = Cohabitant.find(params[:id])
    end
end
