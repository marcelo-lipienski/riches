# frozen_string_literal: true

require('rails_helper')

RSpec.describe('Accounts', type: :request) do
  describe('PUT /') do
    let!(:account) do
      Timecop.freeze(2020, 1, 1, 12, 0, 0) do
        create(:account)
      end
    end

    let(:headers) do
      { authorization: "Bearer #{JsonWebToken.encode(user_id: account.user.id)}" }
    end

    context('when request is unauthorized') do
      it('returns http not found') do
        put('/accounts')
        expect(response).to(have_http_status(:not_found))
      end
    end

    context('when account new limit is invalid') do
      it('returns http bad request') do
        params = { limit: -0.01 }

        put('/accounts', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when new limit has been set less than 10 minutes ago') do
      let(:params) { { limit: 0.00 } }

      before do
        Timecop.freeze(2020, 1, 1, 12, 10, 1) do
          put('/accounts', headers: headers, params: params, as: :json)
        end
      end

      it('returns http bad request') do
        Timecop.freeze(2020, 1, 1, 12, 19, 59) do
          put('/accounts', headers: headers, params: params, as: :json)
          expect(response).to(have_http_status(:bad_request))
        end
      end
    end

    context('when new limit is valid and respect the 10 minutes window') do
      let(:params)         { { limit: 0.00 } }
      let(:original_limit) { account.limit   }

      before do
        Timecop.freeze(2020, 1, 1, 12, 10, 1) do
          put('/accounts', headers: headers, params: params, as: :json)
        end
      end

      it('returns http ok') do
        Timecop.freeze(2020, 1, 1, 12, 20, 2) do
          put('/accounts', headers: headers, params: params, as: :json)
          expect(response).to(have_http_status(:ok))
        end
      end

      it { expect { account.reload }.to(change(account, :limit).from(original_limit).to(0.00)) }
    end
  end
end
