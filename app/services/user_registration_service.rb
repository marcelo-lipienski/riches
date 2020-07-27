# frozen_string_literal: true

class UserRegistrationService
  def initialize(user_attributes, address_attributes)
    @user_attributes    = user_attributes
    @address_attributes = address_attributes
  end

  def call
    user = User.create(@user_attributes)

    raise(ActiveRecord::RecordInvalid) unless user.persisted?

    address = Address.create!(@address_attributes.merge(user_id: user.id))

    raise(ActiveRecord::RecordInvalid) unless address.persisted?

    OpenStruct.new(success?: true, data: user)
  rescue ActiveRecord::RecordInvalid => e
    OpenStruct.new(success?: false, error: e.message)
  rescue StandardError => e
    OpenStruct.new(success?: false, error: e.message)
  end
end
