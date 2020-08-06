# frozen_string_literal: true

require('rails_helper')

RSpec.describe('Accounts', type: :request) do
  describe('GET /balance') do
    let(:account) { create(:account) }

    let(:headers) do
      { authorization: "Bearer #{JsonWebToken.encode(user_id: account.user.id)}" }
    end

    context('when request is unauthorized') do
      it('returns http not found') do
        get('/accounts/balance')
        expect(response).to(have_http_status(:not_found))
      end
    end

    context('when account is valid') do
      before { get('/accounts/balance', headers: headers) }

      it { expect(response).to(have_http_status(:ok)) }

      it('returns balance') do
        response_body = JSON.parse(response.body).symbolize_keys

        expect(response_body[:balance]).to(eq(Float(account.balance).to_s))
      end
    end
  end
end
