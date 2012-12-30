class UsersController < ApplicationController
  #  this will do it for all methods before_filter :signed_in_user
  #  if you want only specific to edit:
  before_filter :signed_in_user, 
                only:  [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user, only:    [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  
  def index
    @users = User.search(params[:search]).paginate(page: params[:page])
  end
  
  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
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
   # @user = User.find(params[:id]) because correct_users runs 'before'
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

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  
  private 
    

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

end
