# frozen_string_literal: true

class StatementService
  def initialize(account, since)
    @account = account
    @since = since || 7
  end

  def call
    raise(ArgumentError, 'Invalid period') unless since.is_a?(Numeric) && since.positive?

    OpenStruct.new(success?: true, data: statement)
  rescue ArgumentError => e
    OpenStruct.new(success?: false, error: e.message)
  end

  private

  attr_reader :account, :since

  def statement
    Statement.new(account, transactions).history
  end

  def transactions
    StatementQuery.new.account_transactions(account, since)
  end
end
