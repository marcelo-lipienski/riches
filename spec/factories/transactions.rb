# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    transaction_type    { rand(0..1)                                }
    amount              { Faker::Number.between(from: 100, to: 999) }
    source_account      { association :account                      }
    destination_account { association :account                      }

    factory :deposit do
      transaction_type { :credit }
    end

    factory :withdrawal do
      transaction_type { :debit }
    end

    factory :transfer_out do
      transaction_type { :debit }
    end

    factory :transfer_in do
      transaction_type { :credit }
    end
  end

end
