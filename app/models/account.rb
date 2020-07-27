# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user

  before_create :create_account

  private

  def create_account
    service = UserAccountCreationService.new.call

    self.number  = service.data[:number]
    self.agency  = service.data[:agency]
    self.balance = service.data[:balance]
    self.token   = service.data[:token]
  end
end
