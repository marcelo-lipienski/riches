# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  enum gender: { female: 0, male: 1 }

  validates :fullname, :document, :birthdate, :gender, :password, presence: true
  validates :document, uniqueness: true

  has_one :address, dependent: :destroy
  has_one :account, dependent: :destroy

  attribute :token

  # Virtual attribute with Json Web Token used to authenticate transactions
  def token
    JsonWebToken.encode(user_id: self.id)
  end

  # Removes password and password_digest from serialization
  def as_json(options)
    hidden = %w[password password_digest]

    super(options).reject { |key| hidden.include?(key) }
  end
end
