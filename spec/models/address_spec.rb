# frozen_string_literal: true

require('rails_helper')

RSpec.describe(Address, type: :model) do
  context('when address country is blank') do
    it('expects to be invalid') do
      address = build(:address, country: '')

      expect(address).to(be_invalid)
    end
  end

  context('when address state is blank') do
    it('expects to be invalid') do
      address = build(:address, state: '')

      expect(address).to(be_invalid)
    end
  end

  context('when address city is blank') do
    it('expects to be invalid') do
      address = build(:address, city: '')

      expect(address).to(be_invalid)
    end
  end

  context('when address district is blank') do
    it('expects to be invalid') do
      address = build(:address, district: '')

      expect(address).to(be_invalid)
    end
  end

  context('when address street is blank') do
    it('expects to be invalid') do
      address = build(:address, street: '')

      expect(address).to(be_invalid)
    end
  end

  context('when address number is blank') do
    it('expects to be invalid') do
      address = build(:address, number: '')

      expect(address).to(be_invalid)
    end
  end

  context('when address complement is blank') do
    it('expects to be invalid') do
      address = build(:address, complement: '')

      expect(address).to(be_invalid)
    end
  end

  context('when address complement is blank') do
    it('expects to be invalid') do
      address = build(:address, complement: '')

      expect(address).to(be_invalid)
    end
  end

  context('when address zip code is blank') do
    it('expects to be invalid') do
      address = build(:address, zip_code: '')

      expect(address).to(be_invalid)
    end
  end
end
