class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user  = User.new
  end

  def create
  	@user  = User.new(params[:user]) #this user matches up from new.html.erb's class of @user
  	if @user.save
  		flash[:success] = "Welcome to the Twitter App"
  		redirect_to user_path(@user)
  	else
  		render 'new'
  	end
  end


end
