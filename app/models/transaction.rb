# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :source_account, class_name: 'Account'
  belongs_to :destination_account, class_name: 'Account'

  enum transaction_type: { credit: 0, debit: 1 }

  validates :amount, numericality: { greater_than: 0 }

  # Amount is an absolute property, but we still need a way to calculate
  # based on whether a transaction is a credit or debit.
  #
  # Value virtual attribute allows to easily convert positive amounts into
  # negative whenever a transaction was a debit.
  def value
    return amount if credit?

    -amount
  end

  def credit?
    transaction_type.to_sym == :credit
  end

  def debit?
    transaction_type.to_sym == :debit
  end

  def deposit?
    debit? && source_account == destination_account
  end

  def withdrawal?
    credit? && source_account == destination_account
  end

  def action
    return 'deposit' if deposit?
    return 'withdrawal' if withdrawal?

    'transfer'
  end
end
