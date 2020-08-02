# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :source_account, class_name: 'Account'
  belongs_to :destination_account, class_name: 'Account'

  enum transaction_type: { credit: 0, debit: 1 }

  validates :amount, numericality: { greater_than: 0 }
end
