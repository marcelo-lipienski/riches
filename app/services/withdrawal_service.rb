# frozen_string_literal: true

class WithdrawalService
  def initialize(account, withdrawal_request)
    @account = account
    @withdrawal_request = WithdrawalRequest.where(id: withdrawal_request, account_id: account.id).first
  end

  def call
    raise(ArgumentError, 'Invalid withdrawal request') if withdrawal_request.blank?
    raise(ArgumentError, 'Insufficient funds') unless sufficient_funds?

    ActiveRecord::Base.transaction do
      create_withdraw_transaction!

      account.subtract_balance(withdrawal_request.amount).save!
    end

    OpenStruct.new(
      success?: true,
      data: {
        amount: withdrawal_request.amount
      }
    )
  rescue ArgumentError => e
    OpenStruct.new(success?: false, error: e.message)
  end

  private

  attr_reader :account, :withdrawal_request

  def sufficient_funds?
    account.balance + account.limit - withdrawal_request.amount >= 0
  end

  def create_withdraw_transaction!
    Transaction.create!(
      transaction_type: :debit,
      amount: withdrawal_request.amount,
      source_account: account,
      destination_account: account
    )
  end
end
