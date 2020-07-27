# frozen_string_literal: true

require('rails_helper')

RSpec.describe(UserRegistrationService) do
  let(:user)    { attributes_for(:user)    }
  let(:address) { attributes_for(:address) }

  let(:invalid_user) do
    # Sets all user attributes to empty string
    user.each { |k, _v| user[k] = '' }
  end

  let(:invalid_address) do
    # Sets all address attributes to empty string
    address.each { |k, _v| address[k] = '' }
  end

  context('when user and address are valid') do
    it('expects response to be success') do
      service = described_class.new(user, address).call

      expect(service).to(be_success)
    end
  end

  context('when user is invalid and address is valid') do
    it('expects response not to be success') do
      service = described_class.new(invalid_user, address).call

      expect(service).not_to(be_success)
    end
  end

  context('when user is valid and address is invalid') do
    it('expects response not to be success') do
      service = described_class.new(user, invalid_address).call

      expect(service).not_to(be_success)
    end
  end

  context('when user and address are invalid') do
    it('expects response not to be success') do
      service = described_class.new(invalid_user, invalid_address).call

      expect(service).not_to(be_success)
    end
  end
end
