# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  enum gender: { female: 0, male: 1 }

  validates :fullname, :document, :birthdate, :gender, :password, presence: true

  has_one :address, dependent: :destroy
end
