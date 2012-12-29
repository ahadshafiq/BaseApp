class UsersController < ApplicationController
  #  this will do it for all methods before_filter :signed_in_user
  #  if you want only specific to edit:
  before_filter :signed_in_user, only:  [:index, :edit, :update]
  before_filter :correct_user, only:    [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user  = User.new
  end

  def create
  	@user  = User.new(params[:user]) #this user matches up from new.html.erb's class of @user
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Twitter App"
  		redirect_to user_path(@user)
  	else
  		render 'new' 
      # solution to it looking for a view page
  	end
  end

  def edit
    # in this case the user already exists, we wanna pull it out of DB
    
  end

  def update 
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      sign_in @user
      # handle a successful update....if you dont have a template you get error
      # so redirect somewhere
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # solution to it looking for a view page
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
      redirect_to users_path
  end

  private 
    def signed_in_user
      unless signed_in?
        # below method in sessions helpers
        store_location 
        redirect_to signin_path, notice: "Please sign in." 
      #  THe notice: has automatically puts it into hash
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

end
