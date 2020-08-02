# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user

  has_many :source_transactions,
           class_name: 'Transaction',
           foreign_key: 'source_account_id'

  has_many :destination_transactions,
           class_name: 'Transaction',
           foreign_key: 'destination_account_id'

  before_create :create_account

  private

  def create_account
    service = UserAccountCreationService.new.call

    self.number  = service.data[:number]
    self.agency  = service.data[:agency]
    self.limit   = service.data[:limit]
  end
end
