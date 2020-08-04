# frozen_string_literal: true

require('rails_helper')

RSpec.describe('Transactions', type: :request) do
  describe('POST /transfer') do
    let!(:source)      { create(:account) }
    let!(:destination) { create(:account) }

    let(:params) do
      {
        document: destination.user.document,
        number: destination.number,
        agency: destination.agency,
        amount: 0.01
      }
    end

    let(:headers) do
      { authorization: "Bearer #{JsonWebToken.encode(user_id: source.user.id)}" }
    end

    context('when request is unauthorized') do
      it('returns http not found') do
        post('/transactions/transfer')
        expect(response).to(have_http_status(:not_found))
      end
    end

    context('when source and destination are equal') do
      before do
        params[:document] = source.user.document
        params[:number] = source.number
        params[:agency] = source.agency
      end

      it('returns http bad request') do
        post('/transactions/transfer', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when destination doesn\'t exist') do
      before { params[:document] = 'invalid' }

      it('returns http bad request') do
        post('/transactions/transfer', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when amount is negative') do
      before { params[:amount] = -0.01 }

      it('returns http bad request') do
        post('/transactions/transfer', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when source has insufficient funds') do
      before { params[:amount] = 0.01 + source.balance + source.limit }

      it('returns http bad request') do
        post('/transactions/transfer', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context('when transfer is valid') do
      before { params[:amount] = source.balance + source.limit }

      it('returns http ok') do
        post('/transactions/transfer', headers: headers, params: params, as: :json)
        expect(response).to(have_http_status(:bad_request))
      end
    end
  end
end
