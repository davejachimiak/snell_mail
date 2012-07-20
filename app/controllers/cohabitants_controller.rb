class CohabitantsController < ApplicationController
  before_filter :authenticate
  before_filter :authenticate_admin
<<<<<<< HEAD
  before_filter :set_cohabitant, except: [:index, :new, :create]
=======
  before_filter :set_cohabitant, only: [:show, :edit, :update, :destroy]
>>>>>>> design

  def index
    @cohabitants = Cohabitant.all
  end

  def new
    @cohabitant = Cohabitant.new
  end

  def create
    @cohabitant = Cohabitant.new(params[:cohabitant])
    if @cohabitant.save
      redirect_to cohabitants_path, notice: 'New cohabitant successfully ' +
                                            'created.'
    else
      render 'new'
    end
  end

  def update
    if @cohabitant.update_attributes(params[:cohabitant])
      redirect_to cohabitants_path,
        notice: "#{@cohabitant.department} updated."
    else
<<<<<<< HEAD
      redirect_to request.referer,
=======
      redirect_to request.referer, 
>>>>>>> design
        notice: "Something went wrong. Try again."
    end
  end

  def destroy
    @cohabitant.destroy
    redirect_to cohabitants_path
  end
  
  def show
    @notifications = @cohabitant.notifications.order('id DESC').page(params[:page]).per_page(15)
  end

  def show
  end

  def edit
  end

  private

    def set_cohabitant
      @cohabitant = Cohabitant.find(params[:id])
    end
end
