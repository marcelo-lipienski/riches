# frozen_string_literal: true

class Statement
  def initialize(account, transactions = [])
    @account = account
    @transactions = transactions
  end

  def starting_balance
    Float(account.balance + transactions_total)
  end

  def final_balance
    Float(account.balance)
  end

  def history
    {
      starting_balance: starting_balance,
      final_balance: final_balance,
      transactions: transactions.map do |transaction|
        {
          timestamp: transaction.created_at,
          amount: transaction.value,
          action: transaction.action,
          from: transaction.source_account.number,
          to: transaction.destination_account.number
        }
      end
    }
  end

  private

  attr_reader :account, :transactions

  def transactions_total
    return 0 if transactions.empty?

    transactions.map(&:value).inject(:+)
  end
end
