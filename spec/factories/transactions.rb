# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    transaction_type    { rand(0..1)                                }
    amount              { Faker::Number.between(from: 100, to: 999) }
    source_account      { association :account                      }
    destination_account { association :account                      }
  end
end
