# frozen_string_literal: true

require('rails_helper')

RSpec.describe('Users', type: :request) do
  describe('POST /') do
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
      it('returns http created') do
        params = user.merge(address: address)

        post('/users', params: params, as: :json)
        expect(response).to(have_http_status(:created))
      end
    end

    context('when user is invalid and address is valid') do
      it('returns http bad request') do
        params = invalid_user.merge(address: address)

        post('/users', params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when user is valid and address is invalid') do
      it('returns http bad request') do
        params = user.merge(address: invalid_address)

        post('/users', params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when user and address are invalid') do
      it('returns http bad request') do
        params = invalid_user.merge(address: invalid_address)

        post('/users', params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end
  end
end
