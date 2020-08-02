# frozen_string_literal: true

class DepositService
  def initialize(account, amount)
    @account = account
    @amount = amount
  end

  def call
    raise(ActiveRecord::RecordInvalid, 'Amount cannot be less than 0.00') unless amount > 0.00

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
