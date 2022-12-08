class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[update]

  def index; end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to(@user, notice: 'User Created')
    else
      render action: 'new'
    end
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Object was successfully updated'
      redirect_to @user
    else
      flash[:error] = 'Something went wrong'
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
end
