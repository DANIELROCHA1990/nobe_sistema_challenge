class Account < ApplicationRecord
  # constante com business hour
  belongs_to :user
  has_many :transactions

  attr_accessor :account

  OPEN_BUSINESS          = DateTime.parse('today 09:00')
  CLOSED_BUSINESS        = DateTime.parse('today 18:00')
  IN_BUSINESS_HOUR       = 5
  OUT_BUSINESS_HOUR      = 7
  OUT_LIMIT_TRANSFER_TAX = 10
  LIMIT_TRANSFER_VALUE   = 1000

  # Realiza saque
  def withdraw(value)
    raise 'You have no enough ballance for this transaction' if ballance < value

    transactions.create(value: value, kind: :withdraw)
  end

  # realiza deposito
  def deposit(value)
    Transaction.create(account: self, value: value, kind: :deposit)
  end

  # Realiza transaferencia
  def transfer(to_account, value)
    if transfer_ballance(value)
      withdraw(value)
      withdraw(hour_transfer_tax)
      to_account.deposit(value)
    else
      raise 'You have no enough ballance for this transaction'
    end
  end

  # Mostra o extrato
  def extract(start_date, end_date)
    if valid_date?(end_date) && valid_date?(start_date)
      transactions.where(created_at: start_date.midnight..end_date.end_of_day)
    else
      raise 'Choose a valid date'
    end
  end

  # Define o saldo
  def ballance
    deposits  = transactions.deposit
    withdraws = transactions.withdraw

    sum_transactions(deposits) - sum_transactions(withdraws)
  end

  private

  # Soma o valor de todas as transacoes (deposits e withdraw)
  def sum_transactions(transactions)
    transactions.map(&:value).sum
  end

  # Checa se esta dentro do horario de funcionamento
  def in_business_hour?
    (OPEN_BUSINESS..CLOSED_BUSINESS).cover?(DateTime.now)
  end

  # Define qual taxa sera aplicada com base no horario da transferencia
  def hour_transfer_tax
    in_business_hour? ? IN_BUSINESS_HOUR : OUT_BUSINESS_HOUR
  end

  # Define qual taxa caso o valor da transferencia seja alem do teto
  def limit_transfer_tax(value)
    value > LIMIT_TRANSFER_VALUE ? OUT_LIMIT_TRANSFER_TAX : 0
  end

  # checa se o saldo mais taxas e suficiente para saque
  def transfer_ballance(value)
    ballance > value + hour_transfer_tax + limit_transfer_tax(value)
  end

  # Checa se o horario e valido
  def valid_date?(date_to_compare)
    DateTime.tomorrow > date_to_compare
  end
end
