FactoryBot.define do
  factory :account do
    number  { "#{Faker::Bank.account_number(digits: 4)}-1" }
    agency  { Faker::Number.number(digits: 4)              }
    balance { Faker::Number.between(from: 1000, to: 1800)  }
    token   { Faker::Number.number(digits: 4)              }
    user_id { nil }
  end
end
