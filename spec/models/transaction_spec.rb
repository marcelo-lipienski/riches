# frozen_string_literal: true

require('rails_helper')

RSpec.describe(Transaction, type: :model) do
  context('when transaction amount is zero') do
    it('expects to be invalid') do
      transaction = build(:transaction, amount: 0)

      expect(transaction).to(be_invalid)
    end
  end

  context('when transaction amount is negative') do
    it('expects to be invalid') do
      transaction = build(:transaction, amount: -1)

      expect(transaction).to(be_invalid)
    end
  end

  context('when transaction amount is positive') do
    it('expects to be valid') do
      transaction = build(:transaction)

      expect(transaction).to(be_valid)
    end
  end
end
