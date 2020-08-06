# frozen_string_literal: true

require('rails_helper')

RSpec.describe(UserAccountCreationService) do
  let(:service) { described_class.new.call }

  context('when there are no registered accounts') do
    it { expect(service).to(be_success) }
    it { expect(service.data[:number][0..3]).to(eq('1000')) }
    it { expect(service.data[:limit]).to(be_between(1000, 1800)) }
  end

  context('when there is already a registered account') do
    it('expects account number to be 1001-?') do
      create(:account)

      expect(service.data[:number][0..3]).to(eq('1001'))
    end
  end
end
