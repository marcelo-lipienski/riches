FactoryBot.define do
  factory :address do
    country    { Faker::Address.country           }
    state      { Faker::Address.state             }
    city       { Faker::Address.city              }
    district   { Faker::Address.community         }
    street     { Faker::Address.street_name       }
    number     { Faker::Address.building_number   }
    complement { Faker::Address.secondary_address }
    zip_code   { Faker::Address.zip_code          }
  end
end
