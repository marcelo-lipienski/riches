# frozen_string_literal: true

require('rails_helper')

RSpec.describe(UpdateAccountLimitService) do
  let!(:account) { build(:account) }

  context('when new limit is less than 0.00') do
    let(:new_limit) { -0.01                                        }
    let(:service)   { described_class.new(account, new_limit).call }

    it { expect(service).not_to(be_success) }
  end

  context('when new limit is equal to 0.00') do
    let(:new_limit) { 0.00                                         }
    let(:service)   { described_class.new(account, new_limit).call }

    it { expect(service).to(be_success) }
  end

  context('when new limit is greater than 0.00') do
    let(:new_limit) { 0.01                                         }
    let(:service)   { described_class.new(account, new_limit).call }

    it { expect(service).to(be_success) }
  end

  context('when limit has been updated less than 10 minutes ago') do
    let(:new_limit) { 0.01                                         }
    let(:service)   { described_class.new(account, new_limit).call }

    before do
      Timecop.freeze(2020, 1, 1, 12, 0, 0) do
        described_class.new(account, new_limit).call
      end
    end

    it('expects response not to be success') do
      Timecop.freeze(2020, 1, 1, 12, 10, 0) do
        expect(service).not_to(be_success)
      end
    end
  end

  context('when limit has been updated more than 10 minutes ago') do
    let(:new_limit) { 0.01                                         }
    let(:service)   { described_class.new(account, new_limit).call }

    before do
      Timecop.freeze(2020, 1, 1, 12, 0, 0) do
        described_class.new(account, new_limit).call
      end
    end

    it('expects response to be success') do
      Timecop.freeze(2020, 1, 1, 12, 10, 1) do
        expect(service).to(be_success)
      end
    end
  end
end
