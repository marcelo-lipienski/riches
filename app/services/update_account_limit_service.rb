# frozen_string_literal: true

class UpdateAccountLimitService
  def initialize(account, new_limit)
    @account = account
    @new_limit = new_limit
  end

  def call
    raise(ActiveRecord::RecordInvalid, 'Limit cannot be less than 0.00') unless new_limit >= 0.00
    raise(StandardError, 'Limit cannot be updated twice in less than 10 minutes') unless valid_interval?

    account.update!(limit: new_limit, updated_at: Time.zone.now)

    OpenStruct.new(success?: true, data: account)
  rescue ActiveRecord::RecordInvalid => e
    OpenStruct.new(success?: false, error: e.message)
  rescue StandardError => e
    OpenStruct.new(success?: false, error: e.message)
  end

  private

  attr_reader :account, :new_limit

  def valid_interval?
    return true if account.updated_at.nil?

    (Time.zone.now - account.updated_at) > update_interval
  end

  def update_interval
    # Ten minutes
    60 * 10
  end
end
