# frozen_string_literal: true

require('rails_helper')

RSpec.describe(TransferService) do
  let!(:source)      { create(:account)                          }
  let!(:destination) { create(:account)                          }
  let(:service)      { described_class.new(source, params).call  }

  let(:params) do
    {
      document: destination.user.document,
      number: destination.number,
      agency: destination.agency,
      amount: 0.01
    }
  end

  context('when source and destination are equal') do
    before do
      params[:document] = source.user.document
      params[:number] = source.number
      params[:agency] = source.agency
    end

    it { expect(service).not_to(be_success) }
  end

  context('when destination doesn\'t exist') do
    before { params[:document] = 'invalid' }

    it { expect(service).not_to(be_success) }
  end

  context('when amount is negative') do
    before { params[:amount] = -0.01 }

    it { expect(service).not_to(be_success) }
  end

  context('when source has insufficient funds') do
    before { params[:amount] = 0.01 + source.balance + source.limit }

    it { expect(service).not_to(be_success) }
  end

  context('when transfer is valid') do
    before { params[:amount] = source.balance + source.limit }

    it { expect(service).to(be_success) }

    it('expects source account balance to be updated') do
      new_balance = source.balance - params[:amount]

      expect { service }.to(change(source, :balance).from(source.balance).to(new_balance))
    end

    it('expects destination account balance to be updated') do
      new_balance = destination.balance + params[:amount]

      service

      expect(destination.reload.balance).to(eq(new_balance))

      # No idea why would the below expectation fail since the example at line 62 does pass.
      #
      # Since the above expectation does the same test in a more verbose way, it's safe to assume
      # that TransferService code is valid (I did check with rails console just to be sure)
      #
      # expect { service }.to(change(destination, :balance).from(destination.balance).to(new_balance))
    end
  end
end
