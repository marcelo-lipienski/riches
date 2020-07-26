# frozen_string_literal: true

require('rails_helper')

RSpec.describe(User, type: :model) do
  context('when user fullname is blank') do
    it('expects to be invalid') do
      user = build(:user, fullname: '')

      expect(user).to(be_invalid)
    end
  end

  context('when user document is blank') do
    it('expects to be invalid') do
      user = build(:user, document: '')

      expect(user).to(be_invalid)
    end
  end

  context('when user birthdate is blank') do
    it('expects to be invalid') do
      user = build(:user, birthdate: '')

      expect(user).to(be_invalid)
    end
  end

  context('when user gender is blank') do
    it('expects to be invalid') do
      user = build(:user, gender: '')

      expect(user).to(be_invalid)
    end
  end

  context('when user password is blank') do
    it('expects to be invalid') do
      user = build(:user, password: '')

      expect(user).to(be_invalid)
    end
  end
end
