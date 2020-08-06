# frozen_string_literal: true

require('rails_helper')

RSpec.describe(WithdrawalRequestService) do
  let!(:account) { create(:account)                          }
  let(:service)  { described_class.new(account, amount).call }

  context('when amount is negative') do
    let(:amount) { -0.01 }

    it { expect(service).not_to(be_success) }
  end

  context('when amount is not an integer') do
    let(:amount) { 0.01 }

    it { expect(service).not_to(be_success) }
  end

  context('when amount is odd') do
    let(:amount) { 1 }

    it { expect(service).not_to(be_success) }
  end

  context('when amount is lower than 20') do
    let(:amount)        { 18           }
    let(:configuration) { [{ '2': 9 }] }

    it { expect(service).to(be_success) }
    it { expect(service.data[:withdrawal_options].size).to(eq(configuration.size)) }
    it { expect(service.data[:withdrawal_options]).to(eq(configuration)) }
  end

  context('when amount is higher than 20') do
    let(:amount)        { 170                                          }
    let(:configuration) { [{ '50': 3, '20': 1 }, { '50': 1, '20': 6 }] }

    it { expect(service).to(be_success) }
    it { expect(service.data[:withdrawal_options].size).to(eq(configuration.size)) }
    it { expect(service.data[:withdrawal_options]).to(eq(configuration)) }
  end
end
