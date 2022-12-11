require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user)    { create(:user) }
  let(:account) { create(:account) }
  let(:deposit) do
    create(:transaction, kind: :deposit, account: account, value: deposit_value)
  end

  context 'validations' do
    it do
      should define_enum_for(:kind)
        .with_values(%i[deposit withdraw])
    end
    it { should validate_presence_of(:account) }
    it { should validate_presence_of(:value) }
    it { should validate_numericality_of(:value) }
  end

  context 'associations' do
    it { should belong_to(:account) }
  end
end
