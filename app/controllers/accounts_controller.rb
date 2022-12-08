class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts.order(id: :asc)
    @account = current_user.accounts
  end

  def show; end

  def new; end

  def create
    @account = Account.new(params[:account])
    if @account.save
      flash[:success] = 'Account successfully created'
      redirect_to @account
    else
      flash[:error] = 'Something went wrong'
      render 'new'
    end
  end

  def toggle_active; end

  private

  def account_params
    params.require(:account).permit(:user)
  end
end
