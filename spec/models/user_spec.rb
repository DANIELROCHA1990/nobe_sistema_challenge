require 'rails_helper'

RSpec.describe User, type: :model do
  subject       { create(:user) }
  let(:account) { create(:account, user: user) }

  context 'success to create' do
    it 'new user because is valid' do
      expect { subject }.to change { User.count }.by(1)
      expect(subject).to be_valid
    end
  end

  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  context 'relations' do
    it { should have_many(:accounts) }
  end
end
