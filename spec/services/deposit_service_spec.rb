# frozen_string_literal: true

require('rails_helper')

RSpec.describe(DepositService) do
  let(:account) { create(:account)                          }
  let(:service) { described_class.new(account, amount).call }

  describe('when deposit amount is negative') do
    let(:amount) { -0.01 }

    it('expects response not to be success') do
      expect(service).not_to(be_success)
    end
  end

  describe('when deposit amount is zero') do
    let(:amount) { 0 }

    it('expects response not to be success') do
      expect(service).not_to(be_success)
    end
  end

  describe('when deposit amount is positive') do
    let(:amount) { 0.01 }

    it('expects response to be success') do
      expect(service).to(be_success)
    end

    it('expects account balance to be updated') do
      expect { service }.to(change(account, :balance).from(0).to(0.01))
    end

    it('expects account destination_transaction to have one deposit') do
      service

      expect(account.destination_transactions.credit.count).to(eq(1))
    end

    it('expects account source_transaction to have one deposit') do
      service

      expect(account.source_transactions.credit.count).to(eq(1))
    end
  end
end
