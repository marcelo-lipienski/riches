# frozen_string_literal: true

class Address < ApplicationRecord
  validates :country,
            :state,
            :city,
            :district,
            :street,
            :number,
            :complement,
            :zip_code,
            presence: true

  belongs_to :user
end
