# frozen_string_literal: true

class DepositService
  def initialize(account, amount)
    @account = account
    @amount = amount
  end

  def call
    raise(ActiveRecord::RecordInvalid, 'Amount cannot be less than 0.00') unless amount > 0.00
    raise(ActiveRecord::RecordInvalid, 'Amount cannot be greater than 800.00') unless amount < daily_deposit_limit
    raise(ActiveRecord::RecordInvalid, 'Exceeded daily deposit limit') unless can_deposit?

    ActiveRecord::Base.transaction do
      create_transaction!
      update_account_balance!
    end

    OpenStruct.new(success?: true)
  rescue ActiveRecord::RecordInvalid => e
    OpenStruct.new(success?: false, error: e.message)
  rescue StandardError => e
    OpenStruct.new(success?: false, error: e.message)
  end

  private

  attr_reader :account, :amount

  def can_deposit?
    deposits = DailyDepositQuery.new(account).deposits

    (daily_deposit_limit - deposits - amount) >= 0
  end

  def daily_deposit_limit
    800
  end

  def create_transaction!
    Transaction.create!(
      transaction_type: :credit,
      amount: amount,
      source_account: account,
      destination_account: account
    )
  end

  def update_account_balance!
    new_balance = account.balance + amount

    account.update!(balance: new_balance)
  end
end
