class UsersController < ApplicationController

  before_filter :find_user,  :only => [ :show, :edit, :update, :destroy ]

  def index
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      render(:action => :show)
    else
      render(:action => :new)
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      render(:action => :show)
    else
      render(:action => :edit)
    end
  end
  
  protected
    def find_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to users_path
    end
    
end
