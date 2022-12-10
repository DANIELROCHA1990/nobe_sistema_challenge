class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  def new
    @kind = params[:kind]
    @accounts = Account.includes(:user).where.not(id: params[:account_id]) if @kind == 'transfer'
    @error = params[:error]
    @url = url_for_kind(@kind)
  end

  def deposit
    @account.deposit(transaction_value_param)
    redirect_to user_account_path(user_id: current_user.id, id: @account.id)
  rescue StandardError => e
    render_new(:deposit, e)
  end

  def withdraw
    @account.withdraw(transaction_value_param)
    redirect_to user_account_path(user_id: current_user.id, id: @account.id)
  rescue StandardError => e
    render_new(:withdraw, e)
  end

  def transfer
    @account.transfer(to_account, transaction_value_param)
    redirect_to user_account_path(user_id: current_user.id, id: @account.id)
  rescue StandardError => e
    render_new(:transfer, e)
  end

  def extract
    @from_date = params[:from_date].to_date
    @to_date   = params[:to_date].to_date
    @transactions = @account.extract(@from_date, @to_date)
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to user_account_path(user_id: current_user.id, id: @account.id)
  end

  private

  def render_new(kind, error)
    @kind = kind
    redirect_to new_user_account_transaction_path(user_id: params[:user_id], account_id: params[:account_id], kind: kind, error: error.message)
  end

  def set_account
    @account = Account.find(params[:account_id])
  end

  def transaction_value_param
    params.require(:transaction).permit(:value)[:value].to_f
  end

  def to_account
    Account.find(params[:transaction][:to_account_id])
  end

  def url_for_kind(kind)
    @map ||= {
     deposit:  deposit_user_account_transactions_path(user_id:  params[:user_id], account_id: params[:account_id]),
     transfer: transfer_user_account_transactions_path(user_id: params[:user_id], account_id: params[:account_id]),
     withdraw: withdraw_user_account_transactions_path(user_id: params[:user_id], account_id: params[:account_id])
    }
    @map[kind.to_sym]
  end
end
