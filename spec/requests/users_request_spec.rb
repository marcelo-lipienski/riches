# frozen_string_literal: true

require('rails_helper')

RSpec.describe('Users', type: :request) do
  describe('POST /') do
    let(:user) { attributes_for(:user) }

    it('returns http created') do
      post('/users', params: user, as: :json)
      expect(response).to(have_http_status(:created))
    end

    it('returns http internal server error') do
      # Sets all user attributes to empty string
      invalid_user = user.each { |k, _v| user[k] = '' }

      post('/users', params: invalid_user, as: :json)
      expect(response).to(have_http_status(:internal_server_error))
    end
  end
end
