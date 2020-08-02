# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    number  { "#{Faker::Bank.account_number(digits: 4)}-1" }
    agency  { Faker::Number.number(digits: 4)              }
    balance { 0                                            }
    limit   { Faker::Number.between(from: 1000, to: 1800)  }
    user    { association :user                            }
  end
end
