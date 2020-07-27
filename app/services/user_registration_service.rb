# frozen_string_literal: true

class UserRegistrationService
  def initialize(user, address)
    @user    = user
    @address = address
  end

  def call
    user = User.create(@user)

    raise(ActiveRecord::RecordInvalid) unless user.persisted?

    address = Address.create!(@address.merge(user_id: user.id))

    raise(ActiveRecord::RecordInvalid) unless address.persisted?

    OpenStruct.new(success?: true, data: user)
  rescue ActiveRecord::RecordInvalid => e
    OpenStruct.new(success?: false, error: e.message)
  rescue StandardError => e
    OpenStruct.new(success?: false, error: e.message)
  end
end
