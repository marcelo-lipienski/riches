# frozen_string_literal: true

class User < ApplicationRecord
  enum gender: { female: 0, male: 1 }

  validates :fullname, :document, :birthdate, :gender, :password, presence: true
end
