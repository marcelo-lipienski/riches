# frozen_string_literal: true

class DepositService
  DAILY_DEPOSIT_LIMIT = 800
  private_constant :DAILY_DEPOSIT_LIMIT

  def initialize(account, amount)
    @account = account
    @amount = amount
  end

  def call
    raise(ArgumentError, 'Amount cannot be less than 0.00') unless amount > 0.00
    raise(ArgumentError, 'Amount cannot be greater than 800.00') unless amount < DAILY_DEPOSIT_LIMIT
    raise(ArgumentError, 'Exceeded daily deposit limit') unless can_deposit?

    ActiveRecord::Base.transaction do
      create_transaction!
      account.add_balance(amount).save!
    end

    OpenStruct.new(success?: true)
  rescue ArgumentError => e
    OpenStruct.new(success?: false, error: e.message)
  end

  private

  attr_reader :account, :amount

  def can_deposit?
    deposits = DailyDepositQuery.new(account).deposits

    (DAILY_DEPOSIT_LIMIT - deposits - amount) >= 0
  end

  def create_transaction!
    Transaction.create!(
      transaction_type: :credit,
      amount: amount,
      source_account: account,
      destination_account: account
    )
  end
end
