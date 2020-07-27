# frozen_string_literal: true

require('rails_helper')

RSpec.describe(UserAccountCreationService) do
  let(:service) { described_class.new.call }

  context('when there are no registered accounts') do
    it('expects response to be success') do
      expect(service).to(be_success)
    end

    it('expects account number to be 1000-?') do
      expect(service.data[:number][0..3]).to(eq('1000'))
    end

    it('expects account balance to be between 1000 and 1800') do
      expect(service.data[:balance]).to(be_between(1000, 1800))
    end
  end

  context('when there is already a registered account') do
    it('expects account number to be 1001-?') do
      user = create(:user)
      Account.create!(user_id: user.id)

      expect(service.data[:number][0..3]).to(eq('1001'))
    end
  end
end
