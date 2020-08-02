# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authorize
  before_action :set_account, only: %i[update]

  def update
    service = UpdateAccountLimitService.new(@account, account_params[:limit]).call

    unless service.success?
      render(json: { error: service.error }, status: :bad_request)
      return
    end

    render(json: service.data, status: :ok)
  end

  private

  def set_account
    @account = @current_user.account
  end

  def account_params
    params.permit(:token, :limit)
  end
end
