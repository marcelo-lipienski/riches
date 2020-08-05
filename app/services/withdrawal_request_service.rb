# frozen_string_literal: true

class WithdrawalRequestService
  def initialize(account, amount)
    @account = account
    @amount = amount
  end

  def call
    raise(ArgumentError, 'Invalid amount') unless amount.positive? && amount.integer?
    raise(ArgumentError, 'Available bills are: 50, 20 and 2') unless amount.even?

    create_withdrawal_request!

    OpenStruct.new(success?: true, data: response)
  rescue ArgumentError => e
    OpenStruct.new(success?: false, error: e.message)
  end

  private

  attr_reader :account, :amount, :withdrawal_request

  def create_withdrawal_request!
    @withdrawal_request ||= WithdrawalRequest.create!(account: account, amount: amount)
  end

  def response
    {
      withdrawal_request: withdrawal_request.id,
      withdrawal_options: withdrawal_options
    }
  end

  def withdrawal_options
    withdrawal_options = Withdrawal.new(amount).options

    WithdrawalPresenter.new(withdrawal_options).data
  end
end
