require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }
  context 'Succes to create' do
    it 'new user because is valid' do
      expect { subject }.to change { User.count }.by(1)
      expect(subject).to be_valid
    end
  end

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
end
