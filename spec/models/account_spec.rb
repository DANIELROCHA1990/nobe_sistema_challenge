# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#withdraw' do
    let(:account) { create(:account) }
    let(:deposit) do
      create(:transaction, kind: :deposit, account: account, value: deposit_value)
    end
    let(:deposit_value) { 300 }
    let(:withdraw) do
      create(:transaction, kind: :withdraw, account: account, value: withdraw_value)
    end
    let(:withdraw_value) { 350 }

    context 'associations' do
      it { should belong_to(:user) }
    end

    context 'with ballance' do
      subject { account.withdraw(deposit_value) }
      before { deposit }

      it 'create transaction' do
        expect { subject }.to change { Transaction.count }.by(1)
      end
    end

    context 'without ballance' do
      subject { account.withdraw(withdraw_value) }
      before { withdraw }

      it 'raise error message' do
        expect { subject }.to raise_error('You have no enough ballance for this transaction')
      end
    end
  end

  describe '#deposit' do
    let(:account) { create(:account) }
    let(:deposit_value) { 150 }
    subject { account.deposit(deposit_value) }

    context 'success' do
      it 'to create a new transaction' do
        expect { subject }.to change { Transaction.count }.by(1)
      end

      it 'to update ballance' do
        # espero haja uma atualizacao no saldo
        expect { subject }.to change { account.ballance }.by(deposit_value)
      end
    end
  end

  describe '#transfer' do
    let(:user_to)      { create(:user, email: 'dede@dede.com') }
    let(:account_from) { create(:account) }
    let(:account_to)   { create(:account, user: user_to) }

    let(:deposit_value)  { 2000 }
    let(:transfer_value) { 1200 }

    context 'with ballance' do
      let(:within_time_now) { DateTime.parse('today 10:00') }
      let(:out_time_now)    { DateTime.parse('today 22:00') }

      before { account_from.deposit(deposit_value) }

      subject { account_from.transfer(account_to, transfer_value) }

      context 'in business time' do
        before do
          allow(DateTime).to receive(:now).and_return(within_time_now)
        end

        context 'within limit' do
          # espero que a qtde de transacoes aumente em 3
          it 'to create a new transaction' do
            expect { subject }.to change { Transaction.count }.by(3)
          end
          # esper que altere o saldo
          it 'update ballance' do
            expect { subject }.to change {
                                    account_from.ballance.to_f
                                  }.by((transfer_value + Account::IN_BUSINESS_HOUR) * -1)
          end

          # espero que altere o saldo de 2
          it 'updates all users ballance' do
            expect { subject }.to change { account_to.ballance }.by(transfer_value)
          end
        end
      end

      context 'out business time' do
        before do
          allow(DateTime).to receive(:now).and_return(out_time_now)
        end

        context 'within limit' do
          # espero que a qtde de transacoes aumente em 3
          it 'to create a new transaction' do
            expect { subject }.to change { Transaction.count }.by(3)
          end
          # esper que altere o saldo
          it 'update ballance' do
            expect { subject }.to change {
                                    account_from.ballance.to_f
                                  }.by((transfer_value + Account::OUT_BUSINESS_HOUR) * -1)
          end

          # espero que altere o saldo de 2
          it 'updates all users ballance' do
            expect { subject }.to change { account_to.ballance }.by(transfer_value)
          end
        end
      end
    end

    context 'without ballance' do
      let(:big_withdraw_value) { 5000 }
      subject { account_from.withdraw(big_withdraw_value) }

      it 'raise error message' do
        expect { subject }.to raise_error('You have no enough ballance for this transaction')
      end
    end
  end

  describe '#return_extract' do
    let(:account) { create(:account) }
    let(:deposit_value) { 200 }
    let(:withdraw_value) { 150 }
    let(:start_date) { account.transactions.first.created_at }
    let(:final_date) { DateTime.now }

    before do
      account.deposit(deposit_value)
      account.withdraw(withdraw_value)
    end

    subject { account.extract(start_date, final_date) }

    context 'valid date' do
      it 'show full extract' do
        expect(subject.count).to eql(account.transactions.count)
      end

      context 'with a very old transaction' do
        let(:start_date) { 1.day.ago }
        let(:old_transaction) do
          create(:transaction, account: account, value: 300, kind: :deposit, created_at: 1.month.ago)
        end

        before { old_transaction }
        it 'show filtered extract' do
          expect(subject.count).to eql(account.transactions.count - 1)
        end
      end
    end

    context 'invalid_date' do
      let(:final_date) { DateTime.tomorrow }

      it 'raise error message' do
        expect { subject }.to raise_error('Choose a valid date')
      end
    end
  end
end
