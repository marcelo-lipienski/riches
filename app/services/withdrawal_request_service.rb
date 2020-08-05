# frozen_string_literal: true

class WithdrawalRequestService
  def initialize(amount)
    @amount = amount
  end

  def call
    raise(ArgumentError, 'Invalid amount') unless amount.positive? && amount.integer?
    raise(ArgumentError, 'Available bills are: 50, 20 and 2') unless amount.even?

    # Criar solicitação de saque
    # Salvar as duas opções de notas para o saque

    OpenStruct.new(success?: true, data: withdrawal_options)
  rescue ArgumentError => e
    OpenStruct.new(success?: false, error: e.message)
  end

  private

  attr_reader :amount

  def withdrawal_options
    withdrawal_options = Withdrawal.new(amount).options

    WithdrawalPresenter.new(withdrawal_options).data
  end
end
