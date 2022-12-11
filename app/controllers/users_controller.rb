class UsersController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "User successfully created"
      redirect_to @user
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end
  

  def update
    if current_user.update(user_params)
      flash[:success] = 'User was successfully updated'
      redirect_to root_path(current_user)
    else
      flash[:error] = 'Something went wrong'
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
