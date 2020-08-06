FactoryBot.define do
  factory :withdrawal_request do
    account { association :account }
    amount  { rand(1..1000)        }
  end
end
