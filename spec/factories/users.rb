# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    fullname  { Faker::Name.name }
    document  { Faker::CPF.number }
    birthdate { Faker::Date.birthday(min_age: 18) }
    gender    { Faker::Gender.binary_type.downcase.to_sym }
    password  { Faker::Internet.password(min_length: 8) }
  end
end
