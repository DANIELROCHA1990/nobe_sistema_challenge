class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, except: [:index, :new]

  def index
    @accounts = current_user.accounts.order(id: :asc)
  end

  def show; end

  def new
    @account = Account.new
  end

  def create
    byebug
    @account = Account.new(user: current_user)
    if @account.save
      redirect_to user_accounts_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  def toggle_active
    @account.toggle_active
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end
end
