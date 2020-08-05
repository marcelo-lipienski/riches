# frozen_string_literal: true

require('rails_helper')

RSpec.describe('Transactions', type: :request) do
  describe('POST /withdrawal_request') do
    let!(:account) { create(:account) }

    let(:headers) do
      { authorization: "Bearer #{JsonWebToken.encode(user_id: account.user.id)}" }
    end

    context('when request is unauthorized') do
      it('returns http not found') do
        post('/transactions/deposit')
        expect(response).to(have_http_status(:not_found))
      end
    end

    context('when withdrawal amount is negative') do
      it('returns http bad request') do
        params = { amount: -0.01 }

        post('/transactions/withdrawal_request', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when withdrawal amount is zero') do
      it('returns http bad request') do
        params = { amount: 0 }

        post('/transactions/withdrawal_request', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when withdrawal amount is positive but invalid') do
      it('returns http bad request') do
        params = { amount: 1 }

        post('/transactions/withdrawal_request', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when withdrawal amount is valid') do
      before do
        params = { amount: 100 }

        post('/transactions/withdrawal_request', headers: headers, params: params, as: :json)
      end

      it('returns http ok') do
        expect(response).to(have_http_status(:ok))
      end

      it('expects response withdrawal_options') do
        withdrawal_options = [{ '50' => 2 }, { '20' => 5 }]

        response_data = JSON.parse(response.body).symbolize_keys

        expect(response_data[:withdrawal_options]).to(eq(withdrawal_options))
      end
    end
  end
end
