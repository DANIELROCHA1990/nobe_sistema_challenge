FactoryBot.define do
  factory :transaction do
    account { :account }
    kind    { 0 }
    value   { 200 }
  end
end
