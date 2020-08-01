# frozen_string_literal: true

require('rails_helper')

RSpec.describe(Account, type: :model) do
  context('when account does not belongs to a user') do
    it('expects to be invalid') do
      account = build(:account, user: nil)

      expect(account).to(be_invalid)
    end
  end

  context('when account belongs to a user') do
    it('expects to be valid') do
      account = build(:account)

      expect(account).to(be_valid)
    end
  end
end
