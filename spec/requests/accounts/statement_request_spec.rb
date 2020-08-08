# frozen_string_literal: true

require('rails_helper')

RSpec.describe('Accounts', type: :request) do
  describe('GET /statement') do
    let(:account) { create(:account) }

    let(:headers) do
      { authorization: "Bearer #{JsonWebToken.encode(user_id: account.user.id)}" }
    end

    context('when request is unauthorized') do
      before { get('/accounts/statement') }

      it { expect(response).to(have_http_status(:not_found)) }
    end

    context('when account has no transactions') do
      let(:response_body) { JSON.parse(response.body).deep_symbolize_keys }

      before { get('/accounts/statement', headers: headers) }

      it { expect(response).to(have_http_status(:ok)) }
      it { expect(response_body[:starting_balance]).to(eq(0)) }
      it { expect(response_body[:final_balance]).to(eq(0)) }
    end

    context('when account has deposits') do
      let(:deposit)          { create(:deposit, source_account: account, destination_account: account) }
      let(:starting_balance) { Float(account.balance + deposit.amount)                                 }
      let(:final_balance)    { deposit.amount                                                          }
      let(:response_body)    { JSON.parse(response.body).deep_symbolize_keys                           }

      before do
        account.update!(balance: final_balance)
        get('/accounts/statement', headers: headers)
      end

      it { expect(response).to(have_http_status(:ok)) }
      it { expect(response_body[:starting_balance]).to(eq(starting_balance)) }
      it { expect(response_body[:final_balance]).to(eq(final_balance)) }
    end
  end
end
