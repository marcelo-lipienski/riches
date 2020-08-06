# frozen_string_literal: true

require('rails_helper')

RSpec.describe(WithdrawalService) do
  let!(:account) { create(:account) }

  context('when withdrawal_request is blank') do
    let(:service) { described_class.new(account, nil).call }

    it { expect(service).not_to(be_success) }
  end

  context('when withdrawal_request is valid') do
    let(:withdrawal_request) { create(:withdrawal_request, account: account)            }
    let(:service)            { described_class.new(account, withdrawal_request.id).call }

    it { expect(service).to(be_success) }
    it { expect(service.data[:amount]).to(eq(withdrawal_request.amount)) }
  end
end
