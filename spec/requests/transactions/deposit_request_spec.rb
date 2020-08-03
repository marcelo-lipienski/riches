# frozen_string_literal: true

require('rails_helper')

RSpec.describe('Transactions', type: :request) do
  describe('POST /deposit') do
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

    context('when deposit amount is negative') do
      it('returns http bad request') do
        params = { amount: -0.01 }

        post('/transactions/deposit', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when deposit amount is zero') do
      it('returns http bad request') do
        params = { amount: 0 }

        post('/transactions/deposit', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when deposit amount is positive') do
      before do
        params = { amount: 0.01 }

        post('/transactions/deposit', headers: headers, params: params, as: :json)
      end

      it('returns http ok') do
        expect(response).to(have_http_status(:ok))
      end

      it('expects balance to have been updated') do
        expect { account.reload }.to(change(account, :balance).from(0).to(0.01))
      end
    end
  end
end
