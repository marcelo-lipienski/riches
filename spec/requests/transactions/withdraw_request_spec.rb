# frozen_string_literal: true

require('rails_helper')

RSpec.describe('Transactions', type: :request) do
  describe('POST /withdrawal') do
    let(:account) { create(:account) }

    let(:headers) do
      { authorization: "Bearer #{JsonWebToken.encode(user_id: account.user.id)}" }
    end

    context('when request is unauthorized') do
      it('returns http not found') do
        post('/transactions/withdraw')
        expect(response).to(have_http_status(:not_found))
      end
    end

    context('when withdrawal request does not belong to the user trying to withdraw') do
      let!(:withdrawal_request) { create(:withdrawal_request) }

      it('returns http bad request') do
        params = { withdrawal_request: withdrawal_request.id }

        post('/transactions/withdraw', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when account has insufficient amount') do
      let!(:account_with_no_funds) { create(:account, limit: 0)                                  }
      let!(:withdrawal_request)    { create(:withdrawal_request, account: account_with_no_funds) }

      it('returns http bad request') do
        params = { withdrawal_request: withdrawal_request.id }

        post('/transactions/withdraw', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when withdrawal is valid') do
      let!(:withdrawal_request) { create(:withdrawal_request, account: account) }

      before do
        params = { withdrawal_request: withdrawal_request.id }

        post('/transactions/withdraw', headers: headers, params: params, as: :json)
      end

      it { expect(response).to(have_http_status(:ok)) }

      it('expects withdrawal amount') do
        response_data = JSON.parse(response.body).symbolize_keys

        expect(response_data[:amount]).to(eq(Float(withdrawal_request.amount).to_s))
      end
    end
  end
end
